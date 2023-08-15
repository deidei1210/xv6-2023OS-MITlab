
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
    80000060:	ac478793          	add	a5,a5,-1340 # 80005b20 <timervec>
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
    8000012a:	364080e7          	jalr	868(ra) # 8000248a <either_copyin>
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
    800001d4:	00a080e7          	jalr	10(ra) # 800021da <sleep>
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
    8000021a:	21e080e7          	jalr	542(ra) # 80002434 <either_copyout>
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
    800002f8:	1ec080e7          	jalr	492(ra) # 800024e0 <procdump>
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
    8000044c:	f12080e7          	jalr	-238(ra) # 8000235a <wakeup>
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
    800008a6:	ab8080e7          	jalr	-1352(ra) # 8000235a <wakeup>
    
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
    80000940:	89e080e7          	jalr	-1890(ra) # 800021da <sleep>
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
    80000eee:	738080e7          	jalr	1848(ra) # 80002622 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ef2:	00005097          	auipc	ra,0x5
    80000ef6:	c6e080e7          	jalr	-914(ra) # 80005b60 <plicinithart>
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
    80000f66:	698080e7          	jalr	1688(ra) # 800025fa <trapinit>
    trapinithart();  // install kernel trap vector
    80000f6a:	00001097          	auipc	ra,0x1
    80000f6e:	6b8080e7          	jalr	1720(ra) # 80002622 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f72:	00005097          	auipc	ra,0x5
    80000f76:	bd8080e7          	jalr	-1064(ra) # 80005b4a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f7a:	00005097          	auipc	ra,0x5
    80000f7e:	be6080e7          	jalr	-1050(ra) # 80005b60 <plicinithart>
    binit();         // buffer cache
    80000f82:	00002097          	auipc	ra,0x2
    80000f86:	de6080e7          	jalr	-538(ra) # 80002d68 <binit>
    iinit();         // inode cache
    80000f8a:	00002097          	auipc	ra,0x2
    80000f8e:	472080e7          	jalr	1138(ra) # 800033fc <iinit>
    fileinit();      // file table
    80000f92:	00003097          	auipc	ra,0x3
    80000f96:	3e4080e7          	jalr	996(ra) # 80004376 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f9a:	00005097          	auipc	ra,0x5
    80000f9e:	ccc080e7          	jalr	-820(ra) # 80005c66 <virtio_disk_init>
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
    80001a24:	c1a080e7          	jalr	-998(ra) # 8000263a <usertrapret>
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
    80001a3e:	942080e7          	jalr	-1726(ra) # 8000337c <fsinit>
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
    80001cf2:	0b2080e7          	jalr	178(ra) # 80003da0 <namei>
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
    80001e40:	5cc080e7          	jalr	1484(ra) # 80004408 <filedup>
    80001e44:	00a93023          	sd	a0,0(s2)
    80001e48:	b7e5                	j	80001e30 <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001e4a:	150ab503          	ld	a0,336(s5)
    80001e4e:	00001097          	auipc	ra,0x1
    80001e52:	764080e7          	jalr	1892(ra) # 800035b2 <idup>
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
    80001f1a:	00779b13          	sll	s6,a5,0x7
    80001f1e:	00010717          	auipc	a4,0x10
    80001f22:	a3270713          	add	a4,a4,-1486 # 80011950 <pid_lock>
    80001f26:	975a                	add	a4,a4,s6
    80001f28:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    80001f2c:	00010717          	auipc	a4,0x10
    80001f30:	a4470713          	add	a4,a4,-1468 # 80011970 <cpus+0x8>
    80001f34:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001f36:	4c0d                	li	s8,3
        c->proc = p;
    80001f38:	079e                	sll	a5,a5,0x7
    80001f3a:	00010a17          	auipc	s4,0x10
    80001f3e:	a16a0a13          	add	s4,s4,-1514 # 80011950 <pid_lock>
    80001f42:	9a3e                	add	s4,s4,a5
        found = 1;
    80001f44:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f46:	00016997          	auipc	s3,0x16
    80001f4a:	82298993          	add	s3,s3,-2014 # 80017768 <tickslock>
    80001f4e:	a899                	j	80001fa4 <scheduler+0xa6>
      release(&p->lock);
    80001f50:	8526                	mv	a0,s1
    80001f52:	fffff097          	auipc	ra,0xfffff
    80001f56:	d5e080e7          	jalr	-674(ra) # 80000cb0 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f5a:	16848493          	add	s1,s1,360
    80001f5e:	03348963          	beq	s1,s3,80001f90 <scheduler+0x92>
      acquire(&p->lock);
    80001f62:	8526                	mv	a0,s1
    80001f64:	fffff097          	auipc	ra,0xfffff
    80001f68:	c98080e7          	jalr	-872(ra) # 80000bfc <acquire>
      if(p->state == RUNNABLE) {
    80001f6c:	4c9c                	lw	a5,24(s1)
    80001f6e:	ff2791e3          	bne	a5,s2,80001f50 <scheduler+0x52>
        p->state = RUNNING;
    80001f72:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001f76:	009a3c23          	sd	s1,24(s4)
        swtch(&c->context, &p->context);
    80001f7a:	06048593          	add	a1,s1,96
    80001f7e:	855a                	mv	a0,s6
    80001f80:	00000097          	auipc	ra,0x0
    80001f84:	610080e7          	jalr	1552(ra) # 80002590 <swtch>
        c->proc = 0;
    80001f88:	000a3c23          	sd	zero,24(s4)
        found = 1;
    80001f8c:	8ade                	mv	s5,s7
    80001f8e:	b7c9                	j	80001f50 <scheduler+0x52>
    if(found == 0) {
    80001f90:	000a9a63          	bnez	s5,80001fa4 <scheduler+0xa6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f94:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f98:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f9c:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001fa0:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fa4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001fa8:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fac:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001fb0:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fb2:	00010497          	auipc	s1,0x10
    80001fb6:	db648493          	add	s1,s1,-586 # 80011d68 <proc>
      if(p->state == RUNNABLE) {
    80001fba:	4909                	li	s2,2
    80001fbc:	b75d                	j	80001f62 <scheduler+0x64>

0000000080001fbe <sched>:
{
    80001fbe:	7179                	add	sp,sp,-48
    80001fc0:	f406                	sd	ra,40(sp)
    80001fc2:	f022                	sd	s0,32(sp)
    80001fc4:	ec26                	sd	s1,24(sp)
    80001fc6:	e84a                	sd	s2,16(sp)
    80001fc8:	e44e                	sd	s3,8(sp)
    80001fca:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    80001fcc:	00000097          	auipc	ra,0x0
    80001fd0:	9fa080e7          	jalr	-1542(ra) # 800019c6 <myproc>
    80001fd4:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001fd6:	fffff097          	auipc	ra,0xfffff
    80001fda:	bac080e7          	jalr	-1108(ra) # 80000b82 <holding>
    80001fde:	c93d                	beqz	a0,80002054 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001fe0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001fe2:	2781                	sext.w	a5,a5
    80001fe4:	079e                	sll	a5,a5,0x7
    80001fe6:	00010717          	auipc	a4,0x10
    80001fea:	96a70713          	add	a4,a4,-1686 # 80011950 <pid_lock>
    80001fee:	97ba                	add	a5,a5,a4
    80001ff0:	0907a703          	lw	a4,144(a5)
    80001ff4:	4785                	li	a5,1
    80001ff6:	06f71763          	bne	a4,a5,80002064 <sched+0xa6>
  if(p->state == RUNNING)
    80001ffa:	4c98                	lw	a4,24(s1)
    80001ffc:	478d                	li	a5,3
    80001ffe:	06f70b63          	beq	a4,a5,80002074 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002002:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002006:	8b89                	and	a5,a5,2
  if(intr_get())
    80002008:	efb5                	bnez	a5,80002084 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000200a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000200c:	00010917          	auipc	s2,0x10
    80002010:	94490913          	add	s2,s2,-1724 # 80011950 <pid_lock>
    80002014:	2781                	sext.w	a5,a5
    80002016:	079e                	sll	a5,a5,0x7
    80002018:	97ca                	add	a5,a5,s2
    8000201a:	0947a983          	lw	s3,148(a5)
    8000201e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002020:	2781                	sext.w	a5,a5
    80002022:	079e                	sll	a5,a5,0x7
    80002024:	00010597          	auipc	a1,0x10
    80002028:	94c58593          	add	a1,a1,-1716 # 80011970 <cpus+0x8>
    8000202c:	95be                	add	a1,a1,a5
    8000202e:	06048513          	add	a0,s1,96
    80002032:	00000097          	auipc	ra,0x0
    80002036:	55e080e7          	jalr	1374(ra) # 80002590 <swtch>
    8000203a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000203c:	2781                	sext.w	a5,a5
    8000203e:	079e                	sll	a5,a5,0x7
    80002040:	993e                	add	s2,s2,a5
    80002042:	09392a23          	sw	s3,148(s2)
}
    80002046:	70a2                	ld	ra,40(sp)
    80002048:	7402                	ld	s0,32(sp)
    8000204a:	64e2                	ld	s1,24(sp)
    8000204c:	6942                	ld	s2,16(sp)
    8000204e:	69a2                	ld	s3,8(sp)
    80002050:	6145                	add	sp,sp,48
    80002052:	8082                	ret
    panic("sched p->lock");
    80002054:	00006517          	auipc	a0,0x6
    80002058:	1ac50513          	add	a0,a0,428 # 80008200 <digits+0x1c0>
    8000205c:	ffffe097          	auipc	ra,0xffffe
    80002060:	4e6080e7          	jalr	1254(ra) # 80000542 <panic>
    panic("sched locks");
    80002064:	00006517          	auipc	a0,0x6
    80002068:	1ac50513          	add	a0,a0,428 # 80008210 <digits+0x1d0>
    8000206c:	ffffe097          	auipc	ra,0xffffe
    80002070:	4d6080e7          	jalr	1238(ra) # 80000542 <panic>
    panic("sched running");
    80002074:	00006517          	auipc	a0,0x6
    80002078:	1ac50513          	add	a0,a0,428 # 80008220 <digits+0x1e0>
    8000207c:	ffffe097          	auipc	ra,0xffffe
    80002080:	4c6080e7          	jalr	1222(ra) # 80000542 <panic>
    panic("sched interruptible");
    80002084:	00006517          	auipc	a0,0x6
    80002088:	1ac50513          	add	a0,a0,428 # 80008230 <digits+0x1f0>
    8000208c:	ffffe097          	auipc	ra,0xffffe
    80002090:	4b6080e7          	jalr	1206(ra) # 80000542 <panic>

0000000080002094 <exit>:
{
    80002094:	7179                	add	sp,sp,-48
    80002096:	f406                	sd	ra,40(sp)
    80002098:	f022                	sd	s0,32(sp)
    8000209a:	ec26                	sd	s1,24(sp)
    8000209c:	e84a                	sd	s2,16(sp)
    8000209e:	e44e                	sd	s3,8(sp)
    800020a0:	e052                	sd	s4,0(sp)
    800020a2:	1800                	add	s0,sp,48
    800020a4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800020a6:	00000097          	auipc	ra,0x0
    800020aa:	920080e7          	jalr	-1760(ra) # 800019c6 <myproc>
    800020ae:	89aa                	mv	s3,a0
  if(p == initproc)
    800020b0:	00007797          	auipc	a5,0x7
    800020b4:	f687b783          	ld	a5,-152(a5) # 80009018 <initproc>
    800020b8:	0d050493          	add	s1,a0,208
    800020bc:	15050913          	add	s2,a0,336
    800020c0:	02a79363          	bne	a5,a0,800020e6 <exit+0x52>
    panic("init exiting");
    800020c4:	00006517          	auipc	a0,0x6
    800020c8:	18450513          	add	a0,a0,388 # 80008248 <digits+0x208>
    800020cc:	ffffe097          	auipc	ra,0xffffe
    800020d0:	476080e7          	jalr	1142(ra) # 80000542 <panic>
      fileclose(f);
    800020d4:	00002097          	auipc	ra,0x2
    800020d8:	386080e7          	jalr	902(ra) # 8000445a <fileclose>
      p->ofile[fd] = 0;
    800020dc:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800020e0:	04a1                	add	s1,s1,8
    800020e2:	01248563          	beq	s1,s2,800020ec <exit+0x58>
    if(p->ofile[fd]){
    800020e6:	6088                	ld	a0,0(s1)
    800020e8:	f575                	bnez	a0,800020d4 <exit+0x40>
    800020ea:	bfdd                	j	800020e0 <exit+0x4c>
  begin_op();
    800020ec:	00002097          	auipc	ra,0x2
    800020f0:	ea4080e7          	jalr	-348(ra) # 80003f90 <begin_op>
  iput(p->cwd);
    800020f4:	1509b503          	ld	a0,336(s3)
    800020f8:	00001097          	auipc	ra,0x1
    800020fc:	6b2080e7          	jalr	1714(ra) # 800037aa <iput>
  end_op();
    80002100:	00002097          	auipc	ra,0x2
    80002104:	f0a080e7          	jalr	-246(ra) # 8000400a <end_op>
  p->cwd = 0;
    80002108:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    8000210c:	00007497          	auipc	s1,0x7
    80002110:	f0c48493          	add	s1,s1,-244 # 80009018 <initproc>
    80002114:	6088                	ld	a0,0(s1)
    80002116:	fffff097          	auipc	ra,0xfffff
    8000211a:	ae6080e7          	jalr	-1306(ra) # 80000bfc <acquire>
  wakeup1(initproc);
    8000211e:	6088                	ld	a0,0(s1)
    80002120:	fffff097          	auipc	ra,0xfffff
    80002124:	766080e7          	jalr	1894(ra) # 80001886 <wakeup1>
  release(&initproc->lock);
    80002128:	6088                	ld	a0,0(s1)
    8000212a:	fffff097          	auipc	ra,0xfffff
    8000212e:	b86080e7          	jalr	-1146(ra) # 80000cb0 <release>
  acquire(&p->lock);
    80002132:	854e                	mv	a0,s3
    80002134:	fffff097          	auipc	ra,0xfffff
    80002138:	ac8080e7          	jalr	-1336(ra) # 80000bfc <acquire>
  struct proc *original_parent = p->parent;
    8000213c:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    80002140:	854e                	mv	a0,s3
    80002142:	fffff097          	auipc	ra,0xfffff
    80002146:	b6e080e7          	jalr	-1170(ra) # 80000cb0 <release>
  acquire(&original_parent->lock);
    8000214a:	8526                	mv	a0,s1
    8000214c:	fffff097          	auipc	ra,0xfffff
    80002150:	ab0080e7          	jalr	-1360(ra) # 80000bfc <acquire>
  acquire(&p->lock);
    80002154:	854e                	mv	a0,s3
    80002156:	fffff097          	auipc	ra,0xfffff
    8000215a:	aa6080e7          	jalr	-1370(ra) # 80000bfc <acquire>
  reparent(p);
    8000215e:	854e                	mv	a0,s3
    80002160:	00000097          	auipc	ra,0x0
    80002164:	d38080e7          	jalr	-712(ra) # 80001e98 <reparent>
  wakeup1(original_parent);
    80002168:	8526                	mv	a0,s1
    8000216a:	fffff097          	auipc	ra,0xfffff
    8000216e:	71c080e7          	jalr	1820(ra) # 80001886 <wakeup1>
  p->xstate = status;
    80002172:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80002176:	4791                	li	a5,4
    80002178:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    8000217c:	8526                	mv	a0,s1
    8000217e:	fffff097          	auipc	ra,0xfffff
    80002182:	b32080e7          	jalr	-1230(ra) # 80000cb0 <release>
  sched();
    80002186:	00000097          	auipc	ra,0x0
    8000218a:	e38080e7          	jalr	-456(ra) # 80001fbe <sched>
  panic("zombie exit");
    8000218e:	00006517          	auipc	a0,0x6
    80002192:	0ca50513          	add	a0,a0,202 # 80008258 <digits+0x218>
    80002196:	ffffe097          	auipc	ra,0xffffe
    8000219a:	3ac080e7          	jalr	940(ra) # 80000542 <panic>

000000008000219e <yield>:
{
    8000219e:	1101                	add	sp,sp,-32
    800021a0:	ec06                	sd	ra,24(sp)
    800021a2:	e822                	sd	s0,16(sp)
    800021a4:	e426                	sd	s1,8(sp)
    800021a6:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    800021a8:	00000097          	auipc	ra,0x0
    800021ac:	81e080e7          	jalr	-2018(ra) # 800019c6 <myproc>
    800021b0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800021b2:	fffff097          	auipc	ra,0xfffff
    800021b6:	a4a080e7          	jalr	-1462(ra) # 80000bfc <acquire>
  p->state = RUNNABLE;
    800021ba:	4789                	li	a5,2
    800021bc:	cc9c                	sw	a5,24(s1)
  sched();
    800021be:	00000097          	auipc	ra,0x0
    800021c2:	e00080e7          	jalr	-512(ra) # 80001fbe <sched>
  release(&p->lock);
    800021c6:	8526                	mv	a0,s1
    800021c8:	fffff097          	auipc	ra,0xfffff
    800021cc:	ae8080e7          	jalr	-1304(ra) # 80000cb0 <release>
}
    800021d0:	60e2                	ld	ra,24(sp)
    800021d2:	6442                	ld	s0,16(sp)
    800021d4:	64a2                	ld	s1,8(sp)
    800021d6:	6105                	add	sp,sp,32
    800021d8:	8082                	ret

00000000800021da <sleep>:
{
    800021da:	7179                	add	sp,sp,-48
    800021dc:	f406                	sd	ra,40(sp)
    800021de:	f022                	sd	s0,32(sp)
    800021e0:	ec26                	sd	s1,24(sp)
    800021e2:	e84a                	sd	s2,16(sp)
    800021e4:	e44e                	sd	s3,8(sp)
    800021e6:	1800                	add	s0,sp,48
    800021e8:	89aa                	mv	s3,a0
    800021ea:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800021ec:	fffff097          	auipc	ra,0xfffff
    800021f0:	7da080e7          	jalr	2010(ra) # 800019c6 <myproc>
    800021f4:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    800021f6:	05250663          	beq	a0,s2,80002242 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    800021fa:	fffff097          	auipc	ra,0xfffff
    800021fe:	a02080e7          	jalr	-1534(ra) # 80000bfc <acquire>
    release(lk);
    80002202:	854a                	mv	a0,s2
    80002204:	fffff097          	auipc	ra,0xfffff
    80002208:	aac080e7          	jalr	-1364(ra) # 80000cb0 <release>
  p->chan = chan;
    8000220c:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    80002210:	4785                	li	a5,1
    80002212:	cc9c                	sw	a5,24(s1)
  sched();
    80002214:	00000097          	auipc	ra,0x0
    80002218:	daa080e7          	jalr	-598(ra) # 80001fbe <sched>
  p->chan = 0;
    8000221c:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    80002220:	8526                	mv	a0,s1
    80002222:	fffff097          	auipc	ra,0xfffff
    80002226:	a8e080e7          	jalr	-1394(ra) # 80000cb0 <release>
    acquire(lk);
    8000222a:	854a                	mv	a0,s2
    8000222c:	fffff097          	auipc	ra,0xfffff
    80002230:	9d0080e7          	jalr	-1584(ra) # 80000bfc <acquire>
}
    80002234:	70a2                	ld	ra,40(sp)
    80002236:	7402                	ld	s0,32(sp)
    80002238:	64e2                	ld	s1,24(sp)
    8000223a:	6942                	ld	s2,16(sp)
    8000223c:	69a2                	ld	s3,8(sp)
    8000223e:	6145                	add	sp,sp,48
    80002240:	8082                	ret
  p->chan = chan;
    80002242:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    80002246:	4785                	li	a5,1
    80002248:	cd1c                	sw	a5,24(a0)
  sched();
    8000224a:	00000097          	auipc	ra,0x0
    8000224e:	d74080e7          	jalr	-652(ra) # 80001fbe <sched>
  p->chan = 0;
    80002252:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    80002256:	bff9                	j	80002234 <sleep+0x5a>

0000000080002258 <wait>:
{
    80002258:	715d                	add	sp,sp,-80
    8000225a:	e486                	sd	ra,72(sp)
    8000225c:	e0a2                	sd	s0,64(sp)
    8000225e:	fc26                	sd	s1,56(sp)
    80002260:	f84a                	sd	s2,48(sp)
    80002262:	f44e                	sd	s3,40(sp)
    80002264:	f052                	sd	s4,32(sp)
    80002266:	ec56                	sd	s5,24(sp)
    80002268:	e85a                	sd	s6,16(sp)
    8000226a:	e45e                	sd	s7,8(sp)
    8000226c:	0880                	add	s0,sp,80
    8000226e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002270:	fffff097          	auipc	ra,0xfffff
    80002274:	756080e7          	jalr	1878(ra) # 800019c6 <myproc>
    80002278:	892a                	mv	s2,a0
  acquire(&p->lock);
    8000227a:	fffff097          	auipc	ra,0xfffff
    8000227e:	982080e7          	jalr	-1662(ra) # 80000bfc <acquire>
    havekids = 0;
    80002282:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80002284:	4a11                	li	s4,4
        havekids = 1;
    80002286:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80002288:	00015997          	auipc	s3,0x15
    8000228c:	4e098993          	add	s3,s3,1248 # 80017768 <tickslock>
    80002290:	a845                	j	80002340 <wait+0xe8>
          pid = np->pid;
    80002292:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002296:	000b0e63          	beqz	s6,800022b2 <wait+0x5a>
    8000229a:	4691                	li	a3,4
    8000229c:	03448613          	add	a2,s1,52
    800022a0:	85da                	mv	a1,s6
    800022a2:	05093503          	ld	a0,80(s2)
    800022a6:	fffff097          	auipc	ra,0xfffff
    800022aa:	416080e7          	jalr	1046(ra) # 800016bc <copyout>
    800022ae:	02054d63          	bltz	a0,800022e8 <wait+0x90>
          freeproc(np);
    800022b2:	8526                	mv	a0,s1
    800022b4:	00000097          	auipc	ra,0x0
    800022b8:	8c4080e7          	jalr	-1852(ra) # 80001b78 <freeproc>
          release(&np->lock);
    800022bc:	8526                	mv	a0,s1
    800022be:	fffff097          	auipc	ra,0xfffff
    800022c2:	9f2080e7          	jalr	-1550(ra) # 80000cb0 <release>
          release(&p->lock);
    800022c6:	854a                	mv	a0,s2
    800022c8:	fffff097          	auipc	ra,0xfffff
    800022cc:	9e8080e7          	jalr	-1560(ra) # 80000cb0 <release>
}
    800022d0:	854e                	mv	a0,s3
    800022d2:	60a6                	ld	ra,72(sp)
    800022d4:	6406                	ld	s0,64(sp)
    800022d6:	74e2                	ld	s1,56(sp)
    800022d8:	7942                	ld	s2,48(sp)
    800022da:	79a2                	ld	s3,40(sp)
    800022dc:	7a02                	ld	s4,32(sp)
    800022de:	6ae2                	ld	s5,24(sp)
    800022e0:	6b42                	ld	s6,16(sp)
    800022e2:	6ba2                	ld	s7,8(sp)
    800022e4:	6161                	add	sp,sp,80
    800022e6:	8082                	ret
            release(&np->lock);
    800022e8:	8526                	mv	a0,s1
    800022ea:	fffff097          	auipc	ra,0xfffff
    800022ee:	9c6080e7          	jalr	-1594(ra) # 80000cb0 <release>
            release(&p->lock);
    800022f2:	854a                	mv	a0,s2
    800022f4:	fffff097          	auipc	ra,0xfffff
    800022f8:	9bc080e7          	jalr	-1604(ra) # 80000cb0 <release>
            return -1;
    800022fc:	59fd                	li	s3,-1
    800022fe:	bfc9                	j	800022d0 <wait+0x78>
    for(np = proc; np < &proc[NPROC]; np++){
    80002300:	16848493          	add	s1,s1,360
    80002304:	03348463          	beq	s1,s3,8000232c <wait+0xd4>
      if(np->parent == p){
    80002308:	709c                	ld	a5,32(s1)
    8000230a:	ff279be3          	bne	a5,s2,80002300 <wait+0xa8>
        acquire(&np->lock);
    8000230e:	8526                	mv	a0,s1
    80002310:	fffff097          	auipc	ra,0xfffff
    80002314:	8ec080e7          	jalr	-1812(ra) # 80000bfc <acquire>
        if(np->state == ZOMBIE){
    80002318:	4c9c                	lw	a5,24(s1)
    8000231a:	f7478ce3          	beq	a5,s4,80002292 <wait+0x3a>
        release(&np->lock);
    8000231e:	8526                	mv	a0,s1
    80002320:	fffff097          	auipc	ra,0xfffff
    80002324:	990080e7          	jalr	-1648(ra) # 80000cb0 <release>
        havekids = 1;
    80002328:	8756                	mv	a4,s5
    8000232a:	bfd9                	j	80002300 <wait+0xa8>
    if(!havekids || p->killed){
    8000232c:	c305                	beqz	a4,8000234c <wait+0xf4>
    8000232e:	03092783          	lw	a5,48(s2)
    80002332:	ef89                	bnez	a5,8000234c <wait+0xf4>
    sleep(p, &p->lock);  //DOC: wait-sleep
    80002334:	85ca                	mv	a1,s2
    80002336:	854a                	mv	a0,s2
    80002338:	00000097          	auipc	ra,0x0
    8000233c:	ea2080e7          	jalr	-350(ra) # 800021da <sleep>
    havekids = 0;
    80002340:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80002342:	00010497          	auipc	s1,0x10
    80002346:	a2648493          	add	s1,s1,-1498 # 80011d68 <proc>
    8000234a:	bf7d                	j	80002308 <wait+0xb0>
      release(&p->lock);
    8000234c:	854a                	mv	a0,s2
    8000234e:	fffff097          	auipc	ra,0xfffff
    80002352:	962080e7          	jalr	-1694(ra) # 80000cb0 <release>
      return -1;
    80002356:	59fd                	li	s3,-1
    80002358:	bfa5                	j	800022d0 <wait+0x78>

000000008000235a <wakeup>:
{
    8000235a:	7139                	add	sp,sp,-64
    8000235c:	fc06                	sd	ra,56(sp)
    8000235e:	f822                	sd	s0,48(sp)
    80002360:	f426                	sd	s1,40(sp)
    80002362:	f04a                	sd	s2,32(sp)
    80002364:	ec4e                	sd	s3,24(sp)
    80002366:	e852                	sd	s4,16(sp)
    80002368:	e456                	sd	s5,8(sp)
    8000236a:	0080                	add	s0,sp,64
    8000236c:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    8000236e:	00010497          	auipc	s1,0x10
    80002372:	9fa48493          	add	s1,s1,-1542 # 80011d68 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    80002376:	4985                	li	s3,1
      p->state = RUNNABLE;
    80002378:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    8000237a:	00015917          	auipc	s2,0x15
    8000237e:	3ee90913          	add	s2,s2,1006 # 80017768 <tickslock>
    80002382:	a811                	j	80002396 <wakeup+0x3c>
    release(&p->lock);
    80002384:	8526                	mv	a0,s1
    80002386:	fffff097          	auipc	ra,0xfffff
    8000238a:	92a080e7          	jalr	-1750(ra) # 80000cb0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000238e:	16848493          	add	s1,s1,360
    80002392:	03248063          	beq	s1,s2,800023b2 <wakeup+0x58>
    acquire(&p->lock);
    80002396:	8526                	mv	a0,s1
    80002398:	fffff097          	auipc	ra,0xfffff
    8000239c:	864080e7          	jalr	-1948(ra) # 80000bfc <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    800023a0:	4c9c                	lw	a5,24(s1)
    800023a2:	ff3791e3          	bne	a5,s3,80002384 <wakeup+0x2a>
    800023a6:	749c                	ld	a5,40(s1)
    800023a8:	fd479ee3          	bne	a5,s4,80002384 <wakeup+0x2a>
      p->state = RUNNABLE;
    800023ac:	0154ac23          	sw	s5,24(s1)
    800023b0:	bfd1                	j	80002384 <wakeup+0x2a>
}
    800023b2:	70e2                	ld	ra,56(sp)
    800023b4:	7442                	ld	s0,48(sp)
    800023b6:	74a2                	ld	s1,40(sp)
    800023b8:	7902                	ld	s2,32(sp)
    800023ba:	69e2                	ld	s3,24(sp)
    800023bc:	6a42                	ld	s4,16(sp)
    800023be:	6aa2                	ld	s5,8(sp)
    800023c0:	6121                	add	sp,sp,64
    800023c2:	8082                	ret

00000000800023c4 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800023c4:	7179                	add	sp,sp,-48
    800023c6:	f406                	sd	ra,40(sp)
    800023c8:	f022                	sd	s0,32(sp)
    800023ca:	ec26                	sd	s1,24(sp)
    800023cc:	e84a                	sd	s2,16(sp)
    800023ce:	e44e                	sd	s3,8(sp)
    800023d0:	1800                	add	s0,sp,48
    800023d2:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800023d4:	00010497          	auipc	s1,0x10
    800023d8:	99448493          	add	s1,s1,-1644 # 80011d68 <proc>
    800023dc:	00015997          	auipc	s3,0x15
    800023e0:	38c98993          	add	s3,s3,908 # 80017768 <tickslock>
    acquire(&p->lock);
    800023e4:	8526                	mv	a0,s1
    800023e6:	fffff097          	auipc	ra,0xfffff
    800023ea:	816080e7          	jalr	-2026(ra) # 80000bfc <acquire>
    if(p->pid == pid){
    800023ee:	5c9c                	lw	a5,56(s1)
    800023f0:	01278d63          	beq	a5,s2,8000240a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800023f4:	8526                	mv	a0,s1
    800023f6:	fffff097          	auipc	ra,0xfffff
    800023fa:	8ba080e7          	jalr	-1862(ra) # 80000cb0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800023fe:	16848493          	add	s1,s1,360
    80002402:	ff3491e3          	bne	s1,s3,800023e4 <kill+0x20>
  }
  return -1;
    80002406:	557d                	li	a0,-1
    80002408:	a821                	j	80002420 <kill+0x5c>
      p->killed = 1;
    8000240a:	4785                	li	a5,1
    8000240c:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    8000240e:	4c98                	lw	a4,24(s1)
    80002410:	00f70f63          	beq	a4,a5,8000242e <kill+0x6a>
      release(&p->lock);
    80002414:	8526                	mv	a0,s1
    80002416:	fffff097          	auipc	ra,0xfffff
    8000241a:	89a080e7          	jalr	-1894(ra) # 80000cb0 <release>
      return 0;
    8000241e:	4501                	li	a0,0
}
    80002420:	70a2                	ld	ra,40(sp)
    80002422:	7402                	ld	s0,32(sp)
    80002424:	64e2                	ld	s1,24(sp)
    80002426:	6942                	ld	s2,16(sp)
    80002428:	69a2                	ld	s3,8(sp)
    8000242a:	6145                	add	sp,sp,48
    8000242c:	8082                	ret
        p->state = RUNNABLE;
    8000242e:	4789                	li	a5,2
    80002430:	cc9c                	sw	a5,24(s1)
    80002432:	b7cd                	j	80002414 <kill+0x50>

0000000080002434 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002434:	7179                	add	sp,sp,-48
    80002436:	f406                	sd	ra,40(sp)
    80002438:	f022                	sd	s0,32(sp)
    8000243a:	ec26                	sd	s1,24(sp)
    8000243c:	e84a                	sd	s2,16(sp)
    8000243e:	e44e                	sd	s3,8(sp)
    80002440:	e052                	sd	s4,0(sp)
    80002442:	1800                	add	s0,sp,48
    80002444:	84aa                	mv	s1,a0
    80002446:	892e                	mv	s2,a1
    80002448:	89b2                	mv	s3,a2
    8000244a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000244c:	fffff097          	auipc	ra,0xfffff
    80002450:	57a080e7          	jalr	1402(ra) # 800019c6 <myproc>
  if(user_dst){
    80002454:	c08d                	beqz	s1,80002476 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002456:	86d2                	mv	a3,s4
    80002458:	864e                	mv	a2,s3
    8000245a:	85ca                	mv	a1,s2
    8000245c:	6928                	ld	a0,80(a0)
    8000245e:	fffff097          	auipc	ra,0xfffff
    80002462:	25e080e7          	jalr	606(ra) # 800016bc <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002466:	70a2                	ld	ra,40(sp)
    80002468:	7402                	ld	s0,32(sp)
    8000246a:	64e2                	ld	s1,24(sp)
    8000246c:	6942                	ld	s2,16(sp)
    8000246e:	69a2                	ld	s3,8(sp)
    80002470:	6a02                	ld	s4,0(sp)
    80002472:	6145                	add	sp,sp,48
    80002474:	8082                	ret
    memmove((char *)dst, src, len);
    80002476:	000a061b          	sext.w	a2,s4
    8000247a:	85ce                	mv	a1,s3
    8000247c:	854a                	mv	a0,s2
    8000247e:	fffff097          	auipc	ra,0xfffff
    80002482:	8d6080e7          	jalr	-1834(ra) # 80000d54 <memmove>
    return 0;
    80002486:	8526                	mv	a0,s1
    80002488:	bff9                	j	80002466 <either_copyout+0x32>

000000008000248a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000248a:	7179                	add	sp,sp,-48
    8000248c:	f406                	sd	ra,40(sp)
    8000248e:	f022                	sd	s0,32(sp)
    80002490:	ec26                	sd	s1,24(sp)
    80002492:	e84a                	sd	s2,16(sp)
    80002494:	e44e                	sd	s3,8(sp)
    80002496:	e052                	sd	s4,0(sp)
    80002498:	1800                	add	s0,sp,48
    8000249a:	892a                	mv	s2,a0
    8000249c:	84ae                	mv	s1,a1
    8000249e:	89b2                	mv	s3,a2
    800024a0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024a2:	fffff097          	auipc	ra,0xfffff
    800024a6:	524080e7          	jalr	1316(ra) # 800019c6 <myproc>
  if(user_src){
    800024aa:	c08d                	beqz	s1,800024cc <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800024ac:	86d2                	mv	a3,s4
    800024ae:	864e                	mv	a2,s3
    800024b0:	85ca                	mv	a1,s2
    800024b2:	6928                	ld	a0,80(a0)
    800024b4:	fffff097          	auipc	ra,0xfffff
    800024b8:	294080e7          	jalr	660(ra) # 80001748 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800024bc:	70a2                	ld	ra,40(sp)
    800024be:	7402                	ld	s0,32(sp)
    800024c0:	64e2                	ld	s1,24(sp)
    800024c2:	6942                	ld	s2,16(sp)
    800024c4:	69a2                	ld	s3,8(sp)
    800024c6:	6a02                	ld	s4,0(sp)
    800024c8:	6145                	add	sp,sp,48
    800024ca:	8082                	ret
    memmove(dst, (char*)src, len);
    800024cc:	000a061b          	sext.w	a2,s4
    800024d0:	85ce                	mv	a1,s3
    800024d2:	854a                	mv	a0,s2
    800024d4:	fffff097          	auipc	ra,0xfffff
    800024d8:	880080e7          	jalr	-1920(ra) # 80000d54 <memmove>
    return 0;
    800024dc:	8526                	mv	a0,s1
    800024de:	bff9                	j	800024bc <either_copyin+0x32>

00000000800024e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800024e0:	715d                	add	sp,sp,-80
    800024e2:	e486                	sd	ra,72(sp)
    800024e4:	e0a2                	sd	s0,64(sp)
    800024e6:	fc26                	sd	s1,56(sp)
    800024e8:	f84a                	sd	s2,48(sp)
    800024ea:	f44e                	sd	s3,40(sp)
    800024ec:	f052                	sd	s4,32(sp)
    800024ee:	ec56                	sd	s5,24(sp)
    800024f0:	e85a                	sd	s6,16(sp)
    800024f2:	e45e                	sd	s7,8(sp)
    800024f4:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800024f6:	00006517          	auipc	a0,0x6
    800024fa:	bd250513          	add	a0,a0,-1070 # 800080c8 <digits+0x88>
    800024fe:	ffffe097          	auipc	ra,0xffffe
    80002502:	08e080e7          	jalr	142(ra) # 8000058c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002506:	00010497          	auipc	s1,0x10
    8000250a:	9ba48493          	add	s1,s1,-1606 # 80011ec0 <proc+0x158>
    8000250e:	00015917          	auipc	s2,0x15
    80002512:	3b290913          	add	s2,s2,946 # 800178c0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002516:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    80002518:	00006997          	auipc	s3,0x6
    8000251c:	d5098993          	add	s3,s3,-688 # 80008268 <digits+0x228>
    printf("%d %s %s", p->pid, state, p->name);
    80002520:	00006a97          	auipc	s5,0x6
    80002524:	d50a8a93          	add	s5,s5,-688 # 80008270 <digits+0x230>
    printf("\n");
    80002528:	00006a17          	auipc	s4,0x6
    8000252c:	ba0a0a13          	add	s4,s4,-1120 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002530:	00006b97          	auipc	s7,0x6
    80002534:	d78b8b93          	add	s7,s7,-648 # 800082a8 <states.0>
    80002538:	a00d                	j	8000255a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000253a:	ee06a583          	lw	a1,-288(a3)
    8000253e:	8556                	mv	a0,s5
    80002540:	ffffe097          	auipc	ra,0xffffe
    80002544:	04c080e7          	jalr	76(ra) # 8000058c <printf>
    printf("\n");
    80002548:	8552                	mv	a0,s4
    8000254a:	ffffe097          	auipc	ra,0xffffe
    8000254e:	042080e7          	jalr	66(ra) # 8000058c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002552:	16848493          	add	s1,s1,360
    80002556:	03248263          	beq	s1,s2,8000257a <procdump+0x9a>
    if(p->state == UNUSED)
    8000255a:	86a6                	mv	a3,s1
    8000255c:	ec04a783          	lw	a5,-320(s1)
    80002560:	dbed                	beqz	a5,80002552 <procdump+0x72>
      state = "???";
    80002562:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002564:	fcfb6be3          	bltu	s6,a5,8000253a <procdump+0x5a>
    80002568:	02079713          	sll	a4,a5,0x20
    8000256c:	01d75793          	srl	a5,a4,0x1d
    80002570:	97de                	add	a5,a5,s7
    80002572:	6390                	ld	a2,0(a5)
    80002574:	f279                	bnez	a2,8000253a <procdump+0x5a>
      state = "???";
    80002576:	864e                	mv	a2,s3
    80002578:	b7c9                	j	8000253a <procdump+0x5a>
  }
}
    8000257a:	60a6                	ld	ra,72(sp)
    8000257c:	6406                	ld	s0,64(sp)
    8000257e:	74e2                	ld	s1,56(sp)
    80002580:	7942                	ld	s2,48(sp)
    80002582:	79a2                	ld	s3,40(sp)
    80002584:	7a02                	ld	s4,32(sp)
    80002586:	6ae2                	ld	s5,24(sp)
    80002588:	6b42                	ld	s6,16(sp)
    8000258a:	6ba2                	ld	s7,8(sp)
    8000258c:	6161                	add	sp,sp,80
    8000258e:	8082                	ret

0000000080002590 <swtch>:
    80002590:	00153023          	sd	ra,0(a0)
    80002594:	00253423          	sd	sp,8(a0)
    80002598:	e900                	sd	s0,16(a0)
    8000259a:	ed04                	sd	s1,24(a0)
    8000259c:	03253023          	sd	s2,32(a0)
    800025a0:	03353423          	sd	s3,40(a0)
    800025a4:	03453823          	sd	s4,48(a0)
    800025a8:	03553c23          	sd	s5,56(a0)
    800025ac:	05653023          	sd	s6,64(a0)
    800025b0:	05753423          	sd	s7,72(a0)
    800025b4:	05853823          	sd	s8,80(a0)
    800025b8:	05953c23          	sd	s9,88(a0)
    800025bc:	07a53023          	sd	s10,96(a0)
    800025c0:	07b53423          	sd	s11,104(a0)
    800025c4:	0005b083          	ld	ra,0(a1)
    800025c8:	0085b103          	ld	sp,8(a1)
    800025cc:	6980                	ld	s0,16(a1)
    800025ce:	6d84                	ld	s1,24(a1)
    800025d0:	0205b903          	ld	s2,32(a1)
    800025d4:	0285b983          	ld	s3,40(a1)
    800025d8:	0305ba03          	ld	s4,48(a1)
    800025dc:	0385ba83          	ld	s5,56(a1)
    800025e0:	0405bb03          	ld	s6,64(a1)
    800025e4:	0485bb83          	ld	s7,72(a1)
    800025e8:	0505bc03          	ld	s8,80(a1)
    800025ec:	0585bc83          	ld	s9,88(a1)
    800025f0:	0605bd03          	ld	s10,96(a1)
    800025f4:	0685bd83          	ld	s11,104(a1)
    800025f8:	8082                	ret

00000000800025fa <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800025fa:	1141                	add	sp,sp,-16
    800025fc:	e406                	sd	ra,8(sp)
    800025fe:	e022                	sd	s0,0(sp)
    80002600:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80002602:	00006597          	auipc	a1,0x6
    80002606:	cce58593          	add	a1,a1,-818 # 800082d0 <states.0+0x28>
    8000260a:	00015517          	auipc	a0,0x15
    8000260e:	15e50513          	add	a0,a0,350 # 80017768 <tickslock>
    80002612:	ffffe097          	auipc	ra,0xffffe
    80002616:	55a080e7          	jalr	1370(ra) # 80000b6c <initlock>
}
    8000261a:	60a2                	ld	ra,8(sp)
    8000261c:	6402                	ld	s0,0(sp)
    8000261e:	0141                	add	sp,sp,16
    80002620:	8082                	ret

0000000080002622 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002622:	1141                	add	sp,sp,-16
    80002624:	e422                	sd	s0,8(sp)
    80002626:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002628:	00003797          	auipc	a5,0x3
    8000262c:	46878793          	add	a5,a5,1128 # 80005a90 <kernelvec>
    80002630:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002634:	6422                	ld	s0,8(sp)
    80002636:	0141                	add	sp,sp,16
    80002638:	8082                	ret

000000008000263a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000263a:	1141                	add	sp,sp,-16
    8000263c:	e406                	sd	ra,8(sp)
    8000263e:	e022                	sd	s0,0(sp)
    80002640:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80002642:	fffff097          	auipc	ra,0xfffff
    80002646:	384080e7          	jalr	900(ra) # 800019c6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000264a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000264e:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002650:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002654:	00005697          	auipc	a3,0x5
    80002658:	9ac68693          	add	a3,a3,-1620 # 80007000 <_trampoline>
    8000265c:	00005717          	auipc	a4,0x5
    80002660:	9a470713          	add	a4,a4,-1628 # 80007000 <_trampoline>
    80002664:	8f15                	sub	a4,a4,a3
    80002666:	040007b7          	lui	a5,0x4000
    8000266a:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000266c:	07b2                	sll	a5,a5,0xc
    8000266e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002670:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002674:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002676:	18002673          	csrr	a2,satp
    8000267a:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000267c:	6d30                	ld	a2,88(a0)
    8000267e:	6138                	ld	a4,64(a0)
    80002680:	6585                	lui	a1,0x1
    80002682:	972e                	add	a4,a4,a1
    80002684:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002686:	6d38                	ld	a4,88(a0)
    80002688:	00000617          	auipc	a2,0x0
    8000268c:	13c60613          	add	a2,a2,316 # 800027c4 <usertrap>
    80002690:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002692:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002694:	8612                	mv	a2,tp
    80002696:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002698:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000269c:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800026a0:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026a4:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800026a8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800026aa:	6f18                	ld	a4,24(a4)
    800026ac:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800026b0:	692c                	ld	a1,80(a0)
    800026b2:	81b1                	srl	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    800026b4:	00005717          	auipc	a4,0x5
    800026b8:	9dc70713          	add	a4,a4,-1572 # 80007090 <userret>
    800026bc:	8f15                	sub	a4,a4,a3
    800026be:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    800026c0:	577d                	li	a4,-1
    800026c2:	177e                	sll	a4,a4,0x3f
    800026c4:	8dd9                	or	a1,a1,a4
    800026c6:	02000537          	lui	a0,0x2000
    800026ca:	157d                	add	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800026cc:	0536                	sll	a0,a0,0xd
    800026ce:	9782                	jalr	a5
}
    800026d0:	60a2                	ld	ra,8(sp)
    800026d2:	6402                	ld	s0,0(sp)
    800026d4:	0141                	add	sp,sp,16
    800026d6:	8082                	ret

00000000800026d8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800026d8:	1101                	add	sp,sp,-32
    800026da:	ec06                	sd	ra,24(sp)
    800026dc:	e822                	sd	s0,16(sp)
    800026de:	e426                	sd	s1,8(sp)
    800026e0:	1000                	add	s0,sp,32
  acquire(&tickslock);
    800026e2:	00015497          	auipc	s1,0x15
    800026e6:	08648493          	add	s1,s1,134 # 80017768 <tickslock>
    800026ea:	8526                	mv	a0,s1
    800026ec:	ffffe097          	auipc	ra,0xffffe
    800026f0:	510080e7          	jalr	1296(ra) # 80000bfc <acquire>
  ticks++;
    800026f4:	00007517          	auipc	a0,0x7
    800026f8:	92c50513          	add	a0,a0,-1748 # 80009020 <ticks>
    800026fc:	411c                	lw	a5,0(a0)
    800026fe:	2785                	addw	a5,a5,1
    80002700:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002702:	00000097          	auipc	ra,0x0
    80002706:	c58080e7          	jalr	-936(ra) # 8000235a <wakeup>
  release(&tickslock);
    8000270a:	8526                	mv	a0,s1
    8000270c:	ffffe097          	auipc	ra,0xffffe
    80002710:	5a4080e7          	jalr	1444(ra) # 80000cb0 <release>
}
    80002714:	60e2                	ld	ra,24(sp)
    80002716:	6442                	ld	s0,16(sp)
    80002718:	64a2                	ld	s1,8(sp)
    8000271a:	6105                	add	sp,sp,32
    8000271c:	8082                	ret

000000008000271e <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000271e:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002722:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80002724:	0807df63          	bgez	a5,800027c2 <devintr+0xa4>
{
    80002728:	1101                	add	sp,sp,-32
    8000272a:	ec06                	sd	ra,24(sp)
    8000272c:	e822                	sd	s0,16(sp)
    8000272e:	e426                	sd	s1,8(sp)
    80002730:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    80002732:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80002736:	46a5                	li	a3,9
    80002738:	00d70d63          	beq	a4,a3,80002752 <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    8000273c:	577d                	li	a4,-1
    8000273e:	177e                	sll	a4,a4,0x3f
    80002740:	0705                	add	a4,a4,1
    return 0;
    80002742:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002744:	04e78e63          	beq	a5,a4,800027a0 <devintr+0x82>
  }
}
    80002748:	60e2                	ld	ra,24(sp)
    8000274a:	6442                	ld	s0,16(sp)
    8000274c:	64a2                	ld	s1,8(sp)
    8000274e:	6105                	add	sp,sp,32
    80002750:	8082                	ret
    int irq = plic_claim();
    80002752:	00003097          	auipc	ra,0x3
    80002756:	446080e7          	jalr	1094(ra) # 80005b98 <plic_claim>
    8000275a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000275c:	47a9                	li	a5,10
    8000275e:	02f50763          	beq	a0,a5,8000278c <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80002762:	4785                	li	a5,1
    80002764:	02f50963          	beq	a0,a5,80002796 <devintr+0x78>
    return 1;
    80002768:	4505                	li	a0,1
    } else if(irq){
    8000276a:	dcf9                	beqz	s1,80002748 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    8000276c:	85a6                	mv	a1,s1
    8000276e:	00006517          	auipc	a0,0x6
    80002772:	b6a50513          	add	a0,a0,-1174 # 800082d8 <states.0+0x30>
    80002776:	ffffe097          	auipc	ra,0xffffe
    8000277a:	e16080e7          	jalr	-490(ra) # 8000058c <printf>
      plic_complete(irq);
    8000277e:	8526                	mv	a0,s1
    80002780:	00003097          	auipc	ra,0x3
    80002784:	43c080e7          	jalr	1084(ra) # 80005bbc <plic_complete>
    return 1;
    80002788:	4505                	li	a0,1
    8000278a:	bf7d                	j	80002748 <devintr+0x2a>
      uartintr();
    8000278c:	ffffe097          	auipc	ra,0xffffe
    80002790:	232080e7          	jalr	562(ra) # 800009be <uartintr>
    if(irq)
    80002794:	b7ed                	j	8000277e <devintr+0x60>
      virtio_disk_intr();
    80002796:	00004097          	auipc	ra,0x4
    8000279a:	898080e7          	jalr	-1896(ra) # 8000602e <virtio_disk_intr>
    if(irq)
    8000279e:	b7c5                	j	8000277e <devintr+0x60>
    if(cpuid() == 0){
    800027a0:	fffff097          	auipc	ra,0xfffff
    800027a4:	1fa080e7          	jalr	506(ra) # 8000199a <cpuid>
    800027a8:	c901                	beqz	a0,800027b8 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800027aa:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800027ae:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800027b0:	14479073          	csrw	sip,a5
    return 2;
    800027b4:	4509                	li	a0,2
    800027b6:	bf49                	j	80002748 <devintr+0x2a>
      clockintr();
    800027b8:	00000097          	auipc	ra,0x0
    800027bc:	f20080e7          	jalr	-224(ra) # 800026d8 <clockintr>
    800027c0:	b7ed                	j	800027aa <devintr+0x8c>
}
    800027c2:	8082                	ret

00000000800027c4 <usertrap>:
{
    800027c4:	1101                	add	sp,sp,-32
    800027c6:	ec06                	sd	ra,24(sp)
    800027c8:	e822                	sd	s0,16(sp)
    800027ca:	e426                	sd	s1,8(sp)
    800027cc:	e04a                	sd	s2,0(sp)
    800027ce:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027d0:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800027d4:	1007f793          	and	a5,a5,256
    800027d8:	e3ad                	bnez	a5,8000283a <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027da:	00003797          	auipc	a5,0x3
    800027de:	2b678793          	add	a5,a5,694 # 80005a90 <kernelvec>
    800027e2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800027e6:	fffff097          	auipc	ra,0xfffff
    800027ea:	1e0080e7          	jalr	480(ra) # 800019c6 <myproc>
    800027ee:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800027f0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027f2:	14102773          	csrr	a4,sepc
    800027f6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027f8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800027fc:	47a1                	li	a5,8
    800027fe:	04f71c63          	bne	a4,a5,80002856 <usertrap+0x92>
    if(p->killed)
    80002802:	591c                	lw	a5,48(a0)
    80002804:	e3b9                	bnez	a5,8000284a <usertrap+0x86>
    p->trapframe->epc += 4;
    80002806:	6cb8                	ld	a4,88(s1)
    80002808:	6f1c                	ld	a5,24(a4)
    8000280a:	0791                	add	a5,a5,4
    8000280c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000280e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002812:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002816:	10079073          	csrw	sstatus,a5
    syscall();
    8000281a:	00000097          	auipc	ra,0x0
    8000281e:	2e0080e7          	jalr	736(ra) # 80002afa <syscall>
  if(p->killed)
    80002822:	589c                	lw	a5,48(s1)
    80002824:	ebc1                	bnez	a5,800028b4 <usertrap+0xf0>
  usertrapret();
    80002826:	00000097          	auipc	ra,0x0
    8000282a:	e14080e7          	jalr	-492(ra) # 8000263a <usertrapret>
}
    8000282e:	60e2                	ld	ra,24(sp)
    80002830:	6442                	ld	s0,16(sp)
    80002832:	64a2                	ld	s1,8(sp)
    80002834:	6902                	ld	s2,0(sp)
    80002836:	6105                	add	sp,sp,32
    80002838:	8082                	ret
    panic("usertrap: not from user mode");
    8000283a:	00006517          	auipc	a0,0x6
    8000283e:	abe50513          	add	a0,a0,-1346 # 800082f8 <states.0+0x50>
    80002842:	ffffe097          	auipc	ra,0xffffe
    80002846:	d00080e7          	jalr	-768(ra) # 80000542 <panic>
      exit(-1);
    8000284a:	557d                	li	a0,-1
    8000284c:	00000097          	auipc	ra,0x0
    80002850:	848080e7          	jalr	-1976(ra) # 80002094 <exit>
    80002854:	bf4d                	j	80002806 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002856:	00000097          	auipc	ra,0x0
    8000285a:	ec8080e7          	jalr	-312(ra) # 8000271e <devintr>
    8000285e:	892a                	mv	s2,a0
    80002860:	c501                	beqz	a0,80002868 <usertrap+0xa4>
  if(p->killed)
    80002862:	589c                	lw	a5,48(s1)
    80002864:	c3a1                	beqz	a5,800028a4 <usertrap+0xe0>
    80002866:	a815                	j	8000289a <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002868:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000286c:	5c90                	lw	a2,56(s1)
    8000286e:	00006517          	auipc	a0,0x6
    80002872:	aaa50513          	add	a0,a0,-1366 # 80008318 <states.0+0x70>
    80002876:	ffffe097          	auipc	ra,0xffffe
    8000287a:	d16080e7          	jalr	-746(ra) # 8000058c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000287e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002882:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002886:	00006517          	auipc	a0,0x6
    8000288a:	ac250513          	add	a0,a0,-1342 # 80008348 <states.0+0xa0>
    8000288e:	ffffe097          	auipc	ra,0xffffe
    80002892:	cfe080e7          	jalr	-770(ra) # 8000058c <printf>
    p->killed = 1;
    80002896:	4785                	li	a5,1
    80002898:	d89c                	sw	a5,48(s1)
    exit(-1);
    8000289a:	557d                	li	a0,-1
    8000289c:	fffff097          	auipc	ra,0xfffff
    800028a0:	7f8080e7          	jalr	2040(ra) # 80002094 <exit>
  if(which_dev == 2)
    800028a4:	4789                	li	a5,2
    800028a6:	f8f910e3          	bne	s2,a5,80002826 <usertrap+0x62>
    yield();
    800028aa:	00000097          	auipc	ra,0x0
    800028ae:	8f4080e7          	jalr	-1804(ra) # 8000219e <yield>
    800028b2:	bf95                	j	80002826 <usertrap+0x62>
  int which_dev = 0;
    800028b4:	4901                	li	s2,0
    800028b6:	b7d5                	j	8000289a <usertrap+0xd6>

00000000800028b8 <kerneltrap>:
{
    800028b8:	7179                	add	sp,sp,-48
    800028ba:	f406                	sd	ra,40(sp)
    800028bc:	f022                	sd	s0,32(sp)
    800028be:	ec26                	sd	s1,24(sp)
    800028c0:	e84a                	sd	s2,16(sp)
    800028c2:	e44e                	sd	s3,8(sp)
    800028c4:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028c6:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028ca:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028ce:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800028d2:	1004f793          	and	a5,s1,256
    800028d6:	cb85                	beqz	a5,80002906 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028d8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800028dc:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    800028de:	ef85                	bnez	a5,80002916 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800028e0:	00000097          	auipc	ra,0x0
    800028e4:	e3e080e7          	jalr	-450(ra) # 8000271e <devintr>
    800028e8:	cd1d                	beqz	a0,80002926 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800028ea:	4789                	li	a5,2
    800028ec:	06f50a63          	beq	a0,a5,80002960 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800028f0:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028f4:	10049073          	csrw	sstatus,s1
}
    800028f8:	70a2                	ld	ra,40(sp)
    800028fa:	7402                	ld	s0,32(sp)
    800028fc:	64e2                	ld	s1,24(sp)
    800028fe:	6942                	ld	s2,16(sp)
    80002900:	69a2                	ld	s3,8(sp)
    80002902:	6145                	add	sp,sp,48
    80002904:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002906:	00006517          	auipc	a0,0x6
    8000290a:	a6250513          	add	a0,a0,-1438 # 80008368 <states.0+0xc0>
    8000290e:	ffffe097          	auipc	ra,0xffffe
    80002912:	c34080e7          	jalr	-972(ra) # 80000542 <panic>
    panic("kerneltrap: interrupts enabled");
    80002916:	00006517          	auipc	a0,0x6
    8000291a:	a7a50513          	add	a0,a0,-1414 # 80008390 <states.0+0xe8>
    8000291e:	ffffe097          	auipc	ra,0xffffe
    80002922:	c24080e7          	jalr	-988(ra) # 80000542 <panic>
    printf("scause %p\n", scause);
    80002926:	85ce                	mv	a1,s3
    80002928:	00006517          	auipc	a0,0x6
    8000292c:	a8850513          	add	a0,a0,-1400 # 800083b0 <states.0+0x108>
    80002930:	ffffe097          	auipc	ra,0xffffe
    80002934:	c5c080e7          	jalr	-932(ra) # 8000058c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002938:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000293c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002940:	00006517          	auipc	a0,0x6
    80002944:	a8050513          	add	a0,a0,-1408 # 800083c0 <states.0+0x118>
    80002948:	ffffe097          	auipc	ra,0xffffe
    8000294c:	c44080e7          	jalr	-956(ra) # 8000058c <printf>
    panic("kerneltrap");
    80002950:	00006517          	auipc	a0,0x6
    80002954:	a8850513          	add	a0,a0,-1400 # 800083d8 <states.0+0x130>
    80002958:	ffffe097          	auipc	ra,0xffffe
    8000295c:	bea080e7          	jalr	-1046(ra) # 80000542 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002960:	fffff097          	auipc	ra,0xfffff
    80002964:	066080e7          	jalr	102(ra) # 800019c6 <myproc>
    80002968:	d541                	beqz	a0,800028f0 <kerneltrap+0x38>
    8000296a:	fffff097          	auipc	ra,0xfffff
    8000296e:	05c080e7          	jalr	92(ra) # 800019c6 <myproc>
    80002972:	4d18                	lw	a4,24(a0)
    80002974:	478d                	li	a5,3
    80002976:	f6f71de3          	bne	a4,a5,800028f0 <kerneltrap+0x38>
    yield();
    8000297a:	00000097          	auipc	ra,0x0
    8000297e:	824080e7          	jalr	-2012(ra) # 8000219e <yield>
    80002982:	b7bd                	j	800028f0 <kerneltrap+0x38>

0000000080002984 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002984:	1101                	add	sp,sp,-32
    80002986:	ec06                	sd	ra,24(sp)
    80002988:	e822                	sd	s0,16(sp)
    8000298a:	e426                	sd	s1,8(sp)
    8000298c:	1000                	add	s0,sp,32
    8000298e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002990:	fffff097          	auipc	ra,0xfffff
    80002994:	036080e7          	jalr	54(ra) # 800019c6 <myproc>
  switch (n) {
    80002998:	4795                	li	a5,5
    8000299a:	0497e163          	bltu	a5,s1,800029dc <argraw+0x58>
    8000299e:	048a                	sll	s1,s1,0x2
    800029a0:	00006717          	auipc	a4,0x6
    800029a4:	a7070713          	add	a4,a4,-1424 # 80008410 <states.0+0x168>
    800029a8:	94ba                	add	s1,s1,a4
    800029aa:	409c                	lw	a5,0(s1)
    800029ac:	97ba                	add	a5,a5,a4
    800029ae:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800029b0:	6d3c                	ld	a5,88(a0)
    800029b2:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800029b4:	60e2                	ld	ra,24(sp)
    800029b6:	6442                	ld	s0,16(sp)
    800029b8:	64a2                	ld	s1,8(sp)
    800029ba:	6105                	add	sp,sp,32
    800029bc:	8082                	ret
    return p->trapframe->a1;
    800029be:	6d3c                	ld	a5,88(a0)
    800029c0:	7fa8                	ld	a0,120(a5)
    800029c2:	bfcd                	j	800029b4 <argraw+0x30>
    return p->trapframe->a2;
    800029c4:	6d3c                	ld	a5,88(a0)
    800029c6:	63c8                	ld	a0,128(a5)
    800029c8:	b7f5                	j	800029b4 <argraw+0x30>
    return p->trapframe->a3;
    800029ca:	6d3c                	ld	a5,88(a0)
    800029cc:	67c8                	ld	a0,136(a5)
    800029ce:	b7dd                	j	800029b4 <argraw+0x30>
    return p->trapframe->a4;
    800029d0:	6d3c                	ld	a5,88(a0)
    800029d2:	6bc8                	ld	a0,144(a5)
    800029d4:	b7c5                	j	800029b4 <argraw+0x30>
    return p->trapframe->a5;
    800029d6:	6d3c                	ld	a5,88(a0)
    800029d8:	6fc8                	ld	a0,152(a5)
    800029da:	bfe9                	j	800029b4 <argraw+0x30>
  panic("argraw");
    800029dc:	00006517          	auipc	a0,0x6
    800029e0:	a0c50513          	add	a0,a0,-1524 # 800083e8 <states.0+0x140>
    800029e4:	ffffe097          	auipc	ra,0xffffe
    800029e8:	b5e080e7          	jalr	-1186(ra) # 80000542 <panic>

00000000800029ec <fetchaddr>:
{
    800029ec:	1101                	add	sp,sp,-32
    800029ee:	ec06                	sd	ra,24(sp)
    800029f0:	e822                	sd	s0,16(sp)
    800029f2:	e426                	sd	s1,8(sp)
    800029f4:	e04a                	sd	s2,0(sp)
    800029f6:	1000                	add	s0,sp,32
    800029f8:	84aa                	mv	s1,a0
    800029fa:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800029fc:	fffff097          	auipc	ra,0xfffff
    80002a00:	fca080e7          	jalr	-54(ra) # 800019c6 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002a04:	653c                	ld	a5,72(a0)
    80002a06:	02f4f863          	bgeu	s1,a5,80002a36 <fetchaddr+0x4a>
    80002a0a:	00848713          	add	a4,s1,8
    80002a0e:	02e7e663          	bltu	a5,a4,80002a3a <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002a12:	46a1                	li	a3,8
    80002a14:	8626                	mv	a2,s1
    80002a16:	85ca                	mv	a1,s2
    80002a18:	6928                	ld	a0,80(a0)
    80002a1a:	fffff097          	auipc	ra,0xfffff
    80002a1e:	d2e080e7          	jalr	-722(ra) # 80001748 <copyin>
    80002a22:	00a03533          	snez	a0,a0
    80002a26:	40a00533          	neg	a0,a0
}
    80002a2a:	60e2                	ld	ra,24(sp)
    80002a2c:	6442                	ld	s0,16(sp)
    80002a2e:	64a2                	ld	s1,8(sp)
    80002a30:	6902                	ld	s2,0(sp)
    80002a32:	6105                	add	sp,sp,32
    80002a34:	8082                	ret
    return -1;
    80002a36:	557d                	li	a0,-1
    80002a38:	bfcd                	j	80002a2a <fetchaddr+0x3e>
    80002a3a:	557d                	li	a0,-1
    80002a3c:	b7fd                	j	80002a2a <fetchaddr+0x3e>

0000000080002a3e <fetchstr>:
{
    80002a3e:	7179                	add	sp,sp,-48
    80002a40:	f406                	sd	ra,40(sp)
    80002a42:	f022                	sd	s0,32(sp)
    80002a44:	ec26                	sd	s1,24(sp)
    80002a46:	e84a                	sd	s2,16(sp)
    80002a48:	e44e                	sd	s3,8(sp)
    80002a4a:	1800                	add	s0,sp,48
    80002a4c:	892a                	mv	s2,a0
    80002a4e:	84ae                	mv	s1,a1
    80002a50:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002a52:	fffff097          	auipc	ra,0xfffff
    80002a56:	f74080e7          	jalr	-140(ra) # 800019c6 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002a5a:	86ce                	mv	a3,s3
    80002a5c:	864a                	mv	a2,s2
    80002a5e:	85a6                	mv	a1,s1
    80002a60:	6928                	ld	a0,80(a0)
    80002a62:	fffff097          	auipc	ra,0xfffff
    80002a66:	d74080e7          	jalr	-652(ra) # 800017d6 <copyinstr>
  if(err < 0)
    80002a6a:	00054763          	bltz	a0,80002a78 <fetchstr+0x3a>
  return strlen(buf);
    80002a6e:	8526                	mv	a0,s1
    80002a70:	ffffe097          	auipc	ra,0xffffe
    80002a74:	40a080e7          	jalr	1034(ra) # 80000e7a <strlen>
}
    80002a78:	70a2                	ld	ra,40(sp)
    80002a7a:	7402                	ld	s0,32(sp)
    80002a7c:	64e2                	ld	s1,24(sp)
    80002a7e:	6942                	ld	s2,16(sp)
    80002a80:	69a2                	ld	s3,8(sp)
    80002a82:	6145                	add	sp,sp,48
    80002a84:	8082                	ret

0000000080002a86 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002a86:	1101                	add	sp,sp,-32
    80002a88:	ec06                	sd	ra,24(sp)
    80002a8a:	e822                	sd	s0,16(sp)
    80002a8c:	e426                	sd	s1,8(sp)
    80002a8e:	1000                	add	s0,sp,32
    80002a90:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002a92:	00000097          	auipc	ra,0x0
    80002a96:	ef2080e7          	jalr	-270(ra) # 80002984 <argraw>
    80002a9a:	c088                	sw	a0,0(s1)
  return 0;
}
    80002a9c:	4501                	li	a0,0
    80002a9e:	60e2                	ld	ra,24(sp)
    80002aa0:	6442                	ld	s0,16(sp)
    80002aa2:	64a2                	ld	s1,8(sp)
    80002aa4:	6105                	add	sp,sp,32
    80002aa6:	8082                	ret

0000000080002aa8 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002aa8:	1101                	add	sp,sp,-32
    80002aaa:	ec06                	sd	ra,24(sp)
    80002aac:	e822                	sd	s0,16(sp)
    80002aae:	e426                	sd	s1,8(sp)
    80002ab0:	1000                	add	s0,sp,32
    80002ab2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002ab4:	00000097          	auipc	ra,0x0
    80002ab8:	ed0080e7          	jalr	-304(ra) # 80002984 <argraw>
    80002abc:	e088                	sd	a0,0(s1)
  return 0;
}
    80002abe:	4501                	li	a0,0
    80002ac0:	60e2                	ld	ra,24(sp)
    80002ac2:	6442                	ld	s0,16(sp)
    80002ac4:	64a2                	ld	s1,8(sp)
    80002ac6:	6105                	add	sp,sp,32
    80002ac8:	8082                	ret

0000000080002aca <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002aca:	1101                	add	sp,sp,-32
    80002acc:	ec06                	sd	ra,24(sp)
    80002ace:	e822                	sd	s0,16(sp)
    80002ad0:	e426                	sd	s1,8(sp)
    80002ad2:	e04a                	sd	s2,0(sp)
    80002ad4:	1000                	add	s0,sp,32
    80002ad6:	84ae                	mv	s1,a1
    80002ad8:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002ada:	00000097          	auipc	ra,0x0
    80002ade:	eaa080e7          	jalr	-342(ra) # 80002984 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002ae2:	864a                	mv	a2,s2
    80002ae4:	85a6                	mv	a1,s1
    80002ae6:	00000097          	auipc	ra,0x0
    80002aea:	f58080e7          	jalr	-168(ra) # 80002a3e <fetchstr>
}
    80002aee:	60e2                	ld	ra,24(sp)
    80002af0:	6442                	ld	s0,16(sp)
    80002af2:	64a2                	ld	s1,8(sp)
    80002af4:	6902                	ld	s2,0(sp)
    80002af6:	6105                	add	sp,sp,32
    80002af8:	8082                	ret

0000000080002afa <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002afa:	1101                	add	sp,sp,-32
    80002afc:	ec06                	sd	ra,24(sp)
    80002afe:	e822                	sd	s0,16(sp)
    80002b00:	e426                	sd	s1,8(sp)
    80002b02:	e04a                	sd	s2,0(sp)
    80002b04:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002b06:	fffff097          	auipc	ra,0xfffff
    80002b0a:	ec0080e7          	jalr	-320(ra) # 800019c6 <myproc>
    80002b0e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002b10:	05853903          	ld	s2,88(a0)
    80002b14:	0a893783          	ld	a5,168(s2)
    80002b18:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002b1c:	37fd                	addw	a5,a5,-1
    80002b1e:	4751                	li	a4,20
    80002b20:	00f76f63          	bltu	a4,a5,80002b3e <syscall+0x44>
    80002b24:	00369713          	sll	a4,a3,0x3
    80002b28:	00006797          	auipc	a5,0x6
    80002b2c:	90078793          	add	a5,a5,-1792 # 80008428 <syscalls>
    80002b30:	97ba                	add	a5,a5,a4
    80002b32:	639c                	ld	a5,0(a5)
    80002b34:	c789                	beqz	a5,80002b3e <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002b36:	9782                	jalr	a5
    80002b38:	06a93823          	sd	a0,112(s2)
    80002b3c:	a839                	j	80002b5a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002b3e:	15848613          	add	a2,s1,344
    80002b42:	5c8c                	lw	a1,56(s1)
    80002b44:	00006517          	auipc	a0,0x6
    80002b48:	8ac50513          	add	a0,a0,-1876 # 800083f0 <states.0+0x148>
    80002b4c:	ffffe097          	auipc	ra,0xffffe
    80002b50:	a40080e7          	jalr	-1472(ra) # 8000058c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002b54:	6cbc                	ld	a5,88(s1)
    80002b56:	577d                	li	a4,-1
    80002b58:	fbb8                	sd	a4,112(a5)
  }
}
    80002b5a:	60e2                	ld	ra,24(sp)
    80002b5c:	6442                	ld	s0,16(sp)
    80002b5e:	64a2                	ld	s1,8(sp)
    80002b60:	6902                	ld	s2,0(sp)
    80002b62:	6105                	add	sp,sp,32
    80002b64:	8082                	ret

0000000080002b66 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002b66:	1101                	add	sp,sp,-32
    80002b68:	ec06                	sd	ra,24(sp)
    80002b6a:	e822                	sd	s0,16(sp)
    80002b6c:	1000                	add	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002b6e:	fec40593          	add	a1,s0,-20
    80002b72:	4501                	li	a0,0
    80002b74:	00000097          	auipc	ra,0x0
    80002b78:	f12080e7          	jalr	-238(ra) # 80002a86 <argint>
    return -1;
    80002b7c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002b7e:	00054963          	bltz	a0,80002b90 <sys_exit+0x2a>
  exit(n);
    80002b82:	fec42503          	lw	a0,-20(s0)
    80002b86:	fffff097          	auipc	ra,0xfffff
    80002b8a:	50e080e7          	jalr	1294(ra) # 80002094 <exit>
  return 0;  // not reached
    80002b8e:	4781                	li	a5,0
}
    80002b90:	853e                	mv	a0,a5
    80002b92:	60e2                	ld	ra,24(sp)
    80002b94:	6442                	ld	s0,16(sp)
    80002b96:	6105                	add	sp,sp,32
    80002b98:	8082                	ret

0000000080002b9a <sys_getpid>:

uint64
sys_getpid(void)
{
    80002b9a:	1141                	add	sp,sp,-16
    80002b9c:	e406                	sd	ra,8(sp)
    80002b9e:	e022                	sd	s0,0(sp)
    80002ba0:	0800                	add	s0,sp,16
  return myproc()->pid;
    80002ba2:	fffff097          	auipc	ra,0xfffff
    80002ba6:	e24080e7          	jalr	-476(ra) # 800019c6 <myproc>
}
    80002baa:	5d08                	lw	a0,56(a0)
    80002bac:	60a2                	ld	ra,8(sp)
    80002bae:	6402                	ld	s0,0(sp)
    80002bb0:	0141                	add	sp,sp,16
    80002bb2:	8082                	ret

0000000080002bb4 <sys_fork>:

uint64
sys_fork(void)
{
    80002bb4:	1141                	add	sp,sp,-16
    80002bb6:	e406                	sd	ra,8(sp)
    80002bb8:	e022                	sd	s0,0(sp)
    80002bba:	0800                	add	s0,sp,16
  return fork();
    80002bbc:	fffff097          	auipc	ra,0xfffff
    80002bc0:	1ce080e7          	jalr	462(ra) # 80001d8a <fork>
}
    80002bc4:	60a2                	ld	ra,8(sp)
    80002bc6:	6402                	ld	s0,0(sp)
    80002bc8:	0141                	add	sp,sp,16
    80002bca:	8082                	ret

0000000080002bcc <sys_wait>:

uint64
sys_wait(void)
{
    80002bcc:	1101                	add	sp,sp,-32
    80002bce:	ec06                	sd	ra,24(sp)
    80002bd0:	e822                	sd	s0,16(sp)
    80002bd2:	1000                	add	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002bd4:	fe840593          	add	a1,s0,-24
    80002bd8:	4501                	li	a0,0
    80002bda:	00000097          	auipc	ra,0x0
    80002bde:	ece080e7          	jalr	-306(ra) # 80002aa8 <argaddr>
    80002be2:	87aa                	mv	a5,a0
    return -1;
    80002be4:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002be6:	0007c863          	bltz	a5,80002bf6 <sys_wait+0x2a>
  return wait(p);
    80002bea:	fe843503          	ld	a0,-24(s0)
    80002bee:	fffff097          	auipc	ra,0xfffff
    80002bf2:	66a080e7          	jalr	1642(ra) # 80002258 <wait>
}
    80002bf6:	60e2                	ld	ra,24(sp)
    80002bf8:	6442                	ld	s0,16(sp)
    80002bfa:	6105                	add	sp,sp,32
    80002bfc:	8082                	ret

0000000080002bfe <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002bfe:	7179                	add	sp,sp,-48
    80002c00:	f406                	sd	ra,40(sp)
    80002c02:	f022                	sd	s0,32(sp)
    80002c04:	ec26                	sd	s1,24(sp)
    80002c06:	1800                	add	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002c08:	fdc40593          	add	a1,s0,-36
    80002c0c:	4501                	li	a0,0
    80002c0e:	00000097          	auipc	ra,0x0
    80002c12:	e78080e7          	jalr	-392(ra) # 80002a86 <argint>
    80002c16:	87aa                	mv	a5,a0
    return -1;
    80002c18:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002c1a:	0207c063          	bltz	a5,80002c3a <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002c1e:	fffff097          	auipc	ra,0xfffff
    80002c22:	da8080e7          	jalr	-600(ra) # 800019c6 <myproc>
    80002c26:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002c28:	fdc42503          	lw	a0,-36(s0)
    80002c2c:	fffff097          	auipc	ra,0xfffff
    80002c30:	0e6080e7          	jalr	230(ra) # 80001d12 <growproc>
    80002c34:	00054863          	bltz	a0,80002c44 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002c38:	8526                	mv	a0,s1
}
    80002c3a:	70a2                	ld	ra,40(sp)
    80002c3c:	7402                	ld	s0,32(sp)
    80002c3e:	64e2                	ld	s1,24(sp)
    80002c40:	6145                	add	sp,sp,48
    80002c42:	8082                	ret
    return -1;
    80002c44:	557d                	li	a0,-1
    80002c46:	bfd5                	j	80002c3a <sys_sbrk+0x3c>

0000000080002c48 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002c48:	7139                	add	sp,sp,-64
    80002c4a:	fc06                	sd	ra,56(sp)
    80002c4c:	f822                	sd	s0,48(sp)
    80002c4e:	f426                	sd	s1,40(sp)
    80002c50:	f04a                	sd	s2,32(sp)
    80002c52:	ec4e                	sd	s3,24(sp)
    80002c54:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002c56:	fcc40593          	add	a1,s0,-52
    80002c5a:	4501                	li	a0,0
    80002c5c:	00000097          	auipc	ra,0x0
    80002c60:	e2a080e7          	jalr	-470(ra) # 80002a86 <argint>
    return -1;
    80002c64:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002c66:	06054563          	bltz	a0,80002cd0 <sys_sleep+0x88>
  acquire(&tickslock);
    80002c6a:	00015517          	auipc	a0,0x15
    80002c6e:	afe50513          	add	a0,a0,-1282 # 80017768 <tickslock>
    80002c72:	ffffe097          	auipc	ra,0xffffe
    80002c76:	f8a080e7          	jalr	-118(ra) # 80000bfc <acquire>
  ticks0 = ticks;
    80002c7a:	00006917          	auipc	s2,0x6
    80002c7e:	3a692903          	lw	s2,934(s2) # 80009020 <ticks>
  while(ticks - ticks0 < n){
    80002c82:	fcc42783          	lw	a5,-52(s0)
    80002c86:	cf85                	beqz	a5,80002cbe <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002c88:	00015997          	auipc	s3,0x15
    80002c8c:	ae098993          	add	s3,s3,-1312 # 80017768 <tickslock>
    80002c90:	00006497          	auipc	s1,0x6
    80002c94:	39048493          	add	s1,s1,912 # 80009020 <ticks>
    if(myproc()->killed){
    80002c98:	fffff097          	auipc	ra,0xfffff
    80002c9c:	d2e080e7          	jalr	-722(ra) # 800019c6 <myproc>
    80002ca0:	591c                	lw	a5,48(a0)
    80002ca2:	ef9d                	bnez	a5,80002ce0 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002ca4:	85ce                	mv	a1,s3
    80002ca6:	8526                	mv	a0,s1
    80002ca8:	fffff097          	auipc	ra,0xfffff
    80002cac:	532080e7          	jalr	1330(ra) # 800021da <sleep>
  while(ticks - ticks0 < n){
    80002cb0:	409c                	lw	a5,0(s1)
    80002cb2:	412787bb          	subw	a5,a5,s2
    80002cb6:	fcc42703          	lw	a4,-52(s0)
    80002cba:	fce7efe3          	bltu	a5,a4,80002c98 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002cbe:	00015517          	auipc	a0,0x15
    80002cc2:	aaa50513          	add	a0,a0,-1366 # 80017768 <tickslock>
    80002cc6:	ffffe097          	auipc	ra,0xffffe
    80002cca:	fea080e7          	jalr	-22(ra) # 80000cb0 <release>
  return 0;
    80002cce:	4781                	li	a5,0
}
    80002cd0:	853e                	mv	a0,a5
    80002cd2:	70e2                	ld	ra,56(sp)
    80002cd4:	7442                	ld	s0,48(sp)
    80002cd6:	74a2                	ld	s1,40(sp)
    80002cd8:	7902                	ld	s2,32(sp)
    80002cda:	69e2                	ld	s3,24(sp)
    80002cdc:	6121                	add	sp,sp,64
    80002cde:	8082                	ret
      release(&tickslock);
    80002ce0:	00015517          	auipc	a0,0x15
    80002ce4:	a8850513          	add	a0,a0,-1400 # 80017768 <tickslock>
    80002ce8:	ffffe097          	auipc	ra,0xffffe
    80002cec:	fc8080e7          	jalr	-56(ra) # 80000cb0 <release>
      return -1;
    80002cf0:	57fd                	li	a5,-1
    80002cf2:	bff9                	j	80002cd0 <sys_sleep+0x88>

0000000080002cf4 <sys_kill>:

uint64
sys_kill(void)
{
    80002cf4:	1101                	add	sp,sp,-32
    80002cf6:	ec06                	sd	ra,24(sp)
    80002cf8:	e822                	sd	s0,16(sp)
    80002cfa:	1000                	add	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002cfc:	fec40593          	add	a1,s0,-20
    80002d00:	4501                	li	a0,0
    80002d02:	00000097          	auipc	ra,0x0
    80002d06:	d84080e7          	jalr	-636(ra) # 80002a86 <argint>
    80002d0a:	87aa                	mv	a5,a0
    return -1;
    80002d0c:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002d0e:	0007c863          	bltz	a5,80002d1e <sys_kill+0x2a>
  return kill(pid);
    80002d12:	fec42503          	lw	a0,-20(s0)
    80002d16:	fffff097          	auipc	ra,0xfffff
    80002d1a:	6ae080e7          	jalr	1710(ra) # 800023c4 <kill>
}
    80002d1e:	60e2                	ld	ra,24(sp)
    80002d20:	6442                	ld	s0,16(sp)
    80002d22:	6105                	add	sp,sp,32
    80002d24:	8082                	ret

0000000080002d26 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002d26:	1101                	add	sp,sp,-32
    80002d28:	ec06                	sd	ra,24(sp)
    80002d2a:	e822                	sd	s0,16(sp)
    80002d2c:	e426                	sd	s1,8(sp)
    80002d2e:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002d30:	00015517          	auipc	a0,0x15
    80002d34:	a3850513          	add	a0,a0,-1480 # 80017768 <tickslock>
    80002d38:	ffffe097          	auipc	ra,0xffffe
    80002d3c:	ec4080e7          	jalr	-316(ra) # 80000bfc <acquire>
  xticks = ticks;
    80002d40:	00006497          	auipc	s1,0x6
    80002d44:	2e04a483          	lw	s1,736(s1) # 80009020 <ticks>
  release(&tickslock);
    80002d48:	00015517          	auipc	a0,0x15
    80002d4c:	a2050513          	add	a0,a0,-1504 # 80017768 <tickslock>
    80002d50:	ffffe097          	auipc	ra,0xffffe
    80002d54:	f60080e7          	jalr	-160(ra) # 80000cb0 <release>
  return xticks;
}
    80002d58:	02049513          	sll	a0,s1,0x20
    80002d5c:	9101                	srl	a0,a0,0x20
    80002d5e:	60e2                	ld	ra,24(sp)
    80002d60:	6442                	ld	s0,16(sp)
    80002d62:	64a2                	ld	s1,8(sp)
    80002d64:	6105                	add	sp,sp,32
    80002d66:	8082                	ret

0000000080002d68 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002d68:	7179                	add	sp,sp,-48
    80002d6a:	f406                	sd	ra,40(sp)
    80002d6c:	f022                	sd	s0,32(sp)
    80002d6e:	ec26                	sd	s1,24(sp)
    80002d70:	e84a                	sd	s2,16(sp)
    80002d72:	e44e                	sd	s3,8(sp)
    80002d74:	e052                	sd	s4,0(sp)
    80002d76:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002d78:	00005597          	auipc	a1,0x5
    80002d7c:	76058593          	add	a1,a1,1888 # 800084d8 <syscalls+0xb0>
    80002d80:	00015517          	auipc	a0,0x15
    80002d84:	a0050513          	add	a0,a0,-1536 # 80017780 <bcache>
    80002d88:	ffffe097          	auipc	ra,0xffffe
    80002d8c:	de4080e7          	jalr	-540(ra) # 80000b6c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002d90:	0001d797          	auipc	a5,0x1d
    80002d94:	9f078793          	add	a5,a5,-1552 # 8001f780 <bcache+0x8000>
    80002d98:	0001d717          	auipc	a4,0x1d
    80002d9c:	c5070713          	add	a4,a4,-944 # 8001f9e8 <bcache+0x8268>
    80002da0:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002da4:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002da8:	00015497          	auipc	s1,0x15
    80002dac:	9f048493          	add	s1,s1,-1552 # 80017798 <bcache+0x18>
    b->next = bcache.head.next;
    80002db0:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002db2:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002db4:	00005a17          	auipc	s4,0x5
    80002db8:	72ca0a13          	add	s4,s4,1836 # 800084e0 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002dbc:	2b893783          	ld	a5,696(s2)
    80002dc0:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002dc2:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002dc6:	85d2                	mv	a1,s4
    80002dc8:	01048513          	add	a0,s1,16
    80002dcc:	00001097          	auipc	ra,0x1
    80002dd0:	480080e7          	jalr	1152(ra) # 8000424c <initsleeplock>
    bcache.head.next->prev = b;
    80002dd4:	2b893783          	ld	a5,696(s2)
    80002dd8:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002dda:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002dde:	45848493          	add	s1,s1,1112
    80002de2:	fd349de3          	bne	s1,s3,80002dbc <binit+0x54>
  }
}
    80002de6:	70a2                	ld	ra,40(sp)
    80002de8:	7402                	ld	s0,32(sp)
    80002dea:	64e2                	ld	s1,24(sp)
    80002dec:	6942                	ld	s2,16(sp)
    80002dee:	69a2                	ld	s3,8(sp)
    80002df0:	6a02                	ld	s4,0(sp)
    80002df2:	6145                	add	sp,sp,48
    80002df4:	8082                	ret

0000000080002df6 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002df6:	7179                	add	sp,sp,-48
    80002df8:	f406                	sd	ra,40(sp)
    80002dfa:	f022                	sd	s0,32(sp)
    80002dfc:	ec26                	sd	s1,24(sp)
    80002dfe:	e84a                	sd	s2,16(sp)
    80002e00:	e44e                	sd	s3,8(sp)
    80002e02:	1800                	add	s0,sp,48
    80002e04:	892a                	mv	s2,a0
    80002e06:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002e08:	00015517          	auipc	a0,0x15
    80002e0c:	97850513          	add	a0,a0,-1672 # 80017780 <bcache>
    80002e10:	ffffe097          	auipc	ra,0xffffe
    80002e14:	dec080e7          	jalr	-532(ra) # 80000bfc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002e18:	0001d497          	auipc	s1,0x1d
    80002e1c:	c204b483          	ld	s1,-992(s1) # 8001fa38 <bcache+0x82b8>
    80002e20:	0001d797          	auipc	a5,0x1d
    80002e24:	bc878793          	add	a5,a5,-1080 # 8001f9e8 <bcache+0x8268>
    80002e28:	02f48f63          	beq	s1,a5,80002e66 <bread+0x70>
    80002e2c:	873e                	mv	a4,a5
    80002e2e:	a021                	j	80002e36 <bread+0x40>
    80002e30:	68a4                	ld	s1,80(s1)
    80002e32:	02e48a63          	beq	s1,a4,80002e66 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002e36:	449c                	lw	a5,8(s1)
    80002e38:	ff279ce3          	bne	a5,s2,80002e30 <bread+0x3a>
    80002e3c:	44dc                	lw	a5,12(s1)
    80002e3e:	ff3799e3          	bne	a5,s3,80002e30 <bread+0x3a>
      b->refcnt++;
    80002e42:	40bc                	lw	a5,64(s1)
    80002e44:	2785                	addw	a5,a5,1
    80002e46:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e48:	00015517          	auipc	a0,0x15
    80002e4c:	93850513          	add	a0,a0,-1736 # 80017780 <bcache>
    80002e50:	ffffe097          	auipc	ra,0xffffe
    80002e54:	e60080e7          	jalr	-416(ra) # 80000cb0 <release>
      acquiresleep(&b->lock);
    80002e58:	01048513          	add	a0,s1,16
    80002e5c:	00001097          	auipc	ra,0x1
    80002e60:	42a080e7          	jalr	1066(ra) # 80004286 <acquiresleep>
      return b;
    80002e64:	a8b9                	j	80002ec2 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e66:	0001d497          	auipc	s1,0x1d
    80002e6a:	bca4b483          	ld	s1,-1078(s1) # 8001fa30 <bcache+0x82b0>
    80002e6e:	0001d797          	auipc	a5,0x1d
    80002e72:	b7a78793          	add	a5,a5,-1158 # 8001f9e8 <bcache+0x8268>
    80002e76:	00f48863          	beq	s1,a5,80002e86 <bread+0x90>
    80002e7a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002e7c:	40bc                	lw	a5,64(s1)
    80002e7e:	cf81                	beqz	a5,80002e96 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e80:	64a4                	ld	s1,72(s1)
    80002e82:	fee49de3          	bne	s1,a4,80002e7c <bread+0x86>
  panic("bget: no buffers");
    80002e86:	00005517          	auipc	a0,0x5
    80002e8a:	66250513          	add	a0,a0,1634 # 800084e8 <syscalls+0xc0>
    80002e8e:	ffffd097          	auipc	ra,0xffffd
    80002e92:	6b4080e7          	jalr	1716(ra) # 80000542 <panic>
      b->dev = dev;
    80002e96:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002e9a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002e9e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002ea2:	4785                	li	a5,1
    80002ea4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002ea6:	00015517          	auipc	a0,0x15
    80002eaa:	8da50513          	add	a0,a0,-1830 # 80017780 <bcache>
    80002eae:	ffffe097          	auipc	ra,0xffffe
    80002eb2:	e02080e7          	jalr	-510(ra) # 80000cb0 <release>
      acquiresleep(&b->lock);
    80002eb6:	01048513          	add	a0,s1,16
    80002eba:	00001097          	auipc	ra,0x1
    80002ebe:	3cc080e7          	jalr	972(ra) # 80004286 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002ec2:	409c                	lw	a5,0(s1)
    80002ec4:	cb89                	beqz	a5,80002ed6 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002ec6:	8526                	mv	a0,s1
    80002ec8:	70a2                	ld	ra,40(sp)
    80002eca:	7402                	ld	s0,32(sp)
    80002ecc:	64e2                	ld	s1,24(sp)
    80002ece:	6942                	ld	s2,16(sp)
    80002ed0:	69a2                	ld	s3,8(sp)
    80002ed2:	6145                	add	sp,sp,48
    80002ed4:	8082                	ret
    virtio_disk_rw(b, 0);
    80002ed6:	4581                	li	a1,0
    80002ed8:	8526                	mv	a0,s1
    80002eda:	00003097          	auipc	ra,0x3
    80002ede:	ece080e7          	jalr	-306(ra) # 80005da8 <virtio_disk_rw>
    b->valid = 1;
    80002ee2:	4785                	li	a5,1
    80002ee4:	c09c                	sw	a5,0(s1)
  return b;
    80002ee6:	b7c5                	j	80002ec6 <bread+0xd0>

0000000080002ee8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002ee8:	1101                	add	sp,sp,-32
    80002eea:	ec06                	sd	ra,24(sp)
    80002eec:	e822                	sd	s0,16(sp)
    80002eee:	e426                	sd	s1,8(sp)
    80002ef0:	1000                	add	s0,sp,32
    80002ef2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002ef4:	0541                	add	a0,a0,16
    80002ef6:	00001097          	auipc	ra,0x1
    80002efa:	42a080e7          	jalr	1066(ra) # 80004320 <holdingsleep>
    80002efe:	cd01                	beqz	a0,80002f16 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002f00:	4585                	li	a1,1
    80002f02:	8526                	mv	a0,s1
    80002f04:	00003097          	auipc	ra,0x3
    80002f08:	ea4080e7          	jalr	-348(ra) # 80005da8 <virtio_disk_rw>
}
    80002f0c:	60e2                	ld	ra,24(sp)
    80002f0e:	6442                	ld	s0,16(sp)
    80002f10:	64a2                	ld	s1,8(sp)
    80002f12:	6105                	add	sp,sp,32
    80002f14:	8082                	ret
    panic("bwrite");
    80002f16:	00005517          	auipc	a0,0x5
    80002f1a:	5ea50513          	add	a0,a0,1514 # 80008500 <syscalls+0xd8>
    80002f1e:	ffffd097          	auipc	ra,0xffffd
    80002f22:	624080e7          	jalr	1572(ra) # 80000542 <panic>

0000000080002f26 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002f26:	1101                	add	sp,sp,-32
    80002f28:	ec06                	sd	ra,24(sp)
    80002f2a:	e822                	sd	s0,16(sp)
    80002f2c:	e426                	sd	s1,8(sp)
    80002f2e:	e04a                	sd	s2,0(sp)
    80002f30:	1000                	add	s0,sp,32
    80002f32:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002f34:	01050913          	add	s2,a0,16
    80002f38:	854a                	mv	a0,s2
    80002f3a:	00001097          	auipc	ra,0x1
    80002f3e:	3e6080e7          	jalr	998(ra) # 80004320 <holdingsleep>
    80002f42:	c925                	beqz	a0,80002fb2 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002f44:	854a                	mv	a0,s2
    80002f46:	00001097          	auipc	ra,0x1
    80002f4a:	396080e7          	jalr	918(ra) # 800042dc <releasesleep>

  acquire(&bcache.lock);
    80002f4e:	00015517          	auipc	a0,0x15
    80002f52:	83250513          	add	a0,a0,-1998 # 80017780 <bcache>
    80002f56:	ffffe097          	auipc	ra,0xffffe
    80002f5a:	ca6080e7          	jalr	-858(ra) # 80000bfc <acquire>
  b->refcnt--;
    80002f5e:	40bc                	lw	a5,64(s1)
    80002f60:	37fd                	addw	a5,a5,-1
    80002f62:	0007871b          	sext.w	a4,a5
    80002f66:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002f68:	e71d                	bnez	a4,80002f96 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002f6a:	68b8                	ld	a4,80(s1)
    80002f6c:	64bc                	ld	a5,72(s1)
    80002f6e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002f70:	68b8                	ld	a4,80(s1)
    80002f72:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002f74:	0001d797          	auipc	a5,0x1d
    80002f78:	80c78793          	add	a5,a5,-2036 # 8001f780 <bcache+0x8000>
    80002f7c:	2b87b703          	ld	a4,696(a5)
    80002f80:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002f82:	0001d717          	auipc	a4,0x1d
    80002f86:	a6670713          	add	a4,a4,-1434 # 8001f9e8 <bcache+0x8268>
    80002f8a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002f8c:	2b87b703          	ld	a4,696(a5)
    80002f90:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002f92:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002f96:	00014517          	auipc	a0,0x14
    80002f9a:	7ea50513          	add	a0,a0,2026 # 80017780 <bcache>
    80002f9e:	ffffe097          	auipc	ra,0xffffe
    80002fa2:	d12080e7          	jalr	-750(ra) # 80000cb0 <release>
}
    80002fa6:	60e2                	ld	ra,24(sp)
    80002fa8:	6442                	ld	s0,16(sp)
    80002faa:	64a2                	ld	s1,8(sp)
    80002fac:	6902                	ld	s2,0(sp)
    80002fae:	6105                	add	sp,sp,32
    80002fb0:	8082                	ret
    panic("brelse");
    80002fb2:	00005517          	auipc	a0,0x5
    80002fb6:	55650513          	add	a0,a0,1366 # 80008508 <syscalls+0xe0>
    80002fba:	ffffd097          	auipc	ra,0xffffd
    80002fbe:	588080e7          	jalr	1416(ra) # 80000542 <panic>

0000000080002fc2 <bpin>:

void
bpin(struct buf *b) {
    80002fc2:	1101                	add	sp,sp,-32
    80002fc4:	ec06                	sd	ra,24(sp)
    80002fc6:	e822                	sd	s0,16(sp)
    80002fc8:	e426                	sd	s1,8(sp)
    80002fca:	1000                	add	s0,sp,32
    80002fcc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002fce:	00014517          	auipc	a0,0x14
    80002fd2:	7b250513          	add	a0,a0,1970 # 80017780 <bcache>
    80002fd6:	ffffe097          	auipc	ra,0xffffe
    80002fda:	c26080e7          	jalr	-986(ra) # 80000bfc <acquire>
  b->refcnt++;
    80002fde:	40bc                	lw	a5,64(s1)
    80002fe0:	2785                	addw	a5,a5,1
    80002fe2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002fe4:	00014517          	auipc	a0,0x14
    80002fe8:	79c50513          	add	a0,a0,1948 # 80017780 <bcache>
    80002fec:	ffffe097          	auipc	ra,0xffffe
    80002ff0:	cc4080e7          	jalr	-828(ra) # 80000cb0 <release>
}
    80002ff4:	60e2                	ld	ra,24(sp)
    80002ff6:	6442                	ld	s0,16(sp)
    80002ff8:	64a2                	ld	s1,8(sp)
    80002ffa:	6105                	add	sp,sp,32
    80002ffc:	8082                	ret

0000000080002ffe <bunpin>:

void
bunpin(struct buf *b) {
    80002ffe:	1101                	add	sp,sp,-32
    80003000:	ec06                	sd	ra,24(sp)
    80003002:	e822                	sd	s0,16(sp)
    80003004:	e426                	sd	s1,8(sp)
    80003006:	1000                	add	s0,sp,32
    80003008:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000300a:	00014517          	auipc	a0,0x14
    8000300e:	77650513          	add	a0,a0,1910 # 80017780 <bcache>
    80003012:	ffffe097          	auipc	ra,0xffffe
    80003016:	bea080e7          	jalr	-1046(ra) # 80000bfc <acquire>
  b->refcnt--;
    8000301a:	40bc                	lw	a5,64(s1)
    8000301c:	37fd                	addw	a5,a5,-1
    8000301e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003020:	00014517          	auipc	a0,0x14
    80003024:	76050513          	add	a0,a0,1888 # 80017780 <bcache>
    80003028:	ffffe097          	auipc	ra,0xffffe
    8000302c:	c88080e7          	jalr	-888(ra) # 80000cb0 <release>
}
    80003030:	60e2                	ld	ra,24(sp)
    80003032:	6442                	ld	s0,16(sp)
    80003034:	64a2                	ld	s1,8(sp)
    80003036:	6105                	add	sp,sp,32
    80003038:	8082                	ret

000000008000303a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000303a:	1101                	add	sp,sp,-32
    8000303c:	ec06                	sd	ra,24(sp)
    8000303e:	e822                	sd	s0,16(sp)
    80003040:	e426                	sd	s1,8(sp)
    80003042:	e04a                	sd	s2,0(sp)
    80003044:	1000                	add	s0,sp,32
    80003046:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003048:	00d5d59b          	srlw	a1,a1,0xd
    8000304c:	0001d797          	auipc	a5,0x1d
    80003050:	e107a783          	lw	a5,-496(a5) # 8001fe5c <sb+0x1c>
    80003054:	9dbd                	addw	a1,a1,a5
    80003056:	00000097          	auipc	ra,0x0
    8000305a:	da0080e7          	jalr	-608(ra) # 80002df6 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000305e:	0074f713          	and	a4,s1,7
    80003062:	4785                	li	a5,1
    80003064:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003068:	14ce                	sll	s1,s1,0x33
    8000306a:	90d9                	srl	s1,s1,0x36
    8000306c:	00950733          	add	a4,a0,s1
    80003070:	05874703          	lbu	a4,88(a4)
    80003074:	00e7f6b3          	and	a3,a5,a4
    80003078:	c69d                	beqz	a3,800030a6 <bfree+0x6c>
    8000307a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000307c:	94aa                	add	s1,s1,a0
    8000307e:	fff7c793          	not	a5,a5
    80003082:	8f7d                	and	a4,a4,a5
    80003084:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003088:	00001097          	auipc	ra,0x1
    8000308c:	0d8080e7          	jalr	216(ra) # 80004160 <log_write>
  brelse(bp);
    80003090:	854a                	mv	a0,s2
    80003092:	00000097          	auipc	ra,0x0
    80003096:	e94080e7          	jalr	-364(ra) # 80002f26 <brelse>
}
    8000309a:	60e2                	ld	ra,24(sp)
    8000309c:	6442                	ld	s0,16(sp)
    8000309e:	64a2                	ld	s1,8(sp)
    800030a0:	6902                	ld	s2,0(sp)
    800030a2:	6105                	add	sp,sp,32
    800030a4:	8082                	ret
    panic("freeing free block");
    800030a6:	00005517          	auipc	a0,0x5
    800030aa:	46a50513          	add	a0,a0,1130 # 80008510 <syscalls+0xe8>
    800030ae:	ffffd097          	auipc	ra,0xffffd
    800030b2:	494080e7          	jalr	1172(ra) # 80000542 <panic>

00000000800030b6 <balloc>:
{
    800030b6:	711d                	add	sp,sp,-96
    800030b8:	ec86                	sd	ra,88(sp)
    800030ba:	e8a2                	sd	s0,80(sp)
    800030bc:	e4a6                	sd	s1,72(sp)
    800030be:	e0ca                	sd	s2,64(sp)
    800030c0:	fc4e                	sd	s3,56(sp)
    800030c2:	f852                	sd	s4,48(sp)
    800030c4:	f456                	sd	s5,40(sp)
    800030c6:	f05a                	sd	s6,32(sp)
    800030c8:	ec5e                	sd	s7,24(sp)
    800030ca:	e862                	sd	s8,16(sp)
    800030cc:	e466                	sd	s9,8(sp)
    800030ce:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800030d0:	0001d797          	auipc	a5,0x1d
    800030d4:	d747a783          	lw	a5,-652(a5) # 8001fe44 <sb+0x4>
    800030d8:	cbc1                	beqz	a5,80003168 <balloc+0xb2>
    800030da:	8baa                	mv	s7,a0
    800030dc:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800030de:	0001db17          	auipc	s6,0x1d
    800030e2:	d62b0b13          	add	s6,s6,-670 # 8001fe40 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030e6:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800030e8:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030ea:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800030ec:	6c89                	lui	s9,0x2
    800030ee:	a831                	j	8000310a <balloc+0x54>
    brelse(bp);
    800030f0:	854a                	mv	a0,s2
    800030f2:	00000097          	auipc	ra,0x0
    800030f6:	e34080e7          	jalr	-460(ra) # 80002f26 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800030fa:	015c87bb          	addw	a5,s9,s5
    800030fe:	00078a9b          	sext.w	s5,a5
    80003102:	004b2703          	lw	a4,4(s6)
    80003106:	06eaf163          	bgeu	s5,a4,80003168 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    8000310a:	41fad79b          	sraw	a5,s5,0x1f
    8000310e:	0137d79b          	srlw	a5,a5,0x13
    80003112:	015787bb          	addw	a5,a5,s5
    80003116:	40d7d79b          	sraw	a5,a5,0xd
    8000311a:	01cb2583          	lw	a1,28(s6)
    8000311e:	9dbd                	addw	a1,a1,a5
    80003120:	855e                	mv	a0,s7
    80003122:	00000097          	auipc	ra,0x0
    80003126:	cd4080e7          	jalr	-812(ra) # 80002df6 <bread>
    8000312a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000312c:	004b2503          	lw	a0,4(s6)
    80003130:	000a849b          	sext.w	s1,s5
    80003134:	8762                	mv	a4,s8
    80003136:	faa4fde3          	bgeu	s1,a0,800030f0 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000313a:	00777693          	and	a3,a4,7
    8000313e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003142:	41f7579b          	sraw	a5,a4,0x1f
    80003146:	01d7d79b          	srlw	a5,a5,0x1d
    8000314a:	9fb9                	addw	a5,a5,a4
    8000314c:	4037d79b          	sraw	a5,a5,0x3
    80003150:	00f90633          	add	a2,s2,a5
    80003154:	05864603          	lbu	a2,88(a2)
    80003158:	00c6f5b3          	and	a1,a3,a2
    8000315c:	cd91                	beqz	a1,80003178 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000315e:	2705                	addw	a4,a4,1
    80003160:	2485                	addw	s1,s1,1
    80003162:	fd471ae3          	bne	a4,s4,80003136 <balloc+0x80>
    80003166:	b769                	j	800030f0 <balloc+0x3a>
  panic("balloc: out of blocks");
    80003168:	00005517          	auipc	a0,0x5
    8000316c:	3c050513          	add	a0,a0,960 # 80008528 <syscalls+0x100>
    80003170:	ffffd097          	auipc	ra,0xffffd
    80003174:	3d2080e7          	jalr	978(ra) # 80000542 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003178:	97ca                	add	a5,a5,s2
    8000317a:	8e55                	or	a2,a2,a3
    8000317c:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003180:	854a                	mv	a0,s2
    80003182:	00001097          	auipc	ra,0x1
    80003186:	fde080e7          	jalr	-34(ra) # 80004160 <log_write>
        brelse(bp);
    8000318a:	854a                	mv	a0,s2
    8000318c:	00000097          	auipc	ra,0x0
    80003190:	d9a080e7          	jalr	-614(ra) # 80002f26 <brelse>
  bp = bread(dev, bno);
    80003194:	85a6                	mv	a1,s1
    80003196:	855e                	mv	a0,s7
    80003198:	00000097          	auipc	ra,0x0
    8000319c:	c5e080e7          	jalr	-930(ra) # 80002df6 <bread>
    800031a0:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800031a2:	40000613          	li	a2,1024
    800031a6:	4581                	li	a1,0
    800031a8:	05850513          	add	a0,a0,88
    800031ac:	ffffe097          	auipc	ra,0xffffe
    800031b0:	b4c080e7          	jalr	-1204(ra) # 80000cf8 <memset>
  log_write(bp);
    800031b4:	854a                	mv	a0,s2
    800031b6:	00001097          	auipc	ra,0x1
    800031ba:	faa080e7          	jalr	-86(ra) # 80004160 <log_write>
  brelse(bp);
    800031be:	854a                	mv	a0,s2
    800031c0:	00000097          	auipc	ra,0x0
    800031c4:	d66080e7          	jalr	-666(ra) # 80002f26 <brelse>
}
    800031c8:	8526                	mv	a0,s1
    800031ca:	60e6                	ld	ra,88(sp)
    800031cc:	6446                	ld	s0,80(sp)
    800031ce:	64a6                	ld	s1,72(sp)
    800031d0:	6906                	ld	s2,64(sp)
    800031d2:	79e2                	ld	s3,56(sp)
    800031d4:	7a42                	ld	s4,48(sp)
    800031d6:	7aa2                	ld	s5,40(sp)
    800031d8:	7b02                	ld	s6,32(sp)
    800031da:	6be2                	ld	s7,24(sp)
    800031dc:	6c42                	ld	s8,16(sp)
    800031de:	6ca2                	ld	s9,8(sp)
    800031e0:	6125                	add	sp,sp,96
    800031e2:	8082                	ret

00000000800031e4 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800031e4:	7179                	add	sp,sp,-48
    800031e6:	f406                	sd	ra,40(sp)
    800031e8:	f022                	sd	s0,32(sp)
    800031ea:	ec26                	sd	s1,24(sp)
    800031ec:	e84a                	sd	s2,16(sp)
    800031ee:	e44e                	sd	s3,8(sp)
    800031f0:	e052                	sd	s4,0(sp)
    800031f2:	1800                	add	s0,sp,48
    800031f4:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800031f6:	47ad                	li	a5,11
    800031f8:	04b7fe63          	bgeu	a5,a1,80003254 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800031fc:	ff45849b          	addw	s1,a1,-12
    80003200:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003204:	0ff00793          	li	a5,255
    80003208:	0ae7e463          	bltu	a5,a4,800032b0 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000320c:	08052583          	lw	a1,128(a0)
    80003210:	c5b5                	beqz	a1,8000327c <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003212:	00092503          	lw	a0,0(s2)
    80003216:	00000097          	auipc	ra,0x0
    8000321a:	be0080e7          	jalr	-1056(ra) # 80002df6 <bread>
    8000321e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003220:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    80003224:	02049713          	sll	a4,s1,0x20
    80003228:	01e75593          	srl	a1,a4,0x1e
    8000322c:	00b784b3          	add	s1,a5,a1
    80003230:	0004a983          	lw	s3,0(s1)
    80003234:	04098e63          	beqz	s3,80003290 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003238:	8552                	mv	a0,s4
    8000323a:	00000097          	auipc	ra,0x0
    8000323e:	cec080e7          	jalr	-788(ra) # 80002f26 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003242:	854e                	mv	a0,s3
    80003244:	70a2                	ld	ra,40(sp)
    80003246:	7402                	ld	s0,32(sp)
    80003248:	64e2                	ld	s1,24(sp)
    8000324a:	6942                	ld	s2,16(sp)
    8000324c:	69a2                	ld	s3,8(sp)
    8000324e:	6a02                	ld	s4,0(sp)
    80003250:	6145                	add	sp,sp,48
    80003252:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80003254:	02059793          	sll	a5,a1,0x20
    80003258:	01e7d593          	srl	a1,a5,0x1e
    8000325c:	00b504b3          	add	s1,a0,a1
    80003260:	0504a983          	lw	s3,80(s1)
    80003264:	fc099fe3          	bnez	s3,80003242 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003268:	4108                	lw	a0,0(a0)
    8000326a:	00000097          	auipc	ra,0x0
    8000326e:	e4c080e7          	jalr	-436(ra) # 800030b6 <balloc>
    80003272:	0005099b          	sext.w	s3,a0
    80003276:	0534a823          	sw	s3,80(s1)
    8000327a:	b7e1                	j	80003242 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000327c:	4108                	lw	a0,0(a0)
    8000327e:	00000097          	auipc	ra,0x0
    80003282:	e38080e7          	jalr	-456(ra) # 800030b6 <balloc>
    80003286:	0005059b          	sext.w	a1,a0
    8000328a:	08b92023          	sw	a1,128(s2)
    8000328e:	b751                	j	80003212 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003290:	00092503          	lw	a0,0(s2)
    80003294:	00000097          	auipc	ra,0x0
    80003298:	e22080e7          	jalr	-478(ra) # 800030b6 <balloc>
    8000329c:	0005099b          	sext.w	s3,a0
    800032a0:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800032a4:	8552                	mv	a0,s4
    800032a6:	00001097          	auipc	ra,0x1
    800032aa:	eba080e7          	jalr	-326(ra) # 80004160 <log_write>
    800032ae:	b769                	j	80003238 <bmap+0x54>
  panic("bmap: out of range");
    800032b0:	00005517          	auipc	a0,0x5
    800032b4:	29050513          	add	a0,a0,656 # 80008540 <syscalls+0x118>
    800032b8:	ffffd097          	auipc	ra,0xffffd
    800032bc:	28a080e7          	jalr	650(ra) # 80000542 <panic>

00000000800032c0 <iget>:
{
    800032c0:	7179                	add	sp,sp,-48
    800032c2:	f406                	sd	ra,40(sp)
    800032c4:	f022                	sd	s0,32(sp)
    800032c6:	ec26                	sd	s1,24(sp)
    800032c8:	e84a                	sd	s2,16(sp)
    800032ca:	e44e                	sd	s3,8(sp)
    800032cc:	e052                	sd	s4,0(sp)
    800032ce:	1800                	add	s0,sp,48
    800032d0:	89aa                	mv	s3,a0
    800032d2:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    800032d4:	0001d517          	auipc	a0,0x1d
    800032d8:	b8c50513          	add	a0,a0,-1140 # 8001fe60 <icache>
    800032dc:	ffffe097          	auipc	ra,0xffffe
    800032e0:	920080e7          	jalr	-1760(ra) # 80000bfc <acquire>
  empty = 0;
    800032e4:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800032e6:	0001d497          	auipc	s1,0x1d
    800032ea:	b9248493          	add	s1,s1,-1134 # 8001fe78 <icache+0x18>
    800032ee:	0001e697          	auipc	a3,0x1e
    800032f2:	61a68693          	add	a3,a3,1562 # 80021908 <log>
    800032f6:	a039                	j	80003304 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800032f8:	02090b63          	beqz	s2,8000332e <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800032fc:	08848493          	add	s1,s1,136
    80003300:	02d48a63          	beq	s1,a3,80003334 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003304:	449c                	lw	a5,8(s1)
    80003306:	fef059e3          	blez	a5,800032f8 <iget+0x38>
    8000330a:	4098                	lw	a4,0(s1)
    8000330c:	ff3716e3          	bne	a4,s3,800032f8 <iget+0x38>
    80003310:	40d8                	lw	a4,4(s1)
    80003312:	ff4713e3          	bne	a4,s4,800032f8 <iget+0x38>
      ip->ref++;
    80003316:	2785                	addw	a5,a5,1
    80003318:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    8000331a:	0001d517          	auipc	a0,0x1d
    8000331e:	b4650513          	add	a0,a0,-1210 # 8001fe60 <icache>
    80003322:	ffffe097          	auipc	ra,0xffffe
    80003326:	98e080e7          	jalr	-1650(ra) # 80000cb0 <release>
      return ip;
    8000332a:	8926                	mv	s2,s1
    8000332c:	a03d                	j	8000335a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000332e:	f7f9                	bnez	a5,800032fc <iget+0x3c>
    80003330:	8926                	mv	s2,s1
    80003332:	b7e9                	j	800032fc <iget+0x3c>
  if(empty == 0)
    80003334:	02090c63          	beqz	s2,8000336c <iget+0xac>
  ip->dev = dev;
    80003338:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000333c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003340:	4785                	li	a5,1
    80003342:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003346:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    8000334a:	0001d517          	auipc	a0,0x1d
    8000334e:	b1650513          	add	a0,a0,-1258 # 8001fe60 <icache>
    80003352:	ffffe097          	auipc	ra,0xffffe
    80003356:	95e080e7          	jalr	-1698(ra) # 80000cb0 <release>
}
    8000335a:	854a                	mv	a0,s2
    8000335c:	70a2                	ld	ra,40(sp)
    8000335e:	7402                	ld	s0,32(sp)
    80003360:	64e2                	ld	s1,24(sp)
    80003362:	6942                	ld	s2,16(sp)
    80003364:	69a2                	ld	s3,8(sp)
    80003366:	6a02                	ld	s4,0(sp)
    80003368:	6145                	add	sp,sp,48
    8000336a:	8082                	ret
    panic("iget: no inodes");
    8000336c:	00005517          	auipc	a0,0x5
    80003370:	1ec50513          	add	a0,a0,492 # 80008558 <syscalls+0x130>
    80003374:	ffffd097          	auipc	ra,0xffffd
    80003378:	1ce080e7          	jalr	462(ra) # 80000542 <panic>

000000008000337c <fsinit>:
fsinit(int dev) {
    8000337c:	7179                	add	sp,sp,-48
    8000337e:	f406                	sd	ra,40(sp)
    80003380:	f022                	sd	s0,32(sp)
    80003382:	ec26                	sd	s1,24(sp)
    80003384:	e84a                	sd	s2,16(sp)
    80003386:	e44e                	sd	s3,8(sp)
    80003388:	1800                	add	s0,sp,48
    8000338a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000338c:	4585                	li	a1,1
    8000338e:	00000097          	auipc	ra,0x0
    80003392:	a68080e7          	jalr	-1432(ra) # 80002df6 <bread>
    80003396:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003398:	0001d997          	auipc	s3,0x1d
    8000339c:	aa898993          	add	s3,s3,-1368 # 8001fe40 <sb>
    800033a0:	02000613          	li	a2,32
    800033a4:	05850593          	add	a1,a0,88
    800033a8:	854e                	mv	a0,s3
    800033aa:	ffffe097          	auipc	ra,0xffffe
    800033ae:	9aa080e7          	jalr	-1622(ra) # 80000d54 <memmove>
  brelse(bp);
    800033b2:	8526                	mv	a0,s1
    800033b4:	00000097          	auipc	ra,0x0
    800033b8:	b72080e7          	jalr	-1166(ra) # 80002f26 <brelse>
  if(sb.magic != FSMAGIC)
    800033bc:	0009a703          	lw	a4,0(s3)
    800033c0:	102037b7          	lui	a5,0x10203
    800033c4:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800033c8:	02f71263          	bne	a4,a5,800033ec <fsinit+0x70>
  initlog(dev, &sb);
    800033cc:	0001d597          	auipc	a1,0x1d
    800033d0:	a7458593          	add	a1,a1,-1420 # 8001fe40 <sb>
    800033d4:	854a                	mv	a0,s2
    800033d6:	00001097          	auipc	ra,0x1
    800033da:	b24080e7          	jalr	-1244(ra) # 80003efa <initlog>
}
    800033de:	70a2                	ld	ra,40(sp)
    800033e0:	7402                	ld	s0,32(sp)
    800033e2:	64e2                	ld	s1,24(sp)
    800033e4:	6942                	ld	s2,16(sp)
    800033e6:	69a2                	ld	s3,8(sp)
    800033e8:	6145                	add	sp,sp,48
    800033ea:	8082                	ret
    panic("invalid file system");
    800033ec:	00005517          	auipc	a0,0x5
    800033f0:	17c50513          	add	a0,a0,380 # 80008568 <syscalls+0x140>
    800033f4:	ffffd097          	auipc	ra,0xffffd
    800033f8:	14e080e7          	jalr	334(ra) # 80000542 <panic>

00000000800033fc <iinit>:
{
    800033fc:	7179                	add	sp,sp,-48
    800033fe:	f406                	sd	ra,40(sp)
    80003400:	f022                	sd	s0,32(sp)
    80003402:	ec26                	sd	s1,24(sp)
    80003404:	e84a                	sd	s2,16(sp)
    80003406:	e44e                	sd	s3,8(sp)
    80003408:	1800                	add	s0,sp,48
  initlock(&icache.lock, "icache");
    8000340a:	00005597          	auipc	a1,0x5
    8000340e:	17658593          	add	a1,a1,374 # 80008580 <syscalls+0x158>
    80003412:	0001d517          	auipc	a0,0x1d
    80003416:	a4e50513          	add	a0,a0,-1458 # 8001fe60 <icache>
    8000341a:	ffffd097          	auipc	ra,0xffffd
    8000341e:	752080e7          	jalr	1874(ra) # 80000b6c <initlock>
  for(i = 0; i < NINODE; i++) {
    80003422:	0001d497          	auipc	s1,0x1d
    80003426:	a6648493          	add	s1,s1,-1434 # 8001fe88 <icache+0x28>
    8000342a:	0001e997          	auipc	s3,0x1e
    8000342e:	4ee98993          	add	s3,s3,1262 # 80021918 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003432:	00005917          	auipc	s2,0x5
    80003436:	15690913          	add	s2,s2,342 # 80008588 <syscalls+0x160>
    8000343a:	85ca                	mv	a1,s2
    8000343c:	8526                	mv	a0,s1
    8000343e:	00001097          	auipc	ra,0x1
    80003442:	e0e080e7          	jalr	-498(ra) # 8000424c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003446:	08848493          	add	s1,s1,136
    8000344a:	ff3498e3          	bne	s1,s3,8000343a <iinit+0x3e>
}
    8000344e:	70a2                	ld	ra,40(sp)
    80003450:	7402                	ld	s0,32(sp)
    80003452:	64e2                	ld	s1,24(sp)
    80003454:	6942                	ld	s2,16(sp)
    80003456:	69a2                	ld	s3,8(sp)
    80003458:	6145                	add	sp,sp,48
    8000345a:	8082                	ret

000000008000345c <ialloc>:
{
    8000345c:	7139                	add	sp,sp,-64
    8000345e:	fc06                	sd	ra,56(sp)
    80003460:	f822                	sd	s0,48(sp)
    80003462:	f426                	sd	s1,40(sp)
    80003464:	f04a                	sd	s2,32(sp)
    80003466:	ec4e                	sd	s3,24(sp)
    80003468:	e852                	sd	s4,16(sp)
    8000346a:	e456                	sd	s5,8(sp)
    8000346c:	e05a                	sd	s6,0(sp)
    8000346e:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003470:	0001d717          	auipc	a4,0x1d
    80003474:	9dc72703          	lw	a4,-1572(a4) # 8001fe4c <sb+0xc>
    80003478:	4785                	li	a5,1
    8000347a:	04e7f863          	bgeu	a5,a4,800034ca <ialloc+0x6e>
    8000347e:	8aaa                	mv	s5,a0
    80003480:	8b2e                	mv	s6,a1
    80003482:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003484:	0001da17          	auipc	s4,0x1d
    80003488:	9bca0a13          	add	s4,s4,-1604 # 8001fe40 <sb>
    8000348c:	00495593          	srl	a1,s2,0x4
    80003490:	018a2783          	lw	a5,24(s4)
    80003494:	9dbd                	addw	a1,a1,a5
    80003496:	8556                	mv	a0,s5
    80003498:	00000097          	auipc	ra,0x0
    8000349c:	95e080e7          	jalr	-1698(ra) # 80002df6 <bread>
    800034a0:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800034a2:	05850993          	add	s3,a0,88
    800034a6:	00f97793          	and	a5,s2,15
    800034aa:	079a                	sll	a5,a5,0x6
    800034ac:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800034ae:	00099783          	lh	a5,0(s3)
    800034b2:	c785                	beqz	a5,800034da <ialloc+0x7e>
    brelse(bp);
    800034b4:	00000097          	auipc	ra,0x0
    800034b8:	a72080e7          	jalr	-1422(ra) # 80002f26 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800034bc:	0905                	add	s2,s2,1
    800034be:	00ca2703          	lw	a4,12(s4)
    800034c2:	0009079b          	sext.w	a5,s2
    800034c6:	fce7e3e3          	bltu	a5,a4,8000348c <ialloc+0x30>
  panic("ialloc: no inodes");
    800034ca:	00005517          	auipc	a0,0x5
    800034ce:	0c650513          	add	a0,a0,198 # 80008590 <syscalls+0x168>
    800034d2:	ffffd097          	auipc	ra,0xffffd
    800034d6:	070080e7          	jalr	112(ra) # 80000542 <panic>
      memset(dip, 0, sizeof(*dip));
    800034da:	04000613          	li	a2,64
    800034de:	4581                	li	a1,0
    800034e0:	854e                	mv	a0,s3
    800034e2:	ffffe097          	auipc	ra,0xffffe
    800034e6:	816080e7          	jalr	-2026(ra) # 80000cf8 <memset>
      dip->type = type;
    800034ea:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800034ee:	8526                	mv	a0,s1
    800034f0:	00001097          	auipc	ra,0x1
    800034f4:	c70080e7          	jalr	-912(ra) # 80004160 <log_write>
      brelse(bp);
    800034f8:	8526                	mv	a0,s1
    800034fa:	00000097          	auipc	ra,0x0
    800034fe:	a2c080e7          	jalr	-1492(ra) # 80002f26 <brelse>
      return iget(dev, inum);
    80003502:	0009059b          	sext.w	a1,s2
    80003506:	8556                	mv	a0,s5
    80003508:	00000097          	auipc	ra,0x0
    8000350c:	db8080e7          	jalr	-584(ra) # 800032c0 <iget>
}
    80003510:	70e2                	ld	ra,56(sp)
    80003512:	7442                	ld	s0,48(sp)
    80003514:	74a2                	ld	s1,40(sp)
    80003516:	7902                	ld	s2,32(sp)
    80003518:	69e2                	ld	s3,24(sp)
    8000351a:	6a42                	ld	s4,16(sp)
    8000351c:	6aa2                	ld	s5,8(sp)
    8000351e:	6b02                	ld	s6,0(sp)
    80003520:	6121                	add	sp,sp,64
    80003522:	8082                	ret

0000000080003524 <iupdate>:
{
    80003524:	1101                	add	sp,sp,-32
    80003526:	ec06                	sd	ra,24(sp)
    80003528:	e822                	sd	s0,16(sp)
    8000352a:	e426                	sd	s1,8(sp)
    8000352c:	e04a                	sd	s2,0(sp)
    8000352e:	1000                	add	s0,sp,32
    80003530:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003532:	415c                	lw	a5,4(a0)
    80003534:	0047d79b          	srlw	a5,a5,0x4
    80003538:	0001d597          	auipc	a1,0x1d
    8000353c:	9205a583          	lw	a1,-1760(a1) # 8001fe58 <sb+0x18>
    80003540:	9dbd                	addw	a1,a1,a5
    80003542:	4108                	lw	a0,0(a0)
    80003544:	00000097          	auipc	ra,0x0
    80003548:	8b2080e7          	jalr	-1870(ra) # 80002df6 <bread>
    8000354c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000354e:	05850793          	add	a5,a0,88
    80003552:	40d8                	lw	a4,4(s1)
    80003554:	8b3d                	and	a4,a4,15
    80003556:	071a                	sll	a4,a4,0x6
    80003558:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000355a:	04449703          	lh	a4,68(s1)
    8000355e:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003562:	04649703          	lh	a4,70(s1)
    80003566:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000356a:	04849703          	lh	a4,72(s1)
    8000356e:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003572:	04a49703          	lh	a4,74(s1)
    80003576:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000357a:	44f8                	lw	a4,76(s1)
    8000357c:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000357e:	03400613          	li	a2,52
    80003582:	05048593          	add	a1,s1,80
    80003586:	00c78513          	add	a0,a5,12
    8000358a:	ffffd097          	auipc	ra,0xffffd
    8000358e:	7ca080e7          	jalr	1994(ra) # 80000d54 <memmove>
  log_write(bp);
    80003592:	854a                	mv	a0,s2
    80003594:	00001097          	auipc	ra,0x1
    80003598:	bcc080e7          	jalr	-1076(ra) # 80004160 <log_write>
  brelse(bp);
    8000359c:	854a                	mv	a0,s2
    8000359e:	00000097          	auipc	ra,0x0
    800035a2:	988080e7          	jalr	-1656(ra) # 80002f26 <brelse>
}
    800035a6:	60e2                	ld	ra,24(sp)
    800035a8:	6442                	ld	s0,16(sp)
    800035aa:	64a2                	ld	s1,8(sp)
    800035ac:	6902                	ld	s2,0(sp)
    800035ae:	6105                	add	sp,sp,32
    800035b0:	8082                	ret

00000000800035b2 <idup>:
{
    800035b2:	1101                	add	sp,sp,-32
    800035b4:	ec06                	sd	ra,24(sp)
    800035b6:	e822                	sd	s0,16(sp)
    800035b8:	e426                	sd	s1,8(sp)
    800035ba:	1000                	add	s0,sp,32
    800035bc:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800035be:	0001d517          	auipc	a0,0x1d
    800035c2:	8a250513          	add	a0,a0,-1886 # 8001fe60 <icache>
    800035c6:	ffffd097          	auipc	ra,0xffffd
    800035ca:	636080e7          	jalr	1590(ra) # 80000bfc <acquire>
  ip->ref++;
    800035ce:	449c                	lw	a5,8(s1)
    800035d0:	2785                	addw	a5,a5,1
    800035d2:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800035d4:	0001d517          	auipc	a0,0x1d
    800035d8:	88c50513          	add	a0,a0,-1908 # 8001fe60 <icache>
    800035dc:	ffffd097          	auipc	ra,0xffffd
    800035e0:	6d4080e7          	jalr	1748(ra) # 80000cb0 <release>
}
    800035e4:	8526                	mv	a0,s1
    800035e6:	60e2                	ld	ra,24(sp)
    800035e8:	6442                	ld	s0,16(sp)
    800035ea:	64a2                	ld	s1,8(sp)
    800035ec:	6105                	add	sp,sp,32
    800035ee:	8082                	ret

00000000800035f0 <ilock>:
{
    800035f0:	1101                	add	sp,sp,-32
    800035f2:	ec06                	sd	ra,24(sp)
    800035f4:	e822                	sd	s0,16(sp)
    800035f6:	e426                	sd	s1,8(sp)
    800035f8:	e04a                	sd	s2,0(sp)
    800035fa:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800035fc:	c115                	beqz	a0,80003620 <ilock+0x30>
    800035fe:	84aa                	mv	s1,a0
    80003600:	451c                	lw	a5,8(a0)
    80003602:	00f05f63          	blez	a5,80003620 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003606:	0541                	add	a0,a0,16
    80003608:	00001097          	auipc	ra,0x1
    8000360c:	c7e080e7          	jalr	-898(ra) # 80004286 <acquiresleep>
  if(ip->valid == 0){
    80003610:	40bc                	lw	a5,64(s1)
    80003612:	cf99                	beqz	a5,80003630 <ilock+0x40>
}
    80003614:	60e2                	ld	ra,24(sp)
    80003616:	6442                	ld	s0,16(sp)
    80003618:	64a2                	ld	s1,8(sp)
    8000361a:	6902                	ld	s2,0(sp)
    8000361c:	6105                	add	sp,sp,32
    8000361e:	8082                	ret
    panic("ilock");
    80003620:	00005517          	auipc	a0,0x5
    80003624:	f8850513          	add	a0,a0,-120 # 800085a8 <syscalls+0x180>
    80003628:	ffffd097          	auipc	ra,0xffffd
    8000362c:	f1a080e7          	jalr	-230(ra) # 80000542 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003630:	40dc                	lw	a5,4(s1)
    80003632:	0047d79b          	srlw	a5,a5,0x4
    80003636:	0001d597          	auipc	a1,0x1d
    8000363a:	8225a583          	lw	a1,-2014(a1) # 8001fe58 <sb+0x18>
    8000363e:	9dbd                	addw	a1,a1,a5
    80003640:	4088                	lw	a0,0(s1)
    80003642:	fffff097          	auipc	ra,0xfffff
    80003646:	7b4080e7          	jalr	1972(ra) # 80002df6 <bread>
    8000364a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000364c:	05850593          	add	a1,a0,88
    80003650:	40dc                	lw	a5,4(s1)
    80003652:	8bbd                	and	a5,a5,15
    80003654:	079a                	sll	a5,a5,0x6
    80003656:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003658:	00059783          	lh	a5,0(a1)
    8000365c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003660:	00259783          	lh	a5,2(a1)
    80003664:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003668:	00459783          	lh	a5,4(a1)
    8000366c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003670:	00659783          	lh	a5,6(a1)
    80003674:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003678:	459c                	lw	a5,8(a1)
    8000367a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000367c:	03400613          	li	a2,52
    80003680:	05b1                	add	a1,a1,12
    80003682:	05048513          	add	a0,s1,80
    80003686:	ffffd097          	auipc	ra,0xffffd
    8000368a:	6ce080e7          	jalr	1742(ra) # 80000d54 <memmove>
    brelse(bp);
    8000368e:	854a                	mv	a0,s2
    80003690:	00000097          	auipc	ra,0x0
    80003694:	896080e7          	jalr	-1898(ra) # 80002f26 <brelse>
    ip->valid = 1;
    80003698:	4785                	li	a5,1
    8000369a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000369c:	04449783          	lh	a5,68(s1)
    800036a0:	fbb5                	bnez	a5,80003614 <ilock+0x24>
      panic("ilock: no type");
    800036a2:	00005517          	auipc	a0,0x5
    800036a6:	f0e50513          	add	a0,a0,-242 # 800085b0 <syscalls+0x188>
    800036aa:	ffffd097          	auipc	ra,0xffffd
    800036ae:	e98080e7          	jalr	-360(ra) # 80000542 <panic>

00000000800036b2 <iunlock>:
{
    800036b2:	1101                	add	sp,sp,-32
    800036b4:	ec06                	sd	ra,24(sp)
    800036b6:	e822                	sd	s0,16(sp)
    800036b8:	e426                	sd	s1,8(sp)
    800036ba:	e04a                	sd	s2,0(sp)
    800036bc:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800036be:	c905                	beqz	a0,800036ee <iunlock+0x3c>
    800036c0:	84aa                	mv	s1,a0
    800036c2:	01050913          	add	s2,a0,16
    800036c6:	854a                	mv	a0,s2
    800036c8:	00001097          	auipc	ra,0x1
    800036cc:	c58080e7          	jalr	-936(ra) # 80004320 <holdingsleep>
    800036d0:	cd19                	beqz	a0,800036ee <iunlock+0x3c>
    800036d2:	449c                	lw	a5,8(s1)
    800036d4:	00f05d63          	blez	a5,800036ee <iunlock+0x3c>
  releasesleep(&ip->lock);
    800036d8:	854a                	mv	a0,s2
    800036da:	00001097          	auipc	ra,0x1
    800036de:	c02080e7          	jalr	-1022(ra) # 800042dc <releasesleep>
}
    800036e2:	60e2                	ld	ra,24(sp)
    800036e4:	6442                	ld	s0,16(sp)
    800036e6:	64a2                	ld	s1,8(sp)
    800036e8:	6902                	ld	s2,0(sp)
    800036ea:	6105                	add	sp,sp,32
    800036ec:	8082                	ret
    panic("iunlock");
    800036ee:	00005517          	auipc	a0,0x5
    800036f2:	ed250513          	add	a0,a0,-302 # 800085c0 <syscalls+0x198>
    800036f6:	ffffd097          	auipc	ra,0xffffd
    800036fa:	e4c080e7          	jalr	-436(ra) # 80000542 <panic>

00000000800036fe <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800036fe:	7179                	add	sp,sp,-48
    80003700:	f406                	sd	ra,40(sp)
    80003702:	f022                	sd	s0,32(sp)
    80003704:	ec26                	sd	s1,24(sp)
    80003706:	e84a                	sd	s2,16(sp)
    80003708:	e44e                	sd	s3,8(sp)
    8000370a:	e052                	sd	s4,0(sp)
    8000370c:	1800                	add	s0,sp,48
    8000370e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003710:	05050493          	add	s1,a0,80
    80003714:	08050913          	add	s2,a0,128
    80003718:	a021                	j	80003720 <itrunc+0x22>
    8000371a:	0491                	add	s1,s1,4
    8000371c:	01248d63          	beq	s1,s2,80003736 <itrunc+0x38>
    if(ip->addrs[i]){
    80003720:	408c                	lw	a1,0(s1)
    80003722:	dde5                	beqz	a1,8000371a <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003724:	0009a503          	lw	a0,0(s3)
    80003728:	00000097          	auipc	ra,0x0
    8000372c:	912080e7          	jalr	-1774(ra) # 8000303a <bfree>
      ip->addrs[i] = 0;
    80003730:	0004a023          	sw	zero,0(s1)
    80003734:	b7dd                	j	8000371a <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003736:	0809a583          	lw	a1,128(s3)
    8000373a:	e185                	bnez	a1,8000375a <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000373c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003740:	854e                	mv	a0,s3
    80003742:	00000097          	auipc	ra,0x0
    80003746:	de2080e7          	jalr	-542(ra) # 80003524 <iupdate>
}
    8000374a:	70a2                	ld	ra,40(sp)
    8000374c:	7402                	ld	s0,32(sp)
    8000374e:	64e2                	ld	s1,24(sp)
    80003750:	6942                	ld	s2,16(sp)
    80003752:	69a2                	ld	s3,8(sp)
    80003754:	6a02                	ld	s4,0(sp)
    80003756:	6145                	add	sp,sp,48
    80003758:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000375a:	0009a503          	lw	a0,0(s3)
    8000375e:	fffff097          	auipc	ra,0xfffff
    80003762:	698080e7          	jalr	1688(ra) # 80002df6 <bread>
    80003766:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003768:	05850493          	add	s1,a0,88
    8000376c:	45850913          	add	s2,a0,1112
    80003770:	a021                	j	80003778 <itrunc+0x7a>
    80003772:	0491                	add	s1,s1,4
    80003774:	01248b63          	beq	s1,s2,8000378a <itrunc+0x8c>
      if(a[j])
    80003778:	408c                	lw	a1,0(s1)
    8000377a:	dde5                	beqz	a1,80003772 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    8000377c:	0009a503          	lw	a0,0(s3)
    80003780:	00000097          	auipc	ra,0x0
    80003784:	8ba080e7          	jalr	-1862(ra) # 8000303a <bfree>
    80003788:	b7ed                	j	80003772 <itrunc+0x74>
    brelse(bp);
    8000378a:	8552                	mv	a0,s4
    8000378c:	fffff097          	auipc	ra,0xfffff
    80003790:	79a080e7          	jalr	1946(ra) # 80002f26 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003794:	0809a583          	lw	a1,128(s3)
    80003798:	0009a503          	lw	a0,0(s3)
    8000379c:	00000097          	auipc	ra,0x0
    800037a0:	89e080e7          	jalr	-1890(ra) # 8000303a <bfree>
    ip->addrs[NDIRECT] = 0;
    800037a4:	0809a023          	sw	zero,128(s3)
    800037a8:	bf51                	j	8000373c <itrunc+0x3e>

00000000800037aa <iput>:
{
    800037aa:	1101                	add	sp,sp,-32
    800037ac:	ec06                	sd	ra,24(sp)
    800037ae:	e822                	sd	s0,16(sp)
    800037b0:	e426                	sd	s1,8(sp)
    800037b2:	e04a                	sd	s2,0(sp)
    800037b4:	1000                	add	s0,sp,32
    800037b6:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800037b8:	0001c517          	auipc	a0,0x1c
    800037bc:	6a850513          	add	a0,a0,1704 # 8001fe60 <icache>
    800037c0:	ffffd097          	auipc	ra,0xffffd
    800037c4:	43c080e7          	jalr	1084(ra) # 80000bfc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800037c8:	4498                	lw	a4,8(s1)
    800037ca:	4785                	li	a5,1
    800037cc:	02f70363          	beq	a4,a5,800037f2 <iput+0x48>
  ip->ref--;
    800037d0:	449c                	lw	a5,8(s1)
    800037d2:	37fd                	addw	a5,a5,-1
    800037d4:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800037d6:	0001c517          	auipc	a0,0x1c
    800037da:	68a50513          	add	a0,a0,1674 # 8001fe60 <icache>
    800037de:	ffffd097          	auipc	ra,0xffffd
    800037e2:	4d2080e7          	jalr	1234(ra) # 80000cb0 <release>
}
    800037e6:	60e2                	ld	ra,24(sp)
    800037e8:	6442                	ld	s0,16(sp)
    800037ea:	64a2                	ld	s1,8(sp)
    800037ec:	6902                	ld	s2,0(sp)
    800037ee:	6105                	add	sp,sp,32
    800037f0:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800037f2:	40bc                	lw	a5,64(s1)
    800037f4:	dff1                	beqz	a5,800037d0 <iput+0x26>
    800037f6:	04a49783          	lh	a5,74(s1)
    800037fa:	fbf9                	bnez	a5,800037d0 <iput+0x26>
    acquiresleep(&ip->lock);
    800037fc:	01048913          	add	s2,s1,16
    80003800:	854a                	mv	a0,s2
    80003802:	00001097          	auipc	ra,0x1
    80003806:	a84080e7          	jalr	-1404(ra) # 80004286 <acquiresleep>
    release(&icache.lock);
    8000380a:	0001c517          	auipc	a0,0x1c
    8000380e:	65650513          	add	a0,a0,1622 # 8001fe60 <icache>
    80003812:	ffffd097          	auipc	ra,0xffffd
    80003816:	49e080e7          	jalr	1182(ra) # 80000cb0 <release>
    itrunc(ip);
    8000381a:	8526                	mv	a0,s1
    8000381c:	00000097          	auipc	ra,0x0
    80003820:	ee2080e7          	jalr	-286(ra) # 800036fe <itrunc>
    ip->type = 0;
    80003824:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003828:	8526                	mv	a0,s1
    8000382a:	00000097          	auipc	ra,0x0
    8000382e:	cfa080e7          	jalr	-774(ra) # 80003524 <iupdate>
    ip->valid = 0;
    80003832:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003836:	854a                	mv	a0,s2
    80003838:	00001097          	auipc	ra,0x1
    8000383c:	aa4080e7          	jalr	-1372(ra) # 800042dc <releasesleep>
    acquire(&icache.lock);
    80003840:	0001c517          	auipc	a0,0x1c
    80003844:	62050513          	add	a0,a0,1568 # 8001fe60 <icache>
    80003848:	ffffd097          	auipc	ra,0xffffd
    8000384c:	3b4080e7          	jalr	948(ra) # 80000bfc <acquire>
    80003850:	b741                	j	800037d0 <iput+0x26>

0000000080003852 <iunlockput>:
{
    80003852:	1101                	add	sp,sp,-32
    80003854:	ec06                	sd	ra,24(sp)
    80003856:	e822                	sd	s0,16(sp)
    80003858:	e426                	sd	s1,8(sp)
    8000385a:	1000                	add	s0,sp,32
    8000385c:	84aa                	mv	s1,a0
  iunlock(ip);
    8000385e:	00000097          	auipc	ra,0x0
    80003862:	e54080e7          	jalr	-428(ra) # 800036b2 <iunlock>
  iput(ip);
    80003866:	8526                	mv	a0,s1
    80003868:	00000097          	auipc	ra,0x0
    8000386c:	f42080e7          	jalr	-190(ra) # 800037aa <iput>
}
    80003870:	60e2                	ld	ra,24(sp)
    80003872:	6442                	ld	s0,16(sp)
    80003874:	64a2                	ld	s1,8(sp)
    80003876:	6105                	add	sp,sp,32
    80003878:	8082                	ret

000000008000387a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000387a:	1141                	add	sp,sp,-16
    8000387c:	e422                	sd	s0,8(sp)
    8000387e:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80003880:	411c                	lw	a5,0(a0)
    80003882:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003884:	415c                	lw	a5,4(a0)
    80003886:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003888:	04451783          	lh	a5,68(a0)
    8000388c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003890:	04a51783          	lh	a5,74(a0)
    80003894:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003898:	04c56783          	lwu	a5,76(a0)
    8000389c:	e99c                	sd	a5,16(a1)
}
    8000389e:	6422                	ld	s0,8(sp)
    800038a0:	0141                	add	sp,sp,16
    800038a2:	8082                	ret

00000000800038a4 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800038a4:	457c                	lw	a5,76(a0)
    800038a6:	0ed7e863          	bltu	a5,a3,80003996 <readi+0xf2>
{
    800038aa:	7159                	add	sp,sp,-112
    800038ac:	f486                	sd	ra,104(sp)
    800038ae:	f0a2                	sd	s0,96(sp)
    800038b0:	eca6                	sd	s1,88(sp)
    800038b2:	e8ca                	sd	s2,80(sp)
    800038b4:	e4ce                	sd	s3,72(sp)
    800038b6:	e0d2                	sd	s4,64(sp)
    800038b8:	fc56                	sd	s5,56(sp)
    800038ba:	f85a                	sd	s6,48(sp)
    800038bc:	f45e                	sd	s7,40(sp)
    800038be:	f062                	sd	s8,32(sp)
    800038c0:	ec66                	sd	s9,24(sp)
    800038c2:	e86a                	sd	s10,16(sp)
    800038c4:	e46e                	sd	s11,8(sp)
    800038c6:	1880                	add	s0,sp,112
    800038c8:	8baa                	mv	s7,a0
    800038ca:	8c2e                	mv	s8,a1
    800038cc:	8ab2                	mv	s5,a2
    800038ce:	84b6                	mv	s1,a3
    800038d0:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800038d2:	9f35                	addw	a4,a4,a3
    return 0;
    800038d4:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800038d6:	08d76f63          	bltu	a4,a3,80003974 <readi+0xd0>
  if(off + n > ip->size)
    800038da:	00e7f463          	bgeu	a5,a4,800038e2 <readi+0x3e>
    n = ip->size - off;
    800038de:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800038e2:	0a0b0863          	beqz	s6,80003992 <readi+0xee>
    800038e6:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800038e8:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800038ec:	5cfd                	li	s9,-1
    800038ee:	a82d                	j	80003928 <readi+0x84>
    800038f0:	020a1d93          	sll	s11,s4,0x20
    800038f4:	020ddd93          	srl	s11,s11,0x20
    800038f8:	05890613          	add	a2,s2,88
    800038fc:	86ee                	mv	a3,s11
    800038fe:	963a                	add	a2,a2,a4
    80003900:	85d6                	mv	a1,s5
    80003902:	8562                	mv	a0,s8
    80003904:	fffff097          	auipc	ra,0xfffff
    80003908:	b30080e7          	jalr	-1232(ra) # 80002434 <either_copyout>
    8000390c:	05950d63          	beq	a0,s9,80003966 <readi+0xc2>
      brelse(bp);
      break;
    }
    brelse(bp);
    80003910:	854a                	mv	a0,s2
    80003912:	fffff097          	auipc	ra,0xfffff
    80003916:	614080e7          	jalr	1556(ra) # 80002f26 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000391a:	013a09bb          	addw	s3,s4,s3
    8000391e:	009a04bb          	addw	s1,s4,s1
    80003922:	9aee                	add	s5,s5,s11
    80003924:	0569f663          	bgeu	s3,s6,80003970 <readi+0xcc>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003928:	000ba903          	lw	s2,0(s7)
    8000392c:	00a4d59b          	srlw	a1,s1,0xa
    80003930:	855e                	mv	a0,s7
    80003932:	00000097          	auipc	ra,0x0
    80003936:	8b2080e7          	jalr	-1870(ra) # 800031e4 <bmap>
    8000393a:	0005059b          	sext.w	a1,a0
    8000393e:	854a                	mv	a0,s2
    80003940:	fffff097          	auipc	ra,0xfffff
    80003944:	4b6080e7          	jalr	1206(ra) # 80002df6 <bread>
    80003948:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000394a:	3ff4f713          	and	a4,s1,1023
    8000394e:	40ed07bb          	subw	a5,s10,a4
    80003952:	413b06bb          	subw	a3,s6,s3
    80003956:	8a3e                	mv	s4,a5
    80003958:	2781                	sext.w	a5,a5
    8000395a:	0006861b          	sext.w	a2,a3
    8000395e:	f8f679e3          	bgeu	a2,a5,800038f0 <readi+0x4c>
    80003962:	8a36                	mv	s4,a3
    80003964:	b771                	j	800038f0 <readi+0x4c>
      brelse(bp);
    80003966:	854a                	mv	a0,s2
    80003968:	fffff097          	auipc	ra,0xfffff
    8000396c:	5be080e7          	jalr	1470(ra) # 80002f26 <brelse>
  }
  return tot;
    80003970:	0009851b          	sext.w	a0,s3
}
    80003974:	70a6                	ld	ra,104(sp)
    80003976:	7406                	ld	s0,96(sp)
    80003978:	64e6                	ld	s1,88(sp)
    8000397a:	6946                	ld	s2,80(sp)
    8000397c:	69a6                	ld	s3,72(sp)
    8000397e:	6a06                	ld	s4,64(sp)
    80003980:	7ae2                	ld	s5,56(sp)
    80003982:	7b42                	ld	s6,48(sp)
    80003984:	7ba2                	ld	s7,40(sp)
    80003986:	7c02                	ld	s8,32(sp)
    80003988:	6ce2                	ld	s9,24(sp)
    8000398a:	6d42                	ld	s10,16(sp)
    8000398c:	6da2                	ld	s11,8(sp)
    8000398e:	6165                	add	sp,sp,112
    80003990:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003992:	89da                	mv	s3,s6
    80003994:	bff1                	j	80003970 <readi+0xcc>
    return 0;
    80003996:	4501                	li	a0,0
}
    80003998:	8082                	ret

000000008000399a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000399a:	457c                	lw	a5,76(a0)
    8000399c:	10d7e663          	bltu	a5,a3,80003aa8 <writei+0x10e>
{
    800039a0:	7159                	add	sp,sp,-112
    800039a2:	f486                	sd	ra,104(sp)
    800039a4:	f0a2                	sd	s0,96(sp)
    800039a6:	eca6                	sd	s1,88(sp)
    800039a8:	e8ca                	sd	s2,80(sp)
    800039aa:	e4ce                	sd	s3,72(sp)
    800039ac:	e0d2                	sd	s4,64(sp)
    800039ae:	fc56                	sd	s5,56(sp)
    800039b0:	f85a                	sd	s6,48(sp)
    800039b2:	f45e                	sd	s7,40(sp)
    800039b4:	f062                	sd	s8,32(sp)
    800039b6:	ec66                	sd	s9,24(sp)
    800039b8:	e86a                	sd	s10,16(sp)
    800039ba:	e46e                	sd	s11,8(sp)
    800039bc:	1880                	add	s0,sp,112
    800039be:	8baa                	mv	s7,a0
    800039c0:	8c2e                	mv	s8,a1
    800039c2:	8ab2                	mv	s5,a2
    800039c4:	8936                	mv	s2,a3
    800039c6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800039c8:	00e687bb          	addw	a5,a3,a4
    800039cc:	0ed7e063          	bltu	a5,a3,80003aac <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800039d0:	00043737          	lui	a4,0x43
    800039d4:	0cf76e63          	bltu	a4,a5,80003ab0 <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800039d8:	0a0b0763          	beqz	s6,80003a86 <writei+0xec>
    800039dc:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800039de:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800039e2:	5cfd                	li	s9,-1
    800039e4:	a091                	j	80003a28 <writei+0x8e>
    800039e6:	02099d93          	sll	s11,s3,0x20
    800039ea:	020ddd93          	srl	s11,s11,0x20
    800039ee:	05848513          	add	a0,s1,88
    800039f2:	86ee                	mv	a3,s11
    800039f4:	8656                	mv	a2,s5
    800039f6:	85e2                	mv	a1,s8
    800039f8:	953a                	add	a0,a0,a4
    800039fa:	fffff097          	auipc	ra,0xfffff
    800039fe:	a90080e7          	jalr	-1392(ra) # 8000248a <either_copyin>
    80003a02:	07950263          	beq	a0,s9,80003a66 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003a06:	8526                	mv	a0,s1
    80003a08:	00000097          	auipc	ra,0x0
    80003a0c:	758080e7          	jalr	1880(ra) # 80004160 <log_write>
    brelse(bp);
    80003a10:	8526                	mv	a0,s1
    80003a12:	fffff097          	auipc	ra,0xfffff
    80003a16:	514080e7          	jalr	1300(ra) # 80002f26 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003a1a:	01498a3b          	addw	s4,s3,s4
    80003a1e:	0129893b          	addw	s2,s3,s2
    80003a22:	9aee                	add	s5,s5,s11
    80003a24:	056a7663          	bgeu	s4,s6,80003a70 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003a28:	000ba483          	lw	s1,0(s7)
    80003a2c:	00a9559b          	srlw	a1,s2,0xa
    80003a30:	855e                	mv	a0,s7
    80003a32:	fffff097          	auipc	ra,0xfffff
    80003a36:	7b2080e7          	jalr	1970(ra) # 800031e4 <bmap>
    80003a3a:	0005059b          	sext.w	a1,a0
    80003a3e:	8526                	mv	a0,s1
    80003a40:	fffff097          	auipc	ra,0xfffff
    80003a44:	3b6080e7          	jalr	950(ra) # 80002df6 <bread>
    80003a48:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a4a:	3ff97713          	and	a4,s2,1023
    80003a4e:	40ed07bb          	subw	a5,s10,a4
    80003a52:	414b06bb          	subw	a3,s6,s4
    80003a56:	89be                	mv	s3,a5
    80003a58:	2781                	sext.w	a5,a5
    80003a5a:	0006861b          	sext.w	a2,a3
    80003a5e:	f8f674e3          	bgeu	a2,a5,800039e6 <writei+0x4c>
    80003a62:	89b6                	mv	s3,a3
    80003a64:	b749                	j	800039e6 <writei+0x4c>
      brelse(bp);
    80003a66:	8526                	mv	a0,s1
    80003a68:	fffff097          	auipc	ra,0xfffff
    80003a6c:	4be080e7          	jalr	1214(ra) # 80002f26 <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80003a70:	04cba783          	lw	a5,76(s7)
    80003a74:	0127f463          	bgeu	a5,s2,80003a7c <writei+0xe2>
      ip->size = off;
    80003a78:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003a7c:	855e                	mv	a0,s7
    80003a7e:	00000097          	auipc	ra,0x0
    80003a82:	aa6080e7          	jalr	-1370(ra) # 80003524 <iupdate>
  }

  return n;
    80003a86:	000b051b          	sext.w	a0,s6
}
    80003a8a:	70a6                	ld	ra,104(sp)
    80003a8c:	7406                	ld	s0,96(sp)
    80003a8e:	64e6                	ld	s1,88(sp)
    80003a90:	6946                	ld	s2,80(sp)
    80003a92:	69a6                	ld	s3,72(sp)
    80003a94:	6a06                	ld	s4,64(sp)
    80003a96:	7ae2                	ld	s5,56(sp)
    80003a98:	7b42                	ld	s6,48(sp)
    80003a9a:	7ba2                	ld	s7,40(sp)
    80003a9c:	7c02                	ld	s8,32(sp)
    80003a9e:	6ce2                	ld	s9,24(sp)
    80003aa0:	6d42                	ld	s10,16(sp)
    80003aa2:	6da2                	ld	s11,8(sp)
    80003aa4:	6165                	add	sp,sp,112
    80003aa6:	8082                	ret
    return -1;
    80003aa8:	557d                	li	a0,-1
}
    80003aaa:	8082                	ret
    return -1;
    80003aac:	557d                	li	a0,-1
    80003aae:	bff1                	j	80003a8a <writei+0xf0>
    return -1;
    80003ab0:	557d                	li	a0,-1
    80003ab2:	bfe1                	j	80003a8a <writei+0xf0>

0000000080003ab4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003ab4:	1141                	add	sp,sp,-16
    80003ab6:	e406                	sd	ra,8(sp)
    80003ab8:	e022                	sd	s0,0(sp)
    80003aba:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003abc:	4639                	li	a2,14
    80003abe:	ffffd097          	auipc	ra,0xffffd
    80003ac2:	312080e7          	jalr	786(ra) # 80000dd0 <strncmp>
}
    80003ac6:	60a2                	ld	ra,8(sp)
    80003ac8:	6402                	ld	s0,0(sp)
    80003aca:	0141                	add	sp,sp,16
    80003acc:	8082                	ret

0000000080003ace <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003ace:	7139                	add	sp,sp,-64
    80003ad0:	fc06                	sd	ra,56(sp)
    80003ad2:	f822                	sd	s0,48(sp)
    80003ad4:	f426                	sd	s1,40(sp)
    80003ad6:	f04a                	sd	s2,32(sp)
    80003ad8:	ec4e                	sd	s3,24(sp)
    80003ada:	e852                	sd	s4,16(sp)
    80003adc:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003ade:	04451703          	lh	a4,68(a0)
    80003ae2:	4785                	li	a5,1
    80003ae4:	00f71a63          	bne	a4,a5,80003af8 <dirlookup+0x2a>
    80003ae8:	892a                	mv	s2,a0
    80003aea:	89ae                	mv	s3,a1
    80003aec:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003aee:	457c                	lw	a5,76(a0)
    80003af0:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003af2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003af4:	e79d                	bnez	a5,80003b22 <dirlookup+0x54>
    80003af6:	a8a5                	j	80003b6e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003af8:	00005517          	auipc	a0,0x5
    80003afc:	ad050513          	add	a0,a0,-1328 # 800085c8 <syscalls+0x1a0>
    80003b00:	ffffd097          	auipc	ra,0xffffd
    80003b04:	a42080e7          	jalr	-1470(ra) # 80000542 <panic>
      panic("dirlookup read");
    80003b08:	00005517          	auipc	a0,0x5
    80003b0c:	ad850513          	add	a0,a0,-1320 # 800085e0 <syscalls+0x1b8>
    80003b10:	ffffd097          	auipc	ra,0xffffd
    80003b14:	a32080e7          	jalr	-1486(ra) # 80000542 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b18:	24c1                	addw	s1,s1,16
    80003b1a:	04c92783          	lw	a5,76(s2)
    80003b1e:	04f4f763          	bgeu	s1,a5,80003b6c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b22:	4741                	li	a4,16
    80003b24:	86a6                	mv	a3,s1
    80003b26:	fc040613          	add	a2,s0,-64
    80003b2a:	4581                	li	a1,0
    80003b2c:	854a                	mv	a0,s2
    80003b2e:	00000097          	auipc	ra,0x0
    80003b32:	d76080e7          	jalr	-650(ra) # 800038a4 <readi>
    80003b36:	47c1                	li	a5,16
    80003b38:	fcf518e3          	bne	a0,a5,80003b08 <dirlookup+0x3a>
    if(de.inum == 0)
    80003b3c:	fc045783          	lhu	a5,-64(s0)
    80003b40:	dfe1                	beqz	a5,80003b18 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003b42:	fc240593          	add	a1,s0,-62
    80003b46:	854e                	mv	a0,s3
    80003b48:	00000097          	auipc	ra,0x0
    80003b4c:	f6c080e7          	jalr	-148(ra) # 80003ab4 <namecmp>
    80003b50:	f561                	bnez	a0,80003b18 <dirlookup+0x4a>
      if(poff)
    80003b52:	000a0463          	beqz	s4,80003b5a <dirlookup+0x8c>
        *poff = off;
    80003b56:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003b5a:	fc045583          	lhu	a1,-64(s0)
    80003b5e:	00092503          	lw	a0,0(s2)
    80003b62:	fffff097          	auipc	ra,0xfffff
    80003b66:	75e080e7          	jalr	1886(ra) # 800032c0 <iget>
    80003b6a:	a011                	j	80003b6e <dirlookup+0xa0>
  return 0;
    80003b6c:	4501                	li	a0,0
}
    80003b6e:	70e2                	ld	ra,56(sp)
    80003b70:	7442                	ld	s0,48(sp)
    80003b72:	74a2                	ld	s1,40(sp)
    80003b74:	7902                	ld	s2,32(sp)
    80003b76:	69e2                	ld	s3,24(sp)
    80003b78:	6a42                	ld	s4,16(sp)
    80003b7a:	6121                	add	sp,sp,64
    80003b7c:	8082                	ret

0000000080003b7e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003b7e:	711d                	add	sp,sp,-96
    80003b80:	ec86                	sd	ra,88(sp)
    80003b82:	e8a2                	sd	s0,80(sp)
    80003b84:	e4a6                	sd	s1,72(sp)
    80003b86:	e0ca                	sd	s2,64(sp)
    80003b88:	fc4e                	sd	s3,56(sp)
    80003b8a:	f852                	sd	s4,48(sp)
    80003b8c:	f456                	sd	s5,40(sp)
    80003b8e:	f05a                	sd	s6,32(sp)
    80003b90:	ec5e                	sd	s7,24(sp)
    80003b92:	e862                	sd	s8,16(sp)
    80003b94:	e466                	sd	s9,8(sp)
    80003b96:	1080                	add	s0,sp,96
    80003b98:	84aa                	mv	s1,a0
    80003b9a:	8b2e                	mv	s6,a1
    80003b9c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003b9e:	00054703          	lbu	a4,0(a0)
    80003ba2:	02f00793          	li	a5,47
    80003ba6:	02f70263          	beq	a4,a5,80003bca <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003baa:	ffffe097          	auipc	ra,0xffffe
    80003bae:	e1c080e7          	jalr	-484(ra) # 800019c6 <myproc>
    80003bb2:	15053503          	ld	a0,336(a0)
    80003bb6:	00000097          	auipc	ra,0x0
    80003bba:	9fc080e7          	jalr	-1540(ra) # 800035b2 <idup>
    80003bbe:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003bc0:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003bc4:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003bc6:	4b85                	li	s7,1
    80003bc8:	a875                	j	80003c84 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003bca:	4585                	li	a1,1
    80003bcc:	4505                	li	a0,1
    80003bce:	fffff097          	auipc	ra,0xfffff
    80003bd2:	6f2080e7          	jalr	1778(ra) # 800032c0 <iget>
    80003bd6:	8a2a                	mv	s4,a0
    80003bd8:	b7e5                	j	80003bc0 <namex+0x42>
      iunlockput(ip);
    80003bda:	8552                	mv	a0,s4
    80003bdc:	00000097          	auipc	ra,0x0
    80003be0:	c76080e7          	jalr	-906(ra) # 80003852 <iunlockput>
      return 0;
    80003be4:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003be6:	8552                	mv	a0,s4
    80003be8:	60e6                	ld	ra,88(sp)
    80003bea:	6446                	ld	s0,80(sp)
    80003bec:	64a6                	ld	s1,72(sp)
    80003bee:	6906                	ld	s2,64(sp)
    80003bf0:	79e2                	ld	s3,56(sp)
    80003bf2:	7a42                	ld	s4,48(sp)
    80003bf4:	7aa2                	ld	s5,40(sp)
    80003bf6:	7b02                	ld	s6,32(sp)
    80003bf8:	6be2                	ld	s7,24(sp)
    80003bfa:	6c42                	ld	s8,16(sp)
    80003bfc:	6ca2                	ld	s9,8(sp)
    80003bfe:	6125                	add	sp,sp,96
    80003c00:	8082                	ret
      iunlock(ip);
    80003c02:	8552                	mv	a0,s4
    80003c04:	00000097          	auipc	ra,0x0
    80003c08:	aae080e7          	jalr	-1362(ra) # 800036b2 <iunlock>
      return ip;
    80003c0c:	bfe9                	j	80003be6 <namex+0x68>
      iunlockput(ip);
    80003c0e:	8552                	mv	a0,s4
    80003c10:	00000097          	auipc	ra,0x0
    80003c14:	c42080e7          	jalr	-958(ra) # 80003852 <iunlockput>
      return 0;
    80003c18:	8a4e                	mv	s4,s3
    80003c1a:	b7f1                	j	80003be6 <namex+0x68>
  len = path - s;
    80003c1c:	40998633          	sub	a2,s3,s1
    80003c20:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003c24:	099c5863          	bge	s8,s9,80003cb4 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003c28:	4639                	li	a2,14
    80003c2a:	85a6                	mv	a1,s1
    80003c2c:	8556                	mv	a0,s5
    80003c2e:	ffffd097          	auipc	ra,0xffffd
    80003c32:	126080e7          	jalr	294(ra) # 80000d54 <memmove>
    80003c36:	84ce                	mv	s1,s3
  while(*path == '/')
    80003c38:	0004c783          	lbu	a5,0(s1)
    80003c3c:	01279763          	bne	a5,s2,80003c4a <namex+0xcc>
    path++;
    80003c40:	0485                	add	s1,s1,1
  while(*path == '/')
    80003c42:	0004c783          	lbu	a5,0(s1)
    80003c46:	ff278de3          	beq	a5,s2,80003c40 <namex+0xc2>
    ilock(ip);
    80003c4a:	8552                	mv	a0,s4
    80003c4c:	00000097          	auipc	ra,0x0
    80003c50:	9a4080e7          	jalr	-1628(ra) # 800035f0 <ilock>
    if(ip->type != T_DIR){
    80003c54:	044a1783          	lh	a5,68(s4)
    80003c58:	f97791e3          	bne	a5,s7,80003bda <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003c5c:	000b0563          	beqz	s6,80003c66 <namex+0xe8>
    80003c60:	0004c783          	lbu	a5,0(s1)
    80003c64:	dfd9                	beqz	a5,80003c02 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003c66:	4601                	li	a2,0
    80003c68:	85d6                	mv	a1,s5
    80003c6a:	8552                	mv	a0,s4
    80003c6c:	00000097          	auipc	ra,0x0
    80003c70:	e62080e7          	jalr	-414(ra) # 80003ace <dirlookup>
    80003c74:	89aa                	mv	s3,a0
    80003c76:	dd41                	beqz	a0,80003c0e <namex+0x90>
    iunlockput(ip);
    80003c78:	8552                	mv	a0,s4
    80003c7a:	00000097          	auipc	ra,0x0
    80003c7e:	bd8080e7          	jalr	-1064(ra) # 80003852 <iunlockput>
    ip = next;
    80003c82:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003c84:	0004c783          	lbu	a5,0(s1)
    80003c88:	01279763          	bne	a5,s2,80003c96 <namex+0x118>
    path++;
    80003c8c:	0485                	add	s1,s1,1
  while(*path == '/')
    80003c8e:	0004c783          	lbu	a5,0(s1)
    80003c92:	ff278de3          	beq	a5,s2,80003c8c <namex+0x10e>
  if(*path == 0)
    80003c96:	cb9d                	beqz	a5,80003ccc <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003c98:	0004c783          	lbu	a5,0(s1)
    80003c9c:	89a6                	mv	s3,s1
  len = path - s;
    80003c9e:	4c81                	li	s9,0
    80003ca0:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003ca2:	01278963          	beq	a5,s2,80003cb4 <namex+0x136>
    80003ca6:	dbbd                	beqz	a5,80003c1c <namex+0x9e>
    path++;
    80003ca8:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80003caa:	0009c783          	lbu	a5,0(s3)
    80003cae:	ff279ce3          	bne	a5,s2,80003ca6 <namex+0x128>
    80003cb2:	b7ad                	j	80003c1c <namex+0x9e>
    memmove(name, s, len);
    80003cb4:	2601                	sext.w	a2,a2
    80003cb6:	85a6                	mv	a1,s1
    80003cb8:	8556                	mv	a0,s5
    80003cba:	ffffd097          	auipc	ra,0xffffd
    80003cbe:	09a080e7          	jalr	154(ra) # 80000d54 <memmove>
    name[len] = 0;
    80003cc2:	9cd6                	add	s9,s9,s5
    80003cc4:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003cc8:	84ce                	mv	s1,s3
    80003cca:	b7bd                	j	80003c38 <namex+0xba>
  if(nameiparent){
    80003ccc:	f00b0de3          	beqz	s6,80003be6 <namex+0x68>
    iput(ip);
    80003cd0:	8552                	mv	a0,s4
    80003cd2:	00000097          	auipc	ra,0x0
    80003cd6:	ad8080e7          	jalr	-1320(ra) # 800037aa <iput>
    return 0;
    80003cda:	4a01                	li	s4,0
    80003cdc:	b729                	j	80003be6 <namex+0x68>

0000000080003cde <dirlink>:
{
    80003cde:	7139                	add	sp,sp,-64
    80003ce0:	fc06                	sd	ra,56(sp)
    80003ce2:	f822                	sd	s0,48(sp)
    80003ce4:	f426                	sd	s1,40(sp)
    80003ce6:	f04a                	sd	s2,32(sp)
    80003ce8:	ec4e                	sd	s3,24(sp)
    80003cea:	e852                	sd	s4,16(sp)
    80003cec:	0080                	add	s0,sp,64
    80003cee:	892a                	mv	s2,a0
    80003cf0:	8a2e                	mv	s4,a1
    80003cf2:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003cf4:	4601                	li	a2,0
    80003cf6:	00000097          	auipc	ra,0x0
    80003cfa:	dd8080e7          	jalr	-552(ra) # 80003ace <dirlookup>
    80003cfe:	e93d                	bnez	a0,80003d74 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d00:	04c92483          	lw	s1,76(s2)
    80003d04:	c49d                	beqz	s1,80003d32 <dirlink+0x54>
    80003d06:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d08:	4741                	li	a4,16
    80003d0a:	86a6                	mv	a3,s1
    80003d0c:	fc040613          	add	a2,s0,-64
    80003d10:	4581                	li	a1,0
    80003d12:	854a                	mv	a0,s2
    80003d14:	00000097          	auipc	ra,0x0
    80003d18:	b90080e7          	jalr	-1136(ra) # 800038a4 <readi>
    80003d1c:	47c1                	li	a5,16
    80003d1e:	06f51163          	bne	a0,a5,80003d80 <dirlink+0xa2>
    if(de.inum == 0)
    80003d22:	fc045783          	lhu	a5,-64(s0)
    80003d26:	c791                	beqz	a5,80003d32 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d28:	24c1                	addw	s1,s1,16
    80003d2a:	04c92783          	lw	a5,76(s2)
    80003d2e:	fcf4ede3          	bltu	s1,a5,80003d08 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003d32:	4639                	li	a2,14
    80003d34:	85d2                	mv	a1,s4
    80003d36:	fc240513          	add	a0,s0,-62
    80003d3a:	ffffd097          	auipc	ra,0xffffd
    80003d3e:	0d2080e7          	jalr	210(ra) # 80000e0c <strncpy>
  de.inum = inum;
    80003d42:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d46:	4741                	li	a4,16
    80003d48:	86a6                	mv	a3,s1
    80003d4a:	fc040613          	add	a2,s0,-64
    80003d4e:	4581                	li	a1,0
    80003d50:	854a                	mv	a0,s2
    80003d52:	00000097          	auipc	ra,0x0
    80003d56:	c48080e7          	jalr	-952(ra) # 8000399a <writei>
    80003d5a:	872a                	mv	a4,a0
    80003d5c:	47c1                	li	a5,16
  return 0;
    80003d5e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d60:	02f71863          	bne	a4,a5,80003d90 <dirlink+0xb2>
}
    80003d64:	70e2                	ld	ra,56(sp)
    80003d66:	7442                	ld	s0,48(sp)
    80003d68:	74a2                	ld	s1,40(sp)
    80003d6a:	7902                	ld	s2,32(sp)
    80003d6c:	69e2                	ld	s3,24(sp)
    80003d6e:	6a42                	ld	s4,16(sp)
    80003d70:	6121                	add	sp,sp,64
    80003d72:	8082                	ret
    iput(ip);
    80003d74:	00000097          	auipc	ra,0x0
    80003d78:	a36080e7          	jalr	-1482(ra) # 800037aa <iput>
    return -1;
    80003d7c:	557d                	li	a0,-1
    80003d7e:	b7dd                	j	80003d64 <dirlink+0x86>
      panic("dirlink read");
    80003d80:	00005517          	auipc	a0,0x5
    80003d84:	87050513          	add	a0,a0,-1936 # 800085f0 <syscalls+0x1c8>
    80003d88:	ffffc097          	auipc	ra,0xffffc
    80003d8c:	7ba080e7          	jalr	1978(ra) # 80000542 <panic>
    panic("dirlink");
    80003d90:	00005517          	auipc	a0,0x5
    80003d94:	98050513          	add	a0,a0,-1664 # 80008710 <syscalls+0x2e8>
    80003d98:	ffffc097          	auipc	ra,0xffffc
    80003d9c:	7aa080e7          	jalr	1962(ra) # 80000542 <panic>

0000000080003da0 <namei>:

struct inode*
namei(char *path)
{
    80003da0:	1101                	add	sp,sp,-32
    80003da2:	ec06                	sd	ra,24(sp)
    80003da4:	e822                	sd	s0,16(sp)
    80003da6:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003da8:	fe040613          	add	a2,s0,-32
    80003dac:	4581                	li	a1,0
    80003dae:	00000097          	auipc	ra,0x0
    80003db2:	dd0080e7          	jalr	-560(ra) # 80003b7e <namex>
}
    80003db6:	60e2                	ld	ra,24(sp)
    80003db8:	6442                	ld	s0,16(sp)
    80003dba:	6105                	add	sp,sp,32
    80003dbc:	8082                	ret

0000000080003dbe <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003dbe:	1141                	add	sp,sp,-16
    80003dc0:	e406                	sd	ra,8(sp)
    80003dc2:	e022                	sd	s0,0(sp)
    80003dc4:	0800                	add	s0,sp,16
    80003dc6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003dc8:	4585                	li	a1,1
    80003dca:	00000097          	auipc	ra,0x0
    80003dce:	db4080e7          	jalr	-588(ra) # 80003b7e <namex>
}
    80003dd2:	60a2                	ld	ra,8(sp)
    80003dd4:	6402                	ld	s0,0(sp)
    80003dd6:	0141                	add	sp,sp,16
    80003dd8:	8082                	ret

0000000080003dda <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003dda:	1101                	add	sp,sp,-32
    80003ddc:	ec06                	sd	ra,24(sp)
    80003dde:	e822                	sd	s0,16(sp)
    80003de0:	e426                	sd	s1,8(sp)
    80003de2:	e04a                	sd	s2,0(sp)
    80003de4:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003de6:	0001e917          	auipc	s2,0x1e
    80003dea:	b2290913          	add	s2,s2,-1246 # 80021908 <log>
    80003dee:	01892583          	lw	a1,24(s2)
    80003df2:	02892503          	lw	a0,40(s2)
    80003df6:	fffff097          	auipc	ra,0xfffff
    80003dfa:	000080e7          	jalr	ra # 80002df6 <bread>
    80003dfe:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003e00:	02c92603          	lw	a2,44(s2)
    80003e04:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003e06:	00c05f63          	blez	a2,80003e24 <write_head+0x4a>
    80003e0a:	0001e717          	auipc	a4,0x1e
    80003e0e:	b2e70713          	add	a4,a4,-1234 # 80021938 <log+0x30>
    80003e12:	87aa                	mv	a5,a0
    80003e14:	060a                	sll	a2,a2,0x2
    80003e16:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003e18:	4314                	lw	a3,0(a4)
    80003e1a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003e1c:	0711                	add	a4,a4,4
    80003e1e:	0791                	add	a5,a5,4
    80003e20:	fec79ce3          	bne	a5,a2,80003e18 <write_head+0x3e>
  }
  bwrite(buf);
    80003e24:	8526                	mv	a0,s1
    80003e26:	fffff097          	auipc	ra,0xfffff
    80003e2a:	0c2080e7          	jalr	194(ra) # 80002ee8 <bwrite>
  brelse(buf);
    80003e2e:	8526                	mv	a0,s1
    80003e30:	fffff097          	auipc	ra,0xfffff
    80003e34:	0f6080e7          	jalr	246(ra) # 80002f26 <brelse>
}
    80003e38:	60e2                	ld	ra,24(sp)
    80003e3a:	6442                	ld	s0,16(sp)
    80003e3c:	64a2                	ld	s1,8(sp)
    80003e3e:	6902                	ld	s2,0(sp)
    80003e40:	6105                	add	sp,sp,32
    80003e42:	8082                	ret

0000000080003e44 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e44:	0001e797          	auipc	a5,0x1e
    80003e48:	af07a783          	lw	a5,-1296(a5) # 80021934 <log+0x2c>
    80003e4c:	0af05663          	blez	a5,80003ef8 <install_trans+0xb4>
{
    80003e50:	7139                	add	sp,sp,-64
    80003e52:	fc06                	sd	ra,56(sp)
    80003e54:	f822                	sd	s0,48(sp)
    80003e56:	f426                	sd	s1,40(sp)
    80003e58:	f04a                	sd	s2,32(sp)
    80003e5a:	ec4e                	sd	s3,24(sp)
    80003e5c:	e852                	sd	s4,16(sp)
    80003e5e:	e456                	sd	s5,8(sp)
    80003e60:	0080                	add	s0,sp,64
    80003e62:	0001ea97          	auipc	s5,0x1e
    80003e66:	ad6a8a93          	add	s5,s5,-1322 # 80021938 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e6a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003e6c:	0001e997          	auipc	s3,0x1e
    80003e70:	a9c98993          	add	s3,s3,-1380 # 80021908 <log>
    80003e74:	0189a583          	lw	a1,24(s3)
    80003e78:	014585bb          	addw	a1,a1,s4
    80003e7c:	2585                	addw	a1,a1,1
    80003e7e:	0289a503          	lw	a0,40(s3)
    80003e82:	fffff097          	auipc	ra,0xfffff
    80003e86:	f74080e7          	jalr	-140(ra) # 80002df6 <bread>
    80003e8a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003e8c:	000aa583          	lw	a1,0(s5)
    80003e90:	0289a503          	lw	a0,40(s3)
    80003e94:	fffff097          	auipc	ra,0xfffff
    80003e98:	f62080e7          	jalr	-158(ra) # 80002df6 <bread>
    80003e9c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003e9e:	40000613          	li	a2,1024
    80003ea2:	05890593          	add	a1,s2,88
    80003ea6:	05850513          	add	a0,a0,88
    80003eaa:	ffffd097          	auipc	ra,0xffffd
    80003eae:	eaa080e7          	jalr	-342(ra) # 80000d54 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003eb2:	8526                	mv	a0,s1
    80003eb4:	fffff097          	auipc	ra,0xfffff
    80003eb8:	034080e7          	jalr	52(ra) # 80002ee8 <bwrite>
    bunpin(dbuf);
    80003ebc:	8526                	mv	a0,s1
    80003ebe:	fffff097          	auipc	ra,0xfffff
    80003ec2:	140080e7          	jalr	320(ra) # 80002ffe <bunpin>
    brelse(lbuf);
    80003ec6:	854a                	mv	a0,s2
    80003ec8:	fffff097          	auipc	ra,0xfffff
    80003ecc:	05e080e7          	jalr	94(ra) # 80002f26 <brelse>
    brelse(dbuf);
    80003ed0:	8526                	mv	a0,s1
    80003ed2:	fffff097          	auipc	ra,0xfffff
    80003ed6:	054080e7          	jalr	84(ra) # 80002f26 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003eda:	2a05                	addw	s4,s4,1
    80003edc:	0a91                	add	s5,s5,4
    80003ede:	02c9a783          	lw	a5,44(s3)
    80003ee2:	f8fa49e3          	blt	s4,a5,80003e74 <install_trans+0x30>
}
    80003ee6:	70e2                	ld	ra,56(sp)
    80003ee8:	7442                	ld	s0,48(sp)
    80003eea:	74a2                	ld	s1,40(sp)
    80003eec:	7902                	ld	s2,32(sp)
    80003eee:	69e2                	ld	s3,24(sp)
    80003ef0:	6a42                	ld	s4,16(sp)
    80003ef2:	6aa2                	ld	s5,8(sp)
    80003ef4:	6121                	add	sp,sp,64
    80003ef6:	8082                	ret
    80003ef8:	8082                	ret

0000000080003efa <initlog>:
{
    80003efa:	7179                	add	sp,sp,-48
    80003efc:	f406                	sd	ra,40(sp)
    80003efe:	f022                	sd	s0,32(sp)
    80003f00:	ec26                	sd	s1,24(sp)
    80003f02:	e84a                	sd	s2,16(sp)
    80003f04:	e44e                	sd	s3,8(sp)
    80003f06:	1800                	add	s0,sp,48
    80003f08:	892a                	mv	s2,a0
    80003f0a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003f0c:	0001e497          	auipc	s1,0x1e
    80003f10:	9fc48493          	add	s1,s1,-1540 # 80021908 <log>
    80003f14:	00004597          	auipc	a1,0x4
    80003f18:	6ec58593          	add	a1,a1,1772 # 80008600 <syscalls+0x1d8>
    80003f1c:	8526                	mv	a0,s1
    80003f1e:	ffffd097          	auipc	ra,0xffffd
    80003f22:	c4e080e7          	jalr	-946(ra) # 80000b6c <initlock>
  log.start = sb->logstart;
    80003f26:	0149a583          	lw	a1,20(s3)
    80003f2a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003f2c:	0109a783          	lw	a5,16(s3)
    80003f30:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003f32:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003f36:	854a                	mv	a0,s2
    80003f38:	fffff097          	auipc	ra,0xfffff
    80003f3c:	ebe080e7          	jalr	-322(ra) # 80002df6 <bread>
  log.lh.n = lh->n;
    80003f40:	4d30                	lw	a2,88(a0)
    80003f42:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003f44:	00c05f63          	blez	a2,80003f62 <initlog+0x68>
    80003f48:	87aa                	mv	a5,a0
    80003f4a:	0001e717          	auipc	a4,0x1e
    80003f4e:	9ee70713          	add	a4,a4,-1554 # 80021938 <log+0x30>
    80003f52:	060a                	sll	a2,a2,0x2
    80003f54:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003f56:	4ff4                	lw	a3,92(a5)
    80003f58:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003f5a:	0791                	add	a5,a5,4
    80003f5c:	0711                	add	a4,a4,4
    80003f5e:	fec79ce3          	bne	a5,a2,80003f56 <initlog+0x5c>
  brelse(buf);
    80003f62:	fffff097          	auipc	ra,0xfffff
    80003f66:	fc4080e7          	jalr	-60(ra) # 80002f26 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    80003f6a:	00000097          	auipc	ra,0x0
    80003f6e:	eda080e7          	jalr	-294(ra) # 80003e44 <install_trans>
  log.lh.n = 0;
    80003f72:	0001e797          	auipc	a5,0x1e
    80003f76:	9c07a123          	sw	zero,-1598(a5) # 80021934 <log+0x2c>
  write_head(); // clear the log
    80003f7a:	00000097          	auipc	ra,0x0
    80003f7e:	e60080e7          	jalr	-416(ra) # 80003dda <write_head>
}
    80003f82:	70a2                	ld	ra,40(sp)
    80003f84:	7402                	ld	s0,32(sp)
    80003f86:	64e2                	ld	s1,24(sp)
    80003f88:	6942                	ld	s2,16(sp)
    80003f8a:	69a2                	ld	s3,8(sp)
    80003f8c:	6145                	add	sp,sp,48
    80003f8e:	8082                	ret

0000000080003f90 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003f90:	1101                	add	sp,sp,-32
    80003f92:	ec06                	sd	ra,24(sp)
    80003f94:	e822                	sd	s0,16(sp)
    80003f96:	e426                	sd	s1,8(sp)
    80003f98:	e04a                	sd	s2,0(sp)
    80003f9a:	1000                	add	s0,sp,32
  acquire(&log.lock);
    80003f9c:	0001e517          	auipc	a0,0x1e
    80003fa0:	96c50513          	add	a0,a0,-1684 # 80021908 <log>
    80003fa4:	ffffd097          	auipc	ra,0xffffd
    80003fa8:	c58080e7          	jalr	-936(ra) # 80000bfc <acquire>
  while(1){
    if(log.committing){
    80003fac:	0001e497          	auipc	s1,0x1e
    80003fb0:	95c48493          	add	s1,s1,-1700 # 80021908 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003fb4:	4979                	li	s2,30
    80003fb6:	a039                	j	80003fc4 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003fb8:	85a6                	mv	a1,s1
    80003fba:	8526                	mv	a0,s1
    80003fbc:	ffffe097          	auipc	ra,0xffffe
    80003fc0:	21e080e7          	jalr	542(ra) # 800021da <sleep>
    if(log.committing){
    80003fc4:	50dc                	lw	a5,36(s1)
    80003fc6:	fbed                	bnez	a5,80003fb8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003fc8:	5098                	lw	a4,32(s1)
    80003fca:	2705                	addw	a4,a4,1
    80003fcc:	0027179b          	sllw	a5,a4,0x2
    80003fd0:	9fb9                	addw	a5,a5,a4
    80003fd2:	0017979b          	sllw	a5,a5,0x1
    80003fd6:	54d4                	lw	a3,44(s1)
    80003fd8:	9fb5                	addw	a5,a5,a3
    80003fda:	00f95963          	bge	s2,a5,80003fec <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003fde:	85a6                	mv	a1,s1
    80003fe0:	8526                	mv	a0,s1
    80003fe2:	ffffe097          	auipc	ra,0xffffe
    80003fe6:	1f8080e7          	jalr	504(ra) # 800021da <sleep>
    80003fea:	bfe9                	j	80003fc4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003fec:	0001e517          	auipc	a0,0x1e
    80003ff0:	91c50513          	add	a0,a0,-1764 # 80021908 <log>
    80003ff4:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003ff6:	ffffd097          	auipc	ra,0xffffd
    80003ffa:	cba080e7          	jalr	-838(ra) # 80000cb0 <release>
      break;
    }
  }
}
    80003ffe:	60e2                	ld	ra,24(sp)
    80004000:	6442                	ld	s0,16(sp)
    80004002:	64a2                	ld	s1,8(sp)
    80004004:	6902                	ld	s2,0(sp)
    80004006:	6105                	add	sp,sp,32
    80004008:	8082                	ret

000000008000400a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000400a:	7139                	add	sp,sp,-64
    8000400c:	fc06                	sd	ra,56(sp)
    8000400e:	f822                	sd	s0,48(sp)
    80004010:	f426                	sd	s1,40(sp)
    80004012:	f04a                	sd	s2,32(sp)
    80004014:	ec4e                	sd	s3,24(sp)
    80004016:	e852                	sd	s4,16(sp)
    80004018:	e456                	sd	s5,8(sp)
    8000401a:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000401c:	0001e497          	auipc	s1,0x1e
    80004020:	8ec48493          	add	s1,s1,-1812 # 80021908 <log>
    80004024:	8526                	mv	a0,s1
    80004026:	ffffd097          	auipc	ra,0xffffd
    8000402a:	bd6080e7          	jalr	-1066(ra) # 80000bfc <acquire>
  log.outstanding -= 1;
    8000402e:	509c                	lw	a5,32(s1)
    80004030:	37fd                	addw	a5,a5,-1
    80004032:	0007891b          	sext.w	s2,a5
    80004036:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004038:	50dc                	lw	a5,36(s1)
    8000403a:	e7b9                	bnez	a5,80004088 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000403c:	04091e63          	bnez	s2,80004098 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004040:	0001e497          	auipc	s1,0x1e
    80004044:	8c848493          	add	s1,s1,-1848 # 80021908 <log>
    80004048:	4785                	li	a5,1
    8000404a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000404c:	8526                	mv	a0,s1
    8000404e:	ffffd097          	auipc	ra,0xffffd
    80004052:	c62080e7          	jalr	-926(ra) # 80000cb0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004056:	54dc                	lw	a5,44(s1)
    80004058:	06f04763          	bgtz	a5,800040c6 <end_op+0xbc>
    acquire(&log.lock);
    8000405c:	0001e497          	auipc	s1,0x1e
    80004060:	8ac48493          	add	s1,s1,-1876 # 80021908 <log>
    80004064:	8526                	mv	a0,s1
    80004066:	ffffd097          	auipc	ra,0xffffd
    8000406a:	b96080e7          	jalr	-1130(ra) # 80000bfc <acquire>
    log.committing = 0;
    8000406e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004072:	8526                	mv	a0,s1
    80004074:	ffffe097          	auipc	ra,0xffffe
    80004078:	2e6080e7          	jalr	742(ra) # 8000235a <wakeup>
    release(&log.lock);
    8000407c:	8526                	mv	a0,s1
    8000407e:	ffffd097          	auipc	ra,0xffffd
    80004082:	c32080e7          	jalr	-974(ra) # 80000cb0 <release>
}
    80004086:	a03d                	j	800040b4 <end_op+0xaa>
    panic("log.committing");
    80004088:	00004517          	auipc	a0,0x4
    8000408c:	58050513          	add	a0,a0,1408 # 80008608 <syscalls+0x1e0>
    80004090:	ffffc097          	auipc	ra,0xffffc
    80004094:	4b2080e7          	jalr	1202(ra) # 80000542 <panic>
    wakeup(&log);
    80004098:	0001e497          	auipc	s1,0x1e
    8000409c:	87048493          	add	s1,s1,-1936 # 80021908 <log>
    800040a0:	8526                	mv	a0,s1
    800040a2:	ffffe097          	auipc	ra,0xffffe
    800040a6:	2b8080e7          	jalr	696(ra) # 8000235a <wakeup>
  release(&log.lock);
    800040aa:	8526                	mv	a0,s1
    800040ac:	ffffd097          	auipc	ra,0xffffd
    800040b0:	c04080e7          	jalr	-1020(ra) # 80000cb0 <release>
}
    800040b4:	70e2                	ld	ra,56(sp)
    800040b6:	7442                	ld	s0,48(sp)
    800040b8:	74a2                	ld	s1,40(sp)
    800040ba:	7902                	ld	s2,32(sp)
    800040bc:	69e2                	ld	s3,24(sp)
    800040be:	6a42                	ld	s4,16(sp)
    800040c0:	6aa2                	ld	s5,8(sp)
    800040c2:	6121                	add	sp,sp,64
    800040c4:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800040c6:	0001ea97          	auipc	s5,0x1e
    800040ca:	872a8a93          	add	s5,s5,-1934 # 80021938 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800040ce:	0001ea17          	auipc	s4,0x1e
    800040d2:	83aa0a13          	add	s4,s4,-1990 # 80021908 <log>
    800040d6:	018a2583          	lw	a1,24(s4)
    800040da:	012585bb          	addw	a1,a1,s2
    800040de:	2585                	addw	a1,a1,1
    800040e0:	028a2503          	lw	a0,40(s4)
    800040e4:	fffff097          	auipc	ra,0xfffff
    800040e8:	d12080e7          	jalr	-750(ra) # 80002df6 <bread>
    800040ec:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800040ee:	000aa583          	lw	a1,0(s5)
    800040f2:	028a2503          	lw	a0,40(s4)
    800040f6:	fffff097          	auipc	ra,0xfffff
    800040fa:	d00080e7          	jalr	-768(ra) # 80002df6 <bread>
    800040fe:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004100:	40000613          	li	a2,1024
    80004104:	05850593          	add	a1,a0,88
    80004108:	05848513          	add	a0,s1,88
    8000410c:	ffffd097          	auipc	ra,0xffffd
    80004110:	c48080e7          	jalr	-952(ra) # 80000d54 <memmove>
    bwrite(to);  // write the log
    80004114:	8526                	mv	a0,s1
    80004116:	fffff097          	auipc	ra,0xfffff
    8000411a:	dd2080e7          	jalr	-558(ra) # 80002ee8 <bwrite>
    brelse(from);
    8000411e:	854e                	mv	a0,s3
    80004120:	fffff097          	auipc	ra,0xfffff
    80004124:	e06080e7          	jalr	-506(ra) # 80002f26 <brelse>
    brelse(to);
    80004128:	8526                	mv	a0,s1
    8000412a:	fffff097          	auipc	ra,0xfffff
    8000412e:	dfc080e7          	jalr	-516(ra) # 80002f26 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004132:	2905                	addw	s2,s2,1
    80004134:	0a91                	add	s5,s5,4
    80004136:	02ca2783          	lw	a5,44(s4)
    8000413a:	f8f94ee3          	blt	s2,a5,800040d6 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000413e:	00000097          	auipc	ra,0x0
    80004142:	c9c080e7          	jalr	-868(ra) # 80003dda <write_head>
    install_trans(); // Now install writes to home locations
    80004146:	00000097          	auipc	ra,0x0
    8000414a:	cfe080e7          	jalr	-770(ra) # 80003e44 <install_trans>
    log.lh.n = 0;
    8000414e:	0001d797          	auipc	a5,0x1d
    80004152:	7e07a323          	sw	zero,2022(a5) # 80021934 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004156:	00000097          	auipc	ra,0x0
    8000415a:	c84080e7          	jalr	-892(ra) # 80003dda <write_head>
    8000415e:	bdfd                	j	8000405c <end_op+0x52>

0000000080004160 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004160:	1101                	add	sp,sp,-32
    80004162:	ec06                	sd	ra,24(sp)
    80004164:	e822                	sd	s0,16(sp)
    80004166:	e426                	sd	s1,8(sp)
    80004168:	e04a                	sd	s2,0(sp)
    8000416a:	1000                	add	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000416c:	0001d717          	auipc	a4,0x1d
    80004170:	7c872703          	lw	a4,1992(a4) # 80021934 <log+0x2c>
    80004174:	47f5                	li	a5,29
    80004176:	08e7c063          	blt	a5,a4,800041f6 <log_write+0x96>
    8000417a:	84aa                	mv	s1,a0
    8000417c:	0001d797          	auipc	a5,0x1d
    80004180:	7a87a783          	lw	a5,1960(a5) # 80021924 <log+0x1c>
    80004184:	37fd                	addw	a5,a5,-1
    80004186:	06f75863          	bge	a4,a5,800041f6 <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000418a:	0001d797          	auipc	a5,0x1d
    8000418e:	79e7a783          	lw	a5,1950(a5) # 80021928 <log+0x20>
    80004192:	06f05a63          	blez	a5,80004206 <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    80004196:	0001d917          	auipc	s2,0x1d
    8000419a:	77290913          	add	s2,s2,1906 # 80021908 <log>
    8000419e:	854a                	mv	a0,s2
    800041a0:	ffffd097          	auipc	ra,0xffffd
    800041a4:	a5c080e7          	jalr	-1444(ra) # 80000bfc <acquire>
  for (i = 0; i < log.lh.n; i++) {
    800041a8:	02c92603          	lw	a2,44(s2)
    800041ac:	06c05563          	blez	a2,80004216 <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800041b0:	44cc                	lw	a1,12(s1)
    800041b2:	0001d717          	auipc	a4,0x1d
    800041b6:	78670713          	add	a4,a4,1926 # 80021938 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800041ba:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800041bc:	4314                	lw	a3,0(a4)
    800041be:	04b68d63          	beq	a3,a1,80004218 <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    800041c2:	2785                	addw	a5,a5,1
    800041c4:	0711                	add	a4,a4,4
    800041c6:	fec79be3          	bne	a5,a2,800041bc <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    800041ca:	0621                	add	a2,a2,8
    800041cc:	060a                	sll	a2,a2,0x2
    800041ce:	0001d797          	auipc	a5,0x1d
    800041d2:	73a78793          	add	a5,a5,1850 # 80021908 <log>
    800041d6:	97b2                	add	a5,a5,a2
    800041d8:	44d8                	lw	a4,12(s1)
    800041da:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800041dc:	8526                	mv	a0,s1
    800041de:	fffff097          	auipc	ra,0xfffff
    800041e2:	de4080e7          	jalr	-540(ra) # 80002fc2 <bpin>
    log.lh.n++;
    800041e6:	0001d717          	auipc	a4,0x1d
    800041ea:	72270713          	add	a4,a4,1826 # 80021908 <log>
    800041ee:	575c                	lw	a5,44(a4)
    800041f0:	2785                	addw	a5,a5,1
    800041f2:	d75c                	sw	a5,44(a4)
    800041f4:	a835                	j	80004230 <log_write+0xd0>
    panic("too big a transaction");
    800041f6:	00004517          	auipc	a0,0x4
    800041fa:	42250513          	add	a0,a0,1058 # 80008618 <syscalls+0x1f0>
    800041fe:	ffffc097          	auipc	ra,0xffffc
    80004202:	344080e7          	jalr	836(ra) # 80000542 <panic>
    panic("log_write outside of trans");
    80004206:	00004517          	auipc	a0,0x4
    8000420a:	42a50513          	add	a0,a0,1066 # 80008630 <syscalls+0x208>
    8000420e:	ffffc097          	auipc	ra,0xffffc
    80004212:	334080e7          	jalr	820(ra) # 80000542 <panic>
  for (i = 0; i < log.lh.n; i++) {
    80004216:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    80004218:	00878693          	add	a3,a5,8
    8000421c:	068a                	sll	a3,a3,0x2
    8000421e:	0001d717          	auipc	a4,0x1d
    80004222:	6ea70713          	add	a4,a4,1770 # 80021908 <log>
    80004226:	9736                	add	a4,a4,a3
    80004228:	44d4                	lw	a3,12(s1)
    8000422a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000422c:	faf608e3          	beq	a2,a5,800041dc <log_write+0x7c>
  }
  release(&log.lock);
    80004230:	0001d517          	auipc	a0,0x1d
    80004234:	6d850513          	add	a0,a0,1752 # 80021908 <log>
    80004238:	ffffd097          	auipc	ra,0xffffd
    8000423c:	a78080e7          	jalr	-1416(ra) # 80000cb0 <release>
}
    80004240:	60e2                	ld	ra,24(sp)
    80004242:	6442                	ld	s0,16(sp)
    80004244:	64a2                	ld	s1,8(sp)
    80004246:	6902                	ld	s2,0(sp)
    80004248:	6105                	add	sp,sp,32
    8000424a:	8082                	ret

000000008000424c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000424c:	1101                	add	sp,sp,-32
    8000424e:	ec06                	sd	ra,24(sp)
    80004250:	e822                	sd	s0,16(sp)
    80004252:	e426                	sd	s1,8(sp)
    80004254:	e04a                	sd	s2,0(sp)
    80004256:	1000                	add	s0,sp,32
    80004258:	84aa                	mv	s1,a0
    8000425a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000425c:	00004597          	auipc	a1,0x4
    80004260:	3f458593          	add	a1,a1,1012 # 80008650 <syscalls+0x228>
    80004264:	0521                	add	a0,a0,8
    80004266:	ffffd097          	auipc	ra,0xffffd
    8000426a:	906080e7          	jalr	-1786(ra) # 80000b6c <initlock>
  lk->name = name;
    8000426e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004272:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004276:	0204a423          	sw	zero,40(s1)
}
    8000427a:	60e2                	ld	ra,24(sp)
    8000427c:	6442                	ld	s0,16(sp)
    8000427e:	64a2                	ld	s1,8(sp)
    80004280:	6902                	ld	s2,0(sp)
    80004282:	6105                	add	sp,sp,32
    80004284:	8082                	ret

0000000080004286 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004286:	1101                	add	sp,sp,-32
    80004288:	ec06                	sd	ra,24(sp)
    8000428a:	e822                	sd	s0,16(sp)
    8000428c:	e426                	sd	s1,8(sp)
    8000428e:	e04a                	sd	s2,0(sp)
    80004290:	1000                	add	s0,sp,32
    80004292:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004294:	00850913          	add	s2,a0,8
    80004298:	854a                	mv	a0,s2
    8000429a:	ffffd097          	auipc	ra,0xffffd
    8000429e:	962080e7          	jalr	-1694(ra) # 80000bfc <acquire>
  while (lk->locked) {
    800042a2:	409c                	lw	a5,0(s1)
    800042a4:	cb89                	beqz	a5,800042b6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800042a6:	85ca                	mv	a1,s2
    800042a8:	8526                	mv	a0,s1
    800042aa:	ffffe097          	auipc	ra,0xffffe
    800042ae:	f30080e7          	jalr	-208(ra) # 800021da <sleep>
  while (lk->locked) {
    800042b2:	409c                	lw	a5,0(s1)
    800042b4:	fbed                	bnez	a5,800042a6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800042b6:	4785                	li	a5,1
    800042b8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800042ba:	ffffd097          	auipc	ra,0xffffd
    800042be:	70c080e7          	jalr	1804(ra) # 800019c6 <myproc>
    800042c2:	5d1c                	lw	a5,56(a0)
    800042c4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800042c6:	854a                	mv	a0,s2
    800042c8:	ffffd097          	auipc	ra,0xffffd
    800042cc:	9e8080e7          	jalr	-1560(ra) # 80000cb0 <release>
}
    800042d0:	60e2                	ld	ra,24(sp)
    800042d2:	6442                	ld	s0,16(sp)
    800042d4:	64a2                	ld	s1,8(sp)
    800042d6:	6902                	ld	s2,0(sp)
    800042d8:	6105                	add	sp,sp,32
    800042da:	8082                	ret

00000000800042dc <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800042dc:	1101                	add	sp,sp,-32
    800042de:	ec06                	sd	ra,24(sp)
    800042e0:	e822                	sd	s0,16(sp)
    800042e2:	e426                	sd	s1,8(sp)
    800042e4:	e04a                	sd	s2,0(sp)
    800042e6:	1000                	add	s0,sp,32
    800042e8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800042ea:	00850913          	add	s2,a0,8
    800042ee:	854a                	mv	a0,s2
    800042f0:	ffffd097          	auipc	ra,0xffffd
    800042f4:	90c080e7          	jalr	-1780(ra) # 80000bfc <acquire>
  lk->locked = 0;
    800042f8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800042fc:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004300:	8526                	mv	a0,s1
    80004302:	ffffe097          	auipc	ra,0xffffe
    80004306:	058080e7          	jalr	88(ra) # 8000235a <wakeup>
  release(&lk->lk);
    8000430a:	854a                	mv	a0,s2
    8000430c:	ffffd097          	auipc	ra,0xffffd
    80004310:	9a4080e7          	jalr	-1628(ra) # 80000cb0 <release>
}
    80004314:	60e2                	ld	ra,24(sp)
    80004316:	6442                	ld	s0,16(sp)
    80004318:	64a2                	ld	s1,8(sp)
    8000431a:	6902                	ld	s2,0(sp)
    8000431c:	6105                	add	sp,sp,32
    8000431e:	8082                	ret

0000000080004320 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004320:	7179                	add	sp,sp,-48
    80004322:	f406                	sd	ra,40(sp)
    80004324:	f022                	sd	s0,32(sp)
    80004326:	ec26                	sd	s1,24(sp)
    80004328:	e84a                	sd	s2,16(sp)
    8000432a:	e44e                	sd	s3,8(sp)
    8000432c:	1800                	add	s0,sp,48
    8000432e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004330:	00850913          	add	s2,a0,8
    80004334:	854a                	mv	a0,s2
    80004336:	ffffd097          	auipc	ra,0xffffd
    8000433a:	8c6080e7          	jalr	-1850(ra) # 80000bfc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000433e:	409c                	lw	a5,0(s1)
    80004340:	ef99                	bnez	a5,8000435e <holdingsleep+0x3e>
    80004342:	4481                	li	s1,0
  release(&lk->lk);
    80004344:	854a                	mv	a0,s2
    80004346:	ffffd097          	auipc	ra,0xffffd
    8000434a:	96a080e7          	jalr	-1686(ra) # 80000cb0 <release>
  return r;
}
    8000434e:	8526                	mv	a0,s1
    80004350:	70a2                	ld	ra,40(sp)
    80004352:	7402                	ld	s0,32(sp)
    80004354:	64e2                	ld	s1,24(sp)
    80004356:	6942                	ld	s2,16(sp)
    80004358:	69a2                	ld	s3,8(sp)
    8000435a:	6145                	add	sp,sp,48
    8000435c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000435e:	0284a983          	lw	s3,40(s1)
    80004362:	ffffd097          	auipc	ra,0xffffd
    80004366:	664080e7          	jalr	1636(ra) # 800019c6 <myproc>
    8000436a:	5d04                	lw	s1,56(a0)
    8000436c:	413484b3          	sub	s1,s1,s3
    80004370:	0014b493          	seqz	s1,s1
    80004374:	bfc1                	j	80004344 <holdingsleep+0x24>

0000000080004376 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004376:	1141                	add	sp,sp,-16
    80004378:	e406                	sd	ra,8(sp)
    8000437a:	e022                	sd	s0,0(sp)
    8000437c:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000437e:	00004597          	auipc	a1,0x4
    80004382:	2e258593          	add	a1,a1,738 # 80008660 <syscalls+0x238>
    80004386:	0001d517          	auipc	a0,0x1d
    8000438a:	6ca50513          	add	a0,a0,1738 # 80021a50 <ftable>
    8000438e:	ffffc097          	auipc	ra,0xffffc
    80004392:	7de080e7          	jalr	2014(ra) # 80000b6c <initlock>
}
    80004396:	60a2                	ld	ra,8(sp)
    80004398:	6402                	ld	s0,0(sp)
    8000439a:	0141                	add	sp,sp,16
    8000439c:	8082                	ret

000000008000439e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000439e:	1101                	add	sp,sp,-32
    800043a0:	ec06                	sd	ra,24(sp)
    800043a2:	e822                	sd	s0,16(sp)
    800043a4:	e426                	sd	s1,8(sp)
    800043a6:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800043a8:	0001d517          	auipc	a0,0x1d
    800043ac:	6a850513          	add	a0,a0,1704 # 80021a50 <ftable>
    800043b0:	ffffd097          	auipc	ra,0xffffd
    800043b4:	84c080e7          	jalr	-1972(ra) # 80000bfc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800043b8:	0001d497          	auipc	s1,0x1d
    800043bc:	6b048493          	add	s1,s1,1712 # 80021a68 <ftable+0x18>
    800043c0:	0001e717          	auipc	a4,0x1e
    800043c4:	64870713          	add	a4,a4,1608 # 80022a08 <ftable+0xfb8>
    if(f->ref == 0){
    800043c8:	40dc                	lw	a5,4(s1)
    800043ca:	cf99                	beqz	a5,800043e8 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800043cc:	02848493          	add	s1,s1,40
    800043d0:	fee49ce3          	bne	s1,a4,800043c8 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800043d4:	0001d517          	auipc	a0,0x1d
    800043d8:	67c50513          	add	a0,a0,1660 # 80021a50 <ftable>
    800043dc:	ffffd097          	auipc	ra,0xffffd
    800043e0:	8d4080e7          	jalr	-1836(ra) # 80000cb0 <release>
  return 0;
    800043e4:	4481                	li	s1,0
    800043e6:	a819                	j	800043fc <filealloc+0x5e>
      f->ref = 1;
    800043e8:	4785                	li	a5,1
    800043ea:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800043ec:	0001d517          	auipc	a0,0x1d
    800043f0:	66450513          	add	a0,a0,1636 # 80021a50 <ftable>
    800043f4:	ffffd097          	auipc	ra,0xffffd
    800043f8:	8bc080e7          	jalr	-1860(ra) # 80000cb0 <release>
}
    800043fc:	8526                	mv	a0,s1
    800043fe:	60e2                	ld	ra,24(sp)
    80004400:	6442                	ld	s0,16(sp)
    80004402:	64a2                	ld	s1,8(sp)
    80004404:	6105                	add	sp,sp,32
    80004406:	8082                	ret

0000000080004408 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004408:	1101                	add	sp,sp,-32
    8000440a:	ec06                	sd	ra,24(sp)
    8000440c:	e822                	sd	s0,16(sp)
    8000440e:	e426                	sd	s1,8(sp)
    80004410:	1000                	add	s0,sp,32
    80004412:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004414:	0001d517          	auipc	a0,0x1d
    80004418:	63c50513          	add	a0,a0,1596 # 80021a50 <ftable>
    8000441c:	ffffc097          	auipc	ra,0xffffc
    80004420:	7e0080e7          	jalr	2016(ra) # 80000bfc <acquire>
  if(f->ref < 1)
    80004424:	40dc                	lw	a5,4(s1)
    80004426:	02f05263          	blez	a5,8000444a <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000442a:	2785                	addw	a5,a5,1
    8000442c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000442e:	0001d517          	auipc	a0,0x1d
    80004432:	62250513          	add	a0,a0,1570 # 80021a50 <ftable>
    80004436:	ffffd097          	auipc	ra,0xffffd
    8000443a:	87a080e7          	jalr	-1926(ra) # 80000cb0 <release>
  return f;
}
    8000443e:	8526                	mv	a0,s1
    80004440:	60e2                	ld	ra,24(sp)
    80004442:	6442                	ld	s0,16(sp)
    80004444:	64a2                	ld	s1,8(sp)
    80004446:	6105                	add	sp,sp,32
    80004448:	8082                	ret
    panic("filedup");
    8000444a:	00004517          	auipc	a0,0x4
    8000444e:	21e50513          	add	a0,a0,542 # 80008668 <syscalls+0x240>
    80004452:	ffffc097          	auipc	ra,0xffffc
    80004456:	0f0080e7          	jalr	240(ra) # 80000542 <panic>

000000008000445a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000445a:	7139                	add	sp,sp,-64
    8000445c:	fc06                	sd	ra,56(sp)
    8000445e:	f822                	sd	s0,48(sp)
    80004460:	f426                	sd	s1,40(sp)
    80004462:	f04a                	sd	s2,32(sp)
    80004464:	ec4e                	sd	s3,24(sp)
    80004466:	e852                	sd	s4,16(sp)
    80004468:	e456                	sd	s5,8(sp)
    8000446a:	0080                	add	s0,sp,64
    8000446c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000446e:	0001d517          	auipc	a0,0x1d
    80004472:	5e250513          	add	a0,a0,1506 # 80021a50 <ftable>
    80004476:	ffffc097          	auipc	ra,0xffffc
    8000447a:	786080e7          	jalr	1926(ra) # 80000bfc <acquire>
  if(f->ref < 1)
    8000447e:	40dc                	lw	a5,4(s1)
    80004480:	06f05163          	blez	a5,800044e2 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004484:	37fd                	addw	a5,a5,-1
    80004486:	0007871b          	sext.w	a4,a5
    8000448a:	c0dc                	sw	a5,4(s1)
    8000448c:	06e04363          	bgtz	a4,800044f2 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004490:	0004a903          	lw	s2,0(s1)
    80004494:	0094ca83          	lbu	s5,9(s1)
    80004498:	0104ba03          	ld	s4,16(s1)
    8000449c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800044a0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800044a4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800044a8:	0001d517          	auipc	a0,0x1d
    800044ac:	5a850513          	add	a0,a0,1448 # 80021a50 <ftable>
    800044b0:	ffffd097          	auipc	ra,0xffffd
    800044b4:	800080e7          	jalr	-2048(ra) # 80000cb0 <release>

  if(ff.type == FD_PIPE){
    800044b8:	4785                	li	a5,1
    800044ba:	04f90d63          	beq	s2,a5,80004514 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800044be:	3979                	addw	s2,s2,-2
    800044c0:	4785                	li	a5,1
    800044c2:	0527e063          	bltu	a5,s2,80004502 <fileclose+0xa8>
    begin_op();
    800044c6:	00000097          	auipc	ra,0x0
    800044ca:	aca080e7          	jalr	-1334(ra) # 80003f90 <begin_op>
    iput(ff.ip);
    800044ce:	854e                	mv	a0,s3
    800044d0:	fffff097          	auipc	ra,0xfffff
    800044d4:	2da080e7          	jalr	730(ra) # 800037aa <iput>
    end_op();
    800044d8:	00000097          	auipc	ra,0x0
    800044dc:	b32080e7          	jalr	-1230(ra) # 8000400a <end_op>
    800044e0:	a00d                	j	80004502 <fileclose+0xa8>
    panic("fileclose");
    800044e2:	00004517          	auipc	a0,0x4
    800044e6:	18e50513          	add	a0,a0,398 # 80008670 <syscalls+0x248>
    800044ea:	ffffc097          	auipc	ra,0xffffc
    800044ee:	058080e7          	jalr	88(ra) # 80000542 <panic>
    release(&ftable.lock);
    800044f2:	0001d517          	auipc	a0,0x1d
    800044f6:	55e50513          	add	a0,a0,1374 # 80021a50 <ftable>
    800044fa:	ffffc097          	auipc	ra,0xffffc
    800044fe:	7b6080e7          	jalr	1974(ra) # 80000cb0 <release>
  }
}
    80004502:	70e2                	ld	ra,56(sp)
    80004504:	7442                	ld	s0,48(sp)
    80004506:	74a2                	ld	s1,40(sp)
    80004508:	7902                	ld	s2,32(sp)
    8000450a:	69e2                	ld	s3,24(sp)
    8000450c:	6a42                	ld	s4,16(sp)
    8000450e:	6aa2                	ld	s5,8(sp)
    80004510:	6121                	add	sp,sp,64
    80004512:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004514:	85d6                	mv	a1,s5
    80004516:	8552                	mv	a0,s4
    80004518:	00000097          	auipc	ra,0x0
    8000451c:	372080e7          	jalr	882(ra) # 8000488a <pipeclose>
    80004520:	b7cd                	j	80004502 <fileclose+0xa8>

0000000080004522 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004522:	715d                	add	sp,sp,-80
    80004524:	e486                	sd	ra,72(sp)
    80004526:	e0a2                	sd	s0,64(sp)
    80004528:	fc26                	sd	s1,56(sp)
    8000452a:	f84a                	sd	s2,48(sp)
    8000452c:	f44e                	sd	s3,40(sp)
    8000452e:	0880                	add	s0,sp,80
    80004530:	84aa                	mv	s1,a0
    80004532:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004534:	ffffd097          	auipc	ra,0xffffd
    80004538:	492080e7          	jalr	1170(ra) # 800019c6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000453c:	409c                	lw	a5,0(s1)
    8000453e:	37f9                	addw	a5,a5,-2
    80004540:	4705                	li	a4,1
    80004542:	04f76763          	bltu	a4,a5,80004590 <filestat+0x6e>
    80004546:	892a                	mv	s2,a0
    ilock(f->ip);
    80004548:	6c88                	ld	a0,24(s1)
    8000454a:	fffff097          	auipc	ra,0xfffff
    8000454e:	0a6080e7          	jalr	166(ra) # 800035f0 <ilock>
    stati(f->ip, &st);
    80004552:	fb840593          	add	a1,s0,-72
    80004556:	6c88                	ld	a0,24(s1)
    80004558:	fffff097          	auipc	ra,0xfffff
    8000455c:	322080e7          	jalr	802(ra) # 8000387a <stati>
    iunlock(f->ip);
    80004560:	6c88                	ld	a0,24(s1)
    80004562:	fffff097          	auipc	ra,0xfffff
    80004566:	150080e7          	jalr	336(ra) # 800036b2 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000456a:	46e1                	li	a3,24
    8000456c:	fb840613          	add	a2,s0,-72
    80004570:	85ce                	mv	a1,s3
    80004572:	05093503          	ld	a0,80(s2)
    80004576:	ffffd097          	auipc	ra,0xffffd
    8000457a:	146080e7          	jalr	326(ra) # 800016bc <copyout>
    8000457e:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004582:	60a6                	ld	ra,72(sp)
    80004584:	6406                	ld	s0,64(sp)
    80004586:	74e2                	ld	s1,56(sp)
    80004588:	7942                	ld	s2,48(sp)
    8000458a:	79a2                	ld	s3,40(sp)
    8000458c:	6161                	add	sp,sp,80
    8000458e:	8082                	ret
  return -1;
    80004590:	557d                	li	a0,-1
    80004592:	bfc5                	j	80004582 <filestat+0x60>

0000000080004594 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004594:	7179                	add	sp,sp,-48
    80004596:	f406                	sd	ra,40(sp)
    80004598:	f022                	sd	s0,32(sp)
    8000459a:	ec26                	sd	s1,24(sp)
    8000459c:	e84a                	sd	s2,16(sp)
    8000459e:	e44e                	sd	s3,8(sp)
    800045a0:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800045a2:	00854783          	lbu	a5,8(a0)
    800045a6:	c3d5                	beqz	a5,8000464a <fileread+0xb6>
    800045a8:	84aa                	mv	s1,a0
    800045aa:	89ae                	mv	s3,a1
    800045ac:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800045ae:	411c                	lw	a5,0(a0)
    800045b0:	4705                	li	a4,1
    800045b2:	04e78963          	beq	a5,a4,80004604 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800045b6:	470d                	li	a4,3
    800045b8:	04e78d63          	beq	a5,a4,80004612 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800045bc:	4709                	li	a4,2
    800045be:	06e79e63          	bne	a5,a4,8000463a <fileread+0xa6>
    ilock(f->ip);
    800045c2:	6d08                	ld	a0,24(a0)
    800045c4:	fffff097          	auipc	ra,0xfffff
    800045c8:	02c080e7          	jalr	44(ra) # 800035f0 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800045cc:	874a                	mv	a4,s2
    800045ce:	5094                	lw	a3,32(s1)
    800045d0:	864e                	mv	a2,s3
    800045d2:	4585                	li	a1,1
    800045d4:	6c88                	ld	a0,24(s1)
    800045d6:	fffff097          	auipc	ra,0xfffff
    800045da:	2ce080e7          	jalr	718(ra) # 800038a4 <readi>
    800045de:	892a                	mv	s2,a0
    800045e0:	00a05563          	blez	a0,800045ea <fileread+0x56>
      f->off += r;
    800045e4:	509c                	lw	a5,32(s1)
    800045e6:	9fa9                	addw	a5,a5,a0
    800045e8:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800045ea:	6c88                	ld	a0,24(s1)
    800045ec:	fffff097          	auipc	ra,0xfffff
    800045f0:	0c6080e7          	jalr	198(ra) # 800036b2 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800045f4:	854a                	mv	a0,s2
    800045f6:	70a2                	ld	ra,40(sp)
    800045f8:	7402                	ld	s0,32(sp)
    800045fa:	64e2                	ld	s1,24(sp)
    800045fc:	6942                	ld	s2,16(sp)
    800045fe:	69a2                	ld	s3,8(sp)
    80004600:	6145                	add	sp,sp,48
    80004602:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004604:	6908                	ld	a0,16(a0)
    80004606:	00000097          	auipc	ra,0x0
    8000460a:	3ee080e7          	jalr	1006(ra) # 800049f4 <piperead>
    8000460e:	892a                	mv	s2,a0
    80004610:	b7d5                	j	800045f4 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004612:	02451783          	lh	a5,36(a0)
    80004616:	03079693          	sll	a3,a5,0x30
    8000461a:	92c1                	srl	a3,a3,0x30
    8000461c:	4725                	li	a4,9
    8000461e:	02d76863          	bltu	a4,a3,8000464e <fileread+0xba>
    80004622:	0792                	sll	a5,a5,0x4
    80004624:	0001d717          	auipc	a4,0x1d
    80004628:	38c70713          	add	a4,a4,908 # 800219b0 <devsw>
    8000462c:	97ba                	add	a5,a5,a4
    8000462e:	639c                	ld	a5,0(a5)
    80004630:	c38d                	beqz	a5,80004652 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004632:	4505                	li	a0,1
    80004634:	9782                	jalr	a5
    80004636:	892a                	mv	s2,a0
    80004638:	bf75                	j	800045f4 <fileread+0x60>
    panic("fileread");
    8000463a:	00004517          	auipc	a0,0x4
    8000463e:	04650513          	add	a0,a0,70 # 80008680 <syscalls+0x258>
    80004642:	ffffc097          	auipc	ra,0xffffc
    80004646:	f00080e7          	jalr	-256(ra) # 80000542 <panic>
    return -1;
    8000464a:	597d                	li	s2,-1
    8000464c:	b765                	j	800045f4 <fileread+0x60>
      return -1;
    8000464e:	597d                	li	s2,-1
    80004650:	b755                	j	800045f4 <fileread+0x60>
    80004652:	597d                	li	s2,-1
    80004654:	b745                	j	800045f4 <fileread+0x60>

0000000080004656 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004656:	00954783          	lbu	a5,9(a0)
    8000465a:	14078363          	beqz	a5,800047a0 <filewrite+0x14a>
{
    8000465e:	715d                	add	sp,sp,-80
    80004660:	e486                	sd	ra,72(sp)
    80004662:	e0a2                	sd	s0,64(sp)
    80004664:	fc26                	sd	s1,56(sp)
    80004666:	f84a                	sd	s2,48(sp)
    80004668:	f44e                	sd	s3,40(sp)
    8000466a:	f052                	sd	s4,32(sp)
    8000466c:	ec56                	sd	s5,24(sp)
    8000466e:	e85a                	sd	s6,16(sp)
    80004670:	e45e                	sd	s7,8(sp)
    80004672:	e062                	sd	s8,0(sp)
    80004674:	0880                	add	s0,sp,80
    80004676:	892a                	mv	s2,a0
    80004678:	8b2e                	mv	s6,a1
    8000467a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000467c:	411c                	lw	a5,0(a0)
    8000467e:	4705                	li	a4,1
    80004680:	02e78263          	beq	a5,a4,800046a4 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004684:	470d                	li	a4,3
    80004686:	02e78563          	beq	a5,a4,800046b0 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000468a:	4709                	li	a4,2
    8000468c:	10e79263          	bne	a5,a4,80004790 <filewrite+0x13a>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004690:	0ec05e63          	blez	a2,8000478c <filewrite+0x136>
    int i = 0;
    80004694:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004696:	6b85                	lui	s7,0x1
    80004698:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000469c:	6c05                	lui	s8,0x1
    8000469e:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800046a2:	a851                	j	80004736 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    800046a4:	6908                	ld	a0,16(a0)
    800046a6:	00000097          	auipc	ra,0x0
    800046aa:	254080e7          	jalr	596(ra) # 800048fa <pipewrite>
    800046ae:	a85d                	j	80004764 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800046b0:	02451783          	lh	a5,36(a0)
    800046b4:	03079693          	sll	a3,a5,0x30
    800046b8:	92c1                	srl	a3,a3,0x30
    800046ba:	4725                	li	a4,9
    800046bc:	0ed76463          	bltu	a4,a3,800047a4 <filewrite+0x14e>
    800046c0:	0792                	sll	a5,a5,0x4
    800046c2:	0001d717          	auipc	a4,0x1d
    800046c6:	2ee70713          	add	a4,a4,750 # 800219b0 <devsw>
    800046ca:	97ba                	add	a5,a5,a4
    800046cc:	679c                	ld	a5,8(a5)
    800046ce:	cfe9                	beqz	a5,800047a8 <filewrite+0x152>
    ret = devsw[f->major].write(1, addr, n);
    800046d0:	4505                	li	a0,1
    800046d2:	9782                	jalr	a5
    800046d4:	a841                	j	80004764 <filewrite+0x10e>
      if(n1 > max)
    800046d6:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800046da:	00000097          	auipc	ra,0x0
    800046de:	8b6080e7          	jalr	-1866(ra) # 80003f90 <begin_op>
      ilock(f->ip);
    800046e2:	01893503          	ld	a0,24(s2)
    800046e6:	fffff097          	auipc	ra,0xfffff
    800046ea:	f0a080e7          	jalr	-246(ra) # 800035f0 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800046ee:	8756                	mv	a4,s5
    800046f0:	02092683          	lw	a3,32(s2)
    800046f4:	01698633          	add	a2,s3,s6
    800046f8:	4585                	li	a1,1
    800046fa:	01893503          	ld	a0,24(s2)
    800046fe:	fffff097          	auipc	ra,0xfffff
    80004702:	29c080e7          	jalr	668(ra) # 8000399a <writei>
    80004706:	84aa                	mv	s1,a0
    80004708:	02a05f63          	blez	a0,80004746 <filewrite+0xf0>
        f->off += r;
    8000470c:	02092783          	lw	a5,32(s2)
    80004710:	9fa9                	addw	a5,a5,a0
    80004712:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004716:	01893503          	ld	a0,24(s2)
    8000471a:	fffff097          	auipc	ra,0xfffff
    8000471e:	f98080e7          	jalr	-104(ra) # 800036b2 <iunlock>
      end_op();
    80004722:	00000097          	auipc	ra,0x0
    80004726:	8e8080e7          	jalr	-1816(ra) # 8000400a <end_op>

      if(r < 0)
        break;
      if(r != n1)
    8000472a:	049a9963          	bne	s5,s1,8000477c <filewrite+0x126>
        panic("short filewrite");
      i += r;
    8000472e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004732:	0349d663          	bge	s3,s4,8000475e <filewrite+0x108>
      int n1 = n - i;
    80004736:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000473a:	0004879b          	sext.w	a5,s1
    8000473e:	f8fbdce3          	bge	s7,a5,800046d6 <filewrite+0x80>
    80004742:	84e2                	mv	s1,s8
    80004744:	bf49                	j	800046d6 <filewrite+0x80>
      iunlock(f->ip);
    80004746:	01893503          	ld	a0,24(s2)
    8000474a:	fffff097          	auipc	ra,0xfffff
    8000474e:	f68080e7          	jalr	-152(ra) # 800036b2 <iunlock>
      end_op();
    80004752:	00000097          	auipc	ra,0x0
    80004756:	8b8080e7          	jalr	-1864(ra) # 8000400a <end_op>
      if(r < 0)
    8000475a:	fc04d8e3          	bgez	s1,8000472a <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    8000475e:	053a1763          	bne	s4,s3,800047ac <filewrite+0x156>
    80004762:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004764:	60a6                	ld	ra,72(sp)
    80004766:	6406                	ld	s0,64(sp)
    80004768:	74e2                	ld	s1,56(sp)
    8000476a:	7942                	ld	s2,48(sp)
    8000476c:	79a2                	ld	s3,40(sp)
    8000476e:	7a02                	ld	s4,32(sp)
    80004770:	6ae2                	ld	s5,24(sp)
    80004772:	6b42                	ld	s6,16(sp)
    80004774:	6ba2                	ld	s7,8(sp)
    80004776:	6c02                	ld	s8,0(sp)
    80004778:	6161                	add	sp,sp,80
    8000477a:	8082                	ret
        panic("short filewrite");
    8000477c:	00004517          	auipc	a0,0x4
    80004780:	f1450513          	add	a0,a0,-236 # 80008690 <syscalls+0x268>
    80004784:	ffffc097          	auipc	ra,0xffffc
    80004788:	dbe080e7          	jalr	-578(ra) # 80000542 <panic>
    int i = 0;
    8000478c:	4981                	li	s3,0
    8000478e:	bfc1                	j	8000475e <filewrite+0x108>
    panic("filewrite");
    80004790:	00004517          	auipc	a0,0x4
    80004794:	f1050513          	add	a0,a0,-240 # 800086a0 <syscalls+0x278>
    80004798:	ffffc097          	auipc	ra,0xffffc
    8000479c:	daa080e7          	jalr	-598(ra) # 80000542 <panic>
    return -1;
    800047a0:	557d                	li	a0,-1
}
    800047a2:	8082                	ret
      return -1;
    800047a4:	557d                	li	a0,-1
    800047a6:	bf7d                	j	80004764 <filewrite+0x10e>
    800047a8:	557d                	li	a0,-1
    800047aa:	bf6d                	j	80004764 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    800047ac:	557d                	li	a0,-1
    800047ae:	bf5d                	j	80004764 <filewrite+0x10e>

00000000800047b0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800047b0:	7179                	add	sp,sp,-48
    800047b2:	f406                	sd	ra,40(sp)
    800047b4:	f022                	sd	s0,32(sp)
    800047b6:	ec26                	sd	s1,24(sp)
    800047b8:	e84a                	sd	s2,16(sp)
    800047ba:	e44e                	sd	s3,8(sp)
    800047bc:	e052                	sd	s4,0(sp)
    800047be:	1800                	add	s0,sp,48
    800047c0:	84aa                	mv	s1,a0
    800047c2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800047c4:	0005b023          	sd	zero,0(a1)
    800047c8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800047cc:	00000097          	auipc	ra,0x0
    800047d0:	bd2080e7          	jalr	-1070(ra) # 8000439e <filealloc>
    800047d4:	e088                	sd	a0,0(s1)
    800047d6:	c551                	beqz	a0,80004862 <pipealloc+0xb2>
    800047d8:	00000097          	auipc	ra,0x0
    800047dc:	bc6080e7          	jalr	-1082(ra) # 8000439e <filealloc>
    800047e0:	00aa3023          	sd	a0,0(s4)
    800047e4:	c92d                	beqz	a0,80004856 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800047e6:	ffffc097          	auipc	ra,0xffffc
    800047ea:	326080e7          	jalr	806(ra) # 80000b0c <kalloc>
    800047ee:	892a                	mv	s2,a0
    800047f0:	c125                	beqz	a0,80004850 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    800047f2:	4985                	li	s3,1
    800047f4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800047f8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800047fc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004800:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004804:	00004597          	auipc	a1,0x4
    80004808:	eac58593          	add	a1,a1,-340 # 800086b0 <syscalls+0x288>
    8000480c:	ffffc097          	auipc	ra,0xffffc
    80004810:	360080e7          	jalr	864(ra) # 80000b6c <initlock>
  (*f0)->type = FD_PIPE;
    80004814:	609c                	ld	a5,0(s1)
    80004816:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000481a:	609c                	ld	a5,0(s1)
    8000481c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004820:	609c                	ld	a5,0(s1)
    80004822:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004826:	609c                	ld	a5,0(s1)
    80004828:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000482c:	000a3783          	ld	a5,0(s4)
    80004830:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004834:	000a3783          	ld	a5,0(s4)
    80004838:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000483c:	000a3783          	ld	a5,0(s4)
    80004840:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004844:	000a3783          	ld	a5,0(s4)
    80004848:	0127b823          	sd	s2,16(a5)
  return 0;
    8000484c:	4501                	li	a0,0
    8000484e:	a025                	j	80004876 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004850:	6088                	ld	a0,0(s1)
    80004852:	e501                	bnez	a0,8000485a <pipealloc+0xaa>
    80004854:	a039                	j	80004862 <pipealloc+0xb2>
    80004856:	6088                	ld	a0,0(s1)
    80004858:	c51d                	beqz	a0,80004886 <pipealloc+0xd6>
    fileclose(*f0);
    8000485a:	00000097          	auipc	ra,0x0
    8000485e:	c00080e7          	jalr	-1024(ra) # 8000445a <fileclose>
  if(*f1)
    80004862:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004866:	557d                	li	a0,-1
  if(*f1)
    80004868:	c799                	beqz	a5,80004876 <pipealloc+0xc6>
    fileclose(*f1);
    8000486a:	853e                	mv	a0,a5
    8000486c:	00000097          	auipc	ra,0x0
    80004870:	bee080e7          	jalr	-1042(ra) # 8000445a <fileclose>
  return -1;
    80004874:	557d                	li	a0,-1
}
    80004876:	70a2                	ld	ra,40(sp)
    80004878:	7402                	ld	s0,32(sp)
    8000487a:	64e2                	ld	s1,24(sp)
    8000487c:	6942                	ld	s2,16(sp)
    8000487e:	69a2                	ld	s3,8(sp)
    80004880:	6a02                	ld	s4,0(sp)
    80004882:	6145                	add	sp,sp,48
    80004884:	8082                	ret
  return -1;
    80004886:	557d                	li	a0,-1
    80004888:	b7fd                	j	80004876 <pipealloc+0xc6>

000000008000488a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000488a:	1101                	add	sp,sp,-32
    8000488c:	ec06                	sd	ra,24(sp)
    8000488e:	e822                	sd	s0,16(sp)
    80004890:	e426                	sd	s1,8(sp)
    80004892:	e04a                	sd	s2,0(sp)
    80004894:	1000                	add	s0,sp,32
    80004896:	84aa                	mv	s1,a0
    80004898:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000489a:	ffffc097          	auipc	ra,0xffffc
    8000489e:	362080e7          	jalr	866(ra) # 80000bfc <acquire>
  if(writable){
    800048a2:	02090d63          	beqz	s2,800048dc <pipeclose+0x52>
    pi->writeopen = 0;
    800048a6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800048aa:	21848513          	add	a0,s1,536
    800048ae:	ffffe097          	auipc	ra,0xffffe
    800048b2:	aac080e7          	jalr	-1364(ra) # 8000235a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800048b6:	2204b783          	ld	a5,544(s1)
    800048ba:	eb95                	bnez	a5,800048ee <pipeclose+0x64>
    release(&pi->lock);
    800048bc:	8526                	mv	a0,s1
    800048be:	ffffc097          	auipc	ra,0xffffc
    800048c2:	3f2080e7          	jalr	1010(ra) # 80000cb0 <release>
    kfree((char*)pi);
    800048c6:	8526                	mv	a0,s1
    800048c8:	ffffc097          	auipc	ra,0xffffc
    800048cc:	146080e7          	jalr	326(ra) # 80000a0e <kfree>
  } else
    release(&pi->lock);
}
    800048d0:	60e2                	ld	ra,24(sp)
    800048d2:	6442                	ld	s0,16(sp)
    800048d4:	64a2                	ld	s1,8(sp)
    800048d6:	6902                	ld	s2,0(sp)
    800048d8:	6105                	add	sp,sp,32
    800048da:	8082                	ret
    pi->readopen = 0;
    800048dc:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800048e0:	21c48513          	add	a0,s1,540
    800048e4:	ffffe097          	auipc	ra,0xffffe
    800048e8:	a76080e7          	jalr	-1418(ra) # 8000235a <wakeup>
    800048ec:	b7e9                	j	800048b6 <pipeclose+0x2c>
    release(&pi->lock);
    800048ee:	8526                	mv	a0,s1
    800048f0:	ffffc097          	auipc	ra,0xffffc
    800048f4:	3c0080e7          	jalr	960(ra) # 80000cb0 <release>
}
    800048f8:	bfe1                	j	800048d0 <pipeclose+0x46>

00000000800048fa <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800048fa:	711d                	add	sp,sp,-96
    800048fc:	ec86                	sd	ra,88(sp)
    800048fe:	e8a2                	sd	s0,80(sp)
    80004900:	e4a6                	sd	s1,72(sp)
    80004902:	e0ca                	sd	s2,64(sp)
    80004904:	fc4e                	sd	s3,56(sp)
    80004906:	f852                	sd	s4,48(sp)
    80004908:	f456                	sd	s5,40(sp)
    8000490a:	f05a                	sd	s6,32(sp)
    8000490c:	ec5e                	sd	s7,24(sp)
    8000490e:	1080                	add	s0,sp,96
    80004910:	84aa                	mv	s1,a0
    80004912:	8b2e                	mv	s6,a1
    80004914:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004916:	ffffd097          	auipc	ra,0xffffd
    8000491a:	0b0080e7          	jalr	176(ra) # 800019c6 <myproc>
    8000491e:	892a                	mv	s2,a0

  acquire(&pi->lock);
    80004920:	8526                	mv	a0,s1
    80004922:	ffffc097          	auipc	ra,0xffffc
    80004926:	2da080e7          	jalr	730(ra) # 80000bfc <acquire>
  for(i = 0; i < n; i++){
    8000492a:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    8000492c:	21848a13          	add	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004930:	21c48993          	add	s3,s1,540
  for(i = 0; i < n; i++){
    80004934:	09505263          	blez	s5,800049b8 <pipewrite+0xbe>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004938:	2184a783          	lw	a5,536(s1)
    8000493c:	21c4a703          	lw	a4,540(s1)
    80004940:	2007879b          	addw	a5,a5,512
    80004944:	02f71b63          	bne	a4,a5,8000497a <pipewrite+0x80>
      if(pi->readopen == 0 || pr->killed){
    80004948:	2204a783          	lw	a5,544(s1)
    8000494c:	c3d1                	beqz	a5,800049d0 <pipewrite+0xd6>
    8000494e:	03092783          	lw	a5,48(s2)
    80004952:	efbd                	bnez	a5,800049d0 <pipewrite+0xd6>
      wakeup(&pi->nread);
    80004954:	8552                	mv	a0,s4
    80004956:	ffffe097          	auipc	ra,0xffffe
    8000495a:	a04080e7          	jalr	-1532(ra) # 8000235a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000495e:	85a6                	mv	a1,s1
    80004960:	854e                	mv	a0,s3
    80004962:	ffffe097          	auipc	ra,0xffffe
    80004966:	878080e7          	jalr	-1928(ra) # 800021da <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    8000496a:	2184a783          	lw	a5,536(s1)
    8000496e:	21c4a703          	lw	a4,540(s1)
    80004972:	2007879b          	addw	a5,a5,512
    80004976:	fcf709e3          	beq	a4,a5,80004948 <pipewrite+0x4e>
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000497a:	4685                	li	a3,1
    8000497c:	865a                	mv	a2,s6
    8000497e:	faf40593          	add	a1,s0,-81
    80004982:	05093503          	ld	a0,80(s2)
    80004986:	ffffd097          	auipc	ra,0xffffd
    8000498a:	dc2080e7          	jalr	-574(ra) # 80001748 <copyin>
    8000498e:	57fd                	li	a5,-1
    80004990:	02f50463          	beq	a0,a5,800049b8 <pipewrite+0xbe>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004994:	21c4a783          	lw	a5,540(s1)
    80004998:	0017871b          	addw	a4,a5,1
    8000499c:	20e4ae23          	sw	a4,540(s1)
    800049a0:	1ff7f793          	and	a5,a5,511
    800049a4:	97a6                	add	a5,a5,s1
    800049a6:	faf44703          	lbu	a4,-81(s0)
    800049aa:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    800049ae:	2b85                	addw	s7,s7,1
    800049b0:	0b05                	add	s6,s6,1
    800049b2:	f97a93e3          	bne	s5,s7,80004938 <pipewrite+0x3e>
    800049b6:	8bd6                	mv	s7,s5
  }
  wakeup(&pi->nread);
    800049b8:	21848513          	add	a0,s1,536
    800049bc:	ffffe097          	auipc	ra,0xffffe
    800049c0:	99e080e7          	jalr	-1634(ra) # 8000235a <wakeup>
  release(&pi->lock);
    800049c4:	8526                	mv	a0,s1
    800049c6:	ffffc097          	auipc	ra,0xffffc
    800049ca:	2ea080e7          	jalr	746(ra) # 80000cb0 <release>
  return i;
    800049ce:	a039                	j	800049dc <pipewrite+0xe2>
        release(&pi->lock);
    800049d0:	8526                	mv	a0,s1
    800049d2:	ffffc097          	auipc	ra,0xffffc
    800049d6:	2de080e7          	jalr	734(ra) # 80000cb0 <release>
        return -1;
    800049da:	5bfd                	li	s7,-1
}
    800049dc:	855e                	mv	a0,s7
    800049de:	60e6                	ld	ra,88(sp)
    800049e0:	6446                	ld	s0,80(sp)
    800049e2:	64a6                	ld	s1,72(sp)
    800049e4:	6906                	ld	s2,64(sp)
    800049e6:	79e2                	ld	s3,56(sp)
    800049e8:	7a42                	ld	s4,48(sp)
    800049ea:	7aa2                	ld	s5,40(sp)
    800049ec:	7b02                	ld	s6,32(sp)
    800049ee:	6be2                	ld	s7,24(sp)
    800049f0:	6125                	add	sp,sp,96
    800049f2:	8082                	ret

00000000800049f4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800049f4:	715d                	add	sp,sp,-80
    800049f6:	e486                	sd	ra,72(sp)
    800049f8:	e0a2                	sd	s0,64(sp)
    800049fa:	fc26                	sd	s1,56(sp)
    800049fc:	f84a                	sd	s2,48(sp)
    800049fe:	f44e                	sd	s3,40(sp)
    80004a00:	f052                	sd	s4,32(sp)
    80004a02:	ec56                	sd	s5,24(sp)
    80004a04:	e85a                	sd	s6,16(sp)
    80004a06:	0880                	add	s0,sp,80
    80004a08:	84aa                	mv	s1,a0
    80004a0a:	892e                	mv	s2,a1
    80004a0c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004a0e:	ffffd097          	auipc	ra,0xffffd
    80004a12:	fb8080e7          	jalr	-72(ra) # 800019c6 <myproc>
    80004a16:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004a18:	8526                	mv	a0,s1
    80004a1a:	ffffc097          	auipc	ra,0xffffc
    80004a1e:	1e2080e7          	jalr	482(ra) # 80000bfc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a22:	2184a703          	lw	a4,536(s1)
    80004a26:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a2a:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a2e:	02f71463          	bne	a4,a5,80004a56 <piperead+0x62>
    80004a32:	2244a783          	lw	a5,548(s1)
    80004a36:	c385                	beqz	a5,80004a56 <piperead+0x62>
    if(pr->killed){
    80004a38:	030a2783          	lw	a5,48(s4)
    80004a3c:	ebc9                	bnez	a5,80004ace <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a3e:	85a6                	mv	a1,s1
    80004a40:	854e                	mv	a0,s3
    80004a42:	ffffd097          	auipc	ra,0xffffd
    80004a46:	798080e7          	jalr	1944(ra) # 800021da <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a4a:	2184a703          	lw	a4,536(s1)
    80004a4e:	21c4a783          	lw	a5,540(s1)
    80004a52:	fef700e3          	beq	a4,a5,80004a32 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a56:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004a58:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a5a:	05505463          	blez	s5,80004aa2 <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004a5e:	2184a783          	lw	a5,536(s1)
    80004a62:	21c4a703          	lw	a4,540(s1)
    80004a66:	02f70e63          	beq	a4,a5,80004aa2 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004a6a:	0017871b          	addw	a4,a5,1
    80004a6e:	20e4ac23          	sw	a4,536(s1)
    80004a72:	1ff7f793          	and	a5,a5,511
    80004a76:	97a6                	add	a5,a5,s1
    80004a78:	0187c783          	lbu	a5,24(a5)
    80004a7c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004a80:	4685                	li	a3,1
    80004a82:	fbf40613          	add	a2,s0,-65
    80004a86:	85ca                	mv	a1,s2
    80004a88:	050a3503          	ld	a0,80(s4)
    80004a8c:	ffffd097          	auipc	ra,0xffffd
    80004a90:	c30080e7          	jalr	-976(ra) # 800016bc <copyout>
    80004a94:	01650763          	beq	a0,s6,80004aa2 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a98:	2985                	addw	s3,s3,1
    80004a9a:	0905                	add	s2,s2,1
    80004a9c:	fd3a91e3          	bne	s5,s3,80004a5e <piperead+0x6a>
    80004aa0:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004aa2:	21c48513          	add	a0,s1,540
    80004aa6:	ffffe097          	auipc	ra,0xffffe
    80004aaa:	8b4080e7          	jalr	-1868(ra) # 8000235a <wakeup>
  release(&pi->lock);
    80004aae:	8526                	mv	a0,s1
    80004ab0:	ffffc097          	auipc	ra,0xffffc
    80004ab4:	200080e7          	jalr	512(ra) # 80000cb0 <release>
  return i;
}
    80004ab8:	854e                	mv	a0,s3
    80004aba:	60a6                	ld	ra,72(sp)
    80004abc:	6406                	ld	s0,64(sp)
    80004abe:	74e2                	ld	s1,56(sp)
    80004ac0:	7942                	ld	s2,48(sp)
    80004ac2:	79a2                	ld	s3,40(sp)
    80004ac4:	7a02                	ld	s4,32(sp)
    80004ac6:	6ae2                	ld	s5,24(sp)
    80004ac8:	6b42                	ld	s6,16(sp)
    80004aca:	6161                	add	sp,sp,80
    80004acc:	8082                	ret
      release(&pi->lock);
    80004ace:	8526                	mv	a0,s1
    80004ad0:	ffffc097          	auipc	ra,0xffffc
    80004ad4:	1e0080e7          	jalr	480(ra) # 80000cb0 <release>
      return -1;
    80004ad8:	59fd                	li	s3,-1
    80004ada:	bff9                	j	80004ab8 <piperead+0xc4>

0000000080004adc <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004adc:	df010113          	add	sp,sp,-528
    80004ae0:	20113423          	sd	ra,520(sp)
    80004ae4:	20813023          	sd	s0,512(sp)
    80004ae8:	ffa6                	sd	s1,504(sp)
    80004aea:	fbca                	sd	s2,496(sp)
    80004aec:	f7ce                	sd	s3,488(sp)
    80004aee:	f3d2                	sd	s4,480(sp)
    80004af0:	efd6                	sd	s5,472(sp)
    80004af2:	ebda                	sd	s6,464(sp)
    80004af4:	e7de                	sd	s7,456(sp)
    80004af6:	e3e2                	sd	s8,448(sp)
    80004af8:	ff66                	sd	s9,440(sp)
    80004afa:	fb6a                	sd	s10,432(sp)
    80004afc:	f76e                	sd	s11,424(sp)
    80004afe:	0c00                	add	s0,sp,528
    80004b00:	892a                	mv	s2,a0
    80004b02:	dea43c23          	sd	a0,-520(s0)
    80004b06:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004b0a:	ffffd097          	auipc	ra,0xffffd
    80004b0e:	ebc080e7          	jalr	-324(ra) # 800019c6 <myproc>
    80004b12:	84aa                	mv	s1,a0

  begin_op();
    80004b14:	fffff097          	auipc	ra,0xfffff
    80004b18:	47c080e7          	jalr	1148(ra) # 80003f90 <begin_op>

  if((ip = namei(path)) == 0){
    80004b1c:	854a                	mv	a0,s2
    80004b1e:	fffff097          	auipc	ra,0xfffff
    80004b22:	282080e7          	jalr	642(ra) # 80003da0 <namei>
    80004b26:	c92d                	beqz	a0,80004b98 <exec+0xbc>
    80004b28:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004b2a:	fffff097          	auipc	ra,0xfffff
    80004b2e:	ac6080e7          	jalr	-1338(ra) # 800035f0 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004b32:	04000713          	li	a4,64
    80004b36:	4681                	li	a3,0
    80004b38:	e4840613          	add	a2,s0,-440
    80004b3c:	4581                	li	a1,0
    80004b3e:	8552                	mv	a0,s4
    80004b40:	fffff097          	auipc	ra,0xfffff
    80004b44:	d64080e7          	jalr	-668(ra) # 800038a4 <readi>
    80004b48:	04000793          	li	a5,64
    80004b4c:	00f51a63          	bne	a0,a5,80004b60 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004b50:	e4842703          	lw	a4,-440(s0)
    80004b54:	464c47b7          	lui	a5,0x464c4
    80004b58:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004b5c:	04f70463          	beq	a4,a5,80004ba4 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004b60:	8552                	mv	a0,s4
    80004b62:	fffff097          	auipc	ra,0xfffff
    80004b66:	cf0080e7          	jalr	-784(ra) # 80003852 <iunlockput>
    end_op();
    80004b6a:	fffff097          	auipc	ra,0xfffff
    80004b6e:	4a0080e7          	jalr	1184(ra) # 8000400a <end_op>
  }
  return -1;
    80004b72:	557d                	li	a0,-1
}
    80004b74:	20813083          	ld	ra,520(sp)
    80004b78:	20013403          	ld	s0,512(sp)
    80004b7c:	74fe                	ld	s1,504(sp)
    80004b7e:	795e                	ld	s2,496(sp)
    80004b80:	79be                	ld	s3,488(sp)
    80004b82:	7a1e                	ld	s4,480(sp)
    80004b84:	6afe                	ld	s5,472(sp)
    80004b86:	6b5e                	ld	s6,464(sp)
    80004b88:	6bbe                	ld	s7,456(sp)
    80004b8a:	6c1e                	ld	s8,448(sp)
    80004b8c:	7cfa                	ld	s9,440(sp)
    80004b8e:	7d5a                	ld	s10,432(sp)
    80004b90:	7dba                	ld	s11,424(sp)
    80004b92:	21010113          	add	sp,sp,528
    80004b96:	8082                	ret
    end_op();
    80004b98:	fffff097          	auipc	ra,0xfffff
    80004b9c:	472080e7          	jalr	1138(ra) # 8000400a <end_op>
    return -1;
    80004ba0:	557d                	li	a0,-1
    80004ba2:	bfc9                	j	80004b74 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004ba4:	8526                	mv	a0,s1
    80004ba6:	ffffd097          	auipc	ra,0xffffd
    80004baa:	ee4080e7          	jalr	-284(ra) # 80001a8a <proc_pagetable>
    80004bae:	8b2a                	mv	s6,a0
    80004bb0:	d945                	beqz	a0,80004b60 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004bb2:	e6842d03          	lw	s10,-408(s0)
    80004bb6:	e8045783          	lhu	a5,-384(s0)
    80004bba:	cfe5                	beqz	a5,80004cb2 <exec+0x1d6>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004bbc:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004bbe:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004bc0:	6c85                	lui	s9,0x1
    80004bc2:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004bc6:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004bca:	6a85                	lui	s5,0x1
    80004bcc:	a0b5                	j	80004c38 <exec+0x15c>
      panic("loadseg: address should exist");
    80004bce:	00004517          	auipc	a0,0x4
    80004bd2:	aea50513          	add	a0,a0,-1302 # 800086b8 <syscalls+0x290>
    80004bd6:	ffffc097          	auipc	ra,0xffffc
    80004bda:	96c080e7          	jalr	-1684(ra) # 80000542 <panic>
    if(sz - i < PGSIZE)
    80004bde:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004be0:	8726                	mv	a4,s1
    80004be2:	012c06bb          	addw	a3,s8,s2
    80004be6:	4581                	li	a1,0
    80004be8:	8552                	mv	a0,s4
    80004bea:	fffff097          	auipc	ra,0xfffff
    80004bee:	cba080e7          	jalr	-838(ra) # 800038a4 <readi>
    80004bf2:	2501                	sext.w	a0,a0
    80004bf4:	24a49063          	bne	s1,a0,80004e34 <exec+0x358>
  for(i = 0; i < sz; i += PGSIZE){
    80004bf8:	012a893b          	addw	s2,s5,s2
    80004bfc:	03397563          	bgeu	s2,s3,80004c26 <exec+0x14a>
    pa = walkaddr(pagetable, va + i);
    80004c00:	02091593          	sll	a1,s2,0x20
    80004c04:	9181                	srl	a1,a1,0x20
    80004c06:	95de                	add	a1,a1,s7
    80004c08:	855a                	mv	a0,s6
    80004c0a:	ffffc097          	auipc	ra,0xffffc
    80004c0e:	47a080e7          	jalr	1146(ra) # 80001084 <walkaddr>
    80004c12:	862a                	mv	a2,a0
    if(pa == 0)
    80004c14:	dd4d                	beqz	a0,80004bce <exec+0xf2>
    if(sz - i < PGSIZE)
    80004c16:	412984bb          	subw	s1,s3,s2
    80004c1a:	0004879b          	sext.w	a5,s1
    80004c1e:	fcfcf0e3          	bgeu	s9,a5,80004bde <exec+0x102>
    80004c22:	84d6                	mv	s1,s5
    80004c24:	bf6d                	j	80004bde <exec+0x102>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004c26:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004c2a:	2d85                	addw	s11,s11,1
    80004c2c:	038d0d1b          	addw	s10,s10,56
    80004c30:	e8045783          	lhu	a5,-384(s0)
    80004c34:	08fdd063          	bge	s11,a5,80004cb4 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004c38:	2d01                	sext.w	s10,s10
    80004c3a:	03800713          	li	a4,56
    80004c3e:	86ea                	mv	a3,s10
    80004c40:	e1040613          	add	a2,s0,-496
    80004c44:	4581                	li	a1,0
    80004c46:	8552                	mv	a0,s4
    80004c48:	fffff097          	auipc	ra,0xfffff
    80004c4c:	c5c080e7          	jalr	-932(ra) # 800038a4 <readi>
    80004c50:	03800793          	li	a5,56
    80004c54:	1cf51e63          	bne	a0,a5,80004e30 <exec+0x354>
    if(ph.type != ELF_PROG_LOAD)
    80004c58:	e1042783          	lw	a5,-496(s0)
    80004c5c:	4705                	li	a4,1
    80004c5e:	fce796e3          	bne	a5,a4,80004c2a <exec+0x14e>
    if(ph.memsz < ph.filesz)
    80004c62:	e3843603          	ld	a2,-456(s0)
    80004c66:	e3043783          	ld	a5,-464(s0)
    80004c6a:	1ef66063          	bltu	a2,a5,80004e4a <exec+0x36e>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004c6e:	e2043783          	ld	a5,-480(s0)
    80004c72:	963e                	add	a2,a2,a5
    80004c74:	1cf66e63          	bltu	a2,a5,80004e50 <exec+0x374>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004c78:	85a6                	mv	a1,s1
    80004c7a:	855a                	mv	a0,s6
    80004c7c:	ffffc097          	auipc	ra,0xffffc
    80004c80:	7ec080e7          	jalr	2028(ra) # 80001468 <uvmalloc>
    80004c84:	e0a43423          	sd	a0,-504(s0)
    80004c88:	1c050763          	beqz	a0,80004e56 <exec+0x37a>
    if(ph.vaddr % PGSIZE != 0)
    80004c8c:	e2043b83          	ld	s7,-480(s0)
    80004c90:	df043783          	ld	a5,-528(s0)
    80004c94:	00fbf7b3          	and	a5,s7,a5
    80004c98:	18079e63          	bnez	a5,80004e34 <exec+0x358>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004c9c:	e1842c03          	lw	s8,-488(s0)
    80004ca0:	e3042983          	lw	s3,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004ca4:	00098463          	beqz	s3,80004cac <exec+0x1d0>
    80004ca8:	4901                	li	s2,0
    80004caa:	bf99                	j	80004c00 <exec+0x124>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004cac:	e0843483          	ld	s1,-504(s0)
    80004cb0:	bfad                	j	80004c2a <exec+0x14e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004cb2:	4481                	li	s1,0
  iunlockput(ip);
    80004cb4:	8552                	mv	a0,s4
    80004cb6:	fffff097          	auipc	ra,0xfffff
    80004cba:	b9c080e7          	jalr	-1124(ra) # 80003852 <iunlockput>
  end_op();
    80004cbe:	fffff097          	auipc	ra,0xfffff
    80004cc2:	34c080e7          	jalr	844(ra) # 8000400a <end_op>
  p = myproc();
    80004cc6:	ffffd097          	auipc	ra,0xffffd
    80004cca:	d00080e7          	jalr	-768(ra) # 800019c6 <myproc>
    80004cce:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004cd0:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004cd4:	6985                	lui	s3,0x1
    80004cd6:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004cd8:	99a6                	add	s3,s3,s1
    80004cda:	77fd                	lui	a5,0xfffff
    80004cdc:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004ce0:	6609                	lui	a2,0x2
    80004ce2:	964e                	add	a2,a2,s3
    80004ce4:	85ce                	mv	a1,s3
    80004ce6:	855a                	mv	a0,s6
    80004ce8:	ffffc097          	auipc	ra,0xffffc
    80004cec:	780080e7          	jalr	1920(ra) # 80001468 <uvmalloc>
    80004cf0:	892a                	mv	s2,a0
    80004cf2:	e0a43423          	sd	a0,-504(s0)
    80004cf6:	e509                	bnez	a0,80004d00 <exec+0x224>
  if(pagetable)
    80004cf8:	e1343423          	sd	s3,-504(s0)
    80004cfc:	4a01                	li	s4,0
    80004cfe:	aa1d                	j	80004e34 <exec+0x358>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004d00:	75f9                	lui	a1,0xffffe
    80004d02:	95aa                	add	a1,a1,a0
    80004d04:	855a                	mv	a0,s6
    80004d06:	ffffd097          	auipc	ra,0xffffd
    80004d0a:	984080e7          	jalr	-1660(ra) # 8000168a <uvmclear>
  stackbase = sp - PGSIZE;
    80004d0e:	7bfd                	lui	s7,0xfffff
    80004d10:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004d12:	e0043783          	ld	a5,-512(s0)
    80004d16:	6388                	ld	a0,0(a5)
    80004d18:	c52d                	beqz	a0,80004d82 <exec+0x2a6>
    80004d1a:	e8840993          	add	s3,s0,-376
    80004d1e:	f8840c13          	add	s8,s0,-120
    80004d22:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004d24:	ffffc097          	auipc	ra,0xffffc
    80004d28:	156080e7          	jalr	342(ra) # 80000e7a <strlen>
    80004d2c:	0015079b          	addw	a5,a0,1
    80004d30:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004d34:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80004d38:	13796263          	bltu	s2,s7,80004e5c <exec+0x380>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004d3c:	e0043d03          	ld	s10,-512(s0)
    80004d40:	000d3a03          	ld	s4,0(s10)
    80004d44:	8552                	mv	a0,s4
    80004d46:	ffffc097          	auipc	ra,0xffffc
    80004d4a:	134080e7          	jalr	308(ra) # 80000e7a <strlen>
    80004d4e:	0015069b          	addw	a3,a0,1
    80004d52:	8652                	mv	a2,s4
    80004d54:	85ca                	mv	a1,s2
    80004d56:	855a                	mv	a0,s6
    80004d58:	ffffd097          	auipc	ra,0xffffd
    80004d5c:	964080e7          	jalr	-1692(ra) # 800016bc <copyout>
    80004d60:	10054063          	bltz	a0,80004e60 <exec+0x384>
    ustack[argc] = sp;
    80004d64:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004d68:	0485                	add	s1,s1,1
    80004d6a:	008d0793          	add	a5,s10,8
    80004d6e:	e0f43023          	sd	a5,-512(s0)
    80004d72:	008d3503          	ld	a0,8(s10)
    80004d76:	c909                	beqz	a0,80004d88 <exec+0x2ac>
    if(argc >= MAXARG)
    80004d78:	09a1                	add	s3,s3,8
    80004d7a:	fb8995e3          	bne	s3,s8,80004d24 <exec+0x248>
  ip = 0;
    80004d7e:	4a01                	li	s4,0
    80004d80:	a855                	j	80004e34 <exec+0x358>
  sp = sz;
    80004d82:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004d86:	4481                	li	s1,0
  ustack[argc] = 0;
    80004d88:	00349793          	sll	a5,s1,0x3
    80004d8c:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd8f90>
    80004d90:	97a2                	add	a5,a5,s0
    80004d92:	ee07bc23          	sd	zero,-264(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004d96:	00148693          	add	a3,s1,1
    80004d9a:	068e                	sll	a3,a3,0x3
    80004d9c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004da0:	ff097913          	and	s2,s2,-16
  sz = sz1;
    80004da4:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004da8:	f57968e3          	bltu	s2,s7,80004cf8 <exec+0x21c>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004dac:	e8840613          	add	a2,s0,-376
    80004db0:	85ca                	mv	a1,s2
    80004db2:	855a                	mv	a0,s6
    80004db4:	ffffd097          	auipc	ra,0xffffd
    80004db8:	908080e7          	jalr	-1784(ra) # 800016bc <copyout>
    80004dbc:	0a054463          	bltz	a0,80004e64 <exec+0x388>
  p->trapframe->a1 = sp;
    80004dc0:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004dc4:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004dc8:	df843783          	ld	a5,-520(s0)
    80004dcc:	0007c703          	lbu	a4,0(a5)
    80004dd0:	cf11                	beqz	a4,80004dec <exec+0x310>
    80004dd2:	0785                	add	a5,a5,1
    if(*s == '/')
    80004dd4:	02f00693          	li	a3,47
    80004dd8:	a039                	j	80004de6 <exec+0x30a>
      last = s+1;
    80004dda:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004dde:	0785                	add	a5,a5,1
    80004de0:	fff7c703          	lbu	a4,-1(a5)
    80004de4:	c701                	beqz	a4,80004dec <exec+0x310>
    if(*s == '/')
    80004de6:	fed71ce3          	bne	a4,a3,80004dde <exec+0x302>
    80004dea:	bfc5                	j	80004dda <exec+0x2fe>
  safestrcpy(p->name, last, sizeof(p->name));
    80004dec:	4641                	li	a2,16
    80004dee:	df843583          	ld	a1,-520(s0)
    80004df2:	158a8513          	add	a0,s5,344
    80004df6:	ffffc097          	auipc	ra,0xffffc
    80004dfa:	052080e7          	jalr	82(ra) # 80000e48 <safestrcpy>
  oldpagetable = p->pagetable;
    80004dfe:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004e02:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004e06:	e0843783          	ld	a5,-504(s0)
    80004e0a:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004e0e:	058ab783          	ld	a5,88(s5)
    80004e12:	e6043703          	ld	a4,-416(s0)
    80004e16:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004e18:	058ab783          	ld	a5,88(s5)
    80004e1c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004e20:	85e6                	mv	a1,s9
    80004e22:	ffffd097          	auipc	ra,0xffffd
    80004e26:	d04080e7          	jalr	-764(ra) # 80001b26 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004e2a:	0004851b          	sext.w	a0,s1
    80004e2e:	b399                	j	80004b74 <exec+0x98>
    80004e30:	e0943423          	sd	s1,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004e34:	e0843583          	ld	a1,-504(s0)
    80004e38:	855a                	mv	a0,s6
    80004e3a:	ffffd097          	auipc	ra,0xffffd
    80004e3e:	cec080e7          	jalr	-788(ra) # 80001b26 <proc_freepagetable>
  return -1;
    80004e42:	557d                	li	a0,-1
  if(ip){
    80004e44:	d20a08e3          	beqz	s4,80004b74 <exec+0x98>
    80004e48:	bb21                	j	80004b60 <exec+0x84>
    80004e4a:	e0943423          	sd	s1,-504(s0)
    80004e4e:	b7dd                	j	80004e34 <exec+0x358>
    80004e50:	e0943423          	sd	s1,-504(s0)
    80004e54:	b7c5                	j	80004e34 <exec+0x358>
    80004e56:	e0943423          	sd	s1,-504(s0)
    80004e5a:	bfe9                	j	80004e34 <exec+0x358>
  ip = 0;
    80004e5c:	4a01                	li	s4,0
    80004e5e:	bfd9                	j	80004e34 <exec+0x358>
    80004e60:	4a01                	li	s4,0
  if(pagetable)
    80004e62:	bfc9                	j	80004e34 <exec+0x358>
  sz = sz1;
    80004e64:	e0843983          	ld	s3,-504(s0)
    80004e68:	bd41                	j	80004cf8 <exec+0x21c>

0000000080004e6a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004e6a:	7179                	add	sp,sp,-48
    80004e6c:	f406                	sd	ra,40(sp)
    80004e6e:	f022                	sd	s0,32(sp)
    80004e70:	ec26                	sd	s1,24(sp)
    80004e72:	e84a                	sd	s2,16(sp)
    80004e74:	1800                	add	s0,sp,48
    80004e76:	892e                	mv	s2,a1
    80004e78:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004e7a:	fdc40593          	add	a1,s0,-36
    80004e7e:	ffffe097          	auipc	ra,0xffffe
    80004e82:	c08080e7          	jalr	-1016(ra) # 80002a86 <argint>
    80004e86:	04054063          	bltz	a0,80004ec6 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004e8a:	fdc42703          	lw	a4,-36(s0)
    80004e8e:	47bd                	li	a5,15
    80004e90:	02e7ed63          	bltu	a5,a4,80004eca <argfd+0x60>
    80004e94:	ffffd097          	auipc	ra,0xffffd
    80004e98:	b32080e7          	jalr	-1230(ra) # 800019c6 <myproc>
    80004e9c:	fdc42703          	lw	a4,-36(s0)
    80004ea0:	01a70793          	add	a5,a4,26
    80004ea4:	078e                	sll	a5,a5,0x3
    80004ea6:	953e                	add	a0,a0,a5
    80004ea8:	611c                	ld	a5,0(a0)
    80004eaa:	c395                	beqz	a5,80004ece <argfd+0x64>
    return -1;
  if(pfd)
    80004eac:	00090463          	beqz	s2,80004eb4 <argfd+0x4a>
    *pfd = fd;
    80004eb0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004eb4:	4501                	li	a0,0
  if(pf)
    80004eb6:	c091                	beqz	s1,80004eba <argfd+0x50>
    *pf = f;
    80004eb8:	e09c                	sd	a5,0(s1)
}
    80004eba:	70a2                	ld	ra,40(sp)
    80004ebc:	7402                	ld	s0,32(sp)
    80004ebe:	64e2                	ld	s1,24(sp)
    80004ec0:	6942                	ld	s2,16(sp)
    80004ec2:	6145                	add	sp,sp,48
    80004ec4:	8082                	ret
    return -1;
    80004ec6:	557d                	li	a0,-1
    80004ec8:	bfcd                	j	80004eba <argfd+0x50>
    return -1;
    80004eca:	557d                	li	a0,-1
    80004ecc:	b7fd                	j	80004eba <argfd+0x50>
    80004ece:	557d                	li	a0,-1
    80004ed0:	b7ed                	j	80004eba <argfd+0x50>

0000000080004ed2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004ed2:	1101                	add	sp,sp,-32
    80004ed4:	ec06                	sd	ra,24(sp)
    80004ed6:	e822                	sd	s0,16(sp)
    80004ed8:	e426                	sd	s1,8(sp)
    80004eda:	1000                	add	s0,sp,32
    80004edc:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004ede:	ffffd097          	auipc	ra,0xffffd
    80004ee2:	ae8080e7          	jalr	-1304(ra) # 800019c6 <myproc>
    80004ee6:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004ee8:	0d050793          	add	a5,a0,208
    80004eec:	4501                	li	a0,0
    80004eee:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004ef0:	6398                	ld	a4,0(a5)
    80004ef2:	cb19                	beqz	a4,80004f08 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004ef4:	2505                	addw	a0,a0,1
    80004ef6:	07a1                	add	a5,a5,8
    80004ef8:	fed51ce3          	bne	a0,a3,80004ef0 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004efc:	557d                	li	a0,-1
}
    80004efe:	60e2                	ld	ra,24(sp)
    80004f00:	6442                	ld	s0,16(sp)
    80004f02:	64a2                	ld	s1,8(sp)
    80004f04:	6105                	add	sp,sp,32
    80004f06:	8082                	ret
      p->ofile[fd] = f;
    80004f08:	01a50793          	add	a5,a0,26
    80004f0c:	078e                	sll	a5,a5,0x3
    80004f0e:	963e                	add	a2,a2,a5
    80004f10:	e204                	sd	s1,0(a2)
      return fd;
    80004f12:	b7f5                	j	80004efe <fdalloc+0x2c>

0000000080004f14 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004f14:	715d                	add	sp,sp,-80
    80004f16:	e486                	sd	ra,72(sp)
    80004f18:	e0a2                	sd	s0,64(sp)
    80004f1a:	fc26                	sd	s1,56(sp)
    80004f1c:	f84a                	sd	s2,48(sp)
    80004f1e:	f44e                	sd	s3,40(sp)
    80004f20:	f052                	sd	s4,32(sp)
    80004f22:	ec56                	sd	s5,24(sp)
    80004f24:	0880                	add	s0,sp,80
    80004f26:	8aae                	mv	s5,a1
    80004f28:	8a32                	mv	s4,a2
    80004f2a:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004f2c:	fb040593          	add	a1,s0,-80
    80004f30:	fffff097          	auipc	ra,0xfffff
    80004f34:	e8e080e7          	jalr	-370(ra) # 80003dbe <nameiparent>
    80004f38:	892a                	mv	s2,a0
    80004f3a:	12050c63          	beqz	a0,80005072 <create+0x15e>
    return 0;

  ilock(dp);
    80004f3e:	ffffe097          	auipc	ra,0xffffe
    80004f42:	6b2080e7          	jalr	1714(ra) # 800035f0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004f46:	4601                	li	a2,0
    80004f48:	fb040593          	add	a1,s0,-80
    80004f4c:	854a                	mv	a0,s2
    80004f4e:	fffff097          	auipc	ra,0xfffff
    80004f52:	b80080e7          	jalr	-1152(ra) # 80003ace <dirlookup>
    80004f56:	84aa                	mv	s1,a0
    80004f58:	c539                	beqz	a0,80004fa6 <create+0x92>
    iunlockput(dp);
    80004f5a:	854a                	mv	a0,s2
    80004f5c:	fffff097          	auipc	ra,0xfffff
    80004f60:	8f6080e7          	jalr	-1802(ra) # 80003852 <iunlockput>
    ilock(ip);
    80004f64:	8526                	mv	a0,s1
    80004f66:	ffffe097          	auipc	ra,0xffffe
    80004f6a:	68a080e7          	jalr	1674(ra) # 800035f0 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004f6e:	4789                	li	a5,2
    80004f70:	02fa9463          	bne	s5,a5,80004f98 <create+0x84>
    80004f74:	0444d783          	lhu	a5,68(s1)
    80004f78:	37f9                	addw	a5,a5,-2
    80004f7a:	17c2                	sll	a5,a5,0x30
    80004f7c:	93c1                	srl	a5,a5,0x30
    80004f7e:	4705                	li	a4,1
    80004f80:	00f76c63          	bltu	a4,a5,80004f98 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004f84:	8526                	mv	a0,s1
    80004f86:	60a6                	ld	ra,72(sp)
    80004f88:	6406                	ld	s0,64(sp)
    80004f8a:	74e2                	ld	s1,56(sp)
    80004f8c:	7942                	ld	s2,48(sp)
    80004f8e:	79a2                	ld	s3,40(sp)
    80004f90:	7a02                	ld	s4,32(sp)
    80004f92:	6ae2                	ld	s5,24(sp)
    80004f94:	6161                	add	sp,sp,80
    80004f96:	8082                	ret
    iunlockput(ip);
    80004f98:	8526                	mv	a0,s1
    80004f9a:	fffff097          	auipc	ra,0xfffff
    80004f9e:	8b8080e7          	jalr	-1864(ra) # 80003852 <iunlockput>
    return 0;
    80004fa2:	4481                	li	s1,0
    80004fa4:	b7c5                	j	80004f84 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004fa6:	85d6                	mv	a1,s5
    80004fa8:	00092503          	lw	a0,0(s2)
    80004fac:	ffffe097          	auipc	ra,0xffffe
    80004fb0:	4b0080e7          	jalr	1200(ra) # 8000345c <ialloc>
    80004fb4:	84aa                	mv	s1,a0
    80004fb6:	c139                	beqz	a0,80004ffc <create+0xe8>
  ilock(ip);
    80004fb8:	ffffe097          	auipc	ra,0xffffe
    80004fbc:	638080e7          	jalr	1592(ra) # 800035f0 <ilock>
  ip->major = major;
    80004fc0:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    80004fc4:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    80004fc8:	4985                	li	s3,1
    80004fca:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    80004fce:	8526                	mv	a0,s1
    80004fd0:	ffffe097          	auipc	ra,0xffffe
    80004fd4:	554080e7          	jalr	1364(ra) # 80003524 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004fd8:	033a8a63          	beq	s5,s3,8000500c <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    80004fdc:	40d0                	lw	a2,4(s1)
    80004fde:	fb040593          	add	a1,s0,-80
    80004fe2:	854a                	mv	a0,s2
    80004fe4:	fffff097          	auipc	ra,0xfffff
    80004fe8:	cfa080e7          	jalr	-774(ra) # 80003cde <dirlink>
    80004fec:	06054b63          	bltz	a0,80005062 <create+0x14e>
  iunlockput(dp);
    80004ff0:	854a                	mv	a0,s2
    80004ff2:	fffff097          	auipc	ra,0xfffff
    80004ff6:	860080e7          	jalr	-1952(ra) # 80003852 <iunlockput>
  return ip;
    80004ffa:	b769                	j	80004f84 <create+0x70>
    panic("create: ialloc");
    80004ffc:	00003517          	auipc	a0,0x3
    80005000:	6dc50513          	add	a0,a0,1756 # 800086d8 <syscalls+0x2b0>
    80005004:	ffffb097          	auipc	ra,0xffffb
    80005008:	53e080e7          	jalr	1342(ra) # 80000542 <panic>
    dp->nlink++;  // for ".."
    8000500c:	04a95783          	lhu	a5,74(s2)
    80005010:	2785                	addw	a5,a5,1
    80005012:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005016:	854a                	mv	a0,s2
    80005018:	ffffe097          	auipc	ra,0xffffe
    8000501c:	50c080e7          	jalr	1292(ra) # 80003524 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005020:	40d0                	lw	a2,4(s1)
    80005022:	00003597          	auipc	a1,0x3
    80005026:	6c658593          	add	a1,a1,1734 # 800086e8 <syscalls+0x2c0>
    8000502a:	8526                	mv	a0,s1
    8000502c:	fffff097          	auipc	ra,0xfffff
    80005030:	cb2080e7          	jalr	-846(ra) # 80003cde <dirlink>
    80005034:	00054f63          	bltz	a0,80005052 <create+0x13e>
    80005038:	00492603          	lw	a2,4(s2)
    8000503c:	00003597          	auipc	a1,0x3
    80005040:	6b458593          	add	a1,a1,1716 # 800086f0 <syscalls+0x2c8>
    80005044:	8526                	mv	a0,s1
    80005046:	fffff097          	auipc	ra,0xfffff
    8000504a:	c98080e7          	jalr	-872(ra) # 80003cde <dirlink>
    8000504e:	f80557e3          	bgez	a0,80004fdc <create+0xc8>
      panic("create dots");
    80005052:	00003517          	auipc	a0,0x3
    80005056:	6a650513          	add	a0,a0,1702 # 800086f8 <syscalls+0x2d0>
    8000505a:	ffffb097          	auipc	ra,0xffffb
    8000505e:	4e8080e7          	jalr	1256(ra) # 80000542 <panic>
    panic("create: dirlink");
    80005062:	00003517          	auipc	a0,0x3
    80005066:	6a650513          	add	a0,a0,1702 # 80008708 <syscalls+0x2e0>
    8000506a:	ffffb097          	auipc	ra,0xffffb
    8000506e:	4d8080e7          	jalr	1240(ra) # 80000542 <panic>
    return 0;
    80005072:	84aa                	mv	s1,a0
    80005074:	bf01                	j	80004f84 <create+0x70>

0000000080005076 <sys_dup>:
{
    80005076:	7179                	add	sp,sp,-48
    80005078:	f406                	sd	ra,40(sp)
    8000507a:	f022                	sd	s0,32(sp)
    8000507c:	ec26                	sd	s1,24(sp)
    8000507e:	e84a                	sd	s2,16(sp)
    80005080:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005082:	fd840613          	add	a2,s0,-40
    80005086:	4581                	li	a1,0
    80005088:	4501                	li	a0,0
    8000508a:	00000097          	auipc	ra,0x0
    8000508e:	de0080e7          	jalr	-544(ra) # 80004e6a <argfd>
    return -1;
    80005092:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005094:	02054363          	bltz	a0,800050ba <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80005098:	fd843903          	ld	s2,-40(s0)
    8000509c:	854a                	mv	a0,s2
    8000509e:	00000097          	auipc	ra,0x0
    800050a2:	e34080e7          	jalr	-460(ra) # 80004ed2 <fdalloc>
    800050a6:	84aa                	mv	s1,a0
    return -1;
    800050a8:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800050aa:	00054863          	bltz	a0,800050ba <sys_dup+0x44>
  filedup(f);
    800050ae:	854a                	mv	a0,s2
    800050b0:	fffff097          	auipc	ra,0xfffff
    800050b4:	358080e7          	jalr	856(ra) # 80004408 <filedup>
  return fd;
    800050b8:	87a6                	mv	a5,s1
}
    800050ba:	853e                	mv	a0,a5
    800050bc:	70a2                	ld	ra,40(sp)
    800050be:	7402                	ld	s0,32(sp)
    800050c0:	64e2                	ld	s1,24(sp)
    800050c2:	6942                	ld	s2,16(sp)
    800050c4:	6145                	add	sp,sp,48
    800050c6:	8082                	ret

00000000800050c8 <sys_read>:
{
    800050c8:	7179                	add	sp,sp,-48
    800050ca:	f406                	sd	ra,40(sp)
    800050cc:	f022                	sd	s0,32(sp)
    800050ce:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800050d0:	fe840613          	add	a2,s0,-24
    800050d4:	4581                	li	a1,0
    800050d6:	4501                	li	a0,0
    800050d8:	00000097          	auipc	ra,0x0
    800050dc:	d92080e7          	jalr	-622(ra) # 80004e6a <argfd>
    return -1;
    800050e0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800050e2:	04054163          	bltz	a0,80005124 <sys_read+0x5c>
    800050e6:	fe440593          	add	a1,s0,-28
    800050ea:	4509                	li	a0,2
    800050ec:	ffffe097          	auipc	ra,0xffffe
    800050f0:	99a080e7          	jalr	-1638(ra) # 80002a86 <argint>
    return -1;
    800050f4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800050f6:	02054763          	bltz	a0,80005124 <sys_read+0x5c>
    800050fa:	fd840593          	add	a1,s0,-40
    800050fe:	4505                	li	a0,1
    80005100:	ffffe097          	auipc	ra,0xffffe
    80005104:	9a8080e7          	jalr	-1624(ra) # 80002aa8 <argaddr>
    return -1;
    80005108:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000510a:	00054d63          	bltz	a0,80005124 <sys_read+0x5c>
  return fileread(f, p, n);
    8000510e:	fe442603          	lw	a2,-28(s0)
    80005112:	fd843583          	ld	a1,-40(s0)
    80005116:	fe843503          	ld	a0,-24(s0)
    8000511a:	fffff097          	auipc	ra,0xfffff
    8000511e:	47a080e7          	jalr	1146(ra) # 80004594 <fileread>
    80005122:	87aa                	mv	a5,a0
}
    80005124:	853e                	mv	a0,a5
    80005126:	70a2                	ld	ra,40(sp)
    80005128:	7402                	ld	s0,32(sp)
    8000512a:	6145                	add	sp,sp,48
    8000512c:	8082                	ret

000000008000512e <sys_write>:
{
    8000512e:	7179                	add	sp,sp,-48
    80005130:	f406                	sd	ra,40(sp)
    80005132:	f022                	sd	s0,32(sp)
    80005134:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005136:	fe840613          	add	a2,s0,-24
    8000513a:	4581                	li	a1,0
    8000513c:	4501                	li	a0,0
    8000513e:	00000097          	auipc	ra,0x0
    80005142:	d2c080e7          	jalr	-724(ra) # 80004e6a <argfd>
    return -1;
    80005146:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005148:	04054163          	bltz	a0,8000518a <sys_write+0x5c>
    8000514c:	fe440593          	add	a1,s0,-28
    80005150:	4509                	li	a0,2
    80005152:	ffffe097          	auipc	ra,0xffffe
    80005156:	934080e7          	jalr	-1740(ra) # 80002a86 <argint>
    return -1;
    8000515a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000515c:	02054763          	bltz	a0,8000518a <sys_write+0x5c>
    80005160:	fd840593          	add	a1,s0,-40
    80005164:	4505                	li	a0,1
    80005166:	ffffe097          	auipc	ra,0xffffe
    8000516a:	942080e7          	jalr	-1726(ra) # 80002aa8 <argaddr>
    return -1;
    8000516e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005170:	00054d63          	bltz	a0,8000518a <sys_write+0x5c>
  return filewrite(f, p, n);
    80005174:	fe442603          	lw	a2,-28(s0)
    80005178:	fd843583          	ld	a1,-40(s0)
    8000517c:	fe843503          	ld	a0,-24(s0)
    80005180:	fffff097          	auipc	ra,0xfffff
    80005184:	4d6080e7          	jalr	1238(ra) # 80004656 <filewrite>
    80005188:	87aa                	mv	a5,a0
}
    8000518a:	853e                	mv	a0,a5
    8000518c:	70a2                	ld	ra,40(sp)
    8000518e:	7402                	ld	s0,32(sp)
    80005190:	6145                	add	sp,sp,48
    80005192:	8082                	ret

0000000080005194 <sys_close>:
{
    80005194:	1101                	add	sp,sp,-32
    80005196:	ec06                	sd	ra,24(sp)
    80005198:	e822                	sd	s0,16(sp)
    8000519a:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000519c:	fe040613          	add	a2,s0,-32
    800051a0:	fec40593          	add	a1,s0,-20
    800051a4:	4501                	li	a0,0
    800051a6:	00000097          	auipc	ra,0x0
    800051aa:	cc4080e7          	jalr	-828(ra) # 80004e6a <argfd>
    return -1;
    800051ae:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800051b0:	02054463          	bltz	a0,800051d8 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800051b4:	ffffd097          	auipc	ra,0xffffd
    800051b8:	812080e7          	jalr	-2030(ra) # 800019c6 <myproc>
    800051bc:	fec42783          	lw	a5,-20(s0)
    800051c0:	07e9                	add	a5,a5,26
    800051c2:	078e                	sll	a5,a5,0x3
    800051c4:	953e                	add	a0,a0,a5
    800051c6:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800051ca:	fe043503          	ld	a0,-32(s0)
    800051ce:	fffff097          	auipc	ra,0xfffff
    800051d2:	28c080e7          	jalr	652(ra) # 8000445a <fileclose>
  return 0;
    800051d6:	4781                	li	a5,0
}
    800051d8:	853e                	mv	a0,a5
    800051da:	60e2                	ld	ra,24(sp)
    800051dc:	6442                	ld	s0,16(sp)
    800051de:	6105                	add	sp,sp,32
    800051e0:	8082                	ret

00000000800051e2 <sys_fstat>:
{
    800051e2:	1101                	add	sp,sp,-32
    800051e4:	ec06                	sd	ra,24(sp)
    800051e6:	e822                	sd	s0,16(sp)
    800051e8:	1000                	add	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800051ea:	fe840613          	add	a2,s0,-24
    800051ee:	4581                	li	a1,0
    800051f0:	4501                	li	a0,0
    800051f2:	00000097          	auipc	ra,0x0
    800051f6:	c78080e7          	jalr	-904(ra) # 80004e6a <argfd>
    return -1;
    800051fa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800051fc:	02054563          	bltz	a0,80005226 <sys_fstat+0x44>
    80005200:	fe040593          	add	a1,s0,-32
    80005204:	4505                	li	a0,1
    80005206:	ffffe097          	auipc	ra,0xffffe
    8000520a:	8a2080e7          	jalr	-1886(ra) # 80002aa8 <argaddr>
    return -1;
    8000520e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005210:	00054b63          	bltz	a0,80005226 <sys_fstat+0x44>
  return filestat(f, st);
    80005214:	fe043583          	ld	a1,-32(s0)
    80005218:	fe843503          	ld	a0,-24(s0)
    8000521c:	fffff097          	auipc	ra,0xfffff
    80005220:	306080e7          	jalr	774(ra) # 80004522 <filestat>
    80005224:	87aa                	mv	a5,a0
}
    80005226:	853e                	mv	a0,a5
    80005228:	60e2                	ld	ra,24(sp)
    8000522a:	6442                	ld	s0,16(sp)
    8000522c:	6105                	add	sp,sp,32
    8000522e:	8082                	ret

0000000080005230 <sys_link>:
{
    80005230:	7169                	add	sp,sp,-304
    80005232:	f606                	sd	ra,296(sp)
    80005234:	f222                	sd	s0,288(sp)
    80005236:	ee26                	sd	s1,280(sp)
    80005238:	ea4a                	sd	s2,272(sp)
    8000523a:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000523c:	08000613          	li	a2,128
    80005240:	ed040593          	add	a1,s0,-304
    80005244:	4501                	li	a0,0
    80005246:	ffffe097          	auipc	ra,0xffffe
    8000524a:	884080e7          	jalr	-1916(ra) # 80002aca <argstr>
    return -1;
    8000524e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005250:	10054e63          	bltz	a0,8000536c <sys_link+0x13c>
    80005254:	08000613          	li	a2,128
    80005258:	f5040593          	add	a1,s0,-176
    8000525c:	4505                	li	a0,1
    8000525e:	ffffe097          	auipc	ra,0xffffe
    80005262:	86c080e7          	jalr	-1940(ra) # 80002aca <argstr>
    return -1;
    80005266:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005268:	10054263          	bltz	a0,8000536c <sys_link+0x13c>
  begin_op();
    8000526c:	fffff097          	auipc	ra,0xfffff
    80005270:	d24080e7          	jalr	-732(ra) # 80003f90 <begin_op>
  if((ip = namei(old)) == 0){
    80005274:	ed040513          	add	a0,s0,-304
    80005278:	fffff097          	auipc	ra,0xfffff
    8000527c:	b28080e7          	jalr	-1240(ra) # 80003da0 <namei>
    80005280:	84aa                	mv	s1,a0
    80005282:	c551                	beqz	a0,8000530e <sys_link+0xde>
  ilock(ip);
    80005284:	ffffe097          	auipc	ra,0xffffe
    80005288:	36c080e7          	jalr	876(ra) # 800035f0 <ilock>
  if(ip->type == T_DIR){
    8000528c:	04449703          	lh	a4,68(s1)
    80005290:	4785                	li	a5,1
    80005292:	08f70463          	beq	a4,a5,8000531a <sys_link+0xea>
  ip->nlink++;
    80005296:	04a4d783          	lhu	a5,74(s1)
    8000529a:	2785                	addw	a5,a5,1
    8000529c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800052a0:	8526                	mv	a0,s1
    800052a2:	ffffe097          	auipc	ra,0xffffe
    800052a6:	282080e7          	jalr	642(ra) # 80003524 <iupdate>
  iunlock(ip);
    800052aa:	8526                	mv	a0,s1
    800052ac:	ffffe097          	auipc	ra,0xffffe
    800052b0:	406080e7          	jalr	1030(ra) # 800036b2 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800052b4:	fd040593          	add	a1,s0,-48
    800052b8:	f5040513          	add	a0,s0,-176
    800052bc:	fffff097          	auipc	ra,0xfffff
    800052c0:	b02080e7          	jalr	-1278(ra) # 80003dbe <nameiparent>
    800052c4:	892a                	mv	s2,a0
    800052c6:	c935                	beqz	a0,8000533a <sys_link+0x10a>
  ilock(dp);
    800052c8:	ffffe097          	auipc	ra,0xffffe
    800052cc:	328080e7          	jalr	808(ra) # 800035f0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800052d0:	00092703          	lw	a4,0(s2)
    800052d4:	409c                	lw	a5,0(s1)
    800052d6:	04f71d63          	bne	a4,a5,80005330 <sys_link+0x100>
    800052da:	40d0                	lw	a2,4(s1)
    800052dc:	fd040593          	add	a1,s0,-48
    800052e0:	854a                	mv	a0,s2
    800052e2:	fffff097          	auipc	ra,0xfffff
    800052e6:	9fc080e7          	jalr	-1540(ra) # 80003cde <dirlink>
    800052ea:	04054363          	bltz	a0,80005330 <sys_link+0x100>
  iunlockput(dp);
    800052ee:	854a                	mv	a0,s2
    800052f0:	ffffe097          	auipc	ra,0xffffe
    800052f4:	562080e7          	jalr	1378(ra) # 80003852 <iunlockput>
  iput(ip);
    800052f8:	8526                	mv	a0,s1
    800052fa:	ffffe097          	auipc	ra,0xffffe
    800052fe:	4b0080e7          	jalr	1200(ra) # 800037aa <iput>
  end_op();
    80005302:	fffff097          	auipc	ra,0xfffff
    80005306:	d08080e7          	jalr	-760(ra) # 8000400a <end_op>
  return 0;
    8000530a:	4781                	li	a5,0
    8000530c:	a085                	j	8000536c <sys_link+0x13c>
    end_op();
    8000530e:	fffff097          	auipc	ra,0xfffff
    80005312:	cfc080e7          	jalr	-772(ra) # 8000400a <end_op>
    return -1;
    80005316:	57fd                	li	a5,-1
    80005318:	a891                	j	8000536c <sys_link+0x13c>
    iunlockput(ip);
    8000531a:	8526                	mv	a0,s1
    8000531c:	ffffe097          	auipc	ra,0xffffe
    80005320:	536080e7          	jalr	1334(ra) # 80003852 <iunlockput>
    end_op();
    80005324:	fffff097          	auipc	ra,0xfffff
    80005328:	ce6080e7          	jalr	-794(ra) # 8000400a <end_op>
    return -1;
    8000532c:	57fd                	li	a5,-1
    8000532e:	a83d                	j	8000536c <sys_link+0x13c>
    iunlockput(dp);
    80005330:	854a                	mv	a0,s2
    80005332:	ffffe097          	auipc	ra,0xffffe
    80005336:	520080e7          	jalr	1312(ra) # 80003852 <iunlockput>
  ilock(ip);
    8000533a:	8526                	mv	a0,s1
    8000533c:	ffffe097          	auipc	ra,0xffffe
    80005340:	2b4080e7          	jalr	692(ra) # 800035f0 <ilock>
  ip->nlink--;
    80005344:	04a4d783          	lhu	a5,74(s1)
    80005348:	37fd                	addw	a5,a5,-1
    8000534a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000534e:	8526                	mv	a0,s1
    80005350:	ffffe097          	auipc	ra,0xffffe
    80005354:	1d4080e7          	jalr	468(ra) # 80003524 <iupdate>
  iunlockput(ip);
    80005358:	8526                	mv	a0,s1
    8000535a:	ffffe097          	auipc	ra,0xffffe
    8000535e:	4f8080e7          	jalr	1272(ra) # 80003852 <iunlockput>
  end_op();
    80005362:	fffff097          	auipc	ra,0xfffff
    80005366:	ca8080e7          	jalr	-856(ra) # 8000400a <end_op>
  return -1;
    8000536a:	57fd                	li	a5,-1
}
    8000536c:	853e                	mv	a0,a5
    8000536e:	70b2                	ld	ra,296(sp)
    80005370:	7412                	ld	s0,288(sp)
    80005372:	64f2                	ld	s1,280(sp)
    80005374:	6952                	ld	s2,272(sp)
    80005376:	6155                	add	sp,sp,304
    80005378:	8082                	ret

000000008000537a <sys_unlink>:
{
    8000537a:	7151                	add	sp,sp,-240
    8000537c:	f586                	sd	ra,232(sp)
    8000537e:	f1a2                	sd	s0,224(sp)
    80005380:	eda6                	sd	s1,216(sp)
    80005382:	e9ca                	sd	s2,208(sp)
    80005384:	e5ce                	sd	s3,200(sp)
    80005386:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005388:	08000613          	li	a2,128
    8000538c:	f3040593          	add	a1,s0,-208
    80005390:	4501                	li	a0,0
    80005392:	ffffd097          	auipc	ra,0xffffd
    80005396:	738080e7          	jalr	1848(ra) # 80002aca <argstr>
    8000539a:	18054163          	bltz	a0,8000551c <sys_unlink+0x1a2>
  begin_op();
    8000539e:	fffff097          	auipc	ra,0xfffff
    800053a2:	bf2080e7          	jalr	-1038(ra) # 80003f90 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800053a6:	fb040593          	add	a1,s0,-80
    800053aa:	f3040513          	add	a0,s0,-208
    800053ae:	fffff097          	auipc	ra,0xfffff
    800053b2:	a10080e7          	jalr	-1520(ra) # 80003dbe <nameiparent>
    800053b6:	84aa                	mv	s1,a0
    800053b8:	c979                	beqz	a0,8000548e <sys_unlink+0x114>
  ilock(dp);
    800053ba:	ffffe097          	auipc	ra,0xffffe
    800053be:	236080e7          	jalr	566(ra) # 800035f0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800053c2:	00003597          	auipc	a1,0x3
    800053c6:	32658593          	add	a1,a1,806 # 800086e8 <syscalls+0x2c0>
    800053ca:	fb040513          	add	a0,s0,-80
    800053ce:	ffffe097          	auipc	ra,0xffffe
    800053d2:	6e6080e7          	jalr	1766(ra) # 80003ab4 <namecmp>
    800053d6:	14050a63          	beqz	a0,8000552a <sys_unlink+0x1b0>
    800053da:	00003597          	auipc	a1,0x3
    800053de:	31658593          	add	a1,a1,790 # 800086f0 <syscalls+0x2c8>
    800053e2:	fb040513          	add	a0,s0,-80
    800053e6:	ffffe097          	auipc	ra,0xffffe
    800053ea:	6ce080e7          	jalr	1742(ra) # 80003ab4 <namecmp>
    800053ee:	12050e63          	beqz	a0,8000552a <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800053f2:	f2c40613          	add	a2,s0,-212
    800053f6:	fb040593          	add	a1,s0,-80
    800053fa:	8526                	mv	a0,s1
    800053fc:	ffffe097          	auipc	ra,0xffffe
    80005400:	6d2080e7          	jalr	1746(ra) # 80003ace <dirlookup>
    80005404:	892a                	mv	s2,a0
    80005406:	12050263          	beqz	a0,8000552a <sys_unlink+0x1b0>
  ilock(ip);
    8000540a:	ffffe097          	auipc	ra,0xffffe
    8000540e:	1e6080e7          	jalr	486(ra) # 800035f0 <ilock>
  if(ip->nlink < 1)
    80005412:	04a91783          	lh	a5,74(s2)
    80005416:	08f05263          	blez	a5,8000549a <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000541a:	04491703          	lh	a4,68(s2)
    8000541e:	4785                	li	a5,1
    80005420:	08f70563          	beq	a4,a5,800054aa <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005424:	4641                	li	a2,16
    80005426:	4581                	li	a1,0
    80005428:	fc040513          	add	a0,s0,-64
    8000542c:	ffffc097          	auipc	ra,0xffffc
    80005430:	8cc080e7          	jalr	-1844(ra) # 80000cf8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005434:	4741                	li	a4,16
    80005436:	f2c42683          	lw	a3,-212(s0)
    8000543a:	fc040613          	add	a2,s0,-64
    8000543e:	4581                	li	a1,0
    80005440:	8526                	mv	a0,s1
    80005442:	ffffe097          	auipc	ra,0xffffe
    80005446:	558080e7          	jalr	1368(ra) # 8000399a <writei>
    8000544a:	47c1                	li	a5,16
    8000544c:	0af51563          	bne	a0,a5,800054f6 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005450:	04491703          	lh	a4,68(s2)
    80005454:	4785                	li	a5,1
    80005456:	0af70863          	beq	a4,a5,80005506 <sys_unlink+0x18c>
  iunlockput(dp);
    8000545a:	8526                	mv	a0,s1
    8000545c:	ffffe097          	auipc	ra,0xffffe
    80005460:	3f6080e7          	jalr	1014(ra) # 80003852 <iunlockput>
  ip->nlink--;
    80005464:	04a95783          	lhu	a5,74(s2)
    80005468:	37fd                	addw	a5,a5,-1
    8000546a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000546e:	854a                	mv	a0,s2
    80005470:	ffffe097          	auipc	ra,0xffffe
    80005474:	0b4080e7          	jalr	180(ra) # 80003524 <iupdate>
  iunlockput(ip);
    80005478:	854a                	mv	a0,s2
    8000547a:	ffffe097          	auipc	ra,0xffffe
    8000547e:	3d8080e7          	jalr	984(ra) # 80003852 <iunlockput>
  end_op();
    80005482:	fffff097          	auipc	ra,0xfffff
    80005486:	b88080e7          	jalr	-1144(ra) # 8000400a <end_op>
  return 0;
    8000548a:	4501                	li	a0,0
    8000548c:	a84d                	j	8000553e <sys_unlink+0x1c4>
    end_op();
    8000548e:	fffff097          	auipc	ra,0xfffff
    80005492:	b7c080e7          	jalr	-1156(ra) # 8000400a <end_op>
    return -1;
    80005496:	557d                	li	a0,-1
    80005498:	a05d                	j	8000553e <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    8000549a:	00003517          	auipc	a0,0x3
    8000549e:	27e50513          	add	a0,a0,638 # 80008718 <syscalls+0x2f0>
    800054a2:	ffffb097          	auipc	ra,0xffffb
    800054a6:	0a0080e7          	jalr	160(ra) # 80000542 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800054aa:	04c92703          	lw	a4,76(s2)
    800054ae:	02000793          	li	a5,32
    800054b2:	f6e7f9e3          	bgeu	a5,a4,80005424 <sys_unlink+0xaa>
    800054b6:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800054ba:	4741                	li	a4,16
    800054bc:	86ce                	mv	a3,s3
    800054be:	f1840613          	add	a2,s0,-232
    800054c2:	4581                	li	a1,0
    800054c4:	854a                	mv	a0,s2
    800054c6:	ffffe097          	auipc	ra,0xffffe
    800054ca:	3de080e7          	jalr	990(ra) # 800038a4 <readi>
    800054ce:	47c1                	li	a5,16
    800054d0:	00f51b63          	bne	a0,a5,800054e6 <sys_unlink+0x16c>
    if(de.inum != 0)
    800054d4:	f1845783          	lhu	a5,-232(s0)
    800054d8:	e7a1                	bnez	a5,80005520 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800054da:	29c1                	addw	s3,s3,16
    800054dc:	04c92783          	lw	a5,76(s2)
    800054e0:	fcf9ede3          	bltu	s3,a5,800054ba <sys_unlink+0x140>
    800054e4:	b781                	j	80005424 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800054e6:	00003517          	auipc	a0,0x3
    800054ea:	24a50513          	add	a0,a0,586 # 80008730 <syscalls+0x308>
    800054ee:	ffffb097          	auipc	ra,0xffffb
    800054f2:	054080e7          	jalr	84(ra) # 80000542 <panic>
    panic("unlink: writei");
    800054f6:	00003517          	auipc	a0,0x3
    800054fa:	25250513          	add	a0,a0,594 # 80008748 <syscalls+0x320>
    800054fe:	ffffb097          	auipc	ra,0xffffb
    80005502:	044080e7          	jalr	68(ra) # 80000542 <panic>
    dp->nlink--;
    80005506:	04a4d783          	lhu	a5,74(s1)
    8000550a:	37fd                	addw	a5,a5,-1
    8000550c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005510:	8526                	mv	a0,s1
    80005512:	ffffe097          	auipc	ra,0xffffe
    80005516:	012080e7          	jalr	18(ra) # 80003524 <iupdate>
    8000551a:	b781                	j	8000545a <sys_unlink+0xe0>
    return -1;
    8000551c:	557d                	li	a0,-1
    8000551e:	a005                	j	8000553e <sys_unlink+0x1c4>
    iunlockput(ip);
    80005520:	854a                	mv	a0,s2
    80005522:	ffffe097          	auipc	ra,0xffffe
    80005526:	330080e7          	jalr	816(ra) # 80003852 <iunlockput>
  iunlockput(dp);
    8000552a:	8526                	mv	a0,s1
    8000552c:	ffffe097          	auipc	ra,0xffffe
    80005530:	326080e7          	jalr	806(ra) # 80003852 <iunlockput>
  end_op();
    80005534:	fffff097          	auipc	ra,0xfffff
    80005538:	ad6080e7          	jalr	-1322(ra) # 8000400a <end_op>
  return -1;
    8000553c:	557d                	li	a0,-1
}
    8000553e:	70ae                	ld	ra,232(sp)
    80005540:	740e                	ld	s0,224(sp)
    80005542:	64ee                	ld	s1,216(sp)
    80005544:	694e                	ld	s2,208(sp)
    80005546:	69ae                	ld	s3,200(sp)
    80005548:	616d                	add	sp,sp,240
    8000554a:	8082                	ret

000000008000554c <sys_open>:

uint64
sys_open(void)
{
    8000554c:	7131                	add	sp,sp,-192
    8000554e:	fd06                	sd	ra,184(sp)
    80005550:	f922                	sd	s0,176(sp)
    80005552:	f526                	sd	s1,168(sp)
    80005554:	f14a                	sd	s2,160(sp)
    80005556:	ed4e                	sd	s3,152(sp)
    80005558:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000555a:	08000613          	li	a2,128
    8000555e:	f5040593          	add	a1,s0,-176
    80005562:	4501                	li	a0,0
    80005564:	ffffd097          	auipc	ra,0xffffd
    80005568:	566080e7          	jalr	1382(ra) # 80002aca <argstr>
    return -1;
    8000556c:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000556e:	0c054063          	bltz	a0,8000562e <sys_open+0xe2>
    80005572:	f4c40593          	add	a1,s0,-180
    80005576:	4505                	li	a0,1
    80005578:	ffffd097          	auipc	ra,0xffffd
    8000557c:	50e080e7          	jalr	1294(ra) # 80002a86 <argint>
    80005580:	0a054763          	bltz	a0,8000562e <sys_open+0xe2>

  begin_op();
    80005584:	fffff097          	auipc	ra,0xfffff
    80005588:	a0c080e7          	jalr	-1524(ra) # 80003f90 <begin_op>

  if(omode & O_CREATE){
    8000558c:	f4c42783          	lw	a5,-180(s0)
    80005590:	2007f793          	and	a5,a5,512
    80005594:	cbd5                	beqz	a5,80005648 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80005596:	4681                	li	a3,0
    80005598:	4601                	li	a2,0
    8000559a:	4589                	li	a1,2
    8000559c:	f5040513          	add	a0,s0,-176
    800055a0:	00000097          	auipc	ra,0x0
    800055a4:	974080e7          	jalr	-1676(ra) # 80004f14 <create>
    800055a8:	892a                	mv	s2,a0
    if(ip == 0){
    800055aa:	c951                	beqz	a0,8000563e <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800055ac:	04491703          	lh	a4,68(s2)
    800055b0:	478d                	li	a5,3
    800055b2:	00f71763          	bne	a4,a5,800055c0 <sys_open+0x74>
    800055b6:	04695703          	lhu	a4,70(s2)
    800055ba:	47a5                	li	a5,9
    800055bc:	0ce7eb63          	bltu	a5,a4,80005692 <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800055c0:	fffff097          	auipc	ra,0xfffff
    800055c4:	dde080e7          	jalr	-546(ra) # 8000439e <filealloc>
    800055c8:	89aa                	mv	s3,a0
    800055ca:	c565                	beqz	a0,800056b2 <sys_open+0x166>
    800055cc:	00000097          	auipc	ra,0x0
    800055d0:	906080e7          	jalr	-1786(ra) # 80004ed2 <fdalloc>
    800055d4:	84aa                	mv	s1,a0
    800055d6:	0c054963          	bltz	a0,800056a8 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800055da:	04491703          	lh	a4,68(s2)
    800055de:	478d                	li	a5,3
    800055e0:	0ef70463          	beq	a4,a5,800056c8 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800055e4:	4789                	li	a5,2
    800055e6:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    800055ea:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    800055ee:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    800055f2:	f4c42783          	lw	a5,-180(s0)
    800055f6:	0017c713          	xor	a4,a5,1
    800055fa:	8b05                	and	a4,a4,1
    800055fc:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005600:	0037f713          	and	a4,a5,3
    80005604:	00e03733          	snez	a4,a4
    80005608:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000560c:	4007f793          	and	a5,a5,1024
    80005610:	c791                	beqz	a5,8000561c <sys_open+0xd0>
    80005612:	04491703          	lh	a4,68(s2)
    80005616:	4789                	li	a5,2
    80005618:	0af70f63          	beq	a4,a5,800056d6 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    8000561c:	854a                	mv	a0,s2
    8000561e:	ffffe097          	auipc	ra,0xffffe
    80005622:	094080e7          	jalr	148(ra) # 800036b2 <iunlock>
  end_op();
    80005626:	fffff097          	auipc	ra,0xfffff
    8000562a:	9e4080e7          	jalr	-1564(ra) # 8000400a <end_op>

  return fd;
}
    8000562e:	8526                	mv	a0,s1
    80005630:	70ea                	ld	ra,184(sp)
    80005632:	744a                	ld	s0,176(sp)
    80005634:	74aa                	ld	s1,168(sp)
    80005636:	790a                	ld	s2,160(sp)
    80005638:	69ea                	ld	s3,152(sp)
    8000563a:	6129                	add	sp,sp,192
    8000563c:	8082                	ret
      end_op();
    8000563e:	fffff097          	auipc	ra,0xfffff
    80005642:	9cc080e7          	jalr	-1588(ra) # 8000400a <end_op>
      return -1;
    80005646:	b7e5                	j	8000562e <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80005648:	f5040513          	add	a0,s0,-176
    8000564c:	ffffe097          	auipc	ra,0xffffe
    80005650:	754080e7          	jalr	1876(ra) # 80003da0 <namei>
    80005654:	892a                	mv	s2,a0
    80005656:	c905                	beqz	a0,80005686 <sys_open+0x13a>
    ilock(ip);
    80005658:	ffffe097          	auipc	ra,0xffffe
    8000565c:	f98080e7          	jalr	-104(ra) # 800035f0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005660:	04491703          	lh	a4,68(s2)
    80005664:	4785                	li	a5,1
    80005666:	f4f713e3          	bne	a4,a5,800055ac <sys_open+0x60>
    8000566a:	f4c42783          	lw	a5,-180(s0)
    8000566e:	dba9                	beqz	a5,800055c0 <sys_open+0x74>
      iunlockput(ip);
    80005670:	854a                	mv	a0,s2
    80005672:	ffffe097          	auipc	ra,0xffffe
    80005676:	1e0080e7          	jalr	480(ra) # 80003852 <iunlockput>
      end_op();
    8000567a:	fffff097          	auipc	ra,0xfffff
    8000567e:	990080e7          	jalr	-1648(ra) # 8000400a <end_op>
      return -1;
    80005682:	54fd                	li	s1,-1
    80005684:	b76d                	j	8000562e <sys_open+0xe2>
      end_op();
    80005686:	fffff097          	auipc	ra,0xfffff
    8000568a:	984080e7          	jalr	-1660(ra) # 8000400a <end_op>
      return -1;
    8000568e:	54fd                	li	s1,-1
    80005690:	bf79                	j	8000562e <sys_open+0xe2>
    iunlockput(ip);
    80005692:	854a                	mv	a0,s2
    80005694:	ffffe097          	auipc	ra,0xffffe
    80005698:	1be080e7          	jalr	446(ra) # 80003852 <iunlockput>
    end_op();
    8000569c:	fffff097          	auipc	ra,0xfffff
    800056a0:	96e080e7          	jalr	-1682(ra) # 8000400a <end_op>
    return -1;
    800056a4:	54fd                	li	s1,-1
    800056a6:	b761                	j	8000562e <sys_open+0xe2>
      fileclose(f);
    800056a8:	854e                	mv	a0,s3
    800056aa:	fffff097          	auipc	ra,0xfffff
    800056ae:	db0080e7          	jalr	-592(ra) # 8000445a <fileclose>
    iunlockput(ip);
    800056b2:	854a                	mv	a0,s2
    800056b4:	ffffe097          	auipc	ra,0xffffe
    800056b8:	19e080e7          	jalr	414(ra) # 80003852 <iunlockput>
    end_op();
    800056bc:	fffff097          	auipc	ra,0xfffff
    800056c0:	94e080e7          	jalr	-1714(ra) # 8000400a <end_op>
    return -1;
    800056c4:	54fd                	li	s1,-1
    800056c6:	b7a5                	j	8000562e <sys_open+0xe2>
    f->type = FD_DEVICE;
    800056c8:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    800056cc:	04691783          	lh	a5,70(s2)
    800056d0:	02f99223          	sh	a5,36(s3)
    800056d4:	bf29                	j	800055ee <sys_open+0xa2>
    itrunc(ip);
    800056d6:	854a                	mv	a0,s2
    800056d8:	ffffe097          	auipc	ra,0xffffe
    800056dc:	026080e7          	jalr	38(ra) # 800036fe <itrunc>
    800056e0:	bf35                	j	8000561c <sys_open+0xd0>

00000000800056e2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800056e2:	7175                	add	sp,sp,-144
    800056e4:	e506                	sd	ra,136(sp)
    800056e6:	e122                	sd	s0,128(sp)
    800056e8:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800056ea:	fffff097          	auipc	ra,0xfffff
    800056ee:	8a6080e7          	jalr	-1882(ra) # 80003f90 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800056f2:	08000613          	li	a2,128
    800056f6:	f7040593          	add	a1,s0,-144
    800056fa:	4501                	li	a0,0
    800056fc:	ffffd097          	auipc	ra,0xffffd
    80005700:	3ce080e7          	jalr	974(ra) # 80002aca <argstr>
    80005704:	02054963          	bltz	a0,80005736 <sys_mkdir+0x54>
    80005708:	4681                	li	a3,0
    8000570a:	4601                	li	a2,0
    8000570c:	4585                	li	a1,1
    8000570e:	f7040513          	add	a0,s0,-144
    80005712:	00000097          	auipc	ra,0x0
    80005716:	802080e7          	jalr	-2046(ra) # 80004f14 <create>
    8000571a:	cd11                	beqz	a0,80005736 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000571c:	ffffe097          	auipc	ra,0xffffe
    80005720:	136080e7          	jalr	310(ra) # 80003852 <iunlockput>
  end_op();
    80005724:	fffff097          	auipc	ra,0xfffff
    80005728:	8e6080e7          	jalr	-1818(ra) # 8000400a <end_op>
  return 0;
    8000572c:	4501                	li	a0,0
}
    8000572e:	60aa                	ld	ra,136(sp)
    80005730:	640a                	ld	s0,128(sp)
    80005732:	6149                	add	sp,sp,144
    80005734:	8082                	ret
    end_op();
    80005736:	fffff097          	auipc	ra,0xfffff
    8000573a:	8d4080e7          	jalr	-1836(ra) # 8000400a <end_op>
    return -1;
    8000573e:	557d                	li	a0,-1
    80005740:	b7fd                	j	8000572e <sys_mkdir+0x4c>

0000000080005742 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005742:	7135                	add	sp,sp,-160
    80005744:	ed06                	sd	ra,152(sp)
    80005746:	e922                	sd	s0,144(sp)
    80005748:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000574a:	fffff097          	auipc	ra,0xfffff
    8000574e:	846080e7          	jalr	-1978(ra) # 80003f90 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005752:	08000613          	li	a2,128
    80005756:	f7040593          	add	a1,s0,-144
    8000575a:	4501                	li	a0,0
    8000575c:	ffffd097          	auipc	ra,0xffffd
    80005760:	36e080e7          	jalr	878(ra) # 80002aca <argstr>
    80005764:	04054a63          	bltz	a0,800057b8 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005768:	f6c40593          	add	a1,s0,-148
    8000576c:	4505                	li	a0,1
    8000576e:	ffffd097          	auipc	ra,0xffffd
    80005772:	318080e7          	jalr	792(ra) # 80002a86 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005776:	04054163          	bltz	a0,800057b8 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    8000577a:	f6840593          	add	a1,s0,-152
    8000577e:	4509                	li	a0,2
    80005780:	ffffd097          	auipc	ra,0xffffd
    80005784:	306080e7          	jalr	774(ra) # 80002a86 <argint>
     argint(1, &major) < 0 ||
    80005788:	02054863          	bltz	a0,800057b8 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000578c:	f6841683          	lh	a3,-152(s0)
    80005790:	f6c41603          	lh	a2,-148(s0)
    80005794:	458d                	li	a1,3
    80005796:	f7040513          	add	a0,s0,-144
    8000579a:	fffff097          	auipc	ra,0xfffff
    8000579e:	77a080e7          	jalr	1914(ra) # 80004f14 <create>
     argint(2, &minor) < 0 ||
    800057a2:	c919                	beqz	a0,800057b8 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800057a4:	ffffe097          	auipc	ra,0xffffe
    800057a8:	0ae080e7          	jalr	174(ra) # 80003852 <iunlockput>
  end_op();
    800057ac:	fffff097          	auipc	ra,0xfffff
    800057b0:	85e080e7          	jalr	-1954(ra) # 8000400a <end_op>
  return 0;
    800057b4:	4501                	li	a0,0
    800057b6:	a031                	j	800057c2 <sys_mknod+0x80>
    end_op();
    800057b8:	fffff097          	auipc	ra,0xfffff
    800057bc:	852080e7          	jalr	-1966(ra) # 8000400a <end_op>
    return -1;
    800057c0:	557d                	li	a0,-1
}
    800057c2:	60ea                	ld	ra,152(sp)
    800057c4:	644a                	ld	s0,144(sp)
    800057c6:	610d                	add	sp,sp,160
    800057c8:	8082                	ret

00000000800057ca <sys_chdir>:

uint64
sys_chdir(void)
{
    800057ca:	7135                	add	sp,sp,-160
    800057cc:	ed06                	sd	ra,152(sp)
    800057ce:	e922                	sd	s0,144(sp)
    800057d0:	e526                	sd	s1,136(sp)
    800057d2:	e14a                	sd	s2,128(sp)
    800057d4:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800057d6:	ffffc097          	auipc	ra,0xffffc
    800057da:	1f0080e7          	jalr	496(ra) # 800019c6 <myproc>
    800057de:	892a                	mv	s2,a0
  
  begin_op();
    800057e0:	ffffe097          	auipc	ra,0xffffe
    800057e4:	7b0080e7          	jalr	1968(ra) # 80003f90 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800057e8:	08000613          	li	a2,128
    800057ec:	f6040593          	add	a1,s0,-160
    800057f0:	4501                	li	a0,0
    800057f2:	ffffd097          	auipc	ra,0xffffd
    800057f6:	2d8080e7          	jalr	728(ra) # 80002aca <argstr>
    800057fa:	04054b63          	bltz	a0,80005850 <sys_chdir+0x86>
    800057fe:	f6040513          	add	a0,s0,-160
    80005802:	ffffe097          	auipc	ra,0xffffe
    80005806:	59e080e7          	jalr	1438(ra) # 80003da0 <namei>
    8000580a:	84aa                	mv	s1,a0
    8000580c:	c131                	beqz	a0,80005850 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000580e:	ffffe097          	auipc	ra,0xffffe
    80005812:	de2080e7          	jalr	-542(ra) # 800035f0 <ilock>
  if(ip->type != T_DIR){
    80005816:	04449703          	lh	a4,68(s1)
    8000581a:	4785                	li	a5,1
    8000581c:	04f71063          	bne	a4,a5,8000585c <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005820:	8526                	mv	a0,s1
    80005822:	ffffe097          	auipc	ra,0xffffe
    80005826:	e90080e7          	jalr	-368(ra) # 800036b2 <iunlock>
  iput(p->cwd);
    8000582a:	15093503          	ld	a0,336(s2)
    8000582e:	ffffe097          	auipc	ra,0xffffe
    80005832:	f7c080e7          	jalr	-132(ra) # 800037aa <iput>
  end_op();
    80005836:	ffffe097          	auipc	ra,0xffffe
    8000583a:	7d4080e7          	jalr	2004(ra) # 8000400a <end_op>
  p->cwd = ip;
    8000583e:	14993823          	sd	s1,336(s2)
  return 0;
    80005842:	4501                	li	a0,0
}
    80005844:	60ea                	ld	ra,152(sp)
    80005846:	644a                	ld	s0,144(sp)
    80005848:	64aa                	ld	s1,136(sp)
    8000584a:	690a                	ld	s2,128(sp)
    8000584c:	610d                	add	sp,sp,160
    8000584e:	8082                	ret
    end_op();
    80005850:	ffffe097          	auipc	ra,0xffffe
    80005854:	7ba080e7          	jalr	1978(ra) # 8000400a <end_op>
    return -1;
    80005858:	557d                	li	a0,-1
    8000585a:	b7ed                	j	80005844 <sys_chdir+0x7a>
    iunlockput(ip);
    8000585c:	8526                	mv	a0,s1
    8000585e:	ffffe097          	auipc	ra,0xffffe
    80005862:	ff4080e7          	jalr	-12(ra) # 80003852 <iunlockput>
    end_op();
    80005866:	ffffe097          	auipc	ra,0xffffe
    8000586a:	7a4080e7          	jalr	1956(ra) # 8000400a <end_op>
    return -1;
    8000586e:	557d                	li	a0,-1
    80005870:	bfd1                	j	80005844 <sys_chdir+0x7a>

0000000080005872 <sys_exec>:

uint64
sys_exec(void)
{
    80005872:	7121                	add	sp,sp,-448
    80005874:	ff06                	sd	ra,440(sp)
    80005876:	fb22                	sd	s0,432(sp)
    80005878:	f726                	sd	s1,424(sp)
    8000587a:	f34a                	sd	s2,416(sp)
    8000587c:	ef4e                	sd	s3,408(sp)
    8000587e:	eb52                	sd	s4,400(sp)
    80005880:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005882:	08000613          	li	a2,128
    80005886:	f5040593          	add	a1,s0,-176
    8000588a:	4501                	li	a0,0
    8000588c:	ffffd097          	auipc	ra,0xffffd
    80005890:	23e080e7          	jalr	574(ra) # 80002aca <argstr>
    return -1;
    80005894:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005896:	0c054a63          	bltz	a0,8000596a <sys_exec+0xf8>
    8000589a:	e4840593          	add	a1,s0,-440
    8000589e:	4505                	li	a0,1
    800058a0:	ffffd097          	auipc	ra,0xffffd
    800058a4:	208080e7          	jalr	520(ra) # 80002aa8 <argaddr>
    800058a8:	0c054163          	bltz	a0,8000596a <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    800058ac:	10000613          	li	a2,256
    800058b0:	4581                	li	a1,0
    800058b2:	e5040513          	add	a0,s0,-432
    800058b6:	ffffb097          	auipc	ra,0xffffb
    800058ba:	442080e7          	jalr	1090(ra) # 80000cf8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800058be:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800058c2:	89a6                	mv	s3,s1
    800058c4:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800058c6:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800058ca:	00391513          	sll	a0,s2,0x3
    800058ce:	e4040593          	add	a1,s0,-448
    800058d2:	e4843783          	ld	a5,-440(s0)
    800058d6:	953e                	add	a0,a0,a5
    800058d8:	ffffd097          	auipc	ra,0xffffd
    800058dc:	114080e7          	jalr	276(ra) # 800029ec <fetchaddr>
    800058e0:	02054a63          	bltz	a0,80005914 <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    800058e4:	e4043783          	ld	a5,-448(s0)
    800058e8:	c3b9                	beqz	a5,8000592e <sys_exec+0xbc>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800058ea:	ffffb097          	auipc	ra,0xffffb
    800058ee:	222080e7          	jalr	546(ra) # 80000b0c <kalloc>
    800058f2:	85aa                	mv	a1,a0
    800058f4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800058f8:	cd11                	beqz	a0,80005914 <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800058fa:	6605                	lui	a2,0x1
    800058fc:	e4043503          	ld	a0,-448(s0)
    80005900:	ffffd097          	auipc	ra,0xffffd
    80005904:	13e080e7          	jalr	318(ra) # 80002a3e <fetchstr>
    80005908:	00054663          	bltz	a0,80005914 <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    8000590c:	0905                	add	s2,s2,1
    8000590e:	09a1                	add	s3,s3,8
    80005910:	fb491de3          	bne	s2,s4,800058ca <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005914:	f5040913          	add	s2,s0,-176
    80005918:	6088                	ld	a0,0(s1)
    8000591a:	c539                	beqz	a0,80005968 <sys_exec+0xf6>
    kfree(argv[i]);
    8000591c:	ffffb097          	auipc	ra,0xffffb
    80005920:	0f2080e7          	jalr	242(ra) # 80000a0e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005924:	04a1                	add	s1,s1,8
    80005926:	ff2499e3          	bne	s1,s2,80005918 <sys_exec+0xa6>
  return -1;
    8000592a:	597d                	li	s2,-1
    8000592c:	a83d                	j	8000596a <sys_exec+0xf8>
      argv[i] = 0;
    8000592e:	0009079b          	sext.w	a5,s2
    80005932:	078e                	sll	a5,a5,0x3
    80005934:	fd078793          	add	a5,a5,-48
    80005938:	97a2                	add	a5,a5,s0
    8000593a:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000593e:	e5040593          	add	a1,s0,-432
    80005942:	f5040513          	add	a0,s0,-176
    80005946:	fffff097          	auipc	ra,0xfffff
    8000594a:	196080e7          	jalr	406(ra) # 80004adc <exec>
    8000594e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005950:	f5040993          	add	s3,s0,-176
    80005954:	6088                	ld	a0,0(s1)
    80005956:	c911                	beqz	a0,8000596a <sys_exec+0xf8>
    kfree(argv[i]);
    80005958:	ffffb097          	auipc	ra,0xffffb
    8000595c:	0b6080e7          	jalr	182(ra) # 80000a0e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005960:	04a1                	add	s1,s1,8
    80005962:	ff3499e3          	bne	s1,s3,80005954 <sys_exec+0xe2>
    80005966:	a011                	j	8000596a <sys_exec+0xf8>
  return -1;
    80005968:	597d                	li	s2,-1
}
    8000596a:	854a                	mv	a0,s2
    8000596c:	70fa                	ld	ra,440(sp)
    8000596e:	745a                	ld	s0,432(sp)
    80005970:	74ba                	ld	s1,424(sp)
    80005972:	791a                	ld	s2,416(sp)
    80005974:	69fa                	ld	s3,408(sp)
    80005976:	6a5a                	ld	s4,400(sp)
    80005978:	6139                	add	sp,sp,448
    8000597a:	8082                	ret

000000008000597c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000597c:	7139                	add	sp,sp,-64
    8000597e:	fc06                	sd	ra,56(sp)
    80005980:	f822                	sd	s0,48(sp)
    80005982:	f426                	sd	s1,40(sp)
    80005984:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005986:	ffffc097          	auipc	ra,0xffffc
    8000598a:	040080e7          	jalr	64(ra) # 800019c6 <myproc>
    8000598e:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005990:	fd840593          	add	a1,s0,-40
    80005994:	4501                	li	a0,0
    80005996:	ffffd097          	auipc	ra,0xffffd
    8000599a:	112080e7          	jalr	274(ra) # 80002aa8 <argaddr>
    return -1;
    8000599e:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800059a0:	0e054063          	bltz	a0,80005a80 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800059a4:	fc840593          	add	a1,s0,-56
    800059a8:	fd040513          	add	a0,s0,-48
    800059ac:	fffff097          	auipc	ra,0xfffff
    800059b0:	e04080e7          	jalr	-508(ra) # 800047b0 <pipealloc>
    return -1;
    800059b4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800059b6:	0c054563          	bltz	a0,80005a80 <sys_pipe+0x104>
  fd0 = -1;
    800059ba:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800059be:	fd043503          	ld	a0,-48(s0)
    800059c2:	fffff097          	auipc	ra,0xfffff
    800059c6:	510080e7          	jalr	1296(ra) # 80004ed2 <fdalloc>
    800059ca:	fca42223          	sw	a0,-60(s0)
    800059ce:	08054c63          	bltz	a0,80005a66 <sys_pipe+0xea>
    800059d2:	fc843503          	ld	a0,-56(s0)
    800059d6:	fffff097          	auipc	ra,0xfffff
    800059da:	4fc080e7          	jalr	1276(ra) # 80004ed2 <fdalloc>
    800059de:	fca42023          	sw	a0,-64(s0)
    800059e2:	06054963          	bltz	a0,80005a54 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800059e6:	4691                	li	a3,4
    800059e8:	fc440613          	add	a2,s0,-60
    800059ec:	fd843583          	ld	a1,-40(s0)
    800059f0:	68a8                	ld	a0,80(s1)
    800059f2:	ffffc097          	auipc	ra,0xffffc
    800059f6:	cca080e7          	jalr	-822(ra) # 800016bc <copyout>
    800059fa:	02054063          	bltz	a0,80005a1a <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800059fe:	4691                	li	a3,4
    80005a00:	fc040613          	add	a2,s0,-64
    80005a04:	fd843583          	ld	a1,-40(s0)
    80005a08:	0591                	add	a1,a1,4
    80005a0a:	68a8                	ld	a0,80(s1)
    80005a0c:	ffffc097          	auipc	ra,0xffffc
    80005a10:	cb0080e7          	jalr	-848(ra) # 800016bc <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005a14:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005a16:	06055563          	bgez	a0,80005a80 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005a1a:	fc442783          	lw	a5,-60(s0)
    80005a1e:	07e9                	add	a5,a5,26
    80005a20:	078e                	sll	a5,a5,0x3
    80005a22:	97a6                	add	a5,a5,s1
    80005a24:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005a28:	fc042783          	lw	a5,-64(s0)
    80005a2c:	07e9                	add	a5,a5,26
    80005a2e:	078e                	sll	a5,a5,0x3
    80005a30:	00f48533          	add	a0,s1,a5
    80005a34:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005a38:	fd043503          	ld	a0,-48(s0)
    80005a3c:	fffff097          	auipc	ra,0xfffff
    80005a40:	a1e080e7          	jalr	-1506(ra) # 8000445a <fileclose>
    fileclose(wf);
    80005a44:	fc843503          	ld	a0,-56(s0)
    80005a48:	fffff097          	auipc	ra,0xfffff
    80005a4c:	a12080e7          	jalr	-1518(ra) # 8000445a <fileclose>
    return -1;
    80005a50:	57fd                	li	a5,-1
    80005a52:	a03d                	j	80005a80 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005a54:	fc442783          	lw	a5,-60(s0)
    80005a58:	0007c763          	bltz	a5,80005a66 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005a5c:	07e9                	add	a5,a5,26
    80005a5e:	078e                	sll	a5,a5,0x3
    80005a60:	97a6                	add	a5,a5,s1
    80005a62:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005a66:	fd043503          	ld	a0,-48(s0)
    80005a6a:	fffff097          	auipc	ra,0xfffff
    80005a6e:	9f0080e7          	jalr	-1552(ra) # 8000445a <fileclose>
    fileclose(wf);
    80005a72:	fc843503          	ld	a0,-56(s0)
    80005a76:	fffff097          	auipc	ra,0xfffff
    80005a7a:	9e4080e7          	jalr	-1564(ra) # 8000445a <fileclose>
    return -1;
    80005a7e:	57fd                	li	a5,-1
}
    80005a80:	853e                	mv	a0,a5
    80005a82:	70e2                	ld	ra,56(sp)
    80005a84:	7442                	ld	s0,48(sp)
    80005a86:	74a2                	ld	s1,40(sp)
    80005a88:	6121                	add	sp,sp,64
    80005a8a:	8082                	ret
    80005a8c:	0000                	unimp
	...

0000000080005a90 <kernelvec>:
    80005a90:	7111                	add	sp,sp,-256
    80005a92:	e006                	sd	ra,0(sp)
    80005a94:	e40a                	sd	sp,8(sp)
    80005a96:	e80e                	sd	gp,16(sp)
    80005a98:	ec12                	sd	tp,24(sp)
    80005a9a:	f016                	sd	t0,32(sp)
    80005a9c:	f41a                	sd	t1,40(sp)
    80005a9e:	f81e                	sd	t2,48(sp)
    80005aa0:	fc22                	sd	s0,56(sp)
    80005aa2:	e0a6                	sd	s1,64(sp)
    80005aa4:	e4aa                	sd	a0,72(sp)
    80005aa6:	e8ae                	sd	a1,80(sp)
    80005aa8:	ecb2                	sd	a2,88(sp)
    80005aaa:	f0b6                	sd	a3,96(sp)
    80005aac:	f4ba                	sd	a4,104(sp)
    80005aae:	f8be                	sd	a5,112(sp)
    80005ab0:	fcc2                	sd	a6,120(sp)
    80005ab2:	e146                	sd	a7,128(sp)
    80005ab4:	e54a                	sd	s2,136(sp)
    80005ab6:	e94e                	sd	s3,144(sp)
    80005ab8:	ed52                	sd	s4,152(sp)
    80005aba:	f156                	sd	s5,160(sp)
    80005abc:	f55a                	sd	s6,168(sp)
    80005abe:	f95e                	sd	s7,176(sp)
    80005ac0:	fd62                	sd	s8,184(sp)
    80005ac2:	e1e6                	sd	s9,192(sp)
    80005ac4:	e5ea                	sd	s10,200(sp)
    80005ac6:	e9ee                	sd	s11,208(sp)
    80005ac8:	edf2                	sd	t3,216(sp)
    80005aca:	f1f6                	sd	t4,224(sp)
    80005acc:	f5fa                	sd	t5,232(sp)
    80005ace:	f9fe                	sd	t6,240(sp)
    80005ad0:	de9fc0ef          	jal	800028b8 <kerneltrap>
    80005ad4:	6082                	ld	ra,0(sp)
    80005ad6:	6122                	ld	sp,8(sp)
    80005ad8:	61c2                	ld	gp,16(sp)
    80005ada:	7282                	ld	t0,32(sp)
    80005adc:	7322                	ld	t1,40(sp)
    80005ade:	73c2                	ld	t2,48(sp)
    80005ae0:	7462                	ld	s0,56(sp)
    80005ae2:	6486                	ld	s1,64(sp)
    80005ae4:	6526                	ld	a0,72(sp)
    80005ae6:	65c6                	ld	a1,80(sp)
    80005ae8:	6666                	ld	a2,88(sp)
    80005aea:	7686                	ld	a3,96(sp)
    80005aec:	7726                	ld	a4,104(sp)
    80005aee:	77c6                	ld	a5,112(sp)
    80005af0:	7866                	ld	a6,120(sp)
    80005af2:	688a                	ld	a7,128(sp)
    80005af4:	692a                	ld	s2,136(sp)
    80005af6:	69ca                	ld	s3,144(sp)
    80005af8:	6a6a                	ld	s4,152(sp)
    80005afa:	7a8a                	ld	s5,160(sp)
    80005afc:	7b2a                	ld	s6,168(sp)
    80005afe:	7bca                	ld	s7,176(sp)
    80005b00:	7c6a                	ld	s8,184(sp)
    80005b02:	6c8e                	ld	s9,192(sp)
    80005b04:	6d2e                	ld	s10,200(sp)
    80005b06:	6dce                	ld	s11,208(sp)
    80005b08:	6e6e                	ld	t3,216(sp)
    80005b0a:	7e8e                	ld	t4,224(sp)
    80005b0c:	7f2e                	ld	t5,232(sp)
    80005b0e:	7fce                	ld	t6,240(sp)
    80005b10:	6111                	add	sp,sp,256
    80005b12:	10200073          	sret
    80005b16:	00000013          	nop
    80005b1a:	00000013          	nop
    80005b1e:	0001                	nop

0000000080005b20 <timervec>:
    80005b20:	34051573          	csrrw	a0,mscratch,a0
    80005b24:	e10c                	sd	a1,0(a0)
    80005b26:	e510                	sd	a2,8(a0)
    80005b28:	e914                	sd	a3,16(a0)
    80005b2a:	710c                	ld	a1,32(a0)
    80005b2c:	7510                	ld	a2,40(a0)
    80005b2e:	6194                	ld	a3,0(a1)
    80005b30:	96b2                	add	a3,a3,a2
    80005b32:	e194                	sd	a3,0(a1)
    80005b34:	4589                	li	a1,2
    80005b36:	14459073          	csrw	sip,a1
    80005b3a:	6914                	ld	a3,16(a0)
    80005b3c:	6510                	ld	a2,8(a0)
    80005b3e:	610c                	ld	a1,0(a0)
    80005b40:	34051573          	csrrw	a0,mscratch,a0
    80005b44:	30200073          	mret
	...

0000000080005b4a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005b4a:	1141                	add	sp,sp,-16
    80005b4c:	e422                	sd	s0,8(sp)
    80005b4e:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005b50:	0c0007b7          	lui	a5,0xc000
    80005b54:	4705                	li	a4,1
    80005b56:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005b58:	c3d8                	sw	a4,4(a5)
}
    80005b5a:	6422                	ld	s0,8(sp)
    80005b5c:	0141                	add	sp,sp,16
    80005b5e:	8082                	ret

0000000080005b60 <plicinithart>:

void
plicinithart(void)
{
    80005b60:	1141                	add	sp,sp,-16
    80005b62:	e406                	sd	ra,8(sp)
    80005b64:	e022                	sd	s0,0(sp)
    80005b66:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005b68:	ffffc097          	auipc	ra,0xffffc
    80005b6c:	e32080e7          	jalr	-462(ra) # 8000199a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005b70:	0085171b          	sllw	a4,a0,0x8
    80005b74:	0c0027b7          	lui	a5,0xc002
    80005b78:	97ba                	add	a5,a5,a4
    80005b7a:	40200713          	li	a4,1026
    80005b7e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005b82:	00d5151b          	sllw	a0,a0,0xd
    80005b86:	0c2017b7          	lui	a5,0xc201
    80005b8a:	97aa                	add	a5,a5,a0
    80005b8c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005b90:	60a2                	ld	ra,8(sp)
    80005b92:	6402                	ld	s0,0(sp)
    80005b94:	0141                	add	sp,sp,16
    80005b96:	8082                	ret

0000000080005b98 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005b98:	1141                	add	sp,sp,-16
    80005b9a:	e406                	sd	ra,8(sp)
    80005b9c:	e022                	sd	s0,0(sp)
    80005b9e:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005ba0:	ffffc097          	auipc	ra,0xffffc
    80005ba4:	dfa080e7          	jalr	-518(ra) # 8000199a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005ba8:	00d5151b          	sllw	a0,a0,0xd
    80005bac:	0c2017b7          	lui	a5,0xc201
    80005bb0:	97aa                	add	a5,a5,a0
  return irq;
}
    80005bb2:	43c8                	lw	a0,4(a5)
    80005bb4:	60a2                	ld	ra,8(sp)
    80005bb6:	6402                	ld	s0,0(sp)
    80005bb8:	0141                	add	sp,sp,16
    80005bba:	8082                	ret

0000000080005bbc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005bbc:	1101                	add	sp,sp,-32
    80005bbe:	ec06                	sd	ra,24(sp)
    80005bc0:	e822                	sd	s0,16(sp)
    80005bc2:	e426                	sd	s1,8(sp)
    80005bc4:	1000                	add	s0,sp,32
    80005bc6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005bc8:	ffffc097          	auipc	ra,0xffffc
    80005bcc:	dd2080e7          	jalr	-558(ra) # 8000199a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005bd0:	00d5151b          	sllw	a0,a0,0xd
    80005bd4:	0c2017b7          	lui	a5,0xc201
    80005bd8:	97aa                	add	a5,a5,a0
    80005bda:	c3c4                	sw	s1,4(a5)
}
    80005bdc:	60e2                	ld	ra,24(sp)
    80005bde:	6442                	ld	s0,16(sp)
    80005be0:	64a2                	ld	s1,8(sp)
    80005be2:	6105                	add	sp,sp,32
    80005be4:	8082                	ret

0000000080005be6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005be6:	1141                	add	sp,sp,-16
    80005be8:	e406                	sd	ra,8(sp)
    80005bea:	e022                	sd	s0,0(sp)
    80005bec:	0800                	add	s0,sp,16
  if(i >= NUM)
    80005bee:	479d                	li	a5,7
    80005bf0:	04a7cb63          	blt	a5,a0,80005c46 <free_desc+0x60>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80005bf4:	0001d717          	auipc	a4,0x1d
    80005bf8:	40c70713          	add	a4,a4,1036 # 80023000 <disk>
    80005bfc:	972a                	add	a4,a4,a0
    80005bfe:	6789                	lui	a5,0x2
    80005c00:	97ba                	add	a5,a5,a4
    80005c02:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005c06:	eba1                	bnez	a5,80005c56 <free_desc+0x70>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    80005c08:	00451713          	sll	a4,a0,0x4
    80005c0c:	0001f797          	auipc	a5,0x1f
    80005c10:	3f47b783          	ld	a5,1012(a5) # 80025000 <disk+0x2000>
    80005c14:	97ba                	add	a5,a5,a4
    80005c16:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    80005c1a:	0001d717          	auipc	a4,0x1d
    80005c1e:	3e670713          	add	a4,a4,998 # 80023000 <disk>
    80005c22:	972a                	add	a4,a4,a0
    80005c24:	6789                	lui	a5,0x2
    80005c26:	97ba                	add	a5,a5,a4
    80005c28:	4705                	li	a4,1
    80005c2a:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005c2e:	0001f517          	auipc	a0,0x1f
    80005c32:	3ea50513          	add	a0,a0,1002 # 80025018 <disk+0x2018>
    80005c36:	ffffc097          	auipc	ra,0xffffc
    80005c3a:	724080e7          	jalr	1828(ra) # 8000235a <wakeup>
}
    80005c3e:	60a2                	ld	ra,8(sp)
    80005c40:	6402                	ld	s0,0(sp)
    80005c42:	0141                	add	sp,sp,16
    80005c44:	8082                	ret
    panic("virtio_disk_intr 1");
    80005c46:	00003517          	auipc	a0,0x3
    80005c4a:	b1250513          	add	a0,a0,-1262 # 80008758 <syscalls+0x330>
    80005c4e:	ffffb097          	auipc	ra,0xffffb
    80005c52:	8f4080e7          	jalr	-1804(ra) # 80000542 <panic>
    panic("virtio_disk_intr 2");
    80005c56:	00003517          	auipc	a0,0x3
    80005c5a:	b1a50513          	add	a0,a0,-1254 # 80008770 <syscalls+0x348>
    80005c5e:	ffffb097          	auipc	ra,0xffffb
    80005c62:	8e4080e7          	jalr	-1820(ra) # 80000542 <panic>

0000000080005c66 <virtio_disk_init>:
{
    80005c66:	1101                	add	sp,sp,-32
    80005c68:	ec06                	sd	ra,24(sp)
    80005c6a:	e822                	sd	s0,16(sp)
    80005c6c:	e426                	sd	s1,8(sp)
    80005c6e:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005c70:	00003597          	auipc	a1,0x3
    80005c74:	b1858593          	add	a1,a1,-1256 # 80008788 <syscalls+0x360>
    80005c78:	0001f517          	auipc	a0,0x1f
    80005c7c:	43050513          	add	a0,a0,1072 # 800250a8 <disk+0x20a8>
    80005c80:	ffffb097          	auipc	ra,0xffffb
    80005c84:	eec080e7          	jalr	-276(ra) # 80000b6c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005c88:	100017b7          	lui	a5,0x10001
    80005c8c:	4398                	lw	a4,0(a5)
    80005c8e:	2701                	sext.w	a4,a4
    80005c90:	747277b7          	lui	a5,0x74727
    80005c94:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005c98:	0ef71063          	bne	a4,a5,80005d78 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005c9c:	100017b7          	lui	a5,0x10001
    80005ca0:	43dc                	lw	a5,4(a5)
    80005ca2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005ca4:	4705                	li	a4,1
    80005ca6:	0ce79963          	bne	a5,a4,80005d78 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005caa:	100017b7          	lui	a5,0x10001
    80005cae:	479c                	lw	a5,8(a5)
    80005cb0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005cb2:	4709                	li	a4,2
    80005cb4:	0ce79263          	bne	a5,a4,80005d78 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005cb8:	100017b7          	lui	a5,0x10001
    80005cbc:	47d8                	lw	a4,12(a5)
    80005cbe:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005cc0:	554d47b7          	lui	a5,0x554d4
    80005cc4:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005cc8:	0af71863          	bne	a4,a5,80005d78 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005ccc:	100017b7          	lui	a5,0x10001
    80005cd0:	4705                	li	a4,1
    80005cd2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005cd4:	470d                	li	a4,3
    80005cd6:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005cd8:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005cda:	c7ffe6b7          	lui	a3,0xc7ffe
    80005cde:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    80005ce2:	8f75                	and	a4,a4,a3
    80005ce4:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005ce6:	472d                	li	a4,11
    80005ce8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005cea:	473d                	li	a4,15
    80005cec:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005cee:	6705                	lui	a4,0x1
    80005cf0:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005cf2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005cf6:	5bdc                	lw	a5,52(a5)
    80005cf8:	2781                	sext.w	a5,a5
  if(max == 0)
    80005cfa:	c7d9                	beqz	a5,80005d88 <virtio_disk_init+0x122>
  if(max < NUM)
    80005cfc:	471d                	li	a4,7
    80005cfe:	08f77d63          	bgeu	a4,a5,80005d98 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005d02:	100014b7          	lui	s1,0x10001
    80005d06:	47a1                	li	a5,8
    80005d08:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005d0a:	6609                	lui	a2,0x2
    80005d0c:	4581                	li	a1,0
    80005d0e:	0001d517          	auipc	a0,0x1d
    80005d12:	2f250513          	add	a0,a0,754 # 80023000 <disk>
    80005d16:	ffffb097          	auipc	ra,0xffffb
    80005d1a:	fe2080e7          	jalr	-30(ra) # 80000cf8 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005d1e:	0001d717          	auipc	a4,0x1d
    80005d22:	2e270713          	add	a4,a4,738 # 80023000 <disk>
    80005d26:	00c75793          	srl	a5,a4,0xc
    80005d2a:	2781                	sext.w	a5,a5
    80005d2c:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    80005d2e:	0001f797          	auipc	a5,0x1f
    80005d32:	2d278793          	add	a5,a5,722 # 80025000 <disk+0x2000>
    80005d36:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    80005d38:	0001d717          	auipc	a4,0x1d
    80005d3c:	34870713          	add	a4,a4,840 # 80023080 <disk+0x80>
    80005d40:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    80005d42:	0001e717          	auipc	a4,0x1e
    80005d46:	2be70713          	add	a4,a4,702 # 80024000 <disk+0x1000>
    80005d4a:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005d4c:	4705                	li	a4,1
    80005d4e:	00e78c23          	sb	a4,24(a5)
    80005d52:	00e78ca3          	sb	a4,25(a5)
    80005d56:	00e78d23          	sb	a4,26(a5)
    80005d5a:	00e78da3          	sb	a4,27(a5)
    80005d5e:	00e78e23          	sb	a4,28(a5)
    80005d62:	00e78ea3          	sb	a4,29(a5)
    80005d66:	00e78f23          	sb	a4,30(a5)
    80005d6a:	00e78fa3          	sb	a4,31(a5)
}
    80005d6e:	60e2                	ld	ra,24(sp)
    80005d70:	6442                	ld	s0,16(sp)
    80005d72:	64a2                	ld	s1,8(sp)
    80005d74:	6105                	add	sp,sp,32
    80005d76:	8082                	ret
    panic("could not find virtio disk");
    80005d78:	00003517          	auipc	a0,0x3
    80005d7c:	a2050513          	add	a0,a0,-1504 # 80008798 <syscalls+0x370>
    80005d80:	ffffa097          	auipc	ra,0xffffa
    80005d84:	7c2080e7          	jalr	1986(ra) # 80000542 <panic>
    panic("virtio disk has no queue 0");
    80005d88:	00003517          	auipc	a0,0x3
    80005d8c:	a3050513          	add	a0,a0,-1488 # 800087b8 <syscalls+0x390>
    80005d90:	ffffa097          	auipc	ra,0xffffa
    80005d94:	7b2080e7          	jalr	1970(ra) # 80000542 <panic>
    panic("virtio disk max queue too short");
    80005d98:	00003517          	auipc	a0,0x3
    80005d9c:	a4050513          	add	a0,a0,-1472 # 800087d8 <syscalls+0x3b0>
    80005da0:	ffffa097          	auipc	ra,0xffffa
    80005da4:	7a2080e7          	jalr	1954(ra) # 80000542 <panic>

0000000080005da8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005da8:	7119                	add	sp,sp,-128
    80005daa:	fc86                	sd	ra,120(sp)
    80005dac:	f8a2                	sd	s0,112(sp)
    80005dae:	f4a6                	sd	s1,104(sp)
    80005db0:	f0ca                	sd	s2,96(sp)
    80005db2:	ecce                	sd	s3,88(sp)
    80005db4:	e8d2                	sd	s4,80(sp)
    80005db6:	e4d6                	sd	s5,72(sp)
    80005db8:	e0da                	sd	s6,64(sp)
    80005dba:	fc5e                	sd	s7,56(sp)
    80005dbc:	f862                	sd	s8,48(sp)
    80005dbe:	f466                	sd	s9,40(sp)
    80005dc0:	f06a                	sd	s10,32(sp)
    80005dc2:	0100                	add	s0,sp,128
    80005dc4:	8a2a                	mv	s4,a0
    80005dc6:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005dc8:	00c52c03          	lw	s8,12(a0)
    80005dcc:	001c1c1b          	sllw	s8,s8,0x1
    80005dd0:	1c02                	sll	s8,s8,0x20
    80005dd2:	020c5c13          	srl	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    80005dd6:	0001f517          	auipc	a0,0x1f
    80005dda:	2d250513          	add	a0,a0,722 # 800250a8 <disk+0x20a8>
    80005dde:	ffffb097          	auipc	ra,0xffffb
    80005de2:	e1e080e7          	jalr	-482(ra) # 80000bfc <acquire>
  for(int i = 0; i < 3; i++){
    80005de6:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005de8:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005dea:	0001db97          	auipc	s7,0x1d
    80005dee:	216b8b93          	add	s7,s7,534 # 80023000 <disk>
    80005df2:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005df4:	4a8d                	li	s5,3
    80005df6:	a0b5                	j	80005e62 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005df8:	00fb8733          	add	a4,s7,a5
    80005dfc:	975a                	add	a4,a4,s6
    80005dfe:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005e02:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80005e04:	0207c563          	bltz	a5,80005e2e <virtio_disk_rw+0x86>
  for(int i = 0; i < 3; i++){
    80005e08:	2605                	addw	a2,a2,1 # 2001 <_entry-0x7fffdfff>
    80005e0a:	0591                	add	a1,a1,4
    80005e0c:	19560c63          	beq	a2,s5,80005fa4 <virtio_disk_rw+0x1fc>
    idx[i] = alloc_desc();
    80005e10:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005e12:	0001f717          	auipc	a4,0x1f
    80005e16:	20670713          	add	a4,a4,518 # 80025018 <disk+0x2018>
    80005e1a:	87ca                	mv	a5,s2
    if(disk.free[i]){
    80005e1c:	00074683          	lbu	a3,0(a4)
    80005e20:	fee1                	bnez	a3,80005df8 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005e22:	2785                	addw	a5,a5,1
    80005e24:	0705                	add	a4,a4,1
    80005e26:	fe979be3          	bne	a5,s1,80005e1c <virtio_disk_rw+0x74>
    idx[i] = alloc_desc();
    80005e2a:	57fd                	li	a5,-1
    80005e2c:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    80005e2e:	00c05e63          	blez	a2,80005e4a <virtio_disk_rw+0xa2>
    80005e32:	060a                	sll	a2,a2,0x2
    80005e34:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80005e38:	0009a503          	lw	a0,0(s3)
    80005e3c:	00000097          	auipc	ra,0x0
    80005e40:	daa080e7          	jalr	-598(ra) # 80005be6 <free_desc>
      for(int j = 0; j < i; j++)
    80005e44:	0991                	add	s3,s3,4
    80005e46:	ffa999e3          	bne	s3,s10,80005e38 <virtio_disk_rw+0x90>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005e4a:	0001f597          	auipc	a1,0x1f
    80005e4e:	25e58593          	add	a1,a1,606 # 800250a8 <disk+0x20a8>
    80005e52:	0001f517          	auipc	a0,0x1f
    80005e56:	1c650513          	add	a0,a0,454 # 80025018 <disk+0x2018>
    80005e5a:	ffffc097          	auipc	ra,0xffffc
    80005e5e:	380080e7          	jalr	896(ra) # 800021da <sleep>
  for(int i = 0; i < 3; i++){
    80005e62:	f9040993          	add	s3,s0,-112
{
    80005e66:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80005e68:	864a                	mv	a2,s2
    80005e6a:	b75d                	j	80005e10 <virtio_disk_rw+0x68>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005e6c:	0001f717          	auipc	a4,0x1f
    80005e70:	19473703          	ld	a4,404(a4) # 80025000 <disk+0x2000>
    80005e74:	973e                	add	a4,a4,a5
    80005e76:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005e7a:	0001d517          	auipc	a0,0x1d
    80005e7e:	18650513          	add	a0,a0,390 # 80023000 <disk>
    80005e82:	0001f717          	auipc	a4,0x1f
    80005e86:	17e70713          	add	a4,a4,382 # 80025000 <disk+0x2000>
    80005e8a:	6314                	ld	a3,0(a4)
    80005e8c:	96be                	add	a3,a3,a5
    80005e8e:	00c6d603          	lhu	a2,12(a3)
    80005e92:	00166613          	or	a2,a2,1
    80005e96:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005e9a:	f9842683          	lw	a3,-104(s0)
    80005e9e:	6310                	ld	a2,0(a4)
    80005ea0:	97b2                	add	a5,a5,a2
    80005ea2:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
    80005ea6:	20048613          	add	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    80005eaa:	0612                	sll	a2,a2,0x4
    80005eac:	962a                	add	a2,a2,a0
    80005eae:	02060823          	sb	zero,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005eb2:	00469793          	sll	a5,a3,0x4
    80005eb6:	630c                	ld	a1,0(a4)
    80005eb8:	95be                	add	a1,a1,a5
    80005eba:	6689                	lui	a3,0x2
    80005ebc:	03068693          	add	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005ec0:	96ca                	add	a3,a3,s2
    80005ec2:	96aa                	add	a3,a3,a0
    80005ec4:	e194                	sd	a3,0(a1)
  disk.desc[idx[2]].len = 1;
    80005ec6:	6314                	ld	a3,0(a4)
    80005ec8:	96be                	add	a3,a3,a5
    80005eca:	4585                	li	a1,1
    80005ecc:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005ece:	6314                	ld	a3,0(a4)
    80005ed0:	96be                	add	a3,a3,a5
    80005ed2:	4509                	li	a0,2
    80005ed4:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    80005ed8:	6314                	ld	a3,0(a4)
    80005eda:	97b6                	add	a5,a5,a3
    80005edc:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005ee0:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80005ee4:	03463423          	sd	s4,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    80005ee8:	6714                	ld	a3,8(a4)
    80005eea:	0026d783          	lhu	a5,2(a3)
    80005eee:	8b9d                	and	a5,a5,7
    80005ef0:	0789                	add	a5,a5,2
    80005ef2:	0786                	sll	a5,a5,0x1
    80005ef4:	96be                	add	a3,a3,a5
    80005ef6:	00969023          	sh	s1,0(a3)
  __sync_synchronize();
    80005efa:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    80005efe:	6718                	ld	a4,8(a4)
    80005f00:	00275783          	lhu	a5,2(a4)
    80005f04:	2785                	addw	a5,a5,1
    80005f06:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005f0a:	100017b7          	lui	a5,0x10001
    80005f0e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005f12:	004a2783          	lw	a5,4(s4)
    80005f16:	02b79163          	bne	a5,a1,80005f38 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005f1a:	0001f917          	auipc	s2,0x1f
    80005f1e:	18e90913          	add	s2,s2,398 # 800250a8 <disk+0x20a8>
  while(b->disk == 1) {
    80005f22:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005f24:	85ca                	mv	a1,s2
    80005f26:	8552                	mv	a0,s4
    80005f28:	ffffc097          	auipc	ra,0xffffc
    80005f2c:	2b2080e7          	jalr	690(ra) # 800021da <sleep>
  while(b->disk == 1) {
    80005f30:	004a2783          	lw	a5,4(s4)
    80005f34:	fe9788e3          	beq	a5,s1,80005f24 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005f38:	f9042483          	lw	s1,-112(s0)
    80005f3c:	20048713          	add	a4,s1,512
    80005f40:	0712                	sll	a4,a4,0x4
    80005f42:	0001d797          	auipc	a5,0x1d
    80005f46:	0be78793          	add	a5,a5,190 # 80023000 <disk>
    80005f4a:	97ba                	add	a5,a5,a4
    80005f4c:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80005f50:	0001f917          	auipc	s2,0x1f
    80005f54:	0b090913          	add	s2,s2,176 # 80025000 <disk+0x2000>
    80005f58:	a019                	j	80005f5e <virtio_disk_rw+0x1b6>
      i = disk.desc[i].next;
    80005f5a:	00e7d483          	lhu	s1,14(a5)
    free_desc(i);
    80005f5e:	8526                	mv	a0,s1
    80005f60:	00000097          	auipc	ra,0x0
    80005f64:	c86080e7          	jalr	-890(ra) # 80005be6 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80005f68:	0492                	sll	s1,s1,0x4
    80005f6a:	00093783          	ld	a5,0(s2)
    80005f6e:	97a6                	add	a5,a5,s1
    80005f70:	00c7d703          	lhu	a4,12(a5)
    80005f74:	8b05                	and	a4,a4,1
    80005f76:	f375                	bnez	a4,80005f5a <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005f78:	0001f517          	auipc	a0,0x1f
    80005f7c:	13050513          	add	a0,a0,304 # 800250a8 <disk+0x20a8>
    80005f80:	ffffb097          	auipc	ra,0xffffb
    80005f84:	d30080e7          	jalr	-720(ra) # 80000cb0 <release>
}
    80005f88:	70e6                	ld	ra,120(sp)
    80005f8a:	7446                	ld	s0,112(sp)
    80005f8c:	74a6                	ld	s1,104(sp)
    80005f8e:	7906                	ld	s2,96(sp)
    80005f90:	69e6                	ld	s3,88(sp)
    80005f92:	6a46                	ld	s4,80(sp)
    80005f94:	6aa6                	ld	s5,72(sp)
    80005f96:	6b06                	ld	s6,64(sp)
    80005f98:	7be2                	ld	s7,56(sp)
    80005f9a:	7c42                	ld	s8,48(sp)
    80005f9c:	7ca2                	ld	s9,40(sp)
    80005f9e:	7d02                	ld	s10,32(sp)
    80005fa0:	6109                	add	sp,sp,128
    80005fa2:	8082                	ret
  if(write)
    80005fa4:	019037b3          	snez	a5,s9
    80005fa8:	f8f42023          	sw	a5,-128(s0)
  buf0.reserved = 0;
    80005fac:	f8042223          	sw	zero,-124(s0)
  buf0.sector = sector;
    80005fb0:	f9843423          	sd	s8,-120(s0)
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    80005fb4:	f9042483          	lw	s1,-112(s0)
    80005fb8:	00449913          	sll	s2,s1,0x4
    80005fbc:	0001f997          	auipc	s3,0x1f
    80005fc0:	04498993          	add	s3,s3,68 # 80025000 <disk+0x2000>
    80005fc4:	0009ba83          	ld	s5,0(s3)
    80005fc8:	9aca                	add	s5,s5,s2
    80005fca:	f8040513          	add	a0,s0,-128
    80005fce:	ffffb097          	auipc	ra,0xffffb
    80005fd2:	0f8080e7          	jalr	248(ra) # 800010c6 <kvmpa>
    80005fd6:	00aab023          	sd	a0,0(s5)
  disk.desc[idx[0]].len = sizeof(buf0);
    80005fda:	0009b783          	ld	a5,0(s3)
    80005fde:	97ca                	add	a5,a5,s2
    80005fe0:	4741                	li	a4,16
    80005fe2:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005fe4:	0009b783          	ld	a5,0(s3)
    80005fe8:	97ca                	add	a5,a5,s2
    80005fea:	4705                	li	a4,1
    80005fec:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005ff0:	f9442783          	lw	a5,-108(s0)
    80005ff4:	0009b703          	ld	a4,0(s3)
    80005ff8:	974a                	add	a4,a4,s2
    80005ffa:	00f71723          	sh	a5,14(a4)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005ffe:	0792                	sll	a5,a5,0x4
    80006000:	0009b703          	ld	a4,0(s3)
    80006004:	973e                	add	a4,a4,a5
    80006006:	058a0693          	add	a3,s4,88
    8000600a:	e314                	sd	a3,0(a4)
  disk.desc[idx[1]].len = BSIZE;
    8000600c:	0009b703          	ld	a4,0(s3)
    80006010:	973e                	add	a4,a4,a5
    80006012:	40000693          	li	a3,1024
    80006016:	c714                	sw	a3,8(a4)
  if(write)
    80006018:	e40c9ae3          	bnez	s9,80005e6c <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000601c:	0001f717          	auipc	a4,0x1f
    80006020:	fe473703          	ld	a4,-28(a4) # 80025000 <disk+0x2000>
    80006024:	973e                	add	a4,a4,a5
    80006026:	4689                	li	a3,2
    80006028:	00d71623          	sh	a3,12(a4)
    8000602c:	b5b9                	j	80005e7a <virtio_disk_rw+0xd2>

000000008000602e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000602e:	1101                	add	sp,sp,-32
    80006030:	ec06                	sd	ra,24(sp)
    80006032:	e822                	sd	s0,16(sp)
    80006034:	e426                	sd	s1,8(sp)
    80006036:	e04a                	sd	s2,0(sp)
    80006038:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000603a:	0001f517          	auipc	a0,0x1f
    8000603e:	06e50513          	add	a0,a0,110 # 800250a8 <disk+0x20a8>
    80006042:	ffffb097          	auipc	ra,0xffffb
    80006046:	bba080e7          	jalr	-1094(ra) # 80000bfc <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    8000604a:	0001f717          	auipc	a4,0x1f
    8000604e:	fb670713          	add	a4,a4,-74 # 80025000 <disk+0x2000>
    80006052:	02075783          	lhu	a5,32(a4)
    80006056:	6b18                	ld	a4,16(a4)
    80006058:	00275683          	lhu	a3,2(a4)
    8000605c:	8ebd                	xor	a3,a3,a5
    8000605e:	8a9d                	and	a3,a3,7
    80006060:	cab9                	beqz	a3,800060b6 <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    80006062:	0001d917          	auipc	s2,0x1d
    80006066:	f9e90913          	add	s2,s2,-98 # 80023000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    8000606a:	0001f497          	auipc	s1,0x1f
    8000606e:	f9648493          	add	s1,s1,-106 # 80025000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    80006072:	078e                	sll	a5,a5,0x3
    80006074:	973e                	add	a4,a4,a5
    80006076:	435c                	lw	a5,4(a4)
    if(disk.info[id].status != 0)
    80006078:	20078713          	add	a4,a5,512
    8000607c:	0712                	sll	a4,a4,0x4
    8000607e:	974a                	add	a4,a4,s2
    80006080:	03074703          	lbu	a4,48(a4)
    80006084:	ef21                	bnez	a4,800060dc <virtio_disk_intr+0xae>
    disk.info[id].b->disk = 0;   // disk is done with buf
    80006086:	20078793          	add	a5,a5,512
    8000608a:	0792                	sll	a5,a5,0x4
    8000608c:	97ca                	add	a5,a5,s2
    8000608e:	7798                	ld	a4,40(a5)
    80006090:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    80006094:	7788                	ld	a0,40(a5)
    80006096:	ffffc097          	auipc	ra,0xffffc
    8000609a:	2c4080e7          	jalr	708(ra) # 8000235a <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    8000609e:	0204d783          	lhu	a5,32(s1)
    800060a2:	2785                	addw	a5,a5,1
    800060a4:	8b9d                	and	a5,a5,7
    800060a6:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    800060aa:	6898                	ld	a4,16(s1)
    800060ac:	00275683          	lhu	a3,2(a4)
    800060b0:	8a9d                	and	a3,a3,7
    800060b2:	fcf690e3          	bne	a3,a5,80006072 <virtio_disk_intr+0x44>
  }
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800060b6:	10001737          	lui	a4,0x10001
    800060ba:	533c                	lw	a5,96(a4)
    800060bc:	8b8d                	and	a5,a5,3
    800060be:	d37c                	sw	a5,100(a4)

  release(&disk.vdisk_lock);
    800060c0:	0001f517          	auipc	a0,0x1f
    800060c4:	fe850513          	add	a0,a0,-24 # 800250a8 <disk+0x20a8>
    800060c8:	ffffb097          	auipc	ra,0xffffb
    800060cc:	be8080e7          	jalr	-1048(ra) # 80000cb0 <release>
}
    800060d0:	60e2                	ld	ra,24(sp)
    800060d2:	6442                	ld	s0,16(sp)
    800060d4:	64a2                	ld	s1,8(sp)
    800060d6:	6902                	ld	s2,0(sp)
    800060d8:	6105                	add	sp,sp,32
    800060da:	8082                	ret
      panic("virtio_disk_intr status");
    800060dc:	00002517          	auipc	a0,0x2
    800060e0:	71c50513          	add	a0,a0,1820 # 800087f8 <syscalls+0x3d0>
    800060e4:	ffffa097          	auipc	ra,0xffffa
    800060e8:	45e080e7          	jalr	1118(ra) # 80000542 <panic>
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
