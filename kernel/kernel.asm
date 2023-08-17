
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
    80000060:	ad478793          	add	a5,a5,-1324 # 80005b30 <timervec>
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
    8000012a:	366080e7          	jalr	870(ra) # 8000248c <either_copyin>
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
    800001c4:	806080e7          	jalr	-2042(ra) # 800019c6 <myproc>
    800001c8:	591c                	lw	a5,48(a0)
    800001ca:	efad                	bnez	a5,80000244 <consoleread+0xd4>
      sleep(&cons.r, &cons.lock);
    800001cc:	85a6                	mv	a1,s1
    800001ce:	854a                	mv	a0,s2
    800001d0:	00002097          	auipc	ra,0x2
    800001d4:	00c080e7          	jalr	12(ra) # 800021dc <sleep>
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
    8000021a:	220080e7          	jalr	544(ra) # 80002436 <either_copyout>
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
    800002f8:	1ee080e7          	jalr	494(ra) # 800024e2 <procdump>
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
    8000044c:	f14080e7          	jalr	-236(ra) # 8000235c <wakeup>
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
    800008a6:	aba080e7          	jalr	-1350(ra) # 8000235c <wakeup>
    
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
    80000940:	8a0080e7          	jalr	-1888(ra) # 800021dc <sleep>
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
    80000b9a:	e14080e7          	jalr	-492(ra) # 800019aa <mycpu>
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
    80000bcc:	de2080e7          	jalr	-542(ra) # 800019aa <mycpu>
    80000bd0:	5d3c                	lw	a5,120(a0)
    80000bd2:	cf89                	beqz	a5,80000bec <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd4:	00001097          	auipc	ra,0x1
    80000bd8:	dd6080e7          	jalr	-554(ra) # 800019aa <mycpu>
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
    80000bf0:	dbe080e7          	jalr	-578(ra) # 800019aa <mycpu>
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
    80000c30:	d7e080e7          	jalr	-642(ra) # 800019aa <mycpu>
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
    80000c5c:	d52080e7          	jalr	-686(ra) # 800019aa <mycpu>
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
    80000eb0:	aee080e7          	jalr	-1298(ra) # 8000199a <cpuid>
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
    80000ecc:	ad2080e7          	jalr	-1326(ra) # 8000199a <cpuid>
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
    80000eee:	73a080e7          	jalr	1850(ra) # 80002624 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ef2:	00005097          	auipc	ra,0x5
    80000ef6:	c7e080e7          	jalr	-898(ra) # 80005b70 <plicinithart>
  }

  scheduler();        
    80000efa:	00001097          	auipc	ra,0x1
    80000efe:	004080e7          	jalr	4(ra) # 80001efe <scheduler>
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
    80000f5e:	970080e7          	jalr	-1680(ra) # 800018ca <procinit>
    trapinit();      // trap vectors
    80000f62:	00001097          	auipc	ra,0x1
    80000f66:	69a080e7          	jalr	1690(ra) # 800025fc <trapinit>
    trapinithart();  // install kernel trap vector
    80000f6a:	00001097          	auipc	ra,0x1
    80000f6e:	6ba080e7          	jalr	1722(ra) # 80002624 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f72:	00005097          	auipc	ra,0x5
    80000f76:	be8080e7          	jalr	-1048(ra) # 80005b5a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f7a:	00005097          	auipc	ra,0x5
    80000f7e:	bf6080e7          	jalr	-1034(ra) # 80005b70 <plicinithart>
    binit();         // buffer cache
    80000f82:	00002097          	auipc	ra,0x2
    80000f86:	de8080e7          	jalr	-536(ra) # 80002d6a <binit>
    iinit();         // inode cache
    80000f8a:	00002097          	auipc	ra,0x2
    80000f8e:	474080e7          	jalr	1140(ra) # 800033fe <iinit>
    fileinit();      // file table
    80000f92:	00003097          	auipc	ra,0x3
    80000f96:	3ea080e7          	jalr	1002(ra) # 8000437c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f9a:	00005097          	auipc	ra,0x5
    80000f9e:	cdc080e7          	jalr	-804(ra) # 80005c76 <virtio_disk_init>
    userinit();      // first user process
    80000fa2:	00001097          	auipc	ra,0x1
    80000fa6:	cee080e7          	jalr	-786(ra) # 80001c90 <userinit>
    __sync_synchronize();
    80000faa:	0ff0000f          	fence
    started = 1;
    80000fae:	4785                	li	a5,1
    80000fb0:	00008717          	auipc	a4,0x8
    80000fb4:	04f72e23          	sw	a5,92(a4) # 8000900c <started>
    80000fb8:	b789                	j	80000efa <main+0x56>

0000000080000fba <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
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
  if(va >= MAXVA)
    80000ff8:	57fd                	li	a5,-1
    80000ffa:	83e9                	srl	a5,a5,0x1a
    80000ffc:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000ffe:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001000:	04b7f263          	bgeu	a5,a1,80001044 <walk+0x66>
    panic("walk");
    80001004:	00007517          	auipc	a0,0x7
    80001008:	0cc50513          	add	a0,a0,204 # 800080d0 <digits+0x90>
    8000100c:	fffff097          	auipc	ra,0xfffff
    80001010:	536080e7          	jalr	1334(ra) # 80000542 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
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
  for(int level = 2; level > 0; level--) {
    8000103e:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8ff7>
    80001040:	036a0063          	beq	s4,s6,80001060 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001044:	0149d933          	srl	s2,s3,s4
    80001048:	1ff97913          	and	s2,s2,511
    8000104c:	090e                	sll	s2,s2,0x3
    8000104e:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
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

  if(va >= MAXVA)
    80001084:	57fd                	li	a5,-1
    80001086:	83e9                	srl	a5,a5,0x1a
    80001088:	00b7f463          	bgeu	a5,a1,80001090 <walkaddr+0xc>
    return 0;
    8000108c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
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
  if(pte == 0)
    800010a2:	c105                	beqz	a0,800010c2 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800010a4:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800010a6:	0117f693          	and	a3,a5,17
    800010aa:	4745                	li	a4,17
    return 0;
    800010ac:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
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
  if(pte == 0)
    800010ea:	cd09                	beqz	a0,80001104 <kvmpa+0x3e>
    panic("kvmpa");
  if((*pte & PTE_V) == 0)
    800010ec:	6108                	ld	a0,0(a0)
    800010ee:	00157793          	and	a5,a0,1
    800010f2:	c38d                	beqz	a5,80001114 <kvmpa+0x4e>
    panic("kvmpa");
  pa = PTE2PA(*pte);
    800010f4:	8129                	srl	a0,a0,0xa
    800010f6:	0532                	sll	a0,a0,0xc
  return pa+off;
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
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
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
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001154:	6b85                	lui	s7,0x1
    80001156:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000115a:	4605                	li	a2,1
    8000115c:	85ca                	mv	a1,s2
    8000115e:	8556                	mv	a0,s5
    80001160:	00000097          	auipc	ra,0x0
    80001164:	e7e080e7          	jalr	-386(ra) # 80000fde <walk>
    80001168:	c51d                	beqz	a0,80001196 <mappages+0x72>
    if(*pte & PTE_V)
    8000116a:	611c                	ld	a5,0(a0)
    8000116c:	8b85                	and	a5,a5,1
    8000116e:	ef81                	bnez	a5,80001186 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001170:	80b1                	srl	s1,s1,0xc
    80001172:	04aa                	sll	s1,s1,0xa
    80001174:	0164e4b3          	or	s1,s1,s6
    80001178:	0014e493          	or	s1,s1,1
    8000117c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000117e:	03390863          	beq	s2,s3,800011ae <mappages+0x8a>
    a += PGSIZE;
    80001182:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
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
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
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
  kernel_pagetable = (pagetable_t) kalloc();
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
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
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
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
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
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
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

  if((va % PGSIZE) != 0)
    800012d2:	03459793          	sll	a5,a1,0x34
    800012d6:	e795                	bnez	a5,80001302 <uvmunmap+0x46>
    800012d8:	8a2a                	mv	s4,a0
    800012da:	892e                	mv	s2,a1
    800012dc:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012de:	0632                	sll	a2,a2,0xc
    800012e0:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800012e4:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012e6:	6b05                	lui	s6,0x1
    800012e8:	0735e263          	bltu	a1,s3,8000134c <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
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
      panic("uvmunmap: walk");
    80001312:	00007517          	auipc	a0,0x7
    80001316:	df650513          	add	a0,a0,-522 # 80008108 <digits+0xc8>
    8000131a:	fffff097          	auipc	ra,0xfffff
    8000131e:	228080e7          	jalr	552(ra) # 80000542 <panic>
      panic("uvmunmap: not mapped");
    80001322:	00007517          	auipc	a0,0x7
    80001326:	df650513          	add	a0,a0,-522 # 80008118 <digits+0xd8>
    8000132a:	fffff097          	auipc	ra,0xfffff
    8000132e:	218080e7          	jalr	536(ra) # 80000542 <panic>
      panic("uvmunmap: not a leaf");
    80001332:	00007517          	auipc	a0,0x7
    80001336:	dfe50513          	add	a0,a0,-514 # 80008130 <digits+0xf0>
    8000133a:	fffff097          	auipc	ra,0xfffff
    8000133e:	208080e7          	jalr	520(ra) # 80000542 <panic>
    *pte = 0;
    80001342:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001346:	995a                	add	s2,s2,s6
    80001348:	fb3972e3          	bgeu	s2,s3,800012ec <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000134c:	4601                	li	a2,0
    8000134e:	85ca                	mv	a1,s2
    80001350:	8552                	mv	a0,s4
    80001352:	00000097          	auipc	ra,0x0
    80001356:	c8c080e7          	jalr	-884(ra) # 80000fde <walk>
    8000135a:	84aa                	mv	s1,a0
    8000135c:	d95d                	beqz	a0,80001312 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000135e:	6108                	ld	a0,0(a0)
    80001360:	00157793          	and	a5,a0,1
    80001364:	dfdd                	beqz	a5,80001322 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001366:	3ff57793          	and	a5,a0,1023
    8000136a:	fd7784e3          	beq	a5,s7,80001332 <uvmunmap+0x76>
    if(do_free){
    8000136e:	fc0a8ae3          	beqz	s5,80001342 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80001372:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    80001374:	0532                	sll	a0,a0,0xc
    80001376:	fffff097          	auipc	ra,0xfffff
    8000137a:	698080e7          	jalr	1688(ra) # 80000a0e <kfree>
    8000137e:	b7d1                	j	80001342 <uvmunmap+0x86>

0000000080001380 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001380:	1101                	add	sp,sp,-32
    80001382:	ec06                	sd	ra,24(sp)
    80001384:	e822                	sd	s0,16(sp)
    80001386:	e426                	sd	s1,8(sp)
    80001388:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000138a:	fffff097          	auipc	ra,0xfffff
    8000138e:	782080e7          	jalr	1922(ra) # 80000b0c <kalloc>
    80001392:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001394:	c519                	beqz	a0,800013a2 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001396:	6605                	lui	a2,0x1
    80001398:	4581                	li	a1,0
    8000139a:	00000097          	auipc	ra,0x0
    8000139e:	95e080e7          	jalr	-1698(ra) # 80000cf8 <memset>
  return pagetable;
}
    800013a2:	8526                	mv	a0,s1
    800013a4:	60e2                	ld	ra,24(sp)
    800013a6:	6442                	ld	s0,16(sp)
    800013a8:	64a2                	ld	s1,8(sp)
    800013aa:	6105                	add	sp,sp,32
    800013ac:	8082                	ret

00000000800013ae <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800013ae:	7179                	add	sp,sp,-48
    800013b0:	f406                	sd	ra,40(sp)
    800013b2:	f022                	sd	s0,32(sp)
    800013b4:	ec26                	sd	s1,24(sp)
    800013b6:	e84a                	sd	s2,16(sp)
    800013b8:	e44e                	sd	s3,8(sp)
    800013ba:	e052                	sd	s4,0(sp)
    800013bc:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800013be:	6785                	lui	a5,0x1
    800013c0:	04f67863          	bgeu	a2,a5,80001410 <uvminit+0x62>
    800013c4:	8a2a                	mv	s4,a0
    800013c6:	89ae                	mv	s3,a1
    800013c8:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    800013ca:	fffff097          	auipc	ra,0xfffff
    800013ce:	742080e7          	jalr	1858(ra) # 80000b0c <kalloc>
    800013d2:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800013d4:	6605                	lui	a2,0x1
    800013d6:	4581                	li	a1,0
    800013d8:	00000097          	auipc	ra,0x0
    800013dc:	920080e7          	jalr	-1760(ra) # 80000cf8 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800013e0:	4779                	li	a4,30
    800013e2:	86ca                	mv	a3,s2
    800013e4:	6605                	lui	a2,0x1
    800013e6:	4581                	li	a1,0
    800013e8:	8552                	mv	a0,s4
    800013ea:	00000097          	auipc	ra,0x0
    800013ee:	d3a080e7          	jalr	-710(ra) # 80001124 <mappages>
  memmove(mem, src, sz);
    800013f2:	8626                	mv	a2,s1
    800013f4:	85ce                	mv	a1,s3
    800013f6:	854a                	mv	a0,s2
    800013f8:	00000097          	auipc	ra,0x0
    800013fc:	95c080e7          	jalr	-1700(ra) # 80000d54 <memmove>
}
    80001400:	70a2                	ld	ra,40(sp)
    80001402:	7402                	ld	s0,32(sp)
    80001404:	64e2                	ld	s1,24(sp)
    80001406:	6942                	ld	s2,16(sp)
    80001408:	69a2                	ld	s3,8(sp)
    8000140a:	6a02                	ld	s4,0(sp)
    8000140c:	6145                	add	sp,sp,48
    8000140e:	8082                	ret
    panic("inituvm: more than a page");
    80001410:	00007517          	auipc	a0,0x7
    80001414:	d3850513          	add	a0,a0,-712 # 80008148 <digits+0x108>
    80001418:	fffff097          	auipc	ra,0xfffff
    8000141c:	12a080e7          	jalr	298(ra) # 80000542 <panic>

0000000080001420 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001420:	1101                	add	sp,sp,-32
    80001422:	ec06                	sd	ra,24(sp)
    80001424:	e822                	sd	s0,16(sp)
    80001426:	e426                	sd	s1,8(sp)
    80001428:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000142a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000142c:	00b67d63          	bgeu	a2,a1,80001446 <uvmdealloc+0x26>
    80001430:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001432:	6785                	lui	a5,0x1
    80001434:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001436:	00f60733          	add	a4,a2,a5
    8000143a:	76fd                	lui	a3,0xfffff
    8000143c:	8f75                	and	a4,a4,a3
    8000143e:	97ae                	add	a5,a5,a1
    80001440:	8ff5                	and	a5,a5,a3
    80001442:	00f76863          	bltu	a4,a5,80001452 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001446:	8526                	mv	a0,s1
    80001448:	60e2                	ld	ra,24(sp)
    8000144a:	6442                	ld	s0,16(sp)
    8000144c:	64a2                	ld	s1,8(sp)
    8000144e:	6105                	add	sp,sp,32
    80001450:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001452:	8f99                	sub	a5,a5,a4
    80001454:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001456:	4685                	li	a3,1
    80001458:	0007861b          	sext.w	a2,a5
    8000145c:	85ba                	mv	a1,a4
    8000145e:	00000097          	auipc	ra,0x0
    80001462:	e5e080e7          	jalr	-418(ra) # 800012bc <uvmunmap>
    80001466:	b7c5                	j	80001446 <uvmdealloc+0x26>

0000000080001468 <uvmalloc>:
  if(newsz < oldsz)
    80001468:	0ab66163          	bltu	a2,a1,8000150a <uvmalloc+0xa2>
{
    8000146c:	7139                	add	sp,sp,-64
    8000146e:	fc06                	sd	ra,56(sp)
    80001470:	f822                	sd	s0,48(sp)
    80001472:	f426                	sd	s1,40(sp)
    80001474:	f04a                	sd	s2,32(sp)
    80001476:	ec4e                	sd	s3,24(sp)
    80001478:	e852                	sd	s4,16(sp)
    8000147a:	e456                	sd	s5,8(sp)
    8000147c:	0080                	add	s0,sp,64
    8000147e:	8aaa                	mv	s5,a0
    80001480:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001482:	6785                	lui	a5,0x1
    80001484:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001486:	95be                	add	a1,a1,a5
    80001488:	77fd                	lui	a5,0xfffff
    8000148a:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000148e:	08c9f063          	bgeu	s3,a2,8000150e <uvmalloc+0xa6>
    80001492:	894e                	mv	s2,s3
    mem = kalloc();
    80001494:	fffff097          	auipc	ra,0xfffff
    80001498:	678080e7          	jalr	1656(ra) # 80000b0c <kalloc>
    8000149c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000149e:	c51d                	beqz	a0,800014cc <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800014a0:	6605                	lui	a2,0x1
    800014a2:	4581                	li	a1,0
    800014a4:	00000097          	auipc	ra,0x0
    800014a8:	854080e7          	jalr	-1964(ra) # 80000cf8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800014ac:	4779                	li	a4,30
    800014ae:	86a6                	mv	a3,s1
    800014b0:	6605                	lui	a2,0x1
    800014b2:	85ca                	mv	a1,s2
    800014b4:	8556                	mv	a0,s5
    800014b6:	00000097          	auipc	ra,0x0
    800014ba:	c6e080e7          	jalr	-914(ra) # 80001124 <mappages>
    800014be:	e905                	bnez	a0,800014ee <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014c0:	6785                	lui	a5,0x1
    800014c2:	993e                	add	s2,s2,a5
    800014c4:	fd4968e3          	bltu	s2,s4,80001494 <uvmalloc+0x2c>
  return newsz;
    800014c8:	8552                	mv	a0,s4
    800014ca:	a809                	j	800014dc <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800014cc:	864e                	mv	a2,s3
    800014ce:	85ca                	mv	a1,s2
    800014d0:	8556                	mv	a0,s5
    800014d2:	00000097          	auipc	ra,0x0
    800014d6:	f4e080e7          	jalr	-178(ra) # 80001420 <uvmdealloc>
      return 0;
    800014da:	4501                	li	a0,0
}
    800014dc:	70e2                	ld	ra,56(sp)
    800014de:	7442                	ld	s0,48(sp)
    800014e0:	74a2                	ld	s1,40(sp)
    800014e2:	7902                	ld	s2,32(sp)
    800014e4:	69e2                	ld	s3,24(sp)
    800014e6:	6a42                	ld	s4,16(sp)
    800014e8:	6aa2                	ld	s5,8(sp)
    800014ea:	6121                	add	sp,sp,64
    800014ec:	8082                	ret
      kfree(mem);
    800014ee:	8526                	mv	a0,s1
    800014f0:	fffff097          	auipc	ra,0xfffff
    800014f4:	51e080e7          	jalr	1310(ra) # 80000a0e <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800014f8:	864e                	mv	a2,s3
    800014fa:	85ca                	mv	a1,s2
    800014fc:	8556                	mv	a0,s5
    800014fe:	00000097          	auipc	ra,0x0
    80001502:	f22080e7          	jalr	-222(ra) # 80001420 <uvmdealloc>
      return 0;
    80001506:	4501                	li	a0,0
    80001508:	bfd1                	j	800014dc <uvmalloc+0x74>
    return oldsz;
    8000150a:	852e                	mv	a0,a1
}
    8000150c:	8082                	ret
  return newsz;
    8000150e:	8532                	mv	a0,a2
    80001510:	b7f1                	j	800014dc <uvmalloc+0x74>

0000000080001512 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001512:	7179                	add	sp,sp,-48
    80001514:	f406                	sd	ra,40(sp)
    80001516:	f022                	sd	s0,32(sp)
    80001518:	ec26                	sd	s1,24(sp)
    8000151a:	e84a                	sd	s2,16(sp)
    8000151c:	e44e                	sd	s3,8(sp)
    8000151e:	e052                	sd	s4,0(sp)
    80001520:	1800                	add	s0,sp,48
    80001522:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001524:	84aa                	mv	s1,a0
    80001526:	6905                	lui	s2,0x1
    80001528:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000152a:	4985                	li	s3,1
    8000152c:	a829                	j	80001546 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000152e:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001530:	00c79513          	sll	a0,a5,0xc
    80001534:	00000097          	auipc	ra,0x0
    80001538:	fde080e7          	jalr	-34(ra) # 80001512 <freewalk>
      pagetable[i] = 0;
    8000153c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001540:	04a1                	add	s1,s1,8
    80001542:	03248163          	beq	s1,s2,80001564 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80001546:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001548:	00f7f713          	and	a4,a5,15
    8000154c:	ff3701e3          	beq	a4,s3,8000152e <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001550:	8b85                	and	a5,a5,1
    80001552:	d7fd                	beqz	a5,80001540 <freewalk+0x2e>
      panic("freewalk: leaf");
    80001554:	00007517          	auipc	a0,0x7
    80001558:	c1450513          	add	a0,a0,-1004 # 80008168 <digits+0x128>
    8000155c:	fffff097          	auipc	ra,0xfffff
    80001560:	fe6080e7          	jalr	-26(ra) # 80000542 <panic>
    }
  }
  kfree((void*)pagetable);
    80001564:	8552                	mv	a0,s4
    80001566:	fffff097          	auipc	ra,0xfffff
    8000156a:	4a8080e7          	jalr	1192(ra) # 80000a0e <kfree>
}
    8000156e:	70a2                	ld	ra,40(sp)
    80001570:	7402                	ld	s0,32(sp)
    80001572:	64e2                	ld	s1,24(sp)
    80001574:	6942                	ld	s2,16(sp)
    80001576:	69a2                	ld	s3,8(sp)
    80001578:	6a02                	ld	s4,0(sp)
    8000157a:	6145                	add	sp,sp,48
    8000157c:	8082                	ret

000000008000157e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000157e:	1101                	add	sp,sp,-32
    80001580:	ec06                	sd	ra,24(sp)
    80001582:	e822                	sd	s0,16(sp)
    80001584:	e426                	sd	s1,8(sp)
    80001586:	1000                	add	s0,sp,32
    80001588:	84aa                	mv	s1,a0
  if(sz > 0)
    8000158a:	e999                	bnez	a1,800015a0 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000158c:	8526                	mv	a0,s1
    8000158e:	00000097          	auipc	ra,0x0
    80001592:	f84080e7          	jalr	-124(ra) # 80001512 <freewalk>
}
    80001596:	60e2                	ld	ra,24(sp)
    80001598:	6442                	ld	s0,16(sp)
    8000159a:	64a2                	ld	s1,8(sp)
    8000159c:	6105                	add	sp,sp,32
    8000159e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800015a0:	6785                	lui	a5,0x1
    800015a2:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800015a4:	95be                	add	a1,a1,a5
    800015a6:	4685                	li	a3,1
    800015a8:	00c5d613          	srl	a2,a1,0xc
    800015ac:	4581                	li	a1,0
    800015ae:	00000097          	auipc	ra,0x0
    800015b2:	d0e080e7          	jalr	-754(ra) # 800012bc <uvmunmap>
    800015b6:	bfd9                	j	8000158c <uvmfree+0xe>

00000000800015b8 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800015b8:	c679                	beqz	a2,80001686 <uvmcopy+0xce>
{
    800015ba:	715d                	add	sp,sp,-80
    800015bc:	e486                	sd	ra,72(sp)
    800015be:	e0a2                	sd	s0,64(sp)
    800015c0:	fc26                	sd	s1,56(sp)
    800015c2:	f84a                	sd	s2,48(sp)
    800015c4:	f44e                	sd	s3,40(sp)
    800015c6:	f052                	sd	s4,32(sp)
    800015c8:	ec56                	sd	s5,24(sp)
    800015ca:	e85a                	sd	s6,16(sp)
    800015cc:	e45e                	sd	s7,8(sp)
    800015ce:	0880                	add	s0,sp,80
    800015d0:	8b2a                	mv	s6,a0
    800015d2:	8aae                	mv	s5,a1
    800015d4:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800015d6:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800015d8:	4601                	li	a2,0
    800015da:	85ce                	mv	a1,s3
    800015dc:	855a                	mv	a0,s6
    800015de:	00000097          	auipc	ra,0x0
    800015e2:	a00080e7          	jalr	-1536(ra) # 80000fde <walk>
    800015e6:	c531                	beqz	a0,80001632 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800015e8:	6118                	ld	a4,0(a0)
    800015ea:	00177793          	and	a5,a4,1
    800015ee:	cbb1                	beqz	a5,80001642 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800015f0:	00a75593          	srl	a1,a4,0xa
    800015f4:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800015f8:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    800015fc:	fffff097          	auipc	ra,0xfffff
    80001600:	510080e7          	jalr	1296(ra) # 80000b0c <kalloc>
    80001604:	892a                	mv	s2,a0
    80001606:	c939                	beqz	a0,8000165c <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001608:	6605                	lui	a2,0x1
    8000160a:	85de                	mv	a1,s7
    8000160c:	fffff097          	auipc	ra,0xfffff
    80001610:	748080e7          	jalr	1864(ra) # 80000d54 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001614:	8726                	mv	a4,s1
    80001616:	86ca                	mv	a3,s2
    80001618:	6605                	lui	a2,0x1
    8000161a:	85ce                	mv	a1,s3
    8000161c:	8556                	mv	a0,s5
    8000161e:	00000097          	auipc	ra,0x0
    80001622:	b06080e7          	jalr	-1274(ra) # 80001124 <mappages>
    80001626:	e515                	bnez	a0,80001652 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80001628:	6785                	lui	a5,0x1
    8000162a:	99be                	add	s3,s3,a5
    8000162c:	fb49e6e3          	bltu	s3,s4,800015d8 <uvmcopy+0x20>
    80001630:	a081                	j	80001670 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80001632:	00007517          	auipc	a0,0x7
    80001636:	b4650513          	add	a0,a0,-1210 # 80008178 <digits+0x138>
    8000163a:	fffff097          	auipc	ra,0xfffff
    8000163e:	f08080e7          	jalr	-248(ra) # 80000542 <panic>
      panic("uvmcopy: page not present");
    80001642:	00007517          	auipc	a0,0x7
    80001646:	b5650513          	add	a0,a0,-1194 # 80008198 <digits+0x158>
    8000164a:	fffff097          	auipc	ra,0xfffff
    8000164e:	ef8080e7          	jalr	-264(ra) # 80000542 <panic>
      kfree(mem);
    80001652:	854a                	mv	a0,s2
    80001654:	fffff097          	auipc	ra,0xfffff
    80001658:	3ba080e7          	jalr	954(ra) # 80000a0e <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000165c:	4685                	li	a3,1
    8000165e:	00c9d613          	srl	a2,s3,0xc
    80001662:	4581                	li	a1,0
    80001664:	8556                	mv	a0,s5
    80001666:	00000097          	auipc	ra,0x0
    8000166a:	c56080e7          	jalr	-938(ra) # 800012bc <uvmunmap>
  return -1;
    8000166e:	557d                	li	a0,-1
}
    80001670:	60a6                	ld	ra,72(sp)
    80001672:	6406                	ld	s0,64(sp)
    80001674:	74e2                	ld	s1,56(sp)
    80001676:	7942                	ld	s2,48(sp)
    80001678:	79a2                	ld	s3,40(sp)
    8000167a:	7a02                	ld	s4,32(sp)
    8000167c:	6ae2                	ld	s5,24(sp)
    8000167e:	6b42                	ld	s6,16(sp)
    80001680:	6ba2                	ld	s7,8(sp)
    80001682:	6161                	add	sp,sp,80
    80001684:	8082                	ret
  return 0;
    80001686:	4501                	li	a0,0
}
    80001688:	8082                	ret

000000008000168a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000168a:	1141                	add	sp,sp,-16
    8000168c:	e406                	sd	ra,8(sp)
    8000168e:	e022                	sd	s0,0(sp)
    80001690:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001692:	4601                	li	a2,0
    80001694:	00000097          	auipc	ra,0x0
    80001698:	94a080e7          	jalr	-1718(ra) # 80000fde <walk>
  if(pte == 0)
    8000169c:	c901                	beqz	a0,800016ac <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000169e:	611c                	ld	a5,0(a0)
    800016a0:	9bbd                	and	a5,a5,-17
    800016a2:	e11c                	sd	a5,0(a0)
}
    800016a4:	60a2                	ld	ra,8(sp)
    800016a6:	6402                	ld	s0,0(sp)
    800016a8:	0141                	add	sp,sp,16
    800016aa:	8082                	ret
    panic("uvmclear");
    800016ac:	00007517          	auipc	a0,0x7
    800016b0:	b0c50513          	add	a0,a0,-1268 # 800081b8 <digits+0x178>
    800016b4:	fffff097          	auipc	ra,0xfffff
    800016b8:	e8e080e7          	jalr	-370(ra) # 80000542 <panic>

00000000800016bc <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016bc:	c6bd                	beqz	a3,8000172a <copyout+0x6e>
{
    800016be:	715d                	add	sp,sp,-80
    800016c0:	e486                	sd	ra,72(sp)
    800016c2:	e0a2                	sd	s0,64(sp)
    800016c4:	fc26                	sd	s1,56(sp)
    800016c6:	f84a                	sd	s2,48(sp)
    800016c8:	f44e                	sd	s3,40(sp)
    800016ca:	f052                	sd	s4,32(sp)
    800016cc:	ec56                	sd	s5,24(sp)
    800016ce:	e85a                	sd	s6,16(sp)
    800016d0:	e45e                	sd	s7,8(sp)
    800016d2:	e062                	sd	s8,0(sp)
    800016d4:	0880                	add	s0,sp,80
    800016d6:	8b2a                	mv	s6,a0
    800016d8:	8c2e                	mv	s8,a1
    800016da:	8a32                	mv	s4,a2
    800016dc:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800016de:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    800016e0:	6a85                	lui	s5,0x1
    800016e2:	a015                	j	80001706 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800016e4:	9562                	add	a0,a0,s8
    800016e6:	0004861b          	sext.w	a2,s1
    800016ea:	85d2                	mv	a1,s4
    800016ec:	41250533          	sub	a0,a0,s2
    800016f0:	fffff097          	auipc	ra,0xfffff
    800016f4:	664080e7          	jalr	1636(ra) # 80000d54 <memmove>

    len -= n;
    800016f8:	409989b3          	sub	s3,s3,s1
    src += n;
    800016fc:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800016fe:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001702:	02098263          	beqz	s3,80001726 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001706:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000170a:	85ca                	mv	a1,s2
    8000170c:	855a                	mv	a0,s6
    8000170e:	00000097          	auipc	ra,0x0
    80001712:	976080e7          	jalr	-1674(ra) # 80001084 <walkaddr>
    if(pa0 == 0)
    80001716:	cd01                	beqz	a0,8000172e <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001718:	418904b3          	sub	s1,s2,s8
    8000171c:	94d6                	add	s1,s1,s5
    8000171e:	fc99f3e3          	bgeu	s3,s1,800016e4 <copyout+0x28>
    80001722:	84ce                	mv	s1,s3
    80001724:	b7c1                	j	800016e4 <copyout+0x28>
  }
  return 0;
    80001726:	4501                	li	a0,0
    80001728:	a021                	j	80001730 <copyout+0x74>
    8000172a:	4501                	li	a0,0
}
    8000172c:	8082                	ret
      return -1;
    8000172e:	557d                	li	a0,-1
}
    80001730:	60a6                	ld	ra,72(sp)
    80001732:	6406                	ld	s0,64(sp)
    80001734:	74e2                	ld	s1,56(sp)
    80001736:	7942                	ld	s2,48(sp)
    80001738:	79a2                	ld	s3,40(sp)
    8000173a:	7a02                	ld	s4,32(sp)
    8000173c:	6ae2                	ld	s5,24(sp)
    8000173e:	6b42                	ld	s6,16(sp)
    80001740:	6ba2                	ld	s7,8(sp)
    80001742:	6c02                	ld	s8,0(sp)
    80001744:	6161                	add	sp,sp,80
    80001746:	8082                	ret

0000000080001748 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001748:	caa5                	beqz	a3,800017b8 <copyin+0x70>
{
    8000174a:	715d                	add	sp,sp,-80
    8000174c:	e486                	sd	ra,72(sp)
    8000174e:	e0a2                	sd	s0,64(sp)
    80001750:	fc26                	sd	s1,56(sp)
    80001752:	f84a                	sd	s2,48(sp)
    80001754:	f44e                	sd	s3,40(sp)
    80001756:	f052                	sd	s4,32(sp)
    80001758:	ec56                	sd	s5,24(sp)
    8000175a:	e85a                	sd	s6,16(sp)
    8000175c:	e45e                	sd	s7,8(sp)
    8000175e:	e062                	sd	s8,0(sp)
    80001760:	0880                	add	s0,sp,80
    80001762:	8b2a                	mv	s6,a0
    80001764:	8a2e                	mv	s4,a1
    80001766:	8c32                	mv	s8,a2
    80001768:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000176a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000176c:	6a85                	lui	s5,0x1
    8000176e:	a01d                	j	80001794 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001770:	018505b3          	add	a1,a0,s8
    80001774:	0004861b          	sext.w	a2,s1
    80001778:	412585b3          	sub	a1,a1,s2
    8000177c:	8552                	mv	a0,s4
    8000177e:	fffff097          	auipc	ra,0xfffff
    80001782:	5d6080e7          	jalr	1494(ra) # 80000d54 <memmove>

    len -= n;
    80001786:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000178a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000178c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001790:	02098263          	beqz	s3,800017b4 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001794:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001798:	85ca                	mv	a1,s2
    8000179a:	855a                	mv	a0,s6
    8000179c:	00000097          	auipc	ra,0x0
    800017a0:	8e8080e7          	jalr	-1816(ra) # 80001084 <walkaddr>
    if(pa0 == 0)
    800017a4:	cd01                	beqz	a0,800017bc <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    800017a6:	418904b3          	sub	s1,s2,s8
    800017aa:	94d6                	add	s1,s1,s5
    800017ac:	fc99f2e3          	bgeu	s3,s1,80001770 <copyin+0x28>
    800017b0:	84ce                	mv	s1,s3
    800017b2:	bf7d                	j	80001770 <copyin+0x28>
  }
  return 0;
    800017b4:	4501                	li	a0,0
    800017b6:	a021                	j	800017be <copyin+0x76>
    800017b8:	4501                	li	a0,0
}
    800017ba:	8082                	ret
      return -1;
    800017bc:	557d                	li	a0,-1
}
    800017be:	60a6                	ld	ra,72(sp)
    800017c0:	6406                	ld	s0,64(sp)
    800017c2:	74e2                	ld	s1,56(sp)
    800017c4:	7942                	ld	s2,48(sp)
    800017c6:	79a2                	ld	s3,40(sp)
    800017c8:	7a02                	ld	s4,32(sp)
    800017ca:	6ae2                	ld	s5,24(sp)
    800017cc:	6b42                	ld	s6,16(sp)
    800017ce:	6ba2                	ld	s7,8(sp)
    800017d0:	6c02                	ld	s8,0(sp)
    800017d2:	6161                	add	sp,sp,80
    800017d4:	8082                	ret

00000000800017d6 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800017d6:	c2dd                	beqz	a3,8000187c <copyinstr+0xa6>
{
    800017d8:	715d                	add	sp,sp,-80
    800017da:	e486                	sd	ra,72(sp)
    800017dc:	e0a2                	sd	s0,64(sp)
    800017de:	fc26                	sd	s1,56(sp)
    800017e0:	f84a                	sd	s2,48(sp)
    800017e2:	f44e                	sd	s3,40(sp)
    800017e4:	f052                	sd	s4,32(sp)
    800017e6:	ec56                	sd	s5,24(sp)
    800017e8:	e85a                	sd	s6,16(sp)
    800017ea:	e45e                	sd	s7,8(sp)
    800017ec:	0880                	add	s0,sp,80
    800017ee:	8a2a                	mv	s4,a0
    800017f0:	8b2e                	mv	s6,a1
    800017f2:	8bb2                	mv	s7,a2
    800017f4:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800017f6:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017f8:	6985                	lui	s3,0x1
    800017fa:	a02d                	j	80001824 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800017fc:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001800:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001802:	37fd                	addw	a5,a5,-1
    80001804:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
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
    8000181a:	6161                	add	sp,sp,80
    8000181c:	8082                	ret
    srcva = va0 + PGSIZE;
    8000181e:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80001822:	c8a9                	beqz	s1,80001874 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80001824:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001828:	85ca                	mv	a1,s2
    8000182a:	8552                	mv	a0,s4
    8000182c:	00000097          	auipc	ra,0x0
    80001830:	858080e7          	jalr	-1960(ra) # 80001084 <walkaddr>
    if(pa0 == 0)
    80001834:	c131                	beqz	a0,80001878 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80001836:	417906b3          	sub	a3,s2,s7
    8000183a:	96ce                	add	a3,a3,s3
    8000183c:	00d4f363          	bgeu	s1,a3,80001842 <copyinstr+0x6c>
    80001840:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001842:	955e                	add	a0,a0,s7
    80001844:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001848:	daf9                	beqz	a3,8000181e <copyinstr+0x48>
    8000184a:	87da                	mv	a5,s6
    8000184c:	885a                	mv	a6,s6
      if(*p == '\0'){
    8000184e:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001852:	96da                	add	a3,a3,s6
    80001854:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001856:	00f60733          	add	a4,a2,a5
    8000185a:	00074703          	lbu	a4,0(a4)
    8000185e:	df59                	beqz	a4,800017fc <copyinstr+0x26>
        *dst = *p;
    80001860:	00e78023          	sb	a4,0(a5)
      dst++;
    80001864:	0785                	add	a5,a5,1
    while(n > 0){
    80001866:	fed797e3          	bne	a5,a3,80001854 <copyinstr+0x7e>
    8000186a:	14fd                	add	s1,s1,-1
    8000186c:	94c2                	add	s1,s1,a6
      --max;
    8000186e:	8c8d                	sub	s1,s1,a1
      dst++;
    80001870:	8b3e                	mv	s6,a5
    80001872:	b775                	j	8000181e <copyinstr+0x48>
    80001874:	4781                	li	a5,0
    80001876:	b771                	j	80001802 <copyinstr+0x2c>
      return -1;
    80001878:	557d                	li	a0,-1
    8000187a:	b779                	j	80001808 <copyinstr+0x32>
  int got_null = 0;
    8000187c:	4781                	li	a5,0
  if(got_null){
    8000187e:	37fd                	addw	a5,a5,-1
    80001880:	0007851b          	sext.w	a0,a5
}
    80001884:	8082                	ret

0000000080001886 <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    80001886:	1101                	add	sp,sp,-32
    80001888:	ec06                	sd	ra,24(sp)
    8000188a:	e822                	sd	s0,16(sp)
    8000188c:	e426                	sd	s1,8(sp)
    8000188e:	1000                	add	s0,sp,32
    80001890:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001892:	fffff097          	auipc	ra,0xfffff
    80001896:	2f0080e7          	jalr	752(ra) # 80000b82 <holding>
    8000189a:	c909                	beqz	a0,800018ac <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    8000189c:	749c                	ld	a5,40(s1)
    8000189e:	00978f63          	beq	a5,s1,800018bc <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    800018a2:	60e2                	ld	ra,24(sp)
    800018a4:	6442                	ld	s0,16(sp)
    800018a6:	64a2                	ld	s1,8(sp)
    800018a8:	6105                	add	sp,sp,32
    800018aa:	8082                	ret
    panic("wakeup1");
    800018ac:	00007517          	auipc	a0,0x7
    800018b0:	91c50513          	add	a0,a0,-1764 # 800081c8 <digits+0x188>
    800018b4:	fffff097          	auipc	ra,0xfffff
    800018b8:	c8e080e7          	jalr	-882(ra) # 80000542 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    800018bc:	4c98                	lw	a4,24(s1)
    800018be:	4785                	li	a5,1
    800018c0:	fef711e3          	bne	a4,a5,800018a2 <wakeup1+0x1c>
    p->state = RUNNABLE;
    800018c4:	4789                	li	a5,2
    800018c6:	cc9c                	sw	a5,24(s1)
}
    800018c8:	bfe9                	j	800018a2 <wakeup1+0x1c>

00000000800018ca <procinit>:
{
    800018ca:	715d                	add	sp,sp,-80
    800018cc:	e486                	sd	ra,72(sp)
    800018ce:	e0a2                	sd	s0,64(sp)
    800018d0:	fc26                	sd	s1,56(sp)
    800018d2:	f84a                	sd	s2,48(sp)
    800018d4:	f44e                	sd	s3,40(sp)
    800018d6:	f052                	sd	s4,32(sp)
    800018d8:	ec56                	sd	s5,24(sp)
    800018da:	e85a                	sd	s6,16(sp)
    800018dc:	e45e                	sd	s7,8(sp)
    800018de:	0880                	add	s0,sp,80
  initlock(&pid_lock, "nextpid");
    800018e0:	00007597          	auipc	a1,0x7
    800018e4:	8f058593          	add	a1,a1,-1808 # 800081d0 <digits+0x190>
    800018e8:	00010517          	auipc	a0,0x10
    800018ec:	06850513          	add	a0,a0,104 # 80011950 <pid_lock>
    800018f0:	fffff097          	auipc	ra,0xfffff
    800018f4:	27c080e7          	jalr	636(ra) # 80000b6c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018f8:	00010917          	auipc	s2,0x10
    800018fc:	47090913          	add	s2,s2,1136 # 80011d68 <proc>
      initlock(&p->lock, "proc");
    80001900:	00007b97          	auipc	s7,0x7
    80001904:	8d8b8b93          	add	s7,s7,-1832 # 800081d8 <digits+0x198>
      uint64 va = KSTACK((int) (p - proc));
    80001908:	8b4a                	mv	s6,s2
    8000190a:	00006a97          	auipc	s5,0x6
    8000190e:	6f6a8a93          	add	s5,s5,1782 # 80008000 <etext>
    80001912:	040009b7          	lui	s3,0x4000
    80001916:	19fd                	add	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001918:	09b2                	sll	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000191a:	00016a17          	auipc	s4,0x16
    8000191e:	e4ea0a13          	add	s4,s4,-434 # 80017768 <tickslock>
      initlock(&p->lock, "proc");
    80001922:	85de                	mv	a1,s7
    80001924:	854a                	mv	a0,s2
    80001926:	fffff097          	auipc	ra,0xfffff
    8000192a:	246080e7          	jalr	582(ra) # 80000b6c <initlock>
      char *pa = kalloc();
    8000192e:	fffff097          	auipc	ra,0xfffff
    80001932:	1de080e7          	jalr	478(ra) # 80000b0c <kalloc>
    80001936:	85aa                	mv	a1,a0
      if(pa == 0)
    80001938:	c929                	beqz	a0,8000198a <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc));
    8000193a:	416904b3          	sub	s1,s2,s6
    8000193e:	848d                	sra	s1,s1,0x3
    80001940:	000ab783          	ld	a5,0(s5)
    80001944:	02f484b3          	mul	s1,s1,a5
    80001948:	2485                	addw	s1,s1,1
    8000194a:	00d4949b          	sllw	s1,s1,0xd
    8000194e:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001952:	4699                	li	a3,6
    80001954:	6605                	lui	a2,0x1
    80001956:	8526                	mv	a0,s1
    80001958:	00000097          	auipc	ra,0x0
    8000195c:	85a080e7          	jalr	-1958(ra) # 800011b2 <kvmmap>
      p->kstack = va;
    80001960:	04993023          	sd	s1,64(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001964:	16890913          	add	s2,s2,360
    80001968:	fb491de3          	bne	s2,s4,80001922 <procinit+0x58>
  kvminithart();
    8000196c:	fffff097          	auipc	ra,0xfffff
    80001970:	64e080e7          	jalr	1614(ra) # 80000fba <kvminithart>
}
    80001974:	60a6                	ld	ra,72(sp)
    80001976:	6406                	ld	s0,64(sp)
    80001978:	74e2                	ld	s1,56(sp)
    8000197a:	7942                	ld	s2,48(sp)
    8000197c:	79a2                	ld	s3,40(sp)
    8000197e:	7a02                	ld	s4,32(sp)
    80001980:	6ae2                	ld	s5,24(sp)
    80001982:	6b42                	ld	s6,16(sp)
    80001984:	6ba2                	ld	s7,8(sp)
    80001986:	6161                	add	sp,sp,80
    80001988:	8082                	ret
        panic("kalloc");
    8000198a:	00007517          	auipc	a0,0x7
    8000198e:	85650513          	add	a0,a0,-1962 # 800081e0 <digits+0x1a0>
    80001992:	fffff097          	auipc	ra,0xfffff
    80001996:	bb0080e7          	jalr	-1104(ra) # 80000542 <panic>

000000008000199a <cpuid>:
{
    8000199a:	1141                	add	sp,sp,-16
    8000199c:	e422                	sd	s0,8(sp)
    8000199e:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800019a0:	8512                	mv	a0,tp
}
    800019a2:	2501                	sext.w	a0,a0
    800019a4:	6422                	ld	s0,8(sp)
    800019a6:	0141                	add	sp,sp,16
    800019a8:	8082                	ret

00000000800019aa <mycpu>:
mycpu(void) {
    800019aa:	1141                	add	sp,sp,-16
    800019ac:	e422                	sd	s0,8(sp)
    800019ae:	0800                	add	s0,sp,16
    800019b0:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    800019b2:	2781                	sext.w	a5,a5
    800019b4:	079e                	sll	a5,a5,0x7
}
    800019b6:	00010517          	auipc	a0,0x10
    800019ba:	fb250513          	add	a0,a0,-78 # 80011968 <cpus>
    800019be:	953e                	add	a0,a0,a5
    800019c0:	6422                	ld	s0,8(sp)
    800019c2:	0141                	add	sp,sp,16
    800019c4:	8082                	ret

00000000800019c6 <myproc>:
myproc(void) {
    800019c6:	1101                	add	sp,sp,-32
    800019c8:	ec06                	sd	ra,24(sp)
    800019ca:	e822                	sd	s0,16(sp)
    800019cc:	e426                	sd	s1,8(sp)
    800019ce:	1000                	add	s0,sp,32
  push_off();
    800019d0:	fffff097          	auipc	ra,0xfffff
    800019d4:	1e0080e7          	jalr	480(ra) # 80000bb0 <push_off>
    800019d8:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    800019da:	2781                	sext.w	a5,a5
    800019dc:	079e                	sll	a5,a5,0x7
    800019de:	00010717          	auipc	a4,0x10
    800019e2:	f7270713          	add	a4,a4,-142 # 80011950 <pid_lock>
    800019e6:	97ba                	add	a5,a5,a4
    800019e8:	6f84                	ld	s1,24(a5)
  pop_off();
    800019ea:	fffff097          	auipc	ra,0xfffff
    800019ee:	266080e7          	jalr	614(ra) # 80000c50 <pop_off>
}
    800019f2:	8526                	mv	a0,s1
    800019f4:	60e2                	ld	ra,24(sp)
    800019f6:	6442                	ld	s0,16(sp)
    800019f8:	64a2                	ld	s1,8(sp)
    800019fa:	6105                	add	sp,sp,32
    800019fc:	8082                	ret

00000000800019fe <forkret>:
{
    800019fe:	1141                	add	sp,sp,-16
    80001a00:	e406                	sd	ra,8(sp)
    80001a02:	e022                	sd	s0,0(sp)
    80001a04:	0800                	add	s0,sp,16
  release(&myproc()->lock);
    80001a06:	00000097          	auipc	ra,0x0
    80001a0a:	fc0080e7          	jalr	-64(ra) # 800019c6 <myproc>
    80001a0e:	fffff097          	auipc	ra,0xfffff
    80001a12:	2a2080e7          	jalr	674(ra) # 80000cb0 <release>
  if (first) {
    80001a16:	00007797          	auipc	a5,0x7
    80001a1a:	dfa7a783          	lw	a5,-518(a5) # 80008810 <first.1>
    80001a1e:	eb89                	bnez	a5,80001a30 <forkret+0x32>
  usertrapret();
    80001a20:	00001097          	auipc	ra,0x1
    80001a24:	c1c080e7          	jalr	-996(ra) # 8000263c <usertrapret>
}
    80001a28:	60a2                	ld	ra,8(sp)
    80001a2a:	6402                	ld	s0,0(sp)
    80001a2c:	0141                	add	sp,sp,16
    80001a2e:	8082                	ret
    first = 0;
    80001a30:	00007797          	auipc	a5,0x7
    80001a34:	de07a023          	sw	zero,-544(a5) # 80008810 <first.1>
    fsinit(ROOTDEV);
    80001a38:	4505                	li	a0,1
    80001a3a:	00002097          	auipc	ra,0x2
    80001a3e:	944080e7          	jalr	-1724(ra) # 8000337e <fsinit>
    80001a42:	bff9                	j	80001a20 <forkret+0x22>

0000000080001a44 <allocpid>:
allocpid() {
    80001a44:	1101                	add	sp,sp,-32
    80001a46:	ec06                	sd	ra,24(sp)
    80001a48:	e822                	sd	s0,16(sp)
    80001a4a:	e426                	sd	s1,8(sp)
    80001a4c:	e04a                	sd	s2,0(sp)
    80001a4e:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    80001a50:	00010917          	auipc	s2,0x10
    80001a54:	f0090913          	add	s2,s2,-256 # 80011950 <pid_lock>
    80001a58:	854a                	mv	a0,s2
    80001a5a:	fffff097          	auipc	ra,0xfffff
    80001a5e:	1a2080e7          	jalr	418(ra) # 80000bfc <acquire>
  pid = nextpid;
    80001a62:	00007797          	auipc	a5,0x7
    80001a66:	db278793          	add	a5,a5,-590 # 80008814 <nextpid>
    80001a6a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a6c:	0014871b          	addw	a4,s1,1
    80001a70:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a72:	854a                	mv	a0,s2
    80001a74:	fffff097          	auipc	ra,0xfffff
    80001a78:	23c080e7          	jalr	572(ra) # 80000cb0 <release>
}
    80001a7c:	8526                	mv	a0,s1
    80001a7e:	60e2                	ld	ra,24(sp)
    80001a80:	6442                	ld	s0,16(sp)
    80001a82:	64a2                	ld	s1,8(sp)
    80001a84:	6902                	ld	s2,0(sp)
    80001a86:	6105                	add	sp,sp,32
    80001a88:	8082                	ret

0000000080001a8a <proc_pagetable>:
{
    80001a8a:	1101                	add	sp,sp,-32
    80001a8c:	ec06                	sd	ra,24(sp)
    80001a8e:	e822                	sd	s0,16(sp)
    80001a90:	e426                	sd	s1,8(sp)
    80001a92:	e04a                	sd	s2,0(sp)
    80001a94:	1000                	add	s0,sp,32
    80001a96:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a98:	00000097          	auipc	ra,0x0
    80001a9c:	8e8080e7          	jalr	-1816(ra) # 80001380 <uvmcreate>
    80001aa0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001aa2:	c121                	beqz	a0,80001ae2 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001aa4:	4729                	li	a4,10
    80001aa6:	00005697          	auipc	a3,0x5
    80001aaa:	55a68693          	add	a3,a3,1370 # 80007000 <_trampoline>
    80001aae:	6605                	lui	a2,0x1
    80001ab0:	040005b7          	lui	a1,0x4000
    80001ab4:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ab6:	05b2                	sll	a1,a1,0xc
    80001ab8:	fffff097          	auipc	ra,0xfffff
    80001abc:	66c080e7          	jalr	1644(ra) # 80001124 <mappages>
    80001ac0:	02054863          	bltz	a0,80001af0 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001ac4:	4719                	li	a4,6
    80001ac6:	05893683          	ld	a3,88(s2)
    80001aca:	6605                	lui	a2,0x1
    80001acc:	020005b7          	lui	a1,0x2000
    80001ad0:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001ad2:	05b6                	sll	a1,a1,0xd
    80001ad4:	8526                	mv	a0,s1
    80001ad6:	fffff097          	auipc	ra,0xfffff
    80001ada:	64e080e7          	jalr	1614(ra) # 80001124 <mappages>
    80001ade:	02054163          	bltz	a0,80001b00 <proc_pagetable+0x76>
}
    80001ae2:	8526                	mv	a0,s1
    80001ae4:	60e2                	ld	ra,24(sp)
    80001ae6:	6442                	ld	s0,16(sp)
    80001ae8:	64a2                	ld	s1,8(sp)
    80001aea:	6902                	ld	s2,0(sp)
    80001aec:	6105                	add	sp,sp,32
    80001aee:	8082                	ret
    uvmfree(pagetable, 0);
    80001af0:	4581                	li	a1,0
    80001af2:	8526                	mv	a0,s1
    80001af4:	00000097          	auipc	ra,0x0
    80001af8:	a8a080e7          	jalr	-1398(ra) # 8000157e <uvmfree>
    return 0;
    80001afc:	4481                	li	s1,0
    80001afe:	b7d5                	j	80001ae2 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b00:	4681                	li	a3,0
    80001b02:	4605                	li	a2,1
    80001b04:	040005b7          	lui	a1,0x4000
    80001b08:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b0a:	05b2                	sll	a1,a1,0xc
    80001b0c:	8526                	mv	a0,s1
    80001b0e:	fffff097          	auipc	ra,0xfffff
    80001b12:	7ae080e7          	jalr	1966(ra) # 800012bc <uvmunmap>
    uvmfree(pagetable, 0);
    80001b16:	4581                	li	a1,0
    80001b18:	8526                	mv	a0,s1
    80001b1a:	00000097          	auipc	ra,0x0
    80001b1e:	a64080e7          	jalr	-1436(ra) # 8000157e <uvmfree>
    return 0;
    80001b22:	4481                	li	s1,0
    80001b24:	bf7d                	j	80001ae2 <proc_pagetable+0x58>

0000000080001b26 <proc_freepagetable>:
{
    80001b26:	1101                	add	sp,sp,-32
    80001b28:	ec06                	sd	ra,24(sp)
    80001b2a:	e822                	sd	s0,16(sp)
    80001b2c:	e426                	sd	s1,8(sp)
    80001b2e:	e04a                	sd	s2,0(sp)
    80001b30:	1000                	add	s0,sp,32
    80001b32:	84aa                	mv	s1,a0
    80001b34:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b36:	4681                	li	a3,0
    80001b38:	4605                	li	a2,1
    80001b3a:	040005b7          	lui	a1,0x4000
    80001b3e:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b40:	05b2                	sll	a1,a1,0xc
    80001b42:	fffff097          	auipc	ra,0xfffff
    80001b46:	77a080e7          	jalr	1914(ra) # 800012bc <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b4a:	4681                	li	a3,0
    80001b4c:	4605                	li	a2,1
    80001b4e:	020005b7          	lui	a1,0x2000
    80001b52:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b54:	05b6                	sll	a1,a1,0xd
    80001b56:	8526                	mv	a0,s1
    80001b58:	fffff097          	auipc	ra,0xfffff
    80001b5c:	764080e7          	jalr	1892(ra) # 800012bc <uvmunmap>
  uvmfree(pagetable, sz);
    80001b60:	85ca                	mv	a1,s2
    80001b62:	8526                	mv	a0,s1
    80001b64:	00000097          	auipc	ra,0x0
    80001b68:	a1a080e7          	jalr	-1510(ra) # 8000157e <uvmfree>
}
    80001b6c:	60e2                	ld	ra,24(sp)
    80001b6e:	6442                	ld	s0,16(sp)
    80001b70:	64a2                	ld	s1,8(sp)
    80001b72:	6902                	ld	s2,0(sp)
    80001b74:	6105                	add	sp,sp,32
    80001b76:	8082                	ret

0000000080001b78 <freeproc>:
{
    80001b78:	1101                	add	sp,sp,-32
    80001b7a:	ec06                	sd	ra,24(sp)
    80001b7c:	e822                	sd	s0,16(sp)
    80001b7e:	e426                	sd	s1,8(sp)
    80001b80:	1000                	add	s0,sp,32
    80001b82:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b84:	6d28                	ld	a0,88(a0)
    80001b86:	c509                	beqz	a0,80001b90 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001b88:	fffff097          	auipc	ra,0xfffff
    80001b8c:	e86080e7          	jalr	-378(ra) # 80000a0e <kfree>
  p->trapframe = 0;
    80001b90:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b94:	68a8                	ld	a0,80(s1)
    80001b96:	c511                	beqz	a0,80001ba2 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001b98:	64ac                	ld	a1,72(s1)
    80001b9a:	00000097          	auipc	ra,0x0
    80001b9e:	f8c080e7          	jalr	-116(ra) # 80001b26 <proc_freepagetable>
  p->pagetable = 0;
    80001ba2:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001ba6:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001baa:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001bae:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001bb2:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001bb6:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001bba:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001bbe:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001bc2:	0004ac23          	sw	zero,24(s1)
}
    80001bc6:	60e2                	ld	ra,24(sp)
    80001bc8:	6442                	ld	s0,16(sp)
    80001bca:	64a2                	ld	s1,8(sp)
    80001bcc:	6105                	add	sp,sp,32
    80001bce:	8082                	ret

0000000080001bd0 <allocproc>:
{
    80001bd0:	1101                	add	sp,sp,-32
    80001bd2:	ec06                	sd	ra,24(sp)
    80001bd4:	e822                	sd	s0,16(sp)
    80001bd6:	e426                	sd	s1,8(sp)
    80001bd8:	e04a                	sd	s2,0(sp)
    80001bda:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bdc:	00010497          	auipc	s1,0x10
    80001be0:	18c48493          	add	s1,s1,396 # 80011d68 <proc>
    80001be4:	00016917          	auipc	s2,0x16
    80001be8:	b8490913          	add	s2,s2,-1148 # 80017768 <tickslock>
    acquire(&p->lock);
    80001bec:	8526                	mv	a0,s1
    80001bee:	fffff097          	auipc	ra,0xfffff
    80001bf2:	00e080e7          	jalr	14(ra) # 80000bfc <acquire>
    if(p->state == UNUSED) {
    80001bf6:	4c9c                	lw	a5,24(s1)
    80001bf8:	cf81                	beqz	a5,80001c10 <allocproc+0x40>
      release(&p->lock);
    80001bfa:	8526                	mv	a0,s1
    80001bfc:	fffff097          	auipc	ra,0xfffff
    80001c00:	0b4080e7          	jalr	180(ra) # 80000cb0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c04:	16848493          	add	s1,s1,360
    80001c08:	ff2492e3          	bne	s1,s2,80001bec <allocproc+0x1c>
  return 0;
    80001c0c:	4481                	li	s1,0
    80001c0e:	a0b9                	j	80001c5c <allocproc+0x8c>
  p->pid = allocpid();
    80001c10:	00000097          	auipc	ra,0x0
    80001c14:	e34080e7          	jalr	-460(ra) # 80001a44 <allocpid>
    80001c18:	dc88                	sw	a0,56(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c1a:	fffff097          	auipc	ra,0xfffff
    80001c1e:	ef2080e7          	jalr	-270(ra) # 80000b0c <kalloc>
    80001c22:	892a                	mv	s2,a0
    80001c24:	eca8                	sd	a0,88(s1)
    80001c26:	c131                	beqz	a0,80001c6a <allocproc+0x9a>
  p->pagetable = proc_pagetable(p);
    80001c28:	8526                	mv	a0,s1
    80001c2a:	00000097          	auipc	ra,0x0
    80001c2e:	e60080e7          	jalr	-416(ra) # 80001a8a <proc_pagetable>
    80001c32:	892a                	mv	s2,a0
    80001c34:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c36:	c129                	beqz	a0,80001c78 <allocproc+0xa8>
  memset(&p->context, 0, sizeof(p->context));
    80001c38:	07000613          	li	a2,112
    80001c3c:	4581                	li	a1,0
    80001c3e:	06048513          	add	a0,s1,96
    80001c42:	fffff097          	auipc	ra,0xfffff
    80001c46:	0b6080e7          	jalr	182(ra) # 80000cf8 <memset>
  p->context.ra = (uint64)forkret;
    80001c4a:	00000797          	auipc	a5,0x0
    80001c4e:	db478793          	add	a5,a5,-588 # 800019fe <forkret>
    80001c52:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c54:	60bc                	ld	a5,64(s1)
    80001c56:	6705                	lui	a4,0x1
    80001c58:	97ba                	add	a5,a5,a4
    80001c5a:	f4bc                	sd	a5,104(s1)
}
    80001c5c:	8526                	mv	a0,s1
    80001c5e:	60e2                	ld	ra,24(sp)
    80001c60:	6442                	ld	s0,16(sp)
    80001c62:	64a2                	ld	s1,8(sp)
    80001c64:	6902                	ld	s2,0(sp)
    80001c66:	6105                	add	sp,sp,32
    80001c68:	8082                	ret
    release(&p->lock);
    80001c6a:	8526                	mv	a0,s1
    80001c6c:	fffff097          	auipc	ra,0xfffff
    80001c70:	044080e7          	jalr	68(ra) # 80000cb0 <release>
    return 0;
    80001c74:	84ca                	mv	s1,s2
    80001c76:	b7dd                	j	80001c5c <allocproc+0x8c>
    freeproc(p);
    80001c78:	8526                	mv	a0,s1
    80001c7a:	00000097          	auipc	ra,0x0
    80001c7e:	efe080e7          	jalr	-258(ra) # 80001b78 <freeproc>
    release(&p->lock);
    80001c82:	8526                	mv	a0,s1
    80001c84:	fffff097          	auipc	ra,0xfffff
    80001c88:	02c080e7          	jalr	44(ra) # 80000cb0 <release>
    return 0;
    80001c8c:	84ca                	mv	s1,s2
    80001c8e:	b7f9                	j	80001c5c <allocproc+0x8c>

0000000080001c90 <userinit>:
{
    80001c90:	1101                	add	sp,sp,-32
    80001c92:	ec06                	sd	ra,24(sp)
    80001c94:	e822                	sd	s0,16(sp)
    80001c96:	e426                	sd	s1,8(sp)
    80001c98:	1000                	add	s0,sp,32
  p = allocproc();
    80001c9a:	00000097          	auipc	ra,0x0
    80001c9e:	f36080e7          	jalr	-202(ra) # 80001bd0 <allocproc>
    80001ca2:	84aa                	mv	s1,a0
  initproc = p;
    80001ca4:	00007797          	auipc	a5,0x7
    80001ca8:	36a7ba23          	sd	a0,884(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001cac:	03400613          	li	a2,52
    80001cb0:	00007597          	auipc	a1,0x7
    80001cb4:	b7058593          	add	a1,a1,-1168 # 80008820 <initcode>
    80001cb8:	6928                	ld	a0,80(a0)
    80001cba:	fffff097          	auipc	ra,0xfffff
    80001cbe:	6f4080e7          	jalr	1780(ra) # 800013ae <uvminit>
  p->sz = PGSIZE;
    80001cc2:	6785                	lui	a5,0x1
    80001cc4:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001cc6:	6cb8                	ld	a4,88(s1)
    80001cc8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001ccc:	6cb8                	ld	a4,88(s1)
    80001cce:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001cd0:	4641                	li	a2,16
    80001cd2:	00006597          	auipc	a1,0x6
    80001cd6:	51658593          	add	a1,a1,1302 # 800081e8 <digits+0x1a8>
    80001cda:	15848513          	add	a0,s1,344
    80001cde:	fffff097          	auipc	ra,0xfffff
    80001ce2:	16a080e7          	jalr	362(ra) # 80000e48 <safestrcpy>
  p->cwd = namei("/");
    80001ce6:	00006517          	auipc	a0,0x6
    80001cea:	51250513          	add	a0,a0,1298 # 800081f8 <digits+0x1b8>
    80001cee:	00002097          	auipc	ra,0x2
    80001cf2:	0b8080e7          	jalr	184(ra) # 80003da6 <namei>
    80001cf6:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001cfa:	4789                	li	a5,2
    80001cfc:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001cfe:	8526                	mv	a0,s1
    80001d00:	fffff097          	auipc	ra,0xfffff
    80001d04:	fb0080e7          	jalr	-80(ra) # 80000cb0 <release>
}
    80001d08:	60e2                	ld	ra,24(sp)
    80001d0a:	6442                	ld	s0,16(sp)
    80001d0c:	64a2                	ld	s1,8(sp)
    80001d0e:	6105                	add	sp,sp,32
    80001d10:	8082                	ret

0000000080001d12 <growproc>:
{
    80001d12:	1101                	add	sp,sp,-32
    80001d14:	ec06                	sd	ra,24(sp)
    80001d16:	e822                	sd	s0,16(sp)
    80001d18:	e426                	sd	s1,8(sp)
    80001d1a:	e04a                	sd	s2,0(sp)
    80001d1c:	1000                	add	s0,sp,32
    80001d1e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d20:	00000097          	auipc	ra,0x0
    80001d24:	ca6080e7          	jalr	-858(ra) # 800019c6 <myproc>
    80001d28:	892a                	mv	s2,a0
  sz = p->sz;
    80001d2a:	652c                	ld	a1,72(a0)
    80001d2c:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001d30:	00904f63          	bgtz	s1,80001d4e <growproc+0x3c>
  } else if(n < 0){
    80001d34:	0204cd63          	bltz	s1,80001d6e <growproc+0x5c>
  p->sz = sz;
    80001d38:	1782                	sll	a5,a5,0x20
    80001d3a:	9381                	srl	a5,a5,0x20
    80001d3c:	04f93423          	sd	a5,72(s2)
  return 0;
    80001d40:	4501                	li	a0,0
}
    80001d42:	60e2                	ld	ra,24(sp)
    80001d44:	6442                	ld	s0,16(sp)
    80001d46:	64a2                	ld	s1,8(sp)
    80001d48:	6902                	ld	s2,0(sp)
    80001d4a:	6105                	add	sp,sp,32
    80001d4c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001d4e:	00f4863b          	addw	a2,s1,a5
    80001d52:	1602                	sll	a2,a2,0x20
    80001d54:	9201                	srl	a2,a2,0x20
    80001d56:	1582                	sll	a1,a1,0x20
    80001d58:	9181                	srl	a1,a1,0x20
    80001d5a:	6928                	ld	a0,80(a0)
    80001d5c:	fffff097          	auipc	ra,0xfffff
    80001d60:	70c080e7          	jalr	1804(ra) # 80001468 <uvmalloc>
    80001d64:	0005079b          	sext.w	a5,a0
    80001d68:	fbe1                	bnez	a5,80001d38 <growproc+0x26>
      return -1;
    80001d6a:	557d                	li	a0,-1
    80001d6c:	bfd9                	j	80001d42 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d6e:	00f4863b          	addw	a2,s1,a5
    80001d72:	1602                	sll	a2,a2,0x20
    80001d74:	9201                	srl	a2,a2,0x20
    80001d76:	1582                	sll	a1,a1,0x20
    80001d78:	9181                	srl	a1,a1,0x20
    80001d7a:	6928                	ld	a0,80(a0)
    80001d7c:	fffff097          	auipc	ra,0xfffff
    80001d80:	6a4080e7          	jalr	1700(ra) # 80001420 <uvmdealloc>
    80001d84:	0005079b          	sext.w	a5,a0
    80001d88:	bf45                	j	80001d38 <growproc+0x26>

0000000080001d8a <fork>:
{
    80001d8a:	7139                	add	sp,sp,-64
    80001d8c:	fc06                	sd	ra,56(sp)
    80001d8e:	f822                	sd	s0,48(sp)
    80001d90:	f426                	sd	s1,40(sp)
    80001d92:	f04a                	sd	s2,32(sp)
    80001d94:	ec4e                	sd	s3,24(sp)
    80001d96:	e852                	sd	s4,16(sp)
    80001d98:	e456                	sd	s5,8(sp)
    80001d9a:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001d9c:	00000097          	auipc	ra,0x0
    80001da0:	c2a080e7          	jalr	-982(ra) # 800019c6 <myproc>
    80001da4:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001da6:	00000097          	auipc	ra,0x0
    80001daa:	e2a080e7          	jalr	-470(ra) # 80001bd0 <allocproc>
    80001dae:	c17d                	beqz	a0,80001e94 <fork+0x10a>
    80001db0:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001db2:	048ab603          	ld	a2,72(s5)
    80001db6:	692c                	ld	a1,80(a0)
    80001db8:	050ab503          	ld	a0,80(s5)
    80001dbc:	fffff097          	auipc	ra,0xfffff
    80001dc0:	7fc080e7          	jalr	2044(ra) # 800015b8 <uvmcopy>
    80001dc4:	04054a63          	bltz	a0,80001e18 <fork+0x8e>
  np->sz = p->sz;
    80001dc8:	048ab783          	ld	a5,72(s5)
    80001dcc:	04fa3423          	sd	a5,72(s4)
  np->parent = p;
    80001dd0:	035a3023          	sd	s5,32(s4)
  *(np->trapframe) = *(p->trapframe);
    80001dd4:	058ab683          	ld	a3,88(s5)
    80001dd8:	87b6                	mv	a5,a3
    80001dda:	058a3703          	ld	a4,88(s4)
    80001dde:	12068693          	add	a3,a3,288
    80001de2:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001de6:	6788                	ld	a0,8(a5)
    80001de8:	6b8c                	ld	a1,16(a5)
    80001dea:	6f90                	ld	a2,24(a5)
    80001dec:	01073023          	sd	a6,0(a4)
    80001df0:	e708                	sd	a0,8(a4)
    80001df2:	eb0c                	sd	a1,16(a4)
    80001df4:	ef10                	sd	a2,24(a4)
    80001df6:	02078793          	add	a5,a5,32
    80001dfa:	02070713          	add	a4,a4,32
    80001dfe:	fed792e3          	bne	a5,a3,80001de2 <fork+0x58>
  np->trapframe->a0 = 0;
    80001e02:	058a3783          	ld	a5,88(s4)
    80001e06:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001e0a:	0d0a8493          	add	s1,s5,208
    80001e0e:	0d0a0913          	add	s2,s4,208
    80001e12:	150a8993          	add	s3,s5,336
    80001e16:	a00d                	j	80001e38 <fork+0xae>
    freeproc(np);
    80001e18:	8552                	mv	a0,s4
    80001e1a:	00000097          	auipc	ra,0x0
    80001e1e:	d5e080e7          	jalr	-674(ra) # 80001b78 <freeproc>
    release(&np->lock);
    80001e22:	8552                	mv	a0,s4
    80001e24:	fffff097          	auipc	ra,0xfffff
    80001e28:	e8c080e7          	jalr	-372(ra) # 80000cb0 <release>
    return -1;
    80001e2c:	54fd                	li	s1,-1
    80001e2e:	a889                	j	80001e80 <fork+0xf6>
  for(i = 0; i < NOFILE; i++)
    80001e30:	04a1                	add	s1,s1,8
    80001e32:	0921                	add	s2,s2,8
    80001e34:	01348b63          	beq	s1,s3,80001e4a <fork+0xc0>
    if(p->ofile[i])
    80001e38:	6088                	ld	a0,0(s1)
    80001e3a:	d97d                	beqz	a0,80001e30 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e3c:	00002097          	auipc	ra,0x2
    80001e40:	5d2080e7          	jalr	1490(ra) # 8000440e <filedup>
    80001e44:	00a93023          	sd	a0,0(s2)
    80001e48:	b7e5                	j	80001e30 <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001e4a:	150ab503          	ld	a0,336(s5)
    80001e4e:	00001097          	auipc	ra,0x1
    80001e52:	766080e7          	jalr	1894(ra) # 800035b4 <idup>
    80001e56:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e5a:	4641                	li	a2,16
    80001e5c:	158a8593          	add	a1,s5,344
    80001e60:	158a0513          	add	a0,s4,344
    80001e64:	fffff097          	auipc	ra,0xfffff
    80001e68:	fe4080e7          	jalr	-28(ra) # 80000e48 <safestrcpy>
  pid = np->pid;
    80001e6c:	038a2483          	lw	s1,56(s4)
  np->state = RUNNABLE;
    80001e70:	4789                	li	a5,2
    80001e72:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001e76:	8552                	mv	a0,s4
    80001e78:	fffff097          	auipc	ra,0xfffff
    80001e7c:	e38080e7          	jalr	-456(ra) # 80000cb0 <release>
}
    80001e80:	8526                	mv	a0,s1
    80001e82:	70e2                	ld	ra,56(sp)
    80001e84:	7442                	ld	s0,48(sp)
    80001e86:	74a2                	ld	s1,40(sp)
    80001e88:	7902                	ld	s2,32(sp)
    80001e8a:	69e2                	ld	s3,24(sp)
    80001e8c:	6a42                	ld	s4,16(sp)
    80001e8e:	6aa2                	ld	s5,8(sp)
    80001e90:	6121                	add	sp,sp,64
    80001e92:	8082                	ret
    return -1;
    80001e94:	54fd                	li	s1,-1
    80001e96:	b7ed                	j	80001e80 <fork+0xf6>

0000000080001e98 <reparent>:
{
    80001e98:	7179                	add	sp,sp,-48
    80001e9a:	f406                	sd	ra,40(sp)
    80001e9c:	f022                	sd	s0,32(sp)
    80001e9e:	ec26                	sd	s1,24(sp)
    80001ea0:	e84a                	sd	s2,16(sp)
    80001ea2:	e44e                	sd	s3,8(sp)
    80001ea4:	e052                	sd	s4,0(sp)
    80001ea6:	1800                	add	s0,sp,48
    80001ea8:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001eaa:	00010497          	auipc	s1,0x10
    80001eae:	ebe48493          	add	s1,s1,-322 # 80011d68 <proc>
      pp->parent = initproc;
    80001eb2:	00007a17          	auipc	s4,0x7
    80001eb6:	166a0a13          	add	s4,s4,358 # 80009018 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001eba:	00016997          	auipc	s3,0x16
    80001ebe:	8ae98993          	add	s3,s3,-1874 # 80017768 <tickslock>
    80001ec2:	a029                	j	80001ecc <reparent+0x34>
    80001ec4:	16848493          	add	s1,s1,360
    80001ec8:	03348363          	beq	s1,s3,80001eee <reparent+0x56>
    if(pp->parent == p){
    80001ecc:	709c                	ld	a5,32(s1)
    80001ece:	ff279be3          	bne	a5,s2,80001ec4 <reparent+0x2c>
      acquire(&pp->lock);
    80001ed2:	8526                	mv	a0,s1
    80001ed4:	fffff097          	auipc	ra,0xfffff
    80001ed8:	d28080e7          	jalr	-728(ra) # 80000bfc <acquire>
      pp->parent = initproc;
    80001edc:	000a3783          	ld	a5,0(s4)
    80001ee0:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80001ee2:	8526                	mv	a0,s1
    80001ee4:	fffff097          	auipc	ra,0xfffff
    80001ee8:	dcc080e7          	jalr	-564(ra) # 80000cb0 <release>
    80001eec:	bfe1                	j	80001ec4 <reparent+0x2c>
}
    80001eee:	70a2                	ld	ra,40(sp)
    80001ef0:	7402                	ld	s0,32(sp)
    80001ef2:	64e2                	ld	s1,24(sp)
    80001ef4:	6942                	ld	s2,16(sp)
    80001ef6:	69a2                	ld	s3,8(sp)
    80001ef8:	6a02                	ld	s4,0(sp)
    80001efa:	6145                	add	sp,sp,48
    80001efc:	8082                	ret

0000000080001efe <scheduler>:
{
    80001efe:	715d                	add	sp,sp,-80
    80001f00:	e486                	sd	ra,72(sp)
    80001f02:	e0a2                	sd	s0,64(sp)
    80001f04:	fc26                	sd	s1,56(sp)
    80001f06:	f84a                	sd	s2,48(sp)
    80001f08:	f44e                	sd	s3,40(sp)
    80001f0a:	f052                	sd	s4,32(sp)
    80001f0c:	ec56                	sd	s5,24(sp)
    80001f0e:	e85a                	sd	s6,16(sp)
    80001f10:	e45e                	sd	s7,8(sp)
    80001f12:	e062                	sd	s8,0(sp)
    80001f14:	0880                	add	s0,sp,80
    80001f16:	8792                	mv	a5,tp
  int id = r_tp();
    80001f18:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001f1a:	00779b93          	sll	s7,a5,0x7
    80001f1e:	00010717          	auipc	a4,0x10
    80001f22:	a3270713          	add	a4,a4,-1486 # 80011950 <pid_lock>
    80001f26:	975e                	add	a4,a4,s7
    80001f28:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    80001f2c:	00010717          	auipc	a4,0x10
    80001f30:	a4470713          	add	a4,a4,-1468 # 80011970 <cpus+0x8>
    80001f34:	9bba                	add	s7,s7,a4
    int nproc = 0;
    80001f36:	4c01                	li	s8,0
      if(p->state == RUNNABLE) {
    80001f38:	4a09                	li	s4,2
        c->proc = p;
    80001f3a:	079e                	sll	a5,a5,0x7
    80001f3c:	00010a97          	auipc	s5,0x10
    80001f40:	a14a8a93          	add	s5,s5,-1516 # 80011950 <pid_lock>
    80001f44:	9abe                	add	s5,s5,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f46:	00016997          	auipc	s3,0x16
    80001f4a:	82298993          	add	s3,s3,-2014 # 80017768 <tickslock>
    80001f4e:	a8a1                	j	80001fa6 <scheduler+0xa8>
      release(&p->lock);
    80001f50:	8526                	mv	a0,s1
    80001f52:	fffff097          	auipc	ra,0xfffff
    80001f56:	d5e080e7          	jalr	-674(ra) # 80000cb0 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f5a:	16848493          	add	s1,s1,360
    80001f5e:	03348a63          	beq	s1,s3,80001f92 <scheduler+0x94>
      acquire(&p->lock);
    80001f62:	8526                	mv	a0,s1
    80001f64:	fffff097          	auipc	ra,0xfffff
    80001f68:	c98080e7          	jalr	-872(ra) # 80000bfc <acquire>
      if(p->state != UNUSED) {
    80001f6c:	4c9c                	lw	a5,24(s1)
    80001f6e:	d3ed                	beqz	a5,80001f50 <scheduler+0x52>
        nproc++;
    80001f70:	2905                	addw	s2,s2,1
      if(p->state == RUNNABLE) {
    80001f72:	fd479fe3          	bne	a5,s4,80001f50 <scheduler+0x52>
        p->state = RUNNING;
    80001f76:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001f7a:	009abc23          	sd	s1,24(s5)
        swtch(&c->context, &p->context);
    80001f7e:	06048593          	add	a1,s1,96
    80001f82:	855e                	mv	a0,s7
    80001f84:	00000097          	auipc	ra,0x0
    80001f88:	60e080e7          	jalr	1550(ra) # 80002592 <swtch>
        c->proc = 0;
    80001f8c:	000abc23          	sd	zero,24(s5)
    80001f90:	b7c1                	j	80001f50 <scheduler+0x52>
    if(nproc <= 2) {   // only init and sh exist
    80001f92:	012a4a63          	blt	s4,s2,80001fa6 <scheduler+0xa8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f96:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f9a:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f9e:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001fa2:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fa6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001faa:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fae:	10079073          	csrw	sstatus,a5
    int nproc = 0;
    80001fb2:	8962                	mv	s2,s8
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fb4:	00010497          	auipc	s1,0x10
    80001fb8:	db448493          	add	s1,s1,-588 # 80011d68 <proc>
        p->state = RUNNING;
    80001fbc:	4b0d                	li	s6,3
    80001fbe:	b755                	j	80001f62 <scheduler+0x64>

0000000080001fc0 <sched>:
{
    80001fc0:	7179                	add	sp,sp,-48
    80001fc2:	f406                	sd	ra,40(sp)
    80001fc4:	f022                	sd	s0,32(sp)
    80001fc6:	ec26                	sd	s1,24(sp)
    80001fc8:	e84a                	sd	s2,16(sp)
    80001fca:	e44e                	sd	s3,8(sp)
    80001fcc:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    80001fce:	00000097          	auipc	ra,0x0
    80001fd2:	9f8080e7          	jalr	-1544(ra) # 800019c6 <myproc>
    80001fd6:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001fd8:	fffff097          	auipc	ra,0xfffff
    80001fdc:	baa080e7          	jalr	-1110(ra) # 80000b82 <holding>
    80001fe0:	c93d                	beqz	a0,80002056 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001fe2:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001fe4:	2781                	sext.w	a5,a5
    80001fe6:	079e                	sll	a5,a5,0x7
    80001fe8:	00010717          	auipc	a4,0x10
    80001fec:	96870713          	add	a4,a4,-1688 # 80011950 <pid_lock>
    80001ff0:	97ba                	add	a5,a5,a4
    80001ff2:	0907a703          	lw	a4,144(a5)
    80001ff6:	4785                	li	a5,1
    80001ff8:	06f71763          	bne	a4,a5,80002066 <sched+0xa6>
  if(p->state == RUNNING)
    80001ffc:	4c98                	lw	a4,24(s1)
    80001ffe:	478d                	li	a5,3
    80002000:	06f70b63          	beq	a4,a5,80002076 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002004:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002008:	8b89                	and	a5,a5,2
  if(intr_get())
    8000200a:	efb5                	bnez	a5,80002086 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000200c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000200e:	00010917          	auipc	s2,0x10
    80002012:	94290913          	add	s2,s2,-1726 # 80011950 <pid_lock>
    80002016:	2781                	sext.w	a5,a5
    80002018:	079e                	sll	a5,a5,0x7
    8000201a:	97ca                	add	a5,a5,s2
    8000201c:	0947a983          	lw	s3,148(a5)
    80002020:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002022:	2781                	sext.w	a5,a5
    80002024:	079e                	sll	a5,a5,0x7
    80002026:	00010597          	auipc	a1,0x10
    8000202a:	94a58593          	add	a1,a1,-1718 # 80011970 <cpus+0x8>
    8000202e:	95be                	add	a1,a1,a5
    80002030:	06048513          	add	a0,s1,96
    80002034:	00000097          	auipc	ra,0x0
    80002038:	55e080e7          	jalr	1374(ra) # 80002592 <swtch>
    8000203c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000203e:	2781                	sext.w	a5,a5
    80002040:	079e                	sll	a5,a5,0x7
    80002042:	993e                	add	s2,s2,a5
    80002044:	09392a23          	sw	s3,148(s2)
}
    80002048:	70a2                	ld	ra,40(sp)
    8000204a:	7402                	ld	s0,32(sp)
    8000204c:	64e2                	ld	s1,24(sp)
    8000204e:	6942                	ld	s2,16(sp)
    80002050:	69a2                	ld	s3,8(sp)
    80002052:	6145                	add	sp,sp,48
    80002054:	8082                	ret
    panic("sched p->lock");
    80002056:	00006517          	auipc	a0,0x6
    8000205a:	1aa50513          	add	a0,a0,426 # 80008200 <digits+0x1c0>
    8000205e:	ffffe097          	auipc	ra,0xffffe
    80002062:	4e4080e7          	jalr	1252(ra) # 80000542 <panic>
    panic("sched locks");
    80002066:	00006517          	auipc	a0,0x6
    8000206a:	1aa50513          	add	a0,a0,426 # 80008210 <digits+0x1d0>
    8000206e:	ffffe097          	auipc	ra,0xffffe
    80002072:	4d4080e7          	jalr	1236(ra) # 80000542 <panic>
    panic("sched running");
    80002076:	00006517          	auipc	a0,0x6
    8000207a:	1aa50513          	add	a0,a0,426 # 80008220 <digits+0x1e0>
    8000207e:	ffffe097          	auipc	ra,0xffffe
    80002082:	4c4080e7          	jalr	1220(ra) # 80000542 <panic>
    panic("sched interruptible");
    80002086:	00006517          	auipc	a0,0x6
    8000208a:	1aa50513          	add	a0,a0,426 # 80008230 <digits+0x1f0>
    8000208e:	ffffe097          	auipc	ra,0xffffe
    80002092:	4b4080e7          	jalr	1204(ra) # 80000542 <panic>

0000000080002096 <exit>:
{
    80002096:	7179                	add	sp,sp,-48
    80002098:	f406                	sd	ra,40(sp)
    8000209a:	f022                	sd	s0,32(sp)
    8000209c:	ec26                	sd	s1,24(sp)
    8000209e:	e84a                	sd	s2,16(sp)
    800020a0:	e44e                	sd	s3,8(sp)
    800020a2:	e052                	sd	s4,0(sp)
    800020a4:	1800                	add	s0,sp,48
    800020a6:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800020a8:	00000097          	auipc	ra,0x0
    800020ac:	91e080e7          	jalr	-1762(ra) # 800019c6 <myproc>
    800020b0:	89aa                	mv	s3,a0
  if(p == initproc)
    800020b2:	00007797          	auipc	a5,0x7
    800020b6:	f667b783          	ld	a5,-154(a5) # 80009018 <initproc>
    800020ba:	0d050493          	add	s1,a0,208
    800020be:	15050913          	add	s2,a0,336
    800020c2:	02a79363          	bne	a5,a0,800020e8 <exit+0x52>
    panic("init exiting");
    800020c6:	00006517          	auipc	a0,0x6
    800020ca:	18250513          	add	a0,a0,386 # 80008248 <digits+0x208>
    800020ce:	ffffe097          	auipc	ra,0xffffe
    800020d2:	474080e7          	jalr	1140(ra) # 80000542 <panic>
      fileclose(f);
    800020d6:	00002097          	auipc	ra,0x2
    800020da:	38a080e7          	jalr	906(ra) # 80004460 <fileclose>
      p->ofile[fd] = 0;
    800020de:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800020e2:	04a1                	add	s1,s1,8
    800020e4:	01248563          	beq	s1,s2,800020ee <exit+0x58>
    if(p->ofile[fd]){
    800020e8:	6088                	ld	a0,0(s1)
    800020ea:	f575                	bnez	a0,800020d6 <exit+0x40>
    800020ec:	bfdd                	j	800020e2 <exit+0x4c>
  begin_op();
    800020ee:	00002097          	auipc	ra,0x2
    800020f2:	ea8080e7          	jalr	-344(ra) # 80003f96 <begin_op>
  iput(p->cwd);
    800020f6:	1509b503          	ld	a0,336(s3)
    800020fa:	00001097          	auipc	ra,0x1
    800020fe:	6b2080e7          	jalr	1714(ra) # 800037ac <iput>
  end_op();
    80002102:	00002097          	auipc	ra,0x2
    80002106:	f0e080e7          	jalr	-242(ra) # 80004010 <end_op>
  p->cwd = 0;
    8000210a:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    8000210e:	00007497          	auipc	s1,0x7
    80002112:	f0a48493          	add	s1,s1,-246 # 80009018 <initproc>
    80002116:	6088                	ld	a0,0(s1)
    80002118:	fffff097          	auipc	ra,0xfffff
    8000211c:	ae4080e7          	jalr	-1308(ra) # 80000bfc <acquire>
  wakeup1(initproc);
    80002120:	6088                	ld	a0,0(s1)
    80002122:	fffff097          	auipc	ra,0xfffff
    80002126:	764080e7          	jalr	1892(ra) # 80001886 <wakeup1>
  release(&initproc->lock);
    8000212a:	6088                	ld	a0,0(s1)
    8000212c:	fffff097          	auipc	ra,0xfffff
    80002130:	b84080e7          	jalr	-1148(ra) # 80000cb0 <release>
  acquire(&p->lock);
    80002134:	854e                	mv	a0,s3
    80002136:	fffff097          	auipc	ra,0xfffff
    8000213a:	ac6080e7          	jalr	-1338(ra) # 80000bfc <acquire>
  struct proc *original_parent = p->parent;
    8000213e:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    80002142:	854e                	mv	a0,s3
    80002144:	fffff097          	auipc	ra,0xfffff
    80002148:	b6c080e7          	jalr	-1172(ra) # 80000cb0 <release>
  acquire(&original_parent->lock);
    8000214c:	8526                	mv	a0,s1
    8000214e:	fffff097          	auipc	ra,0xfffff
    80002152:	aae080e7          	jalr	-1362(ra) # 80000bfc <acquire>
  acquire(&p->lock);
    80002156:	854e                	mv	a0,s3
    80002158:	fffff097          	auipc	ra,0xfffff
    8000215c:	aa4080e7          	jalr	-1372(ra) # 80000bfc <acquire>
  reparent(p);
    80002160:	854e                	mv	a0,s3
    80002162:	00000097          	auipc	ra,0x0
    80002166:	d36080e7          	jalr	-714(ra) # 80001e98 <reparent>
  wakeup1(original_parent);
    8000216a:	8526                	mv	a0,s1
    8000216c:	fffff097          	auipc	ra,0xfffff
    80002170:	71a080e7          	jalr	1818(ra) # 80001886 <wakeup1>
  p->xstate = status;
    80002174:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80002178:	4791                	li	a5,4
    8000217a:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    8000217e:	8526                	mv	a0,s1
    80002180:	fffff097          	auipc	ra,0xfffff
    80002184:	b30080e7          	jalr	-1232(ra) # 80000cb0 <release>
  sched();
    80002188:	00000097          	auipc	ra,0x0
    8000218c:	e38080e7          	jalr	-456(ra) # 80001fc0 <sched>
  panic("zombie exit");
    80002190:	00006517          	auipc	a0,0x6
    80002194:	0c850513          	add	a0,a0,200 # 80008258 <digits+0x218>
    80002198:	ffffe097          	auipc	ra,0xffffe
    8000219c:	3aa080e7          	jalr	938(ra) # 80000542 <panic>

00000000800021a0 <yield>:
{
    800021a0:	1101                	add	sp,sp,-32
    800021a2:	ec06                	sd	ra,24(sp)
    800021a4:	e822                	sd	s0,16(sp)
    800021a6:	e426                	sd	s1,8(sp)
    800021a8:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    800021aa:	00000097          	auipc	ra,0x0
    800021ae:	81c080e7          	jalr	-2020(ra) # 800019c6 <myproc>
    800021b2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800021b4:	fffff097          	auipc	ra,0xfffff
    800021b8:	a48080e7          	jalr	-1464(ra) # 80000bfc <acquire>
  p->state = RUNNABLE;
    800021bc:	4789                	li	a5,2
    800021be:	cc9c                	sw	a5,24(s1)
  sched();
    800021c0:	00000097          	auipc	ra,0x0
    800021c4:	e00080e7          	jalr	-512(ra) # 80001fc0 <sched>
  release(&p->lock);
    800021c8:	8526                	mv	a0,s1
    800021ca:	fffff097          	auipc	ra,0xfffff
    800021ce:	ae6080e7          	jalr	-1306(ra) # 80000cb0 <release>
}
    800021d2:	60e2                	ld	ra,24(sp)
    800021d4:	6442                	ld	s0,16(sp)
    800021d6:	64a2                	ld	s1,8(sp)
    800021d8:	6105                	add	sp,sp,32
    800021da:	8082                	ret

00000000800021dc <sleep>:
{
    800021dc:	7179                	add	sp,sp,-48
    800021de:	f406                	sd	ra,40(sp)
    800021e0:	f022                	sd	s0,32(sp)
    800021e2:	ec26                	sd	s1,24(sp)
    800021e4:	e84a                	sd	s2,16(sp)
    800021e6:	e44e                	sd	s3,8(sp)
    800021e8:	1800                	add	s0,sp,48
    800021ea:	89aa                	mv	s3,a0
    800021ec:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800021ee:	fffff097          	auipc	ra,0xfffff
    800021f2:	7d8080e7          	jalr	2008(ra) # 800019c6 <myproc>
    800021f6:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    800021f8:	05250663          	beq	a0,s2,80002244 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    800021fc:	fffff097          	auipc	ra,0xfffff
    80002200:	a00080e7          	jalr	-1536(ra) # 80000bfc <acquire>
    release(lk);
    80002204:	854a                	mv	a0,s2
    80002206:	fffff097          	auipc	ra,0xfffff
    8000220a:	aaa080e7          	jalr	-1366(ra) # 80000cb0 <release>
  p->chan = chan;
    8000220e:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    80002212:	4785                	li	a5,1
    80002214:	cc9c                	sw	a5,24(s1)
  sched();
    80002216:	00000097          	auipc	ra,0x0
    8000221a:	daa080e7          	jalr	-598(ra) # 80001fc0 <sched>
  p->chan = 0;
    8000221e:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    80002222:	8526                	mv	a0,s1
    80002224:	fffff097          	auipc	ra,0xfffff
    80002228:	a8c080e7          	jalr	-1396(ra) # 80000cb0 <release>
    acquire(lk);
    8000222c:	854a                	mv	a0,s2
    8000222e:	fffff097          	auipc	ra,0xfffff
    80002232:	9ce080e7          	jalr	-1586(ra) # 80000bfc <acquire>
}
    80002236:	70a2                	ld	ra,40(sp)
    80002238:	7402                	ld	s0,32(sp)
    8000223a:	64e2                	ld	s1,24(sp)
    8000223c:	6942                	ld	s2,16(sp)
    8000223e:	69a2                	ld	s3,8(sp)
    80002240:	6145                	add	sp,sp,48
    80002242:	8082                	ret
  p->chan = chan;
    80002244:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    80002248:	4785                	li	a5,1
    8000224a:	cd1c                	sw	a5,24(a0)
  sched();
    8000224c:	00000097          	auipc	ra,0x0
    80002250:	d74080e7          	jalr	-652(ra) # 80001fc0 <sched>
  p->chan = 0;
    80002254:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    80002258:	bff9                	j	80002236 <sleep+0x5a>

000000008000225a <wait>:
{
    8000225a:	715d                	add	sp,sp,-80
    8000225c:	e486                	sd	ra,72(sp)
    8000225e:	e0a2                	sd	s0,64(sp)
    80002260:	fc26                	sd	s1,56(sp)
    80002262:	f84a                	sd	s2,48(sp)
    80002264:	f44e                	sd	s3,40(sp)
    80002266:	f052                	sd	s4,32(sp)
    80002268:	ec56                	sd	s5,24(sp)
    8000226a:	e85a                	sd	s6,16(sp)
    8000226c:	e45e                	sd	s7,8(sp)
    8000226e:	0880                	add	s0,sp,80
    80002270:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002272:	fffff097          	auipc	ra,0xfffff
    80002276:	754080e7          	jalr	1876(ra) # 800019c6 <myproc>
    8000227a:	892a                	mv	s2,a0
  acquire(&p->lock);
    8000227c:	fffff097          	auipc	ra,0xfffff
    80002280:	980080e7          	jalr	-1664(ra) # 80000bfc <acquire>
    havekids = 0;
    80002284:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80002286:	4a11                	li	s4,4
        havekids = 1;
    80002288:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000228a:	00015997          	auipc	s3,0x15
    8000228e:	4de98993          	add	s3,s3,1246 # 80017768 <tickslock>
    80002292:	a845                	j	80002342 <wait+0xe8>
          pid = np->pid;
    80002294:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002298:	000b0e63          	beqz	s6,800022b4 <wait+0x5a>
    8000229c:	4691                	li	a3,4
    8000229e:	03448613          	add	a2,s1,52
    800022a2:	85da                	mv	a1,s6
    800022a4:	05093503          	ld	a0,80(s2)
    800022a8:	fffff097          	auipc	ra,0xfffff
    800022ac:	414080e7          	jalr	1044(ra) # 800016bc <copyout>
    800022b0:	02054d63          	bltz	a0,800022ea <wait+0x90>
          freeproc(np);
    800022b4:	8526                	mv	a0,s1
    800022b6:	00000097          	auipc	ra,0x0
    800022ba:	8c2080e7          	jalr	-1854(ra) # 80001b78 <freeproc>
          release(&np->lock);
    800022be:	8526                	mv	a0,s1
    800022c0:	fffff097          	auipc	ra,0xfffff
    800022c4:	9f0080e7          	jalr	-1552(ra) # 80000cb0 <release>
          release(&p->lock);
    800022c8:	854a                	mv	a0,s2
    800022ca:	fffff097          	auipc	ra,0xfffff
    800022ce:	9e6080e7          	jalr	-1562(ra) # 80000cb0 <release>
}
    800022d2:	854e                	mv	a0,s3
    800022d4:	60a6                	ld	ra,72(sp)
    800022d6:	6406                	ld	s0,64(sp)
    800022d8:	74e2                	ld	s1,56(sp)
    800022da:	7942                	ld	s2,48(sp)
    800022dc:	79a2                	ld	s3,40(sp)
    800022de:	7a02                	ld	s4,32(sp)
    800022e0:	6ae2                	ld	s5,24(sp)
    800022e2:	6b42                	ld	s6,16(sp)
    800022e4:	6ba2                	ld	s7,8(sp)
    800022e6:	6161                	add	sp,sp,80
    800022e8:	8082                	ret
            release(&np->lock);
    800022ea:	8526                	mv	a0,s1
    800022ec:	fffff097          	auipc	ra,0xfffff
    800022f0:	9c4080e7          	jalr	-1596(ra) # 80000cb0 <release>
            release(&p->lock);
    800022f4:	854a                	mv	a0,s2
    800022f6:	fffff097          	auipc	ra,0xfffff
    800022fa:	9ba080e7          	jalr	-1606(ra) # 80000cb0 <release>
            return -1;
    800022fe:	59fd                	li	s3,-1
    80002300:	bfc9                	j	800022d2 <wait+0x78>
    for(np = proc; np < &proc[NPROC]; np++){
    80002302:	16848493          	add	s1,s1,360
    80002306:	03348463          	beq	s1,s3,8000232e <wait+0xd4>
      if(np->parent == p){
    8000230a:	709c                	ld	a5,32(s1)
    8000230c:	ff279be3          	bne	a5,s2,80002302 <wait+0xa8>
        acquire(&np->lock);
    80002310:	8526                	mv	a0,s1
    80002312:	fffff097          	auipc	ra,0xfffff
    80002316:	8ea080e7          	jalr	-1814(ra) # 80000bfc <acquire>
        if(np->state == ZOMBIE){
    8000231a:	4c9c                	lw	a5,24(s1)
    8000231c:	f7478ce3          	beq	a5,s4,80002294 <wait+0x3a>
        release(&np->lock);
    80002320:	8526                	mv	a0,s1
    80002322:	fffff097          	auipc	ra,0xfffff
    80002326:	98e080e7          	jalr	-1650(ra) # 80000cb0 <release>
        havekids = 1;
    8000232a:	8756                	mv	a4,s5
    8000232c:	bfd9                	j	80002302 <wait+0xa8>
    if(!havekids || p->killed){
    8000232e:	c305                	beqz	a4,8000234e <wait+0xf4>
    80002330:	03092783          	lw	a5,48(s2)
    80002334:	ef89                	bnez	a5,8000234e <wait+0xf4>
    sleep(p, &p->lock);  //DOC: wait-sleep
    80002336:	85ca                	mv	a1,s2
    80002338:	854a                	mv	a0,s2
    8000233a:	00000097          	auipc	ra,0x0
    8000233e:	ea2080e7          	jalr	-350(ra) # 800021dc <sleep>
    havekids = 0;
    80002342:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002344:	00010497          	auipc	s1,0x10
    80002348:	a2448493          	add	s1,s1,-1500 # 80011d68 <proc>
    8000234c:	bf7d                	j	8000230a <wait+0xb0>
      release(&p->lock);
    8000234e:	854a                	mv	a0,s2
    80002350:	fffff097          	auipc	ra,0xfffff
    80002354:	960080e7          	jalr	-1696(ra) # 80000cb0 <release>
      return -1;
    80002358:	59fd                	li	s3,-1
    8000235a:	bfa5                	j	800022d2 <wait+0x78>

000000008000235c <wakeup>:
{
    8000235c:	7139                	add	sp,sp,-64
    8000235e:	fc06                	sd	ra,56(sp)
    80002360:	f822                	sd	s0,48(sp)
    80002362:	f426                	sd	s1,40(sp)
    80002364:	f04a                	sd	s2,32(sp)
    80002366:	ec4e                	sd	s3,24(sp)
    80002368:	e852                	sd	s4,16(sp)
    8000236a:	e456                	sd	s5,8(sp)
    8000236c:	0080                	add	s0,sp,64
    8000236e:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80002370:	00010497          	auipc	s1,0x10
    80002374:	9f848493          	add	s1,s1,-1544 # 80011d68 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    80002378:	4985                	li	s3,1
      p->state = RUNNABLE;
    8000237a:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    8000237c:	00015917          	auipc	s2,0x15
    80002380:	3ec90913          	add	s2,s2,1004 # 80017768 <tickslock>
    80002384:	a811                	j	80002398 <wakeup+0x3c>
    release(&p->lock);
    80002386:	8526                	mv	a0,s1
    80002388:	fffff097          	auipc	ra,0xfffff
    8000238c:	928080e7          	jalr	-1752(ra) # 80000cb0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002390:	16848493          	add	s1,s1,360
    80002394:	03248063          	beq	s1,s2,800023b4 <wakeup+0x58>
    acquire(&p->lock);
    80002398:	8526                	mv	a0,s1
    8000239a:	fffff097          	auipc	ra,0xfffff
    8000239e:	862080e7          	jalr	-1950(ra) # 80000bfc <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    800023a2:	4c9c                	lw	a5,24(s1)
    800023a4:	ff3791e3          	bne	a5,s3,80002386 <wakeup+0x2a>
    800023a8:	749c                	ld	a5,40(s1)
    800023aa:	fd479ee3          	bne	a5,s4,80002386 <wakeup+0x2a>
      p->state = RUNNABLE;
    800023ae:	0154ac23          	sw	s5,24(s1)
    800023b2:	bfd1                	j	80002386 <wakeup+0x2a>
}
    800023b4:	70e2                	ld	ra,56(sp)
    800023b6:	7442                	ld	s0,48(sp)
    800023b8:	74a2                	ld	s1,40(sp)
    800023ba:	7902                	ld	s2,32(sp)
    800023bc:	69e2                	ld	s3,24(sp)
    800023be:	6a42                	ld	s4,16(sp)
    800023c0:	6aa2                	ld	s5,8(sp)
    800023c2:	6121                	add	sp,sp,64
    800023c4:	8082                	ret

00000000800023c6 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800023c6:	7179                	add	sp,sp,-48
    800023c8:	f406                	sd	ra,40(sp)
    800023ca:	f022                	sd	s0,32(sp)
    800023cc:	ec26                	sd	s1,24(sp)
    800023ce:	e84a                	sd	s2,16(sp)
    800023d0:	e44e                	sd	s3,8(sp)
    800023d2:	1800                	add	s0,sp,48
    800023d4:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800023d6:	00010497          	auipc	s1,0x10
    800023da:	99248493          	add	s1,s1,-1646 # 80011d68 <proc>
    800023de:	00015997          	auipc	s3,0x15
    800023e2:	38a98993          	add	s3,s3,906 # 80017768 <tickslock>
    acquire(&p->lock);
    800023e6:	8526                	mv	a0,s1
    800023e8:	fffff097          	auipc	ra,0xfffff
    800023ec:	814080e7          	jalr	-2028(ra) # 80000bfc <acquire>
    if(p->pid == pid){
    800023f0:	5c9c                	lw	a5,56(s1)
    800023f2:	01278d63          	beq	a5,s2,8000240c <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800023f6:	8526                	mv	a0,s1
    800023f8:	fffff097          	auipc	ra,0xfffff
    800023fc:	8b8080e7          	jalr	-1864(ra) # 80000cb0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002400:	16848493          	add	s1,s1,360
    80002404:	ff3491e3          	bne	s1,s3,800023e6 <kill+0x20>
  }
  return -1;
    80002408:	557d                	li	a0,-1
    8000240a:	a821                	j	80002422 <kill+0x5c>
      p->killed = 1;
    8000240c:	4785                	li	a5,1
    8000240e:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80002410:	4c98                	lw	a4,24(s1)
    80002412:	00f70f63          	beq	a4,a5,80002430 <kill+0x6a>
      release(&p->lock);
    80002416:	8526                	mv	a0,s1
    80002418:	fffff097          	auipc	ra,0xfffff
    8000241c:	898080e7          	jalr	-1896(ra) # 80000cb0 <release>
      return 0;
    80002420:	4501                	li	a0,0
}
    80002422:	70a2                	ld	ra,40(sp)
    80002424:	7402                	ld	s0,32(sp)
    80002426:	64e2                	ld	s1,24(sp)
    80002428:	6942                	ld	s2,16(sp)
    8000242a:	69a2                	ld	s3,8(sp)
    8000242c:	6145                	add	sp,sp,48
    8000242e:	8082                	ret
        p->state = RUNNABLE;
    80002430:	4789                	li	a5,2
    80002432:	cc9c                	sw	a5,24(s1)
    80002434:	b7cd                	j	80002416 <kill+0x50>

0000000080002436 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002436:	7179                	add	sp,sp,-48
    80002438:	f406                	sd	ra,40(sp)
    8000243a:	f022                	sd	s0,32(sp)
    8000243c:	ec26                	sd	s1,24(sp)
    8000243e:	e84a                	sd	s2,16(sp)
    80002440:	e44e                	sd	s3,8(sp)
    80002442:	e052                	sd	s4,0(sp)
    80002444:	1800                	add	s0,sp,48
    80002446:	84aa                	mv	s1,a0
    80002448:	892e                	mv	s2,a1
    8000244a:	89b2                	mv	s3,a2
    8000244c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000244e:	fffff097          	auipc	ra,0xfffff
    80002452:	578080e7          	jalr	1400(ra) # 800019c6 <myproc>
  if(user_dst){
    80002456:	c08d                	beqz	s1,80002478 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002458:	86d2                	mv	a3,s4
    8000245a:	864e                	mv	a2,s3
    8000245c:	85ca                	mv	a1,s2
    8000245e:	6928                	ld	a0,80(a0)
    80002460:	fffff097          	auipc	ra,0xfffff
    80002464:	25c080e7          	jalr	604(ra) # 800016bc <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002468:	70a2                	ld	ra,40(sp)
    8000246a:	7402                	ld	s0,32(sp)
    8000246c:	64e2                	ld	s1,24(sp)
    8000246e:	6942                	ld	s2,16(sp)
    80002470:	69a2                	ld	s3,8(sp)
    80002472:	6a02                	ld	s4,0(sp)
    80002474:	6145                	add	sp,sp,48
    80002476:	8082                	ret
    memmove((char *)dst, src, len);
    80002478:	000a061b          	sext.w	a2,s4
    8000247c:	85ce                	mv	a1,s3
    8000247e:	854a                	mv	a0,s2
    80002480:	fffff097          	auipc	ra,0xfffff
    80002484:	8d4080e7          	jalr	-1836(ra) # 80000d54 <memmove>
    return 0;
    80002488:	8526                	mv	a0,s1
    8000248a:	bff9                	j	80002468 <either_copyout+0x32>

000000008000248c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000248c:	7179                	add	sp,sp,-48
    8000248e:	f406                	sd	ra,40(sp)
    80002490:	f022                	sd	s0,32(sp)
    80002492:	ec26                	sd	s1,24(sp)
    80002494:	e84a                	sd	s2,16(sp)
    80002496:	e44e                	sd	s3,8(sp)
    80002498:	e052                	sd	s4,0(sp)
    8000249a:	1800                	add	s0,sp,48
    8000249c:	892a                	mv	s2,a0
    8000249e:	84ae                	mv	s1,a1
    800024a0:	89b2                	mv	s3,a2
    800024a2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024a4:	fffff097          	auipc	ra,0xfffff
    800024a8:	522080e7          	jalr	1314(ra) # 800019c6 <myproc>
  if(user_src){
    800024ac:	c08d                	beqz	s1,800024ce <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800024ae:	86d2                	mv	a3,s4
    800024b0:	864e                	mv	a2,s3
    800024b2:	85ca                	mv	a1,s2
    800024b4:	6928                	ld	a0,80(a0)
    800024b6:	fffff097          	auipc	ra,0xfffff
    800024ba:	292080e7          	jalr	658(ra) # 80001748 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800024be:	70a2                	ld	ra,40(sp)
    800024c0:	7402                	ld	s0,32(sp)
    800024c2:	64e2                	ld	s1,24(sp)
    800024c4:	6942                	ld	s2,16(sp)
    800024c6:	69a2                	ld	s3,8(sp)
    800024c8:	6a02                	ld	s4,0(sp)
    800024ca:	6145                	add	sp,sp,48
    800024cc:	8082                	ret
    memmove(dst, (char*)src, len);
    800024ce:	000a061b          	sext.w	a2,s4
    800024d2:	85ce                	mv	a1,s3
    800024d4:	854a                	mv	a0,s2
    800024d6:	fffff097          	auipc	ra,0xfffff
    800024da:	87e080e7          	jalr	-1922(ra) # 80000d54 <memmove>
    return 0;
    800024de:	8526                	mv	a0,s1
    800024e0:	bff9                	j	800024be <either_copyin+0x32>

00000000800024e2 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800024e2:	715d                	add	sp,sp,-80
    800024e4:	e486                	sd	ra,72(sp)
    800024e6:	e0a2                	sd	s0,64(sp)
    800024e8:	fc26                	sd	s1,56(sp)
    800024ea:	f84a                	sd	s2,48(sp)
    800024ec:	f44e                	sd	s3,40(sp)
    800024ee:	f052                	sd	s4,32(sp)
    800024f0:	ec56                	sd	s5,24(sp)
    800024f2:	e85a                	sd	s6,16(sp)
    800024f4:	e45e                	sd	s7,8(sp)
    800024f6:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800024f8:	00006517          	auipc	a0,0x6
    800024fc:	bd050513          	add	a0,a0,-1072 # 800080c8 <digits+0x88>
    80002500:	ffffe097          	auipc	ra,0xffffe
    80002504:	08c080e7          	jalr	140(ra) # 8000058c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002508:	00010497          	auipc	s1,0x10
    8000250c:	9b848493          	add	s1,s1,-1608 # 80011ec0 <proc+0x158>
    80002510:	00015917          	auipc	s2,0x15
    80002514:	3b090913          	add	s2,s2,944 # 800178c0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002518:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    8000251a:	00006997          	auipc	s3,0x6
    8000251e:	d4e98993          	add	s3,s3,-690 # 80008268 <digits+0x228>
    printf("%d %s %s", p->pid, state, p->name);
    80002522:	00006a97          	auipc	s5,0x6
    80002526:	d4ea8a93          	add	s5,s5,-690 # 80008270 <digits+0x230>
    printf("\n");
    8000252a:	00006a17          	auipc	s4,0x6
    8000252e:	b9ea0a13          	add	s4,s4,-1122 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002532:	00006b97          	auipc	s7,0x6
    80002536:	d76b8b93          	add	s7,s7,-650 # 800082a8 <states.0>
    8000253a:	a00d                	j	8000255c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000253c:	ee06a583          	lw	a1,-288(a3)
    80002540:	8556                	mv	a0,s5
    80002542:	ffffe097          	auipc	ra,0xffffe
    80002546:	04a080e7          	jalr	74(ra) # 8000058c <printf>
    printf("\n");
    8000254a:	8552                	mv	a0,s4
    8000254c:	ffffe097          	auipc	ra,0xffffe
    80002550:	040080e7          	jalr	64(ra) # 8000058c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002554:	16848493          	add	s1,s1,360
    80002558:	03248263          	beq	s1,s2,8000257c <procdump+0x9a>
    if(p->state == UNUSED)
    8000255c:	86a6                	mv	a3,s1
    8000255e:	ec04a783          	lw	a5,-320(s1)
    80002562:	dbed                	beqz	a5,80002554 <procdump+0x72>
      state = "???";
    80002564:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002566:	fcfb6be3          	bltu	s6,a5,8000253c <procdump+0x5a>
    8000256a:	02079713          	sll	a4,a5,0x20
    8000256e:	01d75793          	srl	a5,a4,0x1d
    80002572:	97de                	add	a5,a5,s7
    80002574:	6390                	ld	a2,0(a5)
    80002576:	f279                	bnez	a2,8000253c <procdump+0x5a>
      state = "???";
    80002578:	864e                	mv	a2,s3
    8000257a:	b7c9                	j	8000253c <procdump+0x5a>
  }
}
    8000257c:	60a6                	ld	ra,72(sp)
    8000257e:	6406                	ld	s0,64(sp)
    80002580:	74e2                	ld	s1,56(sp)
    80002582:	7942                	ld	s2,48(sp)
    80002584:	79a2                	ld	s3,40(sp)
    80002586:	7a02                	ld	s4,32(sp)
    80002588:	6ae2                	ld	s5,24(sp)
    8000258a:	6b42                	ld	s6,16(sp)
    8000258c:	6ba2                	ld	s7,8(sp)
    8000258e:	6161                	add	sp,sp,80
    80002590:	8082                	ret

0000000080002592 <swtch>:
    80002592:	00153023          	sd	ra,0(a0)
    80002596:	00253423          	sd	sp,8(a0)
    8000259a:	e900                	sd	s0,16(a0)
    8000259c:	ed04                	sd	s1,24(a0)
    8000259e:	03253023          	sd	s2,32(a0)
    800025a2:	03353423          	sd	s3,40(a0)
    800025a6:	03453823          	sd	s4,48(a0)
    800025aa:	03553c23          	sd	s5,56(a0)
    800025ae:	05653023          	sd	s6,64(a0)
    800025b2:	05753423          	sd	s7,72(a0)
    800025b6:	05853823          	sd	s8,80(a0)
    800025ba:	05953c23          	sd	s9,88(a0)
    800025be:	07a53023          	sd	s10,96(a0)
    800025c2:	07b53423          	sd	s11,104(a0)
    800025c6:	0005b083          	ld	ra,0(a1)
    800025ca:	0085b103          	ld	sp,8(a1)
    800025ce:	6980                	ld	s0,16(a1)
    800025d0:	6d84                	ld	s1,24(a1)
    800025d2:	0205b903          	ld	s2,32(a1)
    800025d6:	0285b983          	ld	s3,40(a1)
    800025da:	0305ba03          	ld	s4,48(a1)
    800025de:	0385ba83          	ld	s5,56(a1)
    800025e2:	0405bb03          	ld	s6,64(a1)
    800025e6:	0485bb83          	ld	s7,72(a1)
    800025ea:	0505bc03          	ld	s8,80(a1)
    800025ee:	0585bc83          	ld	s9,88(a1)
    800025f2:	0605bd03          	ld	s10,96(a1)
    800025f6:	0685bd83          	ld	s11,104(a1)
    800025fa:	8082                	ret

00000000800025fc <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800025fc:	1141                	add	sp,sp,-16
    800025fe:	e406                	sd	ra,8(sp)
    80002600:	e022                	sd	s0,0(sp)
    80002602:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80002604:	00006597          	auipc	a1,0x6
    80002608:	ccc58593          	add	a1,a1,-820 # 800082d0 <states.0+0x28>
    8000260c:	00015517          	auipc	a0,0x15
    80002610:	15c50513          	add	a0,a0,348 # 80017768 <tickslock>
    80002614:	ffffe097          	auipc	ra,0xffffe
    80002618:	558080e7          	jalr	1368(ra) # 80000b6c <initlock>
}
    8000261c:	60a2                	ld	ra,8(sp)
    8000261e:	6402                	ld	s0,0(sp)
    80002620:	0141                	add	sp,sp,16
    80002622:	8082                	ret

0000000080002624 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002624:	1141                	add	sp,sp,-16
    80002626:	e422                	sd	s0,8(sp)
    80002628:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000262a:	00003797          	auipc	a5,0x3
    8000262e:	47678793          	add	a5,a5,1142 # 80005aa0 <kernelvec>
    80002632:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002636:	6422                	ld	s0,8(sp)
    80002638:	0141                	add	sp,sp,16
    8000263a:	8082                	ret

000000008000263c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000263c:	1141                	add	sp,sp,-16
    8000263e:	e406                	sd	ra,8(sp)
    80002640:	e022                	sd	s0,0(sp)
    80002642:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80002644:	fffff097          	auipc	ra,0xfffff
    80002648:	382080e7          	jalr	898(ra) # 800019c6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000264c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002650:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002652:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002656:	00005697          	auipc	a3,0x5
    8000265a:	9aa68693          	add	a3,a3,-1622 # 80007000 <_trampoline>
    8000265e:	00005717          	auipc	a4,0x5
    80002662:	9a270713          	add	a4,a4,-1630 # 80007000 <_trampoline>
    80002666:	8f15                	sub	a4,a4,a3
    80002668:	040007b7          	lui	a5,0x4000
    8000266c:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000266e:	07b2                	sll	a5,a5,0xc
    80002670:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002672:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002676:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002678:	18002673          	csrr	a2,satp
    8000267c:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000267e:	6d30                	ld	a2,88(a0)
    80002680:	6138                	ld	a4,64(a0)
    80002682:	6585                	lui	a1,0x1
    80002684:	972e                	add	a4,a4,a1
    80002686:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002688:	6d38                	ld	a4,88(a0)
    8000268a:	00000617          	auipc	a2,0x0
    8000268e:	13c60613          	add	a2,a2,316 # 800027c6 <usertrap>
    80002692:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002694:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002696:	8612                	mv	a2,tp
    80002698:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000269a:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000269e:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800026a2:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026a6:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800026aa:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800026ac:	6f18                	ld	a4,24(a4)
    800026ae:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800026b2:	692c                	ld	a1,80(a0)
    800026b4:	81b1                	srl	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    800026b6:	00005717          	auipc	a4,0x5
    800026ba:	9da70713          	add	a4,a4,-1574 # 80007090 <userret>
    800026be:	8f15                	sub	a4,a4,a3
    800026c0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    800026c2:	577d                	li	a4,-1
    800026c4:	177e                	sll	a4,a4,0x3f
    800026c6:	8dd9                	or	a1,a1,a4
    800026c8:	02000537          	lui	a0,0x2000
    800026cc:	157d                	add	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800026ce:	0536                	sll	a0,a0,0xd
    800026d0:	9782                	jalr	a5
}
    800026d2:	60a2                	ld	ra,8(sp)
    800026d4:	6402                	ld	s0,0(sp)
    800026d6:	0141                	add	sp,sp,16
    800026d8:	8082                	ret

00000000800026da <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800026da:	1101                	add	sp,sp,-32
    800026dc:	ec06                	sd	ra,24(sp)
    800026de:	e822                	sd	s0,16(sp)
    800026e0:	e426                	sd	s1,8(sp)
    800026e2:	1000                	add	s0,sp,32
  acquire(&tickslock);
    800026e4:	00015497          	auipc	s1,0x15
    800026e8:	08448493          	add	s1,s1,132 # 80017768 <tickslock>
    800026ec:	8526                	mv	a0,s1
    800026ee:	ffffe097          	auipc	ra,0xffffe
    800026f2:	50e080e7          	jalr	1294(ra) # 80000bfc <acquire>
  ticks++;
    800026f6:	00007517          	auipc	a0,0x7
    800026fa:	92a50513          	add	a0,a0,-1750 # 80009020 <ticks>
    800026fe:	411c                	lw	a5,0(a0)
    80002700:	2785                	addw	a5,a5,1
    80002702:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002704:	00000097          	auipc	ra,0x0
    80002708:	c58080e7          	jalr	-936(ra) # 8000235c <wakeup>
  release(&tickslock);
    8000270c:	8526                	mv	a0,s1
    8000270e:	ffffe097          	auipc	ra,0xffffe
    80002712:	5a2080e7          	jalr	1442(ra) # 80000cb0 <release>
}
    80002716:	60e2                	ld	ra,24(sp)
    80002718:	6442                	ld	s0,16(sp)
    8000271a:	64a2                	ld	s1,8(sp)
    8000271c:	6105                	add	sp,sp,32
    8000271e:	8082                	ret

0000000080002720 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002720:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002724:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80002726:	0807df63          	bgez	a5,800027c4 <devintr+0xa4>
{
    8000272a:	1101                	add	sp,sp,-32
    8000272c:	ec06                	sd	ra,24(sp)
    8000272e:	e822                	sd	s0,16(sp)
    80002730:	e426                	sd	s1,8(sp)
    80002732:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    80002734:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80002738:	46a5                	li	a3,9
    8000273a:	00d70d63          	beq	a4,a3,80002754 <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    8000273e:	577d                	li	a4,-1
    80002740:	177e                	sll	a4,a4,0x3f
    80002742:	0705                	add	a4,a4,1
    return 0;
    80002744:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002746:	04e78e63          	beq	a5,a4,800027a2 <devintr+0x82>
  }
}
    8000274a:	60e2                	ld	ra,24(sp)
    8000274c:	6442                	ld	s0,16(sp)
    8000274e:	64a2                	ld	s1,8(sp)
    80002750:	6105                	add	sp,sp,32
    80002752:	8082                	ret
    int irq = plic_claim();
    80002754:	00003097          	auipc	ra,0x3
    80002758:	454080e7          	jalr	1108(ra) # 80005ba8 <plic_claim>
    8000275c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000275e:	47a9                	li	a5,10
    80002760:	02f50763          	beq	a0,a5,8000278e <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80002764:	4785                	li	a5,1
    80002766:	02f50963          	beq	a0,a5,80002798 <devintr+0x78>
    return 1;
    8000276a:	4505                	li	a0,1
    } else if(irq){
    8000276c:	dcf9                	beqz	s1,8000274a <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    8000276e:	85a6                	mv	a1,s1
    80002770:	00006517          	auipc	a0,0x6
    80002774:	b6850513          	add	a0,a0,-1176 # 800082d8 <states.0+0x30>
    80002778:	ffffe097          	auipc	ra,0xffffe
    8000277c:	e14080e7          	jalr	-492(ra) # 8000058c <printf>
      plic_complete(irq);
    80002780:	8526                	mv	a0,s1
    80002782:	00003097          	auipc	ra,0x3
    80002786:	44a080e7          	jalr	1098(ra) # 80005bcc <plic_complete>
    return 1;
    8000278a:	4505                	li	a0,1
    8000278c:	bf7d                	j	8000274a <devintr+0x2a>
      uartintr();
    8000278e:	ffffe097          	auipc	ra,0xffffe
    80002792:	230080e7          	jalr	560(ra) # 800009be <uartintr>
    if(irq)
    80002796:	b7ed                	j	80002780 <devintr+0x60>
      virtio_disk_intr();
    80002798:	00004097          	auipc	ra,0x4
    8000279c:	8a6080e7          	jalr	-1882(ra) # 8000603e <virtio_disk_intr>
    if(irq)
    800027a0:	b7c5                	j	80002780 <devintr+0x60>
    if(cpuid() == 0){
    800027a2:	fffff097          	auipc	ra,0xfffff
    800027a6:	1f8080e7          	jalr	504(ra) # 8000199a <cpuid>
    800027aa:	c901                	beqz	a0,800027ba <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800027ac:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800027b0:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800027b2:	14479073          	csrw	sip,a5
    return 2;
    800027b6:	4509                	li	a0,2
    800027b8:	bf49                	j	8000274a <devintr+0x2a>
      clockintr();
    800027ba:	00000097          	auipc	ra,0x0
    800027be:	f20080e7          	jalr	-224(ra) # 800026da <clockintr>
    800027c2:	b7ed                	j	800027ac <devintr+0x8c>
}
    800027c4:	8082                	ret

00000000800027c6 <usertrap>:
{
    800027c6:	1101                	add	sp,sp,-32
    800027c8:	ec06                	sd	ra,24(sp)
    800027ca:	e822                	sd	s0,16(sp)
    800027cc:	e426                	sd	s1,8(sp)
    800027ce:	e04a                	sd	s2,0(sp)
    800027d0:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027d2:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800027d6:	1007f793          	and	a5,a5,256
    800027da:	e3ad                	bnez	a5,8000283c <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027dc:	00003797          	auipc	a5,0x3
    800027e0:	2c478793          	add	a5,a5,708 # 80005aa0 <kernelvec>
    800027e4:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800027e8:	fffff097          	auipc	ra,0xfffff
    800027ec:	1de080e7          	jalr	478(ra) # 800019c6 <myproc>
    800027f0:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800027f2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027f4:	14102773          	csrr	a4,sepc
    800027f8:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027fa:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800027fe:	47a1                	li	a5,8
    80002800:	04f71c63          	bne	a4,a5,80002858 <usertrap+0x92>
    if(p->killed)
    80002804:	591c                	lw	a5,48(a0)
    80002806:	e3b9                	bnez	a5,8000284c <usertrap+0x86>
    p->trapframe->epc += 4;
    80002808:	6cb8                	ld	a4,88(s1)
    8000280a:	6f1c                	ld	a5,24(a4)
    8000280c:	0791                	add	a5,a5,4
    8000280e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002810:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002814:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002818:	10079073          	csrw	sstatus,a5
    syscall();
    8000281c:	00000097          	auipc	ra,0x0
    80002820:	2e0080e7          	jalr	736(ra) # 80002afc <syscall>
  if(p->killed)
    80002824:	589c                	lw	a5,48(s1)
    80002826:	ebc1                	bnez	a5,800028b6 <usertrap+0xf0>
  usertrapret();
    80002828:	00000097          	auipc	ra,0x0
    8000282c:	e14080e7          	jalr	-492(ra) # 8000263c <usertrapret>
}
    80002830:	60e2                	ld	ra,24(sp)
    80002832:	6442                	ld	s0,16(sp)
    80002834:	64a2                	ld	s1,8(sp)
    80002836:	6902                	ld	s2,0(sp)
    80002838:	6105                	add	sp,sp,32
    8000283a:	8082                	ret
    panic("usertrap: not from user mode");
    8000283c:	00006517          	auipc	a0,0x6
    80002840:	abc50513          	add	a0,a0,-1348 # 800082f8 <states.0+0x50>
    80002844:	ffffe097          	auipc	ra,0xffffe
    80002848:	cfe080e7          	jalr	-770(ra) # 80000542 <panic>
      exit(-1);
    8000284c:	557d                	li	a0,-1
    8000284e:	00000097          	auipc	ra,0x0
    80002852:	848080e7          	jalr	-1976(ra) # 80002096 <exit>
    80002856:	bf4d                	j	80002808 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002858:	00000097          	auipc	ra,0x0
    8000285c:	ec8080e7          	jalr	-312(ra) # 80002720 <devintr>
    80002860:	892a                	mv	s2,a0
    80002862:	c501                	beqz	a0,8000286a <usertrap+0xa4>
  if(p->killed)
    80002864:	589c                	lw	a5,48(s1)
    80002866:	c3a1                	beqz	a5,800028a6 <usertrap+0xe0>
    80002868:	a815                	j	8000289c <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000286a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000286e:	5c90                	lw	a2,56(s1)
    80002870:	00006517          	auipc	a0,0x6
    80002874:	aa850513          	add	a0,a0,-1368 # 80008318 <states.0+0x70>
    80002878:	ffffe097          	auipc	ra,0xffffe
    8000287c:	d14080e7          	jalr	-748(ra) # 8000058c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002880:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002884:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002888:	00006517          	auipc	a0,0x6
    8000288c:	ac050513          	add	a0,a0,-1344 # 80008348 <states.0+0xa0>
    80002890:	ffffe097          	auipc	ra,0xffffe
    80002894:	cfc080e7          	jalr	-772(ra) # 8000058c <printf>
    p->killed = 1;
    80002898:	4785                	li	a5,1
    8000289a:	d89c                	sw	a5,48(s1)
    exit(-1);
    8000289c:	557d                	li	a0,-1
    8000289e:	fffff097          	auipc	ra,0xfffff
    800028a2:	7f8080e7          	jalr	2040(ra) # 80002096 <exit>
  if(which_dev == 2)
    800028a6:	4789                	li	a5,2
    800028a8:	f8f910e3          	bne	s2,a5,80002828 <usertrap+0x62>
    yield();
    800028ac:	00000097          	auipc	ra,0x0
    800028b0:	8f4080e7          	jalr	-1804(ra) # 800021a0 <yield>
    800028b4:	bf95                	j	80002828 <usertrap+0x62>
  int which_dev = 0;
    800028b6:	4901                	li	s2,0
    800028b8:	b7d5                	j	8000289c <usertrap+0xd6>

00000000800028ba <kerneltrap>:
{
    800028ba:	7179                	add	sp,sp,-48
    800028bc:	f406                	sd	ra,40(sp)
    800028be:	f022                	sd	s0,32(sp)
    800028c0:	ec26                	sd	s1,24(sp)
    800028c2:	e84a                	sd	s2,16(sp)
    800028c4:	e44e                	sd	s3,8(sp)
    800028c6:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028c8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028cc:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028d0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800028d4:	1004f793          	and	a5,s1,256
    800028d8:	cb85                	beqz	a5,80002908 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028da:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800028de:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    800028e0:	ef85                	bnez	a5,80002918 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800028e2:	00000097          	auipc	ra,0x0
    800028e6:	e3e080e7          	jalr	-450(ra) # 80002720 <devintr>
    800028ea:	cd1d                	beqz	a0,80002928 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800028ec:	4789                	li	a5,2
    800028ee:	06f50a63          	beq	a0,a5,80002962 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800028f2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028f6:	10049073          	csrw	sstatus,s1
}
    800028fa:	70a2                	ld	ra,40(sp)
    800028fc:	7402                	ld	s0,32(sp)
    800028fe:	64e2                	ld	s1,24(sp)
    80002900:	6942                	ld	s2,16(sp)
    80002902:	69a2                	ld	s3,8(sp)
    80002904:	6145                	add	sp,sp,48
    80002906:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002908:	00006517          	auipc	a0,0x6
    8000290c:	a6050513          	add	a0,a0,-1440 # 80008368 <states.0+0xc0>
    80002910:	ffffe097          	auipc	ra,0xffffe
    80002914:	c32080e7          	jalr	-974(ra) # 80000542 <panic>
    panic("kerneltrap: interrupts enabled");
    80002918:	00006517          	auipc	a0,0x6
    8000291c:	a7850513          	add	a0,a0,-1416 # 80008390 <states.0+0xe8>
    80002920:	ffffe097          	auipc	ra,0xffffe
    80002924:	c22080e7          	jalr	-990(ra) # 80000542 <panic>
    printf("scause %p\n", scause);
    80002928:	85ce                	mv	a1,s3
    8000292a:	00006517          	auipc	a0,0x6
    8000292e:	a8650513          	add	a0,a0,-1402 # 800083b0 <states.0+0x108>
    80002932:	ffffe097          	auipc	ra,0xffffe
    80002936:	c5a080e7          	jalr	-934(ra) # 8000058c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000293a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000293e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002942:	00006517          	auipc	a0,0x6
    80002946:	a7e50513          	add	a0,a0,-1410 # 800083c0 <states.0+0x118>
    8000294a:	ffffe097          	auipc	ra,0xffffe
    8000294e:	c42080e7          	jalr	-958(ra) # 8000058c <printf>
    panic("kerneltrap");
    80002952:	00006517          	auipc	a0,0x6
    80002956:	a8650513          	add	a0,a0,-1402 # 800083d8 <states.0+0x130>
    8000295a:	ffffe097          	auipc	ra,0xffffe
    8000295e:	be8080e7          	jalr	-1048(ra) # 80000542 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002962:	fffff097          	auipc	ra,0xfffff
    80002966:	064080e7          	jalr	100(ra) # 800019c6 <myproc>
    8000296a:	d541                	beqz	a0,800028f2 <kerneltrap+0x38>
    8000296c:	fffff097          	auipc	ra,0xfffff
    80002970:	05a080e7          	jalr	90(ra) # 800019c6 <myproc>
    80002974:	4d18                	lw	a4,24(a0)
    80002976:	478d                	li	a5,3
    80002978:	f6f71de3          	bne	a4,a5,800028f2 <kerneltrap+0x38>
    yield();
    8000297c:	00000097          	auipc	ra,0x0
    80002980:	824080e7          	jalr	-2012(ra) # 800021a0 <yield>
    80002984:	b7bd                	j	800028f2 <kerneltrap+0x38>

0000000080002986 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002986:	1101                	add	sp,sp,-32
    80002988:	ec06                	sd	ra,24(sp)
    8000298a:	e822                	sd	s0,16(sp)
    8000298c:	e426                	sd	s1,8(sp)
    8000298e:	1000                	add	s0,sp,32
    80002990:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002992:	fffff097          	auipc	ra,0xfffff
    80002996:	034080e7          	jalr	52(ra) # 800019c6 <myproc>
  switch (n) {
    8000299a:	4795                	li	a5,5
    8000299c:	0497e163          	bltu	a5,s1,800029de <argraw+0x58>
    800029a0:	048a                	sll	s1,s1,0x2
    800029a2:	00006717          	auipc	a4,0x6
    800029a6:	a6e70713          	add	a4,a4,-1426 # 80008410 <states.0+0x168>
    800029aa:	94ba                	add	s1,s1,a4
    800029ac:	409c                	lw	a5,0(s1)
    800029ae:	97ba                	add	a5,a5,a4
    800029b0:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800029b2:	6d3c                	ld	a5,88(a0)
    800029b4:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800029b6:	60e2                	ld	ra,24(sp)
    800029b8:	6442                	ld	s0,16(sp)
    800029ba:	64a2                	ld	s1,8(sp)
    800029bc:	6105                	add	sp,sp,32
    800029be:	8082                	ret
    return p->trapframe->a1;
    800029c0:	6d3c                	ld	a5,88(a0)
    800029c2:	7fa8                	ld	a0,120(a5)
    800029c4:	bfcd                	j	800029b6 <argraw+0x30>
    return p->trapframe->a2;
    800029c6:	6d3c                	ld	a5,88(a0)
    800029c8:	63c8                	ld	a0,128(a5)
    800029ca:	b7f5                	j	800029b6 <argraw+0x30>
    return p->trapframe->a3;
    800029cc:	6d3c                	ld	a5,88(a0)
    800029ce:	67c8                	ld	a0,136(a5)
    800029d0:	b7dd                	j	800029b6 <argraw+0x30>
    return p->trapframe->a4;
    800029d2:	6d3c                	ld	a5,88(a0)
    800029d4:	6bc8                	ld	a0,144(a5)
    800029d6:	b7c5                	j	800029b6 <argraw+0x30>
    return p->trapframe->a5;
    800029d8:	6d3c                	ld	a5,88(a0)
    800029da:	6fc8                	ld	a0,152(a5)
    800029dc:	bfe9                	j	800029b6 <argraw+0x30>
  panic("argraw");
    800029de:	00006517          	auipc	a0,0x6
    800029e2:	a0a50513          	add	a0,a0,-1526 # 800083e8 <states.0+0x140>
    800029e6:	ffffe097          	auipc	ra,0xffffe
    800029ea:	b5c080e7          	jalr	-1188(ra) # 80000542 <panic>

00000000800029ee <fetchaddr>:
{
    800029ee:	1101                	add	sp,sp,-32
    800029f0:	ec06                	sd	ra,24(sp)
    800029f2:	e822                	sd	s0,16(sp)
    800029f4:	e426                	sd	s1,8(sp)
    800029f6:	e04a                	sd	s2,0(sp)
    800029f8:	1000                	add	s0,sp,32
    800029fa:	84aa                	mv	s1,a0
    800029fc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800029fe:	fffff097          	auipc	ra,0xfffff
    80002a02:	fc8080e7          	jalr	-56(ra) # 800019c6 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002a06:	653c                	ld	a5,72(a0)
    80002a08:	02f4f863          	bgeu	s1,a5,80002a38 <fetchaddr+0x4a>
    80002a0c:	00848713          	add	a4,s1,8
    80002a10:	02e7e663          	bltu	a5,a4,80002a3c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002a14:	46a1                	li	a3,8
    80002a16:	8626                	mv	a2,s1
    80002a18:	85ca                	mv	a1,s2
    80002a1a:	6928                	ld	a0,80(a0)
    80002a1c:	fffff097          	auipc	ra,0xfffff
    80002a20:	d2c080e7          	jalr	-724(ra) # 80001748 <copyin>
    80002a24:	00a03533          	snez	a0,a0
    80002a28:	40a00533          	neg	a0,a0
}
    80002a2c:	60e2                	ld	ra,24(sp)
    80002a2e:	6442                	ld	s0,16(sp)
    80002a30:	64a2                	ld	s1,8(sp)
    80002a32:	6902                	ld	s2,0(sp)
    80002a34:	6105                	add	sp,sp,32
    80002a36:	8082                	ret
    return -1;
    80002a38:	557d                	li	a0,-1
    80002a3a:	bfcd                	j	80002a2c <fetchaddr+0x3e>
    80002a3c:	557d                	li	a0,-1
    80002a3e:	b7fd                	j	80002a2c <fetchaddr+0x3e>

0000000080002a40 <fetchstr>:
{
    80002a40:	7179                	add	sp,sp,-48
    80002a42:	f406                	sd	ra,40(sp)
    80002a44:	f022                	sd	s0,32(sp)
    80002a46:	ec26                	sd	s1,24(sp)
    80002a48:	e84a                	sd	s2,16(sp)
    80002a4a:	e44e                	sd	s3,8(sp)
    80002a4c:	1800                	add	s0,sp,48
    80002a4e:	892a                	mv	s2,a0
    80002a50:	84ae                	mv	s1,a1
    80002a52:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002a54:	fffff097          	auipc	ra,0xfffff
    80002a58:	f72080e7          	jalr	-142(ra) # 800019c6 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002a5c:	86ce                	mv	a3,s3
    80002a5e:	864a                	mv	a2,s2
    80002a60:	85a6                	mv	a1,s1
    80002a62:	6928                	ld	a0,80(a0)
    80002a64:	fffff097          	auipc	ra,0xfffff
    80002a68:	d72080e7          	jalr	-654(ra) # 800017d6 <copyinstr>
  if(err < 0)
    80002a6c:	00054763          	bltz	a0,80002a7a <fetchstr+0x3a>
  return strlen(buf);
    80002a70:	8526                	mv	a0,s1
    80002a72:	ffffe097          	auipc	ra,0xffffe
    80002a76:	408080e7          	jalr	1032(ra) # 80000e7a <strlen>
}
    80002a7a:	70a2                	ld	ra,40(sp)
    80002a7c:	7402                	ld	s0,32(sp)
    80002a7e:	64e2                	ld	s1,24(sp)
    80002a80:	6942                	ld	s2,16(sp)
    80002a82:	69a2                	ld	s3,8(sp)
    80002a84:	6145                	add	sp,sp,48
    80002a86:	8082                	ret

0000000080002a88 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002a88:	1101                	add	sp,sp,-32
    80002a8a:	ec06                	sd	ra,24(sp)
    80002a8c:	e822                	sd	s0,16(sp)
    80002a8e:	e426                	sd	s1,8(sp)
    80002a90:	1000                	add	s0,sp,32
    80002a92:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002a94:	00000097          	auipc	ra,0x0
    80002a98:	ef2080e7          	jalr	-270(ra) # 80002986 <argraw>
    80002a9c:	c088                	sw	a0,0(s1)
  return 0;
}
    80002a9e:	4501                	li	a0,0
    80002aa0:	60e2                	ld	ra,24(sp)
    80002aa2:	6442                	ld	s0,16(sp)
    80002aa4:	64a2                	ld	s1,8(sp)
    80002aa6:	6105                	add	sp,sp,32
    80002aa8:	8082                	ret

0000000080002aaa <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002aaa:	1101                	add	sp,sp,-32
    80002aac:	ec06                	sd	ra,24(sp)
    80002aae:	e822                	sd	s0,16(sp)
    80002ab0:	e426                	sd	s1,8(sp)
    80002ab2:	1000                	add	s0,sp,32
    80002ab4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002ab6:	00000097          	auipc	ra,0x0
    80002aba:	ed0080e7          	jalr	-304(ra) # 80002986 <argraw>
    80002abe:	e088                	sd	a0,0(s1)
  return 0;
}
    80002ac0:	4501                	li	a0,0
    80002ac2:	60e2                	ld	ra,24(sp)
    80002ac4:	6442                	ld	s0,16(sp)
    80002ac6:	64a2                	ld	s1,8(sp)
    80002ac8:	6105                	add	sp,sp,32
    80002aca:	8082                	ret

0000000080002acc <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002acc:	1101                	add	sp,sp,-32
    80002ace:	ec06                	sd	ra,24(sp)
    80002ad0:	e822                	sd	s0,16(sp)
    80002ad2:	e426                	sd	s1,8(sp)
    80002ad4:	e04a                	sd	s2,0(sp)
    80002ad6:	1000                	add	s0,sp,32
    80002ad8:	84ae                	mv	s1,a1
    80002ada:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002adc:	00000097          	auipc	ra,0x0
    80002ae0:	eaa080e7          	jalr	-342(ra) # 80002986 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002ae4:	864a                	mv	a2,s2
    80002ae6:	85a6                	mv	a1,s1
    80002ae8:	00000097          	auipc	ra,0x0
    80002aec:	f58080e7          	jalr	-168(ra) # 80002a40 <fetchstr>
}
    80002af0:	60e2                	ld	ra,24(sp)
    80002af2:	6442                	ld	s0,16(sp)
    80002af4:	64a2                	ld	s1,8(sp)
    80002af6:	6902                	ld	s2,0(sp)
    80002af8:	6105                	add	sp,sp,32
    80002afa:	8082                	ret

0000000080002afc <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002afc:	1101                	add	sp,sp,-32
    80002afe:	ec06                	sd	ra,24(sp)
    80002b00:	e822                	sd	s0,16(sp)
    80002b02:	e426                	sd	s1,8(sp)
    80002b04:	e04a                	sd	s2,0(sp)
    80002b06:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002b08:	fffff097          	auipc	ra,0xfffff
    80002b0c:	ebe080e7          	jalr	-322(ra) # 800019c6 <myproc>
    80002b10:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002b12:	05853903          	ld	s2,88(a0)
    80002b16:	0a893783          	ld	a5,168(s2)
    80002b1a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002b1e:	37fd                	addw	a5,a5,-1
    80002b20:	4751                	li	a4,20
    80002b22:	00f76f63          	bltu	a4,a5,80002b40 <syscall+0x44>
    80002b26:	00369713          	sll	a4,a3,0x3
    80002b2a:	00006797          	auipc	a5,0x6
    80002b2e:	8fe78793          	add	a5,a5,-1794 # 80008428 <syscalls>
    80002b32:	97ba                	add	a5,a5,a4
    80002b34:	639c                	ld	a5,0(a5)
    80002b36:	c789                	beqz	a5,80002b40 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002b38:	9782                	jalr	a5
    80002b3a:	06a93823          	sd	a0,112(s2)
    80002b3e:	a839                	j	80002b5c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002b40:	15848613          	add	a2,s1,344
    80002b44:	5c8c                	lw	a1,56(s1)
    80002b46:	00006517          	auipc	a0,0x6
    80002b4a:	8aa50513          	add	a0,a0,-1878 # 800083f0 <states.0+0x148>
    80002b4e:	ffffe097          	auipc	ra,0xffffe
    80002b52:	a3e080e7          	jalr	-1474(ra) # 8000058c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002b56:	6cbc                	ld	a5,88(s1)
    80002b58:	577d                	li	a4,-1
    80002b5a:	fbb8                	sd	a4,112(a5)
  }
}
    80002b5c:	60e2                	ld	ra,24(sp)
    80002b5e:	6442                	ld	s0,16(sp)
    80002b60:	64a2                	ld	s1,8(sp)
    80002b62:	6902                	ld	s2,0(sp)
    80002b64:	6105                	add	sp,sp,32
    80002b66:	8082                	ret

0000000080002b68 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002b68:	1101                	add	sp,sp,-32
    80002b6a:	ec06                	sd	ra,24(sp)
    80002b6c:	e822                	sd	s0,16(sp)
    80002b6e:	1000                	add	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002b70:	fec40593          	add	a1,s0,-20
    80002b74:	4501                	li	a0,0
    80002b76:	00000097          	auipc	ra,0x0
    80002b7a:	f12080e7          	jalr	-238(ra) # 80002a88 <argint>
    return -1;
    80002b7e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002b80:	00054963          	bltz	a0,80002b92 <sys_exit+0x2a>
  exit(n);
    80002b84:	fec42503          	lw	a0,-20(s0)
    80002b88:	fffff097          	auipc	ra,0xfffff
    80002b8c:	50e080e7          	jalr	1294(ra) # 80002096 <exit>
  return 0;  // not reached
    80002b90:	4781                	li	a5,0
}
    80002b92:	853e                	mv	a0,a5
    80002b94:	60e2                	ld	ra,24(sp)
    80002b96:	6442                	ld	s0,16(sp)
    80002b98:	6105                	add	sp,sp,32
    80002b9a:	8082                	ret

0000000080002b9c <sys_getpid>:

uint64
sys_getpid(void)
{
    80002b9c:	1141                	add	sp,sp,-16
    80002b9e:	e406                	sd	ra,8(sp)
    80002ba0:	e022                	sd	s0,0(sp)
    80002ba2:	0800                	add	s0,sp,16
  return myproc()->pid;
    80002ba4:	fffff097          	auipc	ra,0xfffff
    80002ba8:	e22080e7          	jalr	-478(ra) # 800019c6 <myproc>
}
    80002bac:	5d08                	lw	a0,56(a0)
    80002bae:	60a2                	ld	ra,8(sp)
    80002bb0:	6402                	ld	s0,0(sp)
    80002bb2:	0141                	add	sp,sp,16
    80002bb4:	8082                	ret

0000000080002bb6 <sys_fork>:

uint64
sys_fork(void)
{
    80002bb6:	1141                	add	sp,sp,-16
    80002bb8:	e406                	sd	ra,8(sp)
    80002bba:	e022                	sd	s0,0(sp)
    80002bbc:	0800                	add	s0,sp,16
  return fork();
    80002bbe:	fffff097          	auipc	ra,0xfffff
    80002bc2:	1cc080e7          	jalr	460(ra) # 80001d8a <fork>
}
    80002bc6:	60a2                	ld	ra,8(sp)
    80002bc8:	6402                	ld	s0,0(sp)
    80002bca:	0141                	add	sp,sp,16
    80002bcc:	8082                	ret

0000000080002bce <sys_wait>:

uint64
sys_wait(void)
{
    80002bce:	1101                	add	sp,sp,-32
    80002bd0:	ec06                	sd	ra,24(sp)
    80002bd2:	e822                	sd	s0,16(sp)
    80002bd4:	1000                	add	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002bd6:	fe840593          	add	a1,s0,-24
    80002bda:	4501                	li	a0,0
    80002bdc:	00000097          	auipc	ra,0x0
    80002be0:	ece080e7          	jalr	-306(ra) # 80002aaa <argaddr>
    80002be4:	87aa                	mv	a5,a0
    return -1;
    80002be6:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002be8:	0007c863          	bltz	a5,80002bf8 <sys_wait+0x2a>
  return wait(p);
    80002bec:	fe843503          	ld	a0,-24(s0)
    80002bf0:	fffff097          	auipc	ra,0xfffff
    80002bf4:	66a080e7          	jalr	1642(ra) # 8000225a <wait>
}
    80002bf8:	60e2                	ld	ra,24(sp)
    80002bfa:	6442                	ld	s0,16(sp)
    80002bfc:	6105                	add	sp,sp,32
    80002bfe:	8082                	ret

0000000080002c00 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002c00:	7179                	add	sp,sp,-48
    80002c02:	f406                	sd	ra,40(sp)
    80002c04:	f022                	sd	s0,32(sp)
    80002c06:	ec26                	sd	s1,24(sp)
    80002c08:	1800                	add	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002c0a:	fdc40593          	add	a1,s0,-36
    80002c0e:	4501                	li	a0,0
    80002c10:	00000097          	auipc	ra,0x0
    80002c14:	e78080e7          	jalr	-392(ra) # 80002a88 <argint>
    80002c18:	87aa                	mv	a5,a0
    return -1;
    80002c1a:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002c1c:	0207c063          	bltz	a5,80002c3c <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002c20:	fffff097          	auipc	ra,0xfffff
    80002c24:	da6080e7          	jalr	-602(ra) # 800019c6 <myproc>
    80002c28:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002c2a:	fdc42503          	lw	a0,-36(s0)
    80002c2e:	fffff097          	auipc	ra,0xfffff
    80002c32:	0e4080e7          	jalr	228(ra) # 80001d12 <growproc>
    80002c36:	00054863          	bltz	a0,80002c46 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002c3a:	8526                	mv	a0,s1
}
    80002c3c:	70a2                	ld	ra,40(sp)
    80002c3e:	7402                	ld	s0,32(sp)
    80002c40:	64e2                	ld	s1,24(sp)
    80002c42:	6145                	add	sp,sp,48
    80002c44:	8082                	ret
    return -1;
    80002c46:	557d                	li	a0,-1
    80002c48:	bfd5                	j	80002c3c <sys_sbrk+0x3c>

0000000080002c4a <sys_sleep>:

uint64
sys_sleep(void)
{
    80002c4a:	7139                	add	sp,sp,-64
    80002c4c:	fc06                	sd	ra,56(sp)
    80002c4e:	f822                	sd	s0,48(sp)
    80002c50:	f426                	sd	s1,40(sp)
    80002c52:	f04a                	sd	s2,32(sp)
    80002c54:	ec4e                	sd	s3,24(sp)
    80002c56:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002c58:	fcc40593          	add	a1,s0,-52
    80002c5c:	4501                	li	a0,0
    80002c5e:	00000097          	auipc	ra,0x0
    80002c62:	e2a080e7          	jalr	-470(ra) # 80002a88 <argint>
    return -1;
    80002c66:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002c68:	06054563          	bltz	a0,80002cd2 <sys_sleep+0x88>
  acquire(&tickslock);
    80002c6c:	00015517          	auipc	a0,0x15
    80002c70:	afc50513          	add	a0,a0,-1284 # 80017768 <tickslock>
    80002c74:	ffffe097          	auipc	ra,0xffffe
    80002c78:	f88080e7          	jalr	-120(ra) # 80000bfc <acquire>
  ticks0 = ticks;
    80002c7c:	00006917          	auipc	s2,0x6
    80002c80:	3a492903          	lw	s2,932(s2) # 80009020 <ticks>
  while(ticks - ticks0 < n){
    80002c84:	fcc42783          	lw	a5,-52(s0)
    80002c88:	cf85                	beqz	a5,80002cc0 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002c8a:	00015997          	auipc	s3,0x15
    80002c8e:	ade98993          	add	s3,s3,-1314 # 80017768 <tickslock>
    80002c92:	00006497          	auipc	s1,0x6
    80002c96:	38e48493          	add	s1,s1,910 # 80009020 <ticks>
    if(myproc()->killed){
    80002c9a:	fffff097          	auipc	ra,0xfffff
    80002c9e:	d2c080e7          	jalr	-724(ra) # 800019c6 <myproc>
    80002ca2:	591c                	lw	a5,48(a0)
    80002ca4:	ef9d                	bnez	a5,80002ce2 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002ca6:	85ce                	mv	a1,s3
    80002ca8:	8526                	mv	a0,s1
    80002caa:	fffff097          	auipc	ra,0xfffff
    80002cae:	532080e7          	jalr	1330(ra) # 800021dc <sleep>
  while(ticks - ticks0 < n){
    80002cb2:	409c                	lw	a5,0(s1)
    80002cb4:	412787bb          	subw	a5,a5,s2
    80002cb8:	fcc42703          	lw	a4,-52(s0)
    80002cbc:	fce7efe3          	bltu	a5,a4,80002c9a <sys_sleep+0x50>
  }
  release(&tickslock);
    80002cc0:	00015517          	auipc	a0,0x15
    80002cc4:	aa850513          	add	a0,a0,-1368 # 80017768 <tickslock>
    80002cc8:	ffffe097          	auipc	ra,0xffffe
    80002ccc:	fe8080e7          	jalr	-24(ra) # 80000cb0 <release>
  return 0;
    80002cd0:	4781                	li	a5,0
}
    80002cd2:	853e                	mv	a0,a5
    80002cd4:	70e2                	ld	ra,56(sp)
    80002cd6:	7442                	ld	s0,48(sp)
    80002cd8:	74a2                	ld	s1,40(sp)
    80002cda:	7902                	ld	s2,32(sp)
    80002cdc:	69e2                	ld	s3,24(sp)
    80002cde:	6121                	add	sp,sp,64
    80002ce0:	8082                	ret
      release(&tickslock);
    80002ce2:	00015517          	auipc	a0,0x15
    80002ce6:	a8650513          	add	a0,a0,-1402 # 80017768 <tickslock>
    80002cea:	ffffe097          	auipc	ra,0xffffe
    80002cee:	fc6080e7          	jalr	-58(ra) # 80000cb0 <release>
      return -1;
    80002cf2:	57fd                	li	a5,-1
    80002cf4:	bff9                	j	80002cd2 <sys_sleep+0x88>

0000000080002cf6 <sys_kill>:

uint64
sys_kill(void)
{
    80002cf6:	1101                	add	sp,sp,-32
    80002cf8:	ec06                	sd	ra,24(sp)
    80002cfa:	e822                	sd	s0,16(sp)
    80002cfc:	1000                	add	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002cfe:	fec40593          	add	a1,s0,-20
    80002d02:	4501                	li	a0,0
    80002d04:	00000097          	auipc	ra,0x0
    80002d08:	d84080e7          	jalr	-636(ra) # 80002a88 <argint>
    80002d0c:	87aa                	mv	a5,a0
    return -1;
    80002d0e:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002d10:	0007c863          	bltz	a5,80002d20 <sys_kill+0x2a>
  return kill(pid);
    80002d14:	fec42503          	lw	a0,-20(s0)
    80002d18:	fffff097          	auipc	ra,0xfffff
    80002d1c:	6ae080e7          	jalr	1710(ra) # 800023c6 <kill>
}
    80002d20:	60e2                	ld	ra,24(sp)
    80002d22:	6442                	ld	s0,16(sp)
    80002d24:	6105                	add	sp,sp,32
    80002d26:	8082                	ret

0000000080002d28 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002d28:	1101                	add	sp,sp,-32
    80002d2a:	ec06                	sd	ra,24(sp)
    80002d2c:	e822                	sd	s0,16(sp)
    80002d2e:	e426                	sd	s1,8(sp)
    80002d30:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002d32:	00015517          	auipc	a0,0x15
    80002d36:	a3650513          	add	a0,a0,-1482 # 80017768 <tickslock>
    80002d3a:	ffffe097          	auipc	ra,0xffffe
    80002d3e:	ec2080e7          	jalr	-318(ra) # 80000bfc <acquire>
  xticks = ticks;
    80002d42:	00006497          	auipc	s1,0x6
    80002d46:	2de4a483          	lw	s1,734(s1) # 80009020 <ticks>
  release(&tickslock);
    80002d4a:	00015517          	auipc	a0,0x15
    80002d4e:	a1e50513          	add	a0,a0,-1506 # 80017768 <tickslock>
    80002d52:	ffffe097          	auipc	ra,0xffffe
    80002d56:	f5e080e7          	jalr	-162(ra) # 80000cb0 <release>
  return xticks;
}
    80002d5a:	02049513          	sll	a0,s1,0x20
    80002d5e:	9101                	srl	a0,a0,0x20
    80002d60:	60e2                	ld	ra,24(sp)
    80002d62:	6442                	ld	s0,16(sp)
    80002d64:	64a2                	ld	s1,8(sp)
    80002d66:	6105                	add	sp,sp,32
    80002d68:	8082                	ret

0000000080002d6a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002d6a:	7179                	add	sp,sp,-48
    80002d6c:	f406                	sd	ra,40(sp)
    80002d6e:	f022                	sd	s0,32(sp)
    80002d70:	ec26                	sd	s1,24(sp)
    80002d72:	e84a                	sd	s2,16(sp)
    80002d74:	e44e                	sd	s3,8(sp)
    80002d76:	e052                	sd	s4,0(sp)
    80002d78:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002d7a:	00005597          	auipc	a1,0x5
    80002d7e:	75e58593          	add	a1,a1,1886 # 800084d8 <syscalls+0xb0>
    80002d82:	00015517          	auipc	a0,0x15
    80002d86:	9fe50513          	add	a0,a0,-1538 # 80017780 <bcache>
    80002d8a:	ffffe097          	auipc	ra,0xffffe
    80002d8e:	de2080e7          	jalr	-542(ra) # 80000b6c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002d92:	0001d797          	auipc	a5,0x1d
    80002d96:	9ee78793          	add	a5,a5,-1554 # 8001f780 <bcache+0x8000>
    80002d9a:	0001d717          	auipc	a4,0x1d
    80002d9e:	c4e70713          	add	a4,a4,-946 # 8001f9e8 <bcache+0x8268>
    80002da2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002da6:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002daa:	00015497          	auipc	s1,0x15
    80002dae:	9ee48493          	add	s1,s1,-1554 # 80017798 <bcache+0x18>
    b->next = bcache.head.next;
    80002db2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002db4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002db6:	00005a17          	auipc	s4,0x5
    80002dba:	72aa0a13          	add	s4,s4,1834 # 800084e0 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002dbe:	2b893783          	ld	a5,696(s2)
    80002dc2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002dc4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002dc8:	85d2                	mv	a1,s4
    80002dca:	01048513          	add	a0,s1,16
    80002dce:	00001097          	auipc	ra,0x1
    80002dd2:	484080e7          	jalr	1156(ra) # 80004252 <initsleeplock>
    bcache.head.next->prev = b;
    80002dd6:	2b893783          	ld	a5,696(s2)
    80002dda:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002ddc:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002de0:	45848493          	add	s1,s1,1112
    80002de4:	fd349de3          	bne	s1,s3,80002dbe <binit+0x54>
  }
}
    80002de8:	70a2                	ld	ra,40(sp)
    80002dea:	7402                	ld	s0,32(sp)
    80002dec:	64e2                	ld	s1,24(sp)
    80002dee:	6942                	ld	s2,16(sp)
    80002df0:	69a2                	ld	s3,8(sp)
    80002df2:	6a02                	ld	s4,0(sp)
    80002df4:	6145                	add	sp,sp,48
    80002df6:	8082                	ret

0000000080002df8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002df8:	7179                	add	sp,sp,-48
    80002dfa:	f406                	sd	ra,40(sp)
    80002dfc:	f022                	sd	s0,32(sp)
    80002dfe:	ec26                	sd	s1,24(sp)
    80002e00:	e84a                	sd	s2,16(sp)
    80002e02:	e44e                	sd	s3,8(sp)
    80002e04:	1800                	add	s0,sp,48
    80002e06:	892a                	mv	s2,a0
    80002e08:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002e0a:	00015517          	auipc	a0,0x15
    80002e0e:	97650513          	add	a0,a0,-1674 # 80017780 <bcache>
    80002e12:	ffffe097          	auipc	ra,0xffffe
    80002e16:	dea080e7          	jalr	-534(ra) # 80000bfc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002e1a:	0001d497          	auipc	s1,0x1d
    80002e1e:	c1e4b483          	ld	s1,-994(s1) # 8001fa38 <bcache+0x82b8>
    80002e22:	0001d797          	auipc	a5,0x1d
    80002e26:	bc678793          	add	a5,a5,-1082 # 8001f9e8 <bcache+0x8268>
    80002e2a:	02f48f63          	beq	s1,a5,80002e68 <bread+0x70>
    80002e2e:	873e                	mv	a4,a5
    80002e30:	a021                	j	80002e38 <bread+0x40>
    80002e32:	68a4                	ld	s1,80(s1)
    80002e34:	02e48a63          	beq	s1,a4,80002e68 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002e38:	449c                	lw	a5,8(s1)
    80002e3a:	ff279ce3          	bne	a5,s2,80002e32 <bread+0x3a>
    80002e3e:	44dc                	lw	a5,12(s1)
    80002e40:	ff3799e3          	bne	a5,s3,80002e32 <bread+0x3a>
      b->refcnt++;
    80002e44:	40bc                	lw	a5,64(s1)
    80002e46:	2785                	addw	a5,a5,1
    80002e48:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e4a:	00015517          	auipc	a0,0x15
    80002e4e:	93650513          	add	a0,a0,-1738 # 80017780 <bcache>
    80002e52:	ffffe097          	auipc	ra,0xffffe
    80002e56:	e5e080e7          	jalr	-418(ra) # 80000cb0 <release>
      acquiresleep(&b->lock);
    80002e5a:	01048513          	add	a0,s1,16
    80002e5e:	00001097          	auipc	ra,0x1
    80002e62:	42e080e7          	jalr	1070(ra) # 8000428c <acquiresleep>
      return b;
    80002e66:	a8b9                	j	80002ec4 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e68:	0001d497          	auipc	s1,0x1d
    80002e6c:	bc84b483          	ld	s1,-1080(s1) # 8001fa30 <bcache+0x82b0>
    80002e70:	0001d797          	auipc	a5,0x1d
    80002e74:	b7878793          	add	a5,a5,-1160 # 8001f9e8 <bcache+0x8268>
    80002e78:	00f48863          	beq	s1,a5,80002e88 <bread+0x90>
    80002e7c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002e7e:	40bc                	lw	a5,64(s1)
    80002e80:	cf81                	beqz	a5,80002e98 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e82:	64a4                	ld	s1,72(s1)
    80002e84:	fee49de3          	bne	s1,a4,80002e7e <bread+0x86>
  panic("bget: no buffers");
    80002e88:	00005517          	auipc	a0,0x5
    80002e8c:	66050513          	add	a0,a0,1632 # 800084e8 <syscalls+0xc0>
    80002e90:	ffffd097          	auipc	ra,0xffffd
    80002e94:	6b2080e7          	jalr	1714(ra) # 80000542 <panic>
      b->dev = dev;
    80002e98:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002e9c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002ea0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002ea4:	4785                	li	a5,1
    80002ea6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002ea8:	00015517          	auipc	a0,0x15
    80002eac:	8d850513          	add	a0,a0,-1832 # 80017780 <bcache>
    80002eb0:	ffffe097          	auipc	ra,0xffffe
    80002eb4:	e00080e7          	jalr	-512(ra) # 80000cb0 <release>
      acquiresleep(&b->lock);
    80002eb8:	01048513          	add	a0,s1,16
    80002ebc:	00001097          	auipc	ra,0x1
    80002ec0:	3d0080e7          	jalr	976(ra) # 8000428c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002ec4:	409c                	lw	a5,0(s1)
    80002ec6:	cb89                	beqz	a5,80002ed8 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002ec8:	8526                	mv	a0,s1
    80002eca:	70a2                	ld	ra,40(sp)
    80002ecc:	7402                	ld	s0,32(sp)
    80002ece:	64e2                	ld	s1,24(sp)
    80002ed0:	6942                	ld	s2,16(sp)
    80002ed2:	69a2                	ld	s3,8(sp)
    80002ed4:	6145                	add	sp,sp,48
    80002ed6:	8082                	ret
    virtio_disk_rw(b, 0);
    80002ed8:	4581                	li	a1,0
    80002eda:	8526                	mv	a0,s1
    80002edc:	00003097          	auipc	ra,0x3
    80002ee0:	edc080e7          	jalr	-292(ra) # 80005db8 <virtio_disk_rw>
    b->valid = 1;
    80002ee4:	4785                	li	a5,1
    80002ee6:	c09c                	sw	a5,0(s1)
  return b;
    80002ee8:	b7c5                	j	80002ec8 <bread+0xd0>

0000000080002eea <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002eea:	1101                	add	sp,sp,-32
    80002eec:	ec06                	sd	ra,24(sp)
    80002eee:	e822                	sd	s0,16(sp)
    80002ef0:	e426                	sd	s1,8(sp)
    80002ef2:	1000                	add	s0,sp,32
    80002ef4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002ef6:	0541                	add	a0,a0,16
    80002ef8:	00001097          	auipc	ra,0x1
    80002efc:	42e080e7          	jalr	1070(ra) # 80004326 <holdingsleep>
    80002f00:	cd01                	beqz	a0,80002f18 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002f02:	4585                	li	a1,1
    80002f04:	8526                	mv	a0,s1
    80002f06:	00003097          	auipc	ra,0x3
    80002f0a:	eb2080e7          	jalr	-334(ra) # 80005db8 <virtio_disk_rw>
}
    80002f0e:	60e2                	ld	ra,24(sp)
    80002f10:	6442                	ld	s0,16(sp)
    80002f12:	64a2                	ld	s1,8(sp)
    80002f14:	6105                	add	sp,sp,32
    80002f16:	8082                	ret
    panic("bwrite");
    80002f18:	00005517          	auipc	a0,0x5
    80002f1c:	5e850513          	add	a0,a0,1512 # 80008500 <syscalls+0xd8>
    80002f20:	ffffd097          	auipc	ra,0xffffd
    80002f24:	622080e7          	jalr	1570(ra) # 80000542 <panic>

0000000080002f28 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002f28:	1101                	add	sp,sp,-32
    80002f2a:	ec06                	sd	ra,24(sp)
    80002f2c:	e822                	sd	s0,16(sp)
    80002f2e:	e426                	sd	s1,8(sp)
    80002f30:	e04a                	sd	s2,0(sp)
    80002f32:	1000                	add	s0,sp,32
    80002f34:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002f36:	01050913          	add	s2,a0,16
    80002f3a:	854a                	mv	a0,s2
    80002f3c:	00001097          	auipc	ra,0x1
    80002f40:	3ea080e7          	jalr	1002(ra) # 80004326 <holdingsleep>
    80002f44:	c925                	beqz	a0,80002fb4 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002f46:	854a                	mv	a0,s2
    80002f48:	00001097          	auipc	ra,0x1
    80002f4c:	39a080e7          	jalr	922(ra) # 800042e2 <releasesleep>

  acquire(&bcache.lock);
    80002f50:	00015517          	auipc	a0,0x15
    80002f54:	83050513          	add	a0,a0,-2000 # 80017780 <bcache>
    80002f58:	ffffe097          	auipc	ra,0xffffe
    80002f5c:	ca4080e7          	jalr	-860(ra) # 80000bfc <acquire>
  b->refcnt--;
    80002f60:	40bc                	lw	a5,64(s1)
    80002f62:	37fd                	addw	a5,a5,-1
    80002f64:	0007871b          	sext.w	a4,a5
    80002f68:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002f6a:	e71d                	bnez	a4,80002f98 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002f6c:	68b8                	ld	a4,80(s1)
    80002f6e:	64bc                	ld	a5,72(s1)
    80002f70:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002f72:	68b8                	ld	a4,80(s1)
    80002f74:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002f76:	0001d797          	auipc	a5,0x1d
    80002f7a:	80a78793          	add	a5,a5,-2038 # 8001f780 <bcache+0x8000>
    80002f7e:	2b87b703          	ld	a4,696(a5)
    80002f82:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002f84:	0001d717          	auipc	a4,0x1d
    80002f88:	a6470713          	add	a4,a4,-1436 # 8001f9e8 <bcache+0x8268>
    80002f8c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002f8e:	2b87b703          	ld	a4,696(a5)
    80002f92:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002f94:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002f98:	00014517          	auipc	a0,0x14
    80002f9c:	7e850513          	add	a0,a0,2024 # 80017780 <bcache>
    80002fa0:	ffffe097          	auipc	ra,0xffffe
    80002fa4:	d10080e7          	jalr	-752(ra) # 80000cb0 <release>
}
    80002fa8:	60e2                	ld	ra,24(sp)
    80002faa:	6442                	ld	s0,16(sp)
    80002fac:	64a2                	ld	s1,8(sp)
    80002fae:	6902                	ld	s2,0(sp)
    80002fb0:	6105                	add	sp,sp,32
    80002fb2:	8082                	ret
    panic("brelse");
    80002fb4:	00005517          	auipc	a0,0x5
    80002fb8:	55450513          	add	a0,a0,1364 # 80008508 <syscalls+0xe0>
    80002fbc:	ffffd097          	auipc	ra,0xffffd
    80002fc0:	586080e7          	jalr	1414(ra) # 80000542 <panic>

0000000080002fc4 <bpin>:

void
bpin(struct buf *b) {
    80002fc4:	1101                	add	sp,sp,-32
    80002fc6:	ec06                	sd	ra,24(sp)
    80002fc8:	e822                	sd	s0,16(sp)
    80002fca:	e426                	sd	s1,8(sp)
    80002fcc:	1000                	add	s0,sp,32
    80002fce:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002fd0:	00014517          	auipc	a0,0x14
    80002fd4:	7b050513          	add	a0,a0,1968 # 80017780 <bcache>
    80002fd8:	ffffe097          	auipc	ra,0xffffe
    80002fdc:	c24080e7          	jalr	-988(ra) # 80000bfc <acquire>
  b->refcnt++;
    80002fe0:	40bc                	lw	a5,64(s1)
    80002fe2:	2785                	addw	a5,a5,1
    80002fe4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002fe6:	00014517          	auipc	a0,0x14
    80002fea:	79a50513          	add	a0,a0,1946 # 80017780 <bcache>
    80002fee:	ffffe097          	auipc	ra,0xffffe
    80002ff2:	cc2080e7          	jalr	-830(ra) # 80000cb0 <release>
}
    80002ff6:	60e2                	ld	ra,24(sp)
    80002ff8:	6442                	ld	s0,16(sp)
    80002ffa:	64a2                	ld	s1,8(sp)
    80002ffc:	6105                	add	sp,sp,32
    80002ffe:	8082                	ret

0000000080003000 <bunpin>:

void
bunpin(struct buf *b) {
    80003000:	1101                	add	sp,sp,-32
    80003002:	ec06                	sd	ra,24(sp)
    80003004:	e822                	sd	s0,16(sp)
    80003006:	e426                	sd	s1,8(sp)
    80003008:	1000                	add	s0,sp,32
    8000300a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000300c:	00014517          	auipc	a0,0x14
    80003010:	77450513          	add	a0,a0,1908 # 80017780 <bcache>
    80003014:	ffffe097          	auipc	ra,0xffffe
    80003018:	be8080e7          	jalr	-1048(ra) # 80000bfc <acquire>
  b->refcnt--;
    8000301c:	40bc                	lw	a5,64(s1)
    8000301e:	37fd                	addw	a5,a5,-1
    80003020:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003022:	00014517          	auipc	a0,0x14
    80003026:	75e50513          	add	a0,a0,1886 # 80017780 <bcache>
    8000302a:	ffffe097          	auipc	ra,0xffffe
    8000302e:	c86080e7          	jalr	-890(ra) # 80000cb0 <release>
}
    80003032:	60e2                	ld	ra,24(sp)
    80003034:	6442                	ld	s0,16(sp)
    80003036:	64a2                	ld	s1,8(sp)
    80003038:	6105                	add	sp,sp,32
    8000303a:	8082                	ret

000000008000303c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000303c:	1101                	add	sp,sp,-32
    8000303e:	ec06                	sd	ra,24(sp)
    80003040:	e822                	sd	s0,16(sp)
    80003042:	e426                	sd	s1,8(sp)
    80003044:	e04a                	sd	s2,0(sp)
    80003046:	1000                	add	s0,sp,32
    80003048:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000304a:	00d5d59b          	srlw	a1,a1,0xd
    8000304e:	0001d797          	auipc	a5,0x1d
    80003052:	e0e7a783          	lw	a5,-498(a5) # 8001fe5c <sb+0x1c>
    80003056:	9dbd                	addw	a1,a1,a5
    80003058:	00000097          	auipc	ra,0x0
    8000305c:	da0080e7          	jalr	-608(ra) # 80002df8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003060:	0074f713          	and	a4,s1,7
    80003064:	4785                	li	a5,1
    80003066:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000306a:	14ce                	sll	s1,s1,0x33
    8000306c:	90d9                	srl	s1,s1,0x36
    8000306e:	00950733          	add	a4,a0,s1
    80003072:	05874703          	lbu	a4,88(a4)
    80003076:	00e7f6b3          	and	a3,a5,a4
    8000307a:	c69d                	beqz	a3,800030a8 <bfree+0x6c>
    8000307c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000307e:	94aa                	add	s1,s1,a0
    80003080:	fff7c793          	not	a5,a5
    80003084:	8f7d                	and	a4,a4,a5
    80003086:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000308a:	00001097          	auipc	ra,0x1
    8000308e:	0dc080e7          	jalr	220(ra) # 80004166 <log_write>
  brelse(bp);
    80003092:	854a                	mv	a0,s2
    80003094:	00000097          	auipc	ra,0x0
    80003098:	e94080e7          	jalr	-364(ra) # 80002f28 <brelse>
}
    8000309c:	60e2                	ld	ra,24(sp)
    8000309e:	6442                	ld	s0,16(sp)
    800030a0:	64a2                	ld	s1,8(sp)
    800030a2:	6902                	ld	s2,0(sp)
    800030a4:	6105                	add	sp,sp,32
    800030a6:	8082                	ret
    panic("freeing free block");
    800030a8:	00005517          	auipc	a0,0x5
    800030ac:	46850513          	add	a0,a0,1128 # 80008510 <syscalls+0xe8>
    800030b0:	ffffd097          	auipc	ra,0xffffd
    800030b4:	492080e7          	jalr	1170(ra) # 80000542 <panic>

00000000800030b8 <balloc>:
{
    800030b8:	711d                	add	sp,sp,-96
    800030ba:	ec86                	sd	ra,88(sp)
    800030bc:	e8a2                	sd	s0,80(sp)
    800030be:	e4a6                	sd	s1,72(sp)
    800030c0:	e0ca                	sd	s2,64(sp)
    800030c2:	fc4e                	sd	s3,56(sp)
    800030c4:	f852                	sd	s4,48(sp)
    800030c6:	f456                	sd	s5,40(sp)
    800030c8:	f05a                	sd	s6,32(sp)
    800030ca:	ec5e                	sd	s7,24(sp)
    800030cc:	e862                	sd	s8,16(sp)
    800030ce:	e466                	sd	s9,8(sp)
    800030d0:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800030d2:	0001d797          	auipc	a5,0x1d
    800030d6:	d727a783          	lw	a5,-654(a5) # 8001fe44 <sb+0x4>
    800030da:	cbc1                	beqz	a5,8000316a <balloc+0xb2>
    800030dc:	8baa                	mv	s7,a0
    800030de:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800030e0:	0001db17          	auipc	s6,0x1d
    800030e4:	d60b0b13          	add	s6,s6,-672 # 8001fe40 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030e8:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800030ea:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030ec:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800030ee:	6c89                	lui	s9,0x2
    800030f0:	a831                	j	8000310c <balloc+0x54>
    brelse(bp);
    800030f2:	854a                	mv	a0,s2
    800030f4:	00000097          	auipc	ra,0x0
    800030f8:	e34080e7          	jalr	-460(ra) # 80002f28 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800030fc:	015c87bb          	addw	a5,s9,s5
    80003100:	00078a9b          	sext.w	s5,a5
    80003104:	004b2703          	lw	a4,4(s6)
    80003108:	06eaf163          	bgeu	s5,a4,8000316a <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    8000310c:	41fad79b          	sraw	a5,s5,0x1f
    80003110:	0137d79b          	srlw	a5,a5,0x13
    80003114:	015787bb          	addw	a5,a5,s5
    80003118:	40d7d79b          	sraw	a5,a5,0xd
    8000311c:	01cb2583          	lw	a1,28(s6)
    80003120:	9dbd                	addw	a1,a1,a5
    80003122:	855e                	mv	a0,s7
    80003124:	00000097          	auipc	ra,0x0
    80003128:	cd4080e7          	jalr	-812(ra) # 80002df8 <bread>
    8000312c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000312e:	004b2503          	lw	a0,4(s6)
    80003132:	000a849b          	sext.w	s1,s5
    80003136:	8762                	mv	a4,s8
    80003138:	faa4fde3          	bgeu	s1,a0,800030f2 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000313c:	00777693          	and	a3,a4,7
    80003140:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003144:	41f7579b          	sraw	a5,a4,0x1f
    80003148:	01d7d79b          	srlw	a5,a5,0x1d
    8000314c:	9fb9                	addw	a5,a5,a4
    8000314e:	4037d79b          	sraw	a5,a5,0x3
    80003152:	00f90633          	add	a2,s2,a5
    80003156:	05864603          	lbu	a2,88(a2)
    8000315a:	00c6f5b3          	and	a1,a3,a2
    8000315e:	cd91                	beqz	a1,8000317a <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003160:	2705                	addw	a4,a4,1
    80003162:	2485                	addw	s1,s1,1
    80003164:	fd471ae3          	bne	a4,s4,80003138 <balloc+0x80>
    80003168:	b769                	j	800030f2 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000316a:	00005517          	auipc	a0,0x5
    8000316e:	3be50513          	add	a0,a0,958 # 80008528 <syscalls+0x100>
    80003172:	ffffd097          	auipc	ra,0xffffd
    80003176:	3d0080e7          	jalr	976(ra) # 80000542 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000317a:	97ca                	add	a5,a5,s2
    8000317c:	8e55                	or	a2,a2,a3
    8000317e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003182:	854a                	mv	a0,s2
    80003184:	00001097          	auipc	ra,0x1
    80003188:	fe2080e7          	jalr	-30(ra) # 80004166 <log_write>
        brelse(bp);
    8000318c:	854a                	mv	a0,s2
    8000318e:	00000097          	auipc	ra,0x0
    80003192:	d9a080e7          	jalr	-614(ra) # 80002f28 <brelse>
  bp = bread(dev, bno);
    80003196:	85a6                	mv	a1,s1
    80003198:	855e                	mv	a0,s7
    8000319a:	00000097          	auipc	ra,0x0
    8000319e:	c5e080e7          	jalr	-930(ra) # 80002df8 <bread>
    800031a2:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800031a4:	40000613          	li	a2,1024
    800031a8:	4581                	li	a1,0
    800031aa:	05850513          	add	a0,a0,88
    800031ae:	ffffe097          	auipc	ra,0xffffe
    800031b2:	b4a080e7          	jalr	-1206(ra) # 80000cf8 <memset>
  log_write(bp);
    800031b6:	854a                	mv	a0,s2
    800031b8:	00001097          	auipc	ra,0x1
    800031bc:	fae080e7          	jalr	-82(ra) # 80004166 <log_write>
  brelse(bp);
    800031c0:	854a                	mv	a0,s2
    800031c2:	00000097          	auipc	ra,0x0
    800031c6:	d66080e7          	jalr	-666(ra) # 80002f28 <brelse>
}
    800031ca:	8526                	mv	a0,s1
    800031cc:	60e6                	ld	ra,88(sp)
    800031ce:	6446                	ld	s0,80(sp)
    800031d0:	64a6                	ld	s1,72(sp)
    800031d2:	6906                	ld	s2,64(sp)
    800031d4:	79e2                	ld	s3,56(sp)
    800031d6:	7a42                	ld	s4,48(sp)
    800031d8:	7aa2                	ld	s5,40(sp)
    800031da:	7b02                	ld	s6,32(sp)
    800031dc:	6be2                	ld	s7,24(sp)
    800031de:	6c42                	ld	s8,16(sp)
    800031e0:	6ca2                	ld	s9,8(sp)
    800031e2:	6125                	add	sp,sp,96
    800031e4:	8082                	ret

00000000800031e6 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800031e6:	7179                	add	sp,sp,-48
    800031e8:	f406                	sd	ra,40(sp)
    800031ea:	f022                	sd	s0,32(sp)
    800031ec:	ec26                	sd	s1,24(sp)
    800031ee:	e84a                	sd	s2,16(sp)
    800031f0:	e44e                	sd	s3,8(sp)
    800031f2:	e052                	sd	s4,0(sp)
    800031f4:	1800                	add	s0,sp,48
    800031f6:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800031f8:	47ad                	li	a5,11
    800031fa:	04b7fe63          	bgeu	a5,a1,80003256 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800031fe:	ff45849b          	addw	s1,a1,-12
    80003202:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003206:	0ff00793          	li	a5,255
    8000320a:	0ae7e463          	bltu	a5,a4,800032b2 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000320e:	08052583          	lw	a1,128(a0)
    80003212:	c5b5                	beqz	a1,8000327e <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003214:	00092503          	lw	a0,0(s2)
    80003218:	00000097          	auipc	ra,0x0
    8000321c:	be0080e7          	jalr	-1056(ra) # 80002df8 <bread>
    80003220:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003222:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    80003226:	02049713          	sll	a4,s1,0x20
    8000322a:	01e75593          	srl	a1,a4,0x1e
    8000322e:	00b784b3          	add	s1,a5,a1
    80003232:	0004a983          	lw	s3,0(s1)
    80003236:	04098e63          	beqz	s3,80003292 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000323a:	8552                	mv	a0,s4
    8000323c:	00000097          	auipc	ra,0x0
    80003240:	cec080e7          	jalr	-788(ra) # 80002f28 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003244:	854e                	mv	a0,s3
    80003246:	70a2                	ld	ra,40(sp)
    80003248:	7402                	ld	s0,32(sp)
    8000324a:	64e2                	ld	s1,24(sp)
    8000324c:	6942                	ld	s2,16(sp)
    8000324e:	69a2                	ld	s3,8(sp)
    80003250:	6a02                	ld	s4,0(sp)
    80003252:	6145                	add	sp,sp,48
    80003254:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80003256:	02059793          	sll	a5,a1,0x20
    8000325a:	01e7d593          	srl	a1,a5,0x1e
    8000325e:	00b504b3          	add	s1,a0,a1
    80003262:	0504a983          	lw	s3,80(s1)
    80003266:	fc099fe3          	bnez	s3,80003244 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000326a:	4108                	lw	a0,0(a0)
    8000326c:	00000097          	auipc	ra,0x0
    80003270:	e4c080e7          	jalr	-436(ra) # 800030b8 <balloc>
    80003274:	0005099b          	sext.w	s3,a0
    80003278:	0534a823          	sw	s3,80(s1)
    8000327c:	b7e1                	j	80003244 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000327e:	4108                	lw	a0,0(a0)
    80003280:	00000097          	auipc	ra,0x0
    80003284:	e38080e7          	jalr	-456(ra) # 800030b8 <balloc>
    80003288:	0005059b          	sext.w	a1,a0
    8000328c:	08b92023          	sw	a1,128(s2)
    80003290:	b751                	j	80003214 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003292:	00092503          	lw	a0,0(s2)
    80003296:	00000097          	auipc	ra,0x0
    8000329a:	e22080e7          	jalr	-478(ra) # 800030b8 <balloc>
    8000329e:	0005099b          	sext.w	s3,a0
    800032a2:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800032a6:	8552                	mv	a0,s4
    800032a8:	00001097          	auipc	ra,0x1
    800032ac:	ebe080e7          	jalr	-322(ra) # 80004166 <log_write>
    800032b0:	b769                	j	8000323a <bmap+0x54>
  panic("bmap: out of range");
    800032b2:	00005517          	auipc	a0,0x5
    800032b6:	28e50513          	add	a0,a0,654 # 80008540 <syscalls+0x118>
    800032ba:	ffffd097          	auipc	ra,0xffffd
    800032be:	288080e7          	jalr	648(ra) # 80000542 <panic>

00000000800032c2 <iget>:
{
    800032c2:	7179                	add	sp,sp,-48
    800032c4:	f406                	sd	ra,40(sp)
    800032c6:	f022                	sd	s0,32(sp)
    800032c8:	ec26                	sd	s1,24(sp)
    800032ca:	e84a                	sd	s2,16(sp)
    800032cc:	e44e                	sd	s3,8(sp)
    800032ce:	e052                	sd	s4,0(sp)
    800032d0:	1800                	add	s0,sp,48
    800032d2:	89aa                	mv	s3,a0
    800032d4:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    800032d6:	0001d517          	auipc	a0,0x1d
    800032da:	b8a50513          	add	a0,a0,-1142 # 8001fe60 <icache>
    800032de:	ffffe097          	auipc	ra,0xffffe
    800032e2:	91e080e7          	jalr	-1762(ra) # 80000bfc <acquire>
  empty = 0;
    800032e6:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800032e8:	0001d497          	auipc	s1,0x1d
    800032ec:	b9048493          	add	s1,s1,-1136 # 8001fe78 <icache+0x18>
    800032f0:	0001e697          	auipc	a3,0x1e
    800032f4:	61868693          	add	a3,a3,1560 # 80021908 <log>
    800032f8:	a039                	j	80003306 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800032fa:	02090b63          	beqz	s2,80003330 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800032fe:	08848493          	add	s1,s1,136
    80003302:	02d48a63          	beq	s1,a3,80003336 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003306:	449c                	lw	a5,8(s1)
    80003308:	fef059e3          	blez	a5,800032fa <iget+0x38>
    8000330c:	4098                	lw	a4,0(s1)
    8000330e:	ff3716e3          	bne	a4,s3,800032fa <iget+0x38>
    80003312:	40d8                	lw	a4,4(s1)
    80003314:	ff4713e3          	bne	a4,s4,800032fa <iget+0x38>
      ip->ref++;
    80003318:	2785                	addw	a5,a5,1
    8000331a:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    8000331c:	0001d517          	auipc	a0,0x1d
    80003320:	b4450513          	add	a0,a0,-1212 # 8001fe60 <icache>
    80003324:	ffffe097          	auipc	ra,0xffffe
    80003328:	98c080e7          	jalr	-1652(ra) # 80000cb0 <release>
      return ip;
    8000332c:	8926                	mv	s2,s1
    8000332e:	a03d                	j	8000335c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003330:	f7f9                	bnez	a5,800032fe <iget+0x3c>
    80003332:	8926                	mv	s2,s1
    80003334:	b7e9                	j	800032fe <iget+0x3c>
  if(empty == 0)
    80003336:	02090c63          	beqz	s2,8000336e <iget+0xac>
  ip->dev = dev;
    8000333a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000333e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003342:	4785                	li	a5,1
    80003344:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003348:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    8000334c:	0001d517          	auipc	a0,0x1d
    80003350:	b1450513          	add	a0,a0,-1260 # 8001fe60 <icache>
    80003354:	ffffe097          	auipc	ra,0xffffe
    80003358:	95c080e7          	jalr	-1700(ra) # 80000cb0 <release>
}
    8000335c:	854a                	mv	a0,s2
    8000335e:	70a2                	ld	ra,40(sp)
    80003360:	7402                	ld	s0,32(sp)
    80003362:	64e2                	ld	s1,24(sp)
    80003364:	6942                	ld	s2,16(sp)
    80003366:	69a2                	ld	s3,8(sp)
    80003368:	6a02                	ld	s4,0(sp)
    8000336a:	6145                	add	sp,sp,48
    8000336c:	8082                	ret
    panic("iget: no inodes");
    8000336e:	00005517          	auipc	a0,0x5
    80003372:	1ea50513          	add	a0,a0,490 # 80008558 <syscalls+0x130>
    80003376:	ffffd097          	auipc	ra,0xffffd
    8000337a:	1cc080e7          	jalr	460(ra) # 80000542 <panic>

000000008000337e <fsinit>:
fsinit(int dev) {
    8000337e:	7179                	add	sp,sp,-48
    80003380:	f406                	sd	ra,40(sp)
    80003382:	f022                	sd	s0,32(sp)
    80003384:	ec26                	sd	s1,24(sp)
    80003386:	e84a                	sd	s2,16(sp)
    80003388:	e44e                	sd	s3,8(sp)
    8000338a:	1800                	add	s0,sp,48
    8000338c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000338e:	4585                	li	a1,1
    80003390:	00000097          	auipc	ra,0x0
    80003394:	a68080e7          	jalr	-1432(ra) # 80002df8 <bread>
    80003398:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000339a:	0001d997          	auipc	s3,0x1d
    8000339e:	aa698993          	add	s3,s3,-1370 # 8001fe40 <sb>
    800033a2:	02000613          	li	a2,32
    800033a6:	05850593          	add	a1,a0,88
    800033aa:	854e                	mv	a0,s3
    800033ac:	ffffe097          	auipc	ra,0xffffe
    800033b0:	9a8080e7          	jalr	-1624(ra) # 80000d54 <memmove>
  brelse(bp);
    800033b4:	8526                	mv	a0,s1
    800033b6:	00000097          	auipc	ra,0x0
    800033ba:	b72080e7          	jalr	-1166(ra) # 80002f28 <brelse>
  if(sb.magic != FSMAGIC)
    800033be:	0009a703          	lw	a4,0(s3)
    800033c2:	102037b7          	lui	a5,0x10203
    800033c6:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800033ca:	02f71263          	bne	a4,a5,800033ee <fsinit+0x70>
  initlog(dev, &sb);
    800033ce:	0001d597          	auipc	a1,0x1d
    800033d2:	a7258593          	add	a1,a1,-1422 # 8001fe40 <sb>
    800033d6:	854a                	mv	a0,s2
    800033d8:	00001097          	auipc	ra,0x1
    800033dc:	b28080e7          	jalr	-1240(ra) # 80003f00 <initlog>
}
    800033e0:	70a2                	ld	ra,40(sp)
    800033e2:	7402                	ld	s0,32(sp)
    800033e4:	64e2                	ld	s1,24(sp)
    800033e6:	6942                	ld	s2,16(sp)
    800033e8:	69a2                	ld	s3,8(sp)
    800033ea:	6145                	add	sp,sp,48
    800033ec:	8082                	ret
    panic("invalid file system");
    800033ee:	00005517          	auipc	a0,0x5
    800033f2:	17a50513          	add	a0,a0,378 # 80008568 <syscalls+0x140>
    800033f6:	ffffd097          	auipc	ra,0xffffd
    800033fa:	14c080e7          	jalr	332(ra) # 80000542 <panic>

00000000800033fe <iinit>:
{
    800033fe:	7179                	add	sp,sp,-48
    80003400:	f406                	sd	ra,40(sp)
    80003402:	f022                	sd	s0,32(sp)
    80003404:	ec26                	sd	s1,24(sp)
    80003406:	e84a                	sd	s2,16(sp)
    80003408:	e44e                	sd	s3,8(sp)
    8000340a:	1800                	add	s0,sp,48
  initlock(&icache.lock, "icache");
    8000340c:	00005597          	auipc	a1,0x5
    80003410:	17458593          	add	a1,a1,372 # 80008580 <syscalls+0x158>
    80003414:	0001d517          	auipc	a0,0x1d
    80003418:	a4c50513          	add	a0,a0,-1460 # 8001fe60 <icache>
    8000341c:	ffffd097          	auipc	ra,0xffffd
    80003420:	750080e7          	jalr	1872(ra) # 80000b6c <initlock>
  for(i = 0; i < NINODE; i++) {
    80003424:	0001d497          	auipc	s1,0x1d
    80003428:	a6448493          	add	s1,s1,-1436 # 8001fe88 <icache+0x28>
    8000342c:	0001e997          	auipc	s3,0x1e
    80003430:	4ec98993          	add	s3,s3,1260 # 80021918 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003434:	00005917          	auipc	s2,0x5
    80003438:	15490913          	add	s2,s2,340 # 80008588 <syscalls+0x160>
    8000343c:	85ca                	mv	a1,s2
    8000343e:	8526                	mv	a0,s1
    80003440:	00001097          	auipc	ra,0x1
    80003444:	e12080e7          	jalr	-494(ra) # 80004252 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003448:	08848493          	add	s1,s1,136
    8000344c:	ff3498e3          	bne	s1,s3,8000343c <iinit+0x3e>
}
    80003450:	70a2                	ld	ra,40(sp)
    80003452:	7402                	ld	s0,32(sp)
    80003454:	64e2                	ld	s1,24(sp)
    80003456:	6942                	ld	s2,16(sp)
    80003458:	69a2                	ld	s3,8(sp)
    8000345a:	6145                	add	sp,sp,48
    8000345c:	8082                	ret

000000008000345e <ialloc>:
{
    8000345e:	7139                	add	sp,sp,-64
    80003460:	fc06                	sd	ra,56(sp)
    80003462:	f822                	sd	s0,48(sp)
    80003464:	f426                	sd	s1,40(sp)
    80003466:	f04a                	sd	s2,32(sp)
    80003468:	ec4e                	sd	s3,24(sp)
    8000346a:	e852                	sd	s4,16(sp)
    8000346c:	e456                	sd	s5,8(sp)
    8000346e:	e05a                	sd	s6,0(sp)
    80003470:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003472:	0001d717          	auipc	a4,0x1d
    80003476:	9da72703          	lw	a4,-1574(a4) # 8001fe4c <sb+0xc>
    8000347a:	4785                	li	a5,1
    8000347c:	04e7f863          	bgeu	a5,a4,800034cc <ialloc+0x6e>
    80003480:	8aaa                	mv	s5,a0
    80003482:	8b2e                	mv	s6,a1
    80003484:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003486:	0001da17          	auipc	s4,0x1d
    8000348a:	9baa0a13          	add	s4,s4,-1606 # 8001fe40 <sb>
    8000348e:	00495593          	srl	a1,s2,0x4
    80003492:	018a2783          	lw	a5,24(s4)
    80003496:	9dbd                	addw	a1,a1,a5
    80003498:	8556                	mv	a0,s5
    8000349a:	00000097          	auipc	ra,0x0
    8000349e:	95e080e7          	jalr	-1698(ra) # 80002df8 <bread>
    800034a2:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800034a4:	05850993          	add	s3,a0,88
    800034a8:	00f97793          	and	a5,s2,15
    800034ac:	079a                	sll	a5,a5,0x6
    800034ae:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800034b0:	00099783          	lh	a5,0(s3)
    800034b4:	c785                	beqz	a5,800034dc <ialloc+0x7e>
    brelse(bp);
    800034b6:	00000097          	auipc	ra,0x0
    800034ba:	a72080e7          	jalr	-1422(ra) # 80002f28 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800034be:	0905                	add	s2,s2,1
    800034c0:	00ca2703          	lw	a4,12(s4)
    800034c4:	0009079b          	sext.w	a5,s2
    800034c8:	fce7e3e3          	bltu	a5,a4,8000348e <ialloc+0x30>
  panic("ialloc: no inodes");
    800034cc:	00005517          	auipc	a0,0x5
    800034d0:	0c450513          	add	a0,a0,196 # 80008590 <syscalls+0x168>
    800034d4:	ffffd097          	auipc	ra,0xffffd
    800034d8:	06e080e7          	jalr	110(ra) # 80000542 <panic>
      memset(dip, 0, sizeof(*dip));
    800034dc:	04000613          	li	a2,64
    800034e0:	4581                	li	a1,0
    800034e2:	854e                	mv	a0,s3
    800034e4:	ffffe097          	auipc	ra,0xffffe
    800034e8:	814080e7          	jalr	-2028(ra) # 80000cf8 <memset>
      dip->type = type;
    800034ec:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800034f0:	8526                	mv	a0,s1
    800034f2:	00001097          	auipc	ra,0x1
    800034f6:	c74080e7          	jalr	-908(ra) # 80004166 <log_write>
      brelse(bp);
    800034fa:	8526                	mv	a0,s1
    800034fc:	00000097          	auipc	ra,0x0
    80003500:	a2c080e7          	jalr	-1492(ra) # 80002f28 <brelse>
      return iget(dev, inum);
    80003504:	0009059b          	sext.w	a1,s2
    80003508:	8556                	mv	a0,s5
    8000350a:	00000097          	auipc	ra,0x0
    8000350e:	db8080e7          	jalr	-584(ra) # 800032c2 <iget>
}
    80003512:	70e2                	ld	ra,56(sp)
    80003514:	7442                	ld	s0,48(sp)
    80003516:	74a2                	ld	s1,40(sp)
    80003518:	7902                	ld	s2,32(sp)
    8000351a:	69e2                	ld	s3,24(sp)
    8000351c:	6a42                	ld	s4,16(sp)
    8000351e:	6aa2                	ld	s5,8(sp)
    80003520:	6b02                	ld	s6,0(sp)
    80003522:	6121                	add	sp,sp,64
    80003524:	8082                	ret

0000000080003526 <iupdate>:
{
    80003526:	1101                	add	sp,sp,-32
    80003528:	ec06                	sd	ra,24(sp)
    8000352a:	e822                	sd	s0,16(sp)
    8000352c:	e426                	sd	s1,8(sp)
    8000352e:	e04a                	sd	s2,0(sp)
    80003530:	1000                	add	s0,sp,32
    80003532:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003534:	415c                	lw	a5,4(a0)
    80003536:	0047d79b          	srlw	a5,a5,0x4
    8000353a:	0001d597          	auipc	a1,0x1d
    8000353e:	91e5a583          	lw	a1,-1762(a1) # 8001fe58 <sb+0x18>
    80003542:	9dbd                	addw	a1,a1,a5
    80003544:	4108                	lw	a0,0(a0)
    80003546:	00000097          	auipc	ra,0x0
    8000354a:	8b2080e7          	jalr	-1870(ra) # 80002df8 <bread>
    8000354e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003550:	05850793          	add	a5,a0,88
    80003554:	40d8                	lw	a4,4(s1)
    80003556:	8b3d                	and	a4,a4,15
    80003558:	071a                	sll	a4,a4,0x6
    8000355a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000355c:	04449703          	lh	a4,68(s1)
    80003560:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003564:	04649703          	lh	a4,70(s1)
    80003568:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000356c:	04849703          	lh	a4,72(s1)
    80003570:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003574:	04a49703          	lh	a4,74(s1)
    80003578:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000357c:	44f8                	lw	a4,76(s1)
    8000357e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003580:	03400613          	li	a2,52
    80003584:	05048593          	add	a1,s1,80
    80003588:	00c78513          	add	a0,a5,12
    8000358c:	ffffd097          	auipc	ra,0xffffd
    80003590:	7c8080e7          	jalr	1992(ra) # 80000d54 <memmove>
  log_write(bp);
    80003594:	854a                	mv	a0,s2
    80003596:	00001097          	auipc	ra,0x1
    8000359a:	bd0080e7          	jalr	-1072(ra) # 80004166 <log_write>
  brelse(bp);
    8000359e:	854a                	mv	a0,s2
    800035a0:	00000097          	auipc	ra,0x0
    800035a4:	988080e7          	jalr	-1656(ra) # 80002f28 <brelse>
}
    800035a8:	60e2                	ld	ra,24(sp)
    800035aa:	6442                	ld	s0,16(sp)
    800035ac:	64a2                	ld	s1,8(sp)
    800035ae:	6902                	ld	s2,0(sp)
    800035b0:	6105                	add	sp,sp,32
    800035b2:	8082                	ret

00000000800035b4 <idup>:
{
    800035b4:	1101                	add	sp,sp,-32
    800035b6:	ec06                	sd	ra,24(sp)
    800035b8:	e822                	sd	s0,16(sp)
    800035ba:	e426                	sd	s1,8(sp)
    800035bc:	1000                	add	s0,sp,32
    800035be:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800035c0:	0001d517          	auipc	a0,0x1d
    800035c4:	8a050513          	add	a0,a0,-1888 # 8001fe60 <icache>
    800035c8:	ffffd097          	auipc	ra,0xffffd
    800035cc:	634080e7          	jalr	1588(ra) # 80000bfc <acquire>
  ip->ref++;
    800035d0:	449c                	lw	a5,8(s1)
    800035d2:	2785                	addw	a5,a5,1
    800035d4:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800035d6:	0001d517          	auipc	a0,0x1d
    800035da:	88a50513          	add	a0,a0,-1910 # 8001fe60 <icache>
    800035de:	ffffd097          	auipc	ra,0xffffd
    800035e2:	6d2080e7          	jalr	1746(ra) # 80000cb0 <release>
}
    800035e6:	8526                	mv	a0,s1
    800035e8:	60e2                	ld	ra,24(sp)
    800035ea:	6442                	ld	s0,16(sp)
    800035ec:	64a2                	ld	s1,8(sp)
    800035ee:	6105                	add	sp,sp,32
    800035f0:	8082                	ret

00000000800035f2 <ilock>:
{
    800035f2:	1101                	add	sp,sp,-32
    800035f4:	ec06                	sd	ra,24(sp)
    800035f6:	e822                	sd	s0,16(sp)
    800035f8:	e426                	sd	s1,8(sp)
    800035fa:	e04a                	sd	s2,0(sp)
    800035fc:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800035fe:	c115                	beqz	a0,80003622 <ilock+0x30>
    80003600:	84aa                	mv	s1,a0
    80003602:	451c                	lw	a5,8(a0)
    80003604:	00f05f63          	blez	a5,80003622 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003608:	0541                	add	a0,a0,16
    8000360a:	00001097          	auipc	ra,0x1
    8000360e:	c82080e7          	jalr	-894(ra) # 8000428c <acquiresleep>
  if(ip->valid == 0){
    80003612:	40bc                	lw	a5,64(s1)
    80003614:	cf99                	beqz	a5,80003632 <ilock+0x40>
}
    80003616:	60e2                	ld	ra,24(sp)
    80003618:	6442                	ld	s0,16(sp)
    8000361a:	64a2                	ld	s1,8(sp)
    8000361c:	6902                	ld	s2,0(sp)
    8000361e:	6105                	add	sp,sp,32
    80003620:	8082                	ret
    panic("ilock");
    80003622:	00005517          	auipc	a0,0x5
    80003626:	f8650513          	add	a0,a0,-122 # 800085a8 <syscalls+0x180>
    8000362a:	ffffd097          	auipc	ra,0xffffd
    8000362e:	f18080e7          	jalr	-232(ra) # 80000542 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003632:	40dc                	lw	a5,4(s1)
    80003634:	0047d79b          	srlw	a5,a5,0x4
    80003638:	0001d597          	auipc	a1,0x1d
    8000363c:	8205a583          	lw	a1,-2016(a1) # 8001fe58 <sb+0x18>
    80003640:	9dbd                	addw	a1,a1,a5
    80003642:	4088                	lw	a0,0(s1)
    80003644:	fffff097          	auipc	ra,0xfffff
    80003648:	7b4080e7          	jalr	1972(ra) # 80002df8 <bread>
    8000364c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000364e:	05850593          	add	a1,a0,88
    80003652:	40dc                	lw	a5,4(s1)
    80003654:	8bbd                	and	a5,a5,15
    80003656:	079a                	sll	a5,a5,0x6
    80003658:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000365a:	00059783          	lh	a5,0(a1)
    8000365e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003662:	00259783          	lh	a5,2(a1)
    80003666:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000366a:	00459783          	lh	a5,4(a1)
    8000366e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003672:	00659783          	lh	a5,6(a1)
    80003676:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000367a:	459c                	lw	a5,8(a1)
    8000367c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000367e:	03400613          	li	a2,52
    80003682:	05b1                	add	a1,a1,12
    80003684:	05048513          	add	a0,s1,80
    80003688:	ffffd097          	auipc	ra,0xffffd
    8000368c:	6cc080e7          	jalr	1740(ra) # 80000d54 <memmove>
    brelse(bp);
    80003690:	854a                	mv	a0,s2
    80003692:	00000097          	auipc	ra,0x0
    80003696:	896080e7          	jalr	-1898(ra) # 80002f28 <brelse>
    ip->valid = 1;
    8000369a:	4785                	li	a5,1
    8000369c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000369e:	04449783          	lh	a5,68(s1)
    800036a2:	fbb5                	bnez	a5,80003616 <ilock+0x24>
      panic("ilock: no type");
    800036a4:	00005517          	auipc	a0,0x5
    800036a8:	f0c50513          	add	a0,a0,-244 # 800085b0 <syscalls+0x188>
    800036ac:	ffffd097          	auipc	ra,0xffffd
    800036b0:	e96080e7          	jalr	-362(ra) # 80000542 <panic>

00000000800036b4 <iunlock>:
{
    800036b4:	1101                	add	sp,sp,-32
    800036b6:	ec06                	sd	ra,24(sp)
    800036b8:	e822                	sd	s0,16(sp)
    800036ba:	e426                	sd	s1,8(sp)
    800036bc:	e04a                	sd	s2,0(sp)
    800036be:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800036c0:	c905                	beqz	a0,800036f0 <iunlock+0x3c>
    800036c2:	84aa                	mv	s1,a0
    800036c4:	01050913          	add	s2,a0,16
    800036c8:	854a                	mv	a0,s2
    800036ca:	00001097          	auipc	ra,0x1
    800036ce:	c5c080e7          	jalr	-932(ra) # 80004326 <holdingsleep>
    800036d2:	cd19                	beqz	a0,800036f0 <iunlock+0x3c>
    800036d4:	449c                	lw	a5,8(s1)
    800036d6:	00f05d63          	blez	a5,800036f0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    800036da:	854a                	mv	a0,s2
    800036dc:	00001097          	auipc	ra,0x1
    800036e0:	c06080e7          	jalr	-1018(ra) # 800042e2 <releasesleep>
}
    800036e4:	60e2                	ld	ra,24(sp)
    800036e6:	6442                	ld	s0,16(sp)
    800036e8:	64a2                	ld	s1,8(sp)
    800036ea:	6902                	ld	s2,0(sp)
    800036ec:	6105                	add	sp,sp,32
    800036ee:	8082                	ret
    panic("iunlock");
    800036f0:	00005517          	auipc	a0,0x5
    800036f4:	ed050513          	add	a0,a0,-304 # 800085c0 <syscalls+0x198>
    800036f8:	ffffd097          	auipc	ra,0xffffd
    800036fc:	e4a080e7          	jalr	-438(ra) # 80000542 <panic>

0000000080003700 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003700:	7179                	add	sp,sp,-48
    80003702:	f406                	sd	ra,40(sp)
    80003704:	f022                	sd	s0,32(sp)
    80003706:	ec26                	sd	s1,24(sp)
    80003708:	e84a                	sd	s2,16(sp)
    8000370a:	e44e                	sd	s3,8(sp)
    8000370c:	e052                	sd	s4,0(sp)
    8000370e:	1800                	add	s0,sp,48
    80003710:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003712:	05050493          	add	s1,a0,80
    80003716:	08050913          	add	s2,a0,128
    8000371a:	a021                	j	80003722 <itrunc+0x22>
    8000371c:	0491                	add	s1,s1,4
    8000371e:	01248d63          	beq	s1,s2,80003738 <itrunc+0x38>
    if(ip->addrs[i]){
    80003722:	408c                	lw	a1,0(s1)
    80003724:	dde5                	beqz	a1,8000371c <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003726:	0009a503          	lw	a0,0(s3)
    8000372a:	00000097          	auipc	ra,0x0
    8000372e:	912080e7          	jalr	-1774(ra) # 8000303c <bfree>
      ip->addrs[i] = 0;
    80003732:	0004a023          	sw	zero,0(s1)
    80003736:	b7dd                	j	8000371c <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003738:	0809a583          	lw	a1,128(s3)
    8000373c:	e185                	bnez	a1,8000375c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000373e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003742:	854e                	mv	a0,s3
    80003744:	00000097          	auipc	ra,0x0
    80003748:	de2080e7          	jalr	-542(ra) # 80003526 <iupdate>
}
    8000374c:	70a2                	ld	ra,40(sp)
    8000374e:	7402                	ld	s0,32(sp)
    80003750:	64e2                	ld	s1,24(sp)
    80003752:	6942                	ld	s2,16(sp)
    80003754:	69a2                	ld	s3,8(sp)
    80003756:	6a02                	ld	s4,0(sp)
    80003758:	6145                	add	sp,sp,48
    8000375a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000375c:	0009a503          	lw	a0,0(s3)
    80003760:	fffff097          	auipc	ra,0xfffff
    80003764:	698080e7          	jalr	1688(ra) # 80002df8 <bread>
    80003768:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000376a:	05850493          	add	s1,a0,88
    8000376e:	45850913          	add	s2,a0,1112
    80003772:	a021                	j	8000377a <itrunc+0x7a>
    80003774:	0491                	add	s1,s1,4
    80003776:	01248b63          	beq	s1,s2,8000378c <itrunc+0x8c>
      if(a[j])
    8000377a:	408c                	lw	a1,0(s1)
    8000377c:	dde5                	beqz	a1,80003774 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    8000377e:	0009a503          	lw	a0,0(s3)
    80003782:	00000097          	auipc	ra,0x0
    80003786:	8ba080e7          	jalr	-1862(ra) # 8000303c <bfree>
    8000378a:	b7ed                	j	80003774 <itrunc+0x74>
    brelse(bp);
    8000378c:	8552                	mv	a0,s4
    8000378e:	fffff097          	auipc	ra,0xfffff
    80003792:	79a080e7          	jalr	1946(ra) # 80002f28 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003796:	0809a583          	lw	a1,128(s3)
    8000379a:	0009a503          	lw	a0,0(s3)
    8000379e:	00000097          	auipc	ra,0x0
    800037a2:	89e080e7          	jalr	-1890(ra) # 8000303c <bfree>
    ip->addrs[NDIRECT] = 0;
    800037a6:	0809a023          	sw	zero,128(s3)
    800037aa:	bf51                	j	8000373e <itrunc+0x3e>

00000000800037ac <iput>:
{
    800037ac:	1101                	add	sp,sp,-32
    800037ae:	ec06                	sd	ra,24(sp)
    800037b0:	e822                	sd	s0,16(sp)
    800037b2:	e426                	sd	s1,8(sp)
    800037b4:	e04a                	sd	s2,0(sp)
    800037b6:	1000                	add	s0,sp,32
    800037b8:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800037ba:	0001c517          	auipc	a0,0x1c
    800037be:	6a650513          	add	a0,a0,1702 # 8001fe60 <icache>
    800037c2:	ffffd097          	auipc	ra,0xffffd
    800037c6:	43a080e7          	jalr	1082(ra) # 80000bfc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800037ca:	4498                	lw	a4,8(s1)
    800037cc:	4785                	li	a5,1
    800037ce:	02f70363          	beq	a4,a5,800037f4 <iput+0x48>
  ip->ref--;
    800037d2:	449c                	lw	a5,8(s1)
    800037d4:	37fd                	addw	a5,a5,-1
    800037d6:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800037d8:	0001c517          	auipc	a0,0x1c
    800037dc:	68850513          	add	a0,a0,1672 # 8001fe60 <icache>
    800037e0:	ffffd097          	auipc	ra,0xffffd
    800037e4:	4d0080e7          	jalr	1232(ra) # 80000cb0 <release>
}
    800037e8:	60e2                	ld	ra,24(sp)
    800037ea:	6442                	ld	s0,16(sp)
    800037ec:	64a2                	ld	s1,8(sp)
    800037ee:	6902                	ld	s2,0(sp)
    800037f0:	6105                	add	sp,sp,32
    800037f2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800037f4:	40bc                	lw	a5,64(s1)
    800037f6:	dff1                	beqz	a5,800037d2 <iput+0x26>
    800037f8:	04a49783          	lh	a5,74(s1)
    800037fc:	fbf9                	bnez	a5,800037d2 <iput+0x26>
    acquiresleep(&ip->lock);
    800037fe:	01048913          	add	s2,s1,16
    80003802:	854a                	mv	a0,s2
    80003804:	00001097          	auipc	ra,0x1
    80003808:	a88080e7          	jalr	-1400(ra) # 8000428c <acquiresleep>
    release(&icache.lock);
    8000380c:	0001c517          	auipc	a0,0x1c
    80003810:	65450513          	add	a0,a0,1620 # 8001fe60 <icache>
    80003814:	ffffd097          	auipc	ra,0xffffd
    80003818:	49c080e7          	jalr	1180(ra) # 80000cb0 <release>
    itrunc(ip);
    8000381c:	8526                	mv	a0,s1
    8000381e:	00000097          	auipc	ra,0x0
    80003822:	ee2080e7          	jalr	-286(ra) # 80003700 <itrunc>
    ip->type = 0;
    80003826:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000382a:	8526                	mv	a0,s1
    8000382c:	00000097          	auipc	ra,0x0
    80003830:	cfa080e7          	jalr	-774(ra) # 80003526 <iupdate>
    ip->valid = 0;
    80003834:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003838:	854a                	mv	a0,s2
    8000383a:	00001097          	auipc	ra,0x1
    8000383e:	aa8080e7          	jalr	-1368(ra) # 800042e2 <releasesleep>
    acquire(&icache.lock);
    80003842:	0001c517          	auipc	a0,0x1c
    80003846:	61e50513          	add	a0,a0,1566 # 8001fe60 <icache>
    8000384a:	ffffd097          	auipc	ra,0xffffd
    8000384e:	3b2080e7          	jalr	946(ra) # 80000bfc <acquire>
    80003852:	b741                	j	800037d2 <iput+0x26>

0000000080003854 <iunlockput>:
{
    80003854:	1101                	add	sp,sp,-32
    80003856:	ec06                	sd	ra,24(sp)
    80003858:	e822                	sd	s0,16(sp)
    8000385a:	e426                	sd	s1,8(sp)
    8000385c:	1000                	add	s0,sp,32
    8000385e:	84aa                	mv	s1,a0
  iunlock(ip);
    80003860:	00000097          	auipc	ra,0x0
    80003864:	e54080e7          	jalr	-428(ra) # 800036b4 <iunlock>
  iput(ip);
    80003868:	8526                	mv	a0,s1
    8000386a:	00000097          	auipc	ra,0x0
    8000386e:	f42080e7          	jalr	-190(ra) # 800037ac <iput>
}
    80003872:	60e2                	ld	ra,24(sp)
    80003874:	6442                	ld	s0,16(sp)
    80003876:	64a2                	ld	s1,8(sp)
    80003878:	6105                	add	sp,sp,32
    8000387a:	8082                	ret

000000008000387c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000387c:	1141                	add	sp,sp,-16
    8000387e:	e422                	sd	s0,8(sp)
    80003880:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80003882:	411c                	lw	a5,0(a0)
    80003884:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003886:	415c                	lw	a5,4(a0)
    80003888:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000388a:	04451783          	lh	a5,68(a0)
    8000388e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003892:	04a51783          	lh	a5,74(a0)
    80003896:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000389a:	04c56783          	lwu	a5,76(a0)
    8000389e:	e99c                	sd	a5,16(a1)
}
    800038a0:	6422                	ld	s0,8(sp)
    800038a2:	0141                	add	sp,sp,16
    800038a4:	8082                	ret

00000000800038a6 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800038a6:	457c                	lw	a5,76(a0)
    800038a8:	0ed7e963          	bltu	a5,a3,8000399a <readi+0xf4>
{
    800038ac:	7159                	add	sp,sp,-112
    800038ae:	f486                	sd	ra,104(sp)
    800038b0:	f0a2                	sd	s0,96(sp)
    800038b2:	eca6                	sd	s1,88(sp)
    800038b4:	e8ca                	sd	s2,80(sp)
    800038b6:	e4ce                	sd	s3,72(sp)
    800038b8:	e0d2                	sd	s4,64(sp)
    800038ba:	fc56                	sd	s5,56(sp)
    800038bc:	f85a                	sd	s6,48(sp)
    800038be:	f45e                	sd	s7,40(sp)
    800038c0:	f062                	sd	s8,32(sp)
    800038c2:	ec66                	sd	s9,24(sp)
    800038c4:	e86a                	sd	s10,16(sp)
    800038c6:	e46e                	sd	s11,8(sp)
    800038c8:	1880                	add	s0,sp,112
    800038ca:	8baa                	mv	s7,a0
    800038cc:	8c2e                	mv	s8,a1
    800038ce:	8ab2                	mv	s5,a2
    800038d0:	84b6                	mv	s1,a3
    800038d2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800038d4:	9f35                	addw	a4,a4,a3
    return 0;
    800038d6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800038d8:	0ad76063          	bltu	a4,a3,80003978 <readi+0xd2>
  if(off + n > ip->size)
    800038dc:	00e7f463          	bgeu	a5,a4,800038e4 <readi+0x3e>
    n = ip->size - off;
    800038e0:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800038e4:	0a0b0963          	beqz	s6,80003996 <readi+0xf0>
    800038e8:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800038ea:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800038ee:	5cfd                	li	s9,-1
    800038f0:	a82d                	j	8000392a <readi+0x84>
    800038f2:	020a1d93          	sll	s11,s4,0x20
    800038f6:	020ddd93          	srl	s11,s11,0x20
    800038fa:	05890613          	add	a2,s2,88
    800038fe:	86ee                	mv	a3,s11
    80003900:	963a                	add	a2,a2,a4
    80003902:	85d6                	mv	a1,s5
    80003904:	8562                	mv	a0,s8
    80003906:	fffff097          	auipc	ra,0xfffff
    8000390a:	b30080e7          	jalr	-1232(ra) # 80002436 <either_copyout>
    8000390e:	05950d63          	beq	a0,s9,80003968 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003912:	854a                	mv	a0,s2
    80003914:	fffff097          	auipc	ra,0xfffff
    80003918:	614080e7          	jalr	1556(ra) # 80002f28 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000391c:	013a09bb          	addw	s3,s4,s3
    80003920:	009a04bb          	addw	s1,s4,s1
    80003924:	9aee                	add	s5,s5,s11
    80003926:	0569f763          	bgeu	s3,s6,80003974 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000392a:	000ba903          	lw	s2,0(s7)
    8000392e:	00a4d59b          	srlw	a1,s1,0xa
    80003932:	855e                	mv	a0,s7
    80003934:	00000097          	auipc	ra,0x0
    80003938:	8b2080e7          	jalr	-1870(ra) # 800031e6 <bmap>
    8000393c:	0005059b          	sext.w	a1,a0
    80003940:	854a                	mv	a0,s2
    80003942:	fffff097          	auipc	ra,0xfffff
    80003946:	4b6080e7          	jalr	1206(ra) # 80002df8 <bread>
    8000394a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000394c:	3ff4f713          	and	a4,s1,1023
    80003950:	40ed07bb          	subw	a5,s10,a4
    80003954:	413b06bb          	subw	a3,s6,s3
    80003958:	8a3e                	mv	s4,a5
    8000395a:	2781                	sext.w	a5,a5
    8000395c:	0006861b          	sext.w	a2,a3
    80003960:	f8f679e3          	bgeu	a2,a5,800038f2 <readi+0x4c>
    80003964:	8a36                	mv	s4,a3
    80003966:	b771                	j	800038f2 <readi+0x4c>
      brelse(bp);
    80003968:	854a                	mv	a0,s2
    8000396a:	fffff097          	auipc	ra,0xfffff
    8000396e:	5be080e7          	jalr	1470(ra) # 80002f28 <brelse>
      tot = -1;
    80003972:	59fd                	li	s3,-1
  }
  return tot;
    80003974:	0009851b          	sext.w	a0,s3
}
    80003978:	70a6                	ld	ra,104(sp)
    8000397a:	7406                	ld	s0,96(sp)
    8000397c:	64e6                	ld	s1,88(sp)
    8000397e:	6946                	ld	s2,80(sp)
    80003980:	69a6                	ld	s3,72(sp)
    80003982:	6a06                	ld	s4,64(sp)
    80003984:	7ae2                	ld	s5,56(sp)
    80003986:	7b42                	ld	s6,48(sp)
    80003988:	7ba2                	ld	s7,40(sp)
    8000398a:	7c02                	ld	s8,32(sp)
    8000398c:	6ce2                	ld	s9,24(sp)
    8000398e:	6d42                	ld	s10,16(sp)
    80003990:	6da2                	ld	s11,8(sp)
    80003992:	6165                	add	sp,sp,112
    80003994:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003996:	89da                	mv	s3,s6
    80003998:	bff1                	j	80003974 <readi+0xce>
    return 0;
    8000399a:	4501                	li	a0,0
}
    8000399c:	8082                	ret

000000008000399e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000399e:	457c                	lw	a5,76(a0)
    800039a0:	10d7e763          	bltu	a5,a3,80003aae <writei+0x110>
{
    800039a4:	7159                	add	sp,sp,-112
    800039a6:	f486                	sd	ra,104(sp)
    800039a8:	f0a2                	sd	s0,96(sp)
    800039aa:	eca6                	sd	s1,88(sp)
    800039ac:	e8ca                	sd	s2,80(sp)
    800039ae:	e4ce                	sd	s3,72(sp)
    800039b0:	e0d2                	sd	s4,64(sp)
    800039b2:	fc56                	sd	s5,56(sp)
    800039b4:	f85a                	sd	s6,48(sp)
    800039b6:	f45e                	sd	s7,40(sp)
    800039b8:	f062                	sd	s8,32(sp)
    800039ba:	ec66                	sd	s9,24(sp)
    800039bc:	e86a                	sd	s10,16(sp)
    800039be:	e46e                	sd	s11,8(sp)
    800039c0:	1880                	add	s0,sp,112
    800039c2:	8baa                	mv	s7,a0
    800039c4:	8c2e                	mv	s8,a1
    800039c6:	8ab2                	mv	s5,a2
    800039c8:	8936                	mv	s2,a3
    800039ca:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800039cc:	00e687bb          	addw	a5,a3,a4
    800039d0:	0ed7e163          	bltu	a5,a3,80003ab2 <writei+0x114>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800039d4:	00043737          	lui	a4,0x43
    800039d8:	0cf76f63          	bltu	a4,a5,80003ab6 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800039dc:	0a0b0863          	beqz	s6,80003a8c <writei+0xee>
    800039e0:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800039e2:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800039e6:	5cfd                	li	s9,-1
    800039e8:	a091                	j	80003a2c <writei+0x8e>
    800039ea:	02099d93          	sll	s11,s3,0x20
    800039ee:	020ddd93          	srl	s11,s11,0x20
    800039f2:	05848513          	add	a0,s1,88
    800039f6:	86ee                	mv	a3,s11
    800039f8:	8656                	mv	a2,s5
    800039fa:	85e2                	mv	a1,s8
    800039fc:	953a                	add	a0,a0,a4
    800039fe:	fffff097          	auipc	ra,0xfffff
    80003a02:	a8e080e7          	jalr	-1394(ra) # 8000248c <either_copyin>
    80003a06:	07950263          	beq	a0,s9,80003a6a <writei+0xcc>
      brelse(bp);
      n = -1;
      break;
    }
    log_write(bp);
    80003a0a:	8526                	mv	a0,s1
    80003a0c:	00000097          	auipc	ra,0x0
    80003a10:	75a080e7          	jalr	1882(ra) # 80004166 <log_write>
    brelse(bp);
    80003a14:	8526                	mv	a0,s1
    80003a16:	fffff097          	auipc	ra,0xfffff
    80003a1a:	512080e7          	jalr	1298(ra) # 80002f28 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003a1e:	01498a3b          	addw	s4,s3,s4
    80003a22:	0129893b          	addw	s2,s3,s2
    80003a26:	9aee                	add	s5,s5,s11
    80003a28:	056a7763          	bgeu	s4,s6,80003a76 <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003a2c:	000ba483          	lw	s1,0(s7)
    80003a30:	00a9559b          	srlw	a1,s2,0xa
    80003a34:	855e                	mv	a0,s7
    80003a36:	fffff097          	auipc	ra,0xfffff
    80003a3a:	7b0080e7          	jalr	1968(ra) # 800031e6 <bmap>
    80003a3e:	0005059b          	sext.w	a1,a0
    80003a42:	8526                	mv	a0,s1
    80003a44:	fffff097          	auipc	ra,0xfffff
    80003a48:	3b4080e7          	jalr	948(ra) # 80002df8 <bread>
    80003a4c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a4e:	3ff97713          	and	a4,s2,1023
    80003a52:	40ed07bb          	subw	a5,s10,a4
    80003a56:	414b06bb          	subw	a3,s6,s4
    80003a5a:	89be                	mv	s3,a5
    80003a5c:	2781                	sext.w	a5,a5
    80003a5e:	0006861b          	sext.w	a2,a3
    80003a62:	f8f674e3          	bgeu	a2,a5,800039ea <writei+0x4c>
    80003a66:	89b6                	mv	s3,a3
    80003a68:	b749                	j	800039ea <writei+0x4c>
      brelse(bp);
    80003a6a:	8526                	mv	a0,s1
    80003a6c:	fffff097          	auipc	ra,0xfffff
    80003a70:	4bc080e7          	jalr	1212(ra) # 80002f28 <brelse>
      n = -1;
    80003a74:	5b7d                	li	s6,-1
  }

  if(n > 0){
    if(off > ip->size)
    80003a76:	04cba783          	lw	a5,76(s7)
    80003a7a:	0127f463          	bgeu	a5,s2,80003a82 <writei+0xe4>
      ip->size = off;
    80003a7e:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003a82:	855e                	mv	a0,s7
    80003a84:	00000097          	auipc	ra,0x0
    80003a88:	aa2080e7          	jalr	-1374(ra) # 80003526 <iupdate>
  }

  return n;
    80003a8c:	000b051b          	sext.w	a0,s6
}
    80003a90:	70a6                	ld	ra,104(sp)
    80003a92:	7406                	ld	s0,96(sp)
    80003a94:	64e6                	ld	s1,88(sp)
    80003a96:	6946                	ld	s2,80(sp)
    80003a98:	69a6                	ld	s3,72(sp)
    80003a9a:	6a06                	ld	s4,64(sp)
    80003a9c:	7ae2                	ld	s5,56(sp)
    80003a9e:	7b42                	ld	s6,48(sp)
    80003aa0:	7ba2                	ld	s7,40(sp)
    80003aa2:	7c02                	ld	s8,32(sp)
    80003aa4:	6ce2                	ld	s9,24(sp)
    80003aa6:	6d42                	ld	s10,16(sp)
    80003aa8:	6da2                	ld	s11,8(sp)
    80003aaa:	6165                	add	sp,sp,112
    80003aac:	8082                	ret
    return -1;
    80003aae:	557d                	li	a0,-1
}
    80003ab0:	8082                	ret
    return -1;
    80003ab2:	557d                	li	a0,-1
    80003ab4:	bff1                	j	80003a90 <writei+0xf2>
    return -1;
    80003ab6:	557d                	li	a0,-1
    80003ab8:	bfe1                	j	80003a90 <writei+0xf2>

0000000080003aba <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003aba:	1141                	add	sp,sp,-16
    80003abc:	e406                	sd	ra,8(sp)
    80003abe:	e022                	sd	s0,0(sp)
    80003ac0:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003ac2:	4639                	li	a2,14
    80003ac4:	ffffd097          	auipc	ra,0xffffd
    80003ac8:	30c080e7          	jalr	780(ra) # 80000dd0 <strncmp>
}
    80003acc:	60a2                	ld	ra,8(sp)
    80003ace:	6402                	ld	s0,0(sp)
    80003ad0:	0141                	add	sp,sp,16
    80003ad2:	8082                	ret

0000000080003ad4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003ad4:	7139                	add	sp,sp,-64
    80003ad6:	fc06                	sd	ra,56(sp)
    80003ad8:	f822                	sd	s0,48(sp)
    80003ada:	f426                	sd	s1,40(sp)
    80003adc:	f04a                	sd	s2,32(sp)
    80003ade:	ec4e                	sd	s3,24(sp)
    80003ae0:	e852                	sd	s4,16(sp)
    80003ae2:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003ae4:	04451703          	lh	a4,68(a0)
    80003ae8:	4785                	li	a5,1
    80003aea:	00f71a63          	bne	a4,a5,80003afe <dirlookup+0x2a>
    80003aee:	892a                	mv	s2,a0
    80003af0:	89ae                	mv	s3,a1
    80003af2:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003af4:	457c                	lw	a5,76(a0)
    80003af6:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003af8:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003afa:	e79d                	bnez	a5,80003b28 <dirlookup+0x54>
    80003afc:	a8a5                	j	80003b74 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003afe:	00005517          	auipc	a0,0x5
    80003b02:	aca50513          	add	a0,a0,-1334 # 800085c8 <syscalls+0x1a0>
    80003b06:	ffffd097          	auipc	ra,0xffffd
    80003b0a:	a3c080e7          	jalr	-1476(ra) # 80000542 <panic>
      panic("dirlookup read");
    80003b0e:	00005517          	auipc	a0,0x5
    80003b12:	ad250513          	add	a0,a0,-1326 # 800085e0 <syscalls+0x1b8>
    80003b16:	ffffd097          	auipc	ra,0xffffd
    80003b1a:	a2c080e7          	jalr	-1492(ra) # 80000542 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b1e:	24c1                	addw	s1,s1,16
    80003b20:	04c92783          	lw	a5,76(s2)
    80003b24:	04f4f763          	bgeu	s1,a5,80003b72 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b28:	4741                	li	a4,16
    80003b2a:	86a6                	mv	a3,s1
    80003b2c:	fc040613          	add	a2,s0,-64
    80003b30:	4581                	li	a1,0
    80003b32:	854a                	mv	a0,s2
    80003b34:	00000097          	auipc	ra,0x0
    80003b38:	d72080e7          	jalr	-654(ra) # 800038a6 <readi>
    80003b3c:	47c1                	li	a5,16
    80003b3e:	fcf518e3          	bne	a0,a5,80003b0e <dirlookup+0x3a>
    if(de.inum == 0)
    80003b42:	fc045783          	lhu	a5,-64(s0)
    80003b46:	dfe1                	beqz	a5,80003b1e <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003b48:	fc240593          	add	a1,s0,-62
    80003b4c:	854e                	mv	a0,s3
    80003b4e:	00000097          	auipc	ra,0x0
    80003b52:	f6c080e7          	jalr	-148(ra) # 80003aba <namecmp>
    80003b56:	f561                	bnez	a0,80003b1e <dirlookup+0x4a>
      if(poff)
    80003b58:	000a0463          	beqz	s4,80003b60 <dirlookup+0x8c>
        *poff = off;
    80003b5c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003b60:	fc045583          	lhu	a1,-64(s0)
    80003b64:	00092503          	lw	a0,0(s2)
    80003b68:	fffff097          	auipc	ra,0xfffff
    80003b6c:	75a080e7          	jalr	1882(ra) # 800032c2 <iget>
    80003b70:	a011                	j	80003b74 <dirlookup+0xa0>
  return 0;
    80003b72:	4501                	li	a0,0
}
    80003b74:	70e2                	ld	ra,56(sp)
    80003b76:	7442                	ld	s0,48(sp)
    80003b78:	74a2                	ld	s1,40(sp)
    80003b7a:	7902                	ld	s2,32(sp)
    80003b7c:	69e2                	ld	s3,24(sp)
    80003b7e:	6a42                	ld	s4,16(sp)
    80003b80:	6121                	add	sp,sp,64
    80003b82:	8082                	ret

0000000080003b84 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003b84:	711d                	add	sp,sp,-96
    80003b86:	ec86                	sd	ra,88(sp)
    80003b88:	e8a2                	sd	s0,80(sp)
    80003b8a:	e4a6                	sd	s1,72(sp)
    80003b8c:	e0ca                	sd	s2,64(sp)
    80003b8e:	fc4e                	sd	s3,56(sp)
    80003b90:	f852                	sd	s4,48(sp)
    80003b92:	f456                	sd	s5,40(sp)
    80003b94:	f05a                	sd	s6,32(sp)
    80003b96:	ec5e                	sd	s7,24(sp)
    80003b98:	e862                	sd	s8,16(sp)
    80003b9a:	e466                	sd	s9,8(sp)
    80003b9c:	1080                	add	s0,sp,96
    80003b9e:	84aa                	mv	s1,a0
    80003ba0:	8b2e                	mv	s6,a1
    80003ba2:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003ba4:	00054703          	lbu	a4,0(a0)
    80003ba8:	02f00793          	li	a5,47
    80003bac:	02f70263          	beq	a4,a5,80003bd0 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003bb0:	ffffe097          	auipc	ra,0xffffe
    80003bb4:	e16080e7          	jalr	-490(ra) # 800019c6 <myproc>
    80003bb8:	15053503          	ld	a0,336(a0)
    80003bbc:	00000097          	auipc	ra,0x0
    80003bc0:	9f8080e7          	jalr	-1544(ra) # 800035b4 <idup>
    80003bc4:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003bc6:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003bca:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003bcc:	4b85                	li	s7,1
    80003bce:	a875                	j	80003c8a <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003bd0:	4585                	li	a1,1
    80003bd2:	4505                	li	a0,1
    80003bd4:	fffff097          	auipc	ra,0xfffff
    80003bd8:	6ee080e7          	jalr	1774(ra) # 800032c2 <iget>
    80003bdc:	8a2a                	mv	s4,a0
    80003bde:	b7e5                	j	80003bc6 <namex+0x42>
      iunlockput(ip);
    80003be0:	8552                	mv	a0,s4
    80003be2:	00000097          	auipc	ra,0x0
    80003be6:	c72080e7          	jalr	-910(ra) # 80003854 <iunlockput>
      return 0;
    80003bea:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003bec:	8552                	mv	a0,s4
    80003bee:	60e6                	ld	ra,88(sp)
    80003bf0:	6446                	ld	s0,80(sp)
    80003bf2:	64a6                	ld	s1,72(sp)
    80003bf4:	6906                	ld	s2,64(sp)
    80003bf6:	79e2                	ld	s3,56(sp)
    80003bf8:	7a42                	ld	s4,48(sp)
    80003bfa:	7aa2                	ld	s5,40(sp)
    80003bfc:	7b02                	ld	s6,32(sp)
    80003bfe:	6be2                	ld	s7,24(sp)
    80003c00:	6c42                	ld	s8,16(sp)
    80003c02:	6ca2                	ld	s9,8(sp)
    80003c04:	6125                	add	sp,sp,96
    80003c06:	8082                	ret
      iunlock(ip);
    80003c08:	8552                	mv	a0,s4
    80003c0a:	00000097          	auipc	ra,0x0
    80003c0e:	aaa080e7          	jalr	-1366(ra) # 800036b4 <iunlock>
      return ip;
    80003c12:	bfe9                	j	80003bec <namex+0x68>
      iunlockput(ip);
    80003c14:	8552                	mv	a0,s4
    80003c16:	00000097          	auipc	ra,0x0
    80003c1a:	c3e080e7          	jalr	-962(ra) # 80003854 <iunlockput>
      return 0;
    80003c1e:	8a4e                	mv	s4,s3
    80003c20:	b7f1                	j	80003bec <namex+0x68>
  len = path - s;
    80003c22:	40998633          	sub	a2,s3,s1
    80003c26:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003c2a:	099c5863          	bge	s8,s9,80003cba <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003c2e:	4639                	li	a2,14
    80003c30:	85a6                	mv	a1,s1
    80003c32:	8556                	mv	a0,s5
    80003c34:	ffffd097          	auipc	ra,0xffffd
    80003c38:	120080e7          	jalr	288(ra) # 80000d54 <memmove>
    80003c3c:	84ce                	mv	s1,s3
  while(*path == '/')
    80003c3e:	0004c783          	lbu	a5,0(s1)
    80003c42:	01279763          	bne	a5,s2,80003c50 <namex+0xcc>
    path++;
    80003c46:	0485                	add	s1,s1,1
  while(*path == '/')
    80003c48:	0004c783          	lbu	a5,0(s1)
    80003c4c:	ff278de3          	beq	a5,s2,80003c46 <namex+0xc2>
    ilock(ip);
    80003c50:	8552                	mv	a0,s4
    80003c52:	00000097          	auipc	ra,0x0
    80003c56:	9a0080e7          	jalr	-1632(ra) # 800035f2 <ilock>
    if(ip->type != T_DIR){
    80003c5a:	044a1783          	lh	a5,68(s4)
    80003c5e:	f97791e3          	bne	a5,s7,80003be0 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003c62:	000b0563          	beqz	s6,80003c6c <namex+0xe8>
    80003c66:	0004c783          	lbu	a5,0(s1)
    80003c6a:	dfd9                	beqz	a5,80003c08 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003c6c:	4601                	li	a2,0
    80003c6e:	85d6                	mv	a1,s5
    80003c70:	8552                	mv	a0,s4
    80003c72:	00000097          	auipc	ra,0x0
    80003c76:	e62080e7          	jalr	-414(ra) # 80003ad4 <dirlookup>
    80003c7a:	89aa                	mv	s3,a0
    80003c7c:	dd41                	beqz	a0,80003c14 <namex+0x90>
    iunlockput(ip);
    80003c7e:	8552                	mv	a0,s4
    80003c80:	00000097          	auipc	ra,0x0
    80003c84:	bd4080e7          	jalr	-1068(ra) # 80003854 <iunlockput>
    ip = next;
    80003c88:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003c8a:	0004c783          	lbu	a5,0(s1)
    80003c8e:	01279763          	bne	a5,s2,80003c9c <namex+0x118>
    path++;
    80003c92:	0485                	add	s1,s1,1
  while(*path == '/')
    80003c94:	0004c783          	lbu	a5,0(s1)
    80003c98:	ff278de3          	beq	a5,s2,80003c92 <namex+0x10e>
  if(*path == 0)
    80003c9c:	cb9d                	beqz	a5,80003cd2 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003c9e:	0004c783          	lbu	a5,0(s1)
    80003ca2:	89a6                	mv	s3,s1
  len = path - s;
    80003ca4:	4c81                	li	s9,0
    80003ca6:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003ca8:	01278963          	beq	a5,s2,80003cba <namex+0x136>
    80003cac:	dbbd                	beqz	a5,80003c22 <namex+0x9e>
    path++;
    80003cae:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80003cb0:	0009c783          	lbu	a5,0(s3)
    80003cb4:	ff279ce3          	bne	a5,s2,80003cac <namex+0x128>
    80003cb8:	b7ad                	j	80003c22 <namex+0x9e>
    memmove(name, s, len);
    80003cba:	2601                	sext.w	a2,a2
    80003cbc:	85a6                	mv	a1,s1
    80003cbe:	8556                	mv	a0,s5
    80003cc0:	ffffd097          	auipc	ra,0xffffd
    80003cc4:	094080e7          	jalr	148(ra) # 80000d54 <memmove>
    name[len] = 0;
    80003cc8:	9cd6                	add	s9,s9,s5
    80003cca:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003cce:	84ce                	mv	s1,s3
    80003cd0:	b7bd                	j	80003c3e <namex+0xba>
  if(nameiparent){
    80003cd2:	f00b0de3          	beqz	s6,80003bec <namex+0x68>
    iput(ip);
    80003cd6:	8552                	mv	a0,s4
    80003cd8:	00000097          	auipc	ra,0x0
    80003cdc:	ad4080e7          	jalr	-1324(ra) # 800037ac <iput>
    return 0;
    80003ce0:	4a01                	li	s4,0
    80003ce2:	b729                	j	80003bec <namex+0x68>

0000000080003ce4 <dirlink>:
{
    80003ce4:	7139                	add	sp,sp,-64
    80003ce6:	fc06                	sd	ra,56(sp)
    80003ce8:	f822                	sd	s0,48(sp)
    80003cea:	f426                	sd	s1,40(sp)
    80003cec:	f04a                	sd	s2,32(sp)
    80003cee:	ec4e                	sd	s3,24(sp)
    80003cf0:	e852                	sd	s4,16(sp)
    80003cf2:	0080                	add	s0,sp,64
    80003cf4:	892a                	mv	s2,a0
    80003cf6:	8a2e                	mv	s4,a1
    80003cf8:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003cfa:	4601                	li	a2,0
    80003cfc:	00000097          	auipc	ra,0x0
    80003d00:	dd8080e7          	jalr	-552(ra) # 80003ad4 <dirlookup>
    80003d04:	e93d                	bnez	a0,80003d7a <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d06:	04c92483          	lw	s1,76(s2)
    80003d0a:	c49d                	beqz	s1,80003d38 <dirlink+0x54>
    80003d0c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d0e:	4741                	li	a4,16
    80003d10:	86a6                	mv	a3,s1
    80003d12:	fc040613          	add	a2,s0,-64
    80003d16:	4581                	li	a1,0
    80003d18:	854a                	mv	a0,s2
    80003d1a:	00000097          	auipc	ra,0x0
    80003d1e:	b8c080e7          	jalr	-1140(ra) # 800038a6 <readi>
    80003d22:	47c1                	li	a5,16
    80003d24:	06f51163          	bne	a0,a5,80003d86 <dirlink+0xa2>
    if(de.inum == 0)
    80003d28:	fc045783          	lhu	a5,-64(s0)
    80003d2c:	c791                	beqz	a5,80003d38 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d2e:	24c1                	addw	s1,s1,16
    80003d30:	04c92783          	lw	a5,76(s2)
    80003d34:	fcf4ede3          	bltu	s1,a5,80003d0e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003d38:	4639                	li	a2,14
    80003d3a:	85d2                	mv	a1,s4
    80003d3c:	fc240513          	add	a0,s0,-62
    80003d40:	ffffd097          	auipc	ra,0xffffd
    80003d44:	0cc080e7          	jalr	204(ra) # 80000e0c <strncpy>
  de.inum = inum;
    80003d48:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d4c:	4741                	li	a4,16
    80003d4e:	86a6                	mv	a3,s1
    80003d50:	fc040613          	add	a2,s0,-64
    80003d54:	4581                	li	a1,0
    80003d56:	854a                	mv	a0,s2
    80003d58:	00000097          	auipc	ra,0x0
    80003d5c:	c46080e7          	jalr	-954(ra) # 8000399e <writei>
    80003d60:	872a                	mv	a4,a0
    80003d62:	47c1                	li	a5,16
  return 0;
    80003d64:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d66:	02f71863          	bne	a4,a5,80003d96 <dirlink+0xb2>
}
    80003d6a:	70e2                	ld	ra,56(sp)
    80003d6c:	7442                	ld	s0,48(sp)
    80003d6e:	74a2                	ld	s1,40(sp)
    80003d70:	7902                	ld	s2,32(sp)
    80003d72:	69e2                	ld	s3,24(sp)
    80003d74:	6a42                	ld	s4,16(sp)
    80003d76:	6121                	add	sp,sp,64
    80003d78:	8082                	ret
    iput(ip);
    80003d7a:	00000097          	auipc	ra,0x0
    80003d7e:	a32080e7          	jalr	-1486(ra) # 800037ac <iput>
    return -1;
    80003d82:	557d                	li	a0,-1
    80003d84:	b7dd                	j	80003d6a <dirlink+0x86>
      panic("dirlink read");
    80003d86:	00005517          	auipc	a0,0x5
    80003d8a:	86a50513          	add	a0,a0,-1942 # 800085f0 <syscalls+0x1c8>
    80003d8e:	ffffc097          	auipc	ra,0xffffc
    80003d92:	7b4080e7          	jalr	1972(ra) # 80000542 <panic>
    panic("dirlink");
    80003d96:	00005517          	auipc	a0,0x5
    80003d9a:	97a50513          	add	a0,a0,-1670 # 80008710 <syscalls+0x2e8>
    80003d9e:	ffffc097          	auipc	ra,0xffffc
    80003da2:	7a4080e7          	jalr	1956(ra) # 80000542 <panic>

0000000080003da6 <namei>:

struct inode*
namei(char *path)
{
    80003da6:	1101                	add	sp,sp,-32
    80003da8:	ec06                	sd	ra,24(sp)
    80003daa:	e822                	sd	s0,16(sp)
    80003dac:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003dae:	fe040613          	add	a2,s0,-32
    80003db2:	4581                	li	a1,0
    80003db4:	00000097          	auipc	ra,0x0
    80003db8:	dd0080e7          	jalr	-560(ra) # 80003b84 <namex>
}
    80003dbc:	60e2                	ld	ra,24(sp)
    80003dbe:	6442                	ld	s0,16(sp)
    80003dc0:	6105                	add	sp,sp,32
    80003dc2:	8082                	ret

0000000080003dc4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003dc4:	1141                	add	sp,sp,-16
    80003dc6:	e406                	sd	ra,8(sp)
    80003dc8:	e022                	sd	s0,0(sp)
    80003dca:	0800                	add	s0,sp,16
    80003dcc:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003dce:	4585                	li	a1,1
    80003dd0:	00000097          	auipc	ra,0x0
    80003dd4:	db4080e7          	jalr	-588(ra) # 80003b84 <namex>
}
    80003dd8:	60a2                	ld	ra,8(sp)
    80003dda:	6402                	ld	s0,0(sp)
    80003ddc:	0141                	add	sp,sp,16
    80003dde:	8082                	ret

0000000080003de0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003de0:	1101                	add	sp,sp,-32
    80003de2:	ec06                	sd	ra,24(sp)
    80003de4:	e822                	sd	s0,16(sp)
    80003de6:	e426                	sd	s1,8(sp)
    80003de8:	e04a                	sd	s2,0(sp)
    80003dea:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003dec:	0001e917          	auipc	s2,0x1e
    80003df0:	b1c90913          	add	s2,s2,-1252 # 80021908 <log>
    80003df4:	01892583          	lw	a1,24(s2)
    80003df8:	02892503          	lw	a0,40(s2)
    80003dfc:	fffff097          	auipc	ra,0xfffff
    80003e00:	ffc080e7          	jalr	-4(ra) # 80002df8 <bread>
    80003e04:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003e06:	02c92603          	lw	a2,44(s2)
    80003e0a:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003e0c:	00c05f63          	blez	a2,80003e2a <write_head+0x4a>
    80003e10:	0001e717          	auipc	a4,0x1e
    80003e14:	b2870713          	add	a4,a4,-1240 # 80021938 <log+0x30>
    80003e18:	87aa                	mv	a5,a0
    80003e1a:	060a                	sll	a2,a2,0x2
    80003e1c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003e1e:	4314                	lw	a3,0(a4)
    80003e20:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003e22:	0711                	add	a4,a4,4
    80003e24:	0791                	add	a5,a5,4
    80003e26:	fec79ce3          	bne	a5,a2,80003e1e <write_head+0x3e>
  }
  bwrite(buf);
    80003e2a:	8526                	mv	a0,s1
    80003e2c:	fffff097          	auipc	ra,0xfffff
    80003e30:	0be080e7          	jalr	190(ra) # 80002eea <bwrite>
  brelse(buf);
    80003e34:	8526                	mv	a0,s1
    80003e36:	fffff097          	auipc	ra,0xfffff
    80003e3a:	0f2080e7          	jalr	242(ra) # 80002f28 <brelse>
}
    80003e3e:	60e2                	ld	ra,24(sp)
    80003e40:	6442                	ld	s0,16(sp)
    80003e42:	64a2                	ld	s1,8(sp)
    80003e44:	6902                	ld	s2,0(sp)
    80003e46:	6105                	add	sp,sp,32
    80003e48:	8082                	ret

0000000080003e4a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e4a:	0001e797          	auipc	a5,0x1e
    80003e4e:	aea7a783          	lw	a5,-1302(a5) # 80021934 <log+0x2c>
    80003e52:	0af05663          	blez	a5,80003efe <install_trans+0xb4>
{
    80003e56:	7139                	add	sp,sp,-64
    80003e58:	fc06                	sd	ra,56(sp)
    80003e5a:	f822                	sd	s0,48(sp)
    80003e5c:	f426                	sd	s1,40(sp)
    80003e5e:	f04a                	sd	s2,32(sp)
    80003e60:	ec4e                	sd	s3,24(sp)
    80003e62:	e852                	sd	s4,16(sp)
    80003e64:	e456                	sd	s5,8(sp)
    80003e66:	0080                	add	s0,sp,64
    80003e68:	0001ea97          	auipc	s5,0x1e
    80003e6c:	ad0a8a93          	add	s5,s5,-1328 # 80021938 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e70:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003e72:	0001e997          	auipc	s3,0x1e
    80003e76:	a9698993          	add	s3,s3,-1386 # 80021908 <log>
    80003e7a:	0189a583          	lw	a1,24(s3)
    80003e7e:	014585bb          	addw	a1,a1,s4
    80003e82:	2585                	addw	a1,a1,1
    80003e84:	0289a503          	lw	a0,40(s3)
    80003e88:	fffff097          	auipc	ra,0xfffff
    80003e8c:	f70080e7          	jalr	-144(ra) # 80002df8 <bread>
    80003e90:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003e92:	000aa583          	lw	a1,0(s5)
    80003e96:	0289a503          	lw	a0,40(s3)
    80003e9a:	fffff097          	auipc	ra,0xfffff
    80003e9e:	f5e080e7          	jalr	-162(ra) # 80002df8 <bread>
    80003ea2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003ea4:	40000613          	li	a2,1024
    80003ea8:	05890593          	add	a1,s2,88
    80003eac:	05850513          	add	a0,a0,88
    80003eb0:	ffffd097          	auipc	ra,0xffffd
    80003eb4:	ea4080e7          	jalr	-348(ra) # 80000d54 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003eb8:	8526                	mv	a0,s1
    80003eba:	fffff097          	auipc	ra,0xfffff
    80003ebe:	030080e7          	jalr	48(ra) # 80002eea <bwrite>
    bunpin(dbuf);
    80003ec2:	8526                	mv	a0,s1
    80003ec4:	fffff097          	auipc	ra,0xfffff
    80003ec8:	13c080e7          	jalr	316(ra) # 80003000 <bunpin>
    brelse(lbuf);
    80003ecc:	854a                	mv	a0,s2
    80003ece:	fffff097          	auipc	ra,0xfffff
    80003ed2:	05a080e7          	jalr	90(ra) # 80002f28 <brelse>
    brelse(dbuf);
    80003ed6:	8526                	mv	a0,s1
    80003ed8:	fffff097          	auipc	ra,0xfffff
    80003edc:	050080e7          	jalr	80(ra) # 80002f28 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ee0:	2a05                	addw	s4,s4,1
    80003ee2:	0a91                	add	s5,s5,4
    80003ee4:	02c9a783          	lw	a5,44(s3)
    80003ee8:	f8fa49e3          	blt	s4,a5,80003e7a <install_trans+0x30>
}
    80003eec:	70e2                	ld	ra,56(sp)
    80003eee:	7442                	ld	s0,48(sp)
    80003ef0:	74a2                	ld	s1,40(sp)
    80003ef2:	7902                	ld	s2,32(sp)
    80003ef4:	69e2                	ld	s3,24(sp)
    80003ef6:	6a42                	ld	s4,16(sp)
    80003ef8:	6aa2                	ld	s5,8(sp)
    80003efa:	6121                	add	sp,sp,64
    80003efc:	8082                	ret
    80003efe:	8082                	ret

0000000080003f00 <initlog>:
{
    80003f00:	7179                	add	sp,sp,-48
    80003f02:	f406                	sd	ra,40(sp)
    80003f04:	f022                	sd	s0,32(sp)
    80003f06:	ec26                	sd	s1,24(sp)
    80003f08:	e84a                	sd	s2,16(sp)
    80003f0a:	e44e                	sd	s3,8(sp)
    80003f0c:	1800                	add	s0,sp,48
    80003f0e:	892a                	mv	s2,a0
    80003f10:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003f12:	0001e497          	auipc	s1,0x1e
    80003f16:	9f648493          	add	s1,s1,-1546 # 80021908 <log>
    80003f1a:	00004597          	auipc	a1,0x4
    80003f1e:	6e658593          	add	a1,a1,1766 # 80008600 <syscalls+0x1d8>
    80003f22:	8526                	mv	a0,s1
    80003f24:	ffffd097          	auipc	ra,0xffffd
    80003f28:	c48080e7          	jalr	-952(ra) # 80000b6c <initlock>
  log.start = sb->logstart;
    80003f2c:	0149a583          	lw	a1,20(s3)
    80003f30:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003f32:	0109a783          	lw	a5,16(s3)
    80003f36:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003f38:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003f3c:	854a                	mv	a0,s2
    80003f3e:	fffff097          	auipc	ra,0xfffff
    80003f42:	eba080e7          	jalr	-326(ra) # 80002df8 <bread>
  log.lh.n = lh->n;
    80003f46:	4d30                	lw	a2,88(a0)
    80003f48:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003f4a:	00c05f63          	blez	a2,80003f68 <initlog+0x68>
    80003f4e:	87aa                	mv	a5,a0
    80003f50:	0001e717          	auipc	a4,0x1e
    80003f54:	9e870713          	add	a4,a4,-1560 # 80021938 <log+0x30>
    80003f58:	060a                	sll	a2,a2,0x2
    80003f5a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003f5c:	4ff4                	lw	a3,92(a5)
    80003f5e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003f60:	0791                	add	a5,a5,4
    80003f62:	0711                	add	a4,a4,4
    80003f64:	fec79ce3          	bne	a5,a2,80003f5c <initlog+0x5c>
  brelse(buf);
    80003f68:	fffff097          	auipc	ra,0xfffff
    80003f6c:	fc0080e7          	jalr	-64(ra) # 80002f28 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    80003f70:	00000097          	auipc	ra,0x0
    80003f74:	eda080e7          	jalr	-294(ra) # 80003e4a <install_trans>
  log.lh.n = 0;
    80003f78:	0001e797          	auipc	a5,0x1e
    80003f7c:	9a07ae23          	sw	zero,-1604(a5) # 80021934 <log+0x2c>
  write_head(); // clear the log
    80003f80:	00000097          	auipc	ra,0x0
    80003f84:	e60080e7          	jalr	-416(ra) # 80003de0 <write_head>
}
    80003f88:	70a2                	ld	ra,40(sp)
    80003f8a:	7402                	ld	s0,32(sp)
    80003f8c:	64e2                	ld	s1,24(sp)
    80003f8e:	6942                	ld	s2,16(sp)
    80003f90:	69a2                	ld	s3,8(sp)
    80003f92:	6145                	add	sp,sp,48
    80003f94:	8082                	ret

0000000080003f96 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003f96:	1101                	add	sp,sp,-32
    80003f98:	ec06                	sd	ra,24(sp)
    80003f9a:	e822                	sd	s0,16(sp)
    80003f9c:	e426                	sd	s1,8(sp)
    80003f9e:	e04a                	sd	s2,0(sp)
    80003fa0:	1000                	add	s0,sp,32
  acquire(&log.lock);
    80003fa2:	0001e517          	auipc	a0,0x1e
    80003fa6:	96650513          	add	a0,a0,-1690 # 80021908 <log>
    80003faa:	ffffd097          	auipc	ra,0xffffd
    80003fae:	c52080e7          	jalr	-942(ra) # 80000bfc <acquire>
  while(1){
    if(log.committing){
    80003fb2:	0001e497          	auipc	s1,0x1e
    80003fb6:	95648493          	add	s1,s1,-1706 # 80021908 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003fba:	4979                	li	s2,30
    80003fbc:	a039                	j	80003fca <begin_op+0x34>
      sleep(&log, &log.lock);
    80003fbe:	85a6                	mv	a1,s1
    80003fc0:	8526                	mv	a0,s1
    80003fc2:	ffffe097          	auipc	ra,0xffffe
    80003fc6:	21a080e7          	jalr	538(ra) # 800021dc <sleep>
    if(log.committing){
    80003fca:	50dc                	lw	a5,36(s1)
    80003fcc:	fbed                	bnez	a5,80003fbe <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003fce:	5098                	lw	a4,32(s1)
    80003fd0:	2705                	addw	a4,a4,1
    80003fd2:	0027179b          	sllw	a5,a4,0x2
    80003fd6:	9fb9                	addw	a5,a5,a4
    80003fd8:	0017979b          	sllw	a5,a5,0x1
    80003fdc:	54d4                	lw	a3,44(s1)
    80003fde:	9fb5                	addw	a5,a5,a3
    80003fe0:	00f95963          	bge	s2,a5,80003ff2 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003fe4:	85a6                	mv	a1,s1
    80003fe6:	8526                	mv	a0,s1
    80003fe8:	ffffe097          	auipc	ra,0xffffe
    80003fec:	1f4080e7          	jalr	500(ra) # 800021dc <sleep>
    80003ff0:	bfe9                	j	80003fca <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003ff2:	0001e517          	auipc	a0,0x1e
    80003ff6:	91650513          	add	a0,a0,-1770 # 80021908 <log>
    80003ffa:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003ffc:	ffffd097          	auipc	ra,0xffffd
    80004000:	cb4080e7          	jalr	-844(ra) # 80000cb0 <release>
      break;
    }
  }
}
    80004004:	60e2                	ld	ra,24(sp)
    80004006:	6442                	ld	s0,16(sp)
    80004008:	64a2                	ld	s1,8(sp)
    8000400a:	6902                	ld	s2,0(sp)
    8000400c:	6105                	add	sp,sp,32
    8000400e:	8082                	ret

0000000080004010 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004010:	7139                	add	sp,sp,-64
    80004012:	fc06                	sd	ra,56(sp)
    80004014:	f822                	sd	s0,48(sp)
    80004016:	f426                	sd	s1,40(sp)
    80004018:	f04a                	sd	s2,32(sp)
    8000401a:	ec4e                	sd	s3,24(sp)
    8000401c:	e852                	sd	s4,16(sp)
    8000401e:	e456                	sd	s5,8(sp)
    80004020:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004022:	0001e497          	auipc	s1,0x1e
    80004026:	8e648493          	add	s1,s1,-1818 # 80021908 <log>
    8000402a:	8526                	mv	a0,s1
    8000402c:	ffffd097          	auipc	ra,0xffffd
    80004030:	bd0080e7          	jalr	-1072(ra) # 80000bfc <acquire>
  log.outstanding -= 1;
    80004034:	509c                	lw	a5,32(s1)
    80004036:	37fd                	addw	a5,a5,-1
    80004038:	0007891b          	sext.w	s2,a5
    8000403c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000403e:	50dc                	lw	a5,36(s1)
    80004040:	e7b9                	bnez	a5,8000408e <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004042:	04091e63          	bnez	s2,8000409e <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004046:	0001e497          	auipc	s1,0x1e
    8000404a:	8c248493          	add	s1,s1,-1854 # 80021908 <log>
    8000404e:	4785                	li	a5,1
    80004050:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004052:	8526                	mv	a0,s1
    80004054:	ffffd097          	auipc	ra,0xffffd
    80004058:	c5c080e7          	jalr	-932(ra) # 80000cb0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000405c:	54dc                	lw	a5,44(s1)
    8000405e:	06f04763          	bgtz	a5,800040cc <end_op+0xbc>
    acquire(&log.lock);
    80004062:	0001e497          	auipc	s1,0x1e
    80004066:	8a648493          	add	s1,s1,-1882 # 80021908 <log>
    8000406a:	8526                	mv	a0,s1
    8000406c:	ffffd097          	auipc	ra,0xffffd
    80004070:	b90080e7          	jalr	-1136(ra) # 80000bfc <acquire>
    log.committing = 0;
    80004074:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004078:	8526                	mv	a0,s1
    8000407a:	ffffe097          	auipc	ra,0xffffe
    8000407e:	2e2080e7          	jalr	738(ra) # 8000235c <wakeup>
    release(&log.lock);
    80004082:	8526                	mv	a0,s1
    80004084:	ffffd097          	auipc	ra,0xffffd
    80004088:	c2c080e7          	jalr	-980(ra) # 80000cb0 <release>
}
    8000408c:	a03d                	j	800040ba <end_op+0xaa>
    panic("log.committing");
    8000408e:	00004517          	auipc	a0,0x4
    80004092:	57a50513          	add	a0,a0,1402 # 80008608 <syscalls+0x1e0>
    80004096:	ffffc097          	auipc	ra,0xffffc
    8000409a:	4ac080e7          	jalr	1196(ra) # 80000542 <panic>
    wakeup(&log);
    8000409e:	0001e497          	auipc	s1,0x1e
    800040a2:	86a48493          	add	s1,s1,-1942 # 80021908 <log>
    800040a6:	8526                	mv	a0,s1
    800040a8:	ffffe097          	auipc	ra,0xffffe
    800040ac:	2b4080e7          	jalr	692(ra) # 8000235c <wakeup>
  release(&log.lock);
    800040b0:	8526                	mv	a0,s1
    800040b2:	ffffd097          	auipc	ra,0xffffd
    800040b6:	bfe080e7          	jalr	-1026(ra) # 80000cb0 <release>
}
    800040ba:	70e2                	ld	ra,56(sp)
    800040bc:	7442                	ld	s0,48(sp)
    800040be:	74a2                	ld	s1,40(sp)
    800040c0:	7902                	ld	s2,32(sp)
    800040c2:	69e2                	ld	s3,24(sp)
    800040c4:	6a42                	ld	s4,16(sp)
    800040c6:	6aa2                	ld	s5,8(sp)
    800040c8:	6121                	add	sp,sp,64
    800040ca:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800040cc:	0001ea97          	auipc	s5,0x1e
    800040d0:	86ca8a93          	add	s5,s5,-1940 # 80021938 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800040d4:	0001ea17          	auipc	s4,0x1e
    800040d8:	834a0a13          	add	s4,s4,-1996 # 80021908 <log>
    800040dc:	018a2583          	lw	a1,24(s4)
    800040e0:	012585bb          	addw	a1,a1,s2
    800040e4:	2585                	addw	a1,a1,1
    800040e6:	028a2503          	lw	a0,40(s4)
    800040ea:	fffff097          	auipc	ra,0xfffff
    800040ee:	d0e080e7          	jalr	-754(ra) # 80002df8 <bread>
    800040f2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800040f4:	000aa583          	lw	a1,0(s5)
    800040f8:	028a2503          	lw	a0,40(s4)
    800040fc:	fffff097          	auipc	ra,0xfffff
    80004100:	cfc080e7          	jalr	-772(ra) # 80002df8 <bread>
    80004104:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004106:	40000613          	li	a2,1024
    8000410a:	05850593          	add	a1,a0,88
    8000410e:	05848513          	add	a0,s1,88
    80004112:	ffffd097          	auipc	ra,0xffffd
    80004116:	c42080e7          	jalr	-958(ra) # 80000d54 <memmove>
    bwrite(to);  // write the log
    8000411a:	8526                	mv	a0,s1
    8000411c:	fffff097          	auipc	ra,0xfffff
    80004120:	dce080e7          	jalr	-562(ra) # 80002eea <bwrite>
    brelse(from);
    80004124:	854e                	mv	a0,s3
    80004126:	fffff097          	auipc	ra,0xfffff
    8000412a:	e02080e7          	jalr	-510(ra) # 80002f28 <brelse>
    brelse(to);
    8000412e:	8526                	mv	a0,s1
    80004130:	fffff097          	auipc	ra,0xfffff
    80004134:	df8080e7          	jalr	-520(ra) # 80002f28 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004138:	2905                	addw	s2,s2,1
    8000413a:	0a91                	add	s5,s5,4
    8000413c:	02ca2783          	lw	a5,44(s4)
    80004140:	f8f94ee3          	blt	s2,a5,800040dc <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004144:	00000097          	auipc	ra,0x0
    80004148:	c9c080e7          	jalr	-868(ra) # 80003de0 <write_head>
    install_trans(); // Now install writes to home locations
    8000414c:	00000097          	auipc	ra,0x0
    80004150:	cfe080e7          	jalr	-770(ra) # 80003e4a <install_trans>
    log.lh.n = 0;
    80004154:	0001d797          	auipc	a5,0x1d
    80004158:	7e07a023          	sw	zero,2016(a5) # 80021934 <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000415c:	00000097          	auipc	ra,0x0
    80004160:	c84080e7          	jalr	-892(ra) # 80003de0 <write_head>
    80004164:	bdfd                	j	80004062 <end_op+0x52>

0000000080004166 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004166:	1101                	add	sp,sp,-32
    80004168:	ec06                	sd	ra,24(sp)
    8000416a:	e822                	sd	s0,16(sp)
    8000416c:	e426                	sd	s1,8(sp)
    8000416e:	e04a                	sd	s2,0(sp)
    80004170:	1000                	add	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004172:	0001d717          	auipc	a4,0x1d
    80004176:	7c272703          	lw	a4,1986(a4) # 80021934 <log+0x2c>
    8000417a:	47f5                	li	a5,29
    8000417c:	08e7c063          	blt	a5,a4,800041fc <log_write+0x96>
    80004180:	84aa                	mv	s1,a0
    80004182:	0001d797          	auipc	a5,0x1d
    80004186:	7a27a783          	lw	a5,1954(a5) # 80021924 <log+0x1c>
    8000418a:	37fd                	addw	a5,a5,-1
    8000418c:	06f75863          	bge	a4,a5,800041fc <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004190:	0001d797          	auipc	a5,0x1d
    80004194:	7987a783          	lw	a5,1944(a5) # 80021928 <log+0x20>
    80004198:	06f05a63          	blez	a5,8000420c <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    8000419c:	0001d917          	auipc	s2,0x1d
    800041a0:	76c90913          	add	s2,s2,1900 # 80021908 <log>
    800041a4:	854a                	mv	a0,s2
    800041a6:	ffffd097          	auipc	ra,0xffffd
    800041aa:	a56080e7          	jalr	-1450(ra) # 80000bfc <acquire>
  for (i = 0; i < log.lh.n; i++) {
    800041ae:	02c92603          	lw	a2,44(s2)
    800041b2:	06c05563          	blez	a2,8000421c <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800041b6:	44cc                	lw	a1,12(s1)
    800041b8:	0001d717          	auipc	a4,0x1d
    800041bc:	78070713          	add	a4,a4,1920 # 80021938 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800041c0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800041c2:	4314                	lw	a3,0(a4)
    800041c4:	04b68d63          	beq	a3,a1,8000421e <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    800041c8:	2785                	addw	a5,a5,1
    800041ca:	0711                	add	a4,a4,4
    800041cc:	fec79be3          	bne	a5,a2,800041c2 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    800041d0:	0621                	add	a2,a2,8
    800041d2:	060a                	sll	a2,a2,0x2
    800041d4:	0001d797          	auipc	a5,0x1d
    800041d8:	73478793          	add	a5,a5,1844 # 80021908 <log>
    800041dc:	97b2                	add	a5,a5,a2
    800041de:	44d8                	lw	a4,12(s1)
    800041e0:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800041e2:	8526                	mv	a0,s1
    800041e4:	fffff097          	auipc	ra,0xfffff
    800041e8:	de0080e7          	jalr	-544(ra) # 80002fc4 <bpin>
    log.lh.n++;
    800041ec:	0001d717          	auipc	a4,0x1d
    800041f0:	71c70713          	add	a4,a4,1820 # 80021908 <log>
    800041f4:	575c                	lw	a5,44(a4)
    800041f6:	2785                	addw	a5,a5,1
    800041f8:	d75c                	sw	a5,44(a4)
    800041fa:	a835                	j	80004236 <log_write+0xd0>
    panic("too big a transaction");
    800041fc:	00004517          	auipc	a0,0x4
    80004200:	41c50513          	add	a0,a0,1052 # 80008618 <syscalls+0x1f0>
    80004204:	ffffc097          	auipc	ra,0xffffc
    80004208:	33e080e7          	jalr	830(ra) # 80000542 <panic>
    panic("log_write outside of trans");
    8000420c:	00004517          	auipc	a0,0x4
    80004210:	42450513          	add	a0,a0,1060 # 80008630 <syscalls+0x208>
    80004214:	ffffc097          	auipc	ra,0xffffc
    80004218:	32e080e7          	jalr	814(ra) # 80000542 <panic>
  for (i = 0; i < log.lh.n; i++) {
    8000421c:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    8000421e:	00878693          	add	a3,a5,8
    80004222:	068a                	sll	a3,a3,0x2
    80004224:	0001d717          	auipc	a4,0x1d
    80004228:	6e470713          	add	a4,a4,1764 # 80021908 <log>
    8000422c:	9736                	add	a4,a4,a3
    8000422e:	44d4                	lw	a3,12(s1)
    80004230:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004232:	faf608e3          	beq	a2,a5,800041e2 <log_write+0x7c>
  }
  release(&log.lock);
    80004236:	0001d517          	auipc	a0,0x1d
    8000423a:	6d250513          	add	a0,a0,1746 # 80021908 <log>
    8000423e:	ffffd097          	auipc	ra,0xffffd
    80004242:	a72080e7          	jalr	-1422(ra) # 80000cb0 <release>
}
    80004246:	60e2                	ld	ra,24(sp)
    80004248:	6442                	ld	s0,16(sp)
    8000424a:	64a2                	ld	s1,8(sp)
    8000424c:	6902                	ld	s2,0(sp)
    8000424e:	6105                	add	sp,sp,32
    80004250:	8082                	ret

0000000080004252 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004252:	1101                	add	sp,sp,-32
    80004254:	ec06                	sd	ra,24(sp)
    80004256:	e822                	sd	s0,16(sp)
    80004258:	e426                	sd	s1,8(sp)
    8000425a:	e04a                	sd	s2,0(sp)
    8000425c:	1000                	add	s0,sp,32
    8000425e:	84aa                	mv	s1,a0
    80004260:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004262:	00004597          	auipc	a1,0x4
    80004266:	3ee58593          	add	a1,a1,1006 # 80008650 <syscalls+0x228>
    8000426a:	0521                	add	a0,a0,8
    8000426c:	ffffd097          	auipc	ra,0xffffd
    80004270:	900080e7          	jalr	-1792(ra) # 80000b6c <initlock>
  lk->name = name;
    80004274:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004278:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000427c:	0204a423          	sw	zero,40(s1)
}
    80004280:	60e2                	ld	ra,24(sp)
    80004282:	6442                	ld	s0,16(sp)
    80004284:	64a2                	ld	s1,8(sp)
    80004286:	6902                	ld	s2,0(sp)
    80004288:	6105                	add	sp,sp,32
    8000428a:	8082                	ret

000000008000428c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000428c:	1101                	add	sp,sp,-32
    8000428e:	ec06                	sd	ra,24(sp)
    80004290:	e822                	sd	s0,16(sp)
    80004292:	e426                	sd	s1,8(sp)
    80004294:	e04a                	sd	s2,0(sp)
    80004296:	1000                	add	s0,sp,32
    80004298:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000429a:	00850913          	add	s2,a0,8
    8000429e:	854a                	mv	a0,s2
    800042a0:	ffffd097          	auipc	ra,0xffffd
    800042a4:	95c080e7          	jalr	-1700(ra) # 80000bfc <acquire>
  while (lk->locked) {
    800042a8:	409c                	lw	a5,0(s1)
    800042aa:	cb89                	beqz	a5,800042bc <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800042ac:	85ca                	mv	a1,s2
    800042ae:	8526                	mv	a0,s1
    800042b0:	ffffe097          	auipc	ra,0xffffe
    800042b4:	f2c080e7          	jalr	-212(ra) # 800021dc <sleep>
  while (lk->locked) {
    800042b8:	409c                	lw	a5,0(s1)
    800042ba:	fbed                	bnez	a5,800042ac <acquiresleep+0x20>
  }
  lk->locked = 1;
    800042bc:	4785                	li	a5,1
    800042be:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800042c0:	ffffd097          	auipc	ra,0xffffd
    800042c4:	706080e7          	jalr	1798(ra) # 800019c6 <myproc>
    800042c8:	5d1c                	lw	a5,56(a0)
    800042ca:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800042cc:	854a                	mv	a0,s2
    800042ce:	ffffd097          	auipc	ra,0xffffd
    800042d2:	9e2080e7          	jalr	-1566(ra) # 80000cb0 <release>
}
    800042d6:	60e2                	ld	ra,24(sp)
    800042d8:	6442                	ld	s0,16(sp)
    800042da:	64a2                	ld	s1,8(sp)
    800042dc:	6902                	ld	s2,0(sp)
    800042de:	6105                	add	sp,sp,32
    800042e0:	8082                	ret

00000000800042e2 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800042e2:	1101                	add	sp,sp,-32
    800042e4:	ec06                	sd	ra,24(sp)
    800042e6:	e822                	sd	s0,16(sp)
    800042e8:	e426                	sd	s1,8(sp)
    800042ea:	e04a                	sd	s2,0(sp)
    800042ec:	1000                	add	s0,sp,32
    800042ee:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800042f0:	00850913          	add	s2,a0,8
    800042f4:	854a                	mv	a0,s2
    800042f6:	ffffd097          	auipc	ra,0xffffd
    800042fa:	906080e7          	jalr	-1786(ra) # 80000bfc <acquire>
  lk->locked = 0;
    800042fe:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004302:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004306:	8526                	mv	a0,s1
    80004308:	ffffe097          	auipc	ra,0xffffe
    8000430c:	054080e7          	jalr	84(ra) # 8000235c <wakeup>
  release(&lk->lk);
    80004310:	854a                	mv	a0,s2
    80004312:	ffffd097          	auipc	ra,0xffffd
    80004316:	99e080e7          	jalr	-1634(ra) # 80000cb0 <release>
}
    8000431a:	60e2                	ld	ra,24(sp)
    8000431c:	6442                	ld	s0,16(sp)
    8000431e:	64a2                	ld	s1,8(sp)
    80004320:	6902                	ld	s2,0(sp)
    80004322:	6105                	add	sp,sp,32
    80004324:	8082                	ret

0000000080004326 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004326:	7179                	add	sp,sp,-48
    80004328:	f406                	sd	ra,40(sp)
    8000432a:	f022                	sd	s0,32(sp)
    8000432c:	ec26                	sd	s1,24(sp)
    8000432e:	e84a                	sd	s2,16(sp)
    80004330:	e44e                	sd	s3,8(sp)
    80004332:	1800                	add	s0,sp,48
    80004334:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004336:	00850913          	add	s2,a0,8
    8000433a:	854a                	mv	a0,s2
    8000433c:	ffffd097          	auipc	ra,0xffffd
    80004340:	8c0080e7          	jalr	-1856(ra) # 80000bfc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004344:	409c                	lw	a5,0(s1)
    80004346:	ef99                	bnez	a5,80004364 <holdingsleep+0x3e>
    80004348:	4481                	li	s1,0
  release(&lk->lk);
    8000434a:	854a                	mv	a0,s2
    8000434c:	ffffd097          	auipc	ra,0xffffd
    80004350:	964080e7          	jalr	-1692(ra) # 80000cb0 <release>
  return r;
}
    80004354:	8526                	mv	a0,s1
    80004356:	70a2                	ld	ra,40(sp)
    80004358:	7402                	ld	s0,32(sp)
    8000435a:	64e2                	ld	s1,24(sp)
    8000435c:	6942                	ld	s2,16(sp)
    8000435e:	69a2                	ld	s3,8(sp)
    80004360:	6145                	add	sp,sp,48
    80004362:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004364:	0284a983          	lw	s3,40(s1)
    80004368:	ffffd097          	auipc	ra,0xffffd
    8000436c:	65e080e7          	jalr	1630(ra) # 800019c6 <myproc>
    80004370:	5d04                	lw	s1,56(a0)
    80004372:	413484b3          	sub	s1,s1,s3
    80004376:	0014b493          	seqz	s1,s1
    8000437a:	bfc1                	j	8000434a <holdingsleep+0x24>

000000008000437c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000437c:	1141                	add	sp,sp,-16
    8000437e:	e406                	sd	ra,8(sp)
    80004380:	e022                	sd	s0,0(sp)
    80004382:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004384:	00004597          	auipc	a1,0x4
    80004388:	2dc58593          	add	a1,a1,732 # 80008660 <syscalls+0x238>
    8000438c:	0001d517          	auipc	a0,0x1d
    80004390:	6c450513          	add	a0,a0,1732 # 80021a50 <ftable>
    80004394:	ffffc097          	auipc	ra,0xffffc
    80004398:	7d8080e7          	jalr	2008(ra) # 80000b6c <initlock>
}
    8000439c:	60a2                	ld	ra,8(sp)
    8000439e:	6402                	ld	s0,0(sp)
    800043a0:	0141                	add	sp,sp,16
    800043a2:	8082                	ret

00000000800043a4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800043a4:	1101                	add	sp,sp,-32
    800043a6:	ec06                	sd	ra,24(sp)
    800043a8:	e822                	sd	s0,16(sp)
    800043aa:	e426                	sd	s1,8(sp)
    800043ac:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800043ae:	0001d517          	auipc	a0,0x1d
    800043b2:	6a250513          	add	a0,a0,1698 # 80021a50 <ftable>
    800043b6:	ffffd097          	auipc	ra,0xffffd
    800043ba:	846080e7          	jalr	-1978(ra) # 80000bfc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800043be:	0001d497          	auipc	s1,0x1d
    800043c2:	6aa48493          	add	s1,s1,1706 # 80021a68 <ftable+0x18>
    800043c6:	0001e717          	auipc	a4,0x1e
    800043ca:	64270713          	add	a4,a4,1602 # 80022a08 <ftable+0xfb8>
    if(f->ref == 0){
    800043ce:	40dc                	lw	a5,4(s1)
    800043d0:	cf99                	beqz	a5,800043ee <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800043d2:	02848493          	add	s1,s1,40
    800043d6:	fee49ce3          	bne	s1,a4,800043ce <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800043da:	0001d517          	auipc	a0,0x1d
    800043de:	67650513          	add	a0,a0,1654 # 80021a50 <ftable>
    800043e2:	ffffd097          	auipc	ra,0xffffd
    800043e6:	8ce080e7          	jalr	-1842(ra) # 80000cb0 <release>
  return 0;
    800043ea:	4481                	li	s1,0
    800043ec:	a819                	j	80004402 <filealloc+0x5e>
      f->ref = 1;
    800043ee:	4785                	li	a5,1
    800043f0:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800043f2:	0001d517          	auipc	a0,0x1d
    800043f6:	65e50513          	add	a0,a0,1630 # 80021a50 <ftable>
    800043fa:	ffffd097          	auipc	ra,0xffffd
    800043fe:	8b6080e7          	jalr	-1866(ra) # 80000cb0 <release>
}
    80004402:	8526                	mv	a0,s1
    80004404:	60e2                	ld	ra,24(sp)
    80004406:	6442                	ld	s0,16(sp)
    80004408:	64a2                	ld	s1,8(sp)
    8000440a:	6105                	add	sp,sp,32
    8000440c:	8082                	ret

000000008000440e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000440e:	1101                	add	sp,sp,-32
    80004410:	ec06                	sd	ra,24(sp)
    80004412:	e822                	sd	s0,16(sp)
    80004414:	e426                	sd	s1,8(sp)
    80004416:	1000                	add	s0,sp,32
    80004418:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000441a:	0001d517          	auipc	a0,0x1d
    8000441e:	63650513          	add	a0,a0,1590 # 80021a50 <ftable>
    80004422:	ffffc097          	auipc	ra,0xffffc
    80004426:	7da080e7          	jalr	2010(ra) # 80000bfc <acquire>
  if(f->ref < 1)
    8000442a:	40dc                	lw	a5,4(s1)
    8000442c:	02f05263          	blez	a5,80004450 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004430:	2785                	addw	a5,a5,1
    80004432:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004434:	0001d517          	auipc	a0,0x1d
    80004438:	61c50513          	add	a0,a0,1564 # 80021a50 <ftable>
    8000443c:	ffffd097          	auipc	ra,0xffffd
    80004440:	874080e7          	jalr	-1932(ra) # 80000cb0 <release>
  return f;
}
    80004444:	8526                	mv	a0,s1
    80004446:	60e2                	ld	ra,24(sp)
    80004448:	6442                	ld	s0,16(sp)
    8000444a:	64a2                	ld	s1,8(sp)
    8000444c:	6105                	add	sp,sp,32
    8000444e:	8082                	ret
    panic("filedup");
    80004450:	00004517          	auipc	a0,0x4
    80004454:	21850513          	add	a0,a0,536 # 80008668 <syscalls+0x240>
    80004458:	ffffc097          	auipc	ra,0xffffc
    8000445c:	0ea080e7          	jalr	234(ra) # 80000542 <panic>

0000000080004460 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004460:	7139                	add	sp,sp,-64
    80004462:	fc06                	sd	ra,56(sp)
    80004464:	f822                	sd	s0,48(sp)
    80004466:	f426                	sd	s1,40(sp)
    80004468:	f04a                	sd	s2,32(sp)
    8000446a:	ec4e                	sd	s3,24(sp)
    8000446c:	e852                	sd	s4,16(sp)
    8000446e:	e456                	sd	s5,8(sp)
    80004470:	0080                	add	s0,sp,64
    80004472:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004474:	0001d517          	auipc	a0,0x1d
    80004478:	5dc50513          	add	a0,a0,1500 # 80021a50 <ftable>
    8000447c:	ffffc097          	auipc	ra,0xffffc
    80004480:	780080e7          	jalr	1920(ra) # 80000bfc <acquire>
  if(f->ref < 1)
    80004484:	40dc                	lw	a5,4(s1)
    80004486:	06f05163          	blez	a5,800044e8 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    8000448a:	37fd                	addw	a5,a5,-1
    8000448c:	0007871b          	sext.w	a4,a5
    80004490:	c0dc                	sw	a5,4(s1)
    80004492:	06e04363          	bgtz	a4,800044f8 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004496:	0004a903          	lw	s2,0(s1)
    8000449a:	0094ca83          	lbu	s5,9(s1)
    8000449e:	0104ba03          	ld	s4,16(s1)
    800044a2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800044a6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800044aa:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800044ae:	0001d517          	auipc	a0,0x1d
    800044b2:	5a250513          	add	a0,a0,1442 # 80021a50 <ftable>
    800044b6:	ffffc097          	auipc	ra,0xffffc
    800044ba:	7fa080e7          	jalr	2042(ra) # 80000cb0 <release>

  if(ff.type == FD_PIPE){
    800044be:	4785                	li	a5,1
    800044c0:	04f90d63          	beq	s2,a5,8000451a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800044c4:	3979                	addw	s2,s2,-2
    800044c6:	4785                	li	a5,1
    800044c8:	0527e063          	bltu	a5,s2,80004508 <fileclose+0xa8>
    begin_op();
    800044cc:	00000097          	auipc	ra,0x0
    800044d0:	aca080e7          	jalr	-1334(ra) # 80003f96 <begin_op>
    iput(ff.ip);
    800044d4:	854e                	mv	a0,s3
    800044d6:	fffff097          	auipc	ra,0xfffff
    800044da:	2d6080e7          	jalr	726(ra) # 800037ac <iput>
    end_op();
    800044de:	00000097          	auipc	ra,0x0
    800044e2:	b32080e7          	jalr	-1230(ra) # 80004010 <end_op>
    800044e6:	a00d                	j	80004508 <fileclose+0xa8>
    panic("fileclose");
    800044e8:	00004517          	auipc	a0,0x4
    800044ec:	18850513          	add	a0,a0,392 # 80008670 <syscalls+0x248>
    800044f0:	ffffc097          	auipc	ra,0xffffc
    800044f4:	052080e7          	jalr	82(ra) # 80000542 <panic>
    release(&ftable.lock);
    800044f8:	0001d517          	auipc	a0,0x1d
    800044fc:	55850513          	add	a0,a0,1368 # 80021a50 <ftable>
    80004500:	ffffc097          	auipc	ra,0xffffc
    80004504:	7b0080e7          	jalr	1968(ra) # 80000cb0 <release>
  }
}
    80004508:	70e2                	ld	ra,56(sp)
    8000450a:	7442                	ld	s0,48(sp)
    8000450c:	74a2                	ld	s1,40(sp)
    8000450e:	7902                	ld	s2,32(sp)
    80004510:	69e2                	ld	s3,24(sp)
    80004512:	6a42                	ld	s4,16(sp)
    80004514:	6aa2                	ld	s5,8(sp)
    80004516:	6121                	add	sp,sp,64
    80004518:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000451a:	85d6                	mv	a1,s5
    8000451c:	8552                	mv	a0,s4
    8000451e:	00000097          	auipc	ra,0x0
    80004522:	372080e7          	jalr	882(ra) # 80004890 <pipeclose>
    80004526:	b7cd                	j	80004508 <fileclose+0xa8>

0000000080004528 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004528:	715d                	add	sp,sp,-80
    8000452a:	e486                	sd	ra,72(sp)
    8000452c:	e0a2                	sd	s0,64(sp)
    8000452e:	fc26                	sd	s1,56(sp)
    80004530:	f84a                	sd	s2,48(sp)
    80004532:	f44e                	sd	s3,40(sp)
    80004534:	0880                	add	s0,sp,80
    80004536:	84aa                	mv	s1,a0
    80004538:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000453a:	ffffd097          	auipc	ra,0xffffd
    8000453e:	48c080e7          	jalr	1164(ra) # 800019c6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004542:	409c                	lw	a5,0(s1)
    80004544:	37f9                	addw	a5,a5,-2
    80004546:	4705                	li	a4,1
    80004548:	04f76763          	bltu	a4,a5,80004596 <filestat+0x6e>
    8000454c:	892a                	mv	s2,a0
    ilock(f->ip);
    8000454e:	6c88                	ld	a0,24(s1)
    80004550:	fffff097          	auipc	ra,0xfffff
    80004554:	0a2080e7          	jalr	162(ra) # 800035f2 <ilock>
    stati(f->ip, &st);
    80004558:	fb840593          	add	a1,s0,-72
    8000455c:	6c88                	ld	a0,24(s1)
    8000455e:	fffff097          	auipc	ra,0xfffff
    80004562:	31e080e7          	jalr	798(ra) # 8000387c <stati>
    iunlock(f->ip);
    80004566:	6c88                	ld	a0,24(s1)
    80004568:	fffff097          	auipc	ra,0xfffff
    8000456c:	14c080e7          	jalr	332(ra) # 800036b4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004570:	46e1                	li	a3,24
    80004572:	fb840613          	add	a2,s0,-72
    80004576:	85ce                	mv	a1,s3
    80004578:	05093503          	ld	a0,80(s2)
    8000457c:	ffffd097          	auipc	ra,0xffffd
    80004580:	140080e7          	jalr	320(ra) # 800016bc <copyout>
    80004584:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004588:	60a6                	ld	ra,72(sp)
    8000458a:	6406                	ld	s0,64(sp)
    8000458c:	74e2                	ld	s1,56(sp)
    8000458e:	7942                	ld	s2,48(sp)
    80004590:	79a2                	ld	s3,40(sp)
    80004592:	6161                	add	sp,sp,80
    80004594:	8082                	ret
  return -1;
    80004596:	557d                	li	a0,-1
    80004598:	bfc5                	j	80004588 <filestat+0x60>

000000008000459a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000459a:	7179                	add	sp,sp,-48
    8000459c:	f406                	sd	ra,40(sp)
    8000459e:	f022                	sd	s0,32(sp)
    800045a0:	ec26                	sd	s1,24(sp)
    800045a2:	e84a                	sd	s2,16(sp)
    800045a4:	e44e                	sd	s3,8(sp)
    800045a6:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800045a8:	00854783          	lbu	a5,8(a0)
    800045ac:	c3d5                	beqz	a5,80004650 <fileread+0xb6>
    800045ae:	84aa                	mv	s1,a0
    800045b0:	89ae                	mv	s3,a1
    800045b2:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800045b4:	411c                	lw	a5,0(a0)
    800045b6:	4705                	li	a4,1
    800045b8:	04e78963          	beq	a5,a4,8000460a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800045bc:	470d                	li	a4,3
    800045be:	04e78d63          	beq	a5,a4,80004618 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800045c2:	4709                	li	a4,2
    800045c4:	06e79e63          	bne	a5,a4,80004640 <fileread+0xa6>
    ilock(f->ip);
    800045c8:	6d08                	ld	a0,24(a0)
    800045ca:	fffff097          	auipc	ra,0xfffff
    800045ce:	028080e7          	jalr	40(ra) # 800035f2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800045d2:	874a                	mv	a4,s2
    800045d4:	5094                	lw	a3,32(s1)
    800045d6:	864e                	mv	a2,s3
    800045d8:	4585                	li	a1,1
    800045da:	6c88                	ld	a0,24(s1)
    800045dc:	fffff097          	auipc	ra,0xfffff
    800045e0:	2ca080e7          	jalr	714(ra) # 800038a6 <readi>
    800045e4:	892a                	mv	s2,a0
    800045e6:	00a05563          	blez	a0,800045f0 <fileread+0x56>
      f->off += r;
    800045ea:	509c                	lw	a5,32(s1)
    800045ec:	9fa9                	addw	a5,a5,a0
    800045ee:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800045f0:	6c88                	ld	a0,24(s1)
    800045f2:	fffff097          	auipc	ra,0xfffff
    800045f6:	0c2080e7          	jalr	194(ra) # 800036b4 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800045fa:	854a                	mv	a0,s2
    800045fc:	70a2                	ld	ra,40(sp)
    800045fe:	7402                	ld	s0,32(sp)
    80004600:	64e2                	ld	s1,24(sp)
    80004602:	6942                	ld	s2,16(sp)
    80004604:	69a2                	ld	s3,8(sp)
    80004606:	6145                	add	sp,sp,48
    80004608:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000460a:	6908                	ld	a0,16(a0)
    8000460c:	00000097          	auipc	ra,0x0
    80004610:	3ee080e7          	jalr	1006(ra) # 800049fa <piperead>
    80004614:	892a                	mv	s2,a0
    80004616:	b7d5                	j	800045fa <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004618:	02451783          	lh	a5,36(a0)
    8000461c:	03079693          	sll	a3,a5,0x30
    80004620:	92c1                	srl	a3,a3,0x30
    80004622:	4725                	li	a4,9
    80004624:	02d76863          	bltu	a4,a3,80004654 <fileread+0xba>
    80004628:	0792                	sll	a5,a5,0x4
    8000462a:	0001d717          	auipc	a4,0x1d
    8000462e:	38670713          	add	a4,a4,902 # 800219b0 <devsw>
    80004632:	97ba                	add	a5,a5,a4
    80004634:	639c                	ld	a5,0(a5)
    80004636:	c38d                	beqz	a5,80004658 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004638:	4505                	li	a0,1
    8000463a:	9782                	jalr	a5
    8000463c:	892a                	mv	s2,a0
    8000463e:	bf75                	j	800045fa <fileread+0x60>
    panic("fileread");
    80004640:	00004517          	auipc	a0,0x4
    80004644:	04050513          	add	a0,a0,64 # 80008680 <syscalls+0x258>
    80004648:	ffffc097          	auipc	ra,0xffffc
    8000464c:	efa080e7          	jalr	-262(ra) # 80000542 <panic>
    return -1;
    80004650:	597d                	li	s2,-1
    80004652:	b765                	j	800045fa <fileread+0x60>
      return -1;
    80004654:	597d                	li	s2,-1
    80004656:	b755                	j	800045fa <fileread+0x60>
    80004658:	597d                	li	s2,-1
    8000465a:	b745                	j	800045fa <fileread+0x60>

000000008000465c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000465c:	00954783          	lbu	a5,9(a0)
    80004660:	14078363          	beqz	a5,800047a6 <filewrite+0x14a>
{
    80004664:	715d                	add	sp,sp,-80
    80004666:	e486                	sd	ra,72(sp)
    80004668:	e0a2                	sd	s0,64(sp)
    8000466a:	fc26                	sd	s1,56(sp)
    8000466c:	f84a                	sd	s2,48(sp)
    8000466e:	f44e                	sd	s3,40(sp)
    80004670:	f052                	sd	s4,32(sp)
    80004672:	ec56                	sd	s5,24(sp)
    80004674:	e85a                	sd	s6,16(sp)
    80004676:	e45e                	sd	s7,8(sp)
    80004678:	e062                	sd	s8,0(sp)
    8000467a:	0880                	add	s0,sp,80
    8000467c:	892a                	mv	s2,a0
    8000467e:	8b2e                	mv	s6,a1
    80004680:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004682:	411c                	lw	a5,0(a0)
    80004684:	4705                	li	a4,1
    80004686:	02e78263          	beq	a5,a4,800046aa <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000468a:	470d                	li	a4,3
    8000468c:	02e78563          	beq	a5,a4,800046b6 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004690:	4709                	li	a4,2
    80004692:	10e79263          	bne	a5,a4,80004796 <filewrite+0x13a>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004696:	0ec05e63          	blez	a2,80004792 <filewrite+0x136>
    int i = 0;
    8000469a:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    8000469c:	6b85                	lui	s7,0x1
    8000469e:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800046a2:	6c05                	lui	s8,0x1
    800046a4:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800046a8:	a851                	j	8000473c <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    800046aa:	6908                	ld	a0,16(a0)
    800046ac:	00000097          	auipc	ra,0x0
    800046b0:	254080e7          	jalr	596(ra) # 80004900 <pipewrite>
    800046b4:	a85d                	j	8000476a <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800046b6:	02451783          	lh	a5,36(a0)
    800046ba:	03079693          	sll	a3,a5,0x30
    800046be:	92c1                	srl	a3,a3,0x30
    800046c0:	4725                	li	a4,9
    800046c2:	0ed76463          	bltu	a4,a3,800047aa <filewrite+0x14e>
    800046c6:	0792                	sll	a5,a5,0x4
    800046c8:	0001d717          	auipc	a4,0x1d
    800046cc:	2e870713          	add	a4,a4,744 # 800219b0 <devsw>
    800046d0:	97ba                	add	a5,a5,a4
    800046d2:	679c                	ld	a5,8(a5)
    800046d4:	cfe9                	beqz	a5,800047ae <filewrite+0x152>
    ret = devsw[f->major].write(1, addr, n);
    800046d6:	4505                	li	a0,1
    800046d8:	9782                	jalr	a5
    800046da:	a841                	j	8000476a <filewrite+0x10e>
      if(n1 > max)
    800046dc:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800046e0:	00000097          	auipc	ra,0x0
    800046e4:	8b6080e7          	jalr	-1866(ra) # 80003f96 <begin_op>
      ilock(f->ip);
    800046e8:	01893503          	ld	a0,24(s2)
    800046ec:	fffff097          	auipc	ra,0xfffff
    800046f0:	f06080e7          	jalr	-250(ra) # 800035f2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800046f4:	8756                	mv	a4,s5
    800046f6:	02092683          	lw	a3,32(s2)
    800046fa:	01698633          	add	a2,s3,s6
    800046fe:	4585                	li	a1,1
    80004700:	01893503          	ld	a0,24(s2)
    80004704:	fffff097          	auipc	ra,0xfffff
    80004708:	29a080e7          	jalr	666(ra) # 8000399e <writei>
    8000470c:	84aa                	mv	s1,a0
    8000470e:	02a05f63          	blez	a0,8000474c <filewrite+0xf0>
        f->off += r;
    80004712:	02092783          	lw	a5,32(s2)
    80004716:	9fa9                	addw	a5,a5,a0
    80004718:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000471c:	01893503          	ld	a0,24(s2)
    80004720:	fffff097          	auipc	ra,0xfffff
    80004724:	f94080e7          	jalr	-108(ra) # 800036b4 <iunlock>
      end_op();
    80004728:	00000097          	auipc	ra,0x0
    8000472c:	8e8080e7          	jalr	-1816(ra) # 80004010 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004730:	049a9963          	bne	s5,s1,80004782 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    80004734:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004738:	0349d663          	bge	s3,s4,80004764 <filewrite+0x108>
      int n1 = n - i;
    8000473c:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004740:	0004879b          	sext.w	a5,s1
    80004744:	f8fbdce3          	bge	s7,a5,800046dc <filewrite+0x80>
    80004748:	84e2                	mv	s1,s8
    8000474a:	bf49                	j	800046dc <filewrite+0x80>
      iunlock(f->ip);
    8000474c:	01893503          	ld	a0,24(s2)
    80004750:	fffff097          	auipc	ra,0xfffff
    80004754:	f64080e7          	jalr	-156(ra) # 800036b4 <iunlock>
      end_op();
    80004758:	00000097          	auipc	ra,0x0
    8000475c:	8b8080e7          	jalr	-1864(ra) # 80004010 <end_op>
      if(r < 0)
    80004760:	fc04d8e3          	bgez	s1,80004730 <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004764:	053a1763          	bne	s4,s3,800047b2 <filewrite+0x156>
    80004768:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000476a:	60a6                	ld	ra,72(sp)
    8000476c:	6406                	ld	s0,64(sp)
    8000476e:	74e2                	ld	s1,56(sp)
    80004770:	7942                	ld	s2,48(sp)
    80004772:	79a2                	ld	s3,40(sp)
    80004774:	7a02                	ld	s4,32(sp)
    80004776:	6ae2                	ld	s5,24(sp)
    80004778:	6b42                	ld	s6,16(sp)
    8000477a:	6ba2                	ld	s7,8(sp)
    8000477c:	6c02                	ld	s8,0(sp)
    8000477e:	6161                	add	sp,sp,80
    80004780:	8082                	ret
        panic("short filewrite");
    80004782:	00004517          	auipc	a0,0x4
    80004786:	f0e50513          	add	a0,a0,-242 # 80008690 <syscalls+0x268>
    8000478a:	ffffc097          	auipc	ra,0xffffc
    8000478e:	db8080e7          	jalr	-584(ra) # 80000542 <panic>
    int i = 0;
    80004792:	4981                	li	s3,0
    80004794:	bfc1                	j	80004764 <filewrite+0x108>
    panic("filewrite");
    80004796:	00004517          	auipc	a0,0x4
    8000479a:	f0a50513          	add	a0,a0,-246 # 800086a0 <syscalls+0x278>
    8000479e:	ffffc097          	auipc	ra,0xffffc
    800047a2:	da4080e7          	jalr	-604(ra) # 80000542 <panic>
    return -1;
    800047a6:	557d                	li	a0,-1
}
    800047a8:	8082                	ret
      return -1;
    800047aa:	557d                	li	a0,-1
    800047ac:	bf7d                	j	8000476a <filewrite+0x10e>
    800047ae:	557d                	li	a0,-1
    800047b0:	bf6d                	j	8000476a <filewrite+0x10e>
    ret = (i == n ? n : -1);
    800047b2:	557d                	li	a0,-1
    800047b4:	bf5d                	j	8000476a <filewrite+0x10e>

00000000800047b6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800047b6:	7179                	add	sp,sp,-48
    800047b8:	f406                	sd	ra,40(sp)
    800047ba:	f022                	sd	s0,32(sp)
    800047bc:	ec26                	sd	s1,24(sp)
    800047be:	e84a                	sd	s2,16(sp)
    800047c0:	e44e                	sd	s3,8(sp)
    800047c2:	e052                	sd	s4,0(sp)
    800047c4:	1800                	add	s0,sp,48
    800047c6:	84aa                	mv	s1,a0
    800047c8:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800047ca:	0005b023          	sd	zero,0(a1)
    800047ce:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800047d2:	00000097          	auipc	ra,0x0
    800047d6:	bd2080e7          	jalr	-1070(ra) # 800043a4 <filealloc>
    800047da:	e088                	sd	a0,0(s1)
    800047dc:	c551                	beqz	a0,80004868 <pipealloc+0xb2>
    800047de:	00000097          	auipc	ra,0x0
    800047e2:	bc6080e7          	jalr	-1082(ra) # 800043a4 <filealloc>
    800047e6:	00aa3023          	sd	a0,0(s4)
    800047ea:	c92d                	beqz	a0,8000485c <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800047ec:	ffffc097          	auipc	ra,0xffffc
    800047f0:	320080e7          	jalr	800(ra) # 80000b0c <kalloc>
    800047f4:	892a                	mv	s2,a0
    800047f6:	c125                	beqz	a0,80004856 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    800047f8:	4985                	li	s3,1
    800047fa:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800047fe:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004802:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004806:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000480a:	00004597          	auipc	a1,0x4
    8000480e:	ea658593          	add	a1,a1,-346 # 800086b0 <syscalls+0x288>
    80004812:	ffffc097          	auipc	ra,0xffffc
    80004816:	35a080e7          	jalr	858(ra) # 80000b6c <initlock>
  (*f0)->type = FD_PIPE;
    8000481a:	609c                	ld	a5,0(s1)
    8000481c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004820:	609c                	ld	a5,0(s1)
    80004822:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004826:	609c                	ld	a5,0(s1)
    80004828:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000482c:	609c                	ld	a5,0(s1)
    8000482e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004832:	000a3783          	ld	a5,0(s4)
    80004836:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000483a:	000a3783          	ld	a5,0(s4)
    8000483e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004842:	000a3783          	ld	a5,0(s4)
    80004846:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000484a:	000a3783          	ld	a5,0(s4)
    8000484e:	0127b823          	sd	s2,16(a5)
  return 0;
    80004852:	4501                	li	a0,0
    80004854:	a025                	j	8000487c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004856:	6088                	ld	a0,0(s1)
    80004858:	e501                	bnez	a0,80004860 <pipealloc+0xaa>
    8000485a:	a039                	j	80004868 <pipealloc+0xb2>
    8000485c:	6088                	ld	a0,0(s1)
    8000485e:	c51d                	beqz	a0,8000488c <pipealloc+0xd6>
    fileclose(*f0);
    80004860:	00000097          	auipc	ra,0x0
    80004864:	c00080e7          	jalr	-1024(ra) # 80004460 <fileclose>
  if(*f1)
    80004868:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000486c:	557d                	li	a0,-1
  if(*f1)
    8000486e:	c799                	beqz	a5,8000487c <pipealloc+0xc6>
    fileclose(*f1);
    80004870:	853e                	mv	a0,a5
    80004872:	00000097          	auipc	ra,0x0
    80004876:	bee080e7          	jalr	-1042(ra) # 80004460 <fileclose>
  return -1;
    8000487a:	557d                	li	a0,-1
}
    8000487c:	70a2                	ld	ra,40(sp)
    8000487e:	7402                	ld	s0,32(sp)
    80004880:	64e2                	ld	s1,24(sp)
    80004882:	6942                	ld	s2,16(sp)
    80004884:	69a2                	ld	s3,8(sp)
    80004886:	6a02                	ld	s4,0(sp)
    80004888:	6145                	add	sp,sp,48
    8000488a:	8082                	ret
  return -1;
    8000488c:	557d                	li	a0,-1
    8000488e:	b7fd                	j	8000487c <pipealloc+0xc6>

0000000080004890 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004890:	1101                	add	sp,sp,-32
    80004892:	ec06                	sd	ra,24(sp)
    80004894:	e822                	sd	s0,16(sp)
    80004896:	e426                	sd	s1,8(sp)
    80004898:	e04a                	sd	s2,0(sp)
    8000489a:	1000                	add	s0,sp,32
    8000489c:	84aa                	mv	s1,a0
    8000489e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800048a0:	ffffc097          	auipc	ra,0xffffc
    800048a4:	35c080e7          	jalr	860(ra) # 80000bfc <acquire>
  if(writable){
    800048a8:	02090d63          	beqz	s2,800048e2 <pipeclose+0x52>
    pi->writeopen = 0;
    800048ac:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800048b0:	21848513          	add	a0,s1,536
    800048b4:	ffffe097          	auipc	ra,0xffffe
    800048b8:	aa8080e7          	jalr	-1368(ra) # 8000235c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800048bc:	2204b783          	ld	a5,544(s1)
    800048c0:	eb95                	bnez	a5,800048f4 <pipeclose+0x64>
    release(&pi->lock);
    800048c2:	8526                	mv	a0,s1
    800048c4:	ffffc097          	auipc	ra,0xffffc
    800048c8:	3ec080e7          	jalr	1004(ra) # 80000cb0 <release>
    kfree((char*)pi);
    800048cc:	8526                	mv	a0,s1
    800048ce:	ffffc097          	auipc	ra,0xffffc
    800048d2:	140080e7          	jalr	320(ra) # 80000a0e <kfree>
  } else
    release(&pi->lock);
}
    800048d6:	60e2                	ld	ra,24(sp)
    800048d8:	6442                	ld	s0,16(sp)
    800048da:	64a2                	ld	s1,8(sp)
    800048dc:	6902                	ld	s2,0(sp)
    800048de:	6105                	add	sp,sp,32
    800048e0:	8082                	ret
    pi->readopen = 0;
    800048e2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800048e6:	21c48513          	add	a0,s1,540
    800048ea:	ffffe097          	auipc	ra,0xffffe
    800048ee:	a72080e7          	jalr	-1422(ra) # 8000235c <wakeup>
    800048f2:	b7e9                	j	800048bc <pipeclose+0x2c>
    release(&pi->lock);
    800048f4:	8526                	mv	a0,s1
    800048f6:	ffffc097          	auipc	ra,0xffffc
    800048fa:	3ba080e7          	jalr	954(ra) # 80000cb0 <release>
}
    800048fe:	bfe1                	j	800048d6 <pipeclose+0x46>

0000000080004900 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004900:	711d                	add	sp,sp,-96
    80004902:	ec86                	sd	ra,88(sp)
    80004904:	e8a2                	sd	s0,80(sp)
    80004906:	e4a6                	sd	s1,72(sp)
    80004908:	e0ca                	sd	s2,64(sp)
    8000490a:	fc4e                	sd	s3,56(sp)
    8000490c:	f852                	sd	s4,48(sp)
    8000490e:	f456                	sd	s5,40(sp)
    80004910:	f05a                	sd	s6,32(sp)
    80004912:	ec5e                	sd	s7,24(sp)
    80004914:	1080                	add	s0,sp,96
    80004916:	84aa                	mv	s1,a0
    80004918:	8b2e                	mv	s6,a1
    8000491a:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    8000491c:	ffffd097          	auipc	ra,0xffffd
    80004920:	0aa080e7          	jalr	170(ra) # 800019c6 <myproc>
    80004924:	892a                	mv	s2,a0

  acquire(&pi->lock);
    80004926:	8526                	mv	a0,s1
    80004928:	ffffc097          	auipc	ra,0xffffc
    8000492c:	2d4080e7          	jalr	724(ra) # 80000bfc <acquire>
  for(i = 0; i < n; i++){
    80004930:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004932:	21848a13          	add	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004936:	21c48993          	add	s3,s1,540
  for(i = 0; i < n; i++){
    8000493a:	09505263          	blez	s5,800049be <pipewrite+0xbe>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    8000493e:	2184a783          	lw	a5,536(s1)
    80004942:	21c4a703          	lw	a4,540(s1)
    80004946:	2007879b          	addw	a5,a5,512
    8000494a:	02f71b63          	bne	a4,a5,80004980 <pipewrite+0x80>
      if(pi->readopen == 0 || pr->killed){
    8000494e:	2204a783          	lw	a5,544(s1)
    80004952:	c3d1                	beqz	a5,800049d6 <pipewrite+0xd6>
    80004954:	03092783          	lw	a5,48(s2)
    80004958:	efbd                	bnez	a5,800049d6 <pipewrite+0xd6>
      wakeup(&pi->nread);
    8000495a:	8552                	mv	a0,s4
    8000495c:	ffffe097          	auipc	ra,0xffffe
    80004960:	a00080e7          	jalr	-1536(ra) # 8000235c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004964:	85a6                	mv	a1,s1
    80004966:	854e                	mv	a0,s3
    80004968:	ffffe097          	auipc	ra,0xffffe
    8000496c:	874080e7          	jalr	-1932(ra) # 800021dc <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004970:	2184a783          	lw	a5,536(s1)
    80004974:	21c4a703          	lw	a4,540(s1)
    80004978:	2007879b          	addw	a5,a5,512
    8000497c:	fcf709e3          	beq	a4,a5,8000494e <pipewrite+0x4e>
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004980:	4685                	li	a3,1
    80004982:	865a                	mv	a2,s6
    80004984:	faf40593          	add	a1,s0,-81
    80004988:	05093503          	ld	a0,80(s2)
    8000498c:	ffffd097          	auipc	ra,0xffffd
    80004990:	dbc080e7          	jalr	-580(ra) # 80001748 <copyin>
    80004994:	57fd                	li	a5,-1
    80004996:	02f50463          	beq	a0,a5,800049be <pipewrite+0xbe>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000499a:	21c4a783          	lw	a5,540(s1)
    8000499e:	0017871b          	addw	a4,a5,1
    800049a2:	20e4ae23          	sw	a4,540(s1)
    800049a6:	1ff7f793          	and	a5,a5,511
    800049aa:	97a6                	add	a5,a5,s1
    800049ac:	faf44703          	lbu	a4,-81(s0)
    800049b0:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    800049b4:	2b85                	addw	s7,s7,1
    800049b6:	0b05                	add	s6,s6,1
    800049b8:	f97a93e3          	bne	s5,s7,8000493e <pipewrite+0x3e>
    800049bc:	8bd6                	mv	s7,s5
  }
  wakeup(&pi->nread);
    800049be:	21848513          	add	a0,s1,536
    800049c2:	ffffe097          	auipc	ra,0xffffe
    800049c6:	99a080e7          	jalr	-1638(ra) # 8000235c <wakeup>
  release(&pi->lock);
    800049ca:	8526                	mv	a0,s1
    800049cc:	ffffc097          	auipc	ra,0xffffc
    800049d0:	2e4080e7          	jalr	740(ra) # 80000cb0 <release>
  return i;
    800049d4:	a039                	j	800049e2 <pipewrite+0xe2>
        release(&pi->lock);
    800049d6:	8526                	mv	a0,s1
    800049d8:	ffffc097          	auipc	ra,0xffffc
    800049dc:	2d8080e7          	jalr	728(ra) # 80000cb0 <release>
        return -1;
    800049e0:	5bfd                	li	s7,-1
}
    800049e2:	855e                	mv	a0,s7
    800049e4:	60e6                	ld	ra,88(sp)
    800049e6:	6446                	ld	s0,80(sp)
    800049e8:	64a6                	ld	s1,72(sp)
    800049ea:	6906                	ld	s2,64(sp)
    800049ec:	79e2                	ld	s3,56(sp)
    800049ee:	7a42                	ld	s4,48(sp)
    800049f0:	7aa2                	ld	s5,40(sp)
    800049f2:	7b02                	ld	s6,32(sp)
    800049f4:	6be2                	ld	s7,24(sp)
    800049f6:	6125                	add	sp,sp,96
    800049f8:	8082                	ret

00000000800049fa <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800049fa:	715d                	add	sp,sp,-80
    800049fc:	e486                	sd	ra,72(sp)
    800049fe:	e0a2                	sd	s0,64(sp)
    80004a00:	fc26                	sd	s1,56(sp)
    80004a02:	f84a                	sd	s2,48(sp)
    80004a04:	f44e                	sd	s3,40(sp)
    80004a06:	f052                	sd	s4,32(sp)
    80004a08:	ec56                	sd	s5,24(sp)
    80004a0a:	e85a                	sd	s6,16(sp)
    80004a0c:	0880                	add	s0,sp,80
    80004a0e:	84aa                	mv	s1,a0
    80004a10:	892e                	mv	s2,a1
    80004a12:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004a14:	ffffd097          	auipc	ra,0xffffd
    80004a18:	fb2080e7          	jalr	-78(ra) # 800019c6 <myproc>
    80004a1c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004a1e:	8526                	mv	a0,s1
    80004a20:	ffffc097          	auipc	ra,0xffffc
    80004a24:	1dc080e7          	jalr	476(ra) # 80000bfc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a28:	2184a703          	lw	a4,536(s1)
    80004a2c:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a30:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a34:	02f71463          	bne	a4,a5,80004a5c <piperead+0x62>
    80004a38:	2244a783          	lw	a5,548(s1)
    80004a3c:	c385                	beqz	a5,80004a5c <piperead+0x62>
    if(pr->killed){
    80004a3e:	030a2783          	lw	a5,48(s4)
    80004a42:	ebc9                	bnez	a5,80004ad4 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a44:	85a6                	mv	a1,s1
    80004a46:	854e                	mv	a0,s3
    80004a48:	ffffd097          	auipc	ra,0xffffd
    80004a4c:	794080e7          	jalr	1940(ra) # 800021dc <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a50:	2184a703          	lw	a4,536(s1)
    80004a54:	21c4a783          	lw	a5,540(s1)
    80004a58:	fef700e3          	beq	a4,a5,80004a38 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a5c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004a5e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a60:	05505463          	blez	s5,80004aa8 <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004a64:	2184a783          	lw	a5,536(s1)
    80004a68:	21c4a703          	lw	a4,540(s1)
    80004a6c:	02f70e63          	beq	a4,a5,80004aa8 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004a70:	0017871b          	addw	a4,a5,1
    80004a74:	20e4ac23          	sw	a4,536(s1)
    80004a78:	1ff7f793          	and	a5,a5,511
    80004a7c:	97a6                	add	a5,a5,s1
    80004a7e:	0187c783          	lbu	a5,24(a5)
    80004a82:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004a86:	4685                	li	a3,1
    80004a88:	fbf40613          	add	a2,s0,-65
    80004a8c:	85ca                	mv	a1,s2
    80004a8e:	050a3503          	ld	a0,80(s4)
    80004a92:	ffffd097          	auipc	ra,0xffffd
    80004a96:	c2a080e7          	jalr	-982(ra) # 800016bc <copyout>
    80004a9a:	01650763          	beq	a0,s6,80004aa8 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a9e:	2985                	addw	s3,s3,1
    80004aa0:	0905                	add	s2,s2,1
    80004aa2:	fd3a91e3          	bne	s5,s3,80004a64 <piperead+0x6a>
    80004aa6:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004aa8:	21c48513          	add	a0,s1,540
    80004aac:	ffffe097          	auipc	ra,0xffffe
    80004ab0:	8b0080e7          	jalr	-1872(ra) # 8000235c <wakeup>
  release(&pi->lock);
    80004ab4:	8526                	mv	a0,s1
    80004ab6:	ffffc097          	auipc	ra,0xffffc
    80004aba:	1fa080e7          	jalr	506(ra) # 80000cb0 <release>
  return i;
}
    80004abe:	854e                	mv	a0,s3
    80004ac0:	60a6                	ld	ra,72(sp)
    80004ac2:	6406                	ld	s0,64(sp)
    80004ac4:	74e2                	ld	s1,56(sp)
    80004ac6:	7942                	ld	s2,48(sp)
    80004ac8:	79a2                	ld	s3,40(sp)
    80004aca:	7a02                	ld	s4,32(sp)
    80004acc:	6ae2                	ld	s5,24(sp)
    80004ace:	6b42                	ld	s6,16(sp)
    80004ad0:	6161                	add	sp,sp,80
    80004ad2:	8082                	ret
      release(&pi->lock);
    80004ad4:	8526                	mv	a0,s1
    80004ad6:	ffffc097          	auipc	ra,0xffffc
    80004ada:	1da080e7          	jalr	474(ra) # 80000cb0 <release>
      return -1;
    80004ade:	59fd                	li	s3,-1
    80004ae0:	bff9                	j	80004abe <piperead+0xc4>

0000000080004ae2 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004ae2:	df010113          	add	sp,sp,-528
    80004ae6:	20113423          	sd	ra,520(sp)
    80004aea:	20813023          	sd	s0,512(sp)
    80004aee:	ffa6                	sd	s1,504(sp)
    80004af0:	fbca                	sd	s2,496(sp)
    80004af2:	f7ce                	sd	s3,488(sp)
    80004af4:	f3d2                	sd	s4,480(sp)
    80004af6:	efd6                	sd	s5,472(sp)
    80004af8:	ebda                	sd	s6,464(sp)
    80004afa:	e7de                	sd	s7,456(sp)
    80004afc:	e3e2                	sd	s8,448(sp)
    80004afe:	ff66                	sd	s9,440(sp)
    80004b00:	fb6a                	sd	s10,432(sp)
    80004b02:	f76e                	sd	s11,424(sp)
    80004b04:	0c00                	add	s0,sp,528
    80004b06:	892a                	mv	s2,a0
    80004b08:	dea43c23          	sd	a0,-520(s0)
    80004b0c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004b10:	ffffd097          	auipc	ra,0xffffd
    80004b14:	eb6080e7          	jalr	-330(ra) # 800019c6 <myproc>
    80004b18:	84aa                	mv	s1,a0

  begin_op();
    80004b1a:	fffff097          	auipc	ra,0xfffff
    80004b1e:	47c080e7          	jalr	1148(ra) # 80003f96 <begin_op>

  if((ip = namei(path)) == 0){
    80004b22:	854a                	mv	a0,s2
    80004b24:	fffff097          	auipc	ra,0xfffff
    80004b28:	282080e7          	jalr	642(ra) # 80003da6 <namei>
    80004b2c:	c92d                	beqz	a0,80004b9e <exec+0xbc>
    80004b2e:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004b30:	fffff097          	auipc	ra,0xfffff
    80004b34:	ac2080e7          	jalr	-1342(ra) # 800035f2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004b38:	04000713          	li	a4,64
    80004b3c:	4681                	li	a3,0
    80004b3e:	e4840613          	add	a2,s0,-440
    80004b42:	4581                	li	a1,0
    80004b44:	8552                	mv	a0,s4
    80004b46:	fffff097          	auipc	ra,0xfffff
    80004b4a:	d60080e7          	jalr	-672(ra) # 800038a6 <readi>
    80004b4e:	04000793          	li	a5,64
    80004b52:	00f51a63          	bne	a0,a5,80004b66 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004b56:	e4842703          	lw	a4,-440(s0)
    80004b5a:	464c47b7          	lui	a5,0x464c4
    80004b5e:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004b62:	04f70463          	beq	a4,a5,80004baa <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004b66:	8552                	mv	a0,s4
    80004b68:	fffff097          	auipc	ra,0xfffff
    80004b6c:	cec080e7          	jalr	-788(ra) # 80003854 <iunlockput>
    end_op();
    80004b70:	fffff097          	auipc	ra,0xfffff
    80004b74:	4a0080e7          	jalr	1184(ra) # 80004010 <end_op>
  }
  return -1;
    80004b78:	557d                	li	a0,-1
}
    80004b7a:	20813083          	ld	ra,520(sp)
    80004b7e:	20013403          	ld	s0,512(sp)
    80004b82:	74fe                	ld	s1,504(sp)
    80004b84:	795e                	ld	s2,496(sp)
    80004b86:	79be                	ld	s3,488(sp)
    80004b88:	7a1e                	ld	s4,480(sp)
    80004b8a:	6afe                	ld	s5,472(sp)
    80004b8c:	6b5e                	ld	s6,464(sp)
    80004b8e:	6bbe                	ld	s7,456(sp)
    80004b90:	6c1e                	ld	s8,448(sp)
    80004b92:	7cfa                	ld	s9,440(sp)
    80004b94:	7d5a                	ld	s10,432(sp)
    80004b96:	7dba                	ld	s11,424(sp)
    80004b98:	21010113          	add	sp,sp,528
    80004b9c:	8082                	ret
    end_op();
    80004b9e:	fffff097          	auipc	ra,0xfffff
    80004ba2:	472080e7          	jalr	1138(ra) # 80004010 <end_op>
    return -1;
    80004ba6:	557d                	li	a0,-1
    80004ba8:	bfc9                	j	80004b7a <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004baa:	8526                	mv	a0,s1
    80004bac:	ffffd097          	auipc	ra,0xffffd
    80004bb0:	ede080e7          	jalr	-290(ra) # 80001a8a <proc_pagetable>
    80004bb4:	8b2a                	mv	s6,a0
    80004bb6:	d945                	beqz	a0,80004b66 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004bb8:	e6842d03          	lw	s10,-408(s0)
    80004bbc:	e8045783          	lhu	a5,-384(s0)
    80004bc0:	cfe5                	beqz	a5,80004cb8 <exec+0x1d6>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004bc2:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004bc4:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004bc6:	6c85                	lui	s9,0x1
    80004bc8:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004bcc:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004bd0:	6a85                	lui	s5,0x1
    80004bd2:	a0b5                	j	80004c3e <exec+0x15c>
      panic("loadseg: address should exist");
    80004bd4:	00004517          	auipc	a0,0x4
    80004bd8:	ae450513          	add	a0,a0,-1308 # 800086b8 <syscalls+0x290>
    80004bdc:	ffffc097          	auipc	ra,0xffffc
    80004be0:	966080e7          	jalr	-1690(ra) # 80000542 <panic>
    if(sz - i < PGSIZE)
    80004be4:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004be6:	8726                	mv	a4,s1
    80004be8:	012c06bb          	addw	a3,s8,s2
    80004bec:	4581                	li	a1,0
    80004bee:	8552                	mv	a0,s4
    80004bf0:	fffff097          	auipc	ra,0xfffff
    80004bf4:	cb6080e7          	jalr	-842(ra) # 800038a6 <readi>
    80004bf8:	2501                	sext.w	a0,a0
    80004bfa:	24a49063          	bne	s1,a0,80004e3a <exec+0x358>
  for(i = 0; i < sz; i += PGSIZE){
    80004bfe:	012a893b          	addw	s2,s5,s2
    80004c02:	03397563          	bgeu	s2,s3,80004c2c <exec+0x14a>
    pa = walkaddr(pagetable, va + i);
    80004c06:	02091593          	sll	a1,s2,0x20
    80004c0a:	9181                	srl	a1,a1,0x20
    80004c0c:	95de                	add	a1,a1,s7
    80004c0e:	855a                	mv	a0,s6
    80004c10:	ffffc097          	auipc	ra,0xffffc
    80004c14:	474080e7          	jalr	1140(ra) # 80001084 <walkaddr>
    80004c18:	862a                	mv	a2,a0
    if(pa == 0)
    80004c1a:	dd4d                	beqz	a0,80004bd4 <exec+0xf2>
    if(sz - i < PGSIZE)
    80004c1c:	412984bb          	subw	s1,s3,s2
    80004c20:	0004879b          	sext.w	a5,s1
    80004c24:	fcfcf0e3          	bgeu	s9,a5,80004be4 <exec+0x102>
    80004c28:	84d6                	mv	s1,s5
    80004c2a:	bf6d                	j	80004be4 <exec+0x102>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004c2c:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004c30:	2d85                	addw	s11,s11,1
    80004c32:	038d0d1b          	addw	s10,s10,56
    80004c36:	e8045783          	lhu	a5,-384(s0)
    80004c3a:	08fdd063          	bge	s11,a5,80004cba <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004c3e:	2d01                	sext.w	s10,s10
    80004c40:	03800713          	li	a4,56
    80004c44:	86ea                	mv	a3,s10
    80004c46:	e1040613          	add	a2,s0,-496
    80004c4a:	4581                	li	a1,0
    80004c4c:	8552                	mv	a0,s4
    80004c4e:	fffff097          	auipc	ra,0xfffff
    80004c52:	c58080e7          	jalr	-936(ra) # 800038a6 <readi>
    80004c56:	03800793          	li	a5,56
    80004c5a:	1cf51e63          	bne	a0,a5,80004e36 <exec+0x354>
    if(ph.type != ELF_PROG_LOAD)
    80004c5e:	e1042783          	lw	a5,-496(s0)
    80004c62:	4705                	li	a4,1
    80004c64:	fce796e3          	bne	a5,a4,80004c30 <exec+0x14e>
    if(ph.memsz < ph.filesz)
    80004c68:	e3843603          	ld	a2,-456(s0)
    80004c6c:	e3043783          	ld	a5,-464(s0)
    80004c70:	1ef66063          	bltu	a2,a5,80004e50 <exec+0x36e>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004c74:	e2043783          	ld	a5,-480(s0)
    80004c78:	963e                	add	a2,a2,a5
    80004c7a:	1cf66e63          	bltu	a2,a5,80004e56 <exec+0x374>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004c7e:	85a6                	mv	a1,s1
    80004c80:	855a                	mv	a0,s6
    80004c82:	ffffc097          	auipc	ra,0xffffc
    80004c86:	7e6080e7          	jalr	2022(ra) # 80001468 <uvmalloc>
    80004c8a:	e0a43423          	sd	a0,-504(s0)
    80004c8e:	1c050763          	beqz	a0,80004e5c <exec+0x37a>
    if(ph.vaddr % PGSIZE != 0)
    80004c92:	e2043b83          	ld	s7,-480(s0)
    80004c96:	df043783          	ld	a5,-528(s0)
    80004c9a:	00fbf7b3          	and	a5,s7,a5
    80004c9e:	18079e63          	bnez	a5,80004e3a <exec+0x358>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004ca2:	e1842c03          	lw	s8,-488(s0)
    80004ca6:	e3042983          	lw	s3,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004caa:	00098463          	beqz	s3,80004cb2 <exec+0x1d0>
    80004cae:	4901                	li	s2,0
    80004cb0:	bf99                	j	80004c06 <exec+0x124>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004cb2:	e0843483          	ld	s1,-504(s0)
    80004cb6:	bfad                	j	80004c30 <exec+0x14e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004cb8:	4481                	li	s1,0
  iunlockput(ip);
    80004cba:	8552                	mv	a0,s4
    80004cbc:	fffff097          	auipc	ra,0xfffff
    80004cc0:	b98080e7          	jalr	-1128(ra) # 80003854 <iunlockput>
  end_op();
    80004cc4:	fffff097          	auipc	ra,0xfffff
    80004cc8:	34c080e7          	jalr	844(ra) # 80004010 <end_op>
  p = myproc();
    80004ccc:	ffffd097          	auipc	ra,0xffffd
    80004cd0:	cfa080e7          	jalr	-774(ra) # 800019c6 <myproc>
    80004cd4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004cd6:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004cda:	6985                	lui	s3,0x1
    80004cdc:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004cde:	99a6                	add	s3,s3,s1
    80004ce0:	77fd                	lui	a5,0xfffff
    80004ce2:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004ce6:	6609                	lui	a2,0x2
    80004ce8:	964e                	add	a2,a2,s3
    80004cea:	85ce                	mv	a1,s3
    80004cec:	855a                	mv	a0,s6
    80004cee:	ffffc097          	auipc	ra,0xffffc
    80004cf2:	77a080e7          	jalr	1914(ra) # 80001468 <uvmalloc>
    80004cf6:	892a                	mv	s2,a0
    80004cf8:	e0a43423          	sd	a0,-504(s0)
    80004cfc:	e509                	bnez	a0,80004d06 <exec+0x224>
  if(pagetable)
    80004cfe:	e1343423          	sd	s3,-504(s0)
    80004d02:	4a01                	li	s4,0
    80004d04:	aa1d                	j	80004e3a <exec+0x358>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004d06:	75f9                	lui	a1,0xffffe
    80004d08:	95aa                	add	a1,a1,a0
    80004d0a:	855a                	mv	a0,s6
    80004d0c:	ffffd097          	auipc	ra,0xffffd
    80004d10:	97e080e7          	jalr	-1666(ra) # 8000168a <uvmclear>
  stackbase = sp - PGSIZE;
    80004d14:	7bfd                	lui	s7,0xfffff
    80004d16:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004d18:	e0043783          	ld	a5,-512(s0)
    80004d1c:	6388                	ld	a0,0(a5)
    80004d1e:	c52d                	beqz	a0,80004d88 <exec+0x2a6>
    80004d20:	e8840993          	add	s3,s0,-376
    80004d24:	f8840c13          	add	s8,s0,-120
    80004d28:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004d2a:	ffffc097          	auipc	ra,0xffffc
    80004d2e:	150080e7          	jalr	336(ra) # 80000e7a <strlen>
    80004d32:	0015079b          	addw	a5,a0,1
    80004d36:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004d3a:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80004d3e:	13796263          	bltu	s2,s7,80004e62 <exec+0x380>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004d42:	e0043d03          	ld	s10,-512(s0)
    80004d46:	000d3a03          	ld	s4,0(s10)
    80004d4a:	8552                	mv	a0,s4
    80004d4c:	ffffc097          	auipc	ra,0xffffc
    80004d50:	12e080e7          	jalr	302(ra) # 80000e7a <strlen>
    80004d54:	0015069b          	addw	a3,a0,1
    80004d58:	8652                	mv	a2,s4
    80004d5a:	85ca                	mv	a1,s2
    80004d5c:	855a                	mv	a0,s6
    80004d5e:	ffffd097          	auipc	ra,0xffffd
    80004d62:	95e080e7          	jalr	-1698(ra) # 800016bc <copyout>
    80004d66:	10054063          	bltz	a0,80004e66 <exec+0x384>
    ustack[argc] = sp;
    80004d6a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004d6e:	0485                	add	s1,s1,1
    80004d70:	008d0793          	add	a5,s10,8
    80004d74:	e0f43023          	sd	a5,-512(s0)
    80004d78:	008d3503          	ld	a0,8(s10)
    80004d7c:	c909                	beqz	a0,80004d8e <exec+0x2ac>
    if(argc >= MAXARG)
    80004d7e:	09a1                	add	s3,s3,8
    80004d80:	fb8995e3          	bne	s3,s8,80004d2a <exec+0x248>
  ip = 0;
    80004d84:	4a01                	li	s4,0
    80004d86:	a855                	j	80004e3a <exec+0x358>
  sp = sz;
    80004d88:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004d8c:	4481                	li	s1,0
  ustack[argc] = 0;
    80004d8e:	00349793          	sll	a5,s1,0x3
    80004d92:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd8f90>
    80004d96:	97a2                	add	a5,a5,s0
    80004d98:	ee07bc23          	sd	zero,-264(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004d9c:	00148693          	add	a3,s1,1
    80004da0:	068e                	sll	a3,a3,0x3
    80004da2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004da6:	ff097913          	and	s2,s2,-16
  sz = sz1;
    80004daa:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004dae:	f57968e3          	bltu	s2,s7,80004cfe <exec+0x21c>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004db2:	e8840613          	add	a2,s0,-376
    80004db6:	85ca                	mv	a1,s2
    80004db8:	855a                	mv	a0,s6
    80004dba:	ffffd097          	auipc	ra,0xffffd
    80004dbe:	902080e7          	jalr	-1790(ra) # 800016bc <copyout>
    80004dc2:	0a054463          	bltz	a0,80004e6a <exec+0x388>
  p->trapframe->a1 = sp;
    80004dc6:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004dca:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004dce:	df843783          	ld	a5,-520(s0)
    80004dd2:	0007c703          	lbu	a4,0(a5)
    80004dd6:	cf11                	beqz	a4,80004df2 <exec+0x310>
    80004dd8:	0785                	add	a5,a5,1
    if(*s == '/')
    80004dda:	02f00693          	li	a3,47
    80004dde:	a039                	j	80004dec <exec+0x30a>
      last = s+1;
    80004de0:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004de4:	0785                	add	a5,a5,1
    80004de6:	fff7c703          	lbu	a4,-1(a5)
    80004dea:	c701                	beqz	a4,80004df2 <exec+0x310>
    if(*s == '/')
    80004dec:	fed71ce3          	bne	a4,a3,80004de4 <exec+0x302>
    80004df0:	bfc5                	j	80004de0 <exec+0x2fe>
  safestrcpy(p->name, last, sizeof(p->name));
    80004df2:	4641                	li	a2,16
    80004df4:	df843583          	ld	a1,-520(s0)
    80004df8:	158a8513          	add	a0,s5,344
    80004dfc:	ffffc097          	auipc	ra,0xffffc
    80004e00:	04c080e7          	jalr	76(ra) # 80000e48 <safestrcpy>
  oldpagetable = p->pagetable;
    80004e04:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004e08:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004e0c:	e0843783          	ld	a5,-504(s0)
    80004e10:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004e14:	058ab783          	ld	a5,88(s5)
    80004e18:	e6043703          	ld	a4,-416(s0)
    80004e1c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004e1e:	058ab783          	ld	a5,88(s5)
    80004e22:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004e26:	85e6                	mv	a1,s9
    80004e28:	ffffd097          	auipc	ra,0xffffd
    80004e2c:	cfe080e7          	jalr	-770(ra) # 80001b26 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004e30:	0004851b          	sext.w	a0,s1
    80004e34:	b399                	j	80004b7a <exec+0x98>
    80004e36:	e0943423          	sd	s1,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004e3a:	e0843583          	ld	a1,-504(s0)
    80004e3e:	855a                	mv	a0,s6
    80004e40:	ffffd097          	auipc	ra,0xffffd
    80004e44:	ce6080e7          	jalr	-794(ra) # 80001b26 <proc_freepagetable>
  return -1;
    80004e48:	557d                	li	a0,-1
  if(ip){
    80004e4a:	d20a08e3          	beqz	s4,80004b7a <exec+0x98>
    80004e4e:	bb21                	j	80004b66 <exec+0x84>
    80004e50:	e0943423          	sd	s1,-504(s0)
    80004e54:	b7dd                	j	80004e3a <exec+0x358>
    80004e56:	e0943423          	sd	s1,-504(s0)
    80004e5a:	b7c5                	j	80004e3a <exec+0x358>
    80004e5c:	e0943423          	sd	s1,-504(s0)
    80004e60:	bfe9                	j	80004e3a <exec+0x358>
  ip = 0;
    80004e62:	4a01                	li	s4,0
    80004e64:	bfd9                	j	80004e3a <exec+0x358>
    80004e66:	4a01                	li	s4,0
  if(pagetable)
    80004e68:	bfc9                	j	80004e3a <exec+0x358>
  sz = sz1;
    80004e6a:	e0843983          	ld	s3,-504(s0)
    80004e6e:	bd41                	j	80004cfe <exec+0x21c>

0000000080004e70 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004e70:	7179                	add	sp,sp,-48
    80004e72:	f406                	sd	ra,40(sp)
    80004e74:	f022                	sd	s0,32(sp)
    80004e76:	ec26                	sd	s1,24(sp)
    80004e78:	e84a                	sd	s2,16(sp)
    80004e7a:	1800                	add	s0,sp,48
    80004e7c:	892e                	mv	s2,a1
    80004e7e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004e80:	fdc40593          	add	a1,s0,-36
    80004e84:	ffffe097          	auipc	ra,0xffffe
    80004e88:	c04080e7          	jalr	-1020(ra) # 80002a88 <argint>
    80004e8c:	04054063          	bltz	a0,80004ecc <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004e90:	fdc42703          	lw	a4,-36(s0)
    80004e94:	47bd                	li	a5,15
    80004e96:	02e7ed63          	bltu	a5,a4,80004ed0 <argfd+0x60>
    80004e9a:	ffffd097          	auipc	ra,0xffffd
    80004e9e:	b2c080e7          	jalr	-1236(ra) # 800019c6 <myproc>
    80004ea2:	fdc42703          	lw	a4,-36(s0)
    80004ea6:	01a70793          	add	a5,a4,26
    80004eaa:	078e                	sll	a5,a5,0x3
    80004eac:	953e                	add	a0,a0,a5
    80004eae:	611c                	ld	a5,0(a0)
    80004eb0:	c395                	beqz	a5,80004ed4 <argfd+0x64>
    return -1;
  if(pfd)
    80004eb2:	00090463          	beqz	s2,80004eba <argfd+0x4a>
    *pfd = fd;
    80004eb6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004eba:	4501                	li	a0,0
  if(pf)
    80004ebc:	c091                	beqz	s1,80004ec0 <argfd+0x50>
    *pf = f;
    80004ebe:	e09c                	sd	a5,0(s1)
}
    80004ec0:	70a2                	ld	ra,40(sp)
    80004ec2:	7402                	ld	s0,32(sp)
    80004ec4:	64e2                	ld	s1,24(sp)
    80004ec6:	6942                	ld	s2,16(sp)
    80004ec8:	6145                	add	sp,sp,48
    80004eca:	8082                	ret
    return -1;
    80004ecc:	557d                	li	a0,-1
    80004ece:	bfcd                	j	80004ec0 <argfd+0x50>
    return -1;
    80004ed0:	557d                	li	a0,-1
    80004ed2:	b7fd                	j	80004ec0 <argfd+0x50>
    80004ed4:	557d                	li	a0,-1
    80004ed6:	b7ed                	j	80004ec0 <argfd+0x50>

0000000080004ed8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004ed8:	1101                	add	sp,sp,-32
    80004eda:	ec06                	sd	ra,24(sp)
    80004edc:	e822                	sd	s0,16(sp)
    80004ede:	e426                	sd	s1,8(sp)
    80004ee0:	1000                	add	s0,sp,32
    80004ee2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004ee4:	ffffd097          	auipc	ra,0xffffd
    80004ee8:	ae2080e7          	jalr	-1310(ra) # 800019c6 <myproc>
    80004eec:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004eee:	0d050793          	add	a5,a0,208
    80004ef2:	4501                	li	a0,0
    80004ef4:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004ef6:	6398                	ld	a4,0(a5)
    80004ef8:	cb19                	beqz	a4,80004f0e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004efa:	2505                	addw	a0,a0,1
    80004efc:	07a1                	add	a5,a5,8
    80004efe:	fed51ce3          	bne	a0,a3,80004ef6 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004f02:	557d                	li	a0,-1
}
    80004f04:	60e2                	ld	ra,24(sp)
    80004f06:	6442                	ld	s0,16(sp)
    80004f08:	64a2                	ld	s1,8(sp)
    80004f0a:	6105                	add	sp,sp,32
    80004f0c:	8082                	ret
      p->ofile[fd] = f;
    80004f0e:	01a50793          	add	a5,a0,26
    80004f12:	078e                	sll	a5,a5,0x3
    80004f14:	963e                	add	a2,a2,a5
    80004f16:	e204                	sd	s1,0(a2)
      return fd;
    80004f18:	b7f5                	j	80004f04 <fdalloc+0x2c>

0000000080004f1a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004f1a:	715d                	add	sp,sp,-80
    80004f1c:	e486                	sd	ra,72(sp)
    80004f1e:	e0a2                	sd	s0,64(sp)
    80004f20:	fc26                	sd	s1,56(sp)
    80004f22:	f84a                	sd	s2,48(sp)
    80004f24:	f44e                	sd	s3,40(sp)
    80004f26:	f052                	sd	s4,32(sp)
    80004f28:	ec56                	sd	s5,24(sp)
    80004f2a:	0880                	add	s0,sp,80
    80004f2c:	8aae                	mv	s5,a1
    80004f2e:	8a32                	mv	s4,a2
    80004f30:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004f32:	fb040593          	add	a1,s0,-80
    80004f36:	fffff097          	auipc	ra,0xfffff
    80004f3a:	e8e080e7          	jalr	-370(ra) # 80003dc4 <nameiparent>
    80004f3e:	892a                	mv	s2,a0
    80004f40:	12050c63          	beqz	a0,80005078 <create+0x15e>
    return 0;

  ilock(dp);
    80004f44:	ffffe097          	auipc	ra,0xffffe
    80004f48:	6ae080e7          	jalr	1710(ra) # 800035f2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004f4c:	4601                	li	a2,0
    80004f4e:	fb040593          	add	a1,s0,-80
    80004f52:	854a                	mv	a0,s2
    80004f54:	fffff097          	auipc	ra,0xfffff
    80004f58:	b80080e7          	jalr	-1152(ra) # 80003ad4 <dirlookup>
    80004f5c:	84aa                	mv	s1,a0
    80004f5e:	c539                	beqz	a0,80004fac <create+0x92>
    iunlockput(dp);
    80004f60:	854a                	mv	a0,s2
    80004f62:	fffff097          	auipc	ra,0xfffff
    80004f66:	8f2080e7          	jalr	-1806(ra) # 80003854 <iunlockput>
    ilock(ip);
    80004f6a:	8526                	mv	a0,s1
    80004f6c:	ffffe097          	auipc	ra,0xffffe
    80004f70:	686080e7          	jalr	1670(ra) # 800035f2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004f74:	4789                	li	a5,2
    80004f76:	02fa9463          	bne	s5,a5,80004f9e <create+0x84>
    80004f7a:	0444d783          	lhu	a5,68(s1)
    80004f7e:	37f9                	addw	a5,a5,-2
    80004f80:	17c2                	sll	a5,a5,0x30
    80004f82:	93c1                	srl	a5,a5,0x30
    80004f84:	4705                	li	a4,1
    80004f86:	00f76c63          	bltu	a4,a5,80004f9e <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004f8a:	8526                	mv	a0,s1
    80004f8c:	60a6                	ld	ra,72(sp)
    80004f8e:	6406                	ld	s0,64(sp)
    80004f90:	74e2                	ld	s1,56(sp)
    80004f92:	7942                	ld	s2,48(sp)
    80004f94:	79a2                	ld	s3,40(sp)
    80004f96:	7a02                	ld	s4,32(sp)
    80004f98:	6ae2                	ld	s5,24(sp)
    80004f9a:	6161                	add	sp,sp,80
    80004f9c:	8082                	ret
    iunlockput(ip);
    80004f9e:	8526                	mv	a0,s1
    80004fa0:	fffff097          	auipc	ra,0xfffff
    80004fa4:	8b4080e7          	jalr	-1868(ra) # 80003854 <iunlockput>
    return 0;
    80004fa8:	4481                	li	s1,0
    80004faa:	b7c5                	j	80004f8a <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004fac:	85d6                	mv	a1,s5
    80004fae:	00092503          	lw	a0,0(s2)
    80004fb2:	ffffe097          	auipc	ra,0xffffe
    80004fb6:	4ac080e7          	jalr	1196(ra) # 8000345e <ialloc>
    80004fba:	84aa                	mv	s1,a0
    80004fbc:	c139                	beqz	a0,80005002 <create+0xe8>
  ilock(ip);
    80004fbe:	ffffe097          	auipc	ra,0xffffe
    80004fc2:	634080e7          	jalr	1588(ra) # 800035f2 <ilock>
  ip->major = major;
    80004fc6:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    80004fca:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    80004fce:	4985                	li	s3,1
    80004fd0:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    80004fd4:	8526                	mv	a0,s1
    80004fd6:	ffffe097          	auipc	ra,0xffffe
    80004fda:	550080e7          	jalr	1360(ra) # 80003526 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004fde:	033a8a63          	beq	s5,s3,80005012 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    80004fe2:	40d0                	lw	a2,4(s1)
    80004fe4:	fb040593          	add	a1,s0,-80
    80004fe8:	854a                	mv	a0,s2
    80004fea:	fffff097          	auipc	ra,0xfffff
    80004fee:	cfa080e7          	jalr	-774(ra) # 80003ce4 <dirlink>
    80004ff2:	06054b63          	bltz	a0,80005068 <create+0x14e>
  iunlockput(dp);
    80004ff6:	854a                	mv	a0,s2
    80004ff8:	fffff097          	auipc	ra,0xfffff
    80004ffc:	85c080e7          	jalr	-1956(ra) # 80003854 <iunlockput>
  return ip;
    80005000:	b769                	j	80004f8a <create+0x70>
    panic("create: ialloc");
    80005002:	00003517          	auipc	a0,0x3
    80005006:	6d650513          	add	a0,a0,1750 # 800086d8 <syscalls+0x2b0>
    8000500a:	ffffb097          	auipc	ra,0xffffb
    8000500e:	538080e7          	jalr	1336(ra) # 80000542 <panic>
    dp->nlink++;  // for ".."
    80005012:	04a95783          	lhu	a5,74(s2)
    80005016:	2785                	addw	a5,a5,1
    80005018:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000501c:	854a                	mv	a0,s2
    8000501e:	ffffe097          	auipc	ra,0xffffe
    80005022:	508080e7          	jalr	1288(ra) # 80003526 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005026:	40d0                	lw	a2,4(s1)
    80005028:	00003597          	auipc	a1,0x3
    8000502c:	6c058593          	add	a1,a1,1728 # 800086e8 <syscalls+0x2c0>
    80005030:	8526                	mv	a0,s1
    80005032:	fffff097          	auipc	ra,0xfffff
    80005036:	cb2080e7          	jalr	-846(ra) # 80003ce4 <dirlink>
    8000503a:	00054f63          	bltz	a0,80005058 <create+0x13e>
    8000503e:	00492603          	lw	a2,4(s2)
    80005042:	00003597          	auipc	a1,0x3
    80005046:	6ae58593          	add	a1,a1,1710 # 800086f0 <syscalls+0x2c8>
    8000504a:	8526                	mv	a0,s1
    8000504c:	fffff097          	auipc	ra,0xfffff
    80005050:	c98080e7          	jalr	-872(ra) # 80003ce4 <dirlink>
    80005054:	f80557e3          	bgez	a0,80004fe2 <create+0xc8>
      panic("create dots");
    80005058:	00003517          	auipc	a0,0x3
    8000505c:	6a050513          	add	a0,a0,1696 # 800086f8 <syscalls+0x2d0>
    80005060:	ffffb097          	auipc	ra,0xffffb
    80005064:	4e2080e7          	jalr	1250(ra) # 80000542 <panic>
    panic("create: dirlink");
    80005068:	00003517          	auipc	a0,0x3
    8000506c:	6a050513          	add	a0,a0,1696 # 80008708 <syscalls+0x2e0>
    80005070:	ffffb097          	auipc	ra,0xffffb
    80005074:	4d2080e7          	jalr	1234(ra) # 80000542 <panic>
    return 0;
    80005078:	84aa                	mv	s1,a0
    8000507a:	bf01                	j	80004f8a <create+0x70>

000000008000507c <sys_dup>:
{
    8000507c:	7179                	add	sp,sp,-48
    8000507e:	f406                	sd	ra,40(sp)
    80005080:	f022                	sd	s0,32(sp)
    80005082:	ec26                	sd	s1,24(sp)
    80005084:	e84a                	sd	s2,16(sp)
    80005086:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005088:	fd840613          	add	a2,s0,-40
    8000508c:	4581                	li	a1,0
    8000508e:	4501                	li	a0,0
    80005090:	00000097          	auipc	ra,0x0
    80005094:	de0080e7          	jalr	-544(ra) # 80004e70 <argfd>
    return -1;
    80005098:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000509a:	02054363          	bltz	a0,800050c0 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    8000509e:	fd843903          	ld	s2,-40(s0)
    800050a2:	854a                	mv	a0,s2
    800050a4:	00000097          	auipc	ra,0x0
    800050a8:	e34080e7          	jalr	-460(ra) # 80004ed8 <fdalloc>
    800050ac:	84aa                	mv	s1,a0
    return -1;
    800050ae:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800050b0:	00054863          	bltz	a0,800050c0 <sys_dup+0x44>
  filedup(f);
    800050b4:	854a                	mv	a0,s2
    800050b6:	fffff097          	auipc	ra,0xfffff
    800050ba:	358080e7          	jalr	856(ra) # 8000440e <filedup>
  return fd;
    800050be:	87a6                	mv	a5,s1
}
    800050c0:	853e                	mv	a0,a5
    800050c2:	70a2                	ld	ra,40(sp)
    800050c4:	7402                	ld	s0,32(sp)
    800050c6:	64e2                	ld	s1,24(sp)
    800050c8:	6942                	ld	s2,16(sp)
    800050ca:	6145                	add	sp,sp,48
    800050cc:	8082                	ret

00000000800050ce <sys_read>:
{
    800050ce:	7179                	add	sp,sp,-48
    800050d0:	f406                	sd	ra,40(sp)
    800050d2:	f022                	sd	s0,32(sp)
    800050d4:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800050d6:	fe840613          	add	a2,s0,-24
    800050da:	4581                	li	a1,0
    800050dc:	4501                	li	a0,0
    800050de:	00000097          	auipc	ra,0x0
    800050e2:	d92080e7          	jalr	-622(ra) # 80004e70 <argfd>
    return -1;
    800050e6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800050e8:	04054163          	bltz	a0,8000512a <sys_read+0x5c>
    800050ec:	fe440593          	add	a1,s0,-28
    800050f0:	4509                	li	a0,2
    800050f2:	ffffe097          	auipc	ra,0xffffe
    800050f6:	996080e7          	jalr	-1642(ra) # 80002a88 <argint>
    return -1;
    800050fa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800050fc:	02054763          	bltz	a0,8000512a <sys_read+0x5c>
    80005100:	fd840593          	add	a1,s0,-40
    80005104:	4505                	li	a0,1
    80005106:	ffffe097          	auipc	ra,0xffffe
    8000510a:	9a4080e7          	jalr	-1628(ra) # 80002aaa <argaddr>
    return -1;
    8000510e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005110:	00054d63          	bltz	a0,8000512a <sys_read+0x5c>
  return fileread(f, p, n);
    80005114:	fe442603          	lw	a2,-28(s0)
    80005118:	fd843583          	ld	a1,-40(s0)
    8000511c:	fe843503          	ld	a0,-24(s0)
    80005120:	fffff097          	auipc	ra,0xfffff
    80005124:	47a080e7          	jalr	1146(ra) # 8000459a <fileread>
    80005128:	87aa                	mv	a5,a0
}
    8000512a:	853e                	mv	a0,a5
    8000512c:	70a2                	ld	ra,40(sp)
    8000512e:	7402                	ld	s0,32(sp)
    80005130:	6145                	add	sp,sp,48
    80005132:	8082                	ret

0000000080005134 <sys_write>:
{
    80005134:	7179                	add	sp,sp,-48
    80005136:	f406                	sd	ra,40(sp)
    80005138:	f022                	sd	s0,32(sp)
    8000513a:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000513c:	fe840613          	add	a2,s0,-24
    80005140:	4581                	li	a1,0
    80005142:	4501                	li	a0,0
    80005144:	00000097          	auipc	ra,0x0
    80005148:	d2c080e7          	jalr	-724(ra) # 80004e70 <argfd>
    return -1;
    8000514c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000514e:	04054163          	bltz	a0,80005190 <sys_write+0x5c>
    80005152:	fe440593          	add	a1,s0,-28
    80005156:	4509                	li	a0,2
    80005158:	ffffe097          	auipc	ra,0xffffe
    8000515c:	930080e7          	jalr	-1744(ra) # 80002a88 <argint>
    return -1;
    80005160:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005162:	02054763          	bltz	a0,80005190 <sys_write+0x5c>
    80005166:	fd840593          	add	a1,s0,-40
    8000516a:	4505                	li	a0,1
    8000516c:	ffffe097          	auipc	ra,0xffffe
    80005170:	93e080e7          	jalr	-1730(ra) # 80002aaa <argaddr>
    return -1;
    80005174:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005176:	00054d63          	bltz	a0,80005190 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000517a:	fe442603          	lw	a2,-28(s0)
    8000517e:	fd843583          	ld	a1,-40(s0)
    80005182:	fe843503          	ld	a0,-24(s0)
    80005186:	fffff097          	auipc	ra,0xfffff
    8000518a:	4d6080e7          	jalr	1238(ra) # 8000465c <filewrite>
    8000518e:	87aa                	mv	a5,a0
}
    80005190:	853e                	mv	a0,a5
    80005192:	70a2                	ld	ra,40(sp)
    80005194:	7402                	ld	s0,32(sp)
    80005196:	6145                	add	sp,sp,48
    80005198:	8082                	ret

000000008000519a <sys_close>:
{
    8000519a:	1101                	add	sp,sp,-32
    8000519c:	ec06                	sd	ra,24(sp)
    8000519e:	e822                	sd	s0,16(sp)
    800051a0:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800051a2:	fe040613          	add	a2,s0,-32
    800051a6:	fec40593          	add	a1,s0,-20
    800051aa:	4501                	li	a0,0
    800051ac:	00000097          	auipc	ra,0x0
    800051b0:	cc4080e7          	jalr	-828(ra) # 80004e70 <argfd>
    return -1;
    800051b4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800051b6:	02054463          	bltz	a0,800051de <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800051ba:	ffffd097          	auipc	ra,0xffffd
    800051be:	80c080e7          	jalr	-2036(ra) # 800019c6 <myproc>
    800051c2:	fec42783          	lw	a5,-20(s0)
    800051c6:	07e9                	add	a5,a5,26
    800051c8:	078e                	sll	a5,a5,0x3
    800051ca:	953e                	add	a0,a0,a5
    800051cc:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800051d0:	fe043503          	ld	a0,-32(s0)
    800051d4:	fffff097          	auipc	ra,0xfffff
    800051d8:	28c080e7          	jalr	652(ra) # 80004460 <fileclose>
  return 0;
    800051dc:	4781                	li	a5,0
}
    800051de:	853e                	mv	a0,a5
    800051e0:	60e2                	ld	ra,24(sp)
    800051e2:	6442                	ld	s0,16(sp)
    800051e4:	6105                	add	sp,sp,32
    800051e6:	8082                	ret

00000000800051e8 <sys_fstat>:
{
    800051e8:	1101                	add	sp,sp,-32
    800051ea:	ec06                	sd	ra,24(sp)
    800051ec:	e822                	sd	s0,16(sp)
    800051ee:	1000                	add	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800051f0:	fe840613          	add	a2,s0,-24
    800051f4:	4581                	li	a1,0
    800051f6:	4501                	li	a0,0
    800051f8:	00000097          	auipc	ra,0x0
    800051fc:	c78080e7          	jalr	-904(ra) # 80004e70 <argfd>
    return -1;
    80005200:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005202:	02054563          	bltz	a0,8000522c <sys_fstat+0x44>
    80005206:	fe040593          	add	a1,s0,-32
    8000520a:	4505                	li	a0,1
    8000520c:	ffffe097          	auipc	ra,0xffffe
    80005210:	89e080e7          	jalr	-1890(ra) # 80002aaa <argaddr>
    return -1;
    80005214:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005216:	00054b63          	bltz	a0,8000522c <sys_fstat+0x44>
  return filestat(f, st);
    8000521a:	fe043583          	ld	a1,-32(s0)
    8000521e:	fe843503          	ld	a0,-24(s0)
    80005222:	fffff097          	auipc	ra,0xfffff
    80005226:	306080e7          	jalr	774(ra) # 80004528 <filestat>
    8000522a:	87aa                	mv	a5,a0
}
    8000522c:	853e                	mv	a0,a5
    8000522e:	60e2                	ld	ra,24(sp)
    80005230:	6442                	ld	s0,16(sp)
    80005232:	6105                	add	sp,sp,32
    80005234:	8082                	ret

0000000080005236 <sys_link>:
{
    80005236:	7169                	add	sp,sp,-304
    80005238:	f606                	sd	ra,296(sp)
    8000523a:	f222                	sd	s0,288(sp)
    8000523c:	ee26                	sd	s1,280(sp)
    8000523e:	ea4a                	sd	s2,272(sp)
    80005240:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005242:	08000613          	li	a2,128
    80005246:	ed040593          	add	a1,s0,-304
    8000524a:	4501                	li	a0,0
    8000524c:	ffffe097          	auipc	ra,0xffffe
    80005250:	880080e7          	jalr	-1920(ra) # 80002acc <argstr>
    return -1;
    80005254:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005256:	10054e63          	bltz	a0,80005372 <sys_link+0x13c>
    8000525a:	08000613          	li	a2,128
    8000525e:	f5040593          	add	a1,s0,-176
    80005262:	4505                	li	a0,1
    80005264:	ffffe097          	auipc	ra,0xffffe
    80005268:	868080e7          	jalr	-1944(ra) # 80002acc <argstr>
    return -1;
    8000526c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000526e:	10054263          	bltz	a0,80005372 <sys_link+0x13c>
  begin_op();
    80005272:	fffff097          	auipc	ra,0xfffff
    80005276:	d24080e7          	jalr	-732(ra) # 80003f96 <begin_op>
  if((ip = namei(old)) == 0){
    8000527a:	ed040513          	add	a0,s0,-304
    8000527e:	fffff097          	auipc	ra,0xfffff
    80005282:	b28080e7          	jalr	-1240(ra) # 80003da6 <namei>
    80005286:	84aa                	mv	s1,a0
    80005288:	c551                	beqz	a0,80005314 <sys_link+0xde>
  ilock(ip);
    8000528a:	ffffe097          	auipc	ra,0xffffe
    8000528e:	368080e7          	jalr	872(ra) # 800035f2 <ilock>
  if(ip->type == T_DIR){
    80005292:	04449703          	lh	a4,68(s1)
    80005296:	4785                	li	a5,1
    80005298:	08f70463          	beq	a4,a5,80005320 <sys_link+0xea>
  ip->nlink++;
    8000529c:	04a4d783          	lhu	a5,74(s1)
    800052a0:	2785                	addw	a5,a5,1
    800052a2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800052a6:	8526                	mv	a0,s1
    800052a8:	ffffe097          	auipc	ra,0xffffe
    800052ac:	27e080e7          	jalr	638(ra) # 80003526 <iupdate>
  iunlock(ip);
    800052b0:	8526                	mv	a0,s1
    800052b2:	ffffe097          	auipc	ra,0xffffe
    800052b6:	402080e7          	jalr	1026(ra) # 800036b4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800052ba:	fd040593          	add	a1,s0,-48
    800052be:	f5040513          	add	a0,s0,-176
    800052c2:	fffff097          	auipc	ra,0xfffff
    800052c6:	b02080e7          	jalr	-1278(ra) # 80003dc4 <nameiparent>
    800052ca:	892a                	mv	s2,a0
    800052cc:	c935                	beqz	a0,80005340 <sys_link+0x10a>
  ilock(dp);
    800052ce:	ffffe097          	auipc	ra,0xffffe
    800052d2:	324080e7          	jalr	804(ra) # 800035f2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800052d6:	00092703          	lw	a4,0(s2)
    800052da:	409c                	lw	a5,0(s1)
    800052dc:	04f71d63          	bne	a4,a5,80005336 <sys_link+0x100>
    800052e0:	40d0                	lw	a2,4(s1)
    800052e2:	fd040593          	add	a1,s0,-48
    800052e6:	854a                	mv	a0,s2
    800052e8:	fffff097          	auipc	ra,0xfffff
    800052ec:	9fc080e7          	jalr	-1540(ra) # 80003ce4 <dirlink>
    800052f0:	04054363          	bltz	a0,80005336 <sys_link+0x100>
  iunlockput(dp);
    800052f4:	854a                	mv	a0,s2
    800052f6:	ffffe097          	auipc	ra,0xffffe
    800052fa:	55e080e7          	jalr	1374(ra) # 80003854 <iunlockput>
  iput(ip);
    800052fe:	8526                	mv	a0,s1
    80005300:	ffffe097          	auipc	ra,0xffffe
    80005304:	4ac080e7          	jalr	1196(ra) # 800037ac <iput>
  end_op();
    80005308:	fffff097          	auipc	ra,0xfffff
    8000530c:	d08080e7          	jalr	-760(ra) # 80004010 <end_op>
  return 0;
    80005310:	4781                	li	a5,0
    80005312:	a085                	j	80005372 <sys_link+0x13c>
    end_op();
    80005314:	fffff097          	auipc	ra,0xfffff
    80005318:	cfc080e7          	jalr	-772(ra) # 80004010 <end_op>
    return -1;
    8000531c:	57fd                	li	a5,-1
    8000531e:	a891                	j	80005372 <sys_link+0x13c>
    iunlockput(ip);
    80005320:	8526                	mv	a0,s1
    80005322:	ffffe097          	auipc	ra,0xffffe
    80005326:	532080e7          	jalr	1330(ra) # 80003854 <iunlockput>
    end_op();
    8000532a:	fffff097          	auipc	ra,0xfffff
    8000532e:	ce6080e7          	jalr	-794(ra) # 80004010 <end_op>
    return -1;
    80005332:	57fd                	li	a5,-1
    80005334:	a83d                	j	80005372 <sys_link+0x13c>
    iunlockput(dp);
    80005336:	854a                	mv	a0,s2
    80005338:	ffffe097          	auipc	ra,0xffffe
    8000533c:	51c080e7          	jalr	1308(ra) # 80003854 <iunlockput>
  ilock(ip);
    80005340:	8526                	mv	a0,s1
    80005342:	ffffe097          	auipc	ra,0xffffe
    80005346:	2b0080e7          	jalr	688(ra) # 800035f2 <ilock>
  ip->nlink--;
    8000534a:	04a4d783          	lhu	a5,74(s1)
    8000534e:	37fd                	addw	a5,a5,-1
    80005350:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005354:	8526                	mv	a0,s1
    80005356:	ffffe097          	auipc	ra,0xffffe
    8000535a:	1d0080e7          	jalr	464(ra) # 80003526 <iupdate>
  iunlockput(ip);
    8000535e:	8526                	mv	a0,s1
    80005360:	ffffe097          	auipc	ra,0xffffe
    80005364:	4f4080e7          	jalr	1268(ra) # 80003854 <iunlockput>
  end_op();
    80005368:	fffff097          	auipc	ra,0xfffff
    8000536c:	ca8080e7          	jalr	-856(ra) # 80004010 <end_op>
  return -1;
    80005370:	57fd                	li	a5,-1
}
    80005372:	853e                	mv	a0,a5
    80005374:	70b2                	ld	ra,296(sp)
    80005376:	7412                	ld	s0,288(sp)
    80005378:	64f2                	ld	s1,280(sp)
    8000537a:	6952                	ld	s2,272(sp)
    8000537c:	6155                	add	sp,sp,304
    8000537e:	8082                	ret

0000000080005380 <sys_unlink>:
{
    80005380:	7151                	add	sp,sp,-240
    80005382:	f586                	sd	ra,232(sp)
    80005384:	f1a2                	sd	s0,224(sp)
    80005386:	eda6                	sd	s1,216(sp)
    80005388:	e9ca                	sd	s2,208(sp)
    8000538a:	e5ce                	sd	s3,200(sp)
    8000538c:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000538e:	08000613          	li	a2,128
    80005392:	f3040593          	add	a1,s0,-208
    80005396:	4501                	li	a0,0
    80005398:	ffffd097          	auipc	ra,0xffffd
    8000539c:	734080e7          	jalr	1844(ra) # 80002acc <argstr>
    800053a0:	18054163          	bltz	a0,80005522 <sys_unlink+0x1a2>
  begin_op();
    800053a4:	fffff097          	auipc	ra,0xfffff
    800053a8:	bf2080e7          	jalr	-1038(ra) # 80003f96 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800053ac:	fb040593          	add	a1,s0,-80
    800053b0:	f3040513          	add	a0,s0,-208
    800053b4:	fffff097          	auipc	ra,0xfffff
    800053b8:	a10080e7          	jalr	-1520(ra) # 80003dc4 <nameiparent>
    800053bc:	84aa                	mv	s1,a0
    800053be:	c979                	beqz	a0,80005494 <sys_unlink+0x114>
  ilock(dp);
    800053c0:	ffffe097          	auipc	ra,0xffffe
    800053c4:	232080e7          	jalr	562(ra) # 800035f2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800053c8:	00003597          	auipc	a1,0x3
    800053cc:	32058593          	add	a1,a1,800 # 800086e8 <syscalls+0x2c0>
    800053d0:	fb040513          	add	a0,s0,-80
    800053d4:	ffffe097          	auipc	ra,0xffffe
    800053d8:	6e6080e7          	jalr	1766(ra) # 80003aba <namecmp>
    800053dc:	14050a63          	beqz	a0,80005530 <sys_unlink+0x1b0>
    800053e0:	00003597          	auipc	a1,0x3
    800053e4:	31058593          	add	a1,a1,784 # 800086f0 <syscalls+0x2c8>
    800053e8:	fb040513          	add	a0,s0,-80
    800053ec:	ffffe097          	auipc	ra,0xffffe
    800053f0:	6ce080e7          	jalr	1742(ra) # 80003aba <namecmp>
    800053f4:	12050e63          	beqz	a0,80005530 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800053f8:	f2c40613          	add	a2,s0,-212
    800053fc:	fb040593          	add	a1,s0,-80
    80005400:	8526                	mv	a0,s1
    80005402:	ffffe097          	auipc	ra,0xffffe
    80005406:	6d2080e7          	jalr	1746(ra) # 80003ad4 <dirlookup>
    8000540a:	892a                	mv	s2,a0
    8000540c:	12050263          	beqz	a0,80005530 <sys_unlink+0x1b0>
  ilock(ip);
    80005410:	ffffe097          	auipc	ra,0xffffe
    80005414:	1e2080e7          	jalr	482(ra) # 800035f2 <ilock>
  if(ip->nlink < 1)
    80005418:	04a91783          	lh	a5,74(s2)
    8000541c:	08f05263          	blez	a5,800054a0 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005420:	04491703          	lh	a4,68(s2)
    80005424:	4785                	li	a5,1
    80005426:	08f70563          	beq	a4,a5,800054b0 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    8000542a:	4641                	li	a2,16
    8000542c:	4581                	li	a1,0
    8000542e:	fc040513          	add	a0,s0,-64
    80005432:	ffffc097          	auipc	ra,0xffffc
    80005436:	8c6080e7          	jalr	-1850(ra) # 80000cf8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000543a:	4741                	li	a4,16
    8000543c:	f2c42683          	lw	a3,-212(s0)
    80005440:	fc040613          	add	a2,s0,-64
    80005444:	4581                	li	a1,0
    80005446:	8526                	mv	a0,s1
    80005448:	ffffe097          	auipc	ra,0xffffe
    8000544c:	556080e7          	jalr	1366(ra) # 8000399e <writei>
    80005450:	47c1                	li	a5,16
    80005452:	0af51563          	bne	a0,a5,800054fc <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005456:	04491703          	lh	a4,68(s2)
    8000545a:	4785                	li	a5,1
    8000545c:	0af70863          	beq	a4,a5,8000550c <sys_unlink+0x18c>
  iunlockput(dp);
    80005460:	8526                	mv	a0,s1
    80005462:	ffffe097          	auipc	ra,0xffffe
    80005466:	3f2080e7          	jalr	1010(ra) # 80003854 <iunlockput>
  ip->nlink--;
    8000546a:	04a95783          	lhu	a5,74(s2)
    8000546e:	37fd                	addw	a5,a5,-1
    80005470:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005474:	854a                	mv	a0,s2
    80005476:	ffffe097          	auipc	ra,0xffffe
    8000547a:	0b0080e7          	jalr	176(ra) # 80003526 <iupdate>
  iunlockput(ip);
    8000547e:	854a                	mv	a0,s2
    80005480:	ffffe097          	auipc	ra,0xffffe
    80005484:	3d4080e7          	jalr	980(ra) # 80003854 <iunlockput>
  end_op();
    80005488:	fffff097          	auipc	ra,0xfffff
    8000548c:	b88080e7          	jalr	-1144(ra) # 80004010 <end_op>
  return 0;
    80005490:	4501                	li	a0,0
    80005492:	a84d                	j	80005544 <sys_unlink+0x1c4>
    end_op();
    80005494:	fffff097          	auipc	ra,0xfffff
    80005498:	b7c080e7          	jalr	-1156(ra) # 80004010 <end_op>
    return -1;
    8000549c:	557d                	li	a0,-1
    8000549e:	a05d                	j	80005544 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800054a0:	00003517          	auipc	a0,0x3
    800054a4:	27850513          	add	a0,a0,632 # 80008718 <syscalls+0x2f0>
    800054a8:	ffffb097          	auipc	ra,0xffffb
    800054ac:	09a080e7          	jalr	154(ra) # 80000542 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800054b0:	04c92703          	lw	a4,76(s2)
    800054b4:	02000793          	li	a5,32
    800054b8:	f6e7f9e3          	bgeu	a5,a4,8000542a <sys_unlink+0xaa>
    800054bc:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800054c0:	4741                	li	a4,16
    800054c2:	86ce                	mv	a3,s3
    800054c4:	f1840613          	add	a2,s0,-232
    800054c8:	4581                	li	a1,0
    800054ca:	854a                	mv	a0,s2
    800054cc:	ffffe097          	auipc	ra,0xffffe
    800054d0:	3da080e7          	jalr	986(ra) # 800038a6 <readi>
    800054d4:	47c1                	li	a5,16
    800054d6:	00f51b63          	bne	a0,a5,800054ec <sys_unlink+0x16c>
    if(de.inum != 0)
    800054da:	f1845783          	lhu	a5,-232(s0)
    800054de:	e7a1                	bnez	a5,80005526 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800054e0:	29c1                	addw	s3,s3,16
    800054e2:	04c92783          	lw	a5,76(s2)
    800054e6:	fcf9ede3          	bltu	s3,a5,800054c0 <sys_unlink+0x140>
    800054ea:	b781                	j	8000542a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800054ec:	00003517          	auipc	a0,0x3
    800054f0:	24450513          	add	a0,a0,580 # 80008730 <syscalls+0x308>
    800054f4:	ffffb097          	auipc	ra,0xffffb
    800054f8:	04e080e7          	jalr	78(ra) # 80000542 <panic>
    panic("unlink: writei");
    800054fc:	00003517          	auipc	a0,0x3
    80005500:	24c50513          	add	a0,a0,588 # 80008748 <syscalls+0x320>
    80005504:	ffffb097          	auipc	ra,0xffffb
    80005508:	03e080e7          	jalr	62(ra) # 80000542 <panic>
    dp->nlink--;
    8000550c:	04a4d783          	lhu	a5,74(s1)
    80005510:	37fd                	addw	a5,a5,-1
    80005512:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005516:	8526                	mv	a0,s1
    80005518:	ffffe097          	auipc	ra,0xffffe
    8000551c:	00e080e7          	jalr	14(ra) # 80003526 <iupdate>
    80005520:	b781                	j	80005460 <sys_unlink+0xe0>
    return -1;
    80005522:	557d                	li	a0,-1
    80005524:	a005                	j	80005544 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005526:	854a                	mv	a0,s2
    80005528:	ffffe097          	auipc	ra,0xffffe
    8000552c:	32c080e7          	jalr	812(ra) # 80003854 <iunlockput>
  iunlockput(dp);
    80005530:	8526                	mv	a0,s1
    80005532:	ffffe097          	auipc	ra,0xffffe
    80005536:	322080e7          	jalr	802(ra) # 80003854 <iunlockput>
  end_op();
    8000553a:	fffff097          	auipc	ra,0xfffff
    8000553e:	ad6080e7          	jalr	-1322(ra) # 80004010 <end_op>
  return -1;
    80005542:	557d                	li	a0,-1
}
    80005544:	70ae                	ld	ra,232(sp)
    80005546:	740e                	ld	s0,224(sp)
    80005548:	64ee                	ld	s1,216(sp)
    8000554a:	694e                	ld	s2,208(sp)
    8000554c:	69ae                	ld	s3,200(sp)
    8000554e:	616d                	add	sp,sp,240
    80005550:	8082                	ret

0000000080005552 <sys_open>:

uint64
sys_open(void)
{
    80005552:	7131                	add	sp,sp,-192
    80005554:	fd06                	sd	ra,184(sp)
    80005556:	f922                	sd	s0,176(sp)
    80005558:	f526                	sd	s1,168(sp)
    8000555a:	f14a                	sd	s2,160(sp)
    8000555c:	ed4e                	sd	s3,152(sp)
    8000555e:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005560:	08000613          	li	a2,128
    80005564:	f5040593          	add	a1,s0,-176
    80005568:	4501                	li	a0,0
    8000556a:	ffffd097          	auipc	ra,0xffffd
    8000556e:	562080e7          	jalr	1378(ra) # 80002acc <argstr>
    return -1;
    80005572:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005574:	0c054063          	bltz	a0,80005634 <sys_open+0xe2>
    80005578:	f4c40593          	add	a1,s0,-180
    8000557c:	4505                	li	a0,1
    8000557e:	ffffd097          	auipc	ra,0xffffd
    80005582:	50a080e7          	jalr	1290(ra) # 80002a88 <argint>
    80005586:	0a054763          	bltz	a0,80005634 <sys_open+0xe2>

  begin_op();
    8000558a:	fffff097          	auipc	ra,0xfffff
    8000558e:	a0c080e7          	jalr	-1524(ra) # 80003f96 <begin_op>

  if(omode & O_CREATE){
    80005592:	f4c42783          	lw	a5,-180(s0)
    80005596:	2007f793          	and	a5,a5,512
    8000559a:	cbd5                	beqz	a5,8000564e <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    8000559c:	4681                	li	a3,0
    8000559e:	4601                	li	a2,0
    800055a0:	4589                	li	a1,2
    800055a2:	f5040513          	add	a0,s0,-176
    800055a6:	00000097          	auipc	ra,0x0
    800055aa:	974080e7          	jalr	-1676(ra) # 80004f1a <create>
    800055ae:	892a                	mv	s2,a0
    if(ip == 0){
    800055b0:	c951                	beqz	a0,80005644 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800055b2:	04491703          	lh	a4,68(s2)
    800055b6:	478d                	li	a5,3
    800055b8:	00f71763          	bne	a4,a5,800055c6 <sys_open+0x74>
    800055bc:	04695703          	lhu	a4,70(s2)
    800055c0:	47a5                	li	a5,9
    800055c2:	0ce7eb63          	bltu	a5,a4,80005698 <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800055c6:	fffff097          	auipc	ra,0xfffff
    800055ca:	dde080e7          	jalr	-546(ra) # 800043a4 <filealloc>
    800055ce:	89aa                	mv	s3,a0
    800055d0:	c565                	beqz	a0,800056b8 <sys_open+0x166>
    800055d2:	00000097          	auipc	ra,0x0
    800055d6:	906080e7          	jalr	-1786(ra) # 80004ed8 <fdalloc>
    800055da:	84aa                	mv	s1,a0
    800055dc:	0c054963          	bltz	a0,800056ae <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800055e0:	04491703          	lh	a4,68(s2)
    800055e4:	478d                	li	a5,3
    800055e6:	0ef70463          	beq	a4,a5,800056ce <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800055ea:	4789                	li	a5,2
    800055ec:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    800055f0:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    800055f4:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    800055f8:	f4c42783          	lw	a5,-180(s0)
    800055fc:	0017c713          	xor	a4,a5,1
    80005600:	8b05                	and	a4,a4,1
    80005602:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005606:	0037f713          	and	a4,a5,3
    8000560a:	00e03733          	snez	a4,a4
    8000560e:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005612:	4007f793          	and	a5,a5,1024
    80005616:	c791                	beqz	a5,80005622 <sys_open+0xd0>
    80005618:	04491703          	lh	a4,68(s2)
    8000561c:	4789                	li	a5,2
    8000561e:	0af70f63          	beq	a4,a5,800056dc <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80005622:	854a                	mv	a0,s2
    80005624:	ffffe097          	auipc	ra,0xffffe
    80005628:	090080e7          	jalr	144(ra) # 800036b4 <iunlock>
  end_op();
    8000562c:	fffff097          	auipc	ra,0xfffff
    80005630:	9e4080e7          	jalr	-1564(ra) # 80004010 <end_op>

  return fd;
}
    80005634:	8526                	mv	a0,s1
    80005636:	70ea                	ld	ra,184(sp)
    80005638:	744a                	ld	s0,176(sp)
    8000563a:	74aa                	ld	s1,168(sp)
    8000563c:	790a                	ld	s2,160(sp)
    8000563e:	69ea                	ld	s3,152(sp)
    80005640:	6129                	add	sp,sp,192
    80005642:	8082                	ret
      end_op();
    80005644:	fffff097          	auipc	ra,0xfffff
    80005648:	9cc080e7          	jalr	-1588(ra) # 80004010 <end_op>
      return -1;
    8000564c:	b7e5                	j	80005634 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    8000564e:	f5040513          	add	a0,s0,-176
    80005652:	ffffe097          	auipc	ra,0xffffe
    80005656:	754080e7          	jalr	1876(ra) # 80003da6 <namei>
    8000565a:	892a                	mv	s2,a0
    8000565c:	c905                	beqz	a0,8000568c <sys_open+0x13a>
    ilock(ip);
    8000565e:	ffffe097          	auipc	ra,0xffffe
    80005662:	f94080e7          	jalr	-108(ra) # 800035f2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005666:	04491703          	lh	a4,68(s2)
    8000566a:	4785                	li	a5,1
    8000566c:	f4f713e3          	bne	a4,a5,800055b2 <sys_open+0x60>
    80005670:	f4c42783          	lw	a5,-180(s0)
    80005674:	dba9                	beqz	a5,800055c6 <sys_open+0x74>
      iunlockput(ip);
    80005676:	854a                	mv	a0,s2
    80005678:	ffffe097          	auipc	ra,0xffffe
    8000567c:	1dc080e7          	jalr	476(ra) # 80003854 <iunlockput>
      end_op();
    80005680:	fffff097          	auipc	ra,0xfffff
    80005684:	990080e7          	jalr	-1648(ra) # 80004010 <end_op>
      return -1;
    80005688:	54fd                	li	s1,-1
    8000568a:	b76d                	j	80005634 <sys_open+0xe2>
      end_op();
    8000568c:	fffff097          	auipc	ra,0xfffff
    80005690:	984080e7          	jalr	-1660(ra) # 80004010 <end_op>
      return -1;
    80005694:	54fd                	li	s1,-1
    80005696:	bf79                	j	80005634 <sys_open+0xe2>
    iunlockput(ip);
    80005698:	854a                	mv	a0,s2
    8000569a:	ffffe097          	auipc	ra,0xffffe
    8000569e:	1ba080e7          	jalr	442(ra) # 80003854 <iunlockput>
    end_op();
    800056a2:	fffff097          	auipc	ra,0xfffff
    800056a6:	96e080e7          	jalr	-1682(ra) # 80004010 <end_op>
    return -1;
    800056aa:	54fd                	li	s1,-1
    800056ac:	b761                	j	80005634 <sys_open+0xe2>
      fileclose(f);
    800056ae:	854e                	mv	a0,s3
    800056b0:	fffff097          	auipc	ra,0xfffff
    800056b4:	db0080e7          	jalr	-592(ra) # 80004460 <fileclose>
    iunlockput(ip);
    800056b8:	854a                	mv	a0,s2
    800056ba:	ffffe097          	auipc	ra,0xffffe
    800056be:	19a080e7          	jalr	410(ra) # 80003854 <iunlockput>
    end_op();
    800056c2:	fffff097          	auipc	ra,0xfffff
    800056c6:	94e080e7          	jalr	-1714(ra) # 80004010 <end_op>
    return -1;
    800056ca:	54fd                	li	s1,-1
    800056cc:	b7a5                	j	80005634 <sys_open+0xe2>
    f->type = FD_DEVICE;
    800056ce:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    800056d2:	04691783          	lh	a5,70(s2)
    800056d6:	02f99223          	sh	a5,36(s3)
    800056da:	bf29                	j	800055f4 <sys_open+0xa2>
    itrunc(ip);
    800056dc:	854a                	mv	a0,s2
    800056de:	ffffe097          	auipc	ra,0xffffe
    800056e2:	022080e7          	jalr	34(ra) # 80003700 <itrunc>
    800056e6:	bf35                	j	80005622 <sys_open+0xd0>

00000000800056e8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800056e8:	7175                	add	sp,sp,-144
    800056ea:	e506                	sd	ra,136(sp)
    800056ec:	e122                	sd	s0,128(sp)
    800056ee:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800056f0:	fffff097          	auipc	ra,0xfffff
    800056f4:	8a6080e7          	jalr	-1882(ra) # 80003f96 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800056f8:	08000613          	li	a2,128
    800056fc:	f7040593          	add	a1,s0,-144
    80005700:	4501                	li	a0,0
    80005702:	ffffd097          	auipc	ra,0xffffd
    80005706:	3ca080e7          	jalr	970(ra) # 80002acc <argstr>
    8000570a:	02054963          	bltz	a0,8000573c <sys_mkdir+0x54>
    8000570e:	4681                	li	a3,0
    80005710:	4601                	li	a2,0
    80005712:	4585                	li	a1,1
    80005714:	f7040513          	add	a0,s0,-144
    80005718:	00000097          	auipc	ra,0x0
    8000571c:	802080e7          	jalr	-2046(ra) # 80004f1a <create>
    80005720:	cd11                	beqz	a0,8000573c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005722:	ffffe097          	auipc	ra,0xffffe
    80005726:	132080e7          	jalr	306(ra) # 80003854 <iunlockput>
  end_op();
    8000572a:	fffff097          	auipc	ra,0xfffff
    8000572e:	8e6080e7          	jalr	-1818(ra) # 80004010 <end_op>
  return 0;
    80005732:	4501                	li	a0,0
}
    80005734:	60aa                	ld	ra,136(sp)
    80005736:	640a                	ld	s0,128(sp)
    80005738:	6149                	add	sp,sp,144
    8000573a:	8082                	ret
    end_op();
    8000573c:	fffff097          	auipc	ra,0xfffff
    80005740:	8d4080e7          	jalr	-1836(ra) # 80004010 <end_op>
    return -1;
    80005744:	557d                	li	a0,-1
    80005746:	b7fd                	j	80005734 <sys_mkdir+0x4c>

0000000080005748 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005748:	7135                	add	sp,sp,-160
    8000574a:	ed06                	sd	ra,152(sp)
    8000574c:	e922                	sd	s0,144(sp)
    8000574e:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005750:	fffff097          	auipc	ra,0xfffff
    80005754:	846080e7          	jalr	-1978(ra) # 80003f96 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005758:	08000613          	li	a2,128
    8000575c:	f7040593          	add	a1,s0,-144
    80005760:	4501                	li	a0,0
    80005762:	ffffd097          	auipc	ra,0xffffd
    80005766:	36a080e7          	jalr	874(ra) # 80002acc <argstr>
    8000576a:	04054a63          	bltz	a0,800057be <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    8000576e:	f6c40593          	add	a1,s0,-148
    80005772:	4505                	li	a0,1
    80005774:	ffffd097          	auipc	ra,0xffffd
    80005778:	314080e7          	jalr	788(ra) # 80002a88 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000577c:	04054163          	bltz	a0,800057be <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005780:	f6840593          	add	a1,s0,-152
    80005784:	4509                	li	a0,2
    80005786:	ffffd097          	auipc	ra,0xffffd
    8000578a:	302080e7          	jalr	770(ra) # 80002a88 <argint>
     argint(1, &major) < 0 ||
    8000578e:	02054863          	bltz	a0,800057be <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005792:	f6841683          	lh	a3,-152(s0)
    80005796:	f6c41603          	lh	a2,-148(s0)
    8000579a:	458d                	li	a1,3
    8000579c:	f7040513          	add	a0,s0,-144
    800057a0:	fffff097          	auipc	ra,0xfffff
    800057a4:	77a080e7          	jalr	1914(ra) # 80004f1a <create>
     argint(2, &minor) < 0 ||
    800057a8:	c919                	beqz	a0,800057be <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800057aa:	ffffe097          	auipc	ra,0xffffe
    800057ae:	0aa080e7          	jalr	170(ra) # 80003854 <iunlockput>
  end_op();
    800057b2:	fffff097          	auipc	ra,0xfffff
    800057b6:	85e080e7          	jalr	-1954(ra) # 80004010 <end_op>
  return 0;
    800057ba:	4501                	li	a0,0
    800057bc:	a031                	j	800057c8 <sys_mknod+0x80>
    end_op();
    800057be:	fffff097          	auipc	ra,0xfffff
    800057c2:	852080e7          	jalr	-1966(ra) # 80004010 <end_op>
    return -1;
    800057c6:	557d                	li	a0,-1
}
    800057c8:	60ea                	ld	ra,152(sp)
    800057ca:	644a                	ld	s0,144(sp)
    800057cc:	610d                	add	sp,sp,160
    800057ce:	8082                	ret

00000000800057d0 <sys_chdir>:

uint64
sys_chdir(void)
{
    800057d0:	7135                	add	sp,sp,-160
    800057d2:	ed06                	sd	ra,152(sp)
    800057d4:	e922                	sd	s0,144(sp)
    800057d6:	e526                	sd	s1,136(sp)
    800057d8:	e14a                	sd	s2,128(sp)
    800057da:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800057dc:	ffffc097          	auipc	ra,0xffffc
    800057e0:	1ea080e7          	jalr	490(ra) # 800019c6 <myproc>
    800057e4:	892a                	mv	s2,a0
  
  begin_op();
    800057e6:	ffffe097          	auipc	ra,0xffffe
    800057ea:	7b0080e7          	jalr	1968(ra) # 80003f96 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800057ee:	08000613          	li	a2,128
    800057f2:	f6040593          	add	a1,s0,-160
    800057f6:	4501                	li	a0,0
    800057f8:	ffffd097          	auipc	ra,0xffffd
    800057fc:	2d4080e7          	jalr	724(ra) # 80002acc <argstr>
    80005800:	04054b63          	bltz	a0,80005856 <sys_chdir+0x86>
    80005804:	f6040513          	add	a0,s0,-160
    80005808:	ffffe097          	auipc	ra,0xffffe
    8000580c:	59e080e7          	jalr	1438(ra) # 80003da6 <namei>
    80005810:	84aa                	mv	s1,a0
    80005812:	c131                	beqz	a0,80005856 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005814:	ffffe097          	auipc	ra,0xffffe
    80005818:	dde080e7          	jalr	-546(ra) # 800035f2 <ilock>
  if(ip->type != T_DIR){
    8000581c:	04449703          	lh	a4,68(s1)
    80005820:	4785                	li	a5,1
    80005822:	04f71063          	bne	a4,a5,80005862 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005826:	8526                	mv	a0,s1
    80005828:	ffffe097          	auipc	ra,0xffffe
    8000582c:	e8c080e7          	jalr	-372(ra) # 800036b4 <iunlock>
  iput(p->cwd);
    80005830:	15093503          	ld	a0,336(s2)
    80005834:	ffffe097          	auipc	ra,0xffffe
    80005838:	f78080e7          	jalr	-136(ra) # 800037ac <iput>
  end_op();
    8000583c:	ffffe097          	auipc	ra,0xffffe
    80005840:	7d4080e7          	jalr	2004(ra) # 80004010 <end_op>
  p->cwd = ip;
    80005844:	14993823          	sd	s1,336(s2)
  return 0;
    80005848:	4501                	li	a0,0
}
    8000584a:	60ea                	ld	ra,152(sp)
    8000584c:	644a                	ld	s0,144(sp)
    8000584e:	64aa                	ld	s1,136(sp)
    80005850:	690a                	ld	s2,128(sp)
    80005852:	610d                	add	sp,sp,160
    80005854:	8082                	ret
    end_op();
    80005856:	ffffe097          	auipc	ra,0xffffe
    8000585a:	7ba080e7          	jalr	1978(ra) # 80004010 <end_op>
    return -1;
    8000585e:	557d                	li	a0,-1
    80005860:	b7ed                	j	8000584a <sys_chdir+0x7a>
    iunlockput(ip);
    80005862:	8526                	mv	a0,s1
    80005864:	ffffe097          	auipc	ra,0xffffe
    80005868:	ff0080e7          	jalr	-16(ra) # 80003854 <iunlockput>
    end_op();
    8000586c:	ffffe097          	auipc	ra,0xffffe
    80005870:	7a4080e7          	jalr	1956(ra) # 80004010 <end_op>
    return -1;
    80005874:	557d                	li	a0,-1
    80005876:	bfd1                	j	8000584a <sys_chdir+0x7a>

0000000080005878 <sys_exec>:

uint64
sys_exec(void)
{
    80005878:	7121                	add	sp,sp,-448
    8000587a:	ff06                	sd	ra,440(sp)
    8000587c:	fb22                	sd	s0,432(sp)
    8000587e:	f726                	sd	s1,424(sp)
    80005880:	f34a                	sd	s2,416(sp)
    80005882:	ef4e                	sd	s3,408(sp)
    80005884:	eb52                	sd	s4,400(sp)
    80005886:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005888:	08000613          	li	a2,128
    8000588c:	f5040593          	add	a1,s0,-176
    80005890:	4501                	li	a0,0
    80005892:	ffffd097          	auipc	ra,0xffffd
    80005896:	23a080e7          	jalr	570(ra) # 80002acc <argstr>
    return -1;
    8000589a:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000589c:	0c054a63          	bltz	a0,80005970 <sys_exec+0xf8>
    800058a0:	e4840593          	add	a1,s0,-440
    800058a4:	4505                	li	a0,1
    800058a6:	ffffd097          	auipc	ra,0xffffd
    800058aa:	204080e7          	jalr	516(ra) # 80002aaa <argaddr>
    800058ae:	0c054163          	bltz	a0,80005970 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    800058b2:	10000613          	li	a2,256
    800058b6:	4581                	li	a1,0
    800058b8:	e5040513          	add	a0,s0,-432
    800058bc:	ffffb097          	auipc	ra,0xffffb
    800058c0:	43c080e7          	jalr	1084(ra) # 80000cf8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800058c4:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800058c8:	89a6                	mv	s3,s1
    800058ca:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800058cc:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800058d0:	00391513          	sll	a0,s2,0x3
    800058d4:	e4040593          	add	a1,s0,-448
    800058d8:	e4843783          	ld	a5,-440(s0)
    800058dc:	953e                	add	a0,a0,a5
    800058de:	ffffd097          	auipc	ra,0xffffd
    800058e2:	110080e7          	jalr	272(ra) # 800029ee <fetchaddr>
    800058e6:	02054a63          	bltz	a0,8000591a <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    800058ea:	e4043783          	ld	a5,-448(s0)
    800058ee:	c3b9                	beqz	a5,80005934 <sys_exec+0xbc>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800058f0:	ffffb097          	auipc	ra,0xffffb
    800058f4:	21c080e7          	jalr	540(ra) # 80000b0c <kalloc>
    800058f8:	85aa                	mv	a1,a0
    800058fa:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800058fe:	cd11                	beqz	a0,8000591a <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005900:	6605                	lui	a2,0x1
    80005902:	e4043503          	ld	a0,-448(s0)
    80005906:	ffffd097          	auipc	ra,0xffffd
    8000590a:	13a080e7          	jalr	314(ra) # 80002a40 <fetchstr>
    8000590e:	00054663          	bltz	a0,8000591a <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80005912:	0905                	add	s2,s2,1
    80005914:	09a1                	add	s3,s3,8
    80005916:	fb491de3          	bne	s2,s4,800058d0 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000591a:	f5040913          	add	s2,s0,-176
    8000591e:	6088                	ld	a0,0(s1)
    80005920:	c539                	beqz	a0,8000596e <sys_exec+0xf6>
    kfree(argv[i]);
    80005922:	ffffb097          	auipc	ra,0xffffb
    80005926:	0ec080e7          	jalr	236(ra) # 80000a0e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000592a:	04a1                	add	s1,s1,8
    8000592c:	ff2499e3          	bne	s1,s2,8000591e <sys_exec+0xa6>
  return -1;
    80005930:	597d                	li	s2,-1
    80005932:	a83d                	j	80005970 <sys_exec+0xf8>
      argv[i] = 0;
    80005934:	0009079b          	sext.w	a5,s2
    80005938:	078e                	sll	a5,a5,0x3
    8000593a:	fd078793          	add	a5,a5,-48
    8000593e:	97a2                	add	a5,a5,s0
    80005940:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005944:	e5040593          	add	a1,s0,-432
    80005948:	f5040513          	add	a0,s0,-176
    8000594c:	fffff097          	auipc	ra,0xfffff
    80005950:	196080e7          	jalr	406(ra) # 80004ae2 <exec>
    80005954:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005956:	f5040993          	add	s3,s0,-176
    8000595a:	6088                	ld	a0,0(s1)
    8000595c:	c911                	beqz	a0,80005970 <sys_exec+0xf8>
    kfree(argv[i]);
    8000595e:	ffffb097          	auipc	ra,0xffffb
    80005962:	0b0080e7          	jalr	176(ra) # 80000a0e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005966:	04a1                	add	s1,s1,8
    80005968:	ff3499e3          	bne	s1,s3,8000595a <sys_exec+0xe2>
    8000596c:	a011                	j	80005970 <sys_exec+0xf8>
  return -1;
    8000596e:	597d                	li	s2,-1
}
    80005970:	854a                	mv	a0,s2
    80005972:	70fa                	ld	ra,440(sp)
    80005974:	745a                	ld	s0,432(sp)
    80005976:	74ba                	ld	s1,424(sp)
    80005978:	791a                	ld	s2,416(sp)
    8000597a:	69fa                	ld	s3,408(sp)
    8000597c:	6a5a                	ld	s4,400(sp)
    8000597e:	6139                	add	sp,sp,448
    80005980:	8082                	ret

0000000080005982 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005982:	7139                	add	sp,sp,-64
    80005984:	fc06                	sd	ra,56(sp)
    80005986:	f822                	sd	s0,48(sp)
    80005988:	f426                	sd	s1,40(sp)
    8000598a:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000598c:	ffffc097          	auipc	ra,0xffffc
    80005990:	03a080e7          	jalr	58(ra) # 800019c6 <myproc>
    80005994:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005996:	fd840593          	add	a1,s0,-40
    8000599a:	4501                	li	a0,0
    8000599c:	ffffd097          	auipc	ra,0xffffd
    800059a0:	10e080e7          	jalr	270(ra) # 80002aaa <argaddr>
    return -1;
    800059a4:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800059a6:	0e054063          	bltz	a0,80005a86 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800059aa:	fc840593          	add	a1,s0,-56
    800059ae:	fd040513          	add	a0,s0,-48
    800059b2:	fffff097          	auipc	ra,0xfffff
    800059b6:	e04080e7          	jalr	-508(ra) # 800047b6 <pipealloc>
    return -1;
    800059ba:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800059bc:	0c054563          	bltz	a0,80005a86 <sys_pipe+0x104>
  fd0 = -1;
    800059c0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800059c4:	fd043503          	ld	a0,-48(s0)
    800059c8:	fffff097          	auipc	ra,0xfffff
    800059cc:	510080e7          	jalr	1296(ra) # 80004ed8 <fdalloc>
    800059d0:	fca42223          	sw	a0,-60(s0)
    800059d4:	08054c63          	bltz	a0,80005a6c <sys_pipe+0xea>
    800059d8:	fc843503          	ld	a0,-56(s0)
    800059dc:	fffff097          	auipc	ra,0xfffff
    800059e0:	4fc080e7          	jalr	1276(ra) # 80004ed8 <fdalloc>
    800059e4:	fca42023          	sw	a0,-64(s0)
    800059e8:	06054963          	bltz	a0,80005a5a <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800059ec:	4691                	li	a3,4
    800059ee:	fc440613          	add	a2,s0,-60
    800059f2:	fd843583          	ld	a1,-40(s0)
    800059f6:	68a8                	ld	a0,80(s1)
    800059f8:	ffffc097          	auipc	ra,0xffffc
    800059fc:	cc4080e7          	jalr	-828(ra) # 800016bc <copyout>
    80005a00:	02054063          	bltz	a0,80005a20 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005a04:	4691                	li	a3,4
    80005a06:	fc040613          	add	a2,s0,-64
    80005a0a:	fd843583          	ld	a1,-40(s0)
    80005a0e:	0591                	add	a1,a1,4
    80005a10:	68a8                	ld	a0,80(s1)
    80005a12:	ffffc097          	auipc	ra,0xffffc
    80005a16:	caa080e7          	jalr	-854(ra) # 800016bc <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005a1a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005a1c:	06055563          	bgez	a0,80005a86 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005a20:	fc442783          	lw	a5,-60(s0)
    80005a24:	07e9                	add	a5,a5,26
    80005a26:	078e                	sll	a5,a5,0x3
    80005a28:	97a6                	add	a5,a5,s1
    80005a2a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005a2e:	fc042783          	lw	a5,-64(s0)
    80005a32:	07e9                	add	a5,a5,26
    80005a34:	078e                	sll	a5,a5,0x3
    80005a36:	00f48533          	add	a0,s1,a5
    80005a3a:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005a3e:	fd043503          	ld	a0,-48(s0)
    80005a42:	fffff097          	auipc	ra,0xfffff
    80005a46:	a1e080e7          	jalr	-1506(ra) # 80004460 <fileclose>
    fileclose(wf);
    80005a4a:	fc843503          	ld	a0,-56(s0)
    80005a4e:	fffff097          	auipc	ra,0xfffff
    80005a52:	a12080e7          	jalr	-1518(ra) # 80004460 <fileclose>
    return -1;
    80005a56:	57fd                	li	a5,-1
    80005a58:	a03d                	j	80005a86 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005a5a:	fc442783          	lw	a5,-60(s0)
    80005a5e:	0007c763          	bltz	a5,80005a6c <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005a62:	07e9                	add	a5,a5,26
    80005a64:	078e                	sll	a5,a5,0x3
    80005a66:	97a6                	add	a5,a5,s1
    80005a68:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005a6c:	fd043503          	ld	a0,-48(s0)
    80005a70:	fffff097          	auipc	ra,0xfffff
    80005a74:	9f0080e7          	jalr	-1552(ra) # 80004460 <fileclose>
    fileclose(wf);
    80005a78:	fc843503          	ld	a0,-56(s0)
    80005a7c:	fffff097          	auipc	ra,0xfffff
    80005a80:	9e4080e7          	jalr	-1564(ra) # 80004460 <fileclose>
    return -1;
    80005a84:	57fd                	li	a5,-1
}
    80005a86:	853e                	mv	a0,a5
    80005a88:	70e2                	ld	ra,56(sp)
    80005a8a:	7442                	ld	s0,48(sp)
    80005a8c:	74a2                	ld	s1,40(sp)
    80005a8e:	6121                	add	sp,sp,64
    80005a90:	8082                	ret
	...

0000000080005aa0 <kernelvec>:
    80005aa0:	7111                	add	sp,sp,-256
    80005aa2:	e006                	sd	ra,0(sp)
    80005aa4:	e40a                	sd	sp,8(sp)
    80005aa6:	e80e                	sd	gp,16(sp)
    80005aa8:	ec12                	sd	tp,24(sp)
    80005aaa:	f016                	sd	t0,32(sp)
    80005aac:	f41a                	sd	t1,40(sp)
    80005aae:	f81e                	sd	t2,48(sp)
    80005ab0:	fc22                	sd	s0,56(sp)
    80005ab2:	e0a6                	sd	s1,64(sp)
    80005ab4:	e4aa                	sd	a0,72(sp)
    80005ab6:	e8ae                	sd	a1,80(sp)
    80005ab8:	ecb2                	sd	a2,88(sp)
    80005aba:	f0b6                	sd	a3,96(sp)
    80005abc:	f4ba                	sd	a4,104(sp)
    80005abe:	f8be                	sd	a5,112(sp)
    80005ac0:	fcc2                	sd	a6,120(sp)
    80005ac2:	e146                	sd	a7,128(sp)
    80005ac4:	e54a                	sd	s2,136(sp)
    80005ac6:	e94e                	sd	s3,144(sp)
    80005ac8:	ed52                	sd	s4,152(sp)
    80005aca:	f156                	sd	s5,160(sp)
    80005acc:	f55a                	sd	s6,168(sp)
    80005ace:	f95e                	sd	s7,176(sp)
    80005ad0:	fd62                	sd	s8,184(sp)
    80005ad2:	e1e6                	sd	s9,192(sp)
    80005ad4:	e5ea                	sd	s10,200(sp)
    80005ad6:	e9ee                	sd	s11,208(sp)
    80005ad8:	edf2                	sd	t3,216(sp)
    80005ada:	f1f6                	sd	t4,224(sp)
    80005adc:	f5fa                	sd	t5,232(sp)
    80005ade:	f9fe                	sd	t6,240(sp)
    80005ae0:	ddbfc0ef          	jal	800028ba <kerneltrap>
    80005ae4:	6082                	ld	ra,0(sp)
    80005ae6:	6122                	ld	sp,8(sp)
    80005ae8:	61c2                	ld	gp,16(sp)
    80005aea:	7282                	ld	t0,32(sp)
    80005aec:	7322                	ld	t1,40(sp)
    80005aee:	73c2                	ld	t2,48(sp)
    80005af0:	7462                	ld	s0,56(sp)
    80005af2:	6486                	ld	s1,64(sp)
    80005af4:	6526                	ld	a0,72(sp)
    80005af6:	65c6                	ld	a1,80(sp)
    80005af8:	6666                	ld	a2,88(sp)
    80005afa:	7686                	ld	a3,96(sp)
    80005afc:	7726                	ld	a4,104(sp)
    80005afe:	77c6                	ld	a5,112(sp)
    80005b00:	7866                	ld	a6,120(sp)
    80005b02:	688a                	ld	a7,128(sp)
    80005b04:	692a                	ld	s2,136(sp)
    80005b06:	69ca                	ld	s3,144(sp)
    80005b08:	6a6a                	ld	s4,152(sp)
    80005b0a:	7a8a                	ld	s5,160(sp)
    80005b0c:	7b2a                	ld	s6,168(sp)
    80005b0e:	7bca                	ld	s7,176(sp)
    80005b10:	7c6a                	ld	s8,184(sp)
    80005b12:	6c8e                	ld	s9,192(sp)
    80005b14:	6d2e                	ld	s10,200(sp)
    80005b16:	6dce                	ld	s11,208(sp)
    80005b18:	6e6e                	ld	t3,216(sp)
    80005b1a:	7e8e                	ld	t4,224(sp)
    80005b1c:	7f2e                	ld	t5,232(sp)
    80005b1e:	7fce                	ld	t6,240(sp)
    80005b20:	6111                	add	sp,sp,256
    80005b22:	10200073          	sret
    80005b26:	00000013          	nop
    80005b2a:	00000013          	nop
    80005b2e:	0001                	nop

0000000080005b30 <timervec>:
    80005b30:	34051573          	csrrw	a0,mscratch,a0
    80005b34:	e10c                	sd	a1,0(a0)
    80005b36:	e510                	sd	a2,8(a0)
    80005b38:	e914                	sd	a3,16(a0)
    80005b3a:	710c                	ld	a1,32(a0)
    80005b3c:	7510                	ld	a2,40(a0)
    80005b3e:	6194                	ld	a3,0(a1)
    80005b40:	96b2                	add	a3,a3,a2
    80005b42:	e194                	sd	a3,0(a1)
    80005b44:	4589                	li	a1,2
    80005b46:	14459073          	csrw	sip,a1
    80005b4a:	6914                	ld	a3,16(a0)
    80005b4c:	6510                	ld	a2,8(a0)
    80005b4e:	610c                	ld	a1,0(a0)
    80005b50:	34051573          	csrrw	a0,mscratch,a0
    80005b54:	30200073          	mret
	...

0000000080005b5a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005b5a:	1141                	add	sp,sp,-16
    80005b5c:	e422                	sd	s0,8(sp)
    80005b5e:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005b60:	0c0007b7          	lui	a5,0xc000
    80005b64:	4705                	li	a4,1
    80005b66:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005b68:	c3d8                	sw	a4,4(a5)
}
    80005b6a:	6422                	ld	s0,8(sp)
    80005b6c:	0141                	add	sp,sp,16
    80005b6e:	8082                	ret

0000000080005b70 <plicinithart>:

void
plicinithart(void)
{
    80005b70:	1141                	add	sp,sp,-16
    80005b72:	e406                	sd	ra,8(sp)
    80005b74:	e022                	sd	s0,0(sp)
    80005b76:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005b78:	ffffc097          	auipc	ra,0xffffc
    80005b7c:	e22080e7          	jalr	-478(ra) # 8000199a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005b80:	0085171b          	sllw	a4,a0,0x8
    80005b84:	0c0027b7          	lui	a5,0xc002
    80005b88:	97ba                	add	a5,a5,a4
    80005b8a:	40200713          	li	a4,1026
    80005b8e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005b92:	00d5151b          	sllw	a0,a0,0xd
    80005b96:	0c2017b7          	lui	a5,0xc201
    80005b9a:	97aa                	add	a5,a5,a0
    80005b9c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005ba0:	60a2                	ld	ra,8(sp)
    80005ba2:	6402                	ld	s0,0(sp)
    80005ba4:	0141                	add	sp,sp,16
    80005ba6:	8082                	ret

0000000080005ba8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005ba8:	1141                	add	sp,sp,-16
    80005baa:	e406                	sd	ra,8(sp)
    80005bac:	e022                	sd	s0,0(sp)
    80005bae:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005bb0:	ffffc097          	auipc	ra,0xffffc
    80005bb4:	dea080e7          	jalr	-534(ra) # 8000199a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005bb8:	00d5151b          	sllw	a0,a0,0xd
    80005bbc:	0c2017b7          	lui	a5,0xc201
    80005bc0:	97aa                	add	a5,a5,a0
  return irq;
}
    80005bc2:	43c8                	lw	a0,4(a5)
    80005bc4:	60a2                	ld	ra,8(sp)
    80005bc6:	6402                	ld	s0,0(sp)
    80005bc8:	0141                	add	sp,sp,16
    80005bca:	8082                	ret

0000000080005bcc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005bcc:	1101                	add	sp,sp,-32
    80005bce:	ec06                	sd	ra,24(sp)
    80005bd0:	e822                	sd	s0,16(sp)
    80005bd2:	e426                	sd	s1,8(sp)
    80005bd4:	1000                	add	s0,sp,32
    80005bd6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005bd8:	ffffc097          	auipc	ra,0xffffc
    80005bdc:	dc2080e7          	jalr	-574(ra) # 8000199a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005be0:	00d5151b          	sllw	a0,a0,0xd
    80005be4:	0c2017b7          	lui	a5,0xc201
    80005be8:	97aa                	add	a5,a5,a0
    80005bea:	c3c4                	sw	s1,4(a5)
}
    80005bec:	60e2                	ld	ra,24(sp)
    80005bee:	6442                	ld	s0,16(sp)
    80005bf0:	64a2                	ld	s1,8(sp)
    80005bf2:	6105                	add	sp,sp,32
    80005bf4:	8082                	ret

0000000080005bf6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005bf6:	1141                	add	sp,sp,-16
    80005bf8:	e406                	sd	ra,8(sp)
    80005bfa:	e022                	sd	s0,0(sp)
    80005bfc:	0800                	add	s0,sp,16
  if(i >= NUM)
    80005bfe:	479d                	li	a5,7
    80005c00:	04a7cb63          	blt	a5,a0,80005c56 <free_desc+0x60>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80005c04:	0001d717          	auipc	a4,0x1d
    80005c08:	3fc70713          	add	a4,a4,1020 # 80023000 <disk>
    80005c0c:	972a                	add	a4,a4,a0
    80005c0e:	6789                	lui	a5,0x2
    80005c10:	97ba                	add	a5,a5,a4
    80005c12:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005c16:	eba1                	bnez	a5,80005c66 <free_desc+0x70>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    80005c18:	00451713          	sll	a4,a0,0x4
    80005c1c:	0001f797          	auipc	a5,0x1f
    80005c20:	3e47b783          	ld	a5,996(a5) # 80025000 <disk+0x2000>
    80005c24:	97ba                	add	a5,a5,a4
    80005c26:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    80005c2a:	0001d717          	auipc	a4,0x1d
    80005c2e:	3d670713          	add	a4,a4,982 # 80023000 <disk>
    80005c32:	972a                	add	a4,a4,a0
    80005c34:	6789                	lui	a5,0x2
    80005c36:	97ba                	add	a5,a5,a4
    80005c38:	4705                	li	a4,1
    80005c3a:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005c3e:	0001f517          	auipc	a0,0x1f
    80005c42:	3da50513          	add	a0,a0,986 # 80025018 <disk+0x2018>
    80005c46:	ffffc097          	auipc	ra,0xffffc
    80005c4a:	716080e7          	jalr	1814(ra) # 8000235c <wakeup>
}
    80005c4e:	60a2                	ld	ra,8(sp)
    80005c50:	6402                	ld	s0,0(sp)
    80005c52:	0141                	add	sp,sp,16
    80005c54:	8082                	ret
    panic("virtio_disk_intr 1");
    80005c56:	00003517          	auipc	a0,0x3
    80005c5a:	b0250513          	add	a0,a0,-1278 # 80008758 <syscalls+0x330>
    80005c5e:	ffffb097          	auipc	ra,0xffffb
    80005c62:	8e4080e7          	jalr	-1820(ra) # 80000542 <panic>
    panic("virtio_disk_intr 2");
    80005c66:	00003517          	auipc	a0,0x3
    80005c6a:	b0a50513          	add	a0,a0,-1270 # 80008770 <syscalls+0x348>
    80005c6e:	ffffb097          	auipc	ra,0xffffb
    80005c72:	8d4080e7          	jalr	-1836(ra) # 80000542 <panic>

0000000080005c76 <virtio_disk_init>:
{
    80005c76:	1101                	add	sp,sp,-32
    80005c78:	ec06                	sd	ra,24(sp)
    80005c7a:	e822                	sd	s0,16(sp)
    80005c7c:	e426                	sd	s1,8(sp)
    80005c7e:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005c80:	00003597          	auipc	a1,0x3
    80005c84:	b0858593          	add	a1,a1,-1272 # 80008788 <syscalls+0x360>
    80005c88:	0001f517          	auipc	a0,0x1f
    80005c8c:	42050513          	add	a0,a0,1056 # 800250a8 <disk+0x20a8>
    80005c90:	ffffb097          	auipc	ra,0xffffb
    80005c94:	edc080e7          	jalr	-292(ra) # 80000b6c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005c98:	100017b7          	lui	a5,0x10001
    80005c9c:	4398                	lw	a4,0(a5)
    80005c9e:	2701                	sext.w	a4,a4
    80005ca0:	747277b7          	lui	a5,0x74727
    80005ca4:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005ca8:	0ef71063          	bne	a4,a5,80005d88 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005cac:	100017b7          	lui	a5,0x10001
    80005cb0:	43dc                	lw	a5,4(a5)
    80005cb2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005cb4:	4705                	li	a4,1
    80005cb6:	0ce79963          	bne	a5,a4,80005d88 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005cba:	100017b7          	lui	a5,0x10001
    80005cbe:	479c                	lw	a5,8(a5)
    80005cc0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005cc2:	4709                	li	a4,2
    80005cc4:	0ce79263          	bne	a5,a4,80005d88 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005cc8:	100017b7          	lui	a5,0x10001
    80005ccc:	47d8                	lw	a4,12(a5)
    80005cce:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005cd0:	554d47b7          	lui	a5,0x554d4
    80005cd4:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005cd8:	0af71863          	bne	a4,a5,80005d88 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005cdc:	100017b7          	lui	a5,0x10001
    80005ce0:	4705                	li	a4,1
    80005ce2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005ce4:	470d                	li	a4,3
    80005ce6:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005ce8:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005cea:	c7ffe6b7          	lui	a3,0xc7ffe
    80005cee:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    80005cf2:	8f75                	and	a4,a4,a3
    80005cf4:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005cf6:	472d                	li	a4,11
    80005cf8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005cfa:	473d                	li	a4,15
    80005cfc:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005cfe:	6705                	lui	a4,0x1
    80005d00:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005d02:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005d06:	5bdc                	lw	a5,52(a5)
    80005d08:	2781                	sext.w	a5,a5
  if(max == 0)
    80005d0a:	c7d9                	beqz	a5,80005d98 <virtio_disk_init+0x122>
  if(max < NUM)
    80005d0c:	471d                	li	a4,7
    80005d0e:	08f77d63          	bgeu	a4,a5,80005da8 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005d12:	100014b7          	lui	s1,0x10001
    80005d16:	47a1                	li	a5,8
    80005d18:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005d1a:	6609                	lui	a2,0x2
    80005d1c:	4581                	li	a1,0
    80005d1e:	0001d517          	auipc	a0,0x1d
    80005d22:	2e250513          	add	a0,a0,738 # 80023000 <disk>
    80005d26:	ffffb097          	auipc	ra,0xffffb
    80005d2a:	fd2080e7          	jalr	-46(ra) # 80000cf8 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005d2e:	0001d717          	auipc	a4,0x1d
    80005d32:	2d270713          	add	a4,a4,722 # 80023000 <disk>
    80005d36:	00c75793          	srl	a5,a4,0xc
    80005d3a:	2781                	sext.w	a5,a5
    80005d3c:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    80005d3e:	0001f797          	auipc	a5,0x1f
    80005d42:	2c278793          	add	a5,a5,706 # 80025000 <disk+0x2000>
    80005d46:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    80005d48:	0001d717          	auipc	a4,0x1d
    80005d4c:	33870713          	add	a4,a4,824 # 80023080 <disk+0x80>
    80005d50:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    80005d52:	0001e717          	auipc	a4,0x1e
    80005d56:	2ae70713          	add	a4,a4,686 # 80024000 <disk+0x1000>
    80005d5a:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005d5c:	4705                	li	a4,1
    80005d5e:	00e78c23          	sb	a4,24(a5)
    80005d62:	00e78ca3          	sb	a4,25(a5)
    80005d66:	00e78d23          	sb	a4,26(a5)
    80005d6a:	00e78da3          	sb	a4,27(a5)
    80005d6e:	00e78e23          	sb	a4,28(a5)
    80005d72:	00e78ea3          	sb	a4,29(a5)
    80005d76:	00e78f23          	sb	a4,30(a5)
    80005d7a:	00e78fa3          	sb	a4,31(a5)
}
    80005d7e:	60e2                	ld	ra,24(sp)
    80005d80:	6442                	ld	s0,16(sp)
    80005d82:	64a2                	ld	s1,8(sp)
    80005d84:	6105                	add	sp,sp,32
    80005d86:	8082                	ret
    panic("could not find virtio disk");
    80005d88:	00003517          	auipc	a0,0x3
    80005d8c:	a1050513          	add	a0,a0,-1520 # 80008798 <syscalls+0x370>
    80005d90:	ffffa097          	auipc	ra,0xffffa
    80005d94:	7b2080e7          	jalr	1970(ra) # 80000542 <panic>
    panic("virtio disk has no queue 0");
    80005d98:	00003517          	auipc	a0,0x3
    80005d9c:	a2050513          	add	a0,a0,-1504 # 800087b8 <syscalls+0x390>
    80005da0:	ffffa097          	auipc	ra,0xffffa
    80005da4:	7a2080e7          	jalr	1954(ra) # 80000542 <panic>
    panic("virtio disk max queue too short");
    80005da8:	00003517          	auipc	a0,0x3
    80005dac:	a3050513          	add	a0,a0,-1488 # 800087d8 <syscalls+0x3b0>
    80005db0:	ffffa097          	auipc	ra,0xffffa
    80005db4:	792080e7          	jalr	1938(ra) # 80000542 <panic>

0000000080005db8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005db8:	7119                	add	sp,sp,-128
    80005dba:	fc86                	sd	ra,120(sp)
    80005dbc:	f8a2                	sd	s0,112(sp)
    80005dbe:	f4a6                	sd	s1,104(sp)
    80005dc0:	f0ca                	sd	s2,96(sp)
    80005dc2:	ecce                	sd	s3,88(sp)
    80005dc4:	e8d2                	sd	s4,80(sp)
    80005dc6:	e4d6                	sd	s5,72(sp)
    80005dc8:	e0da                	sd	s6,64(sp)
    80005dca:	fc5e                	sd	s7,56(sp)
    80005dcc:	f862                	sd	s8,48(sp)
    80005dce:	f466                	sd	s9,40(sp)
    80005dd0:	f06a                	sd	s10,32(sp)
    80005dd2:	0100                	add	s0,sp,128
    80005dd4:	8a2a                	mv	s4,a0
    80005dd6:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005dd8:	00c52c03          	lw	s8,12(a0)
    80005ddc:	001c1c1b          	sllw	s8,s8,0x1
    80005de0:	1c02                	sll	s8,s8,0x20
    80005de2:	020c5c13          	srl	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    80005de6:	0001f517          	auipc	a0,0x1f
    80005dea:	2c250513          	add	a0,a0,706 # 800250a8 <disk+0x20a8>
    80005dee:	ffffb097          	auipc	ra,0xffffb
    80005df2:	e0e080e7          	jalr	-498(ra) # 80000bfc <acquire>
  for(int i = 0; i < 3; i++){
    80005df6:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005df8:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005dfa:	0001db97          	auipc	s7,0x1d
    80005dfe:	206b8b93          	add	s7,s7,518 # 80023000 <disk>
    80005e02:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005e04:	4a8d                	li	s5,3
    80005e06:	a0b5                	j	80005e72 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005e08:	00fb8733          	add	a4,s7,a5
    80005e0c:	975a                	add	a4,a4,s6
    80005e0e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005e12:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80005e14:	0207c563          	bltz	a5,80005e3e <virtio_disk_rw+0x86>
  for(int i = 0; i < 3; i++){
    80005e18:	2605                	addw	a2,a2,1 # 2001 <_entry-0x7fffdfff>
    80005e1a:	0591                	add	a1,a1,4
    80005e1c:	19560c63          	beq	a2,s5,80005fb4 <virtio_disk_rw+0x1fc>
    idx[i] = alloc_desc();
    80005e20:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005e22:	0001f717          	auipc	a4,0x1f
    80005e26:	1f670713          	add	a4,a4,502 # 80025018 <disk+0x2018>
    80005e2a:	87ca                	mv	a5,s2
    if(disk.free[i]){
    80005e2c:	00074683          	lbu	a3,0(a4)
    80005e30:	fee1                	bnez	a3,80005e08 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005e32:	2785                	addw	a5,a5,1
    80005e34:	0705                	add	a4,a4,1
    80005e36:	fe979be3          	bne	a5,s1,80005e2c <virtio_disk_rw+0x74>
    idx[i] = alloc_desc();
    80005e3a:	57fd                	li	a5,-1
    80005e3c:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    80005e3e:	00c05e63          	blez	a2,80005e5a <virtio_disk_rw+0xa2>
    80005e42:	060a                	sll	a2,a2,0x2
    80005e44:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80005e48:	0009a503          	lw	a0,0(s3)
    80005e4c:	00000097          	auipc	ra,0x0
    80005e50:	daa080e7          	jalr	-598(ra) # 80005bf6 <free_desc>
      for(int j = 0; j < i; j++)
    80005e54:	0991                	add	s3,s3,4
    80005e56:	ffa999e3          	bne	s3,s10,80005e48 <virtio_disk_rw+0x90>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005e5a:	0001f597          	auipc	a1,0x1f
    80005e5e:	24e58593          	add	a1,a1,590 # 800250a8 <disk+0x20a8>
    80005e62:	0001f517          	auipc	a0,0x1f
    80005e66:	1b650513          	add	a0,a0,438 # 80025018 <disk+0x2018>
    80005e6a:	ffffc097          	auipc	ra,0xffffc
    80005e6e:	372080e7          	jalr	882(ra) # 800021dc <sleep>
  for(int i = 0; i < 3; i++){
    80005e72:	f9040993          	add	s3,s0,-112
{
    80005e76:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80005e78:	864a                	mv	a2,s2
    80005e7a:	b75d                	j	80005e20 <virtio_disk_rw+0x68>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005e7c:	0001f717          	auipc	a4,0x1f
    80005e80:	18473703          	ld	a4,388(a4) # 80025000 <disk+0x2000>
    80005e84:	973e                	add	a4,a4,a5
    80005e86:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005e8a:	0001d517          	auipc	a0,0x1d
    80005e8e:	17650513          	add	a0,a0,374 # 80023000 <disk>
    80005e92:	0001f717          	auipc	a4,0x1f
    80005e96:	16e70713          	add	a4,a4,366 # 80025000 <disk+0x2000>
    80005e9a:	6314                	ld	a3,0(a4)
    80005e9c:	96be                	add	a3,a3,a5
    80005e9e:	00c6d603          	lhu	a2,12(a3)
    80005ea2:	00166613          	or	a2,a2,1
    80005ea6:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005eaa:	f9842683          	lw	a3,-104(s0)
    80005eae:	6310                	ld	a2,0(a4)
    80005eb0:	97b2                	add	a5,a5,a2
    80005eb2:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
    80005eb6:	20048613          	add	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    80005eba:	0612                	sll	a2,a2,0x4
    80005ebc:	962a                	add	a2,a2,a0
    80005ebe:	02060823          	sb	zero,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005ec2:	00469793          	sll	a5,a3,0x4
    80005ec6:	630c                	ld	a1,0(a4)
    80005ec8:	95be                	add	a1,a1,a5
    80005eca:	6689                	lui	a3,0x2
    80005ecc:	03068693          	add	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005ed0:	96ca                	add	a3,a3,s2
    80005ed2:	96aa                	add	a3,a3,a0
    80005ed4:	e194                	sd	a3,0(a1)
  disk.desc[idx[2]].len = 1;
    80005ed6:	6314                	ld	a3,0(a4)
    80005ed8:	96be                	add	a3,a3,a5
    80005eda:	4585                	li	a1,1
    80005edc:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005ede:	6314                	ld	a3,0(a4)
    80005ee0:	96be                	add	a3,a3,a5
    80005ee2:	4509                	li	a0,2
    80005ee4:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    80005ee8:	6314                	ld	a3,0(a4)
    80005eea:	97b6                	add	a5,a5,a3
    80005eec:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005ef0:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80005ef4:	03463423          	sd	s4,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    80005ef8:	6714                	ld	a3,8(a4)
    80005efa:	0026d783          	lhu	a5,2(a3)
    80005efe:	8b9d                	and	a5,a5,7
    80005f00:	0789                	add	a5,a5,2
    80005f02:	0786                	sll	a5,a5,0x1
    80005f04:	96be                	add	a3,a3,a5
    80005f06:	00969023          	sh	s1,0(a3)
  __sync_synchronize();
    80005f0a:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    80005f0e:	6718                	ld	a4,8(a4)
    80005f10:	00275783          	lhu	a5,2(a4)
    80005f14:	2785                	addw	a5,a5,1
    80005f16:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005f1a:	100017b7          	lui	a5,0x10001
    80005f1e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005f22:	004a2783          	lw	a5,4(s4)
    80005f26:	02b79163          	bne	a5,a1,80005f48 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005f2a:	0001f917          	auipc	s2,0x1f
    80005f2e:	17e90913          	add	s2,s2,382 # 800250a8 <disk+0x20a8>
  while(b->disk == 1) {
    80005f32:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005f34:	85ca                	mv	a1,s2
    80005f36:	8552                	mv	a0,s4
    80005f38:	ffffc097          	auipc	ra,0xffffc
    80005f3c:	2a4080e7          	jalr	676(ra) # 800021dc <sleep>
  while(b->disk == 1) {
    80005f40:	004a2783          	lw	a5,4(s4)
    80005f44:	fe9788e3          	beq	a5,s1,80005f34 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005f48:	f9042483          	lw	s1,-112(s0)
    80005f4c:	20048713          	add	a4,s1,512
    80005f50:	0712                	sll	a4,a4,0x4
    80005f52:	0001d797          	auipc	a5,0x1d
    80005f56:	0ae78793          	add	a5,a5,174 # 80023000 <disk>
    80005f5a:	97ba                	add	a5,a5,a4
    80005f5c:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80005f60:	0001f917          	auipc	s2,0x1f
    80005f64:	0a090913          	add	s2,s2,160 # 80025000 <disk+0x2000>
    80005f68:	a019                	j	80005f6e <virtio_disk_rw+0x1b6>
      i = disk.desc[i].next;
    80005f6a:	00e7d483          	lhu	s1,14(a5)
    free_desc(i);
    80005f6e:	8526                	mv	a0,s1
    80005f70:	00000097          	auipc	ra,0x0
    80005f74:	c86080e7          	jalr	-890(ra) # 80005bf6 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80005f78:	0492                	sll	s1,s1,0x4
    80005f7a:	00093783          	ld	a5,0(s2)
    80005f7e:	97a6                	add	a5,a5,s1
    80005f80:	00c7d703          	lhu	a4,12(a5)
    80005f84:	8b05                	and	a4,a4,1
    80005f86:	f375                	bnez	a4,80005f6a <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005f88:	0001f517          	auipc	a0,0x1f
    80005f8c:	12050513          	add	a0,a0,288 # 800250a8 <disk+0x20a8>
    80005f90:	ffffb097          	auipc	ra,0xffffb
    80005f94:	d20080e7          	jalr	-736(ra) # 80000cb0 <release>
}
    80005f98:	70e6                	ld	ra,120(sp)
    80005f9a:	7446                	ld	s0,112(sp)
    80005f9c:	74a6                	ld	s1,104(sp)
    80005f9e:	7906                	ld	s2,96(sp)
    80005fa0:	69e6                	ld	s3,88(sp)
    80005fa2:	6a46                	ld	s4,80(sp)
    80005fa4:	6aa6                	ld	s5,72(sp)
    80005fa6:	6b06                	ld	s6,64(sp)
    80005fa8:	7be2                	ld	s7,56(sp)
    80005faa:	7c42                	ld	s8,48(sp)
    80005fac:	7ca2                	ld	s9,40(sp)
    80005fae:	7d02                	ld	s10,32(sp)
    80005fb0:	6109                	add	sp,sp,128
    80005fb2:	8082                	ret
  if(write)
    80005fb4:	019037b3          	snez	a5,s9
    80005fb8:	f8f42023          	sw	a5,-128(s0)
  buf0.reserved = 0;
    80005fbc:	f8042223          	sw	zero,-124(s0)
  buf0.sector = sector;
    80005fc0:	f9843423          	sd	s8,-120(s0)
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    80005fc4:	f9042483          	lw	s1,-112(s0)
    80005fc8:	00449913          	sll	s2,s1,0x4
    80005fcc:	0001f997          	auipc	s3,0x1f
    80005fd0:	03498993          	add	s3,s3,52 # 80025000 <disk+0x2000>
    80005fd4:	0009ba83          	ld	s5,0(s3)
    80005fd8:	9aca                	add	s5,s5,s2
    80005fda:	f8040513          	add	a0,s0,-128
    80005fde:	ffffb097          	auipc	ra,0xffffb
    80005fe2:	0e8080e7          	jalr	232(ra) # 800010c6 <kvmpa>
    80005fe6:	00aab023          	sd	a0,0(s5)
  disk.desc[idx[0]].len = sizeof(buf0);
    80005fea:	0009b783          	ld	a5,0(s3)
    80005fee:	97ca                	add	a5,a5,s2
    80005ff0:	4741                	li	a4,16
    80005ff2:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005ff4:	0009b783          	ld	a5,0(s3)
    80005ff8:	97ca                	add	a5,a5,s2
    80005ffa:	4705                	li	a4,1
    80005ffc:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80006000:	f9442783          	lw	a5,-108(s0)
    80006004:	0009b703          	ld	a4,0(s3)
    80006008:	974a                	add	a4,a4,s2
    8000600a:	00f71723          	sh	a5,14(a4)
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000600e:	0792                	sll	a5,a5,0x4
    80006010:	0009b703          	ld	a4,0(s3)
    80006014:	973e                	add	a4,a4,a5
    80006016:	058a0693          	add	a3,s4,88
    8000601a:	e314                	sd	a3,0(a4)
  disk.desc[idx[1]].len = BSIZE;
    8000601c:	0009b703          	ld	a4,0(s3)
    80006020:	973e                	add	a4,a4,a5
    80006022:	40000693          	li	a3,1024
    80006026:	c714                	sw	a3,8(a4)
  if(write)
    80006028:	e40c9ae3          	bnez	s9,80005e7c <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000602c:	0001f717          	auipc	a4,0x1f
    80006030:	fd473703          	ld	a4,-44(a4) # 80025000 <disk+0x2000>
    80006034:	973e                	add	a4,a4,a5
    80006036:	4689                	li	a3,2
    80006038:	00d71623          	sh	a3,12(a4)
    8000603c:	b5b9                	j	80005e8a <virtio_disk_rw+0xd2>

000000008000603e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000603e:	1101                	add	sp,sp,-32
    80006040:	ec06                	sd	ra,24(sp)
    80006042:	e822                	sd	s0,16(sp)
    80006044:	e426                	sd	s1,8(sp)
    80006046:	e04a                	sd	s2,0(sp)
    80006048:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000604a:	0001f517          	auipc	a0,0x1f
    8000604e:	05e50513          	add	a0,a0,94 # 800250a8 <disk+0x20a8>
    80006052:	ffffb097          	auipc	ra,0xffffb
    80006056:	baa080e7          	jalr	-1110(ra) # 80000bfc <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    8000605a:	0001f717          	auipc	a4,0x1f
    8000605e:	fa670713          	add	a4,a4,-90 # 80025000 <disk+0x2000>
    80006062:	02075783          	lhu	a5,32(a4)
    80006066:	6b18                	ld	a4,16(a4)
    80006068:	00275683          	lhu	a3,2(a4)
    8000606c:	8ebd                	xor	a3,a3,a5
    8000606e:	8a9d                	and	a3,a3,7
    80006070:	cab9                	beqz	a3,800060c6 <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    80006072:	0001d917          	auipc	s2,0x1d
    80006076:	f8e90913          	add	s2,s2,-114 # 80023000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    8000607a:	0001f497          	auipc	s1,0x1f
    8000607e:	f8648493          	add	s1,s1,-122 # 80025000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    80006082:	078e                	sll	a5,a5,0x3
    80006084:	973e                	add	a4,a4,a5
    80006086:	435c                	lw	a5,4(a4)
    if(disk.info[id].status != 0)
    80006088:	20078713          	add	a4,a5,512
    8000608c:	0712                	sll	a4,a4,0x4
    8000608e:	974a                	add	a4,a4,s2
    80006090:	03074703          	lbu	a4,48(a4)
    80006094:	ef21                	bnez	a4,800060ec <virtio_disk_intr+0xae>
    disk.info[id].b->disk = 0;   // disk is done with buf
    80006096:	20078793          	add	a5,a5,512
    8000609a:	0792                	sll	a5,a5,0x4
    8000609c:	97ca                	add	a5,a5,s2
    8000609e:	7798                	ld	a4,40(a5)
    800060a0:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    800060a4:	7788                	ld	a0,40(a5)
    800060a6:	ffffc097          	auipc	ra,0xffffc
    800060aa:	2b6080e7          	jalr	694(ra) # 8000235c <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    800060ae:	0204d783          	lhu	a5,32(s1)
    800060b2:	2785                	addw	a5,a5,1
    800060b4:	8b9d                	and	a5,a5,7
    800060b6:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    800060ba:	6898                	ld	a4,16(s1)
    800060bc:	00275683          	lhu	a3,2(a4)
    800060c0:	8a9d                	and	a3,a3,7
    800060c2:	fcf690e3          	bne	a3,a5,80006082 <virtio_disk_intr+0x44>
  }
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800060c6:	10001737          	lui	a4,0x10001
    800060ca:	533c                	lw	a5,96(a4)
    800060cc:	8b8d                	and	a5,a5,3
    800060ce:	d37c                	sw	a5,100(a4)

  release(&disk.vdisk_lock);
    800060d0:	0001f517          	auipc	a0,0x1f
    800060d4:	fd850513          	add	a0,a0,-40 # 800250a8 <disk+0x20a8>
    800060d8:	ffffb097          	auipc	ra,0xffffb
    800060dc:	bd8080e7          	jalr	-1064(ra) # 80000cb0 <release>
}
    800060e0:	60e2                	ld	ra,24(sp)
    800060e2:	6442                	ld	s0,16(sp)
    800060e4:	64a2                	ld	s1,8(sp)
    800060e6:	6902                	ld	s2,0(sp)
    800060e8:	6105                	add	sp,sp,32
    800060ea:	8082                	ret
      panic("virtio_disk_intr status");
    800060ec:	00002517          	auipc	a0,0x2
    800060f0:	70c50513          	add	a0,a0,1804 # 800087f8 <syscalls+0x3d0>
    800060f4:	ffffa097          	auipc	ra,0xffffa
    800060f8:	44e080e7          	jalr	1102(ra) # 80000542 <panic>
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
