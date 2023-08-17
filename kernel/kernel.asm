
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
    80000060:	ce478793          	add	a5,a5,-796 # 80005d40 <timervec>
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
    80000094:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd77ff>
    80000098:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	e7278793          	add	a5,a5,-398 # 80000f18 <main>
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
    80000110:	b64080e7          	jalr	-1180(ra) # 80000c70 <acquire>
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
    8000012a:	424080e7          	jalr	1060(ra) # 8000254a <either_copyin>
    8000012e:	01550d63          	beq	a0,s5,80000148 <consolewrite+0x5c>
      break;
    uartputc(c);
    80000132:	fbf44503          	lbu	a0,-65(s0)
    80000136:	00001097          	auipc	ra,0x1
    8000013a:	80a080e7          	jalr	-2038(ra) # 80000940 <uartputc>
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
    80000154:	bd4080e7          	jalr	-1068(ra) # 80000d24 <release>

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
    8000019c:	ad8080e7          	jalr	-1320(ra) # 80000c70 <acquire>
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
    800001c4:	87a080e7          	jalr	-1926(ra) # 80001a3a <myproc>
    800001c8:	591c                	lw	a5,48(a0)
    800001ca:	efad                	bnez	a5,80000244 <consoleread+0xd4>
      sleep(&cons.r, &cons.lock);
    800001cc:	85a6                	mv	a1,s1
    800001ce:	854a                	mv	a0,s2
    800001d0:	00002097          	auipc	ra,0x2
    800001d4:	0ca080e7          	jalr	202(ra) # 8000229a <sleep>
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
    8000021a:	2de080e7          	jalr	734(ra) # 800024f4 <either_copyout>
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
    8000023a:	aee080e7          	jalr	-1298(ra) # 80000d24 <release>

  return target - n;
    8000023e:	413b053b          	subw	a0,s6,s3
    80000242:	a811                	j	80000256 <consoleread+0xe6>
        release(&cons.lock);
    80000244:	00011517          	auipc	a0,0x11
    80000248:	5ec50513          	add	a0,a0,1516 # 80011830 <cons>
    8000024c:	00001097          	auipc	ra,0x1
    80000250:	ad8080e7          	jalr	-1320(ra) # 80000d24 <release>
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
    80000292:	5d4080e7          	jalr	1492(ra) # 80000862 <uartputc_sync>
}
    80000296:	60a2                	ld	ra,8(sp)
    80000298:	6402                	ld	s0,0(sp)
    8000029a:	0141                	add	sp,sp,16
    8000029c:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000029e:	4521                	li	a0,8
    800002a0:	00000097          	auipc	ra,0x0
    800002a4:	5c2080e7          	jalr	1474(ra) # 80000862 <uartputc_sync>
    800002a8:	02000513          	li	a0,32
    800002ac:	00000097          	auipc	ra,0x0
    800002b0:	5b6080e7          	jalr	1462(ra) # 80000862 <uartputc_sync>
    800002b4:	4521                	li	a0,8
    800002b6:	00000097          	auipc	ra,0x0
    800002ba:	5ac080e7          	jalr	1452(ra) # 80000862 <uartputc_sync>
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
    800002da:	99a080e7          	jalr	-1638(ra) # 80000c70 <acquire>

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
    800002f8:	2ac080e7          	jalr	684(ra) # 800025a0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002fc:	00011517          	auipc	a0,0x11
    80000300:	53450513          	add	a0,a0,1332 # 80011830 <cons>
    80000304:	00001097          	auipc	ra,0x1
    80000308:	a20080e7          	jalr	-1504(ra) # 80000d24 <release>
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
    8000044c:	fd2080e7          	jalr	-46(ra) # 8000241a <wakeup>
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
    8000046e:	776080e7          	jalr	1910(ra) # 80000be0 <initlock>

  uartinit();
    80000472:	00000097          	auipc	ra,0x0
    80000476:	3a0080e7          	jalr	928(ra) # 80000812 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000047a:	00022797          	auipc	a5,0x22
    8000047e:	f3678793          	add	a5,a5,-202 # 800223b0 <devsw>
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
    800004c0:	b9c60613          	add	a2,a2,-1124 # 80008058 <digits>
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

0000000080000542 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000542:	1101                	add	sp,sp,-32
    80000544:	ec06                	sd	ra,24(sp)
    80000546:	e822                	sd	s0,16(sp)
    80000548:	e426                	sd	s1,8(sp)
    8000054a:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    8000054c:	00011497          	auipc	s1,0x11
    80000550:	38c48493          	add	s1,s1,908 # 800118d8 <pr>
    80000554:	00008597          	auipc	a1,0x8
    80000558:	ac458593          	add	a1,a1,-1340 # 80008018 <etext+0x18>
    8000055c:	8526                	mv	a0,s1
    8000055e:	00000097          	auipc	ra,0x0
    80000562:	682080e7          	jalr	1666(ra) # 80000be0 <initlock>
  pr.locking = 1;
    80000566:	4785                	li	a5,1
    80000568:	cc9c                	sw	a5,24(s1)
}
    8000056a:	60e2                	ld	ra,24(sp)
    8000056c:	6442                	ld	s0,16(sp)
    8000056e:	64a2                	ld	s1,8(sp)
    80000570:	6105                	add	sp,sp,32
    80000572:	8082                	ret

0000000080000574 <backtrace>:

void
backtrace(void) {
    80000574:	7179                	add	sp,sp,-48
    80000576:	f406                	sd	ra,40(sp)
    80000578:	f022                	sd	s0,32(sp)
    8000057a:	ec26                	sd	s1,24(sp)
    8000057c:	e84a                	sd	s2,16(sp)
    8000057e:	e44e                	sd	s3,8(sp)
    80000580:	e052                	sd	s4,0(sp)
    80000582:	1800                	add	s0,sp,48
  printf("backtrace:\n");
    80000584:	00008517          	auipc	a0,0x8
    80000588:	a9c50513          	add	a0,a0,-1380 # 80008020 <etext+0x20>
    8000058c:	00000097          	auipc	ra,0x0
    80000590:	0a6080e7          	jalr	166(ra) # 80000632 <printf>

static inline uint64
r_fp()
{
  uint64 x;
  asm volatile("mv %0, s0" : "=r" (x) );
    80000594:	84a2                	mv	s1,s0
  // 读取当前帧指针
  uint64 fp = r_fp();
  while (fp != PGROUNDUP(fp)) {
    80000596:	6785                	lui	a5,0x1
    80000598:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000059a:	97a6                	add	a5,a5,s1
    8000059c:	777d                	lui	a4,0xfffff
    8000059e:	8ff9                	and	a5,a5,a4
    800005a0:	02f48863          	beq	s1,a5,800005d0 <backtrace+0x5c>
    // xv6中，用一个页来存储栈，如果fp已经达到了栈页的上届，说明已经达到栈底
    // 地址扩张是向低地址扩展，所以当fp到达最高地址时说明到达栈底
    uint64 ra = *(uint64*)(fp - 8); // return address
    printf("%p\n", ra);
    800005a4:	00008a17          	auipc	s4,0x8
    800005a8:	a8ca0a13          	add	s4,s4,-1396 # 80008030 <etext+0x30>
  while (fp != PGROUNDUP(fp)) {
    800005ac:	6905                	lui	s2,0x1
    800005ae:	197d                	add	s2,s2,-1 # fff <_entry-0x7ffff001>
    800005b0:	79fd                	lui	s3,0xfffff
    printf("%p\n", ra);
    800005b2:	ff84b583          	ld	a1,-8(s1)
    800005b6:	8552                	mv	a0,s4
    800005b8:	00000097          	auipc	ra,0x0
    800005bc:	07a080e7          	jalr	122(ra) # 80000632 <printf>
    fp = *(uint64*)(fp - 16); // preivous fp
    800005c0:	ff04b483          	ld	s1,-16(s1)
  while (fp != PGROUNDUP(fp)) {
    800005c4:	012487b3          	add	a5,s1,s2
    800005c8:	0137f7b3          	and	a5,a5,s3
    800005cc:	fe9793e3          	bne	a5,s1,800005b2 <backtrace+0x3e>
  }
}
    800005d0:	70a2                	ld	ra,40(sp)
    800005d2:	7402                	ld	s0,32(sp)
    800005d4:	64e2                	ld	s1,24(sp)
    800005d6:	6942                	ld	s2,16(sp)
    800005d8:	69a2                	ld	s3,8(sp)
    800005da:	6a02                	ld	s4,0(sp)
    800005dc:	6145                	add	sp,sp,48
    800005de:	8082                	ret

00000000800005e0 <panic>:
{
    800005e0:	1101                	add	sp,sp,-32
    800005e2:	ec06                	sd	ra,24(sp)
    800005e4:	e822                	sd	s0,16(sp)
    800005e6:	e426                	sd	s1,8(sp)
    800005e8:	1000                	add	s0,sp,32
    800005ea:	84aa                	mv	s1,a0
  backtrace();
    800005ec:	00000097          	auipc	ra,0x0
    800005f0:	f88080e7          	jalr	-120(ra) # 80000574 <backtrace>
  pr.locking = 0;
    800005f4:	00011797          	auipc	a5,0x11
    800005f8:	2e07ae23          	sw	zero,764(a5) # 800118f0 <pr+0x18>
  printf("panic: ");
    800005fc:	00008517          	auipc	a0,0x8
    80000600:	a3c50513          	add	a0,a0,-1476 # 80008038 <etext+0x38>
    80000604:	00000097          	auipc	ra,0x0
    80000608:	02e080e7          	jalr	46(ra) # 80000632 <printf>
  printf(s);
    8000060c:	8526                	mv	a0,s1
    8000060e:	00000097          	auipc	ra,0x0
    80000612:	024080e7          	jalr	36(ra) # 80000632 <printf>
  printf("\n");
    80000616:	00008517          	auipc	a0,0x8
    8000061a:	aca50513          	add	a0,a0,-1334 # 800080e0 <digits+0x88>
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	014080e7          	jalr	20(ra) # 80000632 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000626:	4785                	li	a5,1
    80000628:	00009717          	auipc	a4,0x9
    8000062c:	9cf72c23          	sw	a5,-1576(a4) # 80009000 <panicked>
  for(;;)
    80000630:	a001                	j	80000630 <panic+0x50>

0000000080000632 <printf>:
{
    80000632:	7131                	add	sp,sp,-192
    80000634:	fc86                	sd	ra,120(sp)
    80000636:	f8a2                	sd	s0,112(sp)
    80000638:	f4a6                	sd	s1,104(sp)
    8000063a:	f0ca                	sd	s2,96(sp)
    8000063c:	ecce                	sd	s3,88(sp)
    8000063e:	e8d2                	sd	s4,80(sp)
    80000640:	e4d6                	sd	s5,72(sp)
    80000642:	e0da                	sd	s6,64(sp)
    80000644:	fc5e                	sd	s7,56(sp)
    80000646:	f862                	sd	s8,48(sp)
    80000648:	f466                	sd	s9,40(sp)
    8000064a:	f06a                	sd	s10,32(sp)
    8000064c:	ec6e                	sd	s11,24(sp)
    8000064e:	0100                	add	s0,sp,128
    80000650:	8a2a                	mv	s4,a0
    80000652:	e40c                	sd	a1,8(s0)
    80000654:	e810                	sd	a2,16(s0)
    80000656:	ec14                	sd	a3,24(s0)
    80000658:	f018                	sd	a4,32(s0)
    8000065a:	f41c                	sd	a5,40(s0)
    8000065c:	03043823          	sd	a6,48(s0)
    80000660:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80000664:	00011d97          	auipc	s11,0x11
    80000668:	28cdad83          	lw	s11,652(s11) # 800118f0 <pr+0x18>
  if(locking)
    8000066c:	020d9b63          	bnez	s11,800006a2 <printf+0x70>
  if (fmt == 0)
    80000670:	040a0263          	beqz	s4,800006b4 <printf+0x82>
  va_start(ap, fmt);
    80000674:	00840793          	add	a5,s0,8
    80000678:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000067c:	000a4503          	lbu	a0,0(s4)
    80000680:	14050f63          	beqz	a0,800007de <printf+0x1ac>
    80000684:	4981                	li	s3,0
    if(c != '%'){
    80000686:	02500a93          	li	s5,37
    switch(c){
    8000068a:	07000b93          	li	s7,112
  consputc('x');
    8000068e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000690:	00008b17          	auipc	s6,0x8
    80000694:	9c8b0b13          	add	s6,s6,-1592 # 80008058 <digits>
    switch(c){
    80000698:	07300c93          	li	s9,115
    8000069c:	06400c13          	li	s8,100
    800006a0:	a82d                	j	800006da <printf+0xa8>
    acquire(&pr.lock);
    800006a2:	00011517          	auipc	a0,0x11
    800006a6:	23650513          	add	a0,a0,566 # 800118d8 <pr>
    800006aa:	00000097          	auipc	ra,0x0
    800006ae:	5c6080e7          	jalr	1478(ra) # 80000c70 <acquire>
    800006b2:	bf7d                	j	80000670 <printf+0x3e>
    panic("null fmt");
    800006b4:	00008517          	auipc	a0,0x8
    800006b8:	99450513          	add	a0,a0,-1644 # 80008048 <etext+0x48>
    800006bc:	00000097          	auipc	ra,0x0
    800006c0:	f24080e7          	jalr	-220(ra) # 800005e0 <panic>
      consputc(c);
    800006c4:	00000097          	auipc	ra,0x0
    800006c8:	bba080e7          	jalr	-1094(ra) # 8000027e <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800006cc:	2985                	addw	s3,s3,1 # fffffffffffff001 <end+0xffffffff7ffd8001>
    800006ce:	013a07b3          	add	a5,s4,s3
    800006d2:	0007c503          	lbu	a0,0(a5)
    800006d6:	10050463          	beqz	a0,800007de <printf+0x1ac>
    if(c != '%'){
    800006da:	ff5515e3          	bne	a0,s5,800006c4 <printf+0x92>
    c = fmt[++i] & 0xff;
    800006de:	2985                	addw	s3,s3,1
    800006e0:	013a07b3          	add	a5,s4,s3
    800006e4:	0007c783          	lbu	a5,0(a5)
    800006e8:	0007849b          	sext.w	s1,a5
    if(c == 0)
    800006ec:	cbed                	beqz	a5,800007de <printf+0x1ac>
    switch(c){
    800006ee:	05778a63          	beq	a5,s7,80000742 <printf+0x110>
    800006f2:	02fbf663          	bgeu	s7,a5,8000071e <printf+0xec>
    800006f6:	09978863          	beq	a5,s9,80000786 <printf+0x154>
    800006fa:	07800713          	li	a4,120
    800006fe:	0ce79563          	bne	a5,a4,800007c8 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000702:	f8843783          	ld	a5,-120(s0)
    80000706:	00878713          	add	a4,a5,8
    8000070a:	f8e43423          	sd	a4,-120(s0)
    8000070e:	4605                	li	a2,1
    80000710:	85ea                	mv	a1,s10
    80000712:	4388                	lw	a0,0(a5)
    80000714:	00000097          	auipc	ra,0x0
    80000718:	d8a080e7          	jalr	-630(ra) # 8000049e <printint>
      break;
    8000071c:	bf45                	j	800006cc <printf+0x9a>
    switch(c){
    8000071e:	09578f63          	beq	a5,s5,800007bc <printf+0x18a>
    80000722:	0b879363          	bne	a5,s8,800007c8 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80000726:	f8843783          	ld	a5,-120(s0)
    8000072a:	00878713          	add	a4,a5,8
    8000072e:	f8e43423          	sd	a4,-120(s0)
    80000732:	4605                	li	a2,1
    80000734:	45a9                	li	a1,10
    80000736:	4388                	lw	a0,0(a5)
    80000738:	00000097          	auipc	ra,0x0
    8000073c:	d66080e7          	jalr	-666(ra) # 8000049e <printint>
      break;
    80000740:	b771                	j	800006cc <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000742:	f8843783          	ld	a5,-120(s0)
    80000746:	00878713          	add	a4,a5,8
    8000074a:	f8e43423          	sd	a4,-120(s0)
    8000074e:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80000752:	03000513          	li	a0,48
    80000756:	00000097          	auipc	ra,0x0
    8000075a:	b28080e7          	jalr	-1240(ra) # 8000027e <consputc>
  consputc('x');
    8000075e:	07800513          	li	a0,120
    80000762:	00000097          	auipc	ra,0x0
    80000766:	b1c080e7          	jalr	-1252(ra) # 8000027e <consputc>
    8000076a:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000076c:	03c95793          	srl	a5,s2,0x3c
    80000770:	97da                	add	a5,a5,s6
    80000772:	0007c503          	lbu	a0,0(a5)
    80000776:	00000097          	auipc	ra,0x0
    8000077a:	b08080e7          	jalr	-1272(ra) # 8000027e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000077e:	0912                	sll	s2,s2,0x4
    80000780:	34fd                	addw	s1,s1,-1
    80000782:	f4ed                	bnez	s1,8000076c <printf+0x13a>
    80000784:	b7a1                	j	800006cc <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80000786:	f8843783          	ld	a5,-120(s0)
    8000078a:	00878713          	add	a4,a5,8
    8000078e:	f8e43423          	sd	a4,-120(s0)
    80000792:	6384                	ld	s1,0(a5)
    80000794:	cc89                	beqz	s1,800007ae <printf+0x17c>
      for(; *s; s++)
    80000796:	0004c503          	lbu	a0,0(s1)
    8000079a:	d90d                	beqz	a0,800006cc <printf+0x9a>
        consputc(*s);
    8000079c:	00000097          	auipc	ra,0x0
    800007a0:	ae2080e7          	jalr	-1310(ra) # 8000027e <consputc>
      for(; *s; s++)
    800007a4:	0485                	add	s1,s1,1
    800007a6:	0004c503          	lbu	a0,0(s1)
    800007aa:	f96d                	bnez	a0,8000079c <printf+0x16a>
    800007ac:	b705                	j	800006cc <printf+0x9a>
        s = "(null)";
    800007ae:	00008497          	auipc	s1,0x8
    800007b2:	89248493          	add	s1,s1,-1902 # 80008040 <etext+0x40>
      for(; *s; s++)
    800007b6:	02800513          	li	a0,40
    800007ba:	b7cd                	j	8000079c <printf+0x16a>
      consputc('%');
    800007bc:	8556                	mv	a0,s5
    800007be:	00000097          	auipc	ra,0x0
    800007c2:	ac0080e7          	jalr	-1344(ra) # 8000027e <consputc>
      break;
    800007c6:	b719                	j	800006cc <printf+0x9a>
      consputc('%');
    800007c8:	8556                	mv	a0,s5
    800007ca:	00000097          	auipc	ra,0x0
    800007ce:	ab4080e7          	jalr	-1356(ra) # 8000027e <consputc>
      consputc(c);
    800007d2:	8526                	mv	a0,s1
    800007d4:	00000097          	auipc	ra,0x0
    800007d8:	aaa080e7          	jalr	-1366(ra) # 8000027e <consputc>
      break;
    800007dc:	bdc5                	j	800006cc <printf+0x9a>
  if(locking)
    800007de:	020d9163          	bnez	s11,80000800 <printf+0x1ce>
}
    800007e2:	70e6                	ld	ra,120(sp)
    800007e4:	7446                	ld	s0,112(sp)
    800007e6:	74a6                	ld	s1,104(sp)
    800007e8:	7906                	ld	s2,96(sp)
    800007ea:	69e6                	ld	s3,88(sp)
    800007ec:	6a46                	ld	s4,80(sp)
    800007ee:	6aa6                	ld	s5,72(sp)
    800007f0:	6b06                	ld	s6,64(sp)
    800007f2:	7be2                	ld	s7,56(sp)
    800007f4:	7c42                	ld	s8,48(sp)
    800007f6:	7ca2                	ld	s9,40(sp)
    800007f8:	7d02                	ld	s10,32(sp)
    800007fa:	6de2                	ld	s11,24(sp)
    800007fc:	6129                	add	sp,sp,192
    800007fe:	8082                	ret
    release(&pr.lock);
    80000800:	00011517          	auipc	a0,0x11
    80000804:	0d850513          	add	a0,a0,216 # 800118d8 <pr>
    80000808:	00000097          	auipc	ra,0x0
    8000080c:	51c080e7          	jalr	1308(ra) # 80000d24 <release>
}
    80000810:	bfc9                	j	800007e2 <printf+0x1b0>

0000000080000812 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000812:	1141                	add	sp,sp,-16
    80000814:	e406                	sd	ra,8(sp)
    80000816:	e022                	sd	s0,0(sp)
    80000818:	0800                	add	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000081a:	100007b7          	lui	a5,0x10000
    8000081e:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000822:	f8000713          	li	a4,-128
    80000826:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000082a:	470d                	li	a4,3
    8000082c:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000830:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000834:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000838:	469d                	li	a3,7
    8000083a:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000083e:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000842:	00008597          	auipc	a1,0x8
    80000846:	82e58593          	add	a1,a1,-2002 # 80008070 <digits+0x18>
    8000084a:	00011517          	auipc	a0,0x11
    8000084e:	0ae50513          	add	a0,a0,174 # 800118f8 <uart_tx_lock>
    80000852:	00000097          	auipc	ra,0x0
    80000856:	38e080e7          	jalr	910(ra) # 80000be0 <initlock>
}
    8000085a:	60a2                	ld	ra,8(sp)
    8000085c:	6402                	ld	s0,0(sp)
    8000085e:	0141                	add	sp,sp,16
    80000860:	8082                	ret

0000000080000862 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000862:	1101                	add	sp,sp,-32
    80000864:	ec06                	sd	ra,24(sp)
    80000866:	e822                	sd	s0,16(sp)
    80000868:	e426                	sd	s1,8(sp)
    8000086a:	1000                	add	s0,sp,32
    8000086c:	84aa                	mv	s1,a0
  push_off();
    8000086e:	00000097          	auipc	ra,0x0
    80000872:	3b6080e7          	jalr	950(ra) # 80000c24 <push_off>

  if(panicked){
    80000876:	00008797          	auipc	a5,0x8
    8000087a:	78a7a783          	lw	a5,1930(a5) # 80009000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000087e:	10000737          	lui	a4,0x10000
  if(panicked){
    80000882:	c391                	beqz	a5,80000886 <uartputc_sync+0x24>
    for(;;)
    80000884:	a001                	j	80000884 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000886:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000088a:	0207f793          	and	a5,a5,32
    8000088e:	dfe5                	beqz	a5,80000886 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000890:	0ff4f513          	zext.b	a0,s1
    80000894:	100007b7          	lui	a5,0x10000
    80000898:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000089c:	00000097          	auipc	ra,0x0
    800008a0:	428080e7          	jalr	1064(ra) # 80000cc4 <pop_off>
}
    800008a4:	60e2                	ld	ra,24(sp)
    800008a6:	6442                	ld	s0,16(sp)
    800008a8:	64a2                	ld	s1,8(sp)
    800008aa:	6105                	add	sp,sp,32
    800008ac:	8082                	ret

00000000800008ae <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800008ae:	00008797          	auipc	a5,0x8
    800008b2:	7567a783          	lw	a5,1878(a5) # 80009004 <uart_tx_r>
    800008b6:	00008717          	auipc	a4,0x8
    800008ba:	75272703          	lw	a4,1874(a4) # 80009008 <uart_tx_w>
    800008be:	08f70063          	beq	a4,a5,8000093e <uartstart+0x90>
{
    800008c2:	7139                	add	sp,sp,-64
    800008c4:	fc06                	sd	ra,56(sp)
    800008c6:	f822                	sd	s0,48(sp)
    800008c8:	f426                	sd	s1,40(sp)
    800008ca:	f04a                	sd	s2,32(sp)
    800008cc:	ec4e                	sd	s3,24(sp)
    800008ce:	e852                	sd	s4,16(sp)
    800008d0:	e456                	sd	s5,8(sp)
    800008d2:	0080                	add	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008d4:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r];
    800008d8:	00011a97          	auipc	s5,0x11
    800008dc:	020a8a93          	add	s5,s5,32 # 800118f8 <uart_tx_lock>
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    800008e0:	00008497          	auipc	s1,0x8
    800008e4:	72448493          	add	s1,s1,1828 # 80009004 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800008e8:	00008a17          	auipc	s4,0x8
    800008ec:	720a0a13          	add	s4,s4,1824 # 80009008 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008f0:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800008f4:	02077713          	and	a4,a4,32
    800008f8:	cb15                	beqz	a4,8000092c <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r];
    800008fa:	00fa8733          	add	a4,s5,a5
    800008fe:	01874983          	lbu	s3,24(a4)
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    80000902:	2785                	addw	a5,a5,1
    80000904:	41f7d71b          	sraw	a4,a5,0x1f
    80000908:	01b7571b          	srlw	a4,a4,0x1b
    8000090c:	9fb9                	addw	a5,a5,a4
    8000090e:	8bfd                	and	a5,a5,31
    80000910:	9f99                	subw	a5,a5,a4
    80000912:	c09c                	sw	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000914:	8526                	mv	a0,s1
    80000916:	00002097          	auipc	ra,0x2
    8000091a:	b04080e7          	jalr	-1276(ra) # 8000241a <wakeup>
    
    WriteReg(THR, c);
    8000091e:	01390023          	sb	s3,0(s2)
    if(uart_tx_w == uart_tx_r){
    80000922:	409c                	lw	a5,0(s1)
    80000924:	000a2703          	lw	a4,0(s4)
    80000928:	fcf714e3          	bne	a4,a5,800008f0 <uartstart+0x42>
  }
}
    8000092c:	70e2                	ld	ra,56(sp)
    8000092e:	7442                	ld	s0,48(sp)
    80000930:	74a2                	ld	s1,40(sp)
    80000932:	7902                	ld	s2,32(sp)
    80000934:	69e2                	ld	s3,24(sp)
    80000936:	6a42                	ld	s4,16(sp)
    80000938:	6aa2                	ld	s5,8(sp)
    8000093a:	6121                	add	sp,sp,64
    8000093c:	8082                	ret
    8000093e:	8082                	ret

0000000080000940 <uartputc>:
{
    80000940:	7179                	add	sp,sp,-48
    80000942:	f406                	sd	ra,40(sp)
    80000944:	f022                	sd	s0,32(sp)
    80000946:	ec26                	sd	s1,24(sp)
    80000948:	e84a                	sd	s2,16(sp)
    8000094a:	e44e                	sd	s3,8(sp)
    8000094c:	e052                	sd	s4,0(sp)
    8000094e:	1800                	add	s0,sp,48
    80000950:	84aa                	mv	s1,a0
  acquire(&uart_tx_lock);
    80000952:	00011517          	auipc	a0,0x11
    80000956:	fa650513          	add	a0,a0,-90 # 800118f8 <uart_tx_lock>
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	316080e7          	jalr	790(ra) # 80000c70 <acquire>
  if(panicked){
    80000962:	00008797          	auipc	a5,0x8
    80000966:	69e7a783          	lw	a5,1694(a5) # 80009000 <panicked>
    8000096a:	c391                	beqz	a5,8000096e <uartputc+0x2e>
    for(;;)
    8000096c:	a001                	j	8000096c <uartputc+0x2c>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    8000096e:	00008697          	auipc	a3,0x8
    80000972:	69a6a683          	lw	a3,1690(a3) # 80009008 <uart_tx_w>
    80000976:	0016879b          	addw	a5,a3,1
    8000097a:	41f7d71b          	sraw	a4,a5,0x1f
    8000097e:	01b7571b          	srlw	a4,a4,0x1b
    80000982:	9fb9                	addw	a5,a5,a4
    80000984:	8bfd                	and	a5,a5,31
    80000986:	9f99                	subw	a5,a5,a4
    80000988:	00008717          	auipc	a4,0x8
    8000098c:	67c72703          	lw	a4,1660(a4) # 80009004 <uart_tx_r>
    80000990:	04f71363          	bne	a4,a5,800009d6 <uartputc+0x96>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000994:	00011a17          	auipc	s4,0x11
    80000998:	f64a0a13          	add	s4,s4,-156 # 800118f8 <uart_tx_lock>
    8000099c:	00008917          	auipc	s2,0x8
    800009a0:	66890913          	add	s2,s2,1640 # 80009004 <uart_tx_r>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    800009a4:	00008997          	auipc	s3,0x8
    800009a8:	66498993          	add	s3,s3,1636 # 80009008 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800009ac:	85d2                	mv	a1,s4
    800009ae:	854a                	mv	a0,s2
    800009b0:	00002097          	auipc	ra,0x2
    800009b4:	8ea080e7          	jalr	-1814(ra) # 8000229a <sleep>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    800009b8:	0009a683          	lw	a3,0(s3)
    800009bc:	0016879b          	addw	a5,a3,1
    800009c0:	41f7d71b          	sraw	a4,a5,0x1f
    800009c4:	01b7571b          	srlw	a4,a4,0x1b
    800009c8:	9fb9                	addw	a5,a5,a4
    800009ca:	8bfd                	and	a5,a5,31
    800009cc:	9f99                	subw	a5,a5,a4
    800009ce:	00092703          	lw	a4,0(s2)
    800009d2:	fcf70de3          	beq	a4,a5,800009ac <uartputc+0x6c>
      uart_tx_buf[uart_tx_w] = c;
    800009d6:	00011917          	auipc	s2,0x11
    800009da:	f2290913          	add	s2,s2,-222 # 800118f8 <uart_tx_lock>
    800009de:	96ca                	add	a3,a3,s2
    800009e0:	00968c23          	sb	s1,24(a3)
      uart_tx_w = (uart_tx_w + 1) % UART_TX_BUF_SIZE;
    800009e4:	00008717          	auipc	a4,0x8
    800009e8:	62f72223          	sw	a5,1572(a4) # 80009008 <uart_tx_w>
      uartstart();
    800009ec:	00000097          	auipc	ra,0x0
    800009f0:	ec2080e7          	jalr	-318(ra) # 800008ae <uartstart>
      release(&uart_tx_lock);
    800009f4:	854a                	mv	a0,s2
    800009f6:	00000097          	auipc	ra,0x0
    800009fa:	32e080e7          	jalr	814(ra) # 80000d24 <release>
}
    800009fe:	70a2                	ld	ra,40(sp)
    80000a00:	7402                	ld	s0,32(sp)
    80000a02:	64e2                	ld	s1,24(sp)
    80000a04:	6942                	ld	s2,16(sp)
    80000a06:	69a2                	ld	s3,8(sp)
    80000a08:	6a02                	ld	s4,0(sp)
    80000a0a:	6145                	add	sp,sp,48
    80000a0c:	8082                	ret

0000000080000a0e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000a0e:	1141                	add	sp,sp,-16
    80000a10:	e422                	sd	s0,8(sp)
    80000a12:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000a14:	100007b7          	lui	a5,0x10000
    80000a18:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000a1c:	8b85                	and	a5,a5,1
    80000a1e:	cb81                	beqz	a5,80000a2e <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80000a20:	100007b7          	lui	a5,0x10000
    80000a24:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000a28:	6422                	ld	s0,8(sp)
    80000a2a:	0141                	add	sp,sp,16
    80000a2c:	8082                	ret
    return -1;
    80000a2e:	557d                	li	a0,-1
    80000a30:	bfe5                	j	80000a28 <uartgetc+0x1a>

0000000080000a32 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80000a32:	1101                	add	sp,sp,-32
    80000a34:	ec06                	sd	ra,24(sp)
    80000a36:	e822                	sd	s0,16(sp)
    80000a38:	e426                	sd	s1,8(sp)
    80000a3a:	1000                	add	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a3c:	54fd                	li	s1,-1
    80000a3e:	a029                	j	80000a48 <uartintr+0x16>
      break;
    consoleintr(c);
    80000a40:	00000097          	auipc	ra,0x0
    80000a44:	880080e7          	jalr	-1920(ra) # 800002c0 <consoleintr>
    int c = uartgetc();
    80000a48:	00000097          	auipc	ra,0x0
    80000a4c:	fc6080e7          	jalr	-58(ra) # 80000a0e <uartgetc>
    if(c == -1)
    80000a50:	fe9518e3          	bne	a0,s1,80000a40 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a54:	00011497          	auipc	s1,0x11
    80000a58:	ea448493          	add	s1,s1,-348 # 800118f8 <uart_tx_lock>
    80000a5c:	8526                	mv	a0,s1
    80000a5e:	00000097          	auipc	ra,0x0
    80000a62:	212080e7          	jalr	530(ra) # 80000c70 <acquire>
  uartstart();
    80000a66:	00000097          	auipc	ra,0x0
    80000a6a:	e48080e7          	jalr	-440(ra) # 800008ae <uartstart>
  release(&uart_tx_lock);
    80000a6e:	8526                	mv	a0,s1
    80000a70:	00000097          	auipc	ra,0x0
    80000a74:	2b4080e7          	jalr	692(ra) # 80000d24 <release>
}
    80000a78:	60e2                	ld	ra,24(sp)
    80000a7a:	6442                	ld	s0,16(sp)
    80000a7c:	64a2                	ld	s1,8(sp)
    80000a7e:	6105                	add	sp,sp,32
    80000a80:	8082                	ret

0000000080000a82 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a82:	1101                	add	sp,sp,-32
    80000a84:	ec06                	sd	ra,24(sp)
    80000a86:	e822                	sd	s0,16(sp)
    80000a88:	e426                	sd	s1,8(sp)
    80000a8a:	e04a                	sd	s2,0(sp)
    80000a8c:	1000                	add	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a8e:	03451793          	sll	a5,a0,0x34
    80000a92:	ebb9                	bnez	a5,80000ae8 <kfree+0x66>
    80000a94:	84aa                	mv	s1,a0
    80000a96:	00026797          	auipc	a5,0x26
    80000a9a:	56a78793          	add	a5,a5,1386 # 80027000 <end>
    80000a9e:	04f56563          	bltu	a0,a5,80000ae8 <kfree+0x66>
    80000aa2:	47c5                	li	a5,17
    80000aa4:	07ee                	sll	a5,a5,0x1b
    80000aa6:	04f57163          	bgeu	a0,a5,80000ae8 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000aaa:	6605                	lui	a2,0x1
    80000aac:	4585                	li	a1,1
    80000aae:	00000097          	auipc	ra,0x0
    80000ab2:	2be080e7          	jalr	702(ra) # 80000d6c <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000ab6:	00011917          	auipc	s2,0x11
    80000aba:	e7a90913          	add	s2,s2,-390 # 80011930 <kmem>
    80000abe:	854a                	mv	a0,s2
    80000ac0:	00000097          	auipc	ra,0x0
    80000ac4:	1b0080e7          	jalr	432(ra) # 80000c70 <acquire>
  r->next = kmem.freelist;
    80000ac8:	01893783          	ld	a5,24(s2)
    80000acc:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000ace:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000ad2:	854a                	mv	a0,s2
    80000ad4:	00000097          	auipc	ra,0x0
    80000ad8:	250080e7          	jalr	592(ra) # 80000d24 <release>
}
    80000adc:	60e2                	ld	ra,24(sp)
    80000ade:	6442                	ld	s0,16(sp)
    80000ae0:	64a2                	ld	s1,8(sp)
    80000ae2:	6902                	ld	s2,0(sp)
    80000ae4:	6105                	add	sp,sp,32
    80000ae6:	8082                	ret
    panic("kfree");
    80000ae8:	00007517          	auipc	a0,0x7
    80000aec:	59050513          	add	a0,a0,1424 # 80008078 <digits+0x20>
    80000af0:	00000097          	auipc	ra,0x0
    80000af4:	af0080e7          	jalr	-1296(ra) # 800005e0 <panic>

0000000080000af8 <freerange>:
{
    80000af8:	7179                	add	sp,sp,-48
    80000afa:	f406                	sd	ra,40(sp)
    80000afc:	f022                	sd	s0,32(sp)
    80000afe:	ec26                	sd	s1,24(sp)
    80000b00:	e84a                	sd	s2,16(sp)
    80000b02:	e44e                	sd	s3,8(sp)
    80000b04:	e052                	sd	s4,0(sp)
    80000b06:	1800                	add	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000b08:	6785                	lui	a5,0x1
    80000b0a:	fff78713          	add	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000b0e:	00e504b3          	add	s1,a0,a4
    80000b12:	777d                	lui	a4,0xfffff
    80000b14:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b16:	94be                	add	s1,s1,a5
    80000b18:	0095ee63          	bltu	a1,s1,80000b34 <freerange+0x3c>
    80000b1c:	892e                	mv	s2,a1
    kfree(p);
    80000b1e:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b20:	6985                	lui	s3,0x1
    kfree(p);
    80000b22:	01448533          	add	a0,s1,s4
    80000b26:	00000097          	auipc	ra,0x0
    80000b2a:	f5c080e7          	jalr	-164(ra) # 80000a82 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b2e:	94ce                	add	s1,s1,s3
    80000b30:	fe9979e3          	bgeu	s2,s1,80000b22 <freerange+0x2a>
}
    80000b34:	70a2                	ld	ra,40(sp)
    80000b36:	7402                	ld	s0,32(sp)
    80000b38:	64e2                	ld	s1,24(sp)
    80000b3a:	6942                	ld	s2,16(sp)
    80000b3c:	69a2                	ld	s3,8(sp)
    80000b3e:	6a02                	ld	s4,0(sp)
    80000b40:	6145                	add	sp,sp,48
    80000b42:	8082                	ret

0000000080000b44 <kinit>:
{
    80000b44:	1141                	add	sp,sp,-16
    80000b46:	e406                	sd	ra,8(sp)
    80000b48:	e022                	sd	s0,0(sp)
    80000b4a:	0800                	add	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b4c:	00007597          	auipc	a1,0x7
    80000b50:	53458593          	add	a1,a1,1332 # 80008080 <digits+0x28>
    80000b54:	00011517          	auipc	a0,0x11
    80000b58:	ddc50513          	add	a0,a0,-548 # 80011930 <kmem>
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	084080e7          	jalr	132(ra) # 80000be0 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b64:	45c5                	li	a1,17
    80000b66:	05ee                	sll	a1,a1,0x1b
    80000b68:	00026517          	auipc	a0,0x26
    80000b6c:	49850513          	add	a0,a0,1176 # 80027000 <end>
    80000b70:	00000097          	auipc	ra,0x0
    80000b74:	f88080e7          	jalr	-120(ra) # 80000af8 <freerange>
}
    80000b78:	60a2                	ld	ra,8(sp)
    80000b7a:	6402                	ld	s0,0(sp)
    80000b7c:	0141                	add	sp,sp,16
    80000b7e:	8082                	ret

0000000080000b80 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b80:	1101                	add	sp,sp,-32
    80000b82:	ec06                	sd	ra,24(sp)
    80000b84:	e822                	sd	s0,16(sp)
    80000b86:	e426                	sd	s1,8(sp)
    80000b88:	1000                	add	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b8a:	00011497          	auipc	s1,0x11
    80000b8e:	da648493          	add	s1,s1,-602 # 80011930 <kmem>
    80000b92:	8526                	mv	a0,s1
    80000b94:	00000097          	auipc	ra,0x0
    80000b98:	0dc080e7          	jalr	220(ra) # 80000c70 <acquire>
  r = kmem.freelist;
    80000b9c:	6c84                	ld	s1,24(s1)
  if(r)
    80000b9e:	c885                	beqz	s1,80000bce <kalloc+0x4e>
    kmem.freelist = r->next;
    80000ba0:	609c                	ld	a5,0(s1)
    80000ba2:	00011517          	auipc	a0,0x11
    80000ba6:	d8e50513          	add	a0,a0,-626 # 80011930 <kmem>
    80000baa:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000bac:	00000097          	auipc	ra,0x0
    80000bb0:	178080e7          	jalr	376(ra) # 80000d24 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000bb4:	6605                	lui	a2,0x1
    80000bb6:	4595                	li	a1,5
    80000bb8:	8526                	mv	a0,s1
    80000bba:	00000097          	auipc	ra,0x0
    80000bbe:	1b2080e7          	jalr	434(ra) # 80000d6c <memset>
  return (void*)r;
}
    80000bc2:	8526                	mv	a0,s1
    80000bc4:	60e2                	ld	ra,24(sp)
    80000bc6:	6442                	ld	s0,16(sp)
    80000bc8:	64a2                	ld	s1,8(sp)
    80000bca:	6105                	add	sp,sp,32
    80000bcc:	8082                	ret
  release(&kmem.lock);
    80000bce:	00011517          	auipc	a0,0x11
    80000bd2:	d6250513          	add	a0,a0,-670 # 80011930 <kmem>
    80000bd6:	00000097          	auipc	ra,0x0
    80000bda:	14e080e7          	jalr	334(ra) # 80000d24 <release>
  if(r)
    80000bde:	b7d5                	j	80000bc2 <kalloc+0x42>

0000000080000be0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000be0:	1141                	add	sp,sp,-16
    80000be2:	e422                	sd	s0,8(sp)
    80000be4:	0800                	add	s0,sp,16
  lk->name = name;
    80000be6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000be8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bec:	00053823          	sd	zero,16(a0)
}
    80000bf0:	6422                	ld	s0,8(sp)
    80000bf2:	0141                	add	sp,sp,16
    80000bf4:	8082                	ret

0000000080000bf6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bf6:	411c                	lw	a5,0(a0)
    80000bf8:	e399                	bnez	a5,80000bfe <holding+0x8>
    80000bfa:	4501                	li	a0,0
  return r;
}
    80000bfc:	8082                	ret
{
    80000bfe:	1101                	add	sp,sp,-32
    80000c00:	ec06                	sd	ra,24(sp)
    80000c02:	e822                	sd	s0,16(sp)
    80000c04:	e426                	sd	s1,8(sp)
    80000c06:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000c08:	6904                	ld	s1,16(a0)
    80000c0a:	00001097          	auipc	ra,0x1
    80000c0e:	e14080e7          	jalr	-492(ra) # 80001a1e <mycpu>
    80000c12:	40a48533          	sub	a0,s1,a0
    80000c16:	00153513          	seqz	a0,a0
}
    80000c1a:	60e2                	ld	ra,24(sp)
    80000c1c:	6442                	ld	s0,16(sp)
    80000c1e:	64a2                	ld	s1,8(sp)
    80000c20:	6105                	add	sp,sp,32
    80000c22:	8082                	ret

0000000080000c24 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000c24:	1101                	add	sp,sp,-32
    80000c26:	ec06                	sd	ra,24(sp)
    80000c28:	e822                	sd	s0,16(sp)
    80000c2a:	e426                	sd	s1,8(sp)
    80000c2c:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c2e:	100024f3          	csrr	s1,sstatus
    80000c32:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000c36:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c38:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000c3c:	00001097          	auipc	ra,0x1
    80000c40:	de2080e7          	jalr	-542(ra) # 80001a1e <mycpu>
    80000c44:	5d3c                	lw	a5,120(a0)
    80000c46:	cf89                	beqz	a5,80000c60 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c48:	00001097          	auipc	ra,0x1
    80000c4c:	dd6080e7          	jalr	-554(ra) # 80001a1e <mycpu>
    80000c50:	5d3c                	lw	a5,120(a0)
    80000c52:	2785                	addw	a5,a5,1
    80000c54:	dd3c                	sw	a5,120(a0)
}
    80000c56:	60e2                	ld	ra,24(sp)
    80000c58:	6442                	ld	s0,16(sp)
    80000c5a:	64a2                	ld	s1,8(sp)
    80000c5c:	6105                	add	sp,sp,32
    80000c5e:	8082                	ret
    mycpu()->intena = old;
    80000c60:	00001097          	auipc	ra,0x1
    80000c64:	dbe080e7          	jalr	-578(ra) # 80001a1e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c68:	8085                	srl	s1,s1,0x1
    80000c6a:	8885                	and	s1,s1,1
    80000c6c:	dd64                	sw	s1,124(a0)
    80000c6e:	bfe9                	j	80000c48 <push_off+0x24>

0000000080000c70 <acquire>:
{
    80000c70:	1101                	add	sp,sp,-32
    80000c72:	ec06                	sd	ra,24(sp)
    80000c74:	e822                	sd	s0,16(sp)
    80000c76:	e426                	sd	s1,8(sp)
    80000c78:	1000                	add	s0,sp,32
    80000c7a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c7c:	00000097          	auipc	ra,0x0
    80000c80:	fa8080e7          	jalr	-88(ra) # 80000c24 <push_off>
  if(holding(lk))
    80000c84:	8526                	mv	a0,s1
    80000c86:	00000097          	auipc	ra,0x0
    80000c8a:	f70080e7          	jalr	-144(ra) # 80000bf6 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c8e:	4705                	li	a4,1
  if(holding(lk))
    80000c90:	e115                	bnez	a0,80000cb4 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c92:	87ba                	mv	a5,a4
    80000c94:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c98:	2781                	sext.w	a5,a5
    80000c9a:	ffe5                	bnez	a5,80000c92 <acquire+0x22>
  __sync_synchronize();
    80000c9c:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000ca0:	00001097          	auipc	ra,0x1
    80000ca4:	d7e080e7          	jalr	-642(ra) # 80001a1e <mycpu>
    80000ca8:	e888                	sd	a0,16(s1)
}
    80000caa:	60e2                	ld	ra,24(sp)
    80000cac:	6442                	ld	s0,16(sp)
    80000cae:	64a2                	ld	s1,8(sp)
    80000cb0:	6105                	add	sp,sp,32
    80000cb2:	8082                	ret
    panic("acquire");
    80000cb4:	00007517          	auipc	a0,0x7
    80000cb8:	3d450513          	add	a0,a0,980 # 80008088 <digits+0x30>
    80000cbc:	00000097          	auipc	ra,0x0
    80000cc0:	924080e7          	jalr	-1756(ra) # 800005e0 <panic>

0000000080000cc4 <pop_off>:

void
pop_off(void)
{
    80000cc4:	1141                	add	sp,sp,-16
    80000cc6:	e406                	sd	ra,8(sp)
    80000cc8:	e022                	sd	s0,0(sp)
    80000cca:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    80000ccc:	00001097          	auipc	ra,0x1
    80000cd0:	d52080e7          	jalr	-686(ra) # 80001a1e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cd4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000cd8:	8b89                	and	a5,a5,2
  if(intr_get())
    80000cda:	e78d                	bnez	a5,80000d04 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000cdc:	5d3c                	lw	a5,120(a0)
    80000cde:	02f05b63          	blez	a5,80000d14 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000ce2:	37fd                	addw	a5,a5,-1
    80000ce4:	0007871b          	sext.w	a4,a5
    80000ce8:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000cea:	eb09                	bnez	a4,80000cfc <pop_off+0x38>
    80000cec:	5d7c                	lw	a5,124(a0)
    80000cee:	c799                	beqz	a5,80000cfc <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cf0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000cf4:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000cf8:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000cfc:	60a2                	ld	ra,8(sp)
    80000cfe:	6402                	ld	s0,0(sp)
    80000d00:	0141                	add	sp,sp,16
    80000d02:	8082                	ret
    panic("pop_off - interruptible");
    80000d04:	00007517          	auipc	a0,0x7
    80000d08:	38c50513          	add	a0,a0,908 # 80008090 <digits+0x38>
    80000d0c:	00000097          	auipc	ra,0x0
    80000d10:	8d4080e7          	jalr	-1836(ra) # 800005e0 <panic>
    panic("pop_off");
    80000d14:	00007517          	auipc	a0,0x7
    80000d18:	39450513          	add	a0,a0,916 # 800080a8 <digits+0x50>
    80000d1c:	00000097          	auipc	ra,0x0
    80000d20:	8c4080e7          	jalr	-1852(ra) # 800005e0 <panic>

0000000080000d24 <release>:
{
    80000d24:	1101                	add	sp,sp,-32
    80000d26:	ec06                	sd	ra,24(sp)
    80000d28:	e822                	sd	s0,16(sp)
    80000d2a:	e426                	sd	s1,8(sp)
    80000d2c:	1000                	add	s0,sp,32
    80000d2e:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000d30:	00000097          	auipc	ra,0x0
    80000d34:	ec6080e7          	jalr	-314(ra) # 80000bf6 <holding>
    80000d38:	c115                	beqz	a0,80000d5c <release+0x38>
  lk->cpu = 0;
    80000d3a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000d3e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000d42:	0f50000f          	fence	iorw,ow
    80000d46:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000d4a:	00000097          	auipc	ra,0x0
    80000d4e:	f7a080e7          	jalr	-134(ra) # 80000cc4 <pop_off>
}
    80000d52:	60e2                	ld	ra,24(sp)
    80000d54:	6442                	ld	s0,16(sp)
    80000d56:	64a2                	ld	s1,8(sp)
    80000d58:	6105                	add	sp,sp,32
    80000d5a:	8082                	ret
    panic("release");
    80000d5c:	00007517          	auipc	a0,0x7
    80000d60:	35450513          	add	a0,a0,852 # 800080b0 <digits+0x58>
    80000d64:	00000097          	auipc	ra,0x0
    80000d68:	87c080e7          	jalr	-1924(ra) # 800005e0 <panic>

0000000080000d6c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d6c:	1141                	add	sp,sp,-16
    80000d6e:	e422                	sd	s0,8(sp)
    80000d70:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d72:	ca19                	beqz	a2,80000d88 <memset+0x1c>
    80000d74:	87aa                	mv	a5,a0
    80000d76:	1602                	sll	a2,a2,0x20
    80000d78:	9201                	srl	a2,a2,0x20
    80000d7a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d7e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d82:	0785                	add	a5,a5,1
    80000d84:	fee79de3          	bne	a5,a4,80000d7e <memset+0x12>
  }
  return dst;
}
    80000d88:	6422                	ld	s0,8(sp)
    80000d8a:	0141                	add	sp,sp,16
    80000d8c:	8082                	ret

0000000080000d8e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d8e:	1141                	add	sp,sp,-16
    80000d90:	e422                	sd	s0,8(sp)
    80000d92:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d94:	ca05                	beqz	a2,80000dc4 <memcmp+0x36>
    80000d96:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d9a:	1682                	sll	a3,a3,0x20
    80000d9c:	9281                	srl	a3,a3,0x20
    80000d9e:	0685                	add	a3,a3,1
    80000da0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000da2:	00054783          	lbu	a5,0(a0)
    80000da6:	0005c703          	lbu	a4,0(a1)
    80000daa:	00e79863          	bne	a5,a4,80000dba <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000dae:	0505                	add	a0,a0,1
    80000db0:	0585                	add	a1,a1,1
  while(n-- > 0){
    80000db2:	fed518e3          	bne	a0,a3,80000da2 <memcmp+0x14>
  }

  return 0;
    80000db6:	4501                	li	a0,0
    80000db8:	a019                	j	80000dbe <memcmp+0x30>
      return *s1 - *s2;
    80000dba:	40e7853b          	subw	a0,a5,a4
}
    80000dbe:	6422                	ld	s0,8(sp)
    80000dc0:	0141                	add	sp,sp,16
    80000dc2:	8082                	ret
  return 0;
    80000dc4:	4501                	li	a0,0
    80000dc6:	bfe5                	j	80000dbe <memcmp+0x30>

0000000080000dc8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000dc8:	1141                	add	sp,sp,-16
    80000dca:	e422                	sd	s0,8(sp)
    80000dcc:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000dce:	02a5e563          	bltu	a1,a0,80000df8 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000dd2:	fff6069b          	addw	a3,a2,-1
    80000dd6:	ce11                	beqz	a2,80000df2 <memmove+0x2a>
    80000dd8:	1682                	sll	a3,a3,0x20
    80000dda:	9281                	srl	a3,a3,0x20
    80000ddc:	0685                	add	a3,a3,1
    80000dde:	96ae                	add	a3,a3,a1
    80000de0:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000de2:	0585                	add	a1,a1,1
    80000de4:	0785                	add	a5,a5,1
    80000de6:	fff5c703          	lbu	a4,-1(a1)
    80000dea:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000dee:	fed59ae3          	bne	a1,a3,80000de2 <memmove+0x1a>

  return dst;
}
    80000df2:	6422                	ld	s0,8(sp)
    80000df4:	0141                	add	sp,sp,16
    80000df6:	8082                	ret
  if(s < d && s + n > d){
    80000df8:	02061713          	sll	a4,a2,0x20
    80000dfc:	9301                	srl	a4,a4,0x20
    80000dfe:	00e587b3          	add	a5,a1,a4
    80000e02:	fcf578e3          	bgeu	a0,a5,80000dd2 <memmove+0xa>
    d += n;
    80000e06:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000e08:	fff6069b          	addw	a3,a2,-1
    80000e0c:	d27d                	beqz	a2,80000df2 <memmove+0x2a>
    80000e0e:	02069613          	sll	a2,a3,0x20
    80000e12:	9201                	srl	a2,a2,0x20
    80000e14:	fff64613          	not	a2,a2
    80000e18:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000e1a:	17fd                	add	a5,a5,-1
    80000e1c:	177d                	add	a4,a4,-1 # ffffffffffffefff <end+0xffffffff7ffd7fff>
    80000e1e:	0007c683          	lbu	a3,0(a5)
    80000e22:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000e26:	fef61ae3          	bne	a2,a5,80000e1a <memmove+0x52>
    80000e2a:	b7e1                	j	80000df2 <memmove+0x2a>

0000000080000e2c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000e2c:	1141                	add	sp,sp,-16
    80000e2e:	e406                	sd	ra,8(sp)
    80000e30:	e022                	sd	s0,0(sp)
    80000e32:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    80000e34:	00000097          	auipc	ra,0x0
    80000e38:	f94080e7          	jalr	-108(ra) # 80000dc8 <memmove>
}
    80000e3c:	60a2                	ld	ra,8(sp)
    80000e3e:	6402                	ld	s0,0(sp)
    80000e40:	0141                	add	sp,sp,16
    80000e42:	8082                	ret

0000000080000e44 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e44:	1141                	add	sp,sp,-16
    80000e46:	e422                	sd	s0,8(sp)
    80000e48:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e4a:	ce11                	beqz	a2,80000e66 <strncmp+0x22>
    80000e4c:	00054783          	lbu	a5,0(a0)
    80000e50:	cf89                	beqz	a5,80000e6a <strncmp+0x26>
    80000e52:	0005c703          	lbu	a4,0(a1)
    80000e56:	00f71a63          	bne	a4,a5,80000e6a <strncmp+0x26>
    n--, p++, q++;
    80000e5a:	367d                	addw	a2,a2,-1
    80000e5c:	0505                	add	a0,a0,1
    80000e5e:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e60:	f675                	bnez	a2,80000e4c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000e62:	4501                	li	a0,0
    80000e64:	a809                	j	80000e76 <strncmp+0x32>
    80000e66:	4501                	li	a0,0
    80000e68:	a039                	j	80000e76 <strncmp+0x32>
  if(n == 0)
    80000e6a:	ca09                	beqz	a2,80000e7c <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000e6c:	00054503          	lbu	a0,0(a0)
    80000e70:	0005c783          	lbu	a5,0(a1)
    80000e74:	9d1d                	subw	a0,a0,a5
}
    80000e76:	6422                	ld	s0,8(sp)
    80000e78:	0141                	add	sp,sp,16
    80000e7a:	8082                	ret
    return 0;
    80000e7c:	4501                	li	a0,0
    80000e7e:	bfe5                	j	80000e76 <strncmp+0x32>

0000000080000e80 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e80:	1141                	add	sp,sp,-16
    80000e82:	e422                	sd	s0,8(sp)
    80000e84:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e86:	87aa                	mv	a5,a0
    80000e88:	86b2                	mv	a3,a2
    80000e8a:	367d                	addw	a2,a2,-1
    80000e8c:	00d05963          	blez	a3,80000e9e <strncpy+0x1e>
    80000e90:	0785                	add	a5,a5,1
    80000e92:	0005c703          	lbu	a4,0(a1)
    80000e96:	fee78fa3          	sb	a4,-1(a5)
    80000e9a:	0585                	add	a1,a1,1
    80000e9c:	f775                	bnez	a4,80000e88 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e9e:	873e                	mv	a4,a5
    80000ea0:	9fb5                	addw	a5,a5,a3
    80000ea2:	37fd                	addw	a5,a5,-1
    80000ea4:	00c05963          	blez	a2,80000eb6 <strncpy+0x36>
    *s++ = 0;
    80000ea8:	0705                	add	a4,a4,1
    80000eaa:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000eae:	40e786bb          	subw	a3,a5,a4
    80000eb2:	fed04be3          	bgtz	a3,80000ea8 <strncpy+0x28>
  return os;
}
    80000eb6:	6422                	ld	s0,8(sp)
    80000eb8:	0141                	add	sp,sp,16
    80000eba:	8082                	ret

0000000080000ebc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000ebc:	1141                	add	sp,sp,-16
    80000ebe:	e422                	sd	s0,8(sp)
    80000ec0:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000ec2:	02c05363          	blez	a2,80000ee8 <safestrcpy+0x2c>
    80000ec6:	fff6069b          	addw	a3,a2,-1
    80000eca:	1682                	sll	a3,a3,0x20
    80000ecc:	9281                	srl	a3,a3,0x20
    80000ece:	96ae                	add	a3,a3,a1
    80000ed0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000ed2:	00d58963          	beq	a1,a3,80000ee4 <safestrcpy+0x28>
    80000ed6:	0585                	add	a1,a1,1
    80000ed8:	0785                	add	a5,a5,1
    80000eda:	fff5c703          	lbu	a4,-1(a1)
    80000ede:	fee78fa3          	sb	a4,-1(a5)
    80000ee2:	fb65                	bnez	a4,80000ed2 <safestrcpy+0x16>
    ;
  *s = 0;
    80000ee4:	00078023          	sb	zero,0(a5)
  return os;
}
    80000ee8:	6422                	ld	s0,8(sp)
    80000eea:	0141                	add	sp,sp,16
    80000eec:	8082                	ret

0000000080000eee <strlen>:

int
strlen(const char *s)
{
    80000eee:	1141                	add	sp,sp,-16
    80000ef0:	e422                	sd	s0,8(sp)
    80000ef2:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000ef4:	00054783          	lbu	a5,0(a0)
    80000ef8:	cf91                	beqz	a5,80000f14 <strlen+0x26>
    80000efa:	0505                	add	a0,a0,1
    80000efc:	87aa                	mv	a5,a0
    80000efe:	86be                	mv	a3,a5
    80000f00:	0785                	add	a5,a5,1
    80000f02:	fff7c703          	lbu	a4,-1(a5)
    80000f06:	ff65                	bnez	a4,80000efe <strlen+0x10>
    80000f08:	40a6853b          	subw	a0,a3,a0
    80000f0c:	2505                	addw	a0,a0,1
    ;
  return n;
}
    80000f0e:	6422                	ld	s0,8(sp)
    80000f10:	0141                	add	sp,sp,16
    80000f12:	8082                	ret
  for(n = 0; s[n]; n++)
    80000f14:	4501                	li	a0,0
    80000f16:	bfe5                	j	80000f0e <strlen+0x20>

0000000080000f18 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000f18:	1141                	add	sp,sp,-16
    80000f1a:	e406                	sd	ra,8(sp)
    80000f1c:	e022                	sd	s0,0(sp)
    80000f1e:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    80000f20:	00001097          	auipc	ra,0x1
    80000f24:	aee080e7          	jalr	-1298(ra) # 80001a0e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000f28:	00008717          	auipc	a4,0x8
    80000f2c:	0e470713          	add	a4,a4,228 # 8000900c <started>
  if(cpuid() == 0){
    80000f30:	c139                	beqz	a0,80000f76 <main+0x5e>
    while(started == 0)
    80000f32:	431c                	lw	a5,0(a4)
    80000f34:	2781                	sext.w	a5,a5
    80000f36:	dff5                	beqz	a5,80000f32 <main+0x1a>
      ;
    __sync_synchronize();
    80000f38:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000f3c:	00001097          	auipc	ra,0x1
    80000f40:	ad2080e7          	jalr	-1326(ra) # 80001a0e <cpuid>
    80000f44:	85aa                	mv	a1,a0
    80000f46:	00007517          	auipc	a0,0x7
    80000f4a:	18a50513          	add	a0,a0,394 # 800080d0 <digits+0x78>
    80000f4e:	fffff097          	auipc	ra,0xfffff
    80000f52:	6e4080e7          	jalr	1764(ra) # 80000632 <printf>
    kvminithart();    // turn on paging
    80000f56:	00000097          	auipc	ra,0x0
    80000f5a:	0d8080e7          	jalr	216(ra) # 8000102e <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f5e:	00001097          	auipc	ra,0x1
    80000f62:	784080e7          	jalr	1924(ra) # 800026e2 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f66:	00005097          	auipc	ra,0x5
    80000f6a:	e1a080e7          	jalr	-486(ra) # 80005d80 <plicinithart>
  }

  scheduler();        
    80000f6e:	00001097          	auipc	ra,0x1
    80000f72:	050080e7          	jalr	80(ra) # 80001fbe <scheduler>
    consoleinit();
    80000f76:	fffff097          	auipc	ra,0xfffff
    80000f7a:	4dc080e7          	jalr	1244(ra) # 80000452 <consoleinit>
    printfinit();
    80000f7e:	fffff097          	auipc	ra,0xfffff
    80000f82:	5c4080e7          	jalr	1476(ra) # 80000542 <printfinit>
    printf("\n");
    80000f86:	00007517          	auipc	a0,0x7
    80000f8a:	15a50513          	add	a0,a0,346 # 800080e0 <digits+0x88>
    80000f8e:	fffff097          	auipc	ra,0xfffff
    80000f92:	6a4080e7          	jalr	1700(ra) # 80000632 <printf>
    printf("xv6 kernel is booting\n");
    80000f96:	00007517          	auipc	a0,0x7
    80000f9a:	12250513          	add	a0,a0,290 # 800080b8 <digits+0x60>
    80000f9e:	fffff097          	auipc	ra,0xfffff
    80000fa2:	694080e7          	jalr	1684(ra) # 80000632 <printf>
    printf("\n");
    80000fa6:	00007517          	auipc	a0,0x7
    80000faa:	13a50513          	add	a0,a0,314 # 800080e0 <digits+0x88>
    80000fae:	fffff097          	auipc	ra,0xfffff
    80000fb2:	684080e7          	jalr	1668(ra) # 80000632 <printf>
    kinit();         // physical page allocator
    80000fb6:	00000097          	auipc	ra,0x0
    80000fba:	b8e080e7          	jalr	-1138(ra) # 80000b44 <kinit>
    kvminit();       // create kernel page table
    80000fbe:	00000097          	auipc	ra,0x0
    80000fc2:	2a0080e7          	jalr	672(ra) # 8000125e <kvminit>
    kvminithart();   // turn on paging
    80000fc6:	00000097          	auipc	ra,0x0
    80000fca:	068080e7          	jalr	104(ra) # 8000102e <kvminithart>
    procinit();      // process table
    80000fce:	00001097          	auipc	ra,0x1
    80000fd2:	970080e7          	jalr	-1680(ra) # 8000193e <procinit>
    trapinit();      // trap vectors
    80000fd6:	00001097          	auipc	ra,0x1
    80000fda:	6e4080e7          	jalr	1764(ra) # 800026ba <trapinit>
    trapinithart();  // install kernel trap vector
    80000fde:	00001097          	auipc	ra,0x1
    80000fe2:	704080e7          	jalr	1796(ra) # 800026e2 <trapinithart>
    plicinit();      // set up interrupt controller
    80000fe6:	00005097          	auipc	ra,0x5
    80000fea:	d84080e7          	jalr	-636(ra) # 80005d6a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fee:	00005097          	auipc	ra,0x5
    80000ff2:	d92080e7          	jalr	-622(ra) # 80005d80 <plicinithart>
    binit();         // buffer cache
    80000ff6:	00002097          	auipc	ra,0x2
    80000ffa:	f96080e7          	jalr	-106(ra) # 80002f8c <binit>
    iinit();         // inode cache
    80000ffe:	00002097          	auipc	ra,0x2
    80001002:	622080e7          	jalr	1570(ra) # 80003620 <iinit>
    fileinit();      // file table
    80001006:	00003097          	auipc	ra,0x3
    8000100a:	594080e7          	jalr	1428(ra) # 8000459a <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000100e:	00005097          	auipc	ra,0x5
    80001012:	e78080e7          	jalr	-392(ra) # 80005e86 <virtio_disk_init>
    userinit();      // first user process
    80001016:	00001097          	auipc	ra,0x1
    8000101a:	d3a080e7          	jalr	-710(ra) # 80001d50 <userinit>
    __sync_synchronize();
    8000101e:	0ff0000f          	fence
    started = 1;
    80001022:	4785                	li	a5,1
    80001024:	00008717          	auipc	a4,0x8
    80001028:	fef72423          	sw	a5,-24(a4) # 8000900c <started>
    8000102c:	b789                	j	80000f6e <main+0x56>

000000008000102e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000102e:	1141                	add	sp,sp,-16
    80001030:	e422                	sd	s0,8(sp)
    80001032:	0800                	add	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80001034:	00008797          	auipc	a5,0x8
    80001038:	fdc7b783          	ld	a5,-36(a5) # 80009010 <kernel_pagetable>
    8000103c:	83b1                	srl	a5,a5,0xc
    8000103e:	577d                	li	a4,-1
    80001040:	177e                	sll	a4,a4,0x3f
    80001042:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001044:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80001048:	12000073          	sfence.vma
  sfence_vma();
}
    8000104c:	6422                	ld	s0,8(sp)
    8000104e:	0141                	add	sp,sp,16
    80001050:	8082                	ret

0000000080001052 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001052:	7139                	add	sp,sp,-64
    80001054:	fc06                	sd	ra,56(sp)
    80001056:	f822                	sd	s0,48(sp)
    80001058:	f426                	sd	s1,40(sp)
    8000105a:	f04a                	sd	s2,32(sp)
    8000105c:	ec4e                	sd	s3,24(sp)
    8000105e:	e852                	sd	s4,16(sp)
    80001060:	e456                	sd	s5,8(sp)
    80001062:	e05a                	sd	s6,0(sp)
    80001064:	0080                	add	s0,sp,64
    80001066:	84aa                	mv	s1,a0
    80001068:	89ae                	mv	s3,a1
    8000106a:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000106c:	57fd                	li	a5,-1
    8000106e:	83e9                	srl	a5,a5,0x1a
    80001070:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001072:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001074:	04b7f263          	bgeu	a5,a1,800010b8 <walk+0x66>
    panic("walk");
    80001078:	00007517          	auipc	a0,0x7
    8000107c:	07050513          	add	a0,a0,112 # 800080e8 <digits+0x90>
    80001080:	fffff097          	auipc	ra,0xfffff
    80001084:	560080e7          	jalr	1376(ra) # 800005e0 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001088:	060a8663          	beqz	s5,800010f4 <walk+0xa2>
    8000108c:	00000097          	auipc	ra,0x0
    80001090:	af4080e7          	jalr	-1292(ra) # 80000b80 <kalloc>
    80001094:	84aa                	mv	s1,a0
    80001096:	c529                	beqz	a0,800010e0 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001098:	6605                	lui	a2,0x1
    8000109a:	4581                	li	a1,0
    8000109c:	00000097          	auipc	ra,0x0
    800010a0:	cd0080e7          	jalr	-816(ra) # 80000d6c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800010a4:	00c4d793          	srl	a5,s1,0xc
    800010a8:	07aa                	sll	a5,a5,0xa
    800010aa:	0017e793          	or	a5,a5,1
    800010ae:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800010b2:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd7ff7>
    800010b4:	036a0063          	beq	s4,s6,800010d4 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800010b8:	0149d933          	srl	s2,s3,s4
    800010bc:	1ff97913          	and	s2,s2,511
    800010c0:	090e                	sll	s2,s2,0x3
    800010c2:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800010c4:	00093483          	ld	s1,0(s2)
    800010c8:	0014f793          	and	a5,s1,1
    800010cc:	dfd5                	beqz	a5,80001088 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800010ce:	80a9                	srl	s1,s1,0xa
    800010d0:	04b2                	sll	s1,s1,0xc
    800010d2:	b7c5                	j	800010b2 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800010d4:	00c9d513          	srl	a0,s3,0xc
    800010d8:	1ff57513          	and	a0,a0,511
    800010dc:	050e                	sll	a0,a0,0x3
    800010de:	9526                	add	a0,a0,s1
}
    800010e0:	70e2                	ld	ra,56(sp)
    800010e2:	7442                	ld	s0,48(sp)
    800010e4:	74a2                	ld	s1,40(sp)
    800010e6:	7902                	ld	s2,32(sp)
    800010e8:	69e2                	ld	s3,24(sp)
    800010ea:	6a42                	ld	s4,16(sp)
    800010ec:	6aa2                	ld	s5,8(sp)
    800010ee:	6b02                	ld	s6,0(sp)
    800010f0:	6121                	add	sp,sp,64
    800010f2:	8082                	ret
        return 0;
    800010f4:	4501                	li	a0,0
    800010f6:	b7ed                	j	800010e0 <walk+0x8e>

00000000800010f8 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800010f8:	57fd                	li	a5,-1
    800010fa:	83e9                	srl	a5,a5,0x1a
    800010fc:	00b7f463          	bgeu	a5,a1,80001104 <walkaddr+0xc>
    return 0;
    80001100:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001102:	8082                	ret
{
    80001104:	1141                	add	sp,sp,-16
    80001106:	e406                	sd	ra,8(sp)
    80001108:	e022                	sd	s0,0(sp)
    8000110a:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000110c:	4601                	li	a2,0
    8000110e:	00000097          	auipc	ra,0x0
    80001112:	f44080e7          	jalr	-188(ra) # 80001052 <walk>
  if(pte == 0)
    80001116:	c105                	beqz	a0,80001136 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001118:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000111a:	0117f693          	and	a3,a5,17
    8000111e:	4745                	li	a4,17
    return 0;
    80001120:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001122:	00e68663          	beq	a3,a4,8000112e <walkaddr+0x36>
}
    80001126:	60a2                	ld	ra,8(sp)
    80001128:	6402                	ld	s0,0(sp)
    8000112a:	0141                	add	sp,sp,16
    8000112c:	8082                	ret
  pa = PTE2PA(*pte);
    8000112e:	83a9                	srl	a5,a5,0xa
    80001130:	00c79513          	sll	a0,a5,0xc
  return pa;
    80001134:	bfcd                	j	80001126 <walkaddr+0x2e>
    return 0;
    80001136:	4501                	li	a0,0
    80001138:	b7fd                	j	80001126 <walkaddr+0x2e>

000000008000113a <kvmpa>:
// a physical address. only needed for
// addresses on the stack.
// assumes va is page aligned.
uint64
kvmpa(uint64 va)
{
    8000113a:	1101                	add	sp,sp,-32
    8000113c:	ec06                	sd	ra,24(sp)
    8000113e:	e822                	sd	s0,16(sp)
    80001140:	e426                	sd	s1,8(sp)
    80001142:	1000                	add	s0,sp,32
    80001144:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    80001146:	1552                	sll	a0,a0,0x34
    80001148:	03455493          	srl	s1,a0,0x34
  pte_t *pte;
  uint64 pa;
  
  pte = walk(kernel_pagetable, va, 0);
    8000114c:	4601                	li	a2,0
    8000114e:	00008517          	auipc	a0,0x8
    80001152:	ec253503          	ld	a0,-318(a0) # 80009010 <kernel_pagetable>
    80001156:	00000097          	auipc	ra,0x0
    8000115a:	efc080e7          	jalr	-260(ra) # 80001052 <walk>
  if(pte == 0)
    8000115e:	cd09                	beqz	a0,80001178 <kvmpa+0x3e>
    panic("kvmpa");
  if((*pte & PTE_V) == 0)
    80001160:	6108                	ld	a0,0(a0)
    80001162:	00157793          	and	a5,a0,1
    80001166:	c38d                	beqz	a5,80001188 <kvmpa+0x4e>
    panic("kvmpa");
  pa = PTE2PA(*pte);
    80001168:	8129                	srl	a0,a0,0xa
    8000116a:	0532                	sll	a0,a0,0xc
  return pa+off;
}
    8000116c:	9526                	add	a0,a0,s1
    8000116e:	60e2                	ld	ra,24(sp)
    80001170:	6442                	ld	s0,16(sp)
    80001172:	64a2                	ld	s1,8(sp)
    80001174:	6105                	add	sp,sp,32
    80001176:	8082                	ret
    panic("kvmpa");
    80001178:	00007517          	auipc	a0,0x7
    8000117c:	f7850513          	add	a0,a0,-136 # 800080f0 <digits+0x98>
    80001180:	fffff097          	auipc	ra,0xfffff
    80001184:	460080e7          	jalr	1120(ra) # 800005e0 <panic>
    panic("kvmpa");
    80001188:	00007517          	auipc	a0,0x7
    8000118c:	f6850513          	add	a0,a0,-152 # 800080f0 <digits+0x98>
    80001190:	fffff097          	auipc	ra,0xfffff
    80001194:	450080e7          	jalr	1104(ra) # 800005e0 <panic>

0000000080001198 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001198:	715d                	add	sp,sp,-80
    8000119a:	e486                	sd	ra,72(sp)
    8000119c:	e0a2                	sd	s0,64(sp)
    8000119e:	fc26                	sd	s1,56(sp)
    800011a0:	f84a                	sd	s2,48(sp)
    800011a2:	f44e                	sd	s3,40(sp)
    800011a4:	f052                	sd	s4,32(sp)
    800011a6:	ec56                	sd	s5,24(sp)
    800011a8:	e85a                	sd	s6,16(sp)
    800011aa:	e45e                	sd	s7,8(sp)
    800011ac:	0880                	add	s0,sp,80
    800011ae:	8aaa                	mv	s5,a0
    800011b0:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    800011b2:	777d                	lui	a4,0xfffff
    800011b4:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800011b8:	fff60993          	add	s3,a2,-1 # fff <_entry-0x7ffff001>
    800011bc:	99ae                	add	s3,s3,a1
    800011be:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800011c2:	893e                	mv	s2,a5
    800011c4:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800011c8:	6b85                	lui	s7,0x1
    800011ca:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800011ce:	4605                	li	a2,1
    800011d0:	85ca                	mv	a1,s2
    800011d2:	8556                	mv	a0,s5
    800011d4:	00000097          	auipc	ra,0x0
    800011d8:	e7e080e7          	jalr	-386(ra) # 80001052 <walk>
    800011dc:	c51d                	beqz	a0,8000120a <mappages+0x72>
    if(*pte & PTE_V)
    800011de:	611c                	ld	a5,0(a0)
    800011e0:	8b85                	and	a5,a5,1
    800011e2:	ef81                	bnez	a5,800011fa <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800011e4:	80b1                	srl	s1,s1,0xc
    800011e6:	04aa                	sll	s1,s1,0xa
    800011e8:	0164e4b3          	or	s1,s1,s6
    800011ec:	0014e493          	or	s1,s1,1
    800011f0:	e104                	sd	s1,0(a0)
    if(a == last)
    800011f2:	03390863          	beq	s2,s3,80001222 <mappages+0x8a>
    a += PGSIZE;
    800011f6:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800011f8:	bfc9                	j	800011ca <mappages+0x32>
      panic("remap");
    800011fa:	00007517          	auipc	a0,0x7
    800011fe:	efe50513          	add	a0,a0,-258 # 800080f8 <digits+0xa0>
    80001202:	fffff097          	auipc	ra,0xfffff
    80001206:	3de080e7          	jalr	990(ra) # 800005e0 <panic>
      return -1;
    8000120a:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000120c:	60a6                	ld	ra,72(sp)
    8000120e:	6406                	ld	s0,64(sp)
    80001210:	74e2                	ld	s1,56(sp)
    80001212:	7942                	ld	s2,48(sp)
    80001214:	79a2                	ld	s3,40(sp)
    80001216:	7a02                	ld	s4,32(sp)
    80001218:	6ae2                	ld	s5,24(sp)
    8000121a:	6b42                	ld	s6,16(sp)
    8000121c:	6ba2                	ld	s7,8(sp)
    8000121e:	6161                	add	sp,sp,80
    80001220:	8082                	ret
  return 0;
    80001222:	4501                	li	a0,0
    80001224:	b7e5                	j	8000120c <mappages+0x74>

0000000080001226 <kvmmap>:
{
    80001226:	1141                	add	sp,sp,-16
    80001228:	e406                	sd	ra,8(sp)
    8000122a:	e022                	sd	s0,0(sp)
    8000122c:	0800                	add	s0,sp,16
    8000122e:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    80001230:	86ae                	mv	a3,a1
    80001232:	85aa                	mv	a1,a0
    80001234:	00008517          	auipc	a0,0x8
    80001238:	ddc53503          	ld	a0,-548(a0) # 80009010 <kernel_pagetable>
    8000123c:	00000097          	auipc	ra,0x0
    80001240:	f5c080e7          	jalr	-164(ra) # 80001198 <mappages>
    80001244:	e509                	bnez	a0,8000124e <kvmmap+0x28>
}
    80001246:	60a2                	ld	ra,8(sp)
    80001248:	6402                	ld	s0,0(sp)
    8000124a:	0141                	add	sp,sp,16
    8000124c:	8082                	ret
    panic("kvmmap");
    8000124e:	00007517          	auipc	a0,0x7
    80001252:	eb250513          	add	a0,a0,-334 # 80008100 <digits+0xa8>
    80001256:	fffff097          	auipc	ra,0xfffff
    8000125a:	38a080e7          	jalr	906(ra) # 800005e0 <panic>

000000008000125e <kvminit>:
{
    8000125e:	1101                	add	sp,sp,-32
    80001260:	ec06                	sd	ra,24(sp)
    80001262:	e822                	sd	s0,16(sp)
    80001264:	e426                	sd	s1,8(sp)
    80001266:	1000                	add	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    80001268:	00000097          	auipc	ra,0x0
    8000126c:	918080e7          	jalr	-1768(ra) # 80000b80 <kalloc>
    80001270:	00008717          	auipc	a4,0x8
    80001274:	daa73023          	sd	a0,-608(a4) # 80009010 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    80001278:	6605                	lui	a2,0x1
    8000127a:	4581                	li	a1,0
    8000127c:	00000097          	auipc	ra,0x0
    80001280:	af0080e7          	jalr	-1296(ra) # 80000d6c <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001284:	4699                	li	a3,6
    80001286:	6605                	lui	a2,0x1
    80001288:	100005b7          	lui	a1,0x10000
    8000128c:	10000537          	lui	a0,0x10000
    80001290:	00000097          	auipc	ra,0x0
    80001294:	f96080e7          	jalr	-106(ra) # 80001226 <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001298:	4699                	li	a3,6
    8000129a:	6605                	lui	a2,0x1
    8000129c:	100015b7          	lui	a1,0x10001
    800012a0:	10001537          	lui	a0,0x10001
    800012a4:	00000097          	auipc	ra,0x0
    800012a8:	f82080e7          	jalr	-126(ra) # 80001226 <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    800012ac:	4699                	li	a3,6
    800012ae:	6641                	lui	a2,0x10
    800012b0:	020005b7          	lui	a1,0x2000
    800012b4:	02000537          	lui	a0,0x2000
    800012b8:	00000097          	auipc	ra,0x0
    800012bc:	f6e080e7          	jalr	-146(ra) # 80001226 <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800012c0:	4699                	li	a3,6
    800012c2:	00400637          	lui	a2,0x400
    800012c6:	0c0005b7          	lui	a1,0xc000
    800012ca:	0c000537          	lui	a0,0xc000
    800012ce:	00000097          	auipc	ra,0x0
    800012d2:	f58080e7          	jalr	-168(ra) # 80001226 <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800012d6:	00007497          	auipc	s1,0x7
    800012da:	d2a48493          	add	s1,s1,-726 # 80008000 <etext>
    800012de:	46a9                	li	a3,10
    800012e0:	80007617          	auipc	a2,0x80007
    800012e4:	d2060613          	add	a2,a2,-736 # 8000 <_entry-0x7fff8000>
    800012e8:	4585                	li	a1,1
    800012ea:	05fe                	sll	a1,a1,0x1f
    800012ec:	852e                	mv	a0,a1
    800012ee:	00000097          	auipc	ra,0x0
    800012f2:	f38080e7          	jalr	-200(ra) # 80001226 <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800012f6:	4699                	li	a3,6
    800012f8:	4645                	li	a2,17
    800012fa:	066e                	sll	a2,a2,0x1b
    800012fc:	8e05                	sub	a2,a2,s1
    800012fe:	85a6                	mv	a1,s1
    80001300:	8526                	mv	a0,s1
    80001302:	00000097          	auipc	ra,0x0
    80001306:	f24080e7          	jalr	-220(ra) # 80001226 <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000130a:	46a9                	li	a3,10
    8000130c:	6605                	lui	a2,0x1
    8000130e:	00006597          	auipc	a1,0x6
    80001312:	cf258593          	add	a1,a1,-782 # 80007000 <_trampoline>
    80001316:	04000537          	lui	a0,0x4000
    8000131a:	157d                	add	a0,a0,-1 # 3ffffff <_entry-0x7c000001>
    8000131c:	0532                	sll	a0,a0,0xc
    8000131e:	00000097          	auipc	ra,0x0
    80001322:	f08080e7          	jalr	-248(ra) # 80001226 <kvmmap>
}
    80001326:	60e2                	ld	ra,24(sp)
    80001328:	6442                	ld	s0,16(sp)
    8000132a:	64a2                	ld	s1,8(sp)
    8000132c:	6105                	add	sp,sp,32
    8000132e:	8082                	ret

0000000080001330 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001330:	715d                	add	sp,sp,-80
    80001332:	e486                	sd	ra,72(sp)
    80001334:	e0a2                	sd	s0,64(sp)
    80001336:	fc26                	sd	s1,56(sp)
    80001338:	f84a                	sd	s2,48(sp)
    8000133a:	f44e                	sd	s3,40(sp)
    8000133c:	f052                	sd	s4,32(sp)
    8000133e:	ec56                	sd	s5,24(sp)
    80001340:	e85a                	sd	s6,16(sp)
    80001342:	e45e                	sd	s7,8(sp)
    80001344:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001346:	03459793          	sll	a5,a1,0x34
    8000134a:	e795                	bnez	a5,80001376 <uvmunmap+0x46>
    8000134c:	8a2a                	mv	s4,a0
    8000134e:	892e                	mv	s2,a1
    80001350:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001352:	0632                	sll	a2,a2,0xc
    80001354:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001358:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000135a:	6b05                	lui	s6,0x1
    8000135c:	0735e263          	bltu	a1,s3,800013c0 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001360:	60a6                	ld	ra,72(sp)
    80001362:	6406                	ld	s0,64(sp)
    80001364:	74e2                	ld	s1,56(sp)
    80001366:	7942                	ld	s2,48(sp)
    80001368:	79a2                	ld	s3,40(sp)
    8000136a:	7a02                	ld	s4,32(sp)
    8000136c:	6ae2                	ld	s5,24(sp)
    8000136e:	6b42                	ld	s6,16(sp)
    80001370:	6ba2                	ld	s7,8(sp)
    80001372:	6161                	add	sp,sp,80
    80001374:	8082                	ret
    panic("uvmunmap: not aligned");
    80001376:	00007517          	auipc	a0,0x7
    8000137a:	d9250513          	add	a0,a0,-622 # 80008108 <digits+0xb0>
    8000137e:	fffff097          	auipc	ra,0xfffff
    80001382:	262080e7          	jalr	610(ra) # 800005e0 <panic>
      panic("uvmunmap: walk");
    80001386:	00007517          	auipc	a0,0x7
    8000138a:	d9a50513          	add	a0,a0,-614 # 80008120 <digits+0xc8>
    8000138e:	fffff097          	auipc	ra,0xfffff
    80001392:	252080e7          	jalr	594(ra) # 800005e0 <panic>
      panic("uvmunmap: not mapped");
    80001396:	00007517          	auipc	a0,0x7
    8000139a:	d9a50513          	add	a0,a0,-614 # 80008130 <digits+0xd8>
    8000139e:	fffff097          	auipc	ra,0xfffff
    800013a2:	242080e7          	jalr	578(ra) # 800005e0 <panic>
      panic("uvmunmap: not a leaf");
    800013a6:	00007517          	auipc	a0,0x7
    800013aa:	da250513          	add	a0,a0,-606 # 80008148 <digits+0xf0>
    800013ae:	fffff097          	auipc	ra,0xfffff
    800013b2:	232080e7          	jalr	562(ra) # 800005e0 <panic>
    *pte = 0;
    800013b6:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013ba:	995a                	add	s2,s2,s6
    800013bc:	fb3972e3          	bgeu	s2,s3,80001360 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800013c0:	4601                	li	a2,0
    800013c2:	85ca                	mv	a1,s2
    800013c4:	8552                	mv	a0,s4
    800013c6:	00000097          	auipc	ra,0x0
    800013ca:	c8c080e7          	jalr	-884(ra) # 80001052 <walk>
    800013ce:	84aa                	mv	s1,a0
    800013d0:	d95d                	beqz	a0,80001386 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800013d2:	6108                	ld	a0,0(a0)
    800013d4:	00157793          	and	a5,a0,1
    800013d8:	dfdd                	beqz	a5,80001396 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800013da:	3ff57793          	and	a5,a0,1023
    800013de:	fd7784e3          	beq	a5,s7,800013a6 <uvmunmap+0x76>
    if(do_free){
    800013e2:	fc0a8ae3          	beqz	s5,800013b6 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800013e6:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    800013e8:	0532                	sll	a0,a0,0xc
    800013ea:	fffff097          	auipc	ra,0xfffff
    800013ee:	698080e7          	jalr	1688(ra) # 80000a82 <kfree>
    800013f2:	b7d1                	j	800013b6 <uvmunmap+0x86>

00000000800013f4 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800013f4:	1101                	add	sp,sp,-32
    800013f6:	ec06                	sd	ra,24(sp)
    800013f8:	e822                	sd	s0,16(sp)
    800013fa:	e426                	sd	s1,8(sp)
    800013fc:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800013fe:	fffff097          	auipc	ra,0xfffff
    80001402:	782080e7          	jalr	1922(ra) # 80000b80 <kalloc>
    80001406:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001408:	c519                	beqz	a0,80001416 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000140a:	6605                	lui	a2,0x1
    8000140c:	4581                	li	a1,0
    8000140e:	00000097          	auipc	ra,0x0
    80001412:	95e080e7          	jalr	-1698(ra) # 80000d6c <memset>
  return pagetable;
}
    80001416:	8526                	mv	a0,s1
    80001418:	60e2                	ld	ra,24(sp)
    8000141a:	6442                	ld	s0,16(sp)
    8000141c:	64a2                	ld	s1,8(sp)
    8000141e:	6105                	add	sp,sp,32
    80001420:	8082                	ret

0000000080001422 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80001422:	7179                	add	sp,sp,-48
    80001424:	f406                	sd	ra,40(sp)
    80001426:	f022                	sd	s0,32(sp)
    80001428:	ec26                	sd	s1,24(sp)
    8000142a:	e84a                	sd	s2,16(sp)
    8000142c:	e44e                	sd	s3,8(sp)
    8000142e:	e052                	sd	s4,0(sp)
    80001430:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001432:	6785                	lui	a5,0x1
    80001434:	04f67863          	bgeu	a2,a5,80001484 <uvminit+0x62>
    80001438:	8a2a                	mv	s4,a0
    8000143a:	89ae                	mv	s3,a1
    8000143c:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000143e:	fffff097          	auipc	ra,0xfffff
    80001442:	742080e7          	jalr	1858(ra) # 80000b80 <kalloc>
    80001446:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001448:	6605                	lui	a2,0x1
    8000144a:	4581                	li	a1,0
    8000144c:	00000097          	auipc	ra,0x0
    80001450:	920080e7          	jalr	-1760(ra) # 80000d6c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001454:	4779                	li	a4,30
    80001456:	86ca                	mv	a3,s2
    80001458:	6605                	lui	a2,0x1
    8000145a:	4581                	li	a1,0
    8000145c:	8552                	mv	a0,s4
    8000145e:	00000097          	auipc	ra,0x0
    80001462:	d3a080e7          	jalr	-710(ra) # 80001198 <mappages>
  memmove(mem, src, sz);
    80001466:	8626                	mv	a2,s1
    80001468:	85ce                	mv	a1,s3
    8000146a:	854a                	mv	a0,s2
    8000146c:	00000097          	auipc	ra,0x0
    80001470:	95c080e7          	jalr	-1700(ra) # 80000dc8 <memmove>
}
    80001474:	70a2                	ld	ra,40(sp)
    80001476:	7402                	ld	s0,32(sp)
    80001478:	64e2                	ld	s1,24(sp)
    8000147a:	6942                	ld	s2,16(sp)
    8000147c:	69a2                	ld	s3,8(sp)
    8000147e:	6a02                	ld	s4,0(sp)
    80001480:	6145                	add	sp,sp,48
    80001482:	8082                	ret
    panic("inituvm: more than a page");
    80001484:	00007517          	auipc	a0,0x7
    80001488:	cdc50513          	add	a0,a0,-804 # 80008160 <digits+0x108>
    8000148c:	fffff097          	auipc	ra,0xfffff
    80001490:	154080e7          	jalr	340(ra) # 800005e0 <panic>

0000000080001494 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001494:	1101                	add	sp,sp,-32
    80001496:	ec06                	sd	ra,24(sp)
    80001498:	e822                	sd	s0,16(sp)
    8000149a:	e426                	sd	s1,8(sp)
    8000149c:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000149e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800014a0:	00b67d63          	bgeu	a2,a1,800014ba <uvmdealloc+0x26>
    800014a4:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800014a6:	6785                	lui	a5,0x1
    800014a8:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800014aa:	00f60733          	add	a4,a2,a5
    800014ae:	76fd                	lui	a3,0xfffff
    800014b0:	8f75                	and	a4,a4,a3
    800014b2:	97ae                	add	a5,a5,a1
    800014b4:	8ff5                	and	a5,a5,a3
    800014b6:	00f76863          	bltu	a4,a5,800014c6 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800014ba:	8526                	mv	a0,s1
    800014bc:	60e2                	ld	ra,24(sp)
    800014be:	6442                	ld	s0,16(sp)
    800014c0:	64a2                	ld	s1,8(sp)
    800014c2:	6105                	add	sp,sp,32
    800014c4:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800014c6:	8f99                	sub	a5,a5,a4
    800014c8:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800014ca:	4685                	li	a3,1
    800014cc:	0007861b          	sext.w	a2,a5
    800014d0:	85ba                	mv	a1,a4
    800014d2:	00000097          	auipc	ra,0x0
    800014d6:	e5e080e7          	jalr	-418(ra) # 80001330 <uvmunmap>
    800014da:	b7c5                	j	800014ba <uvmdealloc+0x26>

00000000800014dc <uvmalloc>:
  if(newsz < oldsz)
    800014dc:	0ab66163          	bltu	a2,a1,8000157e <uvmalloc+0xa2>
{
    800014e0:	7139                	add	sp,sp,-64
    800014e2:	fc06                	sd	ra,56(sp)
    800014e4:	f822                	sd	s0,48(sp)
    800014e6:	f426                	sd	s1,40(sp)
    800014e8:	f04a                	sd	s2,32(sp)
    800014ea:	ec4e                	sd	s3,24(sp)
    800014ec:	e852                	sd	s4,16(sp)
    800014ee:	e456                	sd	s5,8(sp)
    800014f0:	0080                	add	s0,sp,64
    800014f2:	8aaa                	mv	s5,a0
    800014f4:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800014f6:	6785                	lui	a5,0x1
    800014f8:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800014fa:	95be                	add	a1,a1,a5
    800014fc:	77fd                	lui	a5,0xfffff
    800014fe:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001502:	08c9f063          	bgeu	s3,a2,80001582 <uvmalloc+0xa6>
    80001506:	894e                	mv	s2,s3
    mem = kalloc();
    80001508:	fffff097          	auipc	ra,0xfffff
    8000150c:	678080e7          	jalr	1656(ra) # 80000b80 <kalloc>
    80001510:	84aa                	mv	s1,a0
    if(mem == 0){
    80001512:	c51d                	beqz	a0,80001540 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001514:	6605                	lui	a2,0x1
    80001516:	4581                	li	a1,0
    80001518:	00000097          	auipc	ra,0x0
    8000151c:	854080e7          	jalr	-1964(ra) # 80000d6c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80001520:	4779                	li	a4,30
    80001522:	86a6                	mv	a3,s1
    80001524:	6605                	lui	a2,0x1
    80001526:	85ca                	mv	a1,s2
    80001528:	8556                	mv	a0,s5
    8000152a:	00000097          	auipc	ra,0x0
    8000152e:	c6e080e7          	jalr	-914(ra) # 80001198 <mappages>
    80001532:	e905                	bnez	a0,80001562 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001534:	6785                	lui	a5,0x1
    80001536:	993e                	add	s2,s2,a5
    80001538:	fd4968e3          	bltu	s2,s4,80001508 <uvmalloc+0x2c>
  return newsz;
    8000153c:	8552                	mv	a0,s4
    8000153e:	a809                	j	80001550 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80001540:	864e                	mv	a2,s3
    80001542:	85ca                	mv	a1,s2
    80001544:	8556                	mv	a0,s5
    80001546:	00000097          	auipc	ra,0x0
    8000154a:	f4e080e7          	jalr	-178(ra) # 80001494 <uvmdealloc>
      return 0;
    8000154e:	4501                	li	a0,0
}
    80001550:	70e2                	ld	ra,56(sp)
    80001552:	7442                	ld	s0,48(sp)
    80001554:	74a2                	ld	s1,40(sp)
    80001556:	7902                	ld	s2,32(sp)
    80001558:	69e2                	ld	s3,24(sp)
    8000155a:	6a42                	ld	s4,16(sp)
    8000155c:	6aa2                	ld	s5,8(sp)
    8000155e:	6121                	add	sp,sp,64
    80001560:	8082                	ret
      kfree(mem);
    80001562:	8526                	mv	a0,s1
    80001564:	fffff097          	auipc	ra,0xfffff
    80001568:	51e080e7          	jalr	1310(ra) # 80000a82 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000156c:	864e                	mv	a2,s3
    8000156e:	85ca                	mv	a1,s2
    80001570:	8556                	mv	a0,s5
    80001572:	00000097          	auipc	ra,0x0
    80001576:	f22080e7          	jalr	-222(ra) # 80001494 <uvmdealloc>
      return 0;
    8000157a:	4501                	li	a0,0
    8000157c:	bfd1                	j	80001550 <uvmalloc+0x74>
    return oldsz;
    8000157e:	852e                	mv	a0,a1
}
    80001580:	8082                	ret
  return newsz;
    80001582:	8532                	mv	a0,a2
    80001584:	b7f1                	j	80001550 <uvmalloc+0x74>

0000000080001586 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001586:	7179                	add	sp,sp,-48
    80001588:	f406                	sd	ra,40(sp)
    8000158a:	f022                	sd	s0,32(sp)
    8000158c:	ec26                	sd	s1,24(sp)
    8000158e:	e84a                	sd	s2,16(sp)
    80001590:	e44e                	sd	s3,8(sp)
    80001592:	e052                	sd	s4,0(sp)
    80001594:	1800                	add	s0,sp,48
    80001596:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001598:	84aa                	mv	s1,a0
    8000159a:	6905                	lui	s2,0x1
    8000159c:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000159e:	4985                	li	s3,1
    800015a0:	a829                	j	800015ba <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800015a2:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    800015a4:	00c79513          	sll	a0,a5,0xc
    800015a8:	00000097          	auipc	ra,0x0
    800015ac:	fde080e7          	jalr	-34(ra) # 80001586 <freewalk>
      pagetable[i] = 0;
    800015b0:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800015b4:	04a1                	add	s1,s1,8
    800015b6:	03248163          	beq	s1,s2,800015d8 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800015ba:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800015bc:	00f7f713          	and	a4,a5,15
    800015c0:	ff3701e3          	beq	a4,s3,800015a2 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800015c4:	8b85                	and	a5,a5,1
    800015c6:	d7fd                	beqz	a5,800015b4 <freewalk+0x2e>
      panic("freewalk: leaf");
    800015c8:	00007517          	auipc	a0,0x7
    800015cc:	bb850513          	add	a0,a0,-1096 # 80008180 <digits+0x128>
    800015d0:	fffff097          	auipc	ra,0xfffff
    800015d4:	010080e7          	jalr	16(ra) # 800005e0 <panic>
    }
  }
  kfree((void*)pagetable);
    800015d8:	8552                	mv	a0,s4
    800015da:	fffff097          	auipc	ra,0xfffff
    800015de:	4a8080e7          	jalr	1192(ra) # 80000a82 <kfree>
}
    800015e2:	70a2                	ld	ra,40(sp)
    800015e4:	7402                	ld	s0,32(sp)
    800015e6:	64e2                	ld	s1,24(sp)
    800015e8:	6942                	ld	s2,16(sp)
    800015ea:	69a2                	ld	s3,8(sp)
    800015ec:	6a02                	ld	s4,0(sp)
    800015ee:	6145                	add	sp,sp,48
    800015f0:	8082                	ret

00000000800015f2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800015f2:	1101                	add	sp,sp,-32
    800015f4:	ec06                	sd	ra,24(sp)
    800015f6:	e822                	sd	s0,16(sp)
    800015f8:	e426                	sd	s1,8(sp)
    800015fa:	1000                	add	s0,sp,32
    800015fc:	84aa                	mv	s1,a0
  if(sz > 0)
    800015fe:	e999                	bnez	a1,80001614 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001600:	8526                	mv	a0,s1
    80001602:	00000097          	auipc	ra,0x0
    80001606:	f84080e7          	jalr	-124(ra) # 80001586 <freewalk>
}
    8000160a:	60e2                	ld	ra,24(sp)
    8000160c:	6442                	ld	s0,16(sp)
    8000160e:	64a2                	ld	s1,8(sp)
    80001610:	6105                	add	sp,sp,32
    80001612:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001614:	6785                	lui	a5,0x1
    80001616:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001618:	95be                	add	a1,a1,a5
    8000161a:	4685                	li	a3,1
    8000161c:	00c5d613          	srl	a2,a1,0xc
    80001620:	4581                	li	a1,0
    80001622:	00000097          	auipc	ra,0x0
    80001626:	d0e080e7          	jalr	-754(ra) # 80001330 <uvmunmap>
    8000162a:	bfd9                	j	80001600 <uvmfree+0xe>

000000008000162c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000162c:	c679                	beqz	a2,800016fa <uvmcopy+0xce>
{
    8000162e:	715d                	add	sp,sp,-80
    80001630:	e486                	sd	ra,72(sp)
    80001632:	e0a2                	sd	s0,64(sp)
    80001634:	fc26                	sd	s1,56(sp)
    80001636:	f84a                	sd	s2,48(sp)
    80001638:	f44e                	sd	s3,40(sp)
    8000163a:	f052                	sd	s4,32(sp)
    8000163c:	ec56                	sd	s5,24(sp)
    8000163e:	e85a                	sd	s6,16(sp)
    80001640:	e45e                	sd	s7,8(sp)
    80001642:	0880                	add	s0,sp,80
    80001644:	8b2a                	mv	s6,a0
    80001646:	8aae                	mv	s5,a1
    80001648:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000164a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000164c:	4601                	li	a2,0
    8000164e:	85ce                	mv	a1,s3
    80001650:	855a                	mv	a0,s6
    80001652:	00000097          	auipc	ra,0x0
    80001656:	a00080e7          	jalr	-1536(ra) # 80001052 <walk>
    8000165a:	c531                	beqz	a0,800016a6 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000165c:	6118                	ld	a4,0(a0)
    8000165e:	00177793          	and	a5,a4,1
    80001662:	cbb1                	beqz	a5,800016b6 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001664:	00a75593          	srl	a1,a4,0xa
    80001668:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000166c:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001670:	fffff097          	auipc	ra,0xfffff
    80001674:	510080e7          	jalr	1296(ra) # 80000b80 <kalloc>
    80001678:	892a                	mv	s2,a0
    8000167a:	c939                	beqz	a0,800016d0 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000167c:	6605                	lui	a2,0x1
    8000167e:	85de                	mv	a1,s7
    80001680:	fffff097          	auipc	ra,0xfffff
    80001684:	748080e7          	jalr	1864(ra) # 80000dc8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001688:	8726                	mv	a4,s1
    8000168a:	86ca                	mv	a3,s2
    8000168c:	6605                	lui	a2,0x1
    8000168e:	85ce                	mv	a1,s3
    80001690:	8556                	mv	a0,s5
    80001692:	00000097          	auipc	ra,0x0
    80001696:	b06080e7          	jalr	-1274(ra) # 80001198 <mappages>
    8000169a:	e515                	bnez	a0,800016c6 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    8000169c:	6785                	lui	a5,0x1
    8000169e:	99be                	add	s3,s3,a5
    800016a0:	fb49e6e3          	bltu	s3,s4,8000164c <uvmcopy+0x20>
    800016a4:	a081                	j	800016e4 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800016a6:	00007517          	auipc	a0,0x7
    800016aa:	aea50513          	add	a0,a0,-1302 # 80008190 <digits+0x138>
    800016ae:	fffff097          	auipc	ra,0xfffff
    800016b2:	f32080e7          	jalr	-206(ra) # 800005e0 <panic>
      panic("uvmcopy: page not present");
    800016b6:	00007517          	auipc	a0,0x7
    800016ba:	afa50513          	add	a0,a0,-1286 # 800081b0 <digits+0x158>
    800016be:	fffff097          	auipc	ra,0xfffff
    800016c2:	f22080e7          	jalr	-222(ra) # 800005e0 <panic>
      kfree(mem);
    800016c6:	854a                	mv	a0,s2
    800016c8:	fffff097          	auipc	ra,0xfffff
    800016cc:	3ba080e7          	jalr	954(ra) # 80000a82 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800016d0:	4685                	li	a3,1
    800016d2:	00c9d613          	srl	a2,s3,0xc
    800016d6:	4581                	li	a1,0
    800016d8:	8556                	mv	a0,s5
    800016da:	00000097          	auipc	ra,0x0
    800016de:	c56080e7          	jalr	-938(ra) # 80001330 <uvmunmap>
  return -1;
    800016e2:	557d                	li	a0,-1
}
    800016e4:	60a6                	ld	ra,72(sp)
    800016e6:	6406                	ld	s0,64(sp)
    800016e8:	74e2                	ld	s1,56(sp)
    800016ea:	7942                	ld	s2,48(sp)
    800016ec:	79a2                	ld	s3,40(sp)
    800016ee:	7a02                	ld	s4,32(sp)
    800016f0:	6ae2                	ld	s5,24(sp)
    800016f2:	6b42                	ld	s6,16(sp)
    800016f4:	6ba2                	ld	s7,8(sp)
    800016f6:	6161                	add	sp,sp,80
    800016f8:	8082                	ret
  return 0;
    800016fa:	4501                	li	a0,0
}
    800016fc:	8082                	ret

00000000800016fe <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800016fe:	1141                	add	sp,sp,-16
    80001700:	e406                	sd	ra,8(sp)
    80001702:	e022                	sd	s0,0(sp)
    80001704:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001706:	4601                	li	a2,0
    80001708:	00000097          	auipc	ra,0x0
    8000170c:	94a080e7          	jalr	-1718(ra) # 80001052 <walk>
  if(pte == 0)
    80001710:	c901                	beqz	a0,80001720 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001712:	611c                	ld	a5,0(a0)
    80001714:	9bbd                	and	a5,a5,-17
    80001716:	e11c                	sd	a5,0(a0)
}
    80001718:	60a2                	ld	ra,8(sp)
    8000171a:	6402                	ld	s0,0(sp)
    8000171c:	0141                	add	sp,sp,16
    8000171e:	8082                	ret
    panic("uvmclear");
    80001720:	00007517          	auipc	a0,0x7
    80001724:	ab050513          	add	a0,a0,-1360 # 800081d0 <digits+0x178>
    80001728:	fffff097          	auipc	ra,0xfffff
    8000172c:	eb8080e7          	jalr	-328(ra) # 800005e0 <panic>

0000000080001730 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001730:	c6bd                	beqz	a3,8000179e <copyout+0x6e>
{
    80001732:	715d                	add	sp,sp,-80
    80001734:	e486                	sd	ra,72(sp)
    80001736:	e0a2                	sd	s0,64(sp)
    80001738:	fc26                	sd	s1,56(sp)
    8000173a:	f84a                	sd	s2,48(sp)
    8000173c:	f44e                	sd	s3,40(sp)
    8000173e:	f052                	sd	s4,32(sp)
    80001740:	ec56                	sd	s5,24(sp)
    80001742:	e85a                	sd	s6,16(sp)
    80001744:	e45e                	sd	s7,8(sp)
    80001746:	e062                	sd	s8,0(sp)
    80001748:	0880                	add	s0,sp,80
    8000174a:	8b2a                	mv	s6,a0
    8000174c:	8c2e                	mv	s8,a1
    8000174e:	8a32                	mv	s4,a2
    80001750:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001752:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001754:	6a85                	lui	s5,0x1
    80001756:	a015                	j	8000177a <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001758:	9562                	add	a0,a0,s8
    8000175a:	0004861b          	sext.w	a2,s1
    8000175e:	85d2                	mv	a1,s4
    80001760:	41250533          	sub	a0,a0,s2
    80001764:	fffff097          	auipc	ra,0xfffff
    80001768:	664080e7          	jalr	1636(ra) # 80000dc8 <memmove>

    len -= n;
    8000176c:	409989b3          	sub	s3,s3,s1
    src += n;
    80001770:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001772:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001776:	02098263          	beqz	s3,8000179a <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    8000177a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000177e:	85ca                	mv	a1,s2
    80001780:	855a                	mv	a0,s6
    80001782:	00000097          	auipc	ra,0x0
    80001786:	976080e7          	jalr	-1674(ra) # 800010f8 <walkaddr>
    if(pa0 == 0)
    8000178a:	cd01                	beqz	a0,800017a2 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    8000178c:	418904b3          	sub	s1,s2,s8
    80001790:	94d6                	add	s1,s1,s5
    80001792:	fc99f3e3          	bgeu	s3,s1,80001758 <copyout+0x28>
    80001796:	84ce                	mv	s1,s3
    80001798:	b7c1                	j	80001758 <copyout+0x28>
  }
  return 0;
    8000179a:	4501                	li	a0,0
    8000179c:	a021                	j	800017a4 <copyout+0x74>
    8000179e:	4501                	li	a0,0
}
    800017a0:	8082                	ret
      return -1;
    800017a2:	557d                	li	a0,-1
}
    800017a4:	60a6                	ld	ra,72(sp)
    800017a6:	6406                	ld	s0,64(sp)
    800017a8:	74e2                	ld	s1,56(sp)
    800017aa:	7942                	ld	s2,48(sp)
    800017ac:	79a2                	ld	s3,40(sp)
    800017ae:	7a02                	ld	s4,32(sp)
    800017b0:	6ae2                	ld	s5,24(sp)
    800017b2:	6b42                	ld	s6,16(sp)
    800017b4:	6ba2                	ld	s7,8(sp)
    800017b6:	6c02                	ld	s8,0(sp)
    800017b8:	6161                	add	sp,sp,80
    800017ba:	8082                	ret

00000000800017bc <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800017bc:	caa5                	beqz	a3,8000182c <copyin+0x70>
{
    800017be:	715d                	add	sp,sp,-80
    800017c0:	e486                	sd	ra,72(sp)
    800017c2:	e0a2                	sd	s0,64(sp)
    800017c4:	fc26                	sd	s1,56(sp)
    800017c6:	f84a                	sd	s2,48(sp)
    800017c8:	f44e                	sd	s3,40(sp)
    800017ca:	f052                	sd	s4,32(sp)
    800017cc:	ec56                	sd	s5,24(sp)
    800017ce:	e85a                	sd	s6,16(sp)
    800017d0:	e45e                	sd	s7,8(sp)
    800017d2:	e062                	sd	s8,0(sp)
    800017d4:	0880                	add	s0,sp,80
    800017d6:	8b2a                	mv	s6,a0
    800017d8:	8a2e                	mv	s4,a1
    800017da:	8c32                	mv	s8,a2
    800017dc:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800017de:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017e0:	6a85                	lui	s5,0x1
    800017e2:	a01d                	j	80001808 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800017e4:	018505b3          	add	a1,a0,s8
    800017e8:	0004861b          	sext.w	a2,s1
    800017ec:	412585b3          	sub	a1,a1,s2
    800017f0:	8552                	mv	a0,s4
    800017f2:	fffff097          	auipc	ra,0xfffff
    800017f6:	5d6080e7          	jalr	1494(ra) # 80000dc8 <memmove>

    len -= n;
    800017fa:	409989b3          	sub	s3,s3,s1
    dst += n;
    800017fe:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001800:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001804:	02098263          	beqz	s3,80001828 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001808:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000180c:	85ca                	mv	a1,s2
    8000180e:	855a                	mv	a0,s6
    80001810:	00000097          	auipc	ra,0x0
    80001814:	8e8080e7          	jalr	-1816(ra) # 800010f8 <walkaddr>
    if(pa0 == 0)
    80001818:	cd01                	beqz	a0,80001830 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    8000181a:	418904b3          	sub	s1,s2,s8
    8000181e:	94d6                	add	s1,s1,s5
    80001820:	fc99f2e3          	bgeu	s3,s1,800017e4 <copyin+0x28>
    80001824:	84ce                	mv	s1,s3
    80001826:	bf7d                	j	800017e4 <copyin+0x28>
  }
  return 0;
    80001828:	4501                	li	a0,0
    8000182a:	a021                	j	80001832 <copyin+0x76>
    8000182c:	4501                	li	a0,0
}
    8000182e:	8082                	ret
      return -1;
    80001830:	557d                	li	a0,-1
}
    80001832:	60a6                	ld	ra,72(sp)
    80001834:	6406                	ld	s0,64(sp)
    80001836:	74e2                	ld	s1,56(sp)
    80001838:	7942                	ld	s2,48(sp)
    8000183a:	79a2                	ld	s3,40(sp)
    8000183c:	7a02                	ld	s4,32(sp)
    8000183e:	6ae2                	ld	s5,24(sp)
    80001840:	6b42                	ld	s6,16(sp)
    80001842:	6ba2                	ld	s7,8(sp)
    80001844:	6c02                	ld	s8,0(sp)
    80001846:	6161                	add	sp,sp,80
    80001848:	8082                	ret

000000008000184a <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000184a:	c2dd                	beqz	a3,800018f0 <copyinstr+0xa6>
{
    8000184c:	715d                	add	sp,sp,-80
    8000184e:	e486                	sd	ra,72(sp)
    80001850:	e0a2                	sd	s0,64(sp)
    80001852:	fc26                	sd	s1,56(sp)
    80001854:	f84a                	sd	s2,48(sp)
    80001856:	f44e                	sd	s3,40(sp)
    80001858:	f052                	sd	s4,32(sp)
    8000185a:	ec56                	sd	s5,24(sp)
    8000185c:	e85a                	sd	s6,16(sp)
    8000185e:	e45e                	sd	s7,8(sp)
    80001860:	0880                	add	s0,sp,80
    80001862:	8a2a                	mv	s4,a0
    80001864:	8b2e                	mv	s6,a1
    80001866:	8bb2                	mv	s7,a2
    80001868:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    8000186a:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000186c:	6985                	lui	s3,0x1
    8000186e:	a02d                	j	80001898 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001870:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001874:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001876:	37fd                	addw	a5,a5,-1
    80001878:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000187c:	60a6                	ld	ra,72(sp)
    8000187e:	6406                	ld	s0,64(sp)
    80001880:	74e2                	ld	s1,56(sp)
    80001882:	7942                	ld	s2,48(sp)
    80001884:	79a2                	ld	s3,40(sp)
    80001886:	7a02                	ld	s4,32(sp)
    80001888:	6ae2                	ld	s5,24(sp)
    8000188a:	6b42                	ld	s6,16(sp)
    8000188c:	6ba2                	ld	s7,8(sp)
    8000188e:	6161                	add	sp,sp,80
    80001890:	8082                	ret
    srcva = va0 + PGSIZE;
    80001892:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80001896:	c8a9                	beqz	s1,800018e8 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80001898:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000189c:	85ca                	mv	a1,s2
    8000189e:	8552                	mv	a0,s4
    800018a0:	00000097          	auipc	ra,0x0
    800018a4:	858080e7          	jalr	-1960(ra) # 800010f8 <walkaddr>
    if(pa0 == 0)
    800018a8:	c131                	beqz	a0,800018ec <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    800018aa:	417906b3          	sub	a3,s2,s7
    800018ae:	96ce                	add	a3,a3,s3
    800018b0:	00d4f363          	bgeu	s1,a3,800018b6 <copyinstr+0x6c>
    800018b4:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800018b6:	955e                	add	a0,a0,s7
    800018b8:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800018bc:	daf9                	beqz	a3,80001892 <copyinstr+0x48>
    800018be:	87da                	mv	a5,s6
    800018c0:	885a                	mv	a6,s6
      if(*p == '\0'){
    800018c2:	41650633          	sub	a2,a0,s6
    while(n > 0){
    800018c6:	96da                	add	a3,a3,s6
    800018c8:	85be                	mv	a1,a5
      if(*p == '\0'){
    800018ca:	00f60733          	add	a4,a2,a5
    800018ce:	00074703          	lbu	a4,0(a4)
    800018d2:	df59                	beqz	a4,80001870 <copyinstr+0x26>
        *dst = *p;
    800018d4:	00e78023          	sb	a4,0(a5)
      dst++;
    800018d8:	0785                	add	a5,a5,1
    while(n > 0){
    800018da:	fed797e3          	bne	a5,a3,800018c8 <copyinstr+0x7e>
    800018de:	14fd                	add	s1,s1,-1
    800018e0:	94c2                	add	s1,s1,a6
      --max;
    800018e2:	8c8d                	sub	s1,s1,a1
      dst++;
    800018e4:	8b3e                	mv	s6,a5
    800018e6:	b775                	j	80001892 <copyinstr+0x48>
    800018e8:	4781                	li	a5,0
    800018ea:	b771                	j	80001876 <copyinstr+0x2c>
      return -1;
    800018ec:	557d                	li	a0,-1
    800018ee:	b779                	j	8000187c <copyinstr+0x32>
  int got_null = 0;
    800018f0:	4781                	li	a5,0
  if(got_null){
    800018f2:	37fd                	addw	a5,a5,-1
    800018f4:	0007851b          	sext.w	a0,a5
}
    800018f8:	8082                	ret

00000000800018fa <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    800018fa:	1101                	add	sp,sp,-32
    800018fc:	ec06                	sd	ra,24(sp)
    800018fe:	e822                	sd	s0,16(sp)
    80001900:	e426                	sd	s1,8(sp)
    80001902:	1000                	add	s0,sp,32
    80001904:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001906:	fffff097          	auipc	ra,0xfffff
    8000190a:	2f0080e7          	jalr	752(ra) # 80000bf6 <holding>
    8000190e:	c909                	beqz	a0,80001920 <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    80001910:	749c                	ld	a5,40(s1)
    80001912:	00978f63          	beq	a5,s1,80001930 <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    80001916:	60e2                	ld	ra,24(sp)
    80001918:	6442                	ld	s0,16(sp)
    8000191a:	64a2                	ld	s1,8(sp)
    8000191c:	6105                	add	sp,sp,32
    8000191e:	8082                	ret
    panic("wakeup1");
    80001920:	00007517          	auipc	a0,0x7
    80001924:	8c050513          	add	a0,a0,-1856 # 800081e0 <digits+0x188>
    80001928:	fffff097          	auipc	ra,0xfffff
    8000192c:	cb8080e7          	jalr	-840(ra) # 800005e0 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80001930:	4c98                	lw	a4,24(s1)
    80001932:	4785                	li	a5,1
    80001934:	fef711e3          	bne	a4,a5,80001916 <wakeup1+0x1c>
    p->state = RUNNABLE;
    80001938:	4789                	li	a5,2
    8000193a:	cc9c                	sw	a5,24(s1)
}
    8000193c:	bfe9                	j	80001916 <wakeup1+0x1c>

000000008000193e <procinit>:
{
    8000193e:	715d                	add	sp,sp,-80
    80001940:	e486                	sd	ra,72(sp)
    80001942:	e0a2                	sd	s0,64(sp)
    80001944:	fc26                	sd	s1,56(sp)
    80001946:	f84a                	sd	s2,48(sp)
    80001948:	f44e                	sd	s3,40(sp)
    8000194a:	f052                	sd	s4,32(sp)
    8000194c:	ec56                	sd	s5,24(sp)
    8000194e:	e85a                	sd	s6,16(sp)
    80001950:	e45e                	sd	s7,8(sp)
    80001952:	0880                	add	s0,sp,80
  initlock(&pid_lock, "nextpid");
    80001954:	00007597          	auipc	a1,0x7
    80001958:	89458593          	add	a1,a1,-1900 # 800081e8 <digits+0x190>
    8000195c:	00010517          	auipc	a0,0x10
    80001960:	ff450513          	add	a0,a0,-12 # 80011950 <pid_lock>
    80001964:	fffff097          	auipc	ra,0xfffff
    80001968:	27c080e7          	jalr	636(ra) # 80000be0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000196c:	00010917          	auipc	s2,0x10
    80001970:	3fc90913          	add	s2,s2,1020 # 80011d68 <proc>
      initlock(&p->lock, "proc");
    80001974:	00007b97          	auipc	s7,0x7
    80001978:	87cb8b93          	add	s7,s7,-1924 # 800081f0 <digits+0x198>
      uint64 va = KSTACK((int) (p - proc));
    8000197c:	8b4a                	mv	s6,s2
    8000197e:	00006a97          	auipc	s5,0x6
    80001982:	682a8a93          	add	s5,s5,1666 # 80008000 <etext>
    80001986:	040009b7          	lui	s3,0x4000
    8000198a:	19fd                	add	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000198c:	09b2                	sll	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000198e:	00016a17          	auipc	s4,0x16
    80001992:	7daa0a13          	add	s4,s4,2010 # 80018168 <tickslock>
      initlock(&p->lock, "proc");
    80001996:	85de                	mv	a1,s7
    80001998:	854a                	mv	a0,s2
    8000199a:	fffff097          	auipc	ra,0xfffff
    8000199e:	246080e7          	jalr	582(ra) # 80000be0 <initlock>
      char *pa = kalloc();
    800019a2:	fffff097          	auipc	ra,0xfffff
    800019a6:	1de080e7          	jalr	478(ra) # 80000b80 <kalloc>
    800019aa:	85aa                	mv	a1,a0
      if(pa == 0)
    800019ac:	c929                	beqz	a0,800019fe <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc));
    800019ae:	416904b3          	sub	s1,s2,s6
    800019b2:	8491                	sra	s1,s1,0x4
    800019b4:	000ab783          	ld	a5,0(s5)
    800019b8:	02f484b3          	mul	s1,s1,a5
    800019bc:	2485                	addw	s1,s1,1
    800019be:	00d4949b          	sllw	s1,s1,0xd
    800019c2:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800019c6:	4699                	li	a3,6
    800019c8:	6605                	lui	a2,0x1
    800019ca:	8526                	mv	a0,s1
    800019cc:	00000097          	auipc	ra,0x0
    800019d0:	85a080e7          	jalr	-1958(ra) # 80001226 <kvmmap>
      p->kstack = va;
    800019d4:	04993023          	sd	s1,64(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    800019d8:	19090913          	add	s2,s2,400
    800019dc:	fb491de3          	bne	s2,s4,80001996 <procinit+0x58>
  kvminithart();
    800019e0:	fffff097          	auipc	ra,0xfffff
    800019e4:	64e080e7          	jalr	1614(ra) # 8000102e <kvminithart>
}
    800019e8:	60a6                	ld	ra,72(sp)
    800019ea:	6406                	ld	s0,64(sp)
    800019ec:	74e2                	ld	s1,56(sp)
    800019ee:	7942                	ld	s2,48(sp)
    800019f0:	79a2                	ld	s3,40(sp)
    800019f2:	7a02                	ld	s4,32(sp)
    800019f4:	6ae2                	ld	s5,24(sp)
    800019f6:	6b42                	ld	s6,16(sp)
    800019f8:	6ba2                	ld	s7,8(sp)
    800019fa:	6161                	add	sp,sp,80
    800019fc:	8082                	ret
        panic("kalloc");
    800019fe:	00006517          	auipc	a0,0x6
    80001a02:	7fa50513          	add	a0,a0,2042 # 800081f8 <digits+0x1a0>
    80001a06:	fffff097          	auipc	ra,0xfffff
    80001a0a:	bda080e7          	jalr	-1062(ra) # 800005e0 <panic>

0000000080001a0e <cpuid>:
{
    80001a0e:	1141                	add	sp,sp,-16
    80001a10:	e422                	sd	s0,8(sp)
    80001a12:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a14:	8512                	mv	a0,tp
}
    80001a16:	2501                	sext.w	a0,a0
    80001a18:	6422                	ld	s0,8(sp)
    80001a1a:	0141                	add	sp,sp,16
    80001a1c:	8082                	ret

0000000080001a1e <mycpu>:
mycpu(void) {
    80001a1e:	1141                	add	sp,sp,-16
    80001a20:	e422                	sd	s0,8(sp)
    80001a22:	0800                	add	s0,sp,16
    80001a24:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001a26:	2781                	sext.w	a5,a5
    80001a28:	079e                	sll	a5,a5,0x7
}
    80001a2a:	00010517          	auipc	a0,0x10
    80001a2e:	f3e50513          	add	a0,a0,-194 # 80011968 <cpus>
    80001a32:	953e                	add	a0,a0,a5
    80001a34:	6422                	ld	s0,8(sp)
    80001a36:	0141                	add	sp,sp,16
    80001a38:	8082                	ret

0000000080001a3a <myproc>:
myproc(void) {
    80001a3a:	1101                	add	sp,sp,-32
    80001a3c:	ec06                	sd	ra,24(sp)
    80001a3e:	e822                	sd	s0,16(sp)
    80001a40:	e426                	sd	s1,8(sp)
    80001a42:	1000                	add	s0,sp,32
  push_off();
    80001a44:	fffff097          	auipc	ra,0xfffff
    80001a48:	1e0080e7          	jalr	480(ra) # 80000c24 <push_off>
    80001a4c:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001a4e:	2781                	sext.w	a5,a5
    80001a50:	079e                	sll	a5,a5,0x7
    80001a52:	00010717          	auipc	a4,0x10
    80001a56:	efe70713          	add	a4,a4,-258 # 80011950 <pid_lock>
    80001a5a:	97ba                	add	a5,a5,a4
    80001a5c:	6f84                	ld	s1,24(a5)
  pop_off();
    80001a5e:	fffff097          	auipc	ra,0xfffff
    80001a62:	266080e7          	jalr	614(ra) # 80000cc4 <pop_off>
}
    80001a66:	8526                	mv	a0,s1
    80001a68:	60e2                	ld	ra,24(sp)
    80001a6a:	6442                	ld	s0,16(sp)
    80001a6c:	64a2                	ld	s1,8(sp)
    80001a6e:	6105                	add	sp,sp,32
    80001a70:	8082                	ret

0000000080001a72 <forkret>:
{
    80001a72:	1141                	add	sp,sp,-16
    80001a74:	e406                	sd	ra,8(sp)
    80001a76:	e022                	sd	s0,0(sp)
    80001a78:	0800                	add	s0,sp,16
  release(&myproc()->lock);
    80001a7a:	00000097          	auipc	ra,0x0
    80001a7e:	fc0080e7          	jalr	-64(ra) # 80001a3a <myproc>
    80001a82:	fffff097          	auipc	ra,0xfffff
    80001a86:	2a2080e7          	jalr	674(ra) # 80000d24 <release>
  if (first) {
    80001a8a:	00007797          	auipc	a5,0x7
    80001a8e:	db67a783          	lw	a5,-586(a5) # 80008840 <first.1>
    80001a92:	eb89                	bnez	a5,80001aa4 <forkret+0x32>
  usertrapret();
    80001a94:	00001097          	auipc	ra,0x1
    80001a98:	c66080e7          	jalr	-922(ra) # 800026fa <usertrapret>
}
    80001a9c:	60a2                	ld	ra,8(sp)
    80001a9e:	6402                	ld	s0,0(sp)
    80001aa0:	0141                	add	sp,sp,16
    80001aa2:	8082                	ret
    first = 0;
    80001aa4:	00007797          	auipc	a5,0x7
    80001aa8:	d807ae23          	sw	zero,-612(a5) # 80008840 <first.1>
    fsinit(ROOTDEV);
    80001aac:	4505                	li	a0,1
    80001aae:	00002097          	auipc	ra,0x2
    80001ab2:	af2080e7          	jalr	-1294(ra) # 800035a0 <fsinit>
    80001ab6:	bff9                	j	80001a94 <forkret+0x22>

0000000080001ab8 <allocpid>:
allocpid() {
    80001ab8:	1101                	add	sp,sp,-32
    80001aba:	ec06                	sd	ra,24(sp)
    80001abc:	e822                	sd	s0,16(sp)
    80001abe:	e426                	sd	s1,8(sp)
    80001ac0:	e04a                	sd	s2,0(sp)
    80001ac2:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    80001ac4:	00010917          	auipc	s2,0x10
    80001ac8:	e8c90913          	add	s2,s2,-372 # 80011950 <pid_lock>
    80001acc:	854a                	mv	a0,s2
    80001ace:	fffff097          	auipc	ra,0xfffff
    80001ad2:	1a2080e7          	jalr	418(ra) # 80000c70 <acquire>
  pid = nextpid;
    80001ad6:	00007797          	auipc	a5,0x7
    80001ada:	d6e78793          	add	a5,a5,-658 # 80008844 <nextpid>
    80001ade:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001ae0:	0014871b          	addw	a4,s1,1
    80001ae4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001ae6:	854a                	mv	a0,s2
    80001ae8:	fffff097          	auipc	ra,0xfffff
    80001aec:	23c080e7          	jalr	572(ra) # 80000d24 <release>
}
    80001af0:	8526                	mv	a0,s1
    80001af2:	60e2                	ld	ra,24(sp)
    80001af4:	6442                	ld	s0,16(sp)
    80001af6:	64a2                	ld	s1,8(sp)
    80001af8:	6902                	ld	s2,0(sp)
    80001afa:	6105                	add	sp,sp,32
    80001afc:	8082                	ret

0000000080001afe <proc_pagetable>:
{
    80001afe:	1101                	add	sp,sp,-32
    80001b00:	ec06                	sd	ra,24(sp)
    80001b02:	e822                	sd	s0,16(sp)
    80001b04:	e426                	sd	s1,8(sp)
    80001b06:	e04a                	sd	s2,0(sp)
    80001b08:	1000                	add	s0,sp,32
    80001b0a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001b0c:	00000097          	auipc	ra,0x0
    80001b10:	8e8080e7          	jalr	-1816(ra) # 800013f4 <uvmcreate>
    80001b14:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001b16:	c121                	beqz	a0,80001b56 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001b18:	4729                	li	a4,10
    80001b1a:	00005697          	auipc	a3,0x5
    80001b1e:	4e668693          	add	a3,a3,1254 # 80007000 <_trampoline>
    80001b22:	6605                	lui	a2,0x1
    80001b24:	040005b7          	lui	a1,0x4000
    80001b28:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b2a:	05b2                	sll	a1,a1,0xc
    80001b2c:	fffff097          	auipc	ra,0xfffff
    80001b30:	66c080e7          	jalr	1644(ra) # 80001198 <mappages>
    80001b34:	02054863          	bltz	a0,80001b64 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b38:	4719                	li	a4,6
    80001b3a:	05893683          	ld	a3,88(s2)
    80001b3e:	6605                	lui	a2,0x1
    80001b40:	020005b7          	lui	a1,0x2000
    80001b44:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b46:	05b6                	sll	a1,a1,0xd
    80001b48:	8526                	mv	a0,s1
    80001b4a:	fffff097          	auipc	ra,0xfffff
    80001b4e:	64e080e7          	jalr	1614(ra) # 80001198 <mappages>
    80001b52:	02054163          	bltz	a0,80001b74 <proc_pagetable+0x76>
}
    80001b56:	8526                	mv	a0,s1
    80001b58:	60e2                	ld	ra,24(sp)
    80001b5a:	6442                	ld	s0,16(sp)
    80001b5c:	64a2                	ld	s1,8(sp)
    80001b5e:	6902                	ld	s2,0(sp)
    80001b60:	6105                	add	sp,sp,32
    80001b62:	8082                	ret
    uvmfree(pagetable, 0);
    80001b64:	4581                	li	a1,0
    80001b66:	8526                	mv	a0,s1
    80001b68:	00000097          	auipc	ra,0x0
    80001b6c:	a8a080e7          	jalr	-1398(ra) # 800015f2 <uvmfree>
    return 0;
    80001b70:	4481                	li	s1,0
    80001b72:	b7d5                	j	80001b56 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b74:	4681                	li	a3,0
    80001b76:	4605                	li	a2,1
    80001b78:	040005b7          	lui	a1,0x4000
    80001b7c:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b7e:	05b2                	sll	a1,a1,0xc
    80001b80:	8526                	mv	a0,s1
    80001b82:	fffff097          	auipc	ra,0xfffff
    80001b86:	7ae080e7          	jalr	1966(ra) # 80001330 <uvmunmap>
    uvmfree(pagetable, 0);
    80001b8a:	4581                	li	a1,0
    80001b8c:	8526                	mv	a0,s1
    80001b8e:	00000097          	auipc	ra,0x0
    80001b92:	a64080e7          	jalr	-1436(ra) # 800015f2 <uvmfree>
    return 0;
    80001b96:	4481                	li	s1,0
    80001b98:	bf7d                	j	80001b56 <proc_pagetable+0x58>

0000000080001b9a <proc_freepagetable>:
{
    80001b9a:	1101                	add	sp,sp,-32
    80001b9c:	ec06                	sd	ra,24(sp)
    80001b9e:	e822                	sd	s0,16(sp)
    80001ba0:	e426                	sd	s1,8(sp)
    80001ba2:	e04a                	sd	s2,0(sp)
    80001ba4:	1000                	add	s0,sp,32
    80001ba6:	84aa                	mv	s1,a0
    80001ba8:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001baa:	4681                	li	a3,0
    80001bac:	4605                	li	a2,1
    80001bae:	040005b7          	lui	a1,0x4000
    80001bb2:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001bb4:	05b2                	sll	a1,a1,0xc
    80001bb6:	fffff097          	auipc	ra,0xfffff
    80001bba:	77a080e7          	jalr	1914(ra) # 80001330 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001bbe:	4681                	li	a3,0
    80001bc0:	4605                	li	a2,1
    80001bc2:	020005b7          	lui	a1,0x2000
    80001bc6:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001bc8:	05b6                	sll	a1,a1,0xd
    80001bca:	8526                	mv	a0,s1
    80001bcc:	fffff097          	auipc	ra,0xfffff
    80001bd0:	764080e7          	jalr	1892(ra) # 80001330 <uvmunmap>
  uvmfree(pagetable, sz);
    80001bd4:	85ca                	mv	a1,s2
    80001bd6:	8526                	mv	a0,s1
    80001bd8:	00000097          	auipc	ra,0x0
    80001bdc:	a1a080e7          	jalr	-1510(ra) # 800015f2 <uvmfree>
}
    80001be0:	60e2                	ld	ra,24(sp)
    80001be2:	6442                	ld	s0,16(sp)
    80001be4:	64a2                	ld	s1,8(sp)
    80001be6:	6902                	ld	s2,0(sp)
    80001be8:	6105                	add	sp,sp,32
    80001bea:	8082                	ret

0000000080001bec <freeproc>:
{
    80001bec:	1101                	add	sp,sp,-32
    80001bee:	ec06                	sd	ra,24(sp)
    80001bf0:	e822                	sd	s0,16(sp)
    80001bf2:	e426                	sd	s1,8(sp)
    80001bf4:	1000                	add	s0,sp,32
    80001bf6:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001bf8:	6d28                	ld	a0,88(a0)
    80001bfa:	c509                	beqz	a0,80001c04 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001bfc:	fffff097          	auipc	ra,0xfffff
    80001c00:	e86080e7          	jalr	-378(ra) # 80000a82 <kfree>
  if (p->alarm_trapframe) {
    80001c04:	1804b503          	ld	a0,384(s1)
    80001c08:	c509                	beqz	a0,80001c12 <freeproc+0x26>
    kfree((void*)p->alarm_trapframe);
    80001c0a:	fffff097          	auipc	ra,0xfffff
    80001c0e:	e78080e7          	jalr	-392(ra) # 80000a82 <kfree>
  p->trapframe = 0;
    80001c12:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001c16:	68a8                	ld	a0,80(s1)
    80001c18:	c511                	beqz	a0,80001c24 <freeproc+0x38>
    proc_freepagetable(p->pagetable, p->sz);
    80001c1a:	64ac                	ld	a1,72(s1)
    80001c1c:	00000097          	auipc	ra,0x0
    80001c20:	f7e080e7          	jalr	-130(ra) # 80001b9a <proc_freepagetable>
  p->pagetable = 0;
    80001c24:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001c28:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001c2c:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001c30:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001c34:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001c38:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001c3c:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001c40:	0204aa23          	sw	zero,52(s1)
  p->ticks = 0;
    80001c44:	1604bc23          	sd	zero,376(s1)
  p->handler = 0;
    80001c48:	1604b823          	sd	zero,368(s1)
  p->interval = 0;
    80001c4c:	1604b423          	sd	zero,360(s1)
  p->alarm_goingoff = 0;
    80001c50:	1804a423          	sw	zero,392(s1)
  p->state = UNUSED;
    80001c54:	0004ac23          	sw	zero,24(s1)
}
    80001c58:	60e2                	ld	ra,24(sp)
    80001c5a:	6442                	ld	s0,16(sp)
    80001c5c:	64a2                	ld	s1,8(sp)
    80001c5e:	6105                	add	sp,sp,32
    80001c60:	8082                	ret

0000000080001c62 <allocproc>:
{
    80001c62:	1101                	add	sp,sp,-32
    80001c64:	ec06                	sd	ra,24(sp)
    80001c66:	e822                	sd	s0,16(sp)
    80001c68:	e426                	sd	s1,8(sp)
    80001c6a:	e04a                	sd	s2,0(sp)
    80001c6c:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c6e:	00010497          	auipc	s1,0x10
    80001c72:	0fa48493          	add	s1,s1,250 # 80011d68 <proc>
    80001c76:	00016917          	auipc	s2,0x16
    80001c7a:	4f290913          	add	s2,s2,1266 # 80018168 <tickslock>
    acquire(&p->lock);
    80001c7e:	8526                	mv	a0,s1
    80001c80:	fffff097          	auipc	ra,0xfffff
    80001c84:	ff0080e7          	jalr	-16(ra) # 80000c70 <acquire>
    if(p->state == UNUSED) {
    80001c88:	4c9c                	lw	a5,24(s1)
    80001c8a:	cf81                	beqz	a5,80001ca2 <allocproc+0x40>
      release(&p->lock);
    80001c8c:	8526                	mv	a0,s1
    80001c8e:	fffff097          	auipc	ra,0xfffff
    80001c92:	096080e7          	jalr	150(ra) # 80000d24 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c96:	19048493          	add	s1,s1,400
    80001c9a:	ff2492e3          	bne	s1,s2,80001c7e <allocproc+0x1c>
  return 0;
    80001c9e:	4481                	li	s1,0
    80001ca0:	a0bd                	j	80001d0e <allocproc+0xac>
  p->pid = allocpid();
    80001ca2:	00000097          	auipc	ra,0x0
    80001ca6:	e16080e7          	jalr	-490(ra) # 80001ab8 <allocpid>
    80001caa:	dc88                	sw	a0,56(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001cac:	fffff097          	auipc	ra,0xfffff
    80001cb0:	ed4080e7          	jalr	-300(ra) # 80000b80 <kalloc>
    80001cb4:	892a                	mv	s2,a0
    80001cb6:	eca8                	sd	a0,88(s1)
    80001cb8:	c135                	beqz	a0,80001d1c <allocproc+0xba>
  if((p->alarm_trapframe = (struct trapframe *)kalloc()) == 0){
    80001cba:	fffff097          	auipc	ra,0xfffff
    80001cbe:	ec6080e7          	jalr	-314(ra) # 80000b80 <kalloc>
    80001cc2:	892a                	mv	s2,a0
    80001cc4:	18a4b023          	sd	a0,384(s1)
    80001cc8:	c12d                	beqz	a0,80001d2a <allocproc+0xc8>
  p->pagetable = proc_pagetable(p);
    80001cca:	8526                	mv	a0,s1
    80001ccc:	00000097          	auipc	ra,0x0
    80001cd0:	e32080e7          	jalr	-462(ra) # 80001afe <proc_pagetable>
    80001cd4:	892a                	mv	s2,a0
    80001cd6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001cd8:	c125                	beqz	a0,80001d38 <allocproc+0xd6>
  memset(&p->context, 0, sizeof(p->context));
    80001cda:	07000613          	li	a2,112
    80001cde:	4581                	li	a1,0
    80001ce0:	06048513          	add	a0,s1,96
    80001ce4:	fffff097          	auipc	ra,0xfffff
    80001ce8:	088080e7          	jalr	136(ra) # 80000d6c <memset>
  p->context.ra = (uint64)forkret;
    80001cec:	00000797          	auipc	a5,0x0
    80001cf0:	d8678793          	add	a5,a5,-634 # 80001a72 <forkret>
    80001cf4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001cf6:	60bc                	ld	a5,64(s1)
    80001cf8:	6705                	lui	a4,0x1
    80001cfa:	97ba                	add	a5,a5,a4
    80001cfc:	f4bc                	sd	a5,104(s1)
  p->ticks = 0;
    80001cfe:	1604bc23          	sd	zero,376(s1)
  p->handler = 0;
    80001d02:	1604b823          	sd	zero,368(s1)
  p->interval = 0;
    80001d06:	1604b423          	sd	zero,360(s1)
  p->alarm_goingoff = 0;
    80001d0a:	1804a423          	sw	zero,392(s1)
}
    80001d0e:	8526                	mv	a0,s1
    80001d10:	60e2                	ld	ra,24(sp)
    80001d12:	6442                	ld	s0,16(sp)
    80001d14:	64a2                	ld	s1,8(sp)
    80001d16:	6902                	ld	s2,0(sp)
    80001d18:	6105                	add	sp,sp,32
    80001d1a:	8082                	ret
    release(&p->lock);
    80001d1c:	8526                	mv	a0,s1
    80001d1e:	fffff097          	auipc	ra,0xfffff
    80001d22:	006080e7          	jalr	6(ra) # 80000d24 <release>
    return 0;
    80001d26:	84ca                	mv	s1,s2
    80001d28:	b7dd                	j	80001d0e <allocproc+0xac>
    release(&p->lock);
    80001d2a:	8526                	mv	a0,s1
    80001d2c:	fffff097          	auipc	ra,0xfffff
    80001d30:	ff8080e7          	jalr	-8(ra) # 80000d24 <release>
    return 0;
    80001d34:	84ca                	mv	s1,s2
    80001d36:	bfe1                	j	80001d0e <allocproc+0xac>
    freeproc(p);
    80001d38:	8526                	mv	a0,s1
    80001d3a:	00000097          	auipc	ra,0x0
    80001d3e:	eb2080e7          	jalr	-334(ra) # 80001bec <freeproc>
    release(&p->lock);
    80001d42:	8526                	mv	a0,s1
    80001d44:	fffff097          	auipc	ra,0xfffff
    80001d48:	fe0080e7          	jalr	-32(ra) # 80000d24 <release>
    return 0;
    80001d4c:	84ca                	mv	s1,s2
    80001d4e:	b7c1                	j	80001d0e <allocproc+0xac>

0000000080001d50 <userinit>:
{
    80001d50:	1101                	add	sp,sp,-32
    80001d52:	ec06                	sd	ra,24(sp)
    80001d54:	e822                	sd	s0,16(sp)
    80001d56:	e426                	sd	s1,8(sp)
    80001d58:	1000                	add	s0,sp,32
  p = allocproc();
    80001d5a:	00000097          	auipc	ra,0x0
    80001d5e:	f08080e7          	jalr	-248(ra) # 80001c62 <allocproc>
    80001d62:	84aa                	mv	s1,a0
  initproc = p;
    80001d64:	00007797          	auipc	a5,0x7
    80001d68:	2aa7ba23          	sd	a0,692(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001d6c:	03400613          	li	a2,52
    80001d70:	00007597          	auipc	a1,0x7
    80001d74:	ae058593          	add	a1,a1,-1312 # 80008850 <initcode>
    80001d78:	6928                	ld	a0,80(a0)
    80001d7a:	fffff097          	auipc	ra,0xfffff
    80001d7e:	6a8080e7          	jalr	1704(ra) # 80001422 <uvminit>
  p->sz = PGSIZE;
    80001d82:	6785                	lui	a5,0x1
    80001d84:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001d86:	6cb8                	ld	a4,88(s1)
    80001d88:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001d8c:	6cb8                	ld	a4,88(s1)
    80001d8e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d90:	4641                	li	a2,16
    80001d92:	00006597          	auipc	a1,0x6
    80001d96:	46e58593          	add	a1,a1,1134 # 80008200 <digits+0x1a8>
    80001d9a:	15848513          	add	a0,s1,344
    80001d9e:	fffff097          	auipc	ra,0xfffff
    80001da2:	11e080e7          	jalr	286(ra) # 80000ebc <safestrcpy>
  p->cwd = namei("/");
    80001da6:	00006517          	auipc	a0,0x6
    80001daa:	46a50513          	add	a0,a0,1130 # 80008210 <digits+0x1b8>
    80001dae:	00002097          	auipc	ra,0x2
    80001db2:	216080e7          	jalr	534(ra) # 80003fc4 <namei>
    80001db6:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001dba:	4789                	li	a5,2
    80001dbc:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001dbe:	8526                	mv	a0,s1
    80001dc0:	fffff097          	auipc	ra,0xfffff
    80001dc4:	f64080e7          	jalr	-156(ra) # 80000d24 <release>
}
    80001dc8:	60e2                	ld	ra,24(sp)
    80001dca:	6442                	ld	s0,16(sp)
    80001dcc:	64a2                	ld	s1,8(sp)
    80001dce:	6105                	add	sp,sp,32
    80001dd0:	8082                	ret

0000000080001dd2 <growproc>:
{
    80001dd2:	1101                	add	sp,sp,-32
    80001dd4:	ec06                	sd	ra,24(sp)
    80001dd6:	e822                	sd	s0,16(sp)
    80001dd8:	e426                	sd	s1,8(sp)
    80001dda:	e04a                	sd	s2,0(sp)
    80001ddc:	1000                	add	s0,sp,32
    80001dde:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001de0:	00000097          	auipc	ra,0x0
    80001de4:	c5a080e7          	jalr	-934(ra) # 80001a3a <myproc>
    80001de8:	892a                	mv	s2,a0
  sz = p->sz;
    80001dea:	652c                	ld	a1,72(a0)
    80001dec:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001df0:	00904f63          	bgtz	s1,80001e0e <growproc+0x3c>
  } else if(n < 0){
    80001df4:	0204cd63          	bltz	s1,80001e2e <growproc+0x5c>
  p->sz = sz;
    80001df8:	1782                	sll	a5,a5,0x20
    80001dfa:	9381                	srl	a5,a5,0x20
    80001dfc:	04f93423          	sd	a5,72(s2)
  return 0;
    80001e00:	4501                	li	a0,0
}
    80001e02:	60e2                	ld	ra,24(sp)
    80001e04:	6442                	ld	s0,16(sp)
    80001e06:	64a2                	ld	s1,8(sp)
    80001e08:	6902                	ld	s2,0(sp)
    80001e0a:	6105                	add	sp,sp,32
    80001e0c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001e0e:	00f4863b          	addw	a2,s1,a5
    80001e12:	1602                	sll	a2,a2,0x20
    80001e14:	9201                	srl	a2,a2,0x20
    80001e16:	1582                	sll	a1,a1,0x20
    80001e18:	9181                	srl	a1,a1,0x20
    80001e1a:	6928                	ld	a0,80(a0)
    80001e1c:	fffff097          	auipc	ra,0xfffff
    80001e20:	6c0080e7          	jalr	1728(ra) # 800014dc <uvmalloc>
    80001e24:	0005079b          	sext.w	a5,a0
    80001e28:	fbe1                	bnez	a5,80001df8 <growproc+0x26>
      return -1;
    80001e2a:	557d                	li	a0,-1
    80001e2c:	bfd9                	j	80001e02 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001e2e:	00f4863b          	addw	a2,s1,a5
    80001e32:	1602                	sll	a2,a2,0x20
    80001e34:	9201                	srl	a2,a2,0x20
    80001e36:	1582                	sll	a1,a1,0x20
    80001e38:	9181                	srl	a1,a1,0x20
    80001e3a:	6928                	ld	a0,80(a0)
    80001e3c:	fffff097          	auipc	ra,0xfffff
    80001e40:	658080e7          	jalr	1624(ra) # 80001494 <uvmdealloc>
    80001e44:	0005079b          	sext.w	a5,a0
    80001e48:	bf45                	j	80001df8 <growproc+0x26>

0000000080001e4a <fork>:
{
    80001e4a:	7139                	add	sp,sp,-64
    80001e4c:	fc06                	sd	ra,56(sp)
    80001e4e:	f822                	sd	s0,48(sp)
    80001e50:	f426                	sd	s1,40(sp)
    80001e52:	f04a                	sd	s2,32(sp)
    80001e54:	ec4e                	sd	s3,24(sp)
    80001e56:	e852                	sd	s4,16(sp)
    80001e58:	e456                	sd	s5,8(sp)
    80001e5a:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001e5c:	00000097          	auipc	ra,0x0
    80001e60:	bde080e7          	jalr	-1058(ra) # 80001a3a <myproc>
    80001e64:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001e66:	00000097          	auipc	ra,0x0
    80001e6a:	dfc080e7          	jalr	-516(ra) # 80001c62 <allocproc>
    80001e6e:	c17d                	beqz	a0,80001f54 <fork+0x10a>
    80001e70:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001e72:	048ab603          	ld	a2,72(s5)
    80001e76:	692c                	ld	a1,80(a0)
    80001e78:	050ab503          	ld	a0,80(s5)
    80001e7c:	fffff097          	auipc	ra,0xfffff
    80001e80:	7b0080e7          	jalr	1968(ra) # 8000162c <uvmcopy>
    80001e84:	04054a63          	bltz	a0,80001ed8 <fork+0x8e>
  np->sz = p->sz;
    80001e88:	048ab783          	ld	a5,72(s5)
    80001e8c:	04fa3423          	sd	a5,72(s4)
  np->parent = p;
    80001e90:	035a3023          	sd	s5,32(s4)
  *(np->trapframe) = *(p->trapframe);
    80001e94:	058ab683          	ld	a3,88(s5)
    80001e98:	87b6                	mv	a5,a3
    80001e9a:	058a3703          	ld	a4,88(s4)
    80001e9e:	12068693          	add	a3,a3,288
    80001ea2:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001ea6:	6788                	ld	a0,8(a5)
    80001ea8:	6b8c                	ld	a1,16(a5)
    80001eaa:	6f90                	ld	a2,24(a5)
    80001eac:	01073023          	sd	a6,0(a4)
    80001eb0:	e708                	sd	a0,8(a4)
    80001eb2:	eb0c                	sd	a1,16(a4)
    80001eb4:	ef10                	sd	a2,24(a4)
    80001eb6:	02078793          	add	a5,a5,32
    80001eba:	02070713          	add	a4,a4,32
    80001ebe:	fed792e3          	bne	a5,a3,80001ea2 <fork+0x58>
  np->trapframe->a0 = 0;
    80001ec2:	058a3783          	ld	a5,88(s4)
    80001ec6:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001eca:	0d0a8493          	add	s1,s5,208
    80001ece:	0d0a0913          	add	s2,s4,208
    80001ed2:	150a8993          	add	s3,s5,336
    80001ed6:	a00d                	j	80001ef8 <fork+0xae>
    freeproc(np);
    80001ed8:	8552                	mv	a0,s4
    80001eda:	00000097          	auipc	ra,0x0
    80001ede:	d12080e7          	jalr	-750(ra) # 80001bec <freeproc>
    release(&np->lock);
    80001ee2:	8552                	mv	a0,s4
    80001ee4:	fffff097          	auipc	ra,0xfffff
    80001ee8:	e40080e7          	jalr	-448(ra) # 80000d24 <release>
    return -1;
    80001eec:	54fd                	li	s1,-1
    80001eee:	a889                	j	80001f40 <fork+0xf6>
  for(i = 0; i < NOFILE; i++)
    80001ef0:	04a1                	add	s1,s1,8
    80001ef2:	0921                	add	s2,s2,8
    80001ef4:	01348b63          	beq	s1,s3,80001f0a <fork+0xc0>
    if(p->ofile[i])
    80001ef8:	6088                	ld	a0,0(s1)
    80001efa:	d97d                	beqz	a0,80001ef0 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001efc:	00002097          	auipc	ra,0x2
    80001f00:	730080e7          	jalr	1840(ra) # 8000462c <filedup>
    80001f04:	00a93023          	sd	a0,0(s2)
    80001f08:	b7e5                	j	80001ef0 <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001f0a:	150ab503          	ld	a0,336(s5)
    80001f0e:	00002097          	auipc	ra,0x2
    80001f12:	8c8080e7          	jalr	-1848(ra) # 800037d6 <idup>
    80001f16:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001f1a:	4641                	li	a2,16
    80001f1c:	158a8593          	add	a1,s5,344
    80001f20:	158a0513          	add	a0,s4,344
    80001f24:	fffff097          	auipc	ra,0xfffff
    80001f28:	f98080e7          	jalr	-104(ra) # 80000ebc <safestrcpy>
  pid = np->pid;
    80001f2c:	038a2483          	lw	s1,56(s4)
  np->state = RUNNABLE;
    80001f30:	4789                	li	a5,2
    80001f32:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001f36:	8552                	mv	a0,s4
    80001f38:	fffff097          	auipc	ra,0xfffff
    80001f3c:	dec080e7          	jalr	-532(ra) # 80000d24 <release>
}
    80001f40:	8526                	mv	a0,s1
    80001f42:	70e2                	ld	ra,56(sp)
    80001f44:	7442                	ld	s0,48(sp)
    80001f46:	74a2                	ld	s1,40(sp)
    80001f48:	7902                	ld	s2,32(sp)
    80001f4a:	69e2                	ld	s3,24(sp)
    80001f4c:	6a42                	ld	s4,16(sp)
    80001f4e:	6aa2                	ld	s5,8(sp)
    80001f50:	6121                	add	sp,sp,64
    80001f52:	8082                	ret
    return -1;
    80001f54:	54fd                	li	s1,-1
    80001f56:	b7ed                	j	80001f40 <fork+0xf6>

0000000080001f58 <reparent>:
{
    80001f58:	7179                	add	sp,sp,-48
    80001f5a:	f406                	sd	ra,40(sp)
    80001f5c:	f022                	sd	s0,32(sp)
    80001f5e:	ec26                	sd	s1,24(sp)
    80001f60:	e84a                	sd	s2,16(sp)
    80001f62:	e44e                	sd	s3,8(sp)
    80001f64:	e052                	sd	s4,0(sp)
    80001f66:	1800                	add	s0,sp,48
    80001f68:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f6a:	00010497          	auipc	s1,0x10
    80001f6e:	dfe48493          	add	s1,s1,-514 # 80011d68 <proc>
      pp->parent = initproc;
    80001f72:	00007a17          	auipc	s4,0x7
    80001f76:	0a6a0a13          	add	s4,s4,166 # 80009018 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f7a:	00016997          	auipc	s3,0x16
    80001f7e:	1ee98993          	add	s3,s3,494 # 80018168 <tickslock>
    80001f82:	a029                	j	80001f8c <reparent+0x34>
    80001f84:	19048493          	add	s1,s1,400
    80001f88:	03348363          	beq	s1,s3,80001fae <reparent+0x56>
    if(pp->parent == p){
    80001f8c:	709c                	ld	a5,32(s1)
    80001f8e:	ff279be3          	bne	a5,s2,80001f84 <reparent+0x2c>
      acquire(&pp->lock);
    80001f92:	8526                	mv	a0,s1
    80001f94:	fffff097          	auipc	ra,0xfffff
    80001f98:	cdc080e7          	jalr	-804(ra) # 80000c70 <acquire>
      pp->parent = initproc;
    80001f9c:	000a3783          	ld	a5,0(s4)
    80001fa0:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80001fa2:	8526                	mv	a0,s1
    80001fa4:	fffff097          	auipc	ra,0xfffff
    80001fa8:	d80080e7          	jalr	-640(ra) # 80000d24 <release>
    80001fac:	bfe1                	j	80001f84 <reparent+0x2c>
}
    80001fae:	70a2                	ld	ra,40(sp)
    80001fb0:	7402                	ld	s0,32(sp)
    80001fb2:	64e2                	ld	s1,24(sp)
    80001fb4:	6942                	ld	s2,16(sp)
    80001fb6:	69a2                	ld	s3,8(sp)
    80001fb8:	6a02                	ld	s4,0(sp)
    80001fba:	6145                	add	sp,sp,48
    80001fbc:	8082                	ret

0000000080001fbe <scheduler>:
{
    80001fbe:	715d                	add	sp,sp,-80
    80001fc0:	e486                	sd	ra,72(sp)
    80001fc2:	e0a2                	sd	s0,64(sp)
    80001fc4:	fc26                	sd	s1,56(sp)
    80001fc6:	f84a                	sd	s2,48(sp)
    80001fc8:	f44e                	sd	s3,40(sp)
    80001fca:	f052                	sd	s4,32(sp)
    80001fcc:	ec56                	sd	s5,24(sp)
    80001fce:	e85a                	sd	s6,16(sp)
    80001fd0:	e45e                	sd	s7,8(sp)
    80001fd2:	e062                	sd	s8,0(sp)
    80001fd4:	0880                	add	s0,sp,80
    80001fd6:	8792                	mv	a5,tp
  int id = r_tp();
    80001fd8:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001fda:	00779b13          	sll	s6,a5,0x7
    80001fde:	00010717          	auipc	a4,0x10
    80001fe2:	97270713          	add	a4,a4,-1678 # 80011950 <pid_lock>
    80001fe6:	975a                	add	a4,a4,s6
    80001fe8:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    80001fec:	00010717          	auipc	a4,0x10
    80001ff0:	98470713          	add	a4,a4,-1660 # 80011970 <cpus+0x8>
    80001ff4:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001ff6:	4c0d                	li	s8,3
        c->proc = p;
    80001ff8:	079e                	sll	a5,a5,0x7
    80001ffa:	00010a17          	auipc	s4,0x10
    80001ffe:	956a0a13          	add	s4,s4,-1706 # 80011950 <pid_lock>
    80002002:	9a3e                	add	s4,s4,a5
        found = 1;
    80002004:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80002006:	00016997          	auipc	s3,0x16
    8000200a:	16298993          	add	s3,s3,354 # 80018168 <tickslock>
    8000200e:	a899                	j	80002064 <scheduler+0xa6>
      release(&p->lock);
    80002010:	8526                	mv	a0,s1
    80002012:	fffff097          	auipc	ra,0xfffff
    80002016:	d12080e7          	jalr	-750(ra) # 80000d24 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000201a:	19048493          	add	s1,s1,400
    8000201e:	03348963          	beq	s1,s3,80002050 <scheduler+0x92>
      acquire(&p->lock);
    80002022:	8526                	mv	a0,s1
    80002024:	fffff097          	auipc	ra,0xfffff
    80002028:	c4c080e7          	jalr	-948(ra) # 80000c70 <acquire>
      if(p->state == RUNNABLE) {
    8000202c:	4c9c                	lw	a5,24(s1)
    8000202e:	ff2791e3          	bne	a5,s2,80002010 <scheduler+0x52>
        p->state = RUNNING;
    80002032:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80002036:	009a3c23          	sd	s1,24(s4)
        swtch(&c->context, &p->context);
    8000203a:	06048593          	add	a1,s1,96
    8000203e:	855a                	mv	a0,s6
    80002040:	00000097          	auipc	ra,0x0
    80002044:	610080e7          	jalr	1552(ra) # 80002650 <swtch>
        c->proc = 0;
    80002048:	000a3c23          	sd	zero,24(s4)
        found = 1;
    8000204c:	8ade                	mv	s5,s7
    8000204e:	b7c9                	j	80002010 <scheduler+0x52>
    if(found == 0) {
    80002050:	000a9a63          	bnez	s5,80002064 <scheduler+0xa6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002054:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002058:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000205c:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80002060:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002064:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002068:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000206c:	10079073          	csrw	sstatus,a5
    int found = 0;
    80002070:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80002072:	00010497          	auipc	s1,0x10
    80002076:	cf648493          	add	s1,s1,-778 # 80011d68 <proc>
      if(p->state == RUNNABLE) {
    8000207a:	4909                	li	s2,2
    8000207c:	b75d                	j	80002022 <scheduler+0x64>

000000008000207e <sched>:
{
    8000207e:	7179                	add	sp,sp,-48
    80002080:	f406                	sd	ra,40(sp)
    80002082:	f022                	sd	s0,32(sp)
    80002084:	ec26                	sd	s1,24(sp)
    80002086:	e84a                	sd	s2,16(sp)
    80002088:	e44e                	sd	s3,8(sp)
    8000208a:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    8000208c:	00000097          	auipc	ra,0x0
    80002090:	9ae080e7          	jalr	-1618(ra) # 80001a3a <myproc>
    80002094:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002096:	fffff097          	auipc	ra,0xfffff
    8000209a:	b60080e7          	jalr	-1184(ra) # 80000bf6 <holding>
    8000209e:	c93d                	beqz	a0,80002114 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800020a0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800020a2:	2781                	sext.w	a5,a5
    800020a4:	079e                	sll	a5,a5,0x7
    800020a6:	00010717          	auipc	a4,0x10
    800020aa:	8aa70713          	add	a4,a4,-1878 # 80011950 <pid_lock>
    800020ae:	97ba                	add	a5,a5,a4
    800020b0:	0907a703          	lw	a4,144(a5)
    800020b4:	4785                	li	a5,1
    800020b6:	06f71763          	bne	a4,a5,80002124 <sched+0xa6>
  if(p->state == RUNNING)
    800020ba:	4c98                	lw	a4,24(s1)
    800020bc:	478d                	li	a5,3
    800020be:	06f70b63          	beq	a4,a5,80002134 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020c2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800020c6:	8b89                	and	a5,a5,2
  if(intr_get())
    800020c8:	efb5                	bnez	a5,80002144 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800020ca:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800020cc:	00010917          	auipc	s2,0x10
    800020d0:	88490913          	add	s2,s2,-1916 # 80011950 <pid_lock>
    800020d4:	2781                	sext.w	a5,a5
    800020d6:	079e                	sll	a5,a5,0x7
    800020d8:	97ca                	add	a5,a5,s2
    800020da:	0947a983          	lw	s3,148(a5)
    800020de:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800020e0:	2781                	sext.w	a5,a5
    800020e2:	079e                	sll	a5,a5,0x7
    800020e4:	00010597          	auipc	a1,0x10
    800020e8:	88c58593          	add	a1,a1,-1908 # 80011970 <cpus+0x8>
    800020ec:	95be                	add	a1,a1,a5
    800020ee:	06048513          	add	a0,s1,96
    800020f2:	00000097          	auipc	ra,0x0
    800020f6:	55e080e7          	jalr	1374(ra) # 80002650 <swtch>
    800020fa:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800020fc:	2781                	sext.w	a5,a5
    800020fe:	079e                	sll	a5,a5,0x7
    80002100:	993e                	add	s2,s2,a5
    80002102:	09392a23          	sw	s3,148(s2)
}
    80002106:	70a2                	ld	ra,40(sp)
    80002108:	7402                	ld	s0,32(sp)
    8000210a:	64e2                	ld	s1,24(sp)
    8000210c:	6942                	ld	s2,16(sp)
    8000210e:	69a2                	ld	s3,8(sp)
    80002110:	6145                	add	sp,sp,48
    80002112:	8082                	ret
    panic("sched p->lock");
    80002114:	00006517          	auipc	a0,0x6
    80002118:	10450513          	add	a0,a0,260 # 80008218 <digits+0x1c0>
    8000211c:	ffffe097          	auipc	ra,0xffffe
    80002120:	4c4080e7          	jalr	1220(ra) # 800005e0 <panic>
    panic("sched locks");
    80002124:	00006517          	auipc	a0,0x6
    80002128:	10450513          	add	a0,a0,260 # 80008228 <digits+0x1d0>
    8000212c:	ffffe097          	auipc	ra,0xffffe
    80002130:	4b4080e7          	jalr	1204(ra) # 800005e0 <panic>
    panic("sched running");
    80002134:	00006517          	auipc	a0,0x6
    80002138:	10450513          	add	a0,a0,260 # 80008238 <digits+0x1e0>
    8000213c:	ffffe097          	auipc	ra,0xffffe
    80002140:	4a4080e7          	jalr	1188(ra) # 800005e0 <panic>
    panic("sched interruptible");
    80002144:	00006517          	auipc	a0,0x6
    80002148:	10450513          	add	a0,a0,260 # 80008248 <digits+0x1f0>
    8000214c:	ffffe097          	auipc	ra,0xffffe
    80002150:	494080e7          	jalr	1172(ra) # 800005e0 <panic>

0000000080002154 <exit>:
{
    80002154:	7179                	add	sp,sp,-48
    80002156:	f406                	sd	ra,40(sp)
    80002158:	f022                	sd	s0,32(sp)
    8000215a:	ec26                	sd	s1,24(sp)
    8000215c:	e84a                	sd	s2,16(sp)
    8000215e:	e44e                	sd	s3,8(sp)
    80002160:	e052                	sd	s4,0(sp)
    80002162:	1800                	add	s0,sp,48
    80002164:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002166:	00000097          	auipc	ra,0x0
    8000216a:	8d4080e7          	jalr	-1836(ra) # 80001a3a <myproc>
    8000216e:	89aa                	mv	s3,a0
  if(p == initproc)
    80002170:	00007797          	auipc	a5,0x7
    80002174:	ea87b783          	ld	a5,-344(a5) # 80009018 <initproc>
    80002178:	0d050493          	add	s1,a0,208
    8000217c:	15050913          	add	s2,a0,336
    80002180:	02a79363          	bne	a5,a0,800021a6 <exit+0x52>
    panic("init exiting");
    80002184:	00006517          	auipc	a0,0x6
    80002188:	0dc50513          	add	a0,a0,220 # 80008260 <digits+0x208>
    8000218c:	ffffe097          	auipc	ra,0xffffe
    80002190:	454080e7          	jalr	1108(ra) # 800005e0 <panic>
      fileclose(f);
    80002194:	00002097          	auipc	ra,0x2
    80002198:	4ea080e7          	jalr	1258(ra) # 8000467e <fileclose>
      p->ofile[fd] = 0;
    8000219c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800021a0:	04a1                	add	s1,s1,8
    800021a2:	01248563          	beq	s1,s2,800021ac <exit+0x58>
    if(p->ofile[fd]){
    800021a6:	6088                	ld	a0,0(s1)
    800021a8:	f575                	bnez	a0,80002194 <exit+0x40>
    800021aa:	bfdd                	j	800021a0 <exit+0x4c>
  begin_op();
    800021ac:	00002097          	auipc	ra,0x2
    800021b0:	008080e7          	jalr	8(ra) # 800041b4 <begin_op>
  iput(p->cwd);
    800021b4:	1509b503          	ld	a0,336(s3)
    800021b8:	00002097          	auipc	ra,0x2
    800021bc:	816080e7          	jalr	-2026(ra) # 800039ce <iput>
  end_op();
    800021c0:	00002097          	auipc	ra,0x2
    800021c4:	06e080e7          	jalr	110(ra) # 8000422e <end_op>
  p->cwd = 0;
    800021c8:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    800021cc:	00007497          	auipc	s1,0x7
    800021d0:	e4c48493          	add	s1,s1,-436 # 80009018 <initproc>
    800021d4:	6088                	ld	a0,0(s1)
    800021d6:	fffff097          	auipc	ra,0xfffff
    800021da:	a9a080e7          	jalr	-1382(ra) # 80000c70 <acquire>
  wakeup1(initproc);
    800021de:	6088                	ld	a0,0(s1)
    800021e0:	fffff097          	auipc	ra,0xfffff
    800021e4:	71a080e7          	jalr	1818(ra) # 800018fa <wakeup1>
  release(&initproc->lock);
    800021e8:	6088                	ld	a0,0(s1)
    800021ea:	fffff097          	auipc	ra,0xfffff
    800021ee:	b3a080e7          	jalr	-1222(ra) # 80000d24 <release>
  acquire(&p->lock);
    800021f2:	854e                	mv	a0,s3
    800021f4:	fffff097          	auipc	ra,0xfffff
    800021f8:	a7c080e7          	jalr	-1412(ra) # 80000c70 <acquire>
  struct proc *original_parent = p->parent;
    800021fc:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    80002200:	854e                	mv	a0,s3
    80002202:	fffff097          	auipc	ra,0xfffff
    80002206:	b22080e7          	jalr	-1246(ra) # 80000d24 <release>
  acquire(&original_parent->lock);
    8000220a:	8526                	mv	a0,s1
    8000220c:	fffff097          	auipc	ra,0xfffff
    80002210:	a64080e7          	jalr	-1436(ra) # 80000c70 <acquire>
  acquire(&p->lock);
    80002214:	854e                	mv	a0,s3
    80002216:	fffff097          	auipc	ra,0xfffff
    8000221a:	a5a080e7          	jalr	-1446(ra) # 80000c70 <acquire>
  reparent(p);
    8000221e:	854e                	mv	a0,s3
    80002220:	00000097          	auipc	ra,0x0
    80002224:	d38080e7          	jalr	-712(ra) # 80001f58 <reparent>
  wakeup1(original_parent);
    80002228:	8526                	mv	a0,s1
    8000222a:	fffff097          	auipc	ra,0xfffff
    8000222e:	6d0080e7          	jalr	1744(ra) # 800018fa <wakeup1>
  p->xstate = status;
    80002232:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80002236:	4791                	li	a5,4
    80002238:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    8000223c:	8526                	mv	a0,s1
    8000223e:	fffff097          	auipc	ra,0xfffff
    80002242:	ae6080e7          	jalr	-1306(ra) # 80000d24 <release>
  sched();
    80002246:	00000097          	auipc	ra,0x0
    8000224a:	e38080e7          	jalr	-456(ra) # 8000207e <sched>
  panic("zombie exit");
    8000224e:	00006517          	auipc	a0,0x6
    80002252:	02250513          	add	a0,a0,34 # 80008270 <digits+0x218>
    80002256:	ffffe097          	auipc	ra,0xffffe
    8000225a:	38a080e7          	jalr	906(ra) # 800005e0 <panic>

000000008000225e <yield>:
{
    8000225e:	1101                	add	sp,sp,-32
    80002260:	ec06                	sd	ra,24(sp)
    80002262:	e822                	sd	s0,16(sp)
    80002264:	e426                	sd	s1,8(sp)
    80002266:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    80002268:	fffff097          	auipc	ra,0xfffff
    8000226c:	7d2080e7          	jalr	2002(ra) # 80001a3a <myproc>
    80002270:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002272:	fffff097          	auipc	ra,0xfffff
    80002276:	9fe080e7          	jalr	-1538(ra) # 80000c70 <acquire>
  p->state = RUNNABLE;
    8000227a:	4789                	li	a5,2
    8000227c:	cc9c                	sw	a5,24(s1)
  sched();
    8000227e:	00000097          	auipc	ra,0x0
    80002282:	e00080e7          	jalr	-512(ra) # 8000207e <sched>
  release(&p->lock);
    80002286:	8526                	mv	a0,s1
    80002288:	fffff097          	auipc	ra,0xfffff
    8000228c:	a9c080e7          	jalr	-1380(ra) # 80000d24 <release>
}
    80002290:	60e2                	ld	ra,24(sp)
    80002292:	6442                	ld	s0,16(sp)
    80002294:	64a2                	ld	s1,8(sp)
    80002296:	6105                	add	sp,sp,32
    80002298:	8082                	ret

000000008000229a <sleep>:
{
    8000229a:	7179                	add	sp,sp,-48
    8000229c:	f406                	sd	ra,40(sp)
    8000229e:	f022                	sd	s0,32(sp)
    800022a0:	ec26                	sd	s1,24(sp)
    800022a2:	e84a                	sd	s2,16(sp)
    800022a4:	e44e                	sd	s3,8(sp)
    800022a6:	1800                	add	s0,sp,48
    800022a8:	89aa                	mv	s3,a0
    800022aa:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800022ac:	fffff097          	auipc	ra,0xfffff
    800022b0:	78e080e7          	jalr	1934(ra) # 80001a3a <myproc>
    800022b4:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    800022b6:	05250663          	beq	a0,s2,80002302 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    800022ba:	fffff097          	auipc	ra,0xfffff
    800022be:	9b6080e7          	jalr	-1610(ra) # 80000c70 <acquire>
    release(lk);
    800022c2:	854a                	mv	a0,s2
    800022c4:	fffff097          	auipc	ra,0xfffff
    800022c8:	a60080e7          	jalr	-1440(ra) # 80000d24 <release>
  p->chan = chan;
    800022cc:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800022d0:	4785                	li	a5,1
    800022d2:	cc9c                	sw	a5,24(s1)
  sched();
    800022d4:	00000097          	auipc	ra,0x0
    800022d8:	daa080e7          	jalr	-598(ra) # 8000207e <sched>
  p->chan = 0;
    800022dc:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    800022e0:	8526                	mv	a0,s1
    800022e2:	fffff097          	auipc	ra,0xfffff
    800022e6:	a42080e7          	jalr	-1470(ra) # 80000d24 <release>
    acquire(lk);
    800022ea:	854a                	mv	a0,s2
    800022ec:	fffff097          	auipc	ra,0xfffff
    800022f0:	984080e7          	jalr	-1660(ra) # 80000c70 <acquire>
}
    800022f4:	70a2                	ld	ra,40(sp)
    800022f6:	7402                	ld	s0,32(sp)
    800022f8:	64e2                	ld	s1,24(sp)
    800022fa:	6942                	ld	s2,16(sp)
    800022fc:	69a2                	ld	s3,8(sp)
    800022fe:	6145                	add	sp,sp,48
    80002300:	8082                	ret
  p->chan = chan;
    80002302:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    80002306:	4785                	li	a5,1
    80002308:	cd1c                	sw	a5,24(a0)
  sched();
    8000230a:	00000097          	auipc	ra,0x0
    8000230e:	d74080e7          	jalr	-652(ra) # 8000207e <sched>
  p->chan = 0;
    80002312:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    80002316:	bff9                	j	800022f4 <sleep+0x5a>

0000000080002318 <wait>:
{
    80002318:	715d                	add	sp,sp,-80
    8000231a:	e486                	sd	ra,72(sp)
    8000231c:	e0a2                	sd	s0,64(sp)
    8000231e:	fc26                	sd	s1,56(sp)
    80002320:	f84a                	sd	s2,48(sp)
    80002322:	f44e                	sd	s3,40(sp)
    80002324:	f052                	sd	s4,32(sp)
    80002326:	ec56                	sd	s5,24(sp)
    80002328:	e85a                	sd	s6,16(sp)
    8000232a:	e45e                	sd	s7,8(sp)
    8000232c:	0880                	add	s0,sp,80
    8000232e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002330:	fffff097          	auipc	ra,0xfffff
    80002334:	70a080e7          	jalr	1802(ra) # 80001a3a <myproc>
    80002338:	892a                	mv	s2,a0
  acquire(&p->lock);
    8000233a:	fffff097          	auipc	ra,0xfffff
    8000233e:	936080e7          	jalr	-1738(ra) # 80000c70 <acquire>
    havekids = 0;
    80002342:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80002344:	4a11                	li	s4,4
        havekids = 1;
    80002346:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80002348:	00016997          	auipc	s3,0x16
    8000234c:	e2098993          	add	s3,s3,-480 # 80018168 <tickslock>
    80002350:	a845                	j	80002400 <wait+0xe8>
          pid = np->pid;
    80002352:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002356:	000b0e63          	beqz	s6,80002372 <wait+0x5a>
    8000235a:	4691                	li	a3,4
    8000235c:	03448613          	add	a2,s1,52
    80002360:	85da                	mv	a1,s6
    80002362:	05093503          	ld	a0,80(s2)
    80002366:	fffff097          	auipc	ra,0xfffff
    8000236a:	3ca080e7          	jalr	970(ra) # 80001730 <copyout>
    8000236e:	02054d63          	bltz	a0,800023a8 <wait+0x90>
          freeproc(np);
    80002372:	8526                	mv	a0,s1
    80002374:	00000097          	auipc	ra,0x0
    80002378:	878080e7          	jalr	-1928(ra) # 80001bec <freeproc>
          release(&np->lock);
    8000237c:	8526                	mv	a0,s1
    8000237e:	fffff097          	auipc	ra,0xfffff
    80002382:	9a6080e7          	jalr	-1626(ra) # 80000d24 <release>
          release(&p->lock);
    80002386:	854a                	mv	a0,s2
    80002388:	fffff097          	auipc	ra,0xfffff
    8000238c:	99c080e7          	jalr	-1636(ra) # 80000d24 <release>
}
    80002390:	854e                	mv	a0,s3
    80002392:	60a6                	ld	ra,72(sp)
    80002394:	6406                	ld	s0,64(sp)
    80002396:	74e2                	ld	s1,56(sp)
    80002398:	7942                	ld	s2,48(sp)
    8000239a:	79a2                	ld	s3,40(sp)
    8000239c:	7a02                	ld	s4,32(sp)
    8000239e:	6ae2                	ld	s5,24(sp)
    800023a0:	6b42                	ld	s6,16(sp)
    800023a2:	6ba2                	ld	s7,8(sp)
    800023a4:	6161                	add	sp,sp,80
    800023a6:	8082                	ret
            release(&np->lock);
    800023a8:	8526                	mv	a0,s1
    800023aa:	fffff097          	auipc	ra,0xfffff
    800023ae:	97a080e7          	jalr	-1670(ra) # 80000d24 <release>
            release(&p->lock);
    800023b2:	854a                	mv	a0,s2
    800023b4:	fffff097          	auipc	ra,0xfffff
    800023b8:	970080e7          	jalr	-1680(ra) # 80000d24 <release>
            return -1;
    800023bc:	59fd                	li	s3,-1
    800023be:	bfc9                	j	80002390 <wait+0x78>
    for(np = proc; np < &proc[NPROC]; np++){
    800023c0:	19048493          	add	s1,s1,400
    800023c4:	03348463          	beq	s1,s3,800023ec <wait+0xd4>
      if(np->parent == p){
    800023c8:	709c                	ld	a5,32(s1)
    800023ca:	ff279be3          	bne	a5,s2,800023c0 <wait+0xa8>
        acquire(&np->lock);
    800023ce:	8526                	mv	a0,s1
    800023d0:	fffff097          	auipc	ra,0xfffff
    800023d4:	8a0080e7          	jalr	-1888(ra) # 80000c70 <acquire>
        if(np->state == ZOMBIE){
    800023d8:	4c9c                	lw	a5,24(s1)
    800023da:	f7478ce3          	beq	a5,s4,80002352 <wait+0x3a>
        release(&np->lock);
    800023de:	8526                	mv	a0,s1
    800023e0:	fffff097          	auipc	ra,0xfffff
    800023e4:	944080e7          	jalr	-1724(ra) # 80000d24 <release>
        havekids = 1;
    800023e8:	8756                	mv	a4,s5
    800023ea:	bfd9                	j	800023c0 <wait+0xa8>
    if(!havekids || p->killed){
    800023ec:	c305                	beqz	a4,8000240c <wait+0xf4>
    800023ee:	03092783          	lw	a5,48(s2)
    800023f2:	ef89                	bnez	a5,8000240c <wait+0xf4>
    sleep(p, &p->lock);  //DOC: wait-sleep
    800023f4:	85ca                	mv	a1,s2
    800023f6:	854a                	mv	a0,s2
    800023f8:	00000097          	auipc	ra,0x0
    800023fc:	ea2080e7          	jalr	-350(ra) # 8000229a <sleep>
    havekids = 0;
    80002400:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002402:	00010497          	auipc	s1,0x10
    80002406:	96648493          	add	s1,s1,-1690 # 80011d68 <proc>
    8000240a:	bf7d                	j	800023c8 <wait+0xb0>
      release(&p->lock);
    8000240c:	854a                	mv	a0,s2
    8000240e:	fffff097          	auipc	ra,0xfffff
    80002412:	916080e7          	jalr	-1770(ra) # 80000d24 <release>
      return -1;
    80002416:	59fd                	li	s3,-1
    80002418:	bfa5                	j	80002390 <wait+0x78>

000000008000241a <wakeup>:
{
    8000241a:	7139                	add	sp,sp,-64
    8000241c:	fc06                	sd	ra,56(sp)
    8000241e:	f822                	sd	s0,48(sp)
    80002420:	f426                	sd	s1,40(sp)
    80002422:	f04a                	sd	s2,32(sp)
    80002424:	ec4e                	sd	s3,24(sp)
    80002426:	e852                	sd	s4,16(sp)
    80002428:	e456                	sd	s5,8(sp)
    8000242a:	0080                	add	s0,sp,64
    8000242c:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    8000242e:	00010497          	auipc	s1,0x10
    80002432:	93a48493          	add	s1,s1,-1734 # 80011d68 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    80002436:	4985                	li	s3,1
      p->state = RUNNABLE;
    80002438:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    8000243a:	00016917          	auipc	s2,0x16
    8000243e:	d2e90913          	add	s2,s2,-722 # 80018168 <tickslock>
    80002442:	a811                	j	80002456 <wakeup+0x3c>
    release(&p->lock);
    80002444:	8526                	mv	a0,s1
    80002446:	fffff097          	auipc	ra,0xfffff
    8000244a:	8de080e7          	jalr	-1826(ra) # 80000d24 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000244e:	19048493          	add	s1,s1,400
    80002452:	03248063          	beq	s1,s2,80002472 <wakeup+0x58>
    acquire(&p->lock);
    80002456:	8526                	mv	a0,s1
    80002458:	fffff097          	auipc	ra,0xfffff
    8000245c:	818080e7          	jalr	-2024(ra) # 80000c70 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    80002460:	4c9c                	lw	a5,24(s1)
    80002462:	ff3791e3          	bne	a5,s3,80002444 <wakeup+0x2a>
    80002466:	749c                	ld	a5,40(s1)
    80002468:	fd479ee3          	bne	a5,s4,80002444 <wakeup+0x2a>
      p->state = RUNNABLE;
    8000246c:	0154ac23          	sw	s5,24(s1)
    80002470:	bfd1                	j	80002444 <wakeup+0x2a>
}
    80002472:	70e2                	ld	ra,56(sp)
    80002474:	7442                	ld	s0,48(sp)
    80002476:	74a2                	ld	s1,40(sp)
    80002478:	7902                	ld	s2,32(sp)
    8000247a:	69e2                	ld	s3,24(sp)
    8000247c:	6a42                	ld	s4,16(sp)
    8000247e:	6aa2                	ld	s5,8(sp)
    80002480:	6121                	add	sp,sp,64
    80002482:	8082                	ret

0000000080002484 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002484:	7179                	add	sp,sp,-48
    80002486:	f406                	sd	ra,40(sp)
    80002488:	f022                	sd	s0,32(sp)
    8000248a:	ec26                	sd	s1,24(sp)
    8000248c:	e84a                	sd	s2,16(sp)
    8000248e:	e44e                	sd	s3,8(sp)
    80002490:	1800                	add	s0,sp,48
    80002492:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002494:	00010497          	auipc	s1,0x10
    80002498:	8d448493          	add	s1,s1,-1836 # 80011d68 <proc>
    8000249c:	00016997          	auipc	s3,0x16
    800024a0:	ccc98993          	add	s3,s3,-820 # 80018168 <tickslock>
    acquire(&p->lock);
    800024a4:	8526                	mv	a0,s1
    800024a6:	ffffe097          	auipc	ra,0xffffe
    800024aa:	7ca080e7          	jalr	1994(ra) # 80000c70 <acquire>
    if(p->pid == pid){
    800024ae:	5c9c                	lw	a5,56(s1)
    800024b0:	01278d63          	beq	a5,s2,800024ca <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800024b4:	8526                	mv	a0,s1
    800024b6:	fffff097          	auipc	ra,0xfffff
    800024ba:	86e080e7          	jalr	-1938(ra) # 80000d24 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800024be:	19048493          	add	s1,s1,400
    800024c2:	ff3491e3          	bne	s1,s3,800024a4 <kill+0x20>
  }
  return -1;
    800024c6:	557d                	li	a0,-1
    800024c8:	a821                	j	800024e0 <kill+0x5c>
      p->killed = 1;
    800024ca:	4785                	li	a5,1
    800024cc:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    800024ce:	4c98                	lw	a4,24(s1)
    800024d0:	00f70f63          	beq	a4,a5,800024ee <kill+0x6a>
      release(&p->lock);
    800024d4:	8526                	mv	a0,s1
    800024d6:	fffff097          	auipc	ra,0xfffff
    800024da:	84e080e7          	jalr	-1970(ra) # 80000d24 <release>
      return 0;
    800024de:	4501                	li	a0,0
}
    800024e0:	70a2                	ld	ra,40(sp)
    800024e2:	7402                	ld	s0,32(sp)
    800024e4:	64e2                	ld	s1,24(sp)
    800024e6:	6942                	ld	s2,16(sp)
    800024e8:	69a2                	ld	s3,8(sp)
    800024ea:	6145                	add	sp,sp,48
    800024ec:	8082                	ret
        p->state = RUNNABLE;
    800024ee:	4789                	li	a5,2
    800024f0:	cc9c                	sw	a5,24(s1)
    800024f2:	b7cd                	j	800024d4 <kill+0x50>

00000000800024f4 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800024f4:	7179                	add	sp,sp,-48
    800024f6:	f406                	sd	ra,40(sp)
    800024f8:	f022                	sd	s0,32(sp)
    800024fa:	ec26                	sd	s1,24(sp)
    800024fc:	e84a                	sd	s2,16(sp)
    800024fe:	e44e                	sd	s3,8(sp)
    80002500:	e052                	sd	s4,0(sp)
    80002502:	1800                	add	s0,sp,48
    80002504:	84aa                	mv	s1,a0
    80002506:	892e                	mv	s2,a1
    80002508:	89b2                	mv	s3,a2
    8000250a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000250c:	fffff097          	auipc	ra,0xfffff
    80002510:	52e080e7          	jalr	1326(ra) # 80001a3a <myproc>
  if(user_dst){
    80002514:	c08d                	beqz	s1,80002536 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002516:	86d2                	mv	a3,s4
    80002518:	864e                	mv	a2,s3
    8000251a:	85ca                	mv	a1,s2
    8000251c:	6928                	ld	a0,80(a0)
    8000251e:	fffff097          	auipc	ra,0xfffff
    80002522:	212080e7          	jalr	530(ra) # 80001730 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002526:	70a2                	ld	ra,40(sp)
    80002528:	7402                	ld	s0,32(sp)
    8000252a:	64e2                	ld	s1,24(sp)
    8000252c:	6942                	ld	s2,16(sp)
    8000252e:	69a2                	ld	s3,8(sp)
    80002530:	6a02                	ld	s4,0(sp)
    80002532:	6145                	add	sp,sp,48
    80002534:	8082                	ret
    memmove((char *)dst, src, len);
    80002536:	000a061b          	sext.w	a2,s4
    8000253a:	85ce                	mv	a1,s3
    8000253c:	854a                	mv	a0,s2
    8000253e:	fffff097          	auipc	ra,0xfffff
    80002542:	88a080e7          	jalr	-1910(ra) # 80000dc8 <memmove>
    return 0;
    80002546:	8526                	mv	a0,s1
    80002548:	bff9                	j	80002526 <either_copyout+0x32>

000000008000254a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000254a:	7179                	add	sp,sp,-48
    8000254c:	f406                	sd	ra,40(sp)
    8000254e:	f022                	sd	s0,32(sp)
    80002550:	ec26                	sd	s1,24(sp)
    80002552:	e84a                	sd	s2,16(sp)
    80002554:	e44e                	sd	s3,8(sp)
    80002556:	e052                	sd	s4,0(sp)
    80002558:	1800                	add	s0,sp,48
    8000255a:	892a                	mv	s2,a0
    8000255c:	84ae                	mv	s1,a1
    8000255e:	89b2                	mv	s3,a2
    80002560:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002562:	fffff097          	auipc	ra,0xfffff
    80002566:	4d8080e7          	jalr	1240(ra) # 80001a3a <myproc>
  if(user_src){
    8000256a:	c08d                	beqz	s1,8000258c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000256c:	86d2                	mv	a3,s4
    8000256e:	864e                	mv	a2,s3
    80002570:	85ca                	mv	a1,s2
    80002572:	6928                	ld	a0,80(a0)
    80002574:	fffff097          	auipc	ra,0xfffff
    80002578:	248080e7          	jalr	584(ra) # 800017bc <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000257c:	70a2                	ld	ra,40(sp)
    8000257e:	7402                	ld	s0,32(sp)
    80002580:	64e2                	ld	s1,24(sp)
    80002582:	6942                	ld	s2,16(sp)
    80002584:	69a2                	ld	s3,8(sp)
    80002586:	6a02                	ld	s4,0(sp)
    80002588:	6145                	add	sp,sp,48
    8000258a:	8082                	ret
    memmove(dst, (char*)src, len);
    8000258c:	000a061b          	sext.w	a2,s4
    80002590:	85ce                	mv	a1,s3
    80002592:	854a                	mv	a0,s2
    80002594:	fffff097          	auipc	ra,0xfffff
    80002598:	834080e7          	jalr	-1996(ra) # 80000dc8 <memmove>
    return 0;
    8000259c:	8526                	mv	a0,s1
    8000259e:	bff9                	j	8000257c <either_copyin+0x32>

00000000800025a0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800025a0:	715d                	add	sp,sp,-80
    800025a2:	e486                	sd	ra,72(sp)
    800025a4:	e0a2                	sd	s0,64(sp)
    800025a6:	fc26                	sd	s1,56(sp)
    800025a8:	f84a                	sd	s2,48(sp)
    800025aa:	f44e                	sd	s3,40(sp)
    800025ac:	f052                	sd	s4,32(sp)
    800025ae:	ec56                	sd	s5,24(sp)
    800025b0:	e85a                	sd	s6,16(sp)
    800025b2:	e45e                	sd	s7,8(sp)
    800025b4:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800025b6:	00006517          	auipc	a0,0x6
    800025ba:	b2a50513          	add	a0,a0,-1238 # 800080e0 <digits+0x88>
    800025be:	ffffe097          	auipc	ra,0xffffe
    800025c2:	074080e7          	jalr	116(ra) # 80000632 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025c6:	00010497          	auipc	s1,0x10
    800025ca:	8fa48493          	add	s1,s1,-1798 # 80011ec0 <proc+0x158>
    800025ce:	00016917          	auipc	s2,0x16
    800025d2:	cf290913          	add	s2,s2,-782 # 800182c0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025d6:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    800025d8:	00006997          	auipc	s3,0x6
    800025dc:	ca898993          	add	s3,s3,-856 # 80008280 <digits+0x228>
    printf("%d %s %s", p->pid, state, p->name);
    800025e0:	00006a97          	auipc	s5,0x6
    800025e4:	ca8a8a93          	add	s5,s5,-856 # 80008288 <digits+0x230>
    printf("\n");
    800025e8:	00006a17          	auipc	s4,0x6
    800025ec:	af8a0a13          	add	s4,s4,-1288 # 800080e0 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025f0:	00006b97          	auipc	s7,0x6
    800025f4:	cd0b8b93          	add	s7,s7,-816 # 800082c0 <states.0>
    800025f8:	a00d                	j	8000261a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800025fa:	ee06a583          	lw	a1,-288(a3)
    800025fe:	8556                	mv	a0,s5
    80002600:	ffffe097          	auipc	ra,0xffffe
    80002604:	032080e7          	jalr	50(ra) # 80000632 <printf>
    printf("\n");
    80002608:	8552                	mv	a0,s4
    8000260a:	ffffe097          	auipc	ra,0xffffe
    8000260e:	028080e7          	jalr	40(ra) # 80000632 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002612:	19048493          	add	s1,s1,400
    80002616:	03248263          	beq	s1,s2,8000263a <procdump+0x9a>
    if(p->state == UNUSED)
    8000261a:	86a6                	mv	a3,s1
    8000261c:	ec04a783          	lw	a5,-320(s1)
    80002620:	dbed                	beqz	a5,80002612 <procdump+0x72>
      state = "???";
    80002622:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002624:	fcfb6be3          	bltu	s6,a5,800025fa <procdump+0x5a>
    80002628:	02079713          	sll	a4,a5,0x20
    8000262c:	01d75793          	srl	a5,a4,0x1d
    80002630:	97de                	add	a5,a5,s7
    80002632:	6390                	ld	a2,0(a5)
    80002634:	f279                	bnez	a2,800025fa <procdump+0x5a>
      state = "???";
    80002636:	864e                	mv	a2,s3
    80002638:	b7c9                	j	800025fa <procdump+0x5a>
  }
}
    8000263a:	60a6                	ld	ra,72(sp)
    8000263c:	6406                	ld	s0,64(sp)
    8000263e:	74e2                	ld	s1,56(sp)
    80002640:	7942                	ld	s2,48(sp)
    80002642:	79a2                	ld	s3,40(sp)
    80002644:	7a02                	ld	s4,32(sp)
    80002646:	6ae2                	ld	s5,24(sp)
    80002648:	6b42                	ld	s6,16(sp)
    8000264a:	6ba2                	ld	s7,8(sp)
    8000264c:	6161                	add	sp,sp,80
    8000264e:	8082                	ret

0000000080002650 <swtch>:
    80002650:	00153023          	sd	ra,0(a0)
    80002654:	00253423          	sd	sp,8(a0)
    80002658:	e900                	sd	s0,16(a0)
    8000265a:	ed04                	sd	s1,24(a0)
    8000265c:	03253023          	sd	s2,32(a0)
    80002660:	03353423          	sd	s3,40(a0)
    80002664:	03453823          	sd	s4,48(a0)
    80002668:	03553c23          	sd	s5,56(a0)
    8000266c:	05653023          	sd	s6,64(a0)
    80002670:	05753423          	sd	s7,72(a0)
    80002674:	05853823          	sd	s8,80(a0)
    80002678:	05953c23          	sd	s9,88(a0)
    8000267c:	07a53023          	sd	s10,96(a0)
    80002680:	07b53423          	sd	s11,104(a0)
    80002684:	0005b083          	ld	ra,0(a1)
    80002688:	0085b103          	ld	sp,8(a1)
    8000268c:	6980                	ld	s0,16(a1)
    8000268e:	6d84                	ld	s1,24(a1)
    80002690:	0205b903          	ld	s2,32(a1)
    80002694:	0285b983          	ld	s3,40(a1)
    80002698:	0305ba03          	ld	s4,48(a1)
    8000269c:	0385ba83          	ld	s5,56(a1)
    800026a0:	0405bb03          	ld	s6,64(a1)
    800026a4:	0485bb83          	ld	s7,72(a1)
    800026a8:	0505bc03          	ld	s8,80(a1)
    800026ac:	0585bc83          	ld	s9,88(a1)
    800026b0:	0605bd03          	ld	s10,96(a1)
    800026b4:	0685bd83          	ld	s11,104(a1)
    800026b8:	8082                	ret

00000000800026ba <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800026ba:	1141                	add	sp,sp,-16
    800026bc:	e406                	sd	ra,8(sp)
    800026be:	e022                	sd	s0,0(sp)
    800026c0:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    800026c2:	00006597          	auipc	a1,0x6
    800026c6:	c2658593          	add	a1,a1,-986 # 800082e8 <states.0+0x28>
    800026ca:	00016517          	auipc	a0,0x16
    800026ce:	a9e50513          	add	a0,a0,-1378 # 80018168 <tickslock>
    800026d2:	ffffe097          	auipc	ra,0xffffe
    800026d6:	50e080e7          	jalr	1294(ra) # 80000be0 <initlock>
}
    800026da:	60a2                	ld	ra,8(sp)
    800026dc:	6402                	ld	s0,0(sp)
    800026de:	0141                	add	sp,sp,16
    800026e0:	8082                	ret

00000000800026e2 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800026e2:	1141                	add	sp,sp,-16
    800026e4:	e422                	sd	s0,8(sp)
    800026e6:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026e8:	00003797          	auipc	a5,0x3
    800026ec:	5c878793          	add	a5,a5,1480 # 80005cb0 <kernelvec>
    800026f0:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800026f4:	6422                	ld	s0,8(sp)
    800026f6:	0141                	add	sp,sp,16
    800026f8:	8082                	ret

00000000800026fa <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800026fa:	1141                	add	sp,sp,-16
    800026fc:	e406                	sd	ra,8(sp)
    800026fe:	e022                	sd	s0,0(sp)
    80002700:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80002702:	fffff097          	auipc	ra,0xfffff
    80002706:	338080e7          	jalr	824(ra) # 80001a3a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000270a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000270e:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002710:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002714:	00005697          	auipc	a3,0x5
    80002718:	8ec68693          	add	a3,a3,-1812 # 80007000 <_trampoline>
    8000271c:	00005717          	auipc	a4,0x5
    80002720:	8e470713          	add	a4,a4,-1820 # 80007000 <_trampoline>
    80002724:	8f15                	sub	a4,a4,a3
    80002726:	040007b7          	lui	a5,0x4000
    8000272a:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000272c:	07b2                	sll	a5,a5,0xc
    8000272e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002730:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002734:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002736:	18002673          	csrr	a2,satp
    8000273a:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000273c:	6d30                	ld	a2,88(a0)
    8000273e:	6138                	ld	a4,64(a0)
    80002740:	6585                	lui	a1,0x1
    80002742:	972e                	add	a4,a4,a1
    80002744:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002746:	6d38                	ld	a4,88(a0)
    80002748:	00000617          	auipc	a2,0x0
    8000274c:	13c60613          	add	a2,a2,316 # 80002884 <usertrap>
    80002750:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002752:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002754:	8612                	mv	a2,tp
    80002756:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002758:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000275c:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002760:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002764:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002768:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000276a:	6f18                	ld	a4,24(a4)
    8000276c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002770:	692c                	ld	a1,80(a0)
    80002772:	81b1                	srl	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002774:	00005717          	auipc	a4,0x5
    80002778:	91c70713          	add	a4,a4,-1764 # 80007090 <userret>
    8000277c:	8f15                	sub	a4,a4,a3
    8000277e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002780:	577d                	li	a4,-1
    80002782:	177e                	sll	a4,a4,0x3f
    80002784:	8dd9                	or	a1,a1,a4
    80002786:	02000537          	lui	a0,0x2000
    8000278a:	157d                	add	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000278c:	0536                	sll	a0,a0,0xd
    8000278e:	9782                	jalr	a5
}
    80002790:	60a2                	ld	ra,8(sp)
    80002792:	6402                	ld	s0,0(sp)
    80002794:	0141                	add	sp,sp,16
    80002796:	8082                	ret

0000000080002798 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002798:	1101                	add	sp,sp,-32
    8000279a:	ec06                	sd	ra,24(sp)
    8000279c:	e822                	sd	s0,16(sp)
    8000279e:	e426                	sd	s1,8(sp)
    800027a0:	1000                	add	s0,sp,32
  acquire(&tickslock);
    800027a2:	00016497          	auipc	s1,0x16
    800027a6:	9c648493          	add	s1,s1,-1594 # 80018168 <tickslock>
    800027aa:	8526                	mv	a0,s1
    800027ac:	ffffe097          	auipc	ra,0xffffe
    800027b0:	4c4080e7          	jalr	1220(ra) # 80000c70 <acquire>
  ticks++;
    800027b4:	00007517          	auipc	a0,0x7
    800027b8:	86c50513          	add	a0,a0,-1940 # 80009020 <ticks>
    800027bc:	411c                	lw	a5,0(a0)
    800027be:	2785                	addw	a5,a5,1
    800027c0:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    800027c2:	00000097          	auipc	ra,0x0
    800027c6:	c58080e7          	jalr	-936(ra) # 8000241a <wakeup>
  release(&tickslock);
    800027ca:	8526                	mv	a0,s1
    800027cc:	ffffe097          	auipc	ra,0xffffe
    800027d0:	558080e7          	jalr	1368(ra) # 80000d24 <release>
}
    800027d4:	60e2                	ld	ra,24(sp)
    800027d6:	6442                	ld	s0,16(sp)
    800027d8:	64a2                	ld	s1,8(sp)
    800027da:	6105                	add	sp,sp,32
    800027dc:	8082                	ret

00000000800027de <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027de:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800027e2:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    800027e4:	0807df63          	bgez	a5,80002882 <devintr+0xa4>
{
    800027e8:	1101                	add	sp,sp,-32
    800027ea:	ec06                	sd	ra,24(sp)
    800027ec:	e822                	sd	s0,16(sp)
    800027ee:	e426                	sd	s1,8(sp)
    800027f0:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    800027f2:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    800027f6:	46a5                	li	a3,9
    800027f8:	00d70d63          	beq	a4,a3,80002812 <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    800027fc:	577d                	li	a4,-1
    800027fe:	177e                	sll	a4,a4,0x3f
    80002800:	0705                	add	a4,a4,1
    return 0;
    80002802:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002804:	04e78e63          	beq	a5,a4,80002860 <devintr+0x82>
  }
}
    80002808:	60e2                	ld	ra,24(sp)
    8000280a:	6442                	ld	s0,16(sp)
    8000280c:	64a2                	ld	s1,8(sp)
    8000280e:	6105                	add	sp,sp,32
    80002810:	8082                	ret
    int irq = plic_claim();
    80002812:	00003097          	auipc	ra,0x3
    80002816:	5a6080e7          	jalr	1446(ra) # 80005db8 <plic_claim>
    8000281a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000281c:	47a9                	li	a5,10
    8000281e:	02f50763          	beq	a0,a5,8000284c <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80002822:	4785                	li	a5,1
    80002824:	02f50963          	beq	a0,a5,80002856 <devintr+0x78>
    return 1;
    80002828:	4505                	li	a0,1
    } else if(irq){
    8000282a:	dcf9                	beqz	s1,80002808 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    8000282c:	85a6                	mv	a1,s1
    8000282e:	00006517          	auipc	a0,0x6
    80002832:	ac250513          	add	a0,a0,-1342 # 800082f0 <states.0+0x30>
    80002836:	ffffe097          	auipc	ra,0xffffe
    8000283a:	dfc080e7          	jalr	-516(ra) # 80000632 <printf>
      plic_complete(irq);
    8000283e:	8526                	mv	a0,s1
    80002840:	00003097          	auipc	ra,0x3
    80002844:	59c080e7          	jalr	1436(ra) # 80005ddc <plic_complete>
    return 1;
    80002848:	4505                	li	a0,1
    8000284a:	bf7d                	j	80002808 <devintr+0x2a>
      uartintr();
    8000284c:	ffffe097          	auipc	ra,0xffffe
    80002850:	1e6080e7          	jalr	486(ra) # 80000a32 <uartintr>
    if(irq)
    80002854:	b7ed                	j	8000283e <devintr+0x60>
      virtio_disk_intr();
    80002856:	00004097          	auipc	ra,0x4
    8000285a:	9f8080e7          	jalr	-1544(ra) # 8000624e <virtio_disk_intr>
    if(irq)
    8000285e:	b7c5                	j	8000283e <devintr+0x60>
    if(cpuid() == 0){
    80002860:	fffff097          	auipc	ra,0xfffff
    80002864:	1ae080e7          	jalr	430(ra) # 80001a0e <cpuid>
    80002868:	c901                	beqz	a0,80002878 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    8000286a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000286e:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002870:	14479073          	csrw	sip,a5
    return 2;
    80002874:	4509                	li	a0,2
    80002876:	bf49                	j	80002808 <devintr+0x2a>
      clockintr();
    80002878:	00000097          	auipc	ra,0x0
    8000287c:	f20080e7          	jalr	-224(ra) # 80002798 <clockintr>
    80002880:	b7ed                	j	8000286a <devintr+0x8c>
}
    80002882:	8082                	ret

0000000080002884 <usertrap>:
{
    80002884:	1101                	add	sp,sp,-32
    80002886:	ec06                	sd	ra,24(sp)
    80002888:	e822                	sd	s0,16(sp)
    8000288a:	e426                	sd	s1,8(sp)
    8000288c:	e04a                	sd	s2,0(sp)
    8000288e:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002890:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002894:	1007f793          	and	a5,a5,256
    80002898:	e3b5                	bnez	a5,800028fc <usertrap+0x78>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000289a:	00003797          	auipc	a5,0x3
    8000289e:	41678793          	add	a5,a5,1046 # 80005cb0 <kernelvec>
    800028a2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800028a6:	fffff097          	auipc	ra,0xfffff
    800028aa:	194080e7          	jalr	404(ra) # 80001a3a <myproc>
    800028ae:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800028b0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028b2:	14102773          	csrr	a4,sepc
    800028b6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028b8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800028bc:	47a1                	li	a5,8
    800028be:	04f71d63          	bne	a4,a5,80002918 <usertrap+0x94>
    if(p->killed)
    800028c2:	591c                	lw	a5,48(a0)
    800028c4:	e7a1                	bnez	a5,8000290c <usertrap+0x88>
    p->trapframe->epc += 4;
    800028c6:	6cb8                	ld	a4,88(s1)
    800028c8:	6f1c                	ld	a5,24(a4)
    800028ca:	0791                	add	a5,a5,4
    800028cc:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028ce:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800028d2:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028d6:	10079073          	csrw	sstatus,a5
    syscall();
    800028da:	00000097          	auipc	ra,0x0
    800028de:	3d8080e7          	jalr	984(ra) # 80002cb2 <syscall>
  int which_dev = 0;
    800028e2:	4901                	li	s2,0
  if(p->killed)
    800028e4:	589c                	lw	a5,48(s1)
    800028e6:	ebe5                	bnez	a5,800029d6 <usertrap+0x152>
  usertrapret();
    800028e8:	00000097          	auipc	ra,0x0
    800028ec:	e12080e7          	jalr	-494(ra) # 800026fa <usertrapret>
}
    800028f0:	60e2                	ld	ra,24(sp)
    800028f2:	6442                	ld	s0,16(sp)
    800028f4:	64a2                	ld	s1,8(sp)
    800028f6:	6902                	ld	s2,0(sp)
    800028f8:	6105                	add	sp,sp,32
    800028fa:	8082                	ret
    panic("usertrap: not from user mode");
    800028fc:	00006517          	auipc	a0,0x6
    80002900:	a1450513          	add	a0,a0,-1516 # 80008310 <states.0+0x50>
    80002904:	ffffe097          	auipc	ra,0xffffe
    80002908:	cdc080e7          	jalr	-804(ra) # 800005e0 <panic>
      exit(-1);
    8000290c:	557d                	li	a0,-1
    8000290e:	00000097          	auipc	ra,0x0
    80002912:	846080e7          	jalr	-1978(ra) # 80002154 <exit>
    80002916:	bf45                	j	800028c6 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002918:	00000097          	auipc	ra,0x0
    8000291c:	ec6080e7          	jalr	-314(ra) # 800027de <devintr>
    80002920:	892a                	mv	s2,a0
    80002922:	c93d                	beqz	a0,80002998 <usertrap+0x114>
    if (which_dev == 2) {
    80002924:	4789                	li	a5,2
    80002926:	faf51fe3          	bne	a0,a5,800028e4 <usertrap+0x60>
      if (p->interval != 0) { // 设定了时钟条件
    8000292a:	1684b783          	ld	a5,360(s1)
    8000292e:	cb91                	beqz	a5,80002942 <usertrap+0xbe>
        if (p->ticks == p->interval && p->alarm_goingoff == 0) {
    80002930:	1784b703          	ld	a4,376(s1)
    80002934:	00e78f63          	beq	a5,a4,80002952 <usertrap+0xce>
        p->ticks++; // cpu每产生一次timer中断计数++
    80002938:	1784b783          	ld	a5,376(s1)
    8000293c:	0785                	add	a5,a5,1
    8000293e:	16f4bc23          	sd	a5,376(s1)
  if(p->killed)
    80002942:	589c                	lw	a5,48(s1)
    80002944:	c3cd                	beqz	a5,800029e6 <usertrap+0x162>
    exit(-1);
    80002946:	557d                	li	a0,-1
    80002948:	00000097          	auipc	ra,0x0
    8000294c:	80c080e7          	jalr	-2036(ra) # 80002154 <exit>
  if(which_dev == 2)
    80002950:	a859                	j	800029e6 <usertrap+0x162>
        if (p->ticks == p->interval && p->alarm_goingoff == 0) {
    80002952:	1884a783          	lw	a5,392(s1)
    80002956:	f3ed                	bnez	a5,80002938 <usertrap+0xb4>
          p->ticks = 0;
    80002958:	1604bc23          	sd	zero,376(s1)
          *(p->alarm_trapframe) = *(p->trapframe);
    8000295c:	6cb4                	ld	a3,88(s1)
    8000295e:	87b6                	mv	a5,a3
    80002960:	1804b703          	ld	a4,384(s1)
    80002964:	12068693          	add	a3,a3,288
    80002968:	0007b803          	ld	a6,0(a5)
    8000296c:	6788                	ld	a0,8(a5)
    8000296e:	6b8c                	ld	a1,16(a5)
    80002970:	6f90                	ld	a2,24(a5)
    80002972:	01073023          	sd	a6,0(a4)
    80002976:	e708                	sd	a0,8(a4)
    80002978:	eb0c                	sd	a1,16(a4)
    8000297a:	ef10                	sd	a2,24(a4)
    8000297c:	02078793          	add	a5,a5,32
    80002980:	02070713          	add	a4,a4,32
    80002984:	fed792e3          	bne	a5,a3,80002968 <usertrap+0xe4>
          p->trapframe->epc = (uint64)p->handler;
    80002988:	6cbc                	ld	a5,88(s1)
    8000298a:	1704b703          	ld	a4,368(s1)
    8000298e:	ef98                	sd	a4,24(a5)
          p->alarm_goingoff = 1; // 不允许递归触发handler
    80002990:	4785                	li	a5,1
    80002992:	18f4a423          	sw	a5,392(s1)
    80002996:	b74d                	j	80002938 <usertrap+0xb4>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002998:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000299c:	5c90                	lw	a2,56(s1)
    8000299e:	00006517          	auipc	a0,0x6
    800029a2:	99250513          	add	a0,a0,-1646 # 80008330 <states.0+0x70>
    800029a6:	ffffe097          	auipc	ra,0xffffe
    800029aa:	c8c080e7          	jalr	-884(ra) # 80000632 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029ae:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800029b2:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800029b6:	00006517          	auipc	a0,0x6
    800029ba:	9aa50513          	add	a0,a0,-1622 # 80008360 <states.0+0xa0>
    800029be:	ffffe097          	auipc	ra,0xffffe
    800029c2:	c74080e7          	jalr	-908(ra) # 80000632 <printf>
    p->killed = 1;
    800029c6:	4785                	li	a5,1
    800029c8:	d89c                	sw	a5,48(s1)
    exit(-1);
    800029ca:	557d                	li	a0,-1
    800029cc:	fffff097          	auipc	ra,0xfffff
    800029d0:	788080e7          	jalr	1928(ra) # 80002154 <exit>
  if(which_dev == 2)
    800029d4:	bf11                	j	800028e8 <usertrap+0x64>
    exit(-1);
    800029d6:	557d                	li	a0,-1
    800029d8:	fffff097          	auipc	ra,0xfffff
    800029dc:	77c080e7          	jalr	1916(ra) # 80002154 <exit>
  if(which_dev == 2)
    800029e0:	4789                	li	a5,2
    800029e2:	f0f913e3          	bne	s2,a5,800028e8 <usertrap+0x64>
    yield();
    800029e6:	00000097          	auipc	ra,0x0
    800029ea:	878080e7          	jalr	-1928(ra) # 8000225e <yield>
    800029ee:	bded                	j	800028e8 <usertrap+0x64>

00000000800029f0 <kerneltrap>:
{
    800029f0:	7179                	add	sp,sp,-48
    800029f2:	f406                	sd	ra,40(sp)
    800029f4:	f022                	sd	s0,32(sp)
    800029f6:	ec26                	sd	s1,24(sp)
    800029f8:	e84a                	sd	s2,16(sp)
    800029fa:	e44e                	sd	s3,8(sp)
    800029fc:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029fe:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a02:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a06:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002a0a:	1004f793          	and	a5,s1,256
    80002a0e:	cb85                	beqz	a5,80002a3e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a10:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002a14:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80002a16:	ef85                	bnez	a5,80002a4e <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002a18:	00000097          	auipc	ra,0x0
    80002a1c:	dc6080e7          	jalr	-570(ra) # 800027de <devintr>
    80002a20:	cd1d                	beqz	a0,80002a5e <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002a22:	4789                	li	a5,2
    80002a24:	06f50a63          	beq	a0,a5,80002a98 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a28:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a2c:	10049073          	csrw	sstatus,s1
}
    80002a30:	70a2                	ld	ra,40(sp)
    80002a32:	7402                	ld	s0,32(sp)
    80002a34:	64e2                	ld	s1,24(sp)
    80002a36:	6942                	ld	s2,16(sp)
    80002a38:	69a2                	ld	s3,8(sp)
    80002a3a:	6145                	add	sp,sp,48
    80002a3c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002a3e:	00006517          	auipc	a0,0x6
    80002a42:	94250513          	add	a0,a0,-1726 # 80008380 <states.0+0xc0>
    80002a46:	ffffe097          	auipc	ra,0xffffe
    80002a4a:	b9a080e7          	jalr	-1126(ra) # 800005e0 <panic>
    panic("kerneltrap: interrupts enabled");
    80002a4e:	00006517          	auipc	a0,0x6
    80002a52:	95a50513          	add	a0,a0,-1702 # 800083a8 <states.0+0xe8>
    80002a56:	ffffe097          	auipc	ra,0xffffe
    80002a5a:	b8a080e7          	jalr	-1142(ra) # 800005e0 <panic>
    printf("scause %p\n", scause);
    80002a5e:	85ce                	mv	a1,s3
    80002a60:	00006517          	auipc	a0,0x6
    80002a64:	96850513          	add	a0,a0,-1688 # 800083c8 <states.0+0x108>
    80002a68:	ffffe097          	auipc	ra,0xffffe
    80002a6c:	bca080e7          	jalr	-1078(ra) # 80000632 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a70:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a74:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002a78:	00006517          	auipc	a0,0x6
    80002a7c:	96050513          	add	a0,a0,-1696 # 800083d8 <states.0+0x118>
    80002a80:	ffffe097          	auipc	ra,0xffffe
    80002a84:	bb2080e7          	jalr	-1102(ra) # 80000632 <printf>
    panic("kerneltrap");
    80002a88:	00006517          	auipc	a0,0x6
    80002a8c:	96850513          	add	a0,a0,-1688 # 800083f0 <states.0+0x130>
    80002a90:	ffffe097          	auipc	ra,0xffffe
    80002a94:	b50080e7          	jalr	-1200(ra) # 800005e0 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002a98:	fffff097          	auipc	ra,0xfffff
    80002a9c:	fa2080e7          	jalr	-94(ra) # 80001a3a <myproc>
    80002aa0:	d541                	beqz	a0,80002a28 <kerneltrap+0x38>
    80002aa2:	fffff097          	auipc	ra,0xfffff
    80002aa6:	f98080e7          	jalr	-104(ra) # 80001a3a <myproc>
    80002aaa:	4d18                	lw	a4,24(a0)
    80002aac:	478d                	li	a5,3
    80002aae:	f6f71de3          	bne	a4,a5,80002a28 <kerneltrap+0x38>
    yield();
    80002ab2:	fffff097          	auipc	ra,0xfffff
    80002ab6:	7ac080e7          	jalr	1964(ra) # 8000225e <yield>
    80002aba:	b7bd                	j	80002a28 <kerneltrap+0x38>

0000000080002abc <sigalarm>:

int sigalarm(int ticks, void(*handler)()) {
    80002abc:	1101                	add	sp,sp,-32
    80002abe:	ec06                	sd	ra,24(sp)
    80002ac0:	e822                	sd	s0,16(sp)
    80002ac2:	e426                	sd	s1,8(sp)
    80002ac4:	e04a                	sd	s2,0(sp)
    80002ac6:	1000                	add	s0,sp,32
    80002ac8:	892a                	mv	s2,a0
    80002aca:	84ae                	mv	s1,a1
    // 初始化alarm时设置该进程的计数大小以及对于alarm函数
  struct proc *p = myproc();
    80002acc:	fffff097          	auipc	ra,0xfffff
    80002ad0:	f6e080e7          	jalr	-146(ra) # 80001a3a <myproc>
  p->interval = ticks;
    80002ad4:	17253423          	sd	s2,360(a0)
  p->handler = handler;
    80002ad8:	16953823          	sd	s1,368(a0)
  p->ticks = 0;
    80002adc:	16053c23          	sd	zero,376(a0)
  return 0; 
}
    80002ae0:	4501                	li	a0,0
    80002ae2:	60e2                	ld	ra,24(sp)
    80002ae4:	6442                	ld	s0,16(sp)
    80002ae6:	64a2                	ld	s1,8(sp)
    80002ae8:	6902                	ld	s2,0(sp)
    80002aea:	6105                	add	sp,sp,32
    80002aec:	8082                	ret

0000000080002aee <sigreturn>:
int sigreturn() {
    80002aee:	1141                	add	sp,sp,-16
    80002af0:	e406                	sd	ra,8(sp)
    80002af2:	e022                	sd	s0,0(sp)
    80002af4:	0800                	add	s0,sp,16
    // alarm返回时将备份的trapframe寄存器恢复，确保回退时cpu状态和进入中断时一致，对被中断函数透明
  struct proc *p = myproc();
    80002af6:	fffff097          	auipc	ra,0xfffff
    80002afa:	f44080e7          	jalr	-188(ra) # 80001a3a <myproc>
  *(p->trapframe) = *(p->alarm_trapframe);
    80002afe:	18053683          	ld	a3,384(a0)
    80002b02:	87b6                	mv	a5,a3
    80002b04:	6d38                	ld	a4,88(a0)
    80002b06:	12068693          	add	a3,a3,288
    80002b0a:	0007b883          	ld	a7,0(a5)
    80002b0e:	0087b803          	ld	a6,8(a5)
    80002b12:	6b8c                	ld	a1,16(a5)
    80002b14:	6f90                	ld	a2,24(a5)
    80002b16:	01173023          	sd	a7,0(a4)
    80002b1a:	01073423          	sd	a6,8(a4)
    80002b1e:	eb0c                	sd	a1,16(a4)
    80002b20:	ef10                	sd	a2,24(a4)
    80002b22:	02078793          	add	a5,a5,32
    80002b26:	02070713          	add	a4,a4,32
    80002b2a:	fed790e3          	bne	a5,a3,80002b0a <sigreturn+0x1c>
    // 清除进入alarm标志位，确保能再次进入
  p->alarm_goingoff = 0;
    80002b2e:	18052423          	sw	zero,392(a0)
  return 0;
}
    80002b32:	4501                	li	a0,0
    80002b34:	60a2                	ld	ra,8(sp)
    80002b36:	6402                	ld	s0,0(sp)
    80002b38:	0141                	add	sp,sp,16
    80002b3a:	8082                	ret

0000000080002b3c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002b3c:	1101                	add	sp,sp,-32
    80002b3e:	ec06                	sd	ra,24(sp)
    80002b40:	e822                	sd	s0,16(sp)
    80002b42:	e426                	sd	s1,8(sp)
    80002b44:	1000                	add	s0,sp,32
    80002b46:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002b48:	fffff097          	auipc	ra,0xfffff
    80002b4c:	ef2080e7          	jalr	-270(ra) # 80001a3a <myproc>
  switch (n) {
    80002b50:	4795                	li	a5,5
    80002b52:	0497e163          	bltu	a5,s1,80002b94 <argraw+0x58>
    80002b56:	048a                	sll	s1,s1,0x2
    80002b58:	00006717          	auipc	a4,0x6
    80002b5c:	8d070713          	add	a4,a4,-1840 # 80008428 <states.0+0x168>
    80002b60:	94ba                	add	s1,s1,a4
    80002b62:	409c                	lw	a5,0(s1)
    80002b64:	97ba                	add	a5,a5,a4
    80002b66:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002b68:	6d3c                	ld	a5,88(a0)
    80002b6a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002b6c:	60e2                	ld	ra,24(sp)
    80002b6e:	6442                	ld	s0,16(sp)
    80002b70:	64a2                	ld	s1,8(sp)
    80002b72:	6105                	add	sp,sp,32
    80002b74:	8082                	ret
    return p->trapframe->a1;
    80002b76:	6d3c                	ld	a5,88(a0)
    80002b78:	7fa8                	ld	a0,120(a5)
    80002b7a:	bfcd                	j	80002b6c <argraw+0x30>
    return p->trapframe->a2;
    80002b7c:	6d3c                	ld	a5,88(a0)
    80002b7e:	63c8                	ld	a0,128(a5)
    80002b80:	b7f5                	j	80002b6c <argraw+0x30>
    return p->trapframe->a3;
    80002b82:	6d3c                	ld	a5,88(a0)
    80002b84:	67c8                	ld	a0,136(a5)
    80002b86:	b7dd                	j	80002b6c <argraw+0x30>
    return p->trapframe->a4;
    80002b88:	6d3c                	ld	a5,88(a0)
    80002b8a:	6bc8                	ld	a0,144(a5)
    80002b8c:	b7c5                	j	80002b6c <argraw+0x30>
    return p->trapframe->a5;
    80002b8e:	6d3c                	ld	a5,88(a0)
    80002b90:	6fc8                	ld	a0,152(a5)
    80002b92:	bfe9                	j	80002b6c <argraw+0x30>
  panic("argraw");
    80002b94:	00006517          	auipc	a0,0x6
    80002b98:	86c50513          	add	a0,a0,-1940 # 80008400 <states.0+0x140>
    80002b9c:	ffffe097          	auipc	ra,0xffffe
    80002ba0:	a44080e7          	jalr	-1468(ra) # 800005e0 <panic>

0000000080002ba4 <fetchaddr>:
{
    80002ba4:	1101                	add	sp,sp,-32
    80002ba6:	ec06                	sd	ra,24(sp)
    80002ba8:	e822                	sd	s0,16(sp)
    80002baa:	e426                	sd	s1,8(sp)
    80002bac:	e04a                	sd	s2,0(sp)
    80002bae:	1000                	add	s0,sp,32
    80002bb0:	84aa                	mv	s1,a0
    80002bb2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002bb4:	fffff097          	auipc	ra,0xfffff
    80002bb8:	e86080e7          	jalr	-378(ra) # 80001a3a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002bbc:	653c                	ld	a5,72(a0)
    80002bbe:	02f4f863          	bgeu	s1,a5,80002bee <fetchaddr+0x4a>
    80002bc2:	00848713          	add	a4,s1,8
    80002bc6:	02e7e663          	bltu	a5,a4,80002bf2 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002bca:	46a1                	li	a3,8
    80002bcc:	8626                	mv	a2,s1
    80002bce:	85ca                	mv	a1,s2
    80002bd0:	6928                	ld	a0,80(a0)
    80002bd2:	fffff097          	auipc	ra,0xfffff
    80002bd6:	bea080e7          	jalr	-1046(ra) # 800017bc <copyin>
    80002bda:	00a03533          	snez	a0,a0
    80002bde:	40a00533          	neg	a0,a0
}
    80002be2:	60e2                	ld	ra,24(sp)
    80002be4:	6442                	ld	s0,16(sp)
    80002be6:	64a2                	ld	s1,8(sp)
    80002be8:	6902                	ld	s2,0(sp)
    80002bea:	6105                	add	sp,sp,32
    80002bec:	8082                	ret
    return -1;
    80002bee:	557d                	li	a0,-1
    80002bf0:	bfcd                	j	80002be2 <fetchaddr+0x3e>
    80002bf2:	557d                	li	a0,-1
    80002bf4:	b7fd                	j	80002be2 <fetchaddr+0x3e>

0000000080002bf6 <fetchstr>:
{
    80002bf6:	7179                	add	sp,sp,-48
    80002bf8:	f406                	sd	ra,40(sp)
    80002bfa:	f022                	sd	s0,32(sp)
    80002bfc:	ec26                	sd	s1,24(sp)
    80002bfe:	e84a                	sd	s2,16(sp)
    80002c00:	e44e                	sd	s3,8(sp)
    80002c02:	1800                	add	s0,sp,48
    80002c04:	892a                	mv	s2,a0
    80002c06:	84ae                	mv	s1,a1
    80002c08:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002c0a:	fffff097          	auipc	ra,0xfffff
    80002c0e:	e30080e7          	jalr	-464(ra) # 80001a3a <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002c12:	86ce                	mv	a3,s3
    80002c14:	864a                	mv	a2,s2
    80002c16:	85a6                	mv	a1,s1
    80002c18:	6928                	ld	a0,80(a0)
    80002c1a:	fffff097          	auipc	ra,0xfffff
    80002c1e:	c30080e7          	jalr	-976(ra) # 8000184a <copyinstr>
  if(err < 0)
    80002c22:	00054763          	bltz	a0,80002c30 <fetchstr+0x3a>
  return strlen(buf);
    80002c26:	8526                	mv	a0,s1
    80002c28:	ffffe097          	auipc	ra,0xffffe
    80002c2c:	2c6080e7          	jalr	710(ra) # 80000eee <strlen>
}
    80002c30:	70a2                	ld	ra,40(sp)
    80002c32:	7402                	ld	s0,32(sp)
    80002c34:	64e2                	ld	s1,24(sp)
    80002c36:	6942                	ld	s2,16(sp)
    80002c38:	69a2                	ld	s3,8(sp)
    80002c3a:	6145                	add	sp,sp,48
    80002c3c:	8082                	ret

0000000080002c3e <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002c3e:	1101                	add	sp,sp,-32
    80002c40:	ec06                	sd	ra,24(sp)
    80002c42:	e822                	sd	s0,16(sp)
    80002c44:	e426                	sd	s1,8(sp)
    80002c46:	1000                	add	s0,sp,32
    80002c48:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c4a:	00000097          	auipc	ra,0x0
    80002c4e:	ef2080e7          	jalr	-270(ra) # 80002b3c <argraw>
    80002c52:	c088                	sw	a0,0(s1)
  return 0;
}
    80002c54:	4501                	li	a0,0
    80002c56:	60e2                	ld	ra,24(sp)
    80002c58:	6442                	ld	s0,16(sp)
    80002c5a:	64a2                	ld	s1,8(sp)
    80002c5c:	6105                	add	sp,sp,32
    80002c5e:	8082                	ret

0000000080002c60 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002c60:	1101                	add	sp,sp,-32
    80002c62:	ec06                	sd	ra,24(sp)
    80002c64:	e822                	sd	s0,16(sp)
    80002c66:	e426                	sd	s1,8(sp)
    80002c68:	1000                	add	s0,sp,32
    80002c6a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c6c:	00000097          	auipc	ra,0x0
    80002c70:	ed0080e7          	jalr	-304(ra) # 80002b3c <argraw>
    80002c74:	e088                	sd	a0,0(s1)
  return 0;
}
    80002c76:	4501                	li	a0,0
    80002c78:	60e2                	ld	ra,24(sp)
    80002c7a:	6442                	ld	s0,16(sp)
    80002c7c:	64a2                	ld	s1,8(sp)
    80002c7e:	6105                	add	sp,sp,32
    80002c80:	8082                	ret

0000000080002c82 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002c82:	1101                	add	sp,sp,-32
    80002c84:	ec06                	sd	ra,24(sp)
    80002c86:	e822                	sd	s0,16(sp)
    80002c88:	e426                	sd	s1,8(sp)
    80002c8a:	e04a                	sd	s2,0(sp)
    80002c8c:	1000                	add	s0,sp,32
    80002c8e:	84ae                	mv	s1,a1
    80002c90:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002c92:	00000097          	auipc	ra,0x0
    80002c96:	eaa080e7          	jalr	-342(ra) # 80002b3c <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002c9a:	864a                	mv	a2,s2
    80002c9c:	85a6                	mv	a1,s1
    80002c9e:	00000097          	auipc	ra,0x0
    80002ca2:	f58080e7          	jalr	-168(ra) # 80002bf6 <fetchstr>
}
    80002ca6:	60e2                	ld	ra,24(sp)
    80002ca8:	6442                	ld	s0,16(sp)
    80002caa:	64a2                	ld	s1,8(sp)
    80002cac:	6902                	ld	s2,0(sp)
    80002cae:	6105                	add	sp,sp,32
    80002cb0:	8082                	ret

0000000080002cb2 <syscall>:
[SYS_sigreturn] sys_sigreturn,
};

void
syscall(void)
{
    80002cb2:	1101                	add	sp,sp,-32
    80002cb4:	ec06                	sd	ra,24(sp)
    80002cb6:	e822                	sd	s0,16(sp)
    80002cb8:	e426                	sd	s1,8(sp)
    80002cba:	e04a                	sd	s2,0(sp)
    80002cbc:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002cbe:	fffff097          	auipc	ra,0xfffff
    80002cc2:	d7c080e7          	jalr	-644(ra) # 80001a3a <myproc>
    80002cc6:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002cc8:	05853903          	ld	s2,88(a0)
    80002ccc:	0a893783          	ld	a5,168(s2)
    80002cd0:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002cd4:	37fd                	addw	a5,a5,-1
    80002cd6:	4759                	li	a4,22
    80002cd8:	00f76f63          	bltu	a4,a5,80002cf6 <syscall+0x44>
    80002cdc:	00369713          	sll	a4,a3,0x3
    80002ce0:	00005797          	auipc	a5,0x5
    80002ce4:	76078793          	add	a5,a5,1888 # 80008440 <syscalls>
    80002ce8:	97ba                	add	a5,a5,a4
    80002cea:	639c                	ld	a5,0(a5)
    80002cec:	c789                	beqz	a5,80002cf6 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002cee:	9782                	jalr	a5
    80002cf0:	06a93823          	sd	a0,112(s2)
    80002cf4:	a839                	j	80002d12 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002cf6:	15848613          	add	a2,s1,344
    80002cfa:	5c8c                	lw	a1,56(s1)
    80002cfc:	00005517          	auipc	a0,0x5
    80002d00:	70c50513          	add	a0,a0,1804 # 80008408 <states.0+0x148>
    80002d04:	ffffe097          	auipc	ra,0xffffe
    80002d08:	92e080e7          	jalr	-1746(ra) # 80000632 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002d0c:	6cbc                	ld	a5,88(s1)
    80002d0e:	577d                	li	a4,-1
    80002d10:	fbb8                	sd	a4,112(a5)
  }
}
    80002d12:	60e2                	ld	ra,24(sp)
    80002d14:	6442                	ld	s0,16(sp)
    80002d16:	64a2                	ld	s1,8(sp)
    80002d18:	6902                	ld	s2,0(sp)
    80002d1a:	6105                	add	sp,sp,32
    80002d1c:	8082                	ret

0000000080002d1e <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002d1e:	1101                	add	sp,sp,-32
    80002d20:	ec06                	sd	ra,24(sp)
    80002d22:	e822                	sd	s0,16(sp)
    80002d24:	1000                	add	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002d26:	fec40593          	add	a1,s0,-20
    80002d2a:	4501                	li	a0,0
    80002d2c:	00000097          	auipc	ra,0x0
    80002d30:	f12080e7          	jalr	-238(ra) # 80002c3e <argint>
    return -1;
    80002d34:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002d36:	00054963          	bltz	a0,80002d48 <sys_exit+0x2a>
  exit(n);
    80002d3a:	fec42503          	lw	a0,-20(s0)
    80002d3e:	fffff097          	auipc	ra,0xfffff
    80002d42:	416080e7          	jalr	1046(ra) # 80002154 <exit>
  return 0;  // not reached
    80002d46:	4781                	li	a5,0
}
    80002d48:	853e                	mv	a0,a5
    80002d4a:	60e2                	ld	ra,24(sp)
    80002d4c:	6442                	ld	s0,16(sp)
    80002d4e:	6105                	add	sp,sp,32
    80002d50:	8082                	ret

0000000080002d52 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002d52:	1141                	add	sp,sp,-16
    80002d54:	e406                	sd	ra,8(sp)
    80002d56:	e022                	sd	s0,0(sp)
    80002d58:	0800                	add	s0,sp,16
  return myproc()->pid;
    80002d5a:	fffff097          	auipc	ra,0xfffff
    80002d5e:	ce0080e7          	jalr	-800(ra) # 80001a3a <myproc>
}
    80002d62:	5d08                	lw	a0,56(a0)
    80002d64:	60a2                	ld	ra,8(sp)
    80002d66:	6402                	ld	s0,0(sp)
    80002d68:	0141                	add	sp,sp,16
    80002d6a:	8082                	ret

0000000080002d6c <sys_fork>:

uint64
sys_fork(void)
{
    80002d6c:	1141                	add	sp,sp,-16
    80002d6e:	e406                	sd	ra,8(sp)
    80002d70:	e022                	sd	s0,0(sp)
    80002d72:	0800                	add	s0,sp,16
  return fork();
    80002d74:	fffff097          	auipc	ra,0xfffff
    80002d78:	0d6080e7          	jalr	214(ra) # 80001e4a <fork>
}
    80002d7c:	60a2                	ld	ra,8(sp)
    80002d7e:	6402                	ld	s0,0(sp)
    80002d80:	0141                	add	sp,sp,16
    80002d82:	8082                	ret

0000000080002d84 <sys_wait>:

uint64
sys_wait(void)
{
    80002d84:	1101                	add	sp,sp,-32
    80002d86:	ec06                	sd	ra,24(sp)
    80002d88:	e822                	sd	s0,16(sp)
    80002d8a:	1000                	add	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002d8c:	fe840593          	add	a1,s0,-24
    80002d90:	4501                	li	a0,0
    80002d92:	00000097          	auipc	ra,0x0
    80002d96:	ece080e7          	jalr	-306(ra) # 80002c60 <argaddr>
    80002d9a:	87aa                	mv	a5,a0
    return -1;
    80002d9c:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002d9e:	0007c863          	bltz	a5,80002dae <sys_wait+0x2a>
  return wait(p);
    80002da2:	fe843503          	ld	a0,-24(s0)
    80002da6:	fffff097          	auipc	ra,0xfffff
    80002daa:	572080e7          	jalr	1394(ra) # 80002318 <wait>
}
    80002dae:	60e2                	ld	ra,24(sp)
    80002db0:	6442                	ld	s0,16(sp)
    80002db2:	6105                	add	sp,sp,32
    80002db4:	8082                	ret

0000000080002db6 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002db6:	7179                	add	sp,sp,-48
    80002db8:	f406                	sd	ra,40(sp)
    80002dba:	f022                	sd	s0,32(sp)
    80002dbc:	ec26                	sd	s1,24(sp)
    80002dbe:	1800                	add	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002dc0:	fdc40593          	add	a1,s0,-36
    80002dc4:	4501                	li	a0,0
    80002dc6:	00000097          	auipc	ra,0x0
    80002dca:	e78080e7          	jalr	-392(ra) # 80002c3e <argint>
    80002dce:	87aa                	mv	a5,a0
    return -1;
    80002dd0:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002dd2:	0207c063          	bltz	a5,80002df2 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002dd6:	fffff097          	auipc	ra,0xfffff
    80002dda:	c64080e7          	jalr	-924(ra) # 80001a3a <myproc>
    80002dde:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002de0:	fdc42503          	lw	a0,-36(s0)
    80002de4:	fffff097          	auipc	ra,0xfffff
    80002de8:	fee080e7          	jalr	-18(ra) # 80001dd2 <growproc>
    80002dec:	00054863          	bltz	a0,80002dfc <sys_sbrk+0x46>
    return -1;
  return addr;
    80002df0:	8526                	mv	a0,s1
}
    80002df2:	70a2                	ld	ra,40(sp)
    80002df4:	7402                	ld	s0,32(sp)
    80002df6:	64e2                	ld	s1,24(sp)
    80002df8:	6145                	add	sp,sp,48
    80002dfa:	8082                	ret
    return -1;
    80002dfc:	557d                	li	a0,-1
    80002dfe:	bfd5                	j	80002df2 <sys_sbrk+0x3c>

0000000080002e00 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002e00:	7139                	add	sp,sp,-64
    80002e02:	fc06                	sd	ra,56(sp)
    80002e04:	f822                	sd	s0,48(sp)
    80002e06:	f426                	sd	s1,40(sp)
    80002e08:	f04a                	sd	s2,32(sp)
    80002e0a:	ec4e                	sd	s3,24(sp)
    80002e0c:	0080                	add	s0,sp,64
  int n;
  uint ticks0;
  backtrace(); // print stack backtrace.
    80002e0e:	ffffd097          	auipc	ra,0xffffd
    80002e12:	766080e7          	jalr	1894(ra) # 80000574 <backtrace>

  if(argint(0, &n) < 0)
    80002e16:	fcc40593          	add	a1,s0,-52
    80002e1a:	4501                	li	a0,0
    80002e1c:	00000097          	auipc	ra,0x0
    80002e20:	e22080e7          	jalr	-478(ra) # 80002c3e <argint>
    return -1;
    80002e24:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002e26:	06054563          	bltz	a0,80002e90 <sys_sleep+0x90>
  acquire(&tickslock);
    80002e2a:	00015517          	auipc	a0,0x15
    80002e2e:	33e50513          	add	a0,a0,830 # 80018168 <tickslock>
    80002e32:	ffffe097          	auipc	ra,0xffffe
    80002e36:	e3e080e7          	jalr	-450(ra) # 80000c70 <acquire>
  ticks0 = ticks;
    80002e3a:	00006917          	auipc	s2,0x6
    80002e3e:	1e692903          	lw	s2,486(s2) # 80009020 <ticks>
  while(ticks - ticks0 < n){
    80002e42:	fcc42783          	lw	a5,-52(s0)
    80002e46:	cf85                	beqz	a5,80002e7e <sys_sleep+0x7e>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002e48:	00015997          	auipc	s3,0x15
    80002e4c:	32098993          	add	s3,s3,800 # 80018168 <tickslock>
    80002e50:	00006497          	auipc	s1,0x6
    80002e54:	1d048493          	add	s1,s1,464 # 80009020 <ticks>
    if(myproc()->killed){
    80002e58:	fffff097          	auipc	ra,0xfffff
    80002e5c:	be2080e7          	jalr	-1054(ra) # 80001a3a <myproc>
    80002e60:	591c                	lw	a5,48(a0)
    80002e62:	ef9d                	bnez	a5,80002ea0 <sys_sleep+0xa0>
    sleep(&ticks, &tickslock);
    80002e64:	85ce                	mv	a1,s3
    80002e66:	8526                	mv	a0,s1
    80002e68:	fffff097          	auipc	ra,0xfffff
    80002e6c:	432080e7          	jalr	1074(ra) # 8000229a <sleep>
  while(ticks - ticks0 < n){
    80002e70:	409c                	lw	a5,0(s1)
    80002e72:	412787bb          	subw	a5,a5,s2
    80002e76:	fcc42703          	lw	a4,-52(s0)
    80002e7a:	fce7efe3          	bltu	a5,a4,80002e58 <sys_sleep+0x58>
  }
  release(&tickslock);
    80002e7e:	00015517          	auipc	a0,0x15
    80002e82:	2ea50513          	add	a0,a0,746 # 80018168 <tickslock>
    80002e86:	ffffe097          	auipc	ra,0xffffe
    80002e8a:	e9e080e7          	jalr	-354(ra) # 80000d24 <release>
  return 0;
    80002e8e:	4781                	li	a5,0
}
    80002e90:	853e                	mv	a0,a5
    80002e92:	70e2                	ld	ra,56(sp)
    80002e94:	7442                	ld	s0,48(sp)
    80002e96:	74a2                	ld	s1,40(sp)
    80002e98:	7902                	ld	s2,32(sp)
    80002e9a:	69e2                	ld	s3,24(sp)
    80002e9c:	6121                	add	sp,sp,64
    80002e9e:	8082                	ret
      release(&tickslock);
    80002ea0:	00015517          	auipc	a0,0x15
    80002ea4:	2c850513          	add	a0,a0,712 # 80018168 <tickslock>
    80002ea8:	ffffe097          	auipc	ra,0xffffe
    80002eac:	e7c080e7          	jalr	-388(ra) # 80000d24 <release>
      return -1;
    80002eb0:	57fd                	li	a5,-1
    80002eb2:	bff9                	j	80002e90 <sys_sleep+0x90>

0000000080002eb4 <sys_kill>:

uint64
sys_kill(void)
{
    80002eb4:	1101                	add	sp,sp,-32
    80002eb6:	ec06                	sd	ra,24(sp)
    80002eb8:	e822                	sd	s0,16(sp)
    80002eba:	1000                	add	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002ebc:	fec40593          	add	a1,s0,-20
    80002ec0:	4501                	li	a0,0
    80002ec2:	00000097          	auipc	ra,0x0
    80002ec6:	d7c080e7          	jalr	-644(ra) # 80002c3e <argint>
    80002eca:	87aa                	mv	a5,a0
    return -1;
    80002ecc:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002ece:	0007c863          	bltz	a5,80002ede <sys_kill+0x2a>
  return kill(pid);
    80002ed2:	fec42503          	lw	a0,-20(s0)
    80002ed6:	fffff097          	auipc	ra,0xfffff
    80002eda:	5ae080e7          	jalr	1454(ra) # 80002484 <kill>
}
    80002ede:	60e2                	ld	ra,24(sp)
    80002ee0:	6442                	ld	s0,16(sp)
    80002ee2:	6105                	add	sp,sp,32
    80002ee4:	8082                	ret

0000000080002ee6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002ee6:	1101                	add	sp,sp,-32
    80002ee8:	ec06                	sd	ra,24(sp)
    80002eea:	e822                	sd	s0,16(sp)
    80002eec:	e426                	sd	s1,8(sp)
    80002eee:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002ef0:	00015517          	auipc	a0,0x15
    80002ef4:	27850513          	add	a0,a0,632 # 80018168 <tickslock>
    80002ef8:	ffffe097          	auipc	ra,0xffffe
    80002efc:	d78080e7          	jalr	-648(ra) # 80000c70 <acquire>
  xticks = ticks;
    80002f00:	00006497          	auipc	s1,0x6
    80002f04:	1204a483          	lw	s1,288(s1) # 80009020 <ticks>
  release(&tickslock);
    80002f08:	00015517          	auipc	a0,0x15
    80002f0c:	26050513          	add	a0,a0,608 # 80018168 <tickslock>
    80002f10:	ffffe097          	auipc	ra,0xffffe
    80002f14:	e14080e7          	jalr	-492(ra) # 80000d24 <release>
  return xticks;
}
    80002f18:	02049513          	sll	a0,s1,0x20
    80002f1c:	9101                	srl	a0,a0,0x20
    80002f1e:	60e2                	ld	ra,24(sp)
    80002f20:	6442                	ld	s0,16(sp)
    80002f22:	64a2                	ld	s1,8(sp)
    80002f24:	6105                	add	sp,sp,32
    80002f26:	8082                	ret

0000000080002f28 <sys_sigalarm>:
uint64
sys_sigalarm(void) {
    80002f28:	1101                	add	sp,sp,-32
    80002f2a:	ec06                	sd	ra,24(sp)
    80002f2c:	e822                	sd	s0,16(sp)
    80002f2e:	1000                	add	s0,sp,32
  // sigalarm 的第一个参数为ticks，第二个参数为void(*handler)()
  int n;
  uint64 handler;
  if (argint(0, &n) < 0) {
    80002f30:	fec40593          	add	a1,s0,-20
    80002f34:	4501                	li	a0,0
    80002f36:	00000097          	auipc	ra,0x0
    80002f3a:	d08080e7          	jalr	-760(ra) # 80002c3e <argint>
    return -1;
    80002f3e:	57fd                	li	a5,-1
  if (argint(0, &n) < 0) {
    80002f40:	02054563          	bltz	a0,80002f6a <sys_sigalarm+0x42>
  }
  if (argaddr(1, &handler) < 0) {
    80002f44:	fe040593          	add	a1,s0,-32
    80002f48:	4505                	li	a0,1
    80002f4a:	00000097          	auipc	ra,0x0
    80002f4e:	d16080e7          	jalr	-746(ra) # 80002c60 <argaddr>
    return -1;
    80002f52:	57fd                	li	a5,-1
  if (argaddr(1, &handler) < 0) {
    80002f54:	00054b63          	bltz	a0,80002f6a <sys_sigalarm+0x42>
  }
  return sigalarm(n, (void(*)())(handler));
    80002f58:	fe043583          	ld	a1,-32(s0)
    80002f5c:	fec42503          	lw	a0,-20(s0)
    80002f60:	00000097          	auipc	ra,0x0
    80002f64:	b5c080e7          	jalr	-1188(ra) # 80002abc <sigalarm>
    80002f68:	87aa                	mv	a5,a0
}
    80002f6a:	853e                	mv	a0,a5
    80002f6c:	60e2                	ld	ra,24(sp)
    80002f6e:	6442                	ld	s0,16(sp)
    80002f70:	6105                	add	sp,sp,32
    80002f72:	8082                	ret

0000000080002f74 <sys_sigreturn>:
uint64
sys_sigreturn(void) {
    80002f74:	1141                	add	sp,sp,-16
    80002f76:	e406                	sd	ra,8(sp)
    80002f78:	e022                	sd	s0,0(sp)
    80002f7a:	0800                	add	s0,sp,16
  return sigreturn();
    80002f7c:	00000097          	auipc	ra,0x0
    80002f80:	b72080e7          	jalr	-1166(ra) # 80002aee <sigreturn>
}
    80002f84:	60a2                	ld	ra,8(sp)
    80002f86:	6402                	ld	s0,0(sp)
    80002f88:	0141                	add	sp,sp,16
    80002f8a:	8082                	ret

0000000080002f8c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002f8c:	7179                	add	sp,sp,-48
    80002f8e:	f406                	sd	ra,40(sp)
    80002f90:	f022                	sd	s0,32(sp)
    80002f92:	ec26                	sd	s1,24(sp)
    80002f94:	e84a                	sd	s2,16(sp)
    80002f96:	e44e                	sd	s3,8(sp)
    80002f98:	e052                	sd	s4,0(sp)
    80002f9a:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002f9c:	00005597          	auipc	a1,0x5
    80002fa0:	56458593          	add	a1,a1,1380 # 80008500 <syscalls+0xc0>
    80002fa4:	00015517          	auipc	a0,0x15
    80002fa8:	1dc50513          	add	a0,a0,476 # 80018180 <bcache>
    80002fac:	ffffe097          	auipc	ra,0xffffe
    80002fb0:	c34080e7          	jalr	-972(ra) # 80000be0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002fb4:	0001d797          	auipc	a5,0x1d
    80002fb8:	1cc78793          	add	a5,a5,460 # 80020180 <bcache+0x8000>
    80002fbc:	0001d717          	auipc	a4,0x1d
    80002fc0:	42c70713          	add	a4,a4,1068 # 800203e8 <bcache+0x8268>
    80002fc4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002fc8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002fcc:	00015497          	auipc	s1,0x15
    80002fd0:	1cc48493          	add	s1,s1,460 # 80018198 <bcache+0x18>
    b->next = bcache.head.next;
    80002fd4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002fd6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002fd8:	00005a17          	auipc	s4,0x5
    80002fdc:	530a0a13          	add	s4,s4,1328 # 80008508 <syscalls+0xc8>
    b->next = bcache.head.next;
    80002fe0:	2b893783          	ld	a5,696(s2)
    80002fe4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002fe6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002fea:	85d2                	mv	a1,s4
    80002fec:	01048513          	add	a0,s1,16
    80002ff0:	00001097          	auipc	ra,0x1
    80002ff4:	480080e7          	jalr	1152(ra) # 80004470 <initsleeplock>
    bcache.head.next->prev = b;
    80002ff8:	2b893783          	ld	a5,696(s2)
    80002ffc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002ffe:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003002:	45848493          	add	s1,s1,1112
    80003006:	fd349de3          	bne	s1,s3,80002fe0 <binit+0x54>
  }
}
    8000300a:	70a2                	ld	ra,40(sp)
    8000300c:	7402                	ld	s0,32(sp)
    8000300e:	64e2                	ld	s1,24(sp)
    80003010:	6942                	ld	s2,16(sp)
    80003012:	69a2                	ld	s3,8(sp)
    80003014:	6a02                	ld	s4,0(sp)
    80003016:	6145                	add	sp,sp,48
    80003018:	8082                	ret

000000008000301a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000301a:	7179                	add	sp,sp,-48
    8000301c:	f406                	sd	ra,40(sp)
    8000301e:	f022                	sd	s0,32(sp)
    80003020:	ec26                	sd	s1,24(sp)
    80003022:	e84a                	sd	s2,16(sp)
    80003024:	e44e                	sd	s3,8(sp)
    80003026:	1800                	add	s0,sp,48
    80003028:	892a                	mv	s2,a0
    8000302a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000302c:	00015517          	auipc	a0,0x15
    80003030:	15450513          	add	a0,a0,340 # 80018180 <bcache>
    80003034:	ffffe097          	auipc	ra,0xffffe
    80003038:	c3c080e7          	jalr	-964(ra) # 80000c70 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000303c:	0001d497          	auipc	s1,0x1d
    80003040:	3fc4b483          	ld	s1,1020(s1) # 80020438 <bcache+0x82b8>
    80003044:	0001d797          	auipc	a5,0x1d
    80003048:	3a478793          	add	a5,a5,932 # 800203e8 <bcache+0x8268>
    8000304c:	02f48f63          	beq	s1,a5,8000308a <bread+0x70>
    80003050:	873e                	mv	a4,a5
    80003052:	a021                	j	8000305a <bread+0x40>
    80003054:	68a4                	ld	s1,80(s1)
    80003056:	02e48a63          	beq	s1,a4,8000308a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000305a:	449c                	lw	a5,8(s1)
    8000305c:	ff279ce3          	bne	a5,s2,80003054 <bread+0x3a>
    80003060:	44dc                	lw	a5,12(s1)
    80003062:	ff3799e3          	bne	a5,s3,80003054 <bread+0x3a>
      b->refcnt++;
    80003066:	40bc                	lw	a5,64(s1)
    80003068:	2785                	addw	a5,a5,1
    8000306a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000306c:	00015517          	auipc	a0,0x15
    80003070:	11450513          	add	a0,a0,276 # 80018180 <bcache>
    80003074:	ffffe097          	auipc	ra,0xffffe
    80003078:	cb0080e7          	jalr	-848(ra) # 80000d24 <release>
      acquiresleep(&b->lock);
    8000307c:	01048513          	add	a0,s1,16
    80003080:	00001097          	auipc	ra,0x1
    80003084:	42a080e7          	jalr	1066(ra) # 800044aa <acquiresleep>
      return b;
    80003088:	a8b9                	j	800030e6 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000308a:	0001d497          	auipc	s1,0x1d
    8000308e:	3a64b483          	ld	s1,934(s1) # 80020430 <bcache+0x82b0>
    80003092:	0001d797          	auipc	a5,0x1d
    80003096:	35678793          	add	a5,a5,854 # 800203e8 <bcache+0x8268>
    8000309a:	00f48863          	beq	s1,a5,800030aa <bread+0x90>
    8000309e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800030a0:	40bc                	lw	a5,64(s1)
    800030a2:	cf81                	beqz	a5,800030ba <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800030a4:	64a4                	ld	s1,72(s1)
    800030a6:	fee49de3          	bne	s1,a4,800030a0 <bread+0x86>
  panic("bget: no buffers");
    800030aa:	00005517          	auipc	a0,0x5
    800030ae:	46650513          	add	a0,a0,1126 # 80008510 <syscalls+0xd0>
    800030b2:	ffffd097          	auipc	ra,0xffffd
    800030b6:	52e080e7          	jalr	1326(ra) # 800005e0 <panic>
      b->dev = dev;
    800030ba:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800030be:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800030c2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800030c6:	4785                	li	a5,1
    800030c8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800030ca:	00015517          	auipc	a0,0x15
    800030ce:	0b650513          	add	a0,a0,182 # 80018180 <bcache>
    800030d2:	ffffe097          	auipc	ra,0xffffe
    800030d6:	c52080e7          	jalr	-942(ra) # 80000d24 <release>
      acquiresleep(&b->lock);
    800030da:	01048513          	add	a0,s1,16
    800030de:	00001097          	auipc	ra,0x1
    800030e2:	3cc080e7          	jalr	972(ra) # 800044aa <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800030e6:	409c                	lw	a5,0(s1)
    800030e8:	cb89                	beqz	a5,800030fa <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800030ea:	8526                	mv	a0,s1
    800030ec:	70a2                	ld	ra,40(sp)
    800030ee:	7402                	ld	s0,32(sp)
    800030f0:	64e2                	ld	s1,24(sp)
    800030f2:	6942                	ld	s2,16(sp)
    800030f4:	69a2                	ld	s3,8(sp)
    800030f6:	6145                	add	sp,sp,48
    800030f8:	8082                	ret
    virtio_disk_rw(b, 0);
    800030fa:	4581                	li	a1,0
    800030fc:	8526                	mv	a0,s1
    800030fe:	00003097          	auipc	ra,0x3
    80003102:	eca080e7          	jalr	-310(ra) # 80005fc8 <virtio_disk_rw>
    b->valid = 1;
    80003106:	4785                	li	a5,1
    80003108:	c09c                	sw	a5,0(s1)
  return b;
    8000310a:	b7c5                	j	800030ea <bread+0xd0>

000000008000310c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000310c:	1101                	add	sp,sp,-32
    8000310e:	ec06                	sd	ra,24(sp)
    80003110:	e822                	sd	s0,16(sp)
    80003112:	e426                	sd	s1,8(sp)
    80003114:	1000                	add	s0,sp,32
    80003116:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003118:	0541                	add	a0,a0,16
    8000311a:	00001097          	auipc	ra,0x1
    8000311e:	42a080e7          	jalr	1066(ra) # 80004544 <holdingsleep>
    80003122:	cd01                	beqz	a0,8000313a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003124:	4585                	li	a1,1
    80003126:	8526                	mv	a0,s1
    80003128:	00003097          	auipc	ra,0x3
    8000312c:	ea0080e7          	jalr	-352(ra) # 80005fc8 <virtio_disk_rw>
}
    80003130:	60e2                	ld	ra,24(sp)
    80003132:	6442                	ld	s0,16(sp)
    80003134:	64a2                	ld	s1,8(sp)
    80003136:	6105                	add	sp,sp,32
    80003138:	8082                	ret
    panic("bwrite");
    8000313a:	00005517          	auipc	a0,0x5
    8000313e:	3ee50513          	add	a0,a0,1006 # 80008528 <syscalls+0xe8>
    80003142:	ffffd097          	auipc	ra,0xffffd
    80003146:	49e080e7          	jalr	1182(ra) # 800005e0 <panic>

000000008000314a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000314a:	1101                	add	sp,sp,-32
    8000314c:	ec06                	sd	ra,24(sp)
    8000314e:	e822                	sd	s0,16(sp)
    80003150:	e426                	sd	s1,8(sp)
    80003152:	e04a                	sd	s2,0(sp)
    80003154:	1000                	add	s0,sp,32
    80003156:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003158:	01050913          	add	s2,a0,16
    8000315c:	854a                	mv	a0,s2
    8000315e:	00001097          	auipc	ra,0x1
    80003162:	3e6080e7          	jalr	998(ra) # 80004544 <holdingsleep>
    80003166:	c925                	beqz	a0,800031d6 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80003168:	854a                	mv	a0,s2
    8000316a:	00001097          	auipc	ra,0x1
    8000316e:	396080e7          	jalr	918(ra) # 80004500 <releasesleep>

  acquire(&bcache.lock);
    80003172:	00015517          	auipc	a0,0x15
    80003176:	00e50513          	add	a0,a0,14 # 80018180 <bcache>
    8000317a:	ffffe097          	auipc	ra,0xffffe
    8000317e:	af6080e7          	jalr	-1290(ra) # 80000c70 <acquire>
  b->refcnt--;
    80003182:	40bc                	lw	a5,64(s1)
    80003184:	37fd                	addw	a5,a5,-1
    80003186:	0007871b          	sext.w	a4,a5
    8000318a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000318c:	e71d                	bnez	a4,800031ba <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000318e:	68b8                	ld	a4,80(s1)
    80003190:	64bc                	ld	a5,72(s1)
    80003192:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003194:	68b8                	ld	a4,80(s1)
    80003196:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003198:	0001d797          	auipc	a5,0x1d
    8000319c:	fe878793          	add	a5,a5,-24 # 80020180 <bcache+0x8000>
    800031a0:	2b87b703          	ld	a4,696(a5)
    800031a4:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800031a6:	0001d717          	auipc	a4,0x1d
    800031aa:	24270713          	add	a4,a4,578 # 800203e8 <bcache+0x8268>
    800031ae:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800031b0:	2b87b703          	ld	a4,696(a5)
    800031b4:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800031b6:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800031ba:	00015517          	auipc	a0,0x15
    800031be:	fc650513          	add	a0,a0,-58 # 80018180 <bcache>
    800031c2:	ffffe097          	auipc	ra,0xffffe
    800031c6:	b62080e7          	jalr	-1182(ra) # 80000d24 <release>
}
    800031ca:	60e2                	ld	ra,24(sp)
    800031cc:	6442                	ld	s0,16(sp)
    800031ce:	64a2                	ld	s1,8(sp)
    800031d0:	6902                	ld	s2,0(sp)
    800031d2:	6105                	add	sp,sp,32
    800031d4:	8082                	ret
    panic("brelse");
    800031d6:	00005517          	auipc	a0,0x5
    800031da:	35a50513          	add	a0,a0,858 # 80008530 <syscalls+0xf0>
    800031de:	ffffd097          	auipc	ra,0xffffd
    800031e2:	402080e7          	jalr	1026(ra) # 800005e0 <panic>

00000000800031e6 <bpin>:

void
bpin(struct buf *b) {
    800031e6:	1101                	add	sp,sp,-32
    800031e8:	ec06                	sd	ra,24(sp)
    800031ea:	e822                	sd	s0,16(sp)
    800031ec:	e426                	sd	s1,8(sp)
    800031ee:	1000                	add	s0,sp,32
    800031f0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800031f2:	00015517          	auipc	a0,0x15
    800031f6:	f8e50513          	add	a0,a0,-114 # 80018180 <bcache>
    800031fa:	ffffe097          	auipc	ra,0xffffe
    800031fe:	a76080e7          	jalr	-1418(ra) # 80000c70 <acquire>
  b->refcnt++;
    80003202:	40bc                	lw	a5,64(s1)
    80003204:	2785                	addw	a5,a5,1
    80003206:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003208:	00015517          	auipc	a0,0x15
    8000320c:	f7850513          	add	a0,a0,-136 # 80018180 <bcache>
    80003210:	ffffe097          	auipc	ra,0xffffe
    80003214:	b14080e7          	jalr	-1260(ra) # 80000d24 <release>
}
    80003218:	60e2                	ld	ra,24(sp)
    8000321a:	6442                	ld	s0,16(sp)
    8000321c:	64a2                	ld	s1,8(sp)
    8000321e:	6105                	add	sp,sp,32
    80003220:	8082                	ret

0000000080003222 <bunpin>:

void
bunpin(struct buf *b) {
    80003222:	1101                	add	sp,sp,-32
    80003224:	ec06                	sd	ra,24(sp)
    80003226:	e822                	sd	s0,16(sp)
    80003228:	e426                	sd	s1,8(sp)
    8000322a:	1000                	add	s0,sp,32
    8000322c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000322e:	00015517          	auipc	a0,0x15
    80003232:	f5250513          	add	a0,a0,-174 # 80018180 <bcache>
    80003236:	ffffe097          	auipc	ra,0xffffe
    8000323a:	a3a080e7          	jalr	-1478(ra) # 80000c70 <acquire>
  b->refcnt--;
    8000323e:	40bc                	lw	a5,64(s1)
    80003240:	37fd                	addw	a5,a5,-1
    80003242:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003244:	00015517          	auipc	a0,0x15
    80003248:	f3c50513          	add	a0,a0,-196 # 80018180 <bcache>
    8000324c:	ffffe097          	auipc	ra,0xffffe
    80003250:	ad8080e7          	jalr	-1320(ra) # 80000d24 <release>
}
    80003254:	60e2                	ld	ra,24(sp)
    80003256:	6442                	ld	s0,16(sp)
    80003258:	64a2                	ld	s1,8(sp)
    8000325a:	6105                	add	sp,sp,32
    8000325c:	8082                	ret

000000008000325e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000325e:	1101                	add	sp,sp,-32
    80003260:	ec06                	sd	ra,24(sp)
    80003262:	e822                	sd	s0,16(sp)
    80003264:	e426                	sd	s1,8(sp)
    80003266:	e04a                	sd	s2,0(sp)
    80003268:	1000                	add	s0,sp,32
    8000326a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000326c:	00d5d59b          	srlw	a1,a1,0xd
    80003270:	0001d797          	auipc	a5,0x1d
    80003274:	5ec7a783          	lw	a5,1516(a5) # 8002085c <sb+0x1c>
    80003278:	9dbd                	addw	a1,a1,a5
    8000327a:	00000097          	auipc	ra,0x0
    8000327e:	da0080e7          	jalr	-608(ra) # 8000301a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003282:	0074f713          	and	a4,s1,7
    80003286:	4785                	li	a5,1
    80003288:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000328c:	14ce                	sll	s1,s1,0x33
    8000328e:	90d9                	srl	s1,s1,0x36
    80003290:	00950733          	add	a4,a0,s1
    80003294:	05874703          	lbu	a4,88(a4)
    80003298:	00e7f6b3          	and	a3,a5,a4
    8000329c:	c69d                	beqz	a3,800032ca <bfree+0x6c>
    8000329e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800032a0:	94aa                	add	s1,s1,a0
    800032a2:	fff7c793          	not	a5,a5
    800032a6:	8f7d                	and	a4,a4,a5
    800032a8:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800032ac:	00001097          	auipc	ra,0x1
    800032b0:	0d8080e7          	jalr	216(ra) # 80004384 <log_write>
  brelse(bp);
    800032b4:	854a                	mv	a0,s2
    800032b6:	00000097          	auipc	ra,0x0
    800032ba:	e94080e7          	jalr	-364(ra) # 8000314a <brelse>
}
    800032be:	60e2                	ld	ra,24(sp)
    800032c0:	6442                	ld	s0,16(sp)
    800032c2:	64a2                	ld	s1,8(sp)
    800032c4:	6902                	ld	s2,0(sp)
    800032c6:	6105                	add	sp,sp,32
    800032c8:	8082                	ret
    panic("freeing free block");
    800032ca:	00005517          	auipc	a0,0x5
    800032ce:	26e50513          	add	a0,a0,622 # 80008538 <syscalls+0xf8>
    800032d2:	ffffd097          	auipc	ra,0xffffd
    800032d6:	30e080e7          	jalr	782(ra) # 800005e0 <panic>

00000000800032da <balloc>:
{
    800032da:	711d                	add	sp,sp,-96
    800032dc:	ec86                	sd	ra,88(sp)
    800032de:	e8a2                	sd	s0,80(sp)
    800032e0:	e4a6                	sd	s1,72(sp)
    800032e2:	e0ca                	sd	s2,64(sp)
    800032e4:	fc4e                	sd	s3,56(sp)
    800032e6:	f852                	sd	s4,48(sp)
    800032e8:	f456                	sd	s5,40(sp)
    800032ea:	f05a                	sd	s6,32(sp)
    800032ec:	ec5e                	sd	s7,24(sp)
    800032ee:	e862                	sd	s8,16(sp)
    800032f0:	e466                	sd	s9,8(sp)
    800032f2:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800032f4:	0001d797          	auipc	a5,0x1d
    800032f8:	5507a783          	lw	a5,1360(a5) # 80020844 <sb+0x4>
    800032fc:	cbc1                	beqz	a5,8000338c <balloc+0xb2>
    800032fe:	8baa                	mv	s7,a0
    80003300:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003302:	0001db17          	auipc	s6,0x1d
    80003306:	53eb0b13          	add	s6,s6,1342 # 80020840 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000330a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000330c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000330e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003310:	6c89                	lui	s9,0x2
    80003312:	a831                	j	8000332e <balloc+0x54>
    brelse(bp);
    80003314:	854a                	mv	a0,s2
    80003316:	00000097          	auipc	ra,0x0
    8000331a:	e34080e7          	jalr	-460(ra) # 8000314a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000331e:	015c87bb          	addw	a5,s9,s5
    80003322:	00078a9b          	sext.w	s5,a5
    80003326:	004b2703          	lw	a4,4(s6)
    8000332a:	06eaf163          	bgeu	s5,a4,8000338c <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    8000332e:	41fad79b          	sraw	a5,s5,0x1f
    80003332:	0137d79b          	srlw	a5,a5,0x13
    80003336:	015787bb          	addw	a5,a5,s5
    8000333a:	40d7d79b          	sraw	a5,a5,0xd
    8000333e:	01cb2583          	lw	a1,28(s6)
    80003342:	9dbd                	addw	a1,a1,a5
    80003344:	855e                	mv	a0,s7
    80003346:	00000097          	auipc	ra,0x0
    8000334a:	cd4080e7          	jalr	-812(ra) # 8000301a <bread>
    8000334e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003350:	004b2503          	lw	a0,4(s6)
    80003354:	000a849b          	sext.w	s1,s5
    80003358:	8762                	mv	a4,s8
    8000335a:	faa4fde3          	bgeu	s1,a0,80003314 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000335e:	00777693          	and	a3,a4,7
    80003362:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003366:	41f7579b          	sraw	a5,a4,0x1f
    8000336a:	01d7d79b          	srlw	a5,a5,0x1d
    8000336e:	9fb9                	addw	a5,a5,a4
    80003370:	4037d79b          	sraw	a5,a5,0x3
    80003374:	00f90633          	add	a2,s2,a5
    80003378:	05864603          	lbu	a2,88(a2)
    8000337c:	00c6f5b3          	and	a1,a3,a2
    80003380:	cd91                	beqz	a1,8000339c <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003382:	2705                	addw	a4,a4,1
    80003384:	2485                	addw	s1,s1,1
    80003386:	fd471ae3          	bne	a4,s4,8000335a <balloc+0x80>
    8000338a:	b769                	j	80003314 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000338c:	00005517          	auipc	a0,0x5
    80003390:	1c450513          	add	a0,a0,452 # 80008550 <syscalls+0x110>
    80003394:	ffffd097          	auipc	ra,0xffffd
    80003398:	24c080e7          	jalr	588(ra) # 800005e0 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000339c:	97ca                	add	a5,a5,s2
    8000339e:	8e55                	or	a2,a2,a3
    800033a0:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800033a4:	854a                	mv	a0,s2
    800033a6:	00001097          	auipc	ra,0x1
    800033aa:	fde080e7          	jalr	-34(ra) # 80004384 <log_write>
        brelse(bp);
    800033ae:	854a                	mv	a0,s2
    800033b0:	00000097          	auipc	ra,0x0
    800033b4:	d9a080e7          	jalr	-614(ra) # 8000314a <brelse>
  bp = bread(dev, bno);
    800033b8:	85a6                	mv	a1,s1
    800033ba:	855e                	mv	a0,s7
    800033bc:	00000097          	auipc	ra,0x0
    800033c0:	c5e080e7          	jalr	-930(ra) # 8000301a <bread>
    800033c4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800033c6:	40000613          	li	a2,1024
    800033ca:	4581                	li	a1,0
    800033cc:	05850513          	add	a0,a0,88
    800033d0:	ffffe097          	auipc	ra,0xffffe
    800033d4:	99c080e7          	jalr	-1636(ra) # 80000d6c <memset>
  log_write(bp);
    800033d8:	854a                	mv	a0,s2
    800033da:	00001097          	auipc	ra,0x1
    800033de:	faa080e7          	jalr	-86(ra) # 80004384 <log_write>
  brelse(bp);
    800033e2:	854a                	mv	a0,s2
    800033e4:	00000097          	auipc	ra,0x0
    800033e8:	d66080e7          	jalr	-666(ra) # 8000314a <brelse>
}
    800033ec:	8526                	mv	a0,s1
    800033ee:	60e6                	ld	ra,88(sp)
    800033f0:	6446                	ld	s0,80(sp)
    800033f2:	64a6                	ld	s1,72(sp)
    800033f4:	6906                	ld	s2,64(sp)
    800033f6:	79e2                	ld	s3,56(sp)
    800033f8:	7a42                	ld	s4,48(sp)
    800033fa:	7aa2                	ld	s5,40(sp)
    800033fc:	7b02                	ld	s6,32(sp)
    800033fe:	6be2                	ld	s7,24(sp)
    80003400:	6c42                	ld	s8,16(sp)
    80003402:	6ca2                	ld	s9,8(sp)
    80003404:	6125                	add	sp,sp,96
    80003406:	8082                	ret

0000000080003408 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80003408:	7179                	add	sp,sp,-48
    8000340a:	f406                	sd	ra,40(sp)
    8000340c:	f022                	sd	s0,32(sp)
    8000340e:	ec26                	sd	s1,24(sp)
    80003410:	e84a                	sd	s2,16(sp)
    80003412:	e44e                	sd	s3,8(sp)
    80003414:	e052                	sd	s4,0(sp)
    80003416:	1800                	add	s0,sp,48
    80003418:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000341a:	47ad                	li	a5,11
    8000341c:	04b7fe63          	bgeu	a5,a1,80003478 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003420:	ff45849b          	addw	s1,a1,-12
    80003424:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003428:	0ff00793          	li	a5,255
    8000342c:	0ae7e463          	bltu	a5,a4,800034d4 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003430:	08052583          	lw	a1,128(a0)
    80003434:	c5b5                	beqz	a1,800034a0 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003436:	00092503          	lw	a0,0(s2)
    8000343a:	00000097          	auipc	ra,0x0
    8000343e:	be0080e7          	jalr	-1056(ra) # 8000301a <bread>
    80003442:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003444:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    80003448:	02049713          	sll	a4,s1,0x20
    8000344c:	01e75593          	srl	a1,a4,0x1e
    80003450:	00b784b3          	add	s1,a5,a1
    80003454:	0004a983          	lw	s3,0(s1)
    80003458:	04098e63          	beqz	s3,800034b4 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000345c:	8552                	mv	a0,s4
    8000345e:	00000097          	auipc	ra,0x0
    80003462:	cec080e7          	jalr	-788(ra) # 8000314a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003466:	854e                	mv	a0,s3
    80003468:	70a2                	ld	ra,40(sp)
    8000346a:	7402                	ld	s0,32(sp)
    8000346c:	64e2                	ld	s1,24(sp)
    8000346e:	6942                	ld	s2,16(sp)
    80003470:	69a2                	ld	s3,8(sp)
    80003472:	6a02                	ld	s4,0(sp)
    80003474:	6145                	add	sp,sp,48
    80003476:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80003478:	02059793          	sll	a5,a1,0x20
    8000347c:	01e7d593          	srl	a1,a5,0x1e
    80003480:	00b504b3          	add	s1,a0,a1
    80003484:	0504a983          	lw	s3,80(s1)
    80003488:	fc099fe3          	bnez	s3,80003466 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000348c:	4108                	lw	a0,0(a0)
    8000348e:	00000097          	auipc	ra,0x0
    80003492:	e4c080e7          	jalr	-436(ra) # 800032da <balloc>
    80003496:	0005099b          	sext.w	s3,a0
    8000349a:	0534a823          	sw	s3,80(s1)
    8000349e:	b7e1                	j	80003466 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800034a0:	4108                	lw	a0,0(a0)
    800034a2:	00000097          	auipc	ra,0x0
    800034a6:	e38080e7          	jalr	-456(ra) # 800032da <balloc>
    800034aa:	0005059b          	sext.w	a1,a0
    800034ae:	08b92023          	sw	a1,128(s2)
    800034b2:	b751                	j	80003436 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800034b4:	00092503          	lw	a0,0(s2)
    800034b8:	00000097          	auipc	ra,0x0
    800034bc:	e22080e7          	jalr	-478(ra) # 800032da <balloc>
    800034c0:	0005099b          	sext.w	s3,a0
    800034c4:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800034c8:	8552                	mv	a0,s4
    800034ca:	00001097          	auipc	ra,0x1
    800034ce:	eba080e7          	jalr	-326(ra) # 80004384 <log_write>
    800034d2:	b769                	j	8000345c <bmap+0x54>
  panic("bmap: out of range");
    800034d4:	00005517          	auipc	a0,0x5
    800034d8:	09450513          	add	a0,a0,148 # 80008568 <syscalls+0x128>
    800034dc:	ffffd097          	auipc	ra,0xffffd
    800034e0:	104080e7          	jalr	260(ra) # 800005e0 <panic>

00000000800034e4 <iget>:
{
    800034e4:	7179                	add	sp,sp,-48
    800034e6:	f406                	sd	ra,40(sp)
    800034e8:	f022                	sd	s0,32(sp)
    800034ea:	ec26                	sd	s1,24(sp)
    800034ec:	e84a                	sd	s2,16(sp)
    800034ee:	e44e                	sd	s3,8(sp)
    800034f0:	e052                	sd	s4,0(sp)
    800034f2:	1800                	add	s0,sp,48
    800034f4:	89aa                	mv	s3,a0
    800034f6:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    800034f8:	0001d517          	auipc	a0,0x1d
    800034fc:	36850513          	add	a0,a0,872 # 80020860 <icache>
    80003500:	ffffd097          	auipc	ra,0xffffd
    80003504:	770080e7          	jalr	1904(ra) # 80000c70 <acquire>
  empty = 0;
    80003508:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    8000350a:	0001d497          	auipc	s1,0x1d
    8000350e:	36e48493          	add	s1,s1,878 # 80020878 <icache+0x18>
    80003512:	0001f697          	auipc	a3,0x1f
    80003516:	df668693          	add	a3,a3,-522 # 80022308 <log>
    8000351a:	a039                	j	80003528 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000351c:	02090b63          	beqz	s2,80003552 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003520:	08848493          	add	s1,s1,136
    80003524:	02d48a63          	beq	s1,a3,80003558 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003528:	449c                	lw	a5,8(s1)
    8000352a:	fef059e3          	blez	a5,8000351c <iget+0x38>
    8000352e:	4098                	lw	a4,0(s1)
    80003530:	ff3716e3          	bne	a4,s3,8000351c <iget+0x38>
    80003534:	40d8                	lw	a4,4(s1)
    80003536:	ff4713e3          	bne	a4,s4,8000351c <iget+0x38>
      ip->ref++;
    8000353a:	2785                	addw	a5,a5,1
    8000353c:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    8000353e:	0001d517          	auipc	a0,0x1d
    80003542:	32250513          	add	a0,a0,802 # 80020860 <icache>
    80003546:	ffffd097          	auipc	ra,0xffffd
    8000354a:	7de080e7          	jalr	2014(ra) # 80000d24 <release>
      return ip;
    8000354e:	8926                	mv	s2,s1
    80003550:	a03d                	j	8000357e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003552:	f7f9                	bnez	a5,80003520 <iget+0x3c>
    80003554:	8926                	mv	s2,s1
    80003556:	b7e9                	j	80003520 <iget+0x3c>
  if(empty == 0)
    80003558:	02090c63          	beqz	s2,80003590 <iget+0xac>
  ip->dev = dev;
    8000355c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003560:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003564:	4785                	li	a5,1
    80003566:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000356a:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    8000356e:	0001d517          	auipc	a0,0x1d
    80003572:	2f250513          	add	a0,a0,754 # 80020860 <icache>
    80003576:	ffffd097          	auipc	ra,0xffffd
    8000357a:	7ae080e7          	jalr	1966(ra) # 80000d24 <release>
}
    8000357e:	854a                	mv	a0,s2
    80003580:	70a2                	ld	ra,40(sp)
    80003582:	7402                	ld	s0,32(sp)
    80003584:	64e2                	ld	s1,24(sp)
    80003586:	6942                	ld	s2,16(sp)
    80003588:	69a2                	ld	s3,8(sp)
    8000358a:	6a02                	ld	s4,0(sp)
    8000358c:	6145                	add	sp,sp,48
    8000358e:	8082                	ret
    panic("iget: no inodes");
    80003590:	00005517          	auipc	a0,0x5
    80003594:	ff050513          	add	a0,a0,-16 # 80008580 <syscalls+0x140>
    80003598:	ffffd097          	auipc	ra,0xffffd
    8000359c:	048080e7          	jalr	72(ra) # 800005e0 <panic>

00000000800035a0 <fsinit>:
fsinit(int dev) {
    800035a0:	7179                	add	sp,sp,-48
    800035a2:	f406                	sd	ra,40(sp)
    800035a4:	f022                	sd	s0,32(sp)
    800035a6:	ec26                	sd	s1,24(sp)
    800035a8:	e84a                	sd	s2,16(sp)
    800035aa:	e44e                	sd	s3,8(sp)
    800035ac:	1800                	add	s0,sp,48
    800035ae:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800035b0:	4585                	li	a1,1
    800035b2:	00000097          	auipc	ra,0x0
    800035b6:	a68080e7          	jalr	-1432(ra) # 8000301a <bread>
    800035ba:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800035bc:	0001d997          	auipc	s3,0x1d
    800035c0:	28498993          	add	s3,s3,644 # 80020840 <sb>
    800035c4:	02000613          	li	a2,32
    800035c8:	05850593          	add	a1,a0,88
    800035cc:	854e                	mv	a0,s3
    800035ce:	ffffd097          	auipc	ra,0xffffd
    800035d2:	7fa080e7          	jalr	2042(ra) # 80000dc8 <memmove>
  brelse(bp);
    800035d6:	8526                	mv	a0,s1
    800035d8:	00000097          	auipc	ra,0x0
    800035dc:	b72080e7          	jalr	-1166(ra) # 8000314a <brelse>
  if(sb.magic != FSMAGIC)
    800035e0:	0009a703          	lw	a4,0(s3)
    800035e4:	102037b7          	lui	a5,0x10203
    800035e8:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800035ec:	02f71263          	bne	a4,a5,80003610 <fsinit+0x70>
  initlog(dev, &sb);
    800035f0:	0001d597          	auipc	a1,0x1d
    800035f4:	25058593          	add	a1,a1,592 # 80020840 <sb>
    800035f8:	854a                	mv	a0,s2
    800035fa:	00001097          	auipc	ra,0x1
    800035fe:	b24080e7          	jalr	-1244(ra) # 8000411e <initlog>
}
    80003602:	70a2                	ld	ra,40(sp)
    80003604:	7402                	ld	s0,32(sp)
    80003606:	64e2                	ld	s1,24(sp)
    80003608:	6942                	ld	s2,16(sp)
    8000360a:	69a2                	ld	s3,8(sp)
    8000360c:	6145                	add	sp,sp,48
    8000360e:	8082                	ret
    panic("invalid file system");
    80003610:	00005517          	auipc	a0,0x5
    80003614:	f8050513          	add	a0,a0,-128 # 80008590 <syscalls+0x150>
    80003618:	ffffd097          	auipc	ra,0xffffd
    8000361c:	fc8080e7          	jalr	-56(ra) # 800005e0 <panic>

0000000080003620 <iinit>:
{
    80003620:	7179                	add	sp,sp,-48
    80003622:	f406                	sd	ra,40(sp)
    80003624:	f022                	sd	s0,32(sp)
    80003626:	ec26                	sd	s1,24(sp)
    80003628:	e84a                	sd	s2,16(sp)
    8000362a:	e44e                	sd	s3,8(sp)
    8000362c:	1800                	add	s0,sp,48
  initlock(&icache.lock, "icache");
    8000362e:	00005597          	auipc	a1,0x5
    80003632:	f7a58593          	add	a1,a1,-134 # 800085a8 <syscalls+0x168>
    80003636:	0001d517          	auipc	a0,0x1d
    8000363a:	22a50513          	add	a0,a0,554 # 80020860 <icache>
    8000363e:	ffffd097          	auipc	ra,0xffffd
    80003642:	5a2080e7          	jalr	1442(ra) # 80000be0 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003646:	0001d497          	auipc	s1,0x1d
    8000364a:	24248493          	add	s1,s1,578 # 80020888 <icache+0x28>
    8000364e:	0001f997          	auipc	s3,0x1f
    80003652:	cca98993          	add	s3,s3,-822 # 80022318 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003656:	00005917          	auipc	s2,0x5
    8000365a:	f5a90913          	add	s2,s2,-166 # 800085b0 <syscalls+0x170>
    8000365e:	85ca                	mv	a1,s2
    80003660:	8526                	mv	a0,s1
    80003662:	00001097          	auipc	ra,0x1
    80003666:	e0e080e7          	jalr	-498(ra) # 80004470 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000366a:	08848493          	add	s1,s1,136
    8000366e:	ff3498e3          	bne	s1,s3,8000365e <iinit+0x3e>
}
    80003672:	70a2                	ld	ra,40(sp)
    80003674:	7402                	ld	s0,32(sp)
    80003676:	64e2                	ld	s1,24(sp)
    80003678:	6942                	ld	s2,16(sp)
    8000367a:	69a2                	ld	s3,8(sp)
    8000367c:	6145                	add	sp,sp,48
    8000367e:	8082                	ret

0000000080003680 <ialloc>:
{
    80003680:	7139                	add	sp,sp,-64
    80003682:	fc06                	sd	ra,56(sp)
    80003684:	f822                	sd	s0,48(sp)
    80003686:	f426                	sd	s1,40(sp)
    80003688:	f04a                	sd	s2,32(sp)
    8000368a:	ec4e                	sd	s3,24(sp)
    8000368c:	e852                	sd	s4,16(sp)
    8000368e:	e456                	sd	s5,8(sp)
    80003690:	e05a                	sd	s6,0(sp)
    80003692:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003694:	0001d717          	auipc	a4,0x1d
    80003698:	1b872703          	lw	a4,440(a4) # 8002084c <sb+0xc>
    8000369c:	4785                	li	a5,1
    8000369e:	04e7f863          	bgeu	a5,a4,800036ee <ialloc+0x6e>
    800036a2:	8aaa                	mv	s5,a0
    800036a4:	8b2e                	mv	s6,a1
    800036a6:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800036a8:	0001da17          	auipc	s4,0x1d
    800036ac:	198a0a13          	add	s4,s4,408 # 80020840 <sb>
    800036b0:	00495593          	srl	a1,s2,0x4
    800036b4:	018a2783          	lw	a5,24(s4)
    800036b8:	9dbd                	addw	a1,a1,a5
    800036ba:	8556                	mv	a0,s5
    800036bc:	00000097          	auipc	ra,0x0
    800036c0:	95e080e7          	jalr	-1698(ra) # 8000301a <bread>
    800036c4:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800036c6:	05850993          	add	s3,a0,88
    800036ca:	00f97793          	and	a5,s2,15
    800036ce:	079a                	sll	a5,a5,0x6
    800036d0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800036d2:	00099783          	lh	a5,0(s3)
    800036d6:	c785                	beqz	a5,800036fe <ialloc+0x7e>
    brelse(bp);
    800036d8:	00000097          	auipc	ra,0x0
    800036dc:	a72080e7          	jalr	-1422(ra) # 8000314a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800036e0:	0905                	add	s2,s2,1
    800036e2:	00ca2703          	lw	a4,12(s4)
    800036e6:	0009079b          	sext.w	a5,s2
    800036ea:	fce7e3e3          	bltu	a5,a4,800036b0 <ialloc+0x30>
  panic("ialloc: no inodes");
    800036ee:	00005517          	auipc	a0,0x5
    800036f2:	eca50513          	add	a0,a0,-310 # 800085b8 <syscalls+0x178>
    800036f6:	ffffd097          	auipc	ra,0xffffd
    800036fa:	eea080e7          	jalr	-278(ra) # 800005e0 <panic>
      memset(dip, 0, sizeof(*dip));
    800036fe:	04000613          	li	a2,64
    80003702:	4581                	li	a1,0
    80003704:	854e                	mv	a0,s3
    80003706:	ffffd097          	auipc	ra,0xffffd
    8000370a:	666080e7          	jalr	1638(ra) # 80000d6c <memset>
      dip->type = type;
    8000370e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003712:	8526                	mv	a0,s1
    80003714:	00001097          	auipc	ra,0x1
    80003718:	c70080e7          	jalr	-912(ra) # 80004384 <log_write>
      brelse(bp);
    8000371c:	8526                	mv	a0,s1
    8000371e:	00000097          	auipc	ra,0x0
    80003722:	a2c080e7          	jalr	-1492(ra) # 8000314a <brelse>
      return iget(dev, inum);
    80003726:	0009059b          	sext.w	a1,s2
    8000372a:	8556                	mv	a0,s5
    8000372c:	00000097          	auipc	ra,0x0
    80003730:	db8080e7          	jalr	-584(ra) # 800034e4 <iget>
}
    80003734:	70e2                	ld	ra,56(sp)
    80003736:	7442                	ld	s0,48(sp)
    80003738:	74a2                	ld	s1,40(sp)
    8000373a:	7902                	ld	s2,32(sp)
    8000373c:	69e2                	ld	s3,24(sp)
    8000373e:	6a42                	ld	s4,16(sp)
    80003740:	6aa2                	ld	s5,8(sp)
    80003742:	6b02                	ld	s6,0(sp)
    80003744:	6121                	add	sp,sp,64
    80003746:	8082                	ret

0000000080003748 <iupdate>:
{
    80003748:	1101                	add	sp,sp,-32
    8000374a:	ec06                	sd	ra,24(sp)
    8000374c:	e822                	sd	s0,16(sp)
    8000374e:	e426                	sd	s1,8(sp)
    80003750:	e04a                	sd	s2,0(sp)
    80003752:	1000                	add	s0,sp,32
    80003754:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003756:	415c                	lw	a5,4(a0)
    80003758:	0047d79b          	srlw	a5,a5,0x4
    8000375c:	0001d597          	auipc	a1,0x1d
    80003760:	0fc5a583          	lw	a1,252(a1) # 80020858 <sb+0x18>
    80003764:	9dbd                	addw	a1,a1,a5
    80003766:	4108                	lw	a0,0(a0)
    80003768:	00000097          	auipc	ra,0x0
    8000376c:	8b2080e7          	jalr	-1870(ra) # 8000301a <bread>
    80003770:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003772:	05850793          	add	a5,a0,88
    80003776:	40d8                	lw	a4,4(s1)
    80003778:	8b3d                	and	a4,a4,15
    8000377a:	071a                	sll	a4,a4,0x6
    8000377c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000377e:	04449703          	lh	a4,68(s1)
    80003782:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003786:	04649703          	lh	a4,70(s1)
    8000378a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000378e:	04849703          	lh	a4,72(s1)
    80003792:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003796:	04a49703          	lh	a4,74(s1)
    8000379a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000379e:	44f8                	lw	a4,76(s1)
    800037a0:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800037a2:	03400613          	li	a2,52
    800037a6:	05048593          	add	a1,s1,80
    800037aa:	00c78513          	add	a0,a5,12
    800037ae:	ffffd097          	auipc	ra,0xffffd
    800037b2:	61a080e7          	jalr	1562(ra) # 80000dc8 <memmove>
  log_write(bp);
    800037b6:	854a                	mv	a0,s2
    800037b8:	00001097          	auipc	ra,0x1
    800037bc:	bcc080e7          	jalr	-1076(ra) # 80004384 <log_write>
  brelse(bp);
    800037c0:	854a                	mv	a0,s2
    800037c2:	00000097          	auipc	ra,0x0
    800037c6:	988080e7          	jalr	-1656(ra) # 8000314a <brelse>
}
    800037ca:	60e2                	ld	ra,24(sp)
    800037cc:	6442                	ld	s0,16(sp)
    800037ce:	64a2                	ld	s1,8(sp)
    800037d0:	6902                	ld	s2,0(sp)
    800037d2:	6105                	add	sp,sp,32
    800037d4:	8082                	ret

00000000800037d6 <idup>:
{
    800037d6:	1101                	add	sp,sp,-32
    800037d8:	ec06                	sd	ra,24(sp)
    800037da:	e822                	sd	s0,16(sp)
    800037dc:	e426                	sd	s1,8(sp)
    800037de:	1000                	add	s0,sp,32
    800037e0:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800037e2:	0001d517          	auipc	a0,0x1d
    800037e6:	07e50513          	add	a0,a0,126 # 80020860 <icache>
    800037ea:	ffffd097          	auipc	ra,0xffffd
    800037ee:	486080e7          	jalr	1158(ra) # 80000c70 <acquire>
  ip->ref++;
    800037f2:	449c                	lw	a5,8(s1)
    800037f4:	2785                	addw	a5,a5,1
    800037f6:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800037f8:	0001d517          	auipc	a0,0x1d
    800037fc:	06850513          	add	a0,a0,104 # 80020860 <icache>
    80003800:	ffffd097          	auipc	ra,0xffffd
    80003804:	524080e7          	jalr	1316(ra) # 80000d24 <release>
}
    80003808:	8526                	mv	a0,s1
    8000380a:	60e2                	ld	ra,24(sp)
    8000380c:	6442                	ld	s0,16(sp)
    8000380e:	64a2                	ld	s1,8(sp)
    80003810:	6105                	add	sp,sp,32
    80003812:	8082                	ret

0000000080003814 <ilock>:
{
    80003814:	1101                	add	sp,sp,-32
    80003816:	ec06                	sd	ra,24(sp)
    80003818:	e822                	sd	s0,16(sp)
    8000381a:	e426                	sd	s1,8(sp)
    8000381c:	e04a                	sd	s2,0(sp)
    8000381e:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003820:	c115                	beqz	a0,80003844 <ilock+0x30>
    80003822:	84aa                	mv	s1,a0
    80003824:	451c                	lw	a5,8(a0)
    80003826:	00f05f63          	blez	a5,80003844 <ilock+0x30>
  acquiresleep(&ip->lock);
    8000382a:	0541                	add	a0,a0,16
    8000382c:	00001097          	auipc	ra,0x1
    80003830:	c7e080e7          	jalr	-898(ra) # 800044aa <acquiresleep>
  if(ip->valid == 0){
    80003834:	40bc                	lw	a5,64(s1)
    80003836:	cf99                	beqz	a5,80003854 <ilock+0x40>
}
    80003838:	60e2                	ld	ra,24(sp)
    8000383a:	6442                	ld	s0,16(sp)
    8000383c:	64a2                	ld	s1,8(sp)
    8000383e:	6902                	ld	s2,0(sp)
    80003840:	6105                	add	sp,sp,32
    80003842:	8082                	ret
    panic("ilock");
    80003844:	00005517          	auipc	a0,0x5
    80003848:	d8c50513          	add	a0,a0,-628 # 800085d0 <syscalls+0x190>
    8000384c:	ffffd097          	auipc	ra,0xffffd
    80003850:	d94080e7          	jalr	-620(ra) # 800005e0 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003854:	40dc                	lw	a5,4(s1)
    80003856:	0047d79b          	srlw	a5,a5,0x4
    8000385a:	0001d597          	auipc	a1,0x1d
    8000385e:	ffe5a583          	lw	a1,-2(a1) # 80020858 <sb+0x18>
    80003862:	9dbd                	addw	a1,a1,a5
    80003864:	4088                	lw	a0,0(s1)
    80003866:	fffff097          	auipc	ra,0xfffff
    8000386a:	7b4080e7          	jalr	1972(ra) # 8000301a <bread>
    8000386e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003870:	05850593          	add	a1,a0,88
    80003874:	40dc                	lw	a5,4(s1)
    80003876:	8bbd                	and	a5,a5,15
    80003878:	079a                	sll	a5,a5,0x6
    8000387a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000387c:	00059783          	lh	a5,0(a1)
    80003880:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003884:	00259783          	lh	a5,2(a1)
    80003888:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000388c:	00459783          	lh	a5,4(a1)
    80003890:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003894:	00659783          	lh	a5,6(a1)
    80003898:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000389c:	459c                	lw	a5,8(a1)
    8000389e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800038a0:	03400613          	li	a2,52
    800038a4:	05b1                	add	a1,a1,12
    800038a6:	05048513          	add	a0,s1,80
    800038aa:	ffffd097          	auipc	ra,0xffffd
    800038ae:	51e080e7          	jalr	1310(ra) # 80000dc8 <memmove>
    brelse(bp);
    800038b2:	854a                	mv	a0,s2
    800038b4:	00000097          	auipc	ra,0x0
    800038b8:	896080e7          	jalr	-1898(ra) # 8000314a <brelse>
    ip->valid = 1;
    800038bc:	4785                	li	a5,1
    800038be:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800038c0:	04449783          	lh	a5,68(s1)
    800038c4:	fbb5                	bnez	a5,80003838 <ilock+0x24>
      panic("ilock: no type");
    800038c6:	00005517          	auipc	a0,0x5
    800038ca:	d1250513          	add	a0,a0,-750 # 800085d8 <syscalls+0x198>
    800038ce:	ffffd097          	auipc	ra,0xffffd
    800038d2:	d12080e7          	jalr	-750(ra) # 800005e0 <panic>

00000000800038d6 <iunlock>:
{
    800038d6:	1101                	add	sp,sp,-32
    800038d8:	ec06                	sd	ra,24(sp)
    800038da:	e822                	sd	s0,16(sp)
    800038dc:	e426                	sd	s1,8(sp)
    800038de:	e04a                	sd	s2,0(sp)
    800038e0:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800038e2:	c905                	beqz	a0,80003912 <iunlock+0x3c>
    800038e4:	84aa                	mv	s1,a0
    800038e6:	01050913          	add	s2,a0,16
    800038ea:	854a                	mv	a0,s2
    800038ec:	00001097          	auipc	ra,0x1
    800038f0:	c58080e7          	jalr	-936(ra) # 80004544 <holdingsleep>
    800038f4:	cd19                	beqz	a0,80003912 <iunlock+0x3c>
    800038f6:	449c                	lw	a5,8(s1)
    800038f8:	00f05d63          	blez	a5,80003912 <iunlock+0x3c>
  releasesleep(&ip->lock);
    800038fc:	854a                	mv	a0,s2
    800038fe:	00001097          	auipc	ra,0x1
    80003902:	c02080e7          	jalr	-1022(ra) # 80004500 <releasesleep>
}
    80003906:	60e2                	ld	ra,24(sp)
    80003908:	6442                	ld	s0,16(sp)
    8000390a:	64a2                	ld	s1,8(sp)
    8000390c:	6902                	ld	s2,0(sp)
    8000390e:	6105                	add	sp,sp,32
    80003910:	8082                	ret
    panic("iunlock");
    80003912:	00005517          	auipc	a0,0x5
    80003916:	cd650513          	add	a0,a0,-810 # 800085e8 <syscalls+0x1a8>
    8000391a:	ffffd097          	auipc	ra,0xffffd
    8000391e:	cc6080e7          	jalr	-826(ra) # 800005e0 <panic>

0000000080003922 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003922:	7179                	add	sp,sp,-48
    80003924:	f406                	sd	ra,40(sp)
    80003926:	f022                	sd	s0,32(sp)
    80003928:	ec26                	sd	s1,24(sp)
    8000392a:	e84a                	sd	s2,16(sp)
    8000392c:	e44e                	sd	s3,8(sp)
    8000392e:	e052                	sd	s4,0(sp)
    80003930:	1800                	add	s0,sp,48
    80003932:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003934:	05050493          	add	s1,a0,80
    80003938:	08050913          	add	s2,a0,128
    8000393c:	a021                	j	80003944 <itrunc+0x22>
    8000393e:	0491                	add	s1,s1,4
    80003940:	01248d63          	beq	s1,s2,8000395a <itrunc+0x38>
    if(ip->addrs[i]){
    80003944:	408c                	lw	a1,0(s1)
    80003946:	dde5                	beqz	a1,8000393e <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003948:	0009a503          	lw	a0,0(s3)
    8000394c:	00000097          	auipc	ra,0x0
    80003950:	912080e7          	jalr	-1774(ra) # 8000325e <bfree>
      ip->addrs[i] = 0;
    80003954:	0004a023          	sw	zero,0(s1)
    80003958:	b7dd                	j	8000393e <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000395a:	0809a583          	lw	a1,128(s3)
    8000395e:	e185                	bnez	a1,8000397e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003960:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003964:	854e                	mv	a0,s3
    80003966:	00000097          	auipc	ra,0x0
    8000396a:	de2080e7          	jalr	-542(ra) # 80003748 <iupdate>
}
    8000396e:	70a2                	ld	ra,40(sp)
    80003970:	7402                	ld	s0,32(sp)
    80003972:	64e2                	ld	s1,24(sp)
    80003974:	6942                	ld	s2,16(sp)
    80003976:	69a2                	ld	s3,8(sp)
    80003978:	6a02                	ld	s4,0(sp)
    8000397a:	6145                	add	sp,sp,48
    8000397c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000397e:	0009a503          	lw	a0,0(s3)
    80003982:	fffff097          	auipc	ra,0xfffff
    80003986:	698080e7          	jalr	1688(ra) # 8000301a <bread>
    8000398a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000398c:	05850493          	add	s1,a0,88
    80003990:	45850913          	add	s2,a0,1112
    80003994:	a021                	j	8000399c <itrunc+0x7a>
    80003996:	0491                	add	s1,s1,4
    80003998:	01248b63          	beq	s1,s2,800039ae <itrunc+0x8c>
      if(a[j])
    8000399c:	408c                	lw	a1,0(s1)
    8000399e:	dde5                	beqz	a1,80003996 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    800039a0:	0009a503          	lw	a0,0(s3)
    800039a4:	00000097          	auipc	ra,0x0
    800039a8:	8ba080e7          	jalr	-1862(ra) # 8000325e <bfree>
    800039ac:	b7ed                	j	80003996 <itrunc+0x74>
    brelse(bp);
    800039ae:	8552                	mv	a0,s4
    800039b0:	fffff097          	auipc	ra,0xfffff
    800039b4:	79a080e7          	jalr	1946(ra) # 8000314a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800039b8:	0809a583          	lw	a1,128(s3)
    800039bc:	0009a503          	lw	a0,0(s3)
    800039c0:	00000097          	auipc	ra,0x0
    800039c4:	89e080e7          	jalr	-1890(ra) # 8000325e <bfree>
    ip->addrs[NDIRECT] = 0;
    800039c8:	0809a023          	sw	zero,128(s3)
    800039cc:	bf51                	j	80003960 <itrunc+0x3e>

00000000800039ce <iput>:
{
    800039ce:	1101                	add	sp,sp,-32
    800039d0:	ec06                	sd	ra,24(sp)
    800039d2:	e822                	sd	s0,16(sp)
    800039d4:	e426                	sd	s1,8(sp)
    800039d6:	e04a                	sd	s2,0(sp)
    800039d8:	1000                	add	s0,sp,32
    800039da:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800039dc:	0001d517          	auipc	a0,0x1d
    800039e0:	e8450513          	add	a0,a0,-380 # 80020860 <icache>
    800039e4:	ffffd097          	auipc	ra,0xffffd
    800039e8:	28c080e7          	jalr	652(ra) # 80000c70 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039ec:	4498                	lw	a4,8(s1)
    800039ee:	4785                	li	a5,1
    800039f0:	02f70363          	beq	a4,a5,80003a16 <iput+0x48>
  ip->ref--;
    800039f4:	449c                	lw	a5,8(s1)
    800039f6:	37fd                	addw	a5,a5,-1
    800039f8:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800039fa:	0001d517          	auipc	a0,0x1d
    800039fe:	e6650513          	add	a0,a0,-410 # 80020860 <icache>
    80003a02:	ffffd097          	auipc	ra,0xffffd
    80003a06:	322080e7          	jalr	802(ra) # 80000d24 <release>
}
    80003a0a:	60e2                	ld	ra,24(sp)
    80003a0c:	6442                	ld	s0,16(sp)
    80003a0e:	64a2                	ld	s1,8(sp)
    80003a10:	6902                	ld	s2,0(sp)
    80003a12:	6105                	add	sp,sp,32
    80003a14:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003a16:	40bc                	lw	a5,64(s1)
    80003a18:	dff1                	beqz	a5,800039f4 <iput+0x26>
    80003a1a:	04a49783          	lh	a5,74(s1)
    80003a1e:	fbf9                	bnez	a5,800039f4 <iput+0x26>
    acquiresleep(&ip->lock);
    80003a20:	01048913          	add	s2,s1,16
    80003a24:	854a                	mv	a0,s2
    80003a26:	00001097          	auipc	ra,0x1
    80003a2a:	a84080e7          	jalr	-1404(ra) # 800044aa <acquiresleep>
    release(&icache.lock);
    80003a2e:	0001d517          	auipc	a0,0x1d
    80003a32:	e3250513          	add	a0,a0,-462 # 80020860 <icache>
    80003a36:	ffffd097          	auipc	ra,0xffffd
    80003a3a:	2ee080e7          	jalr	750(ra) # 80000d24 <release>
    itrunc(ip);
    80003a3e:	8526                	mv	a0,s1
    80003a40:	00000097          	auipc	ra,0x0
    80003a44:	ee2080e7          	jalr	-286(ra) # 80003922 <itrunc>
    ip->type = 0;
    80003a48:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003a4c:	8526                	mv	a0,s1
    80003a4e:	00000097          	auipc	ra,0x0
    80003a52:	cfa080e7          	jalr	-774(ra) # 80003748 <iupdate>
    ip->valid = 0;
    80003a56:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003a5a:	854a                	mv	a0,s2
    80003a5c:	00001097          	auipc	ra,0x1
    80003a60:	aa4080e7          	jalr	-1372(ra) # 80004500 <releasesleep>
    acquire(&icache.lock);
    80003a64:	0001d517          	auipc	a0,0x1d
    80003a68:	dfc50513          	add	a0,a0,-516 # 80020860 <icache>
    80003a6c:	ffffd097          	auipc	ra,0xffffd
    80003a70:	204080e7          	jalr	516(ra) # 80000c70 <acquire>
    80003a74:	b741                	j	800039f4 <iput+0x26>

0000000080003a76 <iunlockput>:
{
    80003a76:	1101                	add	sp,sp,-32
    80003a78:	ec06                	sd	ra,24(sp)
    80003a7a:	e822                	sd	s0,16(sp)
    80003a7c:	e426                	sd	s1,8(sp)
    80003a7e:	1000                	add	s0,sp,32
    80003a80:	84aa                	mv	s1,a0
  iunlock(ip);
    80003a82:	00000097          	auipc	ra,0x0
    80003a86:	e54080e7          	jalr	-428(ra) # 800038d6 <iunlock>
  iput(ip);
    80003a8a:	8526                	mv	a0,s1
    80003a8c:	00000097          	auipc	ra,0x0
    80003a90:	f42080e7          	jalr	-190(ra) # 800039ce <iput>
}
    80003a94:	60e2                	ld	ra,24(sp)
    80003a96:	6442                	ld	s0,16(sp)
    80003a98:	64a2                	ld	s1,8(sp)
    80003a9a:	6105                	add	sp,sp,32
    80003a9c:	8082                	ret

0000000080003a9e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003a9e:	1141                	add	sp,sp,-16
    80003aa0:	e422                	sd	s0,8(sp)
    80003aa2:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80003aa4:	411c                	lw	a5,0(a0)
    80003aa6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003aa8:	415c                	lw	a5,4(a0)
    80003aaa:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003aac:	04451783          	lh	a5,68(a0)
    80003ab0:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003ab4:	04a51783          	lh	a5,74(a0)
    80003ab8:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003abc:	04c56783          	lwu	a5,76(a0)
    80003ac0:	e99c                	sd	a5,16(a1)
}
    80003ac2:	6422                	ld	s0,8(sp)
    80003ac4:	0141                	add	sp,sp,16
    80003ac6:	8082                	ret

0000000080003ac8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003ac8:	457c                	lw	a5,76(a0)
    80003aca:	0ed7e863          	bltu	a5,a3,80003bba <readi+0xf2>
{
    80003ace:	7159                	add	sp,sp,-112
    80003ad0:	f486                	sd	ra,104(sp)
    80003ad2:	f0a2                	sd	s0,96(sp)
    80003ad4:	eca6                	sd	s1,88(sp)
    80003ad6:	e8ca                	sd	s2,80(sp)
    80003ad8:	e4ce                	sd	s3,72(sp)
    80003ada:	e0d2                	sd	s4,64(sp)
    80003adc:	fc56                	sd	s5,56(sp)
    80003ade:	f85a                	sd	s6,48(sp)
    80003ae0:	f45e                	sd	s7,40(sp)
    80003ae2:	f062                	sd	s8,32(sp)
    80003ae4:	ec66                	sd	s9,24(sp)
    80003ae6:	e86a                	sd	s10,16(sp)
    80003ae8:	e46e                	sd	s11,8(sp)
    80003aea:	1880                	add	s0,sp,112
    80003aec:	8baa                	mv	s7,a0
    80003aee:	8c2e                	mv	s8,a1
    80003af0:	8ab2                	mv	s5,a2
    80003af2:	84b6                	mv	s1,a3
    80003af4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003af6:	9f35                	addw	a4,a4,a3
    return 0;
    80003af8:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003afa:	08d76f63          	bltu	a4,a3,80003b98 <readi+0xd0>
  if(off + n > ip->size)
    80003afe:	00e7f463          	bgeu	a5,a4,80003b06 <readi+0x3e>
    n = ip->size - off;
    80003b02:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b06:	0a0b0863          	beqz	s6,80003bb6 <readi+0xee>
    80003b0a:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b0c:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003b10:	5cfd                	li	s9,-1
    80003b12:	a82d                	j	80003b4c <readi+0x84>
    80003b14:	020a1d93          	sll	s11,s4,0x20
    80003b18:	020ddd93          	srl	s11,s11,0x20
    80003b1c:	05890613          	add	a2,s2,88
    80003b20:	86ee                	mv	a3,s11
    80003b22:	963a                	add	a2,a2,a4
    80003b24:	85d6                	mv	a1,s5
    80003b26:	8562                	mv	a0,s8
    80003b28:	fffff097          	auipc	ra,0xfffff
    80003b2c:	9cc080e7          	jalr	-1588(ra) # 800024f4 <either_copyout>
    80003b30:	05950d63          	beq	a0,s9,80003b8a <readi+0xc2>
      brelse(bp);
      break;
    }
    brelse(bp);
    80003b34:	854a                	mv	a0,s2
    80003b36:	fffff097          	auipc	ra,0xfffff
    80003b3a:	614080e7          	jalr	1556(ra) # 8000314a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b3e:	013a09bb          	addw	s3,s4,s3
    80003b42:	009a04bb          	addw	s1,s4,s1
    80003b46:	9aee                	add	s5,s5,s11
    80003b48:	0569f663          	bgeu	s3,s6,80003b94 <readi+0xcc>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003b4c:	000ba903          	lw	s2,0(s7)
    80003b50:	00a4d59b          	srlw	a1,s1,0xa
    80003b54:	855e                	mv	a0,s7
    80003b56:	00000097          	auipc	ra,0x0
    80003b5a:	8b2080e7          	jalr	-1870(ra) # 80003408 <bmap>
    80003b5e:	0005059b          	sext.w	a1,a0
    80003b62:	854a                	mv	a0,s2
    80003b64:	fffff097          	auipc	ra,0xfffff
    80003b68:	4b6080e7          	jalr	1206(ra) # 8000301a <bread>
    80003b6c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b6e:	3ff4f713          	and	a4,s1,1023
    80003b72:	40ed07bb          	subw	a5,s10,a4
    80003b76:	413b06bb          	subw	a3,s6,s3
    80003b7a:	8a3e                	mv	s4,a5
    80003b7c:	2781                	sext.w	a5,a5
    80003b7e:	0006861b          	sext.w	a2,a3
    80003b82:	f8f679e3          	bgeu	a2,a5,80003b14 <readi+0x4c>
    80003b86:	8a36                	mv	s4,a3
    80003b88:	b771                	j	80003b14 <readi+0x4c>
      brelse(bp);
    80003b8a:	854a                	mv	a0,s2
    80003b8c:	fffff097          	auipc	ra,0xfffff
    80003b90:	5be080e7          	jalr	1470(ra) # 8000314a <brelse>
  }
  return tot;
    80003b94:	0009851b          	sext.w	a0,s3
}
    80003b98:	70a6                	ld	ra,104(sp)
    80003b9a:	7406                	ld	s0,96(sp)
    80003b9c:	64e6                	ld	s1,88(sp)
    80003b9e:	6946                	ld	s2,80(sp)
    80003ba0:	69a6                	ld	s3,72(sp)
    80003ba2:	6a06                	ld	s4,64(sp)
    80003ba4:	7ae2                	ld	s5,56(sp)
    80003ba6:	7b42                	ld	s6,48(sp)
    80003ba8:	7ba2                	ld	s7,40(sp)
    80003baa:	7c02                	ld	s8,32(sp)
    80003bac:	6ce2                	ld	s9,24(sp)
    80003bae:	6d42                	ld	s10,16(sp)
    80003bb0:	6da2                	ld	s11,8(sp)
    80003bb2:	6165                	add	sp,sp,112
    80003bb4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003bb6:	89da                	mv	s3,s6
    80003bb8:	bff1                	j	80003b94 <readi+0xcc>
    return 0;
    80003bba:	4501                	li	a0,0
}
    80003bbc:	8082                	ret

0000000080003bbe <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003bbe:	457c                	lw	a5,76(a0)
    80003bc0:	10d7e663          	bltu	a5,a3,80003ccc <writei+0x10e>
{
    80003bc4:	7159                	add	sp,sp,-112
    80003bc6:	f486                	sd	ra,104(sp)
    80003bc8:	f0a2                	sd	s0,96(sp)
    80003bca:	eca6                	sd	s1,88(sp)
    80003bcc:	e8ca                	sd	s2,80(sp)
    80003bce:	e4ce                	sd	s3,72(sp)
    80003bd0:	e0d2                	sd	s4,64(sp)
    80003bd2:	fc56                	sd	s5,56(sp)
    80003bd4:	f85a                	sd	s6,48(sp)
    80003bd6:	f45e                	sd	s7,40(sp)
    80003bd8:	f062                	sd	s8,32(sp)
    80003bda:	ec66                	sd	s9,24(sp)
    80003bdc:	e86a                	sd	s10,16(sp)
    80003bde:	e46e                	sd	s11,8(sp)
    80003be0:	1880                	add	s0,sp,112
    80003be2:	8baa                	mv	s7,a0
    80003be4:	8c2e                	mv	s8,a1
    80003be6:	8ab2                	mv	s5,a2
    80003be8:	8936                	mv	s2,a3
    80003bea:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003bec:	00e687bb          	addw	a5,a3,a4
    80003bf0:	0ed7e063          	bltu	a5,a3,80003cd0 <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003bf4:	00043737          	lui	a4,0x43
    80003bf8:	0cf76e63          	bltu	a4,a5,80003cd4 <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003bfc:	0a0b0763          	beqz	s6,80003caa <writei+0xec>
    80003c00:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c02:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003c06:	5cfd                	li	s9,-1
    80003c08:	a091                	j	80003c4c <writei+0x8e>
    80003c0a:	02099d93          	sll	s11,s3,0x20
    80003c0e:	020ddd93          	srl	s11,s11,0x20
    80003c12:	05848513          	add	a0,s1,88
    80003c16:	86ee                	mv	a3,s11
    80003c18:	8656                	mv	a2,s5
    80003c1a:	85e2                	mv	a1,s8
    80003c1c:	953a                	add	a0,a0,a4
    80003c1e:	fffff097          	auipc	ra,0xfffff
    80003c22:	92c080e7          	jalr	-1748(ra) # 8000254a <either_copyin>
    80003c26:	07950263          	beq	a0,s9,80003c8a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003c2a:	8526                	mv	a0,s1
    80003c2c:	00000097          	auipc	ra,0x0
    80003c30:	758080e7          	jalr	1880(ra) # 80004384 <log_write>
    brelse(bp);
    80003c34:	8526                	mv	a0,s1
    80003c36:	fffff097          	auipc	ra,0xfffff
    80003c3a:	514080e7          	jalr	1300(ra) # 8000314a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c3e:	01498a3b          	addw	s4,s3,s4
    80003c42:	0129893b          	addw	s2,s3,s2
    80003c46:	9aee                	add	s5,s5,s11
    80003c48:	056a7663          	bgeu	s4,s6,80003c94 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003c4c:	000ba483          	lw	s1,0(s7)
    80003c50:	00a9559b          	srlw	a1,s2,0xa
    80003c54:	855e                	mv	a0,s7
    80003c56:	fffff097          	auipc	ra,0xfffff
    80003c5a:	7b2080e7          	jalr	1970(ra) # 80003408 <bmap>
    80003c5e:	0005059b          	sext.w	a1,a0
    80003c62:	8526                	mv	a0,s1
    80003c64:	fffff097          	auipc	ra,0xfffff
    80003c68:	3b6080e7          	jalr	950(ra) # 8000301a <bread>
    80003c6c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c6e:	3ff97713          	and	a4,s2,1023
    80003c72:	40ed07bb          	subw	a5,s10,a4
    80003c76:	414b06bb          	subw	a3,s6,s4
    80003c7a:	89be                	mv	s3,a5
    80003c7c:	2781                	sext.w	a5,a5
    80003c7e:	0006861b          	sext.w	a2,a3
    80003c82:	f8f674e3          	bgeu	a2,a5,80003c0a <writei+0x4c>
    80003c86:	89b6                	mv	s3,a3
    80003c88:	b749                	j	80003c0a <writei+0x4c>
      brelse(bp);
    80003c8a:	8526                	mv	a0,s1
    80003c8c:	fffff097          	auipc	ra,0xfffff
    80003c90:	4be080e7          	jalr	1214(ra) # 8000314a <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80003c94:	04cba783          	lw	a5,76(s7)
    80003c98:	0127f463          	bgeu	a5,s2,80003ca0 <writei+0xe2>
      ip->size = off;
    80003c9c:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003ca0:	855e                	mv	a0,s7
    80003ca2:	00000097          	auipc	ra,0x0
    80003ca6:	aa6080e7          	jalr	-1370(ra) # 80003748 <iupdate>
  }

  return n;
    80003caa:	000b051b          	sext.w	a0,s6
}
    80003cae:	70a6                	ld	ra,104(sp)
    80003cb0:	7406                	ld	s0,96(sp)
    80003cb2:	64e6                	ld	s1,88(sp)
    80003cb4:	6946                	ld	s2,80(sp)
    80003cb6:	69a6                	ld	s3,72(sp)
    80003cb8:	6a06                	ld	s4,64(sp)
    80003cba:	7ae2                	ld	s5,56(sp)
    80003cbc:	7b42                	ld	s6,48(sp)
    80003cbe:	7ba2                	ld	s7,40(sp)
    80003cc0:	7c02                	ld	s8,32(sp)
    80003cc2:	6ce2                	ld	s9,24(sp)
    80003cc4:	6d42                	ld	s10,16(sp)
    80003cc6:	6da2                	ld	s11,8(sp)
    80003cc8:	6165                	add	sp,sp,112
    80003cca:	8082                	ret
    return -1;
    80003ccc:	557d                	li	a0,-1
}
    80003cce:	8082                	ret
    return -1;
    80003cd0:	557d                	li	a0,-1
    80003cd2:	bff1                	j	80003cae <writei+0xf0>
    return -1;
    80003cd4:	557d                	li	a0,-1
    80003cd6:	bfe1                	j	80003cae <writei+0xf0>

0000000080003cd8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003cd8:	1141                	add	sp,sp,-16
    80003cda:	e406                	sd	ra,8(sp)
    80003cdc:	e022                	sd	s0,0(sp)
    80003cde:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003ce0:	4639                	li	a2,14
    80003ce2:	ffffd097          	auipc	ra,0xffffd
    80003ce6:	162080e7          	jalr	354(ra) # 80000e44 <strncmp>
}
    80003cea:	60a2                	ld	ra,8(sp)
    80003cec:	6402                	ld	s0,0(sp)
    80003cee:	0141                	add	sp,sp,16
    80003cf0:	8082                	ret

0000000080003cf2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003cf2:	7139                	add	sp,sp,-64
    80003cf4:	fc06                	sd	ra,56(sp)
    80003cf6:	f822                	sd	s0,48(sp)
    80003cf8:	f426                	sd	s1,40(sp)
    80003cfa:	f04a                	sd	s2,32(sp)
    80003cfc:	ec4e                	sd	s3,24(sp)
    80003cfe:	e852                	sd	s4,16(sp)
    80003d00:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003d02:	04451703          	lh	a4,68(a0)
    80003d06:	4785                	li	a5,1
    80003d08:	00f71a63          	bne	a4,a5,80003d1c <dirlookup+0x2a>
    80003d0c:	892a                	mv	s2,a0
    80003d0e:	89ae                	mv	s3,a1
    80003d10:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d12:	457c                	lw	a5,76(a0)
    80003d14:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003d16:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d18:	e79d                	bnez	a5,80003d46 <dirlookup+0x54>
    80003d1a:	a8a5                	j	80003d92 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003d1c:	00005517          	auipc	a0,0x5
    80003d20:	8d450513          	add	a0,a0,-1836 # 800085f0 <syscalls+0x1b0>
    80003d24:	ffffd097          	auipc	ra,0xffffd
    80003d28:	8bc080e7          	jalr	-1860(ra) # 800005e0 <panic>
      panic("dirlookup read");
    80003d2c:	00005517          	auipc	a0,0x5
    80003d30:	8dc50513          	add	a0,a0,-1828 # 80008608 <syscalls+0x1c8>
    80003d34:	ffffd097          	auipc	ra,0xffffd
    80003d38:	8ac080e7          	jalr	-1876(ra) # 800005e0 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d3c:	24c1                	addw	s1,s1,16
    80003d3e:	04c92783          	lw	a5,76(s2)
    80003d42:	04f4f763          	bgeu	s1,a5,80003d90 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d46:	4741                	li	a4,16
    80003d48:	86a6                	mv	a3,s1
    80003d4a:	fc040613          	add	a2,s0,-64
    80003d4e:	4581                	li	a1,0
    80003d50:	854a                	mv	a0,s2
    80003d52:	00000097          	auipc	ra,0x0
    80003d56:	d76080e7          	jalr	-650(ra) # 80003ac8 <readi>
    80003d5a:	47c1                	li	a5,16
    80003d5c:	fcf518e3          	bne	a0,a5,80003d2c <dirlookup+0x3a>
    if(de.inum == 0)
    80003d60:	fc045783          	lhu	a5,-64(s0)
    80003d64:	dfe1                	beqz	a5,80003d3c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003d66:	fc240593          	add	a1,s0,-62
    80003d6a:	854e                	mv	a0,s3
    80003d6c:	00000097          	auipc	ra,0x0
    80003d70:	f6c080e7          	jalr	-148(ra) # 80003cd8 <namecmp>
    80003d74:	f561                	bnez	a0,80003d3c <dirlookup+0x4a>
      if(poff)
    80003d76:	000a0463          	beqz	s4,80003d7e <dirlookup+0x8c>
        *poff = off;
    80003d7a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003d7e:	fc045583          	lhu	a1,-64(s0)
    80003d82:	00092503          	lw	a0,0(s2)
    80003d86:	fffff097          	auipc	ra,0xfffff
    80003d8a:	75e080e7          	jalr	1886(ra) # 800034e4 <iget>
    80003d8e:	a011                	j	80003d92 <dirlookup+0xa0>
  return 0;
    80003d90:	4501                	li	a0,0
}
    80003d92:	70e2                	ld	ra,56(sp)
    80003d94:	7442                	ld	s0,48(sp)
    80003d96:	74a2                	ld	s1,40(sp)
    80003d98:	7902                	ld	s2,32(sp)
    80003d9a:	69e2                	ld	s3,24(sp)
    80003d9c:	6a42                	ld	s4,16(sp)
    80003d9e:	6121                	add	sp,sp,64
    80003da0:	8082                	ret

0000000080003da2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003da2:	711d                	add	sp,sp,-96
    80003da4:	ec86                	sd	ra,88(sp)
    80003da6:	e8a2                	sd	s0,80(sp)
    80003da8:	e4a6                	sd	s1,72(sp)
    80003daa:	e0ca                	sd	s2,64(sp)
    80003dac:	fc4e                	sd	s3,56(sp)
    80003dae:	f852                	sd	s4,48(sp)
    80003db0:	f456                	sd	s5,40(sp)
    80003db2:	f05a                	sd	s6,32(sp)
    80003db4:	ec5e                	sd	s7,24(sp)
    80003db6:	e862                	sd	s8,16(sp)
    80003db8:	e466                	sd	s9,8(sp)
    80003dba:	1080                	add	s0,sp,96
    80003dbc:	84aa                	mv	s1,a0
    80003dbe:	8b2e                	mv	s6,a1
    80003dc0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003dc2:	00054703          	lbu	a4,0(a0)
    80003dc6:	02f00793          	li	a5,47
    80003dca:	02f70263          	beq	a4,a5,80003dee <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003dce:	ffffe097          	auipc	ra,0xffffe
    80003dd2:	c6c080e7          	jalr	-916(ra) # 80001a3a <myproc>
    80003dd6:	15053503          	ld	a0,336(a0)
    80003dda:	00000097          	auipc	ra,0x0
    80003dde:	9fc080e7          	jalr	-1540(ra) # 800037d6 <idup>
    80003de2:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003de4:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003de8:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003dea:	4b85                	li	s7,1
    80003dec:	a875                	j	80003ea8 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003dee:	4585                	li	a1,1
    80003df0:	4505                	li	a0,1
    80003df2:	fffff097          	auipc	ra,0xfffff
    80003df6:	6f2080e7          	jalr	1778(ra) # 800034e4 <iget>
    80003dfa:	8a2a                	mv	s4,a0
    80003dfc:	b7e5                	j	80003de4 <namex+0x42>
      iunlockput(ip);
    80003dfe:	8552                	mv	a0,s4
    80003e00:	00000097          	auipc	ra,0x0
    80003e04:	c76080e7          	jalr	-906(ra) # 80003a76 <iunlockput>
      return 0;
    80003e08:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003e0a:	8552                	mv	a0,s4
    80003e0c:	60e6                	ld	ra,88(sp)
    80003e0e:	6446                	ld	s0,80(sp)
    80003e10:	64a6                	ld	s1,72(sp)
    80003e12:	6906                	ld	s2,64(sp)
    80003e14:	79e2                	ld	s3,56(sp)
    80003e16:	7a42                	ld	s4,48(sp)
    80003e18:	7aa2                	ld	s5,40(sp)
    80003e1a:	7b02                	ld	s6,32(sp)
    80003e1c:	6be2                	ld	s7,24(sp)
    80003e1e:	6c42                	ld	s8,16(sp)
    80003e20:	6ca2                	ld	s9,8(sp)
    80003e22:	6125                	add	sp,sp,96
    80003e24:	8082                	ret
      iunlock(ip);
    80003e26:	8552                	mv	a0,s4
    80003e28:	00000097          	auipc	ra,0x0
    80003e2c:	aae080e7          	jalr	-1362(ra) # 800038d6 <iunlock>
      return ip;
    80003e30:	bfe9                	j	80003e0a <namex+0x68>
      iunlockput(ip);
    80003e32:	8552                	mv	a0,s4
    80003e34:	00000097          	auipc	ra,0x0
    80003e38:	c42080e7          	jalr	-958(ra) # 80003a76 <iunlockput>
      return 0;
    80003e3c:	8a4e                	mv	s4,s3
    80003e3e:	b7f1                	j	80003e0a <namex+0x68>
  len = path - s;
    80003e40:	40998633          	sub	a2,s3,s1
    80003e44:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003e48:	099c5863          	bge	s8,s9,80003ed8 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003e4c:	4639                	li	a2,14
    80003e4e:	85a6                	mv	a1,s1
    80003e50:	8556                	mv	a0,s5
    80003e52:	ffffd097          	auipc	ra,0xffffd
    80003e56:	f76080e7          	jalr	-138(ra) # 80000dc8 <memmove>
    80003e5a:	84ce                	mv	s1,s3
  while(*path == '/')
    80003e5c:	0004c783          	lbu	a5,0(s1)
    80003e60:	01279763          	bne	a5,s2,80003e6e <namex+0xcc>
    path++;
    80003e64:	0485                	add	s1,s1,1
  while(*path == '/')
    80003e66:	0004c783          	lbu	a5,0(s1)
    80003e6a:	ff278de3          	beq	a5,s2,80003e64 <namex+0xc2>
    ilock(ip);
    80003e6e:	8552                	mv	a0,s4
    80003e70:	00000097          	auipc	ra,0x0
    80003e74:	9a4080e7          	jalr	-1628(ra) # 80003814 <ilock>
    if(ip->type != T_DIR){
    80003e78:	044a1783          	lh	a5,68(s4)
    80003e7c:	f97791e3          	bne	a5,s7,80003dfe <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003e80:	000b0563          	beqz	s6,80003e8a <namex+0xe8>
    80003e84:	0004c783          	lbu	a5,0(s1)
    80003e88:	dfd9                	beqz	a5,80003e26 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003e8a:	4601                	li	a2,0
    80003e8c:	85d6                	mv	a1,s5
    80003e8e:	8552                	mv	a0,s4
    80003e90:	00000097          	auipc	ra,0x0
    80003e94:	e62080e7          	jalr	-414(ra) # 80003cf2 <dirlookup>
    80003e98:	89aa                	mv	s3,a0
    80003e9a:	dd41                	beqz	a0,80003e32 <namex+0x90>
    iunlockput(ip);
    80003e9c:	8552                	mv	a0,s4
    80003e9e:	00000097          	auipc	ra,0x0
    80003ea2:	bd8080e7          	jalr	-1064(ra) # 80003a76 <iunlockput>
    ip = next;
    80003ea6:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003ea8:	0004c783          	lbu	a5,0(s1)
    80003eac:	01279763          	bne	a5,s2,80003eba <namex+0x118>
    path++;
    80003eb0:	0485                	add	s1,s1,1
  while(*path == '/')
    80003eb2:	0004c783          	lbu	a5,0(s1)
    80003eb6:	ff278de3          	beq	a5,s2,80003eb0 <namex+0x10e>
  if(*path == 0)
    80003eba:	cb9d                	beqz	a5,80003ef0 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003ebc:	0004c783          	lbu	a5,0(s1)
    80003ec0:	89a6                	mv	s3,s1
  len = path - s;
    80003ec2:	4c81                	li	s9,0
    80003ec4:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003ec6:	01278963          	beq	a5,s2,80003ed8 <namex+0x136>
    80003eca:	dbbd                	beqz	a5,80003e40 <namex+0x9e>
    path++;
    80003ecc:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80003ece:	0009c783          	lbu	a5,0(s3)
    80003ed2:	ff279ce3          	bne	a5,s2,80003eca <namex+0x128>
    80003ed6:	b7ad                	j	80003e40 <namex+0x9e>
    memmove(name, s, len);
    80003ed8:	2601                	sext.w	a2,a2
    80003eda:	85a6                	mv	a1,s1
    80003edc:	8556                	mv	a0,s5
    80003ede:	ffffd097          	auipc	ra,0xffffd
    80003ee2:	eea080e7          	jalr	-278(ra) # 80000dc8 <memmove>
    name[len] = 0;
    80003ee6:	9cd6                	add	s9,s9,s5
    80003ee8:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003eec:	84ce                	mv	s1,s3
    80003eee:	b7bd                	j	80003e5c <namex+0xba>
  if(nameiparent){
    80003ef0:	f00b0de3          	beqz	s6,80003e0a <namex+0x68>
    iput(ip);
    80003ef4:	8552                	mv	a0,s4
    80003ef6:	00000097          	auipc	ra,0x0
    80003efa:	ad8080e7          	jalr	-1320(ra) # 800039ce <iput>
    return 0;
    80003efe:	4a01                	li	s4,0
    80003f00:	b729                	j	80003e0a <namex+0x68>

0000000080003f02 <dirlink>:
{
    80003f02:	7139                	add	sp,sp,-64
    80003f04:	fc06                	sd	ra,56(sp)
    80003f06:	f822                	sd	s0,48(sp)
    80003f08:	f426                	sd	s1,40(sp)
    80003f0a:	f04a                	sd	s2,32(sp)
    80003f0c:	ec4e                	sd	s3,24(sp)
    80003f0e:	e852                	sd	s4,16(sp)
    80003f10:	0080                	add	s0,sp,64
    80003f12:	892a                	mv	s2,a0
    80003f14:	8a2e                	mv	s4,a1
    80003f16:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003f18:	4601                	li	a2,0
    80003f1a:	00000097          	auipc	ra,0x0
    80003f1e:	dd8080e7          	jalr	-552(ra) # 80003cf2 <dirlookup>
    80003f22:	e93d                	bnez	a0,80003f98 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f24:	04c92483          	lw	s1,76(s2)
    80003f28:	c49d                	beqz	s1,80003f56 <dirlink+0x54>
    80003f2a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f2c:	4741                	li	a4,16
    80003f2e:	86a6                	mv	a3,s1
    80003f30:	fc040613          	add	a2,s0,-64
    80003f34:	4581                	li	a1,0
    80003f36:	854a                	mv	a0,s2
    80003f38:	00000097          	auipc	ra,0x0
    80003f3c:	b90080e7          	jalr	-1136(ra) # 80003ac8 <readi>
    80003f40:	47c1                	li	a5,16
    80003f42:	06f51163          	bne	a0,a5,80003fa4 <dirlink+0xa2>
    if(de.inum == 0)
    80003f46:	fc045783          	lhu	a5,-64(s0)
    80003f4a:	c791                	beqz	a5,80003f56 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f4c:	24c1                	addw	s1,s1,16
    80003f4e:	04c92783          	lw	a5,76(s2)
    80003f52:	fcf4ede3          	bltu	s1,a5,80003f2c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003f56:	4639                	li	a2,14
    80003f58:	85d2                	mv	a1,s4
    80003f5a:	fc240513          	add	a0,s0,-62
    80003f5e:	ffffd097          	auipc	ra,0xffffd
    80003f62:	f22080e7          	jalr	-222(ra) # 80000e80 <strncpy>
  de.inum = inum;
    80003f66:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f6a:	4741                	li	a4,16
    80003f6c:	86a6                	mv	a3,s1
    80003f6e:	fc040613          	add	a2,s0,-64
    80003f72:	4581                	li	a1,0
    80003f74:	854a                	mv	a0,s2
    80003f76:	00000097          	auipc	ra,0x0
    80003f7a:	c48080e7          	jalr	-952(ra) # 80003bbe <writei>
    80003f7e:	872a                	mv	a4,a0
    80003f80:	47c1                	li	a5,16
  return 0;
    80003f82:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f84:	02f71863          	bne	a4,a5,80003fb4 <dirlink+0xb2>
}
    80003f88:	70e2                	ld	ra,56(sp)
    80003f8a:	7442                	ld	s0,48(sp)
    80003f8c:	74a2                	ld	s1,40(sp)
    80003f8e:	7902                	ld	s2,32(sp)
    80003f90:	69e2                	ld	s3,24(sp)
    80003f92:	6a42                	ld	s4,16(sp)
    80003f94:	6121                	add	sp,sp,64
    80003f96:	8082                	ret
    iput(ip);
    80003f98:	00000097          	auipc	ra,0x0
    80003f9c:	a36080e7          	jalr	-1482(ra) # 800039ce <iput>
    return -1;
    80003fa0:	557d                	li	a0,-1
    80003fa2:	b7dd                	j	80003f88 <dirlink+0x86>
      panic("dirlink read");
    80003fa4:	00004517          	auipc	a0,0x4
    80003fa8:	67450513          	add	a0,a0,1652 # 80008618 <syscalls+0x1d8>
    80003fac:	ffffc097          	auipc	ra,0xffffc
    80003fb0:	634080e7          	jalr	1588(ra) # 800005e0 <panic>
    panic("dirlink");
    80003fb4:	00004517          	auipc	a0,0x4
    80003fb8:	78450513          	add	a0,a0,1924 # 80008738 <syscalls+0x2f8>
    80003fbc:	ffffc097          	auipc	ra,0xffffc
    80003fc0:	624080e7          	jalr	1572(ra) # 800005e0 <panic>

0000000080003fc4 <namei>:

struct inode*
namei(char *path)
{
    80003fc4:	1101                	add	sp,sp,-32
    80003fc6:	ec06                	sd	ra,24(sp)
    80003fc8:	e822                	sd	s0,16(sp)
    80003fca:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003fcc:	fe040613          	add	a2,s0,-32
    80003fd0:	4581                	li	a1,0
    80003fd2:	00000097          	auipc	ra,0x0
    80003fd6:	dd0080e7          	jalr	-560(ra) # 80003da2 <namex>
}
    80003fda:	60e2                	ld	ra,24(sp)
    80003fdc:	6442                	ld	s0,16(sp)
    80003fde:	6105                	add	sp,sp,32
    80003fe0:	8082                	ret

0000000080003fe2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003fe2:	1141                	add	sp,sp,-16
    80003fe4:	e406                	sd	ra,8(sp)
    80003fe6:	e022                	sd	s0,0(sp)
    80003fe8:	0800                	add	s0,sp,16
    80003fea:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003fec:	4585                	li	a1,1
    80003fee:	00000097          	auipc	ra,0x0
    80003ff2:	db4080e7          	jalr	-588(ra) # 80003da2 <namex>
}
    80003ff6:	60a2                	ld	ra,8(sp)
    80003ff8:	6402                	ld	s0,0(sp)
    80003ffa:	0141                	add	sp,sp,16
    80003ffc:	8082                	ret

0000000080003ffe <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003ffe:	1101                	add	sp,sp,-32
    80004000:	ec06                	sd	ra,24(sp)
    80004002:	e822                	sd	s0,16(sp)
    80004004:	e426                	sd	s1,8(sp)
    80004006:	e04a                	sd	s2,0(sp)
    80004008:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000400a:	0001e917          	auipc	s2,0x1e
    8000400e:	2fe90913          	add	s2,s2,766 # 80022308 <log>
    80004012:	01892583          	lw	a1,24(s2)
    80004016:	02892503          	lw	a0,40(s2)
    8000401a:	fffff097          	auipc	ra,0xfffff
    8000401e:	000080e7          	jalr	ra # 8000301a <bread>
    80004022:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004024:	02c92603          	lw	a2,44(s2)
    80004028:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000402a:	00c05f63          	blez	a2,80004048 <write_head+0x4a>
    8000402e:	0001e717          	auipc	a4,0x1e
    80004032:	30a70713          	add	a4,a4,778 # 80022338 <log+0x30>
    80004036:	87aa                	mv	a5,a0
    80004038:	060a                	sll	a2,a2,0x2
    8000403a:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000403c:	4314                	lw	a3,0(a4)
    8000403e:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004040:	0711                	add	a4,a4,4
    80004042:	0791                	add	a5,a5,4
    80004044:	fec79ce3          	bne	a5,a2,8000403c <write_head+0x3e>
  }
  bwrite(buf);
    80004048:	8526                	mv	a0,s1
    8000404a:	fffff097          	auipc	ra,0xfffff
    8000404e:	0c2080e7          	jalr	194(ra) # 8000310c <bwrite>
  brelse(buf);
    80004052:	8526                	mv	a0,s1
    80004054:	fffff097          	auipc	ra,0xfffff
    80004058:	0f6080e7          	jalr	246(ra) # 8000314a <brelse>
}
    8000405c:	60e2                	ld	ra,24(sp)
    8000405e:	6442                	ld	s0,16(sp)
    80004060:	64a2                	ld	s1,8(sp)
    80004062:	6902                	ld	s2,0(sp)
    80004064:	6105                	add	sp,sp,32
    80004066:	8082                	ret

0000000080004068 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004068:	0001e797          	auipc	a5,0x1e
    8000406c:	2cc7a783          	lw	a5,716(a5) # 80022334 <log+0x2c>
    80004070:	0af05663          	blez	a5,8000411c <install_trans+0xb4>
{
    80004074:	7139                	add	sp,sp,-64
    80004076:	fc06                	sd	ra,56(sp)
    80004078:	f822                	sd	s0,48(sp)
    8000407a:	f426                	sd	s1,40(sp)
    8000407c:	f04a                	sd	s2,32(sp)
    8000407e:	ec4e                	sd	s3,24(sp)
    80004080:	e852                	sd	s4,16(sp)
    80004082:	e456                	sd	s5,8(sp)
    80004084:	0080                	add	s0,sp,64
    80004086:	0001ea97          	auipc	s5,0x1e
    8000408a:	2b2a8a93          	add	s5,s5,690 # 80022338 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000408e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004090:	0001e997          	auipc	s3,0x1e
    80004094:	27898993          	add	s3,s3,632 # 80022308 <log>
    80004098:	0189a583          	lw	a1,24(s3)
    8000409c:	014585bb          	addw	a1,a1,s4
    800040a0:	2585                	addw	a1,a1,1
    800040a2:	0289a503          	lw	a0,40(s3)
    800040a6:	fffff097          	auipc	ra,0xfffff
    800040aa:	f74080e7          	jalr	-140(ra) # 8000301a <bread>
    800040ae:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800040b0:	000aa583          	lw	a1,0(s5)
    800040b4:	0289a503          	lw	a0,40(s3)
    800040b8:	fffff097          	auipc	ra,0xfffff
    800040bc:	f62080e7          	jalr	-158(ra) # 8000301a <bread>
    800040c0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800040c2:	40000613          	li	a2,1024
    800040c6:	05890593          	add	a1,s2,88
    800040ca:	05850513          	add	a0,a0,88
    800040ce:	ffffd097          	auipc	ra,0xffffd
    800040d2:	cfa080e7          	jalr	-774(ra) # 80000dc8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800040d6:	8526                	mv	a0,s1
    800040d8:	fffff097          	auipc	ra,0xfffff
    800040dc:	034080e7          	jalr	52(ra) # 8000310c <bwrite>
    bunpin(dbuf);
    800040e0:	8526                	mv	a0,s1
    800040e2:	fffff097          	auipc	ra,0xfffff
    800040e6:	140080e7          	jalr	320(ra) # 80003222 <bunpin>
    brelse(lbuf);
    800040ea:	854a                	mv	a0,s2
    800040ec:	fffff097          	auipc	ra,0xfffff
    800040f0:	05e080e7          	jalr	94(ra) # 8000314a <brelse>
    brelse(dbuf);
    800040f4:	8526                	mv	a0,s1
    800040f6:	fffff097          	auipc	ra,0xfffff
    800040fa:	054080e7          	jalr	84(ra) # 8000314a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800040fe:	2a05                	addw	s4,s4,1
    80004100:	0a91                	add	s5,s5,4
    80004102:	02c9a783          	lw	a5,44(s3)
    80004106:	f8fa49e3          	blt	s4,a5,80004098 <install_trans+0x30>
}
    8000410a:	70e2                	ld	ra,56(sp)
    8000410c:	7442                	ld	s0,48(sp)
    8000410e:	74a2                	ld	s1,40(sp)
    80004110:	7902                	ld	s2,32(sp)
    80004112:	69e2                	ld	s3,24(sp)
    80004114:	6a42                	ld	s4,16(sp)
    80004116:	6aa2                	ld	s5,8(sp)
    80004118:	6121                	add	sp,sp,64
    8000411a:	8082                	ret
    8000411c:	8082                	ret

000000008000411e <initlog>:
{
    8000411e:	7179                	add	sp,sp,-48
    80004120:	f406                	sd	ra,40(sp)
    80004122:	f022                	sd	s0,32(sp)
    80004124:	ec26                	sd	s1,24(sp)
    80004126:	e84a                	sd	s2,16(sp)
    80004128:	e44e                	sd	s3,8(sp)
    8000412a:	1800                	add	s0,sp,48
    8000412c:	892a                	mv	s2,a0
    8000412e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004130:	0001e497          	auipc	s1,0x1e
    80004134:	1d848493          	add	s1,s1,472 # 80022308 <log>
    80004138:	00004597          	auipc	a1,0x4
    8000413c:	4f058593          	add	a1,a1,1264 # 80008628 <syscalls+0x1e8>
    80004140:	8526                	mv	a0,s1
    80004142:	ffffd097          	auipc	ra,0xffffd
    80004146:	a9e080e7          	jalr	-1378(ra) # 80000be0 <initlock>
  log.start = sb->logstart;
    8000414a:	0149a583          	lw	a1,20(s3)
    8000414e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004150:	0109a783          	lw	a5,16(s3)
    80004154:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004156:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000415a:	854a                	mv	a0,s2
    8000415c:	fffff097          	auipc	ra,0xfffff
    80004160:	ebe080e7          	jalr	-322(ra) # 8000301a <bread>
  log.lh.n = lh->n;
    80004164:	4d30                	lw	a2,88(a0)
    80004166:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004168:	00c05f63          	blez	a2,80004186 <initlog+0x68>
    8000416c:	87aa                	mv	a5,a0
    8000416e:	0001e717          	auipc	a4,0x1e
    80004172:	1ca70713          	add	a4,a4,458 # 80022338 <log+0x30>
    80004176:	060a                	sll	a2,a2,0x2
    80004178:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000417a:	4ff4                	lw	a3,92(a5)
    8000417c:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000417e:	0791                	add	a5,a5,4
    80004180:	0711                	add	a4,a4,4
    80004182:	fec79ce3          	bne	a5,a2,8000417a <initlog+0x5c>
  brelse(buf);
    80004186:	fffff097          	auipc	ra,0xfffff
    8000418a:	fc4080e7          	jalr	-60(ra) # 8000314a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    8000418e:	00000097          	auipc	ra,0x0
    80004192:	eda080e7          	jalr	-294(ra) # 80004068 <install_trans>
  log.lh.n = 0;
    80004196:	0001e797          	auipc	a5,0x1e
    8000419a:	1807af23          	sw	zero,414(a5) # 80022334 <log+0x2c>
  write_head(); // clear the log
    8000419e:	00000097          	auipc	ra,0x0
    800041a2:	e60080e7          	jalr	-416(ra) # 80003ffe <write_head>
}
    800041a6:	70a2                	ld	ra,40(sp)
    800041a8:	7402                	ld	s0,32(sp)
    800041aa:	64e2                	ld	s1,24(sp)
    800041ac:	6942                	ld	s2,16(sp)
    800041ae:	69a2                	ld	s3,8(sp)
    800041b0:	6145                	add	sp,sp,48
    800041b2:	8082                	ret

00000000800041b4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800041b4:	1101                	add	sp,sp,-32
    800041b6:	ec06                	sd	ra,24(sp)
    800041b8:	e822                	sd	s0,16(sp)
    800041ba:	e426                	sd	s1,8(sp)
    800041bc:	e04a                	sd	s2,0(sp)
    800041be:	1000                	add	s0,sp,32
  acquire(&log.lock);
    800041c0:	0001e517          	auipc	a0,0x1e
    800041c4:	14850513          	add	a0,a0,328 # 80022308 <log>
    800041c8:	ffffd097          	auipc	ra,0xffffd
    800041cc:	aa8080e7          	jalr	-1368(ra) # 80000c70 <acquire>
  while(1){
    if(log.committing){
    800041d0:	0001e497          	auipc	s1,0x1e
    800041d4:	13848493          	add	s1,s1,312 # 80022308 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800041d8:	4979                	li	s2,30
    800041da:	a039                	j	800041e8 <begin_op+0x34>
      sleep(&log, &log.lock);
    800041dc:	85a6                	mv	a1,s1
    800041de:	8526                	mv	a0,s1
    800041e0:	ffffe097          	auipc	ra,0xffffe
    800041e4:	0ba080e7          	jalr	186(ra) # 8000229a <sleep>
    if(log.committing){
    800041e8:	50dc                	lw	a5,36(s1)
    800041ea:	fbed                	bnez	a5,800041dc <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800041ec:	5098                	lw	a4,32(s1)
    800041ee:	2705                	addw	a4,a4,1
    800041f0:	0027179b          	sllw	a5,a4,0x2
    800041f4:	9fb9                	addw	a5,a5,a4
    800041f6:	0017979b          	sllw	a5,a5,0x1
    800041fa:	54d4                	lw	a3,44(s1)
    800041fc:	9fb5                	addw	a5,a5,a3
    800041fe:	00f95963          	bge	s2,a5,80004210 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004202:	85a6                	mv	a1,s1
    80004204:	8526                	mv	a0,s1
    80004206:	ffffe097          	auipc	ra,0xffffe
    8000420a:	094080e7          	jalr	148(ra) # 8000229a <sleep>
    8000420e:	bfe9                	j	800041e8 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004210:	0001e517          	auipc	a0,0x1e
    80004214:	0f850513          	add	a0,a0,248 # 80022308 <log>
    80004218:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000421a:	ffffd097          	auipc	ra,0xffffd
    8000421e:	b0a080e7          	jalr	-1270(ra) # 80000d24 <release>
      break;
    }
  }
}
    80004222:	60e2                	ld	ra,24(sp)
    80004224:	6442                	ld	s0,16(sp)
    80004226:	64a2                	ld	s1,8(sp)
    80004228:	6902                	ld	s2,0(sp)
    8000422a:	6105                	add	sp,sp,32
    8000422c:	8082                	ret

000000008000422e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000422e:	7139                	add	sp,sp,-64
    80004230:	fc06                	sd	ra,56(sp)
    80004232:	f822                	sd	s0,48(sp)
    80004234:	f426                	sd	s1,40(sp)
    80004236:	f04a                	sd	s2,32(sp)
    80004238:	ec4e                	sd	s3,24(sp)
    8000423a:	e852                	sd	s4,16(sp)
    8000423c:	e456                	sd	s5,8(sp)
    8000423e:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004240:	0001e497          	auipc	s1,0x1e
    80004244:	0c848493          	add	s1,s1,200 # 80022308 <log>
    80004248:	8526                	mv	a0,s1
    8000424a:	ffffd097          	auipc	ra,0xffffd
    8000424e:	a26080e7          	jalr	-1498(ra) # 80000c70 <acquire>
  log.outstanding -= 1;
    80004252:	509c                	lw	a5,32(s1)
    80004254:	37fd                	addw	a5,a5,-1
    80004256:	0007891b          	sext.w	s2,a5
    8000425a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000425c:	50dc                	lw	a5,36(s1)
    8000425e:	e7b9                	bnez	a5,800042ac <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004260:	04091e63          	bnez	s2,800042bc <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004264:	0001e497          	auipc	s1,0x1e
    80004268:	0a448493          	add	s1,s1,164 # 80022308 <log>
    8000426c:	4785                	li	a5,1
    8000426e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004270:	8526                	mv	a0,s1
    80004272:	ffffd097          	auipc	ra,0xffffd
    80004276:	ab2080e7          	jalr	-1358(ra) # 80000d24 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000427a:	54dc                	lw	a5,44(s1)
    8000427c:	06f04763          	bgtz	a5,800042ea <end_op+0xbc>
    acquire(&log.lock);
    80004280:	0001e497          	auipc	s1,0x1e
    80004284:	08848493          	add	s1,s1,136 # 80022308 <log>
    80004288:	8526                	mv	a0,s1
    8000428a:	ffffd097          	auipc	ra,0xffffd
    8000428e:	9e6080e7          	jalr	-1562(ra) # 80000c70 <acquire>
    log.committing = 0;
    80004292:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004296:	8526                	mv	a0,s1
    80004298:	ffffe097          	auipc	ra,0xffffe
    8000429c:	182080e7          	jalr	386(ra) # 8000241a <wakeup>
    release(&log.lock);
    800042a0:	8526                	mv	a0,s1
    800042a2:	ffffd097          	auipc	ra,0xffffd
    800042a6:	a82080e7          	jalr	-1406(ra) # 80000d24 <release>
}
    800042aa:	a03d                	j	800042d8 <end_op+0xaa>
    panic("log.committing");
    800042ac:	00004517          	auipc	a0,0x4
    800042b0:	38450513          	add	a0,a0,900 # 80008630 <syscalls+0x1f0>
    800042b4:	ffffc097          	auipc	ra,0xffffc
    800042b8:	32c080e7          	jalr	812(ra) # 800005e0 <panic>
    wakeup(&log);
    800042bc:	0001e497          	auipc	s1,0x1e
    800042c0:	04c48493          	add	s1,s1,76 # 80022308 <log>
    800042c4:	8526                	mv	a0,s1
    800042c6:	ffffe097          	auipc	ra,0xffffe
    800042ca:	154080e7          	jalr	340(ra) # 8000241a <wakeup>
  release(&log.lock);
    800042ce:	8526                	mv	a0,s1
    800042d0:	ffffd097          	auipc	ra,0xffffd
    800042d4:	a54080e7          	jalr	-1452(ra) # 80000d24 <release>
}
    800042d8:	70e2                	ld	ra,56(sp)
    800042da:	7442                	ld	s0,48(sp)
    800042dc:	74a2                	ld	s1,40(sp)
    800042de:	7902                	ld	s2,32(sp)
    800042e0:	69e2                	ld	s3,24(sp)
    800042e2:	6a42                	ld	s4,16(sp)
    800042e4:	6aa2                	ld	s5,8(sp)
    800042e6:	6121                	add	sp,sp,64
    800042e8:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800042ea:	0001ea97          	auipc	s5,0x1e
    800042ee:	04ea8a93          	add	s5,s5,78 # 80022338 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800042f2:	0001ea17          	auipc	s4,0x1e
    800042f6:	016a0a13          	add	s4,s4,22 # 80022308 <log>
    800042fa:	018a2583          	lw	a1,24(s4)
    800042fe:	012585bb          	addw	a1,a1,s2
    80004302:	2585                	addw	a1,a1,1
    80004304:	028a2503          	lw	a0,40(s4)
    80004308:	fffff097          	auipc	ra,0xfffff
    8000430c:	d12080e7          	jalr	-750(ra) # 8000301a <bread>
    80004310:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004312:	000aa583          	lw	a1,0(s5)
    80004316:	028a2503          	lw	a0,40(s4)
    8000431a:	fffff097          	auipc	ra,0xfffff
    8000431e:	d00080e7          	jalr	-768(ra) # 8000301a <bread>
    80004322:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004324:	40000613          	li	a2,1024
    80004328:	05850593          	add	a1,a0,88
    8000432c:	05848513          	add	a0,s1,88
    80004330:	ffffd097          	auipc	ra,0xffffd
    80004334:	a98080e7          	jalr	-1384(ra) # 80000dc8 <memmove>
    bwrite(to);  // write the log
    80004338:	8526                	mv	a0,s1
    8000433a:	fffff097          	auipc	ra,0xfffff
    8000433e:	dd2080e7          	jalr	-558(ra) # 8000310c <bwrite>
    brelse(from);
    80004342:	854e                	mv	a0,s3
    80004344:	fffff097          	auipc	ra,0xfffff
    80004348:	e06080e7          	jalr	-506(ra) # 8000314a <brelse>
    brelse(to);
    8000434c:	8526                	mv	a0,s1
    8000434e:	fffff097          	auipc	ra,0xfffff
    80004352:	dfc080e7          	jalr	-516(ra) # 8000314a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004356:	2905                	addw	s2,s2,1
    80004358:	0a91                	add	s5,s5,4
    8000435a:	02ca2783          	lw	a5,44(s4)
    8000435e:	f8f94ee3          	blt	s2,a5,800042fa <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004362:	00000097          	auipc	ra,0x0
    80004366:	c9c080e7          	jalr	-868(ra) # 80003ffe <write_head>
    install_trans(); // Now install writes to home locations
    8000436a:	00000097          	auipc	ra,0x0
    8000436e:	cfe080e7          	jalr	-770(ra) # 80004068 <install_trans>
    log.lh.n = 0;
    80004372:	0001e797          	auipc	a5,0x1e
    80004376:	fc07a123          	sw	zero,-62(a5) # 80022334 <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000437a:	00000097          	auipc	ra,0x0
    8000437e:	c84080e7          	jalr	-892(ra) # 80003ffe <write_head>
    80004382:	bdfd                	j	80004280 <end_op+0x52>

0000000080004384 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004384:	1101                	add	sp,sp,-32
    80004386:	ec06                	sd	ra,24(sp)
    80004388:	e822                	sd	s0,16(sp)
    8000438a:	e426                	sd	s1,8(sp)
    8000438c:	e04a                	sd	s2,0(sp)
    8000438e:	1000                	add	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004390:	0001e717          	auipc	a4,0x1e
    80004394:	fa472703          	lw	a4,-92(a4) # 80022334 <log+0x2c>
    80004398:	47f5                	li	a5,29
    8000439a:	08e7c063          	blt	a5,a4,8000441a <log_write+0x96>
    8000439e:	84aa                	mv	s1,a0
    800043a0:	0001e797          	auipc	a5,0x1e
    800043a4:	f847a783          	lw	a5,-124(a5) # 80022324 <log+0x1c>
    800043a8:	37fd                	addw	a5,a5,-1
    800043aa:	06f75863          	bge	a4,a5,8000441a <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800043ae:	0001e797          	auipc	a5,0x1e
    800043b2:	f7a7a783          	lw	a5,-134(a5) # 80022328 <log+0x20>
    800043b6:	06f05a63          	blez	a5,8000442a <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    800043ba:	0001e917          	auipc	s2,0x1e
    800043be:	f4e90913          	add	s2,s2,-178 # 80022308 <log>
    800043c2:	854a                	mv	a0,s2
    800043c4:	ffffd097          	auipc	ra,0xffffd
    800043c8:	8ac080e7          	jalr	-1876(ra) # 80000c70 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    800043cc:	02c92603          	lw	a2,44(s2)
    800043d0:	06c05563          	blez	a2,8000443a <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800043d4:	44cc                	lw	a1,12(s1)
    800043d6:	0001e717          	auipc	a4,0x1e
    800043da:	f6270713          	add	a4,a4,-158 # 80022338 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800043de:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800043e0:	4314                	lw	a3,0(a4)
    800043e2:	04b68d63          	beq	a3,a1,8000443c <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    800043e6:	2785                	addw	a5,a5,1
    800043e8:	0711                	add	a4,a4,4
    800043ea:	fec79be3          	bne	a5,a2,800043e0 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    800043ee:	0621                	add	a2,a2,8
    800043f0:	060a                	sll	a2,a2,0x2
    800043f2:	0001e797          	auipc	a5,0x1e
    800043f6:	f1678793          	add	a5,a5,-234 # 80022308 <log>
    800043fa:	97b2                	add	a5,a5,a2
    800043fc:	44d8                	lw	a4,12(s1)
    800043fe:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004400:	8526                	mv	a0,s1
    80004402:	fffff097          	auipc	ra,0xfffff
    80004406:	de4080e7          	jalr	-540(ra) # 800031e6 <bpin>
    log.lh.n++;
    8000440a:	0001e717          	auipc	a4,0x1e
    8000440e:	efe70713          	add	a4,a4,-258 # 80022308 <log>
    80004412:	575c                	lw	a5,44(a4)
    80004414:	2785                	addw	a5,a5,1
    80004416:	d75c                	sw	a5,44(a4)
    80004418:	a835                	j	80004454 <log_write+0xd0>
    panic("too big a transaction");
    8000441a:	00004517          	auipc	a0,0x4
    8000441e:	22650513          	add	a0,a0,550 # 80008640 <syscalls+0x200>
    80004422:	ffffc097          	auipc	ra,0xffffc
    80004426:	1be080e7          	jalr	446(ra) # 800005e0 <panic>
    panic("log_write outside of trans");
    8000442a:	00004517          	auipc	a0,0x4
    8000442e:	22e50513          	add	a0,a0,558 # 80008658 <syscalls+0x218>
    80004432:	ffffc097          	auipc	ra,0xffffc
    80004436:	1ae080e7          	jalr	430(ra) # 800005e0 <panic>
  for (i = 0; i < log.lh.n; i++) {
    8000443a:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    8000443c:	00878693          	add	a3,a5,8
    80004440:	068a                	sll	a3,a3,0x2
    80004442:	0001e717          	auipc	a4,0x1e
    80004446:	ec670713          	add	a4,a4,-314 # 80022308 <log>
    8000444a:	9736                	add	a4,a4,a3
    8000444c:	44d4                	lw	a3,12(s1)
    8000444e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004450:	faf608e3          	beq	a2,a5,80004400 <log_write+0x7c>
  }
  release(&log.lock);
    80004454:	0001e517          	auipc	a0,0x1e
    80004458:	eb450513          	add	a0,a0,-332 # 80022308 <log>
    8000445c:	ffffd097          	auipc	ra,0xffffd
    80004460:	8c8080e7          	jalr	-1848(ra) # 80000d24 <release>
}
    80004464:	60e2                	ld	ra,24(sp)
    80004466:	6442                	ld	s0,16(sp)
    80004468:	64a2                	ld	s1,8(sp)
    8000446a:	6902                	ld	s2,0(sp)
    8000446c:	6105                	add	sp,sp,32
    8000446e:	8082                	ret

0000000080004470 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004470:	1101                	add	sp,sp,-32
    80004472:	ec06                	sd	ra,24(sp)
    80004474:	e822                	sd	s0,16(sp)
    80004476:	e426                	sd	s1,8(sp)
    80004478:	e04a                	sd	s2,0(sp)
    8000447a:	1000                	add	s0,sp,32
    8000447c:	84aa                	mv	s1,a0
    8000447e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004480:	00004597          	auipc	a1,0x4
    80004484:	1f858593          	add	a1,a1,504 # 80008678 <syscalls+0x238>
    80004488:	0521                	add	a0,a0,8
    8000448a:	ffffc097          	auipc	ra,0xffffc
    8000448e:	756080e7          	jalr	1878(ra) # 80000be0 <initlock>
  lk->name = name;
    80004492:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004496:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000449a:	0204a423          	sw	zero,40(s1)
}
    8000449e:	60e2                	ld	ra,24(sp)
    800044a0:	6442                	ld	s0,16(sp)
    800044a2:	64a2                	ld	s1,8(sp)
    800044a4:	6902                	ld	s2,0(sp)
    800044a6:	6105                	add	sp,sp,32
    800044a8:	8082                	ret

00000000800044aa <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800044aa:	1101                	add	sp,sp,-32
    800044ac:	ec06                	sd	ra,24(sp)
    800044ae:	e822                	sd	s0,16(sp)
    800044b0:	e426                	sd	s1,8(sp)
    800044b2:	e04a                	sd	s2,0(sp)
    800044b4:	1000                	add	s0,sp,32
    800044b6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800044b8:	00850913          	add	s2,a0,8
    800044bc:	854a                	mv	a0,s2
    800044be:	ffffc097          	auipc	ra,0xffffc
    800044c2:	7b2080e7          	jalr	1970(ra) # 80000c70 <acquire>
  while (lk->locked) {
    800044c6:	409c                	lw	a5,0(s1)
    800044c8:	cb89                	beqz	a5,800044da <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800044ca:	85ca                	mv	a1,s2
    800044cc:	8526                	mv	a0,s1
    800044ce:	ffffe097          	auipc	ra,0xffffe
    800044d2:	dcc080e7          	jalr	-564(ra) # 8000229a <sleep>
  while (lk->locked) {
    800044d6:	409c                	lw	a5,0(s1)
    800044d8:	fbed                	bnez	a5,800044ca <acquiresleep+0x20>
  }
  lk->locked = 1;
    800044da:	4785                	li	a5,1
    800044dc:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800044de:	ffffd097          	auipc	ra,0xffffd
    800044e2:	55c080e7          	jalr	1372(ra) # 80001a3a <myproc>
    800044e6:	5d1c                	lw	a5,56(a0)
    800044e8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800044ea:	854a                	mv	a0,s2
    800044ec:	ffffd097          	auipc	ra,0xffffd
    800044f0:	838080e7          	jalr	-1992(ra) # 80000d24 <release>
}
    800044f4:	60e2                	ld	ra,24(sp)
    800044f6:	6442                	ld	s0,16(sp)
    800044f8:	64a2                	ld	s1,8(sp)
    800044fa:	6902                	ld	s2,0(sp)
    800044fc:	6105                	add	sp,sp,32
    800044fe:	8082                	ret

0000000080004500 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004500:	1101                	add	sp,sp,-32
    80004502:	ec06                	sd	ra,24(sp)
    80004504:	e822                	sd	s0,16(sp)
    80004506:	e426                	sd	s1,8(sp)
    80004508:	e04a                	sd	s2,0(sp)
    8000450a:	1000                	add	s0,sp,32
    8000450c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000450e:	00850913          	add	s2,a0,8
    80004512:	854a                	mv	a0,s2
    80004514:	ffffc097          	auipc	ra,0xffffc
    80004518:	75c080e7          	jalr	1884(ra) # 80000c70 <acquire>
  lk->locked = 0;
    8000451c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004520:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004524:	8526                	mv	a0,s1
    80004526:	ffffe097          	auipc	ra,0xffffe
    8000452a:	ef4080e7          	jalr	-268(ra) # 8000241a <wakeup>
  release(&lk->lk);
    8000452e:	854a                	mv	a0,s2
    80004530:	ffffc097          	auipc	ra,0xffffc
    80004534:	7f4080e7          	jalr	2036(ra) # 80000d24 <release>
}
    80004538:	60e2                	ld	ra,24(sp)
    8000453a:	6442                	ld	s0,16(sp)
    8000453c:	64a2                	ld	s1,8(sp)
    8000453e:	6902                	ld	s2,0(sp)
    80004540:	6105                	add	sp,sp,32
    80004542:	8082                	ret

0000000080004544 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004544:	7179                	add	sp,sp,-48
    80004546:	f406                	sd	ra,40(sp)
    80004548:	f022                	sd	s0,32(sp)
    8000454a:	ec26                	sd	s1,24(sp)
    8000454c:	e84a                	sd	s2,16(sp)
    8000454e:	e44e                	sd	s3,8(sp)
    80004550:	1800                	add	s0,sp,48
    80004552:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004554:	00850913          	add	s2,a0,8
    80004558:	854a                	mv	a0,s2
    8000455a:	ffffc097          	auipc	ra,0xffffc
    8000455e:	716080e7          	jalr	1814(ra) # 80000c70 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004562:	409c                	lw	a5,0(s1)
    80004564:	ef99                	bnez	a5,80004582 <holdingsleep+0x3e>
    80004566:	4481                	li	s1,0
  release(&lk->lk);
    80004568:	854a                	mv	a0,s2
    8000456a:	ffffc097          	auipc	ra,0xffffc
    8000456e:	7ba080e7          	jalr	1978(ra) # 80000d24 <release>
  return r;
}
    80004572:	8526                	mv	a0,s1
    80004574:	70a2                	ld	ra,40(sp)
    80004576:	7402                	ld	s0,32(sp)
    80004578:	64e2                	ld	s1,24(sp)
    8000457a:	6942                	ld	s2,16(sp)
    8000457c:	69a2                	ld	s3,8(sp)
    8000457e:	6145                	add	sp,sp,48
    80004580:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004582:	0284a983          	lw	s3,40(s1)
    80004586:	ffffd097          	auipc	ra,0xffffd
    8000458a:	4b4080e7          	jalr	1204(ra) # 80001a3a <myproc>
    8000458e:	5d04                	lw	s1,56(a0)
    80004590:	413484b3          	sub	s1,s1,s3
    80004594:	0014b493          	seqz	s1,s1
    80004598:	bfc1                	j	80004568 <holdingsleep+0x24>

000000008000459a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000459a:	1141                	add	sp,sp,-16
    8000459c:	e406                	sd	ra,8(sp)
    8000459e:	e022                	sd	s0,0(sp)
    800045a0:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800045a2:	00004597          	auipc	a1,0x4
    800045a6:	0e658593          	add	a1,a1,230 # 80008688 <syscalls+0x248>
    800045aa:	0001e517          	auipc	a0,0x1e
    800045ae:	ea650513          	add	a0,a0,-346 # 80022450 <ftable>
    800045b2:	ffffc097          	auipc	ra,0xffffc
    800045b6:	62e080e7          	jalr	1582(ra) # 80000be0 <initlock>
}
    800045ba:	60a2                	ld	ra,8(sp)
    800045bc:	6402                	ld	s0,0(sp)
    800045be:	0141                	add	sp,sp,16
    800045c0:	8082                	ret

00000000800045c2 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800045c2:	1101                	add	sp,sp,-32
    800045c4:	ec06                	sd	ra,24(sp)
    800045c6:	e822                	sd	s0,16(sp)
    800045c8:	e426                	sd	s1,8(sp)
    800045ca:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800045cc:	0001e517          	auipc	a0,0x1e
    800045d0:	e8450513          	add	a0,a0,-380 # 80022450 <ftable>
    800045d4:	ffffc097          	auipc	ra,0xffffc
    800045d8:	69c080e7          	jalr	1692(ra) # 80000c70 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800045dc:	0001e497          	auipc	s1,0x1e
    800045e0:	e8c48493          	add	s1,s1,-372 # 80022468 <ftable+0x18>
    800045e4:	0001f717          	auipc	a4,0x1f
    800045e8:	e2470713          	add	a4,a4,-476 # 80023408 <ftable+0xfb8>
    if(f->ref == 0){
    800045ec:	40dc                	lw	a5,4(s1)
    800045ee:	cf99                	beqz	a5,8000460c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800045f0:	02848493          	add	s1,s1,40
    800045f4:	fee49ce3          	bne	s1,a4,800045ec <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800045f8:	0001e517          	auipc	a0,0x1e
    800045fc:	e5850513          	add	a0,a0,-424 # 80022450 <ftable>
    80004600:	ffffc097          	auipc	ra,0xffffc
    80004604:	724080e7          	jalr	1828(ra) # 80000d24 <release>
  return 0;
    80004608:	4481                	li	s1,0
    8000460a:	a819                	j	80004620 <filealloc+0x5e>
      f->ref = 1;
    8000460c:	4785                	li	a5,1
    8000460e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004610:	0001e517          	auipc	a0,0x1e
    80004614:	e4050513          	add	a0,a0,-448 # 80022450 <ftable>
    80004618:	ffffc097          	auipc	ra,0xffffc
    8000461c:	70c080e7          	jalr	1804(ra) # 80000d24 <release>
}
    80004620:	8526                	mv	a0,s1
    80004622:	60e2                	ld	ra,24(sp)
    80004624:	6442                	ld	s0,16(sp)
    80004626:	64a2                	ld	s1,8(sp)
    80004628:	6105                	add	sp,sp,32
    8000462a:	8082                	ret

000000008000462c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000462c:	1101                	add	sp,sp,-32
    8000462e:	ec06                	sd	ra,24(sp)
    80004630:	e822                	sd	s0,16(sp)
    80004632:	e426                	sd	s1,8(sp)
    80004634:	1000                	add	s0,sp,32
    80004636:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004638:	0001e517          	auipc	a0,0x1e
    8000463c:	e1850513          	add	a0,a0,-488 # 80022450 <ftable>
    80004640:	ffffc097          	auipc	ra,0xffffc
    80004644:	630080e7          	jalr	1584(ra) # 80000c70 <acquire>
  if(f->ref < 1)
    80004648:	40dc                	lw	a5,4(s1)
    8000464a:	02f05263          	blez	a5,8000466e <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000464e:	2785                	addw	a5,a5,1
    80004650:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004652:	0001e517          	auipc	a0,0x1e
    80004656:	dfe50513          	add	a0,a0,-514 # 80022450 <ftable>
    8000465a:	ffffc097          	auipc	ra,0xffffc
    8000465e:	6ca080e7          	jalr	1738(ra) # 80000d24 <release>
  return f;
}
    80004662:	8526                	mv	a0,s1
    80004664:	60e2                	ld	ra,24(sp)
    80004666:	6442                	ld	s0,16(sp)
    80004668:	64a2                	ld	s1,8(sp)
    8000466a:	6105                	add	sp,sp,32
    8000466c:	8082                	ret
    panic("filedup");
    8000466e:	00004517          	auipc	a0,0x4
    80004672:	02250513          	add	a0,a0,34 # 80008690 <syscalls+0x250>
    80004676:	ffffc097          	auipc	ra,0xffffc
    8000467a:	f6a080e7          	jalr	-150(ra) # 800005e0 <panic>

000000008000467e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000467e:	7139                	add	sp,sp,-64
    80004680:	fc06                	sd	ra,56(sp)
    80004682:	f822                	sd	s0,48(sp)
    80004684:	f426                	sd	s1,40(sp)
    80004686:	f04a                	sd	s2,32(sp)
    80004688:	ec4e                	sd	s3,24(sp)
    8000468a:	e852                	sd	s4,16(sp)
    8000468c:	e456                	sd	s5,8(sp)
    8000468e:	0080                	add	s0,sp,64
    80004690:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004692:	0001e517          	auipc	a0,0x1e
    80004696:	dbe50513          	add	a0,a0,-578 # 80022450 <ftable>
    8000469a:	ffffc097          	auipc	ra,0xffffc
    8000469e:	5d6080e7          	jalr	1494(ra) # 80000c70 <acquire>
  if(f->ref < 1)
    800046a2:	40dc                	lw	a5,4(s1)
    800046a4:	06f05163          	blez	a5,80004706 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800046a8:	37fd                	addw	a5,a5,-1
    800046aa:	0007871b          	sext.w	a4,a5
    800046ae:	c0dc                	sw	a5,4(s1)
    800046b0:	06e04363          	bgtz	a4,80004716 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800046b4:	0004a903          	lw	s2,0(s1)
    800046b8:	0094ca83          	lbu	s5,9(s1)
    800046bc:	0104ba03          	ld	s4,16(s1)
    800046c0:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800046c4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800046c8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800046cc:	0001e517          	auipc	a0,0x1e
    800046d0:	d8450513          	add	a0,a0,-636 # 80022450 <ftable>
    800046d4:	ffffc097          	auipc	ra,0xffffc
    800046d8:	650080e7          	jalr	1616(ra) # 80000d24 <release>

  if(ff.type == FD_PIPE){
    800046dc:	4785                	li	a5,1
    800046de:	04f90d63          	beq	s2,a5,80004738 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800046e2:	3979                	addw	s2,s2,-2
    800046e4:	4785                	li	a5,1
    800046e6:	0527e063          	bltu	a5,s2,80004726 <fileclose+0xa8>
    begin_op();
    800046ea:	00000097          	auipc	ra,0x0
    800046ee:	aca080e7          	jalr	-1334(ra) # 800041b4 <begin_op>
    iput(ff.ip);
    800046f2:	854e                	mv	a0,s3
    800046f4:	fffff097          	auipc	ra,0xfffff
    800046f8:	2da080e7          	jalr	730(ra) # 800039ce <iput>
    end_op();
    800046fc:	00000097          	auipc	ra,0x0
    80004700:	b32080e7          	jalr	-1230(ra) # 8000422e <end_op>
    80004704:	a00d                	j	80004726 <fileclose+0xa8>
    panic("fileclose");
    80004706:	00004517          	auipc	a0,0x4
    8000470a:	f9250513          	add	a0,a0,-110 # 80008698 <syscalls+0x258>
    8000470e:	ffffc097          	auipc	ra,0xffffc
    80004712:	ed2080e7          	jalr	-302(ra) # 800005e0 <panic>
    release(&ftable.lock);
    80004716:	0001e517          	auipc	a0,0x1e
    8000471a:	d3a50513          	add	a0,a0,-710 # 80022450 <ftable>
    8000471e:	ffffc097          	auipc	ra,0xffffc
    80004722:	606080e7          	jalr	1542(ra) # 80000d24 <release>
  }
}
    80004726:	70e2                	ld	ra,56(sp)
    80004728:	7442                	ld	s0,48(sp)
    8000472a:	74a2                	ld	s1,40(sp)
    8000472c:	7902                	ld	s2,32(sp)
    8000472e:	69e2                	ld	s3,24(sp)
    80004730:	6a42                	ld	s4,16(sp)
    80004732:	6aa2                	ld	s5,8(sp)
    80004734:	6121                	add	sp,sp,64
    80004736:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004738:	85d6                	mv	a1,s5
    8000473a:	8552                	mv	a0,s4
    8000473c:	00000097          	auipc	ra,0x0
    80004740:	372080e7          	jalr	882(ra) # 80004aae <pipeclose>
    80004744:	b7cd                	j	80004726 <fileclose+0xa8>

0000000080004746 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004746:	715d                	add	sp,sp,-80
    80004748:	e486                	sd	ra,72(sp)
    8000474a:	e0a2                	sd	s0,64(sp)
    8000474c:	fc26                	sd	s1,56(sp)
    8000474e:	f84a                	sd	s2,48(sp)
    80004750:	f44e                	sd	s3,40(sp)
    80004752:	0880                	add	s0,sp,80
    80004754:	84aa                	mv	s1,a0
    80004756:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004758:	ffffd097          	auipc	ra,0xffffd
    8000475c:	2e2080e7          	jalr	738(ra) # 80001a3a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004760:	409c                	lw	a5,0(s1)
    80004762:	37f9                	addw	a5,a5,-2
    80004764:	4705                	li	a4,1
    80004766:	04f76763          	bltu	a4,a5,800047b4 <filestat+0x6e>
    8000476a:	892a                	mv	s2,a0
    ilock(f->ip);
    8000476c:	6c88                	ld	a0,24(s1)
    8000476e:	fffff097          	auipc	ra,0xfffff
    80004772:	0a6080e7          	jalr	166(ra) # 80003814 <ilock>
    stati(f->ip, &st);
    80004776:	fb840593          	add	a1,s0,-72
    8000477a:	6c88                	ld	a0,24(s1)
    8000477c:	fffff097          	auipc	ra,0xfffff
    80004780:	322080e7          	jalr	802(ra) # 80003a9e <stati>
    iunlock(f->ip);
    80004784:	6c88                	ld	a0,24(s1)
    80004786:	fffff097          	auipc	ra,0xfffff
    8000478a:	150080e7          	jalr	336(ra) # 800038d6 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000478e:	46e1                	li	a3,24
    80004790:	fb840613          	add	a2,s0,-72
    80004794:	85ce                	mv	a1,s3
    80004796:	05093503          	ld	a0,80(s2)
    8000479a:	ffffd097          	auipc	ra,0xffffd
    8000479e:	f96080e7          	jalr	-106(ra) # 80001730 <copyout>
    800047a2:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800047a6:	60a6                	ld	ra,72(sp)
    800047a8:	6406                	ld	s0,64(sp)
    800047aa:	74e2                	ld	s1,56(sp)
    800047ac:	7942                	ld	s2,48(sp)
    800047ae:	79a2                	ld	s3,40(sp)
    800047b0:	6161                	add	sp,sp,80
    800047b2:	8082                	ret
  return -1;
    800047b4:	557d                	li	a0,-1
    800047b6:	bfc5                	j	800047a6 <filestat+0x60>

00000000800047b8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800047b8:	7179                	add	sp,sp,-48
    800047ba:	f406                	sd	ra,40(sp)
    800047bc:	f022                	sd	s0,32(sp)
    800047be:	ec26                	sd	s1,24(sp)
    800047c0:	e84a                	sd	s2,16(sp)
    800047c2:	e44e                	sd	s3,8(sp)
    800047c4:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800047c6:	00854783          	lbu	a5,8(a0)
    800047ca:	c3d5                	beqz	a5,8000486e <fileread+0xb6>
    800047cc:	84aa                	mv	s1,a0
    800047ce:	89ae                	mv	s3,a1
    800047d0:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800047d2:	411c                	lw	a5,0(a0)
    800047d4:	4705                	li	a4,1
    800047d6:	04e78963          	beq	a5,a4,80004828 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800047da:	470d                	li	a4,3
    800047dc:	04e78d63          	beq	a5,a4,80004836 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800047e0:	4709                	li	a4,2
    800047e2:	06e79e63          	bne	a5,a4,8000485e <fileread+0xa6>
    ilock(f->ip);
    800047e6:	6d08                	ld	a0,24(a0)
    800047e8:	fffff097          	auipc	ra,0xfffff
    800047ec:	02c080e7          	jalr	44(ra) # 80003814 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800047f0:	874a                	mv	a4,s2
    800047f2:	5094                	lw	a3,32(s1)
    800047f4:	864e                	mv	a2,s3
    800047f6:	4585                	li	a1,1
    800047f8:	6c88                	ld	a0,24(s1)
    800047fa:	fffff097          	auipc	ra,0xfffff
    800047fe:	2ce080e7          	jalr	718(ra) # 80003ac8 <readi>
    80004802:	892a                	mv	s2,a0
    80004804:	00a05563          	blez	a0,8000480e <fileread+0x56>
      f->off += r;
    80004808:	509c                	lw	a5,32(s1)
    8000480a:	9fa9                	addw	a5,a5,a0
    8000480c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000480e:	6c88                	ld	a0,24(s1)
    80004810:	fffff097          	auipc	ra,0xfffff
    80004814:	0c6080e7          	jalr	198(ra) # 800038d6 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004818:	854a                	mv	a0,s2
    8000481a:	70a2                	ld	ra,40(sp)
    8000481c:	7402                	ld	s0,32(sp)
    8000481e:	64e2                	ld	s1,24(sp)
    80004820:	6942                	ld	s2,16(sp)
    80004822:	69a2                	ld	s3,8(sp)
    80004824:	6145                	add	sp,sp,48
    80004826:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004828:	6908                	ld	a0,16(a0)
    8000482a:	00000097          	auipc	ra,0x0
    8000482e:	3ee080e7          	jalr	1006(ra) # 80004c18 <piperead>
    80004832:	892a                	mv	s2,a0
    80004834:	b7d5                	j	80004818 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004836:	02451783          	lh	a5,36(a0)
    8000483a:	03079693          	sll	a3,a5,0x30
    8000483e:	92c1                	srl	a3,a3,0x30
    80004840:	4725                	li	a4,9
    80004842:	02d76863          	bltu	a4,a3,80004872 <fileread+0xba>
    80004846:	0792                	sll	a5,a5,0x4
    80004848:	0001e717          	auipc	a4,0x1e
    8000484c:	b6870713          	add	a4,a4,-1176 # 800223b0 <devsw>
    80004850:	97ba                	add	a5,a5,a4
    80004852:	639c                	ld	a5,0(a5)
    80004854:	c38d                	beqz	a5,80004876 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004856:	4505                	li	a0,1
    80004858:	9782                	jalr	a5
    8000485a:	892a                	mv	s2,a0
    8000485c:	bf75                	j	80004818 <fileread+0x60>
    panic("fileread");
    8000485e:	00004517          	auipc	a0,0x4
    80004862:	e4a50513          	add	a0,a0,-438 # 800086a8 <syscalls+0x268>
    80004866:	ffffc097          	auipc	ra,0xffffc
    8000486a:	d7a080e7          	jalr	-646(ra) # 800005e0 <panic>
    return -1;
    8000486e:	597d                	li	s2,-1
    80004870:	b765                	j	80004818 <fileread+0x60>
      return -1;
    80004872:	597d                	li	s2,-1
    80004874:	b755                	j	80004818 <fileread+0x60>
    80004876:	597d                	li	s2,-1
    80004878:	b745                	j	80004818 <fileread+0x60>

000000008000487a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000487a:	00954783          	lbu	a5,9(a0)
    8000487e:	14078363          	beqz	a5,800049c4 <filewrite+0x14a>
{
    80004882:	715d                	add	sp,sp,-80
    80004884:	e486                	sd	ra,72(sp)
    80004886:	e0a2                	sd	s0,64(sp)
    80004888:	fc26                	sd	s1,56(sp)
    8000488a:	f84a                	sd	s2,48(sp)
    8000488c:	f44e                	sd	s3,40(sp)
    8000488e:	f052                	sd	s4,32(sp)
    80004890:	ec56                	sd	s5,24(sp)
    80004892:	e85a                	sd	s6,16(sp)
    80004894:	e45e                	sd	s7,8(sp)
    80004896:	e062                	sd	s8,0(sp)
    80004898:	0880                	add	s0,sp,80
    8000489a:	892a                	mv	s2,a0
    8000489c:	8b2e                	mv	s6,a1
    8000489e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800048a0:	411c                	lw	a5,0(a0)
    800048a2:	4705                	li	a4,1
    800048a4:	02e78263          	beq	a5,a4,800048c8 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800048a8:	470d                	li	a4,3
    800048aa:	02e78563          	beq	a5,a4,800048d4 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800048ae:	4709                	li	a4,2
    800048b0:	10e79263          	bne	a5,a4,800049b4 <filewrite+0x13a>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800048b4:	0ec05e63          	blez	a2,800049b0 <filewrite+0x136>
    int i = 0;
    800048b8:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800048ba:	6b85                	lui	s7,0x1
    800048bc:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800048c0:	6c05                	lui	s8,0x1
    800048c2:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800048c6:	a851                	j	8000495a <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    800048c8:	6908                	ld	a0,16(a0)
    800048ca:	00000097          	auipc	ra,0x0
    800048ce:	254080e7          	jalr	596(ra) # 80004b1e <pipewrite>
    800048d2:	a85d                	j	80004988 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800048d4:	02451783          	lh	a5,36(a0)
    800048d8:	03079693          	sll	a3,a5,0x30
    800048dc:	92c1                	srl	a3,a3,0x30
    800048de:	4725                	li	a4,9
    800048e0:	0ed76463          	bltu	a4,a3,800049c8 <filewrite+0x14e>
    800048e4:	0792                	sll	a5,a5,0x4
    800048e6:	0001e717          	auipc	a4,0x1e
    800048ea:	aca70713          	add	a4,a4,-1334 # 800223b0 <devsw>
    800048ee:	97ba                	add	a5,a5,a4
    800048f0:	679c                	ld	a5,8(a5)
    800048f2:	cfe9                	beqz	a5,800049cc <filewrite+0x152>
    ret = devsw[f->major].write(1, addr, n);
    800048f4:	4505                	li	a0,1
    800048f6:	9782                	jalr	a5
    800048f8:	a841                	j	80004988 <filewrite+0x10e>
      if(n1 > max)
    800048fa:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800048fe:	00000097          	auipc	ra,0x0
    80004902:	8b6080e7          	jalr	-1866(ra) # 800041b4 <begin_op>
      ilock(f->ip);
    80004906:	01893503          	ld	a0,24(s2)
    8000490a:	fffff097          	auipc	ra,0xfffff
    8000490e:	f0a080e7          	jalr	-246(ra) # 80003814 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004912:	8756                	mv	a4,s5
    80004914:	02092683          	lw	a3,32(s2)
    80004918:	01698633          	add	a2,s3,s6
    8000491c:	4585                	li	a1,1
    8000491e:	01893503          	ld	a0,24(s2)
    80004922:	fffff097          	auipc	ra,0xfffff
    80004926:	29c080e7          	jalr	668(ra) # 80003bbe <writei>
    8000492a:	84aa                	mv	s1,a0
    8000492c:	02a05f63          	blez	a0,8000496a <filewrite+0xf0>
        f->off += r;
    80004930:	02092783          	lw	a5,32(s2)
    80004934:	9fa9                	addw	a5,a5,a0
    80004936:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000493a:	01893503          	ld	a0,24(s2)
    8000493e:	fffff097          	auipc	ra,0xfffff
    80004942:	f98080e7          	jalr	-104(ra) # 800038d6 <iunlock>
      end_op();
    80004946:	00000097          	auipc	ra,0x0
    8000494a:	8e8080e7          	jalr	-1816(ra) # 8000422e <end_op>

      if(r < 0)
        break;
      if(r != n1)
    8000494e:	049a9963          	bne	s5,s1,800049a0 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    80004952:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004956:	0349d663          	bge	s3,s4,80004982 <filewrite+0x108>
      int n1 = n - i;
    8000495a:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000495e:	0004879b          	sext.w	a5,s1
    80004962:	f8fbdce3          	bge	s7,a5,800048fa <filewrite+0x80>
    80004966:	84e2                	mv	s1,s8
    80004968:	bf49                	j	800048fa <filewrite+0x80>
      iunlock(f->ip);
    8000496a:	01893503          	ld	a0,24(s2)
    8000496e:	fffff097          	auipc	ra,0xfffff
    80004972:	f68080e7          	jalr	-152(ra) # 800038d6 <iunlock>
      end_op();
    80004976:	00000097          	auipc	ra,0x0
    8000497a:	8b8080e7          	jalr	-1864(ra) # 8000422e <end_op>
      if(r < 0)
    8000497e:	fc04d8e3          	bgez	s1,8000494e <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004982:	053a1763          	bne	s4,s3,800049d0 <filewrite+0x156>
    80004986:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004988:	60a6                	ld	ra,72(sp)
    8000498a:	6406                	ld	s0,64(sp)
    8000498c:	74e2                	ld	s1,56(sp)
    8000498e:	7942                	ld	s2,48(sp)
    80004990:	79a2                	ld	s3,40(sp)
    80004992:	7a02                	ld	s4,32(sp)
    80004994:	6ae2                	ld	s5,24(sp)
    80004996:	6b42                	ld	s6,16(sp)
    80004998:	6ba2                	ld	s7,8(sp)
    8000499a:	6c02                	ld	s8,0(sp)
    8000499c:	6161                	add	sp,sp,80
    8000499e:	8082                	ret
        panic("short filewrite");
    800049a0:	00004517          	auipc	a0,0x4
    800049a4:	d1850513          	add	a0,a0,-744 # 800086b8 <syscalls+0x278>
    800049a8:	ffffc097          	auipc	ra,0xffffc
    800049ac:	c38080e7          	jalr	-968(ra) # 800005e0 <panic>
    int i = 0;
    800049b0:	4981                	li	s3,0
    800049b2:	bfc1                	j	80004982 <filewrite+0x108>
    panic("filewrite");
    800049b4:	00004517          	auipc	a0,0x4
    800049b8:	d1450513          	add	a0,a0,-748 # 800086c8 <syscalls+0x288>
    800049bc:	ffffc097          	auipc	ra,0xffffc
    800049c0:	c24080e7          	jalr	-988(ra) # 800005e0 <panic>
    return -1;
    800049c4:	557d                	li	a0,-1
}
    800049c6:	8082                	ret
      return -1;
    800049c8:	557d                	li	a0,-1
    800049ca:	bf7d                	j	80004988 <filewrite+0x10e>
    800049cc:	557d                	li	a0,-1
    800049ce:	bf6d                	j	80004988 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    800049d0:	557d                	li	a0,-1
    800049d2:	bf5d                	j	80004988 <filewrite+0x10e>

00000000800049d4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800049d4:	7179                	add	sp,sp,-48
    800049d6:	f406                	sd	ra,40(sp)
    800049d8:	f022                	sd	s0,32(sp)
    800049da:	ec26                	sd	s1,24(sp)
    800049dc:	e84a                	sd	s2,16(sp)
    800049de:	e44e                	sd	s3,8(sp)
    800049e0:	e052                	sd	s4,0(sp)
    800049e2:	1800                	add	s0,sp,48
    800049e4:	84aa                	mv	s1,a0
    800049e6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800049e8:	0005b023          	sd	zero,0(a1)
    800049ec:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800049f0:	00000097          	auipc	ra,0x0
    800049f4:	bd2080e7          	jalr	-1070(ra) # 800045c2 <filealloc>
    800049f8:	e088                	sd	a0,0(s1)
    800049fa:	c551                	beqz	a0,80004a86 <pipealloc+0xb2>
    800049fc:	00000097          	auipc	ra,0x0
    80004a00:	bc6080e7          	jalr	-1082(ra) # 800045c2 <filealloc>
    80004a04:	00aa3023          	sd	a0,0(s4)
    80004a08:	c92d                	beqz	a0,80004a7a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004a0a:	ffffc097          	auipc	ra,0xffffc
    80004a0e:	176080e7          	jalr	374(ra) # 80000b80 <kalloc>
    80004a12:	892a                	mv	s2,a0
    80004a14:	c125                	beqz	a0,80004a74 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004a16:	4985                	li	s3,1
    80004a18:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004a1c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004a20:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004a24:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004a28:	00004597          	auipc	a1,0x4
    80004a2c:	cb058593          	add	a1,a1,-848 # 800086d8 <syscalls+0x298>
    80004a30:	ffffc097          	auipc	ra,0xffffc
    80004a34:	1b0080e7          	jalr	432(ra) # 80000be0 <initlock>
  (*f0)->type = FD_PIPE;
    80004a38:	609c                	ld	a5,0(s1)
    80004a3a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004a3e:	609c                	ld	a5,0(s1)
    80004a40:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004a44:	609c                	ld	a5,0(s1)
    80004a46:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004a4a:	609c                	ld	a5,0(s1)
    80004a4c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004a50:	000a3783          	ld	a5,0(s4)
    80004a54:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004a58:	000a3783          	ld	a5,0(s4)
    80004a5c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004a60:	000a3783          	ld	a5,0(s4)
    80004a64:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004a68:	000a3783          	ld	a5,0(s4)
    80004a6c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004a70:	4501                	li	a0,0
    80004a72:	a025                	j	80004a9a <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004a74:	6088                	ld	a0,0(s1)
    80004a76:	e501                	bnez	a0,80004a7e <pipealloc+0xaa>
    80004a78:	a039                	j	80004a86 <pipealloc+0xb2>
    80004a7a:	6088                	ld	a0,0(s1)
    80004a7c:	c51d                	beqz	a0,80004aaa <pipealloc+0xd6>
    fileclose(*f0);
    80004a7e:	00000097          	auipc	ra,0x0
    80004a82:	c00080e7          	jalr	-1024(ra) # 8000467e <fileclose>
  if(*f1)
    80004a86:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004a8a:	557d                	li	a0,-1
  if(*f1)
    80004a8c:	c799                	beqz	a5,80004a9a <pipealloc+0xc6>
    fileclose(*f1);
    80004a8e:	853e                	mv	a0,a5
    80004a90:	00000097          	auipc	ra,0x0
    80004a94:	bee080e7          	jalr	-1042(ra) # 8000467e <fileclose>
  return -1;
    80004a98:	557d                	li	a0,-1
}
    80004a9a:	70a2                	ld	ra,40(sp)
    80004a9c:	7402                	ld	s0,32(sp)
    80004a9e:	64e2                	ld	s1,24(sp)
    80004aa0:	6942                	ld	s2,16(sp)
    80004aa2:	69a2                	ld	s3,8(sp)
    80004aa4:	6a02                	ld	s4,0(sp)
    80004aa6:	6145                	add	sp,sp,48
    80004aa8:	8082                	ret
  return -1;
    80004aaa:	557d                	li	a0,-1
    80004aac:	b7fd                	j	80004a9a <pipealloc+0xc6>

0000000080004aae <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004aae:	1101                	add	sp,sp,-32
    80004ab0:	ec06                	sd	ra,24(sp)
    80004ab2:	e822                	sd	s0,16(sp)
    80004ab4:	e426                	sd	s1,8(sp)
    80004ab6:	e04a                	sd	s2,0(sp)
    80004ab8:	1000                	add	s0,sp,32
    80004aba:	84aa                	mv	s1,a0
    80004abc:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004abe:	ffffc097          	auipc	ra,0xffffc
    80004ac2:	1b2080e7          	jalr	434(ra) # 80000c70 <acquire>
  if(writable){
    80004ac6:	02090d63          	beqz	s2,80004b00 <pipeclose+0x52>
    pi->writeopen = 0;
    80004aca:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004ace:	21848513          	add	a0,s1,536
    80004ad2:	ffffe097          	auipc	ra,0xffffe
    80004ad6:	948080e7          	jalr	-1720(ra) # 8000241a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004ada:	2204b783          	ld	a5,544(s1)
    80004ade:	eb95                	bnez	a5,80004b12 <pipeclose+0x64>
    release(&pi->lock);
    80004ae0:	8526                	mv	a0,s1
    80004ae2:	ffffc097          	auipc	ra,0xffffc
    80004ae6:	242080e7          	jalr	578(ra) # 80000d24 <release>
    kfree((char*)pi);
    80004aea:	8526                	mv	a0,s1
    80004aec:	ffffc097          	auipc	ra,0xffffc
    80004af0:	f96080e7          	jalr	-106(ra) # 80000a82 <kfree>
  } else
    release(&pi->lock);
}
    80004af4:	60e2                	ld	ra,24(sp)
    80004af6:	6442                	ld	s0,16(sp)
    80004af8:	64a2                	ld	s1,8(sp)
    80004afa:	6902                	ld	s2,0(sp)
    80004afc:	6105                	add	sp,sp,32
    80004afe:	8082                	ret
    pi->readopen = 0;
    80004b00:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004b04:	21c48513          	add	a0,s1,540
    80004b08:	ffffe097          	auipc	ra,0xffffe
    80004b0c:	912080e7          	jalr	-1774(ra) # 8000241a <wakeup>
    80004b10:	b7e9                	j	80004ada <pipeclose+0x2c>
    release(&pi->lock);
    80004b12:	8526                	mv	a0,s1
    80004b14:	ffffc097          	auipc	ra,0xffffc
    80004b18:	210080e7          	jalr	528(ra) # 80000d24 <release>
}
    80004b1c:	bfe1                	j	80004af4 <pipeclose+0x46>

0000000080004b1e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004b1e:	711d                	add	sp,sp,-96
    80004b20:	ec86                	sd	ra,88(sp)
    80004b22:	e8a2                	sd	s0,80(sp)
    80004b24:	e4a6                	sd	s1,72(sp)
    80004b26:	e0ca                	sd	s2,64(sp)
    80004b28:	fc4e                	sd	s3,56(sp)
    80004b2a:	f852                	sd	s4,48(sp)
    80004b2c:	f456                	sd	s5,40(sp)
    80004b2e:	f05a                	sd	s6,32(sp)
    80004b30:	ec5e                	sd	s7,24(sp)
    80004b32:	1080                	add	s0,sp,96
    80004b34:	84aa                	mv	s1,a0
    80004b36:	8b2e                	mv	s6,a1
    80004b38:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004b3a:	ffffd097          	auipc	ra,0xffffd
    80004b3e:	f00080e7          	jalr	-256(ra) # 80001a3a <myproc>
    80004b42:	892a                	mv	s2,a0

  acquire(&pi->lock);
    80004b44:	8526                	mv	a0,s1
    80004b46:	ffffc097          	auipc	ra,0xffffc
    80004b4a:	12a080e7          	jalr	298(ra) # 80000c70 <acquire>
  for(i = 0; i < n; i++){
    80004b4e:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004b50:	21848a13          	add	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004b54:	21c48993          	add	s3,s1,540
  for(i = 0; i < n; i++){
    80004b58:	09505263          	blez	s5,80004bdc <pipewrite+0xbe>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004b5c:	2184a783          	lw	a5,536(s1)
    80004b60:	21c4a703          	lw	a4,540(s1)
    80004b64:	2007879b          	addw	a5,a5,512
    80004b68:	02f71b63          	bne	a4,a5,80004b9e <pipewrite+0x80>
      if(pi->readopen == 0 || pr->killed){
    80004b6c:	2204a783          	lw	a5,544(s1)
    80004b70:	c3d1                	beqz	a5,80004bf4 <pipewrite+0xd6>
    80004b72:	03092783          	lw	a5,48(s2)
    80004b76:	efbd                	bnez	a5,80004bf4 <pipewrite+0xd6>
      wakeup(&pi->nread);
    80004b78:	8552                	mv	a0,s4
    80004b7a:	ffffe097          	auipc	ra,0xffffe
    80004b7e:	8a0080e7          	jalr	-1888(ra) # 8000241a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004b82:	85a6                	mv	a1,s1
    80004b84:	854e                	mv	a0,s3
    80004b86:	ffffd097          	auipc	ra,0xffffd
    80004b8a:	714080e7          	jalr	1812(ra) # 8000229a <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004b8e:	2184a783          	lw	a5,536(s1)
    80004b92:	21c4a703          	lw	a4,540(s1)
    80004b96:	2007879b          	addw	a5,a5,512
    80004b9a:	fcf709e3          	beq	a4,a5,80004b6c <pipewrite+0x4e>
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004b9e:	4685                	li	a3,1
    80004ba0:	865a                	mv	a2,s6
    80004ba2:	faf40593          	add	a1,s0,-81
    80004ba6:	05093503          	ld	a0,80(s2)
    80004baa:	ffffd097          	auipc	ra,0xffffd
    80004bae:	c12080e7          	jalr	-1006(ra) # 800017bc <copyin>
    80004bb2:	57fd                	li	a5,-1
    80004bb4:	02f50463          	beq	a0,a5,80004bdc <pipewrite+0xbe>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004bb8:	21c4a783          	lw	a5,540(s1)
    80004bbc:	0017871b          	addw	a4,a5,1
    80004bc0:	20e4ae23          	sw	a4,540(s1)
    80004bc4:	1ff7f793          	and	a5,a5,511
    80004bc8:	97a6                	add	a5,a5,s1
    80004bca:	faf44703          	lbu	a4,-81(s0)
    80004bce:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004bd2:	2b85                	addw	s7,s7,1
    80004bd4:	0b05                	add	s6,s6,1
    80004bd6:	f97a93e3          	bne	s5,s7,80004b5c <pipewrite+0x3e>
    80004bda:	8bd6                	mv	s7,s5
  }
  wakeup(&pi->nread);
    80004bdc:	21848513          	add	a0,s1,536
    80004be0:	ffffe097          	auipc	ra,0xffffe
    80004be4:	83a080e7          	jalr	-1990(ra) # 8000241a <wakeup>
  release(&pi->lock);
    80004be8:	8526                	mv	a0,s1
    80004bea:	ffffc097          	auipc	ra,0xffffc
    80004bee:	13a080e7          	jalr	314(ra) # 80000d24 <release>
  return i;
    80004bf2:	a039                	j	80004c00 <pipewrite+0xe2>
        release(&pi->lock);
    80004bf4:	8526                	mv	a0,s1
    80004bf6:	ffffc097          	auipc	ra,0xffffc
    80004bfa:	12e080e7          	jalr	302(ra) # 80000d24 <release>
        return -1;
    80004bfe:	5bfd                	li	s7,-1
}
    80004c00:	855e                	mv	a0,s7
    80004c02:	60e6                	ld	ra,88(sp)
    80004c04:	6446                	ld	s0,80(sp)
    80004c06:	64a6                	ld	s1,72(sp)
    80004c08:	6906                	ld	s2,64(sp)
    80004c0a:	79e2                	ld	s3,56(sp)
    80004c0c:	7a42                	ld	s4,48(sp)
    80004c0e:	7aa2                	ld	s5,40(sp)
    80004c10:	7b02                	ld	s6,32(sp)
    80004c12:	6be2                	ld	s7,24(sp)
    80004c14:	6125                	add	sp,sp,96
    80004c16:	8082                	ret

0000000080004c18 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004c18:	715d                	add	sp,sp,-80
    80004c1a:	e486                	sd	ra,72(sp)
    80004c1c:	e0a2                	sd	s0,64(sp)
    80004c1e:	fc26                	sd	s1,56(sp)
    80004c20:	f84a                	sd	s2,48(sp)
    80004c22:	f44e                	sd	s3,40(sp)
    80004c24:	f052                	sd	s4,32(sp)
    80004c26:	ec56                	sd	s5,24(sp)
    80004c28:	e85a                	sd	s6,16(sp)
    80004c2a:	0880                	add	s0,sp,80
    80004c2c:	84aa                	mv	s1,a0
    80004c2e:	892e                	mv	s2,a1
    80004c30:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004c32:	ffffd097          	auipc	ra,0xffffd
    80004c36:	e08080e7          	jalr	-504(ra) # 80001a3a <myproc>
    80004c3a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004c3c:	8526                	mv	a0,s1
    80004c3e:	ffffc097          	auipc	ra,0xffffc
    80004c42:	032080e7          	jalr	50(ra) # 80000c70 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c46:	2184a703          	lw	a4,536(s1)
    80004c4a:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004c4e:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c52:	02f71463          	bne	a4,a5,80004c7a <piperead+0x62>
    80004c56:	2244a783          	lw	a5,548(s1)
    80004c5a:	c385                	beqz	a5,80004c7a <piperead+0x62>
    if(pr->killed){
    80004c5c:	030a2783          	lw	a5,48(s4)
    80004c60:	ebc9                	bnez	a5,80004cf2 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004c62:	85a6                	mv	a1,s1
    80004c64:	854e                	mv	a0,s3
    80004c66:	ffffd097          	auipc	ra,0xffffd
    80004c6a:	634080e7          	jalr	1588(ra) # 8000229a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c6e:	2184a703          	lw	a4,536(s1)
    80004c72:	21c4a783          	lw	a5,540(s1)
    80004c76:	fef700e3          	beq	a4,a5,80004c56 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c7a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004c7c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c7e:	05505463          	blez	s5,80004cc6 <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004c82:	2184a783          	lw	a5,536(s1)
    80004c86:	21c4a703          	lw	a4,540(s1)
    80004c8a:	02f70e63          	beq	a4,a5,80004cc6 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004c8e:	0017871b          	addw	a4,a5,1
    80004c92:	20e4ac23          	sw	a4,536(s1)
    80004c96:	1ff7f793          	and	a5,a5,511
    80004c9a:	97a6                	add	a5,a5,s1
    80004c9c:	0187c783          	lbu	a5,24(a5)
    80004ca0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004ca4:	4685                	li	a3,1
    80004ca6:	fbf40613          	add	a2,s0,-65
    80004caa:	85ca                	mv	a1,s2
    80004cac:	050a3503          	ld	a0,80(s4)
    80004cb0:	ffffd097          	auipc	ra,0xffffd
    80004cb4:	a80080e7          	jalr	-1408(ra) # 80001730 <copyout>
    80004cb8:	01650763          	beq	a0,s6,80004cc6 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004cbc:	2985                	addw	s3,s3,1
    80004cbe:	0905                	add	s2,s2,1
    80004cc0:	fd3a91e3          	bne	s5,s3,80004c82 <piperead+0x6a>
    80004cc4:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004cc6:	21c48513          	add	a0,s1,540
    80004cca:	ffffd097          	auipc	ra,0xffffd
    80004cce:	750080e7          	jalr	1872(ra) # 8000241a <wakeup>
  release(&pi->lock);
    80004cd2:	8526                	mv	a0,s1
    80004cd4:	ffffc097          	auipc	ra,0xffffc
    80004cd8:	050080e7          	jalr	80(ra) # 80000d24 <release>
  return i;
}
    80004cdc:	854e                	mv	a0,s3
    80004cde:	60a6                	ld	ra,72(sp)
    80004ce0:	6406                	ld	s0,64(sp)
    80004ce2:	74e2                	ld	s1,56(sp)
    80004ce4:	7942                	ld	s2,48(sp)
    80004ce6:	79a2                	ld	s3,40(sp)
    80004ce8:	7a02                	ld	s4,32(sp)
    80004cea:	6ae2                	ld	s5,24(sp)
    80004cec:	6b42                	ld	s6,16(sp)
    80004cee:	6161                	add	sp,sp,80
    80004cf0:	8082                	ret
      release(&pi->lock);
    80004cf2:	8526                	mv	a0,s1
    80004cf4:	ffffc097          	auipc	ra,0xffffc
    80004cf8:	030080e7          	jalr	48(ra) # 80000d24 <release>
      return -1;
    80004cfc:	59fd                	li	s3,-1
    80004cfe:	bff9                	j	80004cdc <piperead+0xc4>

0000000080004d00 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004d00:	df010113          	add	sp,sp,-528
    80004d04:	20113423          	sd	ra,520(sp)
    80004d08:	20813023          	sd	s0,512(sp)
    80004d0c:	ffa6                	sd	s1,504(sp)
    80004d0e:	fbca                	sd	s2,496(sp)
    80004d10:	f7ce                	sd	s3,488(sp)
    80004d12:	f3d2                	sd	s4,480(sp)
    80004d14:	efd6                	sd	s5,472(sp)
    80004d16:	ebda                	sd	s6,464(sp)
    80004d18:	e7de                	sd	s7,456(sp)
    80004d1a:	e3e2                	sd	s8,448(sp)
    80004d1c:	ff66                	sd	s9,440(sp)
    80004d1e:	fb6a                	sd	s10,432(sp)
    80004d20:	f76e                	sd	s11,424(sp)
    80004d22:	0c00                	add	s0,sp,528
    80004d24:	892a                	mv	s2,a0
    80004d26:	dea43c23          	sd	a0,-520(s0)
    80004d2a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004d2e:	ffffd097          	auipc	ra,0xffffd
    80004d32:	d0c080e7          	jalr	-756(ra) # 80001a3a <myproc>
    80004d36:	84aa                	mv	s1,a0

  begin_op();
    80004d38:	fffff097          	auipc	ra,0xfffff
    80004d3c:	47c080e7          	jalr	1148(ra) # 800041b4 <begin_op>

  if((ip = namei(path)) == 0){
    80004d40:	854a                	mv	a0,s2
    80004d42:	fffff097          	auipc	ra,0xfffff
    80004d46:	282080e7          	jalr	642(ra) # 80003fc4 <namei>
    80004d4a:	c92d                	beqz	a0,80004dbc <exec+0xbc>
    80004d4c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004d4e:	fffff097          	auipc	ra,0xfffff
    80004d52:	ac6080e7          	jalr	-1338(ra) # 80003814 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004d56:	04000713          	li	a4,64
    80004d5a:	4681                	li	a3,0
    80004d5c:	e4840613          	add	a2,s0,-440
    80004d60:	4581                	li	a1,0
    80004d62:	8552                	mv	a0,s4
    80004d64:	fffff097          	auipc	ra,0xfffff
    80004d68:	d64080e7          	jalr	-668(ra) # 80003ac8 <readi>
    80004d6c:	04000793          	li	a5,64
    80004d70:	00f51a63          	bne	a0,a5,80004d84 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004d74:	e4842703          	lw	a4,-440(s0)
    80004d78:	464c47b7          	lui	a5,0x464c4
    80004d7c:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004d80:	04f70463          	beq	a4,a5,80004dc8 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004d84:	8552                	mv	a0,s4
    80004d86:	fffff097          	auipc	ra,0xfffff
    80004d8a:	cf0080e7          	jalr	-784(ra) # 80003a76 <iunlockput>
    end_op();
    80004d8e:	fffff097          	auipc	ra,0xfffff
    80004d92:	4a0080e7          	jalr	1184(ra) # 8000422e <end_op>
  }
  return -1;
    80004d96:	557d                	li	a0,-1
}
    80004d98:	20813083          	ld	ra,520(sp)
    80004d9c:	20013403          	ld	s0,512(sp)
    80004da0:	74fe                	ld	s1,504(sp)
    80004da2:	795e                	ld	s2,496(sp)
    80004da4:	79be                	ld	s3,488(sp)
    80004da6:	7a1e                	ld	s4,480(sp)
    80004da8:	6afe                	ld	s5,472(sp)
    80004daa:	6b5e                	ld	s6,464(sp)
    80004dac:	6bbe                	ld	s7,456(sp)
    80004dae:	6c1e                	ld	s8,448(sp)
    80004db0:	7cfa                	ld	s9,440(sp)
    80004db2:	7d5a                	ld	s10,432(sp)
    80004db4:	7dba                	ld	s11,424(sp)
    80004db6:	21010113          	add	sp,sp,528
    80004dba:	8082                	ret
    end_op();
    80004dbc:	fffff097          	auipc	ra,0xfffff
    80004dc0:	472080e7          	jalr	1138(ra) # 8000422e <end_op>
    return -1;
    80004dc4:	557d                	li	a0,-1
    80004dc6:	bfc9                	j	80004d98 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004dc8:	8526                	mv	a0,s1
    80004dca:	ffffd097          	auipc	ra,0xffffd
    80004dce:	d34080e7          	jalr	-716(ra) # 80001afe <proc_pagetable>
    80004dd2:	8b2a                	mv	s6,a0
    80004dd4:	d945                	beqz	a0,80004d84 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004dd6:	e6842d03          	lw	s10,-408(s0)
    80004dda:	e8045783          	lhu	a5,-384(s0)
    80004dde:	cfe5                	beqz	a5,80004ed6 <exec+0x1d6>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004de0:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004de2:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004de4:	6c85                	lui	s9,0x1
    80004de6:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004dea:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004dee:	6a85                	lui	s5,0x1
    80004df0:	a0b5                	j	80004e5c <exec+0x15c>
      panic("loadseg: address should exist");
    80004df2:	00004517          	auipc	a0,0x4
    80004df6:	8ee50513          	add	a0,a0,-1810 # 800086e0 <syscalls+0x2a0>
    80004dfa:	ffffb097          	auipc	ra,0xffffb
    80004dfe:	7e6080e7          	jalr	2022(ra) # 800005e0 <panic>
    if(sz - i < PGSIZE)
    80004e02:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004e04:	8726                	mv	a4,s1
    80004e06:	012c06bb          	addw	a3,s8,s2
    80004e0a:	4581                	li	a1,0
    80004e0c:	8552                	mv	a0,s4
    80004e0e:	fffff097          	auipc	ra,0xfffff
    80004e12:	cba080e7          	jalr	-838(ra) # 80003ac8 <readi>
    80004e16:	2501                	sext.w	a0,a0
    80004e18:	24a49063          	bne	s1,a0,80005058 <exec+0x358>
  for(i = 0; i < sz; i += PGSIZE){
    80004e1c:	012a893b          	addw	s2,s5,s2
    80004e20:	03397563          	bgeu	s2,s3,80004e4a <exec+0x14a>
    pa = walkaddr(pagetable, va + i);
    80004e24:	02091593          	sll	a1,s2,0x20
    80004e28:	9181                	srl	a1,a1,0x20
    80004e2a:	95de                	add	a1,a1,s7
    80004e2c:	855a                	mv	a0,s6
    80004e2e:	ffffc097          	auipc	ra,0xffffc
    80004e32:	2ca080e7          	jalr	714(ra) # 800010f8 <walkaddr>
    80004e36:	862a                	mv	a2,a0
    if(pa == 0)
    80004e38:	dd4d                	beqz	a0,80004df2 <exec+0xf2>
    if(sz - i < PGSIZE)
    80004e3a:	412984bb          	subw	s1,s3,s2
    80004e3e:	0004879b          	sext.w	a5,s1
    80004e42:	fcfcf0e3          	bgeu	s9,a5,80004e02 <exec+0x102>
    80004e46:	84d6                	mv	s1,s5
    80004e48:	bf6d                	j	80004e02 <exec+0x102>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004e4a:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e4e:	2d85                	addw	s11,s11,1
    80004e50:	038d0d1b          	addw	s10,s10,56
    80004e54:	e8045783          	lhu	a5,-384(s0)
    80004e58:	08fdd063          	bge	s11,a5,80004ed8 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004e5c:	2d01                	sext.w	s10,s10
    80004e5e:	03800713          	li	a4,56
    80004e62:	86ea                	mv	a3,s10
    80004e64:	e1040613          	add	a2,s0,-496
    80004e68:	4581                	li	a1,0
    80004e6a:	8552                	mv	a0,s4
    80004e6c:	fffff097          	auipc	ra,0xfffff
    80004e70:	c5c080e7          	jalr	-932(ra) # 80003ac8 <readi>
    80004e74:	03800793          	li	a5,56
    80004e78:	1cf51e63          	bne	a0,a5,80005054 <exec+0x354>
    if(ph.type != ELF_PROG_LOAD)
    80004e7c:	e1042783          	lw	a5,-496(s0)
    80004e80:	4705                	li	a4,1
    80004e82:	fce796e3          	bne	a5,a4,80004e4e <exec+0x14e>
    if(ph.memsz < ph.filesz)
    80004e86:	e3843603          	ld	a2,-456(s0)
    80004e8a:	e3043783          	ld	a5,-464(s0)
    80004e8e:	1ef66063          	bltu	a2,a5,8000506e <exec+0x36e>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004e92:	e2043783          	ld	a5,-480(s0)
    80004e96:	963e                	add	a2,a2,a5
    80004e98:	1cf66e63          	bltu	a2,a5,80005074 <exec+0x374>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004e9c:	85a6                	mv	a1,s1
    80004e9e:	855a                	mv	a0,s6
    80004ea0:	ffffc097          	auipc	ra,0xffffc
    80004ea4:	63c080e7          	jalr	1596(ra) # 800014dc <uvmalloc>
    80004ea8:	e0a43423          	sd	a0,-504(s0)
    80004eac:	1c050763          	beqz	a0,8000507a <exec+0x37a>
    if(ph.vaddr % PGSIZE != 0)
    80004eb0:	e2043b83          	ld	s7,-480(s0)
    80004eb4:	df043783          	ld	a5,-528(s0)
    80004eb8:	00fbf7b3          	and	a5,s7,a5
    80004ebc:	18079e63          	bnez	a5,80005058 <exec+0x358>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004ec0:	e1842c03          	lw	s8,-488(s0)
    80004ec4:	e3042983          	lw	s3,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004ec8:	00098463          	beqz	s3,80004ed0 <exec+0x1d0>
    80004ecc:	4901                	li	s2,0
    80004ece:	bf99                	j	80004e24 <exec+0x124>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004ed0:	e0843483          	ld	s1,-504(s0)
    80004ed4:	bfad                	j	80004e4e <exec+0x14e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004ed6:	4481                	li	s1,0
  iunlockput(ip);
    80004ed8:	8552                	mv	a0,s4
    80004eda:	fffff097          	auipc	ra,0xfffff
    80004ede:	b9c080e7          	jalr	-1124(ra) # 80003a76 <iunlockput>
  end_op();
    80004ee2:	fffff097          	auipc	ra,0xfffff
    80004ee6:	34c080e7          	jalr	844(ra) # 8000422e <end_op>
  p = myproc();
    80004eea:	ffffd097          	auipc	ra,0xffffd
    80004eee:	b50080e7          	jalr	-1200(ra) # 80001a3a <myproc>
    80004ef2:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004ef4:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004ef8:	6985                	lui	s3,0x1
    80004efa:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004efc:	99a6                	add	s3,s3,s1
    80004efe:	77fd                	lui	a5,0xfffff
    80004f00:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004f04:	6609                	lui	a2,0x2
    80004f06:	964e                	add	a2,a2,s3
    80004f08:	85ce                	mv	a1,s3
    80004f0a:	855a                	mv	a0,s6
    80004f0c:	ffffc097          	auipc	ra,0xffffc
    80004f10:	5d0080e7          	jalr	1488(ra) # 800014dc <uvmalloc>
    80004f14:	892a                	mv	s2,a0
    80004f16:	e0a43423          	sd	a0,-504(s0)
    80004f1a:	e509                	bnez	a0,80004f24 <exec+0x224>
  if(pagetable)
    80004f1c:	e1343423          	sd	s3,-504(s0)
    80004f20:	4a01                	li	s4,0
    80004f22:	aa1d                	j	80005058 <exec+0x358>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004f24:	75f9                	lui	a1,0xffffe
    80004f26:	95aa                	add	a1,a1,a0
    80004f28:	855a                	mv	a0,s6
    80004f2a:	ffffc097          	auipc	ra,0xffffc
    80004f2e:	7d4080e7          	jalr	2004(ra) # 800016fe <uvmclear>
  stackbase = sp - PGSIZE;
    80004f32:	7bfd                	lui	s7,0xfffff
    80004f34:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004f36:	e0043783          	ld	a5,-512(s0)
    80004f3a:	6388                	ld	a0,0(a5)
    80004f3c:	c52d                	beqz	a0,80004fa6 <exec+0x2a6>
    80004f3e:	e8840993          	add	s3,s0,-376
    80004f42:	f8840c13          	add	s8,s0,-120
    80004f46:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004f48:	ffffc097          	auipc	ra,0xffffc
    80004f4c:	fa6080e7          	jalr	-90(ra) # 80000eee <strlen>
    80004f50:	0015079b          	addw	a5,a0,1
    80004f54:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004f58:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80004f5c:	13796263          	bltu	s2,s7,80005080 <exec+0x380>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004f60:	e0043d03          	ld	s10,-512(s0)
    80004f64:	000d3a03          	ld	s4,0(s10)
    80004f68:	8552                	mv	a0,s4
    80004f6a:	ffffc097          	auipc	ra,0xffffc
    80004f6e:	f84080e7          	jalr	-124(ra) # 80000eee <strlen>
    80004f72:	0015069b          	addw	a3,a0,1
    80004f76:	8652                	mv	a2,s4
    80004f78:	85ca                	mv	a1,s2
    80004f7a:	855a                	mv	a0,s6
    80004f7c:	ffffc097          	auipc	ra,0xffffc
    80004f80:	7b4080e7          	jalr	1972(ra) # 80001730 <copyout>
    80004f84:	10054063          	bltz	a0,80005084 <exec+0x384>
    ustack[argc] = sp;
    80004f88:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004f8c:	0485                	add	s1,s1,1
    80004f8e:	008d0793          	add	a5,s10,8
    80004f92:	e0f43023          	sd	a5,-512(s0)
    80004f96:	008d3503          	ld	a0,8(s10)
    80004f9a:	c909                	beqz	a0,80004fac <exec+0x2ac>
    if(argc >= MAXARG)
    80004f9c:	09a1                	add	s3,s3,8
    80004f9e:	fb8995e3          	bne	s3,s8,80004f48 <exec+0x248>
  ip = 0;
    80004fa2:	4a01                	li	s4,0
    80004fa4:	a855                	j	80005058 <exec+0x358>
  sp = sz;
    80004fa6:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004faa:	4481                	li	s1,0
  ustack[argc] = 0;
    80004fac:	00349793          	sll	a5,s1,0x3
    80004fb0:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd7f90>
    80004fb4:	97a2                	add	a5,a5,s0
    80004fb6:	ee07bc23          	sd	zero,-264(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004fba:	00148693          	add	a3,s1,1
    80004fbe:	068e                	sll	a3,a3,0x3
    80004fc0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004fc4:	ff097913          	and	s2,s2,-16
  sz = sz1;
    80004fc8:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004fcc:	f57968e3          	bltu	s2,s7,80004f1c <exec+0x21c>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004fd0:	e8840613          	add	a2,s0,-376
    80004fd4:	85ca                	mv	a1,s2
    80004fd6:	855a                	mv	a0,s6
    80004fd8:	ffffc097          	auipc	ra,0xffffc
    80004fdc:	758080e7          	jalr	1880(ra) # 80001730 <copyout>
    80004fe0:	0a054463          	bltz	a0,80005088 <exec+0x388>
  p->trapframe->a1 = sp;
    80004fe4:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004fe8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004fec:	df843783          	ld	a5,-520(s0)
    80004ff0:	0007c703          	lbu	a4,0(a5)
    80004ff4:	cf11                	beqz	a4,80005010 <exec+0x310>
    80004ff6:	0785                	add	a5,a5,1
    if(*s == '/')
    80004ff8:	02f00693          	li	a3,47
    80004ffc:	a039                	j	8000500a <exec+0x30a>
      last = s+1;
    80004ffe:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80005002:	0785                	add	a5,a5,1
    80005004:	fff7c703          	lbu	a4,-1(a5)
    80005008:	c701                	beqz	a4,80005010 <exec+0x310>
    if(*s == '/')
    8000500a:	fed71ce3          	bne	a4,a3,80005002 <exec+0x302>
    8000500e:	bfc5                	j	80004ffe <exec+0x2fe>
  safestrcpy(p->name, last, sizeof(p->name));
    80005010:	4641                	li	a2,16
    80005012:	df843583          	ld	a1,-520(s0)
    80005016:	158a8513          	add	a0,s5,344
    8000501a:	ffffc097          	auipc	ra,0xffffc
    8000501e:	ea2080e7          	jalr	-350(ra) # 80000ebc <safestrcpy>
  oldpagetable = p->pagetable;
    80005022:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80005026:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000502a:	e0843783          	ld	a5,-504(s0)
    8000502e:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005032:	058ab783          	ld	a5,88(s5)
    80005036:	e6043703          	ld	a4,-416(s0)
    8000503a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000503c:	058ab783          	ld	a5,88(s5)
    80005040:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005044:	85e6                	mv	a1,s9
    80005046:	ffffd097          	auipc	ra,0xffffd
    8000504a:	b54080e7          	jalr	-1196(ra) # 80001b9a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000504e:	0004851b          	sext.w	a0,s1
    80005052:	b399                	j	80004d98 <exec+0x98>
    80005054:	e0943423          	sd	s1,-504(s0)
    proc_freepagetable(pagetable, sz);
    80005058:	e0843583          	ld	a1,-504(s0)
    8000505c:	855a                	mv	a0,s6
    8000505e:	ffffd097          	auipc	ra,0xffffd
    80005062:	b3c080e7          	jalr	-1220(ra) # 80001b9a <proc_freepagetable>
  return -1;
    80005066:	557d                	li	a0,-1
  if(ip){
    80005068:	d20a08e3          	beqz	s4,80004d98 <exec+0x98>
    8000506c:	bb21                	j	80004d84 <exec+0x84>
    8000506e:	e0943423          	sd	s1,-504(s0)
    80005072:	b7dd                	j	80005058 <exec+0x358>
    80005074:	e0943423          	sd	s1,-504(s0)
    80005078:	b7c5                	j	80005058 <exec+0x358>
    8000507a:	e0943423          	sd	s1,-504(s0)
    8000507e:	bfe9                	j	80005058 <exec+0x358>
  ip = 0;
    80005080:	4a01                	li	s4,0
    80005082:	bfd9                	j	80005058 <exec+0x358>
    80005084:	4a01                	li	s4,0
  if(pagetable)
    80005086:	bfc9                	j	80005058 <exec+0x358>
  sz = sz1;
    80005088:	e0843983          	ld	s3,-504(s0)
    8000508c:	bd41                	j	80004f1c <exec+0x21c>

000000008000508e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000508e:	7179                	add	sp,sp,-48
    80005090:	f406                	sd	ra,40(sp)
    80005092:	f022                	sd	s0,32(sp)
    80005094:	ec26                	sd	s1,24(sp)
    80005096:	e84a                	sd	s2,16(sp)
    80005098:	1800                	add	s0,sp,48
    8000509a:	892e                	mv	s2,a1
    8000509c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000509e:	fdc40593          	add	a1,s0,-36
    800050a2:	ffffe097          	auipc	ra,0xffffe
    800050a6:	b9c080e7          	jalr	-1124(ra) # 80002c3e <argint>
    800050aa:	04054063          	bltz	a0,800050ea <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800050ae:	fdc42703          	lw	a4,-36(s0)
    800050b2:	47bd                	li	a5,15
    800050b4:	02e7ed63          	bltu	a5,a4,800050ee <argfd+0x60>
    800050b8:	ffffd097          	auipc	ra,0xffffd
    800050bc:	982080e7          	jalr	-1662(ra) # 80001a3a <myproc>
    800050c0:	fdc42703          	lw	a4,-36(s0)
    800050c4:	01a70793          	add	a5,a4,26
    800050c8:	078e                	sll	a5,a5,0x3
    800050ca:	953e                	add	a0,a0,a5
    800050cc:	611c                	ld	a5,0(a0)
    800050ce:	c395                	beqz	a5,800050f2 <argfd+0x64>
    return -1;
  if(pfd)
    800050d0:	00090463          	beqz	s2,800050d8 <argfd+0x4a>
    *pfd = fd;
    800050d4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800050d8:	4501                	li	a0,0
  if(pf)
    800050da:	c091                	beqz	s1,800050de <argfd+0x50>
    *pf = f;
    800050dc:	e09c                	sd	a5,0(s1)
}
    800050de:	70a2                	ld	ra,40(sp)
    800050e0:	7402                	ld	s0,32(sp)
    800050e2:	64e2                	ld	s1,24(sp)
    800050e4:	6942                	ld	s2,16(sp)
    800050e6:	6145                	add	sp,sp,48
    800050e8:	8082                	ret
    return -1;
    800050ea:	557d                	li	a0,-1
    800050ec:	bfcd                	j	800050de <argfd+0x50>
    return -1;
    800050ee:	557d                	li	a0,-1
    800050f0:	b7fd                	j	800050de <argfd+0x50>
    800050f2:	557d                	li	a0,-1
    800050f4:	b7ed                	j	800050de <argfd+0x50>

00000000800050f6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800050f6:	1101                	add	sp,sp,-32
    800050f8:	ec06                	sd	ra,24(sp)
    800050fa:	e822                	sd	s0,16(sp)
    800050fc:	e426                	sd	s1,8(sp)
    800050fe:	1000                	add	s0,sp,32
    80005100:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005102:	ffffd097          	auipc	ra,0xffffd
    80005106:	938080e7          	jalr	-1736(ra) # 80001a3a <myproc>
    8000510a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000510c:	0d050793          	add	a5,a0,208
    80005110:	4501                	li	a0,0
    80005112:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005114:	6398                	ld	a4,0(a5)
    80005116:	cb19                	beqz	a4,8000512c <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005118:	2505                	addw	a0,a0,1
    8000511a:	07a1                	add	a5,a5,8
    8000511c:	fed51ce3          	bne	a0,a3,80005114 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005120:	557d                	li	a0,-1
}
    80005122:	60e2                	ld	ra,24(sp)
    80005124:	6442                	ld	s0,16(sp)
    80005126:	64a2                	ld	s1,8(sp)
    80005128:	6105                	add	sp,sp,32
    8000512a:	8082                	ret
      p->ofile[fd] = f;
    8000512c:	01a50793          	add	a5,a0,26
    80005130:	078e                	sll	a5,a5,0x3
    80005132:	963e                	add	a2,a2,a5
    80005134:	e204                	sd	s1,0(a2)
      return fd;
    80005136:	b7f5                	j	80005122 <fdalloc+0x2c>

0000000080005138 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005138:	715d                	add	sp,sp,-80
    8000513a:	e486                	sd	ra,72(sp)
    8000513c:	e0a2                	sd	s0,64(sp)
    8000513e:	fc26                	sd	s1,56(sp)
    80005140:	f84a                	sd	s2,48(sp)
    80005142:	f44e                	sd	s3,40(sp)
    80005144:	f052                	sd	s4,32(sp)
    80005146:	ec56                	sd	s5,24(sp)
    80005148:	0880                	add	s0,sp,80
    8000514a:	8aae                	mv	s5,a1
    8000514c:	8a32                	mv	s4,a2
    8000514e:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005150:	fb040593          	add	a1,s0,-80
    80005154:	fffff097          	auipc	ra,0xfffff
    80005158:	e8e080e7          	jalr	-370(ra) # 80003fe2 <nameiparent>
    8000515c:	892a                	mv	s2,a0
    8000515e:	12050c63          	beqz	a0,80005296 <create+0x15e>
    return 0;

  ilock(dp);
    80005162:	ffffe097          	auipc	ra,0xffffe
    80005166:	6b2080e7          	jalr	1714(ra) # 80003814 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000516a:	4601                	li	a2,0
    8000516c:	fb040593          	add	a1,s0,-80
    80005170:	854a                	mv	a0,s2
    80005172:	fffff097          	auipc	ra,0xfffff
    80005176:	b80080e7          	jalr	-1152(ra) # 80003cf2 <dirlookup>
    8000517a:	84aa                	mv	s1,a0
    8000517c:	c539                	beqz	a0,800051ca <create+0x92>
    iunlockput(dp);
    8000517e:	854a                	mv	a0,s2
    80005180:	fffff097          	auipc	ra,0xfffff
    80005184:	8f6080e7          	jalr	-1802(ra) # 80003a76 <iunlockput>
    ilock(ip);
    80005188:	8526                	mv	a0,s1
    8000518a:	ffffe097          	auipc	ra,0xffffe
    8000518e:	68a080e7          	jalr	1674(ra) # 80003814 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005192:	4789                	li	a5,2
    80005194:	02fa9463          	bne	s5,a5,800051bc <create+0x84>
    80005198:	0444d783          	lhu	a5,68(s1)
    8000519c:	37f9                	addw	a5,a5,-2
    8000519e:	17c2                	sll	a5,a5,0x30
    800051a0:	93c1                	srl	a5,a5,0x30
    800051a2:	4705                	li	a4,1
    800051a4:	00f76c63          	bltu	a4,a5,800051bc <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800051a8:	8526                	mv	a0,s1
    800051aa:	60a6                	ld	ra,72(sp)
    800051ac:	6406                	ld	s0,64(sp)
    800051ae:	74e2                	ld	s1,56(sp)
    800051b0:	7942                	ld	s2,48(sp)
    800051b2:	79a2                	ld	s3,40(sp)
    800051b4:	7a02                	ld	s4,32(sp)
    800051b6:	6ae2                	ld	s5,24(sp)
    800051b8:	6161                	add	sp,sp,80
    800051ba:	8082                	ret
    iunlockput(ip);
    800051bc:	8526                	mv	a0,s1
    800051be:	fffff097          	auipc	ra,0xfffff
    800051c2:	8b8080e7          	jalr	-1864(ra) # 80003a76 <iunlockput>
    return 0;
    800051c6:	4481                	li	s1,0
    800051c8:	b7c5                	j	800051a8 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    800051ca:	85d6                	mv	a1,s5
    800051cc:	00092503          	lw	a0,0(s2)
    800051d0:	ffffe097          	auipc	ra,0xffffe
    800051d4:	4b0080e7          	jalr	1200(ra) # 80003680 <ialloc>
    800051d8:	84aa                	mv	s1,a0
    800051da:	c139                	beqz	a0,80005220 <create+0xe8>
  ilock(ip);
    800051dc:	ffffe097          	auipc	ra,0xffffe
    800051e0:	638080e7          	jalr	1592(ra) # 80003814 <ilock>
  ip->major = major;
    800051e4:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    800051e8:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    800051ec:	4985                	li	s3,1
    800051ee:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    800051f2:	8526                	mv	a0,s1
    800051f4:	ffffe097          	auipc	ra,0xffffe
    800051f8:	554080e7          	jalr	1364(ra) # 80003748 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800051fc:	033a8a63          	beq	s5,s3,80005230 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    80005200:	40d0                	lw	a2,4(s1)
    80005202:	fb040593          	add	a1,s0,-80
    80005206:	854a                	mv	a0,s2
    80005208:	fffff097          	auipc	ra,0xfffff
    8000520c:	cfa080e7          	jalr	-774(ra) # 80003f02 <dirlink>
    80005210:	06054b63          	bltz	a0,80005286 <create+0x14e>
  iunlockput(dp);
    80005214:	854a                	mv	a0,s2
    80005216:	fffff097          	auipc	ra,0xfffff
    8000521a:	860080e7          	jalr	-1952(ra) # 80003a76 <iunlockput>
  return ip;
    8000521e:	b769                	j	800051a8 <create+0x70>
    panic("create: ialloc");
    80005220:	00003517          	auipc	a0,0x3
    80005224:	4e050513          	add	a0,a0,1248 # 80008700 <syscalls+0x2c0>
    80005228:	ffffb097          	auipc	ra,0xffffb
    8000522c:	3b8080e7          	jalr	952(ra) # 800005e0 <panic>
    dp->nlink++;  // for ".."
    80005230:	04a95783          	lhu	a5,74(s2)
    80005234:	2785                	addw	a5,a5,1
    80005236:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000523a:	854a                	mv	a0,s2
    8000523c:	ffffe097          	auipc	ra,0xffffe
    80005240:	50c080e7          	jalr	1292(ra) # 80003748 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005244:	40d0                	lw	a2,4(s1)
    80005246:	00003597          	auipc	a1,0x3
    8000524a:	4ca58593          	add	a1,a1,1226 # 80008710 <syscalls+0x2d0>
    8000524e:	8526                	mv	a0,s1
    80005250:	fffff097          	auipc	ra,0xfffff
    80005254:	cb2080e7          	jalr	-846(ra) # 80003f02 <dirlink>
    80005258:	00054f63          	bltz	a0,80005276 <create+0x13e>
    8000525c:	00492603          	lw	a2,4(s2)
    80005260:	00003597          	auipc	a1,0x3
    80005264:	4b858593          	add	a1,a1,1208 # 80008718 <syscalls+0x2d8>
    80005268:	8526                	mv	a0,s1
    8000526a:	fffff097          	auipc	ra,0xfffff
    8000526e:	c98080e7          	jalr	-872(ra) # 80003f02 <dirlink>
    80005272:	f80557e3          	bgez	a0,80005200 <create+0xc8>
      panic("create dots");
    80005276:	00003517          	auipc	a0,0x3
    8000527a:	4aa50513          	add	a0,a0,1194 # 80008720 <syscalls+0x2e0>
    8000527e:	ffffb097          	auipc	ra,0xffffb
    80005282:	362080e7          	jalr	866(ra) # 800005e0 <panic>
    panic("create: dirlink");
    80005286:	00003517          	auipc	a0,0x3
    8000528a:	4aa50513          	add	a0,a0,1194 # 80008730 <syscalls+0x2f0>
    8000528e:	ffffb097          	auipc	ra,0xffffb
    80005292:	352080e7          	jalr	850(ra) # 800005e0 <panic>
    return 0;
    80005296:	84aa                	mv	s1,a0
    80005298:	bf01                	j	800051a8 <create+0x70>

000000008000529a <sys_dup>:
{
    8000529a:	7179                	add	sp,sp,-48
    8000529c:	f406                	sd	ra,40(sp)
    8000529e:	f022                	sd	s0,32(sp)
    800052a0:	ec26                	sd	s1,24(sp)
    800052a2:	e84a                	sd	s2,16(sp)
    800052a4:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800052a6:	fd840613          	add	a2,s0,-40
    800052aa:	4581                	li	a1,0
    800052ac:	4501                	li	a0,0
    800052ae:	00000097          	auipc	ra,0x0
    800052b2:	de0080e7          	jalr	-544(ra) # 8000508e <argfd>
    return -1;
    800052b6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800052b8:	02054363          	bltz	a0,800052de <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800052bc:	fd843903          	ld	s2,-40(s0)
    800052c0:	854a                	mv	a0,s2
    800052c2:	00000097          	auipc	ra,0x0
    800052c6:	e34080e7          	jalr	-460(ra) # 800050f6 <fdalloc>
    800052ca:	84aa                	mv	s1,a0
    return -1;
    800052cc:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800052ce:	00054863          	bltz	a0,800052de <sys_dup+0x44>
  filedup(f);
    800052d2:	854a                	mv	a0,s2
    800052d4:	fffff097          	auipc	ra,0xfffff
    800052d8:	358080e7          	jalr	856(ra) # 8000462c <filedup>
  return fd;
    800052dc:	87a6                	mv	a5,s1
}
    800052de:	853e                	mv	a0,a5
    800052e0:	70a2                	ld	ra,40(sp)
    800052e2:	7402                	ld	s0,32(sp)
    800052e4:	64e2                	ld	s1,24(sp)
    800052e6:	6942                	ld	s2,16(sp)
    800052e8:	6145                	add	sp,sp,48
    800052ea:	8082                	ret

00000000800052ec <sys_read>:
{
    800052ec:	7179                	add	sp,sp,-48
    800052ee:	f406                	sd	ra,40(sp)
    800052f0:	f022                	sd	s0,32(sp)
    800052f2:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052f4:	fe840613          	add	a2,s0,-24
    800052f8:	4581                	li	a1,0
    800052fa:	4501                	li	a0,0
    800052fc:	00000097          	auipc	ra,0x0
    80005300:	d92080e7          	jalr	-622(ra) # 8000508e <argfd>
    return -1;
    80005304:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005306:	04054163          	bltz	a0,80005348 <sys_read+0x5c>
    8000530a:	fe440593          	add	a1,s0,-28
    8000530e:	4509                	li	a0,2
    80005310:	ffffe097          	auipc	ra,0xffffe
    80005314:	92e080e7          	jalr	-1746(ra) # 80002c3e <argint>
    return -1;
    80005318:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000531a:	02054763          	bltz	a0,80005348 <sys_read+0x5c>
    8000531e:	fd840593          	add	a1,s0,-40
    80005322:	4505                	li	a0,1
    80005324:	ffffe097          	auipc	ra,0xffffe
    80005328:	93c080e7          	jalr	-1732(ra) # 80002c60 <argaddr>
    return -1;
    8000532c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000532e:	00054d63          	bltz	a0,80005348 <sys_read+0x5c>
  return fileread(f, p, n);
    80005332:	fe442603          	lw	a2,-28(s0)
    80005336:	fd843583          	ld	a1,-40(s0)
    8000533a:	fe843503          	ld	a0,-24(s0)
    8000533e:	fffff097          	auipc	ra,0xfffff
    80005342:	47a080e7          	jalr	1146(ra) # 800047b8 <fileread>
    80005346:	87aa                	mv	a5,a0
}
    80005348:	853e                	mv	a0,a5
    8000534a:	70a2                	ld	ra,40(sp)
    8000534c:	7402                	ld	s0,32(sp)
    8000534e:	6145                	add	sp,sp,48
    80005350:	8082                	ret

0000000080005352 <sys_write>:
{
    80005352:	7179                	add	sp,sp,-48
    80005354:	f406                	sd	ra,40(sp)
    80005356:	f022                	sd	s0,32(sp)
    80005358:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000535a:	fe840613          	add	a2,s0,-24
    8000535e:	4581                	li	a1,0
    80005360:	4501                	li	a0,0
    80005362:	00000097          	auipc	ra,0x0
    80005366:	d2c080e7          	jalr	-724(ra) # 8000508e <argfd>
    return -1;
    8000536a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000536c:	04054163          	bltz	a0,800053ae <sys_write+0x5c>
    80005370:	fe440593          	add	a1,s0,-28
    80005374:	4509                	li	a0,2
    80005376:	ffffe097          	auipc	ra,0xffffe
    8000537a:	8c8080e7          	jalr	-1848(ra) # 80002c3e <argint>
    return -1;
    8000537e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005380:	02054763          	bltz	a0,800053ae <sys_write+0x5c>
    80005384:	fd840593          	add	a1,s0,-40
    80005388:	4505                	li	a0,1
    8000538a:	ffffe097          	auipc	ra,0xffffe
    8000538e:	8d6080e7          	jalr	-1834(ra) # 80002c60 <argaddr>
    return -1;
    80005392:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005394:	00054d63          	bltz	a0,800053ae <sys_write+0x5c>
  return filewrite(f, p, n);
    80005398:	fe442603          	lw	a2,-28(s0)
    8000539c:	fd843583          	ld	a1,-40(s0)
    800053a0:	fe843503          	ld	a0,-24(s0)
    800053a4:	fffff097          	auipc	ra,0xfffff
    800053a8:	4d6080e7          	jalr	1238(ra) # 8000487a <filewrite>
    800053ac:	87aa                	mv	a5,a0
}
    800053ae:	853e                	mv	a0,a5
    800053b0:	70a2                	ld	ra,40(sp)
    800053b2:	7402                	ld	s0,32(sp)
    800053b4:	6145                	add	sp,sp,48
    800053b6:	8082                	ret

00000000800053b8 <sys_close>:
{
    800053b8:	1101                	add	sp,sp,-32
    800053ba:	ec06                	sd	ra,24(sp)
    800053bc:	e822                	sd	s0,16(sp)
    800053be:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800053c0:	fe040613          	add	a2,s0,-32
    800053c4:	fec40593          	add	a1,s0,-20
    800053c8:	4501                	li	a0,0
    800053ca:	00000097          	auipc	ra,0x0
    800053ce:	cc4080e7          	jalr	-828(ra) # 8000508e <argfd>
    return -1;
    800053d2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800053d4:	02054463          	bltz	a0,800053fc <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800053d8:	ffffc097          	auipc	ra,0xffffc
    800053dc:	662080e7          	jalr	1634(ra) # 80001a3a <myproc>
    800053e0:	fec42783          	lw	a5,-20(s0)
    800053e4:	07e9                	add	a5,a5,26
    800053e6:	078e                	sll	a5,a5,0x3
    800053e8:	953e                	add	a0,a0,a5
    800053ea:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800053ee:	fe043503          	ld	a0,-32(s0)
    800053f2:	fffff097          	auipc	ra,0xfffff
    800053f6:	28c080e7          	jalr	652(ra) # 8000467e <fileclose>
  return 0;
    800053fa:	4781                	li	a5,0
}
    800053fc:	853e                	mv	a0,a5
    800053fe:	60e2                	ld	ra,24(sp)
    80005400:	6442                	ld	s0,16(sp)
    80005402:	6105                	add	sp,sp,32
    80005404:	8082                	ret

0000000080005406 <sys_fstat>:
{
    80005406:	1101                	add	sp,sp,-32
    80005408:	ec06                	sd	ra,24(sp)
    8000540a:	e822                	sd	s0,16(sp)
    8000540c:	1000                	add	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000540e:	fe840613          	add	a2,s0,-24
    80005412:	4581                	li	a1,0
    80005414:	4501                	li	a0,0
    80005416:	00000097          	auipc	ra,0x0
    8000541a:	c78080e7          	jalr	-904(ra) # 8000508e <argfd>
    return -1;
    8000541e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005420:	02054563          	bltz	a0,8000544a <sys_fstat+0x44>
    80005424:	fe040593          	add	a1,s0,-32
    80005428:	4505                	li	a0,1
    8000542a:	ffffe097          	auipc	ra,0xffffe
    8000542e:	836080e7          	jalr	-1994(ra) # 80002c60 <argaddr>
    return -1;
    80005432:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005434:	00054b63          	bltz	a0,8000544a <sys_fstat+0x44>
  return filestat(f, st);
    80005438:	fe043583          	ld	a1,-32(s0)
    8000543c:	fe843503          	ld	a0,-24(s0)
    80005440:	fffff097          	auipc	ra,0xfffff
    80005444:	306080e7          	jalr	774(ra) # 80004746 <filestat>
    80005448:	87aa                	mv	a5,a0
}
    8000544a:	853e                	mv	a0,a5
    8000544c:	60e2                	ld	ra,24(sp)
    8000544e:	6442                	ld	s0,16(sp)
    80005450:	6105                	add	sp,sp,32
    80005452:	8082                	ret

0000000080005454 <sys_link>:
{
    80005454:	7169                	add	sp,sp,-304
    80005456:	f606                	sd	ra,296(sp)
    80005458:	f222                	sd	s0,288(sp)
    8000545a:	ee26                	sd	s1,280(sp)
    8000545c:	ea4a                	sd	s2,272(sp)
    8000545e:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005460:	08000613          	li	a2,128
    80005464:	ed040593          	add	a1,s0,-304
    80005468:	4501                	li	a0,0
    8000546a:	ffffe097          	auipc	ra,0xffffe
    8000546e:	818080e7          	jalr	-2024(ra) # 80002c82 <argstr>
    return -1;
    80005472:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005474:	10054e63          	bltz	a0,80005590 <sys_link+0x13c>
    80005478:	08000613          	li	a2,128
    8000547c:	f5040593          	add	a1,s0,-176
    80005480:	4505                	li	a0,1
    80005482:	ffffe097          	auipc	ra,0xffffe
    80005486:	800080e7          	jalr	-2048(ra) # 80002c82 <argstr>
    return -1;
    8000548a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000548c:	10054263          	bltz	a0,80005590 <sys_link+0x13c>
  begin_op();
    80005490:	fffff097          	auipc	ra,0xfffff
    80005494:	d24080e7          	jalr	-732(ra) # 800041b4 <begin_op>
  if((ip = namei(old)) == 0){
    80005498:	ed040513          	add	a0,s0,-304
    8000549c:	fffff097          	auipc	ra,0xfffff
    800054a0:	b28080e7          	jalr	-1240(ra) # 80003fc4 <namei>
    800054a4:	84aa                	mv	s1,a0
    800054a6:	c551                	beqz	a0,80005532 <sys_link+0xde>
  ilock(ip);
    800054a8:	ffffe097          	auipc	ra,0xffffe
    800054ac:	36c080e7          	jalr	876(ra) # 80003814 <ilock>
  if(ip->type == T_DIR){
    800054b0:	04449703          	lh	a4,68(s1)
    800054b4:	4785                	li	a5,1
    800054b6:	08f70463          	beq	a4,a5,8000553e <sys_link+0xea>
  ip->nlink++;
    800054ba:	04a4d783          	lhu	a5,74(s1)
    800054be:	2785                	addw	a5,a5,1
    800054c0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800054c4:	8526                	mv	a0,s1
    800054c6:	ffffe097          	auipc	ra,0xffffe
    800054ca:	282080e7          	jalr	642(ra) # 80003748 <iupdate>
  iunlock(ip);
    800054ce:	8526                	mv	a0,s1
    800054d0:	ffffe097          	auipc	ra,0xffffe
    800054d4:	406080e7          	jalr	1030(ra) # 800038d6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800054d8:	fd040593          	add	a1,s0,-48
    800054dc:	f5040513          	add	a0,s0,-176
    800054e0:	fffff097          	auipc	ra,0xfffff
    800054e4:	b02080e7          	jalr	-1278(ra) # 80003fe2 <nameiparent>
    800054e8:	892a                	mv	s2,a0
    800054ea:	c935                	beqz	a0,8000555e <sys_link+0x10a>
  ilock(dp);
    800054ec:	ffffe097          	auipc	ra,0xffffe
    800054f0:	328080e7          	jalr	808(ra) # 80003814 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800054f4:	00092703          	lw	a4,0(s2)
    800054f8:	409c                	lw	a5,0(s1)
    800054fa:	04f71d63          	bne	a4,a5,80005554 <sys_link+0x100>
    800054fe:	40d0                	lw	a2,4(s1)
    80005500:	fd040593          	add	a1,s0,-48
    80005504:	854a                	mv	a0,s2
    80005506:	fffff097          	auipc	ra,0xfffff
    8000550a:	9fc080e7          	jalr	-1540(ra) # 80003f02 <dirlink>
    8000550e:	04054363          	bltz	a0,80005554 <sys_link+0x100>
  iunlockput(dp);
    80005512:	854a                	mv	a0,s2
    80005514:	ffffe097          	auipc	ra,0xffffe
    80005518:	562080e7          	jalr	1378(ra) # 80003a76 <iunlockput>
  iput(ip);
    8000551c:	8526                	mv	a0,s1
    8000551e:	ffffe097          	auipc	ra,0xffffe
    80005522:	4b0080e7          	jalr	1200(ra) # 800039ce <iput>
  end_op();
    80005526:	fffff097          	auipc	ra,0xfffff
    8000552a:	d08080e7          	jalr	-760(ra) # 8000422e <end_op>
  return 0;
    8000552e:	4781                	li	a5,0
    80005530:	a085                	j	80005590 <sys_link+0x13c>
    end_op();
    80005532:	fffff097          	auipc	ra,0xfffff
    80005536:	cfc080e7          	jalr	-772(ra) # 8000422e <end_op>
    return -1;
    8000553a:	57fd                	li	a5,-1
    8000553c:	a891                	j	80005590 <sys_link+0x13c>
    iunlockput(ip);
    8000553e:	8526                	mv	a0,s1
    80005540:	ffffe097          	auipc	ra,0xffffe
    80005544:	536080e7          	jalr	1334(ra) # 80003a76 <iunlockput>
    end_op();
    80005548:	fffff097          	auipc	ra,0xfffff
    8000554c:	ce6080e7          	jalr	-794(ra) # 8000422e <end_op>
    return -1;
    80005550:	57fd                	li	a5,-1
    80005552:	a83d                	j	80005590 <sys_link+0x13c>
    iunlockput(dp);
    80005554:	854a                	mv	a0,s2
    80005556:	ffffe097          	auipc	ra,0xffffe
    8000555a:	520080e7          	jalr	1312(ra) # 80003a76 <iunlockput>
  ilock(ip);
    8000555e:	8526                	mv	a0,s1
    80005560:	ffffe097          	auipc	ra,0xffffe
    80005564:	2b4080e7          	jalr	692(ra) # 80003814 <ilock>
  ip->nlink--;
    80005568:	04a4d783          	lhu	a5,74(s1)
    8000556c:	37fd                	addw	a5,a5,-1
    8000556e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005572:	8526                	mv	a0,s1
    80005574:	ffffe097          	auipc	ra,0xffffe
    80005578:	1d4080e7          	jalr	468(ra) # 80003748 <iupdate>
  iunlockput(ip);
    8000557c:	8526                	mv	a0,s1
    8000557e:	ffffe097          	auipc	ra,0xffffe
    80005582:	4f8080e7          	jalr	1272(ra) # 80003a76 <iunlockput>
  end_op();
    80005586:	fffff097          	auipc	ra,0xfffff
    8000558a:	ca8080e7          	jalr	-856(ra) # 8000422e <end_op>
  return -1;
    8000558e:	57fd                	li	a5,-1
}
    80005590:	853e                	mv	a0,a5
    80005592:	70b2                	ld	ra,296(sp)
    80005594:	7412                	ld	s0,288(sp)
    80005596:	64f2                	ld	s1,280(sp)
    80005598:	6952                	ld	s2,272(sp)
    8000559a:	6155                	add	sp,sp,304
    8000559c:	8082                	ret

000000008000559e <sys_unlink>:
{
    8000559e:	7151                	add	sp,sp,-240
    800055a0:	f586                	sd	ra,232(sp)
    800055a2:	f1a2                	sd	s0,224(sp)
    800055a4:	eda6                	sd	s1,216(sp)
    800055a6:	e9ca                	sd	s2,208(sp)
    800055a8:	e5ce                	sd	s3,200(sp)
    800055aa:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800055ac:	08000613          	li	a2,128
    800055b0:	f3040593          	add	a1,s0,-208
    800055b4:	4501                	li	a0,0
    800055b6:	ffffd097          	auipc	ra,0xffffd
    800055ba:	6cc080e7          	jalr	1740(ra) # 80002c82 <argstr>
    800055be:	18054163          	bltz	a0,80005740 <sys_unlink+0x1a2>
  begin_op();
    800055c2:	fffff097          	auipc	ra,0xfffff
    800055c6:	bf2080e7          	jalr	-1038(ra) # 800041b4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800055ca:	fb040593          	add	a1,s0,-80
    800055ce:	f3040513          	add	a0,s0,-208
    800055d2:	fffff097          	auipc	ra,0xfffff
    800055d6:	a10080e7          	jalr	-1520(ra) # 80003fe2 <nameiparent>
    800055da:	84aa                	mv	s1,a0
    800055dc:	c979                	beqz	a0,800056b2 <sys_unlink+0x114>
  ilock(dp);
    800055de:	ffffe097          	auipc	ra,0xffffe
    800055e2:	236080e7          	jalr	566(ra) # 80003814 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800055e6:	00003597          	auipc	a1,0x3
    800055ea:	12a58593          	add	a1,a1,298 # 80008710 <syscalls+0x2d0>
    800055ee:	fb040513          	add	a0,s0,-80
    800055f2:	ffffe097          	auipc	ra,0xffffe
    800055f6:	6e6080e7          	jalr	1766(ra) # 80003cd8 <namecmp>
    800055fa:	14050a63          	beqz	a0,8000574e <sys_unlink+0x1b0>
    800055fe:	00003597          	auipc	a1,0x3
    80005602:	11a58593          	add	a1,a1,282 # 80008718 <syscalls+0x2d8>
    80005606:	fb040513          	add	a0,s0,-80
    8000560a:	ffffe097          	auipc	ra,0xffffe
    8000560e:	6ce080e7          	jalr	1742(ra) # 80003cd8 <namecmp>
    80005612:	12050e63          	beqz	a0,8000574e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005616:	f2c40613          	add	a2,s0,-212
    8000561a:	fb040593          	add	a1,s0,-80
    8000561e:	8526                	mv	a0,s1
    80005620:	ffffe097          	auipc	ra,0xffffe
    80005624:	6d2080e7          	jalr	1746(ra) # 80003cf2 <dirlookup>
    80005628:	892a                	mv	s2,a0
    8000562a:	12050263          	beqz	a0,8000574e <sys_unlink+0x1b0>
  ilock(ip);
    8000562e:	ffffe097          	auipc	ra,0xffffe
    80005632:	1e6080e7          	jalr	486(ra) # 80003814 <ilock>
  if(ip->nlink < 1)
    80005636:	04a91783          	lh	a5,74(s2)
    8000563a:	08f05263          	blez	a5,800056be <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000563e:	04491703          	lh	a4,68(s2)
    80005642:	4785                	li	a5,1
    80005644:	08f70563          	beq	a4,a5,800056ce <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005648:	4641                	li	a2,16
    8000564a:	4581                	li	a1,0
    8000564c:	fc040513          	add	a0,s0,-64
    80005650:	ffffb097          	auipc	ra,0xffffb
    80005654:	71c080e7          	jalr	1820(ra) # 80000d6c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005658:	4741                	li	a4,16
    8000565a:	f2c42683          	lw	a3,-212(s0)
    8000565e:	fc040613          	add	a2,s0,-64
    80005662:	4581                	li	a1,0
    80005664:	8526                	mv	a0,s1
    80005666:	ffffe097          	auipc	ra,0xffffe
    8000566a:	558080e7          	jalr	1368(ra) # 80003bbe <writei>
    8000566e:	47c1                	li	a5,16
    80005670:	0af51563          	bne	a0,a5,8000571a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005674:	04491703          	lh	a4,68(s2)
    80005678:	4785                	li	a5,1
    8000567a:	0af70863          	beq	a4,a5,8000572a <sys_unlink+0x18c>
  iunlockput(dp);
    8000567e:	8526                	mv	a0,s1
    80005680:	ffffe097          	auipc	ra,0xffffe
    80005684:	3f6080e7          	jalr	1014(ra) # 80003a76 <iunlockput>
  ip->nlink--;
    80005688:	04a95783          	lhu	a5,74(s2)
    8000568c:	37fd                	addw	a5,a5,-1
    8000568e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005692:	854a                	mv	a0,s2
    80005694:	ffffe097          	auipc	ra,0xffffe
    80005698:	0b4080e7          	jalr	180(ra) # 80003748 <iupdate>
  iunlockput(ip);
    8000569c:	854a                	mv	a0,s2
    8000569e:	ffffe097          	auipc	ra,0xffffe
    800056a2:	3d8080e7          	jalr	984(ra) # 80003a76 <iunlockput>
  end_op();
    800056a6:	fffff097          	auipc	ra,0xfffff
    800056aa:	b88080e7          	jalr	-1144(ra) # 8000422e <end_op>
  return 0;
    800056ae:	4501                	li	a0,0
    800056b0:	a84d                	j	80005762 <sys_unlink+0x1c4>
    end_op();
    800056b2:	fffff097          	auipc	ra,0xfffff
    800056b6:	b7c080e7          	jalr	-1156(ra) # 8000422e <end_op>
    return -1;
    800056ba:	557d                	li	a0,-1
    800056bc:	a05d                	j	80005762 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800056be:	00003517          	auipc	a0,0x3
    800056c2:	08250513          	add	a0,a0,130 # 80008740 <syscalls+0x300>
    800056c6:	ffffb097          	auipc	ra,0xffffb
    800056ca:	f1a080e7          	jalr	-230(ra) # 800005e0 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800056ce:	04c92703          	lw	a4,76(s2)
    800056d2:	02000793          	li	a5,32
    800056d6:	f6e7f9e3          	bgeu	a5,a4,80005648 <sys_unlink+0xaa>
    800056da:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800056de:	4741                	li	a4,16
    800056e0:	86ce                	mv	a3,s3
    800056e2:	f1840613          	add	a2,s0,-232
    800056e6:	4581                	li	a1,0
    800056e8:	854a                	mv	a0,s2
    800056ea:	ffffe097          	auipc	ra,0xffffe
    800056ee:	3de080e7          	jalr	990(ra) # 80003ac8 <readi>
    800056f2:	47c1                	li	a5,16
    800056f4:	00f51b63          	bne	a0,a5,8000570a <sys_unlink+0x16c>
    if(de.inum != 0)
    800056f8:	f1845783          	lhu	a5,-232(s0)
    800056fc:	e7a1                	bnez	a5,80005744 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800056fe:	29c1                	addw	s3,s3,16
    80005700:	04c92783          	lw	a5,76(s2)
    80005704:	fcf9ede3          	bltu	s3,a5,800056de <sys_unlink+0x140>
    80005708:	b781                	j	80005648 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    8000570a:	00003517          	auipc	a0,0x3
    8000570e:	04e50513          	add	a0,a0,78 # 80008758 <syscalls+0x318>
    80005712:	ffffb097          	auipc	ra,0xffffb
    80005716:	ece080e7          	jalr	-306(ra) # 800005e0 <panic>
    panic("unlink: writei");
    8000571a:	00003517          	auipc	a0,0x3
    8000571e:	05650513          	add	a0,a0,86 # 80008770 <syscalls+0x330>
    80005722:	ffffb097          	auipc	ra,0xffffb
    80005726:	ebe080e7          	jalr	-322(ra) # 800005e0 <panic>
    dp->nlink--;
    8000572a:	04a4d783          	lhu	a5,74(s1)
    8000572e:	37fd                	addw	a5,a5,-1
    80005730:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005734:	8526                	mv	a0,s1
    80005736:	ffffe097          	auipc	ra,0xffffe
    8000573a:	012080e7          	jalr	18(ra) # 80003748 <iupdate>
    8000573e:	b781                	j	8000567e <sys_unlink+0xe0>
    return -1;
    80005740:	557d                	li	a0,-1
    80005742:	a005                	j	80005762 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005744:	854a                	mv	a0,s2
    80005746:	ffffe097          	auipc	ra,0xffffe
    8000574a:	330080e7          	jalr	816(ra) # 80003a76 <iunlockput>
  iunlockput(dp);
    8000574e:	8526                	mv	a0,s1
    80005750:	ffffe097          	auipc	ra,0xffffe
    80005754:	326080e7          	jalr	806(ra) # 80003a76 <iunlockput>
  end_op();
    80005758:	fffff097          	auipc	ra,0xfffff
    8000575c:	ad6080e7          	jalr	-1322(ra) # 8000422e <end_op>
  return -1;
    80005760:	557d                	li	a0,-1
}
    80005762:	70ae                	ld	ra,232(sp)
    80005764:	740e                	ld	s0,224(sp)
    80005766:	64ee                	ld	s1,216(sp)
    80005768:	694e                	ld	s2,208(sp)
    8000576a:	69ae                	ld	s3,200(sp)
    8000576c:	616d                	add	sp,sp,240
    8000576e:	8082                	ret

0000000080005770 <sys_open>:

uint64
sys_open(void)
{
    80005770:	7131                	add	sp,sp,-192
    80005772:	fd06                	sd	ra,184(sp)
    80005774:	f922                	sd	s0,176(sp)
    80005776:	f526                	sd	s1,168(sp)
    80005778:	f14a                	sd	s2,160(sp)
    8000577a:	ed4e                	sd	s3,152(sp)
    8000577c:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000577e:	08000613          	li	a2,128
    80005782:	f5040593          	add	a1,s0,-176
    80005786:	4501                	li	a0,0
    80005788:	ffffd097          	auipc	ra,0xffffd
    8000578c:	4fa080e7          	jalr	1274(ra) # 80002c82 <argstr>
    return -1;
    80005790:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005792:	0c054063          	bltz	a0,80005852 <sys_open+0xe2>
    80005796:	f4c40593          	add	a1,s0,-180
    8000579a:	4505                	li	a0,1
    8000579c:	ffffd097          	auipc	ra,0xffffd
    800057a0:	4a2080e7          	jalr	1186(ra) # 80002c3e <argint>
    800057a4:	0a054763          	bltz	a0,80005852 <sys_open+0xe2>

  begin_op();
    800057a8:	fffff097          	auipc	ra,0xfffff
    800057ac:	a0c080e7          	jalr	-1524(ra) # 800041b4 <begin_op>

  if(omode & O_CREATE){
    800057b0:	f4c42783          	lw	a5,-180(s0)
    800057b4:	2007f793          	and	a5,a5,512
    800057b8:	cbd5                	beqz	a5,8000586c <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    800057ba:	4681                	li	a3,0
    800057bc:	4601                	li	a2,0
    800057be:	4589                	li	a1,2
    800057c0:	f5040513          	add	a0,s0,-176
    800057c4:	00000097          	auipc	ra,0x0
    800057c8:	974080e7          	jalr	-1676(ra) # 80005138 <create>
    800057cc:	892a                	mv	s2,a0
    if(ip == 0){
    800057ce:	c951                	beqz	a0,80005862 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800057d0:	04491703          	lh	a4,68(s2)
    800057d4:	478d                	li	a5,3
    800057d6:	00f71763          	bne	a4,a5,800057e4 <sys_open+0x74>
    800057da:	04695703          	lhu	a4,70(s2)
    800057de:	47a5                	li	a5,9
    800057e0:	0ce7eb63          	bltu	a5,a4,800058b6 <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800057e4:	fffff097          	auipc	ra,0xfffff
    800057e8:	dde080e7          	jalr	-546(ra) # 800045c2 <filealloc>
    800057ec:	89aa                	mv	s3,a0
    800057ee:	c565                	beqz	a0,800058d6 <sys_open+0x166>
    800057f0:	00000097          	auipc	ra,0x0
    800057f4:	906080e7          	jalr	-1786(ra) # 800050f6 <fdalloc>
    800057f8:	84aa                	mv	s1,a0
    800057fa:	0c054963          	bltz	a0,800058cc <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800057fe:	04491703          	lh	a4,68(s2)
    80005802:	478d                	li	a5,3
    80005804:	0ef70463          	beq	a4,a5,800058ec <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005808:	4789                	li	a5,2
    8000580a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    8000580e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005812:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005816:	f4c42783          	lw	a5,-180(s0)
    8000581a:	0017c713          	xor	a4,a5,1
    8000581e:	8b05                	and	a4,a4,1
    80005820:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005824:	0037f713          	and	a4,a5,3
    80005828:	00e03733          	snez	a4,a4
    8000582c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005830:	4007f793          	and	a5,a5,1024
    80005834:	c791                	beqz	a5,80005840 <sys_open+0xd0>
    80005836:	04491703          	lh	a4,68(s2)
    8000583a:	4789                	li	a5,2
    8000583c:	0af70f63          	beq	a4,a5,800058fa <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80005840:	854a                	mv	a0,s2
    80005842:	ffffe097          	auipc	ra,0xffffe
    80005846:	094080e7          	jalr	148(ra) # 800038d6 <iunlock>
  end_op();
    8000584a:	fffff097          	auipc	ra,0xfffff
    8000584e:	9e4080e7          	jalr	-1564(ra) # 8000422e <end_op>

  return fd;
}
    80005852:	8526                	mv	a0,s1
    80005854:	70ea                	ld	ra,184(sp)
    80005856:	744a                	ld	s0,176(sp)
    80005858:	74aa                	ld	s1,168(sp)
    8000585a:	790a                	ld	s2,160(sp)
    8000585c:	69ea                	ld	s3,152(sp)
    8000585e:	6129                	add	sp,sp,192
    80005860:	8082                	ret
      end_op();
    80005862:	fffff097          	auipc	ra,0xfffff
    80005866:	9cc080e7          	jalr	-1588(ra) # 8000422e <end_op>
      return -1;
    8000586a:	b7e5                	j	80005852 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    8000586c:	f5040513          	add	a0,s0,-176
    80005870:	ffffe097          	auipc	ra,0xffffe
    80005874:	754080e7          	jalr	1876(ra) # 80003fc4 <namei>
    80005878:	892a                	mv	s2,a0
    8000587a:	c905                	beqz	a0,800058aa <sys_open+0x13a>
    ilock(ip);
    8000587c:	ffffe097          	auipc	ra,0xffffe
    80005880:	f98080e7          	jalr	-104(ra) # 80003814 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005884:	04491703          	lh	a4,68(s2)
    80005888:	4785                	li	a5,1
    8000588a:	f4f713e3          	bne	a4,a5,800057d0 <sys_open+0x60>
    8000588e:	f4c42783          	lw	a5,-180(s0)
    80005892:	dba9                	beqz	a5,800057e4 <sys_open+0x74>
      iunlockput(ip);
    80005894:	854a                	mv	a0,s2
    80005896:	ffffe097          	auipc	ra,0xffffe
    8000589a:	1e0080e7          	jalr	480(ra) # 80003a76 <iunlockput>
      end_op();
    8000589e:	fffff097          	auipc	ra,0xfffff
    800058a2:	990080e7          	jalr	-1648(ra) # 8000422e <end_op>
      return -1;
    800058a6:	54fd                	li	s1,-1
    800058a8:	b76d                	j	80005852 <sys_open+0xe2>
      end_op();
    800058aa:	fffff097          	auipc	ra,0xfffff
    800058ae:	984080e7          	jalr	-1660(ra) # 8000422e <end_op>
      return -1;
    800058b2:	54fd                	li	s1,-1
    800058b4:	bf79                	j	80005852 <sys_open+0xe2>
    iunlockput(ip);
    800058b6:	854a                	mv	a0,s2
    800058b8:	ffffe097          	auipc	ra,0xffffe
    800058bc:	1be080e7          	jalr	446(ra) # 80003a76 <iunlockput>
    end_op();
    800058c0:	fffff097          	auipc	ra,0xfffff
    800058c4:	96e080e7          	jalr	-1682(ra) # 8000422e <end_op>
    return -1;
    800058c8:	54fd                	li	s1,-1
    800058ca:	b761                	j	80005852 <sys_open+0xe2>
      fileclose(f);
    800058cc:	854e                	mv	a0,s3
    800058ce:	fffff097          	auipc	ra,0xfffff
    800058d2:	db0080e7          	jalr	-592(ra) # 8000467e <fileclose>
    iunlockput(ip);
    800058d6:	854a                	mv	a0,s2
    800058d8:	ffffe097          	auipc	ra,0xffffe
    800058dc:	19e080e7          	jalr	414(ra) # 80003a76 <iunlockput>
    end_op();
    800058e0:	fffff097          	auipc	ra,0xfffff
    800058e4:	94e080e7          	jalr	-1714(ra) # 8000422e <end_op>
    return -1;
    800058e8:	54fd                	li	s1,-1
    800058ea:	b7a5                	j	80005852 <sys_open+0xe2>
    f->type = FD_DEVICE;
    800058ec:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    800058f0:	04691783          	lh	a5,70(s2)
    800058f4:	02f99223          	sh	a5,36(s3)
    800058f8:	bf29                	j	80005812 <sys_open+0xa2>
    itrunc(ip);
    800058fa:	854a                	mv	a0,s2
    800058fc:	ffffe097          	auipc	ra,0xffffe
    80005900:	026080e7          	jalr	38(ra) # 80003922 <itrunc>
    80005904:	bf35                	j	80005840 <sys_open+0xd0>

0000000080005906 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005906:	7175                	add	sp,sp,-144
    80005908:	e506                	sd	ra,136(sp)
    8000590a:	e122                	sd	s0,128(sp)
    8000590c:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000590e:	fffff097          	auipc	ra,0xfffff
    80005912:	8a6080e7          	jalr	-1882(ra) # 800041b4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005916:	08000613          	li	a2,128
    8000591a:	f7040593          	add	a1,s0,-144
    8000591e:	4501                	li	a0,0
    80005920:	ffffd097          	auipc	ra,0xffffd
    80005924:	362080e7          	jalr	866(ra) # 80002c82 <argstr>
    80005928:	02054963          	bltz	a0,8000595a <sys_mkdir+0x54>
    8000592c:	4681                	li	a3,0
    8000592e:	4601                	li	a2,0
    80005930:	4585                	li	a1,1
    80005932:	f7040513          	add	a0,s0,-144
    80005936:	00000097          	auipc	ra,0x0
    8000593a:	802080e7          	jalr	-2046(ra) # 80005138 <create>
    8000593e:	cd11                	beqz	a0,8000595a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005940:	ffffe097          	auipc	ra,0xffffe
    80005944:	136080e7          	jalr	310(ra) # 80003a76 <iunlockput>
  end_op();
    80005948:	fffff097          	auipc	ra,0xfffff
    8000594c:	8e6080e7          	jalr	-1818(ra) # 8000422e <end_op>
  return 0;
    80005950:	4501                	li	a0,0
}
    80005952:	60aa                	ld	ra,136(sp)
    80005954:	640a                	ld	s0,128(sp)
    80005956:	6149                	add	sp,sp,144
    80005958:	8082                	ret
    end_op();
    8000595a:	fffff097          	auipc	ra,0xfffff
    8000595e:	8d4080e7          	jalr	-1836(ra) # 8000422e <end_op>
    return -1;
    80005962:	557d                	li	a0,-1
    80005964:	b7fd                	j	80005952 <sys_mkdir+0x4c>

0000000080005966 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005966:	7135                	add	sp,sp,-160
    80005968:	ed06                	sd	ra,152(sp)
    8000596a:	e922                	sd	s0,144(sp)
    8000596c:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000596e:	fffff097          	auipc	ra,0xfffff
    80005972:	846080e7          	jalr	-1978(ra) # 800041b4 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005976:	08000613          	li	a2,128
    8000597a:	f7040593          	add	a1,s0,-144
    8000597e:	4501                	li	a0,0
    80005980:	ffffd097          	auipc	ra,0xffffd
    80005984:	302080e7          	jalr	770(ra) # 80002c82 <argstr>
    80005988:	04054a63          	bltz	a0,800059dc <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    8000598c:	f6c40593          	add	a1,s0,-148
    80005990:	4505                	li	a0,1
    80005992:	ffffd097          	auipc	ra,0xffffd
    80005996:	2ac080e7          	jalr	684(ra) # 80002c3e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000599a:	04054163          	bltz	a0,800059dc <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    8000599e:	f6840593          	add	a1,s0,-152
    800059a2:	4509                	li	a0,2
    800059a4:	ffffd097          	auipc	ra,0xffffd
    800059a8:	29a080e7          	jalr	666(ra) # 80002c3e <argint>
     argint(1, &major) < 0 ||
    800059ac:	02054863          	bltz	a0,800059dc <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800059b0:	f6841683          	lh	a3,-152(s0)
    800059b4:	f6c41603          	lh	a2,-148(s0)
    800059b8:	458d                	li	a1,3
    800059ba:	f7040513          	add	a0,s0,-144
    800059be:	fffff097          	auipc	ra,0xfffff
    800059c2:	77a080e7          	jalr	1914(ra) # 80005138 <create>
     argint(2, &minor) < 0 ||
    800059c6:	c919                	beqz	a0,800059dc <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800059c8:	ffffe097          	auipc	ra,0xffffe
    800059cc:	0ae080e7          	jalr	174(ra) # 80003a76 <iunlockput>
  end_op();
    800059d0:	fffff097          	auipc	ra,0xfffff
    800059d4:	85e080e7          	jalr	-1954(ra) # 8000422e <end_op>
  return 0;
    800059d8:	4501                	li	a0,0
    800059da:	a031                	j	800059e6 <sys_mknod+0x80>
    end_op();
    800059dc:	fffff097          	auipc	ra,0xfffff
    800059e0:	852080e7          	jalr	-1966(ra) # 8000422e <end_op>
    return -1;
    800059e4:	557d                	li	a0,-1
}
    800059e6:	60ea                	ld	ra,152(sp)
    800059e8:	644a                	ld	s0,144(sp)
    800059ea:	610d                	add	sp,sp,160
    800059ec:	8082                	ret

00000000800059ee <sys_chdir>:

uint64
sys_chdir(void)
{
    800059ee:	7135                	add	sp,sp,-160
    800059f0:	ed06                	sd	ra,152(sp)
    800059f2:	e922                	sd	s0,144(sp)
    800059f4:	e526                	sd	s1,136(sp)
    800059f6:	e14a                	sd	s2,128(sp)
    800059f8:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800059fa:	ffffc097          	auipc	ra,0xffffc
    800059fe:	040080e7          	jalr	64(ra) # 80001a3a <myproc>
    80005a02:	892a                	mv	s2,a0
  
  begin_op();
    80005a04:	ffffe097          	auipc	ra,0xffffe
    80005a08:	7b0080e7          	jalr	1968(ra) # 800041b4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005a0c:	08000613          	li	a2,128
    80005a10:	f6040593          	add	a1,s0,-160
    80005a14:	4501                	li	a0,0
    80005a16:	ffffd097          	auipc	ra,0xffffd
    80005a1a:	26c080e7          	jalr	620(ra) # 80002c82 <argstr>
    80005a1e:	04054b63          	bltz	a0,80005a74 <sys_chdir+0x86>
    80005a22:	f6040513          	add	a0,s0,-160
    80005a26:	ffffe097          	auipc	ra,0xffffe
    80005a2a:	59e080e7          	jalr	1438(ra) # 80003fc4 <namei>
    80005a2e:	84aa                	mv	s1,a0
    80005a30:	c131                	beqz	a0,80005a74 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005a32:	ffffe097          	auipc	ra,0xffffe
    80005a36:	de2080e7          	jalr	-542(ra) # 80003814 <ilock>
  if(ip->type != T_DIR){
    80005a3a:	04449703          	lh	a4,68(s1)
    80005a3e:	4785                	li	a5,1
    80005a40:	04f71063          	bne	a4,a5,80005a80 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005a44:	8526                	mv	a0,s1
    80005a46:	ffffe097          	auipc	ra,0xffffe
    80005a4a:	e90080e7          	jalr	-368(ra) # 800038d6 <iunlock>
  iput(p->cwd);
    80005a4e:	15093503          	ld	a0,336(s2)
    80005a52:	ffffe097          	auipc	ra,0xffffe
    80005a56:	f7c080e7          	jalr	-132(ra) # 800039ce <iput>
  end_op();
    80005a5a:	ffffe097          	auipc	ra,0xffffe
    80005a5e:	7d4080e7          	jalr	2004(ra) # 8000422e <end_op>
  p->cwd = ip;
    80005a62:	14993823          	sd	s1,336(s2)
  return 0;
    80005a66:	4501                	li	a0,0
}
    80005a68:	60ea                	ld	ra,152(sp)
    80005a6a:	644a                	ld	s0,144(sp)
    80005a6c:	64aa                	ld	s1,136(sp)
    80005a6e:	690a                	ld	s2,128(sp)
    80005a70:	610d                	add	sp,sp,160
    80005a72:	8082                	ret
    end_op();
    80005a74:	ffffe097          	auipc	ra,0xffffe
    80005a78:	7ba080e7          	jalr	1978(ra) # 8000422e <end_op>
    return -1;
    80005a7c:	557d                	li	a0,-1
    80005a7e:	b7ed                	j	80005a68 <sys_chdir+0x7a>
    iunlockput(ip);
    80005a80:	8526                	mv	a0,s1
    80005a82:	ffffe097          	auipc	ra,0xffffe
    80005a86:	ff4080e7          	jalr	-12(ra) # 80003a76 <iunlockput>
    end_op();
    80005a8a:	ffffe097          	auipc	ra,0xffffe
    80005a8e:	7a4080e7          	jalr	1956(ra) # 8000422e <end_op>
    return -1;
    80005a92:	557d                	li	a0,-1
    80005a94:	bfd1                	j	80005a68 <sys_chdir+0x7a>

0000000080005a96 <sys_exec>:

uint64
sys_exec(void)
{
    80005a96:	7121                	add	sp,sp,-448
    80005a98:	ff06                	sd	ra,440(sp)
    80005a9a:	fb22                	sd	s0,432(sp)
    80005a9c:	f726                	sd	s1,424(sp)
    80005a9e:	f34a                	sd	s2,416(sp)
    80005aa0:	ef4e                	sd	s3,408(sp)
    80005aa2:	eb52                	sd	s4,400(sp)
    80005aa4:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005aa6:	08000613          	li	a2,128
    80005aaa:	f5040593          	add	a1,s0,-176
    80005aae:	4501                	li	a0,0
    80005ab0:	ffffd097          	auipc	ra,0xffffd
    80005ab4:	1d2080e7          	jalr	466(ra) # 80002c82 <argstr>
    return -1;
    80005ab8:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005aba:	0c054a63          	bltz	a0,80005b8e <sys_exec+0xf8>
    80005abe:	e4840593          	add	a1,s0,-440
    80005ac2:	4505                	li	a0,1
    80005ac4:	ffffd097          	auipc	ra,0xffffd
    80005ac8:	19c080e7          	jalr	412(ra) # 80002c60 <argaddr>
    80005acc:	0c054163          	bltz	a0,80005b8e <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80005ad0:	10000613          	li	a2,256
    80005ad4:	4581                	li	a1,0
    80005ad6:	e5040513          	add	a0,s0,-432
    80005ada:	ffffb097          	auipc	ra,0xffffb
    80005ade:	292080e7          	jalr	658(ra) # 80000d6c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005ae2:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005ae6:	89a6                	mv	s3,s1
    80005ae8:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005aea:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005aee:	00391513          	sll	a0,s2,0x3
    80005af2:	e4040593          	add	a1,s0,-448
    80005af6:	e4843783          	ld	a5,-440(s0)
    80005afa:	953e                	add	a0,a0,a5
    80005afc:	ffffd097          	auipc	ra,0xffffd
    80005b00:	0a8080e7          	jalr	168(ra) # 80002ba4 <fetchaddr>
    80005b04:	02054a63          	bltz	a0,80005b38 <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80005b08:	e4043783          	ld	a5,-448(s0)
    80005b0c:	c3b9                	beqz	a5,80005b52 <sys_exec+0xbc>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005b0e:	ffffb097          	auipc	ra,0xffffb
    80005b12:	072080e7          	jalr	114(ra) # 80000b80 <kalloc>
    80005b16:	85aa                	mv	a1,a0
    80005b18:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005b1c:	cd11                	beqz	a0,80005b38 <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005b1e:	6605                	lui	a2,0x1
    80005b20:	e4043503          	ld	a0,-448(s0)
    80005b24:	ffffd097          	auipc	ra,0xffffd
    80005b28:	0d2080e7          	jalr	210(ra) # 80002bf6 <fetchstr>
    80005b2c:	00054663          	bltz	a0,80005b38 <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80005b30:	0905                	add	s2,s2,1
    80005b32:	09a1                	add	s3,s3,8
    80005b34:	fb491de3          	bne	s2,s4,80005aee <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b38:	f5040913          	add	s2,s0,-176
    80005b3c:	6088                	ld	a0,0(s1)
    80005b3e:	c539                	beqz	a0,80005b8c <sys_exec+0xf6>
    kfree(argv[i]);
    80005b40:	ffffb097          	auipc	ra,0xffffb
    80005b44:	f42080e7          	jalr	-190(ra) # 80000a82 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b48:	04a1                	add	s1,s1,8
    80005b4a:	ff2499e3          	bne	s1,s2,80005b3c <sys_exec+0xa6>
  return -1;
    80005b4e:	597d                	li	s2,-1
    80005b50:	a83d                	j	80005b8e <sys_exec+0xf8>
      argv[i] = 0;
    80005b52:	0009079b          	sext.w	a5,s2
    80005b56:	078e                	sll	a5,a5,0x3
    80005b58:	fd078793          	add	a5,a5,-48
    80005b5c:	97a2                	add	a5,a5,s0
    80005b5e:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005b62:	e5040593          	add	a1,s0,-432
    80005b66:	f5040513          	add	a0,s0,-176
    80005b6a:	fffff097          	auipc	ra,0xfffff
    80005b6e:	196080e7          	jalr	406(ra) # 80004d00 <exec>
    80005b72:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b74:	f5040993          	add	s3,s0,-176
    80005b78:	6088                	ld	a0,0(s1)
    80005b7a:	c911                	beqz	a0,80005b8e <sys_exec+0xf8>
    kfree(argv[i]);
    80005b7c:	ffffb097          	auipc	ra,0xffffb
    80005b80:	f06080e7          	jalr	-250(ra) # 80000a82 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b84:	04a1                	add	s1,s1,8
    80005b86:	ff3499e3          	bne	s1,s3,80005b78 <sys_exec+0xe2>
    80005b8a:	a011                	j	80005b8e <sys_exec+0xf8>
  return -1;
    80005b8c:	597d                	li	s2,-1
}
    80005b8e:	854a                	mv	a0,s2
    80005b90:	70fa                	ld	ra,440(sp)
    80005b92:	745a                	ld	s0,432(sp)
    80005b94:	74ba                	ld	s1,424(sp)
    80005b96:	791a                	ld	s2,416(sp)
    80005b98:	69fa                	ld	s3,408(sp)
    80005b9a:	6a5a                	ld	s4,400(sp)
    80005b9c:	6139                	add	sp,sp,448
    80005b9e:	8082                	ret

0000000080005ba0 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005ba0:	7139                	add	sp,sp,-64
    80005ba2:	fc06                	sd	ra,56(sp)
    80005ba4:	f822                	sd	s0,48(sp)
    80005ba6:	f426                	sd	s1,40(sp)
    80005ba8:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005baa:	ffffc097          	auipc	ra,0xffffc
    80005bae:	e90080e7          	jalr	-368(ra) # 80001a3a <myproc>
    80005bb2:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005bb4:	fd840593          	add	a1,s0,-40
    80005bb8:	4501                	li	a0,0
    80005bba:	ffffd097          	auipc	ra,0xffffd
    80005bbe:	0a6080e7          	jalr	166(ra) # 80002c60 <argaddr>
    return -1;
    80005bc2:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005bc4:	0e054063          	bltz	a0,80005ca4 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005bc8:	fc840593          	add	a1,s0,-56
    80005bcc:	fd040513          	add	a0,s0,-48
    80005bd0:	fffff097          	auipc	ra,0xfffff
    80005bd4:	e04080e7          	jalr	-508(ra) # 800049d4 <pipealloc>
    return -1;
    80005bd8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005bda:	0c054563          	bltz	a0,80005ca4 <sys_pipe+0x104>
  fd0 = -1;
    80005bde:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005be2:	fd043503          	ld	a0,-48(s0)
    80005be6:	fffff097          	auipc	ra,0xfffff
    80005bea:	510080e7          	jalr	1296(ra) # 800050f6 <fdalloc>
    80005bee:	fca42223          	sw	a0,-60(s0)
    80005bf2:	08054c63          	bltz	a0,80005c8a <sys_pipe+0xea>
    80005bf6:	fc843503          	ld	a0,-56(s0)
    80005bfa:	fffff097          	auipc	ra,0xfffff
    80005bfe:	4fc080e7          	jalr	1276(ra) # 800050f6 <fdalloc>
    80005c02:	fca42023          	sw	a0,-64(s0)
    80005c06:	06054963          	bltz	a0,80005c78 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005c0a:	4691                	li	a3,4
    80005c0c:	fc440613          	add	a2,s0,-60
    80005c10:	fd843583          	ld	a1,-40(s0)
    80005c14:	68a8                	ld	a0,80(s1)
    80005c16:	ffffc097          	auipc	ra,0xffffc
    80005c1a:	b1a080e7          	jalr	-1254(ra) # 80001730 <copyout>
    80005c1e:	02054063          	bltz	a0,80005c3e <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005c22:	4691                	li	a3,4
    80005c24:	fc040613          	add	a2,s0,-64
    80005c28:	fd843583          	ld	a1,-40(s0)
    80005c2c:	0591                	add	a1,a1,4
    80005c2e:	68a8                	ld	a0,80(s1)
    80005c30:	ffffc097          	auipc	ra,0xffffc
    80005c34:	b00080e7          	jalr	-1280(ra) # 80001730 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005c38:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005c3a:	06055563          	bgez	a0,80005ca4 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005c3e:	fc442783          	lw	a5,-60(s0)
    80005c42:	07e9                	add	a5,a5,26
    80005c44:	078e                	sll	a5,a5,0x3
    80005c46:	97a6                	add	a5,a5,s1
    80005c48:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005c4c:	fc042783          	lw	a5,-64(s0)
    80005c50:	07e9                	add	a5,a5,26
    80005c52:	078e                	sll	a5,a5,0x3
    80005c54:	00f48533          	add	a0,s1,a5
    80005c58:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005c5c:	fd043503          	ld	a0,-48(s0)
    80005c60:	fffff097          	auipc	ra,0xfffff
    80005c64:	a1e080e7          	jalr	-1506(ra) # 8000467e <fileclose>
    fileclose(wf);
    80005c68:	fc843503          	ld	a0,-56(s0)
    80005c6c:	fffff097          	auipc	ra,0xfffff
    80005c70:	a12080e7          	jalr	-1518(ra) # 8000467e <fileclose>
    return -1;
    80005c74:	57fd                	li	a5,-1
    80005c76:	a03d                	j	80005ca4 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005c78:	fc442783          	lw	a5,-60(s0)
    80005c7c:	0007c763          	bltz	a5,80005c8a <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005c80:	07e9                	add	a5,a5,26
    80005c82:	078e                	sll	a5,a5,0x3
    80005c84:	97a6                	add	a5,a5,s1
    80005c86:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005c8a:	fd043503          	ld	a0,-48(s0)
    80005c8e:	fffff097          	auipc	ra,0xfffff
    80005c92:	9f0080e7          	jalr	-1552(ra) # 8000467e <fileclose>
    fileclose(wf);
    80005c96:	fc843503          	ld	a0,-56(s0)
    80005c9a:	fffff097          	auipc	ra,0xfffff
    80005c9e:	9e4080e7          	jalr	-1564(ra) # 8000467e <fileclose>
    return -1;
    80005ca2:	57fd                	li	a5,-1
}
    80005ca4:	853e                	mv	a0,a5
    80005ca6:	70e2                	ld	ra,56(sp)
    80005ca8:	7442                	ld	s0,48(sp)
    80005caa:	74a2                	ld	s1,40(sp)
    80005cac:	6121                	add	sp,sp,64
    80005cae:	8082                	ret

0000000080005cb0 <kernelvec>:
    80005cb0:	7111                	add	sp,sp,-256
    80005cb2:	e006                	sd	ra,0(sp)
    80005cb4:	e40a                	sd	sp,8(sp)
    80005cb6:	e80e                	sd	gp,16(sp)
    80005cb8:	ec12                	sd	tp,24(sp)
    80005cba:	f016                	sd	t0,32(sp)
    80005cbc:	f41a                	sd	t1,40(sp)
    80005cbe:	f81e                	sd	t2,48(sp)
    80005cc0:	fc22                	sd	s0,56(sp)
    80005cc2:	e0a6                	sd	s1,64(sp)
    80005cc4:	e4aa                	sd	a0,72(sp)
    80005cc6:	e8ae                	sd	a1,80(sp)
    80005cc8:	ecb2                	sd	a2,88(sp)
    80005cca:	f0b6                	sd	a3,96(sp)
    80005ccc:	f4ba                	sd	a4,104(sp)
    80005cce:	f8be                	sd	a5,112(sp)
    80005cd0:	fcc2                	sd	a6,120(sp)
    80005cd2:	e146                	sd	a7,128(sp)
    80005cd4:	e54a                	sd	s2,136(sp)
    80005cd6:	e94e                	sd	s3,144(sp)
    80005cd8:	ed52                	sd	s4,152(sp)
    80005cda:	f156                	sd	s5,160(sp)
    80005cdc:	f55a                	sd	s6,168(sp)
    80005cde:	f95e                	sd	s7,176(sp)
    80005ce0:	fd62                	sd	s8,184(sp)
    80005ce2:	e1e6                	sd	s9,192(sp)
    80005ce4:	e5ea                	sd	s10,200(sp)
    80005ce6:	e9ee                	sd	s11,208(sp)
    80005ce8:	edf2                	sd	t3,216(sp)
    80005cea:	f1f6                	sd	t4,224(sp)
    80005cec:	f5fa                	sd	t5,232(sp)
    80005cee:	f9fe                	sd	t6,240(sp)
    80005cf0:	d01fc0ef          	jal	800029f0 <kerneltrap>
    80005cf4:	6082                	ld	ra,0(sp)
    80005cf6:	6122                	ld	sp,8(sp)
    80005cf8:	61c2                	ld	gp,16(sp)
    80005cfa:	7282                	ld	t0,32(sp)
    80005cfc:	7322                	ld	t1,40(sp)
    80005cfe:	73c2                	ld	t2,48(sp)
    80005d00:	7462                	ld	s0,56(sp)
    80005d02:	6486                	ld	s1,64(sp)
    80005d04:	6526                	ld	a0,72(sp)
    80005d06:	65c6                	ld	a1,80(sp)
    80005d08:	6666                	ld	a2,88(sp)
    80005d0a:	7686                	ld	a3,96(sp)
    80005d0c:	7726                	ld	a4,104(sp)
    80005d0e:	77c6                	ld	a5,112(sp)
    80005d10:	7866                	ld	a6,120(sp)
    80005d12:	688a                	ld	a7,128(sp)
    80005d14:	692a                	ld	s2,136(sp)
    80005d16:	69ca                	ld	s3,144(sp)
    80005d18:	6a6a                	ld	s4,152(sp)
    80005d1a:	7a8a                	ld	s5,160(sp)
    80005d1c:	7b2a                	ld	s6,168(sp)
    80005d1e:	7bca                	ld	s7,176(sp)
    80005d20:	7c6a                	ld	s8,184(sp)
    80005d22:	6c8e                	ld	s9,192(sp)
    80005d24:	6d2e                	ld	s10,200(sp)
    80005d26:	6dce                	ld	s11,208(sp)
    80005d28:	6e6e                	ld	t3,216(sp)
    80005d2a:	7e8e                	ld	t4,224(sp)
    80005d2c:	7f2e                	ld	t5,232(sp)
    80005d2e:	7fce                	ld	t6,240(sp)
    80005d30:	6111                	add	sp,sp,256
    80005d32:	10200073          	sret
    80005d36:	00000013          	nop
    80005d3a:	00000013          	nop
    80005d3e:	0001                	nop

0000000080005d40 <timervec>:
    80005d40:	34051573          	csrrw	a0,mscratch,a0
    80005d44:	e10c                	sd	a1,0(a0)
    80005d46:	e510                	sd	a2,8(a0)
    80005d48:	e914                	sd	a3,16(a0)
    80005d4a:	710c                	ld	a1,32(a0)
    80005d4c:	7510                	ld	a2,40(a0)
    80005d4e:	6194                	ld	a3,0(a1)
    80005d50:	96b2                	add	a3,a3,a2
    80005d52:	e194                	sd	a3,0(a1)
    80005d54:	4589                	li	a1,2
    80005d56:	14459073          	csrw	sip,a1
    80005d5a:	6914                	ld	a3,16(a0)
    80005d5c:	6510                	ld	a2,8(a0)
    80005d5e:	610c                	ld	a1,0(a0)
    80005d60:	34051573          	csrrw	a0,mscratch,a0
    80005d64:	30200073          	mret
	...

0000000080005d6a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005d6a:	1141                	add	sp,sp,-16
    80005d6c:	e422                	sd	s0,8(sp)
    80005d6e:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005d70:	0c0007b7          	lui	a5,0xc000
    80005d74:	4705                	li	a4,1
    80005d76:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005d78:	c3d8                	sw	a4,4(a5)
}
    80005d7a:	6422                	ld	s0,8(sp)
    80005d7c:	0141                	add	sp,sp,16
    80005d7e:	8082                	ret

0000000080005d80 <plicinithart>:

void
plicinithart(void)
{
    80005d80:	1141                	add	sp,sp,-16
    80005d82:	e406                	sd	ra,8(sp)
    80005d84:	e022                	sd	s0,0(sp)
    80005d86:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005d88:	ffffc097          	auipc	ra,0xffffc
    80005d8c:	c86080e7          	jalr	-890(ra) # 80001a0e <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005d90:	0085171b          	sllw	a4,a0,0x8
    80005d94:	0c0027b7          	lui	a5,0xc002
    80005d98:	97ba                	add	a5,a5,a4
    80005d9a:	40200713          	li	a4,1026
    80005d9e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005da2:	00d5151b          	sllw	a0,a0,0xd
    80005da6:	0c2017b7          	lui	a5,0xc201
    80005daa:	97aa                	add	a5,a5,a0
    80005dac:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005db0:	60a2                	ld	ra,8(sp)
    80005db2:	6402                	ld	s0,0(sp)
    80005db4:	0141                	add	sp,sp,16
    80005db6:	8082                	ret

0000000080005db8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005db8:	1141                	add	sp,sp,-16
    80005dba:	e406                	sd	ra,8(sp)
    80005dbc:	e022                	sd	s0,0(sp)
    80005dbe:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005dc0:	ffffc097          	auipc	ra,0xffffc
    80005dc4:	c4e080e7          	jalr	-946(ra) # 80001a0e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005dc8:	00d5151b          	sllw	a0,a0,0xd
    80005dcc:	0c2017b7          	lui	a5,0xc201
    80005dd0:	97aa                	add	a5,a5,a0
  return irq;
}
    80005dd2:	43c8                	lw	a0,4(a5)
    80005dd4:	60a2                	ld	ra,8(sp)
    80005dd6:	6402                	ld	s0,0(sp)
    80005dd8:	0141                	add	sp,sp,16
    80005dda:	8082                	ret

0000000080005ddc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005ddc:	1101                	add	sp,sp,-32
    80005dde:	ec06                	sd	ra,24(sp)
    80005de0:	e822                	sd	s0,16(sp)
    80005de2:	e426                	sd	s1,8(sp)
    80005de4:	1000                	add	s0,sp,32
    80005de6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005de8:	ffffc097          	auipc	ra,0xffffc
    80005dec:	c26080e7          	jalr	-986(ra) # 80001a0e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005df0:	00d5151b          	sllw	a0,a0,0xd
    80005df4:	0c2017b7          	lui	a5,0xc201
    80005df8:	97aa                	add	a5,a5,a0
    80005dfa:	c3c4                	sw	s1,4(a5)
}
    80005dfc:	60e2                	ld	ra,24(sp)
    80005dfe:	6442                	ld	s0,16(sp)
    80005e00:	64a2                	ld	s1,8(sp)
    80005e02:	6105                	add	sp,sp,32
    80005e04:	8082                	ret

0000000080005e06 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005e06:	1141                	add	sp,sp,-16
    80005e08:	e406                	sd	ra,8(sp)
    80005e0a:	e022                	sd	s0,0(sp)
    80005e0c:	0800                	add	s0,sp,16
  if(i >= NUM)
    80005e0e:	479d                	li	a5,7
    80005e10:	04a7cb63          	blt	a5,a0,80005e66 <free_desc+0x60>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80005e14:	0001e717          	auipc	a4,0x1e
    80005e18:	1ec70713          	add	a4,a4,492 # 80024000 <disk>
    80005e1c:	972a                	add	a4,a4,a0
    80005e1e:	6789                	lui	a5,0x2
    80005e20:	97ba                	add	a5,a5,a4
    80005e22:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005e26:	eba1                	bnez	a5,80005e76 <free_desc+0x70>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    80005e28:	00451713          	sll	a4,a0,0x4
    80005e2c:	00020797          	auipc	a5,0x20
    80005e30:	1d47b783          	ld	a5,468(a5) # 80026000 <disk+0x2000>
    80005e34:	97ba                	add	a5,a5,a4
    80005e36:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    80005e3a:	0001e717          	auipc	a4,0x1e
    80005e3e:	1c670713          	add	a4,a4,454 # 80024000 <disk>
    80005e42:	972a                	add	a4,a4,a0
    80005e44:	6789                	lui	a5,0x2
    80005e46:	97ba                	add	a5,a5,a4
    80005e48:	4705                	li	a4,1
    80005e4a:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005e4e:	00020517          	auipc	a0,0x20
    80005e52:	1ca50513          	add	a0,a0,458 # 80026018 <disk+0x2018>
    80005e56:	ffffc097          	auipc	ra,0xffffc
    80005e5a:	5c4080e7          	jalr	1476(ra) # 8000241a <wakeup>
}
    80005e5e:	60a2                	ld	ra,8(sp)
    80005e60:	6402                	ld	s0,0(sp)
    80005e62:	0141                	add	sp,sp,16
    80005e64:	8082                	ret
    panic("virtio_disk_intr 1");
    80005e66:	00003517          	auipc	a0,0x3
    80005e6a:	91a50513          	add	a0,a0,-1766 # 80008780 <syscalls+0x340>
    80005e6e:	ffffa097          	auipc	ra,0xffffa
    80005e72:	772080e7          	jalr	1906(ra) # 800005e0 <panic>
    panic("virtio_disk_intr 2");
    80005e76:	00003517          	auipc	a0,0x3
    80005e7a:	92250513          	add	a0,a0,-1758 # 80008798 <syscalls+0x358>
    80005e7e:	ffffa097          	auipc	ra,0xffffa
    80005e82:	762080e7          	jalr	1890(ra) # 800005e0 <panic>

0000000080005e86 <virtio_disk_init>:
{
    80005e86:	1101                	add	sp,sp,-32
    80005e88:	ec06                	sd	ra,24(sp)
    80005e8a:	e822                	sd	s0,16(sp)
    80005e8c:	e426                	sd	s1,8(sp)
    80005e8e:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005e90:	00003597          	auipc	a1,0x3
    80005e94:	92058593          	add	a1,a1,-1760 # 800087b0 <syscalls+0x370>
    80005e98:	00020517          	auipc	a0,0x20
    80005e9c:	21050513          	add	a0,a0,528 # 800260a8 <disk+0x20a8>
    80005ea0:	ffffb097          	auipc	ra,0xffffb
    80005ea4:	d40080e7          	jalr	-704(ra) # 80000be0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005ea8:	100017b7          	lui	a5,0x10001
    80005eac:	4398                	lw	a4,0(a5)
    80005eae:	2701                	sext.w	a4,a4
    80005eb0:	747277b7          	lui	a5,0x74727
    80005eb4:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005eb8:	0ef71063          	bne	a4,a5,80005f98 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005ebc:	100017b7          	lui	a5,0x10001
    80005ec0:	43dc                	lw	a5,4(a5)
    80005ec2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005ec4:	4705                	li	a4,1
    80005ec6:	0ce79963          	bne	a5,a4,80005f98 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005eca:	100017b7          	lui	a5,0x10001
    80005ece:	479c                	lw	a5,8(a5)
    80005ed0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005ed2:	4709                	li	a4,2
    80005ed4:	0ce79263          	bne	a5,a4,80005f98 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005ed8:	100017b7          	lui	a5,0x10001
    80005edc:	47d8                	lw	a4,12(a5)
    80005ede:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005ee0:	554d47b7          	lui	a5,0x554d4
    80005ee4:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005ee8:	0af71863          	bne	a4,a5,80005f98 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005eec:	100017b7          	lui	a5,0x10001
    80005ef0:	4705                	li	a4,1
    80005ef2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005ef4:	470d                	li	a4,3
    80005ef6:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005ef8:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005efa:	c7ffe6b7          	lui	a3,0xc7ffe
    80005efe:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd775f>
    80005f02:	8f75                	and	a4,a4,a3
    80005f04:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f06:	472d                	li	a4,11
    80005f08:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f0a:	473d                	li	a4,15
    80005f0c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005f0e:	6705                	lui	a4,0x1
    80005f10:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005f12:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005f16:	5bdc                	lw	a5,52(a5)
    80005f18:	2781                	sext.w	a5,a5
  if(max == 0)
    80005f1a:	c7d9                	beqz	a5,80005fa8 <virtio_disk_init+0x122>
  if(max < NUM)
    80005f1c:	471d                	li	a4,7
    80005f1e:	08f77d63          	bgeu	a4,a5,80005fb8 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005f22:	100014b7          	lui	s1,0x10001
    80005f26:	47a1                	li	a5,8
    80005f28:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005f2a:	6609                	lui	a2,0x2
    80005f2c:	4581                	li	a1,0
    80005f2e:	0001e517          	auipc	a0,0x1e
    80005f32:	0d250513          	add	a0,a0,210 # 80024000 <disk>
    80005f36:	ffffb097          	auipc	ra,0xffffb
    80005f3a:	e36080e7          	jalr	-458(ra) # 80000d6c <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005f3e:	0001e717          	auipc	a4,0x1e
    80005f42:	0c270713          	add	a4,a4,194 # 80024000 <disk>
    80005f46:	00c75793          	srl	a5,a4,0xc
    80005f4a:	2781                	sext.w	a5,a5
    80005f4c:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    80005f4e:	00020797          	auipc	a5,0x20
    80005f52:	0b278793          	add	a5,a5,178 # 80026000 <disk+0x2000>
    80005f56:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    80005f58:	0001e717          	auipc	a4,0x1e
    80005f5c:	12870713          	add	a4,a4,296 # 80024080 <disk+0x80>
    80005f60:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    80005f62:	0001f717          	auipc	a4,0x1f
    80005f66:	09e70713          	add	a4,a4,158 # 80025000 <disk+0x1000>
    80005f6a:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005f6c:	4705                	li	a4,1
    80005f6e:	00e78c23          	sb	a4,24(a5)
    80005f72:	00e78ca3          	sb	a4,25(a5)
    80005f76:	00e78d23          	sb	a4,26(a5)
    80005f7a:	00e78da3          	sb	a4,27(a5)
    80005f7e:	00e78e23          	sb	a4,28(a5)
    80005f82:	00e78ea3          	sb	a4,29(a5)
    80005f86:	00e78f23          	sb	a4,30(a5)
    80005f8a:	00e78fa3          	sb	a4,31(a5)
}
    80005f8e:	60e2                	ld	ra,24(sp)
    80005f90:	6442                	ld	s0,16(sp)
    80005f92:	64a2                	ld	s1,8(sp)
    80005f94:	6105                	add	sp,sp,32
    80005f96:	8082                	ret
    panic("could not find virtio disk");
    80005f98:	00003517          	auipc	a0,0x3
    80005f9c:	82850513          	add	a0,a0,-2008 # 800087c0 <syscalls+0x380>
    80005fa0:	ffffa097          	auipc	ra,0xffffa
    80005fa4:	640080e7          	jalr	1600(ra) # 800005e0 <panic>
    panic("virtio disk has no queue 0");
    80005fa8:	00003517          	auipc	a0,0x3
    80005fac:	83850513          	add	a0,a0,-1992 # 800087e0 <syscalls+0x3a0>
    80005fb0:	ffffa097          	auipc	ra,0xffffa
    80005fb4:	630080e7          	jalr	1584(ra) # 800005e0 <panic>
    panic("virtio disk max queue too short");
    80005fb8:	00003517          	auipc	a0,0x3
    80005fbc:	84850513          	add	a0,a0,-1976 # 80008800 <syscalls+0x3c0>
    80005fc0:	ffffa097          	auipc	ra,0xffffa
    80005fc4:	620080e7          	jalr	1568(ra) # 800005e0 <panic>

0000000080005fc8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005fc8:	7119                	add	sp,sp,-128
    80005fca:	fc86                	sd	ra,120(sp)
    80005fcc:	f8a2                	sd	s0,112(sp)
    80005fce:	f4a6                	sd	s1,104(sp)
    80005fd0:	f0ca                	sd	s2,96(sp)
    80005fd2:	ecce                	sd	s3,88(sp)
    80005fd4:	e8d2                	sd	s4,80(sp)
    80005fd6:	e4d6                	sd	s5,72(sp)
    80005fd8:	e0da                	sd	s6,64(sp)
    80005fda:	fc5e                	sd	s7,56(sp)
    80005fdc:	f862                	sd	s8,48(sp)
    80005fde:	f466                	sd	s9,40(sp)
    80005fe0:	f06a                	sd	s10,32(sp)
    80005fe2:	0100                	add	s0,sp,128
    80005fe4:	8a2a                	mv	s4,a0
    80005fe6:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005fe8:	00c52c03          	lw	s8,12(a0)
    80005fec:	001c1c1b          	sllw	s8,s8,0x1
    80005ff0:	1c02                	sll	s8,s8,0x20
    80005ff2:	020c5c13          	srl	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    80005ff6:	00020517          	auipc	a0,0x20
    80005ffa:	0b250513          	add	a0,a0,178 # 800260a8 <disk+0x20a8>
    80005ffe:	ffffb097          	auipc	ra,0xffffb
    80006002:	c72080e7          	jalr	-910(ra) # 80000c70 <acquire>
  for(int i = 0; i < 3; i++){
    80006006:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80006008:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000600a:	0001eb97          	auipc	s7,0x1e
    8000600e:	ff6b8b93          	add	s7,s7,-10 # 80024000 <disk>
    80006012:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80006014:	4a8d                	li	s5,3
    80006016:	a0b5                	j	80006082 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80006018:	00fb8733          	add	a4,s7,a5
    8000601c:	975a                	add	a4,a4,s6
    8000601e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006022:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80006024:	0207c563          	bltz	a5,8000604e <virtio_disk_rw+0x86>
  for(int i = 0; i < 3; i++){
    80006028:	2605                	addw	a2,a2,1 # 2001 <_entry-0x7fffdfff>
    8000602a:	0591                	add	a1,a1,4
    8000602c:	19560c63          	beq	a2,s5,800061c4 <virtio_disk_rw+0x1fc>
    idx[i] = alloc_desc();
    80006030:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80006032:	00020717          	auipc	a4,0x20
    80006036:	fe670713          	add	a4,a4,-26 # 80026018 <disk+0x2018>
    8000603a:	87ca                	mv	a5,s2
    if(disk.free[i]){
    8000603c:	00074683          	lbu	a3,0(a4)
    80006040:	fee1                	bnez	a3,80006018 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80006042:	2785                	addw	a5,a5,1
    80006044:	0705                	add	a4,a4,1
    80006046:	fe979be3          	bne	a5,s1,8000603c <virtio_disk_rw+0x74>
    idx[i] = alloc_desc();
    8000604a:	57fd                	li	a5,-1
    8000604c:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    8000604e:	00c05e63          	blez	a2,8000606a <virtio_disk_rw+0xa2>
    80006052:	060a                	sll	a2,a2,0x2
    80006054:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80006058:	0009a503          	lw	a0,0(s3)
    8000605c:	00000097          	auipc	ra,0x0
    80006060:	daa080e7          	jalr	-598(ra) # 80005e06 <free_desc>
      for(int j = 0; j < i; j++)
    80006064:	0991                	add	s3,s3,4
    80006066:	ffa999e3          	bne	s3,s10,80006058 <virtio_disk_rw+0x90>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000606a:	00020597          	auipc	a1,0x20
    8000606e:	03e58593          	add	a1,a1,62 # 800260a8 <disk+0x20a8>
    80006072:	00020517          	auipc	a0,0x20
    80006076:	fa650513          	add	a0,a0,-90 # 80026018 <disk+0x2018>
    8000607a:	ffffc097          	auipc	ra,0xffffc
    8000607e:	220080e7          	jalr	544(ra) # 8000229a <sleep>
  for(int i = 0; i < 3; i++){
    80006082:	f9040993          	add	s3,s0,-112
{
    80006086:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80006088:	864a                	mv	a2,s2
    8000608a:	b75d                	j	80006030 <virtio_disk_rw+0x68>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000608c:	00020717          	auipc	a4,0x20
    80006090:	f7473703          	ld	a4,-140(a4) # 80026000 <disk+0x2000>
    80006094:	973e                	add	a4,a4,a5
    80006096:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000609a:	0001e517          	auipc	a0,0x1e
    8000609e:	f6650513          	add	a0,a0,-154 # 80024000 <disk>
    800060a2:	00020717          	auipc	a4,0x20
    800060a6:	f5e70713          	add	a4,a4,-162 # 80026000 <disk+0x2000>
    800060aa:	6314                	ld	a3,0(a4)
    800060ac:	96be                	add	a3,a3,a5
    800060ae:	00c6d603          	lhu	a2,12(a3)
    800060b2:	00166613          	or	a2,a2,1
    800060b6:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800060ba:	f9842683          	lw	a3,-104(s0)
    800060be:	6310                	ld	a2,0(a4)
    800060c0:	97b2                	add	a5,a5,a2
    800060c2:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
    800060c6:	20048613          	add	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    800060ca:	0612                	sll	a2,a2,0x4
    800060cc:	962a                	add	a2,a2,a0
    800060ce:	02060823          	sb	zero,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800060d2:	00469793          	sll	a5,a3,0x4
    800060d6:	630c                	ld	a1,0(a4)
    800060d8:	95be                	add	a1,a1,a5
    800060da:	6689                	lui	a3,0x2
    800060dc:	03068693          	add	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    800060e0:	96ca                	add	a3,a3,s2
    800060e2:	96aa                	add	a3,a3,a0
    800060e4:	e194                	sd	a3,0(a1)
  disk.desc[idx[2]].len = 1;
    800060e6:	6314                	ld	a3,0(a4)
    800060e8:	96be                	add	a3,a3,a5
    800060ea:	4585                	li	a1,1
    800060ec:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800060ee:	6314                	ld	a3,0(a4)
    800060f0:	96be                	add	a3,a3,a5
    800060f2:	4509                	li	a0,2
    800060f4:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    800060f8:	6314                	ld	a3,0(a4)
    800060fa:	97b6                	add	a5,a5,a3
    800060fc:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006100:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80006104:	03463423          	sd	s4,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    80006108:	6714                	ld	a3,8(a4)
    8000610a:	0026d783          	lhu	a5,2(a3)
    8000610e:	8b9d                	and	a5,a5,7
    80006110:	0789                	add	a5,a5,2
    80006112:	0786                	sll	a5,a5,0x1
    80006114:	96be                	add	a3,a3,a5
    80006116:	00969023          	sh	s1,0(a3)
  __sync_synchronize();
    8000611a:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    8000611e:	6718                	ld	a4,8(a4)
    80006120:	00275783          	lhu	a5,2(a4)
    80006124:	2785                	addw	a5,a5,1
    80006126:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000612a:	100017b7          	lui	a5,0x10001
    8000612e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006132:	004a2783          	lw	a5,4(s4)
    80006136:	02b79163          	bne	a5,a1,80006158 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    8000613a:	00020917          	auipc	s2,0x20
    8000613e:	f6e90913          	add	s2,s2,-146 # 800260a8 <disk+0x20a8>
  while(b->disk == 1) {
    80006142:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006144:	85ca                	mv	a1,s2
    80006146:	8552                	mv	a0,s4
    80006148:	ffffc097          	auipc	ra,0xffffc
    8000614c:	152080e7          	jalr	338(ra) # 8000229a <sleep>
  while(b->disk == 1) {
    80006150:	004a2783          	lw	a5,4(s4)
    80006154:	fe9788e3          	beq	a5,s1,80006144 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80006158:	f9042483          	lw	s1,-112(s0)
    8000615c:	20048713          	add	a4,s1,512
    80006160:	0712                	sll	a4,a4,0x4
    80006162:	0001e797          	auipc	a5,0x1e
    80006166:	e9e78793          	add	a5,a5,-354 # 80024000 <disk>
    8000616a:	97ba                	add	a5,a5,a4
    8000616c:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80006170:	00020917          	auipc	s2,0x20
    80006174:	e9090913          	add	s2,s2,-368 # 80026000 <disk+0x2000>
    80006178:	a019                	j	8000617e <virtio_disk_rw+0x1b6>
      i = disk.desc[i].next;
    8000617a:	00e7d483          	lhu	s1,14(a5)
    free_desc(i);
    8000617e:	8526                	mv	a0,s1
    80006180:	00000097          	auipc	ra,0x0
    80006184:	c86080e7          	jalr	-890(ra) # 80005e06 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80006188:	0492                	sll	s1,s1,0x4
    8000618a:	00093783          	ld	a5,0(s2)
    8000618e:	97a6                	add	a5,a5,s1
    80006190:	00c7d703          	lhu	a4,12(a5)
    80006194:	8b05                	and	a4,a4,1
    80006196:	f375                	bnez	a4,8000617a <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006198:	00020517          	auipc	a0,0x20
    8000619c:	f1050513          	add	a0,a0,-240 # 800260a8 <disk+0x20a8>
    800061a0:	ffffb097          	auipc	ra,0xffffb
    800061a4:	b84080e7          	jalr	-1148(ra) # 80000d24 <release>
}
    800061a8:	70e6                	ld	ra,120(sp)
    800061aa:	7446                	ld	s0,112(sp)
    800061ac:	74a6                	ld	s1,104(sp)
    800061ae:	7906                	ld	s2,96(sp)
    800061b0:	69e6                	ld	s3,88(sp)
    800061b2:	6a46                	ld	s4,80(sp)
    800061b4:	6aa6                	ld	s5,72(sp)
    800061b6:	6b06                	ld	s6,64(sp)
    800061b8:	7be2                	ld	s7,56(sp)
    800061ba:	7c42                	ld	s8,48(sp)
    800061bc:	7ca2                	ld	s9,40(sp)
    800061be:	7d02                	ld	s10,32(sp)
    800061c0:	6109                	add	sp,sp,128
    800061c2:	8082                	ret
  if(write)
    800061c4:	019037b3          	snez	a5,s9
    800061c8:	f8f42023          	sw	a5,-128(s0)
  buf0.reserved = 0;
    800061cc:	f8042223          	sw	zero,-124(s0)
  buf0.sector = sector;
    800061d0:	f9843423          	sd	s8,-120(s0)
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    800061d4:	f9042483          	lw	s1,-112(s0)
    800061d8:	00449913          	sll	s2,s1,0x4
    800061dc:	00020997          	auipc	s3,0x20
    800061e0:	e2498993          	add	s3,s3,-476 # 80026000 <disk+0x2000>
    800061e4:	0009ba83          	ld	s5,0(s3)
    800061e8:	9aca                	add	s5,s5,s2
    800061ea:	f8040513          	add	a0,s0,-128
    800061ee:	ffffb097          	auipc	ra,0xffffb
    800061f2:	f4c080e7          	jalr	-180(ra) # 8000113a <kvmpa>
    800061f6:	00aab023          	sd	a0,0(s5)
  disk.desc[idx[0]].len = sizeof(buf0);
    800061fa:	0009b783          	ld	a5,0(s3)
    800061fe:	97ca                	add	a5,a5,s2
    80006200:	4741                	li	a4,16
    80006202:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006204:	0009b783          	ld	a5,0(s3)
    80006208:	97ca                	add	a5,a5,s2
    8000620a:	4705                	li	a4,1
    8000620c:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80006210:	f9442783          	lw	a5,-108(s0)
    80006214:	0009b703          	ld	a4,0(s3)
    80006218:	974a                	add	a4,a4,s2
    8000621a:	00f71723          	sh	a5,14(a4)
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000621e:	0792                	sll	a5,a5,0x4
    80006220:	0009b703          	ld	a4,0(s3)
    80006224:	973e                	add	a4,a4,a5
    80006226:	058a0693          	add	a3,s4,88
    8000622a:	e314                	sd	a3,0(a4)
  disk.desc[idx[1]].len = BSIZE;
    8000622c:	0009b703          	ld	a4,0(s3)
    80006230:	973e                	add	a4,a4,a5
    80006232:	40000693          	li	a3,1024
    80006236:	c714                	sw	a3,8(a4)
  if(write)
    80006238:	e40c9ae3          	bnez	s9,8000608c <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000623c:	00020717          	auipc	a4,0x20
    80006240:	dc473703          	ld	a4,-572(a4) # 80026000 <disk+0x2000>
    80006244:	973e                	add	a4,a4,a5
    80006246:	4689                	li	a3,2
    80006248:	00d71623          	sh	a3,12(a4)
    8000624c:	b5b9                	j	8000609a <virtio_disk_rw+0xd2>

000000008000624e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000624e:	1101                	add	sp,sp,-32
    80006250:	ec06                	sd	ra,24(sp)
    80006252:	e822                	sd	s0,16(sp)
    80006254:	e426                	sd	s1,8(sp)
    80006256:	e04a                	sd	s2,0(sp)
    80006258:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000625a:	00020517          	auipc	a0,0x20
    8000625e:	e4e50513          	add	a0,a0,-434 # 800260a8 <disk+0x20a8>
    80006262:	ffffb097          	auipc	ra,0xffffb
    80006266:	a0e080e7          	jalr	-1522(ra) # 80000c70 <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    8000626a:	00020717          	auipc	a4,0x20
    8000626e:	d9670713          	add	a4,a4,-618 # 80026000 <disk+0x2000>
    80006272:	02075783          	lhu	a5,32(a4)
    80006276:	6b18                	ld	a4,16(a4)
    80006278:	00275683          	lhu	a3,2(a4)
    8000627c:	8ebd                	xor	a3,a3,a5
    8000627e:	8a9d                	and	a3,a3,7
    80006280:	cab9                	beqz	a3,800062d6 <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    80006282:	0001e917          	auipc	s2,0x1e
    80006286:	d7e90913          	add	s2,s2,-642 # 80024000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    8000628a:	00020497          	auipc	s1,0x20
    8000628e:	d7648493          	add	s1,s1,-650 # 80026000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    80006292:	078e                	sll	a5,a5,0x3
    80006294:	973e                	add	a4,a4,a5
    80006296:	435c                	lw	a5,4(a4)
    if(disk.info[id].status != 0)
    80006298:	20078713          	add	a4,a5,512
    8000629c:	0712                	sll	a4,a4,0x4
    8000629e:	974a                	add	a4,a4,s2
    800062a0:	03074703          	lbu	a4,48(a4)
    800062a4:	ef21                	bnez	a4,800062fc <virtio_disk_intr+0xae>
    disk.info[id].b->disk = 0;   // disk is done with buf
    800062a6:	20078793          	add	a5,a5,512
    800062aa:	0792                	sll	a5,a5,0x4
    800062ac:	97ca                	add	a5,a5,s2
    800062ae:	7798                	ld	a4,40(a5)
    800062b0:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    800062b4:	7788                	ld	a0,40(a5)
    800062b6:	ffffc097          	auipc	ra,0xffffc
    800062ba:	164080e7          	jalr	356(ra) # 8000241a <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    800062be:	0204d783          	lhu	a5,32(s1)
    800062c2:	2785                	addw	a5,a5,1
    800062c4:	8b9d                	and	a5,a5,7
    800062c6:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    800062ca:	6898                	ld	a4,16(s1)
    800062cc:	00275683          	lhu	a3,2(a4)
    800062d0:	8a9d                	and	a3,a3,7
    800062d2:	fcf690e3          	bne	a3,a5,80006292 <virtio_disk_intr+0x44>
  }
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800062d6:	10001737          	lui	a4,0x10001
    800062da:	533c                	lw	a5,96(a4)
    800062dc:	8b8d                	and	a5,a5,3
    800062de:	d37c                	sw	a5,100(a4)

  release(&disk.vdisk_lock);
    800062e0:	00020517          	auipc	a0,0x20
    800062e4:	dc850513          	add	a0,a0,-568 # 800260a8 <disk+0x20a8>
    800062e8:	ffffb097          	auipc	ra,0xffffb
    800062ec:	a3c080e7          	jalr	-1476(ra) # 80000d24 <release>
}
    800062f0:	60e2                	ld	ra,24(sp)
    800062f2:	6442                	ld	s0,16(sp)
    800062f4:	64a2                	ld	s1,8(sp)
    800062f6:	6902                	ld	s2,0(sp)
    800062f8:	6105                	add	sp,sp,32
    800062fa:	8082                	ret
      panic("virtio_disk_intr status");
    800062fc:	00002517          	auipc	a0,0x2
    80006300:	52450513          	add	a0,a0,1316 # 80008820 <syscalls+0x3e0>
    80006304:	ffffa097          	auipc	ra,0xffffa
    80006308:	2dc080e7          	jalr	732(ra) # 800005e0 <panic>
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
