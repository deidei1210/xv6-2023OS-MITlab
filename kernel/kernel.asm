
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
    80000060:	ed478793          	add	a5,a5,-300 # 80005f30 <timervec>
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
    80000094:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd77df>
    80000098:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	dfe78793          	add	a5,a5,-514 # 80000ea4 <main>
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
    80000110:	af0080e7          	jalr	-1296(ra) # 80000bfc <acquire>
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
    8000012a:	63a080e7          	jalr	1594(ra) # 80002760 <either_copyin>
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
    80000154:	b60080e7          	jalr	-1184(ra) # 80000cb0 <release>

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
    8000019c:	a64080e7          	jalr	-1436(ra) # 80000bfc <acquire>
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
    800001c4:	8d0080e7          	jalr	-1840(ra) # 80001a90 <myproc>
    800001c8:	591c                	lw	a5,48(a0)
    800001ca:	efad                	bnez	a5,80000244 <consoleread+0xd4>
      sleep(&cons.r, &cons.lock);
    800001cc:	85a6                	mv	a1,s1
    800001ce:	854a                	mv	a0,s2
    800001d0:	00002097          	auipc	ra,0x2
    800001d4:	2e0080e7          	jalr	736(ra) # 800024b0 <sleep>
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
    8000021a:	4f4080e7          	jalr	1268(ra) # 8000270a <either_copyout>
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
    8000023a:	a7a080e7          	jalr	-1414(ra) # 80000cb0 <release>

  return target - n;
    8000023e:	413b053b          	subw	a0,s6,s3
    80000242:	a811                	j	80000256 <consoleread+0xe6>
        release(&cons.lock);
    80000244:	00011517          	auipc	a0,0x11
    80000248:	5ec50513          	add	a0,a0,1516 # 80011830 <cons>
    8000024c:	00001097          	auipc	ra,0x1
    80000250:	a64080e7          	jalr	-1436(ra) # 80000cb0 <release>
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
    800002da:	926080e7          	jalr	-1754(ra) # 80000bfc <acquire>

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
    800002f8:	4c2080e7          	jalr	1218(ra) # 800027b6 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002fc:	00011517          	auipc	a0,0x11
    80000300:	53450513          	add	a0,a0,1332 # 80011830 <cons>
    80000304:	00001097          	auipc	ra,0x1
    80000308:	9ac080e7          	jalr	-1620(ra) # 80000cb0 <release>
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
    8000044c:	1e8080e7          	jalr	488(ra) # 80002630 <wakeup>
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
    8000046e:	702080e7          	jalr	1794(ra) # 80000b6c <initlock>

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
    80000608:	5f8080e7          	jalr	1528(ra) # 80000bfc <acquire>
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
    80000766:	54e080e7          	jalr	1358(ra) # 80000cb0 <release>
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
    8000078c:	3e4080e7          	jalr	996(ra) # 80000b6c <initlock>
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
    800007e2:	38e080e7          	jalr	910(ra) # 80000b6c <initlock>
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
    800007fe:	3b6080e7          	jalr	950(ra) # 80000bb0 <push_off>

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
    8000082c:	428080e7          	jalr	1064(ra) # 80000c50 <pop_off>
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
    800008a6:	d8e080e7          	jalr	-626(ra) # 80002630 <wakeup>
    
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
    800008ea:	316080e7          	jalr	790(ra) # 80000bfc <acquire>
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
    80000940:	b74080e7          	jalr	-1164(ra) # 800024b0 <sleep>
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
    80000986:	32e080e7          	jalr	814(ra) # 80000cb0 <release>
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
    800009ee:	212080e7          	jalr	530(ra) # 80000bfc <acquire>
  uartstart();
    800009f2:	00000097          	auipc	ra,0x0
    800009f6:	e48080e7          	jalr	-440(ra) # 8000083a <uartstart>
  release(&uart_tx_lock);
    800009fa:	8526                	mv	a0,s1
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	2b4080e7          	jalr	692(ra) # 80000cb0 <release>
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
    80000a22:	00026797          	auipc	a5,0x26
    80000a26:	5fe78793          	add	a5,a5,1534 # 80027020 <end>
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
    80000a3e:	2be080e7          	jalr	702(ra) # 80000cf8 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a42:	00011917          	auipc	s2,0x11
    80000a46:	eee90913          	add	s2,s2,-274 # 80011930 <kmem>
    80000a4a:	854a                	mv	a0,s2
    80000a4c:	00000097          	auipc	ra,0x0
    80000a50:	1b0080e7          	jalr	432(ra) # 80000bfc <acquire>
  r->next = kmem.freelist;
    80000a54:	01893783          	ld	a5,24(s2)
    80000a58:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a5a:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a5e:	854a                	mv	a0,s2
    80000a60:	00000097          	auipc	ra,0x0
    80000a64:	250080e7          	jalr	592(ra) # 80000cb0 <release>
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
    80000aec:	084080e7          	jalr	132(ra) # 80000b6c <initlock>
  freerange(end, (void*)PHYSTOP);
    80000af0:	45c5                	li	a1,17
    80000af2:	05ee                	sll	a1,a1,0x1b
    80000af4:	00026517          	auipc	a0,0x26
    80000af8:	52c50513          	add	a0,a0,1324 # 80027020 <end>
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
    80000b24:	0dc080e7          	jalr	220(ra) # 80000bfc <acquire>
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
    80000b3c:	178080e7          	jalr	376(ra) # 80000cb0 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b40:	6605                	lui	a2,0x1
    80000b42:	4595                	li	a1,5
    80000b44:	8526                	mv	a0,s1
    80000b46:	00000097          	auipc	ra,0x0
    80000b4a:	1b2080e7          	jalr	434(ra) # 80000cf8 <memset>
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
    80000b66:	14e080e7          	jalr	334(ra) # 80000cb0 <release>
  if(r)
    80000b6a:	b7d5                	j	80000b4e <kalloc+0x42>

0000000080000b6c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b6c:	1141                	add	sp,sp,-16
    80000b6e:	e422                	sd	s0,8(sp)
    80000b70:	0800                	add	s0,sp,16
  lk->name = name;
    80000b72:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b74:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b78:	00053823          	sd	zero,16(a0)
}
    80000b7c:	6422                	ld	s0,8(sp)
    80000b7e:	0141                	add	sp,sp,16
    80000b80:	8082                	ret

0000000080000b82 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b82:	411c                	lw	a5,0(a0)
    80000b84:	e399                	bnez	a5,80000b8a <holding+0x8>
    80000b86:	4501                	li	a0,0
  return r;
}
    80000b88:	8082                	ret
{
    80000b8a:	1101                	add	sp,sp,-32
    80000b8c:	ec06                	sd	ra,24(sp)
    80000b8e:	e822                	sd	s0,16(sp)
    80000b90:	e426                	sd	s1,8(sp)
    80000b92:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b94:	6904                	ld	s1,16(a0)
    80000b96:	00001097          	auipc	ra,0x1
    80000b9a:	ede080e7          	jalr	-290(ra) # 80001a74 <mycpu>
    80000b9e:	40a48533          	sub	a0,s1,a0
    80000ba2:	00153513          	seqz	a0,a0
}
    80000ba6:	60e2                	ld	ra,24(sp)
    80000ba8:	6442                	ld	s0,16(sp)
    80000baa:	64a2                	ld	s1,8(sp)
    80000bac:	6105                	add	sp,sp,32
    80000bae:	8082                	ret

0000000080000bb0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bb0:	1101                	add	sp,sp,-32
    80000bb2:	ec06                	sd	ra,24(sp)
    80000bb4:	e822                	sd	s0,16(sp)
    80000bb6:	e426                	sd	s1,8(sp)
    80000bb8:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bba:	100024f3          	csrr	s1,sstatus
    80000bbe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bc2:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bc4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bc8:	00001097          	auipc	ra,0x1
    80000bcc:	eac080e7          	jalr	-340(ra) # 80001a74 <mycpu>
    80000bd0:	5d3c                	lw	a5,120(a0)
    80000bd2:	cf89                	beqz	a5,80000bec <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd4:	00001097          	auipc	ra,0x1
    80000bd8:	ea0080e7          	jalr	-352(ra) # 80001a74 <mycpu>
    80000bdc:	5d3c                	lw	a5,120(a0)
    80000bde:	2785                	addw	a5,a5,1
    80000be0:	dd3c                	sw	a5,120(a0)
}
    80000be2:	60e2                	ld	ra,24(sp)
    80000be4:	6442                	ld	s0,16(sp)
    80000be6:	64a2                	ld	s1,8(sp)
    80000be8:	6105                	add	sp,sp,32
    80000bea:	8082                	ret
    mycpu()->intena = old;
    80000bec:	00001097          	auipc	ra,0x1
    80000bf0:	e88080e7          	jalr	-376(ra) # 80001a74 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bf4:	8085                	srl	s1,s1,0x1
    80000bf6:	8885                	and	s1,s1,1
    80000bf8:	dd64                	sw	s1,124(a0)
    80000bfa:	bfe9                	j	80000bd4 <push_off+0x24>

0000000080000bfc <acquire>:
{
    80000bfc:	1101                	add	sp,sp,-32
    80000bfe:	ec06                	sd	ra,24(sp)
    80000c00:	e822                	sd	s0,16(sp)
    80000c02:	e426                	sd	s1,8(sp)
    80000c04:	1000                	add	s0,sp,32
    80000c06:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c08:	00000097          	auipc	ra,0x0
    80000c0c:	fa8080e7          	jalr	-88(ra) # 80000bb0 <push_off>
  if(holding(lk))
    80000c10:	8526                	mv	a0,s1
    80000c12:	00000097          	auipc	ra,0x0
    80000c16:	f70080e7          	jalr	-144(ra) # 80000b82 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c1a:	4705                	li	a4,1
  if(holding(lk))
    80000c1c:	e115                	bnez	a0,80000c40 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c1e:	87ba                	mv	a5,a4
    80000c20:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c24:	2781                	sext.w	a5,a5
    80000c26:	ffe5                	bnez	a5,80000c1e <acquire+0x22>
  __sync_synchronize();
    80000c28:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c2c:	00001097          	auipc	ra,0x1
    80000c30:	e48080e7          	jalr	-440(ra) # 80001a74 <mycpu>
    80000c34:	e888                	sd	a0,16(s1)
}
    80000c36:	60e2                	ld	ra,24(sp)
    80000c38:	6442                	ld	s0,16(sp)
    80000c3a:	64a2                	ld	s1,8(sp)
    80000c3c:	6105                	add	sp,sp,32
    80000c3e:	8082                	ret
    panic("acquire");
    80000c40:	00007517          	auipc	a0,0x7
    80000c44:	43050513          	add	a0,a0,1072 # 80008070 <digits+0x30>
    80000c48:	00000097          	auipc	ra,0x0
    80000c4c:	8fa080e7          	jalr	-1798(ra) # 80000542 <panic>

0000000080000c50 <pop_off>:

void
pop_off(void)
{
    80000c50:	1141                	add	sp,sp,-16
    80000c52:	e406                	sd	ra,8(sp)
    80000c54:	e022                	sd	s0,0(sp)
    80000c56:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    80000c58:	00001097          	auipc	ra,0x1
    80000c5c:	e1c080e7          	jalr	-484(ra) # 80001a74 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c60:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c64:	8b89                	and	a5,a5,2
  if(intr_get())
    80000c66:	e78d                	bnez	a5,80000c90 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c68:	5d3c                	lw	a5,120(a0)
    80000c6a:	02f05b63          	blez	a5,80000ca0 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c6e:	37fd                	addw	a5,a5,-1
    80000c70:	0007871b          	sext.w	a4,a5
    80000c74:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c76:	eb09                	bnez	a4,80000c88 <pop_off+0x38>
    80000c78:	5d7c                	lw	a5,124(a0)
    80000c7a:	c799                	beqz	a5,80000c88 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c7c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c80:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c84:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c88:	60a2                	ld	ra,8(sp)
    80000c8a:	6402                	ld	s0,0(sp)
    80000c8c:	0141                	add	sp,sp,16
    80000c8e:	8082                	ret
    panic("pop_off - interruptible");
    80000c90:	00007517          	auipc	a0,0x7
    80000c94:	3e850513          	add	a0,a0,1000 # 80008078 <digits+0x38>
    80000c98:	00000097          	auipc	ra,0x0
    80000c9c:	8aa080e7          	jalr	-1878(ra) # 80000542 <panic>
    panic("pop_off");
    80000ca0:	00007517          	auipc	a0,0x7
    80000ca4:	3f050513          	add	a0,a0,1008 # 80008090 <digits+0x50>
    80000ca8:	00000097          	auipc	ra,0x0
    80000cac:	89a080e7          	jalr	-1894(ra) # 80000542 <panic>

0000000080000cb0 <release>:
{
    80000cb0:	1101                	add	sp,sp,-32
    80000cb2:	ec06                	sd	ra,24(sp)
    80000cb4:	e822                	sd	s0,16(sp)
    80000cb6:	e426                	sd	s1,8(sp)
    80000cb8:	1000                	add	s0,sp,32
    80000cba:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cbc:	00000097          	auipc	ra,0x0
    80000cc0:	ec6080e7          	jalr	-314(ra) # 80000b82 <holding>
    80000cc4:	c115                	beqz	a0,80000ce8 <release+0x38>
  lk->cpu = 0;
    80000cc6:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cca:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000cce:	0f50000f          	fence	iorw,ow
    80000cd2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cd6:	00000097          	auipc	ra,0x0
    80000cda:	f7a080e7          	jalr	-134(ra) # 80000c50 <pop_off>
}
    80000cde:	60e2                	ld	ra,24(sp)
    80000ce0:	6442                	ld	s0,16(sp)
    80000ce2:	64a2                	ld	s1,8(sp)
    80000ce4:	6105                	add	sp,sp,32
    80000ce6:	8082                	ret
    panic("release");
    80000ce8:	00007517          	auipc	a0,0x7
    80000cec:	3b050513          	add	a0,a0,944 # 80008098 <digits+0x58>
    80000cf0:	00000097          	auipc	ra,0x0
    80000cf4:	852080e7          	jalr	-1966(ra) # 80000542 <panic>

0000000080000cf8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cf8:	1141                	add	sp,sp,-16
    80000cfa:	e422                	sd	s0,8(sp)
    80000cfc:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cfe:	ca19                	beqz	a2,80000d14 <memset+0x1c>
    80000d00:	87aa                	mv	a5,a0
    80000d02:	1602                	sll	a2,a2,0x20
    80000d04:	9201                	srl	a2,a2,0x20
    80000d06:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d0a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d0e:	0785                	add	a5,a5,1
    80000d10:	fee79de3          	bne	a5,a4,80000d0a <memset+0x12>
  }
  return dst;
}
    80000d14:	6422                	ld	s0,8(sp)
    80000d16:	0141                	add	sp,sp,16
    80000d18:	8082                	ret

0000000080000d1a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d1a:	1141                	add	sp,sp,-16
    80000d1c:	e422                	sd	s0,8(sp)
    80000d1e:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d20:	ca05                	beqz	a2,80000d50 <memcmp+0x36>
    80000d22:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d26:	1682                	sll	a3,a3,0x20
    80000d28:	9281                	srl	a3,a3,0x20
    80000d2a:	0685                	add	a3,a3,1
    80000d2c:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d2e:	00054783          	lbu	a5,0(a0)
    80000d32:	0005c703          	lbu	a4,0(a1)
    80000d36:	00e79863          	bne	a5,a4,80000d46 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d3a:	0505                	add	a0,a0,1
    80000d3c:	0585                	add	a1,a1,1
  while(n-- > 0){
    80000d3e:	fed518e3          	bne	a0,a3,80000d2e <memcmp+0x14>
  }

  return 0;
    80000d42:	4501                	li	a0,0
    80000d44:	a019                	j	80000d4a <memcmp+0x30>
      return *s1 - *s2;
    80000d46:	40e7853b          	subw	a0,a5,a4
}
    80000d4a:	6422                	ld	s0,8(sp)
    80000d4c:	0141                	add	sp,sp,16
    80000d4e:	8082                	ret
  return 0;
    80000d50:	4501                	li	a0,0
    80000d52:	bfe5                	j	80000d4a <memcmp+0x30>

0000000080000d54 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d54:	1141                	add	sp,sp,-16
    80000d56:	e422                	sd	s0,8(sp)
    80000d58:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d5a:	02a5e563          	bltu	a1,a0,80000d84 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d5e:	fff6069b          	addw	a3,a2,-1
    80000d62:	ce11                	beqz	a2,80000d7e <memmove+0x2a>
    80000d64:	1682                	sll	a3,a3,0x20
    80000d66:	9281                	srl	a3,a3,0x20
    80000d68:	0685                	add	a3,a3,1
    80000d6a:	96ae                	add	a3,a3,a1
    80000d6c:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000d6e:	0585                	add	a1,a1,1
    80000d70:	0785                	add	a5,a5,1
    80000d72:	fff5c703          	lbu	a4,-1(a1)
    80000d76:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000d7a:	fed59ae3          	bne	a1,a3,80000d6e <memmove+0x1a>

  return dst;
}
    80000d7e:	6422                	ld	s0,8(sp)
    80000d80:	0141                	add	sp,sp,16
    80000d82:	8082                	ret
  if(s < d && s + n > d){
    80000d84:	02061713          	sll	a4,a2,0x20
    80000d88:	9301                	srl	a4,a4,0x20
    80000d8a:	00e587b3          	add	a5,a1,a4
    80000d8e:	fcf578e3          	bgeu	a0,a5,80000d5e <memmove+0xa>
    d += n;
    80000d92:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000d94:	fff6069b          	addw	a3,a2,-1
    80000d98:	d27d                	beqz	a2,80000d7e <memmove+0x2a>
    80000d9a:	02069613          	sll	a2,a3,0x20
    80000d9e:	9201                	srl	a2,a2,0x20
    80000da0:	fff64613          	not	a2,a2
    80000da4:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000da6:	17fd                	add	a5,a5,-1
    80000da8:	177d                	add	a4,a4,-1 # ffffffffffffefff <end+0xffffffff7ffd7fdf>
    80000daa:	0007c683          	lbu	a3,0(a5)
    80000dae:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000db2:	fef61ae3          	bne	a2,a5,80000da6 <memmove+0x52>
    80000db6:	b7e1                	j	80000d7e <memmove+0x2a>

0000000080000db8 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000db8:	1141                	add	sp,sp,-16
    80000dba:	e406                	sd	ra,8(sp)
    80000dbc:	e022                	sd	s0,0(sp)
    80000dbe:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    80000dc0:	00000097          	auipc	ra,0x0
    80000dc4:	f94080e7          	jalr	-108(ra) # 80000d54 <memmove>
}
    80000dc8:	60a2                	ld	ra,8(sp)
    80000dca:	6402                	ld	s0,0(sp)
    80000dcc:	0141                	add	sp,sp,16
    80000dce:	8082                	ret

0000000080000dd0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000dd0:	1141                	add	sp,sp,-16
    80000dd2:	e422                	sd	s0,8(sp)
    80000dd4:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000dd6:	ce11                	beqz	a2,80000df2 <strncmp+0x22>
    80000dd8:	00054783          	lbu	a5,0(a0)
    80000ddc:	cf89                	beqz	a5,80000df6 <strncmp+0x26>
    80000dde:	0005c703          	lbu	a4,0(a1)
    80000de2:	00f71a63          	bne	a4,a5,80000df6 <strncmp+0x26>
    n--, p++, q++;
    80000de6:	367d                	addw	a2,a2,-1
    80000de8:	0505                	add	a0,a0,1
    80000dea:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dec:	f675                	bnez	a2,80000dd8 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000dee:	4501                	li	a0,0
    80000df0:	a809                	j	80000e02 <strncmp+0x32>
    80000df2:	4501                	li	a0,0
    80000df4:	a039                	j	80000e02 <strncmp+0x32>
  if(n == 0)
    80000df6:	ca09                	beqz	a2,80000e08 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000df8:	00054503          	lbu	a0,0(a0)
    80000dfc:	0005c783          	lbu	a5,0(a1)
    80000e00:	9d1d                	subw	a0,a0,a5
}
    80000e02:	6422                	ld	s0,8(sp)
    80000e04:	0141                	add	sp,sp,16
    80000e06:	8082                	ret
    return 0;
    80000e08:	4501                	li	a0,0
    80000e0a:	bfe5                	j	80000e02 <strncmp+0x32>

0000000080000e0c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e0c:	1141                	add	sp,sp,-16
    80000e0e:	e422                	sd	s0,8(sp)
    80000e10:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e12:	87aa                	mv	a5,a0
    80000e14:	86b2                	mv	a3,a2
    80000e16:	367d                	addw	a2,a2,-1
    80000e18:	00d05963          	blez	a3,80000e2a <strncpy+0x1e>
    80000e1c:	0785                	add	a5,a5,1
    80000e1e:	0005c703          	lbu	a4,0(a1)
    80000e22:	fee78fa3          	sb	a4,-1(a5)
    80000e26:	0585                	add	a1,a1,1
    80000e28:	f775                	bnez	a4,80000e14 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e2a:	873e                	mv	a4,a5
    80000e2c:	9fb5                	addw	a5,a5,a3
    80000e2e:	37fd                	addw	a5,a5,-1
    80000e30:	00c05963          	blez	a2,80000e42 <strncpy+0x36>
    *s++ = 0;
    80000e34:	0705                	add	a4,a4,1
    80000e36:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e3a:	40e786bb          	subw	a3,a5,a4
    80000e3e:	fed04be3          	bgtz	a3,80000e34 <strncpy+0x28>
  return os;
}
    80000e42:	6422                	ld	s0,8(sp)
    80000e44:	0141                	add	sp,sp,16
    80000e46:	8082                	ret

0000000080000e48 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e48:	1141                	add	sp,sp,-16
    80000e4a:	e422                	sd	s0,8(sp)
    80000e4c:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e4e:	02c05363          	blez	a2,80000e74 <safestrcpy+0x2c>
    80000e52:	fff6069b          	addw	a3,a2,-1
    80000e56:	1682                	sll	a3,a3,0x20
    80000e58:	9281                	srl	a3,a3,0x20
    80000e5a:	96ae                	add	a3,a3,a1
    80000e5c:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e5e:	00d58963          	beq	a1,a3,80000e70 <safestrcpy+0x28>
    80000e62:	0585                	add	a1,a1,1
    80000e64:	0785                	add	a5,a5,1
    80000e66:	fff5c703          	lbu	a4,-1(a1)
    80000e6a:	fee78fa3          	sb	a4,-1(a5)
    80000e6e:	fb65                	bnez	a4,80000e5e <safestrcpy+0x16>
    ;
  *s = 0;
    80000e70:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e74:	6422                	ld	s0,8(sp)
    80000e76:	0141                	add	sp,sp,16
    80000e78:	8082                	ret

0000000080000e7a <strlen>:

int
strlen(const char *s)
{
    80000e7a:	1141                	add	sp,sp,-16
    80000e7c:	e422                	sd	s0,8(sp)
    80000e7e:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e80:	00054783          	lbu	a5,0(a0)
    80000e84:	cf91                	beqz	a5,80000ea0 <strlen+0x26>
    80000e86:	0505                	add	a0,a0,1
    80000e88:	87aa                	mv	a5,a0
    80000e8a:	86be                	mv	a3,a5
    80000e8c:	0785                	add	a5,a5,1
    80000e8e:	fff7c703          	lbu	a4,-1(a5)
    80000e92:	ff65                	bnez	a4,80000e8a <strlen+0x10>
    80000e94:	40a6853b          	subw	a0,a3,a0
    80000e98:	2505                	addw	a0,a0,1
    ;
  return n;
}
    80000e9a:	6422                	ld	s0,8(sp)
    80000e9c:	0141                	add	sp,sp,16
    80000e9e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000ea0:	4501                	li	a0,0
    80000ea2:	bfe5                	j	80000e9a <strlen+0x20>

0000000080000ea4 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000ea4:	1141                	add	sp,sp,-16
    80000ea6:	e406                	sd	ra,8(sp)
    80000ea8:	e022                	sd	s0,0(sp)
    80000eaa:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    80000eac:	00001097          	auipc	ra,0x1
    80000eb0:	bb8080e7          	jalr	-1096(ra) # 80001a64 <cpuid>
#endif    
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000eb4:	00008717          	auipc	a4,0x8
    80000eb8:	15870713          	add	a4,a4,344 # 8000900c <started>
  if(cpuid() == 0){
    80000ebc:	c139                	beqz	a0,80000f02 <main+0x5e>
    while(started == 0)
    80000ebe:	431c                	lw	a5,0(a4)
    80000ec0:	2781                	sext.w	a5,a5
    80000ec2:	dff5                	beqz	a5,80000ebe <main+0x1a>
      ;
    __sync_synchronize();
    80000ec4:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000ec8:	00001097          	auipc	ra,0x1
    80000ecc:	b9c080e7          	jalr	-1124(ra) # 80001a64 <cpuid>
    80000ed0:	85aa                	mv	a1,a0
    80000ed2:	00007517          	auipc	a0,0x7
    80000ed6:	1e650513          	add	a0,a0,486 # 800080b8 <digits+0x78>
    80000eda:	fffff097          	auipc	ra,0xfffff
    80000ede:	6b2080e7          	jalr	1714(ra) # 8000058c <printf>
    kvminithart();    // turn on paging
    80000ee2:	00000097          	auipc	ra,0x0
    80000ee6:	0e0080e7          	jalr	224(ra) # 80000fc2 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000eea:	00002097          	auipc	ra,0x2
    80000eee:	a0e080e7          	jalr	-1522(ra) # 800028f8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ef2:	00005097          	auipc	ra,0x5
    80000ef6:	07e080e7          	jalr	126(ra) # 80005f70 <plicinithart>
  }

  scheduler();        
    80000efa:	00001097          	auipc	ra,0x1
    80000efe:	2c0080e7          	jalr	704(ra) # 800021ba <scheduler>
    consoleinit();
    80000f02:	fffff097          	auipc	ra,0xfffff
    80000f06:	550080e7          	jalr	1360(ra) # 80000452 <consoleinit>
    statsinit();
    80000f0a:	00006097          	auipc	ra,0x6
    80000f0e:	802080e7          	jalr	-2046(ra) # 8000670c <statsinit>
    printfinit();
    80000f12:	00000097          	auipc	ra,0x0
    80000f16:	85a080e7          	jalr	-1958(ra) # 8000076c <printfinit>
    printf("\n");
    80000f1a:	00007517          	auipc	a0,0x7
    80000f1e:	1ae50513          	add	a0,a0,430 # 800080c8 <digits+0x88>
    80000f22:	fffff097          	auipc	ra,0xfffff
    80000f26:	66a080e7          	jalr	1642(ra) # 8000058c <printf>
    printf("xv6 kernel is booting\n");
    80000f2a:	00007517          	auipc	a0,0x7
    80000f2e:	17650513          	add	a0,a0,374 # 800080a0 <digits+0x60>
    80000f32:	fffff097          	auipc	ra,0xfffff
    80000f36:	65a080e7          	jalr	1626(ra) # 8000058c <printf>
    printf("\n");
    80000f3a:	00007517          	auipc	a0,0x7
    80000f3e:	18e50513          	add	a0,a0,398 # 800080c8 <digits+0x88>
    80000f42:	fffff097          	auipc	ra,0xfffff
    80000f46:	64a080e7          	jalr	1610(ra) # 8000058c <printf>
    kinit();         // physical page allocator
    80000f4a:	00000097          	auipc	ra,0x0
    80000f4e:	b86080e7          	jalr	-1146(ra) # 80000ad0 <kinit>
    kvminit();       // create kernel page table
    80000f52:	00000097          	auipc	ra,0x0
    80000f56:	2a8080e7          	jalr	680(ra) # 800011fa <kvminit>
    kvminithart();   // turn on paging
    80000f5a:	00000097          	auipc	ra,0x0
    80000f5e:	068080e7          	jalr	104(ra) # 80000fc2 <kvminithart>
    procinit();      // process table
    80000f62:	00001097          	auipc	ra,0x1
    80000f66:	aa2080e7          	jalr	-1374(ra) # 80001a04 <procinit>
    trapinit();      // trap vectors
    80000f6a:	00002097          	auipc	ra,0x2
    80000f6e:	966080e7          	jalr	-1690(ra) # 800028d0 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f72:	00002097          	auipc	ra,0x2
    80000f76:	986080e7          	jalr	-1658(ra) # 800028f8 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f7a:	00005097          	auipc	ra,0x5
    80000f7e:	fe0080e7          	jalr	-32(ra) # 80005f5a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f82:	00005097          	auipc	ra,0x5
    80000f86:	fee080e7          	jalr	-18(ra) # 80005f70 <plicinithart>
    binit();         // buffer cache
    80000f8a:	00002097          	auipc	ra,0x2
    80000f8e:	164080e7          	jalr	356(ra) # 800030ee <binit>
    iinit();         // inode cache
    80000f92:	00002097          	auipc	ra,0x2
    80000f96:	7f0080e7          	jalr	2032(ra) # 80003782 <iinit>
    fileinit();      // file table
    80000f9a:	00003097          	auipc	ra,0x3
    80000f9e:	762080e7          	jalr	1890(ra) # 800046fc <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fa2:	00005097          	auipc	ra,0x5
    80000fa6:	0d4080e7          	jalr	212(ra) # 80006076 <virtio_disk_init>
    userinit();      // first user process
    80000faa:	00001097          	auipc	ra,0x1
    80000fae:	f18080e7          	jalr	-232(ra) # 80001ec2 <userinit>
    __sync_synchronize();
    80000fb2:	0ff0000f          	fence
    started = 1;
    80000fb6:	4785                	li	a5,1
    80000fb8:	00008717          	auipc	a4,0x8
    80000fbc:	04f72a23          	sw	a5,84(a4) # 8000900c <started>
    80000fc0:	bf2d                	j	80000efa <main+0x56>

0000000080000fc2 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000fc2:	1141                	add	sp,sp,-16
    80000fc4:	e422                	sd	s0,8(sp)
    80000fc6:	0800                	add	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000fc8:	00008797          	auipc	a5,0x8
    80000fcc:	0487b783          	ld	a5,72(a5) # 80009010 <kernel_pagetable>
    80000fd0:	83b1                	srl	a5,a5,0xc
    80000fd2:	577d                	li	a4,-1
    80000fd4:	177e                	sll	a4,a4,0x3f
    80000fd6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fd8:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000fdc:	12000073          	sfence.vma
  sfence_vma();
}
    80000fe0:	6422                	ld	s0,8(sp)
    80000fe2:	0141                	add	sp,sp,16
    80000fe4:	8082                	ret

0000000080000fe6 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fe6:	7139                	add	sp,sp,-64
    80000fe8:	fc06                	sd	ra,56(sp)
    80000fea:	f822                	sd	s0,48(sp)
    80000fec:	f426                	sd	s1,40(sp)
    80000fee:	f04a                	sd	s2,32(sp)
    80000ff0:	ec4e                	sd	s3,24(sp)
    80000ff2:	e852                	sd	s4,16(sp)
    80000ff4:	e456                	sd	s5,8(sp)
    80000ff6:	e05a                	sd	s6,0(sp)
    80000ff8:	0080                	add	s0,sp,64
    80000ffa:	84aa                	mv	s1,a0
    80000ffc:	89ae                	mv	s3,a1
    80000ffe:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80001000:	57fd                	li	a5,-1
    80001002:	83e9                	srl	a5,a5,0x1a
    80001004:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001006:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001008:	04b7f263          	bgeu	a5,a1,8000104c <walk+0x66>
    panic("walk");
    8000100c:	00007517          	auipc	a0,0x7
    80001010:	0c450513          	add	a0,a0,196 # 800080d0 <digits+0x90>
    80001014:	fffff097          	auipc	ra,0xfffff
    80001018:	52e080e7          	jalr	1326(ra) # 80000542 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000101c:	060a8663          	beqz	s5,80001088 <walk+0xa2>
    80001020:	00000097          	auipc	ra,0x0
    80001024:	aec080e7          	jalr	-1300(ra) # 80000b0c <kalloc>
    80001028:	84aa                	mv	s1,a0
    8000102a:	c529                	beqz	a0,80001074 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000102c:	6605                	lui	a2,0x1
    8000102e:	4581                	li	a1,0
    80001030:	00000097          	auipc	ra,0x0
    80001034:	cc8080e7          	jalr	-824(ra) # 80000cf8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001038:	00c4d793          	srl	a5,s1,0xc
    8000103c:	07aa                	sll	a5,a5,0xa
    8000103e:	0017e793          	or	a5,a5,1
    80001042:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001046:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd7fd7>
    80001048:	036a0063          	beq	s4,s6,80001068 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000104c:	0149d933          	srl	s2,s3,s4
    80001050:	1ff97913          	and	s2,s2,511
    80001054:	090e                	sll	s2,s2,0x3
    80001056:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001058:	00093483          	ld	s1,0(s2)
    8000105c:	0014f793          	and	a5,s1,1
    80001060:	dfd5                	beqz	a5,8000101c <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001062:	80a9                	srl	s1,s1,0xa
    80001064:	04b2                	sll	s1,s1,0xc
    80001066:	b7c5                	j	80001046 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001068:	00c9d513          	srl	a0,s3,0xc
    8000106c:	1ff57513          	and	a0,a0,511
    80001070:	050e                	sll	a0,a0,0x3
    80001072:	9526                	add	a0,a0,s1
}
    80001074:	70e2                	ld	ra,56(sp)
    80001076:	7442                	ld	s0,48(sp)
    80001078:	74a2                	ld	s1,40(sp)
    8000107a:	7902                	ld	s2,32(sp)
    8000107c:	69e2                	ld	s3,24(sp)
    8000107e:	6a42                	ld	s4,16(sp)
    80001080:	6aa2                	ld	s5,8(sp)
    80001082:	6b02                	ld	s6,0(sp)
    80001084:	6121                	add	sp,sp,64
    80001086:	8082                	ret
        return 0;
    80001088:	4501                	li	a0,0
    8000108a:	b7ed                	j	80001074 <walk+0x8e>

000000008000108c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000108c:	57fd                	li	a5,-1
    8000108e:	83e9                	srl	a5,a5,0x1a
    80001090:	00b7f463          	bgeu	a5,a1,80001098 <walkaddr+0xc>
    return 0;
    80001094:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001096:	8082                	ret
{
    80001098:	1141                	add	sp,sp,-16
    8000109a:	e406                	sd	ra,8(sp)
    8000109c:	e022                	sd	s0,0(sp)
    8000109e:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    800010a0:	4601                	li	a2,0
    800010a2:	00000097          	auipc	ra,0x0
    800010a6:	f44080e7          	jalr	-188(ra) # 80000fe6 <walk>
  if(pte == 0)
    800010aa:	c105                	beqz	a0,800010ca <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800010ac:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800010ae:	0117f693          	and	a3,a5,17
    800010b2:	4745                	li	a4,17
    return 0;
    800010b4:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800010b6:	00e68663          	beq	a3,a4,800010c2 <walkaddr+0x36>
}
    800010ba:	60a2                	ld	ra,8(sp)
    800010bc:	6402                	ld	s0,0(sp)
    800010be:	0141                	add	sp,sp,16
    800010c0:	8082                	ret
  pa = PTE2PA(*pte);
    800010c2:	83a9                	srl	a5,a5,0xa
    800010c4:	00c79513          	sll	a0,a5,0xc
  return pa;
    800010c8:	bfcd                	j	800010ba <walkaddr+0x2e>
    return 0;
    800010ca:	4501                	li	a0,0
    800010cc:	b7fd                	j	800010ba <walkaddr+0x2e>

00000000800010ce <kvmpa>:
// a physical address. only needed for
// addresses on the stack.
// assumes va is page aligned.
uint64
kvmpa(uint64 va)
{
    800010ce:	1101                	add	sp,sp,-32
    800010d0:	ec06                	sd	ra,24(sp)
    800010d2:	e822                	sd	s0,16(sp)
    800010d4:	e426                	sd	s1,8(sp)
    800010d6:	e04a                	sd	s2,0(sp)
    800010d8:	1000                	add	s0,sp,32
    800010da:	84aa                	mv	s1,a0
  uint64 off = va % PGSIZE;
    800010dc:	1552                	sll	a0,a0,0x34
    800010de:	03455913          	srl	s2,a0,0x34
  pte_t *pte;
  uint64 pa;

  pte = walk(myproc()->kernel_pagetable, va, 0);
    800010e2:	00001097          	auipc	ra,0x1
    800010e6:	9ae080e7          	jalr	-1618(ra) # 80001a90 <myproc>
    800010ea:	4601                	li	a2,0
    800010ec:	85a6                	mv	a1,s1
    800010ee:	6d28                	ld	a0,88(a0)
    800010f0:	00000097          	auipc	ra,0x0
    800010f4:	ef6080e7          	jalr	-266(ra) # 80000fe6 <walk>
  if(pte == 0)
    800010f8:	cd11                	beqz	a0,80001114 <kvmpa+0x46>
    panic("kvmpa");
  if((*pte & PTE_V) == 0)
    800010fa:	6108                	ld	a0,0(a0)
    800010fc:	00157793          	and	a5,a0,1
    80001100:	c395                	beqz	a5,80001124 <kvmpa+0x56>
    panic("kvmpa");
  pa = PTE2PA(*pte);
    80001102:	8129                	srl	a0,a0,0xa
    80001104:	0532                	sll	a0,a0,0xc
  return pa+off;
}
    80001106:	954a                	add	a0,a0,s2
    80001108:	60e2                	ld	ra,24(sp)
    8000110a:	6442                	ld	s0,16(sp)
    8000110c:	64a2                	ld	s1,8(sp)
    8000110e:	6902                	ld	s2,0(sp)
    80001110:	6105                	add	sp,sp,32
    80001112:	8082                	ret
    panic("kvmpa");
    80001114:	00007517          	auipc	a0,0x7
    80001118:	fc450513          	add	a0,a0,-60 # 800080d8 <digits+0x98>
    8000111c:	fffff097          	auipc	ra,0xfffff
    80001120:	426080e7          	jalr	1062(ra) # 80000542 <panic>
    panic("kvmpa");
    80001124:	00007517          	auipc	a0,0x7
    80001128:	fb450513          	add	a0,a0,-76 # 800080d8 <digits+0x98>
    8000112c:	fffff097          	auipc	ra,0xfffff
    80001130:	416080e7          	jalr	1046(ra) # 80000542 <panic>

0000000080001134 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001134:	715d                	add	sp,sp,-80
    80001136:	e486                	sd	ra,72(sp)
    80001138:	e0a2                	sd	s0,64(sp)
    8000113a:	fc26                	sd	s1,56(sp)
    8000113c:	f84a                	sd	s2,48(sp)
    8000113e:	f44e                	sd	s3,40(sp)
    80001140:	f052                	sd	s4,32(sp)
    80001142:	ec56                	sd	s5,24(sp)
    80001144:	e85a                	sd	s6,16(sp)
    80001146:	e45e                	sd	s7,8(sp)
    80001148:	0880                	add	s0,sp,80
    8000114a:	8aaa                	mv	s5,a0
    8000114c:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    8000114e:	777d                	lui	a4,0xfffff
    80001150:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001154:	fff60993          	add	s3,a2,-1 # fff <_entry-0x7ffff001>
    80001158:	99ae                	add	s3,s3,a1
    8000115a:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000115e:	893e                	mv	s2,a5
    80001160:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001164:	6b85                	lui	s7,0x1
    80001166:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000116a:	4605                	li	a2,1
    8000116c:	85ca                	mv	a1,s2
    8000116e:	8556                	mv	a0,s5
    80001170:	00000097          	auipc	ra,0x0
    80001174:	e76080e7          	jalr	-394(ra) # 80000fe6 <walk>
    80001178:	c51d                	beqz	a0,800011a6 <mappages+0x72>
    if(*pte & PTE_V)
    8000117a:	611c                	ld	a5,0(a0)
    8000117c:	8b85                	and	a5,a5,1
    8000117e:	ef81                	bnez	a5,80001196 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001180:	80b1                	srl	s1,s1,0xc
    80001182:	04aa                	sll	s1,s1,0xa
    80001184:	0164e4b3          	or	s1,s1,s6
    80001188:	0014e493          	or	s1,s1,1
    8000118c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000118e:	03390863          	beq	s2,s3,800011be <mappages+0x8a>
    a += PGSIZE;
    80001192:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001194:	bfc9                	j	80001166 <mappages+0x32>
      panic("remap");
    80001196:	00007517          	auipc	a0,0x7
    8000119a:	f4a50513          	add	a0,a0,-182 # 800080e0 <digits+0xa0>
    8000119e:	fffff097          	auipc	ra,0xfffff
    800011a2:	3a4080e7          	jalr	932(ra) # 80000542 <panic>
      return -1;
    800011a6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800011a8:	60a6                	ld	ra,72(sp)
    800011aa:	6406                	ld	s0,64(sp)
    800011ac:	74e2                	ld	s1,56(sp)
    800011ae:	7942                	ld	s2,48(sp)
    800011b0:	79a2                	ld	s3,40(sp)
    800011b2:	7a02                	ld	s4,32(sp)
    800011b4:	6ae2                	ld	s5,24(sp)
    800011b6:	6b42                	ld	s6,16(sp)
    800011b8:	6ba2                	ld	s7,8(sp)
    800011ba:	6161                	add	sp,sp,80
    800011bc:	8082                	ret
  return 0;
    800011be:	4501                	li	a0,0
    800011c0:	b7e5                	j	800011a8 <mappages+0x74>

00000000800011c2 <kvmmap>:
{
    800011c2:	1141                	add	sp,sp,-16
    800011c4:	e406                	sd	ra,8(sp)
    800011c6:	e022                	sd	s0,0(sp)
    800011c8:	0800                	add	s0,sp,16
    800011ca:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800011cc:	86ae                	mv	a3,a1
    800011ce:	85aa                	mv	a1,a0
    800011d0:	00008517          	auipc	a0,0x8
    800011d4:	e4053503          	ld	a0,-448(a0) # 80009010 <kernel_pagetable>
    800011d8:	00000097          	auipc	ra,0x0
    800011dc:	f5c080e7          	jalr	-164(ra) # 80001134 <mappages>
    800011e0:	e509                	bnez	a0,800011ea <kvmmap+0x28>
}
    800011e2:	60a2                	ld	ra,8(sp)
    800011e4:	6402                	ld	s0,0(sp)
    800011e6:	0141                	add	sp,sp,16
    800011e8:	8082                	ret
    panic("kvmmap");
    800011ea:	00007517          	auipc	a0,0x7
    800011ee:	efe50513          	add	a0,a0,-258 # 800080e8 <digits+0xa8>
    800011f2:	fffff097          	auipc	ra,0xfffff
    800011f6:	350080e7          	jalr	848(ra) # 80000542 <panic>

00000000800011fa <kvminit>:
kvminit(){
    800011fa:	1101                	add	sp,sp,-32
    800011fc:	ec06                	sd	ra,24(sp)
    800011fe:	e822                	sd	s0,16(sp)
    80001200:	e426                	sd	s1,8(sp)
    80001202:	1000                	add	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    80001204:	00000097          	auipc	ra,0x0
    80001208:	908080e7          	jalr	-1784(ra) # 80000b0c <kalloc>
    8000120c:	00008717          	auipc	a4,0x8
    80001210:	e0a73223          	sd	a0,-508(a4) # 80009010 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    80001214:	6605                	lui	a2,0x1
    80001216:	4581                	li	a1,0
    80001218:	00000097          	auipc	ra,0x0
    8000121c:	ae0080e7          	jalr	-1312(ra) # 80000cf8 <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001220:	4699                	li	a3,6
    80001222:	6605                	lui	a2,0x1
    80001224:	100005b7          	lui	a1,0x10000
    80001228:	10000537          	lui	a0,0x10000
    8000122c:	00000097          	auipc	ra,0x0
    80001230:	f96080e7          	jalr	-106(ra) # 800011c2 <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001234:	4699                	li	a3,6
    80001236:	6605                	lui	a2,0x1
    80001238:	100015b7          	lui	a1,0x10001
    8000123c:	10001537          	lui	a0,0x10001
    80001240:	00000097          	auipc	ra,0x0
    80001244:	f82080e7          	jalr	-126(ra) # 800011c2 <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    80001248:	4699                	li	a3,6
    8000124a:	6641                	lui	a2,0x10
    8000124c:	020005b7          	lui	a1,0x2000
    80001250:	02000537          	lui	a0,0x2000
    80001254:	00000097          	auipc	ra,0x0
    80001258:	f6e080e7          	jalr	-146(ra) # 800011c2 <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000125c:	4699                	li	a3,6
    8000125e:	00400637          	lui	a2,0x400
    80001262:	0c0005b7          	lui	a1,0xc000
    80001266:	0c000537          	lui	a0,0xc000
    8000126a:	00000097          	auipc	ra,0x0
    8000126e:	f58080e7          	jalr	-168(ra) # 800011c2 <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001272:	00007497          	auipc	s1,0x7
    80001276:	d8e48493          	add	s1,s1,-626 # 80008000 <etext>
    8000127a:	46a9                	li	a3,10
    8000127c:	80007617          	auipc	a2,0x80007
    80001280:	d8460613          	add	a2,a2,-636 # 8000 <_entry-0x7fff8000>
    80001284:	4585                	li	a1,1
    80001286:	05fe                	sll	a1,a1,0x1f
    80001288:	852e                	mv	a0,a1
    8000128a:	00000097          	auipc	ra,0x0
    8000128e:	f38080e7          	jalr	-200(ra) # 800011c2 <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001292:	4699                	li	a3,6
    80001294:	4645                	li	a2,17
    80001296:	066e                	sll	a2,a2,0x1b
    80001298:	8e05                	sub	a2,a2,s1
    8000129a:	85a6                	mv	a1,s1
    8000129c:	8526                	mv	a0,s1
    8000129e:	00000097          	auipc	ra,0x0
    800012a2:	f24080e7          	jalr	-220(ra) # 800011c2 <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800012a6:	46a9                	li	a3,10
    800012a8:	6605                	lui	a2,0x1
    800012aa:	00006597          	auipc	a1,0x6
    800012ae:	d5658593          	add	a1,a1,-682 # 80007000 <_trampoline>
    800012b2:	04000537          	lui	a0,0x4000
    800012b6:	157d                	add	a0,a0,-1 # 3ffffff <_entry-0x7c000001>
    800012b8:	0532                	sll	a0,a0,0xc
    800012ba:	00000097          	auipc	ra,0x0
    800012be:	f08080e7          	jalr	-248(ra) # 800011c2 <kvmmap>
}
    800012c2:	60e2                	ld	ra,24(sp)
    800012c4:	6442                	ld	s0,16(sp)
    800012c6:	64a2                	ld	s1,8(sp)
    800012c8:	6105                	add	sp,sp,32
    800012ca:	8082                	ret

00000000800012cc <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012cc:	715d                	add	sp,sp,-80
    800012ce:	e486                	sd	ra,72(sp)
    800012d0:	e0a2                	sd	s0,64(sp)
    800012d2:	fc26                	sd	s1,56(sp)
    800012d4:	f84a                	sd	s2,48(sp)
    800012d6:	f44e                	sd	s3,40(sp)
    800012d8:	f052                	sd	s4,32(sp)
    800012da:	ec56                	sd	s5,24(sp)
    800012dc:	e85a                	sd	s6,16(sp)
    800012de:	e45e                	sd	s7,8(sp)
    800012e0:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800012e2:	03459793          	sll	a5,a1,0x34
    800012e6:	e795                	bnez	a5,80001312 <uvmunmap+0x46>
    800012e8:	8a2a                	mv	s4,a0
    800012ea:	892e                	mv	s2,a1
    800012ec:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012ee:	0632                	sll	a2,a2,0xc
    800012f0:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800012f4:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012f6:	6b05                	lui	s6,0x1
    800012f8:	0735e263          	bltu	a1,s3,8000135c <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800012fc:	60a6                	ld	ra,72(sp)
    800012fe:	6406                	ld	s0,64(sp)
    80001300:	74e2                	ld	s1,56(sp)
    80001302:	7942                	ld	s2,48(sp)
    80001304:	79a2                	ld	s3,40(sp)
    80001306:	7a02                	ld	s4,32(sp)
    80001308:	6ae2                	ld	s5,24(sp)
    8000130a:	6b42                	ld	s6,16(sp)
    8000130c:	6ba2                	ld	s7,8(sp)
    8000130e:	6161                	add	sp,sp,80
    80001310:	8082                	ret
    panic("uvmunmap: not aligned");
    80001312:	00007517          	auipc	a0,0x7
    80001316:	dde50513          	add	a0,a0,-546 # 800080f0 <digits+0xb0>
    8000131a:	fffff097          	auipc	ra,0xfffff
    8000131e:	228080e7          	jalr	552(ra) # 80000542 <panic>
      panic("uvmunmap: walk");
    80001322:	00007517          	auipc	a0,0x7
    80001326:	de650513          	add	a0,a0,-538 # 80008108 <digits+0xc8>
    8000132a:	fffff097          	auipc	ra,0xfffff
    8000132e:	218080e7          	jalr	536(ra) # 80000542 <panic>
      panic("uvmunmap: not mapped");
    80001332:	00007517          	auipc	a0,0x7
    80001336:	de650513          	add	a0,a0,-538 # 80008118 <digits+0xd8>
    8000133a:	fffff097          	auipc	ra,0xfffff
    8000133e:	208080e7          	jalr	520(ra) # 80000542 <panic>
      panic("uvmunmap: not a leaf");
    80001342:	00007517          	auipc	a0,0x7
    80001346:	dee50513          	add	a0,a0,-530 # 80008130 <digits+0xf0>
    8000134a:	fffff097          	auipc	ra,0xfffff
    8000134e:	1f8080e7          	jalr	504(ra) # 80000542 <panic>
    *pte = 0;
    80001352:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001356:	995a                	add	s2,s2,s6
    80001358:	fb3972e3          	bgeu	s2,s3,800012fc <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000135c:	4601                	li	a2,0
    8000135e:	85ca                	mv	a1,s2
    80001360:	8552                	mv	a0,s4
    80001362:	00000097          	auipc	ra,0x0
    80001366:	c84080e7          	jalr	-892(ra) # 80000fe6 <walk>
    8000136a:	84aa                	mv	s1,a0
    8000136c:	d95d                	beqz	a0,80001322 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000136e:	6108                	ld	a0,0(a0)
    80001370:	00157793          	and	a5,a0,1
    80001374:	dfdd                	beqz	a5,80001332 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001376:	3ff57793          	and	a5,a0,1023
    8000137a:	fd7784e3          	beq	a5,s7,80001342 <uvmunmap+0x76>
    if(do_free){
    8000137e:	fc0a8ae3          	beqz	s5,80001352 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80001382:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    80001384:	0532                	sll	a0,a0,0xc
    80001386:	fffff097          	auipc	ra,0xfffff
    8000138a:	688080e7          	jalr	1672(ra) # 80000a0e <kfree>
    8000138e:	b7d1                	j	80001352 <uvmunmap+0x86>

0000000080001390 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001390:	1101                	add	sp,sp,-32
    80001392:	ec06                	sd	ra,24(sp)
    80001394:	e822                	sd	s0,16(sp)
    80001396:	e426                	sd	s1,8(sp)
    80001398:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000139a:	fffff097          	auipc	ra,0xfffff
    8000139e:	772080e7          	jalr	1906(ra) # 80000b0c <kalloc>
    800013a2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800013a4:	c519                	beqz	a0,800013b2 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800013a6:	6605                	lui	a2,0x1
    800013a8:	4581                	li	a1,0
    800013aa:	00000097          	auipc	ra,0x0
    800013ae:	94e080e7          	jalr	-1714(ra) # 80000cf8 <memset>
  return pagetable;
}
    800013b2:	8526                	mv	a0,s1
    800013b4:	60e2                	ld	ra,24(sp)
    800013b6:	6442                	ld	s0,16(sp)
    800013b8:	64a2                	ld	s1,8(sp)
    800013ba:	6105                	add	sp,sp,32
    800013bc:	8082                	ret

00000000800013be <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800013be:	7179                	add	sp,sp,-48
    800013c0:	f406                	sd	ra,40(sp)
    800013c2:	f022                	sd	s0,32(sp)
    800013c4:	ec26                	sd	s1,24(sp)
    800013c6:	e84a                	sd	s2,16(sp)
    800013c8:	e44e                	sd	s3,8(sp)
    800013ca:	e052                	sd	s4,0(sp)
    800013cc:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800013ce:	6785                	lui	a5,0x1
    800013d0:	04f67863          	bgeu	a2,a5,80001420 <uvminit+0x62>
    800013d4:	8a2a                	mv	s4,a0
    800013d6:	89ae                	mv	s3,a1
    800013d8:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    800013da:	fffff097          	auipc	ra,0xfffff
    800013de:	732080e7          	jalr	1842(ra) # 80000b0c <kalloc>
    800013e2:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800013e4:	6605                	lui	a2,0x1
    800013e6:	4581                	li	a1,0
    800013e8:	00000097          	auipc	ra,0x0
    800013ec:	910080e7          	jalr	-1776(ra) # 80000cf8 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800013f0:	4779                	li	a4,30
    800013f2:	86ca                	mv	a3,s2
    800013f4:	6605                	lui	a2,0x1
    800013f6:	4581                	li	a1,0
    800013f8:	8552                	mv	a0,s4
    800013fa:	00000097          	auipc	ra,0x0
    800013fe:	d3a080e7          	jalr	-710(ra) # 80001134 <mappages>
  memmove(mem, src, sz);
    80001402:	8626                	mv	a2,s1
    80001404:	85ce                	mv	a1,s3
    80001406:	854a                	mv	a0,s2
    80001408:	00000097          	auipc	ra,0x0
    8000140c:	94c080e7          	jalr	-1716(ra) # 80000d54 <memmove>
}
    80001410:	70a2                	ld	ra,40(sp)
    80001412:	7402                	ld	s0,32(sp)
    80001414:	64e2                	ld	s1,24(sp)
    80001416:	6942                	ld	s2,16(sp)
    80001418:	69a2                	ld	s3,8(sp)
    8000141a:	6a02                	ld	s4,0(sp)
    8000141c:	6145                	add	sp,sp,48
    8000141e:	8082                	ret
    panic("inituvm: more than a page");
    80001420:	00007517          	auipc	a0,0x7
    80001424:	d2850513          	add	a0,a0,-728 # 80008148 <digits+0x108>
    80001428:	fffff097          	auipc	ra,0xfffff
    8000142c:	11a080e7          	jalr	282(ra) # 80000542 <panic>

0000000080001430 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001430:	1101                	add	sp,sp,-32
    80001432:	ec06                	sd	ra,24(sp)
    80001434:	e822                	sd	s0,16(sp)
    80001436:	e426                	sd	s1,8(sp)
    80001438:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000143a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000143c:	00b67d63          	bgeu	a2,a1,80001456 <uvmdealloc+0x26>
    80001440:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001442:	6785                	lui	a5,0x1
    80001444:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001446:	00f60733          	add	a4,a2,a5
    8000144a:	76fd                	lui	a3,0xfffff
    8000144c:	8f75                	and	a4,a4,a3
    8000144e:	97ae                	add	a5,a5,a1
    80001450:	8ff5                	and	a5,a5,a3
    80001452:	00f76863          	bltu	a4,a5,80001462 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001456:	8526                	mv	a0,s1
    80001458:	60e2                	ld	ra,24(sp)
    8000145a:	6442                	ld	s0,16(sp)
    8000145c:	64a2                	ld	s1,8(sp)
    8000145e:	6105                	add	sp,sp,32
    80001460:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001462:	8f99                	sub	a5,a5,a4
    80001464:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001466:	4685                	li	a3,1
    80001468:	0007861b          	sext.w	a2,a5
    8000146c:	85ba                	mv	a1,a4
    8000146e:	00000097          	auipc	ra,0x0
    80001472:	e5e080e7          	jalr	-418(ra) # 800012cc <uvmunmap>
    80001476:	b7c5                	j	80001456 <uvmdealloc+0x26>

0000000080001478 <uvmalloc>:
  if(newsz < oldsz)
    80001478:	0ab66163          	bltu	a2,a1,8000151a <uvmalloc+0xa2>
{
    8000147c:	7139                	add	sp,sp,-64
    8000147e:	fc06                	sd	ra,56(sp)
    80001480:	f822                	sd	s0,48(sp)
    80001482:	f426                	sd	s1,40(sp)
    80001484:	f04a                	sd	s2,32(sp)
    80001486:	ec4e                	sd	s3,24(sp)
    80001488:	e852                	sd	s4,16(sp)
    8000148a:	e456                	sd	s5,8(sp)
    8000148c:	0080                	add	s0,sp,64
    8000148e:	8aaa                	mv	s5,a0
    80001490:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001492:	6785                	lui	a5,0x1
    80001494:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001496:	95be                	add	a1,a1,a5
    80001498:	77fd                	lui	a5,0xfffff
    8000149a:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000149e:	08c9f063          	bgeu	s3,a2,8000151e <uvmalloc+0xa6>
    800014a2:	894e                	mv	s2,s3
    mem = kalloc();
    800014a4:	fffff097          	auipc	ra,0xfffff
    800014a8:	668080e7          	jalr	1640(ra) # 80000b0c <kalloc>
    800014ac:	84aa                	mv	s1,a0
    if(mem == 0){
    800014ae:	c51d                	beqz	a0,800014dc <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800014b0:	6605                	lui	a2,0x1
    800014b2:	4581                	li	a1,0
    800014b4:	00000097          	auipc	ra,0x0
    800014b8:	844080e7          	jalr	-1980(ra) # 80000cf8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800014bc:	4779                	li	a4,30
    800014be:	86a6                	mv	a3,s1
    800014c0:	6605                	lui	a2,0x1
    800014c2:	85ca                	mv	a1,s2
    800014c4:	8556                	mv	a0,s5
    800014c6:	00000097          	auipc	ra,0x0
    800014ca:	c6e080e7          	jalr	-914(ra) # 80001134 <mappages>
    800014ce:	e905                	bnez	a0,800014fe <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014d0:	6785                	lui	a5,0x1
    800014d2:	993e                	add	s2,s2,a5
    800014d4:	fd4968e3          	bltu	s2,s4,800014a4 <uvmalloc+0x2c>
  return newsz;
    800014d8:	8552                	mv	a0,s4
    800014da:	a809                	j	800014ec <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800014dc:	864e                	mv	a2,s3
    800014de:	85ca                	mv	a1,s2
    800014e0:	8556                	mv	a0,s5
    800014e2:	00000097          	auipc	ra,0x0
    800014e6:	f4e080e7          	jalr	-178(ra) # 80001430 <uvmdealloc>
      return 0;
    800014ea:	4501                	li	a0,0
}
    800014ec:	70e2                	ld	ra,56(sp)
    800014ee:	7442                	ld	s0,48(sp)
    800014f0:	74a2                	ld	s1,40(sp)
    800014f2:	7902                	ld	s2,32(sp)
    800014f4:	69e2                	ld	s3,24(sp)
    800014f6:	6a42                	ld	s4,16(sp)
    800014f8:	6aa2                	ld	s5,8(sp)
    800014fa:	6121                	add	sp,sp,64
    800014fc:	8082                	ret
      kfree(mem);
    800014fe:	8526                	mv	a0,s1
    80001500:	fffff097          	auipc	ra,0xfffff
    80001504:	50e080e7          	jalr	1294(ra) # 80000a0e <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001508:	864e                	mv	a2,s3
    8000150a:	85ca                	mv	a1,s2
    8000150c:	8556                	mv	a0,s5
    8000150e:	00000097          	auipc	ra,0x0
    80001512:	f22080e7          	jalr	-222(ra) # 80001430 <uvmdealloc>
      return 0;
    80001516:	4501                	li	a0,0
    80001518:	bfd1                	j	800014ec <uvmalloc+0x74>
    return oldsz;
    8000151a:	852e                	mv	a0,a1
}
    8000151c:	8082                	ret
  return newsz;
    8000151e:	8532                	mv	a0,a2
    80001520:	b7f1                	j	800014ec <uvmalloc+0x74>

0000000080001522 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001522:	7179                	add	sp,sp,-48
    80001524:	f406                	sd	ra,40(sp)
    80001526:	f022                	sd	s0,32(sp)
    80001528:	ec26                	sd	s1,24(sp)
    8000152a:	e84a                	sd	s2,16(sp)
    8000152c:	e44e                	sd	s3,8(sp)
    8000152e:	e052                	sd	s4,0(sp)
    80001530:	1800                	add	s0,sp,48
    80001532:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001534:	84aa                	mv	s1,a0
    80001536:	6905                	lui	s2,0x1
    80001538:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000153a:	4985                	li	s3,1
    8000153c:	a829                	j	80001556 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000153e:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001540:	00c79513          	sll	a0,a5,0xc
    80001544:	00000097          	auipc	ra,0x0
    80001548:	fde080e7          	jalr	-34(ra) # 80001522 <freewalk>
      pagetable[i] = 0;
    8000154c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001550:	04a1                	add	s1,s1,8
    80001552:	03248163          	beq	s1,s2,80001574 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80001556:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001558:	00f7f713          	and	a4,a5,15
    8000155c:	ff3701e3          	beq	a4,s3,8000153e <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001560:	8b85                	and	a5,a5,1
    80001562:	d7fd                	beqz	a5,80001550 <freewalk+0x2e>
      panic("freewalk: leaf");
    80001564:	00007517          	auipc	a0,0x7
    80001568:	c0450513          	add	a0,a0,-1020 # 80008168 <digits+0x128>
    8000156c:	fffff097          	auipc	ra,0xfffff
    80001570:	fd6080e7          	jalr	-42(ra) # 80000542 <panic>
    }
  }
  kfree((void*)pagetable);
    80001574:	8552                	mv	a0,s4
    80001576:	fffff097          	auipc	ra,0xfffff
    8000157a:	498080e7          	jalr	1176(ra) # 80000a0e <kfree>
}
    8000157e:	70a2                	ld	ra,40(sp)
    80001580:	7402                	ld	s0,32(sp)
    80001582:	64e2                	ld	s1,24(sp)
    80001584:	6942                	ld	s2,16(sp)
    80001586:	69a2                	ld	s3,8(sp)
    80001588:	6a02                	ld	s4,0(sp)
    8000158a:	6145                	add	sp,sp,48
    8000158c:	8082                	ret

000000008000158e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000158e:	1101                	add	sp,sp,-32
    80001590:	ec06                	sd	ra,24(sp)
    80001592:	e822                	sd	s0,16(sp)
    80001594:	e426                	sd	s1,8(sp)
    80001596:	1000                	add	s0,sp,32
    80001598:	84aa                	mv	s1,a0
  if(sz > 0)
    8000159a:	e999                	bnez	a1,800015b0 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000159c:	8526                	mv	a0,s1
    8000159e:	00000097          	auipc	ra,0x0
    800015a2:	f84080e7          	jalr	-124(ra) # 80001522 <freewalk>
}
    800015a6:	60e2                	ld	ra,24(sp)
    800015a8:	6442                	ld	s0,16(sp)
    800015aa:	64a2                	ld	s1,8(sp)
    800015ac:	6105                	add	sp,sp,32
    800015ae:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800015b0:	6785                	lui	a5,0x1
    800015b2:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800015b4:	95be                	add	a1,a1,a5
    800015b6:	4685                	li	a3,1
    800015b8:	00c5d613          	srl	a2,a1,0xc
    800015bc:	4581                	li	a1,0
    800015be:	00000097          	auipc	ra,0x0
    800015c2:	d0e080e7          	jalr	-754(ra) # 800012cc <uvmunmap>
    800015c6:	bfd9                	j	8000159c <uvmfree+0xe>

00000000800015c8 <uvmfree0>:

void
uvmfree0(pagetable_t pagetable, uint64 va, uint64 npages)
{
    800015c8:	1101                	add	sp,sp,-32
    800015ca:	ec06                	sd	ra,24(sp)
    800015cc:	e822                	sd	s0,16(sp)
    800015ce:	e426                	sd	s1,8(sp)
    800015d0:	1000                	add	s0,sp,32
    800015d2:	84aa                	mv	s1,a0
  if(npages > 0)
    800015d4:	ea19                	bnez	a2,800015ea <uvmfree0+0x22>
    uvmunmap(pagetable, va, npages, 1);
  freewalk(pagetable);
    800015d6:	8526                	mv	a0,s1
    800015d8:	00000097          	auipc	ra,0x0
    800015dc:	f4a080e7          	jalr	-182(ra) # 80001522 <freewalk>
}
    800015e0:	60e2                	ld	ra,24(sp)
    800015e2:	6442                	ld	s0,16(sp)
    800015e4:	64a2                	ld	s1,8(sp)
    800015e6:	6105                	add	sp,sp,32
    800015e8:	8082                	ret
    uvmunmap(pagetable, va, npages, 1);
    800015ea:	4685                	li	a3,1
    800015ec:	00000097          	auipc	ra,0x0
    800015f0:	ce0080e7          	jalr	-800(ra) # 800012cc <uvmunmap>
    800015f4:	b7cd                	j	800015d6 <uvmfree0+0xe>

00000000800015f6 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800015f6:	c679                	beqz	a2,800016c4 <uvmcopy+0xce>
{
    800015f8:	715d                	add	sp,sp,-80
    800015fa:	e486                	sd	ra,72(sp)
    800015fc:	e0a2                	sd	s0,64(sp)
    800015fe:	fc26                	sd	s1,56(sp)
    80001600:	f84a                	sd	s2,48(sp)
    80001602:	f44e                	sd	s3,40(sp)
    80001604:	f052                	sd	s4,32(sp)
    80001606:	ec56                	sd	s5,24(sp)
    80001608:	e85a                	sd	s6,16(sp)
    8000160a:	e45e                	sd	s7,8(sp)
    8000160c:	0880                	add	s0,sp,80
    8000160e:	8b2a                	mv	s6,a0
    80001610:	8aae                	mv	s5,a1
    80001612:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001614:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001616:	4601                	li	a2,0
    80001618:	85ce                	mv	a1,s3
    8000161a:	855a                	mv	a0,s6
    8000161c:	00000097          	auipc	ra,0x0
    80001620:	9ca080e7          	jalr	-1590(ra) # 80000fe6 <walk>
    80001624:	c531                	beqz	a0,80001670 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001626:	6118                	ld	a4,0(a0)
    80001628:	00177793          	and	a5,a4,1
    8000162c:	cbb1                	beqz	a5,80001680 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000162e:	00a75593          	srl	a1,a4,0xa
    80001632:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001636:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000163a:	fffff097          	auipc	ra,0xfffff
    8000163e:	4d2080e7          	jalr	1234(ra) # 80000b0c <kalloc>
    80001642:	892a                	mv	s2,a0
    80001644:	c939                	beqz	a0,8000169a <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001646:	6605                	lui	a2,0x1
    80001648:	85de                	mv	a1,s7
    8000164a:	fffff097          	auipc	ra,0xfffff
    8000164e:	70a080e7          	jalr	1802(ra) # 80000d54 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001652:	8726                	mv	a4,s1
    80001654:	86ca                	mv	a3,s2
    80001656:	6605                	lui	a2,0x1
    80001658:	85ce                	mv	a1,s3
    8000165a:	8556                	mv	a0,s5
    8000165c:	00000097          	auipc	ra,0x0
    80001660:	ad8080e7          	jalr	-1320(ra) # 80001134 <mappages>
    80001664:	e515                	bnez	a0,80001690 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80001666:	6785                	lui	a5,0x1
    80001668:	99be                	add	s3,s3,a5
    8000166a:	fb49e6e3          	bltu	s3,s4,80001616 <uvmcopy+0x20>
    8000166e:	a081                	j	800016ae <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80001670:	00007517          	auipc	a0,0x7
    80001674:	b0850513          	add	a0,a0,-1272 # 80008178 <digits+0x138>
    80001678:	fffff097          	auipc	ra,0xfffff
    8000167c:	eca080e7          	jalr	-310(ra) # 80000542 <panic>
      panic("uvmcopy: page not present");
    80001680:	00007517          	auipc	a0,0x7
    80001684:	b1850513          	add	a0,a0,-1256 # 80008198 <digits+0x158>
    80001688:	fffff097          	auipc	ra,0xfffff
    8000168c:	eba080e7          	jalr	-326(ra) # 80000542 <panic>
      kfree(mem);
    80001690:	854a                	mv	a0,s2
    80001692:	fffff097          	auipc	ra,0xfffff
    80001696:	37c080e7          	jalr	892(ra) # 80000a0e <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000169a:	4685                	li	a3,1
    8000169c:	00c9d613          	srl	a2,s3,0xc
    800016a0:	4581                	li	a1,0
    800016a2:	8556                	mv	a0,s5
    800016a4:	00000097          	auipc	ra,0x0
    800016a8:	c28080e7          	jalr	-984(ra) # 800012cc <uvmunmap>
  return -1;
    800016ac:	557d                	li	a0,-1
}
    800016ae:	60a6                	ld	ra,72(sp)
    800016b0:	6406                	ld	s0,64(sp)
    800016b2:	74e2                	ld	s1,56(sp)
    800016b4:	7942                	ld	s2,48(sp)
    800016b6:	79a2                	ld	s3,40(sp)
    800016b8:	7a02                	ld	s4,32(sp)
    800016ba:	6ae2                	ld	s5,24(sp)
    800016bc:	6b42                	ld	s6,16(sp)
    800016be:	6ba2                	ld	s7,8(sp)
    800016c0:	6161                	add	sp,sp,80
    800016c2:	8082                	ret
  return 0;
    800016c4:	4501                	li	a0,0
}
    800016c6:	8082                	ret

00000000800016c8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800016c8:	1141                	add	sp,sp,-16
    800016ca:	e406                	sd	ra,8(sp)
    800016cc:	e022                	sd	s0,0(sp)
    800016ce:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800016d0:	4601                	li	a2,0
    800016d2:	00000097          	auipc	ra,0x0
    800016d6:	914080e7          	jalr	-1772(ra) # 80000fe6 <walk>
  if(pte == 0)
    800016da:	c901                	beqz	a0,800016ea <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800016dc:	611c                	ld	a5,0(a0)
    800016de:	9bbd                	and	a5,a5,-17
    800016e0:	e11c                	sd	a5,0(a0)
}
    800016e2:	60a2                	ld	ra,8(sp)
    800016e4:	6402                	ld	s0,0(sp)
    800016e6:	0141                	add	sp,sp,16
    800016e8:	8082                	ret
    panic("uvmclear");
    800016ea:	00007517          	auipc	a0,0x7
    800016ee:	ace50513          	add	a0,a0,-1330 # 800081b8 <digits+0x178>
    800016f2:	fffff097          	auipc	ra,0xfffff
    800016f6:	e50080e7          	jalr	-432(ra) # 80000542 <panic>

00000000800016fa <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016fa:	c6bd                	beqz	a3,80001768 <copyout+0x6e>
{
    800016fc:	715d                	add	sp,sp,-80
    800016fe:	e486                	sd	ra,72(sp)
    80001700:	e0a2                	sd	s0,64(sp)
    80001702:	fc26                	sd	s1,56(sp)
    80001704:	f84a                	sd	s2,48(sp)
    80001706:	f44e                	sd	s3,40(sp)
    80001708:	f052                	sd	s4,32(sp)
    8000170a:	ec56                	sd	s5,24(sp)
    8000170c:	e85a                	sd	s6,16(sp)
    8000170e:	e45e                	sd	s7,8(sp)
    80001710:	e062                	sd	s8,0(sp)
    80001712:	0880                	add	s0,sp,80
    80001714:	8b2a                	mv	s6,a0
    80001716:	8c2e                	mv	s8,a1
    80001718:	8a32                	mv	s4,a2
    8000171a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000171c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    8000171e:	6a85                	lui	s5,0x1
    80001720:	a015                	j	80001744 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001722:	9562                	add	a0,a0,s8
    80001724:	0004861b          	sext.w	a2,s1
    80001728:	85d2                	mv	a1,s4
    8000172a:	41250533          	sub	a0,a0,s2
    8000172e:	fffff097          	auipc	ra,0xfffff
    80001732:	626080e7          	jalr	1574(ra) # 80000d54 <memmove>

    len -= n;
    80001736:	409989b3          	sub	s3,s3,s1
    src += n;
    8000173a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    8000173c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001740:	02098263          	beqz	s3,80001764 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001744:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001748:	85ca                	mv	a1,s2
    8000174a:	855a                	mv	a0,s6
    8000174c:	00000097          	auipc	ra,0x0
    80001750:	940080e7          	jalr	-1728(ra) # 8000108c <walkaddr>
    if(pa0 == 0)
    80001754:	cd01                	beqz	a0,8000176c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001756:	418904b3          	sub	s1,s2,s8
    8000175a:	94d6                	add	s1,s1,s5
    8000175c:	fc99f3e3          	bgeu	s3,s1,80001722 <copyout+0x28>
    80001760:	84ce                	mv	s1,s3
    80001762:	b7c1                	j	80001722 <copyout+0x28>
  }
  return 0;
    80001764:	4501                	li	a0,0
    80001766:	a021                	j	8000176e <copyout+0x74>
    80001768:	4501                	li	a0,0
}
    8000176a:	8082                	ret
      return -1;
    8000176c:	557d                	li	a0,-1
}
    8000176e:	60a6                	ld	ra,72(sp)
    80001770:	6406                	ld	s0,64(sp)
    80001772:	74e2                	ld	s1,56(sp)
    80001774:	7942                	ld	s2,48(sp)
    80001776:	79a2                	ld	s3,40(sp)
    80001778:	7a02                	ld	s4,32(sp)
    8000177a:	6ae2                	ld	s5,24(sp)
    8000177c:	6b42                	ld	s6,16(sp)
    8000177e:	6ba2                	ld	s7,8(sp)
    80001780:	6c02                	ld	s8,0(sp)
    80001782:	6161                	add	sp,sp,80
    80001784:	8082                	ret

0000000080001786 <copyin>:
// Copy from user to kernel.
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
    80001786:	1141                	add	sp,sp,-16
    80001788:	e406                	sd	ra,8(sp)
    8000178a:	e022                	sd	s0,0(sp)
    8000178c:	0800                	add	s0,sp,16
  return copyin_new(pagetable, dst, srcva, len);
    8000178e:	00005097          	auipc	ra,0x5
    80001792:	dca080e7          	jalr	-566(ra) # 80006558 <copyin_new>
}
    80001796:	60a2                	ld	ra,8(sp)
    80001798:	6402                	ld	s0,0(sp)
    8000179a:	0141                	add	sp,sp,16
    8000179c:	8082                	ret

000000008000179e <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    8000179e:	1141                	add	sp,sp,-16
    800017a0:	e406                	sd	ra,8(sp)
    800017a2:	e022                	sd	s0,0(sp)
    800017a4:	0800                	add	s0,sp,16
  return copyinstr_new(pagetable, dst, srcva, max);
    800017a6:	00005097          	auipc	ra,0x5
    800017aa:	e1a080e7          	jalr	-486(ra) # 800065c0 <copyinstr_new>
}
    800017ae:	60a2                	ld	ra,8(sp)
    800017b0:	6402                	ld	s0,0(sp)
    800017b2:	0141                	add	sp,sp,16
    800017b4:	8082                	ret

00000000800017b6 <vmprint_level>:
void
vmprint_level(pagetable_t pagetable, uint64 level)
{
    800017b6:	711d                	add	sp,sp,-96
    800017b8:	ec86                	sd	ra,88(sp)
    800017ba:	e8a2                	sd	s0,80(sp)
    800017bc:	e4a6                	sd	s1,72(sp)
    800017be:	e0ca                	sd	s2,64(sp)
    800017c0:	fc4e                	sd	s3,56(sp)
    800017c2:	f852                	sd	s4,48(sp)
    800017c4:	f456                	sd	s5,40(sp)
    800017c6:	f05a                	sd	s6,32(sp)
    800017c8:	ec5e                	sd	s7,24(sp)
    800017ca:	e862                	sd	s8,16(sp)
    800017cc:	e466                	sd	s9,8(sp)
    800017ce:	e06a                	sd	s10,0(sp)
    800017d0:	1080                	add	s0,sp,96
    800017d2:	89ae                	mv	s3,a1
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800017d4:	8baa                	mv	s7,a0
    800017d6:	4a01                	li	s4,0
    pte_t pte = pagetable[i];
    uint64 child = PTE2PA(pte);
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800017d8:	4c85                	li	s9,1
      vmprint_level((pagetable_t)child, level + 1);
    } else if(pte & PTE_V){
      for(int j = 0; j < level; j++) {
        printf(".. ");
      }
      printf("..%d: pte %p pa %p\n", i, pte, child);
    800017da:	00007d17          	auipc	s10,0x7
    800017de:	9f6d0d13          	add	s10,s10,-1546 # 800081d0 <digits+0x190>
        printf(".. ");
    800017e2:	00007b17          	auipc	s6,0x7
    800017e6:	9e6b0b13          	add	s6,s6,-1562 # 800081c8 <digits+0x188>
  for(int i = 0; i < 512; i++){
    800017ea:	20000c13          	li	s8,512
    800017ee:	a899                	j	80001844 <vmprint_level+0x8e>
      for(int j = 0; j < level; j++) {
    800017f0:	00098b63          	beqz	s3,80001806 <vmprint_level+0x50>
    800017f4:	4481                	li	s1,0
        printf(".. ");
    800017f6:	855a                	mv	a0,s6
    800017f8:	fffff097          	auipc	ra,0xfffff
    800017fc:	d94080e7          	jalr	-620(ra) # 8000058c <printf>
      for(int j = 0; j < level; j++) {
    80001800:	0485                	add	s1,s1,1
    80001802:	ff349ae3          	bne	s1,s3,800017f6 <vmprint_level+0x40>
      printf("..%d: pte %p pa %p\n", i, pte, child);
    80001806:	86d6                	mv	a3,s5
    80001808:	864a                	mv	a2,s2
    8000180a:	85d2                	mv	a1,s4
    8000180c:	00007517          	auipc	a0,0x7
    80001810:	9c450513          	add	a0,a0,-1596 # 800081d0 <digits+0x190>
    80001814:	fffff097          	auipc	ra,0xfffff
    80001818:	d78080e7          	jalr	-648(ra) # 8000058c <printf>
      vmprint_level((pagetable_t)child, level + 1);
    8000181c:	00198593          	add	a1,s3,1 # 1001 <_entry-0x7fffefff>
    80001820:	8556                	mv	a0,s5
    80001822:	00000097          	auipc	ra,0x0
    80001826:	f94080e7          	jalr	-108(ra) # 800017b6 <vmprint_level>
    8000182a:	a809                	j	8000183c <vmprint_level+0x86>
      printf("..%d: pte %p pa %p\n", i, pte, child);
    8000182c:	86d6                	mv	a3,s5
    8000182e:	864a                	mv	a2,s2
    80001830:	85d2                	mv	a1,s4
    80001832:	856a                	mv	a0,s10
    80001834:	fffff097          	auipc	ra,0xfffff
    80001838:	d58080e7          	jalr	-680(ra) # 8000058c <printf>
  for(int i = 0; i < 512; i++){
    8000183c:	2a05                	addw	s4,s4,1
    8000183e:	0ba1                	add	s7,s7,8 # fffffffffffff008 <end+0xffffffff7ffd7fe8>
    80001840:	038a0a63          	beq	s4,s8,80001874 <vmprint_level+0xbe>
    pte_t pte = pagetable[i];
    80001844:	000bb903          	ld	s2,0(s7)
    uint64 child = PTE2PA(pte);
    80001848:	00a95a93          	srl	s5,s2,0xa
    8000184c:	0ab2                	sll	s5,s5,0xc
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000184e:	00f97793          	and	a5,s2,15
    80001852:	f9978fe3          	beq	a5,s9,800017f0 <vmprint_level+0x3a>
    } else if(pte & PTE_V){
    80001856:	00197793          	and	a5,s2,1
    8000185a:	d3ed                	beqz	a5,8000183c <vmprint_level+0x86>
      for(int j = 0; j < level; j++) {
    8000185c:	fc0988e3          	beqz	s3,8000182c <vmprint_level+0x76>
    80001860:	4481                	li	s1,0
        printf(".. ");
    80001862:	855a                	mv	a0,s6
    80001864:	fffff097          	auipc	ra,0xfffff
    80001868:	d28080e7          	jalr	-728(ra) # 8000058c <printf>
      for(int j = 0; j < level; j++) {
    8000186c:	0485                	add	s1,s1,1
    8000186e:	ff349ae3          	bne	s1,s3,80001862 <vmprint_level+0xac>
    80001872:	bf6d                	j	8000182c <vmprint_level+0x76>
    }
  }
}
    80001874:	60e6                	ld	ra,88(sp)
    80001876:	6446                	ld	s0,80(sp)
    80001878:	64a6                	ld	s1,72(sp)
    8000187a:	6906                	ld	s2,64(sp)
    8000187c:	79e2                	ld	s3,56(sp)
    8000187e:	7a42                	ld	s4,48(sp)
    80001880:	7aa2                	ld	s5,40(sp)
    80001882:	7b02                	ld	s6,32(sp)
    80001884:	6be2                	ld	s7,24(sp)
    80001886:	6c42                	ld	s8,16(sp)
    80001888:	6ca2                	ld	s9,8(sp)
    8000188a:	6d02                	ld	s10,0(sp)
    8000188c:	6125                	add	sp,sp,96
    8000188e:	8082                	ret

0000000080001890 <vmprint>:
 
 
void
vmprint(pagetable_t pagetable) {
    80001890:	1101                	add	sp,sp,-32
    80001892:	ec06                	sd	ra,24(sp)
    80001894:	e822                	sd	s0,16(sp)
    80001896:	e426                	sd	s1,8(sp)
    80001898:	1000                	add	s0,sp,32
    8000189a:	84aa                	mv	s1,a0
  printf("page table %p\n", pagetable);
    8000189c:	85aa                	mv	a1,a0
    8000189e:	00007517          	auipc	a0,0x7
    800018a2:	94a50513          	add	a0,a0,-1718 # 800081e8 <digits+0x1a8>
    800018a6:	fffff097          	auipc	ra,0xfffff
    800018aa:	ce6080e7          	jalr	-794(ra) # 8000058c <printf>
  vmprint_level(pagetable,(uint64) 0);
    800018ae:	4581                	li	a1,0
    800018b0:	8526                	mv	a0,s1
    800018b2:	00000097          	auipc	ra,0x0
    800018b6:	f04080e7          	jalr	-252(ra) # 800017b6 <vmprint_level>
}
    800018ba:	60e2                	ld	ra,24(sp)
    800018bc:	6442                	ld	s0,16(sp)
    800018be:	64a2                	ld	s1,8(sp)
    800018c0:	6105                	add	sp,sp,32
    800018c2:	8082                	ret

00000000800018c4 <uvmmap>:
void
uvmmap(pagetable_t pgt,uint64 va, uint64 pa, uint64 sz, int perm)
{
    800018c4:	1141                	add	sp,sp,-16
    800018c6:	e406                	sd	ra,8(sp)
    800018c8:	e022                	sd	s0,0(sp)
    800018ca:	0800                	add	s0,sp,16
    800018cc:	87b6                	mv	a5,a3
  if(mappages(pgt, va, sz, pa, perm) != 0)
    800018ce:	86b2                	mv	a3,a2
    800018d0:	863e                	mv	a2,a5
    800018d2:	00000097          	auipc	ra,0x0
    800018d6:	862080e7          	jalr	-1950(ra) # 80001134 <mappages>
    800018da:	e509                	bnez	a0,800018e4 <uvmmap+0x20>
    panic("uvmmap");
}
    800018dc:	60a2                	ld	ra,8(sp)
    800018de:	6402                	ld	s0,0(sp)
    800018e0:	0141                	add	sp,sp,16
    800018e2:	8082                	ret
    panic("uvmmap");
    800018e4:	00007517          	auipc	a0,0x7
    800018e8:	91450513          	add	a0,a0,-1772 # 800081f8 <digits+0x1b8>
    800018ec:	fffff097          	auipc	ra,0xfffff
    800018f0:	c56080e7          	jalr	-938(ra) # 80000542 <panic>

00000000800018f4 <kvminit0>:
pagetable_t
kvminit0()
{
    800018f4:	1101                	add	sp,sp,-32
    800018f6:	ec06                	sd	ra,24(sp)
    800018f8:	e822                	sd	s0,16(sp)
    800018fa:	e426                	sd	s1,8(sp)
    800018fc:	e04a                	sd	s2,0(sp)
    800018fe:	1000                	add	s0,sp,32
  pagetable_t kpt;
  kpt = (pagetable_t) kalloc();
    80001900:	fffff097          	auipc	ra,0xfffff
    80001904:	20c080e7          	jalr	524(ra) # 80000b0c <kalloc>
    80001908:	84aa                	mv	s1,a0
  memset(kpt, 0, PGSIZE);
    8000190a:	6605                	lui	a2,0x1
    8000190c:	4581                	li	a1,0
    8000190e:	fffff097          	auipc	ra,0xfffff
    80001912:	3ea080e7          	jalr	1002(ra) # 80000cf8 <memset>
  // uart registers
  uvmmap(kpt, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001916:	4719                	li	a4,6
    80001918:	6685                	lui	a3,0x1
    8000191a:	10000637          	lui	a2,0x10000
    8000191e:	100005b7          	lui	a1,0x10000
    80001922:	8526                	mv	a0,s1
    80001924:	00000097          	auipc	ra,0x0
    80001928:	fa0080e7          	jalr	-96(ra) # 800018c4 <uvmmap>
  // virtio mmio disk interface
  uvmmap(kpt, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000192c:	4719                	li	a4,6
    8000192e:	6685                	lui	a3,0x1
    80001930:	10001637          	lui	a2,0x10001
    80001934:	100015b7          	lui	a1,0x10001
    80001938:	8526                	mv	a0,s1
    8000193a:	00000097          	auipc	ra,0x0
    8000193e:	f8a080e7          	jalr	-118(ra) # 800018c4 <uvmmap>
  // CLINT
  // uvmmap(kpt, CLINT, CLINT, 0x10000, PTE_R | PTE_W);
  // PLIC
  uvmmap(kpt, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001942:	4719                	li	a4,6
    80001944:	004006b7          	lui	a3,0x400
    80001948:	0c000637          	lui	a2,0xc000
    8000194c:	0c0005b7          	lui	a1,0xc000
    80001950:	8526                	mv	a0,s1
    80001952:	00000097          	auipc	ra,0x0
    80001956:	f72080e7          	jalr	-142(ra) # 800018c4 <uvmmap>
  // map kernel text executable and read-only.
  uvmmap(kpt, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000195a:	00006917          	auipc	s2,0x6
    8000195e:	6a690913          	add	s2,s2,1702 # 80008000 <etext>
    80001962:	4729                	li	a4,10
    80001964:	80006697          	auipc	a3,0x80006
    80001968:	69c68693          	add	a3,a3,1692 # 8000 <_entry-0x7fff8000>
    8000196c:	4605                	li	a2,1
    8000196e:	067e                	sll	a2,a2,0x1f
    80001970:	85b2                	mv	a1,a2
    80001972:	8526                	mv	a0,s1
    80001974:	00000097          	auipc	ra,0x0
    80001978:	f50080e7          	jalr	-176(ra) # 800018c4 <uvmmap>
  // map kernel data and the physical RAM we'll make use of.
  uvmmap(kpt, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000197c:	4719                	li	a4,6
    8000197e:	46c5                	li	a3,17
    80001980:	06ee                	sll	a3,a3,0x1b
    80001982:	412686b3          	sub	a3,a3,s2
    80001986:	864a                	mv	a2,s2
    80001988:	85ca                	mv	a1,s2
    8000198a:	8526                	mv	a0,s1
    8000198c:	00000097          	auipc	ra,0x0
    80001990:	f38080e7          	jalr	-200(ra) # 800018c4 <uvmmap>
  // map the trampoline for trap entry/exit to
  // the highest virtual address in the kernel.
  uvmmap(kpt, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001994:	4729                	li	a4,10
    80001996:	6685                	lui	a3,0x1
    80001998:	00005617          	auipc	a2,0x5
    8000199c:	66860613          	add	a2,a2,1640 # 80007000 <_trampoline>
    800019a0:	040005b7          	lui	a1,0x4000
    800019a4:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019a6:	05b2                	sll	a1,a1,0xc
    800019a8:	8526                	mv	a0,s1
    800019aa:	00000097          	auipc	ra,0x0
    800019ae:	f1a080e7          	jalr	-230(ra) # 800018c4 <uvmmap>
  return kpt;
}
    800019b2:	8526                	mv	a0,s1
    800019b4:	60e2                	ld	ra,24(sp)
    800019b6:	6442                	ld	s0,16(sp)
    800019b8:	64a2                	ld	s1,8(sp)
    800019ba:	6902                	ld	s2,0(sp)
    800019bc:	6105                	add	sp,sp,32
    800019be:	8082                	ret

00000000800019c0 <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    800019c0:	1101                	add	sp,sp,-32
    800019c2:	ec06                	sd	ra,24(sp)
    800019c4:	e822                	sd	s0,16(sp)
    800019c6:	e426                	sd	s1,8(sp)
    800019c8:	1000                	add	s0,sp,32
    800019ca:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800019cc:	fffff097          	auipc	ra,0xfffff
    800019d0:	1b6080e7          	jalr	438(ra) # 80000b82 <holding>
    800019d4:	c909                	beqz	a0,800019e6 <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    800019d6:	749c                	ld	a5,40(s1)
    800019d8:	00978f63          	beq	a5,s1,800019f6 <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    800019dc:	60e2                	ld	ra,24(sp)
    800019de:	6442                	ld	s0,16(sp)
    800019e0:	64a2                	ld	s1,8(sp)
    800019e2:	6105                	add	sp,sp,32
    800019e4:	8082                	ret
    panic("wakeup1");
    800019e6:	00007517          	auipc	a0,0x7
    800019ea:	81a50513          	add	a0,a0,-2022 # 80008200 <digits+0x1c0>
    800019ee:	fffff097          	auipc	ra,0xfffff
    800019f2:	b54080e7          	jalr	-1196(ra) # 80000542 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    800019f6:	4c98                	lw	a4,24(s1)
    800019f8:	4785                	li	a5,1
    800019fa:	fef711e3          	bne	a4,a5,800019dc <wakeup1+0x1c>
    p->state = RUNNABLE;
    800019fe:	4789                	li	a5,2
    80001a00:	cc9c                	sw	a5,24(s1)
}
    80001a02:	bfe9                	j	800019dc <wakeup1+0x1c>

0000000080001a04 <procinit>:
{
    80001a04:	7179                	add	sp,sp,-48
    80001a06:	f406                	sd	ra,40(sp)
    80001a08:	f022                	sd	s0,32(sp)
    80001a0a:	ec26                	sd	s1,24(sp)
    80001a0c:	e84a                	sd	s2,16(sp)
    80001a0e:	e44e                	sd	s3,8(sp)
    80001a10:	1800                	add	s0,sp,48
  initlock(&pid_lock, "nextpid");
    80001a12:	00006597          	auipc	a1,0x6
    80001a16:	7f658593          	add	a1,a1,2038 # 80008208 <digits+0x1c8>
    80001a1a:	00010517          	auipc	a0,0x10
    80001a1e:	f3650513          	add	a0,a0,-202 # 80011950 <pid_lock>
    80001a22:	fffff097          	auipc	ra,0xfffff
    80001a26:	14a080e7          	jalr	330(ra) # 80000b6c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a2a:	00010497          	auipc	s1,0x10
    80001a2e:	33e48493          	add	s1,s1,830 # 80011d68 <proc>
      initlock(&p->lock, "proc");
    80001a32:	00006997          	auipc	s3,0x6
    80001a36:	7de98993          	add	s3,s3,2014 # 80008210 <digits+0x1d0>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a3a:	00016917          	auipc	s2,0x16
    80001a3e:	f2e90913          	add	s2,s2,-210 # 80017968 <tickslock>
      initlock(&p->lock, "proc");
    80001a42:	85ce                	mv	a1,s3
    80001a44:	8526                	mv	a0,s1
    80001a46:	fffff097          	auipc	ra,0xfffff
    80001a4a:	126080e7          	jalr	294(ra) # 80000b6c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a4e:	17048493          	add	s1,s1,368
    80001a52:	ff2498e3          	bne	s1,s2,80001a42 <procinit+0x3e>
}
    80001a56:	70a2                	ld	ra,40(sp)
    80001a58:	7402                	ld	s0,32(sp)
    80001a5a:	64e2                	ld	s1,24(sp)
    80001a5c:	6942                	ld	s2,16(sp)
    80001a5e:	69a2                	ld	s3,8(sp)
    80001a60:	6145                	add	sp,sp,48
    80001a62:	8082                	ret

0000000080001a64 <cpuid>:
{
    80001a64:	1141                	add	sp,sp,-16
    80001a66:	e422                	sd	s0,8(sp)
    80001a68:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a6a:	8512                	mv	a0,tp
}
    80001a6c:	2501                	sext.w	a0,a0
    80001a6e:	6422                	ld	s0,8(sp)
    80001a70:	0141                	add	sp,sp,16
    80001a72:	8082                	ret

0000000080001a74 <mycpu>:
mycpu(void) {
    80001a74:	1141                	add	sp,sp,-16
    80001a76:	e422                	sd	s0,8(sp)
    80001a78:	0800                	add	s0,sp,16
    80001a7a:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001a7c:	2781                	sext.w	a5,a5
    80001a7e:	079e                	sll	a5,a5,0x7
}
    80001a80:	00010517          	auipc	a0,0x10
    80001a84:	ee850513          	add	a0,a0,-280 # 80011968 <cpus>
    80001a88:	953e                	add	a0,a0,a5
    80001a8a:	6422                	ld	s0,8(sp)
    80001a8c:	0141                	add	sp,sp,16
    80001a8e:	8082                	ret

0000000080001a90 <myproc>:
myproc(void) {
    80001a90:	1101                	add	sp,sp,-32
    80001a92:	ec06                	sd	ra,24(sp)
    80001a94:	e822                	sd	s0,16(sp)
    80001a96:	e426                	sd	s1,8(sp)
    80001a98:	1000                	add	s0,sp,32
  push_off();
    80001a9a:	fffff097          	auipc	ra,0xfffff
    80001a9e:	116080e7          	jalr	278(ra) # 80000bb0 <push_off>
    80001aa2:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001aa4:	2781                	sext.w	a5,a5
    80001aa6:	079e                	sll	a5,a5,0x7
    80001aa8:	00010717          	auipc	a4,0x10
    80001aac:	ea870713          	add	a4,a4,-344 # 80011950 <pid_lock>
    80001ab0:	97ba                	add	a5,a5,a4
    80001ab2:	6f84                	ld	s1,24(a5)
  pop_off();
    80001ab4:	fffff097          	auipc	ra,0xfffff
    80001ab8:	19c080e7          	jalr	412(ra) # 80000c50 <pop_off>
}
    80001abc:	8526                	mv	a0,s1
    80001abe:	60e2                	ld	ra,24(sp)
    80001ac0:	6442                	ld	s0,16(sp)
    80001ac2:	64a2                	ld	s1,8(sp)
    80001ac4:	6105                	add	sp,sp,32
    80001ac6:	8082                	ret

0000000080001ac8 <forkret>:
{
    80001ac8:	1141                	add	sp,sp,-16
    80001aca:	e406                	sd	ra,8(sp)
    80001acc:	e022                	sd	s0,0(sp)
    80001ace:	0800                	add	s0,sp,16
  release(&myproc()->lock);
    80001ad0:	00000097          	auipc	ra,0x0
    80001ad4:	fc0080e7          	jalr	-64(ra) # 80001a90 <myproc>
    80001ad8:	fffff097          	auipc	ra,0xfffff
    80001adc:	1d8080e7          	jalr	472(ra) # 80000cb0 <release>
  if (first) {
    80001ae0:	00007797          	auipc	a5,0x7
    80001ae4:	db07a783          	lw	a5,-592(a5) # 80008890 <first.1>
    80001ae8:	eb89                	bnez	a5,80001afa <forkret+0x32>
  usertrapret();
    80001aea:	00001097          	auipc	ra,0x1
    80001aee:	e26080e7          	jalr	-474(ra) # 80002910 <usertrapret>
}
    80001af2:	60a2                	ld	ra,8(sp)
    80001af4:	6402                	ld	s0,0(sp)
    80001af6:	0141                	add	sp,sp,16
    80001af8:	8082                	ret
    first = 0;
    80001afa:	00007797          	auipc	a5,0x7
    80001afe:	d807ab23          	sw	zero,-618(a5) # 80008890 <first.1>
    fsinit(ROOTDEV);
    80001b02:	4505                	li	a0,1
    80001b04:	00002097          	auipc	ra,0x2
    80001b08:	bfe080e7          	jalr	-1026(ra) # 80003702 <fsinit>
    80001b0c:	bff9                	j	80001aea <forkret+0x22>

0000000080001b0e <allocpid>:
allocpid() {
    80001b0e:	1101                	add	sp,sp,-32
    80001b10:	ec06                	sd	ra,24(sp)
    80001b12:	e822                	sd	s0,16(sp)
    80001b14:	e426                	sd	s1,8(sp)
    80001b16:	e04a                	sd	s2,0(sp)
    80001b18:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    80001b1a:	00010917          	auipc	s2,0x10
    80001b1e:	e3690913          	add	s2,s2,-458 # 80011950 <pid_lock>
    80001b22:	854a                	mv	a0,s2
    80001b24:	fffff097          	auipc	ra,0xfffff
    80001b28:	0d8080e7          	jalr	216(ra) # 80000bfc <acquire>
  pid = nextpid;
    80001b2c:	00007797          	auipc	a5,0x7
    80001b30:	d6878793          	add	a5,a5,-664 # 80008894 <nextpid>
    80001b34:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001b36:	0014871b          	addw	a4,s1,1
    80001b3a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001b3c:	854a                	mv	a0,s2
    80001b3e:	fffff097          	auipc	ra,0xfffff
    80001b42:	172080e7          	jalr	370(ra) # 80000cb0 <release>
}
    80001b46:	8526                	mv	a0,s1
    80001b48:	60e2                	ld	ra,24(sp)
    80001b4a:	6442                	ld	s0,16(sp)
    80001b4c:	64a2                	ld	s1,8(sp)
    80001b4e:	6902                	ld	s2,0(sp)
    80001b50:	6105                	add	sp,sp,32
    80001b52:	8082                	ret

0000000080001b54 <proc_kernel_freepagetable>:
{
    80001b54:	7179                	add	sp,sp,-48
    80001b56:	f406                	sd	ra,40(sp)
    80001b58:	f022                	sd	s0,32(sp)
    80001b5a:	ec26                	sd	s1,24(sp)
    80001b5c:	e84a                	sd	s2,16(sp)
    80001b5e:	e44e                	sd	s3,8(sp)
    80001b60:	e052                	sd	s4,0(sp)
    80001b62:	1800                	add	s0,sp,48
    80001b64:	84aa                	mv	s1,a0
    80001b66:	89ae                	mv	s3,a1
    80001b68:	8932                	mv	s2,a2
  uvmunmap(pagetable, UART0, 1, 0);
    80001b6a:	4681                	li	a3,0
    80001b6c:	4605                	li	a2,1
    80001b6e:	100005b7          	lui	a1,0x10000
    80001b72:	fffff097          	auipc	ra,0xfffff
    80001b76:	75a080e7          	jalr	1882(ra) # 800012cc <uvmunmap>
  uvmunmap(pagetable, VIRTIO0, 1, 0);
    80001b7a:	4681                	li	a3,0
    80001b7c:	4605                	li	a2,1
    80001b7e:	100015b7          	lui	a1,0x10001
    80001b82:	8526                	mv	a0,s1
    80001b84:	fffff097          	auipc	ra,0xfffff
    80001b88:	748080e7          	jalr	1864(ra) # 800012cc <uvmunmap>
  uvmunmap(pagetable, PLIC, 0x400000/PGSIZE, 0);
    80001b8c:	4681                	li	a3,0
    80001b8e:	40000613          	li	a2,1024
    80001b92:	0c0005b7          	lui	a1,0xc000
    80001b96:	8526                	mv	a0,s1
    80001b98:	fffff097          	auipc	ra,0xfffff
    80001b9c:	734080e7          	jalr	1844(ra) # 800012cc <uvmunmap>
  uvmunmap(pagetable, KERNBASE, ((uint64)etext-KERNBASE)/PGSIZE, 0);
    80001ba0:	00006a17          	auipc	s4,0x6
    80001ba4:	460a0a13          	add	s4,s4,1120 # 80008000 <etext>
    80001ba8:	4681                	li	a3,0
    80001baa:	80006617          	auipc	a2,0x80006
    80001bae:	45660613          	add	a2,a2,1110 # 8000 <_entry-0x7fff8000>
    80001bb2:	8231                	srl	a2,a2,0xc
    80001bb4:	4585                	li	a1,1
    80001bb6:	05fe                	sll	a1,a1,0x1f
    80001bb8:	8526                	mv	a0,s1
    80001bba:	fffff097          	auipc	ra,0xfffff
    80001bbe:	712080e7          	jalr	1810(ra) # 800012cc <uvmunmap>
  uvmunmap(pagetable, (uint64)etext, (PHYSTOP-(uint64)etext)/PGSIZE, 0);
    80001bc2:	4645                	li	a2,17
    80001bc4:	066e                	sll	a2,a2,0x1b
    80001bc6:	41460633          	sub	a2,a2,s4
    80001bca:	4681                	li	a3,0
    80001bcc:	8231                	srl	a2,a2,0xc
    80001bce:	85d2                	mv	a1,s4
    80001bd0:	8526                	mv	a0,s1
    80001bd2:	fffff097          	auipc	ra,0xfffff
    80001bd6:	6fa080e7          	jalr	1786(ra) # 800012cc <uvmunmap>
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001bda:	4681                	li	a3,0
    80001bdc:	4605                	li	a2,1
    80001bde:	040005b7          	lui	a1,0x4000
    80001be2:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001be4:	05b2                	sll	a1,a1,0xc
    80001be6:	8526                	mv	a0,s1
    80001be8:	fffff097          	auipc	ra,0xfffff
    80001bec:	6e4080e7          	jalr	1764(ra) # 800012cc <uvmunmap>
  uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 0);
    80001bf0:	6785                	lui	a5,0x1
    80001bf2:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001bf4:	00f90633          	add	a2,s2,a5
    80001bf8:	4681                	li	a3,0
    80001bfa:	8231                	srl	a2,a2,0xc
    80001bfc:	4581                	li	a1,0
    80001bfe:	8526                	mv	a0,s1
    80001c00:	fffff097          	auipc	ra,0xfffff
    80001c04:	6cc080e7          	jalr	1740(ra) # 800012cc <uvmunmap>
  uvmfree0(pagetable, kstack, 1);
    80001c08:	4605                	li	a2,1
    80001c0a:	85ce                	mv	a1,s3
    80001c0c:	8526                	mv	a0,s1
    80001c0e:	00000097          	auipc	ra,0x0
    80001c12:	9ba080e7          	jalr	-1606(ra) # 800015c8 <uvmfree0>
}
    80001c16:	70a2                	ld	ra,40(sp)
    80001c18:	7402                	ld	s0,32(sp)
    80001c1a:	64e2                	ld	s1,24(sp)
    80001c1c:	6942                	ld	s2,16(sp)
    80001c1e:	69a2                	ld	s3,8(sp)
    80001c20:	6a02                	ld	s4,0(sp)
    80001c22:	6145                	add	sp,sp,48
    80001c24:	8082                	ret

0000000080001c26 <proc_pagetable>:
{
    80001c26:	1101                	add	sp,sp,-32
    80001c28:	ec06                	sd	ra,24(sp)
    80001c2a:	e822                	sd	s0,16(sp)
    80001c2c:	e426                	sd	s1,8(sp)
    80001c2e:	e04a                	sd	s2,0(sp)
    80001c30:	1000                	add	s0,sp,32
    80001c32:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001c34:	fffff097          	auipc	ra,0xfffff
    80001c38:	75c080e7          	jalr	1884(ra) # 80001390 <uvmcreate>
    80001c3c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001c3e:	c121                	beqz	a0,80001c7e <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001c40:	4729                	li	a4,10
    80001c42:	00005697          	auipc	a3,0x5
    80001c46:	3be68693          	add	a3,a3,958 # 80007000 <_trampoline>
    80001c4a:	6605                	lui	a2,0x1
    80001c4c:	040005b7          	lui	a1,0x4000
    80001c50:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c52:	05b2                	sll	a1,a1,0xc
    80001c54:	fffff097          	auipc	ra,0xfffff
    80001c58:	4e0080e7          	jalr	1248(ra) # 80001134 <mappages>
    80001c5c:	02054863          	bltz	a0,80001c8c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001c60:	4719                	li	a4,6
    80001c62:	06093683          	ld	a3,96(s2)
    80001c66:	6605                	lui	a2,0x1
    80001c68:	020005b7          	lui	a1,0x2000
    80001c6c:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001c6e:	05b6                	sll	a1,a1,0xd
    80001c70:	8526                	mv	a0,s1
    80001c72:	fffff097          	auipc	ra,0xfffff
    80001c76:	4c2080e7          	jalr	1218(ra) # 80001134 <mappages>
    80001c7a:	02054163          	bltz	a0,80001c9c <proc_pagetable+0x76>
}
    80001c7e:	8526                	mv	a0,s1
    80001c80:	60e2                	ld	ra,24(sp)
    80001c82:	6442                	ld	s0,16(sp)
    80001c84:	64a2                	ld	s1,8(sp)
    80001c86:	6902                	ld	s2,0(sp)
    80001c88:	6105                	add	sp,sp,32
    80001c8a:	8082                	ret
    uvmfree(pagetable, 0);
    80001c8c:	4581                	li	a1,0
    80001c8e:	8526                	mv	a0,s1
    80001c90:	00000097          	auipc	ra,0x0
    80001c94:	8fe080e7          	jalr	-1794(ra) # 8000158e <uvmfree>
    return 0;
    80001c98:	4481                	li	s1,0
    80001c9a:	b7d5                	j	80001c7e <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c9c:	4681                	li	a3,0
    80001c9e:	4605                	li	a2,1
    80001ca0:	040005b7          	lui	a1,0x4000
    80001ca4:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ca6:	05b2                	sll	a1,a1,0xc
    80001ca8:	8526                	mv	a0,s1
    80001caa:	fffff097          	auipc	ra,0xfffff
    80001cae:	622080e7          	jalr	1570(ra) # 800012cc <uvmunmap>
    uvmfree(pagetable, 0);
    80001cb2:	4581                	li	a1,0
    80001cb4:	8526                	mv	a0,s1
    80001cb6:	00000097          	auipc	ra,0x0
    80001cba:	8d8080e7          	jalr	-1832(ra) # 8000158e <uvmfree>
    return 0;
    80001cbe:	4481                	li	s1,0
    80001cc0:	bf7d                	j	80001c7e <proc_pagetable+0x58>

0000000080001cc2 <proc_freepagetable>:
{
    80001cc2:	1101                	add	sp,sp,-32
    80001cc4:	ec06                	sd	ra,24(sp)
    80001cc6:	e822                	sd	s0,16(sp)
    80001cc8:	e426                	sd	s1,8(sp)
    80001cca:	e04a                	sd	s2,0(sp)
    80001ccc:	1000                	add	s0,sp,32
    80001cce:	84aa                	mv	s1,a0
    80001cd0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001cd2:	4681                	li	a3,0
    80001cd4:	4605                	li	a2,1
    80001cd6:	040005b7          	lui	a1,0x4000
    80001cda:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001cdc:	05b2                	sll	a1,a1,0xc
    80001cde:	fffff097          	auipc	ra,0xfffff
    80001ce2:	5ee080e7          	jalr	1518(ra) # 800012cc <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001ce6:	4681                	li	a3,0
    80001ce8:	4605                	li	a2,1
    80001cea:	020005b7          	lui	a1,0x2000
    80001cee:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001cf0:	05b6                	sll	a1,a1,0xd
    80001cf2:	8526                	mv	a0,s1
    80001cf4:	fffff097          	auipc	ra,0xfffff
    80001cf8:	5d8080e7          	jalr	1496(ra) # 800012cc <uvmunmap>
  uvmfree(pagetable, sz);
    80001cfc:	85ca                	mv	a1,s2
    80001cfe:	8526                	mv	a0,s1
    80001d00:	00000097          	auipc	ra,0x0
    80001d04:	88e080e7          	jalr	-1906(ra) # 8000158e <uvmfree>
}
    80001d08:	60e2                	ld	ra,24(sp)
    80001d0a:	6442                	ld	s0,16(sp)
    80001d0c:	64a2                	ld	s1,8(sp)
    80001d0e:	6902                	ld	s2,0(sp)
    80001d10:	6105                	add	sp,sp,32
    80001d12:	8082                	ret

0000000080001d14 <freeproc>:
{
    80001d14:	1101                	add	sp,sp,-32
    80001d16:	ec06                	sd	ra,24(sp)
    80001d18:	e822                	sd	s0,16(sp)
    80001d1a:	e426                	sd	s1,8(sp)
    80001d1c:	1000                	add	s0,sp,32
    80001d1e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001d20:	7128                	ld	a0,96(a0)
    80001d22:	c509                	beqz	a0,80001d2c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001d24:	fffff097          	auipc	ra,0xfffff
    80001d28:	cea080e7          	jalr	-790(ra) # 80000a0e <kfree>
  p->trapframe = 0;
    80001d2c:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001d30:	68a8                	ld	a0,80(s1)
    80001d32:	c511                	beqz	a0,80001d3e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001d34:	64ac                	ld	a1,72(s1)
    80001d36:	00000097          	auipc	ra,0x0
    80001d3a:	f8c080e7          	jalr	-116(ra) # 80001cc2 <proc_freepagetable>
  if(p->kernel_pagetable)
    80001d3e:	6ca8                	ld	a0,88(s1)
    80001d40:	c519                	beqz	a0,80001d4e <freeproc+0x3a>
    proc_kernel_freepagetable(p->kernel_pagetable, p->kstack, p->sz);
    80001d42:	64b0                	ld	a2,72(s1)
    80001d44:	60ac                	ld	a1,64(s1)
    80001d46:	00000097          	auipc	ra,0x0
    80001d4a:	e0e080e7          	jalr	-498(ra) # 80001b54 <proc_kernel_freepagetable>
  p->pagetable = 0;
    80001d4e:	0404b823          	sd	zero,80(s1)
  p->kernel_pagetable = 0;
    80001d52:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001d56:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001d5a:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001d5e:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001d62:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001d66:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001d6a:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001d6e:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001d72:	0004ac23          	sw	zero,24(s1)
}
    80001d76:	60e2                	ld	ra,24(sp)
    80001d78:	6442                	ld	s0,16(sp)
    80001d7a:	64a2                	ld	s1,8(sp)
    80001d7c:	6105                	add	sp,sp,32
    80001d7e:	8082                	ret

0000000080001d80 <allocproc>:
{
    80001d80:	1101                	add	sp,sp,-32
    80001d82:	ec06                	sd	ra,24(sp)
    80001d84:	e822                	sd	s0,16(sp)
    80001d86:	e426                	sd	s1,8(sp)
    80001d88:	e04a                	sd	s2,0(sp)
    80001d8a:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d8c:	00010497          	auipc	s1,0x10
    80001d90:	fdc48493          	add	s1,s1,-36 # 80011d68 <proc>
    80001d94:	00016917          	auipc	s2,0x16
    80001d98:	bd490913          	add	s2,s2,-1068 # 80017968 <tickslock>
    acquire(&p->lock);
    80001d9c:	8526                	mv	a0,s1
    80001d9e:	fffff097          	auipc	ra,0xfffff
    80001da2:	e5e080e7          	jalr	-418(ra) # 80000bfc <acquire>
    if(p->state == UNUSED) {
    80001da6:	4c9c                	lw	a5,24(s1)
    80001da8:	cf81                	beqz	a5,80001dc0 <allocproc+0x40>
      release(&p->lock);
    80001daa:	8526                	mv	a0,s1
    80001dac:	fffff097          	auipc	ra,0xfffff
    80001db0:	f04080e7          	jalr	-252(ra) # 80000cb0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001db4:	17048493          	add	s1,s1,368
    80001db8:	ff2492e3          	bne	s1,s2,80001d9c <allocproc+0x1c>
  return 0;
    80001dbc:	4481                	li	s1,0
    80001dbe:	a065                	j	80001e66 <allocproc+0xe6>
  p->pid = allocpid();
    80001dc0:	00000097          	auipc	ra,0x0
    80001dc4:	d4e080e7          	jalr	-690(ra) # 80001b0e <allocpid>
    80001dc8:	dc88                	sw	a0,56(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001dca:	fffff097          	auipc	ra,0xfffff
    80001dce:	d42080e7          	jalr	-702(ra) # 80000b0c <kalloc>
    80001dd2:	892a                	mv	s2,a0
    80001dd4:	f0a8                	sd	a0,96(s1)
    80001dd6:	cd59                	beqz	a0,80001e74 <allocproc+0xf4>
  p->pagetable = proc_pagetable(p);
    80001dd8:	8526                	mv	a0,s1
    80001dda:	00000097          	auipc	ra,0x0
    80001dde:	e4c080e7          	jalr	-436(ra) # 80001c26 <proc_pagetable>
    80001de2:	892a                	mv	s2,a0
    80001de4:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001de6:	cd51                	beqz	a0,80001e82 <allocproc+0x102>
   p->kernel_pagetable = kvminit0();
    80001de8:	00000097          	auipc	ra,0x0
    80001dec:	b0c080e7          	jalr	-1268(ra) # 800018f4 <kvminit0>
    80001df0:	892a                	mv	s2,a0
    80001df2:	eca8                	sd	a0,88(s1)
   if(p->kernel_pagetable == 0){
    80001df4:	c15d                	beqz	a0,80001e9a <allocproc+0x11a>
   char *pa = kalloc();
    80001df6:	fffff097          	auipc	ra,0xfffff
    80001dfa:	d16080e7          	jalr	-746(ra) # 80000b0c <kalloc>
    80001dfe:	862a                	mv	a2,a0
   if(pa == 0)
    80001e00:	c94d                	beqz	a0,80001eb2 <allocproc+0x132>
   uint64 va = KSTACK((int) (p - proc));
    80001e02:	00010797          	auipc	a5,0x10
    80001e06:	f6678793          	add	a5,a5,-154 # 80011d68 <proc>
    80001e0a:	40f487b3          	sub	a5,s1,a5
    80001e0e:	8791                	sra	a5,a5,0x4
    80001e10:	00006717          	auipc	a4,0x6
    80001e14:	1f073703          	ld	a4,496(a4) # 80008000 <etext>
    80001e18:	02e787b3          	mul	a5,a5,a4
    80001e1c:	2785                	addw	a5,a5,1
    80001e1e:	00d7979b          	sllw	a5,a5,0xd
    80001e22:	04000937          	lui	s2,0x4000
    80001e26:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001e28:	0932                	sll	s2,s2,0xc
    80001e2a:	40f90933          	sub	s2,s2,a5
   uvmmap(p->kernel_pagetable, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001e2e:	4719                	li	a4,6
    80001e30:	6685                	lui	a3,0x1
    80001e32:	85ca                	mv	a1,s2
    80001e34:	6ca8                	ld	a0,88(s1)
    80001e36:	00000097          	auipc	ra,0x0
    80001e3a:	a8e080e7          	jalr	-1394(ra) # 800018c4 <uvmmap>
   p->kstack = va;
    80001e3e:	0524b023          	sd	s2,64(s1)
  memset(&p->context, 0, sizeof(p->context));
    80001e42:	07000613          	li	a2,112
    80001e46:	4581                	li	a1,0
    80001e48:	06848513          	add	a0,s1,104
    80001e4c:	fffff097          	auipc	ra,0xfffff
    80001e50:	eac080e7          	jalr	-340(ra) # 80000cf8 <memset>
  p->context.ra = (uint64)forkret;
    80001e54:	00000797          	auipc	a5,0x0
    80001e58:	c7478793          	add	a5,a5,-908 # 80001ac8 <forkret>
    80001e5c:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001e5e:	60bc                	ld	a5,64(s1)
    80001e60:	6705                	lui	a4,0x1
    80001e62:	97ba                	add	a5,a5,a4
    80001e64:	f8bc                	sd	a5,112(s1)
}
    80001e66:	8526                	mv	a0,s1
    80001e68:	60e2                	ld	ra,24(sp)
    80001e6a:	6442                	ld	s0,16(sp)
    80001e6c:	64a2                	ld	s1,8(sp)
    80001e6e:	6902                	ld	s2,0(sp)
    80001e70:	6105                	add	sp,sp,32
    80001e72:	8082                	ret
    release(&p->lock);
    80001e74:	8526                	mv	a0,s1
    80001e76:	fffff097          	auipc	ra,0xfffff
    80001e7a:	e3a080e7          	jalr	-454(ra) # 80000cb0 <release>
    return 0;
    80001e7e:	84ca                	mv	s1,s2
    80001e80:	b7dd                	j	80001e66 <allocproc+0xe6>
    freeproc(p);
    80001e82:	8526                	mv	a0,s1
    80001e84:	00000097          	auipc	ra,0x0
    80001e88:	e90080e7          	jalr	-368(ra) # 80001d14 <freeproc>
    release(&p->lock);
    80001e8c:	8526                	mv	a0,s1
    80001e8e:	fffff097          	auipc	ra,0xfffff
    80001e92:	e22080e7          	jalr	-478(ra) # 80000cb0 <release>
    return 0;
    80001e96:	84ca                	mv	s1,s2
    80001e98:	b7f9                	j	80001e66 <allocproc+0xe6>
     freeproc(p);
    80001e9a:	8526                	mv	a0,s1
    80001e9c:	00000097          	auipc	ra,0x0
    80001ea0:	e78080e7          	jalr	-392(ra) # 80001d14 <freeproc>
     release(&p->lock);
    80001ea4:	8526                	mv	a0,s1
    80001ea6:	fffff097          	auipc	ra,0xfffff
    80001eaa:	e0a080e7          	jalr	-502(ra) # 80000cb0 <release>
     return 0;
    80001eae:	84ca                	mv	s1,s2
    80001eb0:	bf5d                	j	80001e66 <allocproc+0xe6>
     panic("kalloc");
    80001eb2:	00006517          	auipc	a0,0x6
    80001eb6:	36650513          	add	a0,a0,870 # 80008218 <digits+0x1d8>
    80001eba:	ffffe097          	auipc	ra,0xffffe
    80001ebe:	688080e7          	jalr	1672(ra) # 80000542 <panic>

0000000080001ec2 <userinit>:
{
    80001ec2:	7179                	add	sp,sp,-48
    80001ec4:	f406                	sd	ra,40(sp)
    80001ec6:	f022                	sd	s0,32(sp)
    80001ec8:	ec26                	sd	s1,24(sp)
    80001eca:	e84a                	sd	s2,16(sp)
    80001ecc:	e44e                	sd	s3,8(sp)
    80001ece:	e052                	sd	s4,0(sp)
    80001ed0:	1800                	add	s0,sp,48
  p = allocproc();
    80001ed2:	00000097          	auipc	ra,0x0
    80001ed6:	eae080e7          	jalr	-338(ra) # 80001d80 <allocproc>
    80001eda:	892a                	mv	s2,a0
  initproc = p;
    80001edc:	00007797          	auipc	a5,0x7
    80001ee0:	12a7be23          	sd	a0,316(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001ee4:	03400613          	li	a2,52
    80001ee8:	00007597          	auipc	a1,0x7
    80001eec:	9b858593          	add	a1,a1,-1608 # 800088a0 <initcode>
    80001ef0:	6928                	ld	a0,80(a0)
    80001ef2:	fffff097          	auipc	ra,0xfffff
    80001ef6:	4cc080e7          	jalr	1228(ra) # 800013be <uvminit>
  p->sz = PGSIZE;
    80001efa:	6785                	lui	a5,0x1
    80001efc:	04f93423          	sd	a5,72(s2)
    80001f00:	4481                	li	s1,0
  for (int j = 0; j < p->sz; j += PGSIZE) {
    80001f02:	6a05                	lui	s4,0x1
    pte =  walk(p->pagetable, j, 0); // 遍历p的页表，得到pte
    80001f04:	4601                	li	a2,0
    80001f06:	85a6                	mv	a1,s1
    80001f08:	05093503          	ld	a0,80(s2)
    80001f0c:	fffff097          	auipc	ra,0xfffff
    80001f10:	0da080e7          	jalr	218(ra) # 80000fe6 <walk>
    80001f14:	89aa                	mv	s3,a0
    kernel_pte = walk(p->kernel_pagetable, j, 1); // 遍历kernel页表，如果没有该页，则分配一页
    80001f16:	4605                	li	a2,1
    80001f18:	85a6                	mv	a1,s1
    80001f1a:	05893503          	ld	a0,88(s2)
    80001f1e:	fffff097          	auipc	ra,0xfffff
    80001f22:	0c8080e7          	jalr	200(ra) # 80000fe6 <walk>
    *kernel_pte = (*pte) & ~PTE_U; // 内核必须设置~PTE_U, 不然内核无法使用
    80001f26:	0009b783          	ld	a5,0(s3)
    80001f2a:	9bbd                	and	a5,a5,-17
    80001f2c:	e11c                	sd	a5,0(a0)
  for (int j = 0; j < p->sz; j += PGSIZE) {
    80001f2e:	94d2                	add	s1,s1,s4
    80001f30:	04893783          	ld	a5,72(s2)
    80001f34:	fcf4e8e3          	bltu	s1,a5,80001f04 <userinit+0x42>
  p->trapframe->epc = 0;      // user program counter
    80001f38:	06093783          	ld	a5,96(s2)
    80001f3c:	0007bc23          	sd	zero,24(a5) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001f40:	06093783          	ld	a5,96(s2)
    80001f44:	6705                	lui	a4,0x1
    80001f46:	fb98                	sd	a4,48(a5)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001f48:	4641                	li	a2,16
    80001f4a:	00006597          	auipc	a1,0x6
    80001f4e:	2d658593          	add	a1,a1,726 # 80008220 <digits+0x1e0>
    80001f52:	16090513          	add	a0,s2,352
    80001f56:	fffff097          	auipc	ra,0xfffff
    80001f5a:	ef2080e7          	jalr	-270(ra) # 80000e48 <safestrcpy>
  p->cwd = namei("/");
    80001f5e:	00006517          	auipc	a0,0x6
    80001f62:	2d250513          	add	a0,a0,722 # 80008230 <digits+0x1f0>
    80001f66:	00002097          	auipc	ra,0x2
    80001f6a:	1c0080e7          	jalr	448(ra) # 80004126 <namei>
    80001f6e:	14a93c23          	sd	a0,344(s2)
  p->state = RUNNABLE;
    80001f72:	4789                	li	a5,2
    80001f74:	00f92c23          	sw	a5,24(s2)
  release(&p->lock);
    80001f78:	854a                	mv	a0,s2
    80001f7a:	fffff097          	auipc	ra,0xfffff
    80001f7e:	d36080e7          	jalr	-714(ra) # 80000cb0 <release>
}
    80001f82:	70a2                	ld	ra,40(sp)
    80001f84:	7402                	ld	s0,32(sp)
    80001f86:	64e2                	ld	s1,24(sp)
    80001f88:	6942                	ld	s2,16(sp)
    80001f8a:	69a2                	ld	s3,8(sp)
    80001f8c:	6a02                	ld	s4,0(sp)
    80001f8e:	6145                	add	sp,sp,48
    80001f90:	8082                	ret

0000000080001f92 <growproc>:
{
    80001f92:	1101                	add	sp,sp,-32
    80001f94:	ec06                	sd	ra,24(sp)
    80001f96:	e822                	sd	s0,16(sp)
    80001f98:	e426                	sd	s1,8(sp)
    80001f9a:	e04a                	sd	s2,0(sp)
    80001f9c:	1000                	add	s0,sp,32
    80001f9e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fa0:	00000097          	auipc	ra,0x0
    80001fa4:	af0080e7          	jalr	-1296(ra) # 80001a90 <myproc>
    80001fa8:	892a                	mv	s2,a0
  sz = p->sz;
    80001faa:	652c                	ld	a1,72(a0)
    80001fac:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001fb0:	00904f63          	bgtz	s1,80001fce <growproc+0x3c>
  } else if(n < 0){
    80001fb4:	0204cd63          	bltz	s1,80001fee <growproc+0x5c>
  p->sz = sz;
    80001fb8:	1782                	sll	a5,a5,0x20
    80001fba:	9381                	srl	a5,a5,0x20
    80001fbc:	04f93423          	sd	a5,72(s2)
  return 0;
    80001fc0:	4501                	li	a0,0
}
    80001fc2:	60e2                	ld	ra,24(sp)
    80001fc4:	6442                	ld	s0,16(sp)
    80001fc6:	64a2                	ld	s1,8(sp)
    80001fc8:	6902                	ld	s2,0(sp)
    80001fca:	6105                	add	sp,sp,32
    80001fcc:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001fce:	00f4863b          	addw	a2,s1,a5
    80001fd2:	1602                	sll	a2,a2,0x20
    80001fd4:	9201                	srl	a2,a2,0x20
    80001fd6:	1582                	sll	a1,a1,0x20
    80001fd8:	9181                	srl	a1,a1,0x20
    80001fda:	6928                	ld	a0,80(a0)
    80001fdc:	fffff097          	auipc	ra,0xfffff
    80001fe0:	49c080e7          	jalr	1180(ra) # 80001478 <uvmalloc>
    80001fe4:	0005079b          	sext.w	a5,a0
    80001fe8:	fbe1                	bnez	a5,80001fb8 <growproc+0x26>
      return -1;
    80001fea:	557d                	li	a0,-1
    80001fec:	bfd9                	j	80001fc2 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001fee:	00f4863b          	addw	a2,s1,a5
    80001ff2:	1602                	sll	a2,a2,0x20
    80001ff4:	9201                	srl	a2,a2,0x20
    80001ff6:	1582                	sll	a1,a1,0x20
    80001ff8:	9181                	srl	a1,a1,0x20
    80001ffa:	6928                	ld	a0,80(a0)
    80001ffc:	fffff097          	auipc	ra,0xfffff
    80002000:	434080e7          	jalr	1076(ra) # 80001430 <uvmdealloc>
    80002004:	0005079b          	sext.w	a5,a0
    80002008:	bf45                	j	80001fb8 <growproc+0x26>

000000008000200a <fork>:
{
    8000200a:	7139                	add	sp,sp,-64
    8000200c:	fc06                	sd	ra,56(sp)
    8000200e:	f822                	sd	s0,48(sp)
    80002010:	f426                	sd	s1,40(sp)
    80002012:	f04a                	sd	s2,32(sp)
    80002014:	ec4e                	sd	s3,24(sp)
    80002016:	e852                	sd	s4,16(sp)
    80002018:	e456                	sd	s5,8(sp)
    8000201a:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    8000201c:	00000097          	auipc	ra,0x0
    80002020:	a74080e7          	jalr	-1420(ra) # 80001a90 <myproc>
    80002024:	8a2a                	mv	s4,a0
  if((np = allocproc()) == 0){
    80002026:	00000097          	auipc	ra,0x0
    8000202a:	d5a080e7          	jalr	-678(ra) # 80001d80 <allocproc>
    8000202e:	12050163          	beqz	a0,80002150 <fork+0x146>
    80002032:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80002034:	048a3603          	ld	a2,72(s4) # 1048 <_entry-0x7fffefb8>
    80002038:	692c                	ld	a1,80(a0)
    8000203a:	050a3503          	ld	a0,80(s4)
    8000203e:	fffff097          	auipc	ra,0xfffff
    80002042:	5b8080e7          	jalr	1464(ra) # 800015f6 <uvmcopy>
    80002046:	08054763          	bltz	a0,800020d4 <fork+0xca>
  for (int j = 0; j < p->sz; j += PGSIZE) {
    8000204a:	048a3783          	ld	a5,72(s4)
    8000204e:	4481                	li	s1,0
    80002050:	6a85                	lui	s5,0x1
    80002052:	cb9d                	beqz	a5,80002088 <fork+0x7e>
    pte =  walk(np->pagetable, j, 0);
    80002054:	4601                	li	a2,0
    80002056:	85a6                	mv	a1,s1
    80002058:	0509b503          	ld	a0,80(s3)
    8000205c:	fffff097          	auipc	ra,0xfffff
    80002060:	f8a080e7          	jalr	-118(ra) # 80000fe6 <walk>
    80002064:	892a                	mv	s2,a0
    kernel_pte = walk(np->kernel_pagetable, j, 1);
    80002066:	4605                	li	a2,1
    80002068:	85a6                	mv	a1,s1
    8000206a:	0589b503          	ld	a0,88(s3)
    8000206e:	fffff097          	auipc	ra,0xfffff
    80002072:	f78080e7          	jalr	-136(ra) # 80000fe6 <walk>
    *kernel_pte = (*pte) & ~PTE_U;
    80002076:	00093783          	ld	a5,0(s2)
    8000207a:	9bbd                	and	a5,a5,-17
    8000207c:	e11c                	sd	a5,0(a0)
  for (int j = 0; j < p->sz; j += PGSIZE) {
    8000207e:	048a3783          	ld	a5,72(s4)
    80002082:	94d6                	add	s1,s1,s5
    80002084:	fcf4e8e3          	bltu	s1,a5,80002054 <fork+0x4a>
  np->sz = p->sz;
    80002088:	04f9b423          	sd	a5,72(s3)
  np->parent = p;
    8000208c:	0349b023          	sd	s4,32(s3)
  *(np->trapframe) = *(p->trapframe);
    80002090:	060a3683          	ld	a3,96(s4)
    80002094:	87b6                	mv	a5,a3
    80002096:	0609b703          	ld	a4,96(s3)
    8000209a:	12068693          	add	a3,a3,288 # 1120 <_entry-0x7fffeee0>
    8000209e:	0007b803          	ld	a6,0(a5)
    800020a2:	6788                	ld	a0,8(a5)
    800020a4:	6b8c                	ld	a1,16(a5)
    800020a6:	6f90                	ld	a2,24(a5)
    800020a8:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    800020ac:	e708                	sd	a0,8(a4)
    800020ae:	eb0c                	sd	a1,16(a4)
    800020b0:	ef10                	sd	a2,24(a4)
    800020b2:	02078793          	add	a5,a5,32
    800020b6:	02070713          	add	a4,a4,32
    800020ba:	fed792e3          	bne	a5,a3,8000209e <fork+0x94>
  np->trapframe->a0 = 0;
    800020be:	0609b783          	ld	a5,96(s3)
    800020c2:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800020c6:	0d8a0493          	add	s1,s4,216
    800020ca:	0d898913          	add	s2,s3,216
    800020ce:	158a0a93          	add	s5,s4,344
    800020d2:	a00d                	j	800020f4 <fork+0xea>
    freeproc(np);
    800020d4:	854e                	mv	a0,s3
    800020d6:	00000097          	auipc	ra,0x0
    800020da:	c3e080e7          	jalr	-962(ra) # 80001d14 <freeproc>
    release(&np->lock);
    800020de:	854e                	mv	a0,s3
    800020e0:	fffff097          	auipc	ra,0xfffff
    800020e4:	bd0080e7          	jalr	-1072(ra) # 80000cb0 <release>
    return -1;
    800020e8:	54fd                	li	s1,-1
    800020ea:	a889                	j	8000213c <fork+0x132>
  for(i = 0; i < NOFILE; i++)
    800020ec:	04a1                	add	s1,s1,8
    800020ee:	0921                	add	s2,s2,8
    800020f0:	01548b63          	beq	s1,s5,80002106 <fork+0xfc>
    if(p->ofile[i])
    800020f4:	6088                	ld	a0,0(s1)
    800020f6:	d97d                	beqz	a0,800020ec <fork+0xe2>
      np->ofile[i] = filedup(p->ofile[i]);
    800020f8:	00002097          	auipc	ra,0x2
    800020fc:	696080e7          	jalr	1686(ra) # 8000478e <filedup>
    80002100:	00a93023          	sd	a0,0(s2)
    80002104:	b7e5                	j	800020ec <fork+0xe2>
  np->cwd = idup(p->cwd);
    80002106:	158a3503          	ld	a0,344(s4)
    8000210a:	00002097          	auipc	ra,0x2
    8000210e:	82e080e7          	jalr	-2002(ra) # 80003938 <idup>
    80002112:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002116:	4641                	li	a2,16
    80002118:	160a0593          	add	a1,s4,352
    8000211c:	16098513          	add	a0,s3,352
    80002120:	fffff097          	auipc	ra,0xfffff
    80002124:	d28080e7          	jalr	-728(ra) # 80000e48 <safestrcpy>
  pid = np->pid;
    80002128:	0389a483          	lw	s1,56(s3)
  np->state = RUNNABLE;
    8000212c:	4789                	li	a5,2
    8000212e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80002132:	854e                	mv	a0,s3
    80002134:	fffff097          	auipc	ra,0xfffff
    80002138:	b7c080e7          	jalr	-1156(ra) # 80000cb0 <release>
}
    8000213c:	8526                	mv	a0,s1
    8000213e:	70e2                	ld	ra,56(sp)
    80002140:	7442                	ld	s0,48(sp)
    80002142:	74a2                	ld	s1,40(sp)
    80002144:	7902                	ld	s2,32(sp)
    80002146:	69e2                	ld	s3,24(sp)
    80002148:	6a42                	ld	s4,16(sp)
    8000214a:	6aa2                	ld	s5,8(sp)
    8000214c:	6121                	add	sp,sp,64
    8000214e:	8082                	ret
    return -1;
    80002150:	54fd                	li	s1,-1
    80002152:	b7ed                	j	8000213c <fork+0x132>

0000000080002154 <reparent>:
{
    80002154:	7179                	add	sp,sp,-48
    80002156:	f406                	sd	ra,40(sp)
    80002158:	f022                	sd	s0,32(sp)
    8000215a:	ec26                	sd	s1,24(sp)
    8000215c:	e84a                	sd	s2,16(sp)
    8000215e:	e44e                	sd	s3,8(sp)
    80002160:	e052                	sd	s4,0(sp)
    80002162:	1800                	add	s0,sp,48
    80002164:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002166:	00010497          	auipc	s1,0x10
    8000216a:	c0248493          	add	s1,s1,-1022 # 80011d68 <proc>
      pp->parent = initproc;
    8000216e:	00007a17          	auipc	s4,0x7
    80002172:	eaaa0a13          	add	s4,s4,-342 # 80009018 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002176:	00015997          	auipc	s3,0x15
    8000217a:	7f298993          	add	s3,s3,2034 # 80017968 <tickslock>
    8000217e:	a029                	j	80002188 <reparent+0x34>
    80002180:	17048493          	add	s1,s1,368
    80002184:	03348363          	beq	s1,s3,800021aa <reparent+0x56>
    if(pp->parent == p){
    80002188:	709c                	ld	a5,32(s1)
    8000218a:	ff279be3          	bne	a5,s2,80002180 <reparent+0x2c>
      acquire(&pp->lock);
    8000218e:	8526                	mv	a0,s1
    80002190:	fffff097          	auipc	ra,0xfffff
    80002194:	a6c080e7          	jalr	-1428(ra) # 80000bfc <acquire>
      pp->parent = initproc;
    80002198:	000a3783          	ld	a5,0(s4)
    8000219c:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    8000219e:	8526                	mv	a0,s1
    800021a0:	fffff097          	auipc	ra,0xfffff
    800021a4:	b10080e7          	jalr	-1264(ra) # 80000cb0 <release>
    800021a8:	bfe1                	j	80002180 <reparent+0x2c>
}
    800021aa:	70a2                	ld	ra,40(sp)
    800021ac:	7402                	ld	s0,32(sp)
    800021ae:	64e2                	ld	s1,24(sp)
    800021b0:	6942                	ld	s2,16(sp)
    800021b2:	69a2                	ld	s3,8(sp)
    800021b4:	6a02                	ld	s4,0(sp)
    800021b6:	6145                	add	sp,sp,48
    800021b8:	8082                	ret

00000000800021ba <scheduler>:
{
    800021ba:	715d                	add	sp,sp,-80
    800021bc:	e486                	sd	ra,72(sp)
    800021be:	e0a2                	sd	s0,64(sp)
    800021c0:	fc26                	sd	s1,56(sp)
    800021c2:	f84a                	sd	s2,48(sp)
    800021c4:	f44e                	sd	s3,40(sp)
    800021c6:	f052                	sd	s4,32(sp)
    800021c8:	ec56                	sd	s5,24(sp)
    800021ca:	e85a                	sd	s6,16(sp)
    800021cc:	e45e                	sd	s7,8(sp)
    800021ce:	e062                	sd	s8,0(sp)
    800021d0:	0880                	add	s0,sp,80
    800021d2:	8792                	mv	a5,tp
  int id = r_tp();
    800021d4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800021d6:	00779b13          	sll	s6,a5,0x7
    800021da:	0000f717          	auipc	a4,0xf
    800021de:	77670713          	add	a4,a4,1910 # 80011950 <pid_lock>
    800021e2:	975a                	add	a4,a4,s6
    800021e4:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    800021e8:	0000f717          	auipc	a4,0xf
    800021ec:	78870713          	add	a4,a4,1928 # 80011970 <cpus+0x8>
    800021f0:	9b3a                	add	s6,s6,a4
        c->proc = p;
    800021f2:	079e                	sll	a5,a5,0x7
    800021f4:	0000fa17          	auipc	s4,0xf
    800021f8:	75ca0a13          	add	s4,s4,1884 # 80011950 <pid_lock>
    800021fc:	9a3e                	add	s4,s4,a5
        w_satp(MAKE_SATP(p->kernel_pagetable));
    800021fe:	5bfd                	li	s7,-1
    80002200:	1bfe                	sll	s7,s7,0x3f
    for(p = proc; p < &proc[NPROC]; p++) {
    80002202:	00015997          	auipc	s3,0x15
    80002206:	76698993          	add	s3,s3,1894 # 80017968 <tickslock>
    8000220a:	a0bd                	j	80002278 <scheduler+0xbe>
      release(&p->lock);
    8000220c:	8526                	mv	a0,s1
    8000220e:	fffff097          	auipc	ra,0xfffff
    80002212:	aa2080e7          	jalr	-1374(ra) # 80000cb0 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002216:	17048493          	add	s1,s1,368
    8000221a:	05348563          	beq	s1,s3,80002264 <scheduler+0xaa>
      acquire(&p->lock);
    8000221e:	8526                	mv	a0,s1
    80002220:	fffff097          	auipc	ra,0xfffff
    80002224:	9dc080e7          	jalr	-1572(ra) # 80000bfc <acquire>
      if(p->state == RUNNABLE) {
    80002228:	4c9c                	lw	a5,24(s1)
    8000222a:	ff2791e3          	bne	a5,s2,8000220c <scheduler+0x52>
        p->state = RUNNING;
    8000222e:	0154ac23          	sw	s5,24(s1)
        c->proc = p;
    80002232:	009a3c23          	sd	s1,24(s4)
        w_satp(MAKE_SATP(p->kernel_pagetable));
    80002236:	6cbc                	ld	a5,88(s1)
    80002238:	83b1                	srl	a5,a5,0xc
    8000223a:	0177e7b3          	or	a5,a5,s7
  asm volatile("csrw satp, %0" : : "r" (x));
    8000223e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80002242:	12000073          	sfence.vma
        swtch(&c->context, &p->context);
    80002246:	06848593          	add	a1,s1,104
    8000224a:	855a                	mv	a0,s6
    8000224c:	00000097          	auipc	ra,0x0
    80002250:	61a080e7          	jalr	1562(ra) # 80002866 <swtch>
        kvminithart();
    80002254:	fffff097          	auipc	ra,0xfffff
    80002258:	d6e080e7          	jalr	-658(ra) # 80000fc2 <kvminithart>
        c->proc = 0;
    8000225c:	000a3c23          	sd	zero,24(s4)
        found = 1;
    80002260:	4c05                	li	s8,1
    80002262:	b76d                	j	8000220c <scheduler+0x52>
    if(found == 0) {
    80002264:	000c1a63          	bnez	s8,80002278 <scheduler+0xbe>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002268:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000226c:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002270:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80002274:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002278:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000227c:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002280:	10079073          	csrw	sstatus,a5
    int found = 0;
    80002284:	4c01                	li	s8,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80002286:	00010497          	auipc	s1,0x10
    8000228a:	ae248493          	add	s1,s1,-1310 # 80011d68 <proc>
      if(p->state == RUNNABLE) {
    8000228e:	4909                	li	s2,2
        p->state = RUNNING;
    80002290:	4a8d                	li	s5,3
    80002292:	b771                	j	8000221e <scheduler+0x64>

0000000080002294 <sched>:
{
    80002294:	7179                	add	sp,sp,-48
    80002296:	f406                	sd	ra,40(sp)
    80002298:	f022                	sd	s0,32(sp)
    8000229a:	ec26                	sd	s1,24(sp)
    8000229c:	e84a                	sd	s2,16(sp)
    8000229e:	e44e                	sd	s3,8(sp)
    800022a0:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    800022a2:	fffff097          	auipc	ra,0xfffff
    800022a6:	7ee080e7          	jalr	2030(ra) # 80001a90 <myproc>
    800022aa:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800022ac:	fffff097          	auipc	ra,0xfffff
    800022b0:	8d6080e7          	jalr	-1834(ra) # 80000b82 <holding>
    800022b4:	c93d                	beqz	a0,8000232a <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800022b6:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800022b8:	2781                	sext.w	a5,a5
    800022ba:	079e                	sll	a5,a5,0x7
    800022bc:	0000f717          	auipc	a4,0xf
    800022c0:	69470713          	add	a4,a4,1684 # 80011950 <pid_lock>
    800022c4:	97ba                	add	a5,a5,a4
    800022c6:	0907a703          	lw	a4,144(a5)
    800022ca:	4785                	li	a5,1
    800022cc:	06f71763          	bne	a4,a5,8000233a <sched+0xa6>
  if(p->state == RUNNING)
    800022d0:	4c98                	lw	a4,24(s1)
    800022d2:	478d                	li	a5,3
    800022d4:	06f70b63          	beq	a4,a5,8000234a <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800022d8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800022dc:	8b89                	and	a5,a5,2
  if(intr_get())
    800022de:	efb5                	bnez	a5,8000235a <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800022e0:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800022e2:	0000f917          	auipc	s2,0xf
    800022e6:	66e90913          	add	s2,s2,1646 # 80011950 <pid_lock>
    800022ea:	2781                	sext.w	a5,a5
    800022ec:	079e                	sll	a5,a5,0x7
    800022ee:	97ca                	add	a5,a5,s2
    800022f0:	0947a983          	lw	s3,148(a5)
    800022f4:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800022f6:	2781                	sext.w	a5,a5
    800022f8:	079e                	sll	a5,a5,0x7
    800022fa:	0000f597          	auipc	a1,0xf
    800022fe:	67658593          	add	a1,a1,1654 # 80011970 <cpus+0x8>
    80002302:	95be                	add	a1,a1,a5
    80002304:	06848513          	add	a0,s1,104
    80002308:	00000097          	auipc	ra,0x0
    8000230c:	55e080e7          	jalr	1374(ra) # 80002866 <swtch>
    80002310:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002312:	2781                	sext.w	a5,a5
    80002314:	079e                	sll	a5,a5,0x7
    80002316:	993e                	add	s2,s2,a5
    80002318:	09392a23          	sw	s3,148(s2)
}
    8000231c:	70a2                	ld	ra,40(sp)
    8000231e:	7402                	ld	s0,32(sp)
    80002320:	64e2                	ld	s1,24(sp)
    80002322:	6942                	ld	s2,16(sp)
    80002324:	69a2                	ld	s3,8(sp)
    80002326:	6145                	add	sp,sp,48
    80002328:	8082                	ret
    panic("sched p->lock");
    8000232a:	00006517          	auipc	a0,0x6
    8000232e:	f0e50513          	add	a0,a0,-242 # 80008238 <digits+0x1f8>
    80002332:	ffffe097          	auipc	ra,0xffffe
    80002336:	210080e7          	jalr	528(ra) # 80000542 <panic>
    panic("sched locks");
    8000233a:	00006517          	auipc	a0,0x6
    8000233e:	f0e50513          	add	a0,a0,-242 # 80008248 <digits+0x208>
    80002342:	ffffe097          	auipc	ra,0xffffe
    80002346:	200080e7          	jalr	512(ra) # 80000542 <panic>
    panic("sched running");
    8000234a:	00006517          	auipc	a0,0x6
    8000234e:	f0e50513          	add	a0,a0,-242 # 80008258 <digits+0x218>
    80002352:	ffffe097          	auipc	ra,0xffffe
    80002356:	1f0080e7          	jalr	496(ra) # 80000542 <panic>
    panic("sched interruptible");
    8000235a:	00006517          	auipc	a0,0x6
    8000235e:	f0e50513          	add	a0,a0,-242 # 80008268 <digits+0x228>
    80002362:	ffffe097          	auipc	ra,0xffffe
    80002366:	1e0080e7          	jalr	480(ra) # 80000542 <panic>

000000008000236a <exit>:
{
    8000236a:	7179                	add	sp,sp,-48
    8000236c:	f406                	sd	ra,40(sp)
    8000236e:	f022                	sd	s0,32(sp)
    80002370:	ec26                	sd	s1,24(sp)
    80002372:	e84a                	sd	s2,16(sp)
    80002374:	e44e                	sd	s3,8(sp)
    80002376:	e052                	sd	s4,0(sp)
    80002378:	1800                	add	s0,sp,48
    8000237a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000237c:	fffff097          	auipc	ra,0xfffff
    80002380:	714080e7          	jalr	1812(ra) # 80001a90 <myproc>
    80002384:	89aa                	mv	s3,a0
  if(p == initproc)
    80002386:	00007797          	auipc	a5,0x7
    8000238a:	c927b783          	ld	a5,-878(a5) # 80009018 <initproc>
    8000238e:	0d850493          	add	s1,a0,216
    80002392:	15850913          	add	s2,a0,344
    80002396:	02a79363          	bne	a5,a0,800023bc <exit+0x52>
    panic("init exiting");
    8000239a:	00006517          	auipc	a0,0x6
    8000239e:	ee650513          	add	a0,a0,-282 # 80008280 <digits+0x240>
    800023a2:	ffffe097          	auipc	ra,0xffffe
    800023a6:	1a0080e7          	jalr	416(ra) # 80000542 <panic>
      fileclose(f);
    800023aa:	00002097          	auipc	ra,0x2
    800023ae:	436080e7          	jalr	1078(ra) # 800047e0 <fileclose>
      p->ofile[fd] = 0;
    800023b2:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800023b6:	04a1                	add	s1,s1,8
    800023b8:	01248563          	beq	s1,s2,800023c2 <exit+0x58>
    if(p->ofile[fd]){
    800023bc:	6088                	ld	a0,0(s1)
    800023be:	f575                	bnez	a0,800023aa <exit+0x40>
    800023c0:	bfdd                	j	800023b6 <exit+0x4c>
  begin_op();
    800023c2:	00002097          	auipc	ra,0x2
    800023c6:	f54080e7          	jalr	-172(ra) # 80004316 <begin_op>
  iput(p->cwd);
    800023ca:	1589b503          	ld	a0,344(s3)
    800023ce:	00001097          	auipc	ra,0x1
    800023d2:	762080e7          	jalr	1890(ra) # 80003b30 <iput>
  end_op();
    800023d6:	00002097          	auipc	ra,0x2
    800023da:	fba080e7          	jalr	-70(ra) # 80004390 <end_op>
  p->cwd = 0;
    800023de:	1409bc23          	sd	zero,344(s3)
  acquire(&initproc->lock);
    800023e2:	00007497          	auipc	s1,0x7
    800023e6:	c3648493          	add	s1,s1,-970 # 80009018 <initproc>
    800023ea:	6088                	ld	a0,0(s1)
    800023ec:	fffff097          	auipc	ra,0xfffff
    800023f0:	810080e7          	jalr	-2032(ra) # 80000bfc <acquire>
  wakeup1(initproc);
    800023f4:	6088                	ld	a0,0(s1)
    800023f6:	fffff097          	auipc	ra,0xfffff
    800023fa:	5ca080e7          	jalr	1482(ra) # 800019c0 <wakeup1>
  release(&initproc->lock);
    800023fe:	6088                	ld	a0,0(s1)
    80002400:	fffff097          	auipc	ra,0xfffff
    80002404:	8b0080e7          	jalr	-1872(ra) # 80000cb0 <release>
  acquire(&p->lock);
    80002408:	854e                	mv	a0,s3
    8000240a:	ffffe097          	auipc	ra,0xffffe
    8000240e:	7f2080e7          	jalr	2034(ra) # 80000bfc <acquire>
  struct proc *original_parent = p->parent;
    80002412:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    80002416:	854e                	mv	a0,s3
    80002418:	fffff097          	auipc	ra,0xfffff
    8000241c:	898080e7          	jalr	-1896(ra) # 80000cb0 <release>
  acquire(&original_parent->lock);
    80002420:	8526                	mv	a0,s1
    80002422:	ffffe097          	auipc	ra,0xffffe
    80002426:	7da080e7          	jalr	2010(ra) # 80000bfc <acquire>
  acquire(&p->lock);
    8000242a:	854e                	mv	a0,s3
    8000242c:	ffffe097          	auipc	ra,0xffffe
    80002430:	7d0080e7          	jalr	2000(ra) # 80000bfc <acquire>
  reparent(p);
    80002434:	854e                	mv	a0,s3
    80002436:	00000097          	auipc	ra,0x0
    8000243a:	d1e080e7          	jalr	-738(ra) # 80002154 <reparent>
  wakeup1(original_parent);
    8000243e:	8526                	mv	a0,s1
    80002440:	fffff097          	auipc	ra,0xfffff
    80002444:	580080e7          	jalr	1408(ra) # 800019c0 <wakeup1>
  p->xstate = status;
    80002448:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    8000244c:	4791                	li	a5,4
    8000244e:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    80002452:	8526                	mv	a0,s1
    80002454:	fffff097          	auipc	ra,0xfffff
    80002458:	85c080e7          	jalr	-1956(ra) # 80000cb0 <release>
  sched();
    8000245c:	00000097          	auipc	ra,0x0
    80002460:	e38080e7          	jalr	-456(ra) # 80002294 <sched>
  panic("zombie exit");
    80002464:	00006517          	auipc	a0,0x6
    80002468:	e2c50513          	add	a0,a0,-468 # 80008290 <digits+0x250>
    8000246c:	ffffe097          	auipc	ra,0xffffe
    80002470:	0d6080e7          	jalr	214(ra) # 80000542 <panic>

0000000080002474 <yield>:
{
    80002474:	1101                	add	sp,sp,-32
    80002476:	ec06                	sd	ra,24(sp)
    80002478:	e822                	sd	s0,16(sp)
    8000247a:	e426                	sd	s1,8(sp)
    8000247c:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    8000247e:	fffff097          	auipc	ra,0xfffff
    80002482:	612080e7          	jalr	1554(ra) # 80001a90 <myproc>
    80002486:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002488:	ffffe097          	auipc	ra,0xffffe
    8000248c:	774080e7          	jalr	1908(ra) # 80000bfc <acquire>
  p->state = RUNNABLE;
    80002490:	4789                	li	a5,2
    80002492:	cc9c                	sw	a5,24(s1)
  sched();
    80002494:	00000097          	auipc	ra,0x0
    80002498:	e00080e7          	jalr	-512(ra) # 80002294 <sched>
  release(&p->lock);
    8000249c:	8526                	mv	a0,s1
    8000249e:	fffff097          	auipc	ra,0xfffff
    800024a2:	812080e7          	jalr	-2030(ra) # 80000cb0 <release>
}
    800024a6:	60e2                	ld	ra,24(sp)
    800024a8:	6442                	ld	s0,16(sp)
    800024aa:	64a2                	ld	s1,8(sp)
    800024ac:	6105                	add	sp,sp,32
    800024ae:	8082                	ret

00000000800024b0 <sleep>:
{
    800024b0:	7179                	add	sp,sp,-48
    800024b2:	f406                	sd	ra,40(sp)
    800024b4:	f022                	sd	s0,32(sp)
    800024b6:	ec26                	sd	s1,24(sp)
    800024b8:	e84a                	sd	s2,16(sp)
    800024ba:	e44e                	sd	s3,8(sp)
    800024bc:	1800                	add	s0,sp,48
    800024be:	89aa                	mv	s3,a0
    800024c0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800024c2:	fffff097          	auipc	ra,0xfffff
    800024c6:	5ce080e7          	jalr	1486(ra) # 80001a90 <myproc>
    800024ca:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    800024cc:	05250663          	beq	a0,s2,80002518 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    800024d0:	ffffe097          	auipc	ra,0xffffe
    800024d4:	72c080e7          	jalr	1836(ra) # 80000bfc <acquire>
    release(lk);
    800024d8:	854a                	mv	a0,s2
    800024da:	ffffe097          	auipc	ra,0xffffe
    800024de:	7d6080e7          	jalr	2006(ra) # 80000cb0 <release>
  p->chan = chan;
    800024e2:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800024e6:	4785                	li	a5,1
    800024e8:	cc9c                	sw	a5,24(s1)
  sched();
    800024ea:	00000097          	auipc	ra,0x0
    800024ee:	daa080e7          	jalr	-598(ra) # 80002294 <sched>
  p->chan = 0;
    800024f2:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    800024f6:	8526                	mv	a0,s1
    800024f8:	ffffe097          	auipc	ra,0xffffe
    800024fc:	7b8080e7          	jalr	1976(ra) # 80000cb0 <release>
    acquire(lk);
    80002500:	854a                	mv	a0,s2
    80002502:	ffffe097          	auipc	ra,0xffffe
    80002506:	6fa080e7          	jalr	1786(ra) # 80000bfc <acquire>
}
    8000250a:	70a2                	ld	ra,40(sp)
    8000250c:	7402                	ld	s0,32(sp)
    8000250e:	64e2                	ld	s1,24(sp)
    80002510:	6942                	ld	s2,16(sp)
    80002512:	69a2                	ld	s3,8(sp)
    80002514:	6145                	add	sp,sp,48
    80002516:	8082                	ret
  p->chan = chan;
    80002518:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    8000251c:	4785                	li	a5,1
    8000251e:	cd1c                	sw	a5,24(a0)
  sched();
    80002520:	00000097          	auipc	ra,0x0
    80002524:	d74080e7          	jalr	-652(ra) # 80002294 <sched>
  p->chan = 0;
    80002528:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    8000252c:	bff9                	j	8000250a <sleep+0x5a>

000000008000252e <wait>:
{
    8000252e:	715d                	add	sp,sp,-80
    80002530:	e486                	sd	ra,72(sp)
    80002532:	e0a2                	sd	s0,64(sp)
    80002534:	fc26                	sd	s1,56(sp)
    80002536:	f84a                	sd	s2,48(sp)
    80002538:	f44e                	sd	s3,40(sp)
    8000253a:	f052                	sd	s4,32(sp)
    8000253c:	ec56                	sd	s5,24(sp)
    8000253e:	e85a                	sd	s6,16(sp)
    80002540:	e45e                	sd	s7,8(sp)
    80002542:	0880                	add	s0,sp,80
    80002544:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002546:	fffff097          	auipc	ra,0xfffff
    8000254a:	54a080e7          	jalr	1354(ra) # 80001a90 <myproc>
    8000254e:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002550:	ffffe097          	auipc	ra,0xffffe
    80002554:	6ac080e7          	jalr	1708(ra) # 80000bfc <acquire>
    havekids = 0;
    80002558:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000255a:	4a11                	li	s4,4
        havekids = 1;
    8000255c:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000255e:	00015997          	auipc	s3,0x15
    80002562:	40a98993          	add	s3,s3,1034 # 80017968 <tickslock>
    80002566:	a845                	j	80002616 <wait+0xe8>
          pid = np->pid;
    80002568:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000256c:	000b0e63          	beqz	s6,80002588 <wait+0x5a>
    80002570:	4691                	li	a3,4
    80002572:	03448613          	add	a2,s1,52
    80002576:	85da                	mv	a1,s6
    80002578:	05093503          	ld	a0,80(s2)
    8000257c:	fffff097          	auipc	ra,0xfffff
    80002580:	17e080e7          	jalr	382(ra) # 800016fa <copyout>
    80002584:	02054d63          	bltz	a0,800025be <wait+0x90>
          freeproc(np);
    80002588:	8526                	mv	a0,s1
    8000258a:	fffff097          	auipc	ra,0xfffff
    8000258e:	78a080e7          	jalr	1930(ra) # 80001d14 <freeproc>
          release(&np->lock);
    80002592:	8526                	mv	a0,s1
    80002594:	ffffe097          	auipc	ra,0xffffe
    80002598:	71c080e7          	jalr	1820(ra) # 80000cb0 <release>
          release(&p->lock);
    8000259c:	854a                	mv	a0,s2
    8000259e:	ffffe097          	auipc	ra,0xffffe
    800025a2:	712080e7          	jalr	1810(ra) # 80000cb0 <release>
}
    800025a6:	854e                	mv	a0,s3
    800025a8:	60a6                	ld	ra,72(sp)
    800025aa:	6406                	ld	s0,64(sp)
    800025ac:	74e2                	ld	s1,56(sp)
    800025ae:	7942                	ld	s2,48(sp)
    800025b0:	79a2                	ld	s3,40(sp)
    800025b2:	7a02                	ld	s4,32(sp)
    800025b4:	6ae2                	ld	s5,24(sp)
    800025b6:	6b42                	ld	s6,16(sp)
    800025b8:	6ba2                	ld	s7,8(sp)
    800025ba:	6161                	add	sp,sp,80
    800025bc:	8082                	ret
            release(&np->lock);
    800025be:	8526                	mv	a0,s1
    800025c0:	ffffe097          	auipc	ra,0xffffe
    800025c4:	6f0080e7          	jalr	1776(ra) # 80000cb0 <release>
            release(&p->lock);
    800025c8:	854a                	mv	a0,s2
    800025ca:	ffffe097          	auipc	ra,0xffffe
    800025ce:	6e6080e7          	jalr	1766(ra) # 80000cb0 <release>
            return -1;
    800025d2:	59fd                	li	s3,-1
    800025d4:	bfc9                	j	800025a6 <wait+0x78>
    for(np = proc; np < &proc[NPROC]; np++){
    800025d6:	17048493          	add	s1,s1,368
    800025da:	03348463          	beq	s1,s3,80002602 <wait+0xd4>
      if(np->parent == p){
    800025de:	709c                	ld	a5,32(s1)
    800025e0:	ff279be3          	bne	a5,s2,800025d6 <wait+0xa8>
        acquire(&np->lock);
    800025e4:	8526                	mv	a0,s1
    800025e6:	ffffe097          	auipc	ra,0xffffe
    800025ea:	616080e7          	jalr	1558(ra) # 80000bfc <acquire>
        if(np->state == ZOMBIE){
    800025ee:	4c9c                	lw	a5,24(s1)
    800025f0:	f7478ce3          	beq	a5,s4,80002568 <wait+0x3a>
        release(&np->lock);
    800025f4:	8526                	mv	a0,s1
    800025f6:	ffffe097          	auipc	ra,0xffffe
    800025fa:	6ba080e7          	jalr	1722(ra) # 80000cb0 <release>
        havekids = 1;
    800025fe:	8756                	mv	a4,s5
    80002600:	bfd9                	j	800025d6 <wait+0xa8>
    if(!havekids || p->killed){
    80002602:	c305                	beqz	a4,80002622 <wait+0xf4>
    80002604:	03092783          	lw	a5,48(s2)
    80002608:	ef89                	bnez	a5,80002622 <wait+0xf4>
    sleep(p, &p->lock);  //DOC: wait-sleep
    8000260a:	85ca                	mv	a1,s2
    8000260c:	854a                	mv	a0,s2
    8000260e:	00000097          	auipc	ra,0x0
    80002612:	ea2080e7          	jalr	-350(ra) # 800024b0 <sleep>
    havekids = 0;
    80002616:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002618:	0000f497          	auipc	s1,0xf
    8000261c:	75048493          	add	s1,s1,1872 # 80011d68 <proc>
    80002620:	bf7d                	j	800025de <wait+0xb0>
      release(&p->lock);
    80002622:	854a                	mv	a0,s2
    80002624:	ffffe097          	auipc	ra,0xffffe
    80002628:	68c080e7          	jalr	1676(ra) # 80000cb0 <release>
      return -1;
    8000262c:	59fd                	li	s3,-1
    8000262e:	bfa5                	j	800025a6 <wait+0x78>

0000000080002630 <wakeup>:
{
    80002630:	7139                	add	sp,sp,-64
    80002632:	fc06                	sd	ra,56(sp)
    80002634:	f822                	sd	s0,48(sp)
    80002636:	f426                	sd	s1,40(sp)
    80002638:	f04a                	sd	s2,32(sp)
    8000263a:	ec4e                	sd	s3,24(sp)
    8000263c:	e852                	sd	s4,16(sp)
    8000263e:	e456                	sd	s5,8(sp)
    80002640:	0080                	add	s0,sp,64
    80002642:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80002644:	0000f497          	auipc	s1,0xf
    80002648:	72448493          	add	s1,s1,1828 # 80011d68 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    8000264c:	4985                	li	s3,1
      p->state = RUNNABLE;
    8000264e:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    80002650:	00015917          	auipc	s2,0x15
    80002654:	31890913          	add	s2,s2,792 # 80017968 <tickslock>
    80002658:	a811                	j	8000266c <wakeup+0x3c>
    release(&p->lock);
    8000265a:	8526                	mv	a0,s1
    8000265c:	ffffe097          	auipc	ra,0xffffe
    80002660:	654080e7          	jalr	1620(ra) # 80000cb0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002664:	17048493          	add	s1,s1,368
    80002668:	03248063          	beq	s1,s2,80002688 <wakeup+0x58>
    acquire(&p->lock);
    8000266c:	8526                	mv	a0,s1
    8000266e:	ffffe097          	auipc	ra,0xffffe
    80002672:	58e080e7          	jalr	1422(ra) # 80000bfc <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    80002676:	4c9c                	lw	a5,24(s1)
    80002678:	ff3791e3          	bne	a5,s3,8000265a <wakeup+0x2a>
    8000267c:	749c                	ld	a5,40(s1)
    8000267e:	fd479ee3          	bne	a5,s4,8000265a <wakeup+0x2a>
      p->state = RUNNABLE;
    80002682:	0154ac23          	sw	s5,24(s1)
    80002686:	bfd1                	j	8000265a <wakeup+0x2a>
}
    80002688:	70e2                	ld	ra,56(sp)
    8000268a:	7442                	ld	s0,48(sp)
    8000268c:	74a2                	ld	s1,40(sp)
    8000268e:	7902                	ld	s2,32(sp)
    80002690:	69e2                	ld	s3,24(sp)
    80002692:	6a42                	ld	s4,16(sp)
    80002694:	6aa2                	ld	s5,8(sp)
    80002696:	6121                	add	sp,sp,64
    80002698:	8082                	ret

000000008000269a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000269a:	7179                	add	sp,sp,-48
    8000269c:	f406                	sd	ra,40(sp)
    8000269e:	f022                	sd	s0,32(sp)
    800026a0:	ec26                	sd	s1,24(sp)
    800026a2:	e84a                	sd	s2,16(sp)
    800026a4:	e44e                	sd	s3,8(sp)
    800026a6:	1800                	add	s0,sp,48
    800026a8:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800026aa:	0000f497          	auipc	s1,0xf
    800026ae:	6be48493          	add	s1,s1,1726 # 80011d68 <proc>
    800026b2:	00015997          	auipc	s3,0x15
    800026b6:	2b698993          	add	s3,s3,694 # 80017968 <tickslock>
    acquire(&p->lock);
    800026ba:	8526                	mv	a0,s1
    800026bc:	ffffe097          	auipc	ra,0xffffe
    800026c0:	540080e7          	jalr	1344(ra) # 80000bfc <acquire>
    if(p->pid == pid){
    800026c4:	5c9c                	lw	a5,56(s1)
    800026c6:	01278d63          	beq	a5,s2,800026e0 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800026ca:	8526                	mv	a0,s1
    800026cc:	ffffe097          	auipc	ra,0xffffe
    800026d0:	5e4080e7          	jalr	1508(ra) # 80000cb0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800026d4:	17048493          	add	s1,s1,368
    800026d8:	ff3491e3          	bne	s1,s3,800026ba <kill+0x20>
  }
  return -1;
    800026dc:	557d                	li	a0,-1
    800026de:	a821                	j	800026f6 <kill+0x5c>
      p->killed = 1;
    800026e0:	4785                	li	a5,1
    800026e2:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    800026e4:	4c98                	lw	a4,24(s1)
    800026e6:	00f70f63          	beq	a4,a5,80002704 <kill+0x6a>
      release(&p->lock);
    800026ea:	8526                	mv	a0,s1
    800026ec:	ffffe097          	auipc	ra,0xffffe
    800026f0:	5c4080e7          	jalr	1476(ra) # 80000cb0 <release>
      return 0;
    800026f4:	4501                	li	a0,0
}
    800026f6:	70a2                	ld	ra,40(sp)
    800026f8:	7402                	ld	s0,32(sp)
    800026fa:	64e2                	ld	s1,24(sp)
    800026fc:	6942                	ld	s2,16(sp)
    800026fe:	69a2                	ld	s3,8(sp)
    80002700:	6145                	add	sp,sp,48
    80002702:	8082                	ret
        p->state = RUNNABLE;
    80002704:	4789                	li	a5,2
    80002706:	cc9c                	sw	a5,24(s1)
    80002708:	b7cd                	j	800026ea <kill+0x50>

000000008000270a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000270a:	7179                	add	sp,sp,-48
    8000270c:	f406                	sd	ra,40(sp)
    8000270e:	f022                	sd	s0,32(sp)
    80002710:	ec26                	sd	s1,24(sp)
    80002712:	e84a                	sd	s2,16(sp)
    80002714:	e44e                	sd	s3,8(sp)
    80002716:	e052                	sd	s4,0(sp)
    80002718:	1800                	add	s0,sp,48
    8000271a:	84aa                	mv	s1,a0
    8000271c:	892e                	mv	s2,a1
    8000271e:	89b2                	mv	s3,a2
    80002720:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002722:	fffff097          	auipc	ra,0xfffff
    80002726:	36e080e7          	jalr	878(ra) # 80001a90 <myproc>
  if(user_dst){
    8000272a:	c08d                	beqz	s1,8000274c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000272c:	86d2                	mv	a3,s4
    8000272e:	864e                	mv	a2,s3
    80002730:	85ca                	mv	a1,s2
    80002732:	6928                	ld	a0,80(a0)
    80002734:	fffff097          	auipc	ra,0xfffff
    80002738:	fc6080e7          	jalr	-58(ra) # 800016fa <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000273c:	70a2                	ld	ra,40(sp)
    8000273e:	7402                	ld	s0,32(sp)
    80002740:	64e2                	ld	s1,24(sp)
    80002742:	6942                	ld	s2,16(sp)
    80002744:	69a2                	ld	s3,8(sp)
    80002746:	6a02                	ld	s4,0(sp)
    80002748:	6145                	add	sp,sp,48
    8000274a:	8082                	ret
    memmove((char *)dst, src, len);
    8000274c:	000a061b          	sext.w	a2,s4
    80002750:	85ce                	mv	a1,s3
    80002752:	854a                	mv	a0,s2
    80002754:	ffffe097          	auipc	ra,0xffffe
    80002758:	600080e7          	jalr	1536(ra) # 80000d54 <memmove>
    return 0;
    8000275c:	8526                	mv	a0,s1
    8000275e:	bff9                	j	8000273c <either_copyout+0x32>

0000000080002760 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002760:	7179                	add	sp,sp,-48
    80002762:	f406                	sd	ra,40(sp)
    80002764:	f022                	sd	s0,32(sp)
    80002766:	ec26                	sd	s1,24(sp)
    80002768:	e84a                	sd	s2,16(sp)
    8000276a:	e44e                	sd	s3,8(sp)
    8000276c:	e052                	sd	s4,0(sp)
    8000276e:	1800                	add	s0,sp,48
    80002770:	892a                	mv	s2,a0
    80002772:	84ae                	mv	s1,a1
    80002774:	89b2                	mv	s3,a2
    80002776:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002778:	fffff097          	auipc	ra,0xfffff
    8000277c:	318080e7          	jalr	792(ra) # 80001a90 <myproc>
  if(user_src){
    80002780:	c08d                	beqz	s1,800027a2 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002782:	86d2                	mv	a3,s4
    80002784:	864e                	mv	a2,s3
    80002786:	85ca                	mv	a1,s2
    80002788:	6928                	ld	a0,80(a0)
    8000278a:	fffff097          	auipc	ra,0xfffff
    8000278e:	ffc080e7          	jalr	-4(ra) # 80001786 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002792:	70a2                	ld	ra,40(sp)
    80002794:	7402                	ld	s0,32(sp)
    80002796:	64e2                	ld	s1,24(sp)
    80002798:	6942                	ld	s2,16(sp)
    8000279a:	69a2                	ld	s3,8(sp)
    8000279c:	6a02                	ld	s4,0(sp)
    8000279e:	6145                	add	sp,sp,48
    800027a0:	8082                	ret
    memmove(dst, (char*)src, len);
    800027a2:	000a061b          	sext.w	a2,s4
    800027a6:	85ce                	mv	a1,s3
    800027a8:	854a                	mv	a0,s2
    800027aa:	ffffe097          	auipc	ra,0xffffe
    800027ae:	5aa080e7          	jalr	1450(ra) # 80000d54 <memmove>
    return 0;
    800027b2:	8526                	mv	a0,s1
    800027b4:	bff9                	j	80002792 <either_copyin+0x32>

00000000800027b6 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800027b6:	715d                	add	sp,sp,-80
    800027b8:	e486                	sd	ra,72(sp)
    800027ba:	e0a2                	sd	s0,64(sp)
    800027bc:	fc26                	sd	s1,56(sp)
    800027be:	f84a                	sd	s2,48(sp)
    800027c0:	f44e                	sd	s3,40(sp)
    800027c2:	f052                	sd	s4,32(sp)
    800027c4:	ec56                	sd	s5,24(sp)
    800027c6:	e85a                	sd	s6,16(sp)
    800027c8:	e45e                	sd	s7,8(sp)
    800027ca:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800027cc:	00006517          	auipc	a0,0x6
    800027d0:	8fc50513          	add	a0,a0,-1796 # 800080c8 <digits+0x88>
    800027d4:	ffffe097          	auipc	ra,0xffffe
    800027d8:	db8080e7          	jalr	-584(ra) # 8000058c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800027dc:	0000f497          	auipc	s1,0xf
    800027e0:	6ec48493          	add	s1,s1,1772 # 80011ec8 <proc+0x160>
    800027e4:	00015917          	auipc	s2,0x15
    800027e8:	2e490913          	add	s2,s2,740 # 80017ac8 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800027ec:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    800027ee:	00006997          	auipc	s3,0x6
    800027f2:	ab298993          	add	s3,s3,-1358 # 800082a0 <digits+0x260>
    printf("%d %s %s", p->pid, state, p->name);
    800027f6:	00006a97          	auipc	s5,0x6
    800027fa:	ab2a8a93          	add	s5,s5,-1358 # 800082a8 <digits+0x268>
    printf("\n");
    800027fe:	00006a17          	auipc	s4,0x6
    80002802:	8caa0a13          	add	s4,s4,-1846 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002806:	00006b97          	auipc	s7,0x6
    8000280a:	adab8b93          	add	s7,s7,-1318 # 800082e0 <states.0>
    8000280e:	a00d                	j	80002830 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002810:	ed86a583          	lw	a1,-296(a3)
    80002814:	8556                	mv	a0,s5
    80002816:	ffffe097          	auipc	ra,0xffffe
    8000281a:	d76080e7          	jalr	-650(ra) # 8000058c <printf>
    printf("\n");
    8000281e:	8552                	mv	a0,s4
    80002820:	ffffe097          	auipc	ra,0xffffe
    80002824:	d6c080e7          	jalr	-660(ra) # 8000058c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002828:	17048493          	add	s1,s1,368
    8000282c:	03248263          	beq	s1,s2,80002850 <procdump+0x9a>
    if(p->state == UNUSED)
    80002830:	86a6                	mv	a3,s1
    80002832:	eb84a783          	lw	a5,-328(s1)
    80002836:	dbed                	beqz	a5,80002828 <procdump+0x72>
      state = "???";
    80002838:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000283a:	fcfb6be3          	bltu	s6,a5,80002810 <procdump+0x5a>
    8000283e:	02079713          	sll	a4,a5,0x20
    80002842:	01d75793          	srl	a5,a4,0x1d
    80002846:	97de                	add	a5,a5,s7
    80002848:	6390                	ld	a2,0(a5)
    8000284a:	f279                	bnez	a2,80002810 <procdump+0x5a>
      state = "???";
    8000284c:	864e                	mv	a2,s3
    8000284e:	b7c9                	j	80002810 <procdump+0x5a>
  }
}
    80002850:	60a6                	ld	ra,72(sp)
    80002852:	6406                	ld	s0,64(sp)
    80002854:	74e2                	ld	s1,56(sp)
    80002856:	7942                	ld	s2,48(sp)
    80002858:	79a2                	ld	s3,40(sp)
    8000285a:	7a02                	ld	s4,32(sp)
    8000285c:	6ae2                	ld	s5,24(sp)
    8000285e:	6b42                	ld	s6,16(sp)
    80002860:	6ba2                	ld	s7,8(sp)
    80002862:	6161                	add	sp,sp,80
    80002864:	8082                	ret

0000000080002866 <swtch>:
    80002866:	00153023          	sd	ra,0(a0)
    8000286a:	00253423          	sd	sp,8(a0)
    8000286e:	e900                	sd	s0,16(a0)
    80002870:	ed04                	sd	s1,24(a0)
    80002872:	03253023          	sd	s2,32(a0)
    80002876:	03353423          	sd	s3,40(a0)
    8000287a:	03453823          	sd	s4,48(a0)
    8000287e:	03553c23          	sd	s5,56(a0)
    80002882:	05653023          	sd	s6,64(a0)
    80002886:	05753423          	sd	s7,72(a0)
    8000288a:	05853823          	sd	s8,80(a0)
    8000288e:	05953c23          	sd	s9,88(a0)
    80002892:	07a53023          	sd	s10,96(a0)
    80002896:	07b53423          	sd	s11,104(a0)
    8000289a:	0005b083          	ld	ra,0(a1)
    8000289e:	0085b103          	ld	sp,8(a1)
    800028a2:	6980                	ld	s0,16(a1)
    800028a4:	6d84                	ld	s1,24(a1)
    800028a6:	0205b903          	ld	s2,32(a1)
    800028aa:	0285b983          	ld	s3,40(a1)
    800028ae:	0305ba03          	ld	s4,48(a1)
    800028b2:	0385ba83          	ld	s5,56(a1)
    800028b6:	0405bb03          	ld	s6,64(a1)
    800028ba:	0485bb83          	ld	s7,72(a1)
    800028be:	0505bc03          	ld	s8,80(a1)
    800028c2:	0585bc83          	ld	s9,88(a1)
    800028c6:	0605bd03          	ld	s10,96(a1)
    800028ca:	0685bd83          	ld	s11,104(a1)
    800028ce:	8082                	ret

00000000800028d0 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800028d0:	1141                	add	sp,sp,-16
    800028d2:	e406                	sd	ra,8(sp)
    800028d4:	e022                	sd	s0,0(sp)
    800028d6:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    800028d8:	00006597          	auipc	a1,0x6
    800028dc:	a3058593          	add	a1,a1,-1488 # 80008308 <states.0+0x28>
    800028e0:	00015517          	auipc	a0,0x15
    800028e4:	08850513          	add	a0,a0,136 # 80017968 <tickslock>
    800028e8:	ffffe097          	auipc	ra,0xffffe
    800028ec:	284080e7          	jalr	644(ra) # 80000b6c <initlock>
}
    800028f0:	60a2                	ld	ra,8(sp)
    800028f2:	6402                	ld	s0,0(sp)
    800028f4:	0141                	add	sp,sp,16
    800028f6:	8082                	ret

00000000800028f8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800028f8:	1141                	add	sp,sp,-16
    800028fa:	e422                	sd	s0,8(sp)
    800028fc:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800028fe:	00003797          	auipc	a5,0x3
    80002902:	5a278793          	add	a5,a5,1442 # 80005ea0 <kernelvec>
    80002906:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000290a:	6422                	ld	s0,8(sp)
    8000290c:	0141                	add	sp,sp,16
    8000290e:	8082                	ret

0000000080002910 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002910:	1141                	add	sp,sp,-16
    80002912:	e406                	sd	ra,8(sp)
    80002914:	e022                	sd	s0,0(sp)
    80002916:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80002918:	fffff097          	auipc	ra,0xfffff
    8000291c:	178080e7          	jalr	376(ra) # 80001a90 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002920:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002924:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002926:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    8000292a:	00004697          	auipc	a3,0x4
    8000292e:	6d668693          	add	a3,a3,1750 # 80007000 <_trampoline>
    80002932:	00004717          	auipc	a4,0x4
    80002936:	6ce70713          	add	a4,a4,1742 # 80007000 <_trampoline>
    8000293a:	8f15                	sub	a4,a4,a3
    8000293c:	040007b7          	lui	a5,0x4000
    80002940:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002942:	07b2                	sll	a5,a5,0xc
    80002944:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002946:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000294a:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000294c:	18002673          	csrr	a2,satp
    80002950:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002952:	7130                	ld	a2,96(a0)
    80002954:	6138                	ld	a4,64(a0)
    80002956:	6585                	lui	a1,0x1
    80002958:	972e                	add	a4,a4,a1
    8000295a:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000295c:	7138                	ld	a4,96(a0)
    8000295e:	00000617          	auipc	a2,0x0
    80002962:	13c60613          	add	a2,a2,316 # 80002a9a <usertrap>
    80002966:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002968:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000296a:	8612                	mv	a2,tp
    8000296c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000296e:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002972:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002976:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000297a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000297e:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002980:	6f18                	ld	a4,24(a4)
    80002982:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002986:	692c                	ld	a1,80(a0)
    80002988:	81b1                	srl	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    8000298a:	00004717          	auipc	a4,0x4
    8000298e:	70670713          	add	a4,a4,1798 # 80007090 <userret>
    80002992:	8f15                	sub	a4,a4,a3
    80002994:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002996:	577d                	li	a4,-1
    80002998:	177e                	sll	a4,a4,0x3f
    8000299a:	8dd9                	or	a1,a1,a4
    8000299c:	02000537          	lui	a0,0x2000
    800029a0:	157d                	add	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800029a2:	0536                	sll	a0,a0,0xd
    800029a4:	9782                	jalr	a5
}
    800029a6:	60a2                	ld	ra,8(sp)
    800029a8:	6402                	ld	s0,0(sp)
    800029aa:	0141                	add	sp,sp,16
    800029ac:	8082                	ret

00000000800029ae <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800029ae:	1101                	add	sp,sp,-32
    800029b0:	ec06                	sd	ra,24(sp)
    800029b2:	e822                	sd	s0,16(sp)
    800029b4:	e426                	sd	s1,8(sp)
    800029b6:	1000                	add	s0,sp,32
  acquire(&tickslock);
    800029b8:	00015497          	auipc	s1,0x15
    800029bc:	fb048493          	add	s1,s1,-80 # 80017968 <tickslock>
    800029c0:	8526                	mv	a0,s1
    800029c2:	ffffe097          	auipc	ra,0xffffe
    800029c6:	23a080e7          	jalr	570(ra) # 80000bfc <acquire>
  ticks++;
    800029ca:	00006517          	auipc	a0,0x6
    800029ce:	65650513          	add	a0,a0,1622 # 80009020 <ticks>
    800029d2:	411c                	lw	a5,0(a0)
    800029d4:	2785                	addw	a5,a5,1
    800029d6:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    800029d8:	00000097          	auipc	ra,0x0
    800029dc:	c58080e7          	jalr	-936(ra) # 80002630 <wakeup>
  release(&tickslock);
    800029e0:	8526                	mv	a0,s1
    800029e2:	ffffe097          	auipc	ra,0xffffe
    800029e6:	2ce080e7          	jalr	718(ra) # 80000cb0 <release>
}
    800029ea:	60e2                	ld	ra,24(sp)
    800029ec:	6442                	ld	s0,16(sp)
    800029ee:	64a2                	ld	s1,8(sp)
    800029f0:	6105                	add	sp,sp,32
    800029f2:	8082                	ret

00000000800029f4 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    800029f4:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800029f8:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    800029fa:	0807df63          	bgez	a5,80002a98 <devintr+0xa4>
{
    800029fe:	1101                	add	sp,sp,-32
    80002a00:	ec06                	sd	ra,24(sp)
    80002a02:	e822                	sd	s0,16(sp)
    80002a04:	e426                	sd	s1,8(sp)
    80002a06:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    80002a08:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80002a0c:	46a5                	li	a3,9
    80002a0e:	00d70d63          	beq	a4,a3,80002a28 <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80002a12:	577d                	li	a4,-1
    80002a14:	177e                	sll	a4,a4,0x3f
    80002a16:	0705                	add	a4,a4,1
    return 0;
    80002a18:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002a1a:	04e78e63          	beq	a5,a4,80002a76 <devintr+0x82>
  }
}
    80002a1e:	60e2                	ld	ra,24(sp)
    80002a20:	6442                	ld	s0,16(sp)
    80002a22:	64a2                	ld	s1,8(sp)
    80002a24:	6105                	add	sp,sp,32
    80002a26:	8082                	ret
    int irq = plic_claim();
    80002a28:	00003097          	auipc	ra,0x3
    80002a2c:	580080e7          	jalr	1408(ra) # 80005fa8 <plic_claim>
    80002a30:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002a32:	47a9                	li	a5,10
    80002a34:	02f50763          	beq	a0,a5,80002a62 <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80002a38:	4785                	li	a5,1
    80002a3a:	02f50963          	beq	a0,a5,80002a6c <devintr+0x78>
    return 1;
    80002a3e:	4505                	li	a0,1
    } else if(irq){
    80002a40:	dcf9                	beqz	s1,80002a1e <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80002a42:	85a6                	mv	a1,s1
    80002a44:	00006517          	auipc	a0,0x6
    80002a48:	8cc50513          	add	a0,a0,-1844 # 80008310 <states.0+0x30>
    80002a4c:	ffffe097          	auipc	ra,0xffffe
    80002a50:	b40080e7          	jalr	-1216(ra) # 8000058c <printf>
      plic_complete(irq);
    80002a54:	8526                	mv	a0,s1
    80002a56:	00003097          	auipc	ra,0x3
    80002a5a:	576080e7          	jalr	1398(ra) # 80005fcc <plic_complete>
    return 1;
    80002a5e:	4505                	li	a0,1
    80002a60:	bf7d                	j	80002a1e <devintr+0x2a>
      uartintr();
    80002a62:	ffffe097          	auipc	ra,0xffffe
    80002a66:	f5c080e7          	jalr	-164(ra) # 800009be <uartintr>
    if(irq)
    80002a6a:	b7ed                	j	80002a54 <devintr+0x60>
      virtio_disk_intr();
    80002a6c:	00004097          	auipc	ra,0x4
    80002a70:	9d2080e7          	jalr	-1582(ra) # 8000643e <virtio_disk_intr>
    if(irq)
    80002a74:	b7c5                	j	80002a54 <devintr+0x60>
    if(cpuid() == 0){
    80002a76:	fffff097          	auipc	ra,0xfffff
    80002a7a:	fee080e7          	jalr	-18(ra) # 80001a64 <cpuid>
    80002a7e:	c901                	beqz	a0,80002a8e <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002a80:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002a84:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002a86:	14479073          	csrw	sip,a5
    return 2;
    80002a8a:	4509                	li	a0,2
    80002a8c:	bf49                	j	80002a1e <devintr+0x2a>
      clockintr();
    80002a8e:	00000097          	auipc	ra,0x0
    80002a92:	f20080e7          	jalr	-224(ra) # 800029ae <clockintr>
    80002a96:	b7ed                	j	80002a80 <devintr+0x8c>
}
    80002a98:	8082                	ret

0000000080002a9a <usertrap>:
{
    80002a9a:	1101                	add	sp,sp,-32
    80002a9c:	ec06                	sd	ra,24(sp)
    80002a9e:	e822                	sd	s0,16(sp)
    80002aa0:	e426                	sd	s1,8(sp)
    80002aa2:	e04a                	sd	s2,0(sp)
    80002aa4:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002aa6:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002aaa:	1007f793          	and	a5,a5,256
    80002aae:	e3ad                	bnez	a5,80002b10 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002ab0:	00003797          	auipc	a5,0x3
    80002ab4:	3f078793          	add	a5,a5,1008 # 80005ea0 <kernelvec>
    80002ab8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002abc:	fffff097          	auipc	ra,0xfffff
    80002ac0:	fd4080e7          	jalr	-44(ra) # 80001a90 <myproc>
    80002ac4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002ac6:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ac8:	14102773          	csrr	a4,sepc
    80002acc:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ace:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002ad2:	47a1                	li	a5,8
    80002ad4:	04f71c63          	bne	a4,a5,80002b2c <usertrap+0x92>
    if(p->killed)
    80002ad8:	591c                	lw	a5,48(a0)
    80002ada:	e3b9                	bnez	a5,80002b20 <usertrap+0x86>
    p->trapframe->epc += 4;
    80002adc:	70b8                	ld	a4,96(s1)
    80002ade:	6f1c                	ld	a5,24(a4)
    80002ae0:	0791                	add	a5,a5,4
    80002ae2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ae4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002ae8:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002aec:	10079073          	csrw	sstatus,a5
    syscall();
    80002af0:	00000097          	auipc	ra,0x0
    80002af4:	2e0080e7          	jalr	736(ra) # 80002dd0 <syscall>
  if(p->killed)
    80002af8:	589c                	lw	a5,48(s1)
    80002afa:	ebc1                	bnez	a5,80002b8a <usertrap+0xf0>
  usertrapret();
    80002afc:	00000097          	auipc	ra,0x0
    80002b00:	e14080e7          	jalr	-492(ra) # 80002910 <usertrapret>
}
    80002b04:	60e2                	ld	ra,24(sp)
    80002b06:	6442                	ld	s0,16(sp)
    80002b08:	64a2                	ld	s1,8(sp)
    80002b0a:	6902                	ld	s2,0(sp)
    80002b0c:	6105                	add	sp,sp,32
    80002b0e:	8082                	ret
    panic("usertrap: not from user mode");
    80002b10:	00006517          	auipc	a0,0x6
    80002b14:	82050513          	add	a0,a0,-2016 # 80008330 <states.0+0x50>
    80002b18:	ffffe097          	auipc	ra,0xffffe
    80002b1c:	a2a080e7          	jalr	-1494(ra) # 80000542 <panic>
      exit(-1);
    80002b20:	557d                	li	a0,-1
    80002b22:	00000097          	auipc	ra,0x0
    80002b26:	848080e7          	jalr	-1976(ra) # 8000236a <exit>
    80002b2a:	bf4d                	j	80002adc <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002b2c:	00000097          	auipc	ra,0x0
    80002b30:	ec8080e7          	jalr	-312(ra) # 800029f4 <devintr>
    80002b34:	892a                	mv	s2,a0
    80002b36:	c501                	beqz	a0,80002b3e <usertrap+0xa4>
  if(p->killed)
    80002b38:	589c                	lw	a5,48(s1)
    80002b3a:	c3a1                	beqz	a5,80002b7a <usertrap+0xe0>
    80002b3c:	a815                	j	80002b70 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002b3e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002b42:	5c90                	lw	a2,56(s1)
    80002b44:	00006517          	auipc	a0,0x6
    80002b48:	80c50513          	add	a0,a0,-2036 # 80008350 <states.0+0x70>
    80002b4c:	ffffe097          	auipc	ra,0xffffe
    80002b50:	a40080e7          	jalr	-1472(ra) # 8000058c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b54:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002b58:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002b5c:	00006517          	auipc	a0,0x6
    80002b60:	82450513          	add	a0,a0,-2012 # 80008380 <states.0+0xa0>
    80002b64:	ffffe097          	auipc	ra,0xffffe
    80002b68:	a28080e7          	jalr	-1496(ra) # 8000058c <printf>
    p->killed = 1;
    80002b6c:	4785                	li	a5,1
    80002b6e:	d89c                	sw	a5,48(s1)
    exit(-1);
    80002b70:	557d                	li	a0,-1
    80002b72:	fffff097          	auipc	ra,0xfffff
    80002b76:	7f8080e7          	jalr	2040(ra) # 8000236a <exit>
  if(which_dev == 2)
    80002b7a:	4789                	li	a5,2
    80002b7c:	f8f910e3          	bne	s2,a5,80002afc <usertrap+0x62>
    yield();
    80002b80:	00000097          	auipc	ra,0x0
    80002b84:	8f4080e7          	jalr	-1804(ra) # 80002474 <yield>
    80002b88:	bf95                	j	80002afc <usertrap+0x62>
  int which_dev = 0;
    80002b8a:	4901                	li	s2,0
    80002b8c:	b7d5                	j	80002b70 <usertrap+0xd6>

0000000080002b8e <kerneltrap>:
{
    80002b8e:	7179                	add	sp,sp,-48
    80002b90:	f406                	sd	ra,40(sp)
    80002b92:	f022                	sd	s0,32(sp)
    80002b94:	ec26                	sd	s1,24(sp)
    80002b96:	e84a                	sd	s2,16(sp)
    80002b98:	e44e                	sd	s3,8(sp)
    80002b9a:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b9c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ba0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ba4:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002ba8:	1004f793          	and	a5,s1,256
    80002bac:	cb85                	beqz	a5,80002bdc <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bae:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002bb2:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80002bb4:	ef85                	bnez	a5,80002bec <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002bb6:	00000097          	auipc	ra,0x0
    80002bba:	e3e080e7          	jalr	-450(ra) # 800029f4 <devintr>
    80002bbe:	cd1d                	beqz	a0,80002bfc <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002bc0:	4789                	li	a5,2
    80002bc2:	06f50a63          	beq	a0,a5,80002c36 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002bc6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002bca:	10049073          	csrw	sstatus,s1
}
    80002bce:	70a2                	ld	ra,40(sp)
    80002bd0:	7402                	ld	s0,32(sp)
    80002bd2:	64e2                	ld	s1,24(sp)
    80002bd4:	6942                	ld	s2,16(sp)
    80002bd6:	69a2                	ld	s3,8(sp)
    80002bd8:	6145                	add	sp,sp,48
    80002bda:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002bdc:	00005517          	auipc	a0,0x5
    80002be0:	7c450513          	add	a0,a0,1988 # 800083a0 <states.0+0xc0>
    80002be4:	ffffe097          	auipc	ra,0xffffe
    80002be8:	95e080e7          	jalr	-1698(ra) # 80000542 <panic>
    panic("kerneltrap: interrupts enabled");
    80002bec:	00005517          	auipc	a0,0x5
    80002bf0:	7dc50513          	add	a0,a0,2012 # 800083c8 <states.0+0xe8>
    80002bf4:	ffffe097          	auipc	ra,0xffffe
    80002bf8:	94e080e7          	jalr	-1714(ra) # 80000542 <panic>
    printf("scause %p\n", scause);
    80002bfc:	85ce                	mv	a1,s3
    80002bfe:	00005517          	auipc	a0,0x5
    80002c02:	7ea50513          	add	a0,a0,2026 # 800083e8 <states.0+0x108>
    80002c06:	ffffe097          	auipc	ra,0xffffe
    80002c0a:	986080e7          	jalr	-1658(ra) # 8000058c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c0e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002c12:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002c16:	00005517          	auipc	a0,0x5
    80002c1a:	7e250513          	add	a0,a0,2018 # 800083f8 <states.0+0x118>
    80002c1e:	ffffe097          	auipc	ra,0xffffe
    80002c22:	96e080e7          	jalr	-1682(ra) # 8000058c <printf>
    panic("kerneltrap");
    80002c26:	00005517          	auipc	a0,0x5
    80002c2a:	7ea50513          	add	a0,a0,2026 # 80008410 <states.0+0x130>
    80002c2e:	ffffe097          	auipc	ra,0xffffe
    80002c32:	914080e7          	jalr	-1772(ra) # 80000542 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002c36:	fffff097          	auipc	ra,0xfffff
    80002c3a:	e5a080e7          	jalr	-422(ra) # 80001a90 <myproc>
    80002c3e:	d541                	beqz	a0,80002bc6 <kerneltrap+0x38>
    80002c40:	fffff097          	auipc	ra,0xfffff
    80002c44:	e50080e7          	jalr	-432(ra) # 80001a90 <myproc>
    80002c48:	4d18                	lw	a4,24(a0)
    80002c4a:	478d                	li	a5,3
    80002c4c:	f6f71de3          	bne	a4,a5,80002bc6 <kerneltrap+0x38>
    yield();
    80002c50:	00000097          	auipc	ra,0x0
    80002c54:	824080e7          	jalr	-2012(ra) # 80002474 <yield>
    80002c58:	b7bd                	j	80002bc6 <kerneltrap+0x38>

0000000080002c5a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002c5a:	1101                	add	sp,sp,-32
    80002c5c:	ec06                	sd	ra,24(sp)
    80002c5e:	e822                	sd	s0,16(sp)
    80002c60:	e426                	sd	s1,8(sp)
    80002c62:	1000                	add	s0,sp,32
    80002c64:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002c66:	fffff097          	auipc	ra,0xfffff
    80002c6a:	e2a080e7          	jalr	-470(ra) # 80001a90 <myproc>
  switch (n) {
    80002c6e:	4795                	li	a5,5
    80002c70:	0497e163          	bltu	a5,s1,80002cb2 <argraw+0x58>
    80002c74:	048a                	sll	s1,s1,0x2
    80002c76:	00005717          	auipc	a4,0x5
    80002c7a:	7d270713          	add	a4,a4,2002 # 80008448 <states.0+0x168>
    80002c7e:	94ba                	add	s1,s1,a4
    80002c80:	409c                	lw	a5,0(s1)
    80002c82:	97ba                	add	a5,a5,a4
    80002c84:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002c86:	713c                	ld	a5,96(a0)
    80002c88:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002c8a:	60e2                	ld	ra,24(sp)
    80002c8c:	6442                	ld	s0,16(sp)
    80002c8e:	64a2                	ld	s1,8(sp)
    80002c90:	6105                	add	sp,sp,32
    80002c92:	8082                	ret
    return p->trapframe->a1;
    80002c94:	713c                	ld	a5,96(a0)
    80002c96:	7fa8                	ld	a0,120(a5)
    80002c98:	bfcd                	j	80002c8a <argraw+0x30>
    return p->trapframe->a2;
    80002c9a:	713c                	ld	a5,96(a0)
    80002c9c:	63c8                	ld	a0,128(a5)
    80002c9e:	b7f5                	j	80002c8a <argraw+0x30>
    return p->trapframe->a3;
    80002ca0:	713c                	ld	a5,96(a0)
    80002ca2:	67c8                	ld	a0,136(a5)
    80002ca4:	b7dd                	j	80002c8a <argraw+0x30>
    return p->trapframe->a4;
    80002ca6:	713c                	ld	a5,96(a0)
    80002ca8:	6bc8                	ld	a0,144(a5)
    80002caa:	b7c5                	j	80002c8a <argraw+0x30>
    return p->trapframe->a5;
    80002cac:	713c                	ld	a5,96(a0)
    80002cae:	6fc8                	ld	a0,152(a5)
    80002cb0:	bfe9                	j	80002c8a <argraw+0x30>
  panic("argraw");
    80002cb2:	00005517          	auipc	a0,0x5
    80002cb6:	76e50513          	add	a0,a0,1902 # 80008420 <states.0+0x140>
    80002cba:	ffffe097          	auipc	ra,0xffffe
    80002cbe:	888080e7          	jalr	-1912(ra) # 80000542 <panic>

0000000080002cc2 <fetchaddr>:
{
    80002cc2:	1101                	add	sp,sp,-32
    80002cc4:	ec06                	sd	ra,24(sp)
    80002cc6:	e822                	sd	s0,16(sp)
    80002cc8:	e426                	sd	s1,8(sp)
    80002cca:	e04a                	sd	s2,0(sp)
    80002ccc:	1000                	add	s0,sp,32
    80002cce:	84aa                	mv	s1,a0
    80002cd0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002cd2:	fffff097          	auipc	ra,0xfffff
    80002cd6:	dbe080e7          	jalr	-578(ra) # 80001a90 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002cda:	653c                	ld	a5,72(a0)
    80002cdc:	02f4f863          	bgeu	s1,a5,80002d0c <fetchaddr+0x4a>
    80002ce0:	00848713          	add	a4,s1,8
    80002ce4:	02e7e663          	bltu	a5,a4,80002d10 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002ce8:	46a1                	li	a3,8
    80002cea:	8626                	mv	a2,s1
    80002cec:	85ca                	mv	a1,s2
    80002cee:	6928                	ld	a0,80(a0)
    80002cf0:	fffff097          	auipc	ra,0xfffff
    80002cf4:	a96080e7          	jalr	-1386(ra) # 80001786 <copyin>
    80002cf8:	00a03533          	snez	a0,a0
    80002cfc:	40a00533          	neg	a0,a0
}
    80002d00:	60e2                	ld	ra,24(sp)
    80002d02:	6442                	ld	s0,16(sp)
    80002d04:	64a2                	ld	s1,8(sp)
    80002d06:	6902                	ld	s2,0(sp)
    80002d08:	6105                	add	sp,sp,32
    80002d0a:	8082                	ret
    return -1;
    80002d0c:	557d                	li	a0,-1
    80002d0e:	bfcd                	j	80002d00 <fetchaddr+0x3e>
    80002d10:	557d                	li	a0,-1
    80002d12:	b7fd                	j	80002d00 <fetchaddr+0x3e>

0000000080002d14 <fetchstr>:
{
    80002d14:	7179                	add	sp,sp,-48
    80002d16:	f406                	sd	ra,40(sp)
    80002d18:	f022                	sd	s0,32(sp)
    80002d1a:	ec26                	sd	s1,24(sp)
    80002d1c:	e84a                	sd	s2,16(sp)
    80002d1e:	e44e                	sd	s3,8(sp)
    80002d20:	1800                	add	s0,sp,48
    80002d22:	892a                	mv	s2,a0
    80002d24:	84ae                	mv	s1,a1
    80002d26:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002d28:	fffff097          	auipc	ra,0xfffff
    80002d2c:	d68080e7          	jalr	-664(ra) # 80001a90 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002d30:	86ce                	mv	a3,s3
    80002d32:	864a                	mv	a2,s2
    80002d34:	85a6                	mv	a1,s1
    80002d36:	6928                	ld	a0,80(a0)
    80002d38:	fffff097          	auipc	ra,0xfffff
    80002d3c:	a66080e7          	jalr	-1434(ra) # 8000179e <copyinstr>
  if(err < 0)
    80002d40:	00054763          	bltz	a0,80002d4e <fetchstr+0x3a>
  return strlen(buf);
    80002d44:	8526                	mv	a0,s1
    80002d46:	ffffe097          	auipc	ra,0xffffe
    80002d4a:	134080e7          	jalr	308(ra) # 80000e7a <strlen>
}
    80002d4e:	70a2                	ld	ra,40(sp)
    80002d50:	7402                	ld	s0,32(sp)
    80002d52:	64e2                	ld	s1,24(sp)
    80002d54:	6942                	ld	s2,16(sp)
    80002d56:	69a2                	ld	s3,8(sp)
    80002d58:	6145                	add	sp,sp,48
    80002d5a:	8082                	ret

0000000080002d5c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002d5c:	1101                	add	sp,sp,-32
    80002d5e:	ec06                	sd	ra,24(sp)
    80002d60:	e822                	sd	s0,16(sp)
    80002d62:	e426                	sd	s1,8(sp)
    80002d64:	1000                	add	s0,sp,32
    80002d66:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002d68:	00000097          	auipc	ra,0x0
    80002d6c:	ef2080e7          	jalr	-270(ra) # 80002c5a <argraw>
    80002d70:	c088                	sw	a0,0(s1)
  return 0;
}
    80002d72:	4501                	li	a0,0
    80002d74:	60e2                	ld	ra,24(sp)
    80002d76:	6442                	ld	s0,16(sp)
    80002d78:	64a2                	ld	s1,8(sp)
    80002d7a:	6105                	add	sp,sp,32
    80002d7c:	8082                	ret

0000000080002d7e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002d7e:	1101                	add	sp,sp,-32
    80002d80:	ec06                	sd	ra,24(sp)
    80002d82:	e822                	sd	s0,16(sp)
    80002d84:	e426                	sd	s1,8(sp)
    80002d86:	1000                	add	s0,sp,32
    80002d88:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002d8a:	00000097          	auipc	ra,0x0
    80002d8e:	ed0080e7          	jalr	-304(ra) # 80002c5a <argraw>
    80002d92:	e088                	sd	a0,0(s1)
  return 0;
}
    80002d94:	4501                	li	a0,0
    80002d96:	60e2                	ld	ra,24(sp)
    80002d98:	6442                	ld	s0,16(sp)
    80002d9a:	64a2                	ld	s1,8(sp)
    80002d9c:	6105                	add	sp,sp,32
    80002d9e:	8082                	ret

0000000080002da0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002da0:	1101                	add	sp,sp,-32
    80002da2:	ec06                	sd	ra,24(sp)
    80002da4:	e822                	sd	s0,16(sp)
    80002da6:	e426                	sd	s1,8(sp)
    80002da8:	e04a                	sd	s2,0(sp)
    80002daa:	1000                	add	s0,sp,32
    80002dac:	84ae                	mv	s1,a1
    80002dae:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002db0:	00000097          	auipc	ra,0x0
    80002db4:	eaa080e7          	jalr	-342(ra) # 80002c5a <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002db8:	864a                	mv	a2,s2
    80002dba:	85a6                	mv	a1,s1
    80002dbc:	00000097          	auipc	ra,0x0
    80002dc0:	f58080e7          	jalr	-168(ra) # 80002d14 <fetchstr>
}
    80002dc4:	60e2                	ld	ra,24(sp)
    80002dc6:	6442                	ld	s0,16(sp)
    80002dc8:	64a2                	ld	s1,8(sp)
    80002dca:	6902                	ld	s2,0(sp)
    80002dcc:	6105                	add	sp,sp,32
    80002dce:	8082                	ret

0000000080002dd0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002dd0:	1101                	add	sp,sp,-32
    80002dd2:	ec06                	sd	ra,24(sp)
    80002dd4:	e822                	sd	s0,16(sp)
    80002dd6:	e426                	sd	s1,8(sp)
    80002dd8:	e04a                	sd	s2,0(sp)
    80002dda:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002ddc:	fffff097          	auipc	ra,0xfffff
    80002de0:	cb4080e7          	jalr	-844(ra) # 80001a90 <myproc>
    80002de4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002de6:	06053903          	ld	s2,96(a0)
    80002dea:	0a893783          	ld	a5,168(s2)
    80002dee:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002df2:	37fd                	addw	a5,a5,-1
    80002df4:	4751                	li	a4,20
    80002df6:	00f76f63          	bltu	a4,a5,80002e14 <syscall+0x44>
    80002dfa:	00369713          	sll	a4,a3,0x3
    80002dfe:	00005797          	auipc	a5,0x5
    80002e02:	66278793          	add	a5,a5,1634 # 80008460 <syscalls>
    80002e06:	97ba                	add	a5,a5,a4
    80002e08:	639c                	ld	a5,0(a5)
    80002e0a:	c789                	beqz	a5,80002e14 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002e0c:	9782                	jalr	a5
    80002e0e:	06a93823          	sd	a0,112(s2)
    80002e12:	a839                	j	80002e30 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002e14:	16048613          	add	a2,s1,352
    80002e18:	5c8c                	lw	a1,56(s1)
    80002e1a:	00005517          	auipc	a0,0x5
    80002e1e:	60e50513          	add	a0,a0,1550 # 80008428 <states.0+0x148>
    80002e22:	ffffd097          	auipc	ra,0xffffd
    80002e26:	76a080e7          	jalr	1898(ra) # 8000058c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002e2a:	70bc                	ld	a5,96(s1)
    80002e2c:	577d                	li	a4,-1
    80002e2e:	fbb8                	sd	a4,112(a5)
  }
}
    80002e30:	60e2                	ld	ra,24(sp)
    80002e32:	6442                	ld	s0,16(sp)
    80002e34:	64a2                	ld	s1,8(sp)
    80002e36:	6902                	ld	s2,0(sp)
    80002e38:	6105                	add	sp,sp,32
    80002e3a:	8082                	ret

0000000080002e3c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002e3c:	1101                	add	sp,sp,-32
    80002e3e:	ec06                	sd	ra,24(sp)
    80002e40:	e822                	sd	s0,16(sp)
    80002e42:	1000                	add	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002e44:	fec40593          	add	a1,s0,-20
    80002e48:	4501                	li	a0,0
    80002e4a:	00000097          	auipc	ra,0x0
    80002e4e:	f12080e7          	jalr	-238(ra) # 80002d5c <argint>
    return -1;
    80002e52:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002e54:	00054963          	bltz	a0,80002e66 <sys_exit+0x2a>
  exit(n);
    80002e58:	fec42503          	lw	a0,-20(s0)
    80002e5c:	fffff097          	auipc	ra,0xfffff
    80002e60:	50e080e7          	jalr	1294(ra) # 8000236a <exit>
  return 0;  // not reached
    80002e64:	4781                	li	a5,0
}
    80002e66:	853e                	mv	a0,a5
    80002e68:	60e2                	ld	ra,24(sp)
    80002e6a:	6442                	ld	s0,16(sp)
    80002e6c:	6105                	add	sp,sp,32
    80002e6e:	8082                	ret

0000000080002e70 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002e70:	1141                	add	sp,sp,-16
    80002e72:	e406                	sd	ra,8(sp)
    80002e74:	e022                	sd	s0,0(sp)
    80002e76:	0800                	add	s0,sp,16
  return myproc()->pid;
    80002e78:	fffff097          	auipc	ra,0xfffff
    80002e7c:	c18080e7          	jalr	-1000(ra) # 80001a90 <myproc>
}
    80002e80:	5d08                	lw	a0,56(a0)
    80002e82:	60a2                	ld	ra,8(sp)
    80002e84:	6402                	ld	s0,0(sp)
    80002e86:	0141                	add	sp,sp,16
    80002e88:	8082                	ret

0000000080002e8a <sys_fork>:

uint64
sys_fork(void)
{
    80002e8a:	1141                	add	sp,sp,-16
    80002e8c:	e406                	sd	ra,8(sp)
    80002e8e:	e022                	sd	s0,0(sp)
    80002e90:	0800                	add	s0,sp,16
  return fork();
    80002e92:	fffff097          	auipc	ra,0xfffff
    80002e96:	178080e7          	jalr	376(ra) # 8000200a <fork>
}
    80002e9a:	60a2                	ld	ra,8(sp)
    80002e9c:	6402                	ld	s0,0(sp)
    80002e9e:	0141                	add	sp,sp,16
    80002ea0:	8082                	ret

0000000080002ea2 <sys_wait>:

uint64
sys_wait(void)
{
    80002ea2:	1101                	add	sp,sp,-32
    80002ea4:	ec06                	sd	ra,24(sp)
    80002ea6:	e822                	sd	s0,16(sp)
    80002ea8:	1000                	add	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002eaa:	fe840593          	add	a1,s0,-24
    80002eae:	4501                	li	a0,0
    80002eb0:	00000097          	auipc	ra,0x0
    80002eb4:	ece080e7          	jalr	-306(ra) # 80002d7e <argaddr>
    80002eb8:	87aa                	mv	a5,a0
    return -1;
    80002eba:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002ebc:	0007c863          	bltz	a5,80002ecc <sys_wait+0x2a>
  return wait(p);
    80002ec0:	fe843503          	ld	a0,-24(s0)
    80002ec4:	fffff097          	auipc	ra,0xfffff
    80002ec8:	66a080e7          	jalr	1642(ra) # 8000252e <wait>
}
    80002ecc:	60e2                	ld	ra,24(sp)
    80002ece:	6442                	ld	s0,16(sp)
    80002ed0:	6105                	add	sp,sp,32
    80002ed2:	8082                	ret

0000000080002ed4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002ed4:	711d                	add	sp,sp,-96
    80002ed6:	ec86                	sd	ra,88(sp)
    80002ed8:	e8a2                	sd	s0,80(sp)
    80002eda:	e4a6                	sd	s1,72(sp)
    80002edc:	e0ca                	sd	s2,64(sp)
    80002ede:	fc4e                	sd	s3,56(sp)
    80002ee0:	f852                	sd	s4,48(sp)
    80002ee2:	f456                	sd	s5,40(sp)
    80002ee4:	f05a                	sd	s6,32(sp)
    80002ee6:	ec5e                	sd	s7,24(sp)
    80002ee8:	1080                	add	s0,sp,96
  int addr;
  int n;
  struct proc * p = myproc();
    80002eea:	fffff097          	auipc	ra,0xfffff
    80002eee:	ba6080e7          	jalr	-1114(ra) # 80001a90 <myproc>
    80002ef2:	84aa                	mv	s1,a0
  pte_t *pte, *kernel_pte;

  if(argint(0, &n) < 0)
    80002ef4:	fac40593          	add	a1,s0,-84
    80002ef8:	4501                	li	a0,0
    80002efa:	00000097          	auipc	ra,0x0
    80002efe:	e62080e7          	jalr	-414(ra) # 80002d5c <argint>
    return -1;
    80002f02:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002f04:	06054c63          	bltz	a0,80002f7c <sys_sbrk+0xa8>
  addr = myproc()->sz;
    80002f08:	fffff097          	auipc	ra,0xfffff
    80002f0c:	b88080e7          	jalr	-1144(ra) # 80001a90 <myproc>
    80002f10:	04852a83          	lw	s5,72(a0)
  if(addr + n >= PLIC) {
    80002f14:	fac42503          	lw	a0,-84(s0)
    80002f18:	015506bb          	addw	a3,a0,s5
    80002f1c:	0c000737          	lui	a4,0xc000
    return -1;
    80002f20:	57fd                	li	a5,-1
  if(addr + n >= PLIC) {
    80002f22:	04e6dd63          	bge	a3,a4,80002f7c <sys_sbrk+0xa8>
  }
  if(growproc(n) < 0)
    80002f26:	fffff097          	auipc	ra,0xfffff
    80002f2a:	06c080e7          	jalr	108(ra) # 80001f92 <growproc>
    80002f2e:	08054e63          	bltz	a0,80002fca <sys_sbrk+0xf6>
    return -1;

  if(n > 0) {
    80002f32:	fac42783          	lw	a5,-84(s0)
    80002f36:	04f05f63          	blez	a5,80002f94 <sys_sbrk+0xc0>
    for (int j = addr; j < addr + n; j += PGSIZE) {
    80002f3a:	8956                	mv	s2,s5
    80002f3c:	8a56                	mv	s4,s5
    80002f3e:	6b85                	lui	s7,0x1
    80002f40:	6b05                	lui	s6,0x1
      pte =  walk(p->pagetable, j, 0); 
    80002f42:	4601                	li	a2,0
    80002f44:	85ca                	mv	a1,s2
    80002f46:	68a8                	ld	a0,80(s1)
    80002f48:	ffffe097          	auipc	ra,0xffffe
    80002f4c:	09e080e7          	jalr	158(ra) # 80000fe6 <walk>
    80002f50:	89aa                	mv	s3,a0
      kernel_pte = walk(p->kernel_pagetable, j, 1); 
    80002f52:	4605                	li	a2,1
    80002f54:	85ca                	mv	a1,s2
    80002f56:	6ca8                	ld	a0,88(s1)
    80002f58:	ffffe097          	auipc	ra,0xffffe
    80002f5c:	08e080e7          	jalr	142(ra) # 80000fe6 <walk>
      *kernel_pte = (*pte) & ~PTE_U; 
    80002f60:	0009b783          	ld	a5,0(s3)
    80002f64:	9bbd                	and	a5,a5,-17
    80002f66:	e11c                	sd	a5,0(a0)
    for (int j = addr; j < addr + n; j += PGSIZE) {
    80002f68:	014b8a3b          	addw	s4,s7,s4
    80002f6c:	995a                	add	s2,s2,s6
    80002f6e:	fac42783          	lw	a5,-84(s0)
    80002f72:	015787bb          	addw	a5,a5,s5
    80002f76:	fcfa46e3          	blt	s4,a5,80002f42 <sys_sbrk+0x6e>
    for (int j = addr - PGSIZE; j >= addr + n; j -= PGSIZE) {
      uvmunmap(p->kernel_pagetable, j, 1, 0);
    }
    //uvmdealloc(p->kernel_pagetable, addr, addr + n);
  }
  return addr;
    80002f7a:	87d6                	mv	a5,s5
}
    80002f7c:	853e                	mv	a0,a5
    80002f7e:	60e6                	ld	ra,88(sp)
    80002f80:	6446                	ld	s0,80(sp)
    80002f82:	64a6                	ld	s1,72(sp)
    80002f84:	6906                	ld	s2,64(sp)
    80002f86:	79e2                	ld	s3,56(sp)
    80002f88:	7a42                	ld	s4,48(sp)
    80002f8a:	7aa2                	ld	s5,40(sp)
    80002f8c:	7b02                	ld	s6,32(sp)
    80002f8e:	6be2                	ld	s7,24(sp)
    80002f90:	6125                	add	sp,sp,96
    80002f92:	8082                	ret
    for (int j = addr - PGSIZE; j >= addr + n; j -= PGSIZE) {
    80002f94:	797d                	lui	s2,0xfffff
    80002f96:	0159093b          	addw	s2,s2,s5
    80002f9a:	777d                	lui	a4,0xfffff
    80002f9c:	fcf74fe3          	blt	a4,a5,80002f7a <sys_sbrk+0xa6>
    80002fa0:	89ca                	mv	s3,s2
    80002fa2:	7b7d                	lui	s6,0xfffff
    80002fa4:	7a7d                	lui	s4,0xfffff
      uvmunmap(p->kernel_pagetable, j, 1, 0);
    80002fa6:	4681                	li	a3,0
    80002fa8:	4605                	li	a2,1
    80002faa:	85ce                	mv	a1,s3
    80002fac:	6ca8                	ld	a0,88(s1)
    80002fae:	ffffe097          	auipc	ra,0xffffe
    80002fb2:	31e080e7          	jalr	798(ra) # 800012cc <uvmunmap>
    for (int j = addr - PGSIZE; j >= addr + n; j -= PGSIZE) {
    80002fb6:	012b093b          	addw	s2,s6,s2
    80002fba:	99d2                	add	s3,s3,s4
    80002fbc:	fac42783          	lw	a5,-84(s0)
    80002fc0:	015787bb          	addw	a5,a5,s5
    80002fc4:	fef951e3          	bge	s2,a5,80002fa6 <sys_sbrk+0xd2>
    80002fc8:	bf4d                	j	80002f7a <sys_sbrk+0xa6>
    return -1;
    80002fca:	57fd                	li	a5,-1
    80002fcc:	bf45                	j	80002f7c <sys_sbrk+0xa8>

0000000080002fce <sys_sleep>:

uint64
sys_sleep(void)
{
    80002fce:	7139                	add	sp,sp,-64
    80002fd0:	fc06                	sd	ra,56(sp)
    80002fd2:	f822                	sd	s0,48(sp)
    80002fd4:	f426                	sd	s1,40(sp)
    80002fd6:	f04a                	sd	s2,32(sp)
    80002fd8:	ec4e                	sd	s3,24(sp)
    80002fda:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002fdc:	fcc40593          	add	a1,s0,-52
    80002fe0:	4501                	li	a0,0
    80002fe2:	00000097          	auipc	ra,0x0
    80002fe6:	d7a080e7          	jalr	-646(ra) # 80002d5c <argint>
    return -1;
    80002fea:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002fec:	06054563          	bltz	a0,80003056 <sys_sleep+0x88>
  acquire(&tickslock);
    80002ff0:	00015517          	auipc	a0,0x15
    80002ff4:	97850513          	add	a0,a0,-1672 # 80017968 <tickslock>
    80002ff8:	ffffe097          	auipc	ra,0xffffe
    80002ffc:	c04080e7          	jalr	-1020(ra) # 80000bfc <acquire>
  ticks0 = ticks;
    80003000:	00006917          	auipc	s2,0x6
    80003004:	02092903          	lw	s2,32(s2) # 80009020 <ticks>
  while(ticks - ticks0 < n){
    80003008:	fcc42783          	lw	a5,-52(s0)
    8000300c:	cf85                	beqz	a5,80003044 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000300e:	00015997          	auipc	s3,0x15
    80003012:	95a98993          	add	s3,s3,-1702 # 80017968 <tickslock>
    80003016:	00006497          	auipc	s1,0x6
    8000301a:	00a48493          	add	s1,s1,10 # 80009020 <ticks>
    if(myproc()->killed){
    8000301e:	fffff097          	auipc	ra,0xfffff
    80003022:	a72080e7          	jalr	-1422(ra) # 80001a90 <myproc>
    80003026:	591c                	lw	a5,48(a0)
    80003028:	ef9d                	bnez	a5,80003066 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000302a:	85ce                	mv	a1,s3
    8000302c:	8526                	mv	a0,s1
    8000302e:	fffff097          	auipc	ra,0xfffff
    80003032:	482080e7          	jalr	1154(ra) # 800024b0 <sleep>
  while(ticks - ticks0 < n){
    80003036:	409c                	lw	a5,0(s1)
    80003038:	412787bb          	subw	a5,a5,s2
    8000303c:	fcc42703          	lw	a4,-52(s0)
    80003040:	fce7efe3          	bltu	a5,a4,8000301e <sys_sleep+0x50>
  }
  release(&tickslock);
    80003044:	00015517          	auipc	a0,0x15
    80003048:	92450513          	add	a0,a0,-1756 # 80017968 <tickslock>
    8000304c:	ffffe097          	auipc	ra,0xffffe
    80003050:	c64080e7          	jalr	-924(ra) # 80000cb0 <release>
  return 0;
    80003054:	4781                	li	a5,0
}
    80003056:	853e                	mv	a0,a5
    80003058:	70e2                	ld	ra,56(sp)
    8000305a:	7442                	ld	s0,48(sp)
    8000305c:	74a2                	ld	s1,40(sp)
    8000305e:	7902                	ld	s2,32(sp)
    80003060:	69e2                	ld	s3,24(sp)
    80003062:	6121                	add	sp,sp,64
    80003064:	8082                	ret
      release(&tickslock);
    80003066:	00015517          	auipc	a0,0x15
    8000306a:	90250513          	add	a0,a0,-1790 # 80017968 <tickslock>
    8000306e:	ffffe097          	auipc	ra,0xffffe
    80003072:	c42080e7          	jalr	-958(ra) # 80000cb0 <release>
      return -1;
    80003076:	57fd                	li	a5,-1
    80003078:	bff9                	j	80003056 <sys_sleep+0x88>

000000008000307a <sys_kill>:

uint64
sys_kill(void)
{
    8000307a:	1101                	add	sp,sp,-32
    8000307c:	ec06                	sd	ra,24(sp)
    8000307e:	e822                	sd	s0,16(sp)
    80003080:	1000                	add	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80003082:	fec40593          	add	a1,s0,-20
    80003086:	4501                	li	a0,0
    80003088:	00000097          	auipc	ra,0x0
    8000308c:	cd4080e7          	jalr	-812(ra) # 80002d5c <argint>
    80003090:	87aa                	mv	a5,a0
    return -1;
    80003092:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80003094:	0007c863          	bltz	a5,800030a4 <sys_kill+0x2a>
  return kill(pid);
    80003098:	fec42503          	lw	a0,-20(s0)
    8000309c:	fffff097          	auipc	ra,0xfffff
    800030a0:	5fe080e7          	jalr	1534(ra) # 8000269a <kill>
}
    800030a4:	60e2                	ld	ra,24(sp)
    800030a6:	6442                	ld	s0,16(sp)
    800030a8:	6105                	add	sp,sp,32
    800030aa:	8082                	ret

00000000800030ac <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800030ac:	1101                	add	sp,sp,-32
    800030ae:	ec06                	sd	ra,24(sp)
    800030b0:	e822                	sd	s0,16(sp)
    800030b2:	e426                	sd	s1,8(sp)
    800030b4:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800030b6:	00015517          	auipc	a0,0x15
    800030ba:	8b250513          	add	a0,a0,-1870 # 80017968 <tickslock>
    800030be:	ffffe097          	auipc	ra,0xffffe
    800030c2:	b3e080e7          	jalr	-1218(ra) # 80000bfc <acquire>
  xticks = ticks;
    800030c6:	00006497          	auipc	s1,0x6
    800030ca:	f5a4a483          	lw	s1,-166(s1) # 80009020 <ticks>
  release(&tickslock);
    800030ce:	00015517          	auipc	a0,0x15
    800030d2:	89a50513          	add	a0,a0,-1894 # 80017968 <tickslock>
    800030d6:	ffffe097          	auipc	ra,0xffffe
    800030da:	bda080e7          	jalr	-1062(ra) # 80000cb0 <release>
  return xticks;
}
    800030de:	02049513          	sll	a0,s1,0x20
    800030e2:	9101                	srl	a0,a0,0x20
    800030e4:	60e2                	ld	ra,24(sp)
    800030e6:	6442                	ld	s0,16(sp)
    800030e8:	64a2                	ld	s1,8(sp)
    800030ea:	6105                	add	sp,sp,32
    800030ec:	8082                	ret

00000000800030ee <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800030ee:	7179                	add	sp,sp,-48
    800030f0:	f406                	sd	ra,40(sp)
    800030f2:	f022                	sd	s0,32(sp)
    800030f4:	ec26                	sd	s1,24(sp)
    800030f6:	e84a                	sd	s2,16(sp)
    800030f8:	e44e                	sd	s3,8(sp)
    800030fa:	e052                	sd	s4,0(sp)
    800030fc:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800030fe:	00005597          	auipc	a1,0x5
    80003102:	41258593          	add	a1,a1,1042 # 80008510 <syscalls+0xb0>
    80003106:	00015517          	auipc	a0,0x15
    8000310a:	87a50513          	add	a0,a0,-1926 # 80017980 <bcache>
    8000310e:	ffffe097          	auipc	ra,0xffffe
    80003112:	a5e080e7          	jalr	-1442(ra) # 80000b6c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003116:	0001d797          	auipc	a5,0x1d
    8000311a:	86a78793          	add	a5,a5,-1942 # 8001f980 <bcache+0x8000>
    8000311e:	0001d717          	auipc	a4,0x1d
    80003122:	aca70713          	add	a4,a4,-1334 # 8001fbe8 <bcache+0x8268>
    80003126:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000312a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000312e:	00015497          	auipc	s1,0x15
    80003132:	86a48493          	add	s1,s1,-1942 # 80017998 <bcache+0x18>
    b->next = bcache.head.next;
    80003136:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003138:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000313a:	00005a17          	auipc	s4,0x5
    8000313e:	3dea0a13          	add	s4,s4,990 # 80008518 <syscalls+0xb8>
    b->next = bcache.head.next;
    80003142:	2b893783          	ld	a5,696(s2)
    80003146:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003148:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000314c:	85d2                	mv	a1,s4
    8000314e:	01048513          	add	a0,s1,16
    80003152:	00001097          	auipc	ra,0x1
    80003156:	480080e7          	jalr	1152(ra) # 800045d2 <initsleeplock>
    bcache.head.next->prev = b;
    8000315a:	2b893783          	ld	a5,696(s2)
    8000315e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003160:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003164:	45848493          	add	s1,s1,1112
    80003168:	fd349de3          	bne	s1,s3,80003142 <binit+0x54>
  }
}
    8000316c:	70a2                	ld	ra,40(sp)
    8000316e:	7402                	ld	s0,32(sp)
    80003170:	64e2                	ld	s1,24(sp)
    80003172:	6942                	ld	s2,16(sp)
    80003174:	69a2                	ld	s3,8(sp)
    80003176:	6a02                	ld	s4,0(sp)
    80003178:	6145                	add	sp,sp,48
    8000317a:	8082                	ret

000000008000317c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000317c:	7179                	add	sp,sp,-48
    8000317e:	f406                	sd	ra,40(sp)
    80003180:	f022                	sd	s0,32(sp)
    80003182:	ec26                	sd	s1,24(sp)
    80003184:	e84a                	sd	s2,16(sp)
    80003186:	e44e                	sd	s3,8(sp)
    80003188:	1800                	add	s0,sp,48
    8000318a:	892a                	mv	s2,a0
    8000318c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000318e:	00014517          	auipc	a0,0x14
    80003192:	7f250513          	add	a0,a0,2034 # 80017980 <bcache>
    80003196:	ffffe097          	auipc	ra,0xffffe
    8000319a:	a66080e7          	jalr	-1434(ra) # 80000bfc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000319e:	0001d497          	auipc	s1,0x1d
    800031a2:	a9a4b483          	ld	s1,-1382(s1) # 8001fc38 <bcache+0x82b8>
    800031a6:	0001d797          	auipc	a5,0x1d
    800031aa:	a4278793          	add	a5,a5,-1470 # 8001fbe8 <bcache+0x8268>
    800031ae:	02f48f63          	beq	s1,a5,800031ec <bread+0x70>
    800031b2:	873e                	mv	a4,a5
    800031b4:	a021                	j	800031bc <bread+0x40>
    800031b6:	68a4                	ld	s1,80(s1)
    800031b8:	02e48a63          	beq	s1,a4,800031ec <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800031bc:	449c                	lw	a5,8(s1)
    800031be:	ff279ce3          	bne	a5,s2,800031b6 <bread+0x3a>
    800031c2:	44dc                	lw	a5,12(s1)
    800031c4:	ff3799e3          	bne	a5,s3,800031b6 <bread+0x3a>
      b->refcnt++;
    800031c8:	40bc                	lw	a5,64(s1)
    800031ca:	2785                	addw	a5,a5,1
    800031cc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800031ce:	00014517          	auipc	a0,0x14
    800031d2:	7b250513          	add	a0,a0,1970 # 80017980 <bcache>
    800031d6:	ffffe097          	auipc	ra,0xffffe
    800031da:	ada080e7          	jalr	-1318(ra) # 80000cb0 <release>
      acquiresleep(&b->lock);
    800031de:	01048513          	add	a0,s1,16
    800031e2:	00001097          	auipc	ra,0x1
    800031e6:	42a080e7          	jalr	1066(ra) # 8000460c <acquiresleep>
      return b;
    800031ea:	a8b9                	j	80003248 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800031ec:	0001d497          	auipc	s1,0x1d
    800031f0:	a444b483          	ld	s1,-1468(s1) # 8001fc30 <bcache+0x82b0>
    800031f4:	0001d797          	auipc	a5,0x1d
    800031f8:	9f478793          	add	a5,a5,-1548 # 8001fbe8 <bcache+0x8268>
    800031fc:	00f48863          	beq	s1,a5,8000320c <bread+0x90>
    80003200:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003202:	40bc                	lw	a5,64(s1)
    80003204:	cf81                	beqz	a5,8000321c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003206:	64a4                	ld	s1,72(s1)
    80003208:	fee49de3          	bne	s1,a4,80003202 <bread+0x86>
  panic("bget: no buffers");
    8000320c:	00005517          	auipc	a0,0x5
    80003210:	31450513          	add	a0,a0,788 # 80008520 <syscalls+0xc0>
    80003214:	ffffd097          	auipc	ra,0xffffd
    80003218:	32e080e7          	jalr	814(ra) # 80000542 <panic>
      b->dev = dev;
    8000321c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003220:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003224:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003228:	4785                	li	a5,1
    8000322a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000322c:	00014517          	auipc	a0,0x14
    80003230:	75450513          	add	a0,a0,1876 # 80017980 <bcache>
    80003234:	ffffe097          	auipc	ra,0xffffe
    80003238:	a7c080e7          	jalr	-1412(ra) # 80000cb0 <release>
      acquiresleep(&b->lock);
    8000323c:	01048513          	add	a0,s1,16
    80003240:	00001097          	auipc	ra,0x1
    80003244:	3cc080e7          	jalr	972(ra) # 8000460c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003248:	409c                	lw	a5,0(s1)
    8000324a:	cb89                	beqz	a5,8000325c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000324c:	8526                	mv	a0,s1
    8000324e:	70a2                	ld	ra,40(sp)
    80003250:	7402                	ld	s0,32(sp)
    80003252:	64e2                	ld	s1,24(sp)
    80003254:	6942                	ld	s2,16(sp)
    80003256:	69a2                	ld	s3,8(sp)
    80003258:	6145                	add	sp,sp,48
    8000325a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000325c:	4581                	li	a1,0
    8000325e:	8526                	mv	a0,s1
    80003260:	00003097          	auipc	ra,0x3
    80003264:	f58080e7          	jalr	-168(ra) # 800061b8 <virtio_disk_rw>
    b->valid = 1;
    80003268:	4785                	li	a5,1
    8000326a:	c09c                	sw	a5,0(s1)
  return b;
    8000326c:	b7c5                	j	8000324c <bread+0xd0>

000000008000326e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000326e:	1101                	add	sp,sp,-32
    80003270:	ec06                	sd	ra,24(sp)
    80003272:	e822                	sd	s0,16(sp)
    80003274:	e426                	sd	s1,8(sp)
    80003276:	1000                	add	s0,sp,32
    80003278:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000327a:	0541                	add	a0,a0,16
    8000327c:	00001097          	auipc	ra,0x1
    80003280:	42a080e7          	jalr	1066(ra) # 800046a6 <holdingsleep>
    80003284:	cd01                	beqz	a0,8000329c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003286:	4585                	li	a1,1
    80003288:	8526                	mv	a0,s1
    8000328a:	00003097          	auipc	ra,0x3
    8000328e:	f2e080e7          	jalr	-210(ra) # 800061b8 <virtio_disk_rw>
}
    80003292:	60e2                	ld	ra,24(sp)
    80003294:	6442                	ld	s0,16(sp)
    80003296:	64a2                	ld	s1,8(sp)
    80003298:	6105                	add	sp,sp,32
    8000329a:	8082                	ret
    panic("bwrite");
    8000329c:	00005517          	auipc	a0,0x5
    800032a0:	29c50513          	add	a0,a0,668 # 80008538 <syscalls+0xd8>
    800032a4:	ffffd097          	auipc	ra,0xffffd
    800032a8:	29e080e7          	jalr	670(ra) # 80000542 <panic>

00000000800032ac <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800032ac:	1101                	add	sp,sp,-32
    800032ae:	ec06                	sd	ra,24(sp)
    800032b0:	e822                	sd	s0,16(sp)
    800032b2:	e426                	sd	s1,8(sp)
    800032b4:	e04a                	sd	s2,0(sp)
    800032b6:	1000                	add	s0,sp,32
    800032b8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800032ba:	01050913          	add	s2,a0,16
    800032be:	854a                	mv	a0,s2
    800032c0:	00001097          	auipc	ra,0x1
    800032c4:	3e6080e7          	jalr	998(ra) # 800046a6 <holdingsleep>
    800032c8:	c925                	beqz	a0,80003338 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800032ca:	854a                	mv	a0,s2
    800032cc:	00001097          	auipc	ra,0x1
    800032d0:	396080e7          	jalr	918(ra) # 80004662 <releasesleep>

  acquire(&bcache.lock);
    800032d4:	00014517          	auipc	a0,0x14
    800032d8:	6ac50513          	add	a0,a0,1708 # 80017980 <bcache>
    800032dc:	ffffe097          	auipc	ra,0xffffe
    800032e0:	920080e7          	jalr	-1760(ra) # 80000bfc <acquire>
  b->refcnt--;
    800032e4:	40bc                	lw	a5,64(s1)
    800032e6:	37fd                	addw	a5,a5,-1
    800032e8:	0007871b          	sext.w	a4,a5
    800032ec:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800032ee:	e71d                	bnez	a4,8000331c <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800032f0:	68b8                	ld	a4,80(s1)
    800032f2:	64bc                	ld	a5,72(s1)
    800032f4:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800032f6:	68b8                	ld	a4,80(s1)
    800032f8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800032fa:	0001c797          	auipc	a5,0x1c
    800032fe:	68678793          	add	a5,a5,1670 # 8001f980 <bcache+0x8000>
    80003302:	2b87b703          	ld	a4,696(a5)
    80003306:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003308:	0001d717          	auipc	a4,0x1d
    8000330c:	8e070713          	add	a4,a4,-1824 # 8001fbe8 <bcache+0x8268>
    80003310:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003312:	2b87b703          	ld	a4,696(a5)
    80003316:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003318:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000331c:	00014517          	auipc	a0,0x14
    80003320:	66450513          	add	a0,a0,1636 # 80017980 <bcache>
    80003324:	ffffe097          	auipc	ra,0xffffe
    80003328:	98c080e7          	jalr	-1652(ra) # 80000cb0 <release>
}
    8000332c:	60e2                	ld	ra,24(sp)
    8000332e:	6442                	ld	s0,16(sp)
    80003330:	64a2                	ld	s1,8(sp)
    80003332:	6902                	ld	s2,0(sp)
    80003334:	6105                	add	sp,sp,32
    80003336:	8082                	ret
    panic("brelse");
    80003338:	00005517          	auipc	a0,0x5
    8000333c:	20850513          	add	a0,a0,520 # 80008540 <syscalls+0xe0>
    80003340:	ffffd097          	auipc	ra,0xffffd
    80003344:	202080e7          	jalr	514(ra) # 80000542 <panic>

0000000080003348 <bpin>:

void
bpin(struct buf *b) {
    80003348:	1101                	add	sp,sp,-32
    8000334a:	ec06                	sd	ra,24(sp)
    8000334c:	e822                	sd	s0,16(sp)
    8000334e:	e426                	sd	s1,8(sp)
    80003350:	1000                	add	s0,sp,32
    80003352:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003354:	00014517          	auipc	a0,0x14
    80003358:	62c50513          	add	a0,a0,1580 # 80017980 <bcache>
    8000335c:	ffffe097          	auipc	ra,0xffffe
    80003360:	8a0080e7          	jalr	-1888(ra) # 80000bfc <acquire>
  b->refcnt++;
    80003364:	40bc                	lw	a5,64(s1)
    80003366:	2785                	addw	a5,a5,1
    80003368:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000336a:	00014517          	auipc	a0,0x14
    8000336e:	61650513          	add	a0,a0,1558 # 80017980 <bcache>
    80003372:	ffffe097          	auipc	ra,0xffffe
    80003376:	93e080e7          	jalr	-1730(ra) # 80000cb0 <release>
}
    8000337a:	60e2                	ld	ra,24(sp)
    8000337c:	6442                	ld	s0,16(sp)
    8000337e:	64a2                	ld	s1,8(sp)
    80003380:	6105                	add	sp,sp,32
    80003382:	8082                	ret

0000000080003384 <bunpin>:

void
bunpin(struct buf *b) {
    80003384:	1101                	add	sp,sp,-32
    80003386:	ec06                	sd	ra,24(sp)
    80003388:	e822                	sd	s0,16(sp)
    8000338a:	e426                	sd	s1,8(sp)
    8000338c:	1000                	add	s0,sp,32
    8000338e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003390:	00014517          	auipc	a0,0x14
    80003394:	5f050513          	add	a0,a0,1520 # 80017980 <bcache>
    80003398:	ffffe097          	auipc	ra,0xffffe
    8000339c:	864080e7          	jalr	-1948(ra) # 80000bfc <acquire>
  b->refcnt--;
    800033a0:	40bc                	lw	a5,64(s1)
    800033a2:	37fd                	addw	a5,a5,-1
    800033a4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800033a6:	00014517          	auipc	a0,0x14
    800033aa:	5da50513          	add	a0,a0,1498 # 80017980 <bcache>
    800033ae:	ffffe097          	auipc	ra,0xffffe
    800033b2:	902080e7          	jalr	-1790(ra) # 80000cb0 <release>
}
    800033b6:	60e2                	ld	ra,24(sp)
    800033b8:	6442                	ld	s0,16(sp)
    800033ba:	64a2                	ld	s1,8(sp)
    800033bc:	6105                	add	sp,sp,32
    800033be:	8082                	ret

00000000800033c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800033c0:	1101                	add	sp,sp,-32
    800033c2:	ec06                	sd	ra,24(sp)
    800033c4:	e822                	sd	s0,16(sp)
    800033c6:	e426                	sd	s1,8(sp)
    800033c8:	e04a                	sd	s2,0(sp)
    800033ca:	1000                	add	s0,sp,32
    800033cc:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800033ce:	00d5d59b          	srlw	a1,a1,0xd
    800033d2:	0001d797          	auipc	a5,0x1d
    800033d6:	c8a7a783          	lw	a5,-886(a5) # 8002005c <sb+0x1c>
    800033da:	9dbd                	addw	a1,a1,a5
    800033dc:	00000097          	auipc	ra,0x0
    800033e0:	da0080e7          	jalr	-608(ra) # 8000317c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800033e4:	0074f713          	and	a4,s1,7
    800033e8:	4785                	li	a5,1
    800033ea:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800033ee:	14ce                	sll	s1,s1,0x33
    800033f0:	90d9                	srl	s1,s1,0x36
    800033f2:	00950733          	add	a4,a0,s1
    800033f6:	05874703          	lbu	a4,88(a4)
    800033fa:	00e7f6b3          	and	a3,a5,a4
    800033fe:	c69d                	beqz	a3,8000342c <bfree+0x6c>
    80003400:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003402:	94aa                	add	s1,s1,a0
    80003404:	fff7c793          	not	a5,a5
    80003408:	8f7d                	and	a4,a4,a5
    8000340a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000340e:	00001097          	auipc	ra,0x1
    80003412:	0d8080e7          	jalr	216(ra) # 800044e6 <log_write>
  brelse(bp);
    80003416:	854a                	mv	a0,s2
    80003418:	00000097          	auipc	ra,0x0
    8000341c:	e94080e7          	jalr	-364(ra) # 800032ac <brelse>
}
    80003420:	60e2                	ld	ra,24(sp)
    80003422:	6442                	ld	s0,16(sp)
    80003424:	64a2                	ld	s1,8(sp)
    80003426:	6902                	ld	s2,0(sp)
    80003428:	6105                	add	sp,sp,32
    8000342a:	8082                	ret
    panic("freeing free block");
    8000342c:	00005517          	auipc	a0,0x5
    80003430:	11c50513          	add	a0,a0,284 # 80008548 <syscalls+0xe8>
    80003434:	ffffd097          	auipc	ra,0xffffd
    80003438:	10e080e7          	jalr	270(ra) # 80000542 <panic>

000000008000343c <balloc>:
{
    8000343c:	711d                	add	sp,sp,-96
    8000343e:	ec86                	sd	ra,88(sp)
    80003440:	e8a2                	sd	s0,80(sp)
    80003442:	e4a6                	sd	s1,72(sp)
    80003444:	e0ca                	sd	s2,64(sp)
    80003446:	fc4e                	sd	s3,56(sp)
    80003448:	f852                	sd	s4,48(sp)
    8000344a:	f456                	sd	s5,40(sp)
    8000344c:	f05a                	sd	s6,32(sp)
    8000344e:	ec5e                	sd	s7,24(sp)
    80003450:	e862                	sd	s8,16(sp)
    80003452:	e466                	sd	s9,8(sp)
    80003454:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003456:	0001d797          	auipc	a5,0x1d
    8000345a:	bee7a783          	lw	a5,-1042(a5) # 80020044 <sb+0x4>
    8000345e:	cbc1                	beqz	a5,800034ee <balloc+0xb2>
    80003460:	8baa                	mv	s7,a0
    80003462:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003464:	0001db17          	auipc	s6,0x1d
    80003468:	bdcb0b13          	add	s6,s6,-1060 # 80020040 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000346c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000346e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003470:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003472:	6c89                	lui	s9,0x2
    80003474:	a831                	j	80003490 <balloc+0x54>
    brelse(bp);
    80003476:	854a                	mv	a0,s2
    80003478:	00000097          	auipc	ra,0x0
    8000347c:	e34080e7          	jalr	-460(ra) # 800032ac <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003480:	015c87bb          	addw	a5,s9,s5
    80003484:	00078a9b          	sext.w	s5,a5
    80003488:	004b2703          	lw	a4,4(s6)
    8000348c:	06eaf163          	bgeu	s5,a4,800034ee <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80003490:	41fad79b          	sraw	a5,s5,0x1f
    80003494:	0137d79b          	srlw	a5,a5,0x13
    80003498:	015787bb          	addw	a5,a5,s5
    8000349c:	40d7d79b          	sraw	a5,a5,0xd
    800034a0:	01cb2583          	lw	a1,28(s6)
    800034a4:	9dbd                	addw	a1,a1,a5
    800034a6:	855e                	mv	a0,s7
    800034a8:	00000097          	auipc	ra,0x0
    800034ac:	cd4080e7          	jalr	-812(ra) # 8000317c <bread>
    800034b0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800034b2:	004b2503          	lw	a0,4(s6)
    800034b6:	000a849b          	sext.w	s1,s5
    800034ba:	8762                	mv	a4,s8
    800034bc:	faa4fde3          	bgeu	s1,a0,80003476 <balloc+0x3a>
      m = 1 << (bi % 8);
    800034c0:	00777693          	and	a3,a4,7
    800034c4:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800034c8:	41f7579b          	sraw	a5,a4,0x1f
    800034cc:	01d7d79b          	srlw	a5,a5,0x1d
    800034d0:	9fb9                	addw	a5,a5,a4
    800034d2:	4037d79b          	sraw	a5,a5,0x3
    800034d6:	00f90633          	add	a2,s2,a5
    800034da:	05864603          	lbu	a2,88(a2)
    800034de:	00c6f5b3          	and	a1,a3,a2
    800034e2:	cd91                	beqz	a1,800034fe <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800034e4:	2705                	addw	a4,a4,1
    800034e6:	2485                	addw	s1,s1,1
    800034e8:	fd471ae3          	bne	a4,s4,800034bc <balloc+0x80>
    800034ec:	b769                	j	80003476 <balloc+0x3a>
  panic("balloc: out of blocks");
    800034ee:	00005517          	auipc	a0,0x5
    800034f2:	07250513          	add	a0,a0,114 # 80008560 <syscalls+0x100>
    800034f6:	ffffd097          	auipc	ra,0xffffd
    800034fa:	04c080e7          	jalr	76(ra) # 80000542 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800034fe:	97ca                	add	a5,a5,s2
    80003500:	8e55                	or	a2,a2,a3
    80003502:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003506:	854a                	mv	a0,s2
    80003508:	00001097          	auipc	ra,0x1
    8000350c:	fde080e7          	jalr	-34(ra) # 800044e6 <log_write>
        brelse(bp);
    80003510:	854a                	mv	a0,s2
    80003512:	00000097          	auipc	ra,0x0
    80003516:	d9a080e7          	jalr	-614(ra) # 800032ac <brelse>
  bp = bread(dev, bno);
    8000351a:	85a6                	mv	a1,s1
    8000351c:	855e                	mv	a0,s7
    8000351e:	00000097          	auipc	ra,0x0
    80003522:	c5e080e7          	jalr	-930(ra) # 8000317c <bread>
    80003526:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003528:	40000613          	li	a2,1024
    8000352c:	4581                	li	a1,0
    8000352e:	05850513          	add	a0,a0,88
    80003532:	ffffd097          	auipc	ra,0xffffd
    80003536:	7c6080e7          	jalr	1990(ra) # 80000cf8 <memset>
  log_write(bp);
    8000353a:	854a                	mv	a0,s2
    8000353c:	00001097          	auipc	ra,0x1
    80003540:	faa080e7          	jalr	-86(ra) # 800044e6 <log_write>
  brelse(bp);
    80003544:	854a                	mv	a0,s2
    80003546:	00000097          	auipc	ra,0x0
    8000354a:	d66080e7          	jalr	-666(ra) # 800032ac <brelse>
}
    8000354e:	8526                	mv	a0,s1
    80003550:	60e6                	ld	ra,88(sp)
    80003552:	6446                	ld	s0,80(sp)
    80003554:	64a6                	ld	s1,72(sp)
    80003556:	6906                	ld	s2,64(sp)
    80003558:	79e2                	ld	s3,56(sp)
    8000355a:	7a42                	ld	s4,48(sp)
    8000355c:	7aa2                	ld	s5,40(sp)
    8000355e:	7b02                	ld	s6,32(sp)
    80003560:	6be2                	ld	s7,24(sp)
    80003562:	6c42                	ld	s8,16(sp)
    80003564:	6ca2                	ld	s9,8(sp)
    80003566:	6125                	add	sp,sp,96
    80003568:	8082                	ret

000000008000356a <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000356a:	7179                	add	sp,sp,-48
    8000356c:	f406                	sd	ra,40(sp)
    8000356e:	f022                	sd	s0,32(sp)
    80003570:	ec26                	sd	s1,24(sp)
    80003572:	e84a                	sd	s2,16(sp)
    80003574:	e44e                	sd	s3,8(sp)
    80003576:	e052                	sd	s4,0(sp)
    80003578:	1800                	add	s0,sp,48
    8000357a:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000357c:	47ad                	li	a5,11
    8000357e:	04b7fe63          	bgeu	a5,a1,800035da <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003582:	ff45849b          	addw	s1,a1,-12
    80003586:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000358a:	0ff00793          	li	a5,255
    8000358e:	0ae7e463          	bltu	a5,a4,80003636 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003592:	08052583          	lw	a1,128(a0)
    80003596:	c5b5                	beqz	a1,80003602 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003598:	00092503          	lw	a0,0(s2)
    8000359c:	00000097          	auipc	ra,0x0
    800035a0:	be0080e7          	jalr	-1056(ra) # 8000317c <bread>
    800035a4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800035a6:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    800035aa:	02049713          	sll	a4,s1,0x20
    800035ae:	01e75593          	srl	a1,a4,0x1e
    800035b2:	00b784b3          	add	s1,a5,a1
    800035b6:	0004a983          	lw	s3,0(s1)
    800035ba:	04098e63          	beqz	s3,80003616 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800035be:	8552                	mv	a0,s4
    800035c0:	00000097          	auipc	ra,0x0
    800035c4:	cec080e7          	jalr	-788(ra) # 800032ac <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800035c8:	854e                	mv	a0,s3
    800035ca:	70a2                	ld	ra,40(sp)
    800035cc:	7402                	ld	s0,32(sp)
    800035ce:	64e2                	ld	s1,24(sp)
    800035d0:	6942                	ld	s2,16(sp)
    800035d2:	69a2                	ld	s3,8(sp)
    800035d4:	6a02                	ld	s4,0(sp)
    800035d6:	6145                	add	sp,sp,48
    800035d8:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800035da:	02059793          	sll	a5,a1,0x20
    800035de:	01e7d593          	srl	a1,a5,0x1e
    800035e2:	00b504b3          	add	s1,a0,a1
    800035e6:	0504a983          	lw	s3,80(s1)
    800035ea:	fc099fe3          	bnez	s3,800035c8 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800035ee:	4108                	lw	a0,0(a0)
    800035f0:	00000097          	auipc	ra,0x0
    800035f4:	e4c080e7          	jalr	-436(ra) # 8000343c <balloc>
    800035f8:	0005099b          	sext.w	s3,a0
    800035fc:	0534a823          	sw	s3,80(s1)
    80003600:	b7e1                	j	800035c8 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003602:	4108                	lw	a0,0(a0)
    80003604:	00000097          	auipc	ra,0x0
    80003608:	e38080e7          	jalr	-456(ra) # 8000343c <balloc>
    8000360c:	0005059b          	sext.w	a1,a0
    80003610:	08b92023          	sw	a1,128(s2)
    80003614:	b751                	j	80003598 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003616:	00092503          	lw	a0,0(s2)
    8000361a:	00000097          	auipc	ra,0x0
    8000361e:	e22080e7          	jalr	-478(ra) # 8000343c <balloc>
    80003622:	0005099b          	sext.w	s3,a0
    80003626:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000362a:	8552                	mv	a0,s4
    8000362c:	00001097          	auipc	ra,0x1
    80003630:	eba080e7          	jalr	-326(ra) # 800044e6 <log_write>
    80003634:	b769                	j	800035be <bmap+0x54>
  panic("bmap: out of range");
    80003636:	00005517          	auipc	a0,0x5
    8000363a:	f4250513          	add	a0,a0,-190 # 80008578 <syscalls+0x118>
    8000363e:	ffffd097          	auipc	ra,0xffffd
    80003642:	f04080e7          	jalr	-252(ra) # 80000542 <panic>

0000000080003646 <iget>:
{
    80003646:	7179                	add	sp,sp,-48
    80003648:	f406                	sd	ra,40(sp)
    8000364a:	f022                	sd	s0,32(sp)
    8000364c:	ec26                	sd	s1,24(sp)
    8000364e:	e84a                	sd	s2,16(sp)
    80003650:	e44e                	sd	s3,8(sp)
    80003652:	e052                	sd	s4,0(sp)
    80003654:	1800                	add	s0,sp,48
    80003656:	89aa                	mv	s3,a0
    80003658:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    8000365a:	0001d517          	auipc	a0,0x1d
    8000365e:	a0650513          	add	a0,a0,-1530 # 80020060 <icache>
    80003662:	ffffd097          	auipc	ra,0xffffd
    80003666:	59a080e7          	jalr	1434(ra) # 80000bfc <acquire>
  empty = 0;
    8000366a:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    8000366c:	0001d497          	auipc	s1,0x1d
    80003670:	a0c48493          	add	s1,s1,-1524 # 80020078 <icache+0x18>
    80003674:	0001e697          	auipc	a3,0x1e
    80003678:	49468693          	add	a3,a3,1172 # 80021b08 <log>
    8000367c:	a039                	j	8000368a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000367e:	02090b63          	beqz	s2,800036b4 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003682:	08848493          	add	s1,s1,136
    80003686:	02d48a63          	beq	s1,a3,800036ba <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000368a:	449c                	lw	a5,8(s1)
    8000368c:	fef059e3          	blez	a5,8000367e <iget+0x38>
    80003690:	4098                	lw	a4,0(s1)
    80003692:	ff3716e3          	bne	a4,s3,8000367e <iget+0x38>
    80003696:	40d8                	lw	a4,4(s1)
    80003698:	ff4713e3          	bne	a4,s4,8000367e <iget+0x38>
      ip->ref++;
    8000369c:	2785                	addw	a5,a5,1
    8000369e:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    800036a0:	0001d517          	auipc	a0,0x1d
    800036a4:	9c050513          	add	a0,a0,-1600 # 80020060 <icache>
    800036a8:	ffffd097          	auipc	ra,0xffffd
    800036ac:	608080e7          	jalr	1544(ra) # 80000cb0 <release>
      return ip;
    800036b0:	8926                	mv	s2,s1
    800036b2:	a03d                	j	800036e0 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800036b4:	f7f9                	bnez	a5,80003682 <iget+0x3c>
    800036b6:	8926                	mv	s2,s1
    800036b8:	b7e9                	j	80003682 <iget+0x3c>
  if(empty == 0)
    800036ba:	02090c63          	beqz	s2,800036f2 <iget+0xac>
  ip->dev = dev;
    800036be:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800036c2:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800036c6:	4785                	li	a5,1
    800036c8:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800036cc:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    800036d0:	0001d517          	auipc	a0,0x1d
    800036d4:	99050513          	add	a0,a0,-1648 # 80020060 <icache>
    800036d8:	ffffd097          	auipc	ra,0xffffd
    800036dc:	5d8080e7          	jalr	1496(ra) # 80000cb0 <release>
}
    800036e0:	854a                	mv	a0,s2
    800036e2:	70a2                	ld	ra,40(sp)
    800036e4:	7402                	ld	s0,32(sp)
    800036e6:	64e2                	ld	s1,24(sp)
    800036e8:	6942                	ld	s2,16(sp)
    800036ea:	69a2                	ld	s3,8(sp)
    800036ec:	6a02                	ld	s4,0(sp)
    800036ee:	6145                	add	sp,sp,48
    800036f0:	8082                	ret
    panic("iget: no inodes");
    800036f2:	00005517          	auipc	a0,0x5
    800036f6:	e9e50513          	add	a0,a0,-354 # 80008590 <syscalls+0x130>
    800036fa:	ffffd097          	auipc	ra,0xffffd
    800036fe:	e48080e7          	jalr	-440(ra) # 80000542 <panic>

0000000080003702 <fsinit>:
fsinit(int dev) {
    80003702:	7179                	add	sp,sp,-48
    80003704:	f406                	sd	ra,40(sp)
    80003706:	f022                	sd	s0,32(sp)
    80003708:	ec26                	sd	s1,24(sp)
    8000370a:	e84a                	sd	s2,16(sp)
    8000370c:	e44e                	sd	s3,8(sp)
    8000370e:	1800                	add	s0,sp,48
    80003710:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003712:	4585                	li	a1,1
    80003714:	00000097          	auipc	ra,0x0
    80003718:	a68080e7          	jalr	-1432(ra) # 8000317c <bread>
    8000371c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000371e:	0001d997          	auipc	s3,0x1d
    80003722:	92298993          	add	s3,s3,-1758 # 80020040 <sb>
    80003726:	02000613          	li	a2,32
    8000372a:	05850593          	add	a1,a0,88
    8000372e:	854e                	mv	a0,s3
    80003730:	ffffd097          	auipc	ra,0xffffd
    80003734:	624080e7          	jalr	1572(ra) # 80000d54 <memmove>
  brelse(bp);
    80003738:	8526                	mv	a0,s1
    8000373a:	00000097          	auipc	ra,0x0
    8000373e:	b72080e7          	jalr	-1166(ra) # 800032ac <brelse>
  if(sb.magic != FSMAGIC)
    80003742:	0009a703          	lw	a4,0(s3)
    80003746:	102037b7          	lui	a5,0x10203
    8000374a:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000374e:	02f71263          	bne	a4,a5,80003772 <fsinit+0x70>
  initlog(dev, &sb);
    80003752:	0001d597          	auipc	a1,0x1d
    80003756:	8ee58593          	add	a1,a1,-1810 # 80020040 <sb>
    8000375a:	854a                	mv	a0,s2
    8000375c:	00001097          	auipc	ra,0x1
    80003760:	b24080e7          	jalr	-1244(ra) # 80004280 <initlog>
}
    80003764:	70a2                	ld	ra,40(sp)
    80003766:	7402                	ld	s0,32(sp)
    80003768:	64e2                	ld	s1,24(sp)
    8000376a:	6942                	ld	s2,16(sp)
    8000376c:	69a2                	ld	s3,8(sp)
    8000376e:	6145                	add	sp,sp,48
    80003770:	8082                	ret
    panic("invalid file system");
    80003772:	00005517          	auipc	a0,0x5
    80003776:	e2e50513          	add	a0,a0,-466 # 800085a0 <syscalls+0x140>
    8000377a:	ffffd097          	auipc	ra,0xffffd
    8000377e:	dc8080e7          	jalr	-568(ra) # 80000542 <panic>

0000000080003782 <iinit>:
{
    80003782:	7179                	add	sp,sp,-48
    80003784:	f406                	sd	ra,40(sp)
    80003786:	f022                	sd	s0,32(sp)
    80003788:	ec26                	sd	s1,24(sp)
    8000378a:	e84a                	sd	s2,16(sp)
    8000378c:	e44e                	sd	s3,8(sp)
    8000378e:	1800                	add	s0,sp,48
  initlock(&icache.lock, "icache");
    80003790:	00005597          	auipc	a1,0x5
    80003794:	e2858593          	add	a1,a1,-472 # 800085b8 <syscalls+0x158>
    80003798:	0001d517          	auipc	a0,0x1d
    8000379c:	8c850513          	add	a0,a0,-1848 # 80020060 <icache>
    800037a0:	ffffd097          	auipc	ra,0xffffd
    800037a4:	3cc080e7          	jalr	972(ra) # 80000b6c <initlock>
  for(i = 0; i < NINODE; i++) {
    800037a8:	0001d497          	auipc	s1,0x1d
    800037ac:	8e048493          	add	s1,s1,-1824 # 80020088 <icache+0x28>
    800037b0:	0001e997          	auipc	s3,0x1e
    800037b4:	36898993          	add	s3,s3,872 # 80021b18 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    800037b8:	00005917          	auipc	s2,0x5
    800037bc:	e0890913          	add	s2,s2,-504 # 800085c0 <syscalls+0x160>
    800037c0:	85ca                	mv	a1,s2
    800037c2:	8526                	mv	a0,s1
    800037c4:	00001097          	auipc	ra,0x1
    800037c8:	e0e080e7          	jalr	-498(ra) # 800045d2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800037cc:	08848493          	add	s1,s1,136
    800037d0:	ff3498e3          	bne	s1,s3,800037c0 <iinit+0x3e>
}
    800037d4:	70a2                	ld	ra,40(sp)
    800037d6:	7402                	ld	s0,32(sp)
    800037d8:	64e2                	ld	s1,24(sp)
    800037da:	6942                	ld	s2,16(sp)
    800037dc:	69a2                	ld	s3,8(sp)
    800037de:	6145                	add	sp,sp,48
    800037e0:	8082                	ret

00000000800037e2 <ialloc>:
{
    800037e2:	7139                	add	sp,sp,-64
    800037e4:	fc06                	sd	ra,56(sp)
    800037e6:	f822                	sd	s0,48(sp)
    800037e8:	f426                	sd	s1,40(sp)
    800037ea:	f04a                	sd	s2,32(sp)
    800037ec:	ec4e                	sd	s3,24(sp)
    800037ee:	e852                	sd	s4,16(sp)
    800037f0:	e456                	sd	s5,8(sp)
    800037f2:	e05a                	sd	s6,0(sp)
    800037f4:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800037f6:	0001d717          	auipc	a4,0x1d
    800037fa:	85672703          	lw	a4,-1962(a4) # 8002004c <sb+0xc>
    800037fe:	4785                	li	a5,1
    80003800:	04e7f863          	bgeu	a5,a4,80003850 <ialloc+0x6e>
    80003804:	8aaa                	mv	s5,a0
    80003806:	8b2e                	mv	s6,a1
    80003808:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000380a:	0001da17          	auipc	s4,0x1d
    8000380e:	836a0a13          	add	s4,s4,-1994 # 80020040 <sb>
    80003812:	00495593          	srl	a1,s2,0x4
    80003816:	018a2783          	lw	a5,24(s4)
    8000381a:	9dbd                	addw	a1,a1,a5
    8000381c:	8556                	mv	a0,s5
    8000381e:	00000097          	auipc	ra,0x0
    80003822:	95e080e7          	jalr	-1698(ra) # 8000317c <bread>
    80003826:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003828:	05850993          	add	s3,a0,88
    8000382c:	00f97793          	and	a5,s2,15
    80003830:	079a                	sll	a5,a5,0x6
    80003832:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003834:	00099783          	lh	a5,0(s3)
    80003838:	c785                	beqz	a5,80003860 <ialloc+0x7e>
    brelse(bp);
    8000383a:	00000097          	auipc	ra,0x0
    8000383e:	a72080e7          	jalr	-1422(ra) # 800032ac <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003842:	0905                	add	s2,s2,1
    80003844:	00ca2703          	lw	a4,12(s4)
    80003848:	0009079b          	sext.w	a5,s2
    8000384c:	fce7e3e3          	bltu	a5,a4,80003812 <ialloc+0x30>
  panic("ialloc: no inodes");
    80003850:	00005517          	auipc	a0,0x5
    80003854:	d7850513          	add	a0,a0,-648 # 800085c8 <syscalls+0x168>
    80003858:	ffffd097          	auipc	ra,0xffffd
    8000385c:	cea080e7          	jalr	-790(ra) # 80000542 <panic>
      memset(dip, 0, sizeof(*dip));
    80003860:	04000613          	li	a2,64
    80003864:	4581                	li	a1,0
    80003866:	854e                	mv	a0,s3
    80003868:	ffffd097          	auipc	ra,0xffffd
    8000386c:	490080e7          	jalr	1168(ra) # 80000cf8 <memset>
      dip->type = type;
    80003870:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003874:	8526                	mv	a0,s1
    80003876:	00001097          	auipc	ra,0x1
    8000387a:	c70080e7          	jalr	-912(ra) # 800044e6 <log_write>
      brelse(bp);
    8000387e:	8526                	mv	a0,s1
    80003880:	00000097          	auipc	ra,0x0
    80003884:	a2c080e7          	jalr	-1492(ra) # 800032ac <brelse>
      return iget(dev, inum);
    80003888:	0009059b          	sext.w	a1,s2
    8000388c:	8556                	mv	a0,s5
    8000388e:	00000097          	auipc	ra,0x0
    80003892:	db8080e7          	jalr	-584(ra) # 80003646 <iget>
}
    80003896:	70e2                	ld	ra,56(sp)
    80003898:	7442                	ld	s0,48(sp)
    8000389a:	74a2                	ld	s1,40(sp)
    8000389c:	7902                	ld	s2,32(sp)
    8000389e:	69e2                	ld	s3,24(sp)
    800038a0:	6a42                	ld	s4,16(sp)
    800038a2:	6aa2                	ld	s5,8(sp)
    800038a4:	6b02                	ld	s6,0(sp)
    800038a6:	6121                	add	sp,sp,64
    800038a8:	8082                	ret

00000000800038aa <iupdate>:
{
    800038aa:	1101                	add	sp,sp,-32
    800038ac:	ec06                	sd	ra,24(sp)
    800038ae:	e822                	sd	s0,16(sp)
    800038b0:	e426                	sd	s1,8(sp)
    800038b2:	e04a                	sd	s2,0(sp)
    800038b4:	1000                	add	s0,sp,32
    800038b6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800038b8:	415c                	lw	a5,4(a0)
    800038ba:	0047d79b          	srlw	a5,a5,0x4
    800038be:	0001c597          	auipc	a1,0x1c
    800038c2:	79a5a583          	lw	a1,1946(a1) # 80020058 <sb+0x18>
    800038c6:	9dbd                	addw	a1,a1,a5
    800038c8:	4108                	lw	a0,0(a0)
    800038ca:	00000097          	auipc	ra,0x0
    800038ce:	8b2080e7          	jalr	-1870(ra) # 8000317c <bread>
    800038d2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800038d4:	05850793          	add	a5,a0,88
    800038d8:	40d8                	lw	a4,4(s1)
    800038da:	8b3d                	and	a4,a4,15
    800038dc:	071a                	sll	a4,a4,0x6
    800038de:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800038e0:	04449703          	lh	a4,68(s1)
    800038e4:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800038e8:	04649703          	lh	a4,70(s1)
    800038ec:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800038f0:	04849703          	lh	a4,72(s1)
    800038f4:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800038f8:	04a49703          	lh	a4,74(s1)
    800038fc:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003900:	44f8                	lw	a4,76(s1)
    80003902:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003904:	03400613          	li	a2,52
    80003908:	05048593          	add	a1,s1,80
    8000390c:	00c78513          	add	a0,a5,12
    80003910:	ffffd097          	auipc	ra,0xffffd
    80003914:	444080e7          	jalr	1092(ra) # 80000d54 <memmove>
  log_write(bp);
    80003918:	854a                	mv	a0,s2
    8000391a:	00001097          	auipc	ra,0x1
    8000391e:	bcc080e7          	jalr	-1076(ra) # 800044e6 <log_write>
  brelse(bp);
    80003922:	854a                	mv	a0,s2
    80003924:	00000097          	auipc	ra,0x0
    80003928:	988080e7          	jalr	-1656(ra) # 800032ac <brelse>
}
    8000392c:	60e2                	ld	ra,24(sp)
    8000392e:	6442                	ld	s0,16(sp)
    80003930:	64a2                	ld	s1,8(sp)
    80003932:	6902                	ld	s2,0(sp)
    80003934:	6105                	add	sp,sp,32
    80003936:	8082                	ret

0000000080003938 <idup>:
{
    80003938:	1101                	add	sp,sp,-32
    8000393a:	ec06                	sd	ra,24(sp)
    8000393c:	e822                	sd	s0,16(sp)
    8000393e:	e426                	sd	s1,8(sp)
    80003940:	1000                	add	s0,sp,32
    80003942:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003944:	0001c517          	auipc	a0,0x1c
    80003948:	71c50513          	add	a0,a0,1820 # 80020060 <icache>
    8000394c:	ffffd097          	auipc	ra,0xffffd
    80003950:	2b0080e7          	jalr	688(ra) # 80000bfc <acquire>
  ip->ref++;
    80003954:	449c                	lw	a5,8(s1)
    80003956:	2785                	addw	a5,a5,1
    80003958:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    8000395a:	0001c517          	auipc	a0,0x1c
    8000395e:	70650513          	add	a0,a0,1798 # 80020060 <icache>
    80003962:	ffffd097          	auipc	ra,0xffffd
    80003966:	34e080e7          	jalr	846(ra) # 80000cb0 <release>
}
    8000396a:	8526                	mv	a0,s1
    8000396c:	60e2                	ld	ra,24(sp)
    8000396e:	6442                	ld	s0,16(sp)
    80003970:	64a2                	ld	s1,8(sp)
    80003972:	6105                	add	sp,sp,32
    80003974:	8082                	ret

0000000080003976 <ilock>:
{
    80003976:	1101                	add	sp,sp,-32
    80003978:	ec06                	sd	ra,24(sp)
    8000397a:	e822                	sd	s0,16(sp)
    8000397c:	e426                	sd	s1,8(sp)
    8000397e:	e04a                	sd	s2,0(sp)
    80003980:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003982:	c115                	beqz	a0,800039a6 <ilock+0x30>
    80003984:	84aa                	mv	s1,a0
    80003986:	451c                	lw	a5,8(a0)
    80003988:	00f05f63          	blez	a5,800039a6 <ilock+0x30>
  acquiresleep(&ip->lock);
    8000398c:	0541                	add	a0,a0,16
    8000398e:	00001097          	auipc	ra,0x1
    80003992:	c7e080e7          	jalr	-898(ra) # 8000460c <acquiresleep>
  if(ip->valid == 0){
    80003996:	40bc                	lw	a5,64(s1)
    80003998:	cf99                	beqz	a5,800039b6 <ilock+0x40>
}
    8000399a:	60e2                	ld	ra,24(sp)
    8000399c:	6442                	ld	s0,16(sp)
    8000399e:	64a2                	ld	s1,8(sp)
    800039a0:	6902                	ld	s2,0(sp)
    800039a2:	6105                	add	sp,sp,32
    800039a4:	8082                	ret
    panic("ilock");
    800039a6:	00005517          	auipc	a0,0x5
    800039aa:	c3a50513          	add	a0,a0,-966 # 800085e0 <syscalls+0x180>
    800039ae:	ffffd097          	auipc	ra,0xffffd
    800039b2:	b94080e7          	jalr	-1132(ra) # 80000542 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800039b6:	40dc                	lw	a5,4(s1)
    800039b8:	0047d79b          	srlw	a5,a5,0x4
    800039bc:	0001c597          	auipc	a1,0x1c
    800039c0:	69c5a583          	lw	a1,1692(a1) # 80020058 <sb+0x18>
    800039c4:	9dbd                	addw	a1,a1,a5
    800039c6:	4088                	lw	a0,0(s1)
    800039c8:	fffff097          	auipc	ra,0xfffff
    800039cc:	7b4080e7          	jalr	1972(ra) # 8000317c <bread>
    800039d0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800039d2:	05850593          	add	a1,a0,88
    800039d6:	40dc                	lw	a5,4(s1)
    800039d8:	8bbd                	and	a5,a5,15
    800039da:	079a                	sll	a5,a5,0x6
    800039dc:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800039de:	00059783          	lh	a5,0(a1)
    800039e2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800039e6:	00259783          	lh	a5,2(a1)
    800039ea:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800039ee:	00459783          	lh	a5,4(a1)
    800039f2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800039f6:	00659783          	lh	a5,6(a1)
    800039fa:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800039fe:	459c                	lw	a5,8(a1)
    80003a00:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003a02:	03400613          	li	a2,52
    80003a06:	05b1                	add	a1,a1,12
    80003a08:	05048513          	add	a0,s1,80
    80003a0c:	ffffd097          	auipc	ra,0xffffd
    80003a10:	348080e7          	jalr	840(ra) # 80000d54 <memmove>
    brelse(bp);
    80003a14:	854a                	mv	a0,s2
    80003a16:	00000097          	auipc	ra,0x0
    80003a1a:	896080e7          	jalr	-1898(ra) # 800032ac <brelse>
    ip->valid = 1;
    80003a1e:	4785                	li	a5,1
    80003a20:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003a22:	04449783          	lh	a5,68(s1)
    80003a26:	fbb5                	bnez	a5,8000399a <ilock+0x24>
      panic("ilock: no type");
    80003a28:	00005517          	auipc	a0,0x5
    80003a2c:	bc050513          	add	a0,a0,-1088 # 800085e8 <syscalls+0x188>
    80003a30:	ffffd097          	auipc	ra,0xffffd
    80003a34:	b12080e7          	jalr	-1262(ra) # 80000542 <panic>

0000000080003a38 <iunlock>:
{
    80003a38:	1101                	add	sp,sp,-32
    80003a3a:	ec06                	sd	ra,24(sp)
    80003a3c:	e822                	sd	s0,16(sp)
    80003a3e:	e426                	sd	s1,8(sp)
    80003a40:	e04a                	sd	s2,0(sp)
    80003a42:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003a44:	c905                	beqz	a0,80003a74 <iunlock+0x3c>
    80003a46:	84aa                	mv	s1,a0
    80003a48:	01050913          	add	s2,a0,16
    80003a4c:	854a                	mv	a0,s2
    80003a4e:	00001097          	auipc	ra,0x1
    80003a52:	c58080e7          	jalr	-936(ra) # 800046a6 <holdingsleep>
    80003a56:	cd19                	beqz	a0,80003a74 <iunlock+0x3c>
    80003a58:	449c                	lw	a5,8(s1)
    80003a5a:	00f05d63          	blez	a5,80003a74 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003a5e:	854a                	mv	a0,s2
    80003a60:	00001097          	auipc	ra,0x1
    80003a64:	c02080e7          	jalr	-1022(ra) # 80004662 <releasesleep>
}
    80003a68:	60e2                	ld	ra,24(sp)
    80003a6a:	6442                	ld	s0,16(sp)
    80003a6c:	64a2                	ld	s1,8(sp)
    80003a6e:	6902                	ld	s2,0(sp)
    80003a70:	6105                	add	sp,sp,32
    80003a72:	8082                	ret
    panic("iunlock");
    80003a74:	00005517          	auipc	a0,0x5
    80003a78:	b8450513          	add	a0,a0,-1148 # 800085f8 <syscalls+0x198>
    80003a7c:	ffffd097          	auipc	ra,0xffffd
    80003a80:	ac6080e7          	jalr	-1338(ra) # 80000542 <panic>

0000000080003a84 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003a84:	7179                	add	sp,sp,-48
    80003a86:	f406                	sd	ra,40(sp)
    80003a88:	f022                	sd	s0,32(sp)
    80003a8a:	ec26                	sd	s1,24(sp)
    80003a8c:	e84a                	sd	s2,16(sp)
    80003a8e:	e44e                	sd	s3,8(sp)
    80003a90:	e052                	sd	s4,0(sp)
    80003a92:	1800                	add	s0,sp,48
    80003a94:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003a96:	05050493          	add	s1,a0,80
    80003a9a:	08050913          	add	s2,a0,128
    80003a9e:	a021                	j	80003aa6 <itrunc+0x22>
    80003aa0:	0491                	add	s1,s1,4
    80003aa2:	01248d63          	beq	s1,s2,80003abc <itrunc+0x38>
    if(ip->addrs[i]){
    80003aa6:	408c                	lw	a1,0(s1)
    80003aa8:	dde5                	beqz	a1,80003aa0 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003aaa:	0009a503          	lw	a0,0(s3)
    80003aae:	00000097          	auipc	ra,0x0
    80003ab2:	912080e7          	jalr	-1774(ra) # 800033c0 <bfree>
      ip->addrs[i] = 0;
    80003ab6:	0004a023          	sw	zero,0(s1)
    80003aba:	b7dd                	j	80003aa0 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003abc:	0809a583          	lw	a1,128(s3)
    80003ac0:	e185                	bnez	a1,80003ae0 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003ac2:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003ac6:	854e                	mv	a0,s3
    80003ac8:	00000097          	auipc	ra,0x0
    80003acc:	de2080e7          	jalr	-542(ra) # 800038aa <iupdate>
}
    80003ad0:	70a2                	ld	ra,40(sp)
    80003ad2:	7402                	ld	s0,32(sp)
    80003ad4:	64e2                	ld	s1,24(sp)
    80003ad6:	6942                	ld	s2,16(sp)
    80003ad8:	69a2                	ld	s3,8(sp)
    80003ada:	6a02                	ld	s4,0(sp)
    80003adc:	6145                	add	sp,sp,48
    80003ade:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003ae0:	0009a503          	lw	a0,0(s3)
    80003ae4:	fffff097          	auipc	ra,0xfffff
    80003ae8:	698080e7          	jalr	1688(ra) # 8000317c <bread>
    80003aec:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003aee:	05850493          	add	s1,a0,88
    80003af2:	45850913          	add	s2,a0,1112
    80003af6:	a021                	j	80003afe <itrunc+0x7a>
    80003af8:	0491                	add	s1,s1,4
    80003afa:	01248b63          	beq	s1,s2,80003b10 <itrunc+0x8c>
      if(a[j])
    80003afe:	408c                	lw	a1,0(s1)
    80003b00:	dde5                	beqz	a1,80003af8 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003b02:	0009a503          	lw	a0,0(s3)
    80003b06:	00000097          	auipc	ra,0x0
    80003b0a:	8ba080e7          	jalr	-1862(ra) # 800033c0 <bfree>
    80003b0e:	b7ed                	j	80003af8 <itrunc+0x74>
    brelse(bp);
    80003b10:	8552                	mv	a0,s4
    80003b12:	fffff097          	auipc	ra,0xfffff
    80003b16:	79a080e7          	jalr	1946(ra) # 800032ac <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003b1a:	0809a583          	lw	a1,128(s3)
    80003b1e:	0009a503          	lw	a0,0(s3)
    80003b22:	00000097          	auipc	ra,0x0
    80003b26:	89e080e7          	jalr	-1890(ra) # 800033c0 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003b2a:	0809a023          	sw	zero,128(s3)
    80003b2e:	bf51                	j	80003ac2 <itrunc+0x3e>

0000000080003b30 <iput>:
{
    80003b30:	1101                	add	sp,sp,-32
    80003b32:	ec06                	sd	ra,24(sp)
    80003b34:	e822                	sd	s0,16(sp)
    80003b36:	e426                	sd	s1,8(sp)
    80003b38:	e04a                	sd	s2,0(sp)
    80003b3a:	1000                	add	s0,sp,32
    80003b3c:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003b3e:	0001c517          	auipc	a0,0x1c
    80003b42:	52250513          	add	a0,a0,1314 # 80020060 <icache>
    80003b46:	ffffd097          	auipc	ra,0xffffd
    80003b4a:	0b6080e7          	jalr	182(ra) # 80000bfc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003b4e:	4498                	lw	a4,8(s1)
    80003b50:	4785                	li	a5,1
    80003b52:	02f70363          	beq	a4,a5,80003b78 <iput+0x48>
  ip->ref--;
    80003b56:	449c                	lw	a5,8(s1)
    80003b58:	37fd                	addw	a5,a5,-1
    80003b5a:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003b5c:	0001c517          	auipc	a0,0x1c
    80003b60:	50450513          	add	a0,a0,1284 # 80020060 <icache>
    80003b64:	ffffd097          	auipc	ra,0xffffd
    80003b68:	14c080e7          	jalr	332(ra) # 80000cb0 <release>
}
    80003b6c:	60e2                	ld	ra,24(sp)
    80003b6e:	6442                	ld	s0,16(sp)
    80003b70:	64a2                	ld	s1,8(sp)
    80003b72:	6902                	ld	s2,0(sp)
    80003b74:	6105                	add	sp,sp,32
    80003b76:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003b78:	40bc                	lw	a5,64(s1)
    80003b7a:	dff1                	beqz	a5,80003b56 <iput+0x26>
    80003b7c:	04a49783          	lh	a5,74(s1)
    80003b80:	fbf9                	bnez	a5,80003b56 <iput+0x26>
    acquiresleep(&ip->lock);
    80003b82:	01048913          	add	s2,s1,16
    80003b86:	854a                	mv	a0,s2
    80003b88:	00001097          	auipc	ra,0x1
    80003b8c:	a84080e7          	jalr	-1404(ra) # 8000460c <acquiresleep>
    release(&icache.lock);
    80003b90:	0001c517          	auipc	a0,0x1c
    80003b94:	4d050513          	add	a0,a0,1232 # 80020060 <icache>
    80003b98:	ffffd097          	auipc	ra,0xffffd
    80003b9c:	118080e7          	jalr	280(ra) # 80000cb0 <release>
    itrunc(ip);
    80003ba0:	8526                	mv	a0,s1
    80003ba2:	00000097          	auipc	ra,0x0
    80003ba6:	ee2080e7          	jalr	-286(ra) # 80003a84 <itrunc>
    ip->type = 0;
    80003baa:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003bae:	8526                	mv	a0,s1
    80003bb0:	00000097          	auipc	ra,0x0
    80003bb4:	cfa080e7          	jalr	-774(ra) # 800038aa <iupdate>
    ip->valid = 0;
    80003bb8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003bbc:	854a                	mv	a0,s2
    80003bbe:	00001097          	auipc	ra,0x1
    80003bc2:	aa4080e7          	jalr	-1372(ra) # 80004662 <releasesleep>
    acquire(&icache.lock);
    80003bc6:	0001c517          	auipc	a0,0x1c
    80003bca:	49a50513          	add	a0,a0,1178 # 80020060 <icache>
    80003bce:	ffffd097          	auipc	ra,0xffffd
    80003bd2:	02e080e7          	jalr	46(ra) # 80000bfc <acquire>
    80003bd6:	b741                	j	80003b56 <iput+0x26>

0000000080003bd8 <iunlockput>:
{
    80003bd8:	1101                	add	sp,sp,-32
    80003bda:	ec06                	sd	ra,24(sp)
    80003bdc:	e822                	sd	s0,16(sp)
    80003bde:	e426                	sd	s1,8(sp)
    80003be0:	1000                	add	s0,sp,32
    80003be2:	84aa                	mv	s1,a0
  iunlock(ip);
    80003be4:	00000097          	auipc	ra,0x0
    80003be8:	e54080e7          	jalr	-428(ra) # 80003a38 <iunlock>
  iput(ip);
    80003bec:	8526                	mv	a0,s1
    80003bee:	00000097          	auipc	ra,0x0
    80003bf2:	f42080e7          	jalr	-190(ra) # 80003b30 <iput>
}
    80003bf6:	60e2                	ld	ra,24(sp)
    80003bf8:	6442                	ld	s0,16(sp)
    80003bfa:	64a2                	ld	s1,8(sp)
    80003bfc:	6105                	add	sp,sp,32
    80003bfe:	8082                	ret

0000000080003c00 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003c00:	1141                	add	sp,sp,-16
    80003c02:	e422                	sd	s0,8(sp)
    80003c04:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80003c06:	411c                	lw	a5,0(a0)
    80003c08:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003c0a:	415c                	lw	a5,4(a0)
    80003c0c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003c0e:	04451783          	lh	a5,68(a0)
    80003c12:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003c16:	04a51783          	lh	a5,74(a0)
    80003c1a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003c1e:	04c56783          	lwu	a5,76(a0)
    80003c22:	e99c                	sd	a5,16(a1)
}
    80003c24:	6422                	ld	s0,8(sp)
    80003c26:	0141                	add	sp,sp,16
    80003c28:	8082                	ret

0000000080003c2a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003c2a:	457c                	lw	a5,76(a0)
    80003c2c:	0ed7e863          	bltu	a5,a3,80003d1c <readi+0xf2>
{
    80003c30:	7159                	add	sp,sp,-112
    80003c32:	f486                	sd	ra,104(sp)
    80003c34:	f0a2                	sd	s0,96(sp)
    80003c36:	eca6                	sd	s1,88(sp)
    80003c38:	e8ca                	sd	s2,80(sp)
    80003c3a:	e4ce                	sd	s3,72(sp)
    80003c3c:	e0d2                	sd	s4,64(sp)
    80003c3e:	fc56                	sd	s5,56(sp)
    80003c40:	f85a                	sd	s6,48(sp)
    80003c42:	f45e                	sd	s7,40(sp)
    80003c44:	f062                	sd	s8,32(sp)
    80003c46:	ec66                	sd	s9,24(sp)
    80003c48:	e86a                	sd	s10,16(sp)
    80003c4a:	e46e                	sd	s11,8(sp)
    80003c4c:	1880                	add	s0,sp,112
    80003c4e:	8baa                	mv	s7,a0
    80003c50:	8c2e                	mv	s8,a1
    80003c52:	8ab2                	mv	s5,a2
    80003c54:	84b6                	mv	s1,a3
    80003c56:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003c58:	9f35                	addw	a4,a4,a3
    return 0;
    80003c5a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003c5c:	08d76f63          	bltu	a4,a3,80003cfa <readi+0xd0>
  if(off + n > ip->size)
    80003c60:	00e7f463          	bgeu	a5,a4,80003c68 <readi+0x3e>
    n = ip->size - off;
    80003c64:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003c68:	0a0b0863          	beqz	s6,80003d18 <readi+0xee>
    80003c6c:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c6e:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003c72:	5cfd                	li	s9,-1
    80003c74:	a82d                	j	80003cae <readi+0x84>
    80003c76:	020a1d93          	sll	s11,s4,0x20
    80003c7a:	020ddd93          	srl	s11,s11,0x20
    80003c7e:	05890613          	add	a2,s2,88
    80003c82:	86ee                	mv	a3,s11
    80003c84:	963a                	add	a2,a2,a4
    80003c86:	85d6                	mv	a1,s5
    80003c88:	8562                	mv	a0,s8
    80003c8a:	fffff097          	auipc	ra,0xfffff
    80003c8e:	a80080e7          	jalr	-1408(ra) # 8000270a <either_copyout>
    80003c92:	05950d63          	beq	a0,s9,80003cec <readi+0xc2>
      brelse(bp);
      break;
    }
    brelse(bp);
    80003c96:	854a                	mv	a0,s2
    80003c98:	fffff097          	auipc	ra,0xfffff
    80003c9c:	614080e7          	jalr	1556(ra) # 800032ac <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ca0:	013a09bb          	addw	s3,s4,s3
    80003ca4:	009a04bb          	addw	s1,s4,s1
    80003ca8:	9aee                	add	s5,s5,s11
    80003caa:	0569f663          	bgeu	s3,s6,80003cf6 <readi+0xcc>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003cae:	000ba903          	lw	s2,0(s7) # 1000 <_entry-0x7ffff000>
    80003cb2:	00a4d59b          	srlw	a1,s1,0xa
    80003cb6:	855e                	mv	a0,s7
    80003cb8:	00000097          	auipc	ra,0x0
    80003cbc:	8b2080e7          	jalr	-1870(ra) # 8000356a <bmap>
    80003cc0:	0005059b          	sext.w	a1,a0
    80003cc4:	854a                	mv	a0,s2
    80003cc6:	fffff097          	auipc	ra,0xfffff
    80003cca:	4b6080e7          	jalr	1206(ra) # 8000317c <bread>
    80003cce:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003cd0:	3ff4f713          	and	a4,s1,1023
    80003cd4:	40ed07bb          	subw	a5,s10,a4
    80003cd8:	413b06bb          	subw	a3,s6,s3
    80003cdc:	8a3e                	mv	s4,a5
    80003cde:	2781                	sext.w	a5,a5
    80003ce0:	0006861b          	sext.w	a2,a3
    80003ce4:	f8f679e3          	bgeu	a2,a5,80003c76 <readi+0x4c>
    80003ce8:	8a36                	mv	s4,a3
    80003cea:	b771                	j	80003c76 <readi+0x4c>
      brelse(bp);
    80003cec:	854a                	mv	a0,s2
    80003cee:	fffff097          	auipc	ra,0xfffff
    80003cf2:	5be080e7          	jalr	1470(ra) # 800032ac <brelse>
  }
  return tot;
    80003cf6:	0009851b          	sext.w	a0,s3
}
    80003cfa:	70a6                	ld	ra,104(sp)
    80003cfc:	7406                	ld	s0,96(sp)
    80003cfe:	64e6                	ld	s1,88(sp)
    80003d00:	6946                	ld	s2,80(sp)
    80003d02:	69a6                	ld	s3,72(sp)
    80003d04:	6a06                	ld	s4,64(sp)
    80003d06:	7ae2                	ld	s5,56(sp)
    80003d08:	7b42                	ld	s6,48(sp)
    80003d0a:	7ba2                	ld	s7,40(sp)
    80003d0c:	7c02                	ld	s8,32(sp)
    80003d0e:	6ce2                	ld	s9,24(sp)
    80003d10:	6d42                	ld	s10,16(sp)
    80003d12:	6da2                	ld	s11,8(sp)
    80003d14:	6165                	add	sp,sp,112
    80003d16:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003d18:	89da                	mv	s3,s6
    80003d1a:	bff1                	j	80003cf6 <readi+0xcc>
    return 0;
    80003d1c:	4501                	li	a0,0
}
    80003d1e:	8082                	ret

0000000080003d20 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003d20:	457c                	lw	a5,76(a0)
    80003d22:	10d7e663          	bltu	a5,a3,80003e2e <writei+0x10e>
{
    80003d26:	7159                	add	sp,sp,-112
    80003d28:	f486                	sd	ra,104(sp)
    80003d2a:	f0a2                	sd	s0,96(sp)
    80003d2c:	eca6                	sd	s1,88(sp)
    80003d2e:	e8ca                	sd	s2,80(sp)
    80003d30:	e4ce                	sd	s3,72(sp)
    80003d32:	e0d2                	sd	s4,64(sp)
    80003d34:	fc56                	sd	s5,56(sp)
    80003d36:	f85a                	sd	s6,48(sp)
    80003d38:	f45e                	sd	s7,40(sp)
    80003d3a:	f062                	sd	s8,32(sp)
    80003d3c:	ec66                	sd	s9,24(sp)
    80003d3e:	e86a                	sd	s10,16(sp)
    80003d40:	e46e                	sd	s11,8(sp)
    80003d42:	1880                	add	s0,sp,112
    80003d44:	8baa                	mv	s7,a0
    80003d46:	8c2e                	mv	s8,a1
    80003d48:	8ab2                	mv	s5,a2
    80003d4a:	8936                	mv	s2,a3
    80003d4c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003d4e:	00e687bb          	addw	a5,a3,a4
    80003d52:	0ed7e063          	bltu	a5,a3,80003e32 <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003d56:	00043737          	lui	a4,0x43
    80003d5a:	0cf76e63          	bltu	a4,a5,80003e36 <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003d5e:	0a0b0763          	beqz	s6,80003e0c <writei+0xec>
    80003d62:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d64:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003d68:	5cfd                	li	s9,-1
    80003d6a:	a091                	j	80003dae <writei+0x8e>
    80003d6c:	02099d93          	sll	s11,s3,0x20
    80003d70:	020ddd93          	srl	s11,s11,0x20
    80003d74:	05848513          	add	a0,s1,88
    80003d78:	86ee                	mv	a3,s11
    80003d7a:	8656                	mv	a2,s5
    80003d7c:	85e2                	mv	a1,s8
    80003d7e:	953a                	add	a0,a0,a4
    80003d80:	fffff097          	auipc	ra,0xfffff
    80003d84:	9e0080e7          	jalr	-1568(ra) # 80002760 <either_copyin>
    80003d88:	07950263          	beq	a0,s9,80003dec <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003d8c:	8526                	mv	a0,s1
    80003d8e:	00000097          	auipc	ra,0x0
    80003d92:	758080e7          	jalr	1880(ra) # 800044e6 <log_write>
    brelse(bp);
    80003d96:	8526                	mv	a0,s1
    80003d98:	fffff097          	auipc	ra,0xfffff
    80003d9c:	514080e7          	jalr	1300(ra) # 800032ac <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003da0:	01498a3b          	addw	s4,s3,s4
    80003da4:	0129893b          	addw	s2,s3,s2
    80003da8:	9aee                	add	s5,s5,s11
    80003daa:	056a7663          	bgeu	s4,s6,80003df6 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003dae:	000ba483          	lw	s1,0(s7)
    80003db2:	00a9559b          	srlw	a1,s2,0xa
    80003db6:	855e                	mv	a0,s7
    80003db8:	fffff097          	auipc	ra,0xfffff
    80003dbc:	7b2080e7          	jalr	1970(ra) # 8000356a <bmap>
    80003dc0:	0005059b          	sext.w	a1,a0
    80003dc4:	8526                	mv	a0,s1
    80003dc6:	fffff097          	auipc	ra,0xfffff
    80003dca:	3b6080e7          	jalr	950(ra) # 8000317c <bread>
    80003dce:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003dd0:	3ff97713          	and	a4,s2,1023
    80003dd4:	40ed07bb          	subw	a5,s10,a4
    80003dd8:	414b06bb          	subw	a3,s6,s4
    80003ddc:	89be                	mv	s3,a5
    80003dde:	2781                	sext.w	a5,a5
    80003de0:	0006861b          	sext.w	a2,a3
    80003de4:	f8f674e3          	bgeu	a2,a5,80003d6c <writei+0x4c>
    80003de8:	89b6                	mv	s3,a3
    80003dea:	b749                	j	80003d6c <writei+0x4c>
      brelse(bp);
    80003dec:	8526                	mv	a0,s1
    80003dee:	fffff097          	auipc	ra,0xfffff
    80003df2:	4be080e7          	jalr	1214(ra) # 800032ac <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80003df6:	04cba783          	lw	a5,76(s7)
    80003dfa:	0127f463          	bgeu	a5,s2,80003e02 <writei+0xe2>
      ip->size = off;
    80003dfe:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003e02:	855e                	mv	a0,s7
    80003e04:	00000097          	auipc	ra,0x0
    80003e08:	aa6080e7          	jalr	-1370(ra) # 800038aa <iupdate>
  }

  return n;
    80003e0c:	000b051b          	sext.w	a0,s6
}
    80003e10:	70a6                	ld	ra,104(sp)
    80003e12:	7406                	ld	s0,96(sp)
    80003e14:	64e6                	ld	s1,88(sp)
    80003e16:	6946                	ld	s2,80(sp)
    80003e18:	69a6                	ld	s3,72(sp)
    80003e1a:	6a06                	ld	s4,64(sp)
    80003e1c:	7ae2                	ld	s5,56(sp)
    80003e1e:	7b42                	ld	s6,48(sp)
    80003e20:	7ba2                	ld	s7,40(sp)
    80003e22:	7c02                	ld	s8,32(sp)
    80003e24:	6ce2                	ld	s9,24(sp)
    80003e26:	6d42                	ld	s10,16(sp)
    80003e28:	6da2                	ld	s11,8(sp)
    80003e2a:	6165                	add	sp,sp,112
    80003e2c:	8082                	ret
    return -1;
    80003e2e:	557d                	li	a0,-1
}
    80003e30:	8082                	ret
    return -1;
    80003e32:	557d                	li	a0,-1
    80003e34:	bff1                	j	80003e10 <writei+0xf0>
    return -1;
    80003e36:	557d                	li	a0,-1
    80003e38:	bfe1                	j	80003e10 <writei+0xf0>

0000000080003e3a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003e3a:	1141                	add	sp,sp,-16
    80003e3c:	e406                	sd	ra,8(sp)
    80003e3e:	e022                	sd	s0,0(sp)
    80003e40:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003e42:	4639                	li	a2,14
    80003e44:	ffffd097          	auipc	ra,0xffffd
    80003e48:	f8c080e7          	jalr	-116(ra) # 80000dd0 <strncmp>
}
    80003e4c:	60a2                	ld	ra,8(sp)
    80003e4e:	6402                	ld	s0,0(sp)
    80003e50:	0141                	add	sp,sp,16
    80003e52:	8082                	ret

0000000080003e54 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003e54:	7139                	add	sp,sp,-64
    80003e56:	fc06                	sd	ra,56(sp)
    80003e58:	f822                	sd	s0,48(sp)
    80003e5a:	f426                	sd	s1,40(sp)
    80003e5c:	f04a                	sd	s2,32(sp)
    80003e5e:	ec4e                	sd	s3,24(sp)
    80003e60:	e852                	sd	s4,16(sp)
    80003e62:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003e64:	04451703          	lh	a4,68(a0)
    80003e68:	4785                	li	a5,1
    80003e6a:	00f71a63          	bne	a4,a5,80003e7e <dirlookup+0x2a>
    80003e6e:	892a                	mv	s2,a0
    80003e70:	89ae                	mv	s3,a1
    80003e72:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e74:	457c                	lw	a5,76(a0)
    80003e76:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003e78:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e7a:	e79d                	bnez	a5,80003ea8 <dirlookup+0x54>
    80003e7c:	a8a5                	j	80003ef4 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003e7e:	00004517          	auipc	a0,0x4
    80003e82:	78250513          	add	a0,a0,1922 # 80008600 <syscalls+0x1a0>
    80003e86:	ffffc097          	auipc	ra,0xffffc
    80003e8a:	6bc080e7          	jalr	1724(ra) # 80000542 <panic>
      panic("dirlookup read");
    80003e8e:	00004517          	auipc	a0,0x4
    80003e92:	78a50513          	add	a0,a0,1930 # 80008618 <syscalls+0x1b8>
    80003e96:	ffffc097          	auipc	ra,0xffffc
    80003e9a:	6ac080e7          	jalr	1708(ra) # 80000542 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e9e:	24c1                	addw	s1,s1,16
    80003ea0:	04c92783          	lw	a5,76(s2)
    80003ea4:	04f4f763          	bgeu	s1,a5,80003ef2 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ea8:	4741                	li	a4,16
    80003eaa:	86a6                	mv	a3,s1
    80003eac:	fc040613          	add	a2,s0,-64
    80003eb0:	4581                	li	a1,0
    80003eb2:	854a                	mv	a0,s2
    80003eb4:	00000097          	auipc	ra,0x0
    80003eb8:	d76080e7          	jalr	-650(ra) # 80003c2a <readi>
    80003ebc:	47c1                	li	a5,16
    80003ebe:	fcf518e3          	bne	a0,a5,80003e8e <dirlookup+0x3a>
    if(de.inum == 0)
    80003ec2:	fc045783          	lhu	a5,-64(s0)
    80003ec6:	dfe1                	beqz	a5,80003e9e <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003ec8:	fc240593          	add	a1,s0,-62
    80003ecc:	854e                	mv	a0,s3
    80003ece:	00000097          	auipc	ra,0x0
    80003ed2:	f6c080e7          	jalr	-148(ra) # 80003e3a <namecmp>
    80003ed6:	f561                	bnez	a0,80003e9e <dirlookup+0x4a>
      if(poff)
    80003ed8:	000a0463          	beqz	s4,80003ee0 <dirlookup+0x8c>
        *poff = off;
    80003edc:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003ee0:	fc045583          	lhu	a1,-64(s0)
    80003ee4:	00092503          	lw	a0,0(s2)
    80003ee8:	fffff097          	auipc	ra,0xfffff
    80003eec:	75e080e7          	jalr	1886(ra) # 80003646 <iget>
    80003ef0:	a011                	j	80003ef4 <dirlookup+0xa0>
  return 0;
    80003ef2:	4501                	li	a0,0
}
    80003ef4:	70e2                	ld	ra,56(sp)
    80003ef6:	7442                	ld	s0,48(sp)
    80003ef8:	74a2                	ld	s1,40(sp)
    80003efa:	7902                	ld	s2,32(sp)
    80003efc:	69e2                	ld	s3,24(sp)
    80003efe:	6a42                	ld	s4,16(sp)
    80003f00:	6121                	add	sp,sp,64
    80003f02:	8082                	ret

0000000080003f04 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003f04:	711d                	add	sp,sp,-96
    80003f06:	ec86                	sd	ra,88(sp)
    80003f08:	e8a2                	sd	s0,80(sp)
    80003f0a:	e4a6                	sd	s1,72(sp)
    80003f0c:	e0ca                	sd	s2,64(sp)
    80003f0e:	fc4e                	sd	s3,56(sp)
    80003f10:	f852                	sd	s4,48(sp)
    80003f12:	f456                	sd	s5,40(sp)
    80003f14:	f05a                	sd	s6,32(sp)
    80003f16:	ec5e                	sd	s7,24(sp)
    80003f18:	e862                	sd	s8,16(sp)
    80003f1a:	e466                	sd	s9,8(sp)
    80003f1c:	1080                	add	s0,sp,96
    80003f1e:	84aa                	mv	s1,a0
    80003f20:	8b2e                	mv	s6,a1
    80003f22:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003f24:	00054703          	lbu	a4,0(a0)
    80003f28:	02f00793          	li	a5,47
    80003f2c:	02f70263          	beq	a4,a5,80003f50 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003f30:	ffffe097          	auipc	ra,0xffffe
    80003f34:	b60080e7          	jalr	-1184(ra) # 80001a90 <myproc>
    80003f38:	15853503          	ld	a0,344(a0)
    80003f3c:	00000097          	auipc	ra,0x0
    80003f40:	9fc080e7          	jalr	-1540(ra) # 80003938 <idup>
    80003f44:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003f46:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003f4a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003f4c:	4b85                	li	s7,1
    80003f4e:	a875                	j	8000400a <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003f50:	4585                	li	a1,1
    80003f52:	4505                	li	a0,1
    80003f54:	fffff097          	auipc	ra,0xfffff
    80003f58:	6f2080e7          	jalr	1778(ra) # 80003646 <iget>
    80003f5c:	8a2a                	mv	s4,a0
    80003f5e:	b7e5                	j	80003f46 <namex+0x42>
      iunlockput(ip);
    80003f60:	8552                	mv	a0,s4
    80003f62:	00000097          	auipc	ra,0x0
    80003f66:	c76080e7          	jalr	-906(ra) # 80003bd8 <iunlockput>
      return 0;
    80003f6a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003f6c:	8552                	mv	a0,s4
    80003f6e:	60e6                	ld	ra,88(sp)
    80003f70:	6446                	ld	s0,80(sp)
    80003f72:	64a6                	ld	s1,72(sp)
    80003f74:	6906                	ld	s2,64(sp)
    80003f76:	79e2                	ld	s3,56(sp)
    80003f78:	7a42                	ld	s4,48(sp)
    80003f7a:	7aa2                	ld	s5,40(sp)
    80003f7c:	7b02                	ld	s6,32(sp)
    80003f7e:	6be2                	ld	s7,24(sp)
    80003f80:	6c42                	ld	s8,16(sp)
    80003f82:	6ca2                	ld	s9,8(sp)
    80003f84:	6125                	add	sp,sp,96
    80003f86:	8082                	ret
      iunlock(ip);
    80003f88:	8552                	mv	a0,s4
    80003f8a:	00000097          	auipc	ra,0x0
    80003f8e:	aae080e7          	jalr	-1362(ra) # 80003a38 <iunlock>
      return ip;
    80003f92:	bfe9                	j	80003f6c <namex+0x68>
      iunlockput(ip);
    80003f94:	8552                	mv	a0,s4
    80003f96:	00000097          	auipc	ra,0x0
    80003f9a:	c42080e7          	jalr	-958(ra) # 80003bd8 <iunlockput>
      return 0;
    80003f9e:	8a4e                	mv	s4,s3
    80003fa0:	b7f1                	j	80003f6c <namex+0x68>
  len = path - s;
    80003fa2:	40998633          	sub	a2,s3,s1
    80003fa6:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003faa:	099c5863          	bge	s8,s9,8000403a <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003fae:	4639                	li	a2,14
    80003fb0:	85a6                	mv	a1,s1
    80003fb2:	8556                	mv	a0,s5
    80003fb4:	ffffd097          	auipc	ra,0xffffd
    80003fb8:	da0080e7          	jalr	-608(ra) # 80000d54 <memmove>
    80003fbc:	84ce                	mv	s1,s3
  while(*path == '/')
    80003fbe:	0004c783          	lbu	a5,0(s1)
    80003fc2:	01279763          	bne	a5,s2,80003fd0 <namex+0xcc>
    path++;
    80003fc6:	0485                	add	s1,s1,1
  while(*path == '/')
    80003fc8:	0004c783          	lbu	a5,0(s1)
    80003fcc:	ff278de3          	beq	a5,s2,80003fc6 <namex+0xc2>
    ilock(ip);
    80003fd0:	8552                	mv	a0,s4
    80003fd2:	00000097          	auipc	ra,0x0
    80003fd6:	9a4080e7          	jalr	-1628(ra) # 80003976 <ilock>
    if(ip->type != T_DIR){
    80003fda:	044a1783          	lh	a5,68(s4)
    80003fde:	f97791e3          	bne	a5,s7,80003f60 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003fe2:	000b0563          	beqz	s6,80003fec <namex+0xe8>
    80003fe6:	0004c783          	lbu	a5,0(s1)
    80003fea:	dfd9                	beqz	a5,80003f88 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003fec:	4601                	li	a2,0
    80003fee:	85d6                	mv	a1,s5
    80003ff0:	8552                	mv	a0,s4
    80003ff2:	00000097          	auipc	ra,0x0
    80003ff6:	e62080e7          	jalr	-414(ra) # 80003e54 <dirlookup>
    80003ffa:	89aa                	mv	s3,a0
    80003ffc:	dd41                	beqz	a0,80003f94 <namex+0x90>
    iunlockput(ip);
    80003ffe:	8552                	mv	a0,s4
    80004000:	00000097          	auipc	ra,0x0
    80004004:	bd8080e7          	jalr	-1064(ra) # 80003bd8 <iunlockput>
    ip = next;
    80004008:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000400a:	0004c783          	lbu	a5,0(s1)
    8000400e:	01279763          	bne	a5,s2,8000401c <namex+0x118>
    path++;
    80004012:	0485                	add	s1,s1,1
  while(*path == '/')
    80004014:	0004c783          	lbu	a5,0(s1)
    80004018:	ff278de3          	beq	a5,s2,80004012 <namex+0x10e>
  if(*path == 0)
    8000401c:	cb9d                	beqz	a5,80004052 <namex+0x14e>
  while(*path != '/' && *path != 0)
    8000401e:	0004c783          	lbu	a5,0(s1)
    80004022:	89a6                	mv	s3,s1
  len = path - s;
    80004024:	4c81                	li	s9,0
    80004026:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80004028:	01278963          	beq	a5,s2,8000403a <namex+0x136>
    8000402c:	dbbd                	beqz	a5,80003fa2 <namex+0x9e>
    path++;
    8000402e:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80004030:	0009c783          	lbu	a5,0(s3)
    80004034:	ff279ce3          	bne	a5,s2,8000402c <namex+0x128>
    80004038:	b7ad                	j	80003fa2 <namex+0x9e>
    memmove(name, s, len);
    8000403a:	2601                	sext.w	a2,a2
    8000403c:	85a6                	mv	a1,s1
    8000403e:	8556                	mv	a0,s5
    80004040:	ffffd097          	auipc	ra,0xffffd
    80004044:	d14080e7          	jalr	-748(ra) # 80000d54 <memmove>
    name[len] = 0;
    80004048:	9cd6                	add	s9,s9,s5
    8000404a:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000404e:	84ce                	mv	s1,s3
    80004050:	b7bd                	j	80003fbe <namex+0xba>
  if(nameiparent){
    80004052:	f00b0de3          	beqz	s6,80003f6c <namex+0x68>
    iput(ip);
    80004056:	8552                	mv	a0,s4
    80004058:	00000097          	auipc	ra,0x0
    8000405c:	ad8080e7          	jalr	-1320(ra) # 80003b30 <iput>
    return 0;
    80004060:	4a01                	li	s4,0
    80004062:	b729                	j	80003f6c <namex+0x68>

0000000080004064 <dirlink>:
{
    80004064:	7139                	add	sp,sp,-64
    80004066:	fc06                	sd	ra,56(sp)
    80004068:	f822                	sd	s0,48(sp)
    8000406a:	f426                	sd	s1,40(sp)
    8000406c:	f04a                	sd	s2,32(sp)
    8000406e:	ec4e                	sd	s3,24(sp)
    80004070:	e852                	sd	s4,16(sp)
    80004072:	0080                	add	s0,sp,64
    80004074:	892a                	mv	s2,a0
    80004076:	8a2e                	mv	s4,a1
    80004078:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000407a:	4601                	li	a2,0
    8000407c:	00000097          	auipc	ra,0x0
    80004080:	dd8080e7          	jalr	-552(ra) # 80003e54 <dirlookup>
    80004084:	e93d                	bnez	a0,800040fa <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004086:	04c92483          	lw	s1,76(s2)
    8000408a:	c49d                	beqz	s1,800040b8 <dirlink+0x54>
    8000408c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000408e:	4741                	li	a4,16
    80004090:	86a6                	mv	a3,s1
    80004092:	fc040613          	add	a2,s0,-64
    80004096:	4581                	li	a1,0
    80004098:	854a                	mv	a0,s2
    8000409a:	00000097          	auipc	ra,0x0
    8000409e:	b90080e7          	jalr	-1136(ra) # 80003c2a <readi>
    800040a2:	47c1                	li	a5,16
    800040a4:	06f51163          	bne	a0,a5,80004106 <dirlink+0xa2>
    if(de.inum == 0)
    800040a8:	fc045783          	lhu	a5,-64(s0)
    800040ac:	c791                	beqz	a5,800040b8 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800040ae:	24c1                	addw	s1,s1,16
    800040b0:	04c92783          	lw	a5,76(s2)
    800040b4:	fcf4ede3          	bltu	s1,a5,8000408e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800040b8:	4639                	li	a2,14
    800040ba:	85d2                	mv	a1,s4
    800040bc:	fc240513          	add	a0,s0,-62
    800040c0:	ffffd097          	auipc	ra,0xffffd
    800040c4:	d4c080e7          	jalr	-692(ra) # 80000e0c <strncpy>
  de.inum = inum;
    800040c8:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800040cc:	4741                	li	a4,16
    800040ce:	86a6                	mv	a3,s1
    800040d0:	fc040613          	add	a2,s0,-64
    800040d4:	4581                	li	a1,0
    800040d6:	854a                	mv	a0,s2
    800040d8:	00000097          	auipc	ra,0x0
    800040dc:	c48080e7          	jalr	-952(ra) # 80003d20 <writei>
    800040e0:	872a                	mv	a4,a0
    800040e2:	47c1                	li	a5,16
  return 0;
    800040e4:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800040e6:	02f71863          	bne	a4,a5,80004116 <dirlink+0xb2>
}
    800040ea:	70e2                	ld	ra,56(sp)
    800040ec:	7442                	ld	s0,48(sp)
    800040ee:	74a2                	ld	s1,40(sp)
    800040f0:	7902                	ld	s2,32(sp)
    800040f2:	69e2                	ld	s3,24(sp)
    800040f4:	6a42                	ld	s4,16(sp)
    800040f6:	6121                	add	sp,sp,64
    800040f8:	8082                	ret
    iput(ip);
    800040fa:	00000097          	auipc	ra,0x0
    800040fe:	a36080e7          	jalr	-1482(ra) # 80003b30 <iput>
    return -1;
    80004102:	557d                	li	a0,-1
    80004104:	b7dd                	j	800040ea <dirlink+0x86>
      panic("dirlink read");
    80004106:	00004517          	auipc	a0,0x4
    8000410a:	52250513          	add	a0,a0,1314 # 80008628 <syscalls+0x1c8>
    8000410e:	ffffc097          	auipc	ra,0xffffc
    80004112:	434080e7          	jalr	1076(ra) # 80000542 <panic>
    panic("dirlink");
    80004116:	00004517          	auipc	a0,0x4
    8000411a:	63250513          	add	a0,a0,1586 # 80008748 <syscalls+0x2e8>
    8000411e:	ffffc097          	auipc	ra,0xffffc
    80004122:	424080e7          	jalr	1060(ra) # 80000542 <panic>

0000000080004126 <namei>:

struct inode*
namei(char *path)
{
    80004126:	1101                	add	sp,sp,-32
    80004128:	ec06                	sd	ra,24(sp)
    8000412a:	e822                	sd	s0,16(sp)
    8000412c:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000412e:	fe040613          	add	a2,s0,-32
    80004132:	4581                	li	a1,0
    80004134:	00000097          	auipc	ra,0x0
    80004138:	dd0080e7          	jalr	-560(ra) # 80003f04 <namex>
}
    8000413c:	60e2                	ld	ra,24(sp)
    8000413e:	6442                	ld	s0,16(sp)
    80004140:	6105                	add	sp,sp,32
    80004142:	8082                	ret

0000000080004144 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004144:	1141                	add	sp,sp,-16
    80004146:	e406                	sd	ra,8(sp)
    80004148:	e022                	sd	s0,0(sp)
    8000414a:	0800                	add	s0,sp,16
    8000414c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000414e:	4585                	li	a1,1
    80004150:	00000097          	auipc	ra,0x0
    80004154:	db4080e7          	jalr	-588(ra) # 80003f04 <namex>
}
    80004158:	60a2                	ld	ra,8(sp)
    8000415a:	6402                	ld	s0,0(sp)
    8000415c:	0141                	add	sp,sp,16
    8000415e:	8082                	ret

0000000080004160 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004160:	1101                	add	sp,sp,-32
    80004162:	ec06                	sd	ra,24(sp)
    80004164:	e822                	sd	s0,16(sp)
    80004166:	e426                	sd	s1,8(sp)
    80004168:	e04a                	sd	s2,0(sp)
    8000416a:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000416c:	0001e917          	auipc	s2,0x1e
    80004170:	99c90913          	add	s2,s2,-1636 # 80021b08 <log>
    80004174:	01892583          	lw	a1,24(s2)
    80004178:	02892503          	lw	a0,40(s2)
    8000417c:	fffff097          	auipc	ra,0xfffff
    80004180:	000080e7          	jalr	ra # 8000317c <bread>
    80004184:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004186:	02c92603          	lw	a2,44(s2)
    8000418a:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000418c:	00c05f63          	blez	a2,800041aa <write_head+0x4a>
    80004190:	0001e717          	auipc	a4,0x1e
    80004194:	9a870713          	add	a4,a4,-1624 # 80021b38 <log+0x30>
    80004198:	87aa                	mv	a5,a0
    8000419a:	060a                	sll	a2,a2,0x2
    8000419c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000419e:	4314                	lw	a3,0(a4)
    800041a0:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800041a2:	0711                	add	a4,a4,4
    800041a4:	0791                	add	a5,a5,4
    800041a6:	fec79ce3          	bne	a5,a2,8000419e <write_head+0x3e>
  }
  bwrite(buf);
    800041aa:	8526                	mv	a0,s1
    800041ac:	fffff097          	auipc	ra,0xfffff
    800041b0:	0c2080e7          	jalr	194(ra) # 8000326e <bwrite>
  brelse(buf);
    800041b4:	8526                	mv	a0,s1
    800041b6:	fffff097          	auipc	ra,0xfffff
    800041ba:	0f6080e7          	jalr	246(ra) # 800032ac <brelse>
}
    800041be:	60e2                	ld	ra,24(sp)
    800041c0:	6442                	ld	s0,16(sp)
    800041c2:	64a2                	ld	s1,8(sp)
    800041c4:	6902                	ld	s2,0(sp)
    800041c6:	6105                	add	sp,sp,32
    800041c8:	8082                	ret

00000000800041ca <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800041ca:	0001e797          	auipc	a5,0x1e
    800041ce:	96a7a783          	lw	a5,-1686(a5) # 80021b34 <log+0x2c>
    800041d2:	0af05663          	blez	a5,8000427e <install_trans+0xb4>
{
    800041d6:	7139                	add	sp,sp,-64
    800041d8:	fc06                	sd	ra,56(sp)
    800041da:	f822                	sd	s0,48(sp)
    800041dc:	f426                	sd	s1,40(sp)
    800041de:	f04a                	sd	s2,32(sp)
    800041e0:	ec4e                	sd	s3,24(sp)
    800041e2:	e852                	sd	s4,16(sp)
    800041e4:	e456                	sd	s5,8(sp)
    800041e6:	0080                	add	s0,sp,64
    800041e8:	0001ea97          	auipc	s5,0x1e
    800041ec:	950a8a93          	add	s5,s5,-1712 # 80021b38 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800041f0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800041f2:	0001e997          	auipc	s3,0x1e
    800041f6:	91698993          	add	s3,s3,-1770 # 80021b08 <log>
    800041fa:	0189a583          	lw	a1,24(s3)
    800041fe:	014585bb          	addw	a1,a1,s4
    80004202:	2585                	addw	a1,a1,1
    80004204:	0289a503          	lw	a0,40(s3)
    80004208:	fffff097          	auipc	ra,0xfffff
    8000420c:	f74080e7          	jalr	-140(ra) # 8000317c <bread>
    80004210:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004212:	000aa583          	lw	a1,0(s5)
    80004216:	0289a503          	lw	a0,40(s3)
    8000421a:	fffff097          	auipc	ra,0xfffff
    8000421e:	f62080e7          	jalr	-158(ra) # 8000317c <bread>
    80004222:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004224:	40000613          	li	a2,1024
    80004228:	05890593          	add	a1,s2,88
    8000422c:	05850513          	add	a0,a0,88
    80004230:	ffffd097          	auipc	ra,0xffffd
    80004234:	b24080e7          	jalr	-1244(ra) # 80000d54 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004238:	8526                	mv	a0,s1
    8000423a:	fffff097          	auipc	ra,0xfffff
    8000423e:	034080e7          	jalr	52(ra) # 8000326e <bwrite>
    bunpin(dbuf);
    80004242:	8526                	mv	a0,s1
    80004244:	fffff097          	auipc	ra,0xfffff
    80004248:	140080e7          	jalr	320(ra) # 80003384 <bunpin>
    brelse(lbuf);
    8000424c:	854a                	mv	a0,s2
    8000424e:	fffff097          	auipc	ra,0xfffff
    80004252:	05e080e7          	jalr	94(ra) # 800032ac <brelse>
    brelse(dbuf);
    80004256:	8526                	mv	a0,s1
    80004258:	fffff097          	auipc	ra,0xfffff
    8000425c:	054080e7          	jalr	84(ra) # 800032ac <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004260:	2a05                	addw	s4,s4,1
    80004262:	0a91                	add	s5,s5,4
    80004264:	02c9a783          	lw	a5,44(s3)
    80004268:	f8fa49e3          	blt	s4,a5,800041fa <install_trans+0x30>
}
    8000426c:	70e2                	ld	ra,56(sp)
    8000426e:	7442                	ld	s0,48(sp)
    80004270:	74a2                	ld	s1,40(sp)
    80004272:	7902                	ld	s2,32(sp)
    80004274:	69e2                	ld	s3,24(sp)
    80004276:	6a42                	ld	s4,16(sp)
    80004278:	6aa2                	ld	s5,8(sp)
    8000427a:	6121                	add	sp,sp,64
    8000427c:	8082                	ret
    8000427e:	8082                	ret

0000000080004280 <initlog>:
{
    80004280:	7179                	add	sp,sp,-48
    80004282:	f406                	sd	ra,40(sp)
    80004284:	f022                	sd	s0,32(sp)
    80004286:	ec26                	sd	s1,24(sp)
    80004288:	e84a                	sd	s2,16(sp)
    8000428a:	e44e                	sd	s3,8(sp)
    8000428c:	1800                	add	s0,sp,48
    8000428e:	892a                	mv	s2,a0
    80004290:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004292:	0001e497          	auipc	s1,0x1e
    80004296:	87648493          	add	s1,s1,-1930 # 80021b08 <log>
    8000429a:	00004597          	auipc	a1,0x4
    8000429e:	39e58593          	add	a1,a1,926 # 80008638 <syscalls+0x1d8>
    800042a2:	8526                	mv	a0,s1
    800042a4:	ffffd097          	auipc	ra,0xffffd
    800042a8:	8c8080e7          	jalr	-1848(ra) # 80000b6c <initlock>
  log.start = sb->logstart;
    800042ac:	0149a583          	lw	a1,20(s3)
    800042b0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800042b2:	0109a783          	lw	a5,16(s3)
    800042b6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800042b8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800042bc:	854a                	mv	a0,s2
    800042be:	fffff097          	auipc	ra,0xfffff
    800042c2:	ebe080e7          	jalr	-322(ra) # 8000317c <bread>
  log.lh.n = lh->n;
    800042c6:	4d30                	lw	a2,88(a0)
    800042c8:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800042ca:	00c05f63          	blez	a2,800042e8 <initlog+0x68>
    800042ce:	87aa                	mv	a5,a0
    800042d0:	0001e717          	auipc	a4,0x1e
    800042d4:	86870713          	add	a4,a4,-1944 # 80021b38 <log+0x30>
    800042d8:	060a                	sll	a2,a2,0x2
    800042da:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800042dc:	4ff4                	lw	a3,92(a5)
    800042de:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800042e0:	0791                	add	a5,a5,4
    800042e2:	0711                	add	a4,a4,4
    800042e4:	fec79ce3          	bne	a5,a2,800042dc <initlog+0x5c>
  brelse(buf);
    800042e8:	fffff097          	auipc	ra,0xfffff
    800042ec:	fc4080e7          	jalr	-60(ra) # 800032ac <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    800042f0:	00000097          	auipc	ra,0x0
    800042f4:	eda080e7          	jalr	-294(ra) # 800041ca <install_trans>
  log.lh.n = 0;
    800042f8:	0001e797          	auipc	a5,0x1e
    800042fc:	8207ae23          	sw	zero,-1988(a5) # 80021b34 <log+0x2c>
  write_head(); // clear the log
    80004300:	00000097          	auipc	ra,0x0
    80004304:	e60080e7          	jalr	-416(ra) # 80004160 <write_head>
}
    80004308:	70a2                	ld	ra,40(sp)
    8000430a:	7402                	ld	s0,32(sp)
    8000430c:	64e2                	ld	s1,24(sp)
    8000430e:	6942                	ld	s2,16(sp)
    80004310:	69a2                	ld	s3,8(sp)
    80004312:	6145                	add	sp,sp,48
    80004314:	8082                	ret

0000000080004316 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004316:	1101                	add	sp,sp,-32
    80004318:	ec06                	sd	ra,24(sp)
    8000431a:	e822                	sd	s0,16(sp)
    8000431c:	e426                	sd	s1,8(sp)
    8000431e:	e04a                	sd	s2,0(sp)
    80004320:	1000                	add	s0,sp,32
  acquire(&log.lock);
    80004322:	0001d517          	auipc	a0,0x1d
    80004326:	7e650513          	add	a0,a0,2022 # 80021b08 <log>
    8000432a:	ffffd097          	auipc	ra,0xffffd
    8000432e:	8d2080e7          	jalr	-1838(ra) # 80000bfc <acquire>
  while(1){
    if(log.committing){
    80004332:	0001d497          	auipc	s1,0x1d
    80004336:	7d648493          	add	s1,s1,2006 # 80021b08 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000433a:	4979                	li	s2,30
    8000433c:	a039                	j	8000434a <begin_op+0x34>
      sleep(&log, &log.lock);
    8000433e:	85a6                	mv	a1,s1
    80004340:	8526                	mv	a0,s1
    80004342:	ffffe097          	auipc	ra,0xffffe
    80004346:	16e080e7          	jalr	366(ra) # 800024b0 <sleep>
    if(log.committing){
    8000434a:	50dc                	lw	a5,36(s1)
    8000434c:	fbed                	bnez	a5,8000433e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000434e:	5098                	lw	a4,32(s1)
    80004350:	2705                	addw	a4,a4,1
    80004352:	0027179b          	sllw	a5,a4,0x2
    80004356:	9fb9                	addw	a5,a5,a4
    80004358:	0017979b          	sllw	a5,a5,0x1
    8000435c:	54d4                	lw	a3,44(s1)
    8000435e:	9fb5                	addw	a5,a5,a3
    80004360:	00f95963          	bge	s2,a5,80004372 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004364:	85a6                	mv	a1,s1
    80004366:	8526                	mv	a0,s1
    80004368:	ffffe097          	auipc	ra,0xffffe
    8000436c:	148080e7          	jalr	328(ra) # 800024b0 <sleep>
    80004370:	bfe9                	j	8000434a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004372:	0001d517          	auipc	a0,0x1d
    80004376:	79650513          	add	a0,a0,1942 # 80021b08 <log>
    8000437a:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000437c:	ffffd097          	auipc	ra,0xffffd
    80004380:	934080e7          	jalr	-1740(ra) # 80000cb0 <release>
      break;
    }
  }
}
    80004384:	60e2                	ld	ra,24(sp)
    80004386:	6442                	ld	s0,16(sp)
    80004388:	64a2                	ld	s1,8(sp)
    8000438a:	6902                	ld	s2,0(sp)
    8000438c:	6105                	add	sp,sp,32
    8000438e:	8082                	ret

0000000080004390 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004390:	7139                	add	sp,sp,-64
    80004392:	fc06                	sd	ra,56(sp)
    80004394:	f822                	sd	s0,48(sp)
    80004396:	f426                	sd	s1,40(sp)
    80004398:	f04a                	sd	s2,32(sp)
    8000439a:	ec4e                	sd	s3,24(sp)
    8000439c:	e852                	sd	s4,16(sp)
    8000439e:	e456                	sd	s5,8(sp)
    800043a0:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800043a2:	0001d497          	auipc	s1,0x1d
    800043a6:	76648493          	add	s1,s1,1894 # 80021b08 <log>
    800043aa:	8526                	mv	a0,s1
    800043ac:	ffffd097          	auipc	ra,0xffffd
    800043b0:	850080e7          	jalr	-1968(ra) # 80000bfc <acquire>
  log.outstanding -= 1;
    800043b4:	509c                	lw	a5,32(s1)
    800043b6:	37fd                	addw	a5,a5,-1
    800043b8:	0007891b          	sext.w	s2,a5
    800043bc:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800043be:	50dc                	lw	a5,36(s1)
    800043c0:	e7b9                	bnez	a5,8000440e <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800043c2:	04091e63          	bnez	s2,8000441e <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800043c6:	0001d497          	auipc	s1,0x1d
    800043ca:	74248493          	add	s1,s1,1858 # 80021b08 <log>
    800043ce:	4785                	li	a5,1
    800043d0:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800043d2:	8526                	mv	a0,s1
    800043d4:	ffffd097          	auipc	ra,0xffffd
    800043d8:	8dc080e7          	jalr	-1828(ra) # 80000cb0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800043dc:	54dc                	lw	a5,44(s1)
    800043de:	06f04763          	bgtz	a5,8000444c <end_op+0xbc>
    acquire(&log.lock);
    800043e2:	0001d497          	auipc	s1,0x1d
    800043e6:	72648493          	add	s1,s1,1830 # 80021b08 <log>
    800043ea:	8526                	mv	a0,s1
    800043ec:	ffffd097          	auipc	ra,0xffffd
    800043f0:	810080e7          	jalr	-2032(ra) # 80000bfc <acquire>
    log.committing = 0;
    800043f4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800043f8:	8526                	mv	a0,s1
    800043fa:	ffffe097          	auipc	ra,0xffffe
    800043fe:	236080e7          	jalr	566(ra) # 80002630 <wakeup>
    release(&log.lock);
    80004402:	8526                	mv	a0,s1
    80004404:	ffffd097          	auipc	ra,0xffffd
    80004408:	8ac080e7          	jalr	-1876(ra) # 80000cb0 <release>
}
    8000440c:	a03d                	j	8000443a <end_op+0xaa>
    panic("log.committing");
    8000440e:	00004517          	auipc	a0,0x4
    80004412:	23250513          	add	a0,a0,562 # 80008640 <syscalls+0x1e0>
    80004416:	ffffc097          	auipc	ra,0xffffc
    8000441a:	12c080e7          	jalr	300(ra) # 80000542 <panic>
    wakeup(&log);
    8000441e:	0001d497          	auipc	s1,0x1d
    80004422:	6ea48493          	add	s1,s1,1770 # 80021b08 <log>
    80004426:	8526                	mv	a0,s1
    80004428:	ffffe097          	auipc	ra,0xffffe
    8000442c:	208080e7          	jalr	520(ra) # 80002630 <wakeup>
  release(&log.lock);
    80004430:	8526                	mv	a0,s1
    80004432:	ffffd097          	auipc	ra,0xffffd
    80004436:	87e080e7          	jalr	-1922(ra) # 80000cb0 <release>
}
    8000443a:	70e2                	ld	ra,56(sp)
    8000443c:	7442                	ld	s0,48(sp)
    8000443e:	74a2                	ld	s1,40(sp)
    80004440:	7902                	ld	s2,32(sp)
    80004442:	69e2                	ld	s3,24(sp)
    80004444:	6a42                	ld	s4,16(sp)
    80004446:	6aa2                	ld	s5,8(sp)
    80004448:	6121                	add	sp,sp,64
    8000444a:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000444c:	0001da97          	auipc	s5,0x1d
    80004450:	6eca8a93          	add	s5,s5,1772 # 80021b38 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004454:	0001da17          	auipc	s4,0x1d
    80004458:	6b4a0a13          	add	s4,s4,1716 # 80021b08 <log>
    8000445c:	018a2583          	lw	a1,24(s4)
    80004460:	012585bb          	addw	a1,a1,s2
    80004464:	2585                	addw	a1,a1,1
    80004466:	028a2503          	lw	a0,40(s4)
    8000446a:	fffff097          	auipc	ra,0xfffff
    8000446e:	d12080e7          	jalr	-750(ra) # 8000317c <bread>
    80004472:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004474:	000aa583          	lw	a1,0(s5)
    80004478:	028a2503          	lw	a0,40(s4)
    8000447c:	fffff097          	auipc	ra,0xfffff
    80004480:	d00080e7          	jalr	-768(ra) # 8000317c <bread>
    80004484:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004486:	40000613          	li	a2,1024
    8000448a:	05850593          	add	a1,a0,88
    8000448e:	05848513          	add	a0,s1,88
    80004492:	ffffd097          	auipc	ra,0xffffd
    80004496:	8c2080e7          	jalr	-1854(ra) # 80000d54 <memmove>
    bwrite(to);  // write the log
    8000449a:	8526                	mv	a0,s1
    8000449c:	fffff097          	auipc	ra,0xfffff
    800044a0:	dd2080e7          	jalr	-558(ra) # 8000326e <bwrite>
    brelse(from);
    800044a4:	854e                	mv	a0,s3
    800044a6:	fffff097          	auipc	ra,0xfffff
    800044aa:	e06080e7          	jalr	-506(ra) # 800032ac <brelse>
    brelse(to);
    800044ae:	8526                	mv	a0,s1
    800044b0:	fffff097          	auipc	ra,0xfffff
    800044b4:	dfc080e7          	jalr	-516(ra) # 800032ac <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800044b8:	2905                	addw	s2,s2,1
    800044ba:	0a91                	add	s5,s5,4
    800044bc:	02ca2783          	lw	a5,44(s4)
    800044c0:	f8f94ee3          	blt	s2,a5,8000445c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800044c4:	00000097          	auipc	ra,0x0
    800044c8:	c9c080e7          	jalr	-868(ra) # 80004160 <write_head>
    install_trans(); // Now install writes to home locations
    800044cc:	00000097          	auipc	ra,0x0
    800044d0:	cfe080e7          	jalr	-770(ra) # 800041ca <install_trans>
    log.lh.n = 0;
    800044d4:	0001d797          	auipc	a5,0x1d
    800044d8:	6607a023          	sw	zero,1632(a5) # 80021b34 <log+0x2c>
    write_head();    // Erase the transaction from the log
    800044dc:	00000097          	auipc	ra,0x0
    800044e0:	c84080e7          	jalr	-892(ra) # 80004160 <write_head>
    800044e4:	bdfd                	j	800043e2 <end_op+0x52>

00000000800044e6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800044e6:	1101                	add	sp,sp,-32
    800044e8:	ec06                	sd	ra,24(sp)
    800044ea:	e822                	sd	s0,16(sp)
    800044ec:	e426                	sd	s1,8(sp)
    800044ee:	e04a                	sd	s2,0(sp)
    800044f0:	1000                	add	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800044f2:	0001d717          	auipc	a4,0x1d
    800044f6:	64272703          	lw	a4,1602(a4) # 80021b34 <log+0x2c>
    800044fa:	47f5                	li	a5,29
    800044fc:	08e7c063          	blt	a5,a4,8000457c <log_write+0x96>
    80004500:	84aa                	mv	s1,a0
    80004502:	0001d797          	auipc	a5,0x1d
    80004506:	6227a783          	lw	a5,1570(a5) # 80021b24 <log+0x1c>
    8000450a:	37fd                	addw	a5,a5,-1
    8000450c:	06f75863          	bge	a4,a5,8000457c <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004510:	0001d797          	auipc	a5,0x1d
    80004514:	6187a783          	lw	a5,1560(a5) # 80021b28 <log+0x20>
    80004518:	06f05a63          	blez	a5,8000458c <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    8000451c:	0001d917          	auipc	s2,0x1d
    80004520:	5ec90913          	add	s2,s2,1516 # 80021b08 <log>
    80004524:	854a                	mv	a0,s2
    80004526:	ffffc097          	auipc	ra,0xffffc
    8000452a:	6d6080e7          	jalr	1750(ra) # 80000bfc <acquire>
  for (i = 0; i < log.lh.n; i++) {
    8000452e:	02c92603          	lw	a2,44(s2)
    80004532:	06c05563          	blez	a2,8000459c <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004536:	44cc                	lw	a1,12(s1)
    80004538:	0001d717          	auipc	a4,0x1d
    8000453c:	60070713          	add	a4,a4,1536 # 80021b38 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004540:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004542:	4314                	lw	a3,0(a4)
    80004544:	04b68d63          	beq	a3,a1,8000459e <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    80004548:	2785                	addw	a5,a5,1
    8000454a:	0711                	add	a4,a4,4
    8000454c:	fec79be3          	bne	a5,a2,80004542 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004550:	0621                	add	a2,a2,8
    80004552:	060a                	sll	a2,a2,0x2
    80004554:	0001d797          	auipc	a5,0x1d
    80004558:	5b478793          	add	a5,a5,1460 # 80021b08 <log>
    8000455c:	97b2                	add	a5,a5,a2
    8000455e:	44d8                	lw	a4,12(s1)
    80004560:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004562:	8526                	mv	a0,s1
    80004564:	fffff097          	auipc	ra,0xfffff
    80004568:	de4080e7          	jalr	-540(ra) # 80003348 <bpin>
    log.lh.n++;
    8000456c:	0001d717          	auipc	a4,0x1d
    80004570:	59c70713          	add	a4,a4,1436 # 80021b08 <log>
    80004574:	575c                	lw	a5,44(a4)
    80004576:	2785                	addw	a5,a5,1
    80004578:	d75c                	sw	a5,44(a4)
    8000457a:	a835                	j	800045b6 <log_write+0xd0>
    panic("too big a transaction");
    8000457c:	00004517          	auipc	a0,0x4
    80004580:	0d450513          	add	a0,a0,212 # 80008650 <syscalls+0x1f0>
    80004584:	ffffc097          	auipc	ra,0xffffc
    80004588:	fbe080e7          	jalr	-66(ra) # 80000542 <panic>
    panic("log_write outside of trans");
    8000458c:	00004517          	auipc	a0,0x4
    80004590:	0dc50513          	add	a0,a0,220 # 80008668 <syscalls+0x208>
    80004594:	ffffc097          	auipc	ra,0xffffc
    80004598:	fae080e7          	jalr	-82(ra) # 80000542 <panic>
  for (i = 0; i < log.lh.n; i++) {
    8000459c:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    8000459e:	00878693          	add	a3,a5,8
    800045a2:	068a                	sll	a3,a3,0x2
    800045a4:	0001d717          	auipc	a4,0x1d
    800045a8:	56470713          	add	a4,a4,1380 # 80021b08 <log>
    800045ac:	9736                	add	a4,a4,a3
    800045ae:	44d4                	lw	a3,12(s1)
    800045b0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800045b2:	faf608e3          	beq	a2,a5,80004562 <log_write+0x7c>
  }
  release(&log.lock);
    800045b6:	0001d517          	auipc	a0,0x1d
    800045ba:	55250513          	add	a0,a0,1362 # 80021b08 <log>
    800045be:	ffffc097          	auipc	ra,0xffffc
    800045c2:	6f2080e7          	jalr	1778(ra) # 80000cb0 <release>
}
    800045c6:	60e2                	ld	ra,24(sp)
    800045c8:	6442                	ld	s0,16(sp)
    800045ca:	64a2                	ld	s1,8(sp)
    800045cc:	6902                	ld	s2,0(sp)
    800045ce:	6105                	add	sp,sp,32
    800045d0:	8082                	ret

00000000800045d2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800045d2:	1101                	add	sp,sp,-32
    800045d4:	ec06                	sd	ra,24(sp)
    800045d6:	e822                	sd	s0,16(sp)
    800045d8:	e426                	sd	s1,8(sp)
    800045da:	e04a                	sd	s2,0(sp)
    800045dc:	1000                	add	s0,sp,32
    800045de:	84aa                	mv	s1,a0
    800045e0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800045e2:	00004597          	auipc	a1,0x4
    800045e6:	0a658593          	add	a1,a1,166 # 80008688 <syscalls+0x228>
    800045ea:	0521                	add	a0,a0,8
    800045ec:	ffffc097          	auipc	ra,0xffffc
    800045f0:	580080e7          	jalr	1408(ra) # 80000b6c <initlock>
  lk->name = name;
    800045f4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800045f8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800045fc:	0204a423          	sw	zero,40(s1)
}
    80004600:	60e2                	ld	ra,24(sp)
    80004602:	6442                	ld	s0,16(sp)
    80004604:	64a2                	ld	s1,8(sp)
    80004606:	6902                	ld	s2,0(sp)
    80004608:	6105                	add	sp,sp,32
    8000460a:	8082                	ret

000000008000460c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000460c:	1101                	add	sp,sp,-32
    8000460e:	ec06                	sd	ra,24(sp)
    80004610:	e822                	sd	s0,16(sp)
    80004612:	e426                	sd	s1,8(sp)
    80004614:	e04a                	sd	s2,0(sp)
    80004616:	1000                	add	s0,sp,32
    80004618:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000461a:	00850913          	add	s2,a0,8
    8000461e:	854a                	mv	a0,s2
    80004620:	ffffc097          	auipc	ra,0xffffc
    80004624:	5dc080e7          	jalr	1500(ra) # 80000bfc <acquire>
  while (lk->locked) {
    80004628:	409c                	lw	a5,0(s1)
    8000462a:	cb89                	beqz	a5,8000463c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000462c:	85ca                	mv	a1,s2
    8000462e:	8526                	mv	a0,s1
    80004630:	ffffe097          	auipc	ra,0xffffe
    80004634:	e80080e7          	jalr	-384(ra) # 800024b0 <sleep>
  while (lk->locked) {
    80004638:	409c                	lw	a5,0(s1)
    8000463a:	fbed                	bnez	a5,8000462c <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000463c:	4785                	li	a5,1
    8000463e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004640:	ffffd097          	auipc	ra,0xffffd
    80004644:	450080e7          	jalr	1104(ra) # 80001a90 <myproc>
    80004648:	5d1c                	lw	a5,56(a0)
    8000464a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000464c:	854a                	mv	a0,s2
    8000464e:	ffffc097          	auipc	ra,0xffffc
    80004652:	662080e7          	jalr	1634(ra) # 80000cb0 <release>
}
    80004656:	60e2                	ld	ra,24(sp)
    80004658:	6442                	ld	s0,16(sp)
    8000465a:	64a2                	ld	s1,8(sp)
    8000465c:	6902                	ld	s2,0(sp)
    8000465e:	6105                	add	sp,sp,32
    80004660:	8082                	ret

0000000080004662 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004662:	1101                	add	sp,sp,-32
    80004664:	ec06                	sd	ra,24(sp)
    80004666:	e822                	sd	s0,16(sp)
    80004668:	e426                	sd	s1,8(sp)
    8000466a:	e04a                	sd	s2,0(sp)
    8000466c:	1000                	add	s0,sp,32
    8000466e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004670:	00850913          	add	s2,a0,8
    80004674:	854a                	mv	a0,s2
    80004676:	ffffc097          	auipc	ra,0xffffc
    8000467a:	586080e7          	jalr	1414(ra) # 80000bfc <acquire>
  lk->locked = 0;
    8000467e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004682:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004686:	8526                	mv	a0,s1
    80004688:	ffffe097          	auipc	ra,0xffffe
    8000468c:	fa8080e7          	jalr	-88(ra) # 80002630 <wakeup>
  release(&lk->lk);
    80004690:	854a                	mv	a0,s2
    80004692:	ffffc097          	auipc	ra,0xffffc
    80004696:	61e080e7          	jalr	1566(ra) # 80000cb0 <release>
}
    8000469a:	60e2                	ld	ra,24(sp)
    8000469c:	6442                	ld	s0,16(sp)
    8000469e:	64a2                	ld	s1,8(sp)
    800046a0:	6902                	ld	s2,0(sp)
    800046a2:	6105                	add	sp,sp,32
    800046a4:	8082                	ret

00000000800046a6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800046a6:	7179                	add	sp,sp,-48
    800046a8:	f406                	sd	ra,40(sp)
    800046aa:	f022                	sd	s0,32(sp)
    800046ac:	ec26                	sd	s1,24(sp)
    800046ae:	e84a                	sd	s2,16(sp)
    800046b0:	e44e                	sd	s3,8(sp)
    800046b2:	1800                	add	s0,sp,48
    800046b4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800046b6:	00850913          	add	s2,a0,8
    800046ba:	854a                	mv	a0,s2
    800046bc:	ffffc097          	auipc	ra,0xffffc
    800046c0:	540080e7          	jalr	1344(ra) # 80000bfc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800046c4:	409c                	lw	a5,0(s1)
    800046c6:	ef99                	bnez	a5,800046e4 <holdingsleep+0x3e>
    800046c8:	4481                	li	s1,0
  release(&lk->lk);
    800046ca:	854a                	mv	a0,s2
    800046cc:	ffffc097          	auipc	ra,0xffffc
    800046d0:	5e4080e7          	jalr	1508(ra) # 80000cb0 <release>
  return r;
}
    800046d4:	8526                	mv	a0,s1
    800046d6:	70a2                	ld	ra,40(sp)
    800046d8:	7402                	ld	s0,32(sp)
    800046da:	64e2                	ld	s1,24(sp)
    800046dc:	6942                	ld	s2,16(sp)
    800046de:	69a2                	ld	s3,8(sp)
    800046e0:	6145                	add	sp,sp,48
    800046e2:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800046e4:	0284a983          	lw	s3,40(s1)
    800046e8:	ffffd097          	auipc	ra,0xffffd
    800046ec:	3a8080e7          	jalr	936(ra) # 80001a90 <myproc>
    800046f0:	5d04                	lw	s1,56(a0)
    800046f2:	413484b3          	sub	s1,s1,s3
    800046f6:	0014b493          	seqz	s1,s1
    800046fa:	bfc1                	j	800046ca <holdingsleep+0x24>

00000000800046fc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800046fc:	1141                	add	sp,sp,-16
    800046fe:	e406                	sd	ra,8(sp)
    80004700:	e022                	sd	s0,0(sp)
    80004702:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004704:	00004597          	auipc	a1,0x4
    80004708:	f9458593          	add	a1,a1,-108 # 80008698 <syscalls+0x238>
    8000470c:	0001d517          	auipc	a0,0x1d
    80004710:	54450513          	add	a0,a0,1348 # 80021c50 <ftable>
    80004714:	ffffc097          	auipc	ra,0xffffc
    80004718:	458080e7          	jalr	1112(ra) # 80000b6c <initlock>
}
    8000471c:	60a2                	ld	ra,8(sp)
    8000471e:	6402                	ld	s0,0(sp)
    80004720:	0141                	add	sp,sp,16
    80004722:	8082                	ret

0000000080004724 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004724:	1101                	add	sp,sp,-32
    80004726:	ec06                	sd	ra,24(sp)
    80004728:	e822                	sd	s0,16(sp)
    8000472a:	e426                	sd	s1,8(sp)
    8000472c:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000472e:	0001d517          	auipc	a0,0x1d
    80004732:	52250513          	add	a0,a0,1314 # 80021c50 <ftable>
    80004736:	ffffc097          	auipc	ra,0xffffc
    8000473a:	4c6080e7          	jalr	1222(ra) # 80000bfc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000473e:	0001d497          	auipc	s1,0x1d
    80004742:	52a48493          	add	s1,s1,1322 # 80021c68 <ftable+0x18>
    80004746:	0001e717          	auipc	a4,0x1e
    8000474a:	4c270713          	add	a4,a4,1218 # 80022c08 <ftable+0xfb8>
    if(f->ref == 0){
    8000474e:	40dc                	lw	a5,4(s1)
    80004750:	cf99                	beqz	a5,8000476e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004752:	02848493          	add	s1,s1,40
    80004756:	fee49ce3          	bne	s1,a4,8000474e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000475a:	0001d517          	auipc	a0,0x1d
    8000475e:	4f650513          	add	a0,a0,1270 # 80021c50 <ftable>
    80004762:	ffffc097          	auipc	ra,0xffffc
    80004766:	54e080e7          	jalr	1358(ra) # 80000cb0 <release>
  return 0;
    8000476a:	4481                	li	s1,0
    8000476c:	a819                	j	80004782 <filealloc+0x5e>
      f->ref = 1;
    8000476e:	4785                	li	a5,1
    80004770:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004772:	0001d517          	auipc	a0,0x1d
    80004776:	4de50513          	add	a0,a0,1246 # 80021c50 <ftable>
    8000477a:	ffffc097          	auipc	ra,0xffffc
    8000477e:	536080e7          	jalr	1334(ra) # 80000cb0 <release>
}
    80004782:	8526                	mv	a0,s1
    80004784:	60e2                	ld	ra,24(sp)
    80004786:	6442                	ld	s0,16(sp)
    80004788:	64a2                	ld	s1,8(sp)
    8000478a:	6105                	add	sp,sp,32
    8000478c:	8082                	ret

000000008000478e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000478e:	1101                	add	sp,sp,-32
    80004790:	ec06                	sd	ra,24(sp)
    80004792:	e822                	sd	s0,16(sp)
    80004794:	e426                	sd	s1,8(sp)
    80004796:	1000                	add	s0,sp,32
    80004798:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000479a:	0001d517          	auipc	a0,0x1d
    8000479e:	4b650513          	add	a0,a0,1206 # 80021c50 <ftable>
    800047a2:	ffffc097          	auipc	ra,0xffffc
    800047a6:	45a080e7          	jalr	1114(ra) # 80000bfc <acquire>
  if(f->ref < 1)
    800047aa:	40dc                	lw	a5,4(s1)
    800047ac:	02f05263          	blez	a5,800047d0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800047b0:	2785                	addw	a5,a5,1
    800047b2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800047b4:	0001d517          	auipc	a0,0x1d
    800047b8:	49c50513          	add	a0,a0,1180 # 80021c50 <ftable>
    800047bc:	ffffc097          	auipc	ra,0xffffc
    800047c0:	4f4080e7          	jalr	1268(ra) # 80000cb0 <release>
  return f;
}
    800047c4:	8526                	mv	a0,s1
    800047c6:	60e2                	ld	ra,24(sp)
    800047c8:	6442                	ld	s0,16(sp)
    800047ca:	64a2                	ld	s1,8(sp)
    800047cc:	6105                	add	sp,sp,32
    800047ce:	8082                	ret
    panic("filedup");
    800047d0:	00004517          	auipc	a0,0x4
    800047d4:	ed050513          	add	a0,a0,-304 # 800086a0 <syscalls+0x240>
    800047d8:	ffffc097          	auipc	ra,0xffffc
    800047dc:	d6a080e7          	jalr	-662(ra) # 80000542 <panic>

00000000800047e0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800047e0:	7139                	add	sp,sp,-64
    800047e2:	fc06                	sd	ra,56(sp)
    800047e4:	f822                	sd	s0,48(sp)
    800047e6:	f426                	sd	s1,40(sp)
    800047e8:	f04a                	sd	s2,32(sp)
    800047ea:	ec4e                	sd	s3,24(sp)
    800047ec:	e852                	sd	s4,16(sp)
    800047ee:	e456                	sd	s5,8(sp)
    800047f0:	0080                	add	s0,sp,64
    800047f2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800047f4:	0001d517          	auipc	a0,0x1d
    800047f8:	45c50513          	add	a0,a0,1116 # 80021c50 <ftable>
    800047fc:	ffffc097          	auipc	ra,0xffffc
    80004800:	400080e7          	jalr	1024(ra) # 80000bfc <acquire>
  if(f->ref < 1)
    80004804:	40dc                	lw	a5,4(s1)
    80004806:	06f05163          	blez	a5,80004868 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    8000480a:	37fd                	addw	a5,a5,-1
    8000480c:	0007871b          	sext.w	a4,a5
    80004810:	c0dc                	sw	a5,4(s1)
    80004812:	06e04363          	bgtz	a4,80004878 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004816:	0004a903          	lw	s2,0(s1)
    8000481a:	0094ca83          	lbu	s5,9(s1)
    8000481e:	0104ba03          	ld	s4,16(s1)
    80004822:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004826:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000482a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000482e:	0001d517          	auipc	a0,0x1d
    80004832:	42250513          	add	a0,a0,1058 # 80021c50 <ftable>
    80004836:	ffffc097          	auipc	ra,0xffffc
    8000483a:	47a080e7          	jalr	1146(ra) # 80000cb0 <release>

  if(ff.type == FD_PIPE){
    8000483e:	4785                	li	a5,1
    80004840:	04f90d63          	beq	s2,a5,8000489a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004844:	3979                	addw	s2,s2,-2
    80004846:	4785                	li	a5,1
    80004848:	0527e063          	bltu	a5,s2,80004888 <fileclose+0xa8>
    begin_op();
    8000484c:	00000097          	auipc	ra,0x0
    80004850:	aca080e7          	jalr	-1334(ra) # 80004316 <begin_op>
    iput(ff.ip);
    80004854:	854e                	mv	a0,s3
    80004856:	fffff097          	auipc	ra,0xfffff
    8000485a:	2da080e7          	jalr	730(ra) # 80003b30 <iput>
    end_op();
    8000485e:	00000097          	auipc	ra,0x0
    80004862:	b32080e7          	jalr	-1230(ra) # 80004390 <end_op>
    80004866:	a00d                	j	80004888 <fileclose+0xa8>
    panic("fileclose");
    80004868:	00004517          	auipc	a0,0x4
    8000486c:	e4050513          	add	a0,a0,-448 # 800086a8 <syscalls+0x248>
    80004870:	ffffc097          	auipc	ra,0xffffc
    80004874:	cd2080e7          	jalr	-814(ra) # 80000542 <panic>
    release(&ftable.lock);
    80004878:	0001d517          	auipc	a0,0x1d
    8000487c:	3d850513          	add	a0,a0,984 # 80021c50 <ftable>
    80004880:	ffffc097          	auipc	ra,0xffffc
    80004884:	430080e7          	jalr	1072(ra) # 80000cb0 <release>
  }
}
    80004888:	70e2                	ld	ra,56(sp)
    8000488a:	7442                	ld	s0,48(sp)
    8000488c:	74a2                	ld	s1,40(sp)
    8000488e:	7902                	ld	s2,32(sp)
    80004890:	69e2                	ld	s3,24(sp)
    80004892:	6a42                	ld	s4,16(sp)
    80004894:	6aa2                	ld	s5,8(sp)
    80004896:	6121                	add	sp,sp,64
    80004898:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000489a:	85d6                	mv	a1,s5
    8000489c:	8552                	mv	a0,s4
    8000489e:	00000097          	auipc	ra,0x0
    800048a2:	372080e7          	jalr	882(ra) # 80004c10 <pipeclose>
    800048a6:	b7cd                	j	80004888 <fileclose+0xa8>

00000000800048a8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800048a8:	715d                	add	sp,sp,-80
    800048aa:	e486                	sd	ra,72(sp)
    800048ac:	e0a2                	sd	s0,64(sp)
    800048ae:	fc26                	sd	s1,56(sp)
    800048b0:	f84a                	sd	s2,48(sp)
    800048b2:	f44e                	sd	s3,40(sp)
    800048b4:	0880                	add	s0,sp,80
    800048b6:	84aa                	mv	s1,a0
    800048b8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800048ba:	ffffd097          	auipc	ra,0xffffd
    800048be:	1d6080e7          	jalr	470(ra) # 80001a90 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800048c2:	409c                	lw	a5,0(s1)
    800048c4:	37f9                	addw	a5,a5,-2
    800048c6:	4705                	li	a4,1
    800048c8:	04f76763          	bltu	a4,a5,80004916 <filestat+0x6e>
    800048cc:	892a                	mv	s2,a0
    ilock(f->ip);
    800048ce:	6c88                	ld	a0,24(s1)
    800048d0:	fffff097          	auipc	ra,0xfffff
    800048d4:	0a6080e7          	jalr	166(ra) # 80003976 <ilock>
    stati(f->ip, &st);
    800048d8:	fb840593          	add	a1,s0,-72
    800048dc:	6c88                	ld	a0,24(s1)
    800048de:	fffff097          	auipc	ra,0xfffff
    800048e2:	322080e7          	jalr	802(ra) # 80003c00 <stati>
    iunlock(f->ip);
    800048e6:	6c88                	ld	a0,24(s1)
    800048e8:	fffff097          	auipc	ra,0xfffff
    800048ec:	150080e7          	jalr	336(ra) # 80003a38 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800048f0:	46e1                	li	a3,24
    800048f2:	fb840613          	add	a2,s0,-72
    800048f6:	85ce                	mv	a1,s3
    800048f8:	05093503          	ld	a0,80(s2)
    800048fc:	ffffd097          	auipc	ra,0xffffd
    80004900:	dfe080e7          	jalr	-514(ra) # 800016fa <copyout>
    80004904:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004908:	60a6                	ld	ra,72(sp)
    8000490a:	6406                	ld	s0,64(sp)
    8000490c:	74e2                	ld	s1,56(sp)
    8000490e:	7942                	ld	s2,48(sp)
    80004910:	79a2                	ld	s3,40(sp)
    80004912:	6161                	add	sp,sp,80
    80004914:	8082                	ret
  return -1;
    80004916:	557d                	li	a0,-1
    80004918:	bfc5                	j	80004908 <filestat+0x60>

000000008000491a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000491a:	7179                	add	sp,sp,-48
    8000491c:	f406                	sd	ra,40(sp)
    8000491e:	f022                	sd	s0,32(sp)
    80004920:	ec26                	sd	s1,24(sp)
    80004922:	e84a                	sd	s2,16(sp)
    80004924:	e44e                	sd	s3,8(sp)
    80004926:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004928:	00854783          	lbu	a5,8(a0)
    8000492c:	c3d5                	beqz	a5,800049d0 <fileread+0xb6>
    8000492e:	84aa                	mv	s1,a0
    80004930:	89ae                	mv	s3,a1
    80004932:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004934:	411c                	lw	a5,0(a0)
    80004936:	4705                	li	a4,1
    80004938:	04e78963          	beq	a5,a4,8000498a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000493c:	470d                	li	a4,3
    8000493e:	04e78d63          	beq	a5,a4,80004998 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004942:	4709                	li	a4,2
    80004944:	06e79e63          	bne	a5,a4,800049c0 <fileread+0xa6>
    ilock(f->ip);
    80004948:	6d08                	ld	a0,24(a0)
    8000494a:	fffff097          	auipc	ra,0xfffff
    8000494e:	02c080e7          	jalr	44(ra) # 80003976 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004952:	874a                	mv	a4,s2
    80004954:	5094                	lw	a3,32(s1)
    80004956:	864e                	mv	a2,s3
    80004958:	4585                	li	a1,1
    8000495a:	6c88                	ld	a0,24(s1)
    8000495c:	fffff097          	auipc	ra,0xfffff
    80004960:	2ce080e7          	jalr	718(ra) # 80003c2a <readi>
    80004964:	892a                	mv	s2,a0
    80004966:	00a05563          	blez	a0,80004970 <fileread+0x56>
      f->off += r;
    8000496a:	509c                	lw	a5,32(s1)
    8000496c:	9fa9                	addw	a5,a5,a0
    8000496e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004970:	6c88                	ld	a0,24(s1)
    80004972:	fffff097          	auipc	ra,0xfffff
    80004976:	0c6080e7          	jalr	198(ra) # 80003a38 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    8000497a:	854a                	mv	a0,s2
    8000497c:	70a2                	ld	ra,40(sp)
    8000497e:	7402                	ld	s0,32(sp)
    80004980:	64e2                	ld	s1,24(sp)
    80004982:	6942                	ld	s2,16(sp)
    80004984:	69a2                	ld	s3,8(sp)
    80004986:	6145                	add	sp,sp,48
    80004988:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000498a:	6908                	ld	a0,16(a0)
    8000498c:	00000097          	auipc	ra,0x0
    80004990:	3ee080e7          	jalr	1006(ra) # 80004d7a <piperead>
    80004994:	892a                	mv	s2,a0
    80004996:	b7d5                	j	8000497a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004998:	02451783          	lh	a5,36(a0)
    8000499c:	03079693          	sll	a3,a5,0x30
    800049a0:	92c1                	srl	a3,a3,0x30
    800049a2:	4725                	li	a4,9
    800049a4:	02d76863          	bltu	a4,a3,800049d4 <fileread+0xba>
    800049a8:	0792                	sll	a5,a5,0x4
    800049aa:	0001d717          	auipc	a4,0x1d
    800049ae:	20670713          	add	a4,a4,518 # 80021bb0 <devsw>
    800049b2:	97ba                	add	a5,a5,a4
    800049b4:	639c                	ld	a5,0(a5)
    800049b6:	c38d                	beqz	a5,800049d8 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800049b8:	4505                	li	a0,1
    800049ba:	9782                	jalr	a5
    800049bc:	892a                	mv	s2,a0
    800049be:	bf75                	j	8000497a <fileread+0x60>
    panic("fileread");
    800049c0:	00004517          	auipc	a0,0x4
    800049c4:	cf850513          	add	a0,a0,-776 # 800086b8 <syscalls+0x258>
    800049c8:	ffffc097          	auipc	ra,0xffffc
    800049cc:	b7a080e7          	jalr	-1158(ra) # 80000542 <panic>
    return -1;
    800049d0:	597d                	li	s2,-1
    800049d2:	b765                	j	8000497a <fileread+0x60>
      return -1;
    800049d4:	597d                	li	s2,-1
    800049d6:	b755                	j	8000497a <fileread+0x60>
    800049d8:	597d                	li	s2,-1
    800049da:	b745                	j	8000497a <fileread+0x60>

00000000800049dc <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800049dc:	00954783          	lbu	a5,9(a0)
    800049e0:	14078363          	beqz	a5,80004b26 <filewrite+0x14a>
{
    800049e4:	715d                	add	sp,sp,-80
    800049e6:	e486                	sd	ra,72(sp)
    800049e8:	e0a2                	sd	s0,64(sp)
    800049ea:	fc26                	sd	s1,56(sp)
    800049ec:	f84a                	sd	s2,48(sp)
    800049ee:	f44e                	sd	s3,40(sp)
    800049f0:	f052                	sd	s4,32(sp)
    800049f2:	ec56                	sd	s5,24(sp)
    800049f4:	e85a                	sd	s6,16(sp)
    800049f6:	e45e                	sd	s7,8(sp)
    800049f8:	e062                	sd	s8,0(sp)
    800049fa:	0880                	add	s0,sp,80
    800049fc:	892a                	mv	s2,a0
    800049fe:	8b2e                	mv	s6,a1
    80004a00:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004a02:	411c                	lw	a5,0(a0)
    80004a04:	4705                	li	a4,1
    80004a06:	02e78263          	beq	a5,a4,80004a2a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004a0a:	470d                	li	a4,3
    80004a0c:	02e78563          	beq	a5,a4,80004a36 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004a10:	4709                	li	a4,2
    80004a12:	10e79263          	bne	a5,a4,80004b16 <filewrite+0x13a>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004a16:	0ec05e63          	blez	a2,80004b12 <filewrite+0x136>
    int i = 0;
    80004a1a:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004a1c:	6b85                	lui	s7,0x1
    80004a1e:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004a22:	6c05                	lui	s8,0x1
    80004a24:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004a28:	a851                	j	80004abc <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004a2a:	6908                	ld	a0,16(a0)
    80004a2c:	00000097          	auipc	ra,0x0
    80004a30:	254080e7          	jalr	596(ra) # 80004c80 <pipewrite>
    80004a34:	a85d                	j	80004aea <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004a36:	02451783          	lh	a5,36(a0)
    80004a3a:	03079693          	sll	a3,a5,0x30
    80004a3e:	92c1                	srl	a3,a3,0x30
    80004a40:	4725                	li	a4,9
    80004a42:	0ed76463          	bltu	a4,a3,80004b2a <filewrite+0x14e>
    80004a46:	0792                	sll	a5,a5,0x4
    80004a48:	0001d717          	auipc	a4,0x1d
    80004a4c:	16870713          	add	a4,a4,360 # 80021bb0 <devsw>
    80004a50:	97ba                	add	a5,a5,a4
    80004a52:	679c                	ld	a5,8(a5)
    80004a54:	cfe9                	beqz	a5,80004b2e <filewrite+0x152>
    ret = devsw[f->major].write(1, addr, n);
    80004a56:	4505                	li	a0,1
    80004a58:	9782                	jalr	a5
    80004a5a:	a841                	j	80004aea <filewrite+0x10e>
      if(n1 > max)
    80004a5c:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004a60:	00000097          	auipc	ra,0x0
    80004a64:	8b6080e7          	jalr	-1866(ra) # 80004316 <begin_op>
      ilock(f->ip);
    80004a68:	01893503          	ld	a0,24(s2)
    80004a6c:	fffff097          	auipc	ra,0xfffff
    80004a70:	f0a080e7          	jalr	-246(ra) # 80003976 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004a74:	8756                	mv	a4,s5
    80004a76:	02092683          	lw	a3,32(s2)
    80004a7a:	01698633          	add	a2,s3,s6
    80004a7e:	4585                	li	a1,1
    80004a80:	01893503          	ld	a0,24(s2)
    80004a84:	fffff097          	auipc	ra,0xfffff
    80004a88:	29c080e7          	jalr	668(ra) # 80003d20 <writei>
    80004a8c:	84aa                	mv	s1,a0
    80004a8e:	02a05f63          	blez	a0,80004acc <filewrite+0xf0>
        f->off += r;
    80004a92:	02092783          	lw	a5,32(s2)
    80004a96:	9fa9                	addw	a5,a5,a0
    80004a98:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004a9c:	01893503          	ld	a0,24(s2)
    80004aa0:	fffff097          	auipc	ra,0xfffff
    80004aa4:	f98080e7          	jalr	-104(ra) # 80003a38 <iunlock>
      end_op();
    80004aa8:	00000097          	auipc	ra,0x0
    80004aac:	8e8080e7          	jalr	-1816(ra) # 80004390 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004ab0:	049a9963          	bne	s5,s1,80004b02 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    80004ab4:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004ab8:	0349d663          	bge	s3,s4,80004ae4 <filewrite+0x108>
      int n1 = n - i;
    80004abc:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004ac0:	0004879b          	sext.w	a5,s1
    80004ac4:	f8fbdce3          	bge	s7,a5,80004a5c <filewrite+0x80>
    80004ac8:	84e2                	mv	s1,s8
    80004aca:	bf49                	j	80004a5c <filewrite+0x80>
      iunlock(f->ip);
    80004acc:	01893503          	ld	a0,24(s2)
    80004ad0:	fffff097          	auipc	ra,0xfffff
    80004ad4:	f68080e7          	jalr	-152(ra) # 80003a38 <iunlock>
      end_op();
    80004ad8:	00000097          	auipc	ra,0x0
    80004adc:	8b8080e7          	jalr	-1864(ra) # 80004390 <end_op>
      if(r < 0)
    80004ae0:	fc04d8e3          	bgez	s1,80004ab0 <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004ae4:	053a1763          	bne	s4,s3,80004b32 <filewrite+0x156>
    80004ae8:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004aea:	60a6                	ld	ra,72(sp)
    80004aec:	6406                	ld	s0,64(sp)
    80004aee:	74e2                	ld	s1,56(sp)
    80004af0:	7942                	ld	s2,48(sp)
    80004af2:	79a2                	ld	s3,40(sp)
    80004af4:	7a02                	ld	s4,32(sp)
    80004af6:	6ae2                	ld	s5,24(sp)
    80004af8:	6b42                	ld	s6,16(sp)
    80004afa:	6ba2                	ld	s7,8(sp)
    80004afc:	6c02                	ld	s8,0(sp)
    80004afe:	6161                	add	sp,sp,80
    80004b00:	8082                	ret
        panic("short filewrite");
    80004b02:	00004517          	auipc	a0,0x4
    80004b06:	bc650513          	add	a0,a0,-1082 # 800086c8 <syscalls+0x268>
    80004b0a:	ffffc097          	auipc	ra,0xffffc
    80004b0e:	a38080e7          	jalr	-1480(ra) # 80000542 <panic>
    int i = 0;
    80004b12:	4981                	li	s3,0
    80004b14:	bfc1                	j	80004ae4 <filewrite+0x108>
    panic("filewrite");
    80004b16:	00004517          	auipc	a0,0x4
    80004b1a:	bc250513          	add	a0,a0,-1086 # 800086d8 <syscalls+0x278>
    80004b1e:	ffffc097          	auipc	ra,0xffffc
    80004b22:	a24080e7          	jalr	-1500(ra) # 80000542 <panic>
    return -1;
    80004b26:	557d                	li	a0,-1
}
    80004b28:	8082                	ret
      return -1;
    80004b2a:	557d                	li	a0,-1
    80004b2c:	bf7d                	j	80004aea <filewrite+0x10e>
    80004b2e:	557d                	li	a0,-1
    80004b30:	bf6d                	j	80004aea <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80004b32:	557d                	li	a0,-1
    80004b34:	bf5d                	j	80004aea <filewrite+0x10e>

0000000080004b36 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004b36:	7179                	add	sp,sp,-48
    80004b38:	f406                	sd	ra,40(sp)
    80004b3a:	f022                	sd	s0,32(sp)
    80004b3c:	ec26                	sd	s1,24(sp)
    80004b3e:	e84a                	sd	s2,16(sp)
    80004b40:	e44e                	sd	s3,8(sp)
    80004b42:	e052                	sd	s4,0(sp)
    80004b44:	1800                	add	s0,sp,48
    80004b46:	84aa                	mv	s1,a0
    80004b48:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004b4a:	0005b023          	sd	zero,0(a1)
    80004b4e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004b52:	00000097          	auipc	ra,0x0
    80004b56:	bd2080e7          	jalr	-1070(ra) # 80004724 <filealloc>
    80004b5a:	e088                	sd	a0,0(s1)
    80004b5c:	c551                	beqz	a0,80004be8 <pipealloc+0xb2>
    80004b5e:	00000097          	auipc	ra,0x0
    80004b62:	bc6080e7          	jalr	-1082(ra) # 80004724 <filealloc>
    80004b66:	00aa3023          	sd	a0,0(s4)
    80004b6a:	c92d                	beqz	a0,80004bdc <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004b6c:	ffffc097          	auipc	ra,0xffffc
    80004b70:	fa0080e7          	jalr	-96(ra) # 80000b0c <kalloc>
    80004b74:	892a                	mv	s2,a0
    80004b76:	c125                	beqz	a0,80004bd6 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004b78:	4985                	li	s3,1
    80004b7a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004b7e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004b82:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004b86:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004b8a:	00004597          	auipc	a1,0x4
    80004b8e:	b5e58593          	add	a1,a1,-1186 # 800086e8 <syscalls+0x288>
    80004b92:	ffffc097          	auipc	ra,0xffffc
    80004b96:	fda080e7          	jalr	-38(ra) # 80000b6c <initlock>
  (*f0)->type = FD_PIPE;
    80004b9a:	609c                	ld	a5,0(s1)
    80004b9c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004ba0:	609c                	ld	a5,0(s1)
    80004ba2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004ba6:	609c                	ld	a5,0(s1)
    80004ba8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004bac:	609c                	ld	a5,0(s1)
    80004bae:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004bb2:	000a3783          	ld	a5,0(s4)
    80004bb6:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004bba:	000a3783          	ld	a5,0(s4)
    80004bbe:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004bc2:	000a3783          	ld	a5,0(s4)
    80004bc6:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004bca:	000a3783          	ld	a5,0(s4)
    80004bce:	0127b823          	sd	s2,16(a5)
  return 0;
    80004bd2:	4501                	li	a0,0
    80004bd4:	a025                	j	80004bfc <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004bd6:	6088                	ld	a0,0(s1)
    80004bd8:	e501                	bnez	a0,80004be0 <pipealloc+0xaa>
    80004bda:	a039                	j	80004be8 <pipealloc+0xb2>
    80004bdc:	6088                	ld	a0,0(s1)
    80004bde:	c51d                	beqz	a0,80004c0c <pipealloc+0xd6>
    fileclose(*f0);
    80004be0:	00000097          	auipc	ra,0x0
    80004be4:	c00080e7          	jalr	-1024(ra) # 800047e0 <fileclose>
  if(*f1)
    80004be8:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004bec:	557d                	li	a0,-1
  if(*f1)
    80004bee:	c799                	beqz	a5,80004bfc <pipealloc+0xc6>
    fileclose(*f1);
    80004bf0:	853e                	mv	a0,a5
    80004bf2:	00000097          	auipc	ra,0x0
    80004bf6:	bee080e7          	jalr	-1042(ra) # 800047e0 <fileclose>
  return -1;
    80004bfa:	557d                	li	a0,-1
}
    80004bfc:	70a2                	ld	ra,40(sp)
    80004bfe:	7402                	ld	s0,32(sp)
    80004c00:	64e2                	ld	s1,24(sp)
    80004c02:	6942                	ld	s2,16(sp)
    80004c04:	69a2                	ld	s3,8(sp)
    80004c06:	6a02                	ld	s4,0(sp)
    80004c08:	6145                	add	sp,sp,48
    80004c0a:	8082                	ret
  return -1;
    80004c0c:	557d                	li	a0,-1
    80004c0e:	b7fd                	j	80004bfc <pipealloc+0xc6>

0000000080004c10 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004c10:	1101                	add	sp,sp,-32
    80004c12:	ec06                	sd	ra,24(sp)
    80004c14:	e822                	sd	s0,16(sp)
    80004c16:	e426                	sd	s1,8(sp)
    80004c18:	e04a                	sd	s2,0(sp)
    80004c1a:	1000                	add	s0,sp,32
    80004c1c:	84aa                	mv	s1,a0
    80004c1e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004c20:	ffffc097          	auipc	ra,0xffffc
    80004c24:	fdc080e7          	jalr	-36(ra) # 80000bfc <acquire>
  if(writable){
    80004c28:	02090d63          	beqz	s2,80004c62 <pipeclose+0x52>
    pi->writeopen = 0;
    80004c2c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004c30:	21848513          	add	a0,s1,536
    80004c34:	ffffe097          	auipc	ra,0xffffe
    80004c38:	9fc080e7          	jalr	-1540(ra) # 80002630 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004c3c:	2204b783          	ld	a5,544(s1)
    80004c40:	eb95                	bnez	a5,80004c74 <pipeclose+0x64>
    release(&pi->lock);
    80004c42:	8526                	mv	a0,s1
    80004c44:	ffffc097          	auipc	ra,0xffffc
    80004c48:	06c080e7          	jalr	108(ra) # 80000cb0 <release>
    kfree((char*)pi);
    80004c4c:	8526                	mv	a0,s1
    80004c4e:	ffffc097          	auipc	ra,0xffffc
    80004c52:	dc0080e7          	jalr	-576(ra) # 80000a0e <kfree>
  } else
    release(&pi->lock);
}
    80004c56:	60e2                	ld	ra,24(sp)
    80004c58:	6442                	ld	s0,16(sp)
    80004c5a:	64a2                	ld	s1,8(sp)
    80004c5c:	6902                	ld	s2,0(sp)
    80004c5e:	6105                	add	sp,sp,32
    80004c60:	8082                	ret
    pi->readopen = 0;
    80004c62:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004c66:	21c48513          	add	a0,s1,540
    80004c6a:	ffffe097          	auipc	ra,0xffffe
    80004c6e:	9c6080e7          	jalr	-1594(ra) # 80002630 <wakeup>
    80004c72:	b7e9                	j	80004c3c <pipeclose+0x2c>
    release(&pi->lock);
    80004c74:	8526                	mv	a0,s1
    80004c76:	ffffc097          	auipc	ra,0xffffc
    80004c7a:	03a080e7          	jalr	58(ra) # 80000cb0 <release>
}
    80004c7e:	bfe1                	j	80004c56 <pipeclose+0x46>

0000000080004c80 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004c80:	711d                	add	sp,sp,-96
    80004c82:	ec86                	sd	ra,88(sp)
    80004c84:	e8a2                	sd	s0,80(sp)
    80004c86:	e4a6                	sd	s1,72(sp)
    80004c88:	e0ca                	sd	s2,64(sp)
    80004c8a:	fc4e                	sd	s3,56(sp)
    80004c8c:	f852                	sd	s4,48(sp)
    80004c8e:	f456                	sd	s5,40(sp)
    80004c90:	f05a                	sd	s6,32(sp)
    80004c92:	ec5e                	sd	s7,24(sp)
    80004c94:	1080                	add	s0,sp,96
    80004c96:	84aa                	mv	s1,a0
    80004c98:	8b2e                	mv	s6,a1
    80004c9a:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004c9c:	ffffd097          	auipc	ra,0xffffd
    80004ca0:	df4080e7          	jalr	-524(ra) # 80001a90 <myproc>
    80004ca4:	892a                	mv	s2,a0

  acquire(&pi->lock);
    80004ca6:	8526                	mv	a0,s1
    80004ca8:	ffffc097          	auipc	ra,0xffffc
    80004cac:	f54080e7          	jalr	-172(ra) # 80000bfc <acquire>
  for(i = 0; i < n; i++){
    80004cb0:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004cb2:	21848a13          	add	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004cb6:	21c48993          	add	s3,s1,540
  for(i = 0; i < n; i++){
    80004cba:	09505263          	blez	s5,80004d3e <pipewrite+0xbe>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004cbe:	2184a783          	lw	a5,536(s1)
    80004cc2:	21c4a703          	lw	a4,540(s1)
    80004cc6:	2007879b          	addw	a5,a5,512
    80004cca:	02f71b63          	bne	a4,a5,80004d00 <pipewrite+0x80>
      if(pi->readopen == 0 || pr->killed){
    80004cce:	2204a783          	lw	a5,544(s1)
    80004cd2:	c3d1                	beqz	a5,80004d56 <pipewrite+0xd6>
    80004cd4:	03092783          	lw	a5,48(s2)
    80004cd8:	efbd                	bnez	a5,80004d56 <pipewrite+0xd6>
      wakeup(&pi->nread);
    80004cda:	8552                	mv	a0,s4
    80004cdc:	ffffe097          	auipc	ra,0xffffe
    80004ce0:	954080e7          	jalr	-1708(ra) # 80002630 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004ce4:	85a6                	mv	a1,s1
    80004ce6:	854e                	mv	a0,s3
    80004ce8:	ffffd097          	auipc	ra,0xffffd
    80004cec:	7c8080e7          	jalr	1992(ra) # 800024b0 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004cf0:	2184a783          	lw	a5,536(s1)
    80004cf4:	21c4a703          	lw	a4,540(s1)
    80004cf8:	2007879b          	addw	a5,a5,512
    80004cfc:	fcf709e3          	beq	a4,a5,80004cce <pipewrite+0x4e>
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004d00:	4685                	li	a3,1
    80004d02:	865a                	mv	a2,s6
    80004d04:	faf40593          	add	a1,s0,-81
    80004d08:	05093503          	ld	a0,80(s2)
    80004d0c:	ffffd097          	auipc	ra,0xffffd
    80004d10:	a7a080e7          	jalr	-1414(ra) # 80001786 <copyin>
    80004d14:	57fd                	li	a5,-1
    80004d16:	02f50463          	beq	a0,a5,80004d3e <pipewrite+0xbe>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004d1a:	21c4a783          	lw	a5,540(s1)
    80004d1e:	0017871b          	addw	a4,a5,1
    80004d22:	20e4ae23          	sw	a4,540(s1)
    80004d26:	1ff7f793          	and	a5,a5,511
    80004d2a:	97a6                	add	a5,a5,s1
    80004d2c:	faf44703          	lbu	a4,-81(s0)
    80004d30:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004d34:	2b85                	addw	s7,s7,1
    80004d36:	0b05                	add	s6,s6,1
    80004d38:	f97a93e3          	bne	s5,s7,80004cbe <pipewrite+0x3e>
    80004d3c:	8bd6                	mv	s7,s5
  }
  wakeup(&pi->nread);
    80004d3e:	21848513          	add	a0,s1,536
    80004d42:	ffffe097          	auipc	ra,0xffffe
    80004d46:	8ee080e7          	jalr	-1810(ra) # 80002630 <wakeup>
  release(&pi->lock);
    80004d4a:	8526                	mv	a0,s1
    80004d4c:	ffffc097          	auipc	ra,0xffffc
    80004d50:	f64080e7          	jalr	-156(ra) # 80000cb0 <release>
  return i;
    80004d54:	a039                	j	80004d62 <pipewrite+0xe2>
        release(&pi->lock);
    80004d56:	8526                	mv	a0,s1
    80004d58:	ffffc097          	auipc	ra,0xffffc
    80004d5c:	f58080e7          	jalr	-168(ra) # 80000cb0 <release>
        return -1;
    80004d60:	5bfd                	li	s7,-1
}
    80004d62:	855e                	mv	a0,s7
    80004d64:	60e6                	ld	ra,88(sp)
    80004d66:	6446                	ld	s0,80(sp)
    80004d68:	64a6                	ld	s1,72(sp)
    80004d6a:	6906                	ld	s2,64(sp)
    80004d6c:	79e2                	ld	s3,56(sp)
    80004d6e:	7a42                	ld	s4,48(sp)
    80004d70:	7aa2                	ld	s5,40(sp)
    80004d72:	7b02                	ld	s6,32(sp)
    80004d74:	6be2                	ld	s7,24(sp)
    80004d76:	6125                	add	sp,sp,96
    80004d78:	8082                	ret

0000000080004d7a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004d7a:	715d                	add	sp,sp,-80
    80004d7c:	e486                	sd	ra,72(sp)
    80004d7e:	e0a2                	sd	s0,64(sp)
    80004d80:	fc26                	sd	s1,56(sp)
    80004d82:	f84a                	sd	s2,48(sp)
    80004d84:	f44e                	sd	s3,40(sp)
    80004d86:	f052                	sd	s4,32(sp)
    80004d88:	ec56                	sd	s5,24(sp)
    80004d8a:	e85a                	sd	s6,16(sp)
    80004d8c:	0880                	add	s0,sp,80
    80004d8e:	84aa                	mv	s1,a0
    80004d90:	892e                	mv	s2,a1
    80004d92:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004d94:	ffffd097          	auipc	ra,0xffffd
    80004d98:	cfc080e7          	jalr	-772(ra) # 80001a90 <myproc>
    80004d9c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004d9e:	8526                	mv	a0,s1
    80004da0:	ffffc097          	auipc	ra,0xffffc
    80004da4:	e5c080e7          	jalr	-420(ra) # 80000bfc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004da8:	2184a703          	lw	a4,536(s1)
    80004dac:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004db0:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004db4:	02f71463          	bne	a4,a5,80004ddc <piperead+0x62>
    80004db8:	2244a783          	lw	a5,548(s1)
    80004dbc:	c385                	beqz	a5,80004ddc <piperead+0x62>
    if(pr->killed){
    80004dbe:	030a2783          	lw	a5,48(s4)
    80004dc2:	ebc9                	bnez	a5,80004e54 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004dc4:	85a6                	mv	a1,s1
    80004dc6:	854e                	mv	a0,s3
    80004dc8:	ffffd097          	auipc	ra,0xffffd
    80004dcc:	6e8080e7          	jalr	1768(ra) # 800024b0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004dd0:	2184a703          	lw	a4,536(s1)
    80004dd4:	21c4a783          	lw	a5,540(s1)
    80004dd8:	fef700e3          	beq	a4,a5,80004db8 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004ddc:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004dde:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004de0:	05505463          	blez	s5,80004e28 <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004de4:	2184a783          	lw	a5,536(s1)
    80004de8:	21c4a703          	lw	a4,540(s1)
    80004dec:	02f70e63          	beq	a4,a5,80004e28 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004df0:	0017871b          	addw	a4,a5,1
    80004df4:	20e4ac23          	sw	a4,536(s1)
    80004df8:	1ff7f793          	and	a5,a5,511
    80004dfc:	97a6                	add	a5,a5,s1
    80004dfe:	0187c783          	lbu	a5,24(a5)
    80004e02:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004e06:	4685                	li	a3,1
    80004e08:	fbf40613          	add	a2,s0,-65
    80004e0c:	85ca                	mv	a1,s2
    80004e0e:	050a3503          	ld	a0,80(s4)
    80004e12:	ffffd097          	auipc	ra,0xffffd
    80004e16:	8e8080e7          	jalr	-1816(ra) # 800016fa <copyout>
    80004e1a:	01650763          	beq	a0,s6,80004e28 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e1e:	2985                	addw	s3,s3,1
    80004e20:	0905                	add	s2,s2,1
    80004e22:	fd3a91e3          	bne	s5,s3,80004de4 <piperead+0x6a>
    80004e26:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004e28:	21c48513          	add	a0,s1,540
    80004e2c:	ffffe097          	auipc	ra,0xffffe
    80004e30:	804080e7          	jalr	-2044(ra) # 80002630 <wakeup>
  release(&pi->lock);
    80004e34:	8526                	mv	a0,s1
    80004e36:	ffffc097          	auipc	ra,0xffffc
    80004e3a:	e7a080e7          	jalr	-390(ra) # 80000cb0 <release>
  return i;
}
    80004e3e:	854e                	mv	a0,s3
    80004e40:	60a6                	ld	ra,72(sp)
    80004e42:	6406                	ld	s0,64(sp)
    80004e44:	74e2                	ld	s1,56(sp)
    80004e46:	7942                	ld	s2,48(sp)
    80004e48:	79a2                	ld	s3,40(sp)
    80004e4a:	7a02                	ld	s4,32(sp)
    80004e4c:	6ae2                	ld	s5,24(sp)
    80004e4e:	6b42                	ld	s6,16(sp)
    80004e50:	6161                	add	sp,sp,80
    80004e52:	8082                	ret
      release(&pi->lock);
    80004e54:	8526                	mv	a0,s1
    80004e56:	ffffc097          	auipc	ra,0xffffc
    80004e5a:	e5a080e7          	jalr	-422(ra) # 80000cb0 <release>
      return -1;
    80004e5e:	59fd                	li	s3,-1
    80004e60:	bff9                	j	80004e3e <piperead+0xc4>

0000000080004e62 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004e62:	de010113          	add	sp,sp,-544
    80004e66:	20113c23          	sd	ra,536(sp)
    80004e6a:	20813823          	sd	s0,528(sp)
    80004e6e:	20913423          	sd	s1,520(sp)
    80004e72:	21213023          	sd	s2,512(sp)
    80004e76:	ffce                	sd	s3,504(sp)
    80004e78:	fbd2                	sd	s4,496(sp)
    80004e7a:	f7d6                	sd	s5,488(sp)
    80004e7c:	f3da                	sd	s6,480(sp)
    80004e7e:	efde                	sd	s7,472(sp)
    80004e80:	ebe2                	sd	s8,464(sp)
    80004e82:	e7e6                	sd	s9,456(sp)
    80004e84:	e3ea                	sd	s10,448(sp)
    80004e86:	ff6e                	sd	s11,440(sp)
    80004e88:	1400                	add	s0,sp,544
    80004e8a:	892a                	mv	s2,a0
    80004e8c:	dea43c23          	sd	a0,-520(s0)
    80004e90:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004e94:	ffffd097          	auipc	ra,0xffffd
    80004e98:	bfc080e7          	jalr	-1028(ra) # 80001a90 <myproc>
    80004e9c:	84aa                	mv	s1,a0
  pte_t *pte, *kernel_pte;

  begin_op();
    80004e9e:	fffff097          	auipc	ra,0xfffff
    80004ea2:	478080e7          	jalr	1144(ra) # 80004316 <begin_op>

  if((ip = namei(path)) == 0){
    80004ea6:	854a                	mv	a0,s2
    80004ea8:	fffff097          	auipc	ra,0xfffff
    80004eac:	27e080e7          	jalr	638(ra) # 80004126 <namei>
    80004eb0:	c93d                	beqz	a0,80004f26 <exec+0xc4>
    80004eb2:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004eb4:	fffff097          	auipc	ra,0xfffff
    80004eb8:	ac2080e7          	jalr	-1342(ra) # 80003976 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004ebc:	04000713          	li	a4,64
    80004ec0:	4681                	li	a3,0
    80004ec2:	e4840613          	add	a2,s0,-440
    80004ec6:	4581                	li	a1,0
    80004ec8:	8552                	mv	a0,s4
    80004eca:	fffff097          	auipc	ra,0xfffff
    80004ece:	d60080e7          	jalr	-672(ra) # 80003c2a <readi>
    80004ed2:	04000793          	li	a5,64
    80004ed6:	00f51a63          	bne	a0,a5,80004eea <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004eda:	e4842703          	lw	a4,-440(s0)
    80004ede:	464c47b7          	lui	a5,0x464c4
    80004ee2:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004ee6:	04f70663          	beq	a4,a5,80004f32 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004eea:	8552                	mv	a0,s4
    80004eec:	fffff097          	auipc	ra,0xfffff
    80004ef0:	cec080e7          	jalr	-788(ra) # 80003bd8 <iunlockput>
    end_op();
    80004ef4:	fffff097          	auipc	ra,0xfffff
    80004ef8:	49c080e7          	jalr	1180(ra) # 80004390 <end_op>
  }
  return -1;
    80004efc:	557d                	li	a0,-1
}
    80004efe:	21813083          	ld	ra,536(sp)
    80004f02:	21013403          	ld	s0,528(sp)
    80004f06:	20813483          	ld	s1,520(sp)
    80004f0a:	20013903          	ld	s2,512(sp)
    80004f0e:	79fe                	ld	s3,504(sp)
    80004f10:	7a5e                	ld	s4,496(sp)
    80004f12:	7abe                	ld	s5,488(sp)
    80004f14:	7b1e                	ld	s6,480(sp)
    80004f16:	6bfe                	ld	s7,472(sp)
    80004f18:	6c5e                	ld	s8,464(sp)
    80004f1a:	6cbe                	ld	s9,456(sp)
    80004f1c:	6d1e                	ld	s10,448(sp)
    80004f1e:	7dfa                	ld	s11,440(sp)
    80004f20:	22010113          	add	sp,sp,544
    80004f24:	8082                	ret
    end_op();
    80004f26:	fffff097          	auipc	ra,0xfffff
    80004f2a:	46a080e7          	jalr	1130(ra) # 80004390 <end_op>
    return -1;
    80004f2e:	557d                	li	a0,-1
    80004f30:	b7f9                	j	80004efe <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004f32:	8526                	mv	a0,s1
    80004f34:	ffffd097          	auipc	ra,0xffffd
    80004f38:	cf2080e7          	jalr	-782(ra) # 80001c26 <proc_pagetable>
    80004f3c:	8b2a                	mv	s6,a0
    80004f3e:	d555                	beqz	a0,80004eea <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004f40:	e6842d03          	lw	s10,-408(s0)
    80004f44:	e8045783          	lhu	a5,-384(s0)
    80004f48:	10078663          	beqz	a5,80005054 <exec+0x1f2>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004f4c:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004f4e:	4d81                	li	s11,0
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004f50:	0c0007b7          	lui	a5,0xc000
    80004f54:	17f9                	add	a5,a5,-2 # bfffffe <_entry-0x74000002>
    80004f56:	def43823          	sd	a5,-528(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004f5a:	6c85                	lui	s9,0x1
    80004f5c:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004f60:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004f64:	6a85                	lui	s5,0x1
    80004f66:	a0b5                	j	80004fd2 <exec+0x170>
      panic("loadseg: address should exist");
    80004f68:	00003517          	auipc	a0,0x3
    80004f6c:	78850513          	add	a0,a0,1928 # 800086f0 <syscalls+0x290>
    80004f70:	ffffb097          	auipc	ra,0xffffb
    80004f74:	5d2080e7          	jalr	1490(ra) # 80000542 <panic>
    if(sz - i < PGSIZE)
    80004f78:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004f7a:	8726                	mv	a4,s1
    80004f7c:	012c06bb          	addw	a3,s8,s2
    80004f80:	4581                	li	a1,0
    80004f82:	8552                	mv	a0,s4
    80004f84:	fffff097          	auipc	ra,0xfffff
    80004f88:	ca6080e7          	jalr	-858(ra) # 80003c2a <readi>
    80004f8c:	2501                	sext.w	a0,a0
    80004f8e:	2aa49763          	bne	s1,a0,8000523c <exec+0x3da>
  for(i = 0; i < sz; i += PGSIZE){
    80004f92:	012a893b          	addw	s2,s5,s2
    80004f96:	03397563          	bgeu	s2,s3,80004fc0 <exec+0x15e>
    pa = walkaddr(pagetable, va + i);
    80004f9a:	02091593          	sll	a1,s2,0x20
    80004f9e:	9181                	srl	a1,a1,0x20
    80004fa0:	95de                	add	a1,a1,s7
    80004fa2:	855a                	mv	a0,s6
    80004fa4:	ffffc097          	auipc	ra,0xffffc
    80004fa8:	0e8080e7          	jalr	232(ra) # 8000108c <walkaddr>
    80004fac:	862a                	mv	a2,a0
    if(pa == 0)
    80004fae:	dd4d                	beqz	a0,80004f68 <exec+0x106>
    if(sz - i < PGSIZE)
    80004fb0:	412984bb          	subw	s1,s3,s2
    80004fb4:	0004879b          	sext.w	a5,s1
    80004fb8:	fcfcf0e3          	bgeu	s9,a5,80004f78 <exec+0x116>
    80004fbc:	84d6                	mv	s1,s5
    80004fbe:	bf6d                	j	80004f78 <exec+0x116>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004fc0:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004fc4:	2d85                	addw	s11,s11,1
    80004fc6:	038d0d1b          	addw	s10,s10,56
    80004fca:	e8045783          	lhu	a5,-384(s0)
    80004fce:	08fdd463          	bge	s11,a5,80005056 <exec+0x1f4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004fd2:	2d01                	sext.w	s10,s10
    80004fd4:	03800713          	li	a4,56
    80004fd8:	86ea                	mv	a3,s10
    80004fda:	e1040613          	add	a2,s0,-496
    80004fde:	4581                	li	a1,0
    80004fe0:	8552                	mv	a0,s4
    80004fe2:	fffff097          	auipc	ra,0xfffff
    80004fe6:	c48080e7          	jalr	-952(ra) # 80003c2a <readi>
    80004fea:	03800793          	li	a5,56
    80004fee:	24f51563          	bne	a0,a5,80005238 <exec+0x3d6>
    if(ph.type != ELF_PROG_LOAD)
    80004ff2:	e1042783          	lw	a5,-496(s0)
    80004ff6:	4705                	li	a4,1
    80004ff8:	fce796e3          	bne	a5,a4,80004fc4 <exec+0x162>
    if(ph.memsz < ph.filesz)
    80004ffc:	e3843603          	ld	a2,-456(s0)
    80005000:	e3043783          	ld	a5,-464(s0)
    80005004:	24f66763          	bltu	a2,a5,80005252 <exec+0x3f0>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005008:	e2043783          	ld	a5,-480(s0)
    8000500c:	963e                	add	a2,a2,a5
    8000500e:	24f66563          	bltu	a2,a5,80005258 <exec+0x3f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005012:	85a6                	mv	a1,s1
    80005014:	855a                	mv	a0,s6
    80005016:	ffffc097          	auipc	ra,0xffffc
    8000501a:	462080e7          	jalr	1122(ra) # 80001478 <uvmalloc>
    8000501e:	e0a43423          	sd	a0,-504(s0)
    80005022:	fff50793          	add	a5,a0,-1
    80005026:	df043703          	ld	a4,-528(s0)
    8000502a:	22f76a63          	bltu	a4,a5,8000525e <exec+0x3fc>
    if(ph.vaddr % PGSIZE != 0)
    8000502e:	e2043b83          	ld	s7,-480(s0)
    80005032:	de843783          	ld	a5,-536(s0)
    80005036:	00fbf7b3          	and	a5,s7,a5
    8000503a:	20079163          	bnez	a5,8000523c <exec+0x3da>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000503e:	e1842c03          	lw	s8,-488(s0)
    80005042:	e3042983          	lw	s3,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005046:	00098463          	beqz	s3,8000504e <exec+0x1ec>
    8000504a:	4901                	li	s2,0
    8000504c:	b7b9                	j	80004f9a <exec+0x138>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000504e:	e0843483          	ld	s1,-504(s0)
    80005052:	bf8d                	j	80004fc4 <exec+0x162>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80005054:	4481                	li	s1,0
  iunlockput(ip);
    80005056:	8552                	mv	a0,s4
    80005058:	fffff097          	auipc	ra,0xfffff
    8000505c:	b80080e7          	jalr	-1152(ra) # 80003bd8 <iunlockput>
  end_op();
    80005060:	fffff097          	auipc	ra,0xfffff
    80005064:	330080e7          	jalr	816(ra) # 80004390 <end_op>
  p = myproc();
    80005068:	ffffd097          	auipc	ra,0xffffd
    8000506c:	a28080e7          	jalr	-1496(ra) # 80001a90 <myproc>
    80005070:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80005072:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80005076:	6985                	lui	s3,0x1
    80005078:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000507a:	99a6                	add	s3,s3,s1
    8000507c:	77fd                	lui	a5,0xfffff
    8000507e:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80005082:	6609                	lui	a2,0x2
    80005084:	964e                	add	a2,a2,s3
    80005086:	85ce                	mv	a1,s3
    80005088:	855a                	mv	a0,s6
    8000508a:	ffffc097          	auipc	ra,0xffffc
    8000508e:	3ee080e7          	jalr	1006(ra) # 80001478 <uvmalloc>
    80005092:	892a                	mv	s2,a0
    80005094:	e0a43423          	sd	a0,-504(s0)
    80005098:	e509                	bnez	a0,800050a2 <exec+0x240>
  if(pagetable)
    8000509a:	e1343423          	sd	s3,-504(s0)
    8000509e:	4a01                	li	s4,0
    800050a0:	aa71                	j	8000523c <exec+0x3da>
  uvmclear(pagetable, sz-2*PGSIZE);
    800050a2:	75f9                	lui	a1,0xffffe
    800050a4:	95aa                	add	a1,a1,a0
    800050a6:	855a                	mv	a0,s6
    800050a8:	ffffc097          	auipc	ra,0xffffc
    800050ac:	620080e7          	jalr	1568(ra) # 800016c8 <uvmclear>
  stackbase = sp - PGSIZE;
    800050b0:	7bfd                	lui	s7,0xfffff
    800050b2:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800050b4:	e0043783          	ld	a5,-512(s0)
    800050b8:	6388                	ld	a0,0(a5)
    800050ba:	c52d                	beqz	a0,80005124 <exec+0x2c2>
    800050bc:	e8840993          	add	s3,s0,-376
    800050c0:	f8840c13          	add	s8,s0,-120
    800050c4:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800050c6:	ffffc097          	auipc	ra,0xffffc
    800050ca:	db4080e7          	jalr	-588(ra) # 80000e7a <strlen>
    800050ce:	0015079b          	addw	a5,a0,1
    800050d2:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800050d6:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    800050da:	19796563          	bltu	s2,s7,80005264 <exec+0x402>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800050de:	e0043d03          	ld	s10,-512(s0)
    800050e2:	000d3a03          	ld	s4,0(s10)
    800050e6:	8552                	mv	a0,s4
    800050e8:	ffffc097          	auipc	ra,0xffffc
    800050ec:	d92080e7          	jalr	-622(ra) # 80000e7a <strlen>
    800050f0:	0015069b          	addw	a3,a0,1
    800050f4:	8652                	mv	a2,s4
    800050f6:	85ca                	mv	a1,s2
    800050f8:	855a                	mv	a0,s6
    800050fa:	ffffc097          	auipc	ra,0xffffc
    800050fe:	600080e7          	jalr	1536(ra) # 800016fa <copyout>
    80005102:	16054363          	bltz	a0,80005268 <exec+0x406>
    ustack[argc] = sp;
    80005106:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000510a:	0485                	add	s1,s1,1
    8000510c:	008d0793          	add	a5,s10,8
    80005110:	e0f43023          	sd	a5,-512(s0)
    80005114:	008d3503          	ld	a0,8(s10)
    80005118:	c909                	beqz	a0,8000512a <exec+0x2c8>
    if(argc >= MAXARG)
    8000511a:	09a1                	add	s3,s3,8
    8000511c:	fb3c15e3          	bne	s8,s3,800050c6 <exec+0x264>
  ip = 0;
    80005120:	4a01                	li	s4,0
    80005122:	aa29                	j	8000523c <exec+0x3da>
  sp = sz;
    80005124:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80005128:	4481                	li	s1,0
  ustack[argc] = 0;
    8000512a:	00349793          	sll	a5,s1,0x3
    8000512e:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd7f70>
    80005132:	97a2                	add	a5,a5,s0
    80005134:	ee07bc23          	sd	zero,-264(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005138:	00148693          	add	a3,s1,1
    8000513c:	068e                	sll	a3,a3,0x3
    8000513e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005142:	ff097913          	and	s2,s2,-16
  sz = sz1;
    80005146:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000514a:	f57968e3          	bltu	s2,s7,8000509a <exec+0x238>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000514e:	e8840613          	add	a2,s0,-376
    80005152:	85ca                	mv	a1,s2
    80005154:	855a                	mv	a0,s6
    80005156:	ffffc097          	auipc	ra,0xffffc
    8000515a:	5a4080e7          	jalr	1444(ra) # 800016fa <copyout>
    8000515e:	10054763          	bltz	a0,8000526c <exec+0x40a>
  uvmunmap(p->kernel_pagetable, 0 , PGROUNDUP(oldsz)/PGSIZE, 0);
    80005162:	6605                	lui	a2,0x1
    80005164:	167d                	add	a2,a2,-1 # fff <_entry-0x7ffff001>
    80005166:	9666                	add	a2,a2,s9
    80005168:	4681                	li	a3,0
    8000516a:	8231                	srl	a2,a2,0xc
    8000516c:	4581                	li	a1,0
    8000516e:	058ab503          	ld	a0,88(s5) # 1058 <_entry-0x7fffefa8>
    80005172:	ffffc097          	auipc	ra,0xffffc
    80005176:	15a080e7          	jalr	346(ra) # 800012cc <uvmunmap>
    8000517a:	4981                	li	s3,0
  for (int j = 0; j < sz; j += PGSIZE) {
    8000517c:	6a05                	lui	s4,0x1
      pte =  walk(pagetable, j, 0);
    8000517e:	4601                	li	a2,0
    80005180:	85ce                	mv	a1,s3
    80005182:	855a                	mv	a0,s6
    80005184:	ffffc097          	auipc	ra,0xffffc
    80005188:	e62080e7          	jalr	-414(ra) # 80000fe6 <walk>
    8000518c:	8baa                	mv	s7,a0
      kernel_pte = walk(p->kernel_pagetable, j, 1);
    8000518e:	4605                	li	a2,1
    80005190:	85ce                	mv	a1,s3
    80005192:	058ab503          	ld	a0,88(s5)
    80005196:	ffffc097          	auipc	ra,0xffffc
    8000519a:	e50080e7          	jalr	-432(ra) # 80000fe6 <walk>
      *kernel_pte = (*pte) & ~PTE_U;
    8000519e:	000bb783          	ld	a5,0(s7) # fffffffffffff000 <end+0xffffffff7ffd7fe0>
    800051a2:	9bbd                	and	a5,a5,-17
    800051a4:	e11c                	sd	a5,0(a0)
  for (int j = 0; j < sz; j += PGSIZE) {
    800051a6:	99d2                	add	s3,s3,s4
    800051a8:	e0843783          	ld	a5,-504(s0)
    800051ac:	fcf9e9e3          	bltu	s3,a5,8000517e <exec+0x31c>
  p->trapframe->a1 = sp;
    800051b0:	060ab783          	ld	a5,96(s5)
    800051b4:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800051b8:	df843783          	ld	a5,-520(s0)
    800051bc:	0007c703          	lbu	a4,0(a5)
    800051c0:	cf11                	beqz	a4,800051dc <exec+0x37a>
    800051c2:	0785                	add	a5,a5,1
    if(*s == '/')
    800051c4:	02f00693          	li	a3,47
    800051c8:	a039                	j	800051d6 <exec+0x374>
      last = s+1;
    800051ca:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800051ce:	0785                	add	a5,a5,1
    800051d0:	fff7c703          	lbu	a4,-1(a5)
    800051d4:	c701                	beqz	a4,800051dc <exec+0x37a>
    if(*s == '/')
    800051d6:	fed71ce3          	bne	a4,a3,800051ce <exec+0x36c>
    800051da:	bfc5                	j	800051ca <exec+0x368>
  safestrcpy(p->name, last, sizeof(p->name));
    800051dc:	4641                	li	a2,16
    800051de:	df843583          	ld	a1,-520(s0)
    800051e2:	160a8513          	add	a0,s5,352
    800051e6:	ffffc097          	auipc	ra,0xffffc
    800051ea:	c62080e7          	jalr	-926(ra) # 80000e48 <safestrcpy>
  oldpagetable = p->pagetable;
    800051ee:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800051f2:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800051f6:	e0843783          	ld	a5,-504(s0)
    800051fa:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800051fe:	060ab783          	ld	a5,96(s5)
    80005202:	e6043703          	ld	a4,-416(s0)
    80005206:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005208:	060ab783          	ld	a5,96(s5)
    8000520c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005210:	85e6                	mv	a1,s9
    80005212:	ffffd097          	auipc	ra,0xffffd
    80005216:	ab0080e7          	jalr	-1360(ra) # 80001cc2 <proc_freepagetable>
  if(p->pid==1) 
    8000521a:	038aa703          	lw	a4,56(s5)
    8000521e:	4785                	li	a5,1
    80005220:	00f70563          	beq	a4,a5,8000522a <exec+0x3c8>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005224:	0004851b          	sext.w	a0,s1
    80005228:	b9d9                	j	80004efe <exec+0x9c>
    vmprint(p->pagetable);  
    8000522a:	050ab503          	ld	a0,80(s5)
    8000522e:	ffffc097          	auipc	ra,0xffffc
    80005232:	662080e7          	jalr	1634(ra) # 80001890 <vmprint>
    80005236:	b7fd                	j	80005224 <exec+0x3c2>
    80005238:	e0943423          	sd	s1,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000523c:	e0843583          	ld	a1,-504(s0)
    80005240:	855a                	mv	a0,s6
    80005242:	ffffd097          	auipc	ra,0xffffd
    80005246:	a80080e7          	jalr	-1408(ra) # 80001cc2 <proc_freepagetable>
  return -1;
    8000524a:	557d                	li	a0,-1
  if(ip){
    8000524c:	ca0a09e3          	beqz	s4,80004efe <exec+0x9c>
    80005250:	b969                	j	80004eea <exec+0x88>
    80005252:	e0943423          	sd	s1,-504(s0)
    80005256:	b7dd                	j	8000523c <exec+0x3da>
    80005258:	e0943423          	sd	s1,-504(s0)
    8000525c:	b7c5                	j	8000523c <exec+0x3da>
    8000525e:	e0943423          	sd	s1,-504(s0)
    80005262:	bfe9                	j	8000523c <exec+0x3da>
  ip = 0;
    80005264:	4a01                	li	s4,0
    80005266:	bfd9                	j	8000523c <exec+0x3da>
    80005268:	4a01                	li	s4,0
  if(pagetable)
    8000526a:	bfc9                	j	8000523c <exec+0x3da>
  sz = sz1;
    8000526c:	e0843983          	ld	s3,-504(s0)
    80005270:	b52d                	j	8000509a <exec+0x238>

0000000080005272 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005272:	7179                	add	sp,sp,-48
    80005274:	f406                	sd	ra,40(sp)
    80005276:	f022                	sd	s0,32(sp)
    80005278:	ec26                	sd	s1,24(sp)
    8000527a:	e84a                	sd	s2,16(sp)
    8000527c:	1800                	add	s0,sp,48
    8000527e:	892e                	mv	s2,a1
    80005280:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80005282:	fdc40593          	add	a1,s0,-36
    80005286:	ffffe097          	auipc	ra,0xffffe
    8000528a:	ad6080e7          	jalr	-1322(ra) # 80002d5c <argint>
    8000528e:	04054063          	bltz	a0,800052ce <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005292:	fdc42703          	lw	a4,-36(s0)
    80005296:	47bd                	li	a5,15
    80005298:	02e7ed63          	bltu	a5,a4,800052d2 <argfd+0x60>
    8000529c:	ffffc097          	auipc	ra,0xffffc
    800052a0:	7f4080e7          	jalr	2036(ra) # 80001a90 <myproc>
    800052a4:	fdc42703          	lw	a4,-36(s0)
    800052a8:	01a70793          	add	a5,a4,26
    800052ac:	078e                	sll	a5,a5,0x3
    800052ae:	953e                	add	a0,a0,a5
    800052b0:	651c                	ld	a5,8(a0)
    800052b2:	c395                	beqz	a5,800052d6 <argfd+0x64>
    return -1;
  if(pfd)
    800052b4:	00090463          	beqz	s2,800052bc <argfd+0x4a>
    *pfd = fd;
    800052b8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800052bc:	4501                	li	a0,0
  if(pf)
    800052be:	c091                	beqz	s1,800052c2 <argfd+0x50>
    *pf = f;
    800052c0:	e09c                	sd	a5,0(s1)
}
    800052c2:	70a2                	ld	ra,40(sp)
    800052c4:	7402                	ld	s0,32(sp)
    800052c6:	64e2                	ld	s1,24(sp)
    800052c8:	6942                	ld	s2,16(sp)
    800052ca:	6145                	add	sp,sp,48
    800052cc:	8082                	ret
    return -1;
    800052ce:	557d                	li	a0,-1
    800052d0:	bfcd                	j	800052c2 <argfd+0x50>
    return -1;
    800052d2:	557d                	li	a0,-1
    800052d4:	b7fd                	j	800052c2 <argfd+0x50>
    800052d6:	557d                	li	a0,-1
    800052d8:	b7ed                	j	800052c2 <argfd+0x50>

00000000800052da <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800052da:	1101                	add	sp,sp,-32
    800052dc:	ec06                	sd	ra,24(sp)
    800052de:	e822                	sd	s0,16(sp)
    800052e0:	e426                	sd	s1,8(sp)
    800052e2:	1000                	add	s0,sp,32
    800052e4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800052e6:	ffffc097          	auipc	ra,0xffffc
    800052ea:	7aa080e7          	jalr	1962(ra) # 80001a90 <myproc>
    800052ee:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800052f0:	0d850793          	add	a5,a0,216
    800052f4:	4501                	li	a0,0
    800052f6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800052f8:	6398                	ld	a4,0(a5)
    800052fa:	cb19                	beqz	a4,80005310 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800052fc:	2505                	addw	a0,a0,1
    800052fe:	07a1                	add	a5,a5,8
    80005300:	fed51ce3          	bne	a0,a3,800052f8 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005304:	557d                	li	a0,-1
}
    80005306:	60e2                	ld	ra,24(sp)
    80005308:	6442                	ld	s0,16(sp)
    8000530a:	64a2                	ld	s1,8(sp)
    8000530c:	6105                	add	sp,sp,32
    8000530e:	8082                	ret
      p->ofile[fd] = f;
    80005310:	01a50793          	add	a5,a0,26
    80005314:	078e                	sll	a5,a5,0x3
    80005316:	963e                	add	a2,a2,a5
    80005318:	e604                	sd	s1,8(a2)
      return fd;
    8000531a:	b7f5                	j	80005306 <fdalloc+0x2c>

000000008000531c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000531c:	715d                	add	sp,sp,-80
    8000531e:	e486                	sd	ra,72(sp)
    80005320:	e0a2                	sd	s0,64(sp)
    80005322:	fc26                	sd	s1,56(sp)
    80005324:	f84a                	sd	s2,48(sp)
    80005326:	f44e                	sd	s3,40(sp)
    80005328:	f052                	sd	s4,32(sp)
    8000532a:	ec56                	sd	s5,24(sp)
    8000532c:	0880                	add	s0,sp,80
    8000532e:	8aae                	mv	s5,a1
    80005330:	8a32                	mv	s4,a2
    80005332:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005334:	fb040593          	add	a1,s0,-80
    80005338:	fffff097          	auipc	ra,0xfffff
    8000533c:	e0c080e7          	jalr	-500(ra) # 80004144 <nameiparent>
    80005340:	892a                	mv	s2,a0
    80005342:	12050c63          	beqz	a0,8000547a <create+0x15e>
    return 0;

  ilock(dp);
    80005346:	ffffe097          	auipc	ra,0xffffe
    8000534a:	630080e7          	jalr	1584(ra) # 80003976 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000534e:	4601                	li	a2,0
    80005350:	fb040593          	add	a1,s0,-80
    80005354:	854a                	mv	a0,s2
    80005356:	fffff097          	auipc	ra,0xfffff
    8000535a:	afe080e7          	jalr	-1282(ra) # 80003e54 <dirlookup>
    8000535e:	84aa                	mv	s1,a0
    80005360:	c539                	beqz	a0,800053ae <create+0x92>
    iunlockput(dp);
    80005362:	854a                	mv	a0,s2
    80005364:	fffff097          	auipc	ra,0xfffff
    80005368:	874080e7          	jalr	-1932(ra) # 80003bd8 <iunlockput>
    ilock(ip);
    8000536c:	8526                	mv	a0,s1
    8000536e:	ffffe097          	auipc	ra,0xffffe
    80005372:	608080e7          	jalr	1544(ra) # 80003976 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005376:	4789                	li	a5,2
    80005378:	02fa9463          	bne	s5,a5,800053a0 <create+0x84>
    8000537c:	0444d783          	lhu	a5,68(s1)
    80005380:	37f9                	addw	a5,a5,-2
    80005382:	17c2                	sll	a5,a5,0x30
    80005384:	93c1                	srl	a5,a5,0x30
    80005386:	4705                	li	a4,1
    80005388:	00f76c63          	bltu	a4,a5,800053a0 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000538c:	8526                	mv	a0,s1
    8000538e:	60a6                	ld	ra,72(sp)
    80005390:	6406                	ld	s0,64(sp)
    80005392:	74e2                	ld	s1,56(sp)
    80005394:	7942                	ld	s2,48(sp)
    80005396:	79a2                	ld	s3,40(sp)
    80005398:	7a02                	ld	s4,32(sp)
    8000539a:	6ae2                	ld	s5,24(sp)
    8000539c:	6161                	add	sp,sp,80
    8000539e:	8082                	ret
    iunlockput(ip);
    800053a0:	8526                	mv	a0,s1
    800053a2:	fffff097          	auipc	ra,0xfffff
    800053a6:	836080e7          	jalr	-1994(ra) # 80003bd8 <iunlockput>
    return 0;
    800053aa:	4481                	li	s1,0
    800053ac:	b7c5                	j	8000538c <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    800053ae:	85d6                	mv	a1,s5
    800053b0:	00092503          	lw	a0,0(s2)
    800053b4:	ffffe097          	auipc	ra,0xffffe
    800053b8:	42e080e7          	jalr	1070(ra) # 800037e2 <ialloc>
    800053bc:	84aa                	mv	s1,a0
    800053be:	c139                	beqz	a0,80005404 <create+0xe8>
  ilock(ip);
    800053c0:	ffffe097          	auipc	ra,0xffffe
    800053c4:	5b6080e7          	jalr	1462(ra) # 80003976 <ilock>
  ip->major = major;
    800053c8:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    800053cc:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    800053d0:	4985                	li	s3,1
    800053d2:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    800053d6:	8526                	mv	a0,s1
    800053d8:	ffffe097          	auipc	ra,0xffffe
    800053dc:	4d2080e7          	jalr	1234(ra) # 800038aa <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800053e0:	033a8a63          	beq	s5,s3,80005414 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    800053e4:	40d0                	lw	a2,4(s1)
    800053e6:	fb040593          	add	a1,s0,-80
    800053ea:	854a                	mv	a0,s2
    800053ec:	fffff097          	auipc	ra,0xfffff
    800053f0:	c78080e7          	jalr	-904(ra) # 80004064 <dirlink>
    800053f4:	06054b63          	bltz	a0,8000546a <create+0x14e>
  iunlockput(dp);
    800053f8:	854a                	mv	a0,s2
    800053fa:	ffffe097          	auipc	ra,0xffffe
    800053fe:	7de080e7          	jalr	2014(ra) # 80003bd8 <iunlockput>
  return ip;
    80005402:	b769                	j	8000538c <create+0x70>
    panic("create: ialloc");
    80005404:	00003517          	auipc	a0,0x3
    80005408:	30c50513          	add	a0,a0,780 # 80008710 <syscalls+0x2b0>
    8000540c:	ffffb097          	auipc	ra,0xffffb
    80005410:	136080e7          	jalr	310(ra) # 80000542 <panic>
    dp->nlink++;  // for ".."
    80005414:	04a95783          	lhu	a5,74(s2)
    80005418:	2785                	addw	a5,a5,1
    8000541a:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000541e:	854a                	mv	a0,s2
    80005420:	ffffe097          	auipc	ra,0xffffe
    80005424:	48a080e7          	jalr	1162(ra) # 800038aa <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005428:	40d0                	lw	a2,4(s1)
    8000542a:	00003597          	auipc	a1,0x3
    8000542e:	2f658593          	add	a1,a1,758 # 80008720 <syscalls+0x2c0>
    80005432:	8526                	mv	a0,s1
    80005434:	fffff097          	auipc	ra,0xfffff
    80005438:	c30080e7          	jalr	-976(ra) # 80004064 <dirlink>
    8000543c:	00054f63          	bltz	a0,8000545a <create+0x13e>
    80005440:	00492603          	lw	a2,4(s2)
    80005444:	00003597          	auipc	a1,0x3
    80005448:	2e458593          	add	a1,a1,740 # 80008728 <syscalls+0x2c8>
    8000544c:	8526                	mv	a0,s1
    8000544e:	fffff097          	auipc	ra,0xfffff
    80005452:	c16080e7          	jalr	-1002(ra) # 80004064 <dirlink>
    80005456:	f80557e3          	bgez	a0,800053e4 <create+0xc8>
      panic("create dots");
    8000545a:	00003517          	auipc	a0,0x3
    8000545e:	2d650513          	add	a0,a0,726 # 80008730 <syscalls+0x2d0>
    80005462:	ffffb097          	auipc	ra,0xffffb
    80005466:	0e0080e7          	jalr	224(ra) # 80000542 <panic>
    panic("create: dirlink");
    8000546a:	00003517          	auipc	a0,0x3
    8000546e:	2d650513          	add	a0,a0,726 # 80008740 <syscalls+0x2e0>
    80005472:	ffffb097          	auipc	ra,0xffffb
    80005476:	0d0080e7          	jalr	208(ra) # 80000542 <panic>
    return 0;
    8000547a:	84aa                	mv	s1,a0
    8000547c:	bf01                	j	8000538c <create+0x70>

000000008000547e <sys_dup>:
{
    8000547e:	7179                	add	sp,sp,-48
    80005480:	f406                	sd	ra,40(sp)
    80005482:	f022                	sd	s0,32(sp)
    80005484:	ec26                	sd	s1,24(sp)
    80005486:	e84a                	sd	s2,16(sp)
    80005488:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000548a:	fd840613          	add	a2,s0,-40
    8000548e:	4581                	li	a1,0
    80005490:	4501                	li	a0,0
    80005492:	00000097          	auipc	ra,0x0
    80005496:	de0080e7          	jalr	-544(ra) # 80005272 <argfd>
    return -1;
    8000549a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000549c:	02054363          	bltz	a0,800054c2 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800054a0:	fd843903          	ld	s2,-40(s0)
    800054a4:	854a                	mv	a0,s2
    800054a6:	00000097          	auipc	ra,0x0
    800054aa:	e34080e7          	jalr	-460(ra) # 800052da <fdalloc>
    800054ae:	84aa                	mv	s1,a0
    return -1;
    800054b0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800054b2:	00054863          	bltz	a0,800054c2 <sys_dup+0x44>
  filedup(f);
    800054b6:	854a                	mv	a0,s2
    800054b8:	fffff097          	auipc	ra,0xfffff
    800054bc:	2d6080e7          	jalr	726(ra) # 8000478e <filedup>
  return fd;
    800054c0:	87a6                	mv	a5,s1
}
    800054c2:	853e                	mv	a0,a5
    800054c4:	70a2                	ld	ra,40(sp)
    800054c6:	7402                	ld	s0,32(sp)
    800054c8:	64e2                	ld	s1,24(sp)
    800054ca:	6942                	ld	s2,16(sp)
    800054cc:	6145                	add	sp,sp,48
    800054ce:	8082                	ret

00000000800054d0 <sys_read>:
{
    800054d0:	7179                	add	sp,sp,-48
    800054d2:	f406                	sd	ra,40(sp)
    800054d4:	f022                	sd	s0,32(sp)
    800054d6:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054d8:	fe840613          	add	a2,s0,-24
    800054dc:	4581                	li	a1,0
    800054de:	4501                	li	a0,0
    800054e0:	00000097          	auipc	ra,0x0
    800054e4:	d92080e7          	jalr	-622(ra) # 80005272 <argfd>
    return -1;
    800054e8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054ea:	04054163          	bltz	a0,8000552c <sys_read+0x5c>
    800054ee:	fe440593          	add	a1,s0,-28
    800054f2:	4509                	li	a0,2
    800054f4:	ffffe097          	auipc	ra,0xffffe
    800054f8:	868080e7          	jalr	-1944(ra) # 80002d5c <argint>
    return -1;
    800054fc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054fe:	02054763          	bltz	a0,8000552c <sys_read+0x5c>
    80005502:	fd840593          	add	a1,s0,-40
    80005506:	4505                	li	a0,1
    80005508:	ffffe097          	auipc	ra,0xffffe
    8000550c:	876080e7          	jalr	-1930(ra) # 80002d7e <argaddr>
    return -1;
    80005510:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005512:	00054d63          	bltz	a0,8000552c <sys_read+0x5c>
  return fileread(f, p, n);
    80005516:	fe442603          	lw	a2,-28(s0)
    8000551a:	fd843583          	ld	a1,-40(s0)
    8000551e:	fe843503          	ld	a0,-24(s0)
    80005522:	fffff097          	auipc	ra,0xfffff
    80005526:	3f8080e7          	jalr	1016(ra) # 8000491a <fileread>
    8000552a:	87aa                	mv	a5,a0
}
    8000552c:	853e                	mv	a0,a5
    8000552e:	70a2                	ld	ra,40(sp)
    80005530:	7402                	ld	s0,32(sp)
    80005532:	6145                	add	sp,sp,48
    80005534:	8082                	ret

0000000080005536 <sys_write>:
{
    80005536:	7179                	add	sp,sp,-48
    80005538:	f406                	sd	ra,40(sp)
    8000553a:	f022                	sd	s0,32(sp)
    8000553c:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000553e:	fe840613          	add	a2,s0,-24
    80005542:	4581                	li	a1,0
    80005544:	4501                	li	a0,0
    80005546:	00000097          	auipc	ra,0x0
    8000554a:	d2c080e7          	jalr	-724(ra) # 80005272 <argfd>
    return -1;
    8000554e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005550:	04054163          	bltz	a0,80005592 <sys_write+0x5c>
    80005554:	fe440593          	add	a1,s0,-28
    80005558:	4509                	li	a0,2
    8000555a:	ffffe097          	auipc	ra,0xffffe
    8000555e:	802080e7          	jalr	-2046(ra) # 80002d5c <argint>
    return -1;
    80005562:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005564:	02054763          	bltz	a0,80005592 <sys_write+0x5c>
    80005568:	fd840593          	add	a1,s0,-40
    8000556c:	4505                	li	a0,1
    8000556e:	ffffe097          	auipc	ra,0xffffe
    80005572:	810080e7          	jalr	-2032(ra) # 80002d7e <argaddr>
    return -1;
    80005576:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005578:	00054d63          	bltz	a0,80005592 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000557c:	fe442603          	lw	a2,-28(s0)
    80005580:	fd843583          	ld	a1,-40(s0)
    80005584:	fe843503          	ld	a0,-24(s0)
    80005588:	fffff097          	auipc	ra,0xfffff
    8000558c:	454080e7          	jalr	1108(ra) # 800049dc <filewrite>
    80005590:	87aa                	mv	a5,a0
}
    80005592:	853e                	mv	a0,a5
    80005594:	70a2                	ld	ra,40(sp)
    80005596:	7402                	ld	s0,32(sp)
    80005598:	6145                	add	sp,sp,48
    8000559a:	8082                	ret

000000008000559c <sys_close>:
{
    8000559c:	1101                	add	sp,sp,-32
    8000559e:	ec06                	sd	ra,24(sp)
    800055a0:	e822                	sd	s0,16(sp)
    800055a2:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800055a4:	fe040613          	add	a2,s0,-32
    800055a8:	fec40593          	add	a1,s0,-20
    800055ac:	4501                	li	a0,0
    800055ae:	00000097          	auipc	ra,0x0
    800055b2:	cc4080e7          	jalr	-828(ra) # 80005272 <argfd>
    return -1;
    800055b6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800055b8:	02054463          	bltz	a0,800055e0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800055bc:	ffffc097          	auipc	ra,0xffffc
    800055c0:	4d4080e7          	jalr	1236(ra) # 80001a90 <myproc>
    800055c4:	fec42783          	lw	a5,-20(s0)
    800055c8:	07e9                	add	a5,a5,26
    800055ca:	078e                	sll	a5,a5,0x3
    800055cc:	953e                	add	a0,a0,a5
    800055ce:	00053423          	sd	zero,8(a0)
  fileclose(f);
    800055d2:	fe043503          	ld	a0,-32(s0)
    800055d6:	fffff097          	auipc	ra,0xfffff
    800055da:	20a080e7          	jalr	522(ra) # 800047e0 <fileclose>
  return 0;
    800055de:	4781                	li	a5,0
}
    800055e0:	853e                	mv	a0,a5
    800055e2:	60e2                	ld	ra,24(sp)
    800055e4:	6442                	ld	s0,16(sp)
    800055e6:	6105                	add	sp,sp,32
    800055e8:	8082                	ret

00000000800055ea <sys_fstat>:
{
    800055ea:	1101                	add	sp,sp,-32
    800055ec:	ec06                	sd	ra,24(sp)
    800055ee:	e822                	sd	s0,16(sp)
    800055f0:	1000                	add	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800055f2:	fe840613          	add	a2,s0,-24
    800055f6:	4581                	li	a1,0
    800055f8:	4501                	li	a0,0
    800055fa:	00000097          	auipc	ra,0x0
    800055fe:	c78080e7          	jalr	-904(ra) # 80005272 <argfd>
    return -1;
    80005602:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005604:	02054563          	bltz	a0,8000562e <sys_fstat+0x44>
    80005608:	fe040593          	add	a1,s0,-32
    8000560c:	4505                	li	a0,1
    8000560e:	ffffd097          	auipc	ra,0xffffd
    80005612:	770080e7          	jalr	1904(ra) # 80002d7e <argaddr>
    return -1;
    80005616:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005618:	00054b63          	bltz	a0,8000562e <sys_fstat+0x44>
  return filestat(f, st);
    8000561c:	fe043583          	ld	a1,-32(s0)
    80005620:	fe843503          	ld	a0,-24(s0)
    80005624:	fffff097          	auipc	ra,0xfffff
    80005628:	284080e7          	jalr	644(ra) # 800048a8 <filestat>
    8000562c:	87aa                	mv	a5,a0
}
    8000562e:	853e                	mv	a0,a5
    80005630:	60e2                	ld	ra,24(sp)
    80005632:	6442                	ld	s0,16(sp)
    80005634:	6105                	add	sp,sp,32
    80005636:	8082                	ret

0000000080005638 <sys_link>:
{
    80005638:	7169                	add	sp,sp,-304
    8000563a:	f606                	sd	ra,296(sp)
    8000563c:	f222                	sd	s0,288(sp)
    8000563e:	ee26                	sd	s1,280(sp)
    80005640:	ea4a                	sd	s2,272(sp)
    80005642:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005644:	08000613          	li	a2,128
    80005648:	ed040593          	add	a1,s0,-304
    8000564c:	4501                	li	a0,0
    8000564e:	ffffd097          	auipc	ra,0xffffd
    80005652:	752080e7          	jalr	1874(ra) # 80002da0 <argstr>
    return -1;
    80005656:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005658:	10054e63          	bltz	a0,80005774 <sys_link+0x13c>
    8000565c:	08000613          	li	a2,128
    80005660:	f5040593          	add	a1,s0,-176
    80005664:	4505                	li	a0,1
    80005666:	ffffd097          	auipc	ra,0xffffd
    8000566a:	73a080e7          	jalr	1850(ra) # 80002da0 <argstr>
    return -1;
    8000566e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005670:	10054263          	bltz	a0,80005774 <sys_link+0x13c>
  begin_op();
    80005674:	fffff097          	auipc	ra,0xfffff
    80005678:	ca2080e7          	jalr	-862(ra) # 80004316 <begin_op>
  if((ip = namei(old)) == 0){
    8000567c:	ed040513          	add	a0,s0,-304
    80005680:	fffff097          	auipc	ra,0xfffff
    80005684:	aa6080e7          	jalr	-1370(ra) # 80004126 <namei>
    80005688:	84aa                	mv	s1,a0
    8000568a:	c551                	beqz	a0,80005716 <sys_link+0xde>
  ilock(ip);
    8000568c:	ffffe097          	auipc	ra,0xffffe
    80005690:	2ea080e7          	jalr	746(ra) # 80003976 <ilock>
  if(ip->type == T_DIR){
    80005694:	04449703          	lh	a4,68(s1)
    80005698:	4785                	li	a5,1
    8000569a:	08f70463          	beq	a4,a5,80005722 <sys_link+0xea>
  ip->nlink++;
    8000569e:	04a4d783          	lhu	a5,74(s1)
    800056a2:	2785                	addw	a5,a5,1
    800056a4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800056a8:	8526                	mv	a0,s1
    800056aa:	ffffe097          	auipc	ra,0xffffe
    800056ae:	200080e7          	jalr	512(ra) # 800038aa <iupdate>
  iunlock(ip);
    800056b2:	8526                	mv	a0,s1
    800056b4:	ffffe097          	auipc	ra,0xffffe
    800056b8:	384080e7          	jalr	900(ra) # 80003a38 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800056bc:	fd040593          	add	a1,s0,-48
    800056c0:	f5040513          	add	a0,s0,-176
    800056c4:	fffff097          	auipc	ra,0xfffff
    800056c8:	a80080e7          	jalr	-1408(ra) # 80004144 <nameiparent>
    800056cc:	892a                	mv	s2,a0
    800056ce:	c935                	beqz	a0,80005742 <sys_link+0x10a>
  ilock(dp);
    800056d0:	ffffe097          	auipc	ra,0xffffe
    800056d4:	2a6080e7          	jalr	678(ra) # 80003976 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800056d8:	00092703          	lw	a4,0(s2)
    800056dc:	409c                	lw	a5,0(s1)
    800056de:	04f71d63          	bne	a4,a5,80005738 <sys_link+0x100>
    800056e2:	40d0                	lw	a2,4(s1)
    800056e4:	fd040593          	add	a1,s0,-48
    800056e8:	854a                	mv	a0,s2
    800056ea:	fffff097          	auipc	ra,0xfffff
    800056ee:	97a080e7          	jalr	-1670(ra) # 80004064 <dirlink>
    800056f2:	04054363          	bltz	a0,80005738 <sys_link+0x100>
  iunlockput(dp);
    800056f6:	854a                	mv	a0,s2
    800056f8:	ffffe097          	auipc	ra,0xffffe
    800056fc:	4e0080e7          	jalr	1248(ra) # 80003bd8 <iunlockput>
  iput(ip);
    80005700:	8526                	mv	a0,s1
    80005702:	ffffe097          	auipc	ra,0xffffe
    80005706:	42e080e7          	jalr	1070(ra) # 80003b30 <iput>
  end_op();
    8000570a:	fffff097          	auipc	ra,0xfffff
    8000570e:	c86080e7          	jalr	-890(ra) # 80004390 <end_op>
  return 0;
    80005712:	4781                	li	a5,0
    80005714:	a085                	j	80005774 <sys_link+0x13c>
    end_op();
    80005716:	fffff097          	auipc	ra,0xfffff
    8000571a:	c7a080e7          	jalr	-902(ra) # 80004390 <end_op>
    return -1;
    8000571e:	57fd                	li	a5,-1
    80005720:	a891                	j	80005774 <sys_link+0x13c>
    iunlockput(ip);
    80005722:	8526                	mv	a0,s1
    80005724:	ffffe097          	auipc	ra,0xffffe
    80005728:	4b4080e7          	jalr	1204(ra) # 80003bd8 <iunlockput>
    end_op();
    8000572c:	fffff097          	auipc	ra,0xfffff
    80005730:	c64080e7          	jalr	-924(ra) # 80004390 <end_op>
    return -1;
    80005734:	57fd                	li	a5,-1
    80005736:	a83d                	j	80005774 <sys_link+0x13c>
    iunlockput(dp);
    80005738:	854a                	mv	a0,s2
    8000573a:	ffffe097          	auipc	ra,0xffffe
    8000573e:	49e080e7          	jalr	1182(ra) # 80003bd8 <iunlockput>
  ilock(ip);
    80005742:	8526                	mv	a0,s1
    80005744:	ffffe097          	auipc	ra,0xffffe
    80005748:	232080e7          	jalr	562(ra) # 80003976 <ilock>
  ip->nlink--;
    8000574c:	04a4d783          	lhu	a5,74(s1)
    80005750:	37fd                	addw	a5,a5,-1
    80005752:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005756:	8526                	mv	a0,s1
    80005758:	ffffe097          	auipc	ra,0xffffe
    8000575c:	152080e7          	jalr	338(ra) # 800038aa <iupdate>
  iunlockput(ip);
    80005760:	8526                	mv	a0,s1
    80005762:	ffffe097          	auipc	ra,0xffffe
    80005766:	476080e7          	jalr	1142(ra) # 80003bd8 <iunlockput>
  end_op();
    8000576a:	fffff097          	auipc	ra,0xfffff
    8000576e:	c26080e7          	jalr	-986(ra) # 80004390 <end_op>
  return -1;
    80005772:	57fd                	li	a5,-1
}
    80005774:	853e                	mv	a0,a5
    80005776:	70b2                	ld	ra,296(sp)
    80005778:	7412                	ld	s0,288(sp)
    8000577a:	64f2                	ld	s1,280(sp)
    8000577c:	6952                	ld	s2,272(sp)
    8000577e:	6155                	add	sp,sp,304
    80005780:	8082                	ret

0000000080005782 <sys_unlink>:
{
    80005782:	7151                	add	sp,sp,-240
    80005784:	f586                	sd	ra,232(sp)
    80005786:	f1a2                	sd	s0,224(sp)
    80005788:	eda6                	sd	s1,216(sp)
    8000578a:	e9ca                	sd	s2,208(sp)
    8000578c:	e5ce                	sd	s3,200(sp)
    8000578e:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005790:	08000613          	li	a2,128
    80005794:	f3040593          	add	a1,s0,-208
    80005798:	4501                	li	a0,0
    8000579a:	ffffd097          	auipc	ra,0xffffd
    8000579e:	606080e7          	jalr	1542(ra) # 80002da0 <argstr>
    800057a2:	18054163          	bltz	a0,80005924 <sys_unlink+0x1a2>
  begin_op();
    800057a6:	fffff097          	auipc	ra,0xfffff
    800057aa:	b70080e7          	jalr	-1168(ra) # 80004316 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800057ae:	fb040593          	add	a1,s0,-80
    800057b2:	f3040513          	add	a0,s0,-208
    800057b6:	fffff097          	auipc	ra,0xfffff
    800057ba:	98e080e7          	jalr	-1650(ra) # 80004144 <nameiparent>
    800057be:	84aa                	mv	s1,a0
    800057c0:	c979                	beqz	a0,80005896 <sys_unlink+0x114>
  ilock(dp);
    800057c2:	ffffe097          	auipc	ra,0xffffe
    800057c6:	1b4080e7          	jalr	436(ra) # 80003976 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800057ca:	00003597          	auipc	a1,0x3
    800057ce:	f5658593          	add	a1,a1,-170 # 80008720 <syscalls+0x2c0>
    800057d2:	fb040513          	add	a0,s0,-80
    800057d6:	ffffe097          	auipc	ra,0xffffe
    800057da:	664080e7          	jalr	1636(ra) # 80003e3a <namecmp>
    800057de:	14050a63          	beqz	a0,80005932 <sys_unlink+0x1b0>
    800057e2:	00003597          	auipc	a1,0x3
    800057e6:	f4658593          	add	a1,a1,-186 # 80008728 <syscalls+0x2c8>
    800057ea:	fb040513          	add	a0,s0,-80
    800057ee:	ffffe097          	auipc	ra,0xffffe
    800057f2:	64c080e7          	jalr	1612(ra) # 80003e3a <namecmp>
    800057f6:	12050e63          	beqz	a0,80005932 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800057fa:	f2c40613          	add	a2,s0,-212
    800057fe:	fb040593          	add	a1,s0,-80
    80005802:	8526                	mv	a0,s1
    80005804:	ffffe097          	auipc	ra,0xffffe
    80005808:	650080e7          	jalr	1616(ra) # 80003e54 <dirlookup>
    8000580c:	892a                	mv	s2,a0
    8000580e:	12050263          	beqz	a0,80005932 <sys_unlink+0x1b0>
  ilock(ip);
    80005812:	ffffe097          	auipc	ra,0xffffe
    80005816:	164080e7          	jalr	356(ra) # 80003976 <ilock>
  if(ip->nlink < 1)
    8000581a:	04a91783          	lh	a5,74(s2)
    8000581e:	08f05263          	blez	a5,800058a2 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005822:	04491703          	lh	a4,68(s2)
    80005826:	4785                	li	a5,1
    80005828:	08f70563          	beq	a4,a5,800058b2 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    8000582c:	4641                	li	a2,16
    8000582e:	4581                	li	a1,0
    80005830:	fc040513          	add	a0,s0,-64
    80005834:	ffffb097          	auipc	ra,0xffffb
    80005838:	4c4080e7          	jalr	1220(ra) # 80000cf8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000583c:	4741                	li	a4,16
    8000583e:	f2c42683          	lw	a3,-212(s0)
    80005842:	fc040613          	add	a2,s0,-64
    80005846:	4581                	li	a1,0
    80005848:	8526                	mv	a0,s1
    8000584a:	ffffe097          	auipc	ra,0xffffe
    8000584e:	4d6080e7          	jalr	1238(ra) # 80003d20 <writei>
    80005852:	47c1                	li	a5,16
    80005854:	0af51563          	bne	a0,a5,800058fe <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005858:	04491703          	lh	a4,68(s2)
    8000585c:	4785                	li	a5,1
    8000585e:	0af70863          	beq	a4,a5,8000590e <sys_unlink+0x18c>
  iunlockput(dp);
    80005862:	8526                	mv	a0,s1
    80005864:	ffffe097          	auipc	ra,0xffffe
    80005868:	374080e7          	jalr	884(ra) # 80003bd8 <iunlockput>
  ip->nlink--;
    8000586c:	04a95783          	lhu	a5,74(s2)
    80005870:	37fd                	addw	a5,a5,-1
    80005872:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005876:	854a                	mv	a0,s2
    80005878:	ffffe097          	auipc	ra,0xffffe
    8000587c:	032080e7          	jalr	50(ra) # 800038aa <iupdate>
  iunlockput(ip);
    80005880:	854a                	mv	a0,s2
    80005882:	ffffe097          	auipc	ra,0xffffe
    80005886:	356080e7          	jalr	854(ra) # 80003bd8 <iunlockput>
  end_op();
    8000588a:	fffff097          	auipc	ra,0xfffff
    8000588e:	b06080e7          	jalr	-1274(ra) # 80004390 <end_op>
  return 0;
    80005892:	4501                	li	a0,0
    80005894:	a84d                	j	80005946 <sys_unlink+0x1c4>
    end_op();
    80005896:	fffff097          	auipc	ra,0xfffff
    8000589a:	afa080e7          	jalr	-1286(ra) # 80004390 <end_op>
    return -1;
    8000589e:	557d                	li	a0,-1
    800058a0:	a05d                	j	80005946 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800058a2:	00003517          	auipc	a0,0x3
    800058a6:	eae50513          	add	a0,a0,-338 # 80008750 <syscalls+0x2f0>
    800058aa:	ffffb097          	auipc	ra,0xffffb
    800058ae:	c98080e7          	jalr	-872(ra) # 80000542 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800058b2:	04c92703          	lw	a4,76(s2)
    800058b6:	02000793          	li	a5,32
    800058ba:	f6e7f9e3          	bgeu	a5,a4,8000582c <sys_unlink+0xaa>
    800058be:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800058c2:	4741                	li	a4,16
    800058c4:	86ce                	mv	a3,s3
    800058c6:	f1840613          	add	a2,s0,-232
    800058ca:	4581                	li	a1,0
    800058cc:	854a                	mv	a0,s2
    800058ce:	ffffe097          	auipc	ra,0xffffe
    800058d2:	35c080e7          	jalr	860(ra) # 80003c2a <readi>
    800058d6:	47c1                	li	a5,16
    800058d8:	00f51b63          	bne	a0,a5,800058ee <sys_unlink+0x16c>
    if(de.inum != 0)
    800058dc:	f1845783          	lhu	a5,-232(s0)
    800058e0:	e7a1                	bnez	a5,80005928 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800058e2:	29c1                	addw	s3,s3,16
    800058e4:	04c92783          	lw	a5,76(s2)
    800058e8:	fcf9ede3          	bltu	s3,a5,800058c2 <sys_unlink+0x140>
    800058ec:	b781                	j	8000582c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800058ee:	00003517          	auipc	a0,0x3
    800058f2:	e7a50513          	add	a0,a0,-390 # 80008768 <syscalls+0x308>
    800058f6:	ffffb097          	auipc	ra,0xffffb
    800058fa:	c4c080e7          	jalr	-948(ra) # 80000542 <panic>
    panic("unlink: writei");
    800058fe:	00003517          	auipc	a0,0x3
    80005902:	e8250513          	add	a0,a0,-382 # 80008780 <syscalls+0x320>
    80005906:	ffffb097          	auipc	ra,0xffffb
    8000590a:	c3c080e7          	jalr	-964(ra) # 80000542 <panic>
    dp->nlink--;
    8000590e:	04a4d783          	lhu	a5,74(s1)
    80005912:	37fd                	addw	a5,a5,-1
    80005914:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005918:	8526                	mv	a0,s1
    8000591a:	ffffe097          	auipc	ra,0xffffe
    8000591e:	f90080e7          	jalr	-112(ra) # 800038aa <iupdate>
    80005922:	b781                	j	80005862 <sys_unlink+0xe0>
    return -1;
    80005924:	557d                	li	a0,-1
    80005926:	a005                	j	80005946 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005928:	854a                	mv	a0,s2
    8000592a:	ffffe097          	auipc	ra,0xffffe
    8000592e:	2ae080e7          	jalr	686(ra) # 80003bd8 <iunlockput>
  iunlockput(dp);
    80005932:	8526                	mv	a0,s1
    80005934:	ffffe097          	auipc	ra,0xffffe
    80005938:	2a4080e7          	jalr	676(ra) # 80003bd8 <iunlockput>
  end_op();
    8000593c:	fffff097          	auipc	ra,0xfffff
    80005940:	a54080e7          	jalr	-1452(ra) # 80004390 <end_op>
  return -1;
    80005944:	557d                	li	a0,-1
}
    80005946:	70ae                	ld	ra,232(sp)
    80005948:	740e                	ld	s0,224(sp)
    8000594a:	64ee                	ld	s1,216(sp)
    8000594c:	694e                	ld	s2,208(sp)
    8000594e:	69ae                	ld	s3,200(sp)
    80005950:	616d                	add	sp,sp,240
    80005952:	8082                	ret

0000000080005954 <sys_open>:

uint64
sys_open(void)
{
    80005954:	7131                	add	sp,sp,-192
    80005956:	fd06                	sd	ra,184(sp)
    80005958:	f922                	sd	s0,176(sp)
    8000595a:	f526                	sd	s1,168(sp)
    8000595c:	f14a                	sd	s2,160(sp)
    8000595e:	ed4e                	sd	s3,152(sp)
    80005960:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005962:	08000613          	li	a2,128
    80005966:	f5040593          	add	a1,s0,-176
    8000596a:	4501                	li	a0,0
    8000596c:	ffffd097          	auipc	ra,0xffffd
    80005970:	434080e7          	jalr	1076(ra) # 80002da0 <argstr>
    return -1;
    80005974:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005976:	0c054063          	bltz	a0,80005a36 <sys_open+0xe2>
    8000597a:	f4c40593          	add	a1,s0,-180
    8000597e:	4505                	li	a0,1
    80005980:	ffffd097          	auipc	ra,0xffffd
    80005984:	3dc080e7          	jalr	988(ra) # 80002d5c <argint>
    80005988:	0a054763          	bltz	a0,80005a36 <sys_open+0xe2>

  begin_op();
    8000598c:	fffff097          	auipc	ra,0xfffff
    80005990:	98a080e7          	jalr	-1654(ra) # 80004316 <begin_op>

  if(omode & O_CREATE){
    80005994:	f4c42783          	lw	a5,-180(s0)
    80005998:	2007f793          	and	a5,a5,512
    8000599c:	cbd5                	beqz	a5,80005a50 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    8000599e:	4681                	li	a3,0
    800059a0:	4601                	li	a2,0
    800059a2:	4589                	li	a1,2
    800059a4:	f5040513          	add	a0,s0,-176
    800059a8:	00000097          	auipc	ra,0x0
    800059ac:	974080e7          	jalr	-1676(ra) # 8000531c <create>
    800059b0:	892a                	mv	s2,a0
    if(ip == 0){
    800059b2:	c951                	beqz	a0,80005a46 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800059b4:	04491703          	lh	a4,68(s2)
    800059b8:	478d                	li	a5,3
    800059ba:	00f71763          	bne	a4,a5,800059c8 <sys_open+0x74>
    800059be:	04695703          	lhu	a4,70(s2)
    800059c2:	47a5                	li	a5,9
    800059c4:	0ce7eb63          	bltu	a5,a4,80005a9a <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800059c8:	fffff097          	auipc	ra,0xfffff
    800059cc:	d5c080e7          	jalr	-676(ra) # 80004724 <filealloc>
    800059d0:	89aa                	mv	s3,a0
    800059d2:	c565                	beqz	a0,80005aba <sys_open+0x166>
    800059d4:	00000097          	auipc	ra,0x0
    800059d8:	906080e7          	jalr	-1786(ra) # 800052da <fdalloc>
    800059dc:	84aa                	mv	s1,a0
    800059de:	0c054963          	bltz	a0,80005ab0 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800059e2:	04491703          	lh	a4,68(s2)
    800059e6:	478d                	li	a5,3
    800059e8:	0ef70463          	beq	a4,a5,80005ad0 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800059ec:	4789                	li	a5,2
    800059ee:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    800059f2:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    800059f6:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    800059fa:	f4c42783          	lw	a5,-180(s0)
    800059fe:	0017c713          	xor	a4,a5,1
    80005a02:	8b05                	and	a4,a4,1
    80005a04:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005a08:	0037f713          	and	a4,a5,3
    80005a0c:	00e03733          	snez	a4,a4
    80005a10:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005a14:	4007f793          	and	a5,a5,1024
    80005a18:	c791                	beqz	a5,80005a24 <sys_open+0xd0>
    80005a1a:	04491703          	lh	a4,68(s2)
    80005a1e:	4789                	li	a5,2
    80005a20:	0af70f63          	beq	a4,a5,80005ade <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80005a24:	854a                	mv	a0,s2
    80005a26:	ffffe097          	auipc	ra,0xffffe
    80005a2a:	012080e7          	jalr	18(ra) # 80003a38 <iunlock>
  end_op();
    80005a2e:	fffff097          	auipc	ra,0xfffff
    80005a32:	962080e7          	jalr	-1694(ra) # 80004390 <end_op>

  return fd;
}
    80005a36:	8526                	mv	a0,s1
    80005a38:	70ea                	ld	ra,184(sp)
    80005a3a:	744a                	ld	s0,176(sp)
    80005a3c:	74aa                	ld	s1,168(sp)
    80005a3e:	790a                	ld	s2,160(sp)
    80005a40:	69ea                	ld	s3,152(sp)
    80005a42:	6129                	add	sp,sp,192
    80005a44:	8082                	ret
      end_op();
    80005a46:	fffff097          	auipc	ra,0xfffff
    80005a4a:	94a080e7          	jalr	-1718(ra) # 80004390 <end_op>
      return -1;
    80005a4e:	b7e5                	j	80005a36 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80005a50:	f5040513          	add	a0,s0,-176
    80005a54:	ffffe097          	auipc	ra,0xffffe
    80005a58:	6d2080e7          	jalr	1746(ra) # 80004126 <namei>
    80005a5c:	892a                	mv	s2,a0
    80005a5e:	c905                	beqz	a0,80005a8e <sys_open+0x13a>
    ilock(ip);
    80005a60:	ffffe097          	auipc	ra,0xffffe
    80005a64:	f16080e7          	jalr	-234(ra) # 80003976 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005a68:	04491703          	lh	a4,68(s2)
    80005a6c:	4785                	li	a5,1
    80005a6e:	f4f713e3          	bne	a4,a5,800059b4 <sys_open+0x60>
    80005a72:	f4c42783          	lw	a5,-180(s0)
    80005a76:	dba9                	beqz	a5,800059c8 <sys_open+0x74>
      iunlockput(ip);
    80005a78:	854a                	mv	a0,s2
    80005a7a:	ffffe097          	auipc	ra,0xffffe
    80005a7e:	15e080e7          	jalr	350(ra) # 80003bd8 <iunlockput>
      end_op();
    80005a82:	fffff097          	auipc	ra,0xfffff
    80005a86:	90e080e7          	jalr	-1778(ra) # 80004390 <end_op>
      return -1;
    80005a8a:	54fd                	li	s1,-1
    80005a8c:	b76d                	j	80005a36 <sys_open+0xe2>
      end_op();
    80005a8e:	fffff097          	auipc	ra,0xfffff
    80005a92:	902080e7          	jalr	-1790(ra) # 80004390 <end_op>
      return -1;
    80005a96:	54fd                	li	s1,-1
    80005a98:	bf79                	j	80005a36 <sys_open+0xe2>
    iunlockput(ip);
    80005a9a:	854a                	mv	a0,s2
    80005a9c:	ffffe097          	auipc	ra,0xffffe
    80005aa0:	13c080e7          	jalr	316(ra) # 80003bd8 <iunlockput>
    end_op();
    80005aa4:	fffff097          	auipc	ra,0xfffff
    80005aa8:	8ec080e7          	jalr	-1812(ra) # 80004390 <end_op>
    return -1;
    80005aac:	54fd                	li	s1,-1
    80005aae:	b761                	j	80005a36 <sys_open+0xe2>
      fileclose(f);
    80005ab0:	854e                	mv	a0,s3
    80005ab2:	fffff097          	auipc	ra,0xfffff
    80005ab6:	d2e080e7          	jalr	-722(ra) # 800047e0 <fileclose>
    iunlockput(ip);
    80005aba:	854a                	mv	a0,s2
    80005abc:	ffffe097          	auipc	ra,0xffffe
    80005ac0:	11c080e7          	jalr	284(ra) # 80003bd8 <iunlockput>
    end_op();
    80005ac4:	fffff097          	auipc	ra,0xfffff
    80005ac8:	8cc080e7          	jalr	-1844(ra) # 80004390 <end_op>
    return -1;
    80005acc:	54fd                	li	s1,-1
    80005ace:	b7a5                	j	80005a36 <sys_open+0xe2>
    f->type = FD_DEVICE;
    80005ad0:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005ad4:	04691783          	lh	a5,70(s2)
    80005ad8:	02f99223          	sh	a5,36(s3)
    80005adc:	bf29                	j	800059f6 <sys_open+0xa2>
    itrunc(ip);
    80005ade:	854a                	mv	a0,s2
    80005ae0:	ffffe097          	auipc	ra,0xffffe
    80005ae4:	fa4080e7          	jalr	-92(ra) # 80003a84 <itrunc>
    80005ae8:	bf35                	j	80005a24 <sys_open+0xd0>

0000000080005aea <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005aea:	7175                	add	sp,sp,-144
    80005aec:	e506                	sd	ra,136(sp)
    80005aee:	e122                	sd	s0,128(sp)
    80005af0:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005af2:	fffff097          	auipc	ra,0xfffff
    80005af6:	824080e7          	jalr	-2012(ra) # 80004316 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005afa:	08000613          	li	a2,128
    80005afe:	f7040593          	add	a1,s0,-144
    80005b02:	4501                	li	a0,0
    80005b04:	ffffd097          	auipc	ra,0xffffd
    80005b08:	29c080e7          	jalr	668(ra) # 80002da0 <argstr>
    80005b0c:	02054963          	bltz	a0,80005b3e <sys_mkdir+0x54>
    80005b10:	4681                	li	a3,0
    80005b12:	4601                	li	a2,0
    80005b14:	4585                	li	a1,1
    80005b16:	f7040513          	add	a0,s0,-144
    80005b1a:	00000097          	auipc	ra,0x0
    80005b1e:	802080e7          	jalr	-2046(ra) # 8000531c <create>
    80005b22:	cd11                	beqz	a0,80005b3e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005b24:	ffffe097          	auipc	ra,0xffffe
    80005b28:	0b4080e7          	jalr	180(ra) # 80003bd8 <iunlockput>
  end_op();
    80005b2c:	fffff097          	auipc	ra,0xfffff
    80005b30:	864080e7          	jalr	-1948(ra) # 80004390 <end_op>
  return 0;
    80005b34:	4501                	li	a0,0
}
    80005b36:	60aa                	ld	ra,136(sp)
    80005b38:	640a                	ld	s0,128(sp)
    80005b3a:	6149                	add	sp,sp,144
    80005b3c:	8082                	ret
    end_op();
    80005b3e:	fffff097          	auipc	ra,0xfffff
    80005b42:	852080e7          	jalr	-1966(ra) # 80004390 <end_op>
    return -1;
    80005b46:	557d                	li	a0,-1
    80005b48:	b7fd                	j	80005b36 <sys_mkdir+0x4c>

0000000080005b4a <sys_mknod>:

uint64
sys_mknod(void)
{
    80005b4a:	7135                	add	sp,sp,-160
    80005b4c:	ed06                	sd	ra,152(sp)
    80005b4e:	e922                	sd	s0,144(sp)
    80005b50:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005b52:	ffffe097          	auipc	ra,0xffffe
    80005b56:	7c4080e7          	jalr	1988(ra) # 80004316 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005b5a:	08000613          	li	a2,128
    80005b5e:	f7040593          	add	a1,s0,-144
    80005b62:	4501                	li	a0,0
    80005b64:	ffffd097          	auipc	ra,0xffffd
    80005b68:	23c080e7          	jalr	572(ra) # 80002da0 <argstr>
    80005b6c:	04054a63          	bltz	a0,80005bc0 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005b70:	f6c40593          	add	a1,s0,-148
    80005b74:	4505                	li	a0,1
    80005b76:	ffffd097          	auipc	ra,0xffffd
    80005b7a:	1e6080e7          	jalr	486(ra) # 80002d5c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005b7e:	04054163          	bltz	a0,80005bc0 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005b82:	f6840593          	add	a1,s0,-152
    80005b86:	4509                	li	a0,2
    80005b88:	ffffd097          	auipc	ra,0xffffd
    80005b8c:	1d4080e7          	jalr	468(ra) # 80002d5c <argint>
     argint(1, &major) < 0 ||
    80005b90:	02054863          	bltz	a0,80005bc0 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005b94:	f6841683          	lh	a3,-152(s0)
    80005b98:	f6c41603          	lh	a2,-148(s0)
    80005b9c:	458d                	li	a1,3
    80005b9e:	f7040513          	add	a0,s0,-144
    80005ba2:	fffff097          	auipc	ra,0xfffff
    80005ba6:	77a080e7          	jalr	1914(ra) # 8000531c <create>
     argint(2, &minor) < 0 ||
    80005baa:	c919                	beqz	a0,80005bc0 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005bac:	ffffe097          	auipc	ra,0xffffe
    80005bb0:	02c080e7          	jalr	44(ra) # 80003bd8 <iunlockput>
  end_op();
    80005bb4:	ffffe097          	auipc	ra,0xffffe
    80005bb8:	7dc080e7          	jalr	2012(ra) # 80004390 <end_op>
  return 0;
    80005bbc:	4501                	li	a0,0
    80005bbe:	a031                	j	80005bca <sys_mknod+0x80>
    end_op();
    80005bc0:	ffffe097          	auipc	ra,0xffffe
    80005bc4:	7d0080e7          	jalr	2000(ra) # 80004390 <end_op>
    return -1;
    80005bc8:	557d                	li	a0,-1
}
    80005bca:	60ea                	ld	ra,152(sp)
    80005bcc:	644a                	ld	s0,144(sp)
    80005bce:	610d                	add	sp,sp,160
    80005bd0:	8082                	ret

0000000080005bd2 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005bd2:	7135                	add	sp,sp,-160
    80005bd4:	ed06                	sd	ra,152(sp)
    80005bd6:	e922                	sd	s0,144(sp)
    80005bd8:	e526                	sd	s1,136(sp)
    80005bda:	e14a                	sd	s2,128(sp)
    80005bdc:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005bde:	ffffc097          	auipc	ra,0xffffc
    80005be2:	eb2080e7          	jalr	-334(ra) # 80001a90 <myproc>
    80005be6:	892a                	mv	s2,a0
  
  begin_op();
    80005be8:	ffffe097          	auipc	ra,0xffffe
    80005bec:	72e080e7          	jalr	1838(ra) # 80004316 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005bf0:	08000613          	li	a2,128
    80005bf4:	f6040593          	add	a1,s0,-160
    80005bf8:	4501                	li	a0,0
    80005bfa:	ffffd097          	auipc	ra,0xffffd
    80005bfe:	1a6080e7          	jalr	422(ra) # 80002da0 <argstr>
    80005c02:	04054b63          	bltz	a0,80005c58 <sys_chdir+0x86>
    80005c06:	f6040513          	add	a0,s0,-160
    80005c0a:	ffffe097          	auipc	ra,0xffffe
    80005c0e:	51c080e7          	jalr	1308(ra) # 80004126 <namei>
    80005c12:	84aa                	mv	s1,a0
    80005c14:	c131                	beqz	a0,80005c58 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005c16:	ffffe097          	auipc	ra,0xffffe
    80005c1a:	d60080e7          	jalr	-672(ra) # 80003976 <ilock>
  if(ip->type != T_DIR){
    80005c1e:	04449703          	lh	a4,68(s1)
    80005c22:	4785                	li	a5,1
    80005c24:	04f71063          	bne	a4,a5,80005c64 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005c28:	8526                	mv	a0,s1
    80005c2a:	ffffe097          	auipc	ra,0xffffe
    80005c2e:	e0e080e7          	jalr	-498(ra) # 80003a38 <iunlock>
  iput(p->cwd);
    80005c32:	15893503          	ld	a0,344(s2)
    80005c36:	ffffe097          	auipc	ra,0xffffe
    80005c3a:	efa080e7          	jalr	-262(ra) # 80003b30 <iput>
  end_op();
    80005c3e:	ffffe097          	auipc	ra,0xffffe
    80005c42:	752080e7          	jalr	1874(ra) # 80004390 <end_op>
  p->cwd = ip;
    80005c46:	14993c23          	sd	s1,344(s2)
  return 0;
    80005c4a:	4501                	li	a0,0
}
    80005c4c:	60ea                	ld	ra,152(sp)
    80005c4e:	644a                	ld	s0,144(sp)
    80005c50:	64aa                	ld	s1,136(sp)
    80005c52:	690a                	ld	s2,128(sp)
    80005c54:	610d                	add	sp,sp,160
    80005c56:	8082                	ret
    end_op();
    80005c58:	ffffe097          	auipc	ra,0xffffe
    80005c5c:	738080e7          	jalr	1848(ra) # 80004390 <end_op>
    return -1;
    80005c60:	557d                	li	a0,-1
    80005c62:	b7ed                	j	80005c4c <sys_chdir+0x7a>
    iunlockput(ip);
    80005c64:	8526                	mv	a0,s1
    80005c66:	ffffe097          	auipc	ra,0xffffe
    80005c6a:	f72080e7          	jalr	-142(ra) # 80003bd8 <iunlockput>
    end_op();
    80005c6e:	ffffe097          	auipc	ra,0xffffe
    80005c72:	722080e7          	jalr	1826(ra) # 80004390 <end_op>
    return -1;
    80005c76:	557d                	li	a0,-1
    80005c78:	bfd1                	j	80005c4c <sys_chdir+0x7a>

0000000080005c7a <sys_exec>:

uint64
sys_exec(void)
{
    80005c7a:	7121                	add	sp,sp,-448
    80005c7c:	ff06                	sd	ra,440(sp)
    80005c7e:	fb22                	sd	s0,432(sp)
    80005c80:	f726                	sd	s1,424(sp)
    80005c82:	f34a                	sd	s2,416(sp)
    80005c84:	ef4e                	sd	s3,408(sp)
    80005c86:	eb52                	sd	s4,400(sp)
    80005c88:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005c8a:	08000613          	li	a2,128
    80005c8e:	f5040593          	add	a1,s0,-176
    80005c92:	4501                	li	a0,0
    80005c94:	ffffd097          	auipc	ra,0xffffd
    80005c98:	10c080e7          	jalr	268(ra) # 80002da0 <argstr>
    return -1;
    80005c9c:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005c9e:	0c054a63          	bltz	a0,80005d72 <sys_exec+0xf8>
    80005ca2:	e4840593          	add	a1,s0,-440
    80005ca6:	4505                	li	a0,1
    80005ca8:	ffffd097          	auipc	ra,0xffffd
    80005cac:	0d6080e7          	jalr	214(ra) # 80002d7e <argaddr>
    80005cb0:	0c054163          	bltz	a0,80005d72 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80005cb4:	10000613          	li	a2,256
    80005cb8:	4581                	li	a1,0
    80005cba:	e5040513          	add	a0,s0,-432
    80005cbe:	ffffb097          	auipc	ra,0xffffb
    80005cc2:	03a080e7          	jalr	58(ra) # 80000cf8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005cc6:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005cca:	89a6                	mv	s3,s1
    80005ccc:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005cce:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005cd2:	00391513          	sll	a0,s2,0x3
    80005cd6:	e4040593          	add	a1,s0,-448
    80005cda:	e4843783          	ld	a5,-440(s0)
    80005cde:	953e                	add	a0,a0,a5
    80005ce0:	ffffd097          	auipc	ra,0xffffd
    80005ce4:	fe2080e7          	jalr	-30(ra) # 80002cc2 <fetchaddr>
    80005ce8:	02054a63          	bltz	a0,80005d1c <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80005cec:	e4043783          	ld	a5,-448(s0)
    80005cf0:	c3b9                	beqz	a5,80005d36 <sys_exec+0xbc>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005cf2:	ffffb097          	auipc	ra,0xffffb
    80005cf6:	e1a080e7          	jalr	-486(ra) # 80000b0c <kalloc>
    80005cfa:	85aa                	mv	a1,a0
    80005cfc:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005d00:	cd11                	beqz	a0,80005d1c <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005d02:	6605                	lui	a2,0x1
    80005d04:	e4043503          	ld	a0,-448(s0)
    80005d08:	ffffd097          	auipc	ra,0xffffd
    80005d0c:	00c080e7          	jalr	12(ra) # 80002d14 <fetchstr>
    80005d10:	00054663          	bltz	a0,80005d1c <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80005d14:	0905                	add	s2,s2,1
    80005d16:	09a1                	add	s3,s3,8
    80005d18:	fb491de3          	bne	s2,s4,80005cd2 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d1c:	f5040913          	add	s2,s0,-176
    80005d20:	6088                	ld	a0,0(s1)
    80005d22:	c539                	beqz	a0,80005d70 <sys_exec+0xf6>
    kfree(argv[i]);
    80005d24:	ffffb097          	auipc	ra,0xffffb
    80005d28:	cea080e7          	jalr	-790(ra) # 80000a0e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d2c:	04a1                	add	s1,s1,8
    80005d2e:	ff2499e3          	bne	s1,s2,80005d20 <sys_exec+0xa6>
  return -1;
    80005d32:	597d                	li	s2,-1
    80005d34:	a83d                	j	80005d72 <sys_exec+0xf8>
      argv[i] = 0;
    80005d36:	0009079b          	sext.w	a5,s2
    80005d3a:	078e                	sll	a5,a5,0x3
    80005d3c:	fd078793          	add	a5,a5,-48
    80005d40:	97a2                	add	a5,a5,s0
    80005d42:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005d46:	e5040593          	add	a1,s0,-432
    80005d4a:	f5040513          	add	a0,s0,-176
    80005d4e:	fffff097          	auipc	ra,0xfffff
    80005d52:	114080e7          	jalr	276(ra) # 80004e62 <exec>
    80005d56:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d58:	f5040993          	add	s3,s0,-176
    80005d5c:	6088                	ld	a0,0(s1)
    80005d5e:	c911                	beqz	a0,80005d72 <sys_exec+0xf8>
    kfree(argv[i]);
    80005d60:	ffffb097          	auipc	ra,0xffffb
    80005d64:	cae080e7          	jalr	-850(ra) # 80000a0e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d68:	04a1                	add	s1,s1,8
    80005d6a:	ff3499e3          	bne	s1,s3,80005d5c <sys_exec+0xe2>
    80005d6e:	a011                	j	80005d72 <sys_exec+0xf8>
  return -1;
    80005d70:	597d                	li	s2,-1
}
    80005d72:	854a                	mv	a0,s2
    80005d74:	70fa                	ld	ra,440(sp)
    80005d76:	745a                	ld	s0,432(sp)
    80005d78:	74ba                	ld	s1,424(sp)
    80005d7a:	791a                	ld	s2,416(sp)
    80005d7c:	69fa                	ld	s3,408(sp)
    80005d7e:	6a5a                	ld	s4,400(sp)
    80005d80:	6139                	add	sp,sp,448
    80005d82:	8082                	ret

0000000080005d84 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005d84:	7139                	add	sp,sp,-64
    80005d86:	fc06                	sd	ra,56(sp)
    80005d88:	f822                	sd	s0,48(sp)
    80005d8a:	f426                	sd	s1,40(sp)
    80005d8c:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005d8e:	ffffc097          	auipc	ra,0xffffc
    80005d92:	d02080e7          	jalr	-766(ra) # 80001a90 <myproc>
    80005d96:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005d98:	fd840593          	add	a1,s0,-40
    80005d9c:	4501                	li	a0,0
    80005d9e:	ffffd097          	auipc	ra,0xffffd
    80005da2:	fe0080e7          	jalr	-32(ra) # 80002d7e <argaddr>
    return -1;
    80005da6:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005da8:	0e054063          	bltz	a0,80005e88 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005dac:	fc840593          	add	a1,s0,-56
    80005db0:	fd040513          	add	a0,s0,-48
    80005db4:	fffff097          	auipc	ra,0xfffff
    80005db8:	d82080e7          	jalr	-638(ra) # 80004b36 <pipealloc>
    return -1;
    80005dbc:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005dbe:	0c054563          	bltz	a0,80005e88 <sys_pipe+0x104>
  fd0 = -1;
    80005dc2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005dc6:	fd043503          	ld	a0,-48(s0)
    80005dca:	fffff097          	auipc	ra,0xfffff
    80005dce:	510080e7          	jalr	1296(ra) # 800052da <fdalloc>
    80005dd2:	fca42223          	sw	a0,-60(s0)
    80005dd6:	08054c63          	bltz	a0,80005e6e <sys_pipe+0xea>
    80005dda:	fc843503          	ld	a0,-56(s0)
    80005dde:	fffff097          	auipc	ra,0xfffff
    80005de2:	4fc080e7          	jalr	1276(ra) # 800052da <fdalloc>
    80005de6:	fca42023          	sw	a0,-64(s0)
    80005dea:	06054963          	bltz	a0,80005e5c <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005dee:	4691                	li	a3,4
    80005df0:	fc440613          	add	a2,s0,-60
    80005df4:	fd843583          	ld	a1,-40(s0)
    80005df8:	68a8                	ld	a0,80(s1)
    80005dfa:	ffffc097          	auipc	ra,0xffffc
    80005dfe:	900080e7          	jalr	-1792(ra) # 800016fa <copyout>
    80005e02:	02054063          	bltz	a0,80005e22 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005e06:	4691                	li	a3,4
    80005e08:	fc040613          	add	a2,s0,-64
    80005e0c:	fd843583          	ld	a1,-40(s0)
    80005e10:	0591                	add	a1,a1,4
    80005e12:	68a8                	ld	a0,80(s1)
    80005e14:	ffffc097          	auipc	ra,0xffffc
    80005e18:	8e6080e7          	jalr	-1818(ra) # 800016fa <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005e1c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005e1e:	06055563          	bgez	a0,80005e88 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005e22:	fc442783          	lw	a5,-60(s0)
    80005e26:	07e9                	add	a5,a5,26
    80005e28:	078e                	sll	a5,a5,0x3
    80005e2a:	97a6                	add	a5,a5,s1
    80005e2c:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005e30:	fc042783          	lw	a5,-64(s0)
    80005e34:	07e9                	add	a5,a5,26
    80005e36:	078e                	sll	a5,a5,0x3
    80005e38:	00f48533          	add	a0,s1,a5
    80005e3c:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005e40:	fd043503          	ld	a0,-48(s0)
    80005e44:	fffff097          	auipc	ra,0xfffff
    80005e48:	99c080e7          	jalr	-1636(ra) # 800047e0 <fileclose>
    fileclose(wf);
    80005e4c:	fc843503          	ld	a0,-56(s0)
    80005e50:	fffff097          	auipc	ra,0xfffff
    80005e54:	990080e7          	jalr	-1648(ra) # 800047e0 <fileclose>
    return -1;
    80005e58:	57fd                	li	a5,-1
    80005e5a:	a03d                	j	80005e88 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005e5c:	fc442783          	lw	a5,-60(s0)
    80005e60:	0007c763          	bltz	a5,80005e6e <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005e64:	07e9                	add	a5,a5,26
    80005e66:	078e                	sll	a5,a5,0x3
    80005e68:	97a6                	add	a5,a5,s1
    80005e6a:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80005e6e:	fd043503          	ld	a0,-48(s0)
    80005e72:	fffff097          	auipc	ra,0xfffff
    80005e76:	96e080e7          	jalr	-1682(ra) # 800047e0 <fileclose>
    fileclose(wf);
    80005e7a:	fc843503          	ld	a0,-56(s0)
    80005e7e:	fffff097          	auipc	ra,0xfffff
    80005e82:	962080e7          	jalr	-1694(ra) # 800047e0 <fileclose>
    return -1;
    80005e86:	57fd                	li	a5,-1
}
    80005e88:	853e                	mv	a0,a5
    80005e8a:	70e2                	ld	ra,56(sp)
    80005e8c:	7442                	ld	s0,48(sp)
    80005e8e:	74a2                	ld	s1,40(sp)
    80005e90:	6121                	add	sp,sp,64
    80005e92:	8082                	ret
	...

0000000080005ea0 <kernelvec>:
    80005ea0:	7111                	add	sp,sp,-256
    80005ea2:	e006                	sd	ra,0(sp)
    80005ea4:	e40a                	sd	sp,8(sp)
    80005ea6:	e80e                	sd	gp,16(sp)
    80005ea8:	ec12                	sd	tp,24(sp)
    80005eaa:	f016                	sd	t0,32(sp)
    80005eac:	f41a                	sd	t1,40(sp)
    80005eae:	f81e                	sd	t2,48(sp)
    80005eb0:	fc22                	sd	s0,56(sp)
    80005eb2:	e0a6                	sd	s1,64(sp)
    80005eb4:	e4aa                	sd	a0,72(sp)
    80005eb6:	e8ae                	sd	a1,80(sp)
    80005eb8:	ecb2                	sd	a2,88(sp)
    80005eba:	f0b6                	sd	a3,96(sp)
    80005ebc:	f4ba                	sd	a4,104(sp)
    80005ebe:	f8be                	sd	a5,112(sp)
    80005ec0:	fcc2                	sd	a6,120(sp)
    80005ec2:	e146                	sd	a7,128(sp)
    80005ec4:	e54a                	sd	s2,136(sp)
    80005ec6:	e94e                	sd	s3,144(sp)
    80005ec8:	ed52                	sd	s4,152(sp)
    80005eca:	f156                	sd	s5,160(sp)
    80005ecc:	f55a                	sd	s6,168(sp)
    80005ece:	f95e                	sd	s7,176(sp)
    80005ed0:	fd62                	sd	s8,184(sp)
    80005ed2:	e1e6                	sd	s9,192(sp)
    80005ed4:	e5ea                	sd	s10,200(sp)
    80005ed6:	e9ee                	sd	s11,208(sp)
    80005ed8:	edf2                	sd	t3,216(sp)
    80005eda:	f1f6                	sd	t4,224(sp)
    80005edc:	f5fa                	sd	t5,232(sp)
    80005ede:	f9fe                	sd	t6,240(sp)
    80005ee0:	caffc0ef          	jal	80002b8e <kerneltrap>
    80005ee4:	6082                	ld	ra,0(sp)
    80005ee6:	6122                	ld	sp,8(sp)
    80005ee8:	61c2                	ld	gp,16(sp)
    80005eea:	7282                	ld	t0,32(sp)
    80005eec:	7322                	ld	t1,40(sp)
    80005eee:	73c2                	ld	t2,48(sp)
    80005ef0:	7462                	ld	s0,56(sp)
    80005ef2:	6486                	ld	s1,64(sp)
    80005ef4:	6526                	ld	a0,72(sp)
    80005ef6:	65c6                	ld	a1,80(sp)
    80005ef8:	6666                	ld	a2,88(sp)
    80005efa:	7686                	ld	a3,96(sp)
    80005efc:	7726                	ld	a4,104(sp)
    80005efe:	77c6                	ld	a5,112(sp)
    80005f00:	7866                	ld	a6,120(sp)
    80005f02:	688a                	ld	a7,128(sp)
    80005f04:	692a                	ld	s2,136(sp)
    80005f06:	69ca                	ld	s3,144(sp)
    80005f08:	6a6a                	ld	s4,152(sp)
    80005f0a:	7a8a                	ld	s5,160(sp)
    80005f0c:	7b2a                	ld	s6,168(sp)
    80005f0e:	7bca                	ld	s7,176(sp)
    80005f10:	7c6a                	ld	s8,184(sp)
    80005f12:	6c8e                	ld	s9,192(sp)
    80005f14:	6d2e                	ld	s10,200(sp)
    80005f16:	6dce                	ld	s11,208(sp)
    80005f18:	6e6e                	ld	t3,216(sp)
    80005f1a:	7e8e                	ld	t4,224(sp)
    80005f1c:	7f2e                	ld	t5,232(sp)
    80005f1e:	7fce                	ld	t6,240(sp)
    80005f20:	6111                	add	sp,sp,256
    80005f22:	10200073          	sret
    80005f26:	00000013          	nop
    80005f2a:	00000013          	nop
    80005f2e:	0001                	nop

0000000080005f30 <timervec>:
    80005f30:	34051573          	csrrw	a0,mscratch,a0
    80005f34:	e10c                	sd	a1,0(a0)
    80005f36:	e510                	sd	a2,8(a0)
    80005f38:	e914                	sd	a3,16(a0)
    80005f3a:	710c                	ld	a1,32(a0)
    80005f3c:	7510                	ld	a2,40(a0)
    80005f3e:	6194                	ld	a3,0(a1)
    80005f40:	96b2                	add	a3,a3,a2
    80005f42:	e194                	sd	a3,0(a1)
    80005f44:	4589                	li	a1,2
    80005f46:	14459073          	csrw	sip,a1
    80005f4a:	6914                	ld	a3,16(a0)
    80005f4c:	6510                	ld	a2,8(a0)
    80005f4e:	610c                	ld	a1,0(a0)
    80005f50:	34051573          	csrrw	a0,mscratch,a0
    80005f54:	30200073          	mret
	...

0000000080005f5a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005f5a:	1141                	add	sp,sp,-16
    80005f5c:	e422                	sd	s0,8(sp)
    80005f5e:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005f60:	0c0007b7          	lui	a5,0xc000
    80005f64:	4705                	li	a4,1
    80005f66:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005f68:	c3d8                	sw	a4,4(a5)
}
    80005f6a:	6422                	ld	s0,8(sp)
    80005f6c:	0141                	add	sp,sp,16
    80005f6e:	8082                	ret

0000000080005f70 <plicinithart>:

void
plicinithart(void)
{
    80005f70:	1141                	add	sp,sp,-16
    80005f72:	e406                	sd	ra,8(sp)
    80005f74:	e022                	sd	s0,0(sp)
    80005f76:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005f78:	ffffc097          	auipc	ra,0xffffc
    80005f7c:	aec080e7          	jalr	-1300(ra) # 80001a64 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005f80:	0085171b          	sllw	a4,a0,0x8
    80005f84:	0c0027b7          	lui	a5,0xc002
    80005f88:	97ba                	add	a5,a5,a4
    80005f8a:	40200713          	li	a4,1026
    80005f8e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005f92:	00d5151b          	sllw	a0,a0,0xd
    80005f96:	0c2017b7          	lui	a5,0xc201
    80005f9a:	97aa                	add	a5,a5,a0
    80005f9c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005fa0:	60a2                	ld	ra,8(sp)
    80005fa2:	6402                	ld	s0,0(sp)
    80005fa4:	0141                	add	sp,sp,16
    80005fa6:	8082                	ret

0000000080005fa8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005fa8:	1141                	add	sp,sp,-16
    80005faa:	e406                	sd	ra,8(sp)
    80005fac:	e022                	sd	s0,0(sp)
    80005fae:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005fb0:	ffffc097          	auipc	ra,0xffffc
    80005fb4:	ab4080e7          	jalr	-1356(ra) # 80001a64 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005fb8:	00d5151b          	sllw	a0,a0,0xd
    80005fbc:	0c2017b7          	lui	a5,0xc201
    80005fc0:	97aa                	add	a5,a5,a0
  return irq;
}
    80005fc2:	43c8                	lw	a0,4(a5)
    80005fc4:	60a2                	ld	ra,8(sp)
    80005fc6:	6402                	ld	s0,0(sp)
    80005fc8:	0141                	add	sp,sp,16
    80005fca:	8082                	ret

0000000080005fcc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005fcc:	1101                	add	sp,sp,-32
    80005fce:	ec06                	sd	ra,24(sp)
    80005fd0:	e822                	sd	s0,16(sp)
    80005fd2:	e426                	sd	s1,8(sp)
    80005fd4:	1000                	add	s0,sp,32
    80005fd6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005fd8:	ffffc097          	auipc	ra,0xffffc
    80005fdc:	a8c080e7          	jalr	-1396(ra) # 80001a64 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005fe0:	00d5151b          	sllw	a0,a0,0xd
    80005fe4:	0c2017b7          	lui	a5,0xc201
    80005fe8:	97aa                	add	a5,a5,a0
    80005fea:	c3c4                	sw	s1,4(a5)
}
    80005fec:	60e2                	ld	ra,24(sp)
    80005fee:	6442                	ld	s0,16(sp)
    80005ff0:	64a2                	ld	s1,8(sp)
    80005ff2:	6105                	add	sp,sp,32
    80005ff4:	8082                	ret

0000000080005ff6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005ff6:	1141                	add	sp,sp,-16
    80005ff8:	e406                	sd	ra,8(sp)
    80005ffa:	e022                	sd	s0,0(sp)
    80005ffc:	0800                	add	s0,sp,16
  if(i >= NUM)
    80005ffe:	479d                	li	a5,7
    80006000:	04a7cb63          	blt	a5,a0,80006056 <free_desc+0x60>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80006004:	0001d717          	auipc	a4,0x1d
    80006008:	ffc70713          	add	a4,a4,-4 # 80023000 <disk>
    8000600c:	972a                	add	a4,a4,a0
    8000600e:	6789                	lui	a5,0x2
    80006010:	97ba                	add	a5,a5,a4
    80006012:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80006016:	eba1                	bnez	a5,80006066 <free_desc+0x70>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    80006018:	00451713          	sll	a4,a0,0x4
    8000601c:	0001f797          	auipc	a5,0x1f
    80006020:	fe47b783          	ld	a5,-28(a5) # 80025000 <disk+0x2000>
    80006024:	97ba                	add	a5,a5,a4
    80006026:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    8000602a:	0001d717          	auipc	a4,0x1d
    8000602e:	fd670713          	add	a4,a4,-42 # 80023000 <disk>
    80006032:	972a                	add	a4,a4,a0
    80006034:	6789                	lui	a5,0x2
    80006036:	97ba                	add	a5,a5,a4
    80006038:	4705                	li	a4,1
    8000603a:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000603e:	0001f517          	auipc	a0,0x1f
    80006042:	fda50513          	add	a0,a0,-38 # 80025018 <disk+0x2018>
    80006046:	ffffc097          	auipc	ra,0xffffc
    8000604a:	5ea080e7          	jalr	1514(ra) # 80002630 <wakeup>
}
    8000604e:	60a2                	ld	ra,8(sp)
    80006050:	6402                	ld	s0,0(sp)
    80006052:	0141                	add	sp,sp,16
    80006054:	8082                	ret
    panic("virtio_disk_intr 1");
    80006056:	00002517          	auipc	a0,0x2
    8000605a:	73a50513          	add	a0,a0,1850 # 80008790 <syscalls+0x330>
    8000605e:	ffffa097          	auipc	ra,0xffffa
    80006062:	4e4080e7          	jalr	1252(ra) # 80000542 <panic>
    panic("virtio_disk_intr 2");
    80006066:	00002517          	auipc	a0,0x2
    8000606a:	74250513          	add	a0,a0,1858 # 800087a8 <syscalls+0x348>
    8000606e:	ffffa097          	auipc	ra,0xffffa
    80006072:	4d4080e7          	jalr	1236(ra) # 80000542 <panic>

0000000080006076 <virtio_disk_init>:
{
    80006076:	1101                	add	sp,sp,-32
    80006078:	ec06                	sd	ra,24(sp)
    8000607a:	e822                	sd	s0,16(sp)
    8000607c:	e426                	sd	s1,8(sp)
    8000607e:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006080:	00002597          	auipc	a1,0x2
    80006084:	74058593          	add	a1,a1,1856 # 800087c0 <syscalls+0x360>
    80006088:	0001f517          	auipc	a0,0x1f
    8000608c:	02050513          	add	a0,a0,32 # 800250a8 <disk+0x20a8>
    80006090:	ffffb097          	auipc	ra,0xffffb
    80006094:	adc080e7          	jalr	-1316(ra) # 80000b6c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006098:	100017b7          	lui	a5,0x10001
    8000609c:	4398                	lw	a4,0(a5)
    8000609e:	2701                	sext.w	a4,a4
    800060a0:	747277b7          	lui	a5,0x74727
    800060a4:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800060a8:	0ef71063          	bne	a4,a5,80006188 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800060ac:	100017b7          	lui	a5,0x10001
    800060b0:	43dc                	lw	a5,4(a5)
    800060b2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800060b4:	4705                	li	a4,1
    800060b6:	0ce79963          	bne	a5,a4,80006188 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800060ba:	100017b7          	lui	a5,0x10001
    800060be:	479c                	lw	a5,8(a5)
    800060c0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800060c2:	4709                	li	a4,2
    800060c4:	0ce79263          	bne	a5,a4,80006188 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800060c8:	100017b7          	lui	a5,0x10001
    800060cc:	47d8                	lw	a4,12(a5)
    800060ce:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800060d0:	554d47b7          	lui	a5,0x554d4
    800060d4:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800060d8:	0af71863          	bne	a4,a5,80006188 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    800060dc:	100017b7          	lui	a5,0x10001
    800060e0:	4705                	li	a4,1
    800060e2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800060e4:	470d                	li	a4,3
    800060e6:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800060e8:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800060ea:	c7ffe6b7          	lui	a3,0xc7ffe
    800060ee:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd773f>
    800060f2:	8f75                	and	a4,a4,a3
    800060f4:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800060f6:	472d                	li	a4,11
    800060f8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800060fa:	473d                	li	a4,15
    800060fc:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800060fe:	6705                	lui	a4,0x1
    80006100:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006102:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006106:	5bdc                	lw	a5,52(a5)
    80006108:	2781                	sext.w	a5,a5
  if(max == 0)
    8000610a:	c7d9                	beqz	a5,80006198 <virtio_disk_init+0x122>
  if(max < NUM)
    8000610c:	471d                	li	a4,7
    8000610e:	08f77d63          	bgeu	a4,a5,800061a8 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006112:	100014b7          	lui	s1,0x10001
    80006116:	47a1                	li	a5,8
    80006118:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    8000611a:	6609                	lui	a2,0x2
    8000611c:	4581                	li	a1,0
    8000611e:	0001d517          	auipc	a0,0x1d
    80006122:	ee250513          	add	a0,a0,-286 # 80023000 <disk>
    80006126:	ffffb097          	auipc	ra,0xffffb
    8000612a:	bd2080e7          	jalr	-1070(ra) # 80000cf8 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000612e:	0001d717          	auipc	a4,0x1d
    80006132:	ed270713          	add	a4,a4,-302 # 80023000 <disk>
    80006136:	00c75793          	srl	a5,a4,0xc
    8000613a:	2781                	sext.w	a5,a5
    8000613c:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    8000613e:	0001f797          	auipc	a5,0x1f
    80006142:	ec278793          	add	a5,a5,-318 # 80025000 <disk+0x2000>
    80006146:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    80006148:	0001d717          	auipc	a4,0x1d
    8000614c:	f3870713          	add	a4,a4,-200 # 80023080 <disk+0x80>
    80006150:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    80006152:	0001e717          	auipc	a4,0x1e
    80006156:	eae70713          	add	a4,a4,-338 # 80024000 <disk+0x1000>
    8000615a:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000615c:	4705                	li	a4,1
    8000615e:	00e78c23          	sb	a4,24(a5)
    80006162:	00e78ca3          	sb	a4,25(a5)
    80006166:	00e78d23          	sb	a4,26(a5)
    8000616a:	00e78da3          	sb	a4,27(a5)
    8000616e:	00e78e23          	sb	a4,28(a5)
    80006172:	00e78ea3          	sb	a4,29(a5)
    80006176:	00e78f23          	sb	a4,30(a5)
    8000617a:	00e78fa3          	sb	a4,31(a5)
}
    8000617e:	60e2                	ld	ra,24(sp)
    80006180:	6442                	ld	s0,16(sp)
    80006182:	64a2                	ld	s1,8(sp)
    80006184:	6105                	add	sp,sp,32
    80006186:	8082                	ret
    panic("could not find virtio disk");
    80006188:	00002517          	auipc	a0,0x2
    8000618c:	64850513          	add	a0,a0,1608 # 800087d0 <syscalls+0x370>
    80006190:	ffffa097          	auipc	ra,0xffffa
    80006194:	3b2080e7          	jalr	946(ra) # 80000542 <panic>
    panic("virtio disk has no queue 0");
    80006198:	00002517          	auipc	a0,0x2
    8000619c:	65850513          	add	a0,a0,1624 # 800087f0 <syscalls+0x390>
    800061a0:	ffffa097          	auipc	ra,0xffffa
    800061a4:	3a2080e7          	jalr	930(ra) # 80000542 <panic>
    panic("virtio disk max queue too short");
    800061a8:	00002517          	auipc	a0,0x2
    800061ac:	66850513          	add	a0,a0,1640 # 80008810 <syscalls+0x3b0>
    800061b0:	ffffa097          	auipc	ra,0xffffa
    800061b4:	392080e7          	jalr	914(ra) # 80000542 <panic>

00000000800061b8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800061b8:	7119                	add	sp,sp,-128
    800061ba:	fc86                	sd	ra,120(sp)
    800061bc:	f8a2                	sd	s0,112(sp)
    800061be:	f4a6                	sd	s1,104(sp)
    800061c0:	f0ca                	sd	s2,96(sp)
    800061c2:	ecce                	sd	s3,88(sp)
    800061c4:	e8d2                	sd	s4,80(sp)
    800061c6:	e4d6                	sd	s5,72(sp)
    800061c8:	e0da                	sd	s6,64(sp)
    800061ca:	fc5e                	sd	s7,56(sp)
    800061cc:	f862                	sd	s8,48(sp)
    800061ce:	f466                	sd	s9,40(sp)
    800061d0:	f06a                	sd	s10,32(sp)
    800061d2:	0100                	add	s0,sp,128
    800061d4:	8a2a                	mv	s4,a0
    800061d6:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800061d8:	00c52c03          	lw	s8,12(a0)
    800061dc:	001c1c1b          	sllw	s8,s8,0x1
    800061e0:	1c02                	sll	s8,s8,0x20
    800061e2:	020c5c13          	srl	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    800061e6:	0001f517          	auipc	a0,0x1f
    800061ea:	ec250513          	add	a0,a0,-318 # 800250a8 <disk+0x20a8>
    800061ee:	ffffb097          	auipc	ra,0xffffb
    800061f2:	a0e080e7          	jalr	-1522(ra) # 80000bfc <acquire>
  for(int i = 0; i < 3; i++){
    800061f6:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    800061f8:	44a1                	li	s1,8
      disk.free[i] = 0;
    800061fa:	0001db97          	auipc	s7,0x1d
    800061fe:	e06b8b93          	add	s7,s7,-506 # 80023000 <disk>
    80006202:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80006204:	4a8d                	li	s5,3
    80006206:	a0b5                	j	80006272 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80006208:	00fb8733          	add	a4,s7,a5
    8000620c:	975a                	add	a4,a4,s6
    8000620e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006212:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80006214:	0207c563          	bltz	a5,8000623e <virtio_disk_rw+0x86>
  for(int i = 0; i < 3; i++){
    80006218:	2605                	addw	a2,a2,1 # 2001 <_entry-0x7fffdfff>
    8000621a:	0591                	add	a1,a1,4
    8000621c:	19560c63          	beq	a2,s5,800063b4 <virtio_disk_rw+0x1fc>
    idx[i] = alloc_desc();
    80006220:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80006222:	0001f717          	auipc	a4,0x1f
    80006226:	df670713          	add	a4,a4,-522 # 80025018 <disk+0x2018>
    8000622a:	87ca                	mv	a5,s2
    if(disk.free[i]){
    8000622c:	00074683          	lbu	a3,0(a4)
    80006230:	fee1                	bnez	a3,80006208 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80006232:	2785                	addw	a5,a5,1
    80006234:	0705                	add	a4,a4,1
    80006236:	fe979be3          	bne	a5,s1,8000622c <virtio_disk_rw+0x74>
    idx[i] = alloc_desc();
    8000623a:	57fd                	li	a5,-1
    8000623c:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    8000623e:	00c05e63          	blez	a2,8000625a <virtio_disk_rw+0xa2>
    80006242:	060a                	sll	a2,a2,0x2
    80006244:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80006248:	0009a503          	lw	a0,0(s3)
    8000624c:	00000097          	auipc	ra,0x0
    80006250:	daa080e7          	jalr	-598(ra) # 80005ff6 <free_desc>
      for(int j = 0; j < i; j++)
    80006254:	0991                	add	s3,s3,4
    80006256:	ffa999e3          	bne	s3,s10,80006248 <virtio_disk_rw+0x90>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000625a:	0001f597          	auipc	a1,0x1f
    8000625e:	e4e58593          	add	a1,a1,-434 # 800250a8 <disk+0x20a8>
    80006262:	0001f517          	auipc	a0,0x1f
    80006266:	db650513          	add	a0,a0,-586 # 80025018 <disk+0x2018>
    8000626a:	ffffc097          	auipc	ra,0xffffc
    8000626e:	246080e7          	jalr	582(ra) # 800024b0 <sleep>
  for(int i = 0; i < 3; i++){
    80006272:	f9040993          	add	s3,s0,-112
{
    80006276:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80006278:	864a                	mv	a2,s2
    8000627a:	b75d                	j	80006220 <virtio_disk_rw+0x68>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000627c:	0001f717          	auipc	a4,0x1f
    80006280:	d8473703          	ld	a4,-636(a4) # 80025000 <disk+0x2000>
    80006284:	973e                	add	a4,a4,a5
    80006286:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000628a:	0001d517          	auipc	a0,0x1d
    8000628e:	d7650513          	add	a0,a0,-650 # 80023000 <disk>
    80006292:	0001f717          	auipc	a4,0x1f
    80006296:	d6e70713          	add	a4,a4,-658 # 80025000 <disk+0x2000>
    8000629a:	6314                	ld	a3,0(a4)
    8000629c:	96be                	add	a3,a3,a5
    8000629e:	00c6d603          	lhu	a2,12(a3)
    800062a2:	00166613          	or	a2,a2,1
    800062a6:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800062aa:	f9842683          	lw	a3,-104(s0)
    800062ae:	6310                	ld	a2,0(a4)
    800062b0:	97b2                	add	a5,a5,a2
    800062b2:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
    800062b6:	20048613          	add	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    800062ba:	0612                	sll	a2,a2,0x4
    800062bc:	962a                	add	a2,a2,a0
    800062be:	02060823          	sb	zero,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800062c2:	00469793          	sll	a5,a3,0x4
    800062c6:	630c                	ld	a1,0(a4)
    800062c8:	95be                	add	a1,a1,a5
    800062ca:	6689                	lui	a3,0x2
    800062cc:	03068693          	add	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    800062d0:	96ca                	add	a3,a3,s2
    800062d2:	96aa                	add	a3,a3,a0
    800062d4:	e194                	sd	a3,0(a1)
  disk.desc[idx[2]].len = 1;
    800062d6:	6314                	ld	a3,0(a4)
    800062d8:	96be                	add	a3,a3,a5
    800062da:	4585                	li	a1,1
    800062dc:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800062de:	6314                	ld	a3,0(a4)
    800062e0:	96be                	add	a3,a3,a5
    800062e2:	4509                	li	a0,2
    800062e4:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    800062e8:	6314                	ld	a3,0(a4)
    800062ea:	97b6                	add	a5,a5,a3
    800062ec:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800062f0:	00ba2223          	sw	a1,4(s4) # 1004 <_entry-0x7fffeffc>
  disk.info[idx[0]].b = b;
    800062f4:	03463423          	sd	s4,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    800062f8:	6714                	ld	a3,8(a4)
    800062fa:	0026d783          	lhu	a5,2(a3)
    800062fe:	8b9d                	and	a5,a5,7
    80006300:	0789                	add	a5,a5,2
    80006302:	0786                	sll	a5,a5,0x1
    80006304:	96be                	add	a3,a3,a5
    80006306:	00969023          	sh	s1,0(a3)
  __sync_synchronize();
    8000630a:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    8000630e:	6718                	ld	a4,8(a4)
    80006310:	00275783          	lhu	a5,2(a4)
    80006314:	2785                	addw	a5,a5,1
    80006316:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000631a:	100017b7          	lui	a5,0x10001
    8000631e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006322:	004a2783          	lw	a5,4(s4)
    80006326:	02b79163          	bne	a5,a1,80006348 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    8000632a:	0001f917          	auipc	s2,0x1f
    8000632e:	d7e90913          	add	s2,s2,-642 # 800250a8 <disk+0x20a8>
  while(b->disk == 1) {
    80006332:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006334:	85ca                	mv	a1,s2
    80006336:	8552                	mv	a0,s4
    80006338:	ffffc097          	auipc	ra,0xffffc
    8000633c:	178080e7          	jalr	376(ra) # 800024b0 <sleep>
  while(b->disk == 1) {
    80006340:	004a2783          	lw	a5,4(s4)
    80006344:	fe9788e3          	beq	a5,s1,80006334 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80006348:	f9042483          	lw	s1,-112(s0)
    8000634c:	20048713          	add	a4,s1,512
    80006350:	0712                	sll	a4,a4,0x4
    80006352:	0001d797          	auipc	a5,0x1d
    80006356:	cae78793          	add	a5,a5,-850 # 80023000 <disk>
    8000635a:	97ba                	add	a5,a5,a4
    8000635c:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80006360:	0001f917          	auipc	s2,0x1f
    80006364:	ca090913          	add	s2,s2,-864 # 80025000 <disk+0x2000>
    80006368:	a019                	j	8000636e <virtio_disk_rw+0x1b6>
      i = disk.desc[i].next;
    8000636a:	00e7d483          	lhu	s1,14(a5)
    free_desc(i);
    8000636e:	8526                	mv	a0,s1
    80006370:	00000097          	auipc	ra,0x0
    80006374:	c86080e7          	jalr	-890(ra) # 80005ff6 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80006378:	0492                	sll	s1,s1,0x4
    8000637a:	00093783          	ld	a5,0(s2)
    8000637e:	97a6                	add	a5,a5,s1
    80006380:	00c7d703          	lhu	a4,12(a5)
    80006384:	8b05                	and	a4,a4,1
    80006386:	f375                	bnez	a4,8000636a <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006388:	0001f517          	auipc	a0,0x1f
    8000638c:	d2050513          	add	a0,a0,-736 # 800250a8 <disk+0x20a8>
    80006390:	ffffb097          	auipc	ra,0xffffb
    80006394:	920080e7          	jalr	-1760(ra) # 80000cb0 <release>
}
    80006398:	70e6                	ld	ra,120(sp)
    8000639a:	7446                	ld	s0,112(sp)
    8000639c:	74a6                	ld	s1,104(sp)
    8000639e:	7906                	ld	s2,96(sp)
    800063a0:	69e6                	ld	s3,88(sp)
    800063a2:	6a46                	ld	s4,80(sp)
    800063a4:	6aa6                	ld	s5,72(sp)
    800063a6:	6b06                	ld	s6,64(sp)
    800063a8:	7be2                	ld	s7,56(sp)
    800063aa:	7c42                	ld	s8,48(sp)
    800063ac:	7ca2                	ld	s9,40(sp)
    800063ae:	7d02                	ld	s10,32(sp)
    800063b0:	6109                	add	sp,sp,128
    800063b2:	8082                	ret
  if(write)
    800063b4:	019037b3          	snez	a5,s9
    800063b8:	f8f42023          	sw	a5,-128(s0)
  buf0.reserved = 0;
    800063bc:	f8042223          	sw	zero,-124(s0)
  buf0.sector = sector;
    800063c0:	f9843423          	sd	s8,-120(s0)
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    800063c4:	f9042483          	lw	s1,-112(s0)
    800063c8:	00449913          	sll	s2,s1,0x4
    800063cc:	0001f997          	auipc	s3,0x1f
    800063d0:	c3498993          	add	s3,s3,-972 # 80025000 <disk+0x2000>
    800063d4:	0009ba83          	ld	s5,0(s3)
    800063d8:	9aca                	add	s5,s5,s2
    800063da:	f8040513          	add	a0,s0,-128
    800063de:	ffffb097          	auipc	ra,0xffffb
    800063e2:	cf0080e7          	jalr	-784(ra) # 800010ce <kvmpa>
    800063e6:	00aab023          	sd	a0,0(s5)
  disk.desc[idx[0]].len = sizeof(buf0);
    800063ea:	0009b783          	ld	a5,0(s3)
    800063ee:	97ca                	add	a5,a5,s2
    800063f0:	4741                	li	a4,16
    800063f2:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800063f4:	0009b783          	ld	a5,0(s3)
    800063f8:	97ca                	add	a5,a5,s2
    800063fa:	4705                	li	a4,1
    800063fc:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80006400:	f9442783          	lw	a5,-108(s0)
    80006404:	0009b703          	ld	a4,0(s3)
    80006408:	974a                	add	a4,a4,s2
    8000640a:	00f71723          	sh	a5,14(a4)
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000640e:	0792                	sll	a5,a5,0x4
    80006410:	0009b703          	ld	a4,0(s3)
    80006414:	973e                	add	a4,a4,a5
    80006416:	058a0693          	add	a3,s4,88
    8000641a:	e314                	sd	a3,0(a4)
  disk.desc[idx[1]].len = BSIZE;
    8000641c:	0009b703          	ld	a4,0(s3)
    80006420:	973e                	add	a4,a4,a5
    80006422:	40000693          	li	a3,1024
    80006426:	c714                	sw	a3,8(a4)
  if(write)
    80006428:	e40c9ae3          	bnez	s9,8000627c <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000642c:	0001f717          	auipc	a4,0x1f
    80006430:	bd473703          	ld	a4,-1068(a4) # 80025000 <disk+0x2000>
    80006434:	973e                	add	a4,a4,a5
    80006436:	4689                	li	a3,2
    80006438:	00d71623          	sh	a3,12(a4)
    8000643c:	b5b9                	j	8000628a <virtio_disk_rw+0xd2>

000000008000643e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000643e:	1101                	add	sp,sp,-32
    80006440:	ec06                	sd	ra,24(sp)
    80006442:	e822                	sd	s0,16(sp)
    80006444:	e426                	sd	s1,8(sp)
    80006446:	e04a                	sd	s2,0(sp)
    80006448:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000644a:	0001f517          	auipc	a0,0x1f
    8000644e:	c5e50513          	add	a0,a0,-930 # 800250a8 <disk+0x20a8>
    80006452:	ffffa097          	auipc	ra,0xffffa
    80006456:	7aa080e7          	jalr	1962(ra) # 80000bfc <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    8000645a:	0001f717          	auipc	a4,0x1f
    8000645e:	ba670713          	add	a4,a4,-1114 # 80025000 <disk+0x2000>
    80006462:	02075783          	lhu	a5,32(a4)
    80006466:	6b18                	ld	a4,16(a4)
    80006468:	00275683          	lhu	a3,2(a4)
    8000646c:	8ebd                	xor	a3,a3,a5
    8000646e:	8a9d                	and	a3,a3,7
    80006470:	cab9                	beqz	a3,800064c6 <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    80006472:	0001d917          	auipc	s2,0x1d
    80006476:	b8e90913          	add	s2,s2,-1138 # 80023000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    8000647a:	0001f497          	auipc	s1,0x1f
    8000647e:	b8648493          	add	s1,s1,-1146 # 80025000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    80006482:	078e                	sll	a5,a5,0x3
    80006484:	973e                	add	a4,a4,a5
    80006486:	435c                	lw	a5,4(a4)
    if(disk.info[id].status != 0)
    80006488:	20078713          	add	a4,a5,512
    8000648c:	0712                	sll	a4,a4,0x4
    8000648e:	974a                	add	a4,a4,s2
    80006490:	03074703          	lbu	a4,48(a4)
    80006494:	ef21                	bnez	a4,800064ec <virtio_disk_intr+0xae>
    disk.info[id].b->disk = 0;   // disk is done with buf
    80006496:	20078793          	add	a5,a5,512
    8000649a:	0792                	sll	a5,a5,0x4
    8000649c:	97ca                	add	a5,a5,s2
    8000649e:	7798                	ld	a4,40(a5)
    800064a0:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    800064a4:	7788                	ld	a0,40(a5)
    800064a6:	ffffc097          	auipc	ra,0xffffc
    800064aa:	18a080e7          	jalr	394(ra) # 80002630 <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    800064ae:	0204d783          	lhu	a5,32(s1)
    800064b2:	2785                	addw	a5,a5,1
    800064b4:	8b9d                	and	a5,a5,7
    800064b6:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    800064ba:	6898                	ld	a4,16(s1)
    800064bc:	00275683          	lhu	a3,2(a4)
    800064c0:	8a9d                	and	a3,a3,7
    800064c2:	fcf690e3          	bne	a3,a5,80006482 <virtio_disk_intr+0x44>
  }
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800064c6:	10001737          	lui	a4,0x10001
    800064ca:	533c                	lw	a5,96(a4)
    800064cc:	8b8d                	and	a5,a5,3
    800064ce:	d37c                	sw	a5,100(a4)

  release(&disk.vdisk_lock);
    800064d0:	0001f517          	auipc	a0,0x1f
    800064d4:	bd850513          	add	a0,a0,-1064 # 800250a8 <disk+0x20a8>
    800064d8:	ffffa097          	auipc	ra,0xffffa
    800064dc:	7d8080e7          	jalr	2008(ra) # 80000cb0 <release>
}
    800064e0:	60e2                	ld	ra,24(sp)
    800064e2:	6442                	ld	s0,16(sp)
    800064e4:	64a2                	ld	s1,8(sp)
    800064e6:	6902                	ld	s2,0(sp)
    800064e8:	6105                	add	sp,sp,32
    800064ea:	8082                	ret
      panic("virtio_disk_intr status");
    800064ec:	00002517          	auipc	a0,0x2
    800064f0:	34450513          	add	a0,a0,836 # 80008830 <syscalls+0x3d0>
    800064f4:	ffffa097          	auipc	ra,0xffffa
    800064f8:	04e080e7          	jalr	78(ra) # 80000542 <panic>

00000000800064fc <statscopyin>:
  int ncopyin;
  int ncopyinstr;
} stats;

int
statscopyin(char *buf, int sz) {
    800064fc:	7179                	add	sp,sp,-48
    800064fe:	f406                	sd	ra,40(sp)
    80006500:	f022                	sd	s0,32(sp)
    80006502:	ec26                	sd	s1,24(sp)
    80006504:	e84a                	sd	s2,16(sp)
    80006506:	e44e                	sd	s3,8(sp)
    80006508:	e052                	sd	s4,0(sp)
    8000650a:	1800                	add	s0,sp,48
    8000650c:	892a                	mv	s2,a0
    8000650e:	89ae                	mv	s3,a1
  int n;
  n = snprintf(buf, sz, "copyin: %d\n", stats.ncopyin);
    80006510:	00003a17          	auipc	s4,0x3
    80006514:	b18a0a13          	add	s4,s4,-1256 # 80009028 <stats>
    80006518:	000a2683          	lw	a3,0(s4)
    8000651c:	00002617          	auipc	a2,0x2
    80006520:	32c60613          	add	a2,a2,812 # 80008848 <syscalls+0x3e8>
    80006524:	00000097          	auipc	ra,0x0
    80006528:	2c6080e7          	jalr	710(ra) # 800067ea <snprintf>
    8000652c:	84aa                	mv	s1,a0
  n += snprintf(buf+n, sz, "copyinstr: %d\n", stats.ncopyinstr);
    8000652e:	004a2683          	lw	a3,4(s4)
    80006532:	00002617          	auipc	a2,0x2
    80006536:	32660613          	add	a2,a2,806 # 80008858 <syscalls+0x3f8>
    8000653a:	85ce                	mv	a1,s3
    8000653c:	954a                	add	a0,a0,s2
    8000653e:	00000097          	auipc	ra,0x0
    80006542:	2ac080e7          	jalr	684(ra) # 800067ea <snprintf>
  return n;
}
    80006546:	9d25                	addw	a0,a0,s1
    80006548:	70a2                	ld	ra,40(sp)
    8000654a:	7402                	ld	s0,32(sp)
    8000654c:	64e2                	ld	s1,24(sp)
    8000654e:	6942                	ld	s2,16(sp)
    80006550:	69a2                	ld	s3,8(sp)
    80006552:	6a02                	ld	s4,0(sp)
    80006554:	6145                	add	sp,sp,48
    80006556:	8082                	ret

0000000080006558 <copyin_new>:
// Copy from user to kernel.
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int
copyin_new(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
    80006558:	7179                	add	sp,sp,-48
    8000655a:	f406                	sd	ra,40(sp)
    8000655c:	f022                	sd	s0,32(sp)
    8000655e:	ec26                	sd	s1,24(sp)
    80006560:	e84a                	sd	s2,16(sp)
    80006562:	e44e                	sd	s3,8(sp)
    80006564:	1800                	add	s0,sp,48
    80006566:	89ae                	mv	s3,a1
    80006568:	84b2                	mv	s1,a2
    8000656a:	8936                	mv	s2,a3
  struct proc *p = myproc();
    8000656c:	ffffb097          	auipc	ra,0xffffb
    80006570:	524080e7          	jalr	1316(ra) # 80001a90 <myproc>

  if (srcva >= p->sz || srcva+len >= p->sz || srcva+len < srcva)
    80006574:	653c                	ld	a5,72(a0)
    80006576:	02f4ff63          	bgeu	s1,a5,800065b4 <copyin_new+0x5c>
    8000657a:	01248733          	add	a4,s1,s2
    8000657e:	02f77d63          	bgeu	a4,a5,800065b8 <copyin_new+0x60>
    80006582:	02976d63          	bltu	a4,s1,800065bc <copyin_new+0x64>
    return -1;
  memmove((void *) dst, (void *)srcva, len);
    80006586:	0009061b          	sext.w	a2,s2
    8000658a:	85a6                	mv	a1,s1
    8000658c:	854e                	mv	a0,s3
    8000658e:	ffffa097          	auipc	ra,0xffffa
    80006592:	7c6080e7          	jalr	1990(ra) # 80000d54 <memmove>
  stats.ncopyin++;   // XXX lock
    80006596:	00003717          	auipc	a4,0x3
    8000659a:	a9270713          	add	a4,a4,-1390 # 80009028 <stats>
    8000659e:	431c                	lw	a5,0(a4)
    800065a0:	2785                	addw	a5,a5,1
    800065a2:	c31c                	sw	a5,0(a4)
  return 0;
    800065a4:	4501                	li	a0,0
}
    800065a6:	70a2                	ld	ra,40(sp)
    800065a8:	7402                	ld	s0,32(sp)
    800065aa:	64e2                	ld	s1,24(sp)
    800065ac:	6942                	ld	s2,16(sp)
    800065ae:	69a2                	ld	s3,8(sp)
    800065b0:	6145                	add	sp,sp,48
    800065b2:	8082                	ret
    return -1;
    800065b4:	557d                	li	a0,-1
    800065b6:	bfc5                	j	800065a6 <copyin_new+0x4e>
    800065b8:	557d                	li	a0,-1
    800065ba:	b7f5                	j	800065a6 <copyin_new+0x4e>
    800065bc:	557d                	li	a0,-1
    800065be:	b7e5                	j	800065a6 <copyin_new+0x4e>

00000000800065c0 <copyinstr_new>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr_new(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    800065c0:	7179                	add	sp,sp,-48
    800065c2:	f406                	sd	ra,40(sp)
    800065c4:	f022                	sd	s0,32(sp)
    800065c6:	ec26                	sd	s1,24(sp)
    800065c8:	e84a                	sd	s2,16(sp)
    800065ca:	e44e                	sd	s3,8(sp)
    800065cc:	1800                	add	s0,sp,48
    800065ce:	89ae                	mv	s3,a1
    800065d0:	8932                	mv	s2,a2
    800065d2:	84b6                	mv	s1,a3
  struct proc *p = myproc();
    800065d4:	ffffb097          	auipc	ra,0xffffb
    800065d8:	4bc080e7          	jalr	1212(ra) # 80001a90 <myproc>
  char *s = (char *) srcva;
  
  stats.ncopyinstr++;   // XXX lock
    800065dc:	00003717          	auipc	a4,0x3
    800065e0:	a4c70713          	add	a4,a4,-1460 # 80009028 <stats>
    800065e4:	435c                	lw	a5,4(a4)
    800065e6:	2785                	addw	a5,a5,1
    800065e8:	c35c                	sw	a5,4(a4)
  for(int i = 0; i < max && srcva + i < p->sz; i++){
    800065ea:	cc8d                	beqz	s1,80006624 <copyinstr_new+0x64>
    800065ec:	009906b3          	add	a3,s2,s1
    800065f0:	87ca                	mv	a5,s2
    800065f2:	6538                	ld	a4,72(a0)
    800065f4:	02e7f063          	bgeu	a5,a4,80006614 <copyinstr_new+0x54>
    dst[i] = s[i];
    800065f8:	0007c803          	lbu	a6,0(a5)
    800065fc:	41278733          	sub	a4,a5,s2
    80006600:	974e                	add	a4,a4,s3
    80006602:	01070023          	sb	a6,0(a4)
    if(s[i] == '\0')
    80006606:	02080163          	beqz	a6,80006628 <copyinstr_new+0x68>
  for(int i = 0; i < max && srcva + i < p->sz; i++){
    8000660a:	0785                	add	a5,a5,1
    8000660c:	fed793e3          	bne	a5,a3,800065f2 <copyinstr_new+0x32>
      return 0;
  }
  return -1;
    80006610:	557d                	li	a0,-1
    80006612:	a011                	j	80006616 <copyinstr_new+0x56>
    80006614:	557d                	li	a0,-1
}
    80006616:	70a2                	ld	ra,40(sp)
    80006618:	7402                	ld	s0,32(sp)
    8000661a:	64e2                	ld	s1,24(sp)
    8000661c:	6942                	ld	s2,16(sp)
    8000661e:	69a2                	ld	s3,8(sp)
    80006620:	6145                	add	sp,sp,48
    80006622:	8082                	ret
  return -1;
    80006624:	557d                	li	a0,-1
    80006626:	bfc5                	j	80006616 <copyinstr_new+0x56>
      return 0;
    80006628:	4501                	li	a0,0
    8000662a:	b7f5                	j	80006616 <copyinstr_new+0x56>

000000008000662c <statswrite>:
int statscopyin(char*, int);
int statslock(char*, int);
  
int
statswrite(int user_src, uint64 src, int n)
{
    8000662c:	1141                	add	sp,sp,-16
    8000662e:	e422                	sd	s0,8(sp)
    80006630:	0800                	add	s0,sp,16
  return -1;
}
    80006632:	557d                	li	a0,-1
    80006634:	6422                	ld	s0,8(sp)
    80006636:	0141                	add	sp,sp,16
    80006638:	8082                	ret

000000008000663a <statsread>:

int
statsread(int user_dst, uint64 dst, int n)
{
    8000663a:	7179                	add	sp,sp,-48
    8000663c:	f406                	sd	ra,40(sp)
    8000663e:	f022                	sd	s0,32(sp)
    80006640:	ec26                	sd	s1,24(sp)
    80006642:	e84a                	sd	s2,16(sp)
    80006644:	e44e                	sd	s3,8(sp)
    80006646:	e052                	sd	s4,0(sp)
    80006648:	1800                	add	s0,sp,48
    8000664a:	892a                	mv	s2,a0
    8000664c:	89ae                	mv	s3,a1
    8000664e:	84b2                	mv	s1,a2
  int m;

  acquire(&stats.lock);
    80006650:	00020517          	auipc	a0,0x20
    80006654:	9b050513          	add	a0,a0,-1616 # 80026000 <stats>
    80006658:	ffffa097          	auipc	ra,0xffffa
    8000665c:	5a4080e7          	jalr	1444(ra) # 80000bfc <acquire>

  if(stats.sz == 0) {
    80006660:	00021797          	auipc	a5,0x21
    80006664:	9b87a783          	lw	a5,-1608(a5) # 80027018 <stats+0x1018>
    80006668:	cbb5                	beqz	a5,800066dc <statsread+0xa2>
#endif
#ifdef LAB_LOCK
    stats.sz = statslock(stats.buf, BUFSZ);
#endif
  }
  m = stats.sz - stats.off;
    8000666a:	00021797          	auipc	a5,0x21
    8000666e:	99678793          	add	a5,a5,-1642 # 80027000 <stats+0x1000>
    80006672:	4fd8                	lw	a4,28(a5)
    80006674:	4f9c                	lw	a5,24(a5)
    80006676:	9f99                	subw	a5,a5,a4
    80006678:	0007869b          	sext.w	a3,a5

  if (m > 0) {
    8000667c:	06d05e63          	blez	a3,800066f8 <statsread+0xbe>
    if(m > n)
    80006680:	8a3e                	mv	s4,a5
    80006682:	00d4d363          	bge	s1,a3,80006688 <statsread+0x4e>
    80006686:	8a26                	mv	s4,s1
    80006688:	000a049b          	sext.w	s1,s4
      m  = n;
    if(either_copyout(user_dst, dst, stats.buf+stats.off, m) != -1) {
    8000668c:	86a6                	mv	a3,s1
    8000668e:	00020617          	auipc	a2,0x20
    80006692:	98a60613          	add	a2,a2,-1654 # 80026018 <stats+0x18>
    80006696:	963a                	add	a2,a2,a4
    80006698:	85ce                	mv	a1,s3
    8000669a:	854a                	mv	a0,s2
    8000669c:	ffffc097          	auipc	ra,0xffffc
    800066a0:	06e080e7          	jalr	110(ra) # 8000270a <either_copyout>
    800066a4:	57fd                	li	a5,-1
    800066a6:	00f50a63          	beq	a0,a5,800066ba <statsread+0x80>
      stats.off += m;
    800066aa:	00021717          	auipc	a4,0x21
    800066ae:	95670713          	add	a4,a4,-1706 # 80027000 <stats+0x1000>
    800066b2:	4f5c                	lw	a5,28(a4)
    800066b4:	00fa07bb          	addw	a5,s4,a5
    800066b8:	cf5c                	sw	a5,28(a4)
  } else {
    m = -1;
    stats.sz = 0;
    stats.off = 0;
  }
  release(&stats.lock);
    800066ba:	00020517          	auipc	a0,0x20
    800066be:	94650513          	add	a0,a0,-1722 # 80026000 <stats>
    800066c2:	ffffa097          	auipc	ra,0xffffa
    800066c6:	5ee080e7          	jalr	1518(ra) # 80000cb0 <release>
  return m;
}
    800066ca:	8526                	mv	a0,s1
    800066cc:	70a2                	ld	ra,40(sp)
    800066ce:	7402                	ld	s0,32(sp)
    800066d0:	64e2                	ld	s1,24(sp)
    800066d2:	6942                	ld	s2,16(sp)
    800066d4:	69a2                	ld	s3,8(sp)
    800066d6:	6a02                	ld	s4,0(sp)
    800066d8:	6145                	add	sp,sp,48
    800066da:	8082                	ret
    stats.sz = statscopyin(stats.buf, BUFSZ);
    800066dc:	6585                	lui	a1,0x1
    800066de:	00020517          	auipc	a0,0x20
    800066e2:	93a50513          	add	a0,a0,-1734 # 80026018 <stats+0x18>
    800066e6:	00000097          	auipc	ra,0x0
    800066ea:	e16080e7          	jalr	-490(ra) # 800064fc <statscopyin>
    800066ee:	00021797          	auipc	a5,0x21
    800066f2:	92a7a523          	sw	a0,-1750(a5) # 80027018 <stats+0x1018>
    800066f6:	bf95                	j	8000666a <statsread+0x30>
    stats.sz = 0;
    800066f8:	00021797          	auipc	a5,0x21
    800066fc:	90878793          	add	a5,a5,-1784 # 80027000 <stats+0x1000>
    80006700:	0007ac23          	sw	zero,24(a5)
    stats.off = 0;
    80006704:	0007ae23          	sw	zero,28(a5)
    m = -1;
    80006708:	54fd                	li	s1,-1
    8000670a:	bf45                	j	800066ba <statsread+0x80>

000000008000670c <statsinit>:

void
statsinit(void)
{
    8000670c:	1141                	add	sp,sp,-16
    8000670e:	e406                	sd	ra,8(sp)
    80006710:	e022                	sd	s0,0(sp)
    80006712:	0800                	add	s0,sp,16
  initlock(&stats.lock, "stats");
    80006714:	00002597          	auipc	a1,0x2
    80006718:	15458593          	add	a1,a1,340 # 80008868 <syscalls+0x408>
    8000671c:	00020517          	auipc	a0,0x20
    80006720:	8e450513          	add	a0,a0,-1820 # 80026000 <stats>
    80006724:	ffffa097          	auipc	ra,0xffffa
    80006728:	448080e7          	jalr	1096(ra) # 80000b6c <initlock>

  devsw[STATS].read = statsread;
    8000672c:	0001b797          	auipc	a5,0x1b
    80006730:	48478793          	add	a5,a5,1156 # 80021bb0 <devsw>
    80006734:	00000717          	auipc	a4,0x0
    80006738:	f0670713          	add	a4,a4,-250 # 8000663a <statsread>
    8000673c:	f398                	sd	a4,32(a5)
  devsw[STATS].write = statswrite;
    8000673e:	00000717          	auipc	a4,0x0
    80006742:	eee70713          	add	a4,a4,-274 # 8000662c <statswrite>
    80006746:	f798                	sd	a4,40(a5)
}
    80006748:	60a2                	ld	ra,8(sp)
    8000674a:	6402                	ld	s0,0(sp)
    8000674c:	0141                	add	sp,sp,16
    8000674e:	8082                	ret

0000000080006750 <sprintint>:
  return 1;
}

static int
sprintint(char *s, int xx, int base, int sign)
{
    80006750:	1101                	add	sp,sp,-32
    80006752:	ec22                	sd	s0,24(sp)
    80006754:	1000                	add	s0,sp,32
    80006756:	882a                	mv	a6,a0
  char buf[16];
  int i, n;
  uint x;

  if(sign && (sign = xx < 0))
    80006758:	c299                	beqz	a3,8000675e <sprintint+0xe>
    8000675a:	0805c263          	bltz	a1,800067de <sprintint+0x8e>
    x = -xx;
  else
    x = xx;
    8000675e:	2581                	sext.w	a1,a1
    80006760:	4301                	li	t1,0

  i = 0;
    80006762:	fe040713          	add	a4,s0,-32
    80006766:	4501                	li	a0,0
  do {
    buf[i++] = digits[x % base];
    80006768:	2601                	sext.w	a2,a2
    8000676a:	00002697          	auipc	a3,0x2
    8000676e:	10668693          	add	a3,a3,262 # 80008870 <digits>
    80006772:	88aa                	mv	a7,a0
    80006774:	2505                	addw	a0,a0,1
    80006776:	02c5f7bb          	remuw	a5,a1,a2
    8000677a:	1782                	sll	a5,a5,0x20
    8000677c:	9381                	srl	a5,a5,0x20
    8000677e:	97b6                	add	a5,a5,a3
    80006780:	0007c783          	lbu	a5,0(a5)
    80006784:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    80006788:	0005879b          	sext.w	a5,a1
    8000678c:	02c5d5bb          	divuw	a1,a1,a2
    80006790:	0705                	add	a4,a4,1
    80006792:	fec7f0e3          	bgeu	a5,a2,80006772 <sprintint+0x22>

  if(sign)
    80006796:	00030b63          	beqz	t1,800067ac <sprintint+0x5c>
    buf[i++] = '-';
    8000679a:	ff050793          	add	a5,a0,-16
    8000679e:	97a2                	add	a5,a5,s0
    800067a0:	02d00713          	li	a4,45
    800067a4:	fee78823          	sb	a4,-16(a5)
    800067a8:	0028851b          	addw	a0,a7,2

  n = 0;
  while(--i >= 0)
    800067ac:	02a05d63          	blez	a0,800067e6 <sprintint+0x96>
    800067b0:	fe040793          	add	a5,s0,-32
    800067b4:	00a78733          	add	a4,a5,a0
    800067b8:	87c2                	mv	a5,a6
    800067ba:	00180613          	add	a2,a6,1
    800067be:	fff5069b          	addw	a3,a0,-1
    800067c2:	1682                	sll	a3,a3,0x20
    800067c4:	9281                	srl	a3,a3,0x20
    800067c6:	9636                	add	a2,a2,a3
  *s = c;
    800067c8:	fff74683          	lbu	a3,-1(a4)
    800067cc:	00d78023          	sb	a3,0(a5)
  while(--i >= 0)
    800067d0:	177d                	add	a4,a4,-1
    800067d2:	0785                	add	a5,a5,1
    800067d4:	fec79ae3          	bne	a5,a2,800067c8 <sprintint+0x78>
    n += sputc(s+n, buf[i]);
  return n;
}
    800067d8:	6462                	ld	s0,24(sp)
    800067da:	6105                	add	sp,sp,32
    800067dc:	8082                	ret
    x = -xx;
    800067de:	40b005bb          	negw	a1,a1
  if(sign && (sign = xx < 0))
    800067e2:	4305                	li	t1,1
    x = -xx;
    800067e4:	bfbd                	j	80006762 <sprintint+0x12>
  while(--i >= 0)
    800067e6:	4501                	li	a0,0
    800067e8:	bfc5                	j	800067d8 <sprintint+0x88>

00000000800067ea <snprintf>:

int
snprintf(char *buf, int sz, char *fmt, ...)
{
    800067ea:	7135                	add	sp,sp,-160
    800067ec:	f486                	sd	ra,104(sp)
    800067ee:	f0a2                	sd	s0,96(sp)
    800067f0:	eca6                	sd	s1,88(sp)
    800067f2:	e8ca                	sd	s2,80(sp)
    800067f4:	e4ce                	sd	s3,72(sp)
    800067f6:	e0d2                	sd	s4,64(sp)
    800067f8:	fc56                	sd	s5,56(sp)
    800067fa:	f85a                	sd	s6,48(sp)
    800067fc:	f45e                	sd	s7,40(sp)
    800067fe:	f062                	sd	s8,32(sp)
    80006800:	ec66                	sd	s9,24(sp)
    80006802:	1880                	add	s0,sp,112
    80006804:	e414                	sd	a3,8(s0)
    80006806:	e818                	sd	a4,16(s0)
    80006808:	ec1c                	sd	a5,24(s0)
    8000680a:	03043023          	sd	a6,32(s0)
    8000680e:	03143423          	sd	a7,40(s0)
  va_list ap;
  int i, c;
  int off = 0;
  char *s;

  if (fmt == 0)
    80006812:	c60d                	beqz	a2,8000683c <snprintf+0x52>
    80006814:	8baa                	mv	s7,a0
    80006816:	8aae                	mv	s5,a1
    80006818:	89b2                	mv	s3,a2
    panic("null fmt");

  va_start(ap, fmt);
    8000681a:	00840793          	add	a5,s0,8
    8000681e:	f8f43c23          	sd	a5,-104(s0)
  int off = 0;
    80006822:	4481                	li	s1,0
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80006824:	4901                	li	s2,0
    80006826:	02b05363          	blez	a1,8000684c <snprintf+0x62>
    if(c != '%'){
    8000682a:	02500a13          	li	s4,37
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    8000682e:	07300b13          	li	s6,115
    80006832:	07800c93          	li	s9,120
    80006836:	06400c13          	li	s8,100
    8000683a:	a01d                	j	80006860 <snprintf+0x76>
    panic("null fmt");
    8000683c:	00001517          	auipc	a0,0x1
    80006840:	7ec50513          	add	a0,a0,2028 # 80008028 <etext+0x28>
    80006844:	ffffa097          	auipc	ra,0xffffa
    80006848:	cfe080e7          	jalr	-770(ra) # 80000542 <panic>
  int off = 0;
    8000684c:	4481                	li	s1,0
    8000684e:	a0f9                	j	8000691c <snprintf+0x132>
  *s = c;
    80006850:	009b8733          	add	a4,s7,s1
    80006854:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80006858:	2485                	addw	s1,s1,1
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    8000685a:	2905                	addw	s2,s2,1
    8000685c:	0d54d063          	bge	s1,s5,8000691c <snprintf+0x132>
    80006860:	012987b3          	add	a5,s3,s2
    80006864:	0007c783          	lbu	a5,0(a5)
    80006868:	0007871b          	sext.w	a4,a5
    8000686c:	cbc5                	beqz	a5,8000691c <snprintf+0x132>
    if(c != '%'){
    8000686e:	ff4711e3          	bne	a4,s4,80006850 <snprintf+0x66>
    c = fmt[++i] & 0xff;
    80006872:	2905                	addw	s2,s2,1
    80006874:	012987b3          	add	a5,s3,s2
    80006878:	0007c783          	lbu	a5,0(a5)
    if(c == 0)
    8000687c:	c3c5                	beqz	a5,8000691c <snprintf+0x132>
    switch(c){
    8000687e:	05678c63          	beq	a5,s6,800068d6 <snprintf+0xec>
    80006882:	02fb6763          	bltu	s6,a5,800068b0 <snprintf+0xc6>
    80006886:	0d478063          	beq	a5,s4,80006946 <snprintf+0x15c>
    8000688a:	0d879463          	bne	a5,s8,80006952 <snprintf+0x168>
    case 'd':
      off += sprintint(buf+off, va_arg(ap, int), 10, 1);
    8000688e:	f9843783          	ld	a5,-104(s0)
    80006892:	00878713          	add	a4,a5,8
    80006896:	f8e43c23          	sd	a4,-104(s0)
    8000689a:	4685                	li	a3,1
    8000689c:	4629                	li	a2,10
    8000689e:	438c                	lw	a1,0(a5)
    800068a0:	009b8533          	add	a0,s7,s1
    800068a4:	00000097          	auipc	ra,0x0
    800068a8:	eac080e7          	jalr	-340(ra) # 80006750 <sprintint>
    800068ac:	9ca9                	addw	s1,s1,a0
      break;
    800068ae:	b775                	j	8000685a <snprintf+0x70>
    switch(c){
    800068b0:	0b979163          	bne	a5,s9,80006952 <snprintf+0x168>
    case 'x':
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
    800068b4:	f9843783          	ld	a5,-104(s0)
    800068b8:	00878713          	add	a4,a5,8
    800068bc:	f8e43c23          	sd	a4,-104(s0)
    800068c0:	4685                	li	a3,1
    800068c2:	4641                	li	a2,16
    800068c4:	438c                	lw	a1,0(a5)
    800068c6:	009b8533          	add	a0,s7,s1
    800068ca:	00000097          	auipc	ra,0x0
    800068ce:	e86080e7          	jalr	-378(ra) # 80006750 <sprintint>
    800068d2:	9ca9                	addw	s1,s1,a0
      break;
    800068d4:	b759                	j	8000685a <snprintf+0x70>
    case 's':
      if((s = va_arg(ap, char*)) == 0)
    800068d6:	f9843783          	ld	a5,-104(s0)
    800068da:	00878713          	add	a4,a5,8
    800068de:	f8e43c23          	sd	a4,-104(s0)
    800068e2:	6388                	ld	a0,0(a5)
    800068e4:	c931                	beqz	a0,80006938 <snprintf+0x14e>
        s = "(null)";
      for(; *s && off < sz; s++)
    800068e6:	00054703          	lbu	a4,0(a0)
    800068ea:	db25                	beqz	a4,8000685a <snprintf+0x70>
    800068ec:	0354d863          	bge	s1,s5,8000691c <snprintf+0x132>
    800068f0:	009b86b3          	add	a3,s7,s1
    800068f4:	409a863b          	subw	a2,s5,s1
    800068f8:	1602                	sll	a2,a2,0x20
    800068fa:	9201                	srl	a2,a2,0x20
    800068fc:	962a                	add	a2,a2,a0
    800068fe:	87aa                	mv	a5,a0
        off += sputc(buf+off, *s);
    80006900:	0014859b          	addw	a1,s1,1
    80006904:	9d89                	subw	a1,a1,a0
  *s = c;
    80006906:	00e68023          	sb	a4,0(a3)
        off += sputc(buf+off, *s);
    8000690a:	00f584bb          	addw	s1,a1,a5
      for(; *s && off < sz; s++)
    8000690e:	0785                	add	a5,a5,1
    80006910:	0007c703          	lbu	a4,0(a5)
    80006914:	d339                	beqz	a4,8000685a <snprintf+0x70>
    80006916:	0685                	add	a3,a3,1
    80006918:	fec797e3          	bne	a5,a2,80006906 <snprintf+0x11c>
      off += sputc(buf+off, c);
      break;
    }
  }
  return off;
}
    8000691c:	8526                	mv	a0,s1
    8000691e:	70a6                	ld	ra,104(sp)
    80006920:	7406                	ld	s0,96(sp)
    80006922:	64e6                	ld	s1,88(sp)
    80006924:	6946                	ld	s2,80(sp)
    80006926:	69a6                	ld	s3,72(sp)
    80006928:	6a06                	ld	s4,64(sp)
    8000692a:	7ae2                	ld	s5,56(sp)
    8000692c:	7b42                	ld	s6,48(sp)
    8000692e:	7ba2                	ld	s7,40(sp)
    80006930:	7c02                	ld	s8,32(sp)
    80006932:	6ce2                	ld	s9,24(sp)
    80006934:	610d                	add	sp,sp,160
    80006936:	8082                	ret
      for(; *s && off < sz; s++)
    80006938:	02800713          	li	a4,40
        s = "(null)";
    8000693c:	00001517          	auipc	a0,0x1
    80006940:	6e450513          	add	a0,a0,1764 # 80008020 <etext+0x20>
    80006944:	b765                	j	800068ec <snprintf+0x102>
  *s = c;
    80006946:	009b87b3          	add	a5,s7,s1
    8000694a:	01478023          	sb	s4,0(a5)
      off += sputc(buf+off, '%');
    8000694e:	2485                	addw	s1,s1,1
      break;
    80006950:	b729                	j	8000685a <snprintf+0x70>
  *s = c;
    80006952:	009b8733          	add	a4,s7,s1
    80006956:	01470023          	sb	s4,0(a4)
      off += sputc(buf+off, c);
    8000695a:	0014871b          	addw	a4,s1,1
  *s = c;
    8000695e:	975e                	add	a4,a4,s7
    80006960:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80006964:	2489                	addw	s1,s1,2
      break;
    80006966:	bdd5                	j	8000685a <snprintf+0x70>
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
