
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
    80000060:	bd478793          	add	a5,a5,-1068 # 80005c30 <timervec>
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
    8000012a:	3de080e7          	jalr	990(ra) # 80002504 <either_copyin>
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
    800001c4:	87e080e7          	jalr	-1922(ra) # 80001a3e <myproc>
    800001c8:	591c                	lw	a5,48(a0)
    800001ca:	efad                	bnez	a5,80000244 <consoleread+0xd4>
      sleep(&cons.r, &cons.lock);
    800001cc:	85a6                	mv	a1,s1
    800001ce:	854a                	mv	a0,s2
    800001d0:	00002097          	auipc	ra,0x2
    800001d4:	084080e7          	jalr	132(ra) # 80002254 <sleep>
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
    8000021a:	298080e7          	jalr	664(ra) # 800024ae <either_copyout>
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
    800002f8:	266080e7          	jalr	614(ra) # 8000255a <procdump>
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
    8000044c:	f8c080e7          	jalr	-116(ra) # 800023d4 <wakeup>
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
    8000047e:	53678793          	add	a5,a5,1334 # 800219b0 <devsw>
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
    800008a6:	b32080e7          	jalr	-1230(ra) # 800023d4 <wakeup>
    
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
    80000940:	918080e7          	jalr	-1768(ra) # 80002254 <sleep>
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
    80000b9a:	e8c080e7          	jalr	-372(ra) # 80001a22 <mycpu>
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
    80000bcc:	e5a080e7          	jalr	-422(ra) # 80001a22 <mycpu>
    80000bd0:	5d3c                	lw	a5,120(a0)
    80000bd2:	cf89                	beqz	a5,80000bec <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd4:	00001097          	auipc	ra,0x1
    80000bd8:	e4e080e7          	jalr	-434(ra) # 80001a22 <mycpu>
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
    80000bf0:	e36080e7          	jalr	-458(ra) # 80001a22 <mycpu>
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
    80000c30:	df6080e7          	jalr	-522(ra) # 80001a22 <mycpu>
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
    80000c5c:	dca080e7          	jalr	-566(ra) # 80001a22 <mycpu>
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
    80000da8:	177d                	add	a4,a4,-1 # ffffffffffffefff <end+0xffffffff7ffd8fff>
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
    80000eb0:	b66080e7          	jalr	-1178(ra) # 80001a12 <cpuid>
    virtio_disk_init(); // emulated hard disk
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
    80000ecc:	b4a080e7          	jalr	-1206(ra) # 80001a12 <cpuid>
    80000ed0:	85aa                	mv	a1,a0
    80000ed2:	00007517          	auipc	a0,0x7
    80000ed6:	1e650513          	add	a0,a0,486 # 800080b8 <digits+0x78>
    80000eda:	fffff097          	auipc	ra,0xfffff
    80000ede:	6b2080e7          	jalr	1714(ra) # 8000058c <printf>
    kvminithart();    // turn on paging
    80000ee2:	00000097          	auipc	ra,0x0
    80000ee6:	0d8080e7          	jalr	216(ra) # 80000fba <kvminithart>
    trapinithart();   // install kernel trap vector
    80000eea:	00001097          	auipc	ra,0x1
    80000eee:	7b2080e7          	jalr	1970(ra) # 8000269c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ef2:	00005097          	auipc	ra,0x5
    80000ef6:	d7e080e7          	jalr	-642(ra) # 80005c70 <plicinithart>
  }

  scheduler();        
    80000efa:	00001097          	auipc	ra,0x1
    80000efe:	07c080e7          	jalr	124(ra) # 80001f76 <scheduler>
    consoleinit();
    80000f02:	fffff097          	auipc	ra,0xfffff
    80000f06:	550080e7          	jalr	1360(ra) # 80000452 <consoleinit>
    printfinit();
    80000f0a:	00000097          	auipc	ra,0x0
    80000f0e:	862080e7          	jalr	-1950(ra) # 8000076c <printfinit>
    printf("\n");
    80000f12:	00007517          	auipc	a0,0x7
    80000f16:	1b650513          	add	a0,a0,438 # 800080c8 <digits+0x88>
    80000f1a:	fffff097          	auipc	ra,0xfffff
    80000f1e:	672080e7          	jalr	1650(ra) # 8000058c <printf>
    printf("xv6 kernel is booting\n");
    80000f22:	00007517          	auipc	a0,0x7
    80000f26:	17e50513          	add	a0,a0,382 # 800080a0 <digits+0x60>
    80000f2a:	fffff097          	auipc	ra,0xfffff
    80000f2e:	662080e7          	jalr	1634(ra) # 8000058c <printf>
    printf("\n");
    80000f32:	00007517          	auipc	a0,0x7
    80000f36:	19650513          	add	a0,a0,406 # 800080c8 <digits+0x88>
    80000f3a:	fffff097          	auipc	ra,0xfffff
    80000f3e:	652080e7          	jalr	1618(ra) # 8000058c <printf>
    kinit();         // physical page allocator
    80000f42:	00000097          	auipc	ra,0x0
    80000f46:	b8e080e7          	jalr	-1138(ra) # 80000ad0 <kinit>
    kvminit();       // create kernel page table
    80000f4a:	00000097          	auipc	ra,0x0
    80000f4e:	2a0080e7          	jalr	672(ra) # 800011ea <kvminit>
    kvminithart();   // turn on paging
    80000f52:	00000097          	auipc	ra,0x0
    80000f56:	068080e7          	jalr	104(ra) # 80000fba <kvminithart>
    procinit();      // process table
    80000f5a:	00001097          	auipc	ra,0x1
    80000f5e:	9e8080e7          	jalr	-1560(ra) # 80001942 <procinit>
    trapinit();      // trap vectors
    80000f62:	00001097          	auipc	ra,0x1
    80000f66:	712080e7          	jalr	1810(ra) # 80002674 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f6a:	00001097          	auipc	ra,0x1
    80000f6e:	732080e7          	jalr	1842(ra) # 8000269c <trapinithart>
    plicinit();      // set up interrupt controller
    80000f72:	00005097          	auipc	ra,0x5
    80000f76:	ce8080e7          	jalr	-792(ra) # 80005c5a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f7a:	00005097          	auipc	ra,0x5
    80000f7e:	cf6080e7          	jalr	-778(ra) # 80005c70 <plicinithart>
    binit();         // buffer cache
    80000f82:	00002097          	auipc	ra,0x2
    80000f86:	ef4080e7          	jalr	-268(ra) # 80002e76 <binit>
    iinit();         // inode cache
    80000f8a:	00002097          	auipc	ra,0x2
    80000f8e:	580080e7          	jalr	1408(ra) # 8000350a <iinit>
    fileinit();      // file table
    80000f92:	00003097          	auipc	ra,0x3
    80000f96:	4f6080e7          	jalr	1270(ra) # 80004488 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f9a:	00005097          	auipc	ra,0x5
    80000f9e:	ddc080e7          	jalr	-548(ra) # 80005d76 <virtio_disk_init>
    userinit();      // first user process
    80000fa2:	00001097          	auipc	ra,0x1
    80000fa6:	d66080e7          	jalr	-666(ra) # 80001d08 <userinit>
    __sync_synchronize();
    80000faa:	0ff0000f          	fence
    started = 1;
    80000fae:	4785                	li	a5,1
    80000fb0:	00008717          	auipc	a4,0x8
    80000fb4:	04f72e23          	sw	a5,92(a4) # 8000900c <started>
    80000fb8:	b789                	j	80000efa <main+0x56>

0000000080000fba <kvminithart>:
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart()
{
    80000fba:	1141                	add	sp,sp,-16
    80000fbc:	e422                	sd	s0,8(sp)
    80000fbe:	0800                	add	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000fc0:	00008797          	auipc	a5,0x8
    80000fc4:	0507b783          	ld	a5,80(a5) # 80009010 <kernel_pagetable>
    80000fc8:	83b1                	srl	a5,a5,0xc
    80000fca:	577d                	li	a4,-1
    80000fcc:	177e                	sll	a4,a4,0x3f
    80000fce:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fd0:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000fd4:	12000073          	sfence.vma
  sfence_vma();
}
    80000fd8:	6422                	ld	s0,8(sp)
    80000fda:	0141                	add	sp,sp,16
    80000fdc:	8082                	ret

0000000080000fde <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fde:	7139                	add	sp,sp,-64
    80000fe0:	fc06                	sd	ra,56(sp)
    80000fe2:	f822                	sd	s0,48(sp)
    80000fe4:	f426                	sd	s1,40(sp)
    80000fe6:	f04a                	sd	s2,32(sp)
    80000fe8:	ec4e                	sd	s3,24(sp)
    80000fea:	e852                	sd	s4,16(sp)
    80000fec:	e456                	sd	s5,8(sp)
    80000fee:	e05a                	sd	s6,0(sp)
    80000ff0:	0080                	add	s0,sp,64
    80000ff2:	84aa                	mv	s1,a0
    80000ff4:	89ae                	mv	s3,a1
    80000ff6:	8ab2                	mv	s5,a2
  if (va >= MAXVA)
    80000ff8:	57fd                	li	a5,-1
    80000ffa:	83e9                	srl	a5,a5,0x1a
    80000ffc:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--)
    80000ffe:	4b31                	li	s6,12
  if (va >= MAXVA)
    80001000:	04b7f263          	bgeu	a5,a1,80001044 <walk+0x66>
    panic("walk");
    80001004:	00007517          	auipc	a0,0x7
    80001008:	0cc50513          	add	a0,a0,204 # 800080d0 <digits+0x90>
    8000100c:	fffff097          	auipc	ra,0xfffff
    80001010:	536080e7          	jalr	1334(ra) # 80000542 <panic>
    {
      pagetable = (pagetable_t)PTE2PA(*pte);
    }
    else
    {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80001014:	060a8663          	beqz	s5,80001080 <walk+0xa2>
    80001018:	00000097          	auipc	ra,0x0
    8000101c:	af4080e7          	jalr	-1292(ra) # 80000b0c <kalloc>
    80001020:	84aa                	mv	s1,a0
    80001022:	c529                	beqz	a0,8000106c <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001024:	6605                	lui	a2,0x1
    80001026:	4581                	li	a1,0
    80001028:	00000097          	auipc	ra,0x0
    8000102c:	cd0080e7          	jalr	-816(ra) # 80000cf8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001030:	00c4d793          	srl	a5,s1,0xc
    80001034:	07aa                	sll	a5,a5,0xa
    80001036:	0017e793          	or	a5,a5,1
    8000103a:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--)
    8000103e:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8ff7>
    80001040:	036a0063          	beq	s4,s6,80001060 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001044:	0149d933          	srl	s2,s3,s4
    80001048:	1ff97913          	and	s2,s2,511
    8000104c:	090e                	sll	s2,s2,0x3
    8000104e:	9926                	add	s2,s2,s1
    if (*pte & PTE_V)
    80001050:	00093483          	ld	s1,0(s2)
    80001054:	0014f793          	and	a5,s1,1
    80001058:	dfd5                	beqz	a5,80001014 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000105a:	80a9                	srl	s1,s1,0xa
    8000105c:	04b2                	sll	s1,s1,0xc
    8000105e:	b7c5                	j	8000103e <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001060:	00c9d513          	srl	a0,s3,0xc
    80001064:	1ff57513          	and	a0,a0,511
    80001068:	050e                	sll	a0,a0,0x3
    8000106a:	9526                	add	a0,a0,s1
}
    8000106c:	70e2                	ld	ra,56(sp)
    8000106e:	7442                	ld	s0,48(sp)
    80001070:	74a2                	ld	s1,40(sp)
    80001072:	7902                	ld	s2,32(sp)
    80001074:	69e2                	ld	s3,24(sp)
    80001076:	6a42                	ld	s4,16(sp)
    80001078:	6aa2                	ld	s5,8(sp)
    8000107a:	6b02                	ld	s6,0(sp)
    8000107c:	6121                	add	sp,sp,64
    8000107e:	8082                	ret
        return 0;
    80001080:	4501                	li	a0,0
    80001082:	b7ed                	j	8000106c <walk+0x8e>

0000000080001084 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    80001084:	57fd                	li	a5,-1
    80001086:	83e9                	srl	a5,a5,0x1a
    80001088:	00b7f463          	bgeu	a5,a1,80001090 <walkaddr+0xc>
    return 0;
    8000108c:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000108e:	8082                	ret
{
    80001090:	1141                	add	sp,sp,-16
    80001092:	e406                	sd	ra,8(sp)
    80001094:	e022                	sd	s0,0(sp)
    80001096:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001098:	4601                	li	a2,0
    8000109a:	00000097          	auipc	ra,0x0
    8000109e:	f44080e7          	jalr	-188(ra) # 80000fde <walk>
  if (pte == 0)
    800010a2:	c105                	beqz	a0,800010c2 <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0)
    800010a4:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    800010a6:	0117f693          	and	a3,a5,17
    800010aa:	4745                	li	a4,17
    return 0;
    800010ac:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    800010ae:	00e68663          	beq	a3,a4,800010ba <walkaddr+0x36>
}
    800010b2:	60a2                	ld	ra,8(sp)
    800010b4:	6402                	ld	s0,0(sp)
    800010b6:	0141                	add	sp,sp,16
    800010b8:	8082                	ret
  pa = PTE2PA(*pte);
    800010ba:	83a9                	srl	a5,a5,0xa
    800010bc:	00c79513          	sll	a0,a5,0xc
  return pa;
    800010c0:	bfcd                	j	800010b2 <walkaddr+0x2e>
    return 0;
    800010c2:	4501                	li	a0,0
    800010c4:	b7fd                	j	800010b2 <walkaddr+0x2e>

00000000800010c6 <kvmpa>:
// a physical address. only needed for
// addresses on the stack.
// assumes va is page aligned.
uint64
kvmpa(uint64 va)
{
    800010c6:	1101                	add	sp,sp,-32
    800010c8:	ec06                	sd	ra,24(sp)
    800010ca:	e822                	sd	s0,16(sp)
    800010cc:	e426                	sd	s1,8(sp)
    800010ce:	1000                	add	s0,sp,32
    800010d0:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    800010d2:	1552                	sll	a0,a0,0x34
    800010d4:	03455493          	srl	s1,a0,0x34
  pte_t *pte;
  uint64 pa;

  pte = walk(kernel_pagetable, va, 0);
    800010d8:	4601                	li	a2,0
    800010da:	00008517          	auipc	a0,0x8
    800010de:	f3653503          	ld	a0,-202(a0) # 80009010 <kernel_pagetable>
    800010e2:	00000097          	auipc	ra,0x0
    800010e6:	efc080e7          	jalr	-260(ra) # 80000fde <walk>
  if (pte == 0)
    800010ea:	cd09                	beqz	a0,80001104 <kvmpa+0x3e>
    panic("kvmpa");
  if ((*pte & PTE_V) == 0)
    800010ec:	6108                	ld	a0,0(a0)
    800010ee:	00157793          	and	a5,a0,1
    800010f2:	c38d                	beqz	a5,80001114 <kvmpa+0x4e>
    panic("kvmpa");
  pa = PTE2PA(*pte);
    800010f4:	8129                	srl	a0,a0,0xa
    800010f6:	0532                	sll	a0,a0,0xc
  return pa + off;
}
    800010f8:	9526                	add	a0,a0,s1
    800010fa:	60e2                	ld	ra,24(sp)
    800010fc:	6442                	ld	s0,16(sp)
    800010fe:	64a2                	ld	s1,8(sp)
    80001100:	6105                	add	sp,sp,32
    80001102:	8082                	ret
    panic("kvmpa");
    80001104:	00007517          	auipc	a0,0x7
    80001108:	fd450513          	add	a0,a0,-44 # 800080d8 <digits+0x98>
    8000110c:	fffff097          	auipc	ra,0xfffff
    80001110:	436080e7          	jalr	1078(ra) # 80000542 <panic>
    panic("kvmpa");
    80001114:	00007517          	auipc	a0,0x7
    80001118:	fc450513          	add	a0,a0,-60 # 800080d8 <digits+0x98>
    8000111c:	fffff097          	auipc	ra,0xfffff
    80001120:	426080e7          	jalr	1062(ra) # 80000542 <panic>

0000000080001124 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001124:	715d                	add	sp,sp,-80
    80001126:	e486                	sd	ra,72(sp)
    80001128:	e0a2                	sd	s0,64(sp)
    8000112a:	fc26                	sd	s1,56(sp)
    8000112c:	f84a                	sd	s2,48(sp)
    8000112e:	f44e                	sd	s3,40(sp)
    80001130:	f052                	sd	s4,32(sp)
    80001132:	ec56                	sd	s5,24(sp)
    80001134:	e85a                	sd	s6,16(sp)
    80001136:	e45e                	sd	s7,8(sp)
    80001138:	0880                	add	s0,sp,80
    8000113a:	8aaa                	mv	s5,a0
    8000113c:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    8000113e:	777d                	lui	a4,0xfffff
    80001140:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001144:	fff60993          	add	s3,a2,-1 # fff <_entry-0x7ffff001>
    80001148:	99ae                	add	s3,s3,a1
    8000114a:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000114e:	893e                	mv	s2,a5
    80001150:	40f68a33          	sub	s4,a3,a5
    if (*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    80001154:	6b85                	lui	s7,0x1
    80001156:	012a04b3          	add	s1,s4,s2
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000115a:	4605                	li	a2,1
    8000115c:	85ca                	mv	a1,s2
    8000115e:	8556                	mv	a0,s5
    80001160:	00000097          	auipc	ra,0x0
    80001164:	e7e080e7          	jalr	-386(ra) # 80000fde <walk>
    80001168:	c51d                	beqz	a0,80001196 <mappages+0x72>
    if (*pte & PTE_V)
    8000116a:	611c                	ld	a5,0(a0)
    8000116c:	8b85                	and	a5,a5,1
    8000116e:	ef81                	bnez	a5,80001186 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001170:	80b1                	srl	s1,s1,0xc
    80001172:	04aa                	sll	s1,s1,0xa
    80001174:	0164e4b3          	or	s1,s1,s6
    80001178:	0014e493          	or	s1,s1,1
    8000117c:	e104                	sd	s1,0(a0)
    if (a == last)
    8000117e:	03390863          	beq	s2,s3,800011ae <mappages+0x8a>
    a += PGSIZE;
    80001182:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001184:	bfc9                	j	80001156 <mappages+0x32>
      panic("remap");
    80001186:	00007517          	auipc	a0,0x7
    8000118a:	f5a50513          	add	a0,a0,-166 # 800080e0 <digits+0xa0>
    8000118e:	fffff097          	auipc	ra,0xfffff
    80001192:	3b4080e7          	jalr	948(ra) # 80000542 <panic>
      return -1;
    80001196:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001198:	60a6                	ld	ra,72(sp)
    8000119a:	6406                	ld	s0,64(sp)
    8000119c:	74e2                	ld	s1,56(sp)
    8000119e:	7942                	ld	s2,48(sp)
    800011a0:	79a2                	ld	s3,40(sp)
    800011a2:	7a02                	ld	s4,32(sp)
    800011a4:	6ae2                	ld	s5,24(sp)
    800011a6:	6b42                	ld	s6,16(sp)
    800011a8:	6ba2                	ld	s7,8(sp)
    800011aa:	6161                	add	sp,sp,80
    800011ac:	8082                	ret
  return 0;
    800011ae:	4501                	li	a0,0
    800011b0:	b7e5                	j	80001198 <mappages+0x74>

00000000800011b2 <kvmmap>:
{
    800011b2:	1141                	add	sp,sp,-16
    800011b4:	e406                	sd	ra,8(sp)
    800011b6:	e022                	sd	s0,0(sp)
    800011b8:	0800                	add	s0,sp,16
    800011ba:	8736                	mv	a4,a3
  if (mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800011bc:	86ae                	mv	a3,a1
    800011be:	85aa                	mv	a1,a0
    800011c0:	00008517          	auipc	a0,0x8
    800011c4:	e5053503          	ld	a0,-432(a0) # 80009010 <kernel_pagetable>
    800011c8:	00000097          	auipc	ra,0x0
    800011cc:	f5c080e7          	jalr	-164(ra) # 80001124 <mappages>
    800011d0:	e509                	bnez	a0,800011da <kvmmap+0x28>
}
    800011d2:	60a2                	ld	ra,8(sp)
    800011d4:	6402                	ld	s0,0(sp)
    800011d6:	0141                	add	sp,sp,16
    800011d8:	8082                	ret
    panic("kvmmap");
    800011da:	00007517          	auipc	a0,0x7
    800011de:	f0e50513          	add	a0,a0,-242 # 800080e8 <digits+0xa8>
    800011e2:	fffff097          	auipc	ra,0xfffff
    800011e6:	360080e7          	jalr	864(ra) # 80000542 <panic>

00000000800011ea <kvminit>:
{
    800011ea:	1101                	add	sp,sp,-32
    800011ec:	ec06                	sd	ra,24(sp)
    800011ee:	e822                	sd	s0,16(sp)
    800011f0:	e426                	sd	s1,8(sp)
    800011f2:	1000                	add	s0,sp,32
  kernel_pagetable = (pagetable_t)kalloc();
    800011f4:	00000097          	auipc	ra,0x0
    800011f8:	918080e7          	jalr	-1768(ra) # 80000b0c <kalloc>
    800011fc:	00008717          	auipc	a4,0x8
    80001200:	e0a73a23          	sd	a0,-492(a4) # 80009010 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    80001204:	6605                	lui	a2,0x1
    80001206:	4581                	li	a1,0
    80001208:	00000097          	auipc	ra,0x0
    8000120c:	af0080e7          	jalr	-1296(ra) # 80000cf8 <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001210:	4699                	li	a3,6
    80001212:	6605                	lui	a2,0x1
    80001214:	100005b7          	lui	a1,0x10000
    80001218:	10000537          	lui	a0,0x10000
    8000121c:	00000097          	auipc	ra,0x0
    80001220:	f96080e7          	jalr	-106(ra) # 800011b2 <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001224:	4699                	li	a3,6
    80001226:	6605                	lui	a2,0x1
    80001228:	100015b7          	lui	a1,0x10001
    8000122c:	10001537          	lui	a0,0x10001
    80001230:	00000097          	auipc	ra,0x0
    80001234:	f82080e7          	jalr	-126(ra) # 800011b2 <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    80001238:	4699                	li	a3,6
    8000123a:	6641                	lui	a2,0x10
    8000123c:	020005b7          	lui	a1,0x2000
    80001240:	02000537          	lui	a0,0x2000
    80001244:	00000097          	auipc	ra,0x0
    80001248:	f6e080e7          	jalr	-146(ra) # 800011b2 <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000124c:	4699                	li	a3,6
    8000124e:	00400637          	lui	a2,0x400
    80001252:	0c0005b7          	lui	a1,0xc000
    80001256:	0c000537          	lui	a0,0xc000
    8000125a:	00000097          	auipc	ra,0x0
    8000125e:	f58080e7          	jalr	-168(ra) # 800011b2 <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80001262:	00007497          	auipc	s1,0x7
    80001266:	d9e48493          	add	s1,s1,-610 # 80008000 <etext>
    8000126a:	46a9                	li	a3,10
    8000126c:	80007617          	auipc	a2,0x80007
    80001270:	d9460613          	add	a2,a2,-620 # 8000 <_entry-0x7fff8000>
    80001274:	4585                	li	a1,1
    80001276:	05fe                	sll	a1,a1,0x1f
    80001278:	852e                	mv	a0,a1
    8000127a:	00000097          	auipc	ra,0x0
    8000127e:	f38080e7          	jalr	-200(ra) # 800011b2 <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
    80001282:	4699                	li	a3,6
    80001284:	4645                	li	a2,17
    80001286:	066e                	sll	a2,a2,0x1b
    80001288:	8e05                	sub	a2,a2,s1
    8000128a:	85a6                	mv	a1,s1
    8000128c:	8526                	mv	a0,s1
    8000128e:	00000097          	auipc	ra,0x0
    80001292:	f24080e7          	jalr	-220(ra) # 800011b2 <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001296:	46a9                	li	a3,10
    80001298:	6605                	lui	a2,0x1
    8000129a:	00006597          	auipc	a1,0x6
    8000129e:	d6658593          	add	a1,a1,-666 # 80007000 <_trampoline>
    800012a2:	04000537          	lui	a0,0x4000
    800012a6:	157d                	add	a0,a0,-1 # 3ffffff <_entry-0x7c000001>
    800012a8:	0532                	sll	a0,a0,0xc
    800012aa:	00000097          	auipc	ra,0x0
    800012ae:	f08080e7          	jalr	-248(ra) # 800011b2 <kvmmap>
}
    800012b2:	60e2                	ld	ra,24(sp)
    800012b4:	6442                	ld	s0,16(sp)
    800012b6:	64a2                	ld	s1,8(sp)
    800012b8:	6105                	add	sp,sp,32
    800012ba:	8082                	ret

00000000800012bc <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012bc:	715d                	add	sp,sp,-80
    800012be:	e486                	sd	ra,72(sp)
    800012c0:	e0a2                	sd	s0,64(sp)
    800012c2:	fc26                	sd	s1,56(sp)
    800012c4:	f84a                	sd	s2,48(sp)
    800012c6:	f44e                	sd	s3,40(sp)
    800012c8:	f052                	sd	s4,32(sp)
    800012ca:	ec56                	sd	s5,24(sp)
    800012cc:	e85a                	sd	s6,16(sp)
    800012ce:	e45e                	sd	s7,8(sp)
    800012d0:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    800012d2:	03459793          	sll	a5,a1,0x34
    800012d6:	e795                	bnez	a5,80001302 <uvmunmap+0x46>
    800012d8:	8a2a                	mv	s4,a0
    800012da:	892e                	mv	s2,a1
    800012dc:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    800012de:	0632                	sll	a2,a2,0xc
    800012e0:	00b609b3          	add	s3,a2,a1
  {
    if ((pte = walk(pagetable, a, 0)) == 0)
      continue;
    if ((*pte & PTE_V) == 0)
      continue; // panic("uvmunmap: not mapped"); 必须改成continue，否则可能进入do_free
    if (PTE_FLAGS(*pte) == PTE_V)
    800012e4:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    800012e6:	6a85                	lui	s5,0x1
    800012e8:	0535e263          	bltu	a1,s3,8000132c <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
  }
}
    800012ec:	60a6                	ld	ra,72(sp)
    800012ee:	6406                	ld	s0,64(sp)
    800012f0:	74e2                	ld	s1,56(sp)
    800012f2:	7942                	ld	s2,48(sp)
    800012f4:	79a2                	ld	s3,40(sp)
    800012f6:	7a02                	ld	s4,32(sp)
    800012f8:	6ae2                	ld	s5,24(sp)
    800012fa:	6b42                	ld	s6,16(sp)
    800012fc:	6ba2                	ld	s7,8(sp)
    800012fe:	6161                	add	sp,sp,80
    80001300:	8082                	ret
    panic("uvmunmap: not aligned");
    80001302:	00007517          	auipc	a0,0x7
    80001306:	dee50513          	add	a0,a0,-530 # 800080f0 <digits+0xb0>
    8000130a:	fffff097          	auipc	ra,0xfffff
    8000130e:	238080e7          	jalr	568(ra) # 80000542 <panic>
      panic("uvmunmap: not a leaf");
    80001312:	00007517          	auipc	a0,0x7
    80001316:	df650513          	add	a0,a0,-522 # 80008108 <digits+0xc8>
    8000131a:	fffff097          	auipc	ra,0xfffff
    8000131e:	228080e7          	jalr	552(ra) # 80000542 <panic>
    *pte = 0;
    80001322:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80001326:	9956                	add	s2,s2,s5
    80001328:	fd3972e3          	bgeu	s2,s3,800012ec <uvmunmap+0x30>
    if ((pte = walk(pagetable, a, 0)) == 0)
    8000132c:	4601                	li	a2,0
    8000132e:	85ca                	mv	a1,s2
    80001330:	8552                	mv	a0,s4
    80001332:	00000097          	auipc	ra,0x0
    80001336:	cac080e7          	jalr	-852(ra) # 80000fde <walk>
    8000133a:	84aa                	mv	s1,a0
    8000133c:	d56d                	beqz	a0,80001326 <uvmunmap+0x6a>
    if ((*pte & PTE_V) == 0)
    8000133e:	611c                	ld	a5,0(a0)
    80001340:	0017f713          	and	a4,a5,1
    80001344:	d36d                	beqz	a4,80001326 <uvmunmap+0x6a>
    if (PTE_FLAGS(*pte) == PTE_V)
    80001346:	3ff7f713          	and	a4,a5,1023
    8000134a:	fd7704e3          	beq	a4,s7,80001312 <uvmunmap+0x56>
    if (do_free)
    8000134e:	fc0b0ae3          	beqz	s6,80001322 <uvmunmap+0x66>
      uint64 pa = PTE2PA(*pte);
    80001352:	83a9                	srl	a5,a5,0xa
      kfree((void *)pa);
    80001354:	00c79513          	sll	a0,a5,0xc
    80001358:	fffff097          	auipc	ra,0xfffff
    8000135c:	6b6080e7          	jalr	1718(ra) # 80000a0e <kfree>
    80001360:	b7c9                	j	80001322 <uvmunmap+0x66>

0000000080001362 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001362:	1101                	add	sp,sp,-32
    80001364:	ec06                	sd	ra,24(sp)
    80001366:	e822                	sd	s0,16(sp)
    80001368:	e426                	sd	s1,8(sp)
    8000136a:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    8000136c:	fffff097          	auipc	ra,0xfffff
    80001370:	7a0080e7          	jalr	1952(ra) # 80000b0c <kalloc>
    80001374:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001376:	c519                	beqz	a0,80001384 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001378:	6605                	lui	a2,0x1
    8000137a:	4581                	li	a1,0
    8000137c:	00000097          	auipc	ra,0x0
    80001380:	97c080e7          	jalr	-1668(ra) # 80000cf8 <memset>
  return pagetable;
}
    80001384:	8526                	mv	a0,s1
    80001386:	60e2                	ld	ra,24(sp)
    80001388:	6442                	ld	s0,16(sp)
    8000138a:	64a2                	ld	s1,8(sp)
    8000138c:	6105                	add	sp,sp,32
    8000138e:	8082                	ret

0000000080001390 <uvminit>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80001390:	7179                	add	sp,sp,-48
    80001392:	f406                	sd	ra,40(sp)
    80001394:	f022                	sd	s0,32(sp)
    80001396:	ec26                	sd	s1,24(sp)
    80001398:	e84a                	sd	s2,16(sp)
    8000139a:	e44e                	sd	s3,8(sp)
    8000139c:	e052                	sd	s4,0(sp)
    8000139e:	1800                	add	s0,sp,48
  char *mem;

  if (sz >= PGSIZE)
    800013a0:	6785                	lui	a5,0x1
    800013a2:	04f67863          	bgeu	a2,a5,800013f2 <uvminit+0x62>
    800013a6:	8a2a                	mv	s4,a0
    800013a8:	89ae                	mv	s3,a1
    800013aa:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    800013ac:	fffff097          	auipc	ra,0xfffff
    800013b0:	760080e7          	jalr	1888(ra) # 80000b0c <kalloc>
    800013b4:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800013b6:	6605                	lui	a2,0x1
    800013b8:	4581                	li	a1,0
    800013ba:	00000097          	auipc	ra,0x0
    800013be:	93e080e7          	jalr	-1730(ra) # 80000cf8 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    800013c2:	4779                	li	a4,30
    800013c4:	86ca                	mv	a3,s2
    800013c6:	6605                	lui	a2,0x1
    800013c8:	4581                	li	a1,0
    800013ca:	8552                	mv	a0,s4
    800013cc:	00000097          	auipc	ra,0x0
    800013d0:	d58080e7          	jalr	-680(ra) # 80001124 <mappages>
  memmove(mem, src, sz);
    800013d4:	8626                	mv	a2,s1
    800013d6:	85ce                	mv	a1,s3
    800013d8:	854a                	mv	a0,s2
    800013da:	00000097          	auipc	ra,0x0
    800013de:	97a080e7          	jalr	-1670(ra) # 80000d54 <memmove>
}
    800013e2:	70a2                	ld	ra,40(sp)
    800013e4:	7402                	ld	s0,32(sp)
    800013e6:	64e2                	ld	s1,24(sp)
    800013e8:	6942                	ld	s2,16(sp)
    800013ea:	69a2                	ld	s3,8(sp)
    800013ec:	6a02                	ld	s4,0(sp)
    800013ee:	6145                	add	sp,sp,48
    800013f0:	8082                	ret
    panic("inituvm: more than a page");
    800013f2:	00007517          	auipc	a0,0x7
    800013f6:	d2e50513          	add	a0,a0,-722 # 80008120 <digits+0xe0>
    800013fa:	fffff097          	auipc	ra,0xfffff
    800013fe:	148080e7          	jalr	328(ra) # 80000542 <panic>

0000000080001402 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001402:	1101                	add	sp,sp,-32
    80001404:	ec06                	sd	ra,24(sp)
    80001406:	e822                	sd	s0,16(sp)
    80001408:	e426                	sd	s1,8(sp)
    8000140a:	1000                	add	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    8000140c:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    8000140e:	00b67d63          	bgeu	a2,a1,80001428 <uvmdealloc+0x26>
    80001412:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
    80001414:	6785                	lui	a5,0x1
    80001416:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001418:	00f60733          	add	a4,a2,a5
    8000141c:	76fd                	lui	a3,0xfffff
    8000141e:	8f75                	and	a4,a4,a3
    80001420:	97ae                	add	a5,a5,a1
    80001422:	8ff5                	and	a5,a5,a3
    80001424:	00f76863          	bltu	a4,a5,80001434 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001428:	8526                	mv	a0,s1
    8000142a:	60e2                	ld	ra,24(sp)
    8000142c:	6442                	ld	s0,16(sp)
    8000142e:	64a2                	ld	s1,8(sp)
    80001430:	6105                	add	sp,sp,32
    80001432:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001434:	8f99                	sub	a5,a5,a4
    80001436:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001438:	4685                	li	a3,1
    8000143a:	0007861b          	sext.w	a2,a5
    8000143e:	85ba                	mv	a1,a4
    80001440:	00000097          	auipc	ra,0x0
    80001444:	e7c080e7          	jalr	-388(ra) # 800012bc <uvmunmap>
    80001448:	b7c5                	j	80001428 <uvmdealloc+0x26>

000000008000144a <uvmalloc>:
  if (newsz < oldsz)
    8000144a:	0ab66163          	bltu	a2,a1,800014ec <uvmalloc+0xa2>
{
    8000144e:	7139                	add	sp,sp,-64
    80001450:	fc06                	sd	ra,56(sp)
    80001452:	f822                	sd	s0,48(sp)
    80001454:	f426                	sd	s1,40(sp)
    80001456:	f04a                	sd	s2,32(sp)
    80001458:	ec4e                	sd	s3,24(sp)
    8000145a:	e852                	sd	s4,16(sp)
    8000145c:	e456                	sd	s5,8(sp)
    8000145e:	0080                	add	s0,sp,64
    80001460:	8aaa                	mv	s5,a0
    80001462:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001464:	6785                	lui	a5,0x1
    80001466:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001468:	95be                	add	a1,a1,a5
    8000146a:	77fd                	lui	a5,0xfffff
    8000146c:	00f5f9b3          	and	s3,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE)
    80001470:	08c9f063          	bgeu	s3,a2,800014f0 <uvmalloc+0xa6>
    80001474:	894e                	mv	s2,s3
    mem = kalloc();
    80001476:	fffff097          	auipc	ra,0xfffff
    8000147a:	696080e7          	jalr	1686(ra) # 80000b0c <kalloc>
    8000147e:	84aa                	mv	s1,a0
    if (mem == 0)
    80001480:	c51d                	beqz	a0,800014ae <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001482:	6605                	lui	a2,0x1
    80001484:	4581                	li	a1,0
    80001486:	00000097          	auipc	ra,0x0
    8000148a:	872080e7          	jalr	-1934(ra) # 80000cf8 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0)
    8000148e:	4779                	li	a4,30
    80001490:	86a6                	mv	a3,s1
    80001492:	6605                	lui	a2,0x1
    80001494:	85ca                	mv	a1,s2
    80001496:	8556                	mv	a0,s5
    80001498:	00000097          	auipc	ra,0x0
    8000149c:	c8c080e7          	jalr	-884(ra) # 80001124 <mappages>
    800014a0:	e905                	bnez	a0,800014d0 <uvmalloc+0x86>
  for (a = oldsz; a < newsz; a += PGSIZE)
    800014a2:	6785                	lui	a5,0x1
    800014a4:	993e                	add	s2,s2,a5
    800014a6:	fd4968e3          	bltu	s2,s4,80001476 <uvmalloc+0x2c>
  return newsz;
    800014aa:	8552                	mv	a0,s4
    800014ac:	a809                	j	800014be <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800014ae:	864e                	mv	a2,s3
    800014b0:	85ca                	mv	a1,s2
    800014b2:	8556                	mv	a0,s5
    800014b4:	00000097          	auipc	ra,0x0
    800014b8:	f4e080e7          	jalr	-178(ra) # 80001402 <uvmdealloc>
      return 0;
    800014bc:	4501                	li	a0,0
}
    800014be:	70e2                	ld	ra,56(sp)
    800014c0:	7442                	ld	s0,48(sp)
    800014c2:	74a2                	ld	s1,40(sp)
    800014c4:	7902                	ld	s2,32(sp)
    800014c6:	69e2                	ld	s3,24(sp)
    800014c8:	6a42                	ld	s4,16(sp)
    800014ca:	6aa2                	ld	s5,8(sp)
    800014cc:	6121                	add	sp,sp,64
    800014ce:	8082                	ret
      kfree(mem);
    800014d0:	8526                	mv	a0,s1
    800014d2:	fffff097          	auipc	ra,0xfffff
    800014d6:	53c080e7          	jalr	1340(ra) # 80000a0e <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800014da:	864e                	mv	a2,s3
    800014dc:	85ca                	mv	a1,s2
    800014de:	8556                	mv	a0,s5
    800014e0:	00000097          	auipc	ra,0x0
    800014e4:	f22080e7          	jalr	-222(ra) # 80001402 <uvmdealloc>
      return 0;
    800014e8:	4501                	li	a0,0
    800014ea:	bfd1                	j	800014be <uvmalloc+0x74>
    return oldsz;
    800014ec:	852e                	mv	a0,a1
}
    800014ee:	8082                	ret
  return newsz;
    800014f0:	8532                	mv	a0,a2
    800014f2:	b7f1                	j	800014be <uvmalloc+0x74>

00000000800014f4 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    800014f4:	7179                	add	sp,sp,-48
    800014f6:	f406                	sd	ra,40(sp)
    800014f8:	f022                	sd	s0,32(sp)
    800014fa:	ec26                	sd	s1,24(sp)
    800014fc:	e84a                	sd	s2,16(sp)
    800014fe:	e44e                	sd	s3,8(sp)
    80001500:	e052                	sd	s4,0(sp)
    80001502:	1800                	add	s0,sp,48
    80001504:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++)
    80001506:	84aa                	mv	s1,a0
    80001508:	6905                	lui	s2,0x1
    8000150a:	992a                	add	s2,s2,a0
  {
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    8000150c:	4985                	li	s3,1
    8000150e:	a829                	j	80001528 <freewalk+0x34>
    {
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001510:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001512:	00c79513          	sll	a0,a5,0xc
    80001516:	00000097          	auipc	ra,0x0
    8000151a:	fde080e7          	jalr	-34(ra) # 800014f4 <freewalk>
      pagetable[i] = 0;
    8000151e:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++)
    80001522:	04a1                	add	s1,s1,8
    80001524:	03248163          	beq	s1,s2,80001546 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80001528:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    8000152a:	00f7f713          	and	a4,a5,15
    8000152e:	ff3701e3          	beq	a4,s3,80001510 <freewalk+0x1c>
    }
    else if (pte & PTE_V)
    80001532:	8b85                	and	a5,a5,1
    80001534:	d7fd                	beqz	a5,80001522 <freewalk+0x2e>
    {
      panic("freewalk: leaf");
    80001536:	00007517          	auipc	a0,0x7
    8000153a:	c0a50513          	add	a0,a0,-1014 # 80008140 <digits+0x100>
    8000153e:	fffff097          	auipc	ra,0xfffff
    80001542:	004080e7          	jalr	4(ra) # 80000542 <panic>
    }
  }
  kfree((void *)pagetable);
    80001546:	8552                	mv	a0,s4
    80001548:	fffff097          	auipc	ra,0xfffff
    8000154c:	4c6080e7          	jalr	1222(ra) # 80000a0e <kfree>
}
    80001550:	70a2                	ld	ra,40(sp)
    80001552:	7402                	ld	s0,32(sp)
    80001554:	64e2                	ld	s1,24(sp)
    80001556:	6942                	ld	s2,16(sp)
    80001558:	69a2                	ld	s3,8(sp)
    8000155a:	6a02                	ld	s4,0(sp)
    8000155c:	6145                	add	sp,sp,48
    8000155e:	8082                	ret

0000000080001560 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001560:	1101                	add	sp,sp,-32
    80001562:	ec06                	sd	ra,24(sp)
    80001564:	e822                	sd	s0,16(sp)
    80001566:	e426                	sd	s1,8(sp)
    80001568:	1000                	add	s0,sp,32
    8000156a:	84aa                	mv	s1,a0
  if (sz > 0)
    8000156c:	e999                	bnez	a1,80001582 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    8000156e:	8526                	mv	a0,s1
    80001570:	00000097          	auipc	ra,0x0
    80001574:	f84080e7          	jalr	-124(ra) # 800014f4 <freewalk>
}
    80001578:	60e2                	ld	ra,24(sp)
    8000157a:	6442                	ld	s0,16(sp)
    8000157c:	64a2                	ld	s1,8(sp)
    8000157e:	6105                	add	sp,sp,32
    80001580:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80001582:	6785                	lui	a5,0x1
    80001584:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001586:	95be                	add	a1,a1,a5
    80001588:	4685                	li	a3,1
    8000158a:	00c5d613          	srl	a2,a1,0xc
    8000158e:	4581                	li	a1,0
    80001590:	00000097          	auipc	ra,0x0
    80001594:	d2c080e7          	jalr	-724(ra) # 800012bc <uvmunmap>
    80001598:	bfd9                	j	8000156e <uvmfree+0xe>

000000008000159a <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE)
    8000159a:	ca4d                	beqz	a2,8000164c <uvmcopy+0xb2>
{
    8000159c:	715d                	add	sp,sp,-80
    8000159e:	e486                	sd	ra,72(sp)
    800015a0:	e0a2                	sd	s0,64(sp)
    800015a2:	fc26                	sd	s1,56(sp)
    800015a4:	f84a                	sd	s2,48(sp)
    800015a6:	f44e                	sd	s3,40(sp)
    800015a8:	f052                	sd	s4,32(sp)
    800015aa:	ec56                	sd	s5,24(sp)
    800015ac:	e85a                	sd	s6,16(sp)
    800015ae:	e45e                	sd	s7,8(sp)
    800015b0:	0880                	add	s0,sp,80
    800015b2:	8aaa                	mv	s5,a0
    800015b4:	8b2e                	mv	s6,a1
    800015b6:	8a32                	mv	s4,a2
  for (i = 0; i < sz; i += PGSIZE)
    800015b8:	4481                	li	s1,0
    800015ba:	a029                	j	800015c4 <uvmcopy+0x2a>
    800015bc:	6785                	lui	a5,0x1
    800015be:	94be                	add	s1,s1,a5
    800015c0:	0744fa63          	bgeu	s1,s4,80001634 <uvmcopy+0x9a>
  {
    if ((pte = walk(old, i, 0)) == 0)
    800015c4:	4601                	li	a2,0
    800015c6:	85a6                	mv	a1,s1
    800015c8:	8556                	mv	a0,s5
    800015ca:	00000097          	auipc	ra,0x0
    800015ce:	a14080e7          	jalr	-1516(ra) # 80000fde <walk>
    800015d2:	d56d                	beqz	a0,800015bc <uvmcopy+0x22>
      continue; // panic("uvmcopy: pte should exist");
    if ((*pte & PTE_V) == 0)
    800015d4:	6118                	ld	a4,0(a0)
    800015d6:	00177793          	and	a5,a4,1
    800015da:	d3ed                	beqz	a5,800015bc <uvmcopy+0x22>
      continue; // panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800015dc:	00a75593          	srl	a1,a4,0xa
    800015e0:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800015e4:	3ff77913          	and	s2,a4,1023
    if ((mem = kalloc()) == 0)
    800015e8:	fffff097          	auipc	ra,0xfffff
    800015ec:	524080e7          	jalr	1316(ra) # 80000b0c <kalloc>
    800015f0:	89aa                	mv	s3,a0
    800015f2:	c515                	beqz	a0,8000161e <uvmcopy+0x84>
      goto err;
    memmove(mem, (char *)pa, PGSIZE);
    800015f4:	6605                	lui	a2,0x1
    800015f6:	85de                	mv	a1,s7
    800015f8:	fffff097          	auipc	ra,0xfffff
    800015fc:	75c080e7          	jalr	1884(ra) # 80000d54 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0)
    80001600:	874a                	mv	a4,s2
    80001602:	86ce                	mv	a3,s3
    80001604:	6605                	lui	a2,0x1
    80001606:	85a6                	mv	a1,s1
    80001608:	855a                	mv	a0,s6
    8000160a:	00000097          	auipc	ra,0x0
    8000160e:	b1a080e7          	jalr	-1254(ra) # 80001124 <mappages>
    80001612:	d54d                	beqz	a0,800015bc <uvmcopy+0x22>
    {
      kfree(mem);
    80001614:	854e                	mv	a0,s3
    80001616:	fffff097          	auipc	ra,0xfffff
    8000161a:	3f8080e7          	jalr	1016(ra) # 80000a0e <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000161e:	4685                	li	a3,1
    80001620:	00c4d613          	srl	a2,s1,0xc
    80001624:	4581                	li	a1,0
    80001626:	855a                	mv	a0,s6
    80001628:	00000097          	auipc	ra,0x0
    8000162c:	c94080e7          	jalr	-876(ra) # 800012bc <uvmunmap>
  return -1;
    80001630:	557d                	li	a0,-1
    80001632:	a011                	j	80001636 <uvmcopy+0x9c>
  return 0;
    80001634:	4501                	li	a0,0
}
    80001636:	60a6                	ld	ra,72(sp)
    80001638:	6406                	ld	s0,64(sp)
    8000163a:	74e2                	ld	s1,56(sp)
    8000163c:	7942                	ld	s2,48(sp)
    8000163e:	79a2                	ld	s3,40(sp)
    80001640:	7a02                	ld	s4,32(sp)
    80001642:	6ae2                	ld	s5,24(sp)
    80001644:	6b42                	ld	s6,16(sp)
    80001646:	6ba2                	ld	s7,8(sp)
    80001648:	6161                	add	sp,sp,80
    8000164a:	8082                	ret
  return 0;
    8000164c:	4501                	li	a0,0
}
    8000164e:	8082                	ret

0000000080001650 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va)
{
    80001650:	1141                	add	sp,sp,-16
    80001652:	e406                	sd	ra,8(sp)
    80001654:	e022                	sd	s0,0(sp)
    80001656:	0800                	add	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80001658:	4601                	li	a2,0
    8000165a:	00000097          	auipc	ra,0x0
    8000165e:	984080e7          	jalr	-1660(ra) # 80000fde <walk>
  if (pte == 0)
    80001662:	c901                	beqz	a0,80001672 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001664:	611c                	ld	a5,0(a0)
    80001666:	9bbd                	and	a5,a5,-17
    80001668:	e11c                	sd	a5,0(a0)
}
    8000166a:	60a2                	ld	ra,8(sp)
    8000166c:	6402                	ld	s0,0(sp)
    8000166e:	0141                	add	sp,sp,16
    80001670:	8082                	ret
    panic("uvmclear");
    80001672:	00007517          	auipc	a0,0x7
    80001676:	ade50513          	add	a0,a0,-1314 # 80008150 <digits+0x110>
    8000167a:	fffff097          	auipc	ra,0xfffff
    8000167e:	ec8080e7          	jalr	-312(ra) # 80000542 <panic>

0000000080001682 <copyout>:

// Copy from kernel to user.
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
    80001682:	711d                	add	sp,sp,-96
    80001684:	ec86                	sd	ra,88(sp)
    80001686:	e8a2                	sd	s0,80(sp)
    80001688:	e4a6                	sd	s1,72(sp)
    8000168a:	e0ca                	sd	s2,64(sp)
    8000168c:	fc4e                	sd	s3,56(sp)
    8000168e:	f852                	sd	s4,48(sp)
    80001690:	f456                	sd	s5,40(sp)
    80001692:	f05a                	sd	s6,32(sp)
    80001694:	ec5e                	sd	s7,24(sp)
    80001696:	e862                	sd	s8,16(sp)
    80001698:	e466                	sd	s9,8(sp)
    8000169a:	1080                	add	s0,sp,96
    8000169c:	8baa                	mv	s7,a0
    8000169e:	84ae                	mv	s1,a1
    800016a0:	8b32                	mv	s6,a2
    800016a2:	8ab6                	mv	s5,a3
  uint64 n, va0, pa0;
  struct proc *p = myproc();
    800016a4:	00000097          	auipc	ra,0x0
    800016a8:	39a080e7          	jalr	922(ra) # 80001a3e <myproc>
  while (len > 0)
    800016ac:	0a0a8863          	beqz	s5,8000175c <copyout+0xda>
    800016b0:	8caa                	mv	s9,a0
  {
    va0 = PGROUNDDOWN(dstva);
    800016b2:	7c7d                	lui	s8,0xfffff
    800016b4:	a80d                	j	800016e6 <copyout+0x64>
        return -1;
      }
      memset(mem, 0, PGSIZE);
      if (mappages(pagetable, va0, PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0)
      {
        kfree(mem);
    800016b6:	854a                	mv	a0,s2
    800016b8:	fffff097          	auipc	ra,0xfffff
    800016bc:	356080e7          	jalr	854(ra) # 80000a0e <kfree>
        return -1;
    800016c0:	557d                	li	a0,-1
    800016c2:	a041                	j	80001742 <copyout+0xc0>
      pa0 = (uint64)mem;
    }
    n = PGSIZE - (dstva - va0);
    if (n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800016c4:	41348533          	sub	a0,s1,s3
    800016c8:	0009061b          	sext.w	a2,s2
    800016cc:	85da                	mv	a1,s6
    800016ce:	9552                	add	a0,a0,s4
    800016d0:	fffff097          	auipc	ra,0xfffff
    800016d4:	684080e7          	jalr	1668(ra) # 80000d54 <memmove>

    len -= n;
    800016d8:	412a8ab3          	sub	s5,s5,s2
    src += n;
    800016dc:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    800016de:	6485                	lui	s1,0x1
    800016e0:	94ce                	add	s1,s1,s3
  while (len > 0)
    800016e2:	040a8f63          	beqz	s5,80001740 <copyout+0xbe>
    va0 = PGROUNDDOWN(dstva);
    800016e6:	0184f9b3          	and	s3,s1,s8
    pa0 = walkaddr(pagetable, va0);
    800016ea:	85ce                	mv	a1,s3
    800016ec:	855e                	mv	a0,s7
    800016ee:	00000097          	auipc	ra,0x0
    800016f2:	996080e7          	jalr	-1642(ra) # 80001084 <walkaddr>
    800016f6:	8a2a                	mv	s4,a0
    if (pa0 == 0)
    800016f8:	ed05                	bnez	a0,80001730 <copyout+0xae>
      if (p->sz <= va0)
    800016fa:	048cb783          	ld	a5,72(s9)
    800016fe:	06f9f163          	bgeu	s3,a5,80001760 <copyout+0xde>
      char *mem = kalloc();
    80001702:	fffff097          	auipc	ra,0xfffff
    80001706:	40a080e7          	jalr	1034(ra) # 80000b0c <kalloc>
    8000170a:	892a                	mv	s2,a0
      if (mem == 0)
    8000170c:	cd21                	beqz	a0,80001764 <copyout+0xe2>
      memset(mem, 0, PGSIZE);
    8000170e:	6605                	lui	a2,0x1
    80001710:	4581                	li	a1,0
    80001712:	fffff097          	auipc	ra,0xfffff
    80001716:	5e6080e7          	jalr	1510(ra) # 80000cf8 <memset>
      if (mappages(pagetable, va0, PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0)
    8000171a:	8a4a                	mv	s4,s2
    8000171c:	4779                	li	a4,30
    8000171e:	86ca                	mv	a3,s2
    80001720:	6605                	lui	a2,0x1
    80001722:	85ce                	mv	a1,s3
    80001724:	855e                	mv	a0,s7
    80001726:	00000097          	auipc	ra,0x0
    8000172a:	9fe080e7          	jalr	-1538(ra) # 80001124 <mappages>
    8000172e:	f541                	bnez	a0,800016b6 <copyout+0x34>
    n = PGSIZE - (dstva - va0);
    80001730:	40998933          	sub	s2,s3,s1
    80001734:	6785                	lui	a5,0x1
    80001736:	993e                	add	s2,s2,a5
    80001738:	f92af6e3          	bgeu	s5,s2,800016c4 <copyout+0x42>
    8000173c:	8956                	mv	s2,s5
    8000173e:	b759                	j	800016c4 <copyout+0x42>
  }
  return 0;
    80001740:	4501                	li	a0,0
}
    80001742:	60e6                	ld	ra,88(sp)
    80001744:	6446                	ld	s0,80(sp)
    80001746:	64a6                	ld	s1,72(sp)
    80001748:	6906                	ld	s2,64(sp)
    8000174a:	79e2                	ld	s3,56(sp)
    8000174c:	7a42                	ld	s4,48(sp)
    8000174e:	7aa2                	ld	s5,40(sp)
    80001750:	7b02                	ld	s6,32(sp)
    80001752:	6be2                	ld	s7,24(sp)
    80001754:	6c42                	ld	s8,16(sp)
    80001756:	6ca2                	ld	s9,8(sp)
    80001758:	6125                	add	sp,sp,96
    8000175a:	8082                	ret
  return 0;
    8000175c:	4501                	li	a0,0
    8000175e:	b7d5                	j	80001742 <copyout+0xc0>
        return -1;
    80001760:	557d                	li	a0,-1
    80001762:	b7c5                	j	80001742 <copyout+0xc0>
        return -1;
    80001764:	557d                	li	a0,-1
    80001766:	bff1                	j	80001742 <copyout+0xc0>

0000000080001768 <copyin>:

// Copy from user to kernel.
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
    80001768:	711d                	add	sp,sp,-96
    8000176a:	ec86                	sd	ra,88(sp)
    8000176c:	e8a2                	sd	s0,80(sp)
    8000176e:	e4a6                	sd	s1,72(sp)
    80001770:	e0ca                	sd	s2,64(sp)
    80001772:	fc4e                	sd	s3,56(sp)
    80001774:	f852                	sd	s4,48(sp)
    80001776:	f456                	sd	s5,40(sp)
    80001778:	f05a                	sd	s6,32(sp)
    8000177a:	ec5e                	sd	s7,24(sp)
    8000177c:	e862                	sd	s8,16(sp)
    8000177e:	e466                	sd	s9,8(sp)
    80001780:	1080                	add	s0,sp,96
    80001782:	8baa                	mv	s7,a0
    80001784:	8b2e                	mv	s6,a1
    80001786:	84b2                	mv	s1,a2
    80001788:	8ab6                	mv	s5,a3
  uint64 n, va0, pa0;
  struct proc *p = myproc();
    8000178a:	00000097          	auipc	ra,0x0
    8000178e:	2b4080e7          	jalr	692(ra) # 80001a3e <myproc>
  while (len > 0)
    80001792:	0a0a8863          	beqz	s5,80001842 <copyin+0xda>
    80001796:	8caa                	mv	s9,a0
  {
    va0 = PGROUNDDOWN(srcva);
    80001798:	7c7d                	lui	s8,0xfffff
    8000179a:	a80d                	j	800017cc <copyin+0x64>
        return -1;
      }
      memset(mem, 0, PGSIZE);
      if (mappages(pagetable, va0, PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0)
      {
        kfree(mem);
    8000179c:	854a                	mv	a0,s2
    8000179e:	fffff097          	auipc	ra,0xfffff
    800017a2:	270080e7          	jalr	624(ra) # 80000a0e <kfree>
        return -1;
    800017a6:	557d                	li	a0,-1
    800017a8:	a041                	j	80001828 <copyin+0xc0>
      pa0 = (uint64)mem;
    }
    n = PGSIZE - (srcva - va0);
    if (n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800017aa:	413485b3          	sub	a1,s1,s3
    800017ae:	0009061b          	sext.w	a2,s2
    800017b2:	95d2                	add	a1,a1,s4
    800017b4:	855a                	mv	a0,s6
    800017b6:	fffff097          	auipc	ra,0xfffff
    800017ba:	59e080e7          	jalr	1438(ra) # 80000d54 <memmove>

    len -= n;
    800017be:	412a8ab3          	sub	s5,s5,s2
    dst += n;
    800017c2:	9b4a                	add	s6,s6,s2
    srcva = va0 + PGSIZE;
    800017c4:	6485                	lui	s1,0x1
    800017c6:	94ce                	add	s1,s1,s3
  while (len > 0)
    800017c8:	040a8f63          	beqz	s5,80001826 <copyin+0xbe>
    va0 = PGROUNDDOWN(srcva);
    800017cc:	0184f9b3          	and	s3,s1,s8
    pa0 = walkaddr(pagetable, va0);
    800017d0:	85ce                	mv	a1,s3
    800017d2:	855e                	mv	a0,s7
    800017d4:	00000097          	auipc	ra,0x0
    800017d8:	8b0080e7          	jalr	-1872(ra) # 80001084 <walkaddr>
    800017dc:	8a2a                	mv	s4,a0
    if (pa0 == 0)
    800017de:	ed05                	bnez	a0,80001816 <copyin+0xae>
      if (p->sz <= va0)
    800017e0:	048cb783          	ld	a5,72(s9)
    800017e4:	06f9f163          	bgeu	s3,a5,80001846 <copyin+0xde>
      char *mem = kalloc();
    800017e8:	fffff097          	auipc	ra,0xfffff
    800017ec:	324080e7          	jalr	804(ra) # 80000b0c <kalloc>
    800017f0:	892a                	mv	s2,a0
      if (mem == 0)
    800017f2:	cd21                	beqz	a0,8000184a <copyin+0xe2>
      memset(mem, 0, PGSIZE);
    800017f4:	6605                	lui	a2,0x1
    800017f6:	4581                	li	a1,0
    800017f8:	fffff097          	auipc	ra,0xfffff
    800017fc:	500080e7          	jalr	1280(ra) # 80000cf8 <memset>
      if (mappages(pagetable, va0, PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0)
    80001800:	8a4a                	mv	s4,s2
    80001802:	4779                	li	a4,30
    80001804:	86ca                	mv	a3,s2
    80001806:	6605                	lui	a2,0x1
    80001808:	85ce                	mv	a1,s3
    8000180a:	855e                	mv	a0,s7
    8000180c:	00000097          	auipc	ra,0x0
    80001810:	918080e7          	jalr	-1768(ra) # 80001124 <mappages>
    80001814:	f541                	bnez	a0,8000179c <copyin+0x34>
    n = PGSIZE - (srcva - va0);
    80001816:	40998933          	sub	s2,s3,s1
    8000181a:	6785                	lui	a5,0x1
    8000181c:	993e                	add	s2,s2,a5
    8000181e:	f92af6e3          	bgeu	s5,s2,800017aa <copyin+0x42>
    80001822:	8956                	mv	s2,s5
    80001824:	b759                	j	800017aa <copyin+0x42>
  }
  return 0;
    80001826:	4501                	li	a0,0
}
    80001828:	60e6                	ld	ra,88(sp)
    8000182a:	6446                	ld	s0,80(sp)
    8000182c:	64a6                	ld	s1,72(sp)
    8000182e:	6906                	ld	s2,64(sp)
    80001830:	79e2                	ld	s3,56(sp)
    80001832:	7a42                	ld	s4,48(sp)
    80001834:	7aa2                	ld	s5,40(sp)
    80001836:	7b02                	ld	s6,32(sp)
    80001838:	6be2                	ld	s7,24(sp)
    8000183a:	6c42                	ld	s8,16(sp)
    8000183c:	6ca2                	ld	s9,8(sp)
    8000183e:	6125                	add	sp,sp,96
    80001840:	8082                	ret
  return 0;
    80001842:	4501                	li	a0,0
    80001844:	b7d5                	j	80001828 <copyin+0xc0>
        return -1;
    80001846:	557d                	li	a0,-1
    80001848:	b7c5                	j	80001828 <copyin+0xc0>
        return -1;
    8000184a:	557d                	li	a0,-1
    8000184c:	bff1                	j	80001828 <copyin+0xc0>

000000008000184e <copyinstr>:
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0)
    8000184e:	c2dd                	beqz	a3,800018f4 <copyinstr+0xa6>
{
    80001850:	715d                	add	sp,sp,-80
    80001852:	e486                	sd	ra,72(sp)
    80001854:	e0a2                	sd	s0,64(sp)
    80001856:	fc26                	sd	s1,56(sp)
    80001858:	f84a                	sd	s2,48(sp)
    8000185a:	f44e                	sd	s3,40(sp)
    8000185c:	f052                	sd	s4,32(sp)
    8000185e:	ec56                	sd	s5,24(sp)
    80001860:	e85a                	sd	s6,16(sp)
    80001862:	e45e                	sd	s7,8(sp)
    80001864:	0880                	add	s0,sp,80
    80001866:	8a2a                	mv	s4,a0
    80001868:	8b2e                	mv	s6,a1
    8000186a:	8bb2                	mv	s7,a2
    8000186c:	84b6                	mv	s1,a3
  {
    va0 = PGROUNDDOWN(srcva);
    8000186e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001870:	6985                	lui	s3,0x1
    80001872:	a02d                	j	8000189c <copyinstr+0x4e>
    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0)
    {
      if (*p == '\0')
      {
        *dst = '\0';
    80001874:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001878:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null)
    8000187a:	37fd                	addw	a5,a5,-1
    8000187c:	0007851b          	sext.w	a0,a5
  }
  else
  {
    return -1;
  }
}
    80001880:	60a6                	ld	ra,72(sp)
    80001882:	6406                	ld	s0,64(sp)
    80001884:	74e2                	ld	s1,56(sp)
    80001886:	7942                	ld	s2,48(sp)
    80001888:	79a2                	ld	s3,40(sp)
    8000188a:	7a02                	ld	s4,32(sp)
    8000188c:	6ae2                	ld	s5,24(sp)
    8000188e:	6b42                	ld	s6,16(sp)
    80001890:	6ba2                	ld	s7,8(sp)
    80001892:	6161                	add	sp,sp,80
    80001894:	8082                	ret
    srcva = va0 + PGSIZE;
    80001896:	01390bb3          	add	s7,s2,s3
  while (got_null == 0 && max > 0)
    8000189a:	c8a9                	beqz	s1,800018ec <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    8000189c:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800018a0:	85ca                	mv	a1,s2
    800018a2:	8552                	mv	a0,s4
    800018a4:	fffff097          	auipc	ra,0xfffff
    800018a8:	7e0080e7          	jalr	2016(ra) # 80001084 <walkaddr>
    if (pa0 == 0)
    800018ac:	c131                	beqz	a0,800018f0 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    800018ae:	417906b3          	sub	a3,s2,s7
    800018b2:	96ce                	add	a3,a3,s3
    800018b4:	00d4f363          	bgeu	s1,a3,800018ba <copyinstr+0x6c>
    800018b8:	86a6                	mv	a3,s1
    char *p = (char *)(pa0 + (srcva - va0));
    800018ba:	955e                	add	a0,a0,s7
    800018bc:	41250533          	sub	a0,a0,s2
    while (n > 0)
    800018c0:	daf9                	beqz	a3,80001896 <copyinstr+0x48>
    800018c2:	87da                	mv	a5,s6
    800018c4:	885a                	mv	a6,s6
      if (*p == '\0')
    800018c6:	41650633          	sub	a2,a0,s6
    while (n > 0)
    800018ca:	96da                	add	a3,a3,s6
    800018cc:	85be                	mv	a1,a5
      if (*p == '\0')
    800018ce:	00f60733          	add	a4,a2,a5
    800018d2:	00074703          	lbu	a4,0(a4)
    800018d6:	df59                	beqz	a4,80001874 <copyinstr+0x26>
        *dst = *p;
    800018d8:	00e78023          	sb	a4,0(a5)
      dst++;
    800018dc:	0785                	add	a5,a5,1
    while (n > 0)
    800018de:	fed797e3          	bne	a5,a3,800018cc <copyinstr+0x7e>
    800018e2:	14fd                	add	s1,s1,-1 # fff <_entry-0x7ffff001>
    800018e4:	94c2                	add	s1,s1,a6
      --max;
    800018e6:	8c8d                	sub	s1,s1,a1
      dst++;
    800018e8:	8b3e                	mv	s6,a5
    800018ea:	b775                	j	80001896 <copyinstr+0x48>
    800018ec:	4781                	li	a5,0
    800018ee:	b771                	j	8000187a <copyinstr+0x2c>
      return -1;
    800018f0:	557d                	li	a0,-1
    800018f2:	b779                	j	80001880 <copyinstr+0x32>
  int got_null = 0;
    800018f4:	4781                	li	a5,0
  if (got_null)
    800018f6:	37fd                	addw	a5,a5,-1
    800018f8:	0007851b          	sext.w	a0,a5
}
    800018fc:	8082                	ret

00000000800018fe <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    800018fe:	1101                	add	sp,sp,-32
    80001900:	ec06                	sd	ra,24(sp)
    80001902:	e822                	sd	s0,16(sp)
    80001904:	e426                	sd	s1,8(sp)
    80001906:	1000                	add	s0,sp,32
    80001908:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000190a:	fffff097          	auipc	ra,0xfffff
    8000190e:	278080e7          	jalr	632(ra) # 80000b82 <holding>
    80001912:	c909                	beqz	a0,80001924 <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    80001914:	749c                	ld	a5,40(s1)
    80001916:	00978f63          	beq	a5,s1,80001934 <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    8000191a:	60e2                	ld	ra,24(sp)
    8000191c:	6442                	ld	s0,16(sp)
    8000191e:	64a2                	ld	s1,8(sp)
    80001920:	6105                	add	sp,sp,32
    80001922:	8082                	ret
    panic("wakeup1");
    80001924:	00007517          	auipc	a0,0x7
    80001928:	83c50513          	add	a0,a0,-1988 # 80008160 <digits+0x120>
    8000192c:	fffff097          	auipc	ra,0xfffff
    80001930:	c16080e7          	jalr	-1002(ra) # 80000542 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80001934:	4c98                	lw	a4,24(s1)
    80001936:	4785                	li	a5,1
    80001938:	fef711e3          	bne	a4,a5,8000191a <wakeup1+0x1c>
    p->state = RUNNABLE;
    8000193c:	4789                	li	a5,2
    8000193e:	cc9c                	sw	a5,24(s1)
}
    80001940:	bfe9                	j	8000191a <wakeup1+0x1c>

0000000080001942 <procinit>:
{
    80001942:	715d                	add	sp,sp,-80
    80001944:	e486                	sd	ra,72(sp)
    80001946:	e0a2                	sd	s0,64(sp)
    80001948:	fc26                	sd	s1,56(sp)
    8000194a:	f84a                	sd	s2,48(sp)
    8000194c:	f44e                	sd	s3,40(sp)
    8000194e:	f052                	sd	s4,32(sp)
    80001950:	ec56                	sd	s5,24(sp)
    80001952:	e85a                	sd	s6,16(sp)
    80001954:	e45e                	sd	s7,8(sp)
    80001956:	0880                	add	s0,sp,80
  initlock(&pid_lock, "nextpid");
    80001958:	00007597          	auipc	a1,0x7
    8000195c:	81058593          	add	a1,a1,-2032 # 80008168 <digits+0x128>
    80001960:	00010517          	auipc	a0,0x10
    80001964:	ff050513          	add	a0,a0,-16 # 80011950 <pid_lock>
    80001968:	fffff097          	auipc	ra,0xfffff
    8000196c:	204080e7          	jalr	516(ra) # 80000b6c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001970:	00010917          	auipc	s2,0x10
    80001974:	3f890913          	add	s2,s2,1016 # 80011d68 <proc>
      initlock(&p->lock, "proc");
    80001978:	00006b97          	auipc	s7,0x6
    8000197c:	7f8b8b93          	add	s7,s7,2040 # 80008170 <digits+0x130>
      uint64 va = KSTACK((int) (p - proc));
    80001980:	8b4a                	mv	s6,s2
    80001982:	00006a97          	auipc	s5,0x6
    80001986:	67ea8a93          	add	s5,s5,1662 # 80008000 <etext>
    8000198a:	040009b7          	lui	s3,0x4000
    8000198e:	19fd                	add	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001990:	09b2                	sll	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001992:	00016a17          	auipc	s4,0x16
    80001996:	dd6a0a13          	add	s4,s4,-554 # 80017768 <tickslock>
      initlock(&p->lock, "proc");
    8000199a:	85de                	mv	a1,s7
    8000199c:	854a                	mv	a0,s2
    8000199e:	fffff097          	auipc	ra,0xfffff
    800019a2:	1ce080e7          	jalr	462(ra) # 80000b6c <initlock>
      char *pa = kalloc();
    800019a6:	fffff097          	auipc	ra,0xfffff
    800019aa:	166080e7          	jalr	358(ra) # 80000b0c <kalloc>
    800019ae:	85aa                	mv	a1,a0
      if(pa == 0)
    800019b0:	c929                	beqz	a0,80001a02 <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc));
    800019b2:	416904b3          	sub	s1,s2,s6
    800019b6:	848d                	sra	s1,s1,0x3
    800019b8:	000ab783          	ld	a5,0(s5)
    800019bc:	02f484b3          	mul	s1,s1,a5
    800019c0:	2485                	addw	s1,s1,1
    800019c2:	00d4949b          	sllw	s1,s1,0xd
    800019c6:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800019ca:	4699                	li	a3,6
    800019cc:	6605                	lui	a2,0x1
    800019ce:	8526                	mv	a0,s1
    800019d0:	fffff097          	auipc	ra,0xfffff
    800019d4:	7e2080e7          	jalr	2018(ra) # 800011b2 <kvmmap>
      p->kstack = va;
    800019d8:	04993023          	sd	s1,64(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    800019dc:	16890913          	add	s2,s2,360
    800019e0:	fb491de3          	bne	s2,s4,8000199a <procinit+0x58>
  kvminithart();
    800019e4:	fffff097          	auipc	ra,0xfffff
    800019e8:	5d6080e7          	jalr	1494(ra) # 80000fba <kvminithart>
}
    800019ec:	60a6                	ld	ra,72(sp)
    800019ee:	6406                	ld	s0,64(sp)
    800019f0:	74e2                	ld	s1,56(sp)
    800019f2:	7942                	ld	s2,48(sp)
    800019f4:	79a2                	ld	s3,40(sp)
    800019f6:	7a02                	ld	s4,32(sp)
    800019f8:	6ae2                	ld	s5,24(sp)
    800019fa:	6b42                	ld	s6,16(sp)
    800019fc:	6ba2                	ld	s7,8(sp)
    800019fe:	6161                	add	sp,sp,80
    80001a00:	8082                	ret
        panic("kalloc");
    80001a02:	00006517          	auipc	a0,0x6
    80001a06:	77650513          	add	a0,a0,1910 # 80008178 <digits+0x138>
    80001a0a:	fffff097          	auipc	ra,0xfffff
    80001a0e:	b38080e7          	jalr	-1224(ra) # 80000542 <panic>

0000000080001a12 <cpuid>:
{
    80001a12:	1141                	add	sp,sp,-16
    80001a14:	e422                	sd	s0,8(sp)
    80001a16:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a18:	8512                	mv	a0,tp
}
    80001a1a:	2501                	sext.w	a0,a0
    80001a1c:	6422                	ld	s0,8(sp)
    80001a1e:	0141                	add	sp,sp,16
    80001a20:	8082                	ret

0000000080001a22 <mycpu>:
mycpu(void) {
    80001a22:	1141                	add	sp,sp,-16
    80001a24:	e422                	sd	s0,8(sp)
    80001a26:	0800                	add	s0,sp,16
    80001a28:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001a2a:	2781                	sext.w	a5,a5
    80001a2c:	079e                	sll	a5,a5,0x7
}
    80001a2e:	00010517          	auipc	a0,0x10
    80001a32:	f3a50513          	add	a0,a0,-198 # 80011968 <cpus>
    80001a36:	953e                	add	a0,a0,a5
    80001a38:	6422                	ld	s0,8(sp)
    80001a3a:	0141                	add	sp,sp,16
    80001a3c:	8082                	ret

0000000080001a3e <myproc>:
myproc(void) {
    80001a3e:	1101                	add	sp,sp,-32
    80001a40:	ec06                	sd	ra,24(sp)
    80001a42:	e822                	sd	s0,16(sp)
    80001a44:	e426                	sd	s1,8(sp)
    80001a46:	1000                	add	s0,sp,32
  push_off();
    80001a48:	fffff097          	auipc	ra,0xfffff
    80001a4c:	168080e7          	jalr	360(ra) # 80000bb0 <push_off>
    80001a50:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001a52:	2781                	sext.w	a5,a5
    80001a54:	079e                	sll	a5,a5,0x7
    80001a56:	00010717          	auipc	a4,0x10
    80001a5a:	efa70713          	add	a4,a4,-262 # 80011950 <pid_lock>
    80001a5e:	97ba                	add	a5,a5,a4
    80001a60:	6f84                	ld	s1,24(a5)
  pop_off();
    80001a62:	fffff097          	auipc	ra,0xfffff
    80001a66:	1ee080e7          	jalr	494(ra) # 80000c50 <pop_off>
}
    80001a6a:	8526                	mv	a0,s1
    80001a6c:	60e2                	ld	ra,24(sp)
    80001a6e:	6442                	ld	s0,16(sp)
    80001a70:	64a2                	ld	s1,8(sp)
    80001a72:	6105                	add	sp,sp,32
    80001a74:	8082                	ret

0000000080001a76 <forkret>:
{
    80001a76:	1141                	add	sp,sp,-16
    80001a78:	e406                	sd	ra,8(sp)
    80001a7a:	e022                	sd	s0,0(sp)
    80001a7c:	0800                	add	s0,sp,16
  release(&myproc()->lock);
    80001a7e:	00000097          	auipc	ra,0x0
    80001a82:	fc0080e7          	jalr	-64(ra) # 80001a3e <myproc>
    80001a86:	fffff097          	auipc	ra,0xfffff
    80001a8a:	22a080e7          	jalr	554(ra) # 80000cb0 <release>
  if (first) {
    80001a8e:	00007797          	auipc	a5,0x7
    80001a92:	d227a783          	lw	a5,-734(a5) # 800087b0 <first.1>
    80001a96:	eb89                	bnez	a5,80001aa8 <forkret+0x32>
  usertrapret();
    80001a98:	00001097          	auipc	ra,0x1
    80001a9c:	c1c080e7          	jalr	-996(ra) # 800026b4 <usertrapret>
}
    80001aa0:	60a2                	ld	ra,8(sp)
    80001aa2:	6402                	ld	s0,0(sp)
    80001aa4:	0141                	add	sp,sp,16
    80001aa6:	8082                	ret
    first = 0;
    80001aa8:	00007797          	auipc	a5,0x7
    80001aac:	d007a423          	sw	zero,-760(a5) # 800087b0 <first.1>
    fsinit(ROOTDEV);
    80001ab0:	4505                	li	a0,1
    80001ab2:	00002097          	auipc	ra,0x2
    80001ab6:	9d8080e7          	jalr	-1576(ra) # 8000348a <fsinit>
    80001aba:	bff9                	j	80001a98 <forkret+0x22>

0000000080001abc <allocpid>:
allocpid() {
    80001abc:	1101                	add	sp,sp,-32
    80001abe:	ec06                	sd	ra,24(sp)
    80001ac0:	e822                	sd	s0,16(sp)
    80001ac2:	e426                	sd	s1,8(sp)
    80001ac4:	e04a                	sd	s2,0(sp)
    80001ac6:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    80001ac8:	00010917          	auipc	s2,0x10
    80001acc:	e8890913          	add	s2,s2,-376 # 80011950 <pid_lock>
    80001ad0:	854a                	mv	a0,s2
    80001ad2:	fffff097          	auipc	ra,0xfffff
    80001ad6:	12a080e7          	jalr	298(ra) # 80000bfc <acquire>
  pid = nextpid;
    80001ada:	00007797          	auipc	a5,0x7
    80001ade:	cda78793          	add	a5,a5,-806 # 800087b4 <nextpid>
    80001ae2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001ae4:	0014871b          	addw	a4,s1,1
    80001ae8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001aea:	854a                	mv	a0,s2
    80001aec:	fffff097          	auipc	ra,0xfffff
    80001af0:	1c4080e7          	jalr	452(ra) # 80000cb0 <release>
}
    80001af4:	8526                	mv	a0,s1
    80001af6:	60e2                	ld	ra,24(sp)
    80001af8:	6442                	ld	s0,16(sp)
    80001afa:	64a2                	ld	s1,8(sp)
    80001afc:	6902                	ld	s2,0(sp)
    80001afe:	6105                	add	sp,sp,32
    80001b00:	8082                	ret

0000000080001b02 <proc_pagetable>:
{
    80001b02:	1101                	add	sp,sp,-32
    80001b04:	ec06                	sd	ra,24(sp)
    80001b06:	e822                	sd	s0,16(sp)
    80001b08:	e426                	sd	s1,8(sp)
    80001b0a:	e04a                	sd	s2,0(sp)
    80001b0c:	1000                	add	s0,sp,32
    80001b0e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001b10:	00000097          	auipc	ra,0x0
    80001b14:	852080e7          	jalr	-1966(ra) # 80001362 <uvmcreate>
    80001b18:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001b1a:	c121                	beqz	a0,80001b5a <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001b1c:	4729                	li	a4,10
    80001b1e:	00005697          	auipc	a3,0x5
    80001b22:	4e268693          	add	a3,a3,1250 # 80007000 <_trampoline>
    80001b26:	6605                	lui	a2,0x1
    80001b28:	040005b7          	lui	a1,0x4000
    80001b2c:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b2e:	05b2                	sll	a1,a1,0xc
    80001b30:	fffff097          	auipc	ra,0xfffff
    80001b34:	5f4080e7          	jalr	1524(ra) # 80001124 <mappages>
    80001b38:	02054863          	bltz	a0,80001b68 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b3c:	4719                	li	a4,6
    80001b3e:	05893683          	ld	a3,88(s2)
    80001b42:	6605                	lui	a2,0x1
    80001b44:	020005b7          	lui	a1,0x2000
    80001b48:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b4a:	05b6                	sll	a1,a1,0xd
    80001b4c:	8526                	mv	a0,s1
    80001b4e:	fffff097          	auipc	ra,0xfffff
    80001b52:	5d6080e7          	jalr	1494(ra) # 80001124 <mappages>
    80001b56:	02054163          	bltz	a0,80001b78 <proc_pagetable+0x76>
}
    80001b5a:	8526                	mv	a0,s1
    80001b5c:	60e2                	ld	ra,24(sp)
    80001b5e:	6442                	ld	s0,16(sp)
    80001b60:	64a2                	ld	s1,8(sp)
    80001b62:	6902                	ld	s2,0(sp)
    80001b64:	6105                	add	sp,sp,32
    80001b66:	8082                	ret
    uvmfree(pagetable, 0);
    80001b68:	4581                	li	a1,0
    80001b6a:	8526                	mv	a0,s1
    80001b6c:	00000097          	auipc	ra,0x0
    80001b70:	9f4080e7          	jalr	-1548(ra) # 80001560 <uvmfree>
    return 0;
    80001b74:	4481                	li	s1,0
    80001b76:	b7d5                	j	80001b5a <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b78:	4681                	li	a3,0
    80001b7a:	4605                	li	a2,1
    80001b7c:	040005b7          	lui	a1,0x4000
    80001b80:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b82:	05b2                	sll	a1,a1,0xc
    80001b84:	8526                	mv	a0,s1
    80001b86:	fffff097          	auipc	ra,0xfffff
    80001b8a:	736080e7          	jalr	1846(ra) # 800012bc <uvmunmap>
    uvmfree(pagetable, 0);
    80001b8e:	4581                	li	a1,0
    80001b90:	8526                	mv	a0,s1
    80001b92:	00000097          	auipc	ra,0x0
    80001b96:	9ce080e7          	jalr	-1586(ra) # 80001560 <uvmfree>
    return 0;
    80001b9a:	4481                	li	s1,0
    80001b9c:	bf7d                	j	80001b5a <proc_pagetable+0x58>

0000000080001b9e <proc_freepagetable>:
{
    80001b9e:	1101                	add	sp,sp,-32
    80001ba0:	ec06                	sd	ra,24(sp)
    80001ba2:	e822                	sd	s0,16(sp)
    80001ba4:	e426                	sd	s1,8(sp)
    80001ba6:	e04a                	sd	s2,0(sp)
    80001ba8:	1000                	add	s0,sp,32
    80001baa:	84aa                	mv	s1,a0
    80001bac:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001bae:	4681                	li	a3,0
    80001bb0:	4605                	li	a2,1
    80001bb2:	040005b7          	lui	a1,0x4000
    80001bb6:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001bb8:	05b2                	sll	a1,a1,0xc
    80001bba:	fffff097          	auipc	ra,0xfffff
    80001bbe:	702080e7          	jalr	1794(ra) # 800012bc <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001bc2:	4681                	li	a3,0
    80001bc4:	4605                	li	a2,1
    80001bc6:	020005b7          	lui	a1,0x2000
    80001bca:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001bcc:	05b6                	sll	a1,a1,0xd
    80001bce:	8526                	mv	a0,s1
    80001bd0:	fffff097          	auipc	ra,0xfffff
    80001bd4:	6ec080e7          	jalr	1772(ra) # 800012bc <uvmunmap>
  uvmfree(pagetable, sz);
    80001bd8:	85ca                	mv	a1,s2
    80001bda:	8526                	mv	a0,s1
    80001bdc:	00000097          	auipc	ra,0x0
    80001be0:	984080e7          	jalr	-1660(ra) # 80001560 <uvmfree>
}
    80001be4:	60e2                	ld	ra,24(sp)
    80001be6:	6442                	ld	s0,16(sp)
    80001be8:	64a2                	ld	s1,8(sp)
    80001bea:	6902                	ld	s2,0(sp)
    80001bec:	6105                	add	sp,sp,32
    80001bee:	8082                	ret

0000000080001bf0 <freeproc>:
{
    80001bf0:	1101                	add	sp,sp,-32
    80001bf2:	ec06                	sd	ra,24(sp)
    80001bf4:	e822                	sd	s0,16(sp)
    80001bf6:	e426                	sd	s1,8(sp)
    80001bf8:	1000                	add	s0,sp,32
    80001bfa:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001bfc:	6d28                	ld	a0,88(a0)
    80001bfe:	c509                	beqz	a0,80001c08 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001c00:	fffff097          	auipc	ra,0xfffff
    80001c04:	e0e080e7          	jalr	-498(ra) # 80000a0e <kfree>
  p->trapframe = 0;
    80001c08:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001c0c:	68a8                	ld	a0,80(s1)
    80001c0e:	c511                	beqz	a0,80001c1a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001c10:	64ac                	ld	a1,72(s1)
    80001c12:	00000097          	auipc	ra,0x0
    80001c16:	f8c080e7          	jalr	-116(ra) # 80001b9e <proc_freepagetable>
  p->pagetable = 0;
    80001c1a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001c1e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001c22:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001c26:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001c2a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001c2e:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001c32:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001c36:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001c3a:	0004ac23          	sw	zero,24(s1)
}
    80001c3e:	60e2                	ld	ra,24(sp)
    80001c40:	6442                	ld	s0,16(sp)
    80001c42:	64a2                	ld	s1,8(sp)
    80001c44:	6105                	add	sp,sp,32
    80001c46:	8082                	ret

0000000080001c48 <allocproc>:
{
    80001c48:	1101                	add	sp,sp,-32
    80001c4a:	ec06                	sd	ra,24(sp)
    80001c4c:	e822                	sd	s0,16(sp)
    80001c4e:	e426                	sd	s1,8(sp)
    80001c50:	e04a                	sd	s2,0(sp)
    80001c52:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c54:	00010497          	auipc	s1,0x10
    80001c58:	11448493          	add	s1,s1,276 # 80011d68 <proc>
    80001c5c:	00016917          	auipc	s2,0x16
    80001c60:	b0c90913          	add	s2,s2,-1268 # 80017768 <tickslock>
    acquire(&p->lock);
    80001c64:	8526                	mv	a0,s1
    80001c66:	fffff097          	auipc	ra,0xfffff
    80001c6a:	f96080e7          	jalr	-106(ra) # 80000bfc <acquire>
    if(p->state == UNUSED) {
    80001c6e:	4c9c                	lw	a5,24(s1)
    80001c70:	cf81                	beqz	a5,80001c88 <allocproc+0x40>
      release(&p->lock);
    80001c72:	8526                	mv	a0,s1
    80001c74:	fffff097          	auipc	ra,0xfffff
    80001c78:	03c080e7          	jalr	60(ra) # 80000cb0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c7c:	16848493          	add	s1,s1,360
    80001c80:	ff2492e3          	bne	s1,s2,80001c64 <allocproc+0x1c>
  return 0;
    80001c84:	4481                	li	s1,0
    80001c86:	a0b9                	j	80001cd4 <allocproc+0x8c>
  p->pid = allocpid();
    80001c88:	00000097          	auipc	ra,0x0
    80001c8c:	e34080e7          	jalr	-460(ra) # 80001abc <allocpid>
    80001c90:	dc88                	sw	a0,56(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c92:	fffff097          	auipc	ra,0xfffff
    80001c96:	e7a080e7          	jalr	-390(ra) # 80000b0c <kalloc>
    80001c9a:	892a                	mv	s2,a0
    80001c9c:	eca8                	sd	a0,88(s1)
    80001c9e:	c131                	beqz	a0,80001ce2 <allocproc+0x9a>
  p->pagetable = proc_pagetable(p);
    80001ca0:	8526                	mv	a0,s1
    80001ca2:	00000097          	auipc	ra,0x0
    80001ca6:	e60080e7          	jalr	-416(ra) # 80001b02 <proc_pagetable>
    80001caa:	892a                	mv	s2,a0
    80001cac:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001cae:	c129                	beqz	a0,80001cf0 <allocproc+0xa8>
  memset(&p->context, 0, sizeof(p->context));
    80001cb0:	07000613          	li	a2,112
    80001cb4:	4581                	li	a1,0
    80001cb6:	06048513          	add	a0,s1,96
    80001cba:	fffff097          	auipc	ra,0xfffff
    80001cbe:	03e080e7          	jalr	62(ra) # 80000cf8 <memset>
  p->context.ra = (uint64)forkret;
    80001cc2:	00000797          	auipc	a5,0x0
    80001cc6:	db478793          	add	a5,a5,-588 # 80001a76 <forkret>
    80001cca:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001ccc:	60bc                	ld	a5,64(s1)
    80001cce:	6705                	lui	a4,0x1
    80001cd0:	97ba                	add	a5,a5,a4
    80001cd2:	f4bc                	sd	a5,104(s1)
}
    80001cd4:	8526                	mv	a0,s1
    80001cd6:	60e2                	ld	ra,24(sp)
    80001cd8:	6442                	ld	s0,16(sp)
    80001cda:	64a2                	ld	s1,8(sp)
    80001cdc:	6902                	ld	s2,0(sp)
    80001cde:	6105                	add	sp,sp,32
    80001ce0:	8082                	ret
    release(&p->lock);
    80001ce2:	8526                	mv	a0,s1
    80001ce4:	fffff097          	auipc	ra,0xfffff
    80001ce8:	fcc080e7          	jalr	-52(ra) # 80000cb0 <release>
    return 0;
    80001cec:	84ca                	mv	s1,s2
    80001cee:	b7dd                	j	80001cd4 <allocproc+0x8c>
    freeproc(p);
    80001cf0:	8526                	mv	a0,s1
    80001cf2:	00000097          	auipc	ra,0x0
    80001cf6:	efe080e7          	jalr	-258(ra) # 80001bf0 <freeproc>
    release(&p->lock);
    80001cfa:	8526                	mv	a0,s1
    80001cfc:	fffff097          	auipc	ra,0xfffff
    80001d00:	fb4080e7          	jalr	-76(ra) # 80000cb0 <release>
    return 0;
    80001d04:	84ca                	mv	s1,s2
    80001d06:	b7f9                	j	80001cd4 <allocproc+0x8c>

0000000080001d08 <userinit>:
{
    80001d08:	1101                	add	sp,sp,-32
    80001d0a:	ec06                	sd	ra,24(sp)
    80001d0c:	e822                	sd	s0,16(sp)
    80001d0e:	e426                	sd	s1,8(sp)
    80001d10:	1000                	add	s0,sp,32
  p = allocproc();
    80001d12:	00000097          	auipc	ra,0x0
    80001d16:	f36080e7          	jalr	-202(ra) # 80001c48 <allocproc>
    80001d1a:	84aa                	mv	s1,a0
  initproc = p;
    80001d1c:	00007797          	auipc	a5,0x7
    80001d20:	2ea7be23          	sd	a0,764(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001d24:	03400613          	li	a2,52
    80001d28:	00007597          	auipc	a1,0x7
    80001d2c:	a9858593          	add	a1,a1,-1384 # 800087c0 <initcode>
    80001d30:	6928                	ld	a0,80(a0)
    80001d32:	fffff097          	auipc	ra,0xfffff
    80001d36:	65e080e7          	jalr	1630(ra) # 80001390 <uvminit>
  p->sz = PGSIZE;
    80001d3a:	6785                	lui	a5,0x1
    80001d3c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001d3e:	6cb8                	ld	a4,88(s1)
    80001d40:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001d44:	6cb8                	ld	a4,88(s1)
    80001d46:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d48:	4641                	li	a2,16
    80001d4a:	00006597          	auipc	a1,0x6
    80001d4e:	43658593          	add	a1,a1,1078 # 80008180 <digits+0x140>
    80001d52:	15848513          	add	a0,s1,344
    80001d56:	fffff097          	auipc	ra,0xfffff
    80001d5a:	0f2080e7          	jalr	242(ra) # 80000e48 <safestrcpy>
  p->cwd = namei("/");
    80001d5e:	00006517          	auipc	a0,0x6
    80001d62:	43250513          	add	a0,a0,1074 # 80008190 <digits+0x150>
    80001d66:	00002097          	auipc	ra,0x2
    80001d6a:	14c080e7          	jalr	332(ra) # 80003eb2 <namei>
    80001d6e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001d72:	4789                	li	a5,2
    80001d74:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d76:	8526                	mv	a0,s1
    80001d78:	fffff097          	auipc	ra,0xfffff
    80001d7c:	f38080e7          	jalr	-200(ra) # 80000cb0 <release>
}
    80001d80:	60e2                	ld	ra,24(sp)
    80001d82:	6442                	ld	s0,16(sp)
    80001d84:	64a2                	ld	s1,8(sp)
    80001d86:	6105                	add	sp,sp,32
    80001d88:	8082                	ret

0000000080001d8a <growproc>:
{
    80001d8a:	1101                	add	sp,sp,-32
    80001d8c:	ec06                	sd	ra,24(sp)
    80001d8e:	e822                	sd	s0,16(sp)
    80001d90:	e426                	sd	s1,8(sp)
    80001d92:	e04a                	sd	s2,0(sp)
    80001d94:	1000                	add	s0,sp,32
    80001d96:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d98:	00000097          	auipc	ra,0x0
    80001d9c:	ca6080e7          	jalr	-858(ra) # 80001a3e <myproc>
    80001da0:	892a                	mv	s2,a0
  sz = p->sz;
    80001da2:	652c                	ld	a1,72(a0)
    80001da4:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001da8:	00904f63          	bgtz	s1,80001dc6 <growproc+0x3c>
  } else if(n < 0){
    80001dac:	0204cd63          	bltz	s1,80001de6 <growproc+0x5c>
  p->sz = sz;
    80001db0:	1782                	sll	a5,a5,0x20
    80001db2:	9381                	srl	a5,a5,0x20
    80001db4:	04f93423          	sd	a5,72(s2)
  return 0;
    80001db8:	4501                	li	a0,0
}
    80001dba:	60e2                	ld	ra,24(sp)
    80001dbc:	6442                	ld	s0,16(sp)
    80001dbe:	64a2                	ld	s1,8(sp)
    80001dc0:	6902                	ld	s2,0(sp)
    80001dc2:	6105                	add	sp,sp,32
    80001dc4:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001dc6:	00f4863b          	addw	a2,s1,a5
    80001dca:	1602                	sll	a2,a2,0x20
    80001dcc:	9201                	srl	a2,a2,0x20
    80001dce:	1582                	sll	a1,a1,0x20
    80001dd0:	9181                	srl	a1,a1,0x20
    80001dd2:	6928                	ld	a0,80(a0)
    80001dd4:	fffff097          	auipc	ra,0xfffff
    80001dd8:	676080e7          	jalr	1654(ra) # 8000144a <uvmalloc>
    80001ddc:	0005079b          	sext.w	a5,a0
    80001de0:	fbe1                	bnez	a5,80001db0 <growproc+0x26>
      return -1;
    80001de2:	557d                	li	a0,-1
    80001de4:	bfd9                	j	80001dba <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001de6:	00f4863b          	addw	a2,s1,a5
    80001dea:	1602                	sll	a2,a2,0x20
    80001dec:	9201                	srl	a2,a2,0x20
    80001dee:	1582                	sll	a1,a1,0x20
    80001df0:	9181                	srl	a1,a1,0x20
    80001df2:	6928                	ld	a0,80(a0)
    80001df4:	fffff097          	auipc	ra,0xfffff
    80001df8:	60e080e7          	jalr	1550(ra) # 80001402 <uvmdealloc>
    80001dfc:	0005079b          	sext.w	a5,a0
    80001e00:	bf45                	j	80001db0 <growproc+0x26>

0000000080001e02 <fork>:
{
    80001e02:	7139                	add	sp,sp,-64
    80001e04:	fc06                	sd	ra,56(sp)
    80001e06:	f822                	sd	s0,48(sp)
    80001e08:	f426                	sd	s1,40(sp)
    80001e0a:	f04a                	sd	s2,32(sp)
    80001e0c:	ec4e                	sd	s3,24(sp)
    80001e0e:	e852                	sd	s4,16(sp)
    80001e10:	e456                	sd	s5,8(sp)
    80001e12:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001e14:	00000097          	auipc	ra,0x0
    80001e18:	c2a080e7          	jalr	-982(ra) # 80001a3e <myproc>
    80001e1c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001e1e:	00000097          	auipc	ra,0x0
    80001e22:	e2a080e7          	jalr	-470(ra) # 80001c48 <allocproc>
    80001e26:	c17d                	beqz	a0,80001f0c <fork+0x10a>
    80001e28:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001e2a:	048ab603          	ld	a2,72(s5)
    80001e2e:	692c                	ld	a1,80(a0)
    80001e30:	050ab503          	ld	a0,80(s5)
    80001e34:	fffff097          	auipc	ra,0xfffff
    80001e38:	766080e7          	jalr	1894(ra) # 8000159a <uvmcopy>
    80001e3c:	04054a63          	bltz	a0,80001e90 <fork+0x8e>
  np->sz = p->sz;
    80001e40:	048ab783          	ld	a5,72(s5)
    80001e44:	04fa3423          	sd	a5,72(s4)
  np->parent = p;
    80001e48:	035a3023          	sd	s5,32(s4)
  *(np->trapframe) = *(p->trapframe);
    80001e4c:	058ab683          	ld	a3,88(s5)
    80001e50:	87b6                	mv	a5,a3
    80001e52:	058a3703          	ld	a4,88(s4)
    80001e56:	12068693          	add	a3,a3,288
    80001e5a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001e5e:	6788                	ld	a0,8(a5)
    80001e60:	6b8c                	ld	a1,16(a5)
    80001e62:	6f90                	ld	a2,24(a5)
    80001e64:	01073023          	sd	a6,0(a4)
    80001e68:	e708                	sd	a0,8(a4)
    80001e6a:	eb0c                	sd	a1,16(a4)
    80001e6c:	ef10                	sd	a2,24(a4)
    80001e6e:	02078793          	add	a5,a5,32
    80001e72:	02070713          	add	a4,a4,32
    80001e76:	fed792e3          	bne	a5,a3,80001e5a <fork+0x58>
  np->trapframe->a0 = 0;
    80001e7a:	058a3783          	ld	a5,88(s4)
    80001e7e:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001e82:	0d0a8493          	add	s1,s5,208
    80001e86:	0d0a0913          	add	s2,s4,208
    80001e8a:	150a8993          	add	s3,s5,336
    80001e8e:	a00d                	j	80001eb0 <fork+0xae>
    freeproc(np);
    80001e90:	8552                	mv	a0,s4
    80001e92:	00000097          	auipc	ra,0x0
    80001e96:	d5e080e7          	jalr	-674(ra) # 80001bf0 <freeproc>
    release(&np->lock);
    80001e9a:	8552                	mv	a0,s4
    80001e9c:	fffff097          	auipc	ra,0xfffff
    80001ea0:	e14080e7          	jalr	-492(ra) # 80000cb0 <release>
    return -1;
    80001ea4:	54fd                	li	s1,-1
    80001ea6:	a889                	j	80001ef8 <fork+0xf6>
  for(i = 0; i < NOFILE; i++)
    80001ea8:	04a1                	add	s1,s1,8
    80001eaa:	0921                	add	s2,s2,8
    80001eac:	01348b63          	beq	s1,s3,80001ec2 <fork+0xc0>
    if(p->ofile[i])
    80001eb0:	6088                	ld	a0,0(s1)
    80001eb2:	d97d                	beqz	a0,80001ea8 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001eb4:	00002097          	auipc	ra,0x2
    80001eb8:	666080e7          	jalr	1638(ra) # 8000451a <filedup>
    80001ebc:	00a93023          	sd	a0,0(s2)
    80001ec0:	b7e5                	j	80001ea8 <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001ec2:	150ab503          	ld	a0,336(s5)
    80001ec6:	00001097          	auipc	ra,0x1
    80001eca:	7fa080e7          	jalr	2042(ra) # 800036c0 <idup>
    80001ece:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001ed2:	4641                	li	a2,16
    80001ed4:	158a8593          	add	a1,s5,344
    80001ed8:	158a0513          	add	a0,s4,344
    80001edc:	fffff097          	auipc	ra,0xfffff
    80001ee0:	f6c080e7          	jalr	-148(ra) # 80000e48 <safestrcpy>
  pid = np->pid;
    80001ee4:	038a2483          	lw	s1,56(s4)
  np->state = RUNNABLE;
    80001ee8:	4789                	li	a5,2
    80001eea:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001eee:	8552                	mv	a0,s4
    80001ef0:	fffff097          	auipc	ra,0xfffff
    80001ef4:	dc0080e7          	jalr	-576(ra) # 80000cb0 <release>
}
    80001ef8:	8526                	mv	a0,s1
    80001efa:	70e2                	ld	ra,56(sp)
    80001efc:	7442                	ld	s0,48(sp)
    80001efe:	74a2                	ld	s1,40(sp)
    80001f00:	7902                	ld	s2,32(sp)
    80001f02:	69e2                	ld	s3,24(sp)
    80001f04:	6a42                	ld	s4,16(sp)
    80001f06:	6aa2                	ld	s5,8(sp)
    80001f08:	6121                	add	sp,sp,64
    80001f0a:	8082                	ret
    return -1;
    80001f0c:	54fd                	li	s1,-1
    80001f0e:	b7ed                	j	80001ef8 <fork+0xf6>

0000000080001f10 <reparent>:
{
    80001f10:	7179                	add	sp,sp,-48
    80001f12:	f406                	sd	ra,40(sp)
    80001f14:	f022                	sd	s0,32(sp)
    80001f16:	ec26                	sd	s1,24(sp)
    80001f18:	e84a                	sd	s2,16(sp)
    80001f1a:	e44e                	sd	s3,8(sp)
    80001f1c:	e052                	sd	s4,0(sp)
    80001f1e:	1800                	add	s0,sp,48
    80001f20:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f22:	00010497          	auipc	s1,0x10
    80001f26:	e4648493          	add	s1,s1,-442 # 80011d68 <proc>
      pp->parent = initproc;
    80001f2a:	00007a17          	auipc	s4,0x7
    80001f2e:	0eea0a13          	add	s4,s4,238 # 80009018 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f32:	00016997          	auipc	s3,0x16
    80001f36:	83698993          	add	s3,s3,-1994 # 80017768 <tickslock>
    80001f3a:	a029                	j	80001f44 <reparent+0x34>
    80001f3c:	16848493          	add	s1,s1,360
    80001f40:	03348363          	beq	s1,s3,80001f66 <reparent+0x56>
    if(pp->parent == p){
    80001f44:	709c                	ld	a5,32(s1)
    80001f46:	ff279be3          	bne	a5,s2,80001f3c <reparent+0x2c>
      acquire(&pp->lock);
    80001f4a:	8526                	mv	a0,s1
    80001f4c:	fffff097          	auipc	ra,0xfffff
    80001f50:	cb0080e7          	jalr	-848(ra) # 80000bfc <acquire>
      pp->parent = initproc;
    80001f54:	000a3783          	ld	a5,0(s4)
    80001f58:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80001f5a:	8526                	mv	a0,s1
    80001f5c:	fffff097          	auipc	ra,0xfffff
    80001f60:	d54080e7          	jalr	-684(ra) # 80000cb0 <release>
    80001f64:	bfe1                	j	80001f3c <reparent+0x2c>
}
    80001f66:	70a2                	ld	ra,40(sp)
    80001f68:	7402                	ld	s0,32(sp)
    80001f6a:	64e2                	ld	s1,24(sp)
    80001f6c:	6942                	ld	s2,16(sp)
    80001f6e:	69a2                	ld	s3,8(sp)
    80001f70:	6a02                	ld	s4,0(sp)
    80001f72:	6145                	add	sp,sp,48
    80001f74:	8082                	ret

0000000080001f76 <scheduler>:
{
    80001f76:	715d                	add	sp,sp,-80
    80001f78:	e486                	sd	ra,72(sp)
    80001f7a:	e0a2                	sd	s0,64(sp)
    80001f7c:	fc26                	sd	s1,56(sp)
    80001f7e:	f84a                	sd	s2,48(sp)
    80001f80:	f44e                	sd	s3,40(sp)
    80001f82:	f052                	sd	s4,32(sp)
    80001f84:	ec56                	sd	s5,24(sp)
    80001f86:	e85a                	sd	s6,16(sp)
    80001f88:	e45e                	sd	s7,8(sp)
    80001f8a:	e062                	sd	s8,0(sp)
    80001f8c:	0880                	add	s0,sp,80
    80001f8e:	8792                	mv	a5,tp
  int id = r_tp();
    80001f90:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001f92:	00779b93          	sll	s7,a5,0x7
    80001f96:	00010717          	auipc	a4,0x10
    80001f9a:	9ba70713          	add	a4,a4,-1606 # 80011950 <pid_lock>
    80001f9e:	975e                	add	a4,a4,s7
    80001fa0:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    80001fa4:	00010717          	auipc	a4,0x10
    80001fa8:	9cc70713          	add	a4,a4,-1588 # 80011970 <cpus+0x8>
    80001fac:	9bba                	add	s7,s7,a4
    int nproc = 0;
    80001fae:	4c01                	li	s8,0
      if(p->state == RUNNABLE) {
    80001fb0:	4a09                	li	s4,2
        c->proc = p;
    80001fb2:	079e                	sll	a5,a5,0x7
    80001fb4:	00010a97          	auipc	s5,0x10
    80001fb8:	99ca8a93          	add	s5,s5,-1636 # 80011950 <pid_lock>
    80001fbc:	9abe                	add	s5,s5,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fbe:	00015997          	auipc	s3,0x15
    80001fc2:	7aa98993          	add	s3,s3,1962 # 80017768 <tickslock>
    80001fc6:	a8a1                	j	8000201e <scheduler+0xa8>
      release(&p->lock);
    80001fc8:	8526                	mv	a0,s1
    80001fca:	fffff097          	auipc	ra,0xfffff
    80001fce:	ce6080e7          	jalr	-794(ra) # 80000cb0 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fd2:	16848493          	add	s1,s1,360
    80001fd6:	03348a63          	beq	s1,s3,8000200a <scheduler+0x94>
      acquire(&p->lock);
    80001fda:	8526                	mv	a0,s1
    80001fdc:	fffff097          	auipc	ra,0xfffff
    80001fe0:	c20080e7          	jalr	-992(ra) # 80000bfc <acquire>
      if(p->state != UNUSED) {
    80001fe4:	4c9c                	lw	a5,24(s1)
    80001fe6:	d3ed                	beqz	a5,80001fc8 <scheduler+0x52>
        nproc++;
    80001fe8:	2905                	addw	s2,s2,1
      if(p->state == RUNNABLE) {
    80001fea:	fd479fe3          	bne	a5,s4,80001fc8 <scheduler+0x52>
        p->state = RUNNING;
    80001fee:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001ff2:	009abc23          	sd	s1,24(s5)
        swtch(&c->context, &p->context);
    80001ff6:	06048593          	add	a1,s1,96
    80001ffa:	855e                	mv	a0,s7
    80001ffc:	00000097          	auipc	ra,0x0
    80002000:	60e080e7          	jalr	1550(ra) # 8000260a <swtch>
        c->proc = 0;
    80002004:	000abc23          	sd	zero,24(s5)
    80002008:	b7c1                	j	80001fc8 <scheduler+0x52>
    if(nproc <= 2) {   // only init and sh exist
    8000200a:	012a4a63          	blt	s4,s2,8000201e <scheduler+0xa8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000200e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002012:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002016:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    8000201a:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000201e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002022:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002026:	10079073          	csrw	sstatus,a5
    int nproc = 0;
    8000202a:	8962                	mv	s2,s8
    for(p = proc; p < &proc[NPROC]; p++) {
    8000202c:	00010497          	auipc	s1,0x10
    80002030:	d3c48493          	add	s1,s1,-708 # 80011d68 <proc>
        p->state = RUNNING;
    80002034:	4b0d                	li	s6,3
    80002036:	b755                	j	80001fda <scheduler+0x64>

0000000080002038 <sched>:
{
    80002038:	7179                	add	sp,sp,-48
    8000203a:	f406                	sd	ra,40(sp)
    8000203c:	f022                	sd	s0,32(sp)
    8000203e:	ec26                	sd	s1,24(sp)
    80002040:	e84a                	sd	s2,16(sp)
    80002042:	e44e                	sd	s3,8(sp)
    80002044:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    80002046:	00000097          	auipc	ra,0x0
    8000204a:	9f8080e7          	jalr	-1544(ra) # 80001a3e <myproc>
    8000204e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002050:	fffff097          	auipc	ra,0xfffff
    80002054:	b32080e7          	jalr	-1230(ra) # 80000b82 <holding>
    80002058:	c93d                	beqz	a0,800020ce <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000205a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000205c:	2781                	sext.w	a5,a5
    8000205e:	079e                	sll	a5,a5,0x7
    80002060:	00010717          	auipc	a4,0x10
    80002064:	8f070713          	add	a4,a4,-1808 # 80011950 <pid_lock>
    80002068:	97ba                	add	a5,a5,a4
    8000206a:	0907a703          	lw	a4,144(a5)
    8000206e:	4785                	li	a5,1
    80002070:	06f71763          	bne	a4,a5,800020de <sched+0xa6>
  if(p->state == RUNNING)
    80002074:	4c98                	lw	a4,24(s1)
    80002076:	478d                	li	a5,3
    80002078:	06f70b63          	beq	a4,a5,800020ee <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000207c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002080:	8b89                	and	a5,a5,2
  if(intr_get())
    80002082:	efb5                	bnez	a5,800020fe <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002084:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002086:	00010917          	auipc	s2,0x10
    8000208a:	8ca90913          	add	s2,s2,-1846 # 80011950 <pid_lock>
    8000208e:	2781                	sext.w	a5,a5
    80002090:	079e                	sll	a5,a5,0x7
    80002092:	97ca                	add	a5,a5,s2
    80002094:	0947a983          	lw	s3,148(a5)
    80002098:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000209a:	2781                	sext.w	a5,a5
    8000209c:	079e                	sll	a5,a5,0x7
    8000209e:	00010597          	auipc	a1,0x10
    800020a2:	8d258593          	add	a1,a1,-1838 # 80011970 <cpus+0x8>
    800020a6:	95be                	add	a1,a1,a5
    800020a8:	06048513          	add	a0,s1,96
    800020ac:	00000097          	auipc	ra,0x0
    800020b0:	55e080e7          	jalr	1374(ra) # 8000260a <swtch>
    800020b4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800020b6:	2781                	sext.w	a5,a5
    800020b8:	079e                	sll	a5,a5,0x7
    800020ba:	993e                	add	s2,s2,a5
    800020bc:	09392a23          	sw	s3,148(s2)
}
    800020c0:	70a2                	ld	ra,40(sp)
    800020c2:	7402                	ld	s0,32(sp)
    800020c4:	64e2                	ld	s1,24(sp)
    800020c6:	6942                	ld	s2,16(sp)
    800020c8:	69a2                	ld	s3,8(sp)
    800020ca:	6145                	add	sp,sp,48
    800020cc:	8082                	ret
    panic("sched p->lock");
    800020ce:	00006517          	auipc	a0,0x6
    800020d2:	0ca50513          	add	a0,a0,202 # 80008198 <digits+0x158>
    800020d6:	ffffe097          	auipc	ra,0xffffe
    800020da:	46c080e7          	jalr	1132(ra) # 80000542 <panic>
    panic("sched locks");
    800020de:	00006517          	auipc	a0,0x6
    800020e2:	0ca50513          	add	a0,a0,202 # 800081a8 <digits+0x168>
    800020e6:	ffffe097          	auipc	ra,0xffffe
    800020ea:	45c080e7          	jalr	1116(ra) # 80000542 <panic>
    panic("sched running");
    800020ee:	00006517          	auipc	a0,0x6
    800020f2:	0ca50513          	add	a0,a0,202 # 800081b8 <digits+0x178>
    800020f6:	ffffe097          	auipc	ra,0xffffe
    800020fa:	44c080e7          	jalr	1100(ra) # 80000542 <panic>
    panic("sched interruptible");
    800020fe:	00006517          	auipc	a0,0x6
    80002102:	0ca50513          	add	a0,a0,202 # 800081c8 <digits+0x188>
    80002106:	ffffe097          	auipc	ra,0xffffe
    8000210a:	43c080e7          	jalr	1084(ra) # 80000542 <panic>

000000008000210e <exit>:
{
    8000210e:	7179                	add	sp,sp,-48
    80002110:	f406                	sd	ra,40(sp)
    80002112:	f022                	sd	s0,32(sp)
    80002114:	ec26                	sd	s1,24(sp)
    80002116:	e84a                	sd	s2,16(sp)
    80002118:	e44e                	sd	s3,8(sp)
    8000211a:	e052                	sd	s4,0(sp)
    8000211c:	1800                	add	s0,sp,48
    8000211e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002120:	00000097          	auipc	ra,0x0
    80002124:	91e080e7          	jalr	-1762(ra) # 80001a3e <myproc>
    80002128:	89aa                	mv	s3,a0
  if(p == initproc)
    8000212a:	00007797          	auipc	a5,0x7
    8000212e:	eee7b783          	ld	a5,-274(a5) # 80009018 <initproc>
    80002132:	0d050493          	add	s1,a0,208
    80002136:	15050913          	add	s2,a0,336
    8000213a:	02a79363          	bne	a5,a0,80002160 <exit+0x52>
    panic("init exiting");
    8000213e:	00006517          	auipc	a0,0x6
    80002142:	0a250513          	add	a0,a0,162 # 800081e0 <digits+0x1a0>
    80002146:	ffffe097          	auipc	ra,0xffffe
    8000214a:	3fc080e7          	jalr	1020(ra) # 80000542 <panic>
      fileclose(f);
    8000214e:	00002097          	auipc	ra,0x2
    80002152:	41e080e7          	jalr	1054(ra) # 8000456c <fileclose>
      p->ofile[fd] = 0;
    80002156:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000215a:	04a1                	add	s1,s1,8
    8000215c:	01248563          	beq	s1,s2,80002166 <exit+0x58>
    if(p->ofile[fd]){
    80002160:	6088                	ld	a0,0(s1)
    80002162:	f575                	bnez	a0,8000214e <exit+0x40>
    80002164:	bfdd                	j	8000215a <exit+0x4c>
  begin_op();
    80002166:	00002097          	auipc	ra,0x2
    8000216a:	f3c080e7          	jalr	-196(ra) # 800040a2 <begin_op>
  iput(p->cwd);
    8000216e:	1509b503          	ld	a0,336(s3)
    80002172:	00001097          	auipc	ra,0x1
    80002176:	746080e7          	jalr	1862(ra) # 800038b8 <iput>
  end_op();
    8000217a:	00002097          	auipc	ra,0x2
    8000217e:	fa2080e7          	jalr	-94(ra) # 8000411c <end_op>
  p->cwd = 0;
    80002182:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    80002186:	00007497          	auipc	s1,0x7
    8000218a:	e9248493          	add	s1,s1,-366 # 80009018 <initproc>
    8000218e:	6088                	ld	a0,0(s1)
    80002190:	fffff097          	auipc	ra,0xfffff
    80002194:	a6c080e7          	jalr	-1428(ra) # 80000bfc <acquire>
  wakeup1(initproc);
    80002198:	6088                	ld	a0,0(s1)
    8000219a:	fffff097          	auipc	ra,0xfffff
    8000219e:	764080e7          	jalr	1892(ra) # 800018fe <wakeup1>
  release(&initproc->lock);
    800021a2:	6088                	ld	a0,0(s1)
    800021a4:	fffff097          	auipc	ra,0xfffff
    800021a8:	b0c080e7          	jalr	-1268(ra) # 80000cb0 <release>
  acquire(&p->lock);
    800021ac:	854e                	mv	a0,s3
    800021ae:	fffff097          	auipc	ra,0xfffff
    800021b2:	a4e080e7          	jalr	-1458(ra) # 80000bfc <acquire>
  struct proc *original_parent = p->parent;
    800021b6:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    800021ba:	854e                	mv	a0,s3
    800021bc:	fffff097          	auipc	ra,0xfffff
    800021c0:	af4080e7          	jalr	-1292(ra) # 80000cb0 <release>
  acquire(&original_parent->lock);
    800021c4:	8526                	mv	a0,s1
    800021c6:	fffff097          	auipc	ra,0xfffff
    800021ca:	a36080e7          	jalr	-1482(ra) # 80000bfc <acquire>
  acquire(&p->lock);
    800021ce:	854e                	mv	a0,s3
    800021d0:	fffff097          	auipc	ra,0xfffff
    800021d4:	a2c080e7          	jalr	-1492(ra) # 80000bfc <acquire>
  reparent(p);
    800021d8:	854e                	mv	a0,s3
    800021da:	00000097          	auipc	ra,0x0
    800021de:	d36080e7          	jalr	-714(ra) # 80001f10 <reparent>
  wakeup1(original_parent);
    800021e2:	8526                	mv	a0,s1
    800021e4:	fffff097          	auipc	ra,0xfffff
    800021e8:	71a080e7          	jalr	1818(ra) # 800018fe <wakeup1>
  p->xstate = status;
    800021ec:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    800021f0:	4791                	li	a5,4
    800021f2:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    800021f6:	8526                	mv	a0,s1
    800021f8:	fffff097          	auipc	ra,0xfffff
    800021fc:	ab8080e7          	jalr	-1352(ra) # 80000cb0 <release>
  sched();
    80002200:	00000097          	auipc	ra,0x0
    80002204:	e38080e7          	jalr	-456(ra) # 80002038 <sched>
  panic("zombie exit");
    80002208:	00006517          	auipc	a0,0x6
    8000220c:	fe850513          	add	a0,a0,-24 # 800081f0 <digits+0x1b0>
    80002210:	ffffe097          	auipc	ra,0xffffe
    80002214:	332080e7          	jalr	818(ra) # 80000542 <panic>

0000000080002218 <yield>:
{
    80002218:	1101                	add	sp,sp,-32
    8000221a:	ec06                	sd	ra,24(sp)
    8000221c:	e822                	sd	s0,16(sp)
    8000221e:	e426                	sd	s1,8(sp)
    80002220:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    80002222:	00000097          	auipc	ra,0x0
    80002226:	81c080e7          	jalr	-2020(ra) # 80001a3e <myproc>
    8000222a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000222c:	fffff097          	auipc	ra,0xfffff
    80002230:	9d0080e7          	jalr	-1584(ra) # 80000bfc <acquire>
  p->state = RUNNABLE;
    80002234:	4789                	li	a5,2
    80002236:	cc9c                	sw	a5,24(s1)
  sched();
    80002238:	00000097          	auipc	ra,0x0
    8000223c:	e00080e7          	jalr	-512(ra) # 80002038 <sched>
  release(&p->lock);
    80002240:	8526                	mv	a0,s1
    80002242:	fffff097          	auipc	ra,0xfffff
    80002246:	a6e080e7          	jalr	-1426(ra) # 80000cb0 <release>
}
    8000224a:	60e2                	ld	ra,24(sp)
    8000224c:	6442                	ld	s0,16(sp)
    8000224e:	64a2                	ld	s1,8(sp)
    80002250:	6105                	add	sp,sp,32
    80002252:	8082                	ret

0000000080002254 <sleep>:
{
    80002254:	7179                	add	sp,sp,-48
    80002256:	f406                	sd	ra,40(sp)
    80002258:	f022                	sd	s0,32(sp)
    8000225a:	ec26                	sd	s1,24(sp)
    8000225c:	e84a                	sd	s2,16(sp)
    8000225e:	e44e                	sd	s3,8(sp)
    80002260:	1800                	add	s0,sp,48
    80002262:	89aa                	mv	s3,a0
    80002264:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002266:	fffff097          	auipc	ra,0xfffff
    8000226a:	7d8080e7          	jalr	2008(ra) # 80001a3e <myproc>
    8000226e:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    80002270:	05250663          	beq	a0,s2,800022bc <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    80002274:	fffff097          	auipc	ra,0xfffff
    80002278:	988080e7          	jalr	-1656(ra) # 80000bfc <acquire>
    release(lk);
    8000227c:	854a                	mv	a0,s2
    8000227e:	fffff097          	auipc	ra,0xfffff
    80002282:	a32080e7          	jalr	-1486(ra) # 80000cb0 <release>
  p->chan = chan;
    80002286:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    8000228a:	4785                	li	a5,1
    8000228c:	cc9c                	sw	a5,24(s1)
  sched();
    8000228e:	00000097          	auipc	ra,0x0
    80002292:	daa080e7          	jalr	-598(ra) # 80002038 <sched>
  p->chan = 0;
    80002296:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    8000229a:	8526                	mv	a0,s1
    8000229c:	fffff097          	auipc	ra,0xfffff
    800022a0:	a14080e7          	jalr	-1516(ra) # 80000cb0 <release>
    acquire(lk);
    800022a4:	854a                	mv	a0,s2
    800022a6:	fffff097          	auipc	ra,0xfffff
    800022aa:	956080e7          	jalr	-1706(ra) # 80000bfc <acquire>
}
    800022ae:	70a2                	ld	ra,40(sp)
    800022b0:	7402                	ld	s0,32(sp)
    800022b2:	64e2                	ld	s1,24(sp)
    800022b4:	6942                	ld	s2,16(sp)
    800022b6:	69a2                	ld	s3,8(sp)
    800022b8:	6145                	add	sp,sp,48
    800022ba:	8082                	ret
  p->chan = chan;
    800022bc:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    800022c0:	4785                	li	a5,1
    800022c2:	cd1c                	sw	a5,24(a0)
  sched();
    800022c4:	00000097          	auipc	ra,0x0
    800022c8:	d74080e7          	jalr	-652(ra) # 80002038 <sched>
  p->chan = 0;
    800022cc:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    800022d0:	bff9                	j	800022ae <sleep+0x5a>

00000000800022d2 <wait>:
{
    800022d2:	715d                	add	sp,sp,-80
    800022d4:	e486                	sd	ra,72(sp)
    800022d6:	e0a2                	sd	s0,64(sp)
    800022d8:	fc26                	sd	s1,56(sp)
    800022da:	f84a                	sd	s2,48(sp)
    800022dc:	f44e                	sd	s3,40(sp)
    800022de:	f052                	sd	s4,32(sp)
    800022e0:	ec56                	sd	s5,24(sp)
    800022e2:	e85a                	sd	s6,16(sp)
    800022e4:	e45e                	sd	s7,8(sp)
    800022e6:	0880                	add	s0,sp,80
    800022e8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800022ea:	fffff097          	auipc	ra,0xfffff
    800022ee:	754080e7          	jalr	1876(ra) # 80001a3e <myproc>
    800022f2:	892a                	mv	s2,a0
  acquire(&p->lock);
    800022f4:	fffff097          	auipc	ra,0xfffff
    800022f8:	908080e7          	jalr	-1784(ra) # 80000bfc <acquire>
    havekids = 0;
    800022fc:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800022fe:	4a11                	li	s4,4
        havekids = 1;
    80002300:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80002302:	00015997          	auipc	s3,0x15
    80002306:	46698993          	add	s3,s3,1126 # 80017768 <tickslock>
    8000230a:	a845                	j	800023ba <wait+0xe8>
          pid = np->pid;
    8000230c:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002310:	000b0e63          	beqz	s6,8000232c <wait+0x5a>
    80002314:	4691                	li	a3,4
    80002316:	03448613          	add	a2,s1,52
    8000231a:	85da                	mv	a1,s6
    8000231c:	05093503          	ld	a0,80(s2)
    80002320:	fffff097          	auipc	ra,0xfffff
    80002324:	362080e7          	jalr	866(ra) # 80001682 <copyout>
    80002328:	02054d63          	bltz	a0,80002362 <wait+0x90>
          freeproc(np);
    8000232c:	8526                	mv	a0,s1
    8000232e:	00000097          	auipc	ra,0x0
    80002332:	8c2080e7          	jalr	-1854(ra) # 80001bf0 <freeproc>
          release(&np->lock);
    80002336:	8526                	mv	a0,s1
    80002338:	fffff097          	auipc	ra,0xfffff
    8000233c:	978080e7          	jalr	-1672(ra) # 80000cb0 <release>
          release(&p->lock);
    80002340:	854a                	mv	a0,s2
    80002342:	fffff097          	auipc	ra,0xfffff
    80002346:	96e080e7          	jalr	-1682(ra) # 80000cb0 <release>
}
    8000234a:	854e                	mv	a0,s3
    8000234c:	60a6                	ld	ra,72(sp)
    8000234e:	6406                	ld	s0,64(sp)
    80002350:	74e2                	ld	s1,56(sp)
    80002352:	7942                	ld	s2,48(sp)
    80002354:	79a2                	ld	s3,40(sp)
    80002356:	7a02                	ld	s4,32(sp)
    80002358:	6ae2                	ld	s5,24(sp)
    8000235a:	6b42                	ld	s6,16(sp)
    8000235c:	6ba2                	ld	s7,8(sp)
    8000235e:	6161                	add	sp,sp,80
    80002360:	8082                	ret
            release(&np->lock);
    80002362:	8526                	mv	a0,s1
    80002364:	fffff097          	auipc	ra,0xfffff
    80002368:	94c080e7          	jalr	-1716(ra) # 80000cb0 <release>
            release(&p->lock);
    8000236c:	854a                	mv	a0,s2
    8000236e:	fffff097          	auipc	ra,0xfffff
    80002372:	942080e7          	jalr	-1726(ra) # 80000cb0 <release>
            return -1;
    80002376:	59fd                	li	s3,-1
    80002378:	bfc9                	j	8000234a <wait+0x78>
    for(np = proc; np < &proc[NPROC]; np++){
    8000237a:	16848493          	add	s1,s1,360
    8000237e:	03348463          	beq	s1,s3,800023a6 <wait+0xd4>
      if(np->parent == p){
    80002382:	709c                	ld	a5,32(s1)
    80002384:	ff279be3          	bne	a5,s2,8000237a <wait+0xa8>
        acquire(&np->lock);
    80002388:	8526                	mv	a0,s1
    8000238a:	fffff097          	auipc	ra,0xfffff
    8000238e:	872080e7          	jalr	-1934(ra) # 80000bfc <acquire>
        if(np->state == ZOMBIE){
    80002392:	4c9c                	lw	a5,24(s1)
    80002394:	f7478ce3          	beq	a5,s4,8000230c <wait+0x3a>
        release(&np->lock);
    80002398:	8526                	mv	a0,s1
    8000239a:	fffff097          	auipc	ra,0xfffff
    8000239e:	916080e7          	jalr	-1770(ra) # 80000cb0 <release>
        havekids = 1;
    800023a2:	8756                	mv	a4,s5
    800023a4:	bfd9                	j	8000237a <wait+0xa8>
    if(!havekids || p->killed){
    800023a6:	c305                	beqz	a4,800023c6 <wait+0xf4>
    800023a8:	03092783          	lw	a5,48(s2)
    800023ac:	ef89                	bnez	a5,800023c6 <wait+0xf4>
    sleep(p, &p->lock);  //DOC: wait-sleep
    800023ae:	85ca                	mv	a1,s2
    800023b0:	854a                	mv	a0,s2
    800023b2:	00000097          	auipc	ra,0x0
    800023b6:	ea2080e7          	jalr	-350(ra) # 80002254 <sleep>
    havekids = 0;
    800023ba:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800023bc:	00010497          	auipc	s1,0x10
    800023c0:	9ac48493          	add	s1,s1,-1620 # 80011d68 <proc>
    800023c4:	bf7d                	j	80002382 <wait+0xb0>
      release(&p->lock);
    800023c6:	854a                	mv	a0,s2
    800023c8:	fffff097          	auipc	ra,0xfffff
    800023cc:	8e8080e7          	jalr	-1816(ra) # 80000cb0 <release>
      return -1;
    800023d0:	59fd                	li	s3,-1
    800023d2:	bfa5                	j	8000234a <wait+0x78>

00000000800023d4 <wakeup>:
{
    800023d4:	7139                	add	sp,sp,-64
    800023d6:	fc06                	sd	ra,56(sp)
    800023d8:	f822                	sd	s0,48(sp)
    800023da:	f426                	sd	s1,40(sp)
    800023dc:	f04a                	sd	s2,32(sp)
    800023de:	ec4e                	sd	s3,24(sp)
    800023e0:	e852                	sd	s4,16(sp)
    800023e2:	e456                	sd	s5,8(sp)
    800023e4:	0080                	add	s0,sp,64
    800023e6:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    800023e8:	00010497          	auipc	s1,0x10
    800023ec:	98048493          	add	s1,s1,-1664 # 80011d68 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    800023f0:	4985                	li	s3,1
      p->state = RUNNABLE;
    800023f2:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    800023f4:	00015917          	auipc	s2,0x15
    800023f8:	37490913          	add	s2,s2,884 # 80017768 <tickslock>
    800023fc:	a811                	j	80002410 <wakeup+0x3c>
    release(&p->lock);
    800023fe:	8526                	mv	a0,s1
    80002400:	fffff097          	auipc	ra,0xfffff
    80002404:	8b0080e7          	jalr	-1872(ra) # 80000cb0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002408:	16848493          	add	s1,s1,360
    8000240c:	03248063          	beq	s1,s2,8000242c <wakeup+0x58>
    acquire(&p->lock);
    80002410:	8526                	mv	a0,s1
    80002412:	ffffe097          	auipc	ra,0xffffe
    80002416:	7ea080e7          	jalr	2026(ra) # 80000bfc <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    8000241a:	4c9c                	lw	a5,24(s1)
    8000241c:	ff3791e3          	bne	a5,s3,800023fe <wakeup+0x2a>
    80002420:	749c                	ld	a5,40(s1)
    80002422:	fd479ee3          	bne	a5,s4,800023fe <wakeup+0x2a>
      p->state = RUNNABLE;
    80002426:	0154ac23          	sw	s5,24(s1)
    8000242a:	bfd1                	j	800023fe <wakeup+0x2a>
}
    8000242c:	70e2                	ld	ra,56(sp)
    8000242e:	7442                	ld	s0,48(sp)
    80002430:	74a2                	ld	s1,40(sp)
    80002432:	7902                	ld	s2,32(sp)
    80002434:	69e2                	ld	s3,24(sp)
    80002436:	6a42                	ld	s4,16(sp)
    80002438:	6aa2                	ld	s5,8(sp)
    8000243a:	6121                	add	sp,sp,64
    8000243c:	8082                	ret

000000008000243e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000243e:	7179                	add	sp,sp,-48
    80002440:	f406                	sd	ra,40(sp)
    80002442:	f022                	sd	s0,32(sp)
    80002444:	ec26                	sd	s1,24(sp)
    80002446:	e84a                	sd	s2,16(sp)
    80002448:	e44e                	sd	s3,8(sp)
    8000244a:	1800                	add	s0,sp,48
    8000244c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000244e:	00010497          	auipc	s1,0x10
    80002452:	91a48493          	add	s1,s1,-1766 # 80011d68 <proc>
    80002456:	00015997          	auipc	s3,0x15
    8000245a:	31298993          	add	s3,s3,786 # 80017768 <tickslock>
    acquire(&p->lock);
    8000245e:	8526                	mv	a0,s1
    80002460:	ffffe097          	auipc	ra,0xffffe
    80002464:	79c080e7          	jalr	1948(ra) # 80000bfc <acquire>
    if(p->pid == pid){
    80002468:	5c9c                	lw	a5,56(s1)
    8000246a:	01278d63          	beq	a5,s2,80002484 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000246e:	8526                	mv	a0,s1
    80002470:	fffff097          	auipc	ra,0xfffff
    80002474:	840080e7          	jalr	-1984(ra) # 80000cb0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002478:	16848493          	add	s1,s1,360
    8000247c:	ff3491e3          	bne	s1,s3,8000245e <kill+0x20>
  }
  return -1;
    80002480:	557d                	li	a0,-1
    80002482:	a821                	j	8000249a <kill+0x5c>
      p->killed = 1;
    80002484:	4785                	li	a5,1
    80002486:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80002488:	4c98                	lw	a4,24(s1)
    8000248a:	00f70f63          	beq	a4,a5,800024a8 <kill+0x6a>
      release(&p->lock);
    8000248e:	8526                	mv	a0,s1
    80002490:	fffff097          	auipc	ra,0xfffff
    80002494:	820080e7          	jalr	-2016(ra) # 80000cb0 <release>
      return 0;
    80002498:	4501                	li	a0,0
}
    8000249a:	70a2                	ld	ra,40(sp)
    8000249c:	7402                	ld	s0,32(sp)
    8000249e:	64e2                	ld	s1,24(sp)
    800024a0:	6942                	ld	s2,16(sp)
    800024a2:	69a2                	ld	s3,8(sp)
    800024a4:	6145                	add	sp,sp,48
    800024a6:	8082                	ret
        p->state = RUNNABLE;
    800024a8:	4789                	li	a5,2
    800024aa:	cc9c                	sw	a5,24(s1)
    800024ac:	b7cd                	j	8000248e <kill+0x50>

00000000800024ae <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800024ae:	7179                	add	sp,sp,-48
    800024b0:	f406                	sd	ra,40(sp)
    800024b2:	f022                	sd	s0,32(sp)
    800024b4:	ec26                	sd	s1,24(sp)
    800024b6:	e84a                	sd	s2,16(sp)
    800024b8:	e44e                	sd	s3,8(sp)
    800024ba:	e052                	sd	s4,0(sp)
    800024bc:	1800                	add	s0,sp,48
    800024be:	84aa                	mv	s1,a0
    800024c0:	892e                	mv	s2,a1
    800024c2:	89b2                	mv	s3,a2
    800024c4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024c6:	fffff097          	auipc	ra,0xfffff
    800024ca:	578080e7          	jalr	1400(ra) # 80001a3e <myproc>
  if(user_dst){
    800024ce:	c08d                	beqz	s1,800024f0 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800024d0:	86d2                	mv	a3,s4
    800024d2:	864e                	mv	a2,s3
    800024d4:	85ca                	mv	a1,s2
    800024d6:	6928                	ld	a0,80(a0)
    800024d8:	fffff097          	auipc	ra,0xfffff
    800024dc:	1aa080e7          	jalr	426(ra) # 80001682 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800024e0:	70a2                	ld	ra,40(sp)
    800024e2:	7402                	ld	s0,32(sp)
    800024e4:	64e2                	ld	s1,24(sp)
    800024e6:	6942                	ld	s2,16(sp)
    800024e8:	69a2                	ld	s3,8(sp)
    800024ea:	6a02                	ld	s4,0(sp)
    800024ec:	6145                	add	sp,sp,48
    800024ee:	8082                	ret
    memmove((char *)dst, src, len);
    800024f0:	000a061b          	sext.w	a2,s4
    800024f4:	85ce                	mv	a1,s3
    800024f6:	854a                	mv	a0,s2
    800024f8:	fffff097          	auipc	ra,0xfffff
    800024fc:	85c080e7          	jalr	-1956(ra) # 80000d54 <memmove>
    return 0;
    80002500:	8526                	mv	a0,s1
    80002502:	bff9                	j	800024e0 <either_copyout+0x32>

0000000080002504 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002504:	7179                	add	sp,sp,-48
    80002506:	f406                	sd	ra,40(sp)
    80002508:	f022                	sd	s0,32(sp)
    8000250a:	ec26                	sd	s1,24(sp)
    8000250c:	e84a                	sd	s2,16(sp)
    8000250e:	e44e                	sd	s3,8(sp)
    80002510:	e052                	sd	s4,0(sp)
    80002512:	1800                	add	s0,sp,48
    80002514:	892a                	mv	s2,a0
    80002516:	84ae                	mv	s1,a1
    80002518:	89b2                	mv	s3,a2
    8000251a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000251c:	fffff097          	auipc	ra,0xfffff
    80002520:	522080e7          	jalr	1314(ra) # 80001a3e <myproc>
  if(user_src){
    80002524:	c08d                	beqz	s1,80002546 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002526:	86d2                	mv	a3,s4
    80002528:	864e                	mv	a2,s3
    8000252a:	85ca                	mv	a1,s2
    8000252c:	6928                	ld	a0,80(a0)
    8000252e:	fffff097          	auipc	ra,0xfffff
    80002532:	23a080e7          	jalr	570(ra) # 80001768 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002536:	70a2                	ld	ra,40(sp)
    80002538:	7402                	ld	s0,32(sp)
    8000253a:	64e2                	ld	s1,24(sp)
    8000253c:	6942                	ld	s2,16(sp)
    8000253e:	69a2                	ld	s3,8(sp)
    80002540:	6a02                	ld	s4,0(sp)
    80002542:	6145                	add	sp,sp,48
    80002544:	8082                	ret
    memmove(dst, (char*)src, len);
    80002546:	000a061b          	sext.w	a2,s4
    8000254a:	85ce                	mv	a1,s3
    8000254c:	854a                	mv	a0,s2
    8000254e:	fffff097          	auipc	ra,0xfffff
    80002552:	806080e7          	jalr	-2042(ra) # 80000d54 <memmove>
    return 0;
    80002556:	8526                	mv	a0,s1
    80002558:	bff9                	j	80002536 <either_copyin+0x32>

000000008000255a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000255a:	715d                	add	sp,sp,-80
    8000255c:	e486                	sd	ra,72(sp)
    8000255e:	e0a2                	sd	s0,64(sp)
    80002560:	fc26                	sd	s1,56(sp)
    80002562:	f84a                	sd	s2,48(sp)
    80002564:	f44e                	sd	s3,40(sp)
    80002566:	f052                	sd	s4,32(sp)
    80002568:	ec56                	sd	s5,24(sp)
    8000256a:	e85a                	sd	s6,16(sp)
    8000256c:	e45e                	sd	s7,8(sp)
    8000256e:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002570:	00006517          	auipc	a0,0x6
    80002574:	b5850513          	add	a0,a0,-1192 # 800080c8 <digits+0x88>
    80002578:	ffffe097          	auipc	ra,0xffffe
    8000257c:	014080e7          	jalr	20(ra) # 8000058c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002580:	00010497          	auipc	s1,0x10
    80002584:	94048493          	add	s1,s1,-1728 # 80011ec0 <proc+0x158>
    80002588:	00015917          	auipc	s2,0x15
    8000258c:	33890913          	add	s2,s2,824 # 800178c0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002590:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    80002592:	00006997          	auipc	s3,0x6
    80002596:	c6e98993          	add	s3,s3,-914 # 80008200 <digits+0x1c0>
    printf("%d %s %s", p->pid, state, p->name);
    8000259a:	00006a97          	auipc	s5,0x6
    8000259e:	c6ea8a93          	add	s5,s5,-914 # 80008208 <digits+0x1c8>
    printf("\n");
    800025a2:	00006a17          	auipc	s4,0x6
    800025a6:	b26a0a13          	add	s4,s4,-1242 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025aa:	00006b97          	auipc	s7,0x6
    800025ae:	c96b8b93          	add	s7,s7,-874 # 80008240 <states.0>
    800025b2:	a00d                	j	800025d4 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800025b4:	ee06a583          	lw	a1,-288(a3)
    800025b8:	8556                	mv	a0,s5
    800025ba:	ffffe097          	auipc	ra,0xffffe
    800025be:	fd2080e7          	jalr	-46(ra) # 8000058c <printf>
    printf("\n");
    800025c2:	8552                	mv	a0,s4
    800025c4:	ffffe097          	auipc	ra,0xffffe
    800025c8:	fc8080e7          	jalr	-56(ra) # 8000058c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025cc:	16848493          	add	s1,s1,360
    800025d0:	03248263          	beq	s1,s2,800025f4 <procdump+0x9a>
    if(p->state == UNUSED)
    800025d4:	86a6                	mv	a3,s1
    800025d6:	ec04a783          	lw	a5,-320(s1)
    800025da:	dbed                	beqz	a5,800025cc <procdump+0x72>
      state = "???";
    800025dc:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025de:	fcfb6be3          	bltu	s6,a5,800025b4 <procdump+0x5a>
    800025e2:	02079713          	sll	a4,a5,0x20
    800025e6:	01d75793          	srl	a5,a4,0x1d
    800025ea:	97de                	add	a5,a5,s7
    800025ec:	6390                	ld	a2,0(a5)
    800025ee:	f279                	bnez	a2,800025b4 <procdump+0x5a>
      state = "???";
    800025f0:	864e                	mv	a2,s3
    800025f2:	b7c9                	j	800025b4 <procdump+0x5a>
  }
}
    800025f4:	60a6                	ld	ra,72(sp)
    800025f6:	6406                	ld	s0,64(sp)
    800025f8:	74e2                	ld	s1,56(sp)
    800025fa:	7942                	ld	s2,48(sp)
    800025fc:	79a2                	ld	s3,40(sp)
    800025fe:	7a02                	ld	s4,32(sp)
    80002600:	6ae2                	ld	s5,24(sp)
    80002602:	6b42                	ld	s6,16(sp)
    80002604:	6ba2                	ld	s7,8(sp)
    80002606:	6161                	add	sp,sp,80
    80002608:	8082                	ret

000000008000260a <swtch>:
    8000260a:	00153023          	sd	ra,0(a0)
    8000260e:	00253423          	sd	sp,8(a0)
    80002612:	e900                	sd	s0,16(a0)
    80002614:	ed04                	sd	s1,24(a0)
    80002616:	03253023          	sd	s2,32(a0)
    8000261a:	03353423          	sd	s3,40(a0)
    8000261e:	03453823          	sd	s4,48(a0)
    80002622:	03553c23          	sd	s5,56(a0)
    80002626:	05653023          	sd	s6,64(a0)
    8000262a:	05753423          	sd	s7,72(a0)
    8000262e:	05853823          	sd	s8,80(a0)
    80002632:	05953c23          	sd	s9,88(a0)
    80002636:	07a53023          	sd	s10,96(a0)
    8000263a:	07b53423          	sd	s11,104(a0)
    8000263e:	0005b083          	ld	ra,0(a1)
    80002642:	0085b103          	ld	sp,8(a1)
    80002646:	6980                	ld	s0,16(a1)
    80002648:	6d84                	ld	s1,24(a1)
    8000264a:	0205b903          	ld	s2,32(a1)
    8000264e:	0285b983          	ld	s3,40(a1)
    80002652:	0305ba03          	ld	s4,48(a1)
    80002656:	0385ba83          	ld	s5,56(a1)
    8000265a:	0405bb03          	ld	s6,64(a1)
    8000265e:	0485bb83          	ld	s7,72(a1)
    80002662:	0505bc03          	ld	s8,80(a1)
    80002666:	0585bc83          	ld	s9,88(a1)
    8000266a:	0605bd03          	ld	s10,96(a1)
    8000266e:	0685bd83          	ld	s11,104(a1)
    80002672:	8082                	ret

0000000080002674 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002674:	1141                	add	sp,sp,-16
    80002676:	e406                	sd	ra,8(sp)
    80002678:	e022                	sd	s0,0(sp)
    8000267a:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    8000267c:	00006597          	auipc	a1,0x6
    80002680:	bec58593          	add	a1,a1,-1044 # 80008268 <states.0+0x28>
    80002684:	00015517          	auipc	a0,0x15
    80002688:	0e450513          	add	a0,a0,228 # 80017768 <tickslock>
    8000268c:	ffffe097          	auipc	ra,0xffffe
    80002690:	4e0080e7          	jalr	1248(ra) # 80000b6c <initlock>
}
    80002694:	60a2                	ld	ra,8(sp)
    80002696:	6402                	ld	s0,0(sp)
    80002698:	0141                	add	sp,sp,16
    8000269a:	8082                	ret

000000008000269c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000269c:	1141                	add	sp,sp,-16
    8000269e:	e422                	sd	s0,8(sp)
    800026a0:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026a2:	00003797          	auipc	a5,0x3
    800026a6:	4fe78793          	add	a5,a5,1278 # 80005ba0 <kernelvec>
    800026aa:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800026ae:	6422                	ld	s0,8(sp)
    800026b0:	0141                	add	sp,sp,16
    800026b2:	8082                	ret

00000000800026b4 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800026b4:	1141                	add	sp,sp,-16
    800026b6:	e406                	sd	ra,8(sp)
    800026b8:	e022                	sd	s0,0(sp)
    800026ba:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    800026bc:	fffff097          	auipc	ra,0xfffff
    800026c0:	382080e7          	jalr	898(ra) # 80001a3e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026c4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800026c8:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026ca:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    800026ce:	00005697          	auipc	a3,0x5
    800026d2:	93268693          	add	a3,a3,-1742 # 80007000 <_trampoline>
    800026d6:	00005717          	auipc	a4,0x5
    800026da:	92a70713          	add	a4,a4,-1750 # 80007000 <_trampoline>
    800026de:	8f15                	sub	a4,a4,a3
    800026e0:	040007b7          	lui	a5,0x4000
    800026e4:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800026e6:	07b2                	sll	a5,a5,0xc
    800026e8:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026ea:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800026ee:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800026f0:	18002673          	csrr	a2,satp
    800026f4:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800026f6:	6d30                	ld	a2,88(a0)
    800026f8:	6138                	ld	a4,64(a0)
    800026fa:	6585                	lui	a1,0x1
    800026fc:	972e                	add	a4,a4,a1
    800026fe:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002700:	6d38                	ld	a4,88(a0)
    80002702:	00000617          	auipc	a2,0x0
    80002706:	13c60613          	add	a2,a2,316 # 8000283e <usertrap>
    8000270a:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000270c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000270e:	8612                	mv	a2,tp
    80002710:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002712:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002716:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000271a:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000271e:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002722:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002724:	6f18                	ld	a4,24(a4)
    80002726:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000272a:	692c                	ld	a1,80(a0)
    8000272c:	81b1                	srl	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    8000272e:	00005717          	auipc	a4,0x5
    80002732:	96270713          	add	a4,a4,-1694 # 80007090 <userret>
    80002736:	8f15                	sub	a4,a4,a3
    80002738:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    8000273a:	577d                	li	a4,-1
    8000273c:	177e                	sll	a4,a4,0x3f
    8000273e:	8dd9                	or	a1,a1,a4
    80002740:	02000537          	lui	a0,0x2000
    80002744:	157d                	add	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80002746:	0536                	sll	a0,a0,0xd
    80002748:	9782                	jalr	a5
}
    8000274a:	60a2                	ld	ra,8(sp)
    8000274c:	6402                	ld	s0,0(sp)
    8000274e:	0141                	add	sp,sp,16
    80002750:	8082                	ret

0000000080002752 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002752:	1101                	add	sp,sp,-32
    80002754:	ec06                	sd	ra,24(sp)
    80002756:	e822                	sd	s0,16(sp)
    80002758:	e426                	sd	s1,8(sp)
    8000275a:	1000                	add	s0,sp,32
  acquire(&tickslock);
    8000275c:	00015497          	auipc	s1,0x15
    80002760:	00c48493          	add	s1,s1,12 # 80017768 <tickslock>
    80002764:	8526                	mv	a0,s1
    80002766:	ffffe097          	auipc	ra,0xffffe
    8000276a:	496080e7          	jalr	1174(ra) # 80000bfc <acquire>
  ticks++;
    8000276e:	00007517          	auipc	a0,0x7
    80002772:	8b250513          	add	a0,a0,-1870 # 80009020 <ticks>
    80002776:	411c                	lw	a5,0(a0)
    80002778:	2785                	addw	a5,a5,1
    8000277a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    8000277c:	00000097          	auipc	ra,0x0
    80002780:	c58080e7          	jalr	-936(ra) # 800023d4 <wakeup>
  release(&tickslock);
    80002784:	8526                	mv	a0,s1
    80002786:	ffffe097          	auipc	ra,0xffffe
    8000278a:	52a080e7          	jalr	1322(ra) # 80000cb0 <release>
}
    8000278e:	60e2                	ld	ra,24(sp)
    80002790:	6442                	ld	s0,16(sp)
    80002792:	64a2                	ld	s1,8(sp)
    80002794:	6105                	add	sp,sp,32
    80002796:	8082                	ret

0000000080002798 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002798:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    8000279c:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    8000279e:	0807df63          	bgez	a5,8000283c <devintr+0xa4>
{
    800027a2:	1101                	add	sp,sp,-32
    800027a4:	ec06                	sd	ra,24(sp)
    800027a6:	e822                	sd	s0,16(sp)
    800027a8:	e426                	sd	s1,8(sp)
    800027aa:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    800027ac:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    800027b0:	46a5                	li	a3,9
    800027b2:	00d70d63          	beq	a4,a3,800027cc <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    800027b6:	577d                	li	a4,-1
    800027b8:	177e                	sll	a4,a4,0x3f
    800027ba:	0705                	add	a4,a4,1
    return 0;
    800027bc:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800027be:	04e78e63          	beq	a5,a4,8000281a <devintr+0x82>
  }
}
    800027c2:	60e2                	ld	ra,24(sp)
    800027c4:	6442                	ld	s0,16(sp)
    800027c6:	64a2                	ld	s1,8(sp)
    800027c8:	6105                	add	sp,sp,32
    800027ca:	8082                	ret
    int irq = plic_claim();
    800027cc:	00003097          	auipc	ra,0x3
    800027d0:	4dc080e7          	jalr	1244(ra) # 80005ca8 <plic_claim>
    800027d4:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800027d6:	47a9                	li	a5,10
    800027d8:	02f50763          	beq	a0,a5,80002806 <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    800027dc:	4785                	li	a5,1
    800027de:	02f50963          	beq	a0,a5,80002810 <devintr+0x78>
    return 1;
    800027e2:	4505                	li	a0,1
    } else if(irq){
    800027e4:	dcf9                	beqz	s1,800027c2 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    800027e6:	85a6                	mv	a1,s1
    800027e8:	00006517          	auipc	a0,0x6
    800027ec:	a8850513          	add	a0,a0,-1400 # 80008270 <states.0+0x30>
    800027f0:	ffffe097          	auipc	ra,0xffffe
    800027f4:	d9c080e7          	jalr	-612(ra) # 8000058c <printf>
      plic_complete(irq);
    800027f8:	8526                	mv	a0,s1
    800027fa:	00003097          	auipc	ra,0x3
    800027fe:	4d2080e7          	jalr	1234(ra) # 80005ccc <plic_complete>
    return 1;
    80002802:	4505                	li	a0,1
    80002804:	bf7d                	j	800027c2 <devintr+0x2a>
      uartintr();
    80002806:	ffffe097          	auipc	ra,0xffffe
    8000280a:	1b8080e7          	jalr	440(ra) # 800009be <uartintr>
    if(irq)
    8000280e:	b7ed                	j	800027f8 <devintr+0x60>
      virtio_disk_intr();
    80002810:	00004097          	auipc	ra,0x4
    80002814:	92e080e7          	jalr	-1746(ra) # 8000613e <virtio_disk_intr>
    if(irq)
    80002818:	b7c5                	j	800027f8 <devintr+0x60>
    if(cpuid() == 0){
    8000281a:	fffff097          	auipc	ra,0xfffff
    8000281e:	1f8080e7          	jalr	504(ra) # 80001a12 <cpuid>
    80002822:	c901                	beqz	a0,80002832 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002824:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002828:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    8000282a:	14479073          	csrw	sip,a5
    return 2;
    8000282e:	4509                	li	a0,2
    80002830:	bf49                	j	800027c2 <devintr+0x2a>
      clockintr();
    80002832:	00000097          	auipc	ra,0x0
    80002836:	f20080e7          	jalr	-224(ra) # 80002752 <clockintr>
    8000283a:	b7ed                	j	80002824 <devintr+0x8c>
}
    8000283c:	8082                	ret

000000008000283e <usertrap>:
{
    8000283e:	7179                	add	sp,sp,-48
    80002840:	f406                	sd	ra,40(sp)
    80002842:	f022                	sd	s0,32(sp)
    80002844:	ec26                	sd	s1,24(sp)
    80002846:	e84a                	sd	s2,16(sp)
    80002848:	e44e                	sd	s3,8(sp)
    8000284a:	e052                	sd	s4,0(sp)
    8000284c:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000284e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002852:	1007f793          	and	a5,a5,256
    80002856:	e3bd                	bnez	a5,800028bc <usertrap+0x7e>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002858:	00003797          	auipc	a5,0x3
    8000285c:	34878793          	add	a5,a5,840 # 80005ba0 <kernelvec>
    80002860:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002864:	fffff097          	auipc	ra,0xfffff
    80002868:	1da080e7          	jalr	474(ra) # 80001a3e <myproc>
    8000286c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000286e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002870:	14102773          	csrr	a4,sepc
    80002874:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002876:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8000287a:	47a1                	li	a5,8
    8000287c:	04f71e63          	bne	a4,a5,800028d8 <usertrap+0x9a>
    if(p->killed)
    80002880:	591c                	lw	a5,48(a0)
    80002882:	e7a9                	bnez	a5,800028cc <usertrap+0x8e>
    p->trapframe->epc += 4;
    80002884:	6cb8                	ld	a4,88(s1)
    80002886:	6f1c                	ld	a5,24(a4)
    80002888:	0791                	add	a5,a5,4
    8000288a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000288c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002890:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002894:	10079073          	csrw	sstatus,a5
    syscall();
    80002898:	00000097          	auipc	ra,0x0
    8000289c:	346080e7          	jalr	838(ra) # 80002bde <syscall>
  if(p->killed)
    800028a0:	589c                	lw	a5,48(s1)
    800028a2:	ebfd                	bnez	a5,80002998 <usertrap+0x15a>
  usertrapret();
    800028a4:	00000097          	auipc	ra,0x0
    800028a8:	e10080e7          	jalr	-496(ra) # 800026b4 <usertrapret>
}
    800028ac:	70a2                	ld	ra,40(sp)
    800028ae:	7402                	ld	s0,32(sp)
    800028b0:	64e2                	ld	s1,24(sp)
    800028b2:	6942                	ld	s2,16(sp)
    800028b4:	69a2                	ld	s3,8(sp)
    800028b6:	6a02                	ld	s4,0(sp)
    800028b8:	6145                	add	sp,sp,48
    800028ba:	8082                	ret
    panic("usertrap: not from user mode");
    800028bc:	00006517          	auipc	a0,0x6
    800028c0:	9d450513          	add	a0,a0,-1580 # 80008290 <states.0+0x50>
    800028c4:	ffffe097          	auipc	ra,0xffffe
    800028c8:	c7e080e7          	jalr	-898(ra) # 80000542 <panic>
      exit(-1);
    800028cc:	557d                	li	a0,-1
    800028ce:	00000097          	auipc	ra,0x0
    800028d2:	840080e7          	jalr	-1984(ra) # 8000210e <exit>
    800028d6:	b77d                	j	80002884 <usertrap+0x46>
  } else if((which_dev = devintr()) != 0){
    800028d8:	00000097          	auipc	ra,0x0
    800028dc:	ec0080e7          	jalr	-320(ra) # 80002798 <devintr>
    800028e0:	892a                	mv	s2,a0
    800028e2:	e945                	bnez	a0,80002992 <usertrap+0x154>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028e4:	14202773          	csrr	a4,scause
   else if(r_scause() == 13 || r_scause() == 15){//检查一个错误是否是页面错误
    800028e8:	47b5                	li	a5,13
    800028ea:	00f70763          	beq	a4,a5,800028f8 <usertrap+0xba>
    800028ee:	14202773          	csrr	a4,scause
    800028f2:	47bd                	li	a5,15
    800028f4:	04f71963          	bne	a4,a5,80002946 <usertrap+0x108>
  asm volatile("csrr %0, stval" : "=r" (x) );
    800028f8:	143029f3          	csrr	s3,stval
    if(p->sz <= va){//地址高于sbrk申请的地址
    800028fc:	64bc                	ld	a5,72(s1)
    800028fe:	06f9fb63          	bgeu	s3,a5,80002974 <usertrap+0x136>
    } else if(va < p->trapframe->sp){//地址低于栈顶地址 无效页
    80002902:	6cbc                	ld	a5,88(s1)
    80002904:	7b9c                	ld	a5,48(a5)
    80002906:	06f9e763          	bltu	s3,a5,80002974 <usertrap+0x136>
      char *mem = kalloc();//参考vm.c的uvmalloc()，调用kalloc()和mapages()。
    8000290a:	ffffe097          	auipc	ra,0xffffe
    8000290e:	202080e7          	jalr	514(ra) # 80000b0c <kalloc>
    80002912:	8a2a                	mv	s4,a0
      if(mem == 0){//如果kalloc()在页面错误处理程序中失败，终止当前进程
    80002914:	c125                	beqz	a0,80002974 <usertrap+0x136>
        memset(mem, 0, PGSIZE);
    80002916:	6605                	lui	a2,0x1
    80002918:	4581                	li	a1,0
    8000291a:	ffffe097          	auipc	ra,0xffffe
    8000291e:	3de080e7          	jalr	990(ra) # 80000cf8 <memset>
        if(mappages(p->pagetable, va, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80002922:	4779                	li	a4,30
    80002924:	86d2                	mv	a3,s4
    80002926:	6605                	lui	a2,0x1
    80002928:	75fd                	lui	a1,0xfffff
    8000292a:	00b9f5b3          	and	a1,s3,a1
    8000292e:	68a8                	ld	a0,80(s1)
    80002930:	ffffe097          	auipc	ra,0xffffe
    80002934:	7f4080e7          	jalr	2036(ra) # 80001124 <mappages>
    80002938:	d525                	beqz	a0,800028a0 <usertrap+0x62>
            kfree(mem);
    8000293a:	8552                	mv	a0,s4
    8000293c:	ffffe097          	auipc	ra,0xffffe
    80002940:	0d2080e7          	jalr	210(ra) # 80000a0e <kfree>
            p->killed = 1;
    80002944:	a805                	j	80002974 <usertrap+0x136>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002946:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000294a:	5c90                	lw	a2,56(s1)
    8000294c:	00006517          	auipc	a0,0x6
    80002950:	96450513          	add	a0,a0,-1692 # 800082b0 <states.0+0x70>
    80002954:	ffffe097          	auipc	ra,0xffffe
    80002958:	c38080e7          	jalr	-968(ra) # 8000058c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000295c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002960:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002964:	00006517          	auipc	a0,0x6
    80002968:	97c50513          	add	a0,a0,-1668 # 800082e0 <states.0+0xa0>
    8000296c:	ffffe097          	auipc	ra,0xffffe
    80002970:	c20080e7          	jalr	-992(ra) # 8000058c <printf>
        p->killed = 1;
    80002974:	4785                	li	a5,1
    80002976:	d89c                	sw	a5,48(s1)
    exit(-1);
    80002978:	557d                	li	a0,-1
    8000297a:	fffff097          	auipc	ra,0xfffff
    8000297e:	794080e7          	jalr	1940(ra) # 8000210e <exit>
  if(which_dev == 2)
    80002982:	4789                	li	a5,2
    80002984:	f2f910e3          	bne	s2,a5,800028a4 <usertrap+0x66>
    yield();
    80002988:	00000097          	auipc	ra,0x0
    8000298c:	890080e7          	jalr	-1904(ra) # 80002218 <yield>
    80002990:	bf11                	j	800028a4 <usertrap+0x66>
  if(p->killed)
    80002992:	589c                	lw	a5,48(s1)
    80002994:	d7fd                	beqz	a5,80002982 <usertrap+0x144>
    80002996:	b7cd                	j	80002978 <usertrap+0x13a>
    80002998:	4901                	li	s2,0
    8000299a:	bff9                	j	80002978 <usertrap+0x13a>

000000008000299c <kerneltrap>:
{
    8000299c:	7179                	add	sp,sp,-48
    8000299e:	f406                	sd	ra,40(sp)
    800029a0:	f022                	sd	s0,32(sp)
    800029a2:	ec26                	sd	s1,24(sp)
    800029a4:	e84a                	sd	s2,16(sp)
    800029a6:	e44e                	sd	s3,8(sp)
    800029a8:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029aa:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029ae:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800029b2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800029b6:	1004f793          	and	a5,s1,256
    800029ba:	cb85                	beqz	a5,800029ea <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029bc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800029c0:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    800029c2:	ef85                	bnez	a5,800029fa <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800029c4:	00000097          	auipc	ra,0x0
    800029c8:	dd4080e7          	jalr	-556(ra) # 80002798 <devintr>
    800029cc:	cd1d                	beqz	a0,80002a0a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800029ce:	4789                	li	a5,2
    800029d0:	06f50a63          	beq	a0,a5,80002a44 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800029d4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800029d8:	10049073          	csrw	sstatus,s1
}
    800029dc:	70a2                	ld	ra,40(sp)
    800029de:	7402                	ld	s0,32(sp)
    800029e0:	64e2                	ld	s1,24(sp)
    800029e2:	6942                	ld	s2,16(sp)
    800029e4:	69a2                	ld	s3,8(sp)
    800029e6:	6145                	add	sp,sp,48
    800029e8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800029ea:	00006517          	auipc	a0,0x6
    800029ee:	91650513          	add	a0,a0,-1770 # 80008300 <states.0+0xc0>
    800029f2:	ffffe097          	auipc	ra,0xffffe
    800029f6:	b50080e7          	jalr	-1200(ra) # 80000542 <panic>
    panic("kerneltrap: interrupts enabled");
    800029fa:	00006517          	auipc	a0,0x6
    800029fe:	92e50513          	add	a0,a0,-1746 # 80008328 <states.0+0xe8>
    80002a02:	ffffe097          	auipc	ra,0xffffe
    80002a06:	b40080e7          	jalr	-1216(ra) # 80000542 <panic>
    printf("scause %p\n", scause);
    80002a0a:	85ce                	mv	a1,s3
    80002a0c:	00006517          	auipc	a0,0x6
    80002a10:	93c50513          	add	a0,a0,-1732 # 80008348 <states.0+0x108>
    80002a14:	ffffe097          	auipc	ra,0xffffe
    80002a18:	b78080e7          	jalr	-1160(ra) # 8000058c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a1c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a20:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002a24:	00006517          	auipc	a0,0x6
    80002a28:	93450513          	add	a0,a0,-1740 # 80008358 <states.0+0x118>
    80002a2c:	ffffe097          	auipc	ra,0xffffe
    80002a30:	b60080e7          	jalr	-1184(ra) # 8000058c <printf>
    panic("kerneltrap");
    80002a34:	00006517          	auipc	a0,0x6
    80002a38:	93c50513          	add	a0,a0,-1732 # 80008370 <states.0+0x130>
    80002a3c:	ffffe097          	auipc	ra,0xffffe
    80002a40:	b06080e7          	jalr	-1274(ra) # 80000542 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002a44:	fffff097          	auipc	ra,0xfffff
    80002a48:	ffa080e7          	jalr	-6(ra) # 80001a3e <myproc>
    80002a4c:	d541                	beqz	a0,800029d4 <kerneltrap+0x38>
    80002a4e:	fffff097          	auipc	ra,0xfffff
    80002a52:	ff0080e7          	jalr	-16(ra) # 80001a3e <myproc>
    80002a56:	4d18                	lw	a4,24(a0)
    80002a58:	478d                	li	a5,3
    80002a5a:	f6f71de3          	bne	a4,a5,800029d4 <kerneltrap+0x38>
    yield();
    80002a5e:	fffff097          	auipc	ra,0xfffff
    80002a62:	7ba080e7          	jalr	1978(ra) # 80002218 <yield>
    80002a66:	b7bd                	j	800029d4 <kerneltrap+0x38>

0000000080002a68 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002a68:	1101                	add	sp,sp,-32
    80002a6a:	ec06                	sd	ra,24(sp)
    80002a6c:	e822                	sd	s0,16(sp)
    80002a6e:	e426                	sd	s1,8(sp)
    80002a70:	1000                	add	s0,sp,32
    80002a72:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002a74:	fffff097          	auipc	ra,0xfffff
    80002a78:	fca080e7          	jalr	-54(ra) # 80001a3e <myproc>
  switch (n) {
    80002a7c:	4795                	li	a5,5
    80002a7e:	0497e163          	bltu	a5,s1,80002ac0 <argraw+0x58>
    80002a82:	048a                	sll	s1,s1,0x2
    80002a84:	00006717          	auipc	a4,0x6
    80002a88:	92470713          	add	a4,a4,-1756 # 800083a8 <states.0+0x168>
    80002a8c:	94ba                	add	s1,s1,a4
    80002a8e:	409c                	lw	a5,0(s1)
    80002a90:	97ba                	add	a5,a5,a4
    80002a92:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002a94:	6d3c                	ld	a5,88(a0)
    80002a96:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002a98:	60e2                	ld	ra,24(sp)
    80002a9a:	6442                	ld	s0,16(sp)
    80002a9c:	64a2                	ld	s1,8(sp)
    80002a9e:	6105                	add	sp,sp,32
    80002aa0:	8082                	ret
    return p->trapframe->a1;
    80002aa2:	6d3c                	ld	a5,88(a0)
    80002aa4:	7fa8                	ld	a0,120(a5)
    80002aa6:	bfcd                	j	80002a98 <argraw+0x30>
    return p->trapframe->a2;
    80002aa8:	6d3c                	ld	a5,88(a0)
    80002aaa:	63c8                	ld	a0,128(a5)
    80002aac:	b7f5                	j	80002a98 <argraw+0x30>
    return p->trapframe->a3;
    80002aae:	6d3c                	ld	a5,88(a0)
    80002ab0:	67c8                	ld	a0,136(a5)
    80002ab2:	b7dd                	j	80002a98 <argraw+0x30>
    return p->trapframe->a4;
    80002ab4:	6d3c                	ld	a5,88(a0)
    80002ab6:	6bc8                	ld	a0,144(a5)
    80002ab8:	b7c5                	j	80002a98 <argraw+0x30>
    return p->trapframe->a5;
    80002aba:	6d3c                	ld	a5,88(a0)
    80002abc:	6fc8                	ld	a0,152(a5)
    80002abe:	bfe9                	j	80002a98 <argraw+0x30>
  panic("argraw");
    80002ac0:	00006517          	auipc	a0,0x6
    80002ac4:	8c050513          	add	a0,a0,-1856 # 80008380 <states.0+0x140>
    80002ac8:	ffffe097          	auipc	ra,0xffffe
    80002acc:	a7a080e7          	jalr	-1414(ra) # 80000542 <panic>

0000000080002ad0 <fetchaddr>:
{
    80002ad0:	1101                	add	sp,sp,-32
    80002ad2:	ec06                	sd	ra,24(sp)
    80002ad4:	e822                	sd	s0,16(sp)
    80002ad6:	e426                	sd	s1,8(sp)
    80002ad8:	e04a                	sd	s2,0(sp)
    80002ada:	1000                	add	s0,sp,32
    80002adc:	84aa                	mv	s1,a0
    80002ade:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002ae0:	fffff097          	auipc	ra,0xfffff
    80002ae4:	f5e080e7          	jalr	-162(ra) # 80001a3e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002ae8:	653c                	ld	a5,72(a0)
    80002aea:	02f4f863          	bgeu	s1,a5,80002b1a <fetchaddr+0x4a>
    80002aee:	00848713          	add	a4,s1,8
    80002af2:	02e7e663          	bltu	a5,a4,80002b1e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002af6:	46a1                	li	a3,8
    80002af8:	8626                	mv	a2,s1
    80002afa:	85ca                	mv	a1,s2
    80002afc:	6928                	ld	a0,80(a0)
    80002afe:	fffff097          	auipc	ra,0xfffff
    80002b02:	c6a080e7          	jalr	-918(ra) # 80001768 <copyin>
    80002b06:	00a03533          	snez	a0,a0
    80002b0a:	40a00533          	neg	a0,a0
}
    80002b0e:	60e2                	ld	ra,24(sp)
    80002b10:	6442                	ld	s0,16(sp)
    80002b12:	64a2                	ld	s1,8(sp)
    80002b14:	6902                	ld	s2,0(sp)
    80002b16:	6105                	add	sp,sp,32
    80002b18:	8082                	ret
    return -1;
    80002b1a:	557d                	li	a0,-1
    80002b1c:	bfcd                	j	80002b0e <fetchaddr+0x3e>
    80002b1e:	557d                	li	a0,-1
    80002b20:	b7fd                	j	80002b0e <fetchaddr+0x3e>

0000000080002b22 <fetchstr>:
{
    80002b22:	7179                	add	sp,sp,-48
    80002b24:	f406                	sd	ra,40(sp)
    80002b26:	f022                	sd	s0,32(sp)
    80002b28:	ec26                	sd	s1,24(sp)
    80002b2a:	e84a                	sd	s2,16(sp)
    80002b2c:	e44e                	sd	s3,8(sp)
    80002b2e:	1800                	add	s0,sp,48
    80002b30:	892a                	mv	s2,a0
    80002b32:	84ae                	mv	s1,a1
    80002b34:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002b36:	fffff097          	auipc	ra,0xfffff
    80002b3a:	f08080e7          	jalr	-248(ra) # 80001a3e <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002b3e:	86ce                	mv	a3,s3
    80002b40:	864a                	mv	a2,s2
    80002b42:	85a6                	mv	a1,s1
    80002b44:	6928                	ld	a0,80(a0)
    80002b46:	fffff097          	auipc	ra,0xfffff
    80002b4a:	d08080e7          	jalr	-760(ra) # 8000184e <copyinstr>
  if(err < 0)
    80002b4e:	00054763          	bltz	a0,80002b5c <fetchstr+0x3a>
  return strlen(buf);
    80002b52:	8526                	mv	a0,s1
    80002b54:	ffffe097          	auipc	ra,0xffffe
    80002b58:	326080e7          	jalr	806(ra) # 80000e7a <strlen>
}
    80002b5c:	70a2                	ld	ra,40(sp)
    80002b5e:	7402                	ld	s0,32(sp)
    80002b60:	64e2                	ld	s1,24(sp)
    80002b62:	6942                	ld	s2,16(sp)
    80002b64:	69a2                	ld	s3,8(sp)
    80002b66:	6145                	add	sp,sp,48
    80002b68:	8082                	ret

0000000080002b6a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002b6a:	1101                	add	sp,sp,-32
    80002b6c:	ec06                	sd	ra,24(sp)
    80002b6e:	e822                	sd	s0,16(sp)
    80002b70:	e426                	sd	s1,8(sp)
    80002b72:	1000                	add	s0,sp,32
    80002b74:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b76:	00000097          	auipc	ra,0x0
    80002b7a:	ef2080e7          	jalr	-270(ra) # 80002a68 <argraw>
    80002b7e:	c088                	sw	a0,0(s1)
  return 0;
}
    80002b80:	4501                	li	a0,0
    80002b82:	60e2                	ld	ra,24(sp)
    80002b84:	6442                	ld	s0,16(sp)
    80002b86:	64a2                	ld	s1,8(sp)
    80002b88:	6105                	add	sp,sp,32
    80002b8a:	8082                	ret

0000000080002b8c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002b8c:	1101                	add	sp,sp,-32
    80002b8e:	ec06                	sd	ra,24(sp)
    80002b90:	e822                	sd	s0,16(sp)
    80002b92:	e426                	sd	s1,8(sp)
    80002b94:	1000                	add	s0,sp,32
    80002b96:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b98:	00000097          	auipc	ra,0x0
    80002b9c:	ed0080e7          	jalr	-304(ra) # 80002a68 <argraw>
    80002ba0:	e088                	sd	a0,0(s1)
  return 0;
}
    80002ba2:	4501                	li	a0,0
    80002ba4:	60e2                	ld	ra,24(sp)
    80002ba6:	6442                	ld	s0,16(sp)
    80002ba8:	64a2                	ld	s1,8(sp)
    80002baa:	6105                	add	sp,sp,32
    80002bac:	8082                	ret

0000000080002bae <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002bae:	1101                	add	sp,sp,-32
    80002bb0:	ec06                	sd	ra,24(sp)
    80002bb2:	e822                	sd	s0,16(sp)
    80002bb4:	e426                	sd	s1,8(sp)
    80002bb6:	e04a                	sd	s2,0(sp)
    80002bb8:	1000                	add	s0,sp,32
    80002bba:	84ae                	mv	s1,a1
    80002bbc:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002bbe:	00000097          	auipc	ra,0x0
    80002bc2:	eaa080e7          	jalr	-342(ra) # 80002a68 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002bc6:	864a                	mv	a2,s2
    80002bc8:	85a6                	mv	a1,s1
    80002bca:	00000097          	auipc	ra,0x0
    80002bce:	f58080e7          	jalr	-168(ra) # 80002b22 <fetchstr>
}
    80002bd2:	60e2                	ld	ra,24(sp)
    80002bd4:	6442                	ld	s0,16(sp)
    80002bd6:	64a2                	ld	s1,8(sp)
    80002bd8:	6902                	ld	s2,0(sp)
    80002bda:	6105                	add	sp,sp,32
    80002bdc:	8082                	ret

0000000080002bde <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002bde:	1101                	add	sp,sp,-32
    80002be0:	ec06                	sd	ra,24(sp)
    80002be2:	e822                	sd	s0,16(sp)
    80002be4:	e426                	sd	s1,8(sp)
    80002be6:	e04a                	sd	s2,0(sp)
    80002be8:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002bea:	fffff097          	auipc	ra,0xfffff
    80002bee:	e54080e7          	jalr	-428(ra) # 80001a3e <myproc>
    80002bf2:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002bf4:	05853903          	ld	s2,88(a0)
    80002bf8:	0a893783          	ld	a5,168(s2)
    80002bfc:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002c00:	37fd                	addw	a5,a5,-1
    80002c02:	4751                	li	a4,20
    80002c04:	00f76f63          	bltu	a4,a5,80002c22 <syscall+0x44>
    80002c08:	00369713          	sll	a4,a3,0x3
    80002c0c:	00005797          	auipc	a5,0x5
    80002c10:	7b478793          	add	a5,a5,1972 # 800083c0 <syscalls>
    80002c14:	97ba                	add	a5,a5,a4
    80002c16:	639c                	ld	a5,0(a5)
    80002c18:	c789                	beqz	a5,80002c22 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002c1a:	9782                	jalr	a5
    80002c1c:	06a93823          	sd	a0,112(s2)
    80002c20:	a839                	j	80002c3e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002c22:	15848613          	add	a2,s1,344
    80002c26:	5c8c                	lw	a1,56(s1)
    80002c28:	00005517          	auipc	a0,0x5
    80002c2c:	76050513          	add	a0,a0,1888 # 80008388 <states.0+0x148>
    80002c30:	ffffe097          	auipc	ra,0xffffe
    80002c34:	95c080e7          	jalr	-1700(ra) # 8000058c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002c38:	6cbc                	ld	a5,88(s1)
    80002c3a:	577d                	li	a4,-1
    80002c3c:	fbb8                	sd	a4,112(a5)
  }
}
    80002c3e:	60e2                	ld	ra,24(sp)
    80002c40:	6442                	ld	s0,16(sp)
    80002c42:	64a2                	ld	s1,8(sp)
    80002c44:	6902                	ld	s2,0(sp)
    80002c46:	6105                	add	sp,sp,32
    80002c48:	8082                	ret

0000000080002c4a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002c4a:	1101                	add	sp,sp,-32
    80002c4c:	ec06                	sd	ra,24(sp)
    80002c4e:	e822                	sd	s0,16(sp)
    80002c50:	1000                	add	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002c52:	fec40593          	add	a1,s0,-20
    80002c56:	4501                	li	a0,0
    80002c58:	00000097          	auipc	ra,0x0
    80002c5c:	f12080e7          	jalr	-238(ra) # 80002b6a <argint>
    return -1;
    80002c60:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002c62:	00054963          	bltz	a0,80002c74 <sys_exit+0x2a>
  exit(n);
    80002c66:	fec42503          	lw	a0,-20(s0)
    80002c6a:	fffff097          	auipc	ra,0xfffff
    80002c6e:	4a4080e7          	jalr	1188(ra) # 8000210e <exit>
  return 0;  // not reached
    80002c72:	4781                	li	a5,0
}
    80002c74:	853e                	mv	a0,a5
    80002c76:	60e2                	ld	ra,24(sp)
    80002c78:	6442                	ld	s0,16(sp)
    80002c7a:	6105                	add	sp,sp,32
    80002c7c:	8082                	ret

0000000080002c7e <sys_getpid>:

uint64
sys_getpid(void)
{
    80002c7e:	1141                	add	sp,sp,-16
    80002c80:	e406                	sd	ra,8(sp)
    80002c82:	e022                	sd	s0,0(sp)
    80002c84:	0800                	add	s0,sp,16
  return myproc()->pid;
    80002c86:	fffff097          	auipc	ra,0xfffff
    80002c8a:	db8080e7          	jalr	-584(ra) # 80001a3e <myproc>
}
    80002c8e:	5d08                	lw	a0,56(a0)
    80002c90:	60a2                	ld	ra,8(sp)
    80002c92:	6402                	ld	s0,0(sp)
    80002c94:	0141                	add	sp,sp,16
    80002c96:	8082                	ret

0000000080002c98 <sys_fork>:

uint64
sys_fork(void)
{
    80002c98:	1141                	add	sp,sp,-16
    80002c9a:	e406                	sd	ra,8(sp)
    80002c9c:	e022                	sd	s0,0(sp)
    80002c9e:	0800                	add	s0,sp,16
  return fork();
    80002ca0:	fffff097          	auipc	ra,0xfffff
    80002ca4:	162080e7          	jalr	354(ra) # 80001e02 <fork>
}
    80002ca8:	60a2                	ld	ra,8(sp)
    80002caa:	6402                	ld	s0,0(sp)
    80002cac:	0141                	add	sp,sp,16
    80002cae:	8082                	ret

0000000080002cb0 <sys_wait>:

uint64
sys_wait(void)
{
    80002cb0:	1101                	add	sp,sp,-32
    80002cb2:	ec06                	sd	ra,24(sp)
    80002cb4:	e822                	sd	s0,16(sp)
    80002cb6:	1000                	add	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002cb8:	fe840593          	add	a1,s0,-24
    80002cbc:	4501                	li	a0,0
    80002cbe:	00000097          	auipc	ra,0x0
    80002cc2:	ece080e7          	jalr	-306(ra) # 80002b8c <argaddr>
    80002cc6:	87aa                	mv	a5,a0
    return -1;
    80002cc8:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002cca:	0007c863          	bltz	a5,80002cda <sys_wait+0x2a>
  return wait(p);
    80002cce:	fe843503          	ld	a0,-24(s0)
    80002cd2:	fffff097          	auipc	ra,0xfffff
    80002cd6:	600080e7          	jalr	1536(ra) # 800022d2 <wait>
}
    80002cda:	60e2                	ld	ra,24(sp)
    80002cdc:	6442                	ld	s0,16(sp)
    80002cde:	6105                	add	sp,sp,32
    80002ce0:	8082                	ret

0000000080002ce2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002ce2:	7179                	add	sp,sp,-48
    80002ce4:	f406                	sd	ra,40(sp)
    80002ce6:	f022                	sd	s0,32(sp)
    80002ce8:	ec26                	sd	s1,24(sp)
    80002cea:	e84a                	sd	s2,16(sp)
    80002cec:	1800                	add	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002cee:	fdc40593          	add	a1,s0,-36
    80002cf2:	4501                	li	a0,0
    80002cf4:	00000097          	auipc	ra,0x0
    80002cf8:	e76080e7          	jalr	-394(ra) # 80002b6a <argint>
    80002cfc:	87aa                	mv	a5,a0
    return -1;
    80002cfe:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002d00:	0207c363          	bltz	a5,80002d26 <sys_sbrk+0x44>
  addr = myproc()->sz;
    80002d04:	fffff097          	auipc	ra,0xfffff
    80002d08:	d3a080e7          	jalr	-710(ra) # 80001a3e <myproc>
    80002d0c:	4524                	lw	s1,72(a0)
  myproc()->sz += n; // 只增加sz的数值大小，不实际分配内存
    80002d0e:	fffff097          	auipc	ra,0xfffff
    80002d12:	d30080e7          	jalr	-720(ra) # 80001a3e <myproc>
    80002d16:	fdc42703          	lw	a4,-36(s0)
    80002d1a:	653c                	ld	a5,72(a0)
    80002d1c:	97ba                	add	a5,a5,a4
    80002d1e:	e53c                	sd	a5,72(a0)
  if (n < 0) { // n小于0的情况为释放内存，立即执行
    80002d20:	00074963          	bltz	a4,80002d32 <sys_sbrk+0x50>
    uvmdealloc(myproc()->pagetable, addr, myproc()->sz);
  }
  return addr;
    80002d24:	8526                	mv	a0,s1
}
    80002d26:	70a2                	ld	ra,40(sp)
    80002d28:	7402                	ld	s0,32(sp)
    80002d2a:	64e2                	ld	s1,24(sp)
    80002d2c:	6942                	ld	s2,16(sp)
    80002d2e:	6145                	add	sp,sp,48
    80002d30:	8082                	ret
    uvmdealloc(myproc()->pagetable, addr, myproc()->sz);
    80002d32:	fffff097          	auipc	ra,0xfffff
    80002d36:	d0c080e7          	jalr	-756(ra) # 80001a3e <myproc>
    80002d3a:	05053903          	ld	s2,80(a0)
    80002d3e:	fffff097          	auipc	ra,0xfffff
    80002d42:	d00080e7          	jalr	-768(ra) # 80001a3e <myproc>
    80002d46:	6530                	ld	a2,72(a0)
    80002d48:	85a6                	mv	a1,s1
    80002d4a:	854a                	mv	a0,s2
    80002d4c:	ffffe097          	auipc	ra,0xffffe
    80002d50:	6b6080e7          	jalr	1718(ra) # 80001402 <uvmdealloc>
    80002d54:	bfc1                	j	80002d24 <sys_sbrk+0x42>

0000000080002d56 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002d56:	7139                	add	sp,sp,-64
    80002d58:	fc06                	sd	ra,56(sp)
    80002d5a:	f822                	sd	s0,48(sp)
    80002d5c:	f426                	sd	s1,40(sp)
    80002d5e:	f04a                	sd	s2,32(sp)
    80002d60:	ec4e                	sd	s3,24(sp)
    80002d62:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002d64:	fcc40593          	add	a1,s0,-52
    80002d68:	4501                	li	a0,0
    80002d6a:	00000097          	auipc	ra,0x0
    80002d6e:	e00080e7          	jalr	-512(ra) # 80002b6a <argint>
    return -1;
    80002d72:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002d74:	06054563          	bltz	a0,80002dde <sys_sleep+0x88>
  acquire(&tickslock);
    80002d78:	00015517          	auipc	a0,0x15
    80002d7c:	9f050513          	add	a0,a0,-1552 # 80017768 <tickslock>
    80002d80:	ffffe097          	auipc	ra,0xffffe
    80002d84:	e7c080e7          	jalr	-388(ra) # 80000bfc <acquire>
  ticks0 = ticks;
    80002d88:	00006917          	auipc	s2,0x6
    80002d8c:	29892903          	lw	s2,664(s2) # 80009020 <ticks>
  while(ticks - ticks0 < n){
    80002d90:	fcc42783          	lw	a5,-52(s0)
    80002d94:	cf85                	beqz	a5,80002dcc <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002d96:	00015997          	auipc	s3,0x15
    80002d9a:	9d298993          	add	s3,s3,-1582 # 80017768 <tickslock>
    80002d9e:	00006497          	auipc	s1,0x6
    80002da2:	28248493          	add	s1,s1,642 # 80009020 <ticks>
    if(myproc()->killed){
    80002da6:	fffff097          	auipc	ra,0xfffff
    80002daa:	c98080e7          	jalr	-872(ra) # 80001a3e <myproc>
    80002dae:	591c                	lw	a5,48(a0)
    80002db0:	ef9d                	bnez	a5,80002dee <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002db2:	85ce                	mv	a1,s3
    80002db4:	8526                	mv	a0,s1
    80002db6:	fffff097          	auipc	ra,0xfffff
    80002dba:	49e080e7          	jalr	1182(ra) # 80002254 <sleep>
  while(ticks - ticks0 < n){
    80002dbe:	409c                	lw	a5,0(s1)
    80002dc0:	412787bb          	subw	a5,a5,s2
    80002dc4:	fcc42703          	lw	a4,-52(s0)
    80002dc8:	fce7efe3          	bltu	a5,a4,80002da6 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002dcc:	00015517          	auipc	a0,0x15
    80002dd0:	99c50513          	add	a0,a0,-1636 # 80017768 <tickslock>
    80002dd4:	ffffe097          	auipc	ra,0xffffe
    80002dd8:	edc080e7          	jalr	-292(ra) # 80000cb0 <release>
  return 0;
    80002ddc:	4781                	li	a5,0
}
    80002dde:	853e                	mv	a0,a5
    80002de0:	70e2                	ld	ra,56(sp)
    80002de2:	7442                	ld	s0,48(sp)
    80002de4:	74a2                	ld	s1,40(sp)
    80002de6:	7902                	ld	s2,32(sp)
    80002de8:	69e2                	ld	s3,24(sp)
    80002dea:	6121                	add	sp,sp,64
    80002dec:	8082                	ret
      release(&tickslock);
    80002dee:	00015517          	auipc	a0,0x15
    80002df2:	97a50513          	add	a0,a0,-1670 # 80017768 <tickslock>
    80002df6:	ffffe097          	auipc	ra,0xffffe
    80002dfa:	eba080e7          	jalr	-326(ra) # 80000cb0 <release>
      return -1;
    80002dfe:	57fd                	li	a5,-1
    80002e00:	bff9                	j	80002dde <sys_sleep+0x88>

0000000080002e02 <sys_kill>:

uint64
sys_kill(void)
{
    80002e02:	1101                	add	sp,sp,-32
    80002e04:	ec06                	sd	ra,24(sp)
    80002e06:	e822                	sd	s0,16(sp)
    80002e08:	1000                	add	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002e0a:	fec40593          	add	a1,s0,-20
    80002e0e:	4501                	li	a0,0
    80002e10:	00000097          	auipc	ra,0x0
    80002e14:	d5a080e7          	jalr	-678(ra) # 80002b6a <argint>
    80002e18:	87aa                	mv	a5,a0
    return -1;
    80002e1a:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002e1c:	0007c863          	bltz	a5,80002e2c <sys_kill+0x2a>
  return kill(pid);
    80002e20:	fec42503          	lw	a0,-20(s0)
    80002e24:	fffff097          	auipc	ra,0xfffff
    80002e28:	61a080e7          	jalr	1562(ra) # 8000243e <kill>
}
    80002e2c:	60e2                	ld	ra,24(sp)
    80002e2e:	6442                	ld	s0,16(sp)
    80002e30:	6105                	add	sp,sp,32
    80002e32:	8082                	ret

0000000080002e34 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002e34:	1101                	add	sp,sp,-32
    80002e36:	ec06                	sd	ra,24(sp)
    80002e38:	e822                	sd	s0,16(sp)
    80002e3a:	e426                	sd	s1,8(sp)
    80002e3c:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002e3e:	00015517          	auipc	a0,0x15
    80002e42:	92a50513          	add	a0,a0,-1750 # 80017768 <tickslock>
    80002e46:	ffffe097          	auipc	ra,0xffffe
    80002e4a:	db6080e7          	jalr	-586(ra) # 80000bfc <acquire>
  xticks = ticks;
    80002e4e:	00006497          	auipc	s1,0x6
    80002e52:	1d24a483          	lw	s1,466(s1) # 80009020 <ticks>
  release(&tickslock);
    80002e56:	00015517          	auipc	a0,0x15
    80002e5a:	91250513          	add	a0,a0,-1774 # 80017768 <tickslock>
    80002e5e:	ffffe097          	auipc	ra,0xffffe
    80002e62:	e52080e7          	jalr	-430(ra) # 80000cb0 <release>
  return xticks;
}
    80002e66:	02049513          	sll	a0,s1,0x20
    80002e6a:	9101                	srl	a0,a0,0x20
    80002e6c:	60e2                	ld	ra,24(sp)
    80002e6e:	6442                	ld	s0,16(sp)
    80002e70:	64a2                	ld	s1,8(sp)
    80002e72:	6105                	add	sp,sp,32
    80002e74:	8082                	ret

0000000080002e76 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002e76:	7179                	add	sp,sp,-48
    80002e78:	f406                	sd	ra,40(sp)
    80002e7a:	f022                	sd	s0,32(sp)
    80002e7c:	ec26                	sd	s1,24(sp)
    80002e7e:	e84a                	sd	s2,16(sp)
    80002e80:	e44e                	sd	s3,8(sp)
    80002e82:	e052                	sd	s4,0(sp)
    80002e84:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002e86:	00005597          	auipc	a1,0x5
    80002e8a:	5ea58593          	add	a1,a1,1514 # 80008470 <syscalls+0xb0>
    80002e8e:	00015517          	auipc	a0,0x15
    80002e92:	8f250513          	add	a0,a0,-1806 # 80017780 <bcache>
    80002e96:	ffffe097          	auipc	ra,0xffffe
    80002e9a:	cd6080e7          	jalr	-810(ra) # 80000b6c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002e9e:	0001d797          	auipc	a5,0x1d
    80002ea2:	8e278793          	add	a5,a5,-1822 # 8001f780 <bcache+0x8000>
    80002ea6:	0001d717          	auipc	a4,0x1d
    80002eaa:	b4270713          	add	a4,a4,-1214 # 8001f9e8 <bcache+0x8268>
    80002eae:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002eb2:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002eb6:	00015497          	auipc	s1,0x15
    80002eba:	8e248493          	add	s1,s1,-1822 # 80017798 <bcache+0x18>
    b->next = bcache.head.next;
    80002ebe:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002ec0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002ec2:	00005a17          	auipc	s4,0x5
    80002ec6:	5b6a0a13          	add	s4,s4,1462 # 80008478 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002eca:	2b893783          	ld	a5,696(s2)
    80002ece:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002ed0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002ed4:	85d2                	mv	a1,s4
    80002ed6:	01048513          	add	a0,s1,16
    80002eda:	00001097          	auipc	ra,0x1
    80002ede:	484080e7          	jalr	1156(ra) # 8000435e <initsleeplock>
    bcache.head.next->prev = b;
    80002ee2:	2b893783          	ld	a5,696(s2)
    80002ee6:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002ee8:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002eec:	45848493          	add	s1,s1,1112
    80002ef0:	fd349de3          	bne	s1,s3,80002eca <binit+0x54>
  }
}
    80002ef4:	70a2                	ld	ra,40(sp)
    80002ef6:	7402                	ld	s0,32(sp)
    80002ef8:	64e2                	ld	s1,24(sp)
    80002efa:	6942                	ld	s2,16(sp)
    80002efc:	69a2                	ld	s3,8(sp)
    80002efe:	6a02                	ld	s4,0(sp)
    80002f00:	6145                	add	sp,sp,48
    80002f02:	8082                	ret

0000000080002f04 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002f04:	7179                	add	sp,sp,-48
    80002f06:	f406                	sd	ra,40(sp)
    80002f08:	f022                	sd	s0,32(sp)
    80002f0a:	ec26                	sd	s1,24(sp)
    80002f0c:	e84a                	sd	s2,16(sp)
    80002f0e:	e44e                	sd	s3,8(sp)
    80002f10:	1800                	add	s0,sp,48
    80002f12:	892a                	mv	s2,a0
    80002f14:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002f16:	00015517          	auipc	a0,0x15
    80002f1a:	86a50513          	add	a0,a0,-1942 # 80017780 <bcache>
    80002f1e:	ffffe097          	auipc	ra,0xffffe
    80002f22:	cde080e7          	jalr	-802(ra) # 80000bfc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002f26:	0001d497          	auipc	s1,0x1d
    80002f2a:	b124b483          	ld	s1,-1262(s1) # 8001fa38 <bcache+0x82b8>
    80002f2e:	0001d797          	auipc	a5,0x1d
    80002f32:	aba78793          	add	a5,a5,-1350 # 8001f9e8 <bcache+0x8268>
    80002f36:	02f48f63          	beq	s1,a5,80002f74 <bread+0x70>
    80002f3a:	873e                	mv	a4,a5
    80002f3c:	a021                	j	80002f44 <bread+0x40>
    80002f3e:	68a4                	ld	s1,80(s1)
    80002f40:	02e48a63          	beq	s1,a4,80002f74 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002f44:	449c                	lw	a5,8(s1)
    80002f46:	ff279ce3          	bne	a5,s2,80002f3e <bread+0x3a>
    80002f4a:	44dc                	lw	a5,12(s1)
    80002f4c:	ff3799e3          	bne	a5,s3,80002f3e <bread+0x3a>
      b->refcnt++;
    80002f50:	40bc                	lw	a5,64(s1)
    80002f52:	2785                	addw	a5,a5,1
    80002f54:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f56:	00015517          	auipc	a0,0x15
    80002f5a:	82a50513          	add	a0,a0,-2006 # 80017780 <bcache>
    80002f5e:	ffffe097          	auipc	ra,0xffffe
    80002f62:	d52080e7          	jalr	-686(ra) # 80000cb0 <release>
      acquiresleep(&b->lock);
    80002f66:	01048513          	add	a0,s1,16
    80002f6a:	00001097          	auipc	ra,0x1
    80002f6e:	42e080e7          	jalr	1070(ra) # 80004398 <acquiresleep>
      return b;
    80002f72:	a8b9                	j	80002fd0 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f74:	0001d497          	auipc	s1,0x1d
    80002f78:	abc4b483          	ld	s1,-1348(s1) # 8001fa30 <bcache+0x82b0>
    80002f7c:	0001d797          	auipc	a5,0x1d
    80002f80:	a6c78793          	add	a5,a5,-1428 # 8001f9e8 <bcache+0x8268>
    80002f84:	00f48863          	beq	s1,a5,80002f94 <bread+0x90>
    80002f88:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002f8a:	40bc                	lw	a5,64(s1)
    80002f8c:	cf81                	beqz	a5,80002fa4 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f8e:	64a4                	ld	s1,72(s1)
    80002f90:	fee49de3          	bne	s1,a4,80002f8a <bread+0x86>
  panic("bget: no buffers");
    80002f94:	00005517          	auipc	a0,0x5
    80002f98:	4ec50513          	add	a0,a0,1260 # 80008480 <syscalls+0xc0>
    80002f9c:	ffffd097          	auipc	ra,0xffffd
    80002fa0:	5a6080e7          	jalr	1446(ra) # 80000542 <panic>
      b->dev = dev;
    80002fa4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002fa8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002fac:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002fb0:	4785                	li	a5,1
    80002fb2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002fb4:	00014517          	auipc	a0,0x14
    80002fb8:	7cc50513          	add	a0,a0,1996 # 80017780 <bcache>
    80002fbc:	ffffe097          	auipc	ra,0xffffe
    80002fc0:	cf4080e7          	jalr	-780(ra) # 80000cb0 <release>
      acquiresleep(&b->lock);
    80002fc4:	01048513          	add	a0,s1,16
    80002fc8:	00001097          	auipc	ra,0x1
    80002fcc:	3d0080e7          	jalr	976(ra) # 80004398 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002fd0:	409c                	lw	a5,0(s1)
    80002fd2:	cb89                	beqz	a5,80002fe4 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002fd4:	8526                	mv	a0,s1
    80002fd6:	70a2                	ld	ra,40(sp)
    80002fd8:	7402                	ld	s0,32(sp)
    80002fda:	64e2                	ld	s1,24(sp)
    80002fdc:	6942                	ld	s2,16(sp)
    80002fde:	69a2                	ld	s3,8(sp)
    80002fe0:	6145                	add	sp,sp,48
    80002fe2:	8082                	ret
    virtio_disk_rw(b, 0);
    80002fe4:	4581                	li	a1,0
    80002fe6:	8526                	mv	a0,s1
    80002fe8:	00003097          	auipc	ra,0x3
    80002fec:	ed0080e7          	jalr	-304(ra) # 80005eb8 <virtio_disk_rw>
    b->valid = 1;
    80002ff0:	4785                	li	a5,1
    80002ff2:	c09c                	sw	a5,0(s1)
  return b;
    80002ff4:	b7c5                	j	80002fd4 <bread+0xd0>

0000000080002ff6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002ff6:	1101                	add	sp,sp,-32
    80002ff8:	ec06                	sd	ra,24(sp)
    80002ffa:	e822                	sd	s0,16(sp)
    80002ffc:	e426                	sd	s1,8(sp)
    80002ffe:	1000                	add	s0,sp,32
    80003000:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003002:	0541                	add	a0,a0,16
    80003004:	00001097          	auipc	ra,0x1
    80003008:	42e080e7          	jalr	1070(ra) # 80004432 <holdingsleep>
    8000300c:	cd01                	beqz	a0,80003024 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000300e:	4585                	li	a1,1
    80003010:	8526                	mv	a0,s1
    80003012:	00003097          	auipc	ra,0x3
    80003016:	ea6080e7          	jalr	-346(ra) # 80005eb8 <virtio_disk_rw>
}
    8000301a:	60e2                	ld	ra,24(sp)
    8000301c:	6442                	ld	s0,16(sp)
    8000301e:	64a2                	ld	s1,8(sp)
    80003020:	6105                	add	sp,sp,32
    80003022:	8082                	ret
    panic("bwrite");
    80003024:	00005517          	auipc	a0,0x5
    80003028:	47450513          	add	a0,a0,1140 # 80008498 <syscalls+0xd8>
    8000302c:	ffffd097          	auipc	ra,0xffffd
    80003030:	516080e7          	jalr	1302(ra) # 80000542 <panic>

0000000080003034 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003034:	1101                	add	sp,sp,-32
    80003036:	ec06                	sd	ra,24(sp)
    80003038:	e822                	sd	s0,16(sp)
    8000303a:	e426                	sd	s1,8(sp)
    8000303c:	e04a                	sd	s2,0(sp)
    8000303e:	1000                	add	s0,sp,32
    80003040:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003042:	01050913          	add	s2,a0,16
    80003046:	854a                	mv	a0,s2
    80003048:	00001097          	auipc	ra,0x1
    8000304c:	3ea080e7          	jalr	1002(ra) # 80004432 <holdingsleep>
    80003050:	c925                	beqz	a0,800030c0 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80003052:	854a                	mv	a0,s2
    80003054:	00001097          	auipc	ra,0x1
    80003058:	39a080e7          	jalr	922(ra) # 800043ee <releasesleep>

  acquire(&bcache.lock);
    8000305c:	00014517          	auipc	a0,0x14
    80003060:	72450513          	add	a0,a0,1828 # 80017780 <bcache>
    80003064:	ffffe097          	auipc	ra,0xffffe
    80003068:	b98080e7          	jalr	-1128(ra) # 80000bfc <acquire>
  b->refcnt--;
    8000306c:	40bc                	lw	a5,64(s1)
    8000306e:	37fd                	addw	a5,a5,-1
    80003070:	0007871b          	sext.w	a4,a5
    80003074:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003076:	e71d                	bnez	a4,800030a4 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003078:	68b8                	ld	a4,80(s1)
    8000307a:	64bc                	ld	a5,72(s1)
    8000307c:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000307e:	68b8                	ld	a4,80(s1)
    80003080:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003082:	0001c797          	auipc	a5,0x1c
    80003086:	6fe78793          	add	a5,a5,1790 # 8001f780 <bcache+0x8000>
    8000308a:	2b87b703          	ld	a4,696(a5)
    8000308e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003090:	0001d717          	auipc	a4,0x1d
    80003094:	95870713          	add	a4,a4,-1704 # 8001f9e8 <bcache+0x8268>
    80003098:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000309a:	2b87b703          	ld	a4,696(a5)
    8000309e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800030a0:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800030a4:	00014517          	auipc	a0,0x14
    800030a8:	6dc50513          	add	a0,a0,1756 # 80017780 <bcache>
    800030ac:	ffffe097          	auipc	ra,0xffffe
    800030b0:	c04080e7          	jalr	-1020(ra) # 80000cb0 <release>
}
    800030b4:	60e2                	ld	ra,24(sp)
    800030b6:	6442                	ld	s0,16(sp)
    800030b8:	64a2                	ld	s1,8(sp)
    800030ba:	6902                	ld	s2,0(sp)
    800030bc:	6105                	add	sp,sp,32
    800030be:	8082                	ret
    panic("brelse");
    800030c0:	00005517          	auipc	a0,0x5
    800030c4:	3e050513          	add	a0,a0,992 # 800084a0 <syscalls+0xe0>
    800030c8:	ffffd097          	auipc	ra,0xffffd
    800030cc:	47a080e7          	jalr	1146(ra) # 80000542 <panic>

00000000800030d0 <bpin>:

void
bpin(struct buf *b) {
    800030d0:	1101                	add	sp,sp,-32
    800030d2:	ec06                	sd	ra,24(sp)
    800030d4:	e822                	sd	s0,16(sp)
    800030d6:	e426                	sd	s1,8(sp)
    800030d8:	1000                	add	s0,sp,32
    800030da:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800030dc:	00014517          	auipc	a0,0x14
    800030e0:	6a450513          	add	a0,a0,1700 # 80017780 <bcache>
    800030e4:	ffffe097          	auipc	ra,0xffffe
    800030e8:	b18080e7          	jalr	-1256(ra) # 80000bfc <acquire>
  b->refcnt++;
    800030ec:	40bc                	lw	a5,64(s1)
    800030ee:	2785                	addw	a5,a5,1
    800030f0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800030f2:	00014517          	auipc	a0,0x14
    800030f6:	68e50513          	add	a0,a0,1678 # 80017780 <bcache>
    800030fa:	ffffe097          	auipc	ra,0xffffe
    800030fe:	bb6080e7          	jalr	-1098(ra) # 80000cb0 <release>
}
    80003102:	60e2                	ld	ra,24(sp)
    80003104:	6442                	ld	s0,16(sp)
    80003106:	64a2                	ld	s1,8(sp)
    80003108:	6105                	add	sp,sp,32
    8000310a:	8082                	ret

000000008000310c <bunpin>:

void
bunpin(struct buf *b) {
    8000310c:	1101                	add	sp,sp,-32
    8000310e:	ec06                	sd	ra,24(sp)
    80003110:	e822                	sd	s0,16(sp)
    80003112:	e426                	sd	s1,8(sp)
    80003114:	1000                	add	s0,sp,32
    80003116:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003118:	00014517          	auipc	a0,0x14
    8000311c:	66850513          	add	a0,a0,1640 # 80017780 <bcache>
    80003120:	ffffe097          	auipc	ra,0xffffe
    80003124:	adc080e7          	jalr	-1316(ra) # 80000bfc <acquire>
  b->refcnt--;
    80003128:	40bc                	lw	a5,64(s1)
    8000312a:	37fd                	addw	a5,a5,-1
    8000312c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000312e:	00014517          	auipc	a0,0x14
    80003132:	65250513          	add	a0,a0,1618 # 80017780 <bcache>
    80003136:	ffffe097          	auipc	ra,0xffffe
    8000313a:	b7a080e7          	jalr	-1158(ra) # 80000cb0 <release>
}
    8000313e:	60e2                	ld	ra,24(sp)
    80003140:	6442                	ld	s0,16(sp)
    80003142:	64a2                	ld	s1,8(sp)
    80003144:	6105                	add	sp,sp,32
    80003146:	8082                	ret

0000000080003148 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003148:	1101                	add	sp,sp,-32
    8000314a:	ec06                	sd	ra,24(sp)
    8000314c:	e822                	sd	s0,16(sp)
    8000314e:	e426                	sd	s1,8(sp)
    80003150:	e04a                	sd	s2,0(sp)
    80003152:	1000                	add	s0,sp,32
    80003154:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003156:	00d5d59b          	srlw	a1,a1,0xd
    8000315a:	0001d797          	auipc	a5,0x1d
    8000315e:	d027a783          	lw	a5,-766(a5) # 8001fe5c <sb+0x1c>
    80003162:	9dbd                	addw	a1,a1,a5
    80003164:	00000097          	auipc	ra,0x0
    80003168:	da0080e7          	jalr	-608(ra) # 80002f04 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000316c:	0074f713          	and	a4,s1,7
    80003170:	4785                	li	a5,1
    80003172:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003176:	14ce                	sll	s1,s1,0x33
    80003178:	90d9                	srl	s1,s1,0x36
    8000317a:	00950733          	add	a4,a0,s1
    8000317e:	05874703          	lbu	a4,88(a4)
    80003182:	00e7f6b3          	and	a3,a5,a4
    80003186:	c69d                	beqz	a3,800031b4 <bfree+0x6c>
    80003188:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000318a:	94aa                	add	s1,s1,a0
    8000318c:	fff7c793          	not	a5,a5
    80003190:	8f7d                	and	a4,a4,a5
    80003192:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003196:	00001097          	auipc	ra,0x1
    8000319a:	0dc080e7          	jalr	220(ra) # 80004272 <log_write>
  brelse(bp);
    8000319e:	854a                	mv	a0,s2
    800031a0:	00000097          	auipc	ra,0x0
    800031a4:	e94080e7          	jalr	-364(ra) # 80003034 <brelse>
}
    800031a8:	60e2                	ld	ra,24(sp)
    800031aa:	6442                	ld	s0,16(sp)
    800031ac:	64a2                	ld	s1,8(sp)
    800031ae:	6902                	ld	s2,0(sp)
    800031b0:	6105                	add	sp,sp,32
    800031b2:	8082                	ret
    panic("freeing free block");
    800031b4:	00005517          	auipc	a0,0x5
    800031b8:	2f450513          	add	a0,a0,756 # 800084a8 <syscalls+0xe8>
    800031bc:	ffffd097          	auipc	ra,0xffffd
    800031c0:	386080e7          	jalr	902(ra) # 80000542 <panic>

00000000800031c4 <balloc>:
{
    800031c4:	711d                	add	sp,sp,-96
    800031c6:	ec86                	sd	ra,88(sp)
    800031c8:	e8a2                	sd	s0,80(sp)
    800031ca:	e4a6                	sd	s1,72(sp)
    800031cc:	e0ca                	sd	s2,64(sp)
    800031ce:	fc4e                	sd	s3,56(sp)
    800031d0:	f852                	sd	s4,48(sp)
    800031d2:	f456                	sd	s5,40(sp)
    800031d4:	f05a                	sd	s6,32(sp)
    800031d6:	ec5e                	sd	s7,24(sp)
    800031d8:	e862                	sd	s8,16(sp)
    800031da:	e466                	sd	s9,8(sp)
    800031dc:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800031de:	0001d797          	auipc	a5,0x1d
    800031e2:	c667a783          	lw	a5,-922(a5) # 8001fe44 <sb+0x4>
    800031e6:	cbc1                	beqz	a5,80003276 <balloc+0xb2>
    800031e8:	8baa                	mv	s7,a0
    800031ea:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800031ec:	0001db17          	auipc	s6,0x1d
    800031f0:	c54b0b13          	add	s6,s6,-940 # 8001fe40 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031f4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800031f6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031f8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800031fa:	6c89                	lui	s9,0x2
    800031fc:	a831                	j	80003218 <balloc+0x54>
    brelse(bp);
    800031fe:	854a                	mv	a0,s2
    80003200:	00000097          	auipc	ra,0x0
    80003204:	e34080e7          	jalr	-460(ra) # 80003034 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003208:	015c87bb          	addw	a5,s9,s5
    8000320c:	00078a9b          	sext.w	s5,a5
    80003210:	004b2703          	lw	a4,4(s6)
    80003214:	06eaf163          	bgeu	s5,a4,80003276 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80003218:	41fad79b          	sraw	a5,s5,0x1f
    8000321c:	0137d79b          	srlw	a5,a5,0x13
    80003220:	015787bb          	addw	a5,a5,s5
    80003224:	40d7d79b          	sraw	a5,a5,0xd
    80003228:	01cb2583          	lw	a1,28(s6)
    8000322c:	9dbd                	addw	a1,a1,a5
    8000322e:	855e                	mv	a0,s7
    80003230:	00000097          	auipc	ra,0x0
    80003234:	cd4080e7          	jalr	-812(ra) # 80002f04 <bread>
    80003238:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000323a:	004b2503          	lw	a0,4(s6)
    8000323e:	000a849b          	sext.w	s1,s5
    80003242:	8762                	mv	a4,s8
    80003244:	faa4fde3          	bgeu	s1,a0,800031fe <balloc+0x3a>
      m = 1 << (bi % 8);
    80003248:	00777693          	and	a3,a4,7
    8000324c:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003250:	41f7579b          	sraw	a5,a4,0x1f
    80003254:	01d7d79b          	srlw	a5,a5,0x1d
    80003258:	9fb9                	addw	a5,a5,a4
    8000325a:	4037d79b          	sraw	a5,a5,0x3
    8000325e:	00f90633          	add	a2,s2,a5
    80003262:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    80003266:	00c6f5b3          	and	a1,a3,a2
    8000326a:	cd91                	beqz	a1,80003286 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000326c:	2705                	addw	a4,a4,1
    8000326e:	2485                	addw	s1,s1,1
    80003270:	fd471ae3          	bne	a4,s4,80003244 <balloc+0x80>
    80003274:	b769                	j	800031fe <balloc+0x3a>
  panic("balloc: out of blocks");
    80003276:	00005517          	auipc	a0,0x5
    8000327a:	24a50513          	add	a0,a0,586 # 800084c0 <syscalls+0x100>
    8000327e:	ffffd097          	auipc	ra,0xffffd
    80003282:	2c4080e7          	jalr	708(ra) # 80000542 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003286:	97ca                	add	a5,a5,s2
    80003288:	8e55                	or	a2,a2,a3
    8000328a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000328e:	854a                	mv	a0,s2
    80003290:	00001097          	auipc	ra,0x1
    80003294:	fe2080e7          	jalr	-30(ra) # 80004272 <log_write>
        brelse(bp);
    80003298:	854a                	mv	a0,s2
    8000329a:	00000097          	auipc	ra,0x0
    8000329e:	d9a080e7          	jalr	-614(ra) # 80003034 <brelse>
  bp = bread(dev, bno);
    800032a2:	85a6                	mv	a1,s1
    800032a4:	855e                	mv	a0,s7
    800032a6:	00000097          	auipc	ra,0x0
    800032aa:	c5e080e7          	jalr	-930(ra) # 80002f04 <bread>
    800032ae:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800032b0:	40000613          	li	a2,1024
    800032b4:	4581                	li	a1,0
    800032b6:	05850513          	add	a0,a0,88
    800032ba:	ffffe097          	auipc	ra,0xffffe
    800032be:	a3e080e7          	jalr	-1474(ra) # 80000cf8 <memset>
  log_write(bp);
    800032c2:	854a                	mv	a0,s2
    800032c4:	00001097          	auipc	ra,0x1
    800032c8:	fae080e7          	jalr	-82(ra) # 80004272 <log_write>
  brelse(bp);
    800032cc:	854a                	mv	a0,s2
    800032ce:	00000097          	auipc	ra,0x0
    800032d2:	d66080e7          	jalr	-666(ra) # 80003034 <brelse>
}
    800032d6:	8526                	mv	a0,s1
    800032d8:	60e6                	ld	ra,88(sp)
    800032da:	6446                	ld	s0,80(sp)
    800032dc:	64a6                	ld	s1,72(sp)
    800032de:	6906                	ld	s2,64(sp)
    800032e0:	79e2                	ld	s3,56(sp)
    800032e2:	7a42                	ld	s4,48(sp)
    800032e4:	7aa2                	ld	s5,40(sp)
    800032e6:	7b02                	ld	s6,32(sp)
    800032e8:	6be2                	ld	s7,24(sp)
    800032ea:	6c42                	ld	s8,16(sp)
    800032ec:	6ca2                	ld	s9,8(sp)
    800032ee:	6125                	add	sp,sp,96
    800032f0:	8082                	ret

00000000800032f2 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800032f2:	7179                	add	sp,sp,-48
    800032f4:	f406                	sd	ra,40(sp)
    800032f6:	f022                	sd	s0,32(sp)
    800032f8:	ec26                	sd	s1,24(sp)
    800032fa:	e84a                	sd	s2,16(sp)
    800032fc:	e44e                	sd	s3,8(sp)
    800032fe:	e052                	sd	s4,0(sp)
    80003300:	1800                	add	s0,sp,48
    80003302:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003304:	47ad                	li	a5,11
    80003306:	04b7fe63          	bgeu	a5,a1,80003362 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000330a:	ff45849b          	addw	s1,a1,-12
    8000330e:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003312:	0ff00793          	li	a5,255
    80003316:	0ae7e463          	bltu	a5,a4,800033be <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000331a:	08052583          	lw	a1,128(a0)
    8000331e:	c5b5                	beqz	a1,8000338a <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003320:	00092503          	lw	a0,0(s2)
    80003324:	00000097          	auipc	ra,0x0
    80003328:	be0080e7          	jalr	-1056(ra) # 80002f04 <bread>
    8000332c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000332e:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    80003332:	02049713          	sll	a4,s1,0x20
    80003336:	01e75593          	srl	a1,a4,0x1e
    8000333a:	00b784b3          	add	s1,a5,a1
    8000333e:	0004a983          	lw	s3,0(s1)
    80003342:	04098e63          	beqz	s3,8000339e <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003346:	8552                	mv	a0,s4
    80003348:	00000097          	auipc	ra,0x0
    8000334c:	cec080e7          	jalr	-788(ra) # 80003034 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003350:	854e                	mv	a0,s3
    80003352:	70a2                	ld	ra,40(sp)
    80003354:	7402                	ld	s0,32(sp)
    80003356:	64e2                	ld	s1,24(sp)
    80003358:	6942                	ld	s2,16(sp)
    8000335a:	69a2                	ld	s3,8(sp)
    8000335c:	6a02                	ld	s4,0(sp)
    8000335e:	6145                	add	sp,sp,48
    80003360:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80003362:	02059793          	sll	a5,a1,0x20
    80003366:	01e7d593          	srl	a1,a5,0x1e
    8000336a:	00b504b3          	add	s1,a0,a1
    8000336e:	0504a983          	lw	s3,80(s1)
    80003372:	fc099fe3          	bnez	s3,80003350 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003376:	4108                	lw	a0,0(a0)
    80003378:	00000097          	auipc	ra,0x0
    8000337c:	e4c080e7          	jalr	-436(ra) # 800031c4 <balloc>
    80003380:	0005099b          	sext.w	s3,a0
    80003384:	0534a823          	sw	s3,80(s1)
    80003388:	b7e1                	j	80003350 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000338a:	4108                	lw	a0,0(a0)
    8000338c:	00000097          	auipc	ra,0x0
    80003390:	e38080e7          	jalr	-456(ra) # 800031c4 <balloc>
    80003394:	0005059b          	sext.w	a1,a0
    80003398:	08b92023          	sw	a1,128(s2)
    8000339c:	b751                	j	80003320 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000339e:	00092503          	lw	a0,0(s2)
    800033a2:	00000097          	auipc	ra,0x0
    800033a6:	e22080e7          	jalr	-478(ra) # 800031c4 <balloc>
    800033aa:	0005099b          	sext.w	s3,a0
    800033ae:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800033b2:	8552                	mv	a0,s4
    800033b4:	00001097          	auipc	ra,0x1
    800033b8:	ebe080e7          	jalr	-322(ra) # 80004272 <log_write>
    800033bc:	b769                	j	80003346 <bmap+0x54>
  panic("bmap: out of range");
    800033be:	00005517          	auipc	a0,0x5
    800033c2:	11a50513          	add	a0,a0,282 # 800084d8 <syscalls+0x118>
    800033c6:	ffffd097          	auipc	ra,0xffffd
    800033ca:	17c080e7          	jalr	380(ra) # 80000542 <panic>

00000000800033ce <iget>:
{
    800033ce:	7179                	add	sp,sp,-48
    800033d0:	f406                	sd	ra,40(sp)
    800033d2:	f022                	sd	s0,32(sp)
    800033d4:	ec26                	sd	s1,24(sp)
    800033d6:	e84a                	sd	s2,16(sp)
    800033d8:	e44e                	sd	s3,8(sp)
    800033da:	e052                	sd	s4,0(sp)
    800033dc:	1800                	add	s0,sp,48
    800033de:	89aa                	mv	s3,a0
    800033e0:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    800033e2:	0001d517          	auipc	a0,0x1d
    800033e6:	a7e50513          	add	a0,a0,-1410 # 8001fe60 <icache>
    800033ea:	ffffe097          	auipc	ra,0xffffe
    800033ee:	812080e7          	jalr	-2030(ra) # 80000bfc <acquire>
  empty = 0;
    800033f2:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800033f4:	0001d497          	auipc	s1,0x1d
    800033f8:	a8448493          	add	s1,s1,-1404 # 8001fe78 <icache+0x18>
    800033fc:	0001e697          	auipc	a3,0x1e
    80003400:	50c68693          	add	a3,a3,1292 # 80021908 <log>
    80003404:	a039                	j	80003412 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003406:	02090b63          	beqz	s2,8000343c <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    8000340a:	08848493          	add	s1,s1,136
    8000340e:	02d48a63          	beq	s1,a3,80003442 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003412:	449c                	lw	a5,8(s1)
    80003414:	fef059e3          	blez	a5,80003406 <iget+0x38>
    80003418:	4098                	lw	a4,0(s1)
    8000341a:	ff3716e3          	bne	a4,s3,80003406 <iget+0x38>
    8000341e:	40d8                	lw	a4,4(s1)
    80003420:	ff4713e3          	bne	a4,s4,80003406 <iget+0x38>
      ip->ref++;
    80003424:	2785                	addw	a5,a5,1
    80003426:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    80003428:	0001d517          	auipc	a0,0x1d
    8000342c:	a3850513          	add	a0,a0,-1480 # 8001fe60 <icache>
    80003430:	ffffe097          	auipc	ra,0xffffe
    80003434:	880080e7          	jalr	-1920(ra) # 80000cb0 <release>
      return ip;
    80003438:	8926                	mv	s2,s1
    8000343a:	a03d                	j	80003468 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000343c:	f7f9                	bnez	a5,8000340a <iget+0x3c>
    8000343e:	8926                	mv	s2,s1
    80003440:	b7e9                	j	8000340a <iget+0x3c>
  if(empty == 0)
    80003442:	02090c63          	beqz	s2,8000347a <iget+0xac>
  ip->dev = dev;
    80003446:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000344a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000344e:	4785                	li	a5,1
    80003450:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003454:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    80003458:	0001d517          	auipc	a0,0x1d
    8000345c:	a0850513          	add	a0,a0,-1528 # 8001fe60 <icache>
    80003460:	ffffe097          	auipc	ra,0xffffe
    80003464:	850080e7          	jalr	-1968(ra) # 80000cb0 <release>
}
    80003468:	854a                	mv	a0,s2
    8000346a:	70a2                	ld	ra,40(sp)
    8000346c:	7402                	ld	s0,32(sp)
    8000346e:	64e2                	ld	s1,24(sp)
    80003470:	6942                	ld	s2,16(sp)
    80003472:	69a2                	ld	s3,8(sp)
    80003474:	6a02                	ld	s4,0(sp)
    80003476:	6145                	add	sp,sp,48
    80003478:	8082                	ret
    panic("iget: no inodes");
    8000347a:	00005517          	auipc	a0,0x5
    8000347e:	07650513          	add	a0,a0,118 # 800084f0 <syscalls+0x130>
    80003482:	ffffd097          	auipc	ra,0xffffd
    80003486:	0c0080e7          	jalr	192(ra) # 80000542 <panic>

000000008000348a <fsinit>:
fsinit(int dev) {
    8000348a:	7179                	add	sp,sp,-48
    8000348c:	f406                	sd	ra,40(sp)
    8000348e:	f022                	sd	s0,32(sp)
    80003490:	ec26                	sd	s1,24(sp)
    80003492:	e84a                	sd	s2,16(sp)
    80003494:	e44e                	sd	s3,8(sp)
    80003496:	1800                	add	s0,sp,48
    80003498:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000349a:	4585                	li	a1,1
    8000349c:	00000097          	auipc	ra,0x0
    800034a0:	a68080e7          	jalr	-1432(ra) # 80002f04 <bread>
    800034a4:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800034a6:	0001d997          	auipc	s3,0x1d
    800034aa:	99a98993          	add	s3,s3,-1638 # 8001fe40 <sb>
    800034ae:	02000613          	li	a2,32
    800034b2:	05850593          	add	a1,a0,88
    800034b6:	854e                	mv	a0,s3
    800034b8:	ffffe097          	auipc	ra,0xffffe
    800034bc:	89c080e7          	jalr	-1892(ra) # 80000d54 <memmove>
  brelse(bp);
    800034c0:	8526                	mv	a0,s1
    800034c2:	00000097          	auipc	ra,0x0
    800034c6:	b72080e7          	jalr	-1166(ra) # 80003034 <brelse>
  if(sb.magic != FSMAGIC)
    800034ca:	0009a703          	lw	a4,0(s3)
    800034ce:	102037b7          	lui	a5,0x10203
    800034d2:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800034d6:	02f71263          	bne	a4,a5,800034fa <fsinit+0x70>
  initlog(dev, &sb);
    800034da:	0001d597          	auipc	a1,0x1d
    800034de:	96658593          	add	a1,a1,-1690 # 8001fe40 <sb>
    800034e2:	854a                	mv	a0,s2
    800034e4:	00001097          	auipc	ra,0x1
    800034e8:	b28080e7          	jalr	-1240(ra) # 8000400c <initlog>
}
    800034ec:	70a2                	ld	ra,40(sp)
    800034ee:	7402                	ld	s0,32(sp)
    800034f0:	64e2                	ld	s1,24(sp)
    800034f2:	6942                	ld	s2,16(sp)
    800034f4:	69a2                	ld	s3,8(sp)
    800034f6:	6145                	add	sp,sp,48
    800034f8:	8082                	ret
    panic("invalid file system");
    800034fa:	00005517          	auipc	a0,0x5
    800034fe:	00650513          	add	a0,a0,6 # 80008500 <syscalls+0x140>
    80003502:	ffffd097          	auipc	ra,0xffffd
    80003506:	040080e7          	jalr	64(ra) # 80000542 <panic>

000000008000350a <iinit>:
{
    8000350a:	7179                	add	sp,sp,-48
    8000350c:	f406                	sd	ra,40(sp)
    8000350e:	f022                	sd	s0,32(sp)
    80003510:	ec26                	sd	s1,24(sp)
    80003512:	e84a                	sd	s2,16(sp)
    80003514:	e44e                	sd	s3,8(sp)
    80003516:	1800                	add	s0,sp,48
  initlock(&icache.lock, "icache");
    80003518:	00005597          	auipc	a1,0x5
    8000351c:	00058593          	mv	a1,a1
    80003520:	0001d517          	auipc	a0,0x1d
    80003524:	94050513          	add	a0,a0,-1728 # 8001fe60 <icache>
    80003528:	ffffd097          	auipc	ra,0xffffd
    8000352c:	644080e7          	jalr	1604(ra) # 80000b6c <initlock>
  for(i = 0; i < NINODE; i++) {
    80003530:	0001d497          	auipc	s1,0x1d
    80003534:	95848493          	add	s1,s1,-1704 # 8001fe88 <icache+0x28>
    80003538:	0001e997          	auipc	s3,0x1e
    8000353c:	3e098993          	add	s3,s3,992 # 80021918 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003540:	00005917          	auipc	s2,0x5
    80003544:	fe090913          	add	s2,s2,-32 # 80008520 <syscalls+0x160>
    80003548:	85ca                	mv	a1,s2
    8000354a:	8526                	mv	a0,s1
    8000354c:	00001097          	auipc	ra,0x1
    80003550:	e12080e7          	jalr	-494(ra) # 8000435e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003554:	08848493          	add	s1,s1,136
    80003558:	ff3498e3          	bne	s1,s3,80003548 <iinit+0x3e>
}
    8000355c:	70a2                	ld	ra,40(sp)
    8000355e:	7402                	ld	s0,32(sp)
    80003560:	64e2                	ld	s1,24(sp)
    80003562:	6942                	ld	s2,16(sp)
    80003564:	69a2                	ld	s3,8(sp)
    80003566:	6145                	add	sp,sp,48
    80003568:	8082                	ret

000000008000356a <ialloc>:
{
    8000356a:	7139                	add	sp,sp,-64
    8000356c:	fc06                	sd	ra,56(sp)
    8000356e:	f822                	sd	s0,48(sp)
    80003570:	f426                	sd	s1,40(sp)
    80003572:	f04a                	sd	s2,32(sp)
    80003574:	ec4e                	sd	s3,24(sp)
    80003576:	e852                	sd	s4,16(sp)
    80003578:	e456                	sd	s5,8(sp)
    8000357a:	e05a                	sd	s6,0(sp)
    8000357c:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000357e:	0001d717          	auipc	a4,0x1d
    80003582:	8ce72703          	lw	a4,-1842(a4) # 8001fe4c <sb+0xc>
    80003586:	4785                	li	a5,1
    80003588:	04e7f863          	bgeu	a5,a4,800035d8 <ialloc+0x6e>
    8000358c:	8aaa                	mv	s5,a0
    8000358e:	8b2e                	mv	s6,a1
    80003590:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003592:	0001da17          	auipc	s4,0x1d
    80003596:	8aea0a13          	add	s4,s4,-1874 # 8001fe40 <sb>
    8000359a:	00495593          	srl	a1,s2,0x4
    8000359e:	018a2783          	lw	a5,24(s4)
    800035a2:	9dbd                	addw	a1,a1,a5
    800035a4:	8556                	mv	a0,s5
    800035a6:	00000097          	auipc	ra,0x0
    800035aa:	95e080e7          	jalr	-1698(ra) # 80002f04 <bread>
    800035ae:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800035b0:	05850993          	add	s3,a0,88
    800035b4:	00f97793          	and	a5,s2,15
    800035b8:	079a                	sll	a5,a5,0x6
    800035ba:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800035bc:	00099783          	lh	a5,0(s3)
    800035c0:	c785                	beqz	a5,800035e8 <ialloc+0x7e>
    brelse(bp);
    800035c2:	00000097          	auipc	ra,0x0
    800035c6:	a72080e7          	jalr	-1422(ra) # 80003034 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800035ca:	0905                	add	s2,s2,1
    800035cc:	00ca2703          	lw	a4,12(s4)
    800035d0:	0009079b          	sext.w	a5,s2
    800035d4:	fce7e3e3          	bltu	a5,a4,8000359a <ialloc+0x30>
  panic("ialloc: no inodes");
    800035d8:	00005517          	auipc	a0,0x5
    800035dc:	f5050513          	add	a0,a0,-176 # 80008528 <syscalls+0x168>
    800035e0:	ffffd097          	auipc	ra,0xffffd
    800035e4:	f62080e7          	jalr	-158(ra) # 80000542 <panic>
      memset(dip, 0, sizeof(*dip));
    800035e8:	04000613          	li	a2,64
    800035ec:	4581                	li	a1,0
    800035ee:	854e                	mv	a0,s3
    800035f0:	ffffd097          	auipc	ra,0xffffd
    800035f4:	708080e7          	jalr	1800(ra) # 80000cf8 <memset>
      dip->type = type;
    800035f8:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800035fc:	8526                	mv	a0,s1
    800035fe:	00001097          	auipc	ra,0x1
    80003602:	c74080e7          	jalr	-908(ra) # 80004272 <log_write>
      brelse(bp);
    80003606:	8526                	mv	a0,s1
    80003608:	00000097          	auipc	ra,0x0
    8000360c:	a2c080e7          	jalr	-1492(ra) # 80003034 <brelse>
      return iget(dev, inum);
    80003610:	0009059b          	sext.w	a1,s2
    80003614:	8556                	mv	a0,s5
    80003616:	00000097          	auipc	ra,0x0
    8000361a:	db8080e7          	jalr	-584(ra) # 800033ce <iget>
}
    8000361e:	70e2                	ld	ra,56(sp)
    80003620:	7442                	ld	s0,48(sp)
    80003622:	74a2                	ld	s1,40(sp)
    80003624:	7902                	ld	s2,32(sp)
    80003626:	69e2                	ld	s3,24(sp)
    80003628:	6a42                	ld	s4,16(sp)
    8000362a:	6aa2                	ld	s5,8(sp)
    8000362c:	6b02                	ld	s6,0(sp)
    8000362e:	6121                	add	sp,sp,64
    80003630:	8082                	ret

0000000080003632 <iupdate>:
{
    80003632:	1101                	add	sp,sp,-32
    80003634:	ec06                	sd	ra,24(sp)
    80003636:	e822                	sd	s0,16(sp)
    80003638:	e426                	sd	s1,8(sp)
    8000363a:	e04a                	sd	s2,0(sp)
    8000363c:	1000                	add	s0,sp,32
    8000363e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003640:	415c                	lw	a5,4(a0)
    80003642:	0047d79b          	srlw	a5,a5,0x4
    80003646:	0001d597          	auipc	a1,0x1d
    8000364a:	8125a583          	lw	a1,-2030(a1) # 8001fe58 <sb+0x18>
    8000364e:	9dbd                	addw	a1,a1,a5
    80003650:	4108                	lw	a0,0(a0)
    80003652:	00000097          	auipc	ra,0x0
    80003656:	8b2080e7          	jalr	-1870(ra) # 80002f04 <bread>
    8000365a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000365c:	05850793          	add	a5,a0,88
    80003660:	40d8                	lw	a4,4(s1)
    80003662:	8b3d                	and	a4,a4,15
    80003664:	071a                	sll	a4,a4,0x6
    80003666:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003668:	04449703          	lh	a4,68(s1)
    8000366c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003670:	04649703          	lh	a4,70(s1)
    80003674:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003678:	04849703          	lh	a4,72(s1)
    8000367c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003680:	04a49703          	lh	a4,74(s1)
    80003684:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003688:	44f8                	lw	a4,76(s1)
    8000368a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000368c:	03400613          	li	a2,52
    80003690:	05048593          	add	a1,s1,80
    80003694:	00c78513          	add	a0,a5,12
    80003698:	ffffd097          	auipc	ra,0xffffd
    8000369c:	6bc080e7          	jalr	1724(ra) # 80000d54 <memmove>
  log_write(bp);
    800036a0:	854a                	mv	a0,s2
    800036a2:	00001097          	auipc	ra,0x1
    800036a6:	bd0080e7          	jalr	-1072(ra) # 80004272 <log_write>
  brelse(bp);
    800036aa:	854a                	mv	a0,s2
    800036ac:	00000097          	auipc	ra,0x0
    800036b0:	988080e7          	jalr	-1656(ra) # 80003034 <brelse>
}
    800036b4:	60e2                	ld	ra,24(sp)
    800036b6:	6442                	ld	s0,16(sp)
    800036b8:	64a2                	ld	s1,8(sp)
    800036ba:	6902                	ld	s2,0(sp)
    800036bc:	6105                	add	sp,sp,32
    800036be:	8082                	ret

00000000800036c0 <idup>:
{
    800036c0:	1101                	add	sp,sp,-32
    800036c2:	ec06                	sd	ra,24(sp)
    800036c4:	e822                	sd	s0,16(sp)
    800036c6:	e426                	sd	s1,8(sp)
    800036c8:	1000                	add	s0,sp,32
    800036ca:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800036cc:	0001c517          	auipc	a0,0x1c
    800036d0:	79450513          	add	a0,a0,1940 # 8001fe60 <icache>
    800036d4:	ffffd097          	auipc	ra,0xffffd
    800036d8:	528080e7          	jalr	1320(ra) # 80000bfc <acquire>
  ip->ref++;
    800036dc:	449c                	lw	a5,8(s1)
    800036de:	2785                	addw	a5,a5,1
    800036e0:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800036e2:	0001c517          	auipc	a0,0x1c
    800036e6:	77e50513          	add	a0,a0,1918 # 8001fe60 <icache>
    800036ea:	ffffd097          	auipc	ra,0xffffd
    800036ee:	5c6080e7          	jalr	1478(ra) # 80000cb0 <release>
}
    800036f2:	8526                	mv	a0,s1
    800036f4:	60e2                	ld	ra,24(sp)
    800036f6:	6442                	ld	s0,16(sp)
    800036f8:	64a2                	ld	s1,8(sp)
    800036fa:	6105                	add	sp,sp,32
    800036fc:	8082                	ret

00000000800036fe <ilock>:
{
    800036fe:	1101                	add	sp,sp,-32
    80003700:	ec06                	sd	ra,24(sp)
    80003702:	e822                	sd	s0,16(sp)
    80003704:	e426                	sd	s1,8(sp)
    80003706:	e04a                	sd	s2,0(sp)
    80003708:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000370a:	c115                	beqz	a0,8000372e <ilock+0x30>
    8000370c:	84aa                	mv	s1,a0
    8000370e:	451c                	lw	a5,8(a0)
    80003710:	00f05f63          	blez	a5,8000372e <ilock+0x30>
  acquiresleep(&ip->lock);
    80003714:	0541                	add	a0,a0,16
    80003716:	00001097          	auipc	ra,0x1
    8000371a:	c82080e7          	jalr	-894(ra) # 80004398 <acquiresleep>
  if(ip->valid == 0){
    8000371e:	40bc                	lw	a5,64(s1)
    80003720:	cf99                	beqz	a5,8000373e <ilock+0x40>
}
    80003722:	60e2                	ld	ra,24(sp)
    80003724:	6442                	ld	s0,16(sp)
    80003726:	64a2                	ld	s1,8(sp)
    80003728:	6902                	ld	s2,0(sp)
    8000372a:	6105                	add	sp,sp,32
    8000372c:	8082                	ret
    panic("ilock");
    8000372e:	00005517          	auipc	a0,0x5
    80003732:	e1250513          	add	a0,a0,-494 # 80008540 <syscalls+0x180>
    80003736:	ffffd097          	auipc	ra,0xffffd
    8000373a:	e0c080e7          	jalr	-500(ra) # 80000542 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000373e:	40dc                	lw	a5,4(s1)
    80003740:	0047d79b          	srlw	a5,a5,0x4
    80003744:	0001c597          	auipc	a1,0x1c
    80003748:	7145a583          	lw	a1,1812(a1) # 8001fe58 <sb+0x18>
    8000374c:	9dbd                	addw	a1,a1,a5
    8000374e:	4088                	lw	a0,0(s1)
    80003750:	fffff097          	auipc	ra,0xfffff
    80003754:	7b4080e7          	jalr	1972(ra) # 80002f04 <bread>
    80003758:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000375a:	05850593          	add	a1,a0,88
    8000375e:	40dc                	lw	a5,4(s1)
    80003760:	8bbd                	and	a5,a5,15
    80003762:	079a                	sll	a5,a5,0x6
    80003764:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003766:	00059783          	lh	a5,0(a1)
    8000376a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000376e:	00259783          	lh	a5,2(a1)
    80003772:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003776:	00459783          	lh	a5,4(a1)
    8000377a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000377e:	00659783          	lh	a5,6(a1)
    80003782:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003786:	459c                	lw	a5,8(a1)
    80003788:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000378a:	03400613          	li	a2,52
    8000378e:	05b1                	add	a1,a1,12
    80003790:	05048513          	add	a0,s1,80
    80003794:	ffffd097          	auipc	ra,0xffffd
    80003798:	5c0080e7          	jalr	1472(ra) # 80000d54 <memmove>
    brelse(bp);
    8000379c:	854a                	mv	a0,s2
    8000379e:	00000097          	auipc	ra,0x0
    800037a2:	896080e7          	jalr	-1898(ra) # 80003034 <brelse>
    ip->valid = 1;
    800037a6:	4785                	li	a5,1
    800037a8:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800037aa:	04449783          	lh	a5,68(s1)
    800037ae:	fbb5                	bnez	a5,80003722 <ilock+0x24>
      panic("ilock: no type");
    800037b0:	00005517          	auipc	a0,0x5
    800037b4:	d9850513          	add	a0,a0,-616 # 80008548 <syscalls+0x188>
    800037b8:	ffffd097          	auipc	ra,0xffffd
    800037bc:	d8a080e7          	jalr	-630(ra) # 80000542 <panic>

00000000800037c0 <iunlock>:
{
    800037c0:	1101                	add	sp,sp,-32
    800037c2:	ec06                	sd	ra,24(sp)
    800037c4:	e822                	sd	s0,16(sp)
    800037c6:	e426                	sd	s1,8(sp)
    800037c8:	e04a                	sd	s2,0(sp)
    800037ca:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800037cc:	c905                	beqz	a0,800037fc <iunlock+0x3c>
    800037ce:	84aa                	mv	s1,a0
    800037d0:	01050913          	add	s2,a0,16
    800037d4:	854a                	mv	a0,s2
    800037d6:	00001097          	auipc	ra,0x1
    800037da:	c5c080e7          	jalr	-932(ra) # 80004432 <holdingsleep>
    800037de:	cd19                	beqz	a0,800037fc <iunlock+0x3c>
    800037e0:	449c                	lw	a5,8(s1)
    800037e2:	00f05d63          	blez	a5,800037fc <iunlock+0x3c>
  releasesleep(&ip->lock);
    800037e6:	854a                	mv	a0,s2
    800037e8:	00001097          	auipc	ra,0x1
    800037ec:	c06080e7          	jalr	-1018(ra) # 800043ee <releasesleep>
}
    800037f0:	60e2                	ld	ra,24(sp)
    800037f2:	6442                	ld	s0,16(sp)
    800037f4:	64a2                	ld	s1,8(sp)
    800037f6:	6902                	ld	s2,0(sp)
    800037f8:	6105                	add	sp,sp,32
    800037fa:	8082                	ret
    panic("iunlock");
    800037fc:	00005517          	auipc	a0,0x5
    80003800:	d5c50513          	add	a0,a0,-676 # 80008558 <syscalls+0x198>
    80003804:	ffffd097          	auipc	ra,0xffffd
    80003808:	d3e080e7          	jalr	-706(ra) # 80000542 <panic>

000000008000380c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000380c:	7179                	add	sp,sp,-48
    8000380e:	f406                	sd	ra,40(sp)
    80003810:	f022                	sd	s0,32(sp)
    80003812:	ec26                	sd	s1,24(sp)
    80003814:	e84a                	sd	s2,16(sp)
    80003816:	e44e                	sd	s3,8(sp)
    80003818:	e052                	sd	s4,0(sp)
    8000381a:	1800                	add	s0,sp,48
    8000381c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000381e:	05050493          	add	s1,a0,80
    80003822:	08050913          	add	s2,a0,128
    80003826:	a021                	j	8000382e <itrunc+0x22>
    80003828:	0491                	add	s1,s1,4
    8000382a:	01248d63          	beq	s1,s2,80003844 <itrunc+0x38>
    if(ip->addrs[i]){
    8000382e:	408c                	lw	a1,0(s1)
    80003830:	dde5                	beqz	a1,80003828 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003832:	0009a503          	lw	a0,0(s3)
    80003836:	00000097          	auipc	ra,0x0
    8000383a:	912080e7          	jalr	-1774(ra) # 80003148 <bfree>
      ip->addrs[i] = 0;
    8000383e:	0004a023          	sw	zero,0(s1)
    80003842:	b7dd                	j	80003828 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003844:	0809a583          	lw	a1,128(s3)
    80003848:	e185                	bnez	a1,80003868 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000384a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000384e:	854e                	mv	a0,s3
    80003850:	00000097          	auipc	ra,0x0
    80003854:	de2080e7          	jalr	-542(ra) # 80003632 <iupdate>
}
    80003858:	70a2                	ld	ra,40(sp)
    8000385a:	7402                	ld	s0,32(sp)
    8000385c:	64e2                	ld	s1,24(sp)
    8000385e:	6942                	ld	s2,16(sp)
    80003860:	69a2                	ld	s3,8(sp)
    80003862:	6a02                	ld	s4,0(sp)
    80003864:	6145                	add	sp,sp,48
    80003866:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003868:	0009a503          	lw	a0,0(s3)
    8000386c:	fffff097          	auipc	ra,0xfffff
    80003870:	698080e7          	jalr	1688(ra) # 80002f04 <bread>
    80003874:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003876:	05850493          	add	s1,a0,88
    8000387a:	45850913          	add	s2,a0,1112
    8000387e:	a021                	j	80003886 <itrunc+0x7a>
    80003880:	0491                	add	s1,s1,4
    80003882:	01248b63          	beq	s1,s2,80003898 <itrunc+0x8c>
      if(a[j])
    80003886:	408c                	lw	a1,0(s1)
    80003888:	dde5                	beqz	a1,80003880 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    8000388a:	0009a503          	lw	a0,0(s3)
    8000388e:	00000097          	auipc	ra,0x0
    80003892:	8ba080e7          	jalr	-1862(ra) # 80003148 <bfree>
    80003896:	b7ed                	j	80003880 <itrunc+0x74>
    brelse(bp);
    80003898:	8552                	mv	a0,s4
    8000389a:	fffff097          	auipc	ra,0xfffff
    8000389e:	79a080e7          	jalr	1946(ra) # 80003034 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800038a2:	0809a583          	lw	a1,128(s3)
    800038a6:	0009a503          	lw	a0,0(s3)
    800038aa:	00000097          	auipc	ra,0x0
    800038ae:	89e080e7          	jalr	-1890(ra) # 80003148 <bfree>
    ip->addrs[NDIRECT] = 0;
    800038b2:	0809a023          	sw	zero,128(s3)
    800038b6:	bf51                	j	8000384a <itrunc+0x3e>

00000000800038b8 <iput>:
{
    800038b8:	1101                	add	sp,sp,-32
    800038ba:	ec06                	sd	ra,24(sp)
    800038bc:	e822                	sd	s0,16(sp)
    800038be:	e426                	sd	s1,8(sp)
    800038c0:	e04a                	sd	s2,0(sp)
    800038c2:	1000                	add	s0,sp,32
    800038c4:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800038c6:	0001c517          	auipc	a0,0x1c
    800038ca:	59a50513          	add	a0,a0,1434 # 8001fe60 <icache>
    800038ce:	ffffd097          	auipc	ra,0xffffd
    800038d2:	32e080e7          	jalr	814(ra) # 80000bfc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800038d6:	4498                	lw	a4,8(s1)
    800038d8:	4785                	li	a5,1
    800038da:	02f70363          	beq	a4,a5,80003900 <iput+0x48>
  ip->ref--;
    800038de:	449c                	lw	a5,8(s1)
    800038e0:	37fd                	addw	a5,a5,-1
    800038e2:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800038e4:	0001c517          	auipc	a0,0x1c
    800038e8:	57c50513          	add	a0,a0,1404 # 8001fe60 <icache>
    800038ec:	ffffd097          	auipc	ra,0xffffd
    800038f0:	3c4080e7          	jalr	964(ra) # 80000cb0 <release>
}
    800038f4:	60e2                	ld	ra,24(sp)
    800038f6:	6442                	ld	s0,16(sp)
    800038f8:	64a2                	ld	s1,8(sp)
    800038fa:	6902                	ld	s2,0(sp)
    800038fc:	6105                	add	sp,sp,32
    800038fe:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003900:	40bc                	lw	a5,64(s1)
    80003902:	dff1                	beqz	a5,800038de <iput+0x26>
    80003904:	04a49783          	lh	a5,74(s1)
    80003908:	fbf9                	bnez	a5,800038de <iput+0x26>
    acquiresleep(&ip->lock);
    8000390a:	01048913          	add	s2,s1,16
    8000390e:	854a                	mv	a0,s2
    80003910:	00001097          	auipc	ra,0x1
    80003914:	a88080e7          	jalr	-1400(ra) # 80004398 <acquiresleep>
    release(&icache.lock);
    80003918:	0001c517          	auipc	a0,0x1c
    8000391c:	54850513          	add	a0,a0,1352 # 8001fe60 <icache>
    80003920:	ffffd097          	auipc	ra,0xffffd
    80003924:	390080e7          	jalr	912(ra) # 80000cb0 <release>
    itrunc(ip);
    80003928:	8526                	mv	a0,s1
    8000392a:	00000097          	auipc	ra,0x0
    8000392e:	ee2080e7          	jalr	-286(ra) # 8000380c <itrunc>
    ip->type = 0;
    80003932:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003936:	8526                	mv	a0,s1
    80003938:	00000097          	auipc	ra,0x0
    8000393c:	cfa080e7          	jalr	-774(ra) # 80003632 <iupdate>
    ip->valid = 0;
    80003940:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003944:	854a                	mv	a0,s2
    80003946:	00001097          	auipc	ra,0x1
    8000394a:	aa8080e7          	jalr	-1368(ra) # 800043ee <releasesleep>
    acquire(&icache.lock);
    8000394e:	0001c517          	auipc	a0,0x1c
    80003952:	51250513          	add	a0,a0,1298 # 8001fe60 <icache>
    80003956:	ffffd097          	auipc	ra,0xffffd
    8000395a:	2a6080e7          	jalr	678(ra) # 80000bfc <acquire>
    8000395e:	b741                	j	800038de <iput+0x26>

0000000080003960 <iunlockput>:
{
    80003960:	1101                	add	sp,sp,-32
    80003962:	ec06                	sd	ra,24(sp)
    80003964:	e822                	sd	s0,16(sp)
    80003966:	e426                	sd	s1,8(sp)
    80003968:	1000                	add	s0,sp,32
    8000396a:	84aa                	mv	s1,a0
  iunlock(ip);
    8000396c:	00000097          	auipc	ra,0x0
    80003970:	e54080e7          	jalr	-428(ra) # 800037c0 <iunlock>
  iput(ip);
    80003974:	8526                	mv	a0,s1
    80003976:	00000097          	auipc	ra,0x0
    8000397a:	f42080e7          	jalr	-190(ra) # 800038b8 <iput>
}
    8000397e:	60e2                	ld	ra,24(sp)
    80003980:	6442                	ld	s0,16(sp)
    80003982:	64a2                	ld	s1,8(sp)
    80003984:	6105                	add	sp,sp,32
    80003986:	8082                	ret

0000000080003988 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003988:	1141                	add	sp,sp,-16
    8000398a:	e422                	sd	s0,8(sp)
    8000398c:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    8000398e:	411c                	lw	a5,0(a0)
    80003990:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003992:	415c                	lw	a5,4(a0)
    80003994:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003996:	04451783          	lh	a5,68(a0)
    8000399a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000399e:	04a51783          	lh	a5,74(a0)
    800039a2:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800039a6:	04c56783          	lwu	a5,76(a0)
    800039aa:	e99c                	sd	a5,16(a1)
}
    800039ac:	6422                	ld	s0,8(sp)
    800039ae:	0141                	add	sp,sp,16
    800039b0:	8082                	ret

00000000800039b2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800039b2:	457c                	lw	a5,76(a0)
    800039b4:	0ed7e963          	bltu	a5,a3,80003aa6 <readi+0xf4>
{
    800039b8:	7159                	add	sp,sp,-112
    800039ba:	f486                	sd	ra,104(sp)
    800039bc:	f0a2                	sd	s0,96(sp)
    800039be:	eca6                	sd	s1,88(sp)
    800039c0:	e8ca                	sd	s2,80(sp)
    800039c2:	e4ce                	sd	s3,72(sp)
    800039c4:	e0d2                	sd	s4,64(sp)
    800039c6:	fc56                	sd	s5,56(sp)
    800039c8:	f85a                	sd	s6,48(sp)
    800039ca:	f45e                	sd	s7,40(sp)
    800039cc:	f062                	sd	s8,32(sp)
    800039ce:	ec66                	sd	s9,24(sp)
    800039d0:	e86a                	sd	s10,16(sp)
    800039d2:	e46e                	sd	s11,8(sp)
    800039d4:	1880                	add	s0,sp,112
    800039d6:	8baa                	mv	s7,a0
    800039d8:	8c2e                	mv	s8,a1
    800039da:	8ab2                	mv	s5,a2
    800039dc:	84b6                	mv	s1,a3
    800039de:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800039e0:	9f35                	addw	a4,a4,a3
    return 0;
    800039e2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800039e4:	0ad76063          	bltu	a4,a3,80003a84 <readi+0xd2>
  if(off + n > ip->size)
    800039e8:	00e7f463          	bgeu	a5,a4,800039f0 <readi+0x3e>
    n = ip->size - off;
    800039ec:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800039f0:	0a0b0963          	beqz	s6,80003aa2 <readi+0xf0>
    800039f4:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800039f6:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800039fa:	5cfd                	li	s9,-1
    800039fc:	a82d                	j	80003a36 <readi+0x84>
    800039fe:	020a1d93          	sll	s11,s4,0x20
    80003a02:	020ddd93          	srl	s11,s11,0x20
    80003a06:	05890613          	add	a2,s2,88
    80003a0a:	86ee                	mv	a3,s11
    80003a0c:	963a                	add	a2,a2,a4
    80003a0e:	85d6                	mv	a1,s5
    80003a10:	8562                	mv	a0,s8
    80003a12:	fffff097          	auipc	ra,0xfffff
    80003a16:	a9c080e7          	jalr	-1380(ra) # 800024ae <either_copyout>
    80003a1a:	05950d63          	beq	a0,s9,80003a74 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003a1e:	854a                	mv	a0,s2
    80003a20:	fffff097          	auipc	ra,0xfffff
    80003a24:	614080e7          	jalr	1556(ra) # 80003034 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a28:	013a09bb          	addw	s3,s4,s3
    80003a2c:	009a04bb          	addw	s1,s4,s1
    80003a30:	9aee                	add	s5,s5,s11
    80003a32:	0569f763          	bgeu	s3,s6,80003a80 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003a36:	000ba903          	lw	s2,0(s7)
    80003a3a:	00a4d59b          	srlw	a1,s1,0xa
    80003a3e:	855e                	mv	a0,s7
    80003a40:	00000097          	auipc	ra,0x0
    80003a44:	8b2080e7          	jalr	-1870(ra) # 800032f2 <bmap>
    80003a48:	0005059b          	sext.w	a1,a0
    80003a4c:	854a                	mv	a0,s2
    80003a4e:	fffff097          	auipc	ra,0xfffff
    80003a52:	4b6080e7          	jalr	1206(ra) # 80002f04 <bread>
    80003a56:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a58:	3ff4f713          	and	a4,s1,1023
    80003a5c:	40ed07bb          	subw	a5,s10,a4
    80003a60:	413b06bb          	subw	a3,s6,s3
    80003a64:	8a3e                	mv	s4,a5
    80003a66:	2781                	sext.w	a5,a5
    80003a68:	0006861b          	sext.w	a2,a3
    80003a6c:	f8f679e3          	bgeu	a2,a5,800039fe <readi+0x4c>
    80003a70:	8a36                	mv	s4,a3
    80003a72:	b771                	j	800039fe <readi+0x4c>
      brelse(bp);
    80003a74:	854a                	mv	a0,s2
    80003a76:	fffff097          	auipc	ra,0xfffff
    80003a7a:	5be080e7          	jalr	1470(ra) # 80003034 <brelse>
      tot = -1;
    80003a7e:	59fd                	li	s3,-1
  }
  return tot;
    80003a80:	0009851b          	sext.w	a0,s3
}
    80003a84:	70a6                	ld	ra,104(sp)
    80003a86:	7406                	ld	s0,96(sp)
    80003a88:	64e6                	ld	s1,88(sp)
    80003a8a:	6946                	ld	s2,80(sp)
    80003a8c:	69a6                	ld	s3,72(sp)
    80003a8e:	6a06                	ld	s4,64(sp)
    80003a90:	7ae2                	ld	s5,56(sp)
    80003a92:	7b42                	ld	s6,48(sp)
    80003a94:	7ba2                	ld	s7,40(sp)
    80003a96:	7c02                	ld	s8,32(sp)
    80003a98:	6ce2                	ld	s9,24(sp)
    80003a9a:	6d42                	ld	s10,16(sp)
    80003a9c:	6da2                	ld	s11,8(sp)
    80003a9e:	6165                	add	sp,sp,112
    80003aa0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003aa2:	89da                	mv	s3,s6
    80003aa4:	bff1                	j	80003a80 <readi+0xce>
    return 0;
    80003aa6:	4501                	li	a0,0
}
    80003aa8:	8082                	ret

0000000080003aaa <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003aaa:	457c                	lw	a5,76(a0)
    80003aac:	10d7e763          	bltu	a5,a3,80003bba <writei+0x110>
{
    80003ab0:	7159                	add	sp,sp,-112
    80003ab2:	f486                	sd	ra,104(sp)
    80003ab4:	f0a2                	sd	s0,96(sp)
    80003ab6:	eca6                	sd	s1,88(sp)
    80003ab8:	e8ca                	sd	s2,80(sp)
    80003aba:	e4ce                	sd	s3,72(sp)
    80003abc:	e0d2                	sd	s4,64(sp)
    80003abe:	fc56                	sd	s5,56(sp)
    80003ac0:	f85a                	sd	s6,48(sp)
    80003ac2:	f45e                	sd	s7,40(sp)
    80003ac4:	f062                	sd	s8,32(sp)
    80003ac6:	ec66                	sd	s9,24(sp)
    80003ac8:	e86a                	sd	s10,16(sp)
    80003aca:	e46e                	sd	s11,8(sp)
    80003acc:	1880                	add	s0,sp,112
    80003ace:	8baa                	mv	s7,a0
    80003ad0:	8c2e                	mv	s8,a1
    80003ad2:	8ab2                	mv	s5,a2
    80003ad4:	8936                	mv	s2,a3
    80003ad6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003ad8:	00e687bb          	addw	a5,a3,a4
    80003adc:	0ed7e163          	bltu	a5,a3,80003bbe <writei+0x114>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003ae0:	00043737          	lui	a4,0x43
    80003ae4:	0cf76f63          	bltu	a4,a5,80003bc2 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ae8:	0a0b0863          	beqz	s6,80003b98 <writei+0xee>
    80003aec:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003aee:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003af2:	5cfd                	li	s9,-1
    80003af4:	a091                	j	80003b38 <writei+0x8e>
    80003af6:	02099d93          	sll	s11,s3,0x20
    80003afa:	020ddd93          	srl	s11,s11,0x20
    80003afe:	05848513          	add	a0,s1,88
    80003b02:	86ee                	mv	a3,s11
    80003b04:	8656                	mv	a2,s5
    80003b06:	85e2                	mv	a1,s8
    80003b08:	953a                	add	a0,a0,a4
    80003b0a:	fffff097          	auipc	ra,0xfffff
    80003b0e:	9fa080e7          	jalr	-1542(ra) # 80002504 <either_copyin>
    80003b12:	07950263          	beq	a0,s9,80003b76 <writei+0xcc>
      brelse(bp);
      n = -1;
      break;
    }
    log_write(bp);
    80003b16:	8526                	mv	a0,s1
    80003b18:	00000097          	auipc	ra,0x0
    80003b1c:	75a080e7          	jalr	1882(ra) # 80004272 <log_write>
    brelse(bp);
    80003b20:	8526                	mv	a0,s1
    80003b22:	fffff097          	auipc	ra,0xfffff
    80003b26:	512080e7          	jalr	1298(ra) # 80003034 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b2a:	01498a3b          	addw	s4,s3,s4
    80003b2e:	0129893b          	addw	s2,s3,s2
    80003b32:	9aee                	add	s5,s5,s11
    80003b34:	056a7763          	bgeu	s4,s6,80003b82 <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003b38:	000ba483          	lw	s1,0(s7)
    80003b3c:	00a9559b          	srlw	a1,s2,0xa
    80003b40:	855e                	mv	a0,s7
    80003b42:	fffff097          	auipc	ra,0xfffff
    80003b46:	7b0080e7          	jalr	1968(ra) # 800032f2 <bmap>
    80003b4a:	0005059b          	sext.w	a1,a0
    80003b4e:	8526                	mv	a0,s1
    80003b50:	fffff097          	auipc	ra,0xfffff
    80003b54:	3b4080e7          	jalr	948(ra) # 80002f04 <bread>
    80003b58:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b5a:	3ff97713          	and	a4,s2,1023
    80003b5e:	40ed07bb          	subw	a5,s10,a4
    80003b62:	414b06bb          	subw	a3,s6,s4
    80003b66:	89be                	mv	s3,a5
    80003b68:	2781                	sext.w	a5,a5
    80003b6a:	0006861b          	sext.w	a2,a3
    80003b6e:	f8f674e3          	bgeu	a2,a5,80003af6 <writei+0x4c>
    80003b72:	89b6                	mv	s3,a3
    80003b74:	b749                	j	80003af6 <writei+0x4c>
      brelse(bp);
    80003b76:	8526                	mv	a0,s1
    80003b78:	fffff097          	auipc	ra,0xfffff
    80003b7c:	4bc080e7          	jalr	1212(ra) # 80003034 <brelse>
      n = -1;
    80003b80:	5b7d                	li	s6,-1
  }

  if(n > 0){
    if(off > ip->size)
    80003b82:	04cba783          	lw	a5,76(s7)
    80003b86:	0127f463          	bgeu	a5,s2,80003b8e <writei+0xe4>
      ip->size = off;
    80003b8a:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003b8e:	855e                	mv	a0,s7
    80003b90:	00000097          	auipc	ra,0x0
    80003b94:	aa2080e7          	jalr	-1374(ra) # 80003632 <iupdate>
  }

  return n;
    80003b98:	000b051b          	sext.w	a0,s6
}
    80003b9c:	70a6                	ld	ra,104(sp)
    80003b9e:	7406                	ld	s0,96(sp)
    80003ba0:	64e6                	ld	s1,88(sp)
    80003ba2:	6946                	ld	s2,80(sp)
    80003ba4:	69a6                	ld	s3,72(sp)
    80003ba6:	6a06                	ld	s4,64(sp)
    80003ba8:	7ae2                	ld	s5,56(sp)
    80003baa:	7b42                	ld	s6,48(sp)
    80003bac:	7ba2                	ld	s7,40(sp)
    80003bae:	7c02                	ld	s8,32(sp)
    80003bb0:	6ce2                	ld	s9,24(sp)
    80003bb2:	6d42                	ld	s10,16(sp)
    80003bb4:	6da2                	ld	s11,8(sp)
    80003bb6:	6165                	add	sp,sp,112
    80003bb8:	8082                	ret
    return -1;
    80003bba:	557d                	li	a0,-1
}
    80003bbc:	8082                	ret
    return -1;
    80003bbe:	557d                	li	a0,-1
    80003bc0:	bff1                	j	80003b9c <writei+0xf2>
    return -1;
    80003bc2:	557d                	li	a0,-1
    80003bc4:	bfe1                	j	80003b9c <writei+0xf2>

0000000080003bc6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003bc6:	1141                	add	sp,sp,-16
    80003bc8:	e406                	sd	ra,8(sp)
    80003bca:	e022                	sd	s0,0(sp)
    80003bcc:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003bce:	4639                	li	a2,14
    80003bd0:	ffffd097          	auipc	ra,0xffffd
    80003bd4:	200080e7          	jalr	512(ra) # 80000dd0 <strncmp>
}
    80003bd8:	60a2                	ld	ra,8(sp)
    80003bda:	6402                	ld	s0,0(sp)
    80003bdc:	0141                	add	sp,sp,16
    80003bde:	8082                	ret

0000000080003be0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003be0:	7139                	add	sp,sp,-64
    80003be2:	fc06                	sd	ra,56(sp)
    80003be4:	f822                	sd	s0,48(sp)
    80003be6:	f426                	sd	s1,40(sp)
    80003be8:	f04a                	sd	s2,32(sp)
    80003bea:	ec4e                	sd	s3,24(sp)
    80003bec:	e852                	sd	s4,16(sp)
    80003bee:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003bf0:	04451703          	lh	a4,68(a0)
    80003bf4:	4785                	li	a5,1
    80003bf6:	00f71a63          	bne	a4,a5,80003c0a <dirlookup+0x2a>
    80003bfa:	892a                	mv	s2,a0
    80003bfc:	89ae                	mv	s3,a1
    80003bfe:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c00:	457c                	lw	a5,76(a0)
    80003c02:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003c04:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c06:	e79d                	bnez	a5,80003c34 <dirlookup+0x54>
    80003c08:	a8a5                	j	80003c80 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003c0a:	00005517          	auipc	a0,0x5
    80003c0e:	95650513          	add	a0,a0,-1706 # 80008560 <syscalls+0x1a0>
    80003c12:	ffffd097          	auipc	ra,0xffffd
    80003c16:	930080e7          	jalr	-1744(ra) # 80000542 <panic>
      panic("dirlookup read");
    80003c1a:	00005517          	auipc	a0,0x5
    80003c1e:	95e50513          	add	a0,a0,-1698 # 80008578 <syscalls+0x1b8>
    80003c22:	ffffd097          	auipc	ra,0xffffd
    80003c26:	920080e7          	jalr	-1760(ra) # 80000542 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c2a:	24c1                	addw	s1,s1,16
    80003c2c:	04c92783          	lw	a5,76(s2)
    80003c30:	04f4f763          	bgeu	s1,a5,80003c7e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c34:	4741                	li	a4,16
    80003c36:	86a6                	mv	a3,s1
    80003c38:	fc040613          	add	a2,s0,-64
    80003c3c:	4581                	li	a1,0
    80003c3e:	854a                	mv	a0,s2
    80003c40:	00000097          	auipc	ra,0x0
    80003c44:	d72080e7          	jalr	-654(ra) # 800039b2 <readi>
    80003c48:	47c1                	li	a5,16
    80003c4a:	fcf518e3          	bne	a0,a5,80003c1a <dirlookup+0x3a>
    if(de.inum == 0)
    80003c4e:	fc045783          	lhu	a5,-64(s0)
    80003c52:	dfe1                	beqz	a5,80003c2a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003c54:	fc240593          	add	a1,s0,-62
    80003c58:	854e                	mv	a0,s3
    80003c5a:	00000097          	auipc	ra,0x0
    80003c5e:	f6c080e7          	jalr	-148(ra) # 80003bc6 <namecmp>
    80003c62:	f561                	bnez	a0,80003c2a <dirlookup+0x4a>
      if(poff)
    80003c64:	000a0463          	beqz	s4,80003c6c <dirlookup+0x8c>
        *poff = off;
    80003c68:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003c6c:	fc045583          	lhu	a1,-64(s0)
    80003c70:	00092503          	lw	a0,0(s2)
    80003c74:	fffff097          	auipc	ra,0xfffff
    80003c78:	75a080e7          	jalr	1882(ra) # 800033ce <iget>
    80003c7c:	a011                	j	80003c80 <dirlookup+0xa0>
  return 0;
    80003c7e:	4501                	li	a0,0
}
    80003c80:	70e2                	ld	ra,56(sp)
    80003c82:	7442                	ld	s0,48(sp)
    80003c84:	74a2                	ld	s1,40(sp)
    80003c86:	7902                	ld	s2,32(sp)
    80003c88:	69e2                	ld	s3,24(sp)
    80003c8a:	6a42                	ld	s4,16(sp)
    80003c8c:	6121                	add	sp,sp,64
    80003c8e:	8082                	ret

0000000080003c90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003c90:	711d                	add	sp,sp,-96
    80003c92:	ec86                	sd	ra,88(sp)
    80003c94:	e8a2                	sd	s0,80(sp)
    80003c96:	e4a6                	sd	s1,72(sp)
    80003c98:	e0ca                	sd	s2,64(sp)
    80003c9a:	fc4e                	sd	s3,56(sp)
    80003c9c:	f852                	sd	s4,48(sp)
    80003c9e:	f456                	sd	s5,40(sp)
    80003ca0:	f05a                	sd	s6,32(sp)
    80003ca2:	ec5e                	sd	s7,24(sp)
    80003ca4:	e862                	sd	s8,16(sp)
    80003ca6:	e466                	sd	s9,8(sp)
    80003ca8:	1080                	add	s0,sp,96
    80003caa:	84aa                	mv	s1,a0
    80003cac:	8b2e                	mv	s6,a1
    80003cae:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003cb0:	00054703          	lbu	a4,0(a0)
    80003cb4:	02f00793          	li	a5,47
    80003cb8:	02f70263          	beq	a4,a5,80003cdc <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003cbc:	ffffe097          	auipc	ra,0xffffe
    80003cc0:	d82080e7          	jalr	-638(ra) # 80001a3e <myproc>
    80003cc4:	15053503          	ld	a0,336(a0)
    80003cc8:	00000097          	auipc	ra,0x0
    80003ccc:	9f8080e7          	jalr	-1544(ra) # 800036c0 <idup>
    80003cd0:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003cd2:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003cd6:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003cd8:	4b85                	li	s7,1
    80003cda:	a875                	j	80003d96 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003cdc:	4585                	li	a1,1
    80003cde:	4505                	li	a0,1
    80003ce0:	fffff097          	auipc	ra,0xfffff
    80003ce4:	6ee080e7          	jalr	1774(ra) # 800033ce <iget>
    80003ce8:	8a2a                	mv	s4,a0
    80003cea:	b7e5                	j	80003cd2 <namex+0x42>
      iunlockput(ip);
    80003cec:	8552                	mv	a0,s4
    80003cee:	00000097          	auipc	ra,0x0
    80003cf2:	c72080e7          	jalr	-910(ra) # 80003960 <iunlockput>
      return 0;
    80003cf6:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003cf8:	8552                	mv	a0,s4
    80003cfa:	60e6                	ld	ra,88(sp)
    80003cfc:	6446                	ld	s0,80(sp)
    80003cfe:	64a6                	ld	s1,72(sp)
    80003d00:	6906                	ld	s2,64(sp)
    80003d02:	79e2                	ld	s3,56(sp)
    80003d04:	7a42                	ld	s4,48(sp)
    80003d06:	7aa2                	ld	s5,40(sp)
    80003d08:	7b02                	ld	s6,32(sp)
    80003d0a:	6be2                	ld	s7,24(sp)
    80003d0c:	6c42                	ld	s8,16(sp)
    80003d0e:	6ca2                	ld	s9,8(sp)
    80003d10:	6125                	add	sp,sp,96
    80003d12:	8082                	ret
      iunlock(ip);
    80003d14:	8552                	mv	a0,s4
    80003d16:	00000097          	auipc	ra,0x0
    80003d1a:	aaa080e7          	jalr	-1366(ra) # 800037c0 <iunlock>
      return ip;
    80003d1e:	bfe9                	j	80003cf8 <namex+0x68>
      iunlockput(ip);
    80003d20:	8552                	mv	a0,s4
    80003d22:	00000097          	auipc	ra,0x0
    80003d26:	c3e080e7          	jalr	-962(ra) # 80003960 <iunlockput>
      return 0;
    80003d2a:	8a4e                	mv	s4,s3
    80003d2c:	b7f1                	j	80003cf8 <namex+0x68>
  len = path - s;
    80003d2e:	40998633          	sub	a2,s3,s1
    80003d32:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003d36:	099c5863          	bge	s8,s9,80003dc6 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003d3a:	4639                	li	a2,14
    80003d3c:	85a6                	mv	a1,s1
    80003d3e:	8556                	mv	a0,s5
    80003d40:	ffffd097          	auipc	ra,0xffffd
    80003d44:	014080e7          	jalr	20(ra) # 80000d54 <memmove>
    80003d48:	84ce                	mv	s1,s3
  while(*path == '/')
    80003d4a:	0004c783          	lbu	a5,0(s1)
    80003d4e:	01279763          	bne	a5,s2,80003d5c <namex+0xcc>
    path++;
    80003d52:	0485                	add	s1,s1,1
  while(*path == '/')
    80003d54:	0004c783          	lbu	a5,0(s1)
    80003d58:	ff278de3          	beq	a5,s2,80003d52 <namex+0xc2>
    ilock(ip);
    80003d5c:	8552                	mv	a0,s4
    80003d5e:	00000097          	auipc	ra,0x0
    80003d62:	9a0080e7          	jalr	-1632(ra) # 800036fe <ilock>
    if(ip->type != T_DIR){
    80003d66:	044a1783          	lh	a5,68(s4)
    80003d6a:	f97791e3          	bne	a5,s7,80003cec <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003d6e:	000b0563          	beqz	s6,80003d78 <namex+0xe8>
    80003d72:	0004c783          	lbu	a5,0(s1)
    80003d76:	dfd9                	beqz	a5,80003d14 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003d78:	4601                	li	a2,0
    80003d7a:	85d6                	mv	a1,s5
    80003d7c:	8552                	mv	a0,s4
    80003d7e:	00000097          	auipc	ra,0x0
    80003d82:	e62080e7          	jalr	-414(ra) # 80003be0 <dirlookup>
    80003d86:	89aa                	mv	s3,a0
    80003d88:	dd41                	beqz	a0,80003d20 <namex+0x90>
    iunlockput(ip);
    80003d8a:	8552                	mv	a0,s4
    80003d8c:	00000097          	auipc	ra,0x0
    80003d90:	bd4080e7          	jalr	-1068(ra) # 80003960 <iunlockput>
    ip = next;
    80003d94:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003d96:	0004c783          	lbu	a5,0(s1)
    80003d9a:	01279763          	bne	a5,s2,80003da8 <namex+0x118>
    path++;
    80003d9e:	0485                	add	s1,s1,1
  while(*path == '/')
    80003da0:	0004c783          	lbu	a5,0(s1)
    80003da4:	ff278de3          	beq	a5,s2,80003d9e <namex+0x10e>
  if(*path == 0)
    80003da8:	cb9d                	beqz	a5,80003dde <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003daa:	0004c783          	lbu	a5,0(s1)
    80003dae:	89a6                	mv	s3,s1
  len = path - s;
    80003db0:	4c81                	li	s9,0
    80003db2:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003db4:	01278963          	beq	a5,s2,80003dc6 <namex+0x136>
    80003db8:	dbbd                	beqz	a5,80003d2e <namex+0x9e>
    path++;
    80003dba:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80003dbc:	0009c783          	lbu	a5,0(s3)
    80003dc0:	ff279ce3          	bne	a5,s2,80003db8 <namex+0x128>
    80003dc4:	b7ad                	j	80003d2e <namex+0x9e>
    memmove(name, s, len);
    80003dc6:	2601                	sext.w	a2,a2
    80003dc8:	85a6                	mv	a1,s1
    80003dca:	8556                	mv	a0,s5
    80003dcc:	ffffd097          	auipc	ra,0xffffd
    80003dd0:	f88080e7          	jalr	-120(ra) # 80000d54 <memmove>
    name[len] = 0;
    80003dd4:	9cd6                	add	s9,s9,s5
    80003dd6:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003dda:	84ce                	mv	s1,s3
    80003ddc:	b7bd                	j	80003d4a <namex+0xba>
  if(nameiparent){
    80003dde:	f00b0de3          	beqz	s6,80003cf8 <namex+0x68>
    iput(ip);
    80003de2:	8552                	mv	a0,s4
    80003de4:	00000097          	auipc	ra,0x0
    80003de8:	ad4080e7          	jalr	-1324(ra) # 800038b8 <iput>
    return 0;
    80003dec:	4a01                	li	s4,0
    80003dee:	b729                	j	80003cf8 <namex+0x68>

0000000080003df0 <dirlink>:
{
    80003df0:	7139                	add	sp,sp,-64
    80003df2:	fc06                	sd	ra,56(sp)
    80003df4:	f822                	sd	s0,48(sp)
    80003df6:	f426                	sd	s1,40(sp)
    80003df8:	f04a                	sd	s2,32(sp)
    80003dfa:	ec4e                	sd	s3,24(sp)
    80003dfc:	e852                	sd	s4,16(sp)
    80003dfe:	0080                	add	s0,sp,64
    80003e00:	892a                	mv	s2,a0
    80003e02:	8a2e                	mv	s4,a1
    80003e04:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e06:	4601                	li	a2,0
    80003e08:	00000097          	auipc	ra,0x0
    80003e0c:	dd8080e7          	jalr	-552(ra) # 80003be0 <dirlookup>
    80003e10:	e93d                	bnez	a0,80003e86 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e12:	04c92483          	lw	s1,76(s2)
    80003e16:	c49d                	beqz	s1,80003e44 <dirlink+0x54>
    80003e18:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e1a:	4741                	li	a4,16
    80003e1c:	86a6                	mv	a3,s1
    80003e1e:	fc040613          	add	a2,s0,-64
    80003e22:	4581                	li	a1,0
    80003e24:	854a                	mv	a0,s2
    80003e26:	00000097          	auipc	ra,0x0
    80003e2a:	b8c080e7          	jalr	-1140(ra) # 800039b2 <readi>
    80003e2e:	47c1                	li	a5,16
    80003e30:	06f51163          	bne	a0,a5,80003e92 <dirlink+0xa2>
    if(de.inum == 0)
    80003e34:	fc045783          	lhu	a5,-64(s0)
    80003e38:	c791                	beqz	a5,80003e44 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e3a:	24c1                	addw	s1,s1,16
    80003e3c:	04c92783          	lw	a5,76(s2)
    80003e40:	fcf4ede3          	bltu	s1,a5,80003e1a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003e44:	4639                	li	a2,14
    80003e46:	85d2                	mv	a1,s4
    80003e48:	fc240513          	add	a0,s0,-62
    80003e4c:	ffffd097          	auipc	ra,0xffffd
    80003e50:	fc0080e7          	jalr	-64(ra) # 80000e0c <strncpy>
  de.inum = inum;
    80003e54:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e58:	4741                	li	a4,16
    80003e5a:	86a6                	mv	a3,s1
    80003e5c:	fc040613          	add	a2,s0,-64
    80003e60:	4581                	li	a1,0
    80003e62:	854a                	mv	a0,s2
    80003e64:	00000097          	auipc	ra,0x0
    80003e68:	c46080e7          	jalr	-954(ra) # 80003aaa <writei>
    80003e6c:	872a                	mv	a4,a0
    80003e6e:	47c1                	li	a5,16
  return 0;
    80003e70:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e72:	02f71863          	bne	a4,a5,80003ea2 <dirlink+0xb2>
}
    80003e76:	70e2                	ld	ra,56(sp)
    80003e78:	7442                	ld	s0,48(sp)
    80003e7a:	74a2                	ld	s1,40(sp)
    80003e7c:	7902                	ld	s2,32(sp)
    80003e7e:	69e2                	ld	s3,24(sp)
    80003e80:	6a42                	ld	s4,16(sp)
    80003e82:	6121                	add	sp,sp,64
    80003e84:	8082                	ret
    iput(ip);
    80003e86:	00000097          	auipc	ra,0x0
    80003e8a:	a32080e7          	jalr	-1486(ra) # 800038b8 <iput>
    return -1;
    80003e8e:	557d                	li	a0,-1
    80003e90:	b7dd                	j	80003e76 <dirlink+0x86>
      panic("dirlink read");
    80003e92:	00004517          	auipc	a0,0x4
    80003e96:	6f650513          	add	a0,a0,1782 # 80008588 <syscalls+0x1c8>
    80003e9a:	ffffc097          	auipc	ra,0xffffc
    80003e9e:	6a8080e7          	jalr	1704(ra) # 80000542 <panic>
    panic("dirlink");
    80003ea2:	00005517          	auipc	a0,0x5
    80003ea6:	80650513          	add	a0,a0,-2042 # 800086a8 <syscalls+0x2e8>
    80003eaa:	ffffc097          	auipc	ra,0xffffc
    80003eae:	698080e7          	jalr	1688(ra) # 80000542 <panic>

0000000080003eb2 <namei>:

struct inode*
namei(char *path)
{
    80003eb2:	1101                	add	sp,sp,-32
    80003eb4:	ec06                	sd	ra,24(sp)
    80003eb6:	e822                	sd	s0,16(sp)
    80003eb8:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003eba:	fe040613          	add	a2,s0,-32
    80003ebe:	4581                	li	a1,0
    80003ec0:	00000097          	auipc	ra,0x0
    80003ec4:	dd0080e7          	jalr	-560(ra) # 80003c90 <namex>
}
    80003ec8:	60e2                	ld	ra,24(sp)
    80003eca:	6442                	ld	s0,16(sp)
    80003ecc:	6105                	add	sp,sp,32
    80003ece:	8082                	ret

0000000080003ed0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003ed0:	1141                	add	sp,sp,-16
    80003ed2:	e406                	sd	ra,8(sp)
    80003ed4:	e022                	sd	s0,0(sp)
    80003ed6:	0800                	add	s0,sp,16
    80003ed8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003eda:	4585                	li	a1,1
    80003edc:	00000097          	auipc	ra,0x0
    80003ee0:	db4080e7          	jalr	-588(ra) # 80003c90 <namex>
}
    80003ee4:	60a2                	ld	ra,8(sp)
    80003ee6:	6402                	ld	s0,0(sp)
    80003ee8:	0141                	add	sp,sp,16
    80003eea:	8082                	ret

0000000080003eec <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003eec:	1101                	add	sp,sp,-32
    80003eee:	ec06                	sd	ra,24(sp)
    80003ef0:	e822                	sd	s0,16(sp)
    80003ef2:	e426                	sd	s1,8(sp)
    80003ef4:	e04a                	sd	s2,0(sp)
    80003ef6:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003ef8:	0001e917          	auipc	s2,0x1e
    80003efc:	a1090913          	add	s2,s2,-1520 # 80021908 <log>
    80003f00:	01892583          	lw	a1,24(s2)
    80003f04:	02892503          	lw	a0,40(s2)
    80003f08:	fffff097          	auipc	ra,0xfffff
    80003f0c:	ffc080e7          	jalr	-4(ra) # 80002f04 <bread>
    80003f10:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003f12:	02c92603          	lw	a2,44(s2)
    80003f16:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003f18:	00c05f63          	blez	a2,80003f36 <write_head+0x4a>
    80003f1c:	0001e717          	auipc	a4,0x1e
    80003f20:	a1c70713          	add	a4,a4,-1508 # 80021938 <log+0x30>
    80003f24:	87aa                	mv	a5,a0
    80003f26:	060a                	sll	a2,a2,0x2
    80003f28:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003f2a:	4314                	lw	a3,0(a4)
    80003f2c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003f2e:	0711                	add	a4,a4,4
    80003f30:	0791                	add	a5,a5,4
    80003f32:	fec79ce3          	bne	a5,a2,80003f2a <write_head+0x3e>
  }
  bwrite(buf);
    80003f36:	8526                	mv	a0,s1
    80003f38:	fffff097          	auipc	ra,0xfffff
    80003f3c:	0be080e7          	jalr	190(ra) # 80002ff6 <bwrite>
  brelse(buf);
    80003f40:	8526                	mv	a0,s1
    80003f42:	fffff097          	auipc	ra,0xfffff
    80003f46:	0f2080e7          	jalr	242(ra) # 80003034 <brelse>
}
    80003f4a:	60e2                	ld	ra,24(sp)
    80003f4c:	6442                	ld	s0,16(sp)
    80003f4e:	64a2                	ld	s1,8(sp)
    80003f50:	6902                	ld	s2,0(sp)
    80003f52:	6105                	add	sp,sp,32
    80003f54:	8082                	ret

0000000080003f56 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f56:	0001e797          	auipc	a5,0x1e
    80003f5a:	9de7a783          	lw	a5,-1570(a5) # 80021934 <log+0x2c>
    80003f5e:	0af05663          	blez	a5,8000400a <install_trans+0xb4>
{
    80003f62:	7139                	add	sp,sp,-64
    80003f64:	fc06                	sd	ra,56(sp)
    80003f66:	f822                	sd	s0,48(sp)
    80003f68:	f426                	sd	s1,40(sp)
    80003f6a:	f04a                	sd	s2,32(sp)
    80003f6c:	ec4e                	sd	s3,24(sp)
    80003f6e:	e852                	sd	s4,16(sp)
    80003f70:	e456                	sd	s5,8(sp)
    80003f72:	0080                	add	s0,sp,64
    80003f74:	0001ea97          	auipc	s5,0x1e
    80003f78:	9c4a8a93          	add	s5,s5,-1596 # 80021938 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f7c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003f7e:	0001e997          	auipc	s3,0x1e
    80003f82:	98a98993          	add	s3,s3,-1654 # 80021908 <log>
    80003f86:	0189a583          	lw	a1,24(s3)
    80003f8a:	014585bb          	addw	a1,a1,s4
    80003f8e:	2585                	addw	a1,a1,1
    80003f90:	0289a503          	lw	a0,40(s3)
    80003f94:	fffff097          	auipc	ra,0xfffff
    80003f98:	f70080e7          	jalr	-144(ra) # 80002f04 <bread>
    80003f9c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003f9e:	000aa583          	lw	a1,0(s5)
    80003fa2:	0289a503          	lw	a0,40(s3)
    80003fa6:	fffff097          	auipc	ra,0xfffff
    80003faa:	f5e080e7          	jalr	-162(ra) # 80002f04 <bread>
    80003fae:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003fb0:	40000613          	li	a2,1024
    80003fb4:	05890593          	add	a1,s2,88
    80003fb8:	05850513          	add	a0,a0,88
    80003fbc:	ffffd097          	auipc	ra,0xffffd
    80003fc0:	d98080e7          	jalr	-616(ra) # 80000d54 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003fc4:	8526                	mv	a0,s1
    80003fc6:	fffff097          	auipc	ra,0xfffff
    80003fca:	030080e7          	jalr	48(ra) # 80002ff6 <bwrite>
    bunpin(dbuf);
    80003fce:	8526                	mv	a0,s1
    80003fd0:	fffff097          	auipc	ra,0xfffff
    80003fd4:	13c080e7          	jalr	316(ra) # 8000310c <bunpin>
    brelse(lbuf);
    80003fd8:	854a                	mv	a0,s2
    80003fda:	fffff097          	auipc	ra,0xfffff
    80003fde:	05a080e7          	jalr	90(ra) # 80003034 <brelse>
    brelse(dbuf);
    80003fe2:	8526                	mv	a0,s1
    80003fe4:	fffff097          	auipc	ra,0xfffff
    80003fe8:	050080e7          	jalr	80(ra) # 80003034 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fec:	2a05                	addw	s4,s4,1
    80003fee:	0a91                	add	s5,s5,4
    80003ff0:	02c9a783          	lw	a5,44(s3)
    80003ff4:	f8fa49e3          	blt	s4,a5,80003f86 <install_trans+0x30>
}
    80003ff8:	70e2                	ld	ra,56(sp)
    80003ffa:	7442                	ld	s0,48(sp)
    80003ffc:	74a2                	ld	s1,40(sp)
    80003ffe:	7902                	ld	s2,32(sp)
    80004000:	69e2                	ld	s3,24(sp)
    80004002:	6a42                	ld	s4,16(sp)
    80004004:	6aa2                	ld	s5,8(sp)
    80004006:	6121                	add	sp,sp,64
    80004008:	8082                	ret
    8000400a:	8082                	ret

000000008000400c <initlog>:
{
    8000400c:	7179                	add	sp,sp,-48
    8000400e:	f406                	sd	ra,40(sp)
    80004010:	f022                	sd	s0,32(sp)
    80004012:	ec26                	sd	s1,24(sp)
    80004014:	e84a                	sd	s2,16(sp)
    80004016:	e44e                	sd	s3,8(sp)
    80004018:	1800                	add	s0,sp,48
    8000401a:	892a                	mv	s2,a0
    8000401c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000401e:	0001e497          	auipc	s1,0x1e
    80004022:	8ea48493          	add	s1,s1,-1814 # 80021908 <log>
    80004026:	00004597          	auipc	a1,0x4
    8000402a:	57258593          	add	a1,a1,1394 # 80008598 <syscalls+0x1d8>
    8000402e:	8526                	mv	a0,s1
    80004030:	ffffd097          	auipc	ra,0xffffd
    80004034:	b3c080e7          	jalr	-1220(ra) # 80000b6c <initlock>
  log.start = sb->logstart;
    80004038:	0149a583          	lw	a1,20(s3)
    8000403c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000403e:	0109a783          	lw	a5,16(s3)
    80004042:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004044:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004048:	854a                	mv	a0,s2
    8000404a:	fffff097          	auipc	ra,0xfffff
    8000404e:	eba080e7          	jalr	-326(ra) # 80002f04 <bread>
  log.lh.n = lh->n;
    80004052:	4d30                	lw	a2,88(a0)
    80004054:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004056:	00c05f63          	blez	a2,80004074 <initlog+0x68>
    8000405a:	87aa                	mv	a5,a0
    8000405c:	0001e717          	auipc	a4,0x1e
    80004060:	8dc70713          	add	a4,a4,-1828 # 80021938 <log+0x30>
    80004064:	060a                	sll	a2,a2,0x2
    80004066:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004068:	4ff4                	lw	a3,92(a5)
    8000406a:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000406c:	0791                	add	a5,a5,4
    8000406e:	0711                	add	a4,a4,4
    80004070:	fec79ce3          	bne	a5,a2,80004068 <initlog+0x5c>
  brelse(buf);
    80004074:	fffff097          	auipc	ra,0xfffff
    80004078:	fc0080e7          	jalr	-64(ra) # 80003034 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    8000407c:	00000097          	auipc	ra,0x0
    80004080:	eda080e7          	jalr	-294(ra) # 80003f56 <install_trans>
  log.lh.n = 0;
    80004084:	0001e797          	auipc	a5,0x1e
    80004088:	8a07a823          	sw	zero,-1872(a5) # 80021934 <log+0x2c>
  write_head(); // clear the log
    8000408c:	00000097          	auipc	ra,0x0
    80004090:	e60080e7          	jalr	-416(ra) # 80003eec <write_head>
}
    80004094:	70a2                	ld	ra,40(sp)
    80004096:	7402                	ld	s0,32(sp)
    80004098:	64e2                	ld	s1,24(sp)
    8000409a:	6942                	ld	s2,16(sp)
    8000409c:	69a2                	ld	s3,8(sp)
    8000409e:	6145                	add	sp,sp,48
    800040a0:	8082                	ret

00000000800040a2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800040a2:	1101                	add	sp,sp,-32
    800040a4:	ec06                	sd	ra,24(sp)
    800040a6:	e822                	sd	s0,16(sp)
    800040a8:	e426                	sd	s1,8(sp)
    800040aa:	e04a                	sd	s2,0(sp)
    800040ac:	1000                	add	s0,sp,32
  acquire(&log.lock);
    800040ae:	0001e517          	auipc	a0,0x1e
    800040b2:	85a50513          	add	a0,a0,-1958 # 80021908 <log>
    800040b6:	ffffd097          	auipc	ra,0xffffd
    800040ba:	b46080e7          	jalr	-1210(ra) # 80000bfc <acquire>
  while(1){
    if(log.committing){
    800040be:	0001e497          	auipc	s1,0x1e
    800040c2:	84a48493          	add	s1,s1,-1974 # 80021908 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800040c6:	4979                	li	s2,30
    800040c8:	a039                	j	800040d6 <begin_op+0x34>
      sleep(&log, &log.lock);
    800040ca:	85a6                	mv	a1,s1
    800040cc:	8526                	mv	a0,s1
    800040ce:	ffffe097          	auipc	ra,0xffffe
    800040d2:	186080e7          	jalr	390(ra) # 80002254 <sleep>
    if(log.committing){
    800040d6:	50dc                	lw	a5,36(s1)
    800040d8:	fbed                	bnez	a5,800040ca <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800040da:	5098                	lw	a4,32(s1)
    800040dc:	2705                	addw	a4,a4,1
    800040de:	0027179b          	sllw	a5,a4,0x2
    800040e2:	9fb9                	addw	a5,a5,a4
    800040e4:	0017979b          	sllw	a5,a5,0x1
    800040e8:	54d4                	lw	a3,44(s1)
    800040ea:	9fb5                	addw	a5,a5,a3
    800040ec:	00f95963          	bge	s2,a5,800040fe <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800040f0:	85a6                	mv	a1,s1
    800040f2:	8526                	mv	a0,s1
    800040f4:	ffffe097          	auipc	ra,0xffffe
    800040f8:	160080e7          	jalr	352(ra) # 80002254 <sleep>
    800040fc:	bfe9                	j	800040d6 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800040fe:	0001e517          	auipc	a0,0x1e
    80004102:	80a50513          	add	a0,a0,-2038 # 80021908 <log>
    80004106:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004108:	ffffd097          	auipc	ra,0xffffd
    8000410c:	ba8080e7          	jalr	-1112(ra) # 80000cb0 <release>
      break;
    }
  }
}
    80004110:	60e2                	ld	ra,24(sp)
    80004112:	6442                	ld	s0,16(sp)
    80004114:	64a2                	ld	s1,8(sp)
    80004116:	6902                	ld	s2,0(sp)
    80004118:	6105                	add	sp,sp,32
    8000411a:	8082                	ret

000000008000411c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000411c:	7139                	add	sp,sp,-64
    8000411e:	fc06                	sd	ra,56(sp)
    80004120:	f822                	sd	s0,48(sp)
    80004122:	f426                	sd	s1,40(sp)
    80004124:	f04a                	sd	s2,32(sp)
    80004126:	ec4e                	sd	s3,24(sp)
    80004128:	e852                	sd	s4,16(sp)
    8000412a:	e456                	sd	s5,8(sp)
    8000412c:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000412e:	0001d497          	auipc	s1,0x1d
    80004132:	7da48493          	add	s1,s1,2010 # 80021908 <log>
    80004136:	8526                	mv	a0,s1
    80004138:	ffffd097          	auipc	ra,0xffffd
    8000413c:	ac4080e7          	jalr	-1340(ra) # 80000bfc <acquire>
  log.outstanding -= 1;
    80004140:	509c                	lw	a5,32(s1)
    80004142:	37fd                	addw	a5,a5,-1
    80004144:	0007891b          	sext.w	s2,a5
    80004148:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000414a:	50dc                	lw	a5,36(s1)
    8000414c:	e7b9                	bnez	a5,8000419a <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000414e:	04091e63          	bnez	s2,800041aa <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004152:	0001d497          	auipc	s1,0x1d
    80004156:	7b648493          	add	s1,s1,1974 # 80021908 <log>
    8000415a:	4785                	li	a5,1
    8000415c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000415e:	8526                	mv	a0,s1
    80004160:	ffffd097          	auipc	ra,0xffffd
    80004164:	b50080e7          	jalr	-1200(ra) # 80000cb0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004168:	54dc                	lw	a5,44(s1)
    8000416a:	06f04763          	bgtz	a5,800041d8 <end_op+0xbc>
    acquire(&log.lock);
    8000416e:	0001d497          	auipc	s1,0x1d
    80004172:	79a48493          	add	s1,s1,1946 # 80021908 <log>
    80004176:	8526                	mv	a0,s1
    80004178:	ffffd097          	auipc	ra,0xffffd
    8000417c:	a84080e7          	jalr	-1404(ra) # 80000bfc <acquire>
    log.committing = 0;
    80004180:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004184:	8526                	mv	a0,s1
    80004186:	ffffe097          	auipc	ra,0xffffe
    8000418a:	24e080e7          	jalr	590(ra) # 800023d4 <wakeup>
    release(&log.lock);
    8000418e:	8526                	mv	a0,s1
    80004190:	ffffd097          	auipc	ra,0xffffd
    80004194:	b20080e7          	jalr	-1248(ra) # 80000cb0 <release>
}
    80004198:	a03d                	j	800041c6 <end_op+0xaa>
    panic("log.committing");
    8000419a:	00004517          	auipc	a0,0x4
    8000419e:	40650513          	add	a0,a0,1030 # 800085a0 <syscalls+0x1e0>
    800041a2:	ffffc097          	auipc	ra,0xffffc
    800041a6:	3a0080e7          	jalr	928(ra) # 80000542 <panic>
    wakeup(&log);
    800041aa:	0001d497          	auipc	s1,0x1d
    800041ae:	75e48493          	add	s1,s1,1886 # 80021908 <log>
    800041b2:	8526                	mv	a0,s1
    800041b4:	ffffe097          	auipc	ra,0xffffe
    800041b8:	220080e7          	jalr	544(ra) # 800023d4 <wakeup>
  release(&log.lock);
    800041bc:	8526                	mv	a0,s1
    800041be:	ffffd097          	auipc	ra,0xffffd
    800041c2:	af2080e7          	jalr	-1294(ra) # 80000cb0 <release>
}
    800041c6:	70e2                	ld	ra,56(sp)
    800041c8:	7442                	ld	s0,48(sp)
    800041ca:	74a2                	ld	s1,40(sp)
    800041cc:	7902                	ld	s2,32(sp)
    800041ce:	69e2                	ld	s3,24(sp)
    800041d0:	6a42                	ld	s4,16(sp)
    800041d2:	6aa2                	ld	s5,8(sp)
    800041d4:	6121                	add	sp,sp,64
    800041d6:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800041d8:	0001da97          	auipc	s5,0x1d
    800041dc:	760a8a93          	add	s5,s5,1888 # 80021938 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800041e0:	0001da17          	auipc	s4,0x1d
    800041e4:	728a0a13          	add	s4,s4,1832 # 80021908 <log>
    800041e8:	018a2583          	lw	a1,24(s4)
    800041ec:	012585bb          	addw	a1,a1,s2
    800041f0:	2585                	addw	a1,a1,1
    800041f2:	028a2503          	lw	a0,40(s4)
    800041f6:	fffff097          	auipc	ra,0xfffff
    800041fa:	d0e080e7          	jalr	-754(ra) # 80002f04 <bread>
    800041fe:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004200:	000aa583          	lw	a1,0(s5)
    80004204:	028a2503          	lw	a0,40(s4)
    80004208:	fffff097          	auipc	ra,0xfffff
    8000420c:	cfc080e7          	jalr	-772(ra) # 80002f04 <bread>
    80004210:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004212:	40000613          	li	a2,1024
    80004216:	05850593          	add	a1,a0,88
    8000421a:	05848513          	add	a0,s1,88
    8000421e:	ffffd097          	auipc	ra,0xffffd
    80004222:	b36080e7          	jalr	-1226(ra) # 80000d54 <memmove>
    bwrite(to);  // write the log
    80004226:	8526                	mv	a0,s1
    80004228:	fffff097          	auipc	ra,0xfffff
    8000422c:	dce080e7          	jalr	-562(ra) # 80002ff6 <bwrite>
    brelse(from);
    80004230:	854e                	mv	a0,s3
    80004232:	fffff097          	auipc	ra,0xfffff
    80004236:	e02080e7          	jalr	-510(ra) # 80003034 <brelse>
    brelse(to);
    8000423a:	8526                	mv	a0,s1
    8000423c:	fffff097          	auipc	ra,0xfffff
    80004240:	df8080e7          	jalr	-520(ra) # 80003034 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004244:	2905                	addw	s2,s2,1
    80004246:	0a91                	add	s5,s5,4
    80004248:	02ca2783          	lw	a5,44(s4)
    8000424c:	f8f94ee3          	blt	s2,a5,800041e8 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004250:	00000097          	auipc	ra,0x0
    80004254:	c9c080e7          	jalr	-868(ra) # 80003eec <write_head>
    install_trans(); // Now install writes to home locations
    80004258:	00000097          	auipc	ra,0x0
    8000425c:	cfe080e7          	jalr	-770(ra) # 80003f56 <install_trans>
    log.lh.n = 0;
    80004260:	0001d797          	auipc	a5,0x1d
    80004264:	6c07aa23          	sw	zero,1748(a5) # 80021934 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004268:	00000097          	auipc	ra,0x0
    8000426c:	c84080e7          	jalr	-892(ra) # 80003eec <write_head>
    80004270:	bdfd                	j	8000416e <end_op+0x52>

0000000080004272 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004272:	1101                	add	sp,sp,-32
    80004274:	ec06                	sd	ra,24(sp)
    80004276:	e822                	sd	s0,16(sp)
    80004278:	e426                	sd	s1,8(sp)
    8000427a:	e04a                	sd	s2,0(sp)
    8000427c:	1000                	add	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000427e:	0001d717          	auipc	a4,0x1d
    80004282:	6b672703          	lw	a4,1718(a4) # 80021934 <log+0x2c>
    80004286:	47f5                	li	a5,29
    80004288:	08e7c063          	blt	a5,a4,80004308 <log_write+0x96>
    8000428c:	84aa                	mv	s1,a0
    8000428e:	0001d797          	auipc	a5,0x1d
    80004292:	6967a783          	lw	a5,1686(a5) # 80021924 <log+0x1c>
    80004296:	37fd                	addw	a5,a5,-1
    80004298:	06f75863          	bge	a4,a5,80004308 <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000429c:	0001d797          	auipc	a5,0x1d
    800042a0:	68c7a783          	lw	a5,1676(a5) # 80021928 <log+0x20>
    800042a4:	06f05a63          	blez	a5,80004318 <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    800042a8:	0001d917          	auipc	s2,0x1d
    800042ac:	66090913          	add	s2,s2,1632 # 80021908 <log>
    800042b0:	854a                	mv	a0,s2
    800042b2:	ffffd097          	auipc	ra,0xffffd
    800042b6:	94a080e7          	jalr	-1718(ra) # 80000bfc <acquire>
  for (i = 0; i < log.lh.n; i++) {
    800042ba:	02c92603          	lw	a2,44(s2)
    800042be:	06c05563          	blez	a2,80004328 <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800042c2:	44cc                	lw	a1,12(s1)
    800042c4:	0001d717          	auipc	a4,0x1d
    800042c8:	67470713          	add	a4,a4,1652 # 80021938 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800042cc:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800042ce:	4314                	lw	a3,0(a4)
    800042d0:	04b68d63          	beq	a3,a1,8000432a <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    800042d4:	2785                	addw	a5,a5,1
    800042d6:	0711                	add	a4,a4,4
    800042d8:	fec79be3          	bne	a5,a2,800042ce <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    800042dc:	0621                	add	a2,a2,8
    800042de:	060a                	sll	a2,a2,0x2
    800042e0:	0001d797          	auipc	a5,0x1d
    800042e4:	62878793          	add	a5,a5,1576 # 80021908 <log>
    800042e8:	97b2                	add	a5,a5,a2
    800042ea:	44d8                	lw	a4,12(s1)
    800042ec:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800042ee:	8526                	mv	a0,s1
    800042f0:	fffff097          	auipc	ra,0xfffff
    800042f4:	de0080e7          	jalr	-544(ra) # 800030d0 <bpin>
    log.lh.n++;
    800042f8:	0001d717          	auipc	a4,0x1d
    800042fc:	61070713          	add	a4,a4,1552 # 80021908 <log>
    80004300:	575c                	lw	a5,44(a4)
    80004302:	2785                	addw	a5,a5,1
    80004304:	d75c                	sw	a5,44(a4)
    80004306:	a835                	j	80004342 <log_write+0xd0>
    panic("too big a transaction");
    80004308:	00004517          	auipc	a0,0x4
    8000430c:	2a850513          	add	a0,a0,680 # 800085b0 <syscalls+0x1f0>
    80004310:	ffffc097          	auipc	ra,0xffffc
    80004314:	232080e7          	jalr	562(ra) # 80000542 <panic>
    panic("log_write outside of trans");
    80004318:	00004517          	auipc	a0,0x4
    8000431c:	2b050513          	add	a0,a0,688 # 800085c8 <syscalls+0x208>
    80004320:	ffffc097          	auipc	ra,0xffffc
    80004324:	222080e7          	jalr	546(ra) # 80000542 <panic>
  for (i = 0; i < log.lh.n; i++) {
    80004328:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    8000432a:	00878693          	add	a3,a5,8
    8000432e:	068a                	sll	a3,a3,0x2
    80004330:	0001d717          	auipc	a4,0x1d
    80004334:	5d870713          	add	a4,a4,1496 # 80021908 <log>
    80004338:	9736                	add	a4,a4,a3
    8000433a:	44d4                	lw	a3,12(s1)
    8000433c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000433e:	faf608e3          	beq	a2,a5,800042ee <log_write+0x7c>
  }
  release(&log.lock);
    80004342:	0001d517          	auipc	a0,0x1d
    80004346:	5c650513          	add	a0,a0,1478 # 80021908 <log>
    8000434a:	ffffd097          	auipc	ra,0xffffd
    8000434e:	966080e7          	jalr	-1690(ra) # 80000cb0 <release>
}
    80004352:	60e2                	ld	ra,24(sp)
    80004354:	6442                	ld	s0,16(sp)
    80004356:	64a2                	ld	s1,8(sp)
    80004358:	6902                	ld	s2,0(sp)
    8000435a:	6105                	add	sp,sp,32
    8000435c:	8082                	ret

000000008000435e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000435e:	1101                	add	sp,sp,-32
    80004360:	ec06                	sd	ra,24(sp)
    80004362:	e822                	sd	s0,16(sp)
    80004364:	e426                	sd	s1,8(sp)
    80004366:	e04a                	sd	s2,0(sp)
    80004368:	1000                	add	s0,sp,32
    8000436a:	84aa                	mv	s1,a0
    8000436c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000436e:	00004597          	auipc	a1,0x4
    80004372:	27a58593          	add	a1,a1,634 # 800085e8 <syscalls+0x228>
    80004376:	0521                	add	a0,a0,8
    80004378:	ffffc097          	auipc	ra,0xffffc
    8000437c:	7f4080e7          	jalr	2036(ra) # 80000b6c <initlock>
  lk->name = name;
    80004380:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004384:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004388:	0204a423          	sw	zero,40(s1)
}
    8000438c:	60e2                	ld	ra,24(sp)
    8000438e:	6442                	ld	s0,16(sp)
    80004390:	64a2                	ld	s1,8(sp)
    80004392:	6902                	ld	s2,0(sp)
    80004394:	6105                	add	sp,sp,32
    80004396:	8082                	ret

0000000080004398 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004398:	1101                	add	sp,sp,-32
    8000439a:	ec06                	sd	ra,24(sp)
    8000439c:	e822                	sd	s0,16(sp)
    8000439e:	e426                	sd	s1,8(sp)
    800043a0:	e04a                	sd	s2,0(sp)
    800043a2:	1000                	add	s0,sp,32
    800043a4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800043a6:	00850913          	add	s2,a0,8
    800043aa:	854a                	mv	a0,s2
    800043ac:	ffffd097          	auipc	ra,0xffffd
    800043b0:	850080e7          	jalr	-1968(ra) # 80000bfc <acquire>
  while (lk->locked) {
    800043b4:	409c                	lw	a5,0(s1)
    800043b6:	cb89                	beqz	a5,800043c8 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800043b8:	85ca                	mv	a1,s2
    800043ba:	8526                	mv	a0,s1
    800043bc:	ffffe097          	auipc	ra,0xffffe
    800043c0:	e98080e7          	jalr	-360(ra) # 80002254 <sleep>
  while (lk->locked) {
    800043c4:	409c                	lw	a5,0(s1)
    800043c6:	fbed                	bnez	a5,800043b8 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800043c8:	4785                	li	a5,1
    800043ca:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800043cc:	ffffd097          	auipc	ra,0xffffd
    800043d0:	672080e7          	jalr	1650(ra) # 80001a3e <myproc>
    800043d4:	5d1c                	lw	a5,56(a0)
    800043d6:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800043d8:	854a                	mv	a0,s2
    800043da:	ffffd097          	auipc	ra,0xffffd
    800043de:	8d6080e7          	jalr	-1834(ra) # 80000cb0 <release>
}
    800043e2:	60e2                	ld	ra,24(sp)
    800043e4:	6442                	ld	s0,16(sp)
    800043e6:	64a2                	ld	s1,8(sp)
    800043e8:	6902                	ld	s2,0(sp)
    800043ea:	6105                	add	sp,sp,32
    800043ec:	8082                	ret

00000000800043ee <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800043ee:	1101                	add	sp,sp,-32
    800043f0:	ec06                	sd	ra,24(sp)
    800043f2:	e822                	sd	s0,16(sp)
    800043f4:	e426                	sd	s1,8(sp)
    800043f6:	e04a                	sd	s2,0(sp)
    800043f8:	1000                	add	s0,sp,32
    800043fa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800043fc:	00850913          	add	s2,a0,8
    80004400:	854a                	mv	a0,s2
    80004402:	ffffc097          	auipc	ra,0xffffc
    80004406:	7fa080e7          	jalr	2042(ra) # 80000bfc <acquire>
  lk->locked = 0;
    8000440a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000440e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004412:	8526                	mv	a0,s1
    80004414:	ffffe097          	auipc	ra,0xffffe
    80004418:	fc0080e7          	jalr	-64(ra) # 800023d4 <wakeup>
  release(&lk->lk);
    8000441c:	854a                	mv	a0,s2
    8000441e:	ffffd097          	auipc	ra,0xffffd
    80004422:	892080e7          	jalr	-1902(ra) # 80000cb0 <release>
}
    80004426:	60e2                	ld	ra,24(sp)
    80004428:	6442                	ld	s0,16(sp)
    8000442a:	64a2                	ld	s1,8(sp)
    8000442c:	6902                	ld	s2,0(sp)
    8000442e:	6105                	add	sp,sp,32
    80004430:	8082                	ret

0000000080004432 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004432:	7179                	add	sp,sp,-48
    80004434:	f406                	sd	ra,40(sp)
    80004436:	f022                	sd	s0,32(sp)
    80004438:	ec26                	sd	s1,24(sp)
    8000443a:	e84a                	sd	s2,16(sp)
    8000443c:	e44e                	sd	s3,8(sp)
    8000443e:	1800                	add	s0,sp,48
    80004440:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004442:	00850913          	add	s2,a0,8
    80004446:	854a                	mv	a0,s2
    80004448:	ffffc097          	auipc	ra,0xffffc
    8000444c:	7b4080e7          	jalr	1972(ra) # 80000bfc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004450:	409c                	lw	a5,0(s1)
    80004452:	ef99                	bnez	a5,80004470 <holdingsleep+0x3e>
    80004454:	4481                	li	s1,0
  release(&lk->lk);
    80004456:	854a                	mv	a0,s2
    80004458:	ffffd097          	auipc	ra,0xffffd
    8000445c:	858080e7          	jalr	-1960(ra) # 80000cb0 <release>
  return r;
}
    80004460:	8526                	mv	a0,s1
    80004462:	70a2                	ld	ra,40(sp)
    80004464:	7402                	ld	s0,32(sp)
    80004466:	64e2                	ld	s1,24(sp)
    80004468:	6942                	ld	s2,16(sp)
    8000446a:	69a2                	ld	s3,8(sp)
    8000446c:	6145                	add	sp,sp,48
    8000446e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004470:	0284a983          	lw	s3,40(s1)
    80004474:	ffffd097          	auipc	ra,0xffffd
    80004478:	5ca080e7          	jalr	1482(ra) # 80001a3e <myproc>
    8000447c:	5d04                	lw	s1,56(a0)
    8000447e:	413484b3          	sub	s1,s1,s3
    80004482:	0014b493          	seqz	s1,s1
    80004486:	bfc1                	j	80004456 <holdingsleep+0x24>

0000000080004488 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004488:	1141                	add	sp,sp,-16
    8000448a:	e406                	sd	ra,8(sp)
    8000448c:	e022                	sd	s0,0(sp)
    8000448e:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004490:	00004597          	auipc	a1,0x4
    80004494:	16858593          	add	a1,a1,360 # 800085f8 <syscalls+0x238>
    80004498:	0001d517          	auipc	a0,0x1d
    8000449c:	5b850513          	add	a0,a0,1464 # 80021a50 <ftable>
    800044a0:	ffffc097          	auipc	ra,0xffffc
    800044a4:	6cc080e7          	jalr	1740(ra) # 80000b6c <initlock>
}
    800044a8:	60a2                	ld	ra,8(sp)
    800044aa:	6402                	ld	s0,0(sp)
    800044ac:	0141                	add	sp,sp,16
    800044ae:	8082                	ret

00000000800044b0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800044b0:	1101                	add	sp,sp,-32
    800044b2:	ec06                	sd	ra,24(sp)
    800044b4:	e822                	sd	s0,16(sp)
    800044b6:	e426                	sd	s1,8(sp)
    800044b8:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800044ba:	0001d517          	auipc	a0,0x1d
    800044be:	59650513          	add	a0,a0,1430 # 80021a50 <ftable>
    800044c2:	ffffc097          	auipc	ra,0xffffc
    800044c6:	73a080e7          	jalr	1850(ra) # 80000bfc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800044ca:	0001d497          	auipc	s1,0x1d
    800044ce:	59e48493          	add	s1,s1,1438 # 80021a68 <ftable+0x18>
    800044d2:	0001e717          	auipc	a4,0x1e
    800044d6:	53670713          	add	a4,a4,1334 # 80022a08 <ftable+0xfb8>
    if(f->ref == 0){
    800044da:	40dc                	lw	a5,4(s1)
    800044dc:	cf99                	beqz	a5,800044fa <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800044de:	02848493          	add	s1,s1,40
    800044e2:	fee49ce3          	bne	s1,a4,800044da <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800044e6:	0001d517          	auipc	a0,0x1d
    800044ea:	56a50513          	add	a0,a0,1386 # 80021a50 <ftable>
    800044ee:	ffffc097          	auipc	ra,0xffffc
    800044f2:	7c2080e7          	jalr	1986(ra) # 80000cb0 <release>
  return 0;
    800044f6:	4481                	li	s1,0
    800044f8:	a819                	j	8000450e <filealloc+0x5e>
      f->ref = 1;
    800044fa:	4785                	li	a5,1
    800044fc:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800044fe:	0001d517          	auipc	a0,0x1d
    80004502:	55250513          	add	a0,a0,1362 # 80021a50 <ftable>
    80004506:	ffffc097          	auipc	ra,0xffffc
    8000450a:	7aa080e7          	jalr	1962(ra) # 80000cb0 <release>
}
    8000450e:	8526                	mv	a0,s1
    80004510:	60e2                	ld	ra,24(sp)
    80004512:	6442                	ld	s0,16(sp)
    80004514:	64a2                	ld	s1,8(sp)
    80004516:	6105                	add	sp,sp,32
    80004518:	8082                	ret

000000008000451a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000451a:	1101                	add	sp,sp,-32
    8000451c:	ec06                	sd	ra,24(sp)
    8000451e:	e822                	sd	s0,16(sp)
    80004520:	e426                	sd	s1,8(sp)
    80004522:	1000                	add	s0,sp,32
    80004524:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004526:	0001d517          	auipc	a0,0x1d
    8000452a:	52a50513          	add	a0,a0,1322 # 80021a50 <ftable>
    8000452e:	ffffc097          	auipc	ra,0xffffc
    80004532:	6ce080e7          	jalr	1742(ra) # 80000bfc <acquire>
  if(f->ref < 1)
    80004536:	40dc                	lw	a5,4(s1)
    80004538:	02f05263          	blez	a5,8000455c <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000453c:	2785                	addw	a5,a5,1
    8000453e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004540:	0001d517          	auipc	a0,0x1d
    80004544:	51050513          	add	a0,a0,1296 # 80021a50 <ftable>
    80004548:	ffffc097          	auipc	ra,0xffffc
    8000454c:	768080e7          	jalr	1896(ra) # 80000cb0 <release>
  return f;
}
    80004550:	8526                	mv	a0,s1
    80004552:	60e2                	ld	ra,24(sp)
    80004554:	6442                	ld	s0,16(sp)
    80004556:	64a2                	ld	s1,8(sp)
    80004558:	6105                	add	sp,sp,32
    8000455a:	8082                	ret
    panic("filedup");
    8000455c:	00004517          	auipc	a0,0x4
    80004560:	0a450513          	add	a0,a0,164 # 80008600 <syscalls+0x240>
    80004564:	ffffc097          	auipc	ra,0xffffc
    80004568:	fde080e7          	jalr	-34(ra) # 80000542 <panic>

000000008000456c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000456c:	7139                	add	sp,sp,-64
    8000456e:	fc06                	sd	ra,56(sp)
    80004570:	f822                	sd	s0,48(sp)
    80004572:	f426                	sd	s1,40(sp)
    80004574:	f04a                	sd	s2,32(sp)
    80004576:	ec4e                	sd	s3,24(sp)
    80004578:	e852                	sd	s4,16(sp)
    8000457a:	e456                	sd	s5,8(sp)
    8000457c:	0080                	add	s0,sp,64
    8000457e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004580:	0001d517          	auipc	a0,0x1d
    80004584:	4d050513          	add	a0,a0,1232 # 80021a50 <ftable>
    80004588:	ffffc097          	auipc	ra,0xffffc
    8000458c:	674080e7          	jalr	1652(ra) # 80000bfc <acquire>
  if(f->ref < 1)
    80004590:	40dc                	lw	a5,4(s1)
    80004592:	06f05163          	blez	a5,800045f4 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004596:	37fd                	addw	a5,a5,-1
    80004598:	0007871b          	sext.w	a4,a5
    8000459c:	c0dc                	sw	a5,4(s1)
    8000459e:	06e04363          	bgtz	a4,80004604 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800045a2:	0004a903          	lw	s2,0(s1)
    800045a6:	0094ca83          	lbu	s5,9(s1)
    800045aa:	0104ba03          	ld	s4,16(s1)
    800045ae:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800045b2:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800045b6:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800045ba:	0001d517          	auipc	a0,0x1d
    800045be:	49650513          	add	a0,a0,1174 # 80021a50 <ftable>
    800045c2:	ffffc097          	auipc	ra,0xffffc
    800045c6:	6ee080e7          	jalr	1774(ra) # 80000cb0 <release>

  if(ff.type == FD_PIPE){
    800045ca:	4785                	li	a5,1
    800045cc:	04f90d63          	beq	s2,a5,80004626 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800045d0:	3979                	addw	s2,s2,-2
    800045d2:	4785                	li	a5,1
    800045d4:	0527e063          	bltu	a5,s2,80004614 <fileclose+0xa8>
    begin_op();
    800045d8:	00000097          	auipc	ra,0x0
    800045dc:	aca080e7          	jalr	-1334(ra) # 800040a2 <begin_op>
    iput(ff.ip);
    800045e0:	854e                	mv	a0,s3
    800045e2:	fffff097          	auipc	ra,0xfffff
    800045e6:	2d6080e7          	jalr	726(ra) # 800038b8 <iput>
    end_op();
    800045ea:	00000097          	auipc	ra,0x0
    800045ee:	b32080e7          	jalr	-1230(ra) # 8000411c <end_op>
    800045f2:	a00d                	j	80004614 <fileclose+0xa8>
    panic("fileclose");
    800045f4:	00004517          	auipc	a0,0x4
    800045f8:	01450513          	add	a0,a0,20 # 80008608 <syscalls+0x248>
    800045fc:	ffffc097          	auipc	ra,0xffffc
    80004600:	f46080e7          	jalr	-186(ra) # 80000542 <panic>
    release(&ftable.lock);
    80004604:	0001d517          	auipc	a0,0x1d
    80004608:	44c50513          	add	a0,a0,1100 # 80021a50 <ftable>
    8000460c:	ffffc097          	auipc	ra,0xffffc
    80004610:	6a4080e7          	jalr	1700(ra) # 80000cb0 <release>
  }
}
    80004614:	70e2                	ld	ra,56(sp)
    80004616:	7442                	ld	s0,48(sp)
    80004618:	74a2                	ld	s1,40(sp)
    8000461a:	7902                	ld	s2,32(sp)
    8000461c:	69e2                	ld	s3,24(sp)
    8000461e:	6a42                	ld	s4,16(sp)
    80004620:	6aa2                	ld	s5,8(sp)
    80004622:	6121                	add	sp,sp,64
    80004624:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004626:	85d6                	mv	a1,s5
    80004628:	8552                	mv	a0,s4
    8000462a:	00000097          	auipc	ra,0x0
    8000462e:	372080e7          	jalr	882(ra) # 8000499c <pipeclose>
    80004632:	b7cd                	j	80004614 <fileclose+0xa8>

0000000080004634 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004634:	715d                	add	sp,sp,-80
    80004636:	e486                	sd	ra,72(sp)
    80004638:	e0a2                	sd	s0,64(sp)
    8000463a:	fc26                	sd	s1,56(sp)
    8000463c:	f84a                	sd	s2,48(sp)
    8000463e:	f44e                	sd	s3,40(sp)
    80004640:	0880                	add	s0,sp,80
    80004642:	84aa                	mv	s1,a0
    80004644:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004646:	ffffd097          	auipc	ra,0xffffd
    8000464a:	3f8080e7          	jalr	1016(ra) # 80001a3e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000464e:	409c                	lw	a5,0(s1)
    80004650:	37f9                	addw	a5,a5,-2
    80004652:	4705                	li	a4,1
    80004654:	04f76763          	bltu	a4,a5,800046a2 <filestat+0x6e>
    80004658:	892a                	mv	s2,a0
    ilock(f->ip);
    8000465a:	6c88                	ld	a0,24(s1)
    8000465c:	fffff097          	auipc	ra,0xfffff
    80004660:	0a2080e7          	jalr	162(ra) # 800036fe <ilock>
    stati(f->ip, &st);
    80004664:	fb840593          	add	a1,s0,-72
    80004668:	6c88                	ld	a0,24(s1)
    8000466a:	fffff097          	auipc	ra,0xfffff
    8000466e:	31e080e7          	jalr	798(ra) # 80003988 <stati>
    iunlock(f->ip);
    80004672:	6c88                	ld	a0,24(s1)
    80004674:	fffff097          	auipc	ra,0xfffff
    80004678:	14c080e7          	jalr	332(ra) # 800037c0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000467c:	46e1                	li	a3,24
    8000467e:	fb840613          	add	a2,s0,-72
    80004682:	85ce                	mv	a1,s3
    80004684:	05093503          	ld	a0,80(s2)
    80004688:	ffffd097          	auipc	ra,0xffffd
    8000468c:	ffa080e7          	jalr	-6(ra) # 80001682 <copyout>
    80004690:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004694:	60a6                	ld	ra,72(sp)
    80004696:	6406                	ld	s0,64(sp)
    80004698:	74e2                	ld	s1,56(sp)
    8000469a:	7942                	ld	s2,48(sp)
    8000469c:	79a2                	ld	s3,40(sp)
    8000469e:	6161                	add	sp,sp,80
    800046a0:	8082                	ret
  return -1;
    800046a2:	557d                	li	a0,-1
    800046a4:	bfc5                	j	80004694 <filestat+0x60>

00000000800046a6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800046a6:	7179                	add	sp,sp,-48
    800046a8:	f406                	sd	ra,40(sp)
    800046aa:	f022                	sd	s0,32(sp)
    800046ac:	ec26                	sd	s1,24(sp)
    800046ae:	e84a                	sd	s2,16(sp)
    800046b0:	e44e                	sd	s3,8(sp)
    800046b2:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800046b4:	00854783          	lbu	a5,8(a0)
    800046b8:	c3d5                	beqz	a5,8000475c <fileread+0xb6>
    800046ba:	84aa                	mv	s1,a0
    800046bc:	89ae                	mv	s3,a1
    800046be:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800046c0:	411c                	lw	a5,0(a0)
    800046c2:	4705                	li	a4,1
    800046c4:	04e78963          	beq	a5,a4,80004716 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800046c8:	470d                	li	a4,3
    800046ca:	04e78d63          	beq	a5,a4,80004724 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800046ce:	4709                	li	a4,2
    800046d0:	06e79e63          	bne	a5,a4,8000474c <fileread+0xa6>
    ilock(f->ip);
    800046d4:	6d08                	ld	a0,24(a0)
    800046d6:	fffff097          	auipc	ra,0xfffff
    800046da:	028080e7          	jalr	40(ra) # 800036fe <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800046de:	874a                	mv	a4,s2
    800046e0:	5094                	lw	a3,32(s1)
    800046e2:	864e                	mv	a2,s3
    800046e4:	4585                	li	a1,1
    800046e6:	6c88                	ld	a0,24(s1)
    800046e8:	fffff097          	auipc	ra,0xfffff
    800046ec:	2ca080e7          	jalr	714(ra) # 800039b2 <readi>
    800046f0:	892a                	mv	s2,a0
    800046f2:	00a05563          	blez	a0,800046fc <fileread+0x56>
      f->off += r;
    800046f6:	509c                	lw	a5,32(s1)
    800046f8:	9fa9                	addw	a5,a5,a0
    800046fa:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800046fc:	6c88                	ld	a0,24(s1)
    800046fe:	fffff097          	auipc	ra,0xfffff
    80004702:	0c2080e7          	jalr	194(ra) # 800037c0 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004706:	854a                	mv	a0,s2
    80004708:	70a2                	ld	ra,40(sp)
    8000470a:	7402                	ld	s0,32(sp)
    8000470c:	64e2                	ld	s1,24(sp)
    8000470e:	6942                	ld	s2,16(sp)
    80004710:	69a2                	ld	s3,8(sp)
    80004712:	6145                	add	sp,sp,48
    80004714:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004716:	6908                	ld	a0,16(a0)
    80004718:	00000097          	auipc	ra,0x0
    8000471c:	3ee080e7          	jalr	1006(ra) # 80004b06 <piperead>
    80004720:	892a                	mv	s2,a0
    80004722:	b7d5                	j	80004706 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004724:	02451783          	lh	a5,36(a0)
    80004728:	03079693          	sll	a3,a5,0x30
    8000472c:	92c1                	srl	a3,a3,0x30
    8000472e:	4725                	li	a4,9
    80004730:	02d76863          	bltu	a4,a3,80004760 <fileread+0xba>
    80004734:	0792                	sll	a5,a5,0x4
    80004736:	0001d717          	auipc	a4,0x1d
    8000473a:	27a70713          	add	a4,a4,634 # 800219b0 <devsw>
    8000473e:	97ba                	add	a5,a5,a4
    80004740:	639c                	ld	a5,0(a5)
    80004742:	c38d                	beqz	a5,80004764 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004744:	4505                	li	a0,1
    80004746:	9782                	jalr	a5
    80004748:	892a                	mv	s2,a0
    8000474a:	bf75                	j	80004706 <fileread+0x60>
    panic("fileread");
    8000474c:	00004517          	auipc	a0,0x4
    80004750:	ecc50513          	add	a0,a0,-308 # 80008618 <syscalls+0x258>
    80004754:	ffffc097          	auipc	ra,0xffffc
    80004758:	dee080e7          	jalr	-530(ra) # 80000542 <panic>
    return -1;
    8000475c:	597d                	li	s2,-1
    8000475e:	b765                	j	80004706 <fileread+0x60>
      return -1;
    80004760:	597d                	li	s2,-1
    80004762:	b755                	j	80004706 <fileread+0x60>
    80004764:	597d                	li	s2,-1
    80004766:	b745                	j	80004706 <fileread+0x60>

0000000080004768 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004768:	00954783          	lbu	a5,9(a0)
    8000476c:	14078363          	beqz	a5,800048b2 <filewrite+0x14a>
{
    80004770:	715d                	add	sp,sp,-80
    80004772:	e486                	sd	ra,72(sp)
    80004774:	e0a2                	sd	s0,64(sp)
    80004776:	fc26                	sd	s1,56(sp)
    80004778:	f84a                	sd	s2,48(sp)
    8000477a:	f44e                	sd	s3,40(sp)
    8000477c:	f052                	sd	s4,32(sp)
    8000477e:	ec56                	sd	s5,24(sp)
    80004780:	e85a                	sd	s6,16(sp)
    80004782:	e45e                	sd	s7,8(sp)
    80004784:	e062                	sd	s8,0(sp)
    80004786:	0880                	add	s0,sp,80
    80004788:	892a                	mv	s2,a0
    8000478a:	8b2e                	mv	s6,a1
    8000478c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000478e:	411c                	lw	a5,0(a0)
    80004790:	4705                	li	a4,1
    80004792:	02e78263          	beq	a5,a4,800047b6 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004796:	470d                	li	a4,3
    80004798:	02e78563          	beq	a5,a4,800047c2 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000479c:	4709                	li	a4,2
    8000479e:	10e79263          	bne	a5,a4,800048a2 <filewrite+0x13a>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800047a2:	0ec05e63          	blez	a2,8000489e <filewrite+0x136>
    int i = 0;
    800047a6:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800047a8:	6b85                	lui	s7,0x1
    800047aa:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800047ae:	6c05                	lui	s8,0x1
    800047b0:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800047b4:	a851                	j	80004848 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    800047b6:	6908                	ld	a0,16(a0)
    800047b8:	00000097          	auipc	ra,0x0
    800047bc:	254080e7          	jalr	596(ra) # 80004a0c <pipewrite>
    800047c0:	a85d                	j	80004876 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800047c2:	02451783          	lh	a5,36(a0)
    800047c6:	03079693          	sll	a3,a5,0x30
    800047ca:	92c1                	srl	a3,a3,0x30
    800047cc:	4725                	li	a4,9
    800047ce:	0ed76463          	bltu	a4,a3,800048b6 <filewrite+0x14e>
    800047d2:	0792                	sll	a5,a5,0x4
    800047d4:	0001d717          	auipc	a4,0x1d
    800047d8:	1dc70713          	add	a4,a4,476 # 800219b0 <devsw>
    800047dc:	97ba                	add	a5,a5,a4
    800047de:	679c                	ld	a5,8(a5)
    800047e0:	cfe9                	beqz	a5,800048ba <filewrite+0x152>
    ret = devsw[f->major].write(1, addr, n);
    800047e2:	4505                	li	a0,1
    800047e4:	9782                	jalr	a5
    800047e6:	a841                	j	80004876 <filewrite+0x10e>
      if(n1 > max)
    800047e8:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800047ec:	00000097          	auipc	ra,0x0
    800047f0:	8b6080e7          	jalr	-1866(ra) # 800040a2 <begin_op>
      ilock(f->ip);
    800047f4:	01893503          	ld	a0,24(s2)
    800047f8:	fffff097          	auipc	ra,0xfffff
    800047fc:	f06080e7          	jalr	-250(ra) # 800036fe <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004800:	8756                	mv	a4,s5
    80004802:	02092683          	lw	a3,32(s2)
    80004806:	01698633          	add	a2,s3,s6
    8000480a:	4585                	li	a1,1
    8000480c:	01893503          	ld	a0,24(s2)
    80004810:	fffff097          	auipc	ra,0xfffff
    80004814:	29a080e7          	jalr	666(ra) # 80003aaa <writei>
    80004818:	84aa                	mv	s1,a0
    8000481a:	02a05f63          	blez	a0,80004858 <filewrite+0xf0>
        f->off += r;
    8000481e:	02092783          	lw	a5,32(s2)
    80004822:	9fa9                	addw	a5,a5,a0
    80004824:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004828:	01893503          	ld	a0,24(s2)
    8000482c:	fffff097          	auipc	ra,0xfffff
    80004830:	f94080e7          	jalr	-108(ra) # 800037c0 <iunlock>
      end_op();
    80004834:	00000097          	auipc	ra,0x0
    80004838:	8e8080e7          	jalr	-1816(ra) # 8000411c <end_op>

      if(r < 0)
        break;
      if(r != n1)
    8000483c:	049a9963          	bne	s5,s1,8000488e <filewrite+0x126>
        panic("short filewrite");
      i += r;
    80004840:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004844:	0349d663          	bge	s3,s4,80004870 <filewrite+0x108>
      int n1 = n - i;
    80004848:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000484c:	0004879b          	sext.w	a5,s1
    80004850:	f8fbdce3          	bge	s7,a5,800047e8 <filewrite+0x80>
    80004854:	84e2                	mv	s1,s8
    80004856:	bf49                	j	800047e8 <filewrite+0x80>
      iunlock(f->ip);
    80004858:	01893503          	ld	a0,24(s2)
    8000485c:	fffff097          	auipc	ra,0xfffff
    80004860:	f64080e7          	jalr	-156(ra) # 800037c0 <iunlock>
      end_op();
    80004864:	00000097          	auipc	ra,0x0
    80004868:	8b8080e7          	jalr	-1864(ra) # 8000411c <end_op>
      if(r < 0)
    8000486c:	fc04d8e3          	bgez	s1,8000483c <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004870:	053a1763          	bne	s4,s3,800048be <filewrite+0x156>
    80004874:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004876:	60a6                	ld	ra,72(sp)
    80004878:	6406                	ld	s0,64(sp)
    8000487a:	74e2                	ld	s1,56(sp)
    8000487c:	7942                	ld	s2,48(sp)
    8000487e:	79a2                	ld	s3,40(sp)
    80004880:	7a02                	ld	s4,32(sp)
    80004882:	6ae2                	ld	s5,24(sp)
    80004884:	6b42                	ld	s6,16(sp)
    80004886:	6ba2                	ld	s7,8(sp)
    80004888:	6c02                	ld	s8,0(sp)
    8000488a:	6161                	add	sp,sp,80
    8000488c:	8082                	ret
        panic("short filewrite");
    8000488e:	00004517          	auipc	a0,0x4
    80004892:	d9a50513          	add	a0,a0,-614 # 80008628 <syscalls+0x268>
    80004896:	ffffc097          	auipc	ra,0xffffc
    8000489a:	cac080e7          	jalr	-852(ra) # 80000542 <panic>
    int i = 0;
    8000489e:	4981                	li	s3,0
    800048a0:	bfc1                	j	80004870 <filewrite+0x108>
    panic("filewrite");
    800048a2:	00004517          	auipc	a0,0x4
    800048a6:	d9650513          	add	a0,a0,-618 # 80008638 <syscalls+0x278>
    800048aa:	ffffc097          	auipc	ra,0xffffc
    800048ae:	c98080e7          	jalr	-872(ra) # 80000542 <panic>
    return -1;
    800048b2:	557d                	li	a0,-1
}
    800048b4:	8082                	ret
      return -1;
    800048b6:	557d                	li	a0,-1
    800048b8:	bf7d                	j	80004876 <filewrite+0x10e>
    800048ba:	557d                	li	a0,-1
    800048bc:	bf6d                	j	80004876 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    800048be:	557d                	li	a0,-1
    800048c0:	bf5d                	j	80004876 <filewrite+0x10e>

00000000800048c2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800048c2:	7179                	add	sp,sp,-48
    800048c4:	f406                	sd	ra,40(sp)
    800048c6:	f022                	sd	s0,32(sp)
    800048c8:	ec26                	sd	s1,24(sp)
    800048ca:	e84a                	sd	s2,16(sp)
    800048cc:	e44e                	sd	s3,8(sp)
    800048ce:	e052                	sd	s4,0(sp)
    800048d0:	1800                	add	s0,sp,48
    800048d2:	84aa                	mv	s1,a0
    800048d4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800048d6:	0005b023          	sd	zero,0(a1)
    800048da:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800048de:	00000097          	auipc	ra,0x0
    800048e2:	bd2080e7          	jalr	-1070(ra) # 800044b0 <filealloc>
    800048e6:	e088                	sd	a0,0(s1)
    800048e8:	c551                	beqz	a0,80004974 <pipealloc+0xb2>
    800048ea:	00000097          	auipc	ra,0x0
    800048ee:	bc6080e7          	jalr	-1082(ra) # 800044b0 <filealloc>
    800048f2:	00aa3023          	sd	a0,0(s4)
    800048f6:	c92d                	beqz	a0,80004968 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800048f8:	ffffc097          	auipc	ra,0xffffc
    800048fc:	214080e7          	jalr	532(ra) # 80000b0c <kalloc>
    80004900:	892a                	mv	s2,a0
    80004902:	c125                	beqz	a0,80004962 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004904:	4985                	li	s3,1
    80004906:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000490a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000490e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004912:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004916:	00004597          	auipc	a1,0x4
    8000491a:	d3258593          	add	a1,a1,-718 # 80008648 <syscalls+0x288>
    8000491e:	ffffc097          	auipc	ra,0xffffc
    80004922:	24e080e7          	jalr	590(ra) # 80000b6c <initlock>
  (*f0)->type = FD_PIPE;
    80004926:	609c                	ld	a5,0(s1)
    80004928:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000492c:	609c                	ld	a5,0(s1)
    8000492e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004932:	609c                	ld	a5,0(s1)
    80004934:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004938:	609c                	ld	a5,0(s1)
    8000493a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000493e:	000a3783          	ld	a5,0(s4)
    80004942:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004946:	000a3783          	ld	a5,0(s4)
    8000494a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000494e:	000a3783          	ld	a5,0(s4)
    80004952:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004956:	000a3783          	ld	a5,0(s4)
    8000495a:	0127b823          	sd	s2,16(a5)
  return 0;
    8000495e:	4501                	li	a0,0
    80004960:	a025                	j	80004988 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004962:	6088                	ld	a0,0(s1)
    80004964:	e501                	bnez	a0,8000496c <pipealloc+0xaa>
    80004966:	a039                	j	80004974 <pipealloc+0xb2>
    80004968:	6088                	ld	a0,0(s1)
    8000496a:	c51d                	beqz	a0,80004998 <pipealloc+0xd6>
    fileclose(*f0);
    8000496c:	00000097          	auipc	ra,0x0
    80004970:	c00080e7          	jalr	-1024(ra) # 8000456c <fileclose>
  if(*f1)
    80004974:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004978:	557d                	li	a0,-1
  if(*f1)
    8000497a:	c799                	beqz	a5,80004988 <pipealloc+0xc6>
    fileclose(*f1);
    8000497c:	853e                	mv	a0,a5
    8000497e:	00000097          	auipc	ra,0x0
    80004982:	bee080e7          	jalr	-1042(ra) # 8000456c <fileclose>
  return -1;
    80004986:	557d                	li	a0,-1
}
    80004988:	70a2                	ld	ra,40(sp)
    8000498a:	7402                	ld	s0,32(sp)
    8000498c:	64e2                	ld	s1,24(sp)
    8000498e:	6942                	ld	s2,16(sp)
    80004990:	69a2                	ld	s3,8(sp)
    80004992:	6a02                	ld	s4,0(sp)
    80004994:	6145                	add	sp,sp,48
    80004996:	8082                	ret
  return -1;
    80004998:	557d                	li	a0,-1
    8000499a:	b7fd                	j	80004988 <pipealloc+0xc6>

000000008000499c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000499c:	1101                	add	sp,sp,-32
    8000499e:	ec06                	sd	ra,24(sp)
    800049a0:	e822                	sd	s0,16(sp)
    800049a2:	e426                	sd	s1,8(sp)
    800049a4:	e04a                	sd	s2,0(sp)
    800049a6:	1000                	add	s0,sp,32
    800049a8:	84aa                	mv	s1,a0
    800049aa:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800049ac:	ffffc097          	auipc	ra,0xffffc
    800049b0:	250080e7          	jalr	592(ra) # 80000bfc <acquire>
  if(writable){
    800049b4:	02090d63          	beqz	s2,800049ee <pipeclose+0x52>
    pi->writeopen = 0;
    800049b8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800049bc:	21848513          	add	a0,s1,536
    800049c0:	ffffe097          	auipc	ra,0xffffe
    800049c4:	a14080e7          	jalr	-1516(ra) # 800023d4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800049c8:	2204b783          	ld	a5,544(s1)
    800049cc:	eb95                	bnez	a5,80004a00 <pipeclose+0x64>
    release(&pi->lock);
    800049ce:	8526                	mv	a0,s1
    800049d0:	ffffc097          	auipc	ra,0xffffc
    800049d4:	2e0080e7          	jalr	736(ra) # 80000cb0 <release>
    kfree((char*)pi);
    800049d8:	8526                	mv	a0,s1
    800049da:	ffffc097          	auipc	ra,0xffffc
    800049de:	034080e7          	jalr	52(ra) # 80000a0e <kfree>
  } else
    release(&pi->lock);
}
    800049e2:	60e2                	ld	ra,24(sp)
    800049e4:	6442                	ld	s0,16(sp)
    800049e6:	64a2                	ld	s1,8(sp)
    800049e8:	6902                	ld	s2,0(sp)
    800049ea:	6105                	add	sp,sp,32
    800049ec:	8082                	ret
    pi->readopen = 0;
    800049ee:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800049f2:	21c48513          	add	a0,s1,540
    800049f6:	ffffe097          	auipc	ra,0xffffe
    800049fa:	9de080e7          	jalr	-1570(ra) # 800023d4 <wakeup>
    800049fe:	b7e9                	j	800049c8 <pipeclose+0x2c>
    release(&pi->lock);
    80004a00:	8526                	mv	a0,s1
    80004a02:	ffffc097          	auipc	ra,0xffffc
    80004a06:	2ae080e7          	jalr	686(ra) # 80000cb0 <release>
}
    80004a0a:	bfe1                	j	800049e2 <pipeclose+0x46>

0000000080004a0c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004a0c:	711d                	add	sp,sp,-96
    80004a0e:	ec86                	sd	ra,88(sp)
    80004a10:	e8a2                	sd	s0,80(sp)
    80004a12:	e4a6                	sd	s1,72(sp)
    80004a14:	e0ca                	sd	s2,64(sp)
    80004a16:	fc4e                	sd	s3,56(sp)
    80004a18:	f852                	sd	s4,48(sp)
    80004a1a:	f456                	sd	s5,40(sp)
    80004a1c:	f05a                	sd	s6,32(sp)
    80004a1e:	ec5e                	sd	s7,24(sp)
    80004a20:	1080                	add	s0,sp,96
    80004a22:	84aa                	mv	s1,a0
    80004a24:	8b2e                	mv	s6,a1
    80004a26:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004a28:	ffffd097          	auipc	ra,0xffffd
    80004a2c:	016080e7          	jalr	22(ra) # 80001a3e <myproc>
    80004a30:	892a                	mv	s2,a0

  acquire(&pi->lock);
    80004a32:	8526                	mv	a0,s1
    80004a34:	ffffc097          	auipc	ra,0xffffc
    80004a38:	1c8080e7          	jalr	456(ra) # 80000bfc <acquire>
  for(i = 0; i < n; i++){
    80004a3c:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004a3e:	21848a13          	add	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004a42:	21c48993          	add	s3,s1,540
  for(i = 0; i < n; i++){
    80004a46:	09505263          	blez	s5,80004aca <pipewrite+0xbe>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004a4a:	2184a783          	lw	a5,536(s1)
    80004a4e:	21c4a703          	lw	a4,540(s1)
    80004a52:	2007879b          	addw	a5,a5,512
    80004a56:	02f71b63          	bne	a4,a5,80004a8c <pipewrite+0x80>
      if(pi->readopen == 0 || pr->killed){
    80004a5a:	2204a783          	lw	a5,544(s1)
    80004a5e:	c3d1                	beqz	a5,80004ae2 <pipewrite+0xd6>
    80004a60:	03092783          	lw	a5,48(s2)
    80004a64:	efbd                	bnez	a5,80004ae2 <pipewrite+0xd6>
      wakeup(&pi->nread);
    80004a66:	8552                	mv	a0,s4
    80004a68:	ffffe097          	auipc	ra,0xffffe
    80004a6c:	96c080e7          	jalr	-1684(ra) # 800023d4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004a70:	85a6                	mv	a1,s1
    80004a72:	854e                	mv	a0,s3
    80004a74:	ffffd097          	auipc	ra,0xffffd
    80004a78:	7e0080e7          	jalr	2016(ra) # 80002254 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004a7c:	2184a783          	lw	a5,536(s1)
    80004a80:	21c4a703          	lw	a4,540(s1)
    80004a84:	2007879b          	addw	a5,a5,512
    80004a88:	fcf709e3          	beq	a4,a5,80004a5a <pipewrite+0x4e>
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004a8c:	4685                	li	a3,1
    80004a8e:	865a                	mv	a2,s6
    80004a90:	faf40593          	add	a1,s0,-81
    80004a94:	05093503          	ld	a0,80(s2)
    80004a98:	ffffd097          	auipc	ra,0xffffd
    80004a9c:	cd0080e7          	jalr	-816(ra) # 80001768 <copyin>
    80004aa0:	57fd                	li	a5,-1
    80004aa2:	02f50463          	beq	a0,a5,80004aca <pipewrite+0xbe>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004aa6:	21c4a783          	lw	a5,540(s1)
    80004aaa:	0017871b          	addw	a4,a5,1
    80004aae:	20e4ae23          	sw	a4,540(s1)
    80004ab2:	1ff7f793          	and	a5,a5,511
    80004ab6:	97a6                	add	a5,a5,s1
    80004ab8:	faf44703          	lbu	a4,-81(s0)
    80004abc:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004ac0:	2b85                	addw	s7,s7,1
    80004ac2:	0b05                	add	s6,s6,1
    80004ac4:	f97a93e3          	bne	s5,s7,80004a4a <pipewrite+0x3e>
    80004ac8:	8bd6                	mv	s7,s5
  }
  wakeup(&pi->nread);
    80004aca:	21848513          	add	a0,s1,536
    80004ace:	ffffe097          	auipc	ra,0xffffe
    80004ad2:	906080e7          	jalr	-1786(ra) # 800023d4 <wakeup>
  release(&pi->lock);
    80004ad6:	8526                	mv	a0,s1
    80004ad8:	ffffc097          	auipc	ra,0xffffc
    80004adc:	1d8080e7          	jalr	472(ra) # 80000cb0 <release>
  return i;
    80004ae0:	a039                	j	80004aee <pipewrite+0xe2>
        release(&pi->lock);
    80004ae2:	8526                	mv	a0,s1
    80004ae4:	ffffc097          	auipc	ra,0xffffc
    80004ae8:	1cc080e7          	jalr	460(ra) # 80000cb0 <release>
        return -1;
    80004aec:	5bfd                	li	s7,-1
}
    80004aee:	855e                	mv	a0,s7
    80004af0:	60e6                	ld	ra,88(sp)
    80004af2:	6446                	ld	s0,80(sp)
    80004af4:	64a6                	ld	s1,72(sp)
    80004af6:	6906                	ld	s2,64(sp)
    80004af8:	79e2                	ld	s3,56(sp)
    80004afa:	7a42                	ld	s4,48(sp)
    80004afc:	7aa2                	ld	s5,40(sp)
    80004afe:	7b02                	ld	s6,32(sp)
    80004b00:	6be2                	ld	s7,24(sp)
    80004b02:	6125                	add	sp,sp,96
    80004b04:	8082                	ret

0000000080004b06 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004b06:	715d                	add	sp,sp,-80
    80004b08:	e486                	sd	ra,72(sp)
    80004b0a:	e0a2                	sd	s0,64(sp)
    80004b0c:	fc26                	sd	s1,56(sp)
    80004b0e:	f84a                	sd	s2,48(sp)
    80004b10:	f44e                	sd	s3,40(sp)
    80004b12:	f052                	sd	s4,32(sp)
    80004b14:	ec56                	sd	s5,24(sp)
    80004b16:	e85a                	sd	s6,16(sp)
    80004b18:	0880                	add	s0,sp,80
    80004b1a:	84aa                	mv	s1,a0
    80004b1c:	892e                	mv	s2,a1
    80004b1e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004b20:	ffffd097          	auipc	ra,0xffffd
    80004b24:	f1e080e7          	jalr	-226(ra) # 80001a3e <myproc>
    80004b28:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004b2a:	8526                	mv	a0,s1
    80004b2c:	ffffc097          	auipc	ra,0xffffc
    80004b30:	0d0080e7          	jalr	208(ra) # 80000bfc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b34:	2184a703          	lw	a4,536(s1)
    80004b38:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b3c:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b40:	02f71463          	bne	a4,a5,80004b68 <piperead+0x62>
    80004b44:	2244a783          	lw	a5,548(s1)
    80004b48:	c385                	beqz	a5,80004b68 <piperead+0x62>
    if(pr->killed){
    80004b4a:	030a2783          	lw	a5,48(s4)
    80004b4e:	ebc9                	bnez	a5,80004be0 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b50:	85a6                	mv	a1,s1
    80004b52:	854e                	mv	a0,s3
    80004b54:	ffffd097          	auipc	ra,0xffffd
    80004b58:	700080e7          	jalr	1792(ra) # 80002254 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b5c:	2184a703          	lw	a4,536(s1)
    80004b60:	21c4a783          	lw	a5,540(s1)
    80004b64:	fef700e3          	beq	a4,a5,80004b44 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004b68:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004b6a:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004b6c:	05505463          	blez	s5,80004bb4 <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004b70:	2184a783          	lw	a5,536(s1)
    80004b74:	21c4a703          	lw	a4,540(s1)
    80004b78:	02f70e63          	beq	a4,a5,80004bb4 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004b7c:	0017871b          	addw	a4,a5,1
    80004b80:	20e4ac23          	sw	a4,536(s1)
    80004b84:	1ff7f793          	and	a5,a5,511
    80004b88:	97a6                	add	a5,a5,s1
    80004b8a:	0187c783          	lbu	a5,24(a5)
    80004b8e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004b92:	4685                	li	a3,1
    80004b94:	fbf40613          	add	a2,s0,-65
    80004b98:	85ca                	mv	a1,s2
    80004b9a:	050a3503          	ld	a0,80(s4)
    80004b9e:	ffffd097          	auipc	ra,0xffffd
    80004ba2:	ae4080e7          	jalr	-1308(ra) # 80001682 <copyout>
    80004ba6:	01650763          	beq	a0,s6,80004bb4 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004baa:	2985                	addw	s3,s3,1
    80004bac:	0905                	add	s2,s2,1
    80004bae:	fd3a91e3          	bne	s5,s3,80004b70 <piperead+0x6a>
    80004bb2:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004bb4:	21c48513          	add	a0,s1,540
    80004bb8:	ffffe097          	auipc	ra,0xffffe
    80004bbc:	81c080e7          	jalr	-2020(ra) # 800023d4 <wakeup>
  release(&pi->lock);
    80004bc0:	8526                	mv	a0,s1
    80004bc2:	ffffc097          	auipc	ra,0xffffc
    80004bc6:	0ee080e7          	jalr	238(ra) # 80000cb0 <release>
  return i;
}
    80004bca:	854e                	mv	a0,s3
    80004bcc:	60a6                	ld	ra,72(sp)
    80004bce:	6406                	ld	s0,64(sp)
    80004bd0:	74e2                	ld	s1,56(sp)
    80004bd2:	7942                	ld	s2,48(sp)
    80004bd4:	79a2                	ld	s3,40(sp)
    80004bd6:	7a02                	ld	s4,32(sp)
    80004bd8:	6ae2                	ld	s5,24(sp)
    80004bda:	6b42                	ld	s6,16(sp)
    80004bdc:	6161                	add	sp,sp,80
    80004bde:	8082                	ret
      release(&pi->lock);
    80004be0:	8526                	mv	a0,s1
    80004be2:	ffffc097          	auipc	ra,0xffffc
    80004be6:	0ce080e7          	jalr	206(ra) # 80000cb0 <release>
      return -1;
    80004bea:	59fd                	li	s3,-1
    80004bec:	bff9                	j	80004bca <piperead+0xc4>

0000000080004bee <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004bee:	df010113          	add	sp,sp,-528
    80004bf2:	20113423          	sd	ra,520(sp)
    80004bf6:	20813023          	sd	s0,512(sp)
    80004bfa:	ffa6                	sd	s1,504(sp)
    80004bfc:	fbca                	sd	s2,496(sp)
    80004bfe:	f7ce                	sd	s3,488(sp)
    80004c00:	f3d2                	sd	s4,480(sp)
    80004c02:	efd6                	sd	s5,472(sp)
    80004c04:	ebda                	sd	s6,464(sp)
    80004c06:	e7de                	sd	s7,456(sp)
    80004c08:	e3e2                	sd	s8,448(sp)
    80004c0a:	ff66                	sd	s9,440(sp)
    80004c0c:	fb6a                	sd	s10,432(sp)
    80004c0e:	f76e                	sd	s11,424(sp)
    80004c10:	0c00                	add	s0,sp,528
    80004c12:	892a                	mv	s2,a0
    80004c14:	dea43c23          	sd	a0,-520(s0)
    80004c18:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004c1c:	ffffd097          	auipc	ra,0xffffd
    80004c20:	e22080e7          	jalr	-478(ra) # 80001a3e <myproc>
    80004c24:	84aa                	mv	s1,a0

  begin_op();
    80004c26:	fffff097          	auipc	ra,0xfffff
    80004c2a:	47c080e7          	jalr	1148(ra) # 800040a2 <begin_op>

  if((ip = namei(path)) == 0){
    80004c2e:	854a                	mv	a0,s2
    80004c30:	fffff097          	auipc	ra,0xfffff
    80004c34:	282080e7          	jalr	642(ra) # 80003eb2 <namei>
    80004c38:	c92d                	beqz	a0,80004caa <exec+0xbc>
    80004c3a:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004c3c:	fffff097          	auipc	ra,0xfffff
    80004c40:	ac2080e7          	jalr	-1342(ra) # 800036fe <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004c44:	04000713          	li	a4,64
    80004c48:	4681                	li	a3,0
    80004c4a:	e4840613          	add	a2,s0,-440
    80004c4e:	4581                	li	a1,0
    80004c50:	8552                	mv	a0,s4
    80004c52:	fffff097          	auipc	ra,0xfffff
    80004c56:	d60080e7          	jalr	-672(ra) # 800039b2 <readi>
    80004c5a:	04000793          	li	a5,64
    80004c5e:	00f51a63          	bne	a0,a5,80004c72 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004c62:	e4842703          	lw	a4,-440(s0)
    80004c66:	464c47b7          	lui	a5,0x464c4
    80004c6a:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004c6e:	04f70463          	beq	a4,a5,80004cb6 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004c72:	8552                	mv	a0,s4
    80004c74:	fffff097          	auipc	ra,0xfffff
    80004c78:	cec080e7          	jalr	-788(ra) # 80003960 <iunlockput>
    end_op();
    80004c7c:	fffff097          	auipc	ra,0xfffff
    80004c80:	4a0080e7          	jalr	1184(ra) # 8000411c <end_op>
  }
  return -1;
    80004c84:	557d                	li	a0,-1
}
    80004c86:	20813083          	ld	ra,520(sp)
    80004c8a:	20013403          	ld	s0,512(sp)
    80004c8e:	74fe                	ld	s1,504(sp)
    80004c90:	795e                	ld	s2,496(sp)
    80004c92:	79be                	ld	s3,488(sp)
    80004c94:	7a1e                	ld	s4,480(sp)
    80004c96:	6afe                	ld	s5,472(sp)
    80004c98:	6b5e                	ld	s6,464(sp)
    80004c9a:	6bbe                	ld	s7,456(sp)
    80004c9c:	6c1e                	ld	s8,448(sp)
    80004c9e:	7cfa                	ld	s9,440(sp)
    80004ca0:	7d5a                	ld	s10,432(sp)
    80004ca2:	7dba                	ld	s11,424(sp)
    80004ca4:	21010113          	add	sp,sp,528
    80004ca8:	8082                	ret
    end_op();
    80004caa:	fffff097          	auipc	ra,0xfffff
    80004cae:	472080e7          	jalr	1138(ra) # 8000411c <end_op>
    return -1;
    80004cb2:	557d                	li	a0,-1
    80004cb4:	bfc9                	j	80004c86 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004cb6:	8526                	mv	a0,s1
    80004cb8:	ffffd097          	auipc	ra,0xffffd
    80004cbc:	e4a080e7          	jalr	-438(ra) # 80001b02 <proc_pagetable>
    80004cc0:	8b2a                	mv	s6,a0
    80004cc2:	d945                	beqz	a0,80004c72 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004cc4:	e6842d03          	lw	s10,-408(s0)
    80004cc8:	e8045783          	lhu	a5,-384(s0)
    80004ccc:	cfe5                	beqz	a5,80004dc4 <exec+0x1d6>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004cce:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004cd0:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004cd2:	6c85                	lui	s9,0x1
    80004cd4:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004cd8:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004cdc:	6a85                	lui	s5,0x1
    80004cde:	a0b5                	j	80004d4a <exec+0x15c>
      panic("loadseg: address should exist");
    80004ce0:	00004517          	auipc	a0,0x4
    80004ce4:	97050513          	add	a0,a0,-1680 # 80008650 <syscalls+0x290>
    80004ce8:	ffffc097          	auipc	ra,0xffffc
    80004cec:	85a080e7          	jalr	-1958(ra) # 80000542 <panic>
    if(sz - i < PGSIZE)
    80004cf0:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004cf2:	8726                	mv	a4,s1
    80004cf4:	012c06bb          	addw	a3,s8,s2
    80004cf8:	4581                	li	a1,0
    80004cfa:	8552                	mv	a0,s4
    80004cfc:	fffff097          	auipc	ra,0xfffff
    80004d00:	cb6080e7          	jalr	-842(ra) # 800039b2 <readi>
    80004d04:	2501                	sext.w	a0,a0
    80004d06:	24a49063          	bne	s1,a0,80004f46 <exec+0x358>
  for(i = 0; i < sz; i += PGSIZE){
    80004d0a:	012a893b          	addw	s2,s5,s2
    80004d0e:	03397563          	bgeu	s2,s3,80004d38 <exec+0x14a>
    pa = walkaddr(pagetable, va + i);
    80004d12:	02091593          	sll	a1,s2,0x20
    80004d16:	9181                	srl	a1,a1,0x20
    80004d18:	95de                	add	a1,a1,s7
    80004d1a:	855a                	mv	a0,s6
    80004d1c:	ffffc097          	auipc	ra,0xffffc
    80004d20:	368080e7          	jalr	872(ra) # 80001084 <walkaddr>
    80004d24:	862a                	mv	a2,a0
    if(pa == 0)
    80004d26:	dd4d                	beqz	a0,80004ce0 <exec+0xf2>
    if(sz - i < PGSIZE)
    80004d28:	412984bb          	subw	s1,s3,s2
    80004d2c:	0004879b          	sext.w	a5,s1
    80004d30:	fcfcf0e3          	bgeu	s9,a5,80004cf0 <exec+0x102>
    80004d34:	84d6                	mv	s1,s5
    80004d36:	bf6d                	j	80004cf0 <exec+0x102>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004d38:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d3c:	2d85                	addw	s11,s11,1
    80004d3e:	038d0d1b          	addw	s10,s10,56
    80004d42:	e8045783          	lhu	a5,-384(s0)
    80004d46:	08fdd063          	bge	s11,a5,80004dc6 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004d4a:	2d01                	sext.w	s10,s10
    80004d4c:	03800713          	li	a4,56
    80004d50:	86ea                	mv	a3,s10
    80004d52:	e1040613          	add	a2,s0,-496
    80004d56:	4581                	li	a1,0
    80004d58:	8552                	mv	a0,s4
    80004d5a:	fffff097          	auipc	ra,0xfffff
    80004d5e:	c58080e7          	jalr	-936(ra) # 800039b2 <readi>
    80004d62:	03800793          	li	a5,56
    80004d66:	1cf51e63          	bne	a0,a5,80004f42 <exec+0x354>
    if(ph.type != ELF_PROG_LOAD)
    80004d6a:	e1042783          	lw	a5,-496(s0)
    80004d6e:	4705                	li	a4,1
    80004d70:	fce796e3          	bne	a5,a4,80004d3c <exec+0x14e>
    if(ph.memsz < ph.filesz)
    80004d74:	e3843603          	ld	a2,-456(s0)
    80004d78:	e3043783          	ld	a5,-464(s0)
    80004d7c:	1ef66063          	bltu	a2,a5,80004f5c <exec+0x36e>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004d80:	e2043783          	ld	a5,-480(s0)
    80004d84:	963e                	add	a2,a2,a5
    80004d86:	1cf66e63          	bltu	a2,a5,80004f62 <exec+0x374>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004d8a:	85a6                	mv	a1,s1
    80004d8c:	855a                	mv	a0,s6
    80004d8e:	ffffc097          	auipc	ra,0xffffc
    80004d92:	6bc080e7          	jalr	1724(ra) # 8000144a <uvmalloc>
    80004d96:	e0a43423          	sd	a0,-504(s0)
    80004d9a:	1c050763          	beqz	a0,80004f68 <exec+0x37a>
    if(ph.vaddr % PGSIZE != 0)
    80004d9e:	e2043b83          	ld	s7,-480(s0)
    80004da2:	df043783          	ld	a5,-528(s0)
    80004da6:	00fbf7b3          	and	a5,s7,a5
    80004daa:	18079e63          	bnez	a5,80004f46 <exec+0x358>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004dae:	e1842c03          	lw	s8,-488(s0)
    80004db2:	e3042983          	lw	s3,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004db6:	00098463          	beqz	s3,80004dbe <exec+0x1d0>
    80004dba:	4901                	li	s2,0
    80004dbc:	bf99                	j	80004d12 <exec+0x124>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004dbe:	e0843483          	ld	s1,-504(s0)
    80004dc2:	bfad                	j	80004d3c <exec+0x14e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004dc4:	4481                	li	s1,0
  iunlockput(ip);
    80004dc6:	8552                	mv	a0,s4
    80004dc8:	fffff097          	auipc	ra,0xfffff
    80004dcc:	b98080e7          	jalr	-1128(ra) # 80003960 <iunlockput>
  end_op();
    80004dd0:	fffff097          	auipc	ra,0xfffff
    80004dd4:	34c080e7          	jalr	844(ra) # 8000411c <end_op>
  p = myproc();
    80004dd8:	ffffd097          	auipc	ra,0xffffd
    80004ddc:	c66080e7          	jalr	-922(ra) # 80001a3e <myproc>
    80004de0:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004de2:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004de6:	6985                	lui	s3,0x1
    80004de8:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004dea:	99a6                	add	s3,s3,s1
    80004dec:	77fd                	lui	a5,0xfffff
    80004dee:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004df2:	6609                	lui	a2,0x2
    80004df4:	964e                	add	a2,a2,s3
    80004df6:	85ce                	mv	a1,s3
    80004df8:	855a                	mv	a0,s6
    80004dfa:	ffffc097          	auipc	ra,0xffffc
    80004dfe:	650080e7          	jalr	1616(ra) # 8000144a <uvmalloc>
    80004e02:	892a                	mv	s2,a0
    80004e04:	e0a43423          	sd	a0,-504(s0)
    80004e08:	e509                	bnez	a0,80004e12 <exec+0x224>
  if(pagetable)
    80004e0a:	e1343423          	sd	s3,-504(s0)
    80004e0e:	4a01                	li	s4,0
    80004e10:	aa1d                	j	80004f46 <exec+0x358>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004e12:	75f9                	lui	a1,0xffffe
    80004e14:	95aa                	add	a1,a1,a0
    80004e16:	855a                	mv	a0,s6
    80004e18:	ffffd097          	auipc	ra,0xffffd
    80004e1c:	838080e7          	jalr	-1992(ra) # 80001650 <uvmclear>
  stackbase = sp - PGSIZE;
    80004e20:	7bfd                	lui	s7,0xfffff
    80004e22:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004e24:	e0043783          	ld	a5,-512(s0)
    80004e28:	6388                	ld	a0,0(a5)
    80004e2a:	c52d                	beqz	a0,80004e94 <exec+0x2a6>
    80004e2c:	e8840993          	add	s3,s0,-376
    80004e30:	f8840c13          	add	s8,s0,-120
    80004e34:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004e36:	ffffc097          	auipc	ra,0xffffc
    80004e3a:	044080e7          	jalr	68(ra) # 80000e7a <strlen>
    80004e3e:	0015079b          	addw	a5,a0,1
    80004e42:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004e46:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80004e4a:	13796263          	bltu	s2,s7,80004f6e <exec+0x380>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004e4e:	e0043d03          	ld	s10,-512(s0)
    80004e52:	000d3a03          	ld	s4,0(s10)
    80004e56:	8552                	mv	a0,s4
    80004e58:	ffffc097          	auipc	ra,0xffffc
    80004e5c:	022080e7          	jalr	34(ra) # 80000e7a <strlen>
    80004e60:	0015069b          	addw	a3,a0,1
    80004e64:	8652                	mv	a2,s4
    80004e66:	85ca                	mv	a1,s2
    80004e68:	855a                	mv	a0,s6
    80004e6a:	ffffd097          	auipc	ra,0xffffd
    80004e6e:	818080e7          	jalr	-2024(ra) # 80001682 <copyout>
    80004e72:	10054063          	bltz	a0,80004f72 <exec+0x384>
    ustack[argc] = sp;
    80004e76:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004e7a:	0485                	add	s1,s1,1
    80004e7c:	008d0793          	add	a5,s10,8
    80004e80:	e0f43023          	sd	a5,-512(s0)
    80004e84:	008d3503          	ld	a0,8(s10)
    80004e88:	c909                	beqz	a0,80004e9a <exec+0x2ac>
    if(argc >= MAXARG)
    80004e8a:	09a1                	add	s3,s3,8
    80004e8c:	fb8995e3          	bne	s3,s8,80004e36 <exec+0x248>
  ip = 0;
    80004e90:	4a01                	li	s4,0
    80004e92:	a855                	j	80004f46 <exec+0x358>
  sp = sz;
    80004e94:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004e98:	4481                	li	s1,0
  ustack[argc] = 0;
    80004e9a:	00349793          	sll	a5,s1,0x3
    80004e9e:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd8f90>
    80004ea2:	97a2                	add	a5,a5,s0
    80004ea4:	ee07bc23          	sd	zero,-264(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004ea8:	00148693          	add	a3,s1,1
    80004eac:	068e                	sll	a3,a3,0x3
    80004eae:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004eb2:	ff097913          	and	s2,s2,-16
  sz = sz1;
    80004eb6:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004eba:	f57968e3          	bltu	s2,s7,80004e0a <exec+0x21c>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004ebe:	e8840613          	add	a2,s0,-376
    80004ec2:	85ca                	mv	a1,s2
    80004ec4:	855a                	mv	a0,s6
    80004ec6:	ffffc097          	auipc	ra,0xffffc
    80004eca:	7bc080e7          	jalr	1980(ra) # 80001682 <copyout>
    80004ece:	0a054463          	bltz	a0,80004f76 <exec+0x388>
  p->trapframe->a1 = sp;
    80004ed2:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004ed6:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004eda:	df843783          	ld	a5,-520(s0)
    80004ede:	0007c703          	lbu	a4,0(a5)
    80004ee2:	cf11                	beqz	a4,80004efe <exec+0x310>
    80004ee4:	0785                	add	a5,a5,1
    if(*s == '/')
    80004ee6:	02f00693          	li	a3,47
    80004eea:	a039                	j	80004ef8 <exec+0x30a>
      last = s+1;
    80004eec:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004ef0:	0785                	add	a5,a5,1
    80004ef2:	fff7c703          	lbu	a4,-1(a5)
    80004ef6:	c701                	beqz	a4,80004efe <exec+0x310>
    if(*s == '/')
    80004ef8:	fed71ce3          	bne	a4,a3,80004ef0 <exec+0x302>
    80004efc:	bfc5                	j	80004eec <exec+0x2fe>
  safestrcpy(p->name, last, sizeof(p->name));
    80004efe:	4641                	li	a2,16
    80004f00:	df843583          	ld	a1,-520(s0)
    80004f04:	158a8513          	add	a0,s5,344
    80004f08:	ffffc097          	auipc	ra,0xffffc
    80004f0c:	f40080e7          	jalr	-192(ra) # 80000e48 <safestrcpy>
  oldpagetable = p->pagetable;
    80004f10:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004f14:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004f18:	e0843783          	ld	a5,-504(s0)
    80004f1c:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004f20:	058ab783          	ld	a5,88(s5)
    80004f24:	e6043703          	ld	a4,-416(s0)
    80004f28:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004f2a:	058ab783          	ld	a5,88(s5)
    80004f2e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004f32:	85e6                	mv	a1,s9
    80004f34:	ffffd097          	auipc	ra,0xffffd
    80004f38:	c6a080e7          	jalr	-918(ra) # 80001b9e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004f3c:	0004851b          	sext.w	a0,s1
    80004f40:	b399                	j	80004c86 <exec+0x98>
    80004f42:	e0943423          	sd	s1,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004f46:	e0843583          	ld	a1,-504(s0)
    80004f4a:	855a                	mv	a0,s6
    80004f4c:	ffffd097          	auipc	ra,0xffffd
    80004f50:	c52080e7          	jalr	-942(ra) # 80001b9e <proc_freepagetable>
  return -1;
    80004f54:	557d                	li	a0,-1
  if(ip){
    80004f56:	d20a08e3          	beqz	s4,80004c86 <exec+0x98>
    80004f5a:	bb21                	j	80004c72 <exec+0x84>
    80004f5c:	e0943423          	sd	s1,-504(s0)
    80004f60:	b7dd                	j	80004f46 <exec+0x358>
    80004f62:	e0943423          	sd	s1,-504(s0)
    80004f66:	b7c5                	j	80004f46 <exec+0x358>
    80004f68:	e0943423          	sd	s1,-504(s0)
    80004f6c:	bfe9                	j	80004f46 <exec+0x358>
  ip = 0;
    80004f6e:	4a01                	li	s4,0
    80004f70:	bfd9                	j	80004f46 <exec+0x358>
    80004f72:	4a01                	li	s4,0
  if(pagetable)
    80004f74:	bfc9                	j	80004f46 <exec+0x358>
  sz = sz1;
    80004f76:	e0843983          	ld	s3,-504(s0)
    80004f7a:	bd41                	j	80004e0a <exec+0x21c>

0000000080004f7c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004f7c:	7179                	add	sp,sp,-48
    80004f7e:	f406                	sd	ra,40(sp)
    80004f80:	f022                	sd	s0,32(sp)
    80004f82:	ec26                	sd	s1,24(sp)
    80004f84:	e84a                	sd	s2,16(sp)
    80004f86:	1800                	add	s0,sp,48
    80004f88:	892e                	mv	s2,a1
    80004f8a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004f8c:	fdc40593          	add	a1,s0,-36
    80004f90:	ffffe097          	auipc	ra,0xffffe
    80004f94:	bda080e7          	jalr	-1062(ra) # 80002b6a <argint>
    80004f98:	04054063          	bltz	a0,80004fd8 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004f9c:	fdc42703          	lw	a4,-36(s0)
    80004fa0:	47bd                	li	a5,15
    80004fa2:	02e7ed63          	bltu	a5,a4,80004fdc <argfd+0x60>
    80004fa6:	ffffd097          	auipc	ra,0xffffd
    80004faa:	a98080e7          	jalr	-1384(ra) # 80001a3e <myproc>
    80004fae:	fdc42703          	lw	a4,-36(s0)
    80004fb2:	01a70793          	add	a5,a4,26
    80004fb6:	078e                	sll	a5,a5,0x3
    80004fb8:	953e                	add	a0,a0,a5
    80004fba:	611c                	ld	a5,0(a0)
    80004fbc:	c395                	beqz	a5,80004fe0 <argfd+0x64>
    return -1;
  if(pfd)
    80004fbe:	00090463          	beqz	s2,80004fc6 <argfd+0x4a>
    *pfd = fd;
    80004fc2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004fc6:	4501                	li	a0,0
  if(pf)
    80004fc8:	c091                	beqz	s1,80004fcc <argfd+0x50>
    *pf = f;
    80004fca:	e09c                	sd	a5,0(s1)
}
    80004fcc:	70a2                	ld	ra,40(sp)
    80004fce:	7402                	ld	s0,32(sp)
    80004fd0:	64e2                	ld	s1,24(sp)
    80004fd2:	6942                	ld	s2,16(sp)
    80004fd4:	6145                	add	sp,sp,48
    80004fd6:	8082                	ret
    return -1;
    80004fd8:	557d                	li	a0,-1
    80004fda:	bfcd                	j	80004fcc <argfd+0x50>
    return -1;
    80004fdc:	557d                	li	a0,-1
    80004fde:	b7fd                	j	80004fcc <argfd+0x50>
    80004fe0:	557d                	li	a0,-1
    80004fe2:	b7ed                	j	80004fcc <argfd+0x50>

0000000080004fe4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004fe4:	1101                	add	sp,sp,-32
    80004fe6:	ec06                	sd	ra,24(sp)
    80004fe8:	e822                	sd	s0,16(sp)
    80004fea:	e426                	sd	s1,8(sp)
    80004fec:	1000                	add	s0,sp,32
    80004fee:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004ff0:	ffffd097          	auipc	ra,0xffffd
    80004ff4:	a4e080e7          	jalr	-1458(ra) # 80001a3e <myproc>
    80004ff8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004ffa:	0d050793          	add	a5,a0,208
    80004ffe:	4501                	li	a0,0
    80005000:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005002:	6398                	ld	a4,0(a5)
    80005004:	cb19                	beqz	a4,8000501a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005006:	2505                	addw	a0,a0,1
    80005008:	07a1                	add	a5,a5,8
    8000500a:	fed51ce3          	bne	a0,a3,80005002 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000500e:	557d                	li	a0,-1
}
    80005010:	60e2                	ld	ra,24(sp)
    80005012:	6442                	ld	s0,16(sp)
    80005014:	64a2                	ld	s1,8(sp)
    80005016:	6105                	add	sp,sp,32
    80005018:	8082                	ret
      p->ofile[fd] = f;
    8000501a:	01a50793          	add	a5,a0,26
    8000501e:	078e                	sll	a5,a5,0x3
    80005020:	963e                	add	a2,a2,a5
    80005022:	e204                	sd	s1,0(a2)
      return fd;
    80005024:	b7f5                	j	80005010 <fdalloc+0x2c>

0000000080005026 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005026:	715d                	add	sp,sp,-80
    80005028:	e486                	sd	ra,72(sp)
    8000502a:	e0a2                	sd	s0,64(sp)
    8000502c:	fc26                	sd	s1,56(sp)
    8000502e:	f84a                	sd	s2,48(sp)
    80005030:	f44e                	sd	s3,40(sp)
    80005032:	f052                	sd	s4,32(sp)
    80005034:	ec56                	sd	s5,24(sp)
    80005036:	0880                	add	s0,sp,80
    80005038:	8aae                	mv	s5,a1
    8000503a:	8a32                	mv	s4,a2
    8000503c:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000503e:	fb040593          	add	a1,s0,-80
    80005042:	fffff097          	auipc	ra,0xfffff
    80005046:	e8e080e7          	jalr	-370(ra) # 80003ed0 <nameiparent>
    8000504a:	892a                	mv	s2,a0
    8000504c:	12050c63          	beqz	a0,80005184 <create+0x15e>
    return 0;

  ilock(dp);
    80005050:	ffffe097          	auipc	ra,0xffffe
    80005054:	6ae080e7          	jalr	1710(ra) # 800036fe <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005058:	4601                	li	a2,0
    8000505a:	fb040593          	add	a1,s0,-80
    8000505e:	854a                	mv	a0,s2
    80005060:	fffff097          	auipc	ra,0xfffff
    80005064:	b80080e7          	jalr	-1152(ra) # 80003be0 <dirlookup>
    80005068:	84aa                	mv	s1,a0
    8000506a:	c539                	beqz	a0,800050b8 <create+0x92>
    iunlockput(dp);
    8000506c:	854a                	mv	a0,s2
    8000506e:	fffff097          	auipc	ra,0xfffff
    80005072:	8f2080e7          	jalr	-1806(ra) # 80003960 <iunlockput>
    ilock(ip);
    80005076:	8526                	mv	a0,s1
    80005078:	ffffe097          	auipc	ra,0xffffe
    8000507c:	686080e7          	jalr	1670(ra) # 800036fe <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005080:	4789                	li	a5,2
    80005082:	02fa9463          	bne	s5,a5,800050aa <create+0x84>
    80005086:	0444d783          	lhu	a5,68(s1)
    8000508a:	37f9                	addw	a5,a5,-2
    8000508c:	17c2                	sll	a5,a5,0x30
    8000508e:	93c1                	srl	a5,a5,0x30
    80005090:	4705                	li	a4,1
    80005092:	00f76c63          	bltu	a4,a5,800050aa <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80005096:	8526                	mv	a0,s1
    80005098:	60a6                	ld	ra,72(sp)
    8000509a:	6406                	ld	s0,64(sp)
    8000509c:	74e2                	ld	s1,56(sp)
    8000509e:	7942                	ld	s2,48(sp)
    800050a0:	79a2                	ld	s3,40(sp)
    800050a2:	7a02                	ld	s4,32(sp)
    800050a4:	6ae2                	ld	s5,24(sp)
    800050a6:	6161                	add	sp,sp,80
    800050a8:	8082                	ret
    iunlockput(ip);
    800050aa:	8526                	mv	a0,s1
    800050ac:	fffff097          	auipc	ra,0xfffff
    800050b0:	8b4080e7          	jalr	-1868(ra) # 80003960 <iunlockput>
    return 0;
    800050b4:	4481                	li	s1,0
    800050b6:	b7c5                	j	80005096 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    800050b8:	85d6                	mv	a1,s5
    800050ba:	00092503          	lw	a0,0(s2)
    800050be:	ffffe097          	auipc	ra,0xffffe
    800050c2:	4ac080e7          	jalr	1196(ra) # 8000356a <ialloc>
    800050c6:	84aa                	mv	s1,a0
    800050c8:	c139                	beqz	a0,8000510e <create+0xe8>
  ilock(ip);
    800050ca:	ffffe097          	auipc	ra,0xffffe
    800050ce:	634080e7          	jalr	1588(ra) # 800036fe <ilock>
  ip->major = major;
    800050d2:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    800050d6:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    800050da:	4985                	li	s3,1
    800050dc:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    800050e0:	8526                	mv	a0,s1
    800050e2:	ffffe097          	auipc	ra,0xffffe
    800050e6:	550080e7          	jalr	1360(ra) # 80003632 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800050ea:	033a8a63          	beq	s5,s3,8000511e <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    800050ee:	40d0                	lw	a2,4(s1)
    800050f0:	fb040593          	add	a1,s0,-80
    800050f4:	854a                	mv	a0,s2
    800050f6:	fffff097          	auipc	ra,0xfffff
    800050fa:	cfa080e7          	jalr	-774(ra) # 80003df0 <dirlink>
    800050fe:	06054b63          	bltz	a0,80005174 <create+0x14e>
  iunlockput(dp);
    80005102:	854a                	mv	a0,s2
    80005104:	fffff097          	auipc	ra,0xfffff
    80005108:	85c080e7          	jalr	-1956(ra) # 80003960 <iunlockput>
  return ip;
    8000510c:	b769                	j	80005096 <create+0x70>
    panic("create: ialloc");
    8000510e:	00003517          	auipc	a0,0x3
    80005112:	56250513          	add	a0,a0,1378 # 80008670 <syscalls+0x2b0>
    80005116:	ffffb097          	auipc	ra,0xffffb
    8000511a:	42c080e7          	jalr	1068(ra) # 80000542 <panic>
    dp->nlink++;  // for ".."
    8000511e:	04a95783          	lhu	a5,74(s2)
    80005122:	2785                	addw	a5,a5,1
    80005124:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005128:	854a                	mv	a0,s2
    8000512a:	ffffe097          	auipc	ra,0xffffe
    8000512e:	508080e7          	jalr	1288(ra) # 80003632 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005132:	40d0                	lw	a2,4(s1)
    80005134:	00003597          	auipc	a1,0x3
    80005138:	54c58593          	add	a1,a1,1356 # 80008680 <syscalls+0x2c0>
    8000513c:	8526                	mv	a0,s1
    8000513e:	fffff097          	auipc	ra,0xfffff
    80005142:	cb2080e7          	jalr	-846(ra) # 80003df0 <dirlink>
    80005146:	00054f63          	bltz	a0,80005164 <create+0x13e>
    8000514a:	00492603          	lw	a2,4(s2)
    8000514e:	00003597          	auipc	a1,0x3
    80005152:	53a58593          	add	a1,a1,1338 # 80008688 <syscalls+0x2c8>
    80005156:	8526                	mv	a0,s1
    80005158:	fffff097          	auipc	ra,0xfffff
    8000515c:	c98080e7          	jalr	-872(ra) # 80003df0 <dirlink>
    80005160:	f80557e3          	bgez	a0,800050ee <create+0xc8>
      panic("create dots");
    80005164:	00003517          	auipc	a0,0x3
    80005168:	52c50513          	add	a0,a0,1324 # 80008690 <syscalls+0x2d0>
    8000516c:	ffffb097          	auipc	ra,0xffffb
    80005170:	3d6080e7          	jalr	982(ra) # 80000542 <panic>
    panic("create: dirlink");
    80005174:	00003517          	auipc	a0,0x3
    80005178:	52c50513          	add	a0,a0,1324 # 800086a0 <syscalls+0x2e0>
    8000517c:	ffffb097          	auipc	ra,0xffffb
    80005180:	3c6080e7          	jalr	966(ra) # 80000542 <panic>
    return 0;
    80005184:	84aa                	mv	s1,a0
    80005186:	bf01                	j	80005096 <create+0x70>

0000000080005188 <sys_dup>:
{
    80005188:	7179                	add	sp,sp,-48
    8000518a:	f406                	sd	ra,40(sp)
    8000518c:	f022                	sd	s0,32(sp)
    8000518e:	ec26                	sd	s1,24(sp)
    80005190:	e84a                	sd	s2,16(sp)
    80005192:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005194:	fd840613          	add	a2,s0,-40
    80005198:	4581                	li	a1,0
    8000519a:	4501                	li	a0,0
    8000519c:	00000097          	auipc	ra,0x0
    800051a0:	de0080e7          	jalr	-544(ra) # 80004f7c <argfd>
    return -1;
    800051a4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800051a6:	02054363          	bltz	a0,800051cc <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800051aa:	fd843903          	ld	s2,-40(s0)
    800051ae:	854a                	mv	a0,s2
    800051b0:	00000097          	auipc	ra,0x0
    800051b4:	e34080e7          	jalr	-460(ra) # 80004fe4 <fdalloc>
    800051b8:	84aa                	mv	s1,a0
    return -1;
    800051ba:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800051bc:	00054863          	bltz	a0,800051cc <sys_dup+0x44>
  filedup(f);
    800051c0:	854a                	mv	a0,s2
    800051c2:	fffff097          	auipc	ra,0xfffff
    800051c6:	358080e7          	jalr	856(ra) # 8000451a <filedup>
  return fd;
    800051ca:	87a6                	mv	a5,s1
}
    800051cc:	853e                	mv	a0,a5
    800051ce:	70a2                	ld	ra,40(sp)
    800051d0:	7402                	ld	s0,32(sp)
    800051d2:	64e2                	ld	s1,24(sp)
    800051d4:	6942                	ld	s2,16(sp)
    800051d6:	6145                	add	sp,sp,48
    800051d8:	8082                	ret

00000000800051da <sys_read>:
{
    800051da:	7179                	add	sp,sp,-48
    800051dc:	f406                	sd	ra,40(sp)
    800051de:	f022                	sd	s0,32(sp)
    800051e0:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051e2:	fe840613          	add	a2,s0,-24
    800051e6:	4581                	li	a1,0
    800051e8:	4501                	li	a0,0
    800051ea:	00000097          	auipc	ra,0x0
    800051ee:	d92080e7          	jalr	-622(ra) # 80004f7c <argfd>
    return -1;
    800051f2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051f4:	04054163          	bltz	a0,80005236 <sys_read+0x5c>
    800051f8:	fe440593          	add	a1,s0,-28
    800051fc:	4509                	li	a0,2
    800051fe:	ffffe097          	auipc	ra,0xffffe
    80005202:	96c080e7          	jalr	-1684(ra) # 80002b6a <argint>
    return -1;
    80005206:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005208:	02054763          	bltz	a0,80005236 <sys_read+0x5c>
    8000520c:	fd840593          	add	a1,s0,-40
    80005210:	4505                	li	a0,1
    80005212:	ffffe097          	auipc	ra,0xffffe
    80005216:	97a080e7          	jalr	-1670(ra) # 80002b8c <argaddr>
    return -1;
    8000521a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000521c:	00054d63          	bltz	a0,80005236 <sys_read+0x5c>
  return fileread(f, p, n);
    80005220:	fe442603          	lw	a2,-28(s0)
    80005224:	fd843583          	ld	a1,-40(s0)
    80005228:	fe843503          	ld	a0,-24(s0)
    8000522c:	fffff097          	auipc	ra,0xfffff
    80005230:	47a080e7          	jalr	1146(ra) # 800046a6 <fileread>
    80005234:	87aa                	mv	a5,a0
}
    80005236:	853e                	mv	a0,a5
    80005238:	70a2                	ld	ra,40(sp)
    8000523a:	7402                	ld	s0,32(sp)
    8000523c:	6145                	add	sp,sp,48
    8000523e:	8082                	ret

0000000080005240 <sys_write>:
{
    80005240:	7179                	add	sp,sp,-48
    80005242:	f406                	sd	ra,40(sp)
    80005244:	f022                	sd	s0,32(sp)
    80005246:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005248:	fe840613          	add	a2,s0,-24
    8000524c:	4581                	li	a1,0
    8000524e:	4501                	li	a0,0
    80005250:	00000097          	auipc	ra,0x0
    80005254:	d2c080e7          	jalr	-724(ra) # 80004f7c <argfd>
    return -1;
    80005258:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000525a:	04054163          	bltz	a0,8000529c <sys_write+0x5c>
    8000525e:	fe440593          	add	a1,s0,-28
    80005262:	4509                	li	a0,2
    80005264:	ffffe097          	auipc	ra,0xffffe
    80005268:	906080e7          	jalr	-1786(ra) # 80002b6a <argint>
    return -1;
    8000526c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000526e:	02054763          	bltz	a0,8000529c <sys_write+0x5c>
    80005272:	fd840593          	add	a1,s0,-40
    80005276:	4505                	li	a0,1
    80005278:	ffffe097          	auipc	ra,0xffffe
    8000527c:	914080e7          	jalr	-1772(ra) # 80002b8c <argaddr>
    return -1;
    80005280:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005282:	00054d63          	bltz	a0,8000529c <sys_write+0x5c>
  return filewrite(f, p, n);
    80005286:	fe442603          	lw	a2,-28(s0)
    8000528a:	fd843583          	ld	a1,-40(s0)
    8000528e:	fe843503          	ld	a0,-24(s0)
    80005292:	fffff097          	auipc	ra,0xfffff
    80005296:	4d6080e7          	jalr	1238(ra) # 80004768 <filewrite>
    8000529a:	87aa                	mv	a5,a0
}
    8000529c:	853e                	mv	a0,a5
    8000529e:	70a2                	ld	ra,40(sp)
    800052a0:	7402                	ld	s0,32(sp)
    800052a2:	6145                	add	sp,sp,48
    800052a4:	8082                	ret

00000000800052a6 <sys_close>:
{
    800052a6:	1101                	add	sp,sp,-32
    800052a8:	ec06                	sd	ra,24(sp)
    800052aa:	e822                	sd	s0,16(sp)
    800052ac:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800052ae:	fe040613          	add	a2,s0,-32
    800052b2:	fec40593          	add	a1,s0,-20
    800052b6:	4501                	li	a0,0
    800052b8:	00000097          	auipc	ra,0x0
    800052bc:	cc4080e7          	jalr	-828(ra) # 80004f7c <argfd>
    return -1;
    800052c0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800052c2:	02054463          	bltz	a0,800052ea <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800052c6:	ffffc097          	auipc	ra,0xffffc
    800052ca:	778080e7          	jalr	1912(ra) # 80001a3e <myproc>
    800052ce:	fec42783          	lw	a5,-20(s0)
    800052d2:	07e9                	add	a5,a5,26
    800052d4:	078e                	sll	a5,a5,0x3
    800052d6:	953e                	add	a0,a0,a5
    800052d8:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800052dc:	fe043503          	ld	a0,-32(s0)
    800052e0:	fffff097          	auipc	ra,0xfffff
    800052e4:	28c080e7          	jalr	652(ra) # 8000456c <fileclose>
  return 0;
    800052e8:	4781                	li	a5,0
}
    800052ea:	853e                	mv	a0,a5
    800052ec:	60e2                	ld	ra,24(sp)
    800052ee:	6442                	ld	s0,16(sp)
    800052f0:	6105                	add	sp,sp,32
    800052f2:	8082                	ret

00000000800052f4 <sys_fstat>:
{
    800052f4:	1101                	add	sp,sp,-32
    800052f6:	ec06                	sd	ra,24(sp)
    800052f8:	e822                	sd	s0,16(sp)
    800052fa:	1000                	add	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800052fc:	fe840613          	add	a2,s0,-24
    80005300:	4581                	li	a1,0
    80005302:	4501                	li	a0,0
    80005304:	00000097          	auipc	ra,0x0
    80005308:	c78080e7          	jalr	-904(ra) # 80004f7c <argfd>
    return -1;
    8000530c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000530e:	02054563          	bltz	a0,80005338 <sys_fstat+0x44>
    80005312:	fe040593          	add	a1,s0,-32
    80005316:	4505                	li	a0,1
    80005318:	ffffe097          	auipc	ra,0xffffe
    8000531c:	874080e7          	jalr	-1932(ra) # 80002b8c <argaddr>
    return -1;
    80005320:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005322:	00054b63          	bltz	a0,80005338 <sys_fstat+0x44>
  return filestat(f, st);
    80005326:	fe043583          	ld	a1,-32(s0)
    8000532a:	fe843503          	ld	a0,-24(s0)
    8000532e:	fffff097          	auipc	ra,0xfffff
    80005332:	306080e7          	jalr	774(ra) # 80004634 <filestat>
    80005336:	87aa                	mv	a5,a0
}
    80005338:	853e                	mv	a0,a5
    8000533a:	60e2                	ld	ra,24(sp)
    8000533c:	6442                	ld	s0,16(sp)
    8000533e:	6105                	add	sp,sp,32
    80005340:	8082                	ret

0000000080005342 <sys_link>:
{
    80005342:	7169                	add	sp,sp,-304
    80005344:	f606                	sd	ra,296(sp)
    80005346:	f222                	sd	s0,288(sp)
    80005348:	ee26                	sd	s1,280(sp)
    8000534a:	ea4a                	sd	s2,272(sp)
    8000534c:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000534e:	08000613          	li	a2,128
    80005352:	ed040593          	add	a1,s0,-304
    80005356:	4501                	li	a0,0
    80005358:	ffffe097          	auipc	ra,0xffffe
    8000535c:	856080e7          	jalr	-1962(ra) # 80002bae <argstr>
    return -1;
    80005360:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005362:	10054e63          	bltz	a0,8000547e <sys_link+0x13c>
    80005366:	08000613          	li	a2,128
    8000536a:	f5040593          	add	a1,s0,-176
    8000536e:	4505                	li	a0,1
    80005370:	ffffe097          	auipc	ra,0xffffe
    80005374:	83e080e7          	jalr	-1986(ra) # 80002bae <argstr>
    return -1;
    80005378:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000537a:	10054263          	bltz	a0,8000547e <sys_link+0x13c>
  begin_op();
    8000537e:	fffff097          	auipc	ra,0xfffff
    80005382:	d24080e7          	jalr	-732(ra) # 800040a2 <begin_op>
  if((ip = namei(old)) == 0){
    80005386:	ed040513          	add	a0,s0,-304
    8000538a:	fffff097          	auipc	ra,0xfffff
    8000538e:	b28080e7          	jalr	-1240(ra) # 80003eb2 <namei>
    80005392:	84aa                	mv	s1,a0
    80005394:	c551                	beqz	a0,80005420 <sys_link+0xde>
  ilock(ip);
    80005396:	ffffe097          	auipc	ra,0xffffe
    8000539a:	368080e7          	jalr	872(ra) # 800036fe <ilock>
  if(ip->type == T_DIR){
    8000539e:	04449703          	lh	a4,68(s1)
    800053a2:	4785                	li	a5,1
    800053a4:	08f70463          	beq	a4,a5,8000542c <sys_link+0xea>
  ip->nlink++;
    800053a8:	04a4d783          	lhu	a5,74(s1)
    800053ac:	2785                	addw	a5,a5,1
    800053ae:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800053b2:	8526                	mv	a0,s1
    800053b4:	ffffe097          	auipc	ra,0xffffe
    800053b8:	27e080e7          	jalr	638(ra) # 80003632 <iupdate>
  iunlock(ip);
    800053bc:	8526                	mv	a0,s1
    800053be:	ffffe097          	auipc	ra,0xffffe
    800053c2:	402080e7          	jalr	1026(ra) # 800037c0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800053c6:	fd040593          	add	a1,s0,-48
    800053ca:	f5040513          	add	a0,s0,-176
    800053ce:	fffff097          	auipc	ra,0xfffff
    800053d2:	b02080e7          	jalr	-1278(ra) # 80003ed0 <nameiparent>
    800053d6:	892a                	mv	s2,a0
    800053d8:	c935                	beqz	a0,8000544c <sys_link+0x10a>
  ilock(dp);
    800053da:	ffffe097          	auipc	ra,0xffffe
    800053de:	324080e7          	jalr	804(ra) # 800036fe <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800053e2:	00092703          	lw	a4,0(s2)
    800053e6:	409c                	lw	a5,0(s1)
    800053e8:	04f71d63          	bne	a4,a5,80005442 <sys_link+0x100>
    800053ec:	40d0                	lw	a2,4(s1)
    800053ee:	fd040593          	add	a1,s0,-48
    800053f2:	854a                	mv	a0,s2
    800053f4:	fffff097          	auipc	ra,0xfffff
    800053f8:	9fc080e7          	jalr	-1540(ra) # 80003df0 <dirlink>
    800053fc:	04054363          	bltz	a0,80005442 <sys_link+0x100>
  iunlockput(dp);
    80005400:	854a                	mv	a0,s2
    80005402:	ffffe097          	auipc	ra,0xffffe
    80005406:	55e080e7          	jalr	1374(ra) # 80003960 <iunlockput>
  iput(ip);
    8000540a:	8526                	mv	a0,s1
    8000540c:	ffffe097          	auipc	ra,0xffffe
    80005410:	4ac080e7          	jalr	1196(ra) # 800038b8 <iput>
  end_op();
    80005414:	fffff097          	auipc	ra,0xfffff
    80005418:	d08080e7          	jalr	-760(ra) # 8000411c <end_op>
  return 0;
    8000541c:	4781                	li	a5,0
    8000541e:	a085                	j	8000547e <sys_link+0x13c>
    end_op();
    80005420:	fffff097          	auipc	ra,0xfffff
    80005424:	cfc080e7          	jalr	-772(ra) # 8000411c <end_op>
    return -1;
    80005428:	57fd                	li	a5,-1
    8000542a:	a891                	j	8000547e <sys_link+0x13c>
    iunlockput(ip);
    8000542c:	8526                	mv	a0,s1
    8000542e:	ffffe097          	auipc	ra,0xffffe
    80005432:	532080e7          	jalr	1330(ra) # 80003960 <iunlockput>
    end_op();
    80005436:	fffff097          	auipc	ra,0xfffff
    8000543a:	ce6080e7          	jalr	-794(ra) # 8000411c <end_op>
    return -1;
    8000543e:	57fd                	li	a5,-1
    80005440:	a83d                	j	8000547e <sys_link+0x13c>
    iunlockput(dp);
    80005442:	854a                	mv	a0,s2
    80005444:	ffffe097          	auipc	ra,0xffffe
    80005448:	51c080e7          	jalr	1308(ra) # 80003960 <iunlockput>
  ilock(ip);
    8000544c:	8526                	mv	a0,s1
    8000544e:	ffffe097          	auipc	ra,0xffffe
    80005452:	2b0080e7          	jalr	688(ra) # 800036fe <ilock>
  ip->nlink--;
    80005456:	04a4d783          	lhu	a5,74(s1)
    8000545a:	37fd                	addw	a5,a5,-1
    8000545c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005460:	8526                	mv	a0,s1
    80005462:	ffffe097          	auipc	ra,0xffffe
    80005466:	1d0080e7          	jalr	464(ra) # 80003632 <iupdate>
  iunlockput(ip);
    8000546a:	8526                	mv	a0,s1
    8000546c:	ffffe097          	auipc	ra,0xffffe
    80005470:	4f4080e7          	jalr	1268(ra) # 80003960 <iunlockput>
  end_op();
    80005474:	fffff097          	auipc	ra,0xfffff
    80005478:	ca8080e7          	jalr	-856(ra) # 8000411c <end_op>
  return -1;
    8000547c:	57fd                	li	a5,-1
}
    8000547e:	853e                	mv	a0,a5
    80005480:	70b2                	ld	ra,296(sp)
    80005482:	7412                	ld	s0,288(sp)
    80005484:	64f2                	ld	s1,280(sp)
    80005486:	6952                	ld	s2,272(sp)
    80005488:	6155                	add	sp,sp,304
    8000548a:	8082                	ret

000000008000548c <sys_unlink>:
{
    8000548c:	7151                	add	sp,sp,-240
    8000548e:	f586                	sd	ra,232(sp)
    80005490:	f1a2                	sd	s0,224(sp)
    80005492:	eda6                	sd	s1,216(sp)
    80005494:	e9ca                	sd	s2,208(sp)
    80005496:	e5ce                	sd	s3,200(sp)
    80005498:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000549a:	08000613          	li	a2,128
    8000549e:	f3040593          	add	a1,s0,-208
    800054a2:	4501                	li	a0,0
    800054a4:	ffffd097          	auipc	ra,0xffffd
    800054a8:	70a080e7          	jalr	1802(ra) # 80002bae <argstr>
    800054ac:	18054163          	bltz	a0,8000562e <sys_unlink+0x1a2>
  begin_op();
    800054b0:	fffff097          	auipc	ra,0xfffff
    800054b4:	bf2080e7          	jalr	-1038(ra) # 800040a2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800054b8:	fb040593          	add	a1,s0,-80
    800054bc:	f3040513          	add	a0,s0,-208
    800054c0:	fffff097          	auipc	ra,0xfffff
    800054c4:	a10080e7          	jalr	-1520(ra) # 80003ed0 <nameiparent>
    800054c8:	84aa                	mv	s1,a0
    800054ca:	c979                	beqz	a0,800055a0 <sys_unlink+0x114>
  ilock(dp);
    800054cc:	ffffe097          	auipc	ra,0xffffe
    800054d0:	232080e7          	jalr	562(ra) # 800036fe <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800054d4:	00003597          	auipc	a1,0x3
    800054d8:	1ac58593          	add	a1,a1,428 # 80008680 <syscalls+0x2c0>
    800054dc:	fb040513          	add	a0,s0,-80
    800054e0:	ffffe097          	auipc	ra,0xffffe
    800054e4:	6e6080e7          	jalr	1766(ra) # 80003bc6 <namecmp>
    800054e8:	14050a63          	beqz	a0,8000563c <sys_unlink+0x1b0>
    800054ec:	00003597          	auipc	a1,0x3
    800054f0:	19c58593          	add	a1,a1,412 # 80008688 <syscalls+0x2c8>
    800054f4:	fb040513          	add	a0,s0,-80
    800054f8:	ffffe097          	auipc	ra,0xffffe
    800054fc:	6ce080e7          	jalr	1742(ra) # 80003bc6 <namecmp>
    80005500:	12050e63          	beqz	a0,8000563c <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005504:	f2c40613          	add	a2,s0,-212
    80005508:	fb040593          	add	a1,s0,-80
    8000550c:	8526                	mv	a0,s1
    8000550e:	ffffe097          	auipc	ra,0xffffe
    80005512:	6d2080e7          	jalr	1746(ra) # 80003be0 <dirlookup>
    80005516:	892a                	mv	s2,a0
    80005518:	12050263          	beqz	a0,8000563c <sys_unlink+0x1b0>
  ilock(ip);
    8000551c:	ffffe097          	auipc	ra,0xffffe
    80005520:	1e2080e7          	jalr	482(ra) # 800036fe <ilock>
  if(ip->nlink < 1)
    80005524:	04a91783          	lh	a5,74(s2)
    80005528:	08f05263          	blez	a5,800055ac <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000552c:	04491703          	lh	a4,68(s2)
    80005530:	4785                	li	a5,1
    80005532:	08f70563          	beq	a4,a5,800055bc <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005536:	4641                	li	a2,16
    80005538:	4581                	li	a1,0
    8000553a:	fc040513          	add	a0,s0,-64
    8000553e:	ffffb097          	auipc	ra,0xffffb
    80005542:	7ba080e7          	jalr	1978(ra) # 80000cf8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005546:	4741                	li	a4,16
    80005548:	f2c42683          	lw	a3,-212(s0)
    8000554c:	fc040613          	add	a2,s0,-64
    80005550:	4581                	li	a1,0
    80005552:	8526                	mv	a0,s1
    80005554:	ffffe097          	auipc	ra,0xffffe
    80005558:	556080e7          	jalr	1366(ra) # 80003aaa <writei>
    8000555c:	47c1                	li	a5,16
    8000555e:	0af51563          	bne	a0,a5,80005608 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005562:	04491703          	lh	a4,68(s2)
    80005566:	4785                	li	a5,1
    80005568:	0af70863          	beq	a4,a5,80005618 <sys_unlink+0x18c>
  iunlockput(dp);
    8000556c:	8526                	mv	a0,s1
    8000556e:	ffffe097          	auipc	ra,0xffffe
    80005572:	3f2080e7          	jalr	1010(ra) # 80003960 <iunlockput>
  ip->nlink--;
    80005576:	04a95783          	lhu	a5,74(s2)
    8000557a:	37fd                	addw	a5,a5,-1
    8000557c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005580:	854a                	mv	a0,s2
    80005582:	ffffe097          	auipc	ra,0xffffe
    80005586:	0b0080e7          	jalr	176(ra) # 80003632 <iupdate>
  iunlockput(ip);
    8000558a:	854a                	mv	a0,s2
    8000558c:	ffffe097          	auipc	ra,0xffffe
    80005590:	3d4080e7          	jalr	980(ra) # 80003960 <iunlockput>
  end_op();
    80005594:	fffff097          	auipc	ra,0xfffff
    80005598:	b88080e7          	jalr	-1144(ra) # 8000411c <end_op>
  return 0;
    8000559c:	4501                	li	a0,0
    8000559e:	a84d                	j	80005650 <sys_unlink+0x1c4>
    end_op();
    800055a0:	fffff097          	auipc	ra,0xfffff
    800055a4:	b7c080e7          	jalr	-1156(ra) # 8000411c <end_op>
    return -1;
    800055a8:	557d                	li	a0,-1
    800055aa:	a05d                	j	80005650 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800055ac:	00003517          	auipc	a0,0x3
    800055b0:	10450513          	add	a0,a0,260 # 800086b0 <syscalls+0x2f0>
    800055b4:	ffffb097          	auipc	ra,0xffffb
    800055b8:	f8e080e7          	jalr	-114(ra) # 80000542 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800055bc:	04c92703          	lw	a4,76(s2)
    800055c0:	02000793          	li	a5,32
    800055c4:	f6e7f9e3          	bgeu	a5,a4,80005536 <sys_unlink+0xaa>
    800055c8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800055cc:	4741                	li	a4,16
    800055ce:	86ce                	mv	a3,s3
    800055d0:	f1840613          	add	a2,s0,-232
    800055d4:	4581                	li	a1,0
    800055d6:	854a                	mv	a0,s2
    800055d8:	ffffe097          	auipc	ra,0xffffe
    800055dc:	3da080e7          	jalr	986(ra) # 800039b2 <readi>
    800055e0:	47c1                	li	a5,16
    800055e2:	00f51b63          	bne	a0,a5,800055f8 <sys_unlink+0x16c>
    if(de.inum != 0)
    800055e6:	f1845783          	lhu	a5,-232(s0)
    800055ea:	e7a1                	bnez	a5,80005632 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800055ec:	29c1                	addw	s3,s3,16
    800055ee:	04c92783          	lw	a5,76(s2)
    800055f2:	fcf9ede3          	bltu	s3,a5,800055cc <sys_unlink+0x140>
    800055f6:	b781                	j	80005536 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800055f8:	00003517          	auipc	a0,0x3
    800055fc:	0d050513          	add	a0,a0,208 # 800086c8 <syscalls+0x308>
    80005600:	ffffb097          	auipc	ra,0xffffb
    80005604:	f42080e7          	jalr	-190(ra) # 80000542 <panic>
    panic("unlink: writei");
    80005608:	00003517          	auipc	a0,0x3
    8000560c:	0d850513          	add	a0,a0,216 # 800086e0 <syscalls+0x320>
    80005610:	ffffb097          	auipc	ra,0xffffb
    80005614:	f32080e7          	jalr	-206(ra) # 80000542 <panic>
    dp->nlink--;
    80005618:	04a4d783          	lhu	a5,74(s1)
    8000561c:	37fd                	addw	a5,a5,-1
    8000561e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005622:	8526                	mv	a0,s1
    80005624:	ffffe097          	auipc	ra,0xffffe
    80005628:	00e080e7          	jalr	14(ra) # 80003632 <iupdate>
    8000562c:	b781                	j	8000556c <sys_unlink+0xe0>
    return -1;
    8000562e:	557d                	li	a0,-1
    80005630:	a005                	j	80005650 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005632:	854a                	mv	a0,s2
    80005634:	ffffe097          	auipc	ra,0xffffe
    80005638:	32c080e7          	jalr	812(ra) # 80003960 <iunlockput>
  iunlockput(dp);
    8000563c:	8526                	mv	a0,s1
    8000563e:	ffffe097          	auipc	ra,0xffffe
    80005642:	322080e7          	jalr	802(ra) # 80003960 <iunlockput>
  end_op();
    80005646:	fffff097          	auipc	ra,0xfffff
    8000564a:	ad6080e7          	jalr	-1322(ra) # 8000411c <end_op>
  return -1;
    8000564e:	557d                	li	a0,-1
}
    80005650:	70ae                	ld	ra,232(sp)
    80005652:	740e                	ld	s0,224(sp)
    80005654:	64ee                	ld	s1,216(sp)
    80005656:	694e                	ld	s2,208(sp)
    80005658:	69ae                	ld	s3,200(sp)
    8000565a:	616d                	add	sp,sp,240
    8000565c:	8082                	ret

000000008000565e <sys_open>:

uint64
sys_open(void)
{
    8000565e:	7131                	add	sp,sp,-192
    80005660:	fd06                	sd	ra,184(sp)
    80005662:	f922                	sd	s0,176(sp)
    80005664:	f526                	sd	s1,168(sp)
    80005666:	f14a                	sd	s2,160(sp)
    80005668:	ed4e                	sd	s3,152(sp)
    8000566a:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000566c:	08000613          	li	a2,128
    80005670:	f5040593          	add	a1,s0,-176
    80005674:	4501                	li	a0,0
    80005676:	ffffd097          	auipc	ra,0xffffd
    8000567a:	538080e7          	jalr	1336(ra) # 80002bae <argstr>
    return -1;
    8000567e:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005680:	0c054063          	bltz	a0,80005740 <sys_open+0xe2>
    80005684:	f4c40593          	add	a1,s0,-180
    80005688:	4505                	li	a0,1
    8000568a:	ffffd097          	auipc	ra,0xffffd
    8000568e:	4e0080e7          	jalr	1248(ra) # 80002b6a <argint>
    80005692:	0a054763          	bltz	a0,80005740 <sys_open+0xe2>

  begin_op();
    80005696:	fffff097          	auipc	ra,0xfffff
    8000569a:	a0c080e7          	jalr	-1524(ra) # 800040a2 <begin_op>

  if(omode & O_CREATE){
    8000569e:	f4c42783          	lw	a5,-180(s0)
    800056a2:	2007f793          	and	a5,a5,512
    800056a6:	cbd5                	beqz	a5,8000575a <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    800056a8:	4681                	li	a3,0
    800056aa:	4601                	li	a2,0
    800056ac:	4589                	li	a1,2
    800056ae:	f5040513          	add	a0,s0,-176
    800056b2:	00000097          	auipc	ra,0x0
    800056b6:	974080e7          	jalr	-1676(ra) # 80005026 <create>
    800056ba:	892a                	mv	s2,a0
    if(ip == 0){
    800056bc:	c951                	beqz	a0,80005750 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800056be:	04491703          	lh	a4,68(s2)
    800056c2:	478d                	li	a5,3
    800056c4:	00f71763          	bne	a4,a5,800056d2 <sys_open+0x74>
    800056c8:	04695703          	lhu	a4,70(s2)
    800056cc:	47a5                	li	a5,9
    800056ce:	0ce7eb63          	bltu	a5,a4,800057a4 <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800056d2:	fffff097          	auipc	ra,0xfffff
    800056d6:	dde080e7          	jalr	-546(ra) # 800044b0 <filealloc>
    800056da:	89aa                	mv	s3,a0
    800056dc:	c565                	beqz	a0,800057c4 <sys_open+0x166>
    800056de:	00000097          	auipc	ra,0x0
    800056e2:	906080e7          	jalr	-1786(ra) # 80004fe4 <fdalloc>
    800056e6:	84aa                	mv	s1,a0
    800056e8:	0c054963          	bltz	a0,800057ba <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800056ec:	04491703          	lh	a4,68(s2)
    800056f0:	478d                	li	a5,3
    800056f2:	0ef70463          	beq	a4,a5,800057da <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800056f6:	4789                	li	a5,2
    800056f8:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    800056fc:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005700:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005704:	f4c42783          	lw	a5,-180(s0)
    80005708:	0017c713          	xor	a4,a5,1
    8000570c:	8b05                	and	a4,a4,1
    8000570e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005712:	0037f713          	and	a4,a5,3
    80005716:	00e03733          	snez	a4,a4
    8000571a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000571e:	4007f793          	and	a5,a5,1024
    80005722:	c791                	beqz	a5,8000572e <sys_open+0xd0>
    80005724:	04491703          	lh	a4,68(s2)
    80005728:	4789                	li	a5,2
    8000572a:	0af70f63          	beq	a4,a5,800057e8 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    8000572e:	854a                	mv	a0,s2
    80005730:	ffffe097          	auipc	ra,0xffffe
    80005734:	090080e7          	jalr	144(ra) # 800037c0 <iunlock>
  end_op();
    80005738:	fffff097          	auipc	ra,0xfffff
    8000573c:	9e4080e7          	jalr	-1564(ra) # 8000411c <end_op>

  return fd;
}
    80005740:	8526                	mv	a0,s1
    80005742:	70ea                	ld	ra,184(sp)
    80005744:	744a                	ld	s0,176(sp)
    80005746:	74aa                	ld	s1,168(sp)
    80005748:	790a                	ld	s2,160(sp)
    8000574a:	69ea                	ld	s3,152(sp)
    8000574c:	6129                	add	sp,sp,192
    8000574e:	8082                	ret
      end_op();
    80005750:	fffff097          	auipc	ra,0xfffff
    80005754:	9cc080e7          	jalr	-1588(ra) # 8000411c <end_op>
      return -1;
    80005758:	b7e5                	j	80005740 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    8000575a:	f5040513          	add	a0,s0,-176
    8000575e:	ffffe097          	auipc	ra,0xffffe
    80005762:	754080e7          	jalr	1876(ra) # 80003eb2 <namei>
    80005766:	892a                	mv	s2,a0
    80005768:	c905                	beqz	a0,80005798 <sys_open+0x13a>
    ilock(ip);
    8000576a:	ffffe097          	auipc	ra,0xffffe
    8000576e:	f94080e7          	jalr	-108(ra) # 800036fe <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005772:	04491703          	lh	a4,68(s2)
    80005776:	4785                	li	a5,1
    80005778:	f4f713e3          	bne	a4,a5,800056be <sys_open+0x60>
    8000577c:	f4c42783          	lw	a5,-180(s0)
    80005780:	dba9                	beqz	a5,800056d2 <sys_open+0x74>
      iunlockput(ip);
    80005782:	854a                	mv	a0,s2
    80005784:	ffffe097          	auipc	ra,0xffffe
    80005788:	1dc080e7          	jalr	476(ra) # 80003960 <iunlockput>
      end_op();
    8000578c:	fffff097          	auipc	ra,0xfffff
    80005790:	990080e7          	jalr	-1648(ra) # 8000411c <end_op>
      return -1;
    80005794:	54fd                	li	s1,-1
    80005796:	b76d                	j	80005740 <sys_open+0xe2>
      end_op();
    80005798:	fffff097          	auipc	ra,0xfffff
    8000579c:	984080e7          	jalr	-1660(ra) # 8000411c <end_op>
      return -1;
    800057a0:	54fd                	li	s1,-1
    800057a2:	bf79                	j	80005740 <sys_open+0xe2>
    iunlockput(ip);
    800057a4:	854a                	mv	a0,s2
    800057a6:	ffffe097          	auipc	ra,0xffffe
    800057aa:	1ba080e7          	jalr	442(ra) # 80003960 <iunlockput>
    end_op();
    800057ae:	fffff097          	auipc	ra,0xfffff
    800057b2:	96e080e7          	jalr	-1682(ra) # 8000411c <end_op>
    return -1;
    800057b6:	54fd                	li	s1,-1
    800057b8:	b761                	j	80005740 <sys_open+0xe2>
      fileclose(f);
    800057ba:	854e                	mv	a0,s3
    800057bc:	fffff097          	auipc	ra,0xfffff
    800057c0:	db0080e7          	jalr	-592(ra) # 8000456c <fileclose>
    iunlockput(ip);
    800057c4:	854a                	mv	a0,s2
    800057c6:	ffffe097          	auipc	ra,0xffffe
    800057ca:	19a080e7          	jalr	410(ra) # 80003960 <iunlockput>
    end_op();
    800057ce:	fffff097          	auipc	ra,0xfffff
    800057d2:	94e080e7          	jalr	-1714(ra) # 8000411c <end_op>
    return -1;
    800057d6:	54fd                	li	s1,-1
    800057d8:	b7a5                	j	80005740 <sys_open+0xe2>
    f->type = FD_DEVICE;
    800057da:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    800057de:	04691783          	lh	a5,70(s2)
    800057e2:	02f99223          	sh	a5,36(s3)
    800057e6:	bf29                	j	80005700 <sys_open+0xa2>
    itrunc(ip);
    800057e8:	854a                	mv	a0,s2
    800057ea:	ffffe097          	auipc	ra,0xffffe
    800057ee:	022080e7          	jalr	34(ra) # 8000380c <itrunc>
    800057f2:	bf35                	j	8000572e <sys_open+0xd0>

00000000800057f4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800057f4:	7175                	add	sp,sp,-144
    800057f6:	e506                	sd	ra,136(sp)
    800057f8:	e122                	sd	s0,128(sp)
    800057fa:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800057fc:	fffff097          	auipc	ra,0xfffff
    80005800:	8a6080e7          	jalr	-1882(ra) # 800040a2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005804:	08000613          	li	a2,128
    80005808:	f7040593          	add	a1,s0,-144
    8000580c:	4501                	li	a0,0
    8000580e:	ffffd097          	auipc	ra,0xffffd
    80005812:	3a0080e7          	jalr	928(ra) # 80002bae <argstr>
    80005816:	02054963          	bltz	a0,80005848 <sys_mkdir+0x54>
    8000581a:	4681                	li	a3,0
    8000581c:	4601                	li	a2,0
    8000581e:	4585                	li	a1,1
    80005820:	f7040513          	add	a0,s0,-144
    80005824:	00000097          	auipc	ra,0x0
    80005828:	802080e7          	jalr	-2046(ra) # 80005026 <create>
    8000582c:	cd11                	beqz	a0,80005848 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000582e:	ffffe097          	auipc	ra,0xffffe
    80005832:	132080e7          	jalr	306(ra) # 80003960 <iunlockput>
  end_op();
    80005836:	fffff097          	auipc	ra,0xfffff
    8000583a:	8e6080e7          	jalr	-1818(ra) # 8000411c <end_op>
  return 0;
    8000583e:	4501                	li	a0,0
}
    80005840:	60aa                	ld	ra,136(sp)
    80005842:	640a                	ld	s0,128(sp)
    80005844:	6149                	add	sp,sp,144
    80005846:	8082                	ret
    end_op();
    80005848:	fffff097          	auipc	ra,0xfffff
    8000584c:	8d4080e7          	jalr	-1836(ra) # 8000411c <end_op>
    return -1;
    80005850:	557d                	li	a0,-1
    80005852:	b7fd                	j	80005840 <sys_mkdir+0x4c>

0000000080005854 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005854:	7135                	add	sp,sp,-160
    80005856:	ed06                	sd	ra,152(sp)
    80005858:	e922                	sd	s0,144(sp)
    8000585a:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000585c:	fffff097          	auipc	ra,0xfffff
    80005860:	846080e7          	jalr	-1978(ra) # 800040a2 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005864:	08000613          	li	a2,128
    80005868:	f7040593          	add	a1,s0,-144
    8000586c:	4501                	li	a0,0
    8000586e:	ffffd097          	auipc	ra,0xffffd
    80005872:	340080e7          	jalr	832(ra) # 80002bae <argstr>
    80005876:	04054a63          	bltz	a0,800058ca <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    8000587a:	f6c40593          	add	a1,s0,-148
    8000587e:	4505                	li	a0,1
    80005880:	ffffd097          	auipc	ra,0xffffd
    80005884:	2ea080e7          	jalr	746(ra) # 80002b6a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005888:	04054163          	bltz	a0,800058ca <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    8000588c:	f6840593          	add	a1,s0,-152
    80005890:	4509                	li	a0,2
    80005892:	ffffd097          	auipc	ra,0xffffd
    80005896:	2d8080e7          	jalr	728(ra) # 80002b6a <argint>
     argint(1, &major) < 0 ||
    8000589a:	02054863          	bltz	a0,800058ca <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000589e:	f6841683          	lh	a3,-152(s0)
    800058a2:	f6c41603          	lh	a2,-148(s0)
    800058a6:	458d                	li	a1,3
    800058a8:	f7040513          	add	a0,s0,-144
    800058ac:	fffff097          	auipc	ra,0xfffff
    800058b0:	77a080e7          	jalr	1914(ra) # 80005026 <create>
     argint(2, &minor) < 0 ||
    800058b4:	c919                	beqz	a0,800058ca <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800058b6:	ffffe097          	auipc	ra,0xffffe
    800058ba:	0aa080e7          	jalr	170(ra) # 80003960 <iunlockput>
  end_op();
    800058be:	fffff097          	auipc	ra,0xfffff
    800058c2:	85e080e7          	jalr	-1954(ra) # 8000411c <end_op>
  return 0;
    800058c6:	4501                	li	a0,0
    800058c8:	a031                	j	800058d4 <sys_mknod+0x80>
    end_op();
    800058ca:	fffff097          	auipc	ra,0xfffff
    800058ce:	852080e7          	jalr	-1966(ra) # 8000411c <end_op>
    return -1;
    800058d2:	557d                	li	a0,-1
}
    800058d4:	60ea                	ld	ra,152(sp)
    800058d6:	644a                	ld	s0,144(sp)
    800058d8:	610d                	add	sp,sp,160
    800058da:	8082                	ret

00000000800058dc <sys_chdir>:

uint64
sys_chdir(void)
{
    800058dc:	7135                	add	sp,sp,-160
    800058de:	ed06                	sd	ra,152(sp)
    800058e0:	e922                	sd	s0,144(sp)
    800058e2:	e526                	sd	s1,136(sp)
    800058e4:	e14a                	sd	s2,128(sp)
    800058e6:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800058e8:	ffffc097          	auipc	ra,0xffffc
    800058ec:	156080e7          	jalr	342(ra) # 80001a3e <myproc>
    800058f0:	892a                	mv	s2,a0
  
  begin_op();
    800058f2:	ffffe097          	auipc	ra,0xffffe
    800058f6:	7b0080e7          	jalr	1968(ra) # 800040a2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800058fa:	08000613          	li	a2,128
    800058fe:	f6040593          	add	a1,s0,-160
    80005902:	4501                	li	a0,0
    80005904:	ffffd097          	auipc	ra,0xffffd
    80005908:	2aa080e7          	jalr	682(ra) # 80002bae <argstr>
    8000590c:	04054b63          	bltz	a0,80005962 <sys_chdir+0x86>
    80005910:	f6040513          	add	a0,s0,-160
    80005914:	ffffe097          	auipc	ra,0xffffe
    80005918:	59e080e7          	jalr	1438(ra) # 80003eb2 <namei>
    8000591c:	84aa                	mv	s1,a0
    8000591e:	c131                	beqz	a0,80005962 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005920:	ffffe097          	auipc	ra,0xffffe
    80005924:	dde080e7          	jalr	-546(ra) # 800036fe <ilock>
  if(ip->type != T_DIR){
    80005928:	04449703          	lh	a4,68(s1)
    8000592c:	4785                	li	a5,1
    8000592e:	04f71063          	bne	a4,a5,8000596e <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005932:	8526                	mv	a0,s1
    80005934:	ffffe097          	auipc	ra,0xffffe
    80005938:	e8c080e7          	jalr	-372(ra) # 800037c0 <iunlock>
  iput(p->cwd);
    8000593c:	15093503          	ld	a0,336(s2)
    80005940:	ffffe097          	auipc	ra,0xffffe
    80005944:	f78080e7          	jalr	-136(ra) # 800038b8 <iput>
  end_op();
    80005948:	ffffe097          	auipc	ra,0xffffe
    8000594c:	7d4080e7          	jalr	2004(ra) # 8000411c <end_op>
  p->cwd = ip;
    80005950:	14993823          	sd	s1,336(s2)
  return 0;
    80005954:	4501                	li	a0,0
}
    80005956:	60ea                	ld	ra,152(sp)
    80005958:	644a                	ld	s0,144(sp)
    8000595a:	64aa                	ld	s1,136(sp)
    8000595c:	690a                	ld	s2,128(sp)
    8000595e:	610d                	add	sp,sp,160
    80005960:	8082                	ret
    end_op();
    80005962:	ffffe097          	auipc	ra,0xffffe
    80005966:	7ba080e7          	jalr	1978(ra) # 8000411c <end_op>
    return -1;
    8000596a:	557d                	li	a0,-1
    8000596c:	b7ed                	j	80005956 <sys_chdir+0x7a>
    iunlockput(ip);
    8000596e:	8526                	mv	a0,s1
    80005970:	ffffe097          	auipc	ra,0xffffe
    80005974:	ff0080e7          	jalr	-16(ra) # 80003960 <iunlockput>
    end_op();
    80005978:	ffffe097          	auipc	ra,0xffffe
    8000597c:	7a4080e7          	jalr	1956(ra) # 8000411c <end_op>
    return -1;
    80005980:	557d                	li	a0,-1
    80005982:	bfd1                	j	80005956 <sys_chdir+0x7a>

0000000080005984 <sys_exec>:

uint64
sys_exec(void)
{
    80005984:	7121                	add	sp,sp,-448
    80005986:	ff06                	sd	ra,440(sp)
    80005988:	fb22                	sd	s0,432(sp)
    8000598a:	f726                	sd	s1,424(sp)
    8000598c:	f34a                	sd	s2,416(sp)
    8000598e:	ef4e                	sd	s3,408(sp)
    80005990:	eb52                	sd	s4,400(sp)
    80005992:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005994:	08000613          	li	a2,128
    80005998:	f5040593          	add	a1,s0,-176
    8000599c:	4501                	li	a0,0
    8000599e:	ffffd097          	auipc	ra,0xffffd
    800059a2:	210080e7          	jalr	528(ra) # 80002bae <argstr>
    return -1;
    800059a6:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800059a8:	0c054a63          	bltz	a0,80005a7c <sys_exec+0xf8>
    800059ac:	e4840593          	add	a1,s0,-440
    800059b0:	4505                	li	a0,1
    800059b2:	ffffd097          	auipc	ra,0xffffd
    800059b6:	1da080e7          	jalr	474(ra) # 80002b8c <argaddr>
    800059ba:	0c054163          	bltz	a0,80005a7c <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    800059be:	10000613          	li	a2,256
    800059c2:	4581                	li	a1,0
    800059c4:	e5040513          	add	a0,s0,-432
    800059c8:	ffffb097          	auipc	ra,0xffffb
    800059cc:	330080e7          	jalr	816(ra) # 80000cf8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800059d0:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800059d4:	89a6                	mv	s3,s1
    800059d6:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800059d8:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800059dc:	00391513          	sll	a0,s2,0x3
    800059e0:	e4040593          	add	a1,s0,-448
    800059e4:	e4843783          	ld	a5,-440(s0)
    800059e8:	953e                	add	a0,a0,a5
    800059ea:	ffffd097          	auipc	ra,0xffffd
    800059ee:	0e6080e7          	jalr	230(ra) # 80002ad0 <fetchaddr>
    800059f2:	02054a63          	bltz	a0,80005a26 <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    800059f6:	e4043783          	ld	a5,-448(s0)
    800059fa:	c3b9                	beqz	a5,80005a40 <sys_exec+0xbc>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800059fc:	ffffb097          	auipc	ra,0xffffb
    80005a00:	110080e7          	jalr	272(ra) # 80000b0c <kalloc>
    80005a04:	85aa                	mv	a1,a0
    80005a06:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005a0a:	cd11                	beqz	a0,80005a26 <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005a0c:	6605                	lui	a2,0x1
    80005a0e:	e4043503          	ld	a0,-448(s0)
    80005a12:	ffffd097          	auipc	ra,0xffffd
    80005a16:	110080e7          	jalr	272(ra) # 80002b22 <fetchstr>
    80005a1a:	00054663          	bltz	a0,80005a26 <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80005a1e:	0905                	add	s2,s2,1
    80005a20:	09a1                	add	s3,s3,8
    80005a22:	fb491de3          	bne	s2,s4,800059dc <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a26:	f5040913          	add	s2,s0,-176
    80005a2a:	6088                	ld	a0,0(s1)
    80005a2c:	c539                	beqz	a0,80005a7a <sys_exec+0xf6>
    kfree(argv[i]);
    80005a2e:	ffffb097          	auipc	ra,0xffffb
    80005a32:	fe0080e7          	jalr	-32(ra) # 80000a0e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a36:	04a1                	add	s1,s1,8
    80005a38:	ff2499e3          	bne	s1,s2,80005a2a <sys_exec+0xa6>
  return -1;
    80005a3c:	597d                	li	s2,-1
    80005a3e:	a83d                	j	80005a7c <sys_exec+0xf8>
      argv[i] = 0;
    80005a40:	0009079b          	sext.w	a5,s2
    80005a44:	078e                	sll	a5,a5,0x3
    80005a46:	fd078793          	add	a5,a5,-48
    80005a4a:	97a2                	add	a5,a5,s0
    80005a4c:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005a50:	e5040593          	add	a1,s0,-432
    80005a54:	f5040513          	add	a0,s0,-176
    80005a58:	fffff097          	auipc	ra,0xfffff
    80005a5c:	196080e7          	jalr	406(ra) # 80004bee <exec>
    80005a60:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a62:	f5040993          	add	s3,s0,-176
    80005a66:	6088                	ld	a0,0(s1)
    80005a68:	c911                	beqz	a0,80005a7c <sys_exec+0xf8>
    kfree(argv[i]);
    80005a6a:	ffffb097          	auipc	ra,0xffffb
    80005a6e:	fa4080e7          	jalr	-92(ra) # 80000a0e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a72:	04a1                	add	s1,s1,8
    80005a74:	ff3499e3          	bne	s1,s3,80005a66 <sys_exec+0xe2>
    80005a78:	a011                	j	80005a7c <sys_exec+0xf8>
  return -1;
    80005a7a:	597d                	li	s2,-1
}
    80005a7c:	854a                	mv	a0,s2
    80005a7e:	70fa                	ld	ra,440(sp)
    80005a80:	745a                	ld	s0,432(sp)
    80005a82:	74ba                	ld	s1,424(sp)
    80005a84:	791a                	ld	s2,416(sp)
    80005a86:	69fa                	ld	s3,408(sp)
    80005a88:	6a5a                	ld	s4,400(sp)
    80005a8a:	6139                	add	sp,sp,448
    80005a8c:	8082                	ret

0000000080005a8e <sys_pipe>:

uint64
sys_pipe(void)
{
    80005a8e:	7139                	add	sp,sp,-64
    80005a90:	fc06                	sd	ra,56(sp)
    80005a92:	f822                	sd	s0,48(sp)
    80005a94:	f426                	sd	s1,40(sp)
    80005a96:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005a98:	ffffc097          	auipc	ra,0xffffc
    80005a9c:	fa6080e7          	jalr	-90(ra) # 80001a3e <myproc>
    80005aa0:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005aa2:	fd840593          	add	a1,s0,-40
    80005aa6:	4501                	li	a0,0
    80005aa8:	ffffd097          	auipc	ra,0xffffd
    80005aac:	0e4080e7          	jalr	228(ra) # 80002b8c <argaddr>
    return -1;
    80005ab0:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005ab2:	0e054063          	bltz	a0,80005b92 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005ab6:	fc840593          	add	a1,s0,-56
    80005aba:	fd040513          	add	a0,s0,-48
    80005abe:	fffff097          	auipc	ra,0xfffff
    80005ac2:	e04080e7          	jalr	-508(ra) # 800048c2 <pipealloc>
    return -1;
    80005ac6:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005ac8:	0c054563          	bltz	a0,80005b92 <sys_pipe+0x104>
  fd0 = -1;
    80005acc:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005ad0:	fd043503          	ld	a0,-48(s0)
    80005ad4:	fffff097          	auipc	ra,0xfffff
    80005ad8:	510080e7          	jalr	1296(ra) # 80004fe4 <fdalloc>
    80005adc:	fca42223          	sw	a0,-60(s0)
    80005ae0:	08054c63          	bltz	a0,80005b78 <sys_pipe+0xea>
    80005ae4:	fc843503          	ld	a0,-56(s0)
    80005ae8:	fffff097          	auipc	ra,0xfffff
    80005aec:	4fc080e7          	jalr	1276(ra) # 80004fe4 <fdalloc>
    80005af0:	fca42023          	sw	a0,-64(s0)
    80005af4:	06054963          	bltz	a0,80005b66 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005af8:	4691                	li	a3,4
    80005afa:	fc440613          	add	a2,s0,-60
    80005afe:	fd843583          	ld	a1,-40(s0)
    80005b02:	68a8                	ld	a0,80(s1)
    80005b04:	ffffc097          	auipc	ra,0xffffc
    80005b08:	b7e080e7          	jalr	-1154(ra) # 80001682 <copyout>
    80005b0c:	02054063          	bltz	a0,80005b2c <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005b10:	4691                	li	a3,4
    80005b12:	fc040613          	add	a2,s0,-64
    80005b16:	fd843583          	ld	a1,-40(s0)
    80005b1a:	0591                	add	a1,a1,4
    80005b1c:	68a8                	ld	a0,80(s1)
    80005b1e:	ffffc097          	auipc	ra,0xffffc
    80005b22:	b64080e7          	jalr	-1180(ra) # 80001682 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005b26:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005b28:	06055563          	bgez	a0,80005b92 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005b2c:	fc442783          	lw	a5,-60(s0)
    80005b30:	07e9                	add	a5,a5,26
    80005b32:	078e                	sll	a5,a5,0x3
    80005b34:	97a6                	add	a5,a5,s1
    80005b36:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005b3a:	fc042783          	lw	a5,-64(s0)
    80005b3e:	07e9                	add	a5,a5,26
    80005b40:	078e                	sll	a5,a5,0x3
    80005b42:	00f48533          	add	a0,s1,a5
    80005b46:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005b4a:	fd043503          	ld	a0,-48(s0)
    80005b4e:	fffff097          	auipc	ra,0xfffff
    80005b52:	a1e080e7          	jalr	-1506(ra) # 8000456c <fileclose>
    fileclose(wf);
    80005b56:	fc843503          	ld	a0,-56(s0)
    80005b5a:	fffff097          	auipc	ra,0xfffff
    80005b5e:	a12080e7          	jalr	-1518(ra) # 8000456c <fileclose>
    return -1;
    80005b62:	57fd                	li	a5,-1
    80005b64:	a03d                	j	80005b92 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005b66:	fc442783          	lw	a5,-60(s0)
    80005b6a:	0007c763          	bltz	a5,80005b78 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005b6e:	07e9                	add	a5,a5,26
    80005b70:	078e                	sll	a5,a5,0x3
    80005b72:	97a6                	add	a5,a5,s1
    80005b74:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005b78:	fd043503          	ld	a0,-48(s0)
    80005b7c:	fffff097          	auipc	ra,0xfffff
    80005b80:	9f0080e7          	jalr	-1552(ra) # 8000456c <fileclose>
    fileclose(wf);
    80005b84:	fc843503          	ld	a0,-56(s0)
    80005b88:	fffff097          	auipc	ra,0xfffff
    80005b8c:	9e4080e7          	jalr	-1564(ra) # 8000456c <fileclose>
    return -1;
    80005b90:	57fd                	li	a5,-1
}
    80005b92:	853e                	mv	a0,a5
    80005b94:	70e2                	ld	ra,56(sp)
    80005b96:	7442                	ld	s0,48(sp)
    80005b98:	74a2                	ld	s1,40(sp)
    80005b9a:	6121                	add	sp,sp,64
    80005b9c:	8082                	ret
	...

0000000080005ba0 <kernelvec>:
    80005ba0:	7111                	add	sp,sp,-256
    80005ba2:	e006                	sd	ra,0(sp)
    80005ba4:	e40a                	sd	sp,8(sp)
    80005ba6:	e80e                	sd	gp,16(sp)
    80005ba8:	ec12                	sd	tp,24(sp)
    80005baa:	f016                	sd	t0,32(sp)
    80005bac:	f41a                	sd	t1,40(sp)
    80005bae:	f81e                	sd	t2,48(sp)
    80005bb0:	fc22                	sd	s0,56(sp)
    80005bb2:	e0a6                	sd	s1,64(sp)
    80005bb4:	e4aa                	sd	a0,72(sp)
    80005bb6:	e8ae                	sd	a1,80(sp)
    80005bb8:	ecb2                	sd	a2,88(sp)
    80005bba:	f0b6                	sd	a3,96(sp)
    80005bbc:	f4ba                	sd	a4,104(sp)
    80005bbe:	f8be                	sd	a5,112(sp)
    80005bc0:	fcc2                	sd	a6,120(sp)
    80005bc2:	e146                	sd	a7,128(sp)
    80005bc4:	e54a                	sd	s2,136(sp)
    80005bc6:	e94e                	sd	s3,144(sp)
    80005bc8:	ed52                	sd	s4,152(sp)
    80005bca:	f156                	sd	s5,160(sp)
    80005bcc:	f55a                	sd	s6,168(sp)
    80005bce:	f95e                	sd	s7,176(sp)
    80005bd0:	fd62                	sd	s8,184(sp)
    80005bd2:	e1e6                	sd	s9,192(sp)
    80005bd4:	e5ea                	sd	s10,200(sp)
    80005bd6:	e9ee                	sd	s11,208(sp)
    80005bd8:	edf2                	sd	t3,216(sp)
    80005bda:	f1f6                	sd	t4,224(sp)
    80005bdc:	f5fa                	sd	t5,232(sp)
    80005bde:	f9fe                	sd	t6,240(sp)
    80005be0:	dbdfc0ef          	jal	8000299c <kerneltrap>
    80005be4:	6082                	ld	ra,0(sp)
    80005be6:	6122                	ld	sp,8(sp)
    80005be8:	61c2                	ld	gp,16(sp)
    80005bea:	7282                	ld	t0,32(sp)
    80005bec:	7322                	ld	t1,40(sp)
    80005bee:	73c2                	ld	t2,48(sp)
    80005bf0:	7462                	ld	s0,56(sp)
    80005bf2:	6486                	ld	s1,64(sp)
    80005bf4:	6526                	ld	a0,72(sp)
    80005bf6:	65c6                	ld	a1,80(sp)
    80005bf8:	6666                	ld	a2,88(sp)
    80005bfa:	7686                	ld	a3,96(sp)
    80005bfc:	7726                	ld	a4,104(sp)
    80005bfe:	77c6                	ld	a5,112(sp)
    80005c00:	7866                	ld	a6,120(sp)
    80005c02:	688a                	ld	a7,128(sp)
    80005c04:	692a                	ld	s2,136(sp)
    80005c06:	69ca                	ld	s3,144(sp)
    80005c08:	6a6a                	ld	s4,152(sp)
    80005c0a:	7a8a                	ld	s5,160(sp)
    80005c0c:	7b2a                	ld	s6,168(sp)
    80005c0e:	7bca                	ld	s7,176(sp)
    80005c10:	7c6a                	ld	s8,184(sp)
    80005c12:	6c8e                	ld	s9,192(sp)
    80005c14:	6d2e                	ld	s10,200(sp)
    80005c16:	6dce                	ld	s11,208(sp)
    80005c18:	6e6e                	ld	t3,216(sp)
    80005c1a:	7e8e                	ld	t4,224(sp)
    80005c1c:	7f2e                	ld	t5,232(sp)
    80005c1e:	7fce                	ld	t6,240(sp)
    80005c20:	6111                	add	sp,sp,256
    80005c22:	10200073          	sret
    80005c26:	00000013          	nop
    80005c2a:	00000013          	nop
    80005c2e:	0001                	nop

0000000080005c30 <timervec>:
    80005c30:	34051573          	csrrw	a0,mscratch,a0
    80005c34:	e10c                	sd	a1,0(a0)
    80005c36:	e510                	sd	a2,8(a0)
    80005c38:	e914                	sd	a3,16(a0)
    80005c3a:	710c                	ld	a1,32(a0)
    80005c3c:	7510                	ld	a2,40(a0)
    80005c3e:	6194                	ld	a3,0(a1)
    80005c40:	96b2                	add	a3,a3,a2
    80005c42:	e194                	sd	a3,0(a1)
    80005c44:	4589                	li	a1,2
    80005c46:	14459073          	csrw	sip,a1
    80005c4a:	6914                	ld	a3,16(a0)
    80005c4c:	6510                	ld	a2,8(a0)
    80005c4e:	610c                	ld	a1,0(a0)
    80005c50:	34051573          	csrrw	a0,mscratch,a0
    80005c54:	30200073          	mret
	...

0000000080005c5a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005c5a:	1141                	add	sp,sp,-16
    80005c5c:	e422                	sd	s0,8(sp)
    80005c5e:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005c60:	0c0007b7          	lui	a5,0xc000
    80005c64:	4705                	li	a4,1
    80005c66:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005c68:	c3d8                	sw	a4,4(a5)
}
    80005c6a:	6422                	ld	s0,8(sp)
    80005c6c:	0141                	add	sp,sp,16
    80005c6e:	8082                	ret

0000000080005c70 <plicinithart>:

void
plicinithart(void)
{
    80005c70:	1141                	add	sp,sp,-16
    80005c72:	e406                	sd	ra,8(sp)
    80005c74:	e022                	sd	s0,0(sp)
    80005c76:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005c78:	ffffc097          	auipc	ra,0xffffc
    80005c7c:	d9a080e7          	jalr	-614(ra) # 80001a12 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005c80:	0085171b          	sllw	a4,a0,0x8
    80005c84:	0c0027b7          	lui	a5,0xc002
    80005c88:	97ba                	add	a5,a5,a4
    80005c8a:	40200713          	li	a4,1026
    80005c8e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005c92:	00d5151b          	sllw	a0,a0,0xd
    80005c96:	0c2017b7          	lui	a5,0xc201
    80005c9a:	97aa                	add	a5,a5,a0
    80005c9c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005ca0:	60a2                	ld	ra,8(sp)
    80005ca2:	6402                	ld	s0,0(sp)
    80005ca4:	0141                	add	sp,sp,16
    80005ca6:	8082                	ret

0000000080005ca8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005ca8:	1141                	add	sp,sp,-16
    80005caa:	e406                	sd	ra,8(sp)
    80005cac:	e022                	sd	s0,0(sp)
    80005cae:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005cb0:	ffffc097          	auipc	ra,0xffffc
    80005cb4:	d62080e7          	jalr	-670(ra) # 80001a12 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005cb8:	00d5151b          	sllw	a0,a0,0xd
    80005cbc:	0c2017b7          	lui	a5,0xc201
    80005cc0:	97aa                	add	a5,a5,a0
  return irq;
}
    80005cc2:	43c8                	lw	a0,4(a5)
    80005cc4:	60a2                	ld	ra,8(sp)
    80005cc6:	6402                	ld	s0,0(sp)
    80005cc8:	0141                	add	sp,sp,16
    80005cca:	8082                	ret

0000000080005ccc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005ccc:	1101                	add	sp,sp,-32
    80005cce:	ec06                	sd	ra,24(sp)
    80005cd0:	e822                	sd	s0,16(sp)
    80005cd2:	e426                	sd	s1,8(sp)
    80005cd4:	1000                	add	s0,sp,32
    80005cd6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005cd8:	ffffc097          	auipc	ra,0xffffc
    80005cdc:	d3a080e7          	jalr	-710(ra) # 80001a12 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005ce0:	00d5151b          	sllw	a0,a0,0xd
    80005ce4:	0c2017b7          	lui	a5,0xc201
    80005ce8:	97aa                	add	a5,a5,a0
    80005cea:	c3c4                	sw	s1,4(a5)
}
    80005cec:	60e2                	ld	ra,24(sp)
    80005cee:	6442                	ld	s0,16(sp)
    80005cf0:	64a2                	ld	s1,8(sp)
    80005cf2:	6105                	add	sp,sp,32
    80005cf4:	8082                	ret

0000000080005cf6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005cf6:	1141                	add	sp,sp,-16
    80005cf8:	e406                	sd	ra,8(sp)
    80005cfa:	e022                	sd	s0,0(sp)
    80005cfc:	0800                	add	s0,sp,16
  if(i >= NUM)
    80005cfe:	479d                	li	a5,7
    80005d00:	04a7cb63          	blt	a5,a0,80005d56 <free_desc+0x60>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80005d04:	0001d717          	auipc	a4,0x1d
    80005d08:	2fc70713          	add	a4,a4,764 # 80023000 <disk>
    80005d0c:	972a                	add	a4,a4,a0
    80005d0e:	6789                	lui	a5,0x2
    80005d10:	97ba                	add	a5,a5,a4
    80005d12:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005d16:	eba1                	bnez	a5,80005d66 <free_desc+0x70>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    80005d18:	00451713          	sll	a4,a0,0x4
    80005d1c:	0001f797          	auipc	a5,0x1f
    80005d20:	2e47b783          	ld	a5,740(a5) # 80025000 <disk+0x2000>
    80005d24:	97ba                	add	a5,a5,a4
    80005d26:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    80005d2a:	0001d717          	auipc	a4,0x1d
    80005d2e:	2d670713          	add	a4,a4,726 # 80023000 <disk>
    80005d32:	972a                	add	a4,a4,a0
    80005d34:	6789                	lui	a5,0x2
    80005d36:	97ba                	add	a5,a5,a4
    80005d38:	4705                	li	a4,1
    80005d3a:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005d3e:	0001f517          	auipc	a0,0x1f
    80005d42:	2da50513          	add	a0,a0,730 # 80025018 <disk+0x2018>
    80005d46:	ffffc097          	auipc	ra,0xffffc
    80005d4a:	68e080e7          	jalr	1678(ra) # 800023d4 <wakeup>
}
    80005d4e:	60a2                	ld	ra,8(sp)
    80005d50:	6402                	ld	s0,0(sp)
    80005d52:	0141                	add	sp,sp,16
    80005d54:	8082                	ret
    panic("virtio_disk_intr 1");
    80005d56:	00003517          	auipc	a0,0x3
    80005d5a:	99a50513          	add	a0,a0,-1638 # 800086f0 <syscalls+0x330>
    80005d5e:	ffffa097          	auipc	ra,0xffffa
    80005d62:	7e4080e7          	jalr	2020(ra) # 80000542 <panic>
    panic("virtio_disk_intr 2");
    80005d66:	00003517          	auipc	a0,0x3
    80005d6a:	9a250513          	add	a0,a0,-1630 # 80008708 <syscalls+0x348>
    80005d6e:	ffffa097          	auipc	ra,0xffffa
    80005d72:	7d4080e7          	jalr	2004(ra) # 80000542 <panic>

0000000080005d76 <virtio_disk_init>:
{
    80005d76:	1101                	add	sp,sp,-32
    80005d78:	ec06                	sd	ra,24(sp)
    80005d7a:	e822                	sd	s0,16(sp)
    80005d7c:	e426                	sd	s1,8(sp)
    80005d7e:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005d80:	00003597          	auipc	a1,0x3
    80005d84:	9a058593          	add	a1,a1,-1632 # 80008720 <syscalls+0x360>
    80005d88:	0001f517          	auipc	a0,0x1f
    80005d8c:	32050513          	add	a0,a0,800 # 800250a8 <disk+0x20a8>
    80005d90:	ffffb097          	auipc	ra,0xffffb
    80005d94:	ddc080e7          	jalr	-548(ra) # 80000b6c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005d98:	100017b7          	lui	a5,0x10001
    80005d9c:	4398                	lw	a4,0(a5)
    80005d9e:	2701                	sext.w	a4,a4
    80005da0:	747277b7          	lui	a5,0x74727
    80005da4:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005da8:	0ef71063          	bne	a4,a5,80005e88 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005dac:	100017b7          	lui	a5,0x10001
    80005db0:	43dc                	lw	a5,4(a5)
    80005db2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005db4:	4705                	li	a4,1
    80005db6:	0ce79963          	bne	a5,a4,80005e88 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005dba:	100017b7          	lui	a5,0x10001
    80005dbe:	479c                	lw	a5,8(a5)
    80005dc0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005dc2:	4709                	li	a4,2
    80005dc4:	0ce79263          	bne	a5,a4,80005e88 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005dc8:	100017b7          	lui	a5,0x10001
    80005dcc:	47d8                	lw	a4,12(a5)
    80005dce:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005dd0:	554d47b7          	lui	a5,0x554d4
    80005dd4:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005dd8:	0af71863          	bne	a4,a5,80005e88 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005ddc:	100017b7          	lui	a5,0x10001
    80005de0:	4705                	li	a4,1
    80005de2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005de4:	470d                	li	a4,3
    80005de6:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005de8:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005dea:	c7ffe6b7          	lui	a3,0xc7ffe
    80005dee:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    80005df2:	8f75                	and	a4,a4,a3
    80005df4:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005df6:	472d                	li	a4,11
    80005df8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005dfa:	473d                	li	a4,15
    80005dfc:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005dfe:	6705                	lui	a4,0x1
    80005e00:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005e02:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005e06:	5bdc                	lw	a5,52(a5)
    80005e08:	2781                	sext.w	a5,a5
  if(max == 0)
    80005e0a:	c7d9                	beqz	a5,80005e98 <virtio_disk_init+0x122>
  if(max < NUM)
    80005e0c:	471d                	li	a4,7
    80005e0e:	08f77d63          	bgeu	a4,a5,80005ea8 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005e12:	100014b7          	lui	s1,0x10001
    80005e16:	47a1                	li	a5,8
    80005e18:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005e1a:	6609                	lui	a2,0x2
    80005e1c:	4581                	li	a1,0
    80005e1e:	0001d517          	auipc	a0,0x1d
    80005e22:	1e250513          	add	a0,a0,482 # 80023000 <disk>
    80005e26:	ffffb097          	auipc	ra,0xffffb
    80005e2a:	ed2080e7          	jalr	-302(ra) # 80000cf8 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005e2e:	0001d717          	auipc	a4,0x1d
    80005e32:	1d270713          	add	a4,a4,466 # 80023000 <disk>
    80005e36:	00c75793          	srl	a5,a4,0xc
    80005e3a:	2781                	sext.w	a5,a5
    80005e3c:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    80005e3e:	0001f797          	auipc	a5,0x1f
    80005e42:	1c278793          	add	a5,a5,450 # 80025000 <disk+0x2000>
    80005e46:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    80005e48:	0001d717          	auipc	a4,0x1d
    80005e4c:	23870713          	add	a4,a4,568 # 80023080 <disk+0x80>
    80005e50:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    80005e52:	0001e717          	auipc	a4,0x1e
    80005e56:	1ae70713          	add	a4,a4,430 # 80024000 <disk+0x1000>
    80005e5a:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005e5c:	4705                	li	a4,1
    80005e5e:	00e78c23          	sb	a4,24(a5)
    80005e62:	00e78ca3          	sb	a4,25(a5)
    80005e66:	00e78d23          	sb	a4,26(a5)
    80005e6a:	00e78da3          	sb	a4,27(a5)
    80005e6e:	00e78e23          	sb	a4,28(a5)
    80005e72:	00e78ea3          	sb	a4,29(a5)
    80005e76:	00e78f23          	sb	a4,30(a5)
    80005e7a:	00e78fa3          	sb	a4,31(a5)
}
    80005e7e:	60e2                	ld	ra,24(sp)
    80005e80:	6442                	ld	s0,16(sp)
    80005e82:	64a2                	ld	s1,8(sp)
    80005e84:	6105                	add	sp,sp,32
    80005e86:	8082                	ret
    panic("could not find virtio disk");
    80005e88:	00003517          	auipc	a0,0x3
    80005e8c:	8a850513          	add	a0,a0,-1880 # 80008730 <syscalls+0x370>
    80005e90:	ffffa097          	auipc	ra,0xffffa
    80005e94:	6b2080e7          	jalr	1714(ra) # 80000542 <panic>
    panic("virtio disk has no queue 0");
    80005e98:	00003517          	auipc	a0,0x3
    80005e9c:	8b850513          	add	a0,a0,-1864 # 80008750 <syscalls+0x390>
    80005ea0:	ffffa097          	auipc	ra,0xffffa
    80005ea4:	6a2080e7          	jalr	1698(ra) # 80000542 <panic>
    panic("virtio disk max queue too short");
    80005ea8:	00003517          	auipc	a0,0x3
    80005eac:	8c850513          	add	a0,a0,-1848 # 80008770 <syscalls+0x3b0>
    80005eb0:	ffffa097          	auipc	ra,0xffffa
    80005eb4:	692080e7          	jalr	1682(ra) # 80000542 <panic>

0000000080005eb8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005eb8:	7119                	add	sp,sp,-128
    80005eba:	fc86                	sd	ra,120(sp)
    80005ebc:	f8a2                	sd	s0,112(sp)
    80005ebe:	f4a6                	sd	s1,104(sp)
    80005ec0:	f0ca                	sd	s2,96(sp)
    80005ec2:	ecce                	sd	s3,88(sp)
    80005ec4:	e8d2                	sd	s4,80(sp)
    80005ec6:	e4d6                	sd	s5,72(sp)
    80005ec8:	e0da                	sd	s6,64(sp)
    80005eca:	fc5e                	sd	s7,56(sp)
    80005ecc:	f862                	sd	s8,48(sp)
    80005ece:	f466                	sd	s9,40(sp)
    80005ed0:	f06a                	sd	s10,32(sp)
    80005ed2:	0100                	add	s0,sp,128
    80005ed4:	8a2a                	mv	s4,a0
    80005ed6:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005ed8:	00c52c03          	lw	s8,12(a0)
    80005edc:	001c1c1b          	sllw	s8,s8,0x1
    80005ee0:	1c02                	sll	s8,s8,0x20
    80005ee2:	020c5c13          	srl	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    80005ee6:	0001f517          	auipc	a0,0x1f
    80005eea:	1c250513          	add	a0,a0,450 # 800250a8 <disk+0x20a8>
    80005eee:	ffffb097          	auipc	ra,0xffffb
    80005ef2:	d0e080e7          	jalr	-754(ra) # 80000bfc <acquire>
  for(int i = 0; i < 3; i++){
    80005ef6:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005ef8:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005efa:	0001db97          	auipc	s7,0x1d
    80005efe:	106b8b93          	add	s7,s7,262 # 80023000 <disk>
    80005f02:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005f04:	4a8d                	li	s5,3
    80005f06:	a0b5                	j	80005f72 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005f08:	00fb8733          	add	a4,s7,a5
    80005f0c:	975a                	add	a4,a4,s6
    80005f0e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005f12:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80005f14:	0207c563          	bltz	a5,80005f3e <virtio_disk_rw+0x86>
  for(int i = 0; i < 3; i++){
    80005f18:	2605                	addw	a2,a2,1 # 2001 <_entry-0x7fffdfff>
    80005f1a:	0591                	add	a1,a1,4
    80005f1c:	19560c63          	beq	a2,s5,800060b4 <virtio_disk_rw+0x1fc>
    idx[i] = alloc_desc();
    80005f20:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005f22:	0001f717          	auipc	a4,0x1f
    80005f26:	0f670713          	add	a4,a4,246 # 80025018 <disk+0x2018>
    80005f2a:	87ca                	mv	a5,s2
    if(disk.free[i]){
    80005f2c:	00074683          	lbu	a3,0(a4)
    80005f30:	fee1                	bnez	a3,80005f08 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005f32:	2785                	addw	a5,a5,1
    80005f34:	0705                	add	a4,a4,1
    80005f36:	fe979be3          	bne	a5,s1,80005f2c <virtio_disk_rw+0x74>
    idx[i] = alloc_desc();
    80005f3a:	57fd                	li	a5,-1
    80005f3c:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    80005f3e:	00c05e63          	blez	a2,80005f5a <virtio_disk_rw+0xa2>
    80005f42:	060a                	sll	a2,a2,0x2
    80005f44:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80005f48:	0009a503          	lw	a0,0(s3)
    80005f4c:	00000097          	auipc	ra,0x0
    80005f50:	daa080e7          	jalr	-598(ra) # 80005cf6 <free_desc>
      for(int j = 0; j < i; j++)
    80005f54:	0991                	add	s3,s3,4
    80005f56:	ffa999e3          	bne	s3,s10,80005f48 <virtio_disk_rw+0x90>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005f5a:	0001f597          	auipc	a1,0x1f
    80005f5e:	14e58593          	add	a1,a1,334 # 800250a8 <disk+0x20a8>
    80005f62:	0001f517          	auipc	a0,0x1f
    80005f66:	0b650513          	add	a0,a0,182 # 80025018 <disk+0x2018>
    80005f6a:	ffffc097          	auipc	ra,0xffffc
    80005f6e:	2ea080e7          	jalr	746(ra) # 80002254 <sleep>
  for(int i = 0; i < 3; i++){
    80005f72:	f9040993          	add	s3,s0,-112
{
    80005f76:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80005f78:	864a                	mv	a2,s2
    80005f7a:	b75d                	j	80005f20 <virtio_disk_rw+0x68>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005f7c:	0001f717          	auipc	a4,0x1f
    80005f80:	08473703          	ld	a4,132(a4) # 80025000 <disk+0x2000>
    80005f84:	973e                	add	a4,a4,a5
    80005f86:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005f8a:	0001d517          	auipc	a0,0x1d
    80005f8e:	07650513          	add	a0,a0,118 # 80023000 <disk>
    80005f92:	0001f717          	auipc	a4,0x1f
    80005f96:	06e70713          	add	a4,a4,110 # 80025000 <disk+0x2000>
    80005f9a:	6314                	ld	a3,0(a4)
    80005f9c:	96be                	add	a3,a3,a5
    80005f9e:	00c6d603          	lhu	a2,12(a3)
    80005fa2:	00166613          	or	a2,a2,1
    80005fa6:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005faa:	f9842683          	lw	a3,-104(s0)
    80005fae:	6310                	ld	a2,0(a4)
    80005fb0:	97b2                	add	a5,a5,a2
    80005fb2:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
    80005fb6:	20048613          	add	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    80005fba:	0612                	sll	a2,a2,0x4
    80005fbc:	962a                	add	a2,a2,a0
    80005fbe:	02060823          	sb	zero,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005fc2:	00469793          	sll	a5,a3,0x4
    80005fc6:	630c                	ld	a1,0(a4)
    80005fc8:	95be                	add	a1,a1,a5
    80005fca:	6689                	lui	a3,0x2
    80005fcc:	03068693          	add	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005fd0:	96ca                	add	a3,a3,s2
    80005fd2:	96aa                	add	a3,a3,a0
    80005fd4:	e194                	sd	a3,0(a1)
  disk.desc[idx[2]].len = 1;
    80005fd6:	6314                	ld	a3,0(a4)
    80005fd8:	96be                	add	a3,a3,a5
    80005fda:	4585                	li	a1,1
    80005fdc:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005fde:	6314                	ld	a3,0(a4)
    80005fe0:	96be                	add	a3,a3,a5
    80005fe2:	4509                	li	a0,2
    80005fe4:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    80005fe8:	6314                	ld	a3,0(a4)
    80005fea:	97b6                	add	a5,a5,a3
    80005fec:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005ff0:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80005ff4:	03463423          	sd	s4,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    80005ff8:	6714                	ld	a3,8(a4)
    80005ffa:	0026d783          	lhu	a5,2(a3)
    80005ffe:	8b9d                	and	a5,a5,7
    80006000:	0789                	add	a5,a5,2
    80006002:	0786                	sll	a5,a5,0x1
    80006004:	96be                	add	a3,a3,a5
    80006006:	00969023          	sh	s1,0(a3)
  __sync_synchronize();
    8000600a:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    8000600e:	6718                	ld	a4,8(a4)
    80006010:	00275783          	lhu	a5,2(a4)
    80006014:	2785                	addw	a5,a5,1
    80006016:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000601a:	100017b7          	lui	a5,0x10001
    8000601e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006022:	004a2783          	lw	a5,4(s4)
    80006026:	02b79163          	bne	a5,a1,80006048 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    8000602a:	0001f917          	auipc	s2,0x1f
    8000602e:	07e90913          	add	s2,s2,126 # 800250a8 <disk+0x20a8>
  while(b->disk == 1) {
    80006032:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006034:	85ca                	mv	a1,s2
    80006036:	8552                	mv	a0,s4
    80006038:	ffffc097          	auipc	ra,0xffffc
    8000603c:	21c080e7          	jalr	540(ra) # 80002254 <sleep>
  while(b->disk == 1) {
    80006040:	004a2783          	lw	a5,4(s4)
    80006044:	fe9788e3          	beq	a5,s1,80006034 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80006048:	f9042483          	lw	s1,-112(s0)
    8000604c:	20048713          	add	a4,s1,512
    80006050:	0712                	sll	a4,a4,0x4
    80006052:	0001d797          	auipc	a5,0x1d
    80006056:	fae78793          	add	a5,a5,-82 # 80023000 <disk>
    8000605a:	97ba                	add	a5,a5,a4
    8000605c:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80006060:	0001f917          	auipc	s2,0x1f
    80006064:	fa090913          	add	s2,s2,-96 # 80025000 <disk+0x2000>
    80006068:	a019                	j	8000606e <virtio_disk_rw+0x1b6>
      i = disk.desc[i].next;
    8000606a:	00e7d483          	lhu	s1,14(a5)
    free_desc(i);
    8000606e:	8526                	mv	a0,s1
    80006070:	00000097          	auipc	ra,0x0
    80006074:	c86080e7          	jalr	-890(ra) # 80005cf6 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80006078:	0492                	sll	s1,s1,0x4
    8000607a:	00093783          	ld	a5,0(s2)
    8000607e:	97a6                	add	a5,a5,s1
    80006080:	00c7d703          	lhu	a4,12(a5)
    80006084:	8b05                	and	a4,a4,1
    80006086:	f375                	bnez	a4,8000606a <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006088:	0001f517          	auipc	a0,0x1f
    8000608c:	02050513          	add	a0,a0,32 # 800250a8 <disk+0x20a8>
    80006090:	ffffb097          	auipc	ra,0xffffb
    80006094:	c20080e7          	jalr	-992(ra) # 80000cb0 <release>
}
    80006098:	70e6                	ld	ra,120(sp)
    8000609a:	7446                	ld	s0,112(sp)
    8000609c:	74a6                	ld	s1,104(sp)
    8000609e:	7906                	ld	s2,96(sp)
    800060a0:	69e6                	ld	s3,88(sp)
    800060a2:	6a46                	ld	s4,80(sp)
    800060a4:	6aa6                	ld	s5,72(sp)
    800060a6:	6b06                	ld	s6,64(sp)
    800060a8:	7be2                	ld	s7,56(sp)
    800060aa:	7c42                	ld	s8,48(sp)
    800060ac:	7ca2                	ld	s9,40(sp)
    800060ae:	7d02                	ld	s10,32(sp)
    800060b0:	6109                	add	sp,sp,128
    800060b2:	8082                	ret
  if(write)
    800060b4:	019037b3          	snez	a5,s9
    800060b8:	f8f42023          	sw	a5,-128(s0)
  buf0.reserved = 0;
    800060bc:	f8042223          	sw	zero,-124(s0)
  buf0.sector = sector;
    800060c0:	f9843423          	sd	s8,-120(s0)
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    800060c4:	f9042483          	lw	s1,-112(s0)
    800060c8:	00449913          	sll	s2,s1,0x4
    800060cc:	0001f997          	auipc	s3,0x1f
    800060d0:	f3498993          	add	s3,s3,-204 # 80025000 <disk+0x2000>
    800060d4:	0009ba83          	ld	s5,0(s3)
    800060d8:	9aca                	add	s5,s5,s2
    800060da:	f8040513          	add	a0,s0,-128
    800060de:	ffffb097          	auipc	ra,0xffffb
    800060e2:	fe8080e7          	jalr	-24(ra) # 800010c6 <kvmpa>
    800060e6:	00aab023          	sd	a0,0(s5)
  disk.desc[idx[0]].len = sizeof(buf0);
    800060ea:	0009b783          	ld	a5,0(s3)
    800060ee:	97ca                	add	a5,a5,s2
    800060f0:	4741                	li	a4,16
    800060f2:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800060f4:	0009b783          	ld	a5,0(s3)
    800060f8:	97ca                	add	a5,a5,s2
    800060fa:	4705                	li	a4,1
    800060fc:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80006100:	f9442783          	lw	a5,-108(s0)
    80006104:	0009b703          	ld	a4,0(s3)
    80006108:	974a                	add	a4,a4,s2
    8000610a:	00f71723          	sh	a5,14(a4)
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000610e:	0792                	sll	a5,a5,0x4
    80006110:	0009b703          	ld	a4,0(s3)
    80006114:	973e                	add	a4,a4,a5
    80006116:	058a0693          	add	a3,s4,88
    8000611a:	e314                	sd	a3,0(a4)
  disk.desc[idx[1]].len = BSIZE;
    8000611c:	0009b703          	ld	a4,0(s3)
    80006120:	973e                	add	a4,a4,a5
    80006122:	40000693          	li	a3,1024
    80006126:	c714                	sw	a3,8(a4)
  if(write)
    80006128:	e40c9ae3          	bnez	s9,80005f7c <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000612c:	0001f717          	auipc	a4,0x1f
    80006130:	ed473703          	ld	a4,-300(a4) # 80025000 <disk+0x2000>
    80006134:	973e                	add	a4,a4,a5
    80006136:	4689                	li	a3,2
    80006138:	00d71623          	sh	a3,12(a4)
    8000613c:	b5b9                	j	80005f8a <virtio_disk_rw+0xd2>

000000008000613e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000613e:	1101                	add	sp,sp,-32
    80006140:	ec06                	sd	ra,24(sp)
    80006142:	e822                	sd	s0,16(sp)
    80006144:	e426                	sd	s1,8(sp)
    80006146:	e04a                	sd	s2,0(sp)
    80006148:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000614a:	0001f517          	auipc	a0,0x1f
    8000614e:	f5e50513          	add	a0,a0,-162 # 800250a8 <disk+0x20a8>
    80006152:	ffffb097          	auipc	ra,0xffffb
    80006156:	aaa080e7          	jalr	-1366(ra) # 80000bfc <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    8000615a:	0001f717          	auipc	a4,0x1f
    8000615e:	ea670713          	add	a4,a4,-346 # 80025000 <disk+0x2000>
    80006162:	02075783          	lhu	a5,32(a4)
    80006166:	6b18                	ld	a4,16(a4)
    80006168:	00275683          	lhu	a3,2(a4)
    8000616c:	8ebd                	xor	a3,a3,a5
    8000616e:	8a9d                	and	a3,a3,7
    80006170:	cab9                	beqz	a3,800061c6 <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    80006172:	0001d917          	auipc	s2,0x1d
    80006176:	e8e90913          	add	s2,s2,-370 # 80023000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    8000617a:	0001f497          	auipc	s1,0x1f
    8000617e:	e8648493          	add	s1,s1,-378 # 80025000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    80006182:	078e                	sll	a5,a5,0x3
    80006184:	973e                	add	a4,a4,a5
    80006186:	435c                	lw	a5,4(a4)
    if(disk.info[id].status != 0)
    80006188:	20078713          	add	a4,a5,512
    8000618c:	0712                	sll	a4,a4,0x4
    8000618e:	974a                	add	a4,a4,s2
    80006190:	03074703          	lbu	a4,48(a4)
    80006194:	ef21                	bnez	a4,800061ec <virtio_disk_intr+0xae>
    disk.info[id].b->disk = 0;   // disk is done with buf
    80006196:	20078793          	add	a5,a5,512
    8000619a:	0792                	sll	a5,a5,0x4
    8000619c:	97ca                	add	a5,a5,s2
    8000619e:	7798                	ld	a4,40(a5)
    800061a0:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    800061a4:	7788                	ld	a0,40(a5)
    800061a6:	ffffc097          	auipc	ra,0xffffc
    800061aa:	22e080e7          	jalr	558(ra) # 800023d4 <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    800061ae:	0204d783          	lhu	a5,32(s1)
    800061b2:	2785                	addw	a5,a5,1
    800061b4:	8b9d                	and	a5,a5,7
    800061b6:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    800061ba:	6898                	ld	a4,16(s1)
    800061bc:	00275683          	lhu	a3,2(a4)
    800061c0:	8a9d                	and	a3,a3,7
    800061c2:	fcf690e3          	bne	a3,a5,80006182 <virtio_disk_intr+0x44>
  }
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800061c6:	10001737          	lui	a4,0x10001
    800061ca:	533c                	lw	a5,96(a4)
    800061cc:	8b8d                	and	a5,a5,3
    800061ce:	d37c                	sw	a5,100(a4)

  release(&disk.vdisk_lock);
    800061d0:	0001f517          	auipc	a0,0x1f
    800061d4:	ed850513          	add	a0,a0,-296 # 800250a8 <disk+0x20a8>
    800061d8:	ffffb097          	auipc	ra,0xffffb
    800061dc:	ad8080e7          	jalr	-1320(ra) # 80000cb0 <release>
}
    800061e0:	60e2                	ld	ra,24(sp)
    800061e2:	6442                	ld	s0,16(sp)
    800061e4:	64a2                	ld	s1,8(sp)
    800061e6:	6902                	ld	s2,0(sp)
    800061e8:	6105                	add	sp,sp,32
    800061ea:	8082                	ret
      panic("virtio_disk_intr status");
    800061ec:	00002517          	auipc	a0,0x2
    800061f0:	5a450513          	add	a0,a0,1444 # 80008790 <syscalls+0x3d0>
    800061f4:	ffffa097          	auipc	ra,0xffffa
    800061f8:	34e080e7          	jalr	846(ra) # 80000542 <panic>
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
