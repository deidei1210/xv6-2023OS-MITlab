
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	18010113          	add	sp,sp,384 # 80009180 <stack0>
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
    80000054:	ff070713          	add	a4,a4,-16 # 80009040 <timer_scratch>
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
    80000066:	d3e78793          	add	a5,a5,-706 # 80005da0 <timervec>
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
    8000009a:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdd7ff>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	dba78793          	add	a5,a5,-582 # 80000e66 <main>
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
  int i;

  for(i = 0; i < n; i++){
    80000104:	04c05763          	blez	a2,80000152 <consolewrite+0x60>
    80000108:	8a2a                	mv	s4,a0
    8000010a:	84ae                	mv	s1,a1
    8000010c:	89b2                	mv	s3,a2
    8000010e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000110:	5afd                	li	s5,-1
    80000112:	4685                	li	a3,1
    80000114:	8626                	mv	a2,s1
    80000116:	85d2                	mv	a1,s4
    80000118:	fbf40513          	add	a0,s0,-65
    8000011c:	00002097          	auipc	ra,0x2
    80000120:	34e080e7          	jalr	846(ra) # 8000246a <either_copyin>
    80000124:	01550d63          	beq	a0,s5,8000013e <consolewrite+0x4c>
      break;
    uartputc(c);
    80000128:	fbf44503          	lbu	a0,-65(s0)
    8000012c:	00000097          	auipc	ra,0x0
    80000130:	77a080e7          	jalr	1914(ra) # 800008a6 <uartputc>
  for(i = 0; i < n; i++){
    80000134:	2905                	addw	s2,s2,1
    80000136:	0485                	add	s1,s1,1
    80000138:	fd299de3          	bne	s3,s2,80000112 <consolewrite+0x20>
    8000013c:	894e                	mv	s2,s3
  }

  return i;
}
    8000013e:	854a                	mv	a0,s2
    80000140:	60a6                	ld	ra,72(sp)
    80000142:	6406                	ld	s0,64(sp)
    80000144:	74e2                	ld	s1,56(sp)
    80000146:	7942                	ld	s2,48(sp)
    80000148:	79a2                	ld	s3,40(sp)
    8000014a:	7a02                	ld	s4,32(sp)
    8000014c:	6ae2                	ld	s5,24(sp)
    8000014e:	6161                	add	sp,sp,80
    80000150:	8082                	ret
  for(i = 0; i < n; i++){
    80000152:	4901                	li	s2,0
    80000154:	b7ed                	j	8000013e <consolewrite+0x4c>

0000000080000156 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000156:	711d                	add	sp,sp,-96
    80000158:	ec86                	sd	ra,88(sp)
    8000015a:	e8a2                	sd	s0,80(sp)
    8000015c:	e4a6                	sd	s1,72(sp)
    8000015e:	e0ca                	sd	s2,64(sp)
    80000160:	fc4e                	sd	s3,56(sp)
    80000162:	f852                	sd	s4,48(sp)
    80000164:	f456                	sd	s5,40(sp)
    80000166:	f05a                	sd	s6,32(sp)
    80000168:	ec5e                	sd	s7,24(sp)
    8000016a:	1080                	add	s0,sp,96
    8000016c:	8aaa                	mv	s5,a0
    8000016e:	8a2e                	mv	s4,a1
    80000170:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000172:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000176:	00011517          	auipc	a0,0x11
    8000017a:	00a50513          	add	a0,a0,10 # 80011180 <cons>
    8000017e:	00001097          	auipc	ra,0x1
    80000182:	a40080e7          	jalr	-1472(ra) # 80000bbe <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000186:	00011497          	auipc	s1,0x11
    8000018a:	ffa48493          	add	s1,s1,-6 # 80011180 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000018e:	00011917          	auipc	s2,0x11
    80000192:	08a90913          	add	s2,s2,138 # 80011218 <cons+0x98>
  while(n > 0){
    80000196:	07305f63          	blez	s3,80000214 <consoleread+0xbe>
    while(cons.r == cons.w){
    8000019a:	0984a783          	lw	a5,152(s1)
    8000019e:	09c4a703          	lw	a4,156(s1)
    800001a2:	02f71463          	bne	a4,a5,800001ca <consoleread+0x74>
      if(myproc()->killed){
    800001a6:	00001097          	auipc	ra,0x1
    800001aa:	7fe080e7          	jalr	2046(ra) # 800019a4 <myproc>
    800001ae:	591c                	lw	a5,48(a0)
    800001b0:	efad                	bnez	a5,8000022a <consoleread+0xd4>
      sleep(&cons.r, &cons.lock);
    800001b2:	85a6                	mv	a1,s1
    800001b4:	854a                	mv	a0,s2
    800001b6:	00002097          	auipc	ra,0x2
    800001ba:	004080e7          	jalr	4(ra) # 800021ba <sleep>
    while(cons.r == cons.w){
    800001be:	0984a783          	lw	a5,152(s1)
    800001c2:	09c4a703          	lw	a4,156(s1)
    800001c6:	fef700e3          	beq	a4,a5,800001a6 <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    800001ca:	00011717          	auipc	a4,0x11
    800001ce:	fb670713          	add	a4,a4,-74 # 80011180 <cons>
    800001d2:	0017869b          	addw	a3,a5,1
    800001d6:	08d72c23          	sw	a3,152(a4)
    800001da:	07f7f693          	and	a3,a5,127
    800001de:	9736                	add	a4,a4,a3
    800001e0:	01874703          	lbu	a4,24(a4)
    800001e4:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001e8:	4691                	li	a3,4
    800001ea:	06db8463          	beq	s7,a3,80000252 <consoleread+0xfc>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001ee:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001f2:	4685                	li	a3,1
    800001f4:	faf40613          	add	a2,s0,-81
    800001f8:	85d2                	mv	a1,s4
    800001fa:	8556                	mv	a0,s5
    800001fc:	00002097          	auipc	ra,0x2
    80000200:	218080e7          	jalr	536(ra) # 80002414 <either_copyout>
    80000204:	57fd                	li	a5,-1
    80000206:	00f50763          	beq	a0,a5,80000214 <consoleread+0xbe>
      break;

    dst++;
    8000020a:	0a05                	add	s4,s4,1
    --n;
    8000020c:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    8000020e:	47a9                	li	a5,10
    80000210:	f8fb93e3          	bne	s7,a5,80000196 <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000214:	00011517          	auipc	a0,0x11
    80000218:	f6c50513          	add	a0,a0,-148 # 80011180 <cons>
    8000021c:	00001097          	auipc	ra,0x1
    80000220:	a56080e7          	jalr	-1450(ra) # 80000c72 <release>

  return target - n;
    80000224:	413b053b          	subw	a0,s6,s3
    80000228:	a811                	j	8000023c <consoleread+0xe6>
        release(&cons.lock);
    8000022a:	00011517          	auipc	a0,0x11
    8000022e:	f5650513          	add	a0,a0,-170 # 80011180 <cons>
    80000232:	00001097          	auipc	ra,0x1
    80000236:	a40080e7          	jalr	-1472(ra) # 80000c72 <release>
        return -1;
    8000023a:	557d                	li	a0,-1
}
    8000023c:	60e6                	ld	ra,88(sp)
    8000023e:	6446                	ld	s0,80(sp)
    80000240:	64a6                	ld	s1,72(sp)
    80000242:	6906                	ld	s2,64(sp)
    80000244:	79e2                	ld	s3,56(sp)
    80000246:	7a42                	ld	s4,48(sp)
    80000248:	7aa2                	ld	s5,40(sp)
    8000024a:	7b02                	ld	s6,32(sp)
    8000024c:	6be2                	ld	s7,24(sp)
    8000024e:	6125                	add	sp,sp,96
    80000250:	8082                	ret
      if(n < target){
    80000252:	0009871b          	sext.w	a4,s3
    80000256:	fb677fe3          	bgeu	a4,s6,80000214 <consoleread+0xbe>
        cons.r--;
    8000025a:	00011717          	auipc	a4,0x11
    8000025e:	faf72f23          	sw	a5,-66(a4) # 80011218 <cons+0x98>
    80000262:	bf4d                	j	80000214 <consoleread+0xbe>

0000000080000264 <consputc>:
{
    80000264:	1141                	add	sp,sp,-16
    80000266:	e406                	sd	ra,8(sp)
    80000268:	e022                	sd	s0,0(sp)
    8000026a:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    8000026c:	10000793          	li	a5,256
    80000270:	00f50a63          	beq	a0,a5,80000284 <consputc+0x20>
    uartputc_sync(c);
    80000274:	00000097          	auipc	ra,0x0
    80000278:	560080e7          	jalr	1376(ra) # 800007d4 <uartputc_sync>
}
    8000027c:	60a2                	ld	ra,8(sp)
    8000027e:	6402                	ld	s0,0(sp)
    80000280:	0141                	add	sp,sp,16
    80000282:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000284:	4521                	li	a0,8
    80000286:	00000097          	auipc	ra,0x0
    8000028a:	54e080e7          	jalr	1358(ra) # 800007d4 <uartputc_sync>
    8000028e:	02000513          	li	a0,32
    80000292:	00000097          	auipc	ra,0x0
    80000296:	542080e7          	jalr	1346(ra) # 800007d4 <uartputc_sync>
    8000029a:	4521                	li	a0,8
    8000029c:	00000097          	auipc	ra,0x0
    800002a0:	538080e7          	jalr	1336(ra) # 800007d4 <uartputc_sync>
    800002a4:	bfe1                	j	8000027c <consputc+0x18>

00000000800002a6 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002a6:	1101                	add	sp,sp,-32
    800002a8:	ec06                	sd	ra,24(sp)
    800002aa:	e822                	sd	s0,16(sp)
    800002ac:	e426                	sd	s1,8(sp)
    800002ae:	e04a                	sd	s2,0(sp)
    800002b0:	1000                	add	s0,sp,32
    800002b2:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002b4:	00011517          	auipc	a0,0x11
    800002b8:	ecc50513          	add	a0,a0,-308 # 80011180 <cons>
    800002bc:	00001097          	auipc	ra,0x1
    800002c0:	902080e7          	jalr	-1790(ra) # 80000bbe <acquire>

  switch(c){
    800002c4:	47d5                	li	a5,21
    800002c6:	0af48663          	beq	s1,a5,80000372 <consoleintr+0xcc>
    800002ca:	0297ca63          	blt	a5,s1,800002fe <consoleintr+0x58>
    800002ce:	47a1                	li	a5,8
    800002d0:	0ef48763          	beq	s1,a5,800003be <consoleintr+0x118>
    800002d4:	47c1                	li	a5,16
    800002d6:	10f49a63          	bne	s1,a5,800003ea <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002da:	00002097          	auipc	ra,0x2
    800002de:	1e6080e7          	jalr	486(ra) # 800024c0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002e2:	00011517          	auipc	a0,0x11
    800002e6:	e9e50513          	add	a0,a0,-354 # 80011180 <cons>
    800002ea:	00001097          	auipc	ra,0x1
    800002ee:	988080e7          	jalr	-1656(ra) # 80000c72 <release>
}
    800002f2:	60e2                	ld	ra,24(sp)
    800002f4:	6442                	ld	s0,16(sp)
    800002f6:	64a2                	ld	s1,8(sp)
    800002f8:	6902                	ld	s2,0(sp)
    800002fa:	6105                	add	sp,sp,32
    800002fc:	8082                	ret
  switch(c){
    800002fe:	07f00793          	li	a5,127
    80000302:	0af48e63          	beq	s1,a5,800003be <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000306:	00011717          	auipc	a4,0x11
    8000030a:	e7a70713          	add	a4,a4,-390 # 80011180 <cons>
    8000030e:	0a072783          	lw	a5,160(a4)
    80000312:	09872703          	lw	a4,152(a4)
    80000316:	9f99                	subw	a5,a5,a4
    80000318:	07f00713          	li	a4,127
    8000031c:	fcf763e3          	bltu	a4,a5,800002e2 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000320:	47b5                	li	a5,13
    80000322:	0cf48763          	beq	s1,a5,800003f0 <consoleintr+0x14a>
      consputc(c);
    80000326:	8526                	mv	a0,s1
    80000328:	00000097          	auipc	ra,0x0
    8000032c:	f3c080e7          	jalr	-196(ra) # 80000264 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000330:	00011797          	auipc	a5,0x11
    80000334:	e5078793          	add	a5,a5,-432 # 80011180 <cons>
    80000338:	0a07a703          	lw	a4,160(a5)
    8000033c:	0017069b          	addw	a3,a4,1
    80000340:	0006861b          	sext.w	a2,a3
    80000344:	0ad7a023          	sw	a3,160(a5)
    80000348:	07f77713          	and	a4,a4,127
    8000034c:	97ba                	add	a5,a5,a4
    8000034e:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000352:	47a9                	li	a5,10
    80000354:	0cf48563          	beq	s1,a5,8000041e <consoleintr+0x178>
    80000358:	4791                	li	a5,4
    8000035a:	0cf48263          	beq	s1,a5,8000041e <consoleintr+0x178>
    8000035e:	00011797          	auipc	a5,0x11
    80000362:	eba7a783          	lw	a5,-326(a5) # 80011218 <cons+0x98>
    80000366:	0807879b          	addw	a5,a5,128
    8000036a:	f6f61ce3          	bne	a2,a5,800002e2 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000036e:	863e                	mv	a2,a5
    80000370:	a07d                	j	8000041e <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000372:	00011717          	auipc	a4,0x11
    80000376:	e0e70713          	add	a4,a4,-498 # 80011180 <cons>
    8000037a:	0a072783          	lw	a5,160(a4)
    8000037e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80000382:	00011497          	auipc	s1,0x11
    80000386:	dfe48493          	add	s1,s1,-514 # 80011180 <cons>
    while(cons.e != cons.w &&
    8000038a:	4929                	li	s2,10
    8000038c:	f4f70be3          	beq	a4,a5,800002e2 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80000390:	37fd                	addw	a5,a5,-1
    80000392:	07f7f713          	and	a4,a5,127
    80000396:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000398:	01874703          	lbu	a4,24(a4)
    8000039c:	f52703e3          	beq	a4,s2,800002e2 <consoleintr+0x3c>
      cons.e--;
    800003a0:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003a4:	10000513          	li	a0,256
    800003a8:	00000097          	auipc	ra,0x0
    800003ac:	ebc080e7          	jalr	-324(ra) # 80000264 <consputc>
    while(cons.e != cons.w &&
    800003b0:	0a04a783          	lw	a5,160(s1)
    800003b4:	09c4a703          	lw	a4,156(s1)
    800003b8:	fcf71ce3          	bne	a4,a5,80000390 <consoleintr+0xea>
    800003bc:	b71d                	j	800002e2 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003be:	00011717          	auipc	a4,0x11
    800003c2:	dc270713          	add	a4,a4,-574 # 80011180 <cons>
    800003c6:	0a072783          	lw	a5,160(a4)
    800003ca:	09c72703          	lw	a4,156(a4)
    800003ce:	f0f70ae3          	beq	a4,a5,800002e2 <consoleintr+0x3c>
      cons.e--;
    800003d2:	37fd                	addw	a5,a5,-1
    800003d4:	00011717          	auipc	a4,0x11
    800003d8:	e4f72623          	sw	a5,-436(a4) # 80011220 <cons+0xa0>
      consputc(BACKSPACE);
    800003dc:	10000513          	li	a0,256
    800003e0:	00000097          	auipc	ra,0x0
    800003e4:	e84080e7          	jalr	-380(ra) # 80000264 <consputc>
    800003e8:	bded                	j	800002e2 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800003ea:	ee048ce3          	beqz	s1,800002e2 <consoleintr+0x3c>
    800003ee:	bf21                	j	80000306 <consoleintr+0x60>
      consputc(c);
    800003f0:	4529                	li	a0,10
    800003f2:	00000097          	auipc	ra,0x0
    800003f6:	e72080e7          	jalr	-398(ra) # 80000264 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800003fa:	00011797          	auipc	a5,0x11
    800003fe:	d8678793          	add	a5,a5,-634 # 80011180 <cons>
    80000402:	0a07a703          	lw	a4,160(a5)
    80000406:	0017069b          	addw	a3,a4,1
    8000040a:	0006861b          	sext.w	a2,a3
    8000040e:	0ad7a023          	sw	a3,160(a5)
    80000412:	07f77713          	and	a4,a4,127
    80000416:	97ba                	add	a5,a5,a4
    80000418:	4729                	li	a4,10
    8000041a:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000041e:	00011797          	auipc	a5,0x11
    80000422:	dec7af23          	sw	a2,-514(a5) # 8001121c <cons+0x9c>
        wakeup(&cons.r);
    80000426:	00011517          	auipc	a0,0x11
    8000042a:	df250513          	add	a0,a0,-526 # 80011218 <cons+0x98>
    8000042e:	00002097          	auipc	ra,0x2
    80000432:	f0c080e7          	jalr	-244(ra) # 8000233a <wakeup>
    80000436:	b575                	j	800002e2 <consoleintr+0x3c>

0000000080000438 <consoleinit>:

void
consoleinit(void)
{
    80000438:	1141                	add	sp,sp,-16
    8000043a:	e406                	sd	ra,8(sp)
    8000043c:	e022                	sd	s0,0(sp)
    8000043e:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    80000440:	00008597          	auipc	a1,0x8
    80000444:	bd058593          	add	a1,a1,-1072 # 80008010 <etext+0x10>
    80000448:	00011517          	auipc	a0,0x11
    8000044c:	d3850513          	add	a0,a0,-712 # 80011180 <cons>
    80000450:	00000097          	auipc	ra,0x0
    80000454:	6de080e7          	jalr	1758(ra) # 80000b2e <initlock>

  uartinit();
    80000458:	00000097          	auipc	ra,0x0
    8000045c:	32c080e7          	jalr	812(ra) # 80000784 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000460:	0001c797          	auipc	a5,0x1c
    80000464:	2b078793          	add	a5,a5,688 # 8001c710 <devsw>
    80000468:	00000717          	auipc	a4,0x0
    8000046c:	cee70713          	add	a4,a4,-786 # 80000156 <consoleread>
    80000470:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000472:	00000717          	auipc	a4,0x0
    80000476:	c8070713          	add	a4,a4,-896 # 800000f2 <consolewrite>
    8000047a:	ef98                	sd	a4,24(a5)
}
    8000047c:	60a2                	ld	ra,8(sp)
    8000047e:	6402                	ld	s0,0(sp)
    80000480:	0141                	add	sp,sp,16
    80000482:	8082                	ret

0000000080000484 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80000484:	7179                	add	sp,sp,-48
    80000486:	f406                	sd	ra,40(sp)
    80000488:	f022                	sd	s0,32(sp)
    8000048a:	ec26                	sd	s1,24(sp)
    8000048c:	e84a                	sd	s2,16(sp)
    8000048e:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80000490:	c219                	beqz	a2,80000496 <printint+0x12>
    80000492:	08054763          	bltz	a0,80000520 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80000496:	2501                	sext.w	a0,a0
    80000498:	4881                	li	a7,0
    8000049a:	fd040693          	add	a3,s0,-48

  i = 0;
    8000049e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004a0:	2581                	sext.w	a1,a1
    800004a2:	00008617          	auipc	a2,0x8
    800004a6:	b9e60613          	add	a2,a2,-1122 # 80008040 <digits>
    800004aa:	883a                	mv	a6,a4
    800004ac:	2705                	addw	a4,a4,1
    800004ae:	02b577bb          	remuw	a5,a0,a1
    800004b2:	1782                	sll	a5,a5,0x20
    800004b4:	9381                	srl	a5,a5,0x20
    800004b6:	97b2                	add	a5,a5,a2
    800004b8:	0007c783          	lbu	a5,0(a5)
    800004bc:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004c0:	0005079b          	sext.w	a5,a0
    800004c4:	02b5553b          	divuw	a0,a0,a1
    800004c8:	0685                	add	a3,a3,1
    800004ca:	feb7f0e3          	bgeu	a5,a1,800004aa <printint+0x26>

  if(sign)
    800004ce:	00088c63          	beqz	a7,800004e6 <printint+0x62>
    buf[i++] = '-';
    800004d2:	fe070793          	add	a5,a4,-32
    800004d6:	00878733          	add	a4,a5,s0
    800004da:	02d00793          	li	a5,45
    800004de:	fef70823          	sb	a5,-16(a4)
    800004e2:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    800004e6:	02e05763          	blez	a4,80000514 <printint+0x90>
    800004ea:	fd040793          	add	a5,s0,-48
    800004ee:	00e784b3          	add	s1,a5,a4
    800004f2:	fff78913          	add	s2,a5,-1
    800004f6:	993a                	add	s2,s2,a4
    800004f8:	377d                	addw	a4,a4,-1
    800004fa:	1702                	sll	a4,a4,0x20
    800004fc:	9301                	srl	a4,a4,0x20
    800004fe:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000502:	fff4c503          	lbu	a0,-1(s1)
    80000506:	00000097          	auipc	ra,0x0
    8000050a:	d5e080e7          	jalr	-674(ra) # 80000264 <consputc>
  while(--i >= 0)
    8000050e:	14fd                	add	s1,s1,-1
    80000510:	ff2499e3          	bne	s1,s2,80000502 <printint+0x7e>
}
    80000514:	70a2                	ld	ra,40(sp)
    80000516:	7402                	ld	s0,32(sp)
    80000518:	64e2                	ld	s1,24(sp)
    8000051a:	6942                	ld	s2,16(sp)
    8000051c:	6145                	add	sp,sp,48
    8000051e:	8082                	ret
    x = -xx;
    80000520:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000524:	4885                	li	a7,1
    x = -xx;
    80000526:	bf95                	j	8000049a <printint+0x16>

0000000080000528 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000528:	1101                	add	sp,sp,-32
    8000052a:	ec06                	sd	ra,24(sp)
    8000052c:	e822                	sd	s0,16(sp)
    8000052e:	e426                	sd	s1,8(sp)
    80000530:	1000                	add	s0,sp,32
    80000532:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000534:	00011797          	auipc	a5,0x11
    80000538:	d007a623          	sw	zero,-756(a5) # 80011240 <pr+0x18>
  printf("panic: ");
    8000053c:	00008517          	auipc	a0,0x8
    80000540:	adc50513          	add	a0,a0,-1316 # 80008018 <etext+0x18>
    80000544:	00000097          	auipc	ra,0x0
    80000548:	02e080e7          	jalr	46(ra) # 80000572 <printf>
  printf(s);
    8000054c:	8526                	mv	a0,s1
    8000054e:	00000097          	auipc	ra,0x0
    80000552:	024080e7          	jalr	36(ra) # 80000572 <printf>
  printf("\n");
    80000556:	00008517          	auipc	a0,0x8
    8000055a:	b7250513          	add	a0,a0,-1166 # 800080c8 <digits+0x88>
    8000055e:	00000097          	auipc	ra,0x0
    80000562:	014080e7          	jalr	20(ra) # 80000572 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000566:	4785                	li	a5,1
    80000568:	00009717          	auipc	a4,0x9
    8000056c:	a8f72c23          	sw	a5,-1384(a4) # 80009000 <panicked>
  for(;;)
    80000570:	a001                	j	80000570 <panic+0x48>

0000000080000572 <printf>:
{
    80000572:	7131                	add	sp,sp,-192
    80000574:	fc86                	sd	ra,120(sp)
    80000576:	f8a2                	sd	s0,112(sp)
    80000578:	f4a6                	sd	s1,104(sp)
    8000057a:	f0ca                	sd	s2,96(sp)
    8000057c:	ecce                	sd	s3,88(sp)
    8000057e:	e8d2                	sd	s4,80(sp)
    80000580:	e4d6                	sd	s5,72(sp)
    80000582:	e0da                	sd	s6,64(sp)
    80000584:	fc5e                	sd	s7,56(sp)
    80000586:	f862                	sd	s8,48(sp)
    80000588:	f466                	sd	s9,40(sp)
    8000058a:	f06a                	sd	s10,32(sp)
    8000058c:	ec6e                	sd	s11,24(sp)
    8000058e:	0100                	add	s0,sp,128
    80000590:	8a2a                	mv	s4,a0
    80000592:	e40c                	sd	a1,8(s0)
    80000594:	e810                	sd	a2,16(s0)
    80000596:	ec14                	sd	a3,24(s0)
    80000598:	f018                	sd	a4,32(s0)
    8000059a:	f41c                	sd	a5,40(s0)
    8000059c:	03043823          	sd	a6,48(s0)
    800005a0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005a4:	00011d97          	auipc	s11,0x11
    800005a8:	c9cdad83          	lw	s11,-868(s11) # 80011240 <pr+0x18>
  if(locking)
    800005ac:	020d9b63          	bnez	s11,800005e2 <printf+0x70>
  if (fmt == 0)
    800005b0:	040a0263          	beqz	s4,800005f4 <printf+0x82>
  va_start(ap, fmt);
    800005b4:	00840793          	add	a5,s0,8
    800005b8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005bc:	000a4503          	lbu	a0,0(s4)
    800005c0:	14050f63          	beqz	a0,8000071e <printf+0x1ac>
    800005c4:	4981                	li	s3,0
    if(c != '%'){
    800005c6:	02500a93          	li	s5,37
    switch(c){
    800005ca:	07000b93          	li	s7,112
  consputc('x');
    800005ce:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005d0:	00008b17          	auipc	s6,0x8
    800005d4:	a70b0b13          	add	s6,s6,-1424 # 80008040 <digits>
    switch(c){
    800005d8:	07300c93          	li	s9,115
    800005dc:	06400c13          	li	s8,100
    800005e0:	a82d                	j	8000061a <printf+0xa8>
    acquire(&pr.lock);
    800005e2:	00011517          	auipc	a0,0x11
    800005e6:	c4650513          	add	a0,a0,-954 # 80011228 <pr>
    800005ea:	00000097          	auipc	ra,0x0
    800005ee:	5d4080e7          	jalr	1492(ra) # 80000bbe <acquire>
    800005f2:	bf7d                	j	800005b0 <printf+0x3e>
    panic("null fmt");
    800005f4:	00008517          	auipc	a0,0x8
    800005f8:	a3450513          	add	a0,a0,-1484 # 80008028 <etext+0x28>
    800005fc:	00000097          	auipc	ra,0x0
    80000600:	f2c080e7          	jalr	-212(ra) # 80000528 <panic>
      consputc(c);
    80000604:	00000097          	auipc	ra,0x0
    80000608:	c60080e7          	jalr	-928(ra) # 80000264 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000060c:	2985                	addw	s3,s3,1
    8000060e:	013a07b3          	add	a5,s4,s3
    80000612:	0007c503          	lbu	a0,0(a5)
    80000616:	10050463          	beqz	a0,8000071e <printf+0x1ac>
    if(c != '%'){
    8000061a:	ff5515e3          	bne	a0,s5,80000604 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000061e:	2985                	addw	s3,s3,1
    80000620:	013a07b3          	add	a5,s4,s3
    80000624:	0007c783          	lbu	a5,0(a5)
    80000628:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000062c:	cbed                	beqz	a5,8000071e <printf+0x1ac>
    switch(c){
    8000062e:	05778a63          	beq	a5,s7,80000682 <printf+0x110>
    80000632:	02fbf663          	bgeu	s7,a5,8000065e <printf+0xec>
    80000636:	09978863          	beq	a5,s9,800006c6 <printf+0x154>
    8000063a:	07800713          	li	a4,120
    8000063e:	0ce79563          	bne	a5,a4,80000708 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000642:	f8843783          	ld	a5,-120(s0)
    80000646:	00878713          	add	a4,a5,8
    8000064a:	f8e43423          	sd	a4,-120(s0)
    8000064e:	4605                	li	a2,1
    80000650:	85ea                	mv	a1,s10
    80000652:	4388                	lw	a0,0(a5)
    80000654:	00000097          	auipc	ra,0x0
    80000658:	e30080e7          	jalr	-464(ra) # 80000484 <printint>
      break;
    8000065c:	bf45                	j	8000060c <printf+0x9a>
    switch(c){
    8000065e:	09578f63          	beq	a5,s5,800006fc <printf+0x18a>
    80000662:	0b879363          	bne	a5,s8,80000708 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80000666:	f8843783          	ld	a5,-120(s0)
    8000066a:	00878713          	add	a4,a5,8
    8000066e:	f8e43423          	sd	a4,-120(s0)
    80000672:	4605                	li	a2,1
    80000674:	45a9                	li	a1,10
    80000676:	4388                	lw	a0,0(a5)
    80000678:	00000097          	auipc	ra,0x0
    8000067c:	e0c080e7          	jalr	-500(ra) # 80000484 <printint>
      break;
    80000680:	b771                	j	8000060c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000682:	f8843783          	ld	a5,-120(s0)
    80000686:	00878713          	add	a4,a5,8
    8000068a:	f8e43423          	sd	a4,-120(s0)
    8000068e:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80000692:	03000513          	li	a0,48
    80000696:	00000097          	auipc	ra,0x0
    8000069a:	bce080e7          	jalr	-1074(ra) # 80000264 <consputc>
  consputc('x');
    8000069e:	07800513          	li	a0,120
    800006a2:	00000097          	auipc	ra,0x0
    800006a6:	bc2080e7          	jalr	-1086(ra) # 80000264 <consputc>
    800006aa:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006ac:	03c95793          	srl	a5,s2,0x3c
    800006b0:	97da                	add	a5,a5,s6
    800006b2:	0007c503          	lbu	a0,0(a5)
    800006b6:	00000097          	auipc	ra,0x0
    800006ba:	bae080e7          	jalr	-1106(ra) # 80000264 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006be:	0912                	sll	s2,s2,0x4
    800006c0:	34fd                	addw	s1,s1,-1
    800006c2:	f4ed                	bnez	s1,800006ac <printf+0x13a>
    800006c4:	b7a1                	j	8000060c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006c6:	f8843783          	ld	a5,-120(s0)
    800006ca:	00878713          	add	a4,a5,8
    800006ce:	f8e43423          	sd	a4,-120(s0)
    800006d2:	6384                	ld	s1,0(a5)
    800006d4:	cc89                	beqz	s1,800006ee <printf+0x17c>
      for(; *s; s++)
    800006d6:	0004c503          	lbu	a0,0(s1)
    800006da:	d90d                	beqz	a0,8000060c <printf+0x9a>
        consputc(*s);
    800006dc:	00000097          	auipc	ra,0x0
    800006e0:	b88080e7          	jalr	-1144(ra) # 80000264 <consputc>
      for(; *s; s++)
    800006e4:	0485                	add	s1,s1,1
    800006e6:	0004c503          	lbu	a0,0(s1)
    800006ea:	f96d                	bnez	a0,800006dc <printf+0x16a>
    800006ec:	b705                	j	8000060c <printf+0x9a>
        s = "(null)";
    800006ee:	00008497          	auipc	s1,0x8
    800006f2:	93248493          	add	s1,s1,-1742 # 80008020 <etext+0x20>
      for(; *s; s++)
    800006f6:	02800513          	li	a0,40
    800006fa:	b7cd                	j	800006dc <printf+0x16a>
      consputc('%');
    800006fc:	8556                	mv	a0,s5
    800006fe:	00000097          	auipc	ra,0x0
    80000702:	b66080e7          	jalr	-1178(ra) # 80000264 <consputc>
      break;
    80000706:	b719                	j	8000060c <printf+0x9a>
      consputc('%');
    80000708:	8556                	mv	a0,s5
    8000070a:	00000097          	auipc	ra,0x0
    8000070e:	b5a080e7          	jalr	-1190(ra) # 80000264 <consputc>
      consputc(c);
    80000712:	8526                	mv	a0,s1
    80000714:	00000097          	auipc	ra,0x0
    80000718:	b50080e7          	jalr	-1200(ra) # 80000264 <consputc>
      break;
    8000071c:	bdc5                	j	8000060c <printf+0x9a>
  if(locking)
    8000071e:	020d9163          	bnez	s11,80000740 <printf+0x1ce>
}
    80000722:	70e6                	ld	ra,120(sp)
    80000724:	7446                	ld	s0,112(sp)
    80000726:	74a6                	ld	s1,104(sp)
    80000728:	7906                	ld	s2,96(sp)
    8000072a:	69e6                	ld	s3,88(sp)
    8000072c:	6a46                	ld	s4,80(sp)
    8000072e:	6aa6                	ld	s5,72(sp)
    80000730:	6b06                	ld	s6,64(sp)
    80000732:	7be2                	ld	s7,56(sp)
    80000734:	7c42                	ld	s8,48(sp)
    80000736:	7ca2                	ld	s9,40(sp)
    80000738:	7d02                	ld	s10,32(sp)
    8000073a:	6de2                	ld	s11,24(sp)
    8000073c:	6129                	add	sp,sp,192
    8000073e:	8082                	ret
    release(&pr.lock);
    80000740:	00011517          	auipc	a0,0x11
    80000744:	ae850513          	add	a0,a0,-1304 # 80011228 <pr>
    80000748:	00000097          	auipc	ra,0x0
    8000074c:	52a080e7          	jalr	1322(ra) # 80000c72 <release>
}
    80000750:	bfc9                	j	80000722 <printf+0x1b0>

0000000080000752 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000752:	1101                	add	sp,sp,-32
    80000754:	ec06                	sd	ra,24(sp)
    80000756:	e822                	sd	s0,16(sp)
    80000758:	e426                	sd	s1,8(sp)
    8000075a:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    8000075c:	00011497          	auipc	s1,0x11
    80000760:	acc48493          	add	s1,s1,-1332 # 80011228 <pr>
    80000764:	00008597          	auipc	a1,0x8
    80000768:	8d458593          	add	a1,a1,-1836 # 80008038 <etext+0x38>
    8000076c:	8526                	mv	a0,s1
    8000076e:	00000097          	auipc	ra,0x0
    80000772:	3c0080e7          	jalr	960(ra) # 80000b2e <initlock>
  pr.locking = 1;
    80000776:	4785                	li	a5,1
    80000778:	cc9c                	sw	a5,24(s1)
}
    8000077a:	60e2                	ld	ra,24(sp)
    8000077c:	6442                	ld	s0,16(sp)
    8000077e:	64a2                	ld	s1,8(sp)
    80000780:	6105                	add	sp,sp,32
    80000782:	8082                	ret

0000000080000784 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000784:	1141                	add	sp,sp,-16
    80000786:	e406                	sd	ra,8(sp)
    80000788:	e022                	sd	s0,0(sp)
    8000078a:	0800                	add	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000078c:	100007b7          	lui	a5,0x10000
    80000790:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000794:	f8000713          	li	a4,-128
    80000798:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000079c:	470d                	li	a4,3
    8000079e:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007a2:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007a6:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007aa:	469d                	li	a3,7
    800007ac:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007b0:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007b4:	00008597          	auipc	a1,0x8
    800007b8:	8a458593          	add	a1,a1,-1884 # 80008058 <digits+0x18>
    800007bc:	00011517          	auipc	a0,0x11
    800007c0:	a8c50513          	add	a0,a0,-1396 # 80011248 <uart_tx_lock>
    800007c4:	00000097          	auipc	ra,0x0
    800007c8:	36a080e7          	jalr	874(ra) # 80000b2e <initlock>
}
    800007cc:	60a2                	ld	ra,8(sp)
    800007ce:	6402                	ld	s0,0(sp)
    800007d0:	0141                	add	sp,sp,16
    800007d2:	8082                	ret

00000000800007d4 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007d4:	1101                	add	sp,sp,-32
    800007d6:	ec06                	sd	ra,24(sp)
    800007d8:	e822                	sd	s0,16(sp)
    800007da:	e426                	sd	s1,8(sp)
    800007dc:	1000                	add	s0,sp,32
    800007de:	84aa                	mv	s1,a0
  push_off();
    800007e0:	00000097          	auipc	ra,0x0
    800007e4:	392080e7          	jalr	914(ra) # 80000b72 <push_off>

  if(panicked){
    800007e8:	00009797          	auipc	a5,0x9
    800007ec:	8187a783          	lw	a5,-2024(a5) # 80009000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800007f0:	10000737          	lui	a4,0x10000
  if(panicked){
    800007f4:	c391                	beqz	a5,800007f8 <uartputc_sync+0x24>
    for(;;)
    800007f6:	a001                	j	800007f6 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800007f8:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800007fc:	0207f793          	and	a5,a5,32
    80000800:	dfe5                	beqz	a5,800007f8 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000802:	0ff4f513          	zext.b	a0,s1
    80000806:	100007b7          	lui	a5,0x10000
    8000080a:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000080e:	00000097          	auipc	ra,0x0
    80000812:	404080e7          	jalr	1028(ra) # 80000c12 <pop_off>
}
    80000816:	60e2                	ld	ra,24(sp)
    80000818:	6442                	ld	s0,16(sp)
    8000081a:	64a2                	ld	s1,8(sp)
    8000081c:	6105                	add	sp,sp,32
    8000081e:	8082                	ret

0000000080000820 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000820:	00008797          	auipc	a5,0x8
    80000824:	7e87b783          	ld	a5,2024(a5) # 80009008 <uart_tx_r>
    80000828:	00008717          	auipc	a4,0x8
    8000082c:	7e873703          	ld	a4,2024(a4) # 80009010 <uart_tx_w>
    80000830:	06f70a63          	beq	a4,a5,800008a4 <uartstart+0x84>
{
    80000834:	7139                	add	sp,sp,-64
    80000836:	fc06                	sd	ra,56(sp)
    80000838:	f822                	sd	s0,48(sp)
    8000083a:	f426                	sd	s1,40(sp)
    8000083c:	f04a                	sd	s2,32(sp)
    8000083e:	ec4e                	sd	s3,24(sp)
    80000840:	e852                	sd	s4,16(sp)
    80000842:	e456                	sd	s5,8(sp)
    80000844:	0080                	add	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000846:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000084a:	00011a17          	auipc	s4,0x11
    8000084e:	9fea0a13          	add	s4,s4,-1538 # 80011248 <uart_tx_lock>
    uart_tx_r += 1;
    80000852:	00008497          	auipc	s1,0x8
    80000856:	7b648493          	add	s1,s1,1974 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000085a:	00008997          	auipc	s3,0x8
    8000085e:	7b698993          	add	s3,s3,1974 # 80009010 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000862:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000866:	02077713          	and	a4,a4,32
    8000086a:	c705                	beqz	a4,80000892 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000086c:	01f7f713          	and	a4,a5,31
    80000870:	9752                	add	a4,a4,s4
    80000872:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80000876:	0785                	add	a5,a5,1
    80000878:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000087a:	8526                	mv	a0,s1
    8000087c:	00002097          	auipc	ra,0x2
    80000880:	abe080e7          	jalr	-1346(ra) # 8000233a <wakeup>
    
    WriteReg(THR, c);
    80000884:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80000888:	609c                	ld	a5,0(s1)
    8000088a:	0009b703          	ld	a4,0(s3)
    8000088e:	fcf71ae3          	bne	a4,a5,80000862 <uartstart+0x42>
  }
}
    80000892:	70e2                	ld	ra,56(sp)
    80000894:	7442                	ld	s0,48(sp)
    80000896:	74a2                	ld	s1,40(sp)
    80000898:	7902                	ld	s2,32(sp)
    8000089a:	69e2                	ld	s3,24(sp)
    8000089c:	6a42                	ld	s4,16(sp)
    8000089e:	6aa2                	ld	s5,8(sp)
    800008a0:	6121                	add	sp,sp,64
    800008a2:	8082                	ret
    800008a4:	8082                	ret

00000000800008a6 <uartputc>:
{
    800008a6:	7179                	add	sp,sp,-48
    800008a8:	f406                	sd	ra,40(sp)
    800008aa:	f022                	sd	s0,32(sp)
    800008ac:	ec26                	sd	s1,24(sp)
    800008ae:	e84a                	sd	s2,16(sp)
    800008b0:	e44e                	sd	s3,8(sp)
    800008b2:	e052                	sd	s4,0(sp)
    800008b4:	1800                	add	s0,sp,48
    800008b6:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008b8:	00011517          	auipc	a0,0x11
    800008bc:	99050513          	add	a0,a0,-1648 # 80011248 <uart_tx_lock>
    800008c0:	00000097          	auipc	ra,0x0
    800008c4:	2fe080e7          	jalr	766(ra) # 80000bbe <acquire>
  if(panicked){
    800008c8:	00008797          	auipc	a5,0x8
    800008cc:	7387a783          	lw	a5,1848(a5) # 80009000 <panicked>
    800008d0:	c391                	beqz	a5,800008d4 <uartputc+0x2e>
    for(;;)
    800008d2:	a001                	j	800008d2 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008d4:	00008717          	auipc	a4,0x8
    800008d8:	73c73703          	ld	a4,1852(a4) # 80009010 <uart_tx_w>
    800008dc:	00008797          	auipc	a5,0x8
    800008e0:	72c7b783          	ld	a5,1836(a5) # 80009008 <uart_tx_r>
    800008e4:	02078793          	add	a5,a5,32
    800008e8:	02e79b63          	bne	a5,a4,8000091e <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800008ec:	00011997          	auipc	s3,0x11
    800008f0:	95c98993          	add	s3,s3,-1700 # 80011248 <uart_tx_lock>
    800008f4:	00008497          	auipc	s1,0x8
    800008f8:	71448493          	add	s1,s1,1812 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008fc:	00008917          	auipc	s2,0x8
    80000900:	71490913          	add	s2,s2,1812 # 80009010 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000904:	85ce                	mv	a1,s3
    80000906:	8526                	mv	a0,s1
    80000908:	00002097          	auipc	ra,0x2
    8000090c:	8b2080e7          	jalr	-1870(ra) # 800021ba <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000910:	00093703          	ld	a4,0(s2)
    80000914:	609c                	ld	a5,0(s1)
    80000916:	02078793          	add	a5,a5,32
    8000091a:	fee785e3          	beq	a5,a4,80000904 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000091e:	00011497          	auipc	s1,0x11
    80000922:	92a48493          	add	s1,s1,-1750 # 80011248 <uart_tx_lock>
    80000926:	01f77793          	and	a5,a4,31
    8000092a:	97a6                	add	a5,a5,s1
    8000092c:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80000930:	0705                	add	a4,a4,1
    80000932:	00008797          	auipc	a5,0x8
    80000936:	6ce7bf23          	sd	a4,1758(a5) # 80009010 <uart_tx_w>
      uartstart();
    8000093a:	00000097          	auipc	ra,0x0
    8000093e:	ee6080e7          	jalr	-282(ra) # 80000820 <uartstart>
      release(&uart_tx_lock);
    80000942:	8526                	mv	a0,s1
    80000944:	00000097          	auipc	ra,0x0
    80000948:	32e080e7          	jalr	814(ra) # 80000c72 <release>
}
    8000094c:	70a2                	ld	ra,40(sp)
    8000094e:	7402                	ld	s0,32(sp)
    80000950:	64e2                	ld	s1,24(sp)
    80000952:	6942                	ld	s2,16(sp)
    80000954:	69a2                	ld	s3,8(sp)
    80000956:	6a02                	ld	s4,0(sp)
    80000958:	6145                	add	sp,sp,48
    8000095a:	8082                	ret

000000008000095c <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000095c:	1141                	add	sp,sp,-16
    8000095e:	e422                	sd	s0,8(sp)
    80000960:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000962:	100007b7          	lui	a5,0x10000
    80000966:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000096a:	8b85                	and	a5,a5,1
    8000096c:	cb81                	beqz	a5,8000097c <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    8000096e:	100007b7          	lui	a5,0x10000
    80000972:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000976:	6422                	ld	s0,8(sp)
    80000978:	0141                	add	sp,sp,16
    8000097a:	8082                	ret
    return -1;
    8000097c:	557d                	li	a0,-1
    8000097e:	bfe5                	j	80000976 <uartgetc+0x1a>

0000000080000980 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80000980:	1101                	add	sp,sp,-32
    80000982:	ec06                	sd	ra,24(sp)
    80000984:	e822                	sd	s0,16(sp)
    80000986:	e426                	sd	s1,8(sp)
    80000988:	1000                	add	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000098a:	54fd                	li	s1,-1
    8000098c:	a029                	j	80000996 <uartintr+0x16>
      break;
    consoleintr(c);
    8000098e:	00000097          	auipc	ra,0x0
    80000992:	918080e7          	jalr	-1768(ra) # 800002a6 <consoleintr>
    int c = uartgetc();
    80000996:	00000097          	auipc	ra,0x0
    8000099a:	fc6080e7          	jalr	-58(ra) # 8000095c <uartgetc>
    if(c == -1)
    8000099e:	fe9518e3          	bne	a0,s1,8000098e <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009a2:	00011497          	auipc	s1,0x11
    800009a6:	8a648493          	add	s1,s1,-1882 # 80011248 <uart_tx_lock>
    800009aa:	8526                	mv	a0,s1
    800009ac:	00000097          	auipc	ra,0x0
    800009b0:	212080e7          	jalr	530(ra) # 80000bbe <acquire>
  uartstart();
    800009b4:	00000097          	auipc	ra,0x0
    800009b8:	e6c080e7          	jalr	-404(ra) # 80000820 <uartstart>
  release(&uart_tx_lock);
    800009bc:	8526                	mv	a0,s1
    800009be:	00000097          	auipc	ra,0x0
    800009c2:	2b4080e7          	jalr	692(ra) # 80000c72 <release>
}
    800009c6:	60e2                	ld	ra,24(sp)
    800009c8:	6442                	ld	s0,16(sp)
    800009ca:	64a2                	ld	s1,8(sp)
    800009cc:	6105                	add	sp,sp,32
    800009ce:	8082                	ret

00000000800009d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009d0:	1101                	add	sp,sp,-32
    800009d2:	ec06                	sd	ra,24(sp)
    800009d4:	e822                	sd	s0,16(sp)
    800009d6:	e426                	sd	s1,8(sp)
    800009d8:	e04a                	sd	s2,0(sp)
    800009da:	1000                	add	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009dc:	03451793          	sll	a5,a0,0x34
    800009e0:	ebb9                	bnez	a5,80000a36 <kfree+0x66>
    800009e2:	84aa                	mv	s1,a0
    800009e4:	00020797          	auipc	a5,0x20
    800009e8:	61c78793          	add	a5,a5,1564 # 80021000 <end>
    800009ec:	04f56563          	bltu	a0,a5,80000a36 <kfree+0x66>
    800009f0:	47c5                	li	a5,17
    800009f2:	07ee                	sll	a5,a5,0x1b
    800009f4:	04f57163          	bgeu	a0,a5,80000a36 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    800009f8:	6605                	lui	a2,0x1
    800009fa:	4585                	li	a1,1
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	2be080e7          	jalr	702(ra) # 80000cba <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a04:	00011917          	auipc	s2,0x11
    80000a08:	87c90913          	add	s2,s2,-1924 # 80011280 <kmem>
    80000a0c:	854a                	mv	a0,s2
    80000a0e:	00000097          	auipc	ra,0x0
    80000a12:	1b0080e7          	jalr	432(ra) # 80000bbe <acquire>
  r->next = kmem.freelist;
    80000a16:	01893783          	ld	a5,24(s2)
    80000a1a:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a1c:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a20:	854a                	mv	a0,s2
    80000a22:	00000097          	auipc	ra,0x0
    80000a26:	250080e7          	jalr	592(ra) # 80000c72 <release>
}
    80000a2a:	60e2                	ld	ra,24(sp)
    80000a2c:	6442                	ld	s0,16(sp)
    80000a2e:	64a2                	ld	s1,8(sp)
    80000a30:	6902                	ld	s2,0(sp)
    80000a32:	6105                	add	sp,sp,32
    80000a34:	8082                	ret
    panic("kfree");
    80000a36:	00007517          	auipc	a0,0x7
    80000a3a:	62a50513          	add	a0,a0,1578 # 80008060 <digits+0x20>
    80000a3e:	00000097          	auipc	ra,0x0
    80000a42:	aea080e7          	jalr	-1302(ra) # 80000528 <panic>

0000000080000a46 <freerange>:
{
    80000a46:	7179                	add	sp,sp,-48
    80000a48:	f406                	sd	ra,40(sp)
    80000a4a:	f022                	sd	s0,32(sp)
    80000a4c:	ec26                	sd	s1,24(sp)
    80000a4e:	e84a                	sd	s2,16(sp)
    80000a50:	e44e                	sd	s3,8(sp)
    80000a52:	e052                	sd	s4,0(sp)
    80000a54:	1800                	add	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a56:	6785                	lui	a5,0x1
    80000a58:	fff78713          	add	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a5c:	00e504b3          	add	s1,a0,a4
    80000a60:	777d                	lui	a4,0xfffff
    80000a62:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a64:	94be                	add	s1,s1,a5
    80000a66:	0095ee63          	bltu	a1,s1,80000a82 <freerange+0x3c>
    80000a6a:	892e                	mv	s2,a1
    kfree(p);
    80000a6c:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a6e:	6985                	lui	s3,0x1
    kfree(p);
    80000a70:	01448533          	add	a0,s1,s4
    80000a74:	00000097          	auipc	ra,0x0
    80000a78:	f5c080e7          	jalr	-164(ra) # 800009d0 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a7c:	94ce                	add	s1,s1,s3
    80000a7e:	fe9979e3          	bgeu	s2,s1,80000a70 <freerange+0x2a>
}
    80000a82:	70a2                	ld	ra,40(sp)
    80000a84:	7402                	ld	s0,32(sp)
    80000a86:	64e2                	ld	s1,24(sp)
    80000a88:	6942                	ld	s2,16(sp)
    80000a8a:	69a2                	ld	s3,8(sp)
    80000a8c:	6a02                	ld	s4,0(sp)
    80000a8e:	6145                	add	sp,sp,48
    80000a90:	8082                	ret

0000000080000a92 <kinit>:
{
    80000a92:	1141                	add	sp,sp,-16
    80000a94:	e406                	sd	ra,8(sp)
    80000a96:	e022                	sd	s0,0(sp)
    80000a98:	0800                	add	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000a9a:	00007597          	auipc	a1,0x7
    80000a9e:	5ce58593          	add	a1,a1,1486 # 80008068 <digits+0x28>
    80000aa2:	00010517          	auipc	a0,0x10
    80000aa6:	7de50513          	add	a0,a0,2014 # 80011280 <kmem>
    80000aaa:	00000097          	auipc	ra,0x0
    80000aae:	084080e7          	jalr	132(ra) # 80000b2e <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ab2:	45c5                	li	a1,17
    80000ab4:	05ee                	sll	a1,a1,0x1b
    80000ab6:	00020517          	auipc	a0,0x20
    80000aba:	54a50513          	add	a0,a0,1354 # 80021000 <end>
    80000abe:	00000097          	auipc	ra,0x0
    80000ac2:	f88080e7          	jalr	-120(ra) # 80000a46 <freerange>
}
    80000ac6:	60a2                	ld	ra,8(sp)
    80000ac8:	6402                	ld	s0,0(sp)
    80000aca:	0141                	add	sp,sp,16
    80000acc:	8082                	ret

0000000080000ace <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ace:	1101                	add	sp,sp,-32
    80000ad0:	ec06                	sd	ra,24(sp)
    80000ad2:	e822                	sd	s0,16(sp)
    80000ad4:	e426                	sd	s1,8(sp)
    80000ad6:	1000                	add	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000ad8:	00010497          	auipc	s1,0x10
    80000adc:	7a848493          	add	s1,s1,1960 # 80011280 <kmem>
    80000ae0:	8526                	mv	a0,s1
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	0dc080e7          	jalr	220(ra) # 80000bbe <acquire>
  r = kmem.freelist;
    80000aea:	6c84                	ld	s1,24(s1)
  if(r)
    80000aec:	c885                	beqz	s1,80000b1c <kalloc+0x4e>
    kmem.freelist = r->next;
    80000aee:	609c                	ld	a5,0(s1)
    80000af0:	00010517          	auipc	a0,0x10
    80000af4:	79050513          	add	a0,a0,1936 # 80011280 <kmem>
    80000af8:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000afa:	00000097          	auipc	ra,0x0
    80000afe:	178080e7          	jalr	376(ra) # 80000c72 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b02:	6605                	lui	a2,0x1
    80000b04:	4595                	li	a1,5
    80000b06:	8526                	mv	a0,s1
    80000b08:	00000097          	auipc	ra,0x0
    80000b0c:	1b2080e7          	jalr	434(ra) # 80000cba <memset>
  return (void*)r;
}
    80000b10:	8526                	mv	a0,s1
    80000b12:	60e2                	ld	ra,24(sp)
    80000b14:	6442                	ld	s0,16(sp)
    80000b16:	64a2                	ld	s1,8(sp)
    80000b18:	6105                	add	sp,sp,32
    80000b1a:	8082                	ret
  release(&kmem.lock);
    80000b1c:	00010517          	auipc	a0,0x10
    80000b20:	76450513          	add	a0,a0,1892 # 80011280 <kmem>
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	14e080e7          	jalr	334(ra) # 80000c72 <release>
  if(r)
    80000b2c:	b7d5                	j	80000b10 <kalloc+0x42>

0000000080000b2e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b2e:	1141                	add	sp,sp,-16
    80000b30:	e422                	sd	s0,8(sp)
    80000b32:	0800                	add	s0,sp,16
  lk->name = name;
    80000b34:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b36:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b3a:	00053823          	sd	zero,16(a0)
}
    80000b3e:	6422                	ld	s0,8(sp)
    80000b40:	0141                	add	sp,sp,16
    80000b42:	8082                	ret

0000000080000b44 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b44:	411c                	lw	a5,0(a0)
    80000b46:	e399                	bnez	a5,80000b4c <holding+0x8>
    80000b48:	4501                	li	a0,0
  return r;
}
    80000b4a:	8082                	ret
{
    80000b4c:	1101                	add	sp,sp,-32
    80000b4e:	ec06                	sd	ra,24(sp)
    80000b50:	e822                	sd	s0,16(sp)
    80000b52:	e426                	sd	s1,8(sp)
    80000b54:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b56:	6904                	ld	s1,16(a0)
    80000b58:	00001097          	auipc	ra,0x1
    80000b5c:	e30080e7          	jalr	-464(ra) # 80001988 <mycpu>
    80000b60:	40a48533          	sub	a0,s1,a0
    80000b64:	00153513          	seqz	a0,a0
}
    80000b68:	60e2                	ld	ra,24(sp)
    80000b6a:	6442                	ld	s0,16(sp)
    80000b6c:	64a2                	ld	s1,8(sp)
    80000b6e:	6105                	add	sp,sp,32
    80000b70:	8082                	ret

0000000080000b72 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b72:	1101                	add	sp,sp,-32
    80000b74:	ec06                	sd	ra,24(sp)
    80000b76:	e822                	sd	s0,16(sp)
    80000b78:	e426                	sd	s1,8(sp)
    80000b7a:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b7c:	100024f3          	csrr	s1,sstatus
    80000b80:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b84:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b86:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000b8a:	00001097          	auipc	ra,0x1
    80000b8e:	dfe080e7          	jalr	-514(ra) # 80001988 <mycpu>
    80000b92:	5d3c                	lw	a5,120(a0)
    80000b94:	cf89                	beqz	a5,80000bae <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000b96:	00001097          	auipc	ra,0x1
    80000b9a:	df2080e7          	jalr	-526(ra) # 80001988 <mycpu>
    80000b9e:	5d3c                	lw	a5,120(a0)
    80000ba0:	2785                	addw	a5,a5,1
    80000ba2:	dd3c                	sw	a5,120(a0)
}
    80000ba4:	60e2                	ld	ra,24(sp)
    80000ba6:	6442                	ld	s0,16(sp)
    80000ba8:	64a2                	ld	s1,8(sp)
    80000baa:	6105                	add	sp,sp,32
    80000bac:	8082                	ret
    mycpu()->intena = old;
    80000bae:	00001097          	auipc	ra,0x1
    80000bb2:	dda080e7          	jalr	-550(ra) # 80001988 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bb6:	8085                	srl	s1,s1,0x1
    80000bb8:	8885                	and	s1,s1,1
    80000bba:	dd64                	sw	s1,124(a0)
    80000bbc:	bfe9                	j	80000b96 <push_off+0x24>

0000000080000bbe <acquire>:
{
    80000bbe:	1101                	add	sp,sp,-32
    80000bc0:	ec06                	sd	ra,24(sp)
    80000bc2:	e822                	sd	s0,16(sp)
    80000bc4:	e426                	sd	s1,8(sp)
    80000bc6:	1000                	add	s0,sp,32
    80000bc8:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bca:	00000097          	auipc	ra,0x0
    80000bce:	fa8080e7          	jalr	-88(ra) # 80000b72 <push_off>
  if(holding(lk))
    80000bd2:	8526                	mv	a0,s1
    80000bd4:	00000097          	auipc	ra,0x0
    80000bd8:	f70080e7          	jalr	-144(ra) # 80000b44 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bdc:	4705                	li	a4,1
  if(holding(lk))
    80000bde:	e115                	bnez	a0,80000c02 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000be0:	87ba                	mv	a5,a4
    80000be2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000be6:	2781                	sext.w	a5,a5
    80000be8:	ffe5                	bnez	a5,80000be0 <acquire+0x22>
  __sync_synchronize();
    80000bea:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000bee:	00001097          	auipc	ra,0x1
    80000bf2:	d9a080e7          	jalr	-614(ra) # 80001988 <mycpu>
    80000bf6:	e888                	sd	a0,16(s1)
}
    80000bf8:	60e2                	ld	ra,24(sp)
    80000bfa:	6442                	ld	s0,16(sp)
    80000bfc:	64a2                	ld	s1,8(sp)
    80000bfe:	6105                	add	sp,sp,32
    80000c00:	8082                	ret
    panic("acquire");
    80000c02:	00007517          	auipc	a0,0x7
    80000c06:	46e50513          	add	a0,a0,1134 # 80008070 <digits+0x30>
    80000c0a:	00000097          	auipc	ra,0x0
    80000c0e:	91e080e7          	jalr	-1762(ra) # 80000528 <panic>

0000000080000c12 <pop_off>:

void
pop_off(void)
{
    80000c12:	1141                	add	sp,sp,-16
    80000c14:	e406                	sd	ra,8(sp)
    80000c16:	e022                	sd	s0,0(sp)
    80000c18:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    80000c1a:	00001097          	auipc	ra,0x1
    80000c1e:	d6e080e7          	jalr	-658(ra) # 80001988 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c22:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c26:	8b89                	and	a5,a5,2
  if(intr_get())
    80000c28:	e78d                	bnez	a5,80000c52 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c2a:	5d3c                	lw	a5,120(a0)
    80000c2c:	02f05b63          	blez	a5,80000c62 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c30:	37fd                	addw	a5,a5,-1
    80000c32:	0007871b          	sext.w	a4,a5
    80000c36:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c38:	eb09                	bnez	a4,80000c4a <pop_off+0x38>
    80000c3a:	5d7c                	lw	a5,124(a0)
    80000c3c:	c799                	beqz	a5,80000c4a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c3e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c42:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c46:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c4a:	60a2                	ld	ra,8(sp)
    80000c4c:	6402                	ld	s0,0(sp)
    80000c4e:	0141                	add	sp,sp,16
    80000c50:	8082                	ret
    panic("pop_off - interruptible");
    80000c52:	00007517          	auipc	a0,0x7
    80000c56:	42650513          	add	a0,a0,1062 # 80008078 <digits+0x38>
    80000c5a:	00000097          	auipc	ra,0x0
    80000c5e:	8ce080e7          	jalr	-1842(ra) # 80000528 <panic>
    panic("pop_off");
    80000c62:	00007517          	auipc	a0,0x7
    80000c66:	42e50513          	add	a0,a0,1070 # 80008090 <digits+0x50>
    80000c6a:	00000097          	auipc	ra,0x0
    80000c6e:	8be080e7          	jalr	-1858(ra) # 80000528 <panic>

0000000080000c72 <release>:
{
    80000c72:	1101                	add	sp,sp,-32
    80000c74:	ec06                	sd	ra,24(sp)
    80000c76:	e822                	sd	s0,16(sp)
    80000c78:	e426                	sd	s1,8(sp)
    80000c7a:	1000                	add	s0,sp,32
    80000c7c:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c7e:	00000097          	auipc	ra,0x0
    80000c82:	ec6080e7          	jalr	-314(ra) # 80000b44 <holding>
    80000c86:	c115                	beqz	a0,80000caa <release+0x38>
  lk->cpu = 0;
    80000c88:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c8c:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000c90:	0f50000f          	fence	iorw,ow
    80000c94:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000c98:	00000097          	auipc	ra,0x0
    80000c9c:	f7a080e7          	jalr	-134(ra) # 80000c12 <pop_off>
}
    80000ca0:	60e2                	ld	ra,24(sp)
    80000ca2:	6442                	ld	s0,16(sp)
    80000ca4:	64a2                	ld	s1,8(sp)
    80000ca6:	6105                	add	sp,sp,32
    80000ca8:	8082                	ret
    panic("release");
    80000caa:	00007517          	auipc	a0,0x7
    80000cae:	3ee50513          	add	a0,a0,1006 # 80008098 <digits+0x58>
    80000cb2:	00000097          	auipc	ra,0x0
    80000cb6:	876080e7          	jalr	-1930(ra) # 80000528 <panic>

0000000080000cba <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cba:	1141                	add	sp,sp,-16
    80000cbc:	e422                	sd	s0,8(sp)
    80000cbe:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cc0:	ca19                	beqz	a2,80000cd6 <memset+0x1c>
    80000cc2:	87aa                	mv	a5,a0
    80000cc4:	1602                	sll	a2,a2,0x20
    80000cc6:	9201                	srl	a2,a2,0x20
    80000cc8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000ccc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cd0:	0785                	add	a5,a5,1
    80000cd2:	fee79de3          	bne	a5,a4,80000ccc <memset+0x12>
  }
  return dst;
}
    80000cd6:	6422                	ld	s0,8(sp)
    80000cd8:	0141                	add	sp,sp,16
    80000cda:	8082                	ret

0000000080000cdc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cdc:	1141                	add	sp,sp,-16
    80000cde:	e422                	sd	s0,8(sp)
    80000ce0:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000ce2:	ca05                	beqz	a2,80000d12 <memcmp+0x36>
    80000ce4:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000ce8:	1682                	sll	a3,a3,0x20
    80000cea:	9281                	srl	a3,a3,0x20
    80000cec:	0685                	add	a3,a3,1
    80000cee:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000cf0:	00054783          	lbu	a5,0(a0)
    80000cf4:	0005c703          	lbu	a4,0(a1)
    80000cf8:	00e79863          	bne	a5,a4,80000d08 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000cfc:	0505                	add	a0,a0,1
    80000cfe:	0585                	add	a1,a1,1
  while(n-- > 0){
    80000d00:	fed518e3          	bne	a0,a3,80000cf0 <memcmp+0x14>
  }

  return 0;
    80000d04:	4501                	li	a0,0
    80000d06:	a019                	j	80000d0c <memcmp+0x30>
      return *s1 - *s2;
    80000d08:	40e7853b          	subw	a0,a5,a4
}
    80000d0c:	6422                	ld	s0,8(sp)
    80000d0e:	0141                	add	sp,sp,16
    80000d10:	8082                	ret
  return 0;
    80000d12:	4501                	li	a0,0
    80000d14:	bfe5                	j	80000d0c <memcmp+0x30>

0000000080000d16 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d16:	1141                	add	sp,sp,-16
    80000d18:	e422                	sd	s0,8(sp)
    80000d1a:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d1c:	02a5e563          	bltu	a1,a0,80000d46 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d20:	fff6069b          	addw	a3,a2,-1
    80000d24:	ce11                	beqz	a2,80000d40 <memmove+0x2a>
    80000d26:	1682                	sll	a3,a3,0x20
    80000d28:	9281                	srl	a3,a3,0x20
    80000d2a:	0685                	add	a3,a3,1
    80000d2c:	96ae                	add	a3,a3,a1
    80000d2e:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000d30:	0585                	add	a1,a1,1
    80000d32:	0785                	add	a5,a5,1
    80000d34:	fff5c703          	lbu	a4,-1(a1)
    80000d38:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000d3c:	fed59ae3          	bne	a1,a3,80000d30 <memmove+0x1a>

  return dst;
}
    80000d40:	6422                	ld	s0,8(sp)
    80000d42:	0141                	add	sp,sp,16
    80000d44:	8082                	ret
  if(s < d && s + n > d){
    80000d46:	02061713          	sll	a4,a2,0x20
    80000d4a:	9301                	srl	a4,a4,0x20
    80000d4c:	00e587b3          	add	a5,a1,a4
    80000d50:	fcf578e3          	bgeu	a0,a5,80000d20 <memmove+0xa>
    d += n;
    80000d54:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000d56:	fff6069b          	addw	a3,a2,-1
    80000d5a:	d27d                	beqz	a2,80000d40 <memmove+0x2a>
    80000d5c:	02069613          	sll	a2,a3,0x20
    80000d60:	9201                	srl	a2,a2,0x20
    80000d62:	fff64613          	not	a2,a2
    80000d66:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000d68:	17fd                	add	a5,a5,-1
    80000d6a:	177d                	add	a4,a4,-1 # ffffffffffffefff <end+0xffffffff7ffddfff>
    80000d6c:	0007c683          	lbu	a3,0(a5)
    80000d70:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000d74:	fef61ae3          	bne	a2,a5,80000d68 <memmove+0x52>
    80000d78:	b7e1                	j	80000d40 <memmove+0x2a>

0000000080000d7a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d7a:	1141                	add	sp,sp,-16
    80000d7c:	e406                	sd	ra,8(sp)
    80000d7e:	e022                	sd	s0,0(sp)
    80000d80:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    80000d82:	00000097          	auipc	ra,0x0
    80000d86:	f94080e7          	jalr	-108(ra) # 80000d16 <memmove>
}
    80000d8a:	60a2                	ld	ra,8(sp)
    80000d8c:	6402                	ld	s0,0(sp)
    80000d8e:	0141                	add	sp,sp,16
    80000d90:	8082                	ret

0000000080000d92 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d92:	1141                	add	sp,sp,-16
    80000d94:	e422                	sd	s0,8(sp)
    80000d96:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d98:	ce11                	beqz	a2,80000db4 <strncmp+0x22>
    80000d9a:	00054783          	lbu	a5,0(a0)
    80000d9e:	cf89                	beqz	a5,80000db8 <strncmp+0x26>
    80000da0:	0005c703          	lbu	a4,0(a1)
    80000da4:	00f71a63          	bne	a4,a5,80000db8 <strncmp+0x26>
    n--, p++, q++;
    80000da8:	367d                	addw	a2,a2,-1
    80000daa:	0505                	add	a0,a0,1
    80000dac:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dae:	f675                	bnez	a2,80000d9a <strncmp+0x8>
  if(n == 0)
    return 0;
    80000db0:	4501                	li	a0,0
    80000db2:	a809                	j	80000dc4 <strncmp+0x32>
    80000db4:	4501                	li	a0,0
    80000db6:	a039                	j	80000dc4 <strncmp+0x32>
  if(n == 0)
    80000db8:	ca09                	beqz	a2,80000dca <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000dba:	00054503          	lbu	a0,0(a0)
    80000dbe:	0005c783          	lbu	a5,0(a1)
    80000dc2:	9d1d                	subw	a0,a0,a5
}
    80000dc4:	6422                	ld	s0,8(sp)
    80000dc6:	0141                	add	sp,sp,16
    80000dc8:	8082                	ret
    return 0;
    80000dca:	4501                	li	a0,0
    80000dcc:	bfe5                	j	80000dc4 <strncmp+0x32>

0000000080000dce <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dce:	1141                	add	sp,sp,-16
    80000dd0:	e422                	sd	s0,8(sp)
    80000dd2:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000dd4:	87aa                	mv	a5,a0
    80000dd6:	86b2                	mv	a3,a2
    80000dd8:	367d                	addw	a2,a2,-1
    80000dda:	00d05963          	blez	a3,80000dec <strncpy+0x1e>
    80000dde:	0785                	add	a5,a5,1
    80000de0:	0005c703          	lbu	a4,0(a1)
    80000de4:	fee78fa3          	sb	a4,-1(a5)
    80000de8:	0585                	add	a1,a1,1
    80000dea:	f775                	bnez	a4,80000dd6 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000dec:	873e                	mv	a4,a5
    80000dee:	9fb5                	addw	a5,a5,a3
    80000df0:	37fd                	addw	a5,a5,-1
    80000df2:	00c05963          	blez	a2,80000e04 <strncpy+0x36>
    *s++ = 0;
    80000df6:	0705                	add	a4,a4,1
    80000df8:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000dfc:	40e786bb          	subw	a3,a5,a4
    80000e00:	fed04be3          	bgtz	a3,80000df6 <strncpy+0x28>
  return os;
}
    80000e04:	6422                	ld	s0,8(sp)
    80000e06:	0141                	add	sp,sp,16
    80000e08:	8082                	ret

0000000080000e0a <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e0a:	1141                	add	sp,sp,-16
    80000e0c:	e422                	sd	s0,8(sp)
    80000e0e:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e10:	02c05363          	blez	a2,80000e36 <safestrcpy+0x2c>
    80000e14:	fff6069b          	addw	a3,a2,-1
    80000e18:	1682                	sll	a3,a3,0x20
    80000e1a:	9281                	srl	a3,a3,0x20
    80000e1c:	96ae                	add	a3,a3,a1
    80000e1e:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e20:	00d58963          	beq	a1,a3,80000e32 <safestrcpy+0x28>
    80000e24:	0585                	add	a1,a1,1
    80000e26:	0785                	add	a5,a5,1
    80000e28:	fff5c703          	lbu	a4,-1(a1)
    80000e2c:	fee78fa3          	sb	a4,-1(a5)
    80000e30:	fb65                	bnez	a4,80000e20 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e32:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e36:	6422                	ld	s0,8(sp)
    80000e38:	0141                	add	sp,sp,16
    80000e3a:	8082                	ret

0000000080000e3c <strlen>:

int
strlen(const char *s)
{
    80000e3c:	1141                	add	sp,sp,-16
    80000e3e:	e422                	sd	s0,8(sp)
    80000e40:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e42:	00054783          	lbu	a5,0(a0)
    80000e46:	cf91                	beqz	a5,80000e62 <strlen+0x26>
    80000e48:	0505                	add	a0,a0,1
    80000e4a:	87aa                	mv	a5,a0
    80000e4c:	86be                	mv	a3,a5
    80000e4e:	0785                	add	a5,a5,1
    80000e50:	fff7c703          	lbu	a4,-1(a5)
    80000e54:	ff65                	bnez	a4,80000e4c <strlen+0x10>
    80000e56:	40a6853b          	subw	a0,a3,a0
    80000e5a:	2505                	addw	a0,a0,1
    ;
  return n;
}
    80000e5c:	6422                	ld	s0,8(sp)
    80000e5e:	0141                	add	sp,sp,16
    80000e60:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e62:	4501                	li	a0,0
    80000e64:	bfe5                	j	80000e5c <strlen+0x20>

0000000080000e66 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e66:	1141                	add	sp,sp,-16
    80000e68:	e406                	sd	ra,8(sp)
    80000e6a:	e022                	sd	s0,0(sp)
    80000e6c:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    80000e6e:	00001097          	auipc	ra,0x1
    80000e72:	b0a080e7          	jalr	-1270(ra) # 80001978 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e76:	00008717          	auipc	a4,0x8
    80000e7a:	1a270713          	add	a4,a4,418 # 80009018 <started>
  if(cpuid() == 0){
    80000e7e:	c139                	beqz	a0,80000ec4 <main+0x5e>
    while(started == 0)
    80000e80:	431c                	lw	a5,0(a4)
    80000e82:	2781                	sext.w	a5,a5
    80000e84:	dff5                	beqz	a5,80000e80 <main+0x1a>
      ;
    __sync_synchronize();
    80000e86:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e8a:	00001097          	auipc	ra,0x1
    80000e8e:	aee080e7          	jalr	-1298(ra) # 80001978 <cpuid>
    80000e92:	85aa                	mv	a1,a0
    80000e94:	00007517          	auipc	a0,0x7
    80000e98:	22450513          	add	a0,a0,548 # 800080b8 <digits+0x78>
    80000e9c:	fffff097          	auipc	ra,0xfffff
    80000ea0:	6d6080e7          	jalr	1750(ra) # 80000572 <printf>
    kvminithart();    // turn on paging
    80000ea4:	00000097          	auipc	ra,0x0
    80000ea8:	0d8080e7          	jalr	216(ra) # 80000f7c <kvminithart>
    trapinithart();   // install kernel trap vector
    80000eac:	00001097          	auipc	ra,0x1
    80000eb0:	756080e7          	jalr	1878(ra) # 80002602 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000eb4:	00005097          	auipc	ra,0x5
    80000eb8:	f2c080e7          	jalr	-212(ra) # 80005de0 <plicinithart>
  }

  scheduler();        
    80000ebc:	00001097          	auipc	ra,0x1
    80000ec0:	020080e7          	jalr	32(ra) # 80001edc <scheduler>
    consoleinit();
    80000ec4:	fffff097          	auipc	ra,0xfffff
    80000ec8:	574080e7          	jalr	1396(ra) # 80000438 <consoleinit>
    printfinit();
    80000ecc:	00000097          	auipc	ra,0x0
    80000ed0:	886080e7          	jalr	-1914(ra) # 80000752 <printfinit>
    printf("\n");
    80000ed4:	00007517          	auipc	a0,0x7
    80000ed8:	1f450513          	add	a0,a0,500 # 800080c8 <digits+0x88>
    80000edc:	fffff097          	auipc	ra,0xfffff
    80000ee0:	696080e7          	jalr	1686(ra) # 80000572 <printf>
    printf("xv6 kernel is booting\n");
    80000ee4:	00007517          	auipc	a0,0x7
    80000ee8:	1bc50513          	add	a0,a0,444 # 800080a0 <digits+0x60>
    80000eec:	fffff097          	auipc	ra,0xfffff
    80000ef0:	686080e7          	jalr	1670(ra) # 80000572 <printf>
    printf("\n");
    80000ef4:	00007517          	auipc	a0,0x7
    80000ef8:	1d450513          	add	a0,a0,468 # 800080c8 <digits+0x88>
    80000efc:	fffff097          	auipc	ra,0xfffff
    80000f00:	676080e7          	jalr	1654(ra) # 80000572 <printf>
    kinit();         // physical page allocator
    80000f04:	00000097          	auipc	ra,0x0
    80000f08:	b8e080e7          	jalr	-1138(ra) # 80000a92 <kinit>
    kvminit();       // create kernel page table
    80000f0c:	00000097          	auipc	ra,0x0
    80000f10:	310080e7          	jalr	784(ra) # 8000121c <kvminit>
    kvminithart();   // turn on paging
    80000f14:	00000097          	auipc	ra,0x0
    80000f18:	068080e7          	jalr	104(ra) # 80000f7c <kvminithart>
    procinit();      // process table
    80000f1c:	00001097          	auipc	ra,0x1
    80000f20:	9c4080e7          	jalr	-1596(ra) # 800018e0 <procinit>
    trapinit();      // trap vectors
    80000f24:	00001097          	auipc	ra,0x1
    80000f28:	6b6080e7          	jalr	1718(ra) # 800025da <trapinit>
    trapinithart();  // install kernel trap vector
    80000f2c:	00001097          	auipc	ra,0x1
    80000f30:	6d6080e7          	jalr	1750(ra) # 80002602 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f34:	00005097          	auipc	ra,0x5
    80000f38:	e96080e7          	jalr	-362(ra) # 80005dca <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f3c:	00005097          	auipc	ra,0x5
    80000f40:	ea4080e7          	jalr	-348(ra) # 80005de0 <plicinithart>
    binit();         // buffer cache
    80000f44:	00002097          	auipc	ra,0x2
    80000f48:	e04080e7          	jalr	-508(ra) # 80002d48 <binit>
    iinit();         // inode cache
    80000f4c:	00002097          	auipc	ra,0x2
    80000f50:	556080e7          	jalr	1366(ra) # 800034a2 <iinit>
    fileinit();      // file table
    80000f54:	00003097          	auipc	ra,0x3
    80000f58:	588080e7          	jalr	1416(ra) # 800044dc <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f5c:	00005097          	auipc	ra,0x5
    80000f60:	fa4080e7          	jalr	-92(ra) # 80005f00 <virtio_disk_init>
    userinit();      // first user process
    80000f64:	00001097          	auipc	ra,0x1
    80000f68:	d0a080e7          	jalr	-758(ra) # 80001c6e <userinit>
    __sync_synchronize();
    80000f6c:	0ff0000f          	fence
    started = 1;
    80000f70:	4785                	li	a5,1
    80000f72:	00008717          	auipc	a4,0x8
    80000f76:	0af72323          	sw	a5,166(a4) # 80009018 <started>
    80000f7a:	b789                	j	80000ebc <main+0x56>

0000000080000f7c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f7c:	1141                	add	sp,sp,-16
    80000f7e:	e422                	sd	s0,8(sp)
    80000f80:	0800                	add	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000f82:	00008797          	auipc	a5,0x8
    80000f86:	09e7b783          	ld	a5,158(a5) # 80009020 <kernel_pagetable>
    80000f8a:	83b1                	srl	a5,a5,0xc
    80000f8c:	577d                	li	a4,-1
    80000f8e:	177e                	sll	a4,a4,0x3f
    80000f90:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f92:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f96:	12000073          	sfence.vma
  sfence_vma();
}
    80000f9a:	6422                	ld	s0,8(sp)
    80000f9c:	0141                	add	sp,sp,16
    80000f9e:	8082                	ret

0000000080000fa0 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fa0:	7139                	add	sp,sp,-64
    80000fa2:	fc06                	sd	ra,56(sp)
    80000fa4:	f822                	sd	s0,48(sp)
    80000fa6:	f426                	sd	s1,40(sp)
    80000fa8:	f04a                	sd	s2,32(sp)
    80000faa:	ec4e                	sd	s3,24(sp)
    80000fac:	e852                	sd	s4,16(sp)
    80000fae:	e456                	sd	s5,8(sp)
    80000fb0:	e05a                	sd	s6,0(sp)
    80000fb2:	0080                	add	s0,sp,64
    80000fb4:	84aa                	mv	s1,a0
    80000fb6:	89ae                	mv	s3,a1
    80000fb8:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fba:	57fd                	li	a5,-1
    80000fbc:	83e9                	srl	a5,a5,0x1a
    80000fbe:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fc0:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000fc2:	04b7f263          	bgeu	a5,a1,80001006 <walk+0x66>
    panic("walk");
    80000fc6:	00007517          	auipc	a0,0x7
    80000fca:	10a50513          	add	a0,a0,266 # 800080d0 <digits+0x90>
    80000fce:	fffff097          	auipc	ra,0xfffff
    80000fd2:	55a080e7          	jalr	1370(ra) # 80000528 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fd6:	060a8663          	beqz	s5,80001042 <walk+0xa2>
    80000fda:	00000097          	auipc	ra,0x0
    80000fde:	af4080e7          	jalr	-1292(ra) # 80000ace <kalloc>
    80000fe2:	84aa                	mv	s1,a0
    80000fe4:	c529                	beqz	a0,8000102e <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000fe6:	6605                	lui	a2,0x1
    80000fe8:	4581                	li	a1,0
    80000fea:	00000097          	auipc	ra,0x0
    80000fee:	cd0080e7          	jalr	-816(ra) # 80000cba <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000ff2:	00c4d793          	srl	a5,s1,0xc
    80000ff6:	07aa                	sll	a5,a5,0xa
    80000ff8:	0017e793          	or	a5,a5,1
    80000ffc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001000:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffddff7>
    80001002:	036a0063          	beq	s4,s6,80001022 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001006:	0149d933          	srl	s2,s3,s4
    8000100a:	1ff97913          	and	s2,s2,511
    8000100e:	090e                	sll	s2,s2,0x3
    80001010:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001012:	00093483          	ld	s1,0(s2)
    80001016:	0014f793          	and	a5,s1,1
    8000101a:	dfd5                	beqz	a5,80000fd6 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000101c:	80a9                	srl	s1,s1,0xa
    8000101e:	04b2                	sll	s1,s1,0xc
    80001020:	b7c5                	j	80001000 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001022:	00c9d513          	srl	a0,s3,0xc
    80001026:	1ff57513          	and	a0,a0,511
    8000102a:	050e                	sll	a0,a0,0x3
    8000102c:	9526                	add	a0,a0,s1
}
    8000102e:	70e2                	ld	ra,56(sp)
    80001030:	7442                	ld	s0,48(sp)
    80001032:	74a2                	ld	s1,40(sp)
    80001034:	7902                	ld	s2,32(sp)
    80001036:	69e2                	ld	s3,24(sp)
    80001038:	6a42                	ld	s4,16(sp)
    8000103a:	6aa2                	ld	s5,8(sp)
    8000103c:	6b02                	ld	s6,0(sp)
    8000103e:	6121                	add	sp,sp,64
    80001040:	8082                	ret
        return 0;
    80001042:	4501                	li	a0,0
    80001044:	b7ed                	j	8000102e <walk+0x8e>

0000000080001046 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001046:	57fd                	li	a5,-1
    80001048:	83e9                	srl	a5,a5,0x1a
    8000104a:	00b7f463          	bgeu	a5,a1,80001052 <walkaddr+0xc>
    return 0;
    8000104e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001050:	8082                	ret
{
    80001052:	1141                	add	sp,sp,-16
    80001054:	e406                	sd	ra,8(sp)
    80001056:	e022                	sd	s0,0(sp)
    80001058:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000105a:	4601                	li	a2,0
    8000105c:	00000097          	auipc	ra,0x0
    80001060:	f44080e7          	jalr	-188(ra) # 80000fa0 <walk>
  if(pte == 0)
    80001064:	c105                	beqz	a0,80001084 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001066:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001068:	0117f693          	and	a3,a5,17
    8000106c:	4745                	li	a4,17
    return 0;
    8000106e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001070:	00e68663          	beq	a3,a4,8000107c <walkaddr+0x36>
}
    80001074:	60a2                	ld	ra,8(sp)
    80001076:	6402                	ld	s0,0(sp)
    80001078:	0141                	add	sp,sp,16
    8000107a:	8082                	ret
  pa = PTE2PA(*pte);
    8000107c:	83a9                	srl	a5,a5,0xa
    8000107e:	00c79513          	sll	a0,a5,0xc
  return pa;
    80001082:	bfcd                	j	80001074 <walkaddr+0x2e>
    return 0;
    80001084:	4501                	li	a0,0
    80001086:	b7fd                	j	80001074 <walkaddr+0x2e>

0000000080001088 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001088:	715d                	add	sp,sp,-80
    8000108a:	e486                	sd	ra,72(sp)
    8000108c:	e0a2                	sd	s0,64(sp)
    8000108e:	fc26                	sd	s1,56(sp)
    80001090:	f84a                	sd	s2,48(sp)
    80001092:	f44e                	sd	s3,40(sp)
    80001094:	f052                	sd	s4,32(sp)
    80001096:	ec56                	sd	s5,24(sp)
    80001098:	e85a                	sd	s6,16(sp)
    8000109a:	e45e                	sd	s7,8(sp)
    8000109c:	0880                	add	s0,sp,80
    8000109e:	8aaa                	mv	s5,a0
    800010a0:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    800010a2:	777d                	lui	a4,0xfffff
    800010a4:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800010a8:	fff60993          	add	s3,a2,-1 # fff <_entry-0x7ffff001>
    800010ac:	99ae                	add	s3,s3,a1
    800010ae:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800010b2:	893e                	mv	s2,a5
    800010b4:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800010b8:	6b85                	lui	s7,0x1
    800010ba:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800010be:	4605                	li	a2,1
    800010c0:	85ca                	mv	a1,s2
    800010c2:	8556                	mv	a0,s5
    800010c4:	00000097          	auipc	ra,0x0
    800010c8:	edc080e7          	jalr	-292(ra) # 80000fa0 <walk>
    800010cc:	c51d                	beqz	a0,800010fa <mappages+0x72>
    if(*pte & PTE_V)
    800010ce:	611c                	ld	a5,0(a0)
    800010d0:	8b85                	and	a5,a5,1
    800010d2:	ef81                	bnez	a5,800010ea <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010d4:	80b1                	srl	s1,s1,0xc
    800010d6:	04aa                	sll	s1,s1,0xa
    800010d8:	0164e4b3          	or	s1,s1,s6
    800010dc:	0014e493          	or	s1,s1,1
    800010e0:	e104                	sd	s1,0(a0)
    if(a == last)
    800010e2:	03390863          	beq	s2,s3,80001112 <mappages+0x8a>
    a += PGSIZE;
    800010e6:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800010e8:	bfc9                	j	800010ba <mappages+0x32>
      panic("remap");
    800010ea:	00007517          	auipc	a0,0x7
    800010ee:	fee50513          	add	a0,a0,-18 # 800080d8 <digits+0x98>
    800010f2:	fffff097          	auipc	ra,0xfffff
    800010f6:	436080e7          	jalr	1078(ra) # 80000528 <panic>
      return -1;
    800010fa:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010fc:	60a6                	ld	ra,72(sp)
    800010fe:	6406                	ld	s0,64(sp)
    80001100:	74e2                	ld	s1,56(sp)
    80001102:	7942                	ld	s2,48(sp)
    80001104:	79a2                	ld	s3,40(sp)
    80001106:	7a02                	ld	s4,32(sp)
    80001108:	6ae2                	ld	s5,24(sp)
    8000110a:	6b42                	ld	s6,16(sp)
    8000110c:	6ba2                	ld	s7,8(sp)
    8000110e:	6161                	add	sp,sp,80
    80001110:	8082                	ret
  return 0;
    80001112:	4501                	li	a0,0
    80001114:	b7e5                	j	800010fc <mappages+0x74>

0000000080001116 <kvmmap>:
{
    80001116:	1141                	add	sp,sp,-16
    80001118:	e406                	sd	ra,8(sp)
    8000111a:	e022                	sd	s0,0(sp)
    8000111c:	0800                	add	s0,sp,16
    8000111e:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001120:	86b2                	mv	a3,a2
    80001122:	863e                	mv	a2,a5
    80001124:	00000097          	auipc	ra,0x0
    80001128:	f64080e7          	jalr	-156(ra) # 80001088 <mappages>
    8000112c:	e509                	bnez	a0,80001136 <kvmmap+0x20>
}
    8000112e:	60a2                	ld	ra,8(sp)
    80001130:	6402                	ld	s0,0(sp)
    80001132:	0141                	add	sp,sp,16
    80001134:	8082                	ret
    panic("kvmmap");
    80001136:	00007517          	auipc	a0,0x7
    8000113a:	faa50513          	add	a0,a0,-86 # 800080e0 <digits+0xa0>
    8000113e:	fffff097          	auipc	ra,0xfffff
    80001142:	3ea080e7          	jalr	1002(ra) # 80000528 <panic>

0000000080001146 <kvmmake>:
{
    80001146:	1101                	add	sp,sp,-32
    80001148:	ec06                	sd	ra,24(sp)
    8000114a:	e822                	sd	s0,16(sp)
    8000114c:	e426                	sd	s1,8(sp)
    8000114e:	e04a                	sd	s2,0(sp)
    80001150:	1000                	add	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001152:	00000097          	auipc	ra,0x0
    80001156:	97c080e7          	jalr	-1668(ra) # 80000ace <kalloc>
    8000115a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000115c:	6605                	lui	a2,0x1
    8000115e:	4581                	li	a1,0
    80001160:	00000097          	auipc	ra,0x0
    80001164:	b5a080e7          	jalr	-1190(ra) # 80000cba <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001168:	4719                	li	a4,6
    8000116a:	6685                	lui	a3,0x1
    8000116c:	10000637          	lui	a2,0x10000
    80001170:	100005b7          	lui	a1,0x10000
    80001174:	8526                	mv	a0,s1
    80001176:	00000097          	auipc	ra,0x0
    8000117a:	fa0080e7          	jalr	-96(ra) # 80001116 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000117e:	4719                	li	a4,6
    80001180:	6685                	lui	a3,0x1
    80001182:	10001637          	lui	a2,0x10001
    80001186:	100015b7          	lui	a1,0x10001
    8000118a:	8526                	mv	a0,s1
    8000118c:	00000097          	auipc	ra,0x0
    80001190:	f8a080e7          	jalr	-118(ra) # 80001116 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001194:	4719                	li	a4,6
    80001196:	004006b7          	lui	a3,0x400
    8000119a:	0c000637          	lui	a2,0xc000
    8000119e:	0c0005b7          	lui	a1,0xc000
    800011a2:	8526                	mv	a0,s1
    800011a4:	00000097          	auipc	ra,0x0
    800011a8:	f72080e7          	jalr	-142(ra) # 80001116 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011ac:	00007917          	auipc	s2,0x7
    800011b0:	e5490913          	add	s2,s2,-428 # 80008000 <etext>
    800011b4:	4729                	li	a4,10
    800011b6:	80007697          	auipc	a3,0x80007
    800011ba:	e4a68693          	add	a3,a3,-438 # 8000 <_entry-0x7fff8000>
    800011be:	4605                	li	a2,1
    800011c0:	067e                	sll	a2,a2,0x1f
    800011c2:	85b2                	mv	a1,a2
    800011c4:	8526                	mv	a0,s1
    800011c6:	00000097          	auipc	ra,0x0
    800011ca:	f50080e7          	jalr	-176(ra) # 80001116 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011ce:	4719                	li	a4,6
    800011d0:	46c5                	li	a3,17
    800011d2:	06ee                	sll	a3,a3,0x1b
    800011d4:	412686b3          	sub	a3,a3,s2
    800011d8:	864a                	mv	a2,s2
    800011da:	85ca                	mv	a1,s2
    800011dc:	8526                	mv	a0,s1
    800011de:	00000097          	auipc	ra,0x0
    800011e2:	f38080e7          	jalr	-200(ra) # 80001116 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011e6:	4729                	li	a4,10
    800011e8:	6685                	lui	a3,0x1
    800011ea:	00006617          	auipc	a2,0x6
    800011ee:	e1660613          	add	a2,a2,-490 # 80007000 <_trampoline>
    800011f2:	040005b7          	lui	a1,0x4000
    800011f6:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011f8:	05b2                	sll	a1,a1,0xc
    800011fa:	8526                	mv	a0,s1
    800011fc:	00000097          	auipc	ra,0x0
    80001200:	f1a080e7          	jalr	-230(ra) # 80001116 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001204:	8526                	mv	a0,s1
    80001206:	00000097          	auipc	ra,0x0
    8000120a:	644080e7          	jalr	1604(ra) # 8000184a <proc_mapstacks>
}
    8000120e:	8526                	mv	a0,s1
    80001210:	60e2                	ld	ra,24(sp)
    80001212:	6442                	ld	s0,16(sp)
    80001214:	64a2                	ld	s1,8(sp)
    80001216:	6902                	ld	s2,0(sp)
    80001218:	6105                	add	sp,sp,32
    8000121a:	8082                	ret

000000008000121c <kvminit>:
{
    8000121c:	1141                	add	sp,sp,-16
    8000121e:	e406                	sd	ra,8(sp)
    80001220:	e022                	sd	s0,0(sp)
    80001222:	0800                	add	s0,sp,16
  kernel_pagetable = kvmmake();
    80001224:	00000097          	auipc	ra,0x0
    80001228:	f22080e7          	jalr	-222(ra) # 80001146 <kvmmake>
    8000122c:	00008797          	auipc	a5,0x8
    80001230:	dea7ba23          	sd	a0,-524(a5) # 80009020 <kernel_pagetable>
}
    80001234:	60a2                	ld	ra,8(sp)
    80001236:	6402                	ld	s0,0(sp)
    80001238:	0141                	add	sp,sp,16
    8000123a:	8082                	ret

000000008000123c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000123c:	715d                	add	sp,sp,-80
    8000123e:	e486                	sd	ra,72(sp)
    80001240:	e0a2                	sd	s0,64(sp)
    80001242:	fc26                	sd	s1,56(sp)
    80001244:	f84a                	sd	s2,48(sp)
    80001246:	f44e                	sd	s3,40(sp)
    80001248:	f052                	sd	s4,32(sp)
    8000124a:	ec56                	sd	s5,24(sp)
    8000124c:	e85a                	sd	s6,16(sp)
    8000124e:	e45e                	sd	s7,8(sp)
    80001250:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001252:	03459793          	sll	a5,a1,0x34
    80001256:	e795                	bnez	a5,80001282 <uvmunmap+0x46>
    80001258:	8a2a                	mv	s4,a0
    8000125a:	892e                	mv	s2,a1
    8000125c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000125e:	0632                	sll	a2,a2,0xc
    80001260:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001264:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001266:	6b05                	lui	s6,0x1
    80001268:	0735e263          	bltu	a1,s3,800012cc <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000126c:	60a6                	ld	ra,72(sp)
    8000126e:	6406                	ld	s0,64(sp)
    80001270:	74e2                	ld	s1,56(sp)
    80001272:	7942                	ld	s2,48(sp)
    80001274:	79a2                	ld	s3,40(sp)
    80001276:	7a02                	ld	s4,32(sp)
    80001278:	6ae2                	ld	s5,24(sp)
    8000127a:	6b42                	ld	s6,16(sp)
    8000127c:	6ba2                	ld	s7,8(sp)
    8000127e:	6161                	add	sp,sp,80
    80001280:	8082                	ret
    panic("uvmunmap: not aligned");
    80001282:	00007517          	auipc	a0,0x7
    80001286:	e6650513          	add	a0,a0,-410 # 800080e8 <digits+0xa8>
    8000128a:	fffff097          	auipc	ra,0xfffff
    8000128e:	29e080e7          	jalr	670(ra) # 80000528 <panic>
      panic("uvmunmap: walk");
    80001292:	00007517          	auipc	a0,0x7
    80001296:	e6e50513          	add	a0,a0,-402 # 80008100 <digits+0xc0>
    8000129a:	fffff097          	auipc	ra,0xfffff
    8000129e:	28e080e7          	jalr	654(ra) # 80000528 <panic>
      panic("uvmunmap: not mapped");
    800012a2:	00007517          	auipc	a0,0x7
    800012a6:	e6e50513          	add	a0,a0,-402 # 80008110 <digits+0xd0>
    800012aa:	fffff097          	auipc	ra,0xfffff
    800012ae:	27e080e7          	jalr	638(ra) # 80000528 <panic>
      panic("uvmunmap: not a leaf");
    800012b2:	00007517          	auipc	a0,0x7
    800012b6:	e7650513          	add	a0,a0,-394 # 80008128 <digits+0xe8>
    800012ba:	fffff097          	auipc	ra,0xfffff
    800012be:	26e080e7          	jalr	622(ra) # 80000528 <panic>
    *pte = 0;
    800012c2:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012c6:	995a                	add	s2,s2,s6
    800012c8:	fb3972e3          	bgeu	s2,s3,8000126c <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800012cc:	4601                	li	a2,0
    800012ce:	85ca                	mv	a1,s2
    800012d0:	8552                	mv	a0,s4
    800012d2:	00000097          	auipc	ra,0x0
    800012d6:	cce080e7          	jalr	-818(ra) # 80000fa0 <walk>
    800012da:	84aa                	mv	s1,a0
    800012dc:	d95d                	beqz	a0,80001292 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800012de:	6108                	ld	a0,0(a0)
    800012e0:	00157793          	and	a5,a0,1
    800012e4:	dfdd                	beqz	a5,800012a2 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800012e6:	3ff57793          	and	a5,a0,1023
    800012ea:	fd7784e3          	beq	a5,s7,800012b2 <uvmunmap+0x76>
    if(do_free){
    800012ee:	fc0a8ae3          	beqz	s5,800012c2 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800012f2:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    800012f4:	0532                	sll	a0,a0,0xc
    800012f6:	fffff097          	auipc	ra,0xfffff
    800012fa:	6da080e7          	jalr	1754(ra) # 800009d0 <kfree>
    800012fe:	b7d1                	j	800012c2 <uvmunmap+0x86>

0000000080001300 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001300:	1101                	add	sp,sp,-32
    80001302:	ec06                	sd	ra,24(sp)
    80001304:	e822                	sd	s0,16(sp)
    80001306:	e426                	sd	s1,8(sp)
    80001308:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000130a:	fffff097          	auipc	ra,0xfffff
    8000130e:	7c4080e7          	jalr	1988(ra) # 80000ace <kalloc>
    80001312:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001314:	c519                	beqz	a0,80001322 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001316:	6605                	lui	a2,0x1
    80001318:	4581                	li	a1,0
    8000131a:	00000097          	auipc	ra,0x0
    8000131e:	9a0080e7          	jalr	-1632(ra) # 80000cba <memset>
  return pagetable;
}
    80001322:	8526                	mv	a0,s1
    80001324:	60e2                	ld	ra,24(sp)
    80001326:	6442                	ld	s0,16(sp)
    80001328:	64a2                	ld	s1,8(sp)
    8000132a:	6105                	add	sp,sp,32
    8000132c:	8082                	ret

000000008000132e <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000132e:	7179                	add	sp,sp,-48
    80001330:	f406                	sd	ra,40(sp)
    80001332:	f022                	sd	s0,32(sp)
    80001334:	ec26                	sd	s1,24(sp)
    80001336:	e84a                	sd	s2,16(sp)
    80001338:	e44e                	sd	s3,8(sp)
    8000133a:	e052                	sd	s4,0(sp)
    8000133c:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000133e:	6785                	lui	a5,0x1
    80001340:	04f67863          	bgeu	a2,a5,80001390 <uvminit+0x62>
    80001344:	8a2a                	mv	s4,a0
    80001346:	89ae                	mv	s3,a1
    80001348:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000134a:	fffff097          	auipc	ra,0xfffff
    8000134e:	784080e7          	jalr	1924(ra) # 80000ace <kalloc>
    80001352:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001354:	6605                	lui	a2,0x1
    80001356:	4581                	li	a1,0
    80001358:	00000097          	auipc	ra,0x0
    8000135c:	962080e7          	jalr	-1694(ra) # 80000cba <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001360:	4779                	li	a4,30
    80001362:	86ca                	mv	a3,s2
    80001364:	6605                	lui	a2,0x1
    80001366:	4581                	li	a1,0
    80001368:	8552                	mv	a0,s4
    8000136a:	00000097          	auipc	ra,0x0
    8000136e:	d1e080e7          	jalr	-738(ra) # 80001088 <mappages>
  memmove(mem, src, sz);
    80001372:	8626                	mv	a2,s1
    80001374:	85ce                	mv	a1,s3
    80001376:	854a                	mv	a0,s2
    80001378:	00000097          	auipc	ra,0x0
    8000137c:	99e080e7          	jalr	-1634(ra) # 80000d16 <memmove>
}
    80001380:	70a2                	ld	ra,40(sp)
    80001382:	7402                	ld	s0,32(sp)
    80001384:	64e2                	ld	s1,24(sp)
    80001386:	6942                	ld	s2,16(sp)
    80001388:	69a2                	ld	s3,8(sp)
    8000138a:	6a02                	ld	s4,0(sp)
    8000138c:	6145                	add	sp,sp,48
    8000138e:	8082                	ret
    panic("inituvm: more than a page");
    80001390:	00007517          	auipc	a0,0x7
    80001394:	db050513          	add	a0,a0,-592 # 80008140 <digits+0x100>
    80001398:	fffff097          	auipc	ra,0xfffff
    8000139c:	190080e7          	jalr	400(ra) # 80000528 <panic>

00000000800013a0 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013a0:	1101                	add	sp,sp,-32
    800013a2:	ec06                	sd	ra,24(sp)
    800013a4:	e822                	sd	s0,16(sp)
    800013a6:	e426                	sd	s1,8(sp)
    800013a8:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013aa:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013ac:	00b67d63          	bgeu	a2,a1,800013c6 <uvmdealloc+0x26>
    800013b0:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013b2:	6785                	lui	a5,0x1
    800013b4:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013b6:	00f60733          	add	a4,a2,a5
    800013ba:	76fd                	lui	a3,0xfffff
    800013bc:	8f75                	and	a4,a4,a3
    800013be:	97ae                	add	a5,a5,a1
    800013c0:	8ff5                	and	a5,a5,a3
    800013c2:	00f76863          	bltu	a4,a5,800013d2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800013c6:	8526                	mv	a0,s1
    800013c8:	60e2                	ld	ra,24(sp)
    800013ca:	6442                	ld	s0,16(sp)
    800013cc:	64a2                	ld	s1,8(sp)
    800013ce:	6105                	add	sp,sp,32
    800013d0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800013d2:	8f99                	sub	a5,a5,a4
    800013d4:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800013d6:	4685                	li	a3,1
    800013d8:	0007861b          	sext.w	a2,a5
    800013dc:	85ba                	mv	a1,a4
    800013de:	00000097          	auipc	ra,0x0
    800013e2:	e5e080e7          	jalr	-418(ra) # 8000123c <uvmunmap>
    800013e6:	b7c5                	j	800013c6 <uvmdealloc+0x26>

00000000800013e8 <uvmalloc>:
  if(newsz < oldsz)
    800013e8:	0ab66163          	bltu	a2,a1,8000148a <uvmalloc+0xa2>
{
    800013ec:	7139                	add	sp,sp,-64
    800013ee:	fc06                	sd	ra,56(sp)
    800013f0:	f822                	sd	s0,48(sp)
    800013f2:	f426                	sd	s1,40(sp)
    800013f4:	f04a                	sd	s2,32(sp)
    800013f6:	ec4e                	sd	s3,24(sp)
    800013f8:	e852                	sd	s4,16(sp)
    800013fa:	e456                	sd	s5,8(sp)
    800013fc:	0080                	add	s0,sp,64
    800013fe:	8aaa                	mv	s5,a0
    80001400:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001402:	6785                	lui	a5,0x1
    80001404:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001406:	95be                	add	a1,a1,a5
    80001408:	77fd                	lui	a5,0xfffff
    8000140a:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000140e:	08c9f063          	bgeu	s3,a2,8000148e <uvmalloc+0xa6>
    80001412:	894e                	mv	s2,s3
    mem = kalloc();
    80001414:	fffff097          	auipc	ra,0xfffff
    80001418:	6ba080e7          	jalr	1722(ra) # 80000ace <kalloc>
    8000141c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000141e:	c51d                	beqz	a0,8000144c <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001420:	6605                	lui	a2,0x1
    80001422:	4581                	li	a1,0
    80001424:	00000097          	auipc	ra,0x0
    80001428:	896080e7          	jalr	-1898(ra) # 80000cba <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    8000142c:	4779                	li	a4,30
    8000142e:	86a6                	mv	a3,s1
    80001430:	6605                	lui	a2,0x1
    80001432:	85ca                	mv	a1,s2
    80001434:	8556                	mv	a0,s5
    80001436:	00000097          	auipc	ra,0x0
    8000143a:	c52080e7          	jalr	-942(ra) # 80001088 <mappages>
    8000143e:	e905                	bnez	a0,8000146e <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001440:	6785                	lui	a5,0x1
    80001442:	993e                	add	s2,s2,a5
    80001444:	fd4968e3          	bltu	s2,s4,80001414 <uvmalloc+0x2c>
  return newsz;
    80001448:	8552                	mv	a0,s4
    8000144a:	a809                	j	8000145c <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000144c:	864e                	mv	a2,s3
    8000144e:	85ca                	mv	a1,s2
    80001450:	8556                	mv	a0,s5
    80001452:	00000097          	auipc	ra,0x0
    80001456:	f4e080e7          	jalr	-178(ra) # 800013a0 <uvmdealloc>
      return 0;
    8000145a:	4501                	li	a0,0
}
    8000145c:	70e2                	ld	ra,56(sp)
    8000145e:	7442                	ld	s0,48(sp)
    80001460:	74a2                	ld	s1,40(sp)
    80001462:	7902                	ld	s2,32(sp)
    80001464:	69e2                	ld	s3,24(sp)
    80001466:	6a42                	ld	s4,16(sp)
    80001468:	6aa2                	ld	s5,8(sp)
    8000146a:	6121                	add	sp,sp,64
    8000146c:	8082                	ret
      kfree(mem);
    8000146e:	8526                	mv	a0,s1
    80001470:	fffff097          	auipc	ra,0xfffff
    80001474:	560080e7          	jalr	1376(ra) # 800009d0 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001478:	864e                	mv	a2,s3
    8000147a:	85ca                	mv	a1,s2
    8000147c:	8556                	mv	a0,s5
    8000147e:	00000097          	auipc	ra,0x0
    80001482:	f22080e7          	jalr	-222(ra) # 800013a0 <uvmdealloc>
      return 0;
    80001486:	4501                	li	a0,0
    80001488:	bfd1                	j	8000145c <uvmalloc+0x74>
    return oldsz;
    8000148a:	852e                	mv	a0,a1
}
    8000148c:	8082                	ret
  return newsz;
    8000148e:	8532                	mv	a0,a2
    80001490:	b7f1                	j	8000145c <uvmalloc+0x74>

0000000080001492 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001492:	7179                	add	sp,sp,-48
    80001494:	f406                	sd	ra,40(sp)
    80001496:	f022                	sd	s0,32(sp)
    80001498:	ec26                	sd	s1,24(sp)
    8000149a:	e84a                	sd	s2,16(sp)
    8000149c:	e44e                	sd	s3,8(sp)
    8000149e:	e052                	sd	s4,0(sp)
    800014a0:	1800                	add	s0,sp,48
    800014a2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014a4:	84aa                	mv	s1,a0
    800014a6:	6905                	lui	s2,0x1
    800014a8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014aa:	4985                	li	s3,1
    800014ac:	a829                	j	800014c6 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014ae:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    800014b0:	00c79513          	sll	a0,a5,0xc
    800014b4:	00000097          	auipc	ra,0x0
    800014b8:	fde080e7          	jalr	-34(ra) # 80001492 <freewalk>
      pagetable[i] = 0;
    800014bc:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800014c0:	04a1                	add	s1,s1,8
    800014c2:	03248163          	beq	s1,s2,800014e4 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800014c6:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014c8:	00f7f713          	and	a4,a5,15
    800014cc:	ff3701e3          	beq	a4,s3,800014ae <freewalk+0x1c>
    } else if(pte & PTE_V){
    800014d0:	8b85                	and	a5,a5,1
    800014d2:	d7fd                	beqz	a5,800014c0 <freewalk+0x2e>
      panic("freewalk: leaf");
    800014d4:	00007517          	auipc	a0,0x7
    800014d8:	c8c50513          	add	a0,a0,-884 # 80008160 <digits+0x120>
    800014dc:	fffff097          	auipc	ra,0xfffff
    800014e0:	04c080e7          	jalr	76(ra) # 80000528 <panic>
    }
  }
  kfree((void*)pagetable);
    800014e4:	8552                	mv	a0,s4
    800014e6:	fffff097          	auipc	ra,0xfffff
    800014ea:	4ea080e7          	jalr	1258(ra) # 800009d0 <kfree>
}
    800014ee:	70a2                	ld	ra,40(sp)
    800014f0:	7402                	ld	s0,32(sp)
    800014f2:	64e2                	ld	s1,24(sp)
    800014f4:	6942                	ld	s2,16(sp)
    800014f6:	69a2                	ld	s3,8(sp)
    800014f8:	6a02                	ld	s4,0(sp)
    800014fa:	6145                	add	sp,sp,48
    800014fc:	8082                	ret

00000000800014fe <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800014fe:	1101                	add	sp,sp,-32
    80001500:	ec06                	sd	ra,24(sp)
    80001502:	e822                	sd	s0,16(sp)
    80001504:	e426                	sd	s1,8(sp)
    80001506:	1000                	add	s0,sp,32
    80001508:	84aa                	mv	s1,a0
  if(sz > 0)
    8000150a:	e999                	bnez	a1,80001520 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000150c:	8526                	mv	a0,s1
    8000150e:	00000097          	auipc	ra,0x0
    80001512:	f84080e7          	jalr	-124(ra) # 80001492 <freewalk>
}
    80001516:	60e2                	ld	ra,24(sp)
    80001518:	6442                	ld	s0,16(sp)
    8000151a:	64a2                	ld	s1,8(sp)
    8000151c:	6105                	add	sp,sp,32
    8000151e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001520:	6785                	lui	a5,0x1
    80001522:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001524:	95be                	add	a1,a1,a5
    80001526:	4685                	li	a3,1
    80001528:	00c5d613          	srl	a2,a1,0xc
    8000152c:	4581                	li	a1,0
    8000152e:	00000097          	auipc	ra,0x0
    80001532:	d0e080e7          	jalr	-754(ra) # 8000123c <uvmunmap>
    80001536:	bfd9                	j	8000150c <uvmfree+0xe>

0000000080001538 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001538:	c679                	beqz	a2,80001606 <uvmcopy+0xce>
{
    8000153a:	715d                	add	sp,sp,-80
    8000153c:	e486                	sd	ra,72(sp)
    8000153e:	e0a2                	sd	s0,64(sp)
    80001540:	fc26                	sd	s1,56(sp)
    80001542:	f84a                	sd	s2,48(sp)
    80001544:	f44e                	sd	s3,40(sp)
    80001546:	f052                	sd	s4,32(sp)
    80001548:	ec56                	sd	s5,24(sp)
    8000154a:	e85a                	sd	s6,16(sp)
    8000154c:	e45e                	sd	s7,8(sp)
    8000154e:	0880                	add	s0,sp,80
    80001550:	8b2a                	mv	s6,a0
    80001552:	8aae                	mv	s5,a1
    80001554:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001556:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001558:	4601                	li	a2,0
    8000155a:	85ce                	mv	a1,s3
    8000155c:	855a                	mv	a0,s6
    8000155e:	00000097          	auipc	ra,0x0
    80001562:	a42080e7          	jalr	-1470(ra) # 80000fa0 <walk>
    80001566:	c531                	beqz	a0,800015b2 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001568:	6118                	ld	a4,0(a0)
    8000156a:	00177793          	and	a5,a4,1
    8000156e:	cbb1                	beqz	a5,800015c2 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001570:	00a75593          	srl	a1,a4,0xa
    80001574:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001578:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000157c:	fffff097          	auipc	ra,0xfffff
    80001580:	552080e7          	jalr	1362(ra) # 80000ace <kalloc>
    80001584:	892a                	mv	s2,a0
    80001586:	c939                	beqz	a0,800015dc <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001588:	6605                	lui	a2,0x1
    8000158a:	85de                	mv	a1,s7
    8000158c:	fffff097          	auipc	ra,0xfffff
    80001590:	78a080e7          	jalr	1930(ra) # 80000d16 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001594:	8726                	mv	a4,s1
    80001596:	86ca                	mv	a3,s2
    80001598:	6605                	lui	a2,0x1
    8000159a:	85ce                	mv	a1,s3
    8000159c:	8556                	mv	a0,s5
    8000159e:	00000097          	auipc	ra,0x0
    800015a2:	aea080e7          	jalr	-1302(ra) # 80001088 <mappages>
    800015a6:	e515                	bnez	a0,800015d2 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800015a8:	6785                	lui	a5,0x1
    800015aa:	99be                	add	s3,s3,a5
    800015ac:	fb49e6e3          	bltu	s3,s4,80001558 <uvmcopy+0x20>
    800015b0:	a081                	j	800015f0 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800015b2:	00007517          	auipc	a0,0x7
    800015b6:	bbe50513          	add	a0,a0,-1090 # 80008170 <digits+0x130>
    800015ba:	fffff097          	auipc	ra,0xfffff
    800015be:	f6e080e7          	jalr	-146(ra) # 80000528 <panic>
      panic("uvmcopy: page not present");
    800015c2:	00007517          	auipc	a0,0x7
    800015c6:	bce50513          	add	a0,a0,-1074 # 80008190 <digits+0x150>
    800015ca:	fffff097          	auipc	ra,0xfffff
    800015ce:	f5e080e7          	jalr	-162(ra) # 80000528 <panic>
      kfree(mem);
    800015d2:	854a                	mv	a0,s2
    800015d4:	fffff097          	auipc	ra,0xfffff
    800015d8:	3fc080e7          	jalr	1020(ra) # 800009d0 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800015dc:	4685                	li	a3,1
    800015de:	00c9d613          	srl	a2,s3,0xc
    800015e2:	4581                	li	a1,0
    800015e4:	8556                	mv	a0,s5
    800015e6:	00000097          	auipc	ra,0x0
    800015ea:	c56080e7          	jalr	-938(ra) # 8000123c <uvmunmap>
  return -1;
    800015ee:	557d                	li	a0,-1
}
    800015f0:	60a6                	ld	ra,72(sp)
    800015f2:	6406                	ld	s0,64(sp)
    800015f4:	74e2                	ld	s1,56(sp)
    800015f6:	7942                	ld	s2,48(sp)
    800015f8:	79a2                	ld	s3,40(sp)
    800015fa:	7a02                	ld	s4,32(sp)
    800015fc:	6ae2                	ld	s5,24(sp)
    800015fe:	6b42                	ld	s6,16(sp)
    80001600:	6ba2                	ld	s7,8(sp)
    80001602:	6161                	add	sp,sp,80
    80001604:	8082                	ret
  return 0;
    80001606:	4501                	li	a0,0
}
    80001608:	8082                	ret

000000008000160a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000160a:	1141                	add	sp,sp,-16
    8000160c:	e406                	sd	ra,8(sp)
    8000160e:	e022                	sd	s0,0(sp)
    80001610:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001612:	4601                	li	a2,0
    80001614:	00000097          	auipc	ra,0x0
    80001618:	98c080e7          	jalr	-1652(ra) # 80000fa0 <walk>
  if(pte == 0)
    8000161c:	c901                	beqz	a0,8000162c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000161e:	611c                	ld	a5,0(a0)
    80001620:	9bbd                	and	a5,a5,-17
    80001622:	e11c                	sd	a5,0(a0)
}
    80001624:	60a2                	ld	ra,8(sp)
    80001626:	6402                	ld	s0,0(sp)
    80001628:	0141                	add	sp,sp,16
    8000162a:	8082                	ret
    panic("uvmclear");
    8000162c:	00007517          	auipc	a0,0x7
    80001630:	b8450513          	add	a0,a0,-1148 # 800081b0 <digits+0x170>
    80001634:	fffff097          	auipc	ra,0xfffff
    80001638:	ef4080e7          	jalr	-268(ra) # 80000528 <panic>

000000008000163c <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000163c:	c6bd                	beqz	a3,800016aa <copyout+0x6e>
{
    8000163e:	715d                	add	sp,sp,-80
    80001640:	e486                	sd	ra,72(sp)
    80001642:	e0a2                	sd	s0,64(sp)
    80001644:	fc26                	sd	s1,56(sp)
    80001646:	f84a                	sd	s2,48(sp)
    80001648:	f44e                	sd	s3,40(sp)
    8000164a:	f052                	sd	s4,32(sp)
    8000164c:	ec56                	sd	s5,24(sp)
    8000164e:	e85a                	sd	s6,16(sp)
    80001650:	e45e                	sd	s7,8(sp)
    80001652:	e062                	sd	s8,0(sp)
    80001654:	0880                	add	s0,sp,80
    80001656:	8b2a                	mv	s6,a0
    80001658:	8c2e                	mv	s8,a1
    8000165a:	8a32                	mv	s4,a2
    8000165c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000165e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001660:	6a85                	lui	s5,0x1
    80001662:	a015                	j	80001686 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001664:	9562                	add	a0,a0,s8
    80001666:	0004861b          	sext.w	a2,s1
    8000166a:	85d2                	mv	a1,s4
    8000166c:	41250533          	sub	a0,a0,s2
    80001670:	fffff097          	auipc	ra,0xfffff
    80001674:	6a6080e7          	jalr	1702(ra) # 80000d16 <memmove>

    len -= n;
    80001678:	409989b3          	sub	s3,s3,s1
    src += n;
    8000167c:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    8000167e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001682:	02098263          	beqz	s3,800016a6 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001686:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000168a:	85ca                	mv	a1,s2
    8000168c:	855a                	mv	a0,s6
    8000168e:	00000097          	auipc	ra,0x0
    80001692:	9b8080e7          	jalr	-1608(ra) # 80001046 <walkaddr>
    if(pa0 == 0)
    80001696:	cd01                	beqz	a0,800016ae <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001698:	418904b3          	sub	s1,s2,s8
    8000169c:	94d6                	add	s1,s1,s5
    8000169e:	fc99f3e3          	bgeu	s3,s1,80001664 <copyout+0x28>
    800016a2:	84ce                	mv	s1,s3
    800016a4:	b7c1                	j	80001664 <copyout+0x28>
  }
  return 0;
    800016a6:	4501                	li	a0,0
    800016a8:	a021                	j	800016b0 <copyout+0x74>
    800016aa:	4501                	li	a0,0
}
    800016ac:	8082                	ret
      return -1;
    800016ae:	557d                	li	a0,-1
}
    800016b0:	60a6                	ld	ra,72(sp)
    800016b2:	6406                	ld	s0,64(sp)
    800016b4:	74e2                	ld	s1,56(sp)
    800016b6:	7942                	ld	s2,48(sp)
    800016b8:	79a2                	ld	s3,40(sp)
    800016ba:	7a02                	ld	s4,32(sp)
    800016bc:	6ae2                	ld	s5,24(sp)
    800016be:	6b42                	ld	s6,16(sp)
    800016c0:	6ba2                	ld	s7,8(sp)
    800016c2:	6c02                	ld	s8,0(sp)
    800016c4:	6161                	add	sp,sp,80
    800016c6:	8082                	ret

00000000800016c8 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016c8:	caa5                	beqz	a3,80001738 <copyin+0x70>
{
    800016ca:	715d                	add	sp,sp,-80
    800016cc:	e486                	sd	ra,72(sp)
    800016ce:	e0a2                	sd	s0,64(sp)
    800016d0:	fc26                	sd	s1,56(sp)
    800016d2:	f84a                	sd	s2,48(sp)
    800016d4:	f44e                	sd	s3,40(sp)
    800016d6:	f052                	sd	s4,32(sp)
    800016d8:	ec56                	sd	s5,24(sp)
    800016da:	e85a                	sd	s6,16(sp)
    800016dc:	e45e                	sd	s7,8(sp)
    800016de:	e062                	sd	s8,0(sp)
    800016e0:	0880                	add	s0,sp,80
    800016e2:	8b2a                	mv	s6,a0
    800016e4:	8a2e                	mv	s4,a1
    800016e6:	8c32                	mv	s8,a2
    800016e8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800016ea:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016ec:	6a85                	lui	s5,0x1
    800016ee:	a01d                	j	80001714 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800016f0:	018505b3          	add	a1,a0,s8
    800016f4:	0004861b          	sext.w	a2,s1
    800016f8:	412585b3          	sub	a1,a1,s2
    800016fc:	8552                	mv	a0,s4
    800016fe:	fffff097          	auipc	ra,0xfffff
    80001702:	618080e7          	jalr	1560(ra) # 80000d16 <memmove>

    len -= n;
    80001706:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000170a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000170c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001710:	02098263          	beqz	s3,80001734 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001714:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001718:	85ca                	mv	a1,s2
    8000171a:	855a                	mv	a0,s6
    8000171c:	00000097          	auipc	ra,0x0
    80001720:	92a080e7          	jalr	-1750(ra) # 80001046 <walkaddr>
    if(pa0 == 0)
    80001724:	cd01                	beqz	a0,8000173c <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001726:	418904b3          	sub	s1,s2,s8
    8000172a:	94d6                	add	s1,s1,s5
    8000172c:	fc99f2e3          	bgeu	s3,s1,800016f0 <copyin+0x28>
    80001730:	84ce                	mv	s1,s3
    80001732:	bf7d                	j	800016f0 <copyin+0x28>
  }
  return 0;
    80001734:	4501                	li	a0,0
    80001736:	a021                	j	8000173e <copyin+0x76>
    80001738:	4501                	li	a0,0
}
    8000173a:	8082                	ret
      return -1;
    8000173c:	557d                	li	a0,-1
}
    8000173e:	60a6                	ld	ra,72(sp)
    80001740:	6406                	ld	s0,64(sp)
    80001742:	74e2                	ld	s1,56(sp)
    80001744:	7942                	ld	s2,48(sp)
    80001746:	79a2                	ld	s3,40(sp)
    80001748:	7a02                	ld	s4,32(sp)
    8000174a:	6ae2                	ld	s5,24(sp)
    8000174c:	6b42                	ld	s6,16(sp)
    8000174e:	6ba2                	ld	s7,8(sp)
    80001750:	6c02                	ld	s8,0(sp)
    80001752:	6161                	add	sp,sp,80
    80001754:	8082                	ret

0000000080001756 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001756:	c2dd                	beqz	a3,800017fc <copyinstr+0xa6>
{
    80001758:	715d                	add	sp,sp,-80
    8000175a:	e486                	sd	ra,72(sp)
    8000175c:	e0a2                	sd	s0,64(sp)
    8000175e:	fc26                	sd	s1,56(sp)
    80001760:	f84a                	sd	s2,48(sp)
    80001762:	f44e                	sd	s3,40(sp)
    80001764:	f052                	sd	s4,32(sp)
    80001766:	ec56                	sd	s5,24(sp)
    80001768:	e85a                	sd	s6,16(sp)
    8000176a:	e45e                	sd	s7,8(sp)
    8000176c:	0880                	add	s0,sp,80
    8000176e:	8a2a                	mv	s4,a0
    80001770:	8b2e                	mv	s6,a1
    80001772:	8bb2                	mv	s7,a2
    80001774:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001776:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001778:	6985                	lui	s3,0x1
    8000177a:	a02d                	j	800017a4 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000177c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001780:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001782:	37fd                	addw	a5,a5,-1
    80001784:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001788:	60a6                	ld	ra,72(sp)
    8000178a:	6406                	ld	s0,64(sp)
    8000178c:	74e2                	ld	s1,56(sp)
    8000178e:	7942                	ld	s2,48(sp)
    80001790:	79a2                	ld	s3,40(sp)
    80001792:	7a02                	ld	s4,32(sp)
    80001794:	6ae2                	ld	s5,24(sp)
    80001796:	6b42                	ld	s6,16(sp)
    80001798:	6ba2                	ld	s7,8(sp)
    8000179a:	6161                	add	sp,sp,80
    8000179c:	8082                	ret
    srcva = va0 + PGSIZE;
    8000179e:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017a2:	c8a9                	beqz	s1,800017f4 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    800017a4:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017a8:	85ca                	mv	a1,s2
    800017aa:	8552                	mv	a0,s4
    800017ac:	00000097          	auipc	ra,0x0
    800017b0:	89a080e7          	jalr	-1894(ra) # 80001046 <walkaddr>
    if(pa0 == 0)
    800017b4:	c131                	beqz	a0,800017f8 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    800017b6:	417906b3          	sub	a3,s2,s7
    800017ba:	96ce                	add	a3,a3,s3
    800017bc:	00d4f363          	bgeu	s1,a3,800017c2 <copyinstr+0x6c>
    800017c0:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800017c2:	955e                	add	a0,a0,s7
    800017c4:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800017c8:	daf9                	beqz	a3,8000179e <copyinstr+0x48>
    800017ca:	87da                	mv	a5,s6
    800017cc:	885a                	mv	a6,s6
      if(*p == '\0'){
    800017ce:	41650633          	sub	a2,a0,s6
    while(n > 0){
    800017d2:	96da                	add	a3,a3,s6
    800017d4:	85be                	mv	a1,a5
      if(*p == '\0'){
    800017d6:	00f60733          	add	a4,a2,a5
    800017da:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffde000>
    800017de:	df59                	beqz	a4,8000177c <copyinstr+0x26>
        *dst = *p;
    800017e0:	00e78023          	sb	a4,0(a5)
      dst++;
    800017e4:	0785                	add	a5,a5,1
    while(n > 0){
    800017e6:	fed797e3          	bne	a5,a3,800017d4 <copyinstr+0x7e>
    800017ea:	14fd                	add	s1,s1,-1
    800017ec:	94c2                	add	s1,s1,a6
      --max;
    800017ee:	8c8d                	sub	s1,s1,a1
      dst++;
    800017f0:	8b3e                	mv	s6,a5
    800017f2:	b775                	j	8000179e <copyinstr+0x48>
    800017f4:	4781                	li	a5,0
    800017f6:	b771                	j	80001782 <copyinstr+0x2c>
      return -1;
    800017f8:	557d                	li	a0,-1
    800017fa:	b779                	j	80001788 <copyinstr+0x32>
  int got_null = 0;
    800017fc:	4781                	li	a5,0
  if(got_null){
    800017fe:	37fd                	addw	a5,a5,-1
    80001800:	0007851b          	sext.w	a0,a5
}
    80001804:	8082                	ret

0000000080001806 <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    80001806:	1101                	add	sp,sp,-32
    80001808:	ec06                	sd	ra,24(sp)
    8000180a:	e822                	sd	s0,16(sp)
    8000180c:	e426                	sd	s1,8(sp)
    8000180e:	1000                	add	s0,sp,32
    80001810:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001812:	fffff097          	auipc	ra,0xfffff
    80001816:	332080e7          	jalr	818(ra) # 80000b44 <holding>
    8000181a:	c909                	beqz	a0,8000182c <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    8000181c:	749c                	ld	a5,40(s1)
    8000181e:	00978f63          	beq	a5,s1,8000183c <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    80001822:	60e2                	ld	ra,24(sp)
    80001824:	6442                	ld	s0,16(sp)
    80001826:	64a2                	ld	s1,8(sp)
    80001828:	6105                	add	sp,sp,32
    8000182a:	8082                	ret
    panic("wakeup1");
    8000182c:	00007517          	auipc	a0,0x7
    80001830:	99450513          	add	a0,a0,-1644 # 800081c0 <digits+0x180>
    80001834:	fffff097          	auipc	ra,0xfffff
    80001838:	cf4080e7          	jalr	-780(ra) # 80000528 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    8000183c:	4c98                	lw	a4,24(s1)
    8000183e:	4785                	li	a5,1
    80001840:	fef711e3          	bne	a4,a5,80001822 <wakeup1+0x1c>
    p->state = RUNNABLE;
    80001844:	4789                	li	a5,2
    80001846:	cc9c                	sw	a5,24(s1)
}
    80001848:	bfe9                	j	80001822 <wakeup1+0x1c>

000000008000184a <proc_mapstacks>:
proc_mapstacks(pagetable_t kpgtbl) {
    8000184a:	7139                	add	sp,sp,-64
    8000184c:	fc06                	sd	ra,56(sp)
    8000184e:	f822                	sd	s0,48(sp)
    80001850:	f426                	sd	s1,40(sp)
    80001852:	f04a                	sd	s2,32(sp)
    80001854:	ec4e                	sd	s3,24(sp)
    80001856:	e852                	sd	s4,16(sp)
    80001858:	e456                	sd	s5,8(sp)
    8000185a:	e05a                	sd	s6,0(sp)
    8000185c:	0080                	add	s0,sp,64
    8000185e:	89aa                	mv	s3,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80001860:	00010497          	auipc	s1,0x10
    80001864:	e5848493          	add	s1,s1,-424 # 800116b8 <proc>
    uint64 va = KSTACK((int) (p - proc));
    80001868:	8b26                	mv	s6,s1
    8000186a:	00006a97          	auipc	s5,0x6
    8000186e:	796a8a93          	add	s5,s5,1942 # 80008000 <etext>
    80001872:	04000937          	lui	s2,0x4000
    80001876:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001878:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000187a:	00011a17          	auipc	s4,0x11
    8000187e:	c4ea0a13          	add	s4,s4,-946 # 800124c8 <tickslock>
    char *pa = kalloc();
    80001882:	fffff097          	auipc	ra,0xfffff
    80001886:	24c080e7          	jalr	588(ra) # 80000ace <kalloc>
    8000188a:	862a                	mv	a2,a0
    if(pa == 0)
    8000188c:	c131                	beqz	a0,800018d0 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    8000188e:	416485b3          	sub	a1,s1,s6
    80001892:	858d                	sra	a1,a1,0x3
    80001894:	000ab783          	ld	a5,0(s5)
    80001898:	02f585b3          	mul	a1,a1,a5
    8000189c:	2585                	addw	a1,a1,1
    8000189e:	00d5959b          	sllw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800018a2:	4719                	li	a4,6
    800018a4:	6685                	lui	a3,0x1
    800018a6:	40b905b3          	sub	a1,s2,a1
    800018aa:	854e                	mv	a0,s3
    800018ac:	00000097          	auipc	ra,0x0
    800018b0:	86a080e7          	jalr	-1942(ra) # 80001116 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018b4:	16848493          	add	s1,s1,360
    800018b8:	fd4495e3          	bne	s1,s4,80001882 <proc_mapstacks+0x38>
}
    800018bc:	70e2                	ld	ra,56(sp)
    800018be:	7442                	ld	s0,48(sp)
    800018c0:	74a2                	ld	s1,40(sp)
    800018c2:	7902                	ld	s2,32(sp)
    800018c4:	69e2                	ld	s3,24(sp)
    800018c6:	6a42                	ld	s4,16(sp)
    800018c8:	6aa2                	ld	s5,8(sp)
    800018ca:	6b02                	ld	s6,0(sp)
    800018cc:	6121                	add	sp,sp,64
    800018ce:	8082                	ret
      panic("kalloc");
    800018d0:	00007517          	auipc	a0,0x7
    800018d4:	8f850513          	add	a0,a0,-1800 # 800081c8 <digits+0x188>
    800018d8:	fffff097          	auipc	ra,0xfffff
    800018dc:	c50080e7          	jalr	-944(ra) # 80000528 <panic>

00000000800018e0 <procinit>:
{
    800018e0:	7139                	add	sp,sp,-64
    800018e2:	fc06                	sd	ra,56(sp)
    800018e4:	f822                	sd	s0,48(sp)
    800018e6:	f426                	sd	s1,40(sp)
    800018e8:	f04a                	sd	s2,32(sp)
    800018ea:	ec4e                	sd	s3,24(sp)
    800018ec:	e852                	sd	s4,16(sp)
    800018ee:	e456                	sd	s5,8(sp)
    800018f0:	e05a                	sd	s6,0(sp)
    800018f2:	0080                	add	s0,sp,64
  initlock(&pid_lock, "nextpid");
    800018f4:	00007597          	auipc	a1,0x7
    800018f8:	8dc58593          	add	a1,a1,-1828 # 800081d0 <digits+0x190>
    800018fc:	00010517          	auipc	a0,0x10
    80001900:	9a450513          	add	a0,a0,-1628 # 800112a0 <pid_lock>
    80001904:	fffff097          	auipc	ra,0xfffff
    80001908:	22a080e7          	jalr	554(ra) # 80000b2e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000190c:	00010497          	auipc	s1,0x10
    80001910:	dac48493          	add	s1,s1,-596 # 800116b8 <proc>
      initlock(&p->lock, "proc");
    80001914:	00007b17          	auipc	s6,0x7
    80001918:	8c4b0b13          	add	s6,s6,-1852 # 800081d8 <digits+0x198>
      p->kstack = KSTACK((int) (p - proc));
    8000191c:	8aa6                	mv	s5,s1
    8000191e:	00006a17          	auipc	s4,0x6
    80001922:	6e2a0a13          	add	s4,s4,1762 # 80008000 <etext>
    80001926:	04000937          	lui	s2,0x4000
    8000192a:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    8000192c:	0932                	sll	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000192e:	00011997          	auipc	s3,0x11
    80001932:	b9a98993          	add	s3,s3,-1126 # 800124c8 <tickslock>
      initlock(&p->lock, "proc");
    80001936:	85da                	mv	a1,s6
    80001938:	8526                	mv	a0,s1
    8000193a:	fffff097          	auipc	ra,0xfffff
    8000193e:	1f4080e7          	jalr	500(ra) # 80000b2e <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80001942:	415487b3          	sub	a5,s1,s5
    80001946:	878d                	sra	a5,a5,0x3
    80001948:	000a3703          	ld	a4,0(s4)
    8000194c:	02e787b3          	mul	a5,a5,a4
    80001950:	2785                	addw	a5,a5,1
    80001952:	00d7979b          	sllw	a5,a5,0xd
    80001956:	40f907b3          	sub	a5,s2,a5
    8000195a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000195c:	16848493          	add	s1,s1,360
    80001960:	fd349be3          	bne	s1,s3,80001936 <procinit+0x56>
}
    80001964:	70e2                	ld	ra,56(sp)
    80001966:	7442                	ld	s0,48(sp)
    80001968:	74a2                	ld	s1,40(sp)
    8000196a:	7902                	ld	s2,32(sp)
    8000196c:	69e2                	ld	s3,24(sp)
    8000196e:	6a42                	ld	s4,16(sp)
    80001970:	6aa2                	ld	s5,8(sp)
    80001972:	6b02                	ld	s6,0(sp)
    80001974:	6121                	add	sp,sp,64
    80001976:	8082                	ret

0000000080001978 <cpuid>:
{
    80001978:	1141                	add	sp,sp,-16
    8000197a:	e422                	sd	s0,8(sp)
    8000197c:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000197e:	8512                	mv	a0,tp
}
    80001980:	2501                	sext.w	a0,a0
    80001982:	6422                	ld	s0,8(sp)
    80001984:	0141                	add	sp,sp,16
    80001986:	8082                	ret

0000000080001988 <mycpu>:
mycpu(void) {
    80001988:	1141                	add	sp,sp,-16
    8000198a:	e422                	sd	s0,8(sp)
    8000198c:	0800                	add	s0,sp,16
    8000198e:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001990:	2781                	sext.w	a5,a5
    80001992:	079e                	sll	a5,a5,0x7
}
    80001994:	00010517          	auipc	a0,0x10
    80001998:	92450513          	add	a0,a0,-1756 # 800112b8 <cpus>
    8000199c:	953e                	add	a0,a0,a5
    8000199e:	6422                	ld	s0,8(sp)
    800019a0:	0141                	add	sp,sp,16
    800019a2:	8082                	ret

00000000800019a4 <myproc>:
myproc(void) {
    800019a4:	1101                	add	sp,sp,-32
    800019a6:	ec06                	sd	ra,24(sp)
    800019a8:	e822                	sd	s0,16(sp)
    800019aa:	e426                	sd	s1,8(sp)
    800019ac:	1000                	add	s0,sp,32
  push_off();
    800019ae:	fffff097          	auipc	ra,0xfffff
    800019b2:	1c4080e7          	jalr	452(ra) # 80000b72 <push_off>
    800019b6:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    800019b8:	2781                	sext.w	a5,a5
    800019ba:	079e                	sll	a5,a5,0x7
    800019bc:	00010717          	auipc	a4,0x10
    800019c0:	8e470713          	add	a4,a4,-1820 # 800112a0 <pid_lock>
    800019c4:	97ba                	add	a5,a5,a4
    800019c6:	6f84                	ld	s1,24(a5)
  pop_off();
    800019c8:	fffff097          	auipc	ra,0xfffff
    800019cc:	24a080e7          	jalr	586(ra) # 80000c12 <pop_off>
}
    800019d0:	8526                	mv	a0,s1
    800019d2:	60e2                	ld	ra,24(sp)
    800019d4:	6442                	ld	s0,16(sp)
    800019d6:	64a2                	ld	s1,8(sp)
    800019d8:	6105                	add	sp,sp,32
    800019da:	8082                	ret

00000000800019dc <forkret>:
{
    800019dc:	1141                	add	sp,sp,-16
    800019de:	e406                	sd	ra,8(sp)
    800019e0:	e022                	sd	s0,0(sp)
    800019e2:	0800                	add	s0,sp,16
  release(&myproc()->lock);
    800019e4:	00000097          	auipc	ra,0x0
    800019e8:	fc0080e7          	jalr	-64(ra) # 800019a4 <myproc>
    800019ec:	fffff097          	auipc	ra,0xfffff
    800019f0:	286080e7          	jalr	646(ra) # 80000c72 <release>
  if (first) {
    800019f4:	00007797          	auipc	a5,0x7
    800019f8:	dfc7a783          	lw	a5,-516(a5) # 800087f0 <first.1>
    800019fc:	eb89                	bnez	a5,80001a0e <forkret+0x32>
  usertrapret();
    800019fe:	00001097          	auipc	ra,0x1
    80001a02:	c1c080e7          	jalr	-996(ra) # 8000261a <usertrapret>
}
    80001a06:	60a2                	ld	ra,8(sp)
    80001a08:	6402                	ld	s0,0(sp)
    80001a0a:	0141                	add	sp,sp,16
    80001a0c:	8082                	ret
    first = 0;
    80001a0e:	00007797          	auipc	a5,0x7
    80001a12:	de07a123          	sw	zero,-542(a5) # 800087f0 <first.1>
    fsinit(ROOTDEV);
    80001a16:	4505                	li	a0,1
    80001a18:	00002097          	auipc	ra,0x2
    80001a1c:	a0a080e7          	jalr	-1526(ra) # 80003422 <fsinit>
    80001a20:	bff9                	j	800019fe <forkret+0x22>

0000000080001a22 <allocpid>:
allocpid() {
    80001a22:	1101                	add	sp,sp,-32
    80001a24:	ec06                	sd	ra,24(sp)
    80001a26:	e822                	sd	s0,16(sp)
    80001a28:	e426                	sd	s1,8(sp)
    80001a2a:	e04a                	sd	s2,0(sp)
    80001a2c:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    80001a2e:	00010917          	auipc	s2,0x10
    80001a32:	87290913          	add	s2,s2,-1934 # 800112a0 <pid_lock>
    80001a36:	854a                	mv	a0,s2
    80001a38:	fffff097          	auipc	ra,0xfffff
    80001a3c:	186080e7          	jalr	390(ra) # 80000bbe <acquire>
  pid = nextpid;
    80001a40:	00007797          	auipc	a5,0x7
    80001a44:	db478793          	add	a5,a5,-588 # 800087f4 <nextpid>
    80001a48:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a4a:	0014871b          	addw	a4,s1,1
    80001a4e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a50:	854a                	mv	a0,s2
    80001a52:	fffff097          	auipc	ra,0xfffff
    80001a56:	220080e7          	jalr	544(ra) # 80000c72 <release>
}
    80001a5a:	8526                	mv	a0,s1
    80001a5c:	60e2                	ld	ra,24(sp)
    80001a5e:	6442                	ld	s0,16(sp)
    80001a60:	64a2                	ld	s1,8(sp)
    80001a62:	6902                	ld	s2,0(sp)
    80001a64:	6105                	add	sp,sp,32
    80001a66:	8082                	ret

0000000080001a68 <proc_pagetable>:
{
    80001a68:	1101                	add	sp,sp,-32
    80001a6a:	ec06                	sd	ra,24(sp)
    80001a6c:	e822                	sd	s0,16(sp)
    80001a6e:	e426                	sd	s1,8(sp)
    80001a70:	e04a                	sd	s2,0(sp)
    80001a72:	1000                	add	s0,sp,32
    80001a74:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a76:	00000097          	auipc	ra,0x0
    80001a7a:	88a080e7          	jalr	-1910(ra) # 80001300 <uvmcreate>
    80001a7e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a80:	c121                	beqz	a0,80001ac0 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a82:	4729                	li	a4,10
    80001a84:	00005697          	auipc	a3,0x5
    80001a88:	57c68693          	add	a3,a3,1404 # 80007000 <_trampoline>
    80001a8c:	6605                	lui	a2,0x1
    80001a8e:	040005b7          	lui	a1,0x4000
    80001a92:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a94:	05b2                	sll	a1,a1,0xc
    80001a96:	fffff097          	auipc	ra,0xfffff
    80001a9a:	5f2080e7          	jalr	1522(ra) # 80001088 <mappages>
    80001a9e:	02054863          	bltz	a0,80001ace <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001aa2:	4719                	li	a4,6
    80001aa4:	05893683          	ld	a3,88(s2)
    80001aa8:	6605                	lui	a2,0x1
    80001aaa:	020005b7          	lui	a1,0x2000
    80001aae:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001ab0:	05b6                	sll	a1,a1,0xd
    80001ab2:	8526                	mv	a0,s1
    80001ab4:	fffff097          	auipc	ra,0xfffff
    80001ab8:	5d4080e7          	jalr	1492(ra) # 80001088 <mappages>
    80001abc:	02054163          	bltz	a0,80001ade <proc_pagetable+0x76>
}
    80001ac0:	8526                	mv	a0,s1
    80001ac2:	60e2                	ld	ra,24(sp)
    80001ac4:	6442                	ld	s0,16(sp)
    80001ac6:	64a2                	ld	s1,8(sp)
    80001ac8:	6902                	ld	s2,0(sp)
    80001aca:	6105                	add	sp,sp,32
    80001acc:	8082                	ret
    uvmfree(pagetable, 0);
    80001ace:	4581                	li	a1,0
    80001ad0:	8526                	mv	a0,s1
    80001ad2:	00000097          	auipc	ra,0x0
    80001ad6:	a2c080e7          	jalr	-1492(ra) # 800014fe <uvmfree>
    return 0;
    80001ada:	4481                	li	s1,0
    80001adc:	b7d5                	j	80001ac0 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ade:	4681                	li	a3,0
    80001ae0:	4605                	li	a2,1
    80001ae2:	040005b7          	lui	a1,0x4000
    80001ae6:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ae8:	05b2                	sll	a1,a1,0xc
    80001aea:	8526                	mv	a0,s1
    80001aec:	fffff097          	auipc	ra,0xfffff
    80001af0:	750080e7          	jalr	1872(ra) # 8000123c <uvmunmap>
    uvmfree(pagetable, 0);
    80001af4:	4581                	li	a1,0
    80001af6:	8526                	mv	a0,s1
    80001af8:	00000097          	auipc	ra,0x0
    80001afc:	a06080e7          	jalr	-1530(ra) # 800014fe <uvmfree>
    return 0;
    80001b00:	4481                	li	s1,0
    80001b02:	bf7d                	j	80001ac0 <proc_pagetable+0x58>

0000000080001b04 <proc_freepagetable>:
{
    80001b04:	1101                	add	sp,sp,-32
    80001b06:	ec06                	sd	ra,24(sp)
    80001b08:	e822                	sd	s0,16(sp)
    80001b0a:	e426                	sd	s1,8(sp)
    80001b0c:	e04a                	sd	s2,0(sp)
    80001b0e:	1000                	add	s0,sp,32
    80001b10:	84aa                	mv	s1,a0
    80001b12:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b14:	4681                	li	a3,0
    80001b16:	4605                	li	a2,1
    80001b18:	040005b7          	lui	a1,0x4000
    80001b1c:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b1e:	05b2                	sll	a1,a1,0xc
    80001b20:	fffff097          	auipc	ra,0xfffff
    80001b24:	71c080e7          	jalr	1820(ra) # 8000123c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b28:	4681                	li	a3,0
    80001b2a:	4605                	li	a2,1
    80001b2c:	020005b7          	lui	a1,0x2000
    80001b30:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b32:	05b6                	sll	a1,a1,0xd
    80001b34:	8526                	mv	a0,s1
    80001b36:	fffff097          	auipc	ra,0xfffff
    80001b3a:	706080e7          	jalr	1798(ra) # 8000123c <uvmunmap>
  uvmfree(pagetable, sz);
    80001b3e:	85ca                	mv	a1,s2
    80001b40:	8526                	mv	a0,s1
    80001b42:	00000097          	auipc	ra,0x0
    80001b46:	9bc080e7          	jalr	-1604(ra) # 800014fe <uvmfree>
}
    80001b4a:	60e2                	ld	ra,24(sp)
    80001b4c:	6442                	ld	s0,16(sp)
    80001b4e:	64a2                	ld	s1,8(sp)
    80001b50:	6902                	ld	s2,0(sp)
    80001b52:	6105                	add	sp,sp,32
    80001b54:	8082                	ret

0000000080001b56 <freeproc>:
{
    80001b56:	1101                	add	sp,sp,-32
    80001b58:	ec06                	sd	ra,24(sp)
    80001b5a:	e822                	sd	s0,16(sp)
    80001b5c:	e426                	sd	s1,8(sp)
    80001b5e:	1000                	add	s0,sp,32
    80001b60:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b62:	6d28                	ld	a0,88(a0)
    80001b64:	c509                	beqz	a0,80001b6e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001b66:	fffff097          	auipc	ra,0xfffff
    80001b6a:	e6a080e7          	jalr	-406(ra) # 800009d0 <kfree>
  p->trapframe = 0;
    80001b6e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b72:	68a8                	ld	a0,80(s1)
    80001b74:	c511                	beqz	a0,80001b80 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001b76:	64ac                	ld	a1,72(s1)
    80001b78:	00000097          	auipc	ra,0x0
    80001b7c:	f8c080e7          	jalr	-116(ra) # 80001b04 <proc_freepagetable>
  p->pagetable = 0;
    80001b80:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b84:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b88:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001b8c:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001b90:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b94:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001b98:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001b9c:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001ba0:	0004ac23          	sw	zero,24(s1)
}
    80001ba4:	60e2                	ld	ra,24(sp)
    80001ba6:	6442                	ld	s0,16(sp)
    80001ba8:	64a2                	ld	s1,8(sp)
    80001baa:	6105                	add	sp,sp,32
    80001bac:	8082                	ret

0000000080001bae <allocproc>:
{
    80001bae:	1101                	add	sp,sp,-32
    80001bb0:	ec06                	sd	ra,24(sp)
    80001bb2:	e822                	sd	s0,16(sp)
    80001bb4:	e426                	sd	s1,8(sp)
    80001bb6:	e04a                	sd	s2,0(sp)
    80001bb8:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bba:	00010497          	auipc	s1,0x10
    80001bbe:	afe48493          	add	s1,s1,-1282 # 800116b8 <proc>
    80001bc2:	00011917          	auipc	s2,0x11
    80001bc6:	90690913          	add	s2,s2,-1786 # 800124c8 <tickslock>
    acquire(&p->lock);
    80001bca:	8526                	mv	a0,s1
    80001bcc:	fffff097          	auipc	ra,0xfffff
    80001bd0:	ff2080e7          	jalr	-14(ra) # 80000bbe <acquire>
    if(p->state == UNUSED) {
    80001bd4:	4c9c                	lw	a5,24(s1)
    80001bd6:	c395                	beqz	a5,80001bfa <allocproc+0x4c>
      release(&p->lock);
    80001bd8:	8526                	mv	a0,s1
    80001bda:	fffff097          	auipc	ra,0xfffff
    80001bde:	098080e7          	jalr	152(ra) # 80000c72 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001be2:	16848493          	add	s1,s1,360
    80001be6:	ff2492e3          	bne	s1,s2,80001bca <allocproc+0x1c>
  return 0;
    80001bea:	4481                	li	s1,0
}
    80001bec:	8526                	mv	a0,s1
    80001bee:	60e2                	ld	ra,24(sp)
    80001bf0:	6442                	ld	s0,16(sp)
    80001bf2:	64a2                	ld	s1,8(sp)
    80001bf4:	6902                	ld	s2,0(sp)
    80001bf6:	6105                	add	sp,sp,32
    80001bf8:	8082                	ret
  p->pid = allocpid();
    80001bfa:	00000097          	auipc	ra,0x0
    80001bfe:	e28080e7          	jalr	-472(ra) # 80001a22 <allocpid>
    80001c02:	dc88                	sw	a0,56(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c04:	fffff097          	auipc	ra,0xfffff
    80001c08:	eca080e7          	jalr	-310(ra) # 80000ace <kalloc>
    80001c0c:	892a                	mv	s2,a0
    80001c0e:	eca8                	sd	a0,88(s1)
    80001c10:	cd05                	beqz	a0,80001c48 <allocproc+0x9a>
  p->pagetable = proc_pagetable(p);
    80001c12:	8526                	mv	a0,s1
    80001c14:	00000097          	auipc	ra,0x0
    80001c18:	e54080e7          	jalr	-428(ra) # 80001a68 <proc_pagetable>
    80001c1c:	892a                	mv	s2,a0
    80001c1e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c20:	c91d                	beqz	a0,80001c56 <allocproc+0xa8>
  memset(&p->context, 0, sizeof(p->context));
    80001c22:	07000613          	li	a2,112
    80001c26:	4581                	li	a1,0
    80001c28:	06048513          	add	a0,s1,96
    80001c2c:	fffff097          	auipc	ra,0xfffff
    80001c30:	08e080e7          	jalr	142(ra) # 80000cba <memset>
  p->context.ra = (uint64)forkret;
    80001c34:	00000797          	auipc	a5,0x0
    80001c38:	da878793          	add	a5,a5,-600 # 800019dc <forkret>
    80001c3c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c3e:	60bc                	ld	a5,64(s1)
    80001c40:	6705                	lui	a4,0x1
    80001c42:	97ba                	add	a5,a5,a4
    80001c44:	f4bc                	sd	a5,104(s1)
  return p;
    80001c46:	b75d                	j	80001bec <allocproc+0x3e>
    release(&p->lock);
    80001c48:	8526                	mv	a0,s1
    80001c4a:	fffff097          	auipc	ra,0xfffff
    80001c4e:	028080e7          	jalr	40(ra) # 80000c72 <release>
    return 0;
    80001c52:	84ca                	mv	s1,s2
    80001c54:	bf61                	j	80001bec <allocproc+0x3e>
    freeproc(p);
    80001c56:	8526                	mv	a0,s1
    80001c58:	00000097          	auipc	ra,0x0
    80001c5c:	efe080e7          	jalr	-258(ra) # 80001b56 <freeproc>
    release(&p->lock);
    80001c60:	8526                	mv	a0,s1
    80001c62:	fffff097          	auipc	ra,0xfffff
    80001c66:	010080e7          	jalr	16(ra) # 80000c72 <release>
    return 0;
    80001c6a:	84ca                	mv	s1,s2
    80001c6c:	b741                	j	80001bec <allocproc+0x3e>

0000000080001c6e <userinit>:
{
    80001c6e:	1101                	add	sp,sp,-32
    80001c70:	ec06                	sd	ra,24(sp)
    80001c72:	e822                	sd	s0,16(sp)
    80001c74:	e426                	sd	s1,8(sp)
    80001c76:	1000                	add	s0,sp,32
  p = allocproc();
    80001c78:	00000097          	auipc	ra,0x0
    80001c7c:	f36080e7          	jalr	-202(ra) # 80001bae <allocproc>
    80001c80:	84aa                	mv	s1,a0
  initproc = p;
    80001c82:	00007797          	auipc	a5,0x7
    80001c86:	3aa7b323          	sd	a0,934(a5) # 80009028 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001c8a:	03400613          	li	a2,52
    80001c8e:	00007597          	auipc	a1,0x7
    80001c92:	b7258593          	add	a1,a1,-1166 # 80008800 <initcode>
    80001c96:	6928                	ld	a0,80(a0)
    80001c98:	fffff097          	auipc	ra,0xfffff
    80001c9c:	696080e7          	jalr	1686(ra) # 8000132e <uvminit>
  p->sz = PGSIZE;
    80001ca0:	6785                	lui	a5,0x1
    80001ca2:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001ca4:	6cb8                	ld	a4,88(s1)
    80001ca6:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001caa:	6cb8                	ld	a4,88(s1)
    80001cac:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001cae:	4641                	li	a2,16
    80001cb0:	00006597          	auipc	a1,0x6
    80001cb4:	53058593          	add	a1,a1,1328 # 800081e0 <digits+0x1a0>
    80001cb8:	15848513          	add	a0,s1,344
    80001cbc:	fffff097          	auipc	ra,0xfffff
    80001cc0:	14e080e7          	jalr	334(ra) # 80000e0a <safestrcpy>
  p->cwd = namei("/");
    80001cc4:	00006517          	auipc	a0,0x6
    80001cc8:	52c50513          	add	a0,a0,1324 # 800081f0 <digits+0x1b0>
    80001ccc:	00002097          	auipc	ra,0x2
    80001cd0:	228080e7          	jalr	552(ra) # 80003ef4 <namei>
    80001cd4:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001cd8:	4789                	li	a5,2
    80001cda:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001cdc:	8526                	mv	a0,s1
    80001cde:	fffff097          	auipc	ra,0xfffff
    80001ce2:	f94080e7          	jalr	-108(ra) # 80000c72 <release>
}
    80001ce6:	60e2                	ld	ra,24(sp)
    80001ce8:	6442                	ld	s0,16(sp)
    80001cea:	64a2                	ld	s1,8(sp)
    80001cec:	6105                	add	sp,sp,32
    80001cee:	8082                	ret

0000000080001cf0 <growproc>:
{
    80001cf0:	1101                	add	sp,sp,-32
    80001cf2:	ec06                	sd	ra,24(sp)
    80001cf4:	e822                	sd	s0,16(sp)
    80001cf6:	e426                	sd	s1,8(sp)
    80001cf8:	e04a                	sd	s2,0(sp)
    80001cfa:	1000                	add	s0,sp,32
    80001cfc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001cfe:	00000097          	auipc	ra,0x0
    80001d02:	ca6080e7          	jalr	-858(ra) # 800019a4 <myproc>
    80001d06:	892a                	mv	s2,a0
  sz = p->sz;
    80001d08:	652c                	ld	a1,72(a0)
    80001d0a:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001d0e:	00904f63          	bgtz	s1,80001d2c <growproc+0x3c>
  } else if(n < 0){
    80001d12:	0204cd63          	bltz	s1,80001d4c <growproc+0x5c>
  p->sz = sz;
    80001d16:	1782                	sll	a5,a5,0x20
    80001d18:	9381                	srl	a5,a5,0x20
    80001d1a:	04f93423          	sd	a5,72(s2)
  return 0;
    80001d1e:	4501                	li	a0,0
}
    80001d20:	60e2                	ld	ra,24(sp)
    80001d22:	6442                	ld	s0,16(sp)
    80001d24:	64a2                	ld	s1,8(sp)
    80001d26:	6902                	ld	s2,0(sp)
    80001d28:	6105                	add	sp,sp,32
    80001d2a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001d2c:	00f4863b          	addw	a2,s1,a5
    80001d30:	1602                	sll	a2,a2,0x20
    80001d32:	9201                	srl	a2,a2,0x20
    80001d34:	1582                	sll	a1,a1,0x20
    80001d36:	9181                	srl	a1,a1,0x20
    80001d38:	6928                	ld	a0,80(a0)
    80001d3a:	fffff097          	auipc	ra,0xfffff
    80001d3e:	6ae080e7          	jalr	1710(ra) # 800013e8 <uvmalloc>
    80001d42:	0005079b          	sext.w	a5,a0
    80001d46:	fbe1                	bnez	a5,80001d16 <growproc+0x26>
      return -1;
    80001d48:	557d                	li	a0,-1
    80001d4a:	bfd9                	j	80001d20 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d4c:	00f4863b          	addw	a2,s1,a5
    80001d50:	1602                	sll	a2,a2,0x20
    80001d52:	9201                	srl	a2,a2,0x20
    80001d54:	1582                	sll	a1,a1,0x20
    80001d56:	9181                	srl	a1,a1,0x20
    80001d58:	6928                	ld	a0,80(a0)
    80001d5a:	fffff097          	auipc	ra,0xfffff
    80001d5e:	646080e7          	jalr	1606(ra) # 800013a0 <uvmdealloc>
    80001d62:	0005079b          	sext.w	a5,a0
    80001d66:	bf45                	j	80001d16 <growproc+0x26>

0000000080001d68 <fork>:
{
    80001d68:	7139                	add	sp,sp,-64
    80001d6a:	fc06                	sd	ra,56(sp)
    80001d6c:	f822                	sd	s0,48(sp)
    80001d6e:	f426                	sd	s1,40(sp)
    80001d70:	f04a                	sd	s2,32(sp)
    80001d72:	ec4e                	sd	s3,24(sp)
    80001d74:	e852                	sd	s4,16(sp)
    80001d76:	e456                	sd	s5,8(sp)
    80001d78:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    80001d7a:	00000097          	auipc	ra,0x0
    80001d7e:	c2a080e7          	jalr	-982(ra) # 800019a4 <myproc>
    80001d82:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001d84:	00000097          	auipc	ra,0x0
    80001d88:	e2a080e7          	jalr	-470(ra) # 80001bae <allocproc>
    80001d8c:	c17d                	beqz	a0,80001e72 <fork+0x10a>
    80001d8e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001d90:	048ab603          	ld	a2,72(s5)
    80001d94:	692c                	ld	a1,80(a0)
    80001d96:	050ab503          	ld	a0,80(s5)
    80001d9a:	fffff097          	auipc	ra,0xfffff
    80001d9e:	79e080e7          	jalr	1950(ra) # 80001538 <uvmcopy>
    80001da2:	04054a63          	bltz	a0,80001df6 <fork+0x8e>
  np->sz = p->sz;
    80001da6:	048ab783          	ld	a5,72(s5)
    80001daa:	04fa3423          	sd	a5,72(s4)
  np->parent = p;
    80001dae:	035a3023          	sd	s5,32(s4)
  *(np->trapframe) = *(p->trapframe);
    80001db2:	058ab683          	ld	a3,88(s5)
    80001db6:	87b6                	mv	a5,a3
    80001db8:	058a3703          	ld	a4,88(s4)
    80001dbc:	12068693          	add	a3,a3,288
    80001dc0:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001dc4:	6788                	ld	a0,8(a5)
    80001dc6:	6b8c                	ld	a1,16(a5)
    80001dc8:	6f90                	ld	a2,24(a5)
    80001dca:	01073023          	sd	a6,0(a4)
    80001dce:	e708                	sd	a0,8(a4)
    80001dd0:	eb0c                	sd	a1,16(a4)
    80001dd2:	ef10                	sd	a2,24(a4)
    80001dd4:	02078793          	add	a5,a5,32
    80001dd8:	02070713          	add	a4,a4,32
    80001ddc:	fed792e3          	bne	a5,a3,80001dc0 <fork+0x58>
  np->trapframe->a0 = 0;
    80001de0:	058a3783          	ld	a5,88(s4)
    80001de4:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001de8:	0d0a8493          	add	s1,s5,208
    80001dec:	0d0a0913          	add	s2,s4,208
    80001df0:	150a8993          	add	s3,s5,336
    80001df4:	a00d                	j	80001e16 <fork+0xae>
    freeproc(np);
    80001df6:	8552                	mv	a0,s4
    80001df8:	00000097          	auipc	ra,0x0
    80001dfc:	d5e080e7          	jalr	-674(ra) # 80001b56 <freeproc>
    release(&np->lock);
    80001e00:	8552                	mv	a0,s4
    80001e02:	fffff097          	auipc	ra,0xfffff
    80001e06:	e70080e7          	jalr	-400(ra) # 80000c72 <release>
    return -1;
    80001e0a:	54fd                	li	s1,-1
    80001e0c:	a889                	j	80001e5e <fork+0xf6>
  for(i = 0; i < NOFILE; i++)
    80001e0e:	04a1                	add	s1,s1,8
    80001e10:	0921                	add	s2,s2,8
    80001e12:	01348b63          	beq	s1,s3,80001e28 <fork+0xc0>
    if(p->ofile[i])
    80001e16:	6088                	ld	a0,0(s1)
    80001e18:	d97d                	beqz	a0,80001e0e <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e1a:	00002097          	auipc	ra,0x2
    80001e1e:	754080e7          	jalr	1876(ra) # 8000456e <filedup>
    80001e22:	00a93023          	sd	a0,0(s2)
    80001e26:	b7e5                	j	80001e0e <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001e28:	150ab503          	ld	a0,336(s5)
    80001e2c:	00002097          	auipc	ra,0x2
    80001e30:	82c080e7          	jalr	-2004(ra) # 80003658 <idup>
    80001e34:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e38:	4641                	li	a2,16
    80001e3a:	158a8593          	add	a1,s5,344
    80001e3e:	158a0513          	add	a0,s4,344
    80001e42:	fffff097          	auipc	ra,0xfffff
    80001e46:	fc8080e7          	jalr	-56(ra) # 80000e0a <safestrcpy>
  pid = np->pid;
    80001e4a:	038a2483          	lw	s1,56(s4)
  np->state = RUNNABLE;
    80001e4e:	4789                	li	a5,2
    80001e50:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001e54:	8552                	mv	a0,s4
    80001e56:	fffff097          	auipc	ra,0xfffff
    80001e5a:	e1c080e7          	jalr	-484(ra) # 80000c72 <release>
}
    80001e5e:	8526                	mv	a0,s1
    80001e60:	70e2                	ld	ra,56(sp)
    80001e62:	7442                	ld	s0,48(sp)
    80001e64:	74a2                	ld	s1,40(sp)
    80001e66:	7902                	ld	s2,32(sp)
    80001e68:	69e2                	ld	s3,24(sp)
    80001e6a:	6a42                	ld	s4,16(sp)
    80001e6c:	6aa2                	ld	s5,8(sp)
    80001e6e:	6121                	add	sp,sp,64
    80001e70:	8082                	ret
    return -1;
    80001e72:	54fd                	li	s1,-1
    80001e74:	b7ed                	j	80001e5e <fork+0xf6>

0000000080001e76 <reparent>:
{
    80001e76:	7179                	add	sp,sp,-48
    80001e78:	f406                	sd	ra,40(sp)
    80001e7a:	f022                	sd	s0,32(sp)
    80001e7c:	ec26                	sd	s1,24(sp)
    80001e7e:	e84a                	sd	s2,16(sp)
    80001e80:	e44e                	sd	s3,8(sp)
    80001e82:	e052                	sd	s4,0(sp)
    80001e84:	1800                	add	s0,sp,48
    80001e86:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001e88:	00010497          	auipc	s1,0x10
    80001e8c:	83048493          	add	s1,s1,-2000 # 800116b8 <proc>
      pp->parent = initproc;
    80001e90:	00007a17          	auipc	s4,0x7
    80001e94:	198a0a13          	add	s4,s4,408 # 80009028 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001e98:	00010997          	auipc	s3,0x10
    80001e9c:	63098993          	add	s3,s3,1584 # 800124c8 <tickslock>
    80001ea0:	a029                	j	80001eaa <reparent+0x34>
    80001ea2:	16848493          	add	s1,s1,360
    80001ea6:	03348363          	beq	s1,s3,80001ecc <reparent+0x56>
    if(pp->parent == p){
    80001eaa:	709c                	ld	a5,32(s1)
    80001eac:	ff279be3          	bne	a5,s2,80001ea2 <reparent+0x2c>
      acquire(&pp->lock);
    80001eb0:	8526                	mv	a0,s1
    80001eb2:	fffff097          	auipc	ra,0xfffff
    80001eb6:	d0c080e7          	jalr	-756(ra) # 80000bbe <acquire>
      pp->parent = initproc;
    80001eba:	000a3783          	ld	a5,0(s4)
    80001ebe:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80001ec0:	8526                	mv	a0,s1
    80001ec2:	fffff097          	auipc	ra,0xfffff
    80001ec6:	db0080e7          	jalr	-592(ra) # 80000c72 <release>
    80001eca:	bfe1                	j	80001ea2 <reparent+0x2c>
}
    80001ecc:	70a2                	ld	ra,40(sp)
    80001ece:	7402                	ld	s0,32(sp)
    80001ed0:	64e2                	ld	s1,24(sp)
    80001ed2:	6942                	ld	s2,16(sp)
    80001ed4:	69a2                	ld	s3,8(sp)
    80001ed6:	6a02                	ld	s4,0(sp)
    80001ed8:	6145                	add	sp,sp,48
    80001eda:	8082                	ret

0000000080001edc <scheduler>:
{
    80001edc:	715d                	add	sp,sp,-80
    80001ede:	e486                	sd	ra,72(sp)
    80001ee0:	e0a2                	sd	s0,64(sp)
    80001ee2:	fc26                	sd	s1,56(sp)
    80001ee4:	f84a                	sd	s2,48(sp)
    80001ee6:	f44e                	sd	s3,40(sp)
    80001ee8:	f052                	sd	s4,32(sp)
    80001eea:	ec56                	sd	s5,24(sp)
    80001eec:	e85a                	sd	s6,16(sp)
    80001eee:	e45e                	sd	s7,8(sp)
    80001ef0:	e062                	sd	s8,0(sp)
    80001ef2:	0880                	add	s0,sp,80
    80001ef4:	8792                	mv	a5,tp
  int id = r_tp();
    80001ef6:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001ef8:	00779b93          	sll	s7,a5,0x7
    80001efc:	0000f717          	auipc	a4,0xf
    80001f00:	3a470713          	add	a4,a4,932 # 800112a0 <pid_lock>
    80001f04:	975e                	add	a4,a4,s7
    80001f06:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    80001f0a:	0000f717          	auipc	a4,0xf
    80001f0e:	3b670713          	add	a4,a4,950 # 800112c0 <cpus+0x8>
    80001f12:	9bba                	add	s7,s7,a4
    int nproc = 0;
    80001f14:	4c01                	li	s8,0
      if(p->state == RUNNABLE) {
    80001f16:	4a09                	li	s4,2
        c->proc = p;
    80001f18:	079e                	sll	a5,a5,0x7
    80001f1a:	0000fa97          	auipc	s5,0xf
    80001f1e:	386a8a93          	add	s5,s5,902 # 800112a0 <pid_lock>
    80001f22:	9abe                	add	s5,s5,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f24:	00010997          	auipc	s3,0x10
    80001f28:	5a498993          	add	s3,s3,1444 # 800124c8 <tickslock>
    80001f2c:	a8a1                	j	80001f84 <scheduler+0xa8>
      release(&p->lock);
    80001f2e:	8526                	mv	a0,s1
    80001f30:	fffff097          	auipc	ra,0xfffff
    80001f34:	d42080e7          	jalr	-702(ra) # 80000c72 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f38:	16848493          	add	s1,s1,360
    80001f3c:	03348a63          	beq	s1,s3,80001f70 <scheduler+0x94>
      acquire(&p->lock);
    80001f40:	8526                	mv	a0,s1
    80001f42:	fffff097          	auipc	ra,0xfffff
    80001f46:	c7c080e7          	jalr	-900(ra) # 80000bbe <acquire>
      if(p->state != UNUSED) {
    80001f4a:	4c9c                	lw	a5,24(s1)
    80001f4c:	d3ed                	beqz	a5,80001f2e <scheduler+0x52>
        nproc++;
    80001f4e:	2905                	addw	s2,s2,1
      if(p->state == RUNNABLE) {
    80001f50:	fd479fe3          	bne	a5,s4,80001f2e <scheduler+0x52>
        p->state = RUNNING;
    80001f54:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001f58:	009abc23          	sd	s1,24(s5)
        swtch(&c->context, &p->context);
    80001f5c:	06048593          	add	a1,s1,96
    80001f60:	855e                	mv	a0,s7
    80001f62:	00000097          	auipc	ra,0x0
    80001f66:	60e080e7          	jalr	1550(ra) # 80002570 <swtch>
        c->proc = 0;
    80001f6a:	000abc23          	sd	zero,24(s5)
    80001f6e:	b7c1                	j	80001f2e <scheduler+0x52>
    if(nproc <= 2) {   // only init and sh exist
    80001f70:	012a4a63          	blt	s4,s2,80001f84 <scheduler+0xa8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f74:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f78:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f7c:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001f80:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f84:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f88:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f8c:	10079073          	csrw	sstatus,a5
    int nproc = 0;
    80001f90:	8962                	mv	s2,s8
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f92:	0000f497          	auipc	s1,0xf
    80001f96:	72648493          	add	s1,s1,1830 # 800116b8 <proc>
        p->state = RUNNING;
    80001f9a:	4b0d                	li	s6,3
    80001f9c:	b755                	j	80001f40 <scheduler+0x64>

0000000080001f9e <sched>:
{
    80001f9e:	7179                	add	sp,sp,-48
    80001fa0:	f406                	sd	ra,40(sp)
    80001fa2:	f022                	sd	s0,32(sp)
    80001fa4:	ec26                	sd	s1,24(sp)
    80001fa6:	e84a                	sd	s2,16(sp)
    80001fa8:	e44e                	sd	s3,8(sp)
    80001faa:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    80001fac:	00000097          	auipc	ra,0x0
    80001fb0:	9f8080e7          	jalr	-1544(ra) # 800019a4 <myproc>
    80001fb4:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001fb6:	fffff097          	auipc	ra,0xfffff
    80001fba:	b8e080e7          	jalr	-1138(ra) # 80000b44 <holding>
    80001fbe:	c93d                	beqz	a0,80002034 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001fc0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001fc2:	2781                	sext.w	a5,a5
    80001fc4:	079e                	sll	a5,a5,0x7
    80001fc6:	0000f717          	auipc	a4,0xf
    80001fca:	2da70713          	add	a4,a4,730 # 800112a0 <pid_lock>
    80001fce:	97ba                	add	a5,a5,a4
    80001fd0:	0907a703          	lw	a4,144(a5)
    80001fd4:	4785                	li	a5,1
    80001fd6:	06f71763          	bne	a4,a5,80002044 <sched+0xa6>
  if(p->state == RUNNING)
    80001fda:	4c98                	lw	a4,24(s1)
    80001fdc:	478d                	li	a5,3
    80001fde:	06f70b63          	beq	a4,a5,80002054 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fe2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001fe6:	8b89                	and	a5,a5,2
  if(intr_get())
    80001fe8:	efb5                	bnez	a5,80002064 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001fea:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001fec:	0000f917          	auipc	s2,0xf
    80001ff0:	2b490913          	add	s2,s2,692 # 800112a0 <pid_lock>
    80001ff4:	2781                	sext.w	a5,a5
    80001ff6:	079e                	sll	a5,a5,0x7
    80001ff8:	97ca                	add	a5,a5,s2
    80001ffa:	0947a983          	lw	s3,148(a5)
    80001ffe:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002000:	2781                	sext.w	a5,a5
    80002002:	079e                	sll	a5,a5,0x7
    80002004:	0000f597          	auipc	a1,0xf
    80002008:	2bc58593          	add	a1,a1,700 # 800112c0 <cpus+0x8>
    8000200c:	95be                	add	a1,a1,a5
    8000200e:	06048513          	add	a0,s1,96
    80002012:	00000097          	auipc	ra,0x0
    80002016:	55e080e7          	jalr	1374(ra) # 80002570 <swtch>
    8000201a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000201c:	2781                	sext.w	a5,a5
    8000201e:	079e                	sll	a5,a5,0x7
    80002020:	993e                	add	s2,s2,a5
    80002022:	09392a23          	sw	s3,148(s2)
}
    80002026:	70a2                	ld	ra,40(sp)
    80002028:	7402                	ld	s0,32(sp)
    8000202a:	64e2                	ld	s1,24(sp)
    8000202c:	6942                	ld	s2,16(sp)
    8000202e:	69a2                	ld	s3,8(sp)
    80002030:	6145                	add	sp,sp,48
    80002032:	8082                	ret
    panic("sched p->lock");
    80002034:	00006517          	auipc	a0,0x6
    80002038:	1c450513          	add	a0,a0,452 # 800081f8 <digits+0x1b8>
    8000203c:	ffffe097          	auipc	ra,0xffffe
    80002040:	4ec080e7          	jalr	1260(ra) # 80000528 <panic>
    panic("sched locks");
    80002044:	00006517          	auipc	a0,0x6
    80002048:	1c450513          	add	a0,a0,452 # 80008208 <digits+0x1c8>
    8000204c:	ffffe097          	auipc	ra,0xffffe
    80002050:	4dc080e7          	jalr	1244(ra) # 80000528 <panic>
    panic("sched running");
    80002054:	00006517          	auipc	a0,0x6
    80002058:	1c450513          	add	a0,a0,452 # 80008218 <digits+0x1d8>
    8000205c:	ffffe097          	auipc	ra,0xffffe
    80002060:	4cc080e7          	jalr	1228(ra) # 80000528 <panic>
    panic("sched interruptible");
    80002064:	00006517          	auipc	a0,0x6
    80002068:	1c450513          	add	a0,a0,452 # 80008228 <digits+0x1e8>
    8000206c:	ffffe097          	auipc	ra,0xffffe
    80002070:	4bc080e7          	jalr	1212(ra) # 80000528 <panic>

0000000080002074 <exit>:
{
    80002074:	7179                	add	sp,sp,-48
    80002076:	f406                	sd	ra,40(sp)
    80002078:	f022                	sd	s0,32(sp)
    8000207a:	ec26                	sd	s1,24(sp)
    8000207c:	e84a                	sd	s2,16(sp)
    8000207e:	e44e                	sd	s3,8(sp)
    80002080:	e052                	sd	s4,0(sp)
    80002082:	1800                	add	s0,sp,48
    80002084:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002086:	00000097          	auipc	ra,0x0
    8000208a:	91e080e7          	jalr	-1762(ra) # 800019a4 <myproc>
    8000208e:	89aa                	mv	s3,a0
  if(p == initproc)
    80002090:	00007797          	auipc	a5,0x7
    80002094:	f987b783          	ld	a5,-104(a5) # 80009028 <initproc>
    80002098:	0d050493          	add	s1,a0,208
    8000209c:	15050913          	add	s2,a0,336
    800020a0:	02a79363          	bne	a5,a0,800020c6 <exit+0x52>
    panic("init exiting");
    800020a4:	00006517          	auipc	a0,0x6
    800020a8:	19c50513          	add	a0,a0,412 # 80008240 <digits+0x200>
    800020ac:	ffffe097          	auipc	ra,0xffffe
    800020b0:	47c080e7          	jalr	1148(ra) # 80000528 <panic>
      fileclose(f);
    800020b4:	00002097          	auipc	ra,0x2
    800020b8:	50c080e7          	jalr	1292(ra) # 800045c0 <fileclose>
      p->ofile[fd] = 0;
    800020bc:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800020c0:	04a1                	add	s1,s1,8
    800020c2:	01248563          	beq	s1,s2,800020cc <exit+0x58>
    if(p->ofile[fd]){
    800020c6:	6088                	ld	a0,0(s1)
    800020c8:	f575                	bnez	a0,800020b4 <exit+0x40>
    800020ca:	bfdd                	j	800020c0 <exit+0x4c>
  begin_op();
    800020cc:	00002097          	auipc	ra,0x2
    800020d0:	028080e7          	jalr	40(ra) # 800040f4 <begin_op>
  iput(p->cwd);
    800020d4:	1509b503          	ld	a0,336(s3)
    800020d8:	00002097          	auipc	ra,0x2
    800020dc:	81e080e7          	jalr	-2018(ra) # 800038f6 <iput>
  end_op();
    800020e0:	00002097          	auipc	ra,0x2
    800020e4:	08e080e7          	jalr	142(ra) # 8000416e <end_op>
  p->cwd = 0;
    800020e8:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    800020ec:	00007497          	auipc	s1,0x7
    800020f0:	f3c48493          	add	s1,s1,-196 # 80009028 <initproc>
    800020f4:	6088                	ld	a0,0(s1)
    800020f6:	fffff097          	auipc	ra,0xfffff
    800020fa:	ac8080e7          	jalr	-1336(ra) # 80000bbe <acquire>
  wakeup1(initproc);
    800020fe:	6088                	ld	a0,0(s1)
    80002100:	fffff097          	auipc	ra,0xfffff
    80002104:	706080e7          	jalr	1798(ra) # 80001806 <wakeup1>
  release(&initproc->lock);
    80002108:	6088                	ld	a0,0(s1)
    8000210a:	fffff097          	auipc	ra,0xfffff
    8000210e:	b68080e7          	jalr	-1176(ra) # 80000c72 <release>
  acquire(&p->lock);
    80002112:	854e                	mv	a0,s3
    80002114:	fffff097          	auipc	ra,0xfffff
    80002118:	aaa080e7          	jalr	-1366(ra) # 80000bbe <acquire>
  struct proc *original_parent = p->parent;
    8000211c:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    80002120:	854e                	mv	a0,s3
    80002122:	fffff097          	auipc	ra,0xfffff
    80002126:	b50080e7          	jalr	-1200(ra) # 80000c72 <release>
  acquire(&original_parent->lock);
    8000212a:	8526                	mv	a0,s1
    8000212c:	fffff097          	auipc	ra,0xfffff
    80002130:	a92080e7          	jalr	-1390(ra) # 80000bbe <acquire>
  acquire(&p->lock);
    80002134:	854e                	mv	a0,s3
    80002136:	fffff097          	auipc	ra,0xfffff
    8000213a:	a88080e7          	jalr	-1400(ra) # 80000bbe <acquire>
  reparent(p);
    8000213e:	854e                	mv	a0,s3
    80002140:	00000097          	auipc	ra,0x0
    80002144:	d36080e7          	jalr	-714(ra) # 80001e76 <reparent>
  wakeup1(original_parent);
    80002148:	8526                	mv	a0,s1
    8000214a:	fffff097          	auipc	ra,0xfffff
    8000214e:	6bc080e7          	jalr	1724(ra) # 80001806 <wakeup1>
  p->xstate = status;
    80002152:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80002156:	4791                	li	a5,4
    80002158:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    8000215c:	8526                	mv	a0,s1
    8000215e:	fffff097          	auipc	ra,0xfffff
    80002162:	b14080e7          	jalr	-1260(ra) # 80000c72 <release>
  sched();
    80002166:	00000097          	auipc	ra,0x0
    8000216a:	e38080e7          	jalr	-456(ra) # 80001f9e <sched>
  panic("zombie exit");
    8000216e:	00006517          	auipc	a0,0x6
    80002172:	0e250513          	add	a0,a0,226 # 80008250 <digits+0x210>
    80002176:	ffffe097          	auipc	ra,0xffffe
    8000217a:	3b2080e7          	jalr	946(ra) # 80000528 <panic>

000000008000217e <yield>:
{
    8000217e:	1101                	add	sp,sp,-32
    80002180:	ec06                	sd	ra,24(sp)
    80002182:	e822                	sd	s0,16(sp)
    80002184:	e426                	sd	s1,8(sp)
    80002186:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    80002188:	00000097          	auipc	ra,0x0
    8000218c:	81c080e7          	jalr	-2020(ra) # 800019a4 <myproc>
    80002190:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002192:	fffff097          	auipc	ra,0xfffff
    80002196:	a2c080e7          	jalr	-1492(ra) # 80000bbe <acquire>
  p->state = RUNNABLE;
    8000219a:	4789                	li	a5,2
    8000219c:	cc9c                	sw	a5,24(s1)
  sched();
    8000219e:	00000097          	auipc	ra,0x0
    800021a2:	e00080e7          	jalr	-512(ra) # 80001f9e <sched>
  release(&p->lock);
    800021a6:	8526                	mv	a0,s1
    800021a8:	fffff097          	auipc	ra,0xfffff
    800021ac:	aca080e7          	jalr	-1334(ra) # 80000c72 <release>
}
    800021b0:	60e2                	ld	ra,24(sp)
    800021b2:	6442                	ld	s0,16(sp)
    800021b4:	64a2                	ld	s1,8(sp)
    800021b6:	6105                	add	sp,sp,32
    800021b8:	8082                	ret

00000000800021ba <sleep>:
{
    800021ba:	7179                	add	sp,sp,-48
    800021bc:	f406                	sd	ra,40(sp)
    800021be:	f022                	sd	s0,32(sp)
    800021c0:	ec26                	sd	s1,24(sp)
    800021c2:	e84a                	sd	s2,16(sp)
    800021c4:	e44e                	sd	s3,8(sp)
    800021c6:	1800                	add	s0,sp,48
    800021c8:	89aa                	mv	s3,a0
    800021ca:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800021cc:	fffff097          	auipc	ra,0xfffff
    800021d0:	7d8080e7          	jalr	2008(ra) # 800019a4 <myproc>
    800021d4:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    800021d6:	05250663          	beq	a0,s2,80002222 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    800021da:	fffff097          	auipc	ra,0xfffff
    800021de:	9e4080e7          	jalr	-1564(ra) # 80000bbe <acquire>
    release(lk);
    800021e2:	854a                	mv	a0,s2
    800021e4:	fffff097          	auipc	ra,0xfffff
    800021e8:	a8e080e7          	jalr	-1394(ra) # 80000c72 <release>
  p->chan = chan;
    800021ec:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800021f0:	4785                	li	a5,1
    800021f2:	cc9c                	sw	a5,24(s1)
  sched();
    800021f4:	00000097          	auipc	ra,0x0
    800021f8:	daa080e7          	jalr	-598(ra) # 80001f9e <sched>
  p->chan = 0;
    800021fc:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    80002200:	8526                	mv	a0,s1
    80002202:	fffff097          	auipc	ra,0xfffff
    80002206:	a70080e7          	jalr	-1424(ra) # 80000c72 <release>
    acquire(lk);
    8000220a:	854a                	mv	a0,s2
    8000220c:	fffff097          	auipc	ra,0xfffff
    80002210:	9b2080e7          	jalr	-1614(ra) # 80000bbe <acquire>
}
    80002214:	70a2                	ld	ra,40(sp)
    80002216:	7402                	ld	s0,32(sp)
    80002218:	64e2                	ld	s1,24(sp)
    8000221a:	6942                	ld	s2,16(sp)
    8000221c:	69a2                	ld	s3,8(sp)
    8000221e:	6145                	add	sp,sp,48
    80002220:	8082                	ret
  p->chan = chan;
    80002222:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    80002226:	4785                	li	a5,1
    80002228:	cd1c                	sw	a5,24(a0)
  sched();
    8000222a:	00000097          	auipc	ra,0x0
    8000222e:	d74080e7          	jalr	-652(ra) # 80001f9e <sched>
  p->chan = 0;
    80002232:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    80002236:	bff9                	j	80002214 <sleep+0x5a>

0000000080002238 <wait>:
{
    80002238:	715d                	add	sp,sp,-80
    8000223a:	e486                	sd	ra,72(sp)
    8000223c:	e0a2                	sd	s0,64(sp)
    8000223e:	fc26                	sd	s1,56(sp)
    80002240:	f84a                	sd	s2,48(sp)
    80002242:	f44e                	sd	s3,40(sp)
    80002244:	f052                	sd	s4,32(sp)
    80002246:	ec56                	sd	s5,24(sp)
    80002248:	e85a                	sd	s6,16(sp)
    8000224a:	e45e                	sd	s7,8(sp)
    8000224c:	0880                	add	s0,sp,80
    8000224e:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80002250:	fffff097          	auipc	ra,0xfffff
    80002254:	754080e7          	jalr	1876(ra) # 800019a4 <myproc>
    80002258:	892a                	mv	s2,a0
  acquire(&p->lock);
    8000225a:	fffff097          	auipc	ra,0xfffff
    8000225e:	964080e7          	jalr	-1692(ra) # 80000bbe <acquire>
    havekids = 0;
    80002262:	4b01                	li	s6,0
        if(np->state == ZOMBIE){
    80002264:	4a11                	li	s4,4
        havekids = 1;
    80002266:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80002268:	00010997          	auipc	s3,0x10
    8000226c:	26098993          	add	s3,s3,608 # 800124c8 <tickslock>
    80002270:	a845                	j	80002320 <wait+0xe8>
          pid = np->pid;
    80002272:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002276:	000b8e63          	beqz	s7,80002292 <wait+0x5a>
    8000227a:	4691                	li	a3,4
    8000227c:	03448613          	add	a2,s1,52
    80002280:	85de                	mv	a1,s7
    80002282:	05093503          	ld	a0,80(s2)
    80002286:	fffff097          	auipc	ra,0xfffff
    8000228a:	3b6080e7          	jalr	950(ra) # 8000163c <copyout>
    8000228e:	02054d63          	bltz	a0,800022c8 <wait+0x90>
          freeproc(np);
    80002292:	8526                	mv	a0,s1
    80002294:	00000097          	auipc	ra,0x0
    80002298:	8c2080e7          	jalr	-1854(ra) # 80001b56 <freeproc>
          release(&np->lock);
    8000229c:	8526                	mv	a0,s1
    8000229e:	fffff097          	auipc	ra,0xfffff
    800022a2:	9d4080e7          	jalr	-1580(ra) # 80000c72 <release>
          release(&p->lock);
    800022a6:	854a                	mv	a0,s2
    800022a8:	fffff097          	auipc	ra,0xfffff
    800022ac:	9ca080e7          	jalr	-1590(ra) # 80000c72 <release>
}
    800022b0:	854e                	mv	a0,s3
    800022b2:	60a6                	ld	ra,72(sp)
    800022b4:	6406                	ld	s0,64(sp)
    800022b6:	74e2                	ld	s1,56(sp)
    800022b8:	7942                	ld	s2,48(sp)
    800022ba:	79a2                	ld	s3,40(sp)
    800022bc:	7a02                	ld	s4,32(sp)
    800022be:	6ae2                	ld	s5,24(sp)
    800022c0:	6b42                	ld	s6,16(sp)
    800022c2:	6ba2                	ld	s7,8(sp)
    800022c4:	6161                	add	sp,sp,80
    800022c6:	8082                	ret
            release(&np->lock);
    800022c8:	8526                	mv	a0,s1
    800022ca:	fffff097          	auipc	ra,0xfffff
    800022ce:	9a8080e7          	jalr	-1624(ra) # 80000c72 <release>
            release(&p->lock);
    800022d2:	854a                	mv	a0,s2
    800022d4:	fffff097          	auipc	ra,0xfffff
    800022d8:	99e080e7          	jalr	-1634(ra) # 80000c72 <release>
            return -1;
    800022dc:	59fd                	li	s3,-1
    800022de:	bfc9                	j	800022b0 <wait+0x78>
    for(np = proc; np < &proc[NPROC]; np++){
    800022e0:	16848493          	add	s1,s1,360
    800022e4:	03348463          	beq	s1,s3,8000230c <wait+0xd4>
      if(np->parent == p){
    800022e8:	709c                	ld	a5,32(s1)
    800022ea:	ff279be3          	bne	a5,s2,800022e0 <wait+0xa8>
        acquire(&np->lock);
    800022ee:	8526                	mv	a0,s1
    800022f0:	fffff097          	auipc	ra,0xfffff
    800022f4:	8ce080e7          	jalr	-1842(ra) # 80000bbe <acquire>
        if(np->state == ZOMBIE){
    800022f8:	4c9c                	lw	a5,24(s1)
    800022fa:	f7478ce3          	beq	a5,s4,80002272 <wait+0x3a>
        release(&np->lock);
    800022fe:	8526                	mv	a0,s1
    80002300:	fffff097          	auipc	ra,0xfffff
    80002304:	972080e7          	jalr	-1678(ra) # 80000c72 <release>
        havekids = 1;
    80002308:	8756                	mv	a4,s5
    8000230a:	bfd9                	j	800022e0 <wait+0xa8>
    if(!havekids || p->killed){
    8000230c:	c305                	beqz	a4,8000232c <wait+0xf4>
    8000230e:	03092783          	lw	a5,48(s2)
    80002312:	ef89                	bnez	a5,8000232c <wait+0xf4>
    sleep(p, &p->lock);  //DOC: wait-sleep
    80002314:	85ca                	mv	a1,s2
    80002316:	854a                	mv	a0,s2
    80002318:	00000097          	auipc	ra,0x0
    8000231c:	ea2080e7          	jalr	-350(ra) # 800021ba <sleep>
    havekids = 0;
    80002320:	875a                	mv	a4,s6
    for(np = proc; np < &proc[NPROC]; np++){
    80002322:	0000f497          	auipc	s1,0xf
    80002326:	39648493          	add	s1,s1,918 # 800116b8 <proc>
    8000232a:	bf7d                	j	800022e8 <wait+0xb0>
      release(&p->lock);
    8000232c:	854a                	mv	a0,s2
    8000232e:	fffff097          	auipc	ra,0xfffff
    80002332:	944080e7          	jalr	-1724(ra) # 80000c72 <release>
      return -1;
    80002336:	59fd                	li	s3,-1
    80002338:	bfa5                	j	800022b0 <wait+0x78>

000000008000233a <wakeup>:
{
    8000233a:	7139                	add	sp,sp,-64
    8000233c:	fc06                	sd	ra,56(sp)
    8000233e:	f822                	sd	s0,48(sp)
    80002340:	f426                	sd	s1,40(sp)
    80002342:	f04a                	sd	s2,32(sp)
    80002344:	ec4e                	sd	s3,24(sp)
    80002346:	e852                	sd	s4,16(sp)
    80002348:	e456                	sd	s5,8(sp)
    8000234a:	0080                	add	s0,sp,64
    8000234c:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    8000234e:	0000f497          	auipc	s1,0xf
    80002352:	36a48493          	add	s1,s1,874 # 800116b8 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    80002356:	4985                	li	s3,1
      p->state = RUNNABLE;
    80002358:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    8000235a:	00010917          	auipc	s2,0x10
    8000235e:	16e90913          	add	s2,s2,366 # 800124c8 <tickslock>
    80002362:	a811                	j	80002376 <wakeup+0x3c>
    release(&p->lock);
    80002364:	8526                	mv	a0,s1
    80002366:	fffff097          	auipc	ra,0xfffff
    8000236a:	90c080e7          	jalr	-1780(ra) # 80000c72 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000236e:	16848493          	add	s1,s1,360
    80002372:	03248063          	beq	s1,s2,80002392 <wakeup+0x58>
    acquire(&p->lock);
    80002376:	8526                	mv	a0,s1
    80002378:	fffff097          	auipc	ra,0xfffff
    8000237c:	846080e7          	jalr	-1978(ra) # 80000bbe <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    80002380:	4c9c                	lw	a5,24(s1)
    80002382:	ff3791e3          	bne	a5,s3,80002364 <wakeup+0x2a>
    80002386:	749c                	ld	a5,40(s1)
    80002388:	fd479ee3          	bne	a5,s4,80002364 <wakeup+0x2a>
      p->state = RUNNABLE;
    8000238c:	0154ac23          	sw	s5,24(s1)
    80002390:	bfd1                	j	80002364 <wakeup+0x2a>
}
    80002392:	70e2                	ld	ra,56(sp)
    80002394:	7442                	ld	s0,48(sp)
    80002396:	74a2                	ld	s1,40(sp)
    80002398:	7902                	ld	s2,32(sp)
    8000239a:	69e2                	ld	s3,24(sp)
    8000239c:	6a42                	ld	s4,16(sp)
    8000239e:	6aa2                	ld	s5,8(sp)
    800023a0:	6121                	add	sp,sp,64
    800023a2:	8082                	ret

00000000800023a4 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800023a4:	7179                	add	sp,sp,-48
    800023a6:	f406                	sd	ra,40(sp)
    800023a8:	f022                	sd	s0,32(sp)
    800023aa:	ec26                	sd	s1,24(sp)
    800023ac:	e84a                	sd	s2,16(sp)
    800023ae:	e44e                	sd	s3,8(sp)
    800023b0:	1800                	add	s0,sp,48
    800023b2:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800023b4:	0000f497          	auipc	s1,0xf
    800023b8:	30448493          	add	s1,s1,772 # 800116b8 <proc>
    800023bc:	00010997          	auipc	s3,0x10
    800023c0:	10c98993          	add	s3,s3,268 # 800124c8 <tickslock>
    acquire(&p->lock);
    800023c4:	8526                	mv	a0,s1
    800023c6:	ffffe097          	auipc	ra,0xffffe
    800023ca:	7f8080e7          	jalr	2040(ra) # 80000bbe <acquire>
    if(p->pid == pid){
    800023ce:	5c9c                	lw	a5,56(s1)
    800023d0:	03278363          	beq	a5,s2,800023f6 <kill+0x52>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800023d4:	8526                	mv	a0,s1
    800023d6:	fffff097          	auipc	ra,0xfffff
    800023da:	89c080e7          	jalr	-1892(ra) # 80000c72 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800023de:	16848493          	add	s1,s1,360
    800023e2:	ff3491e3          	bne	s1,s3,800023c4 <kill+0x20>
  }
  return -1;
    800023e6:	557d                	li	a0,-1
}
    800023e8:	70a2                	ld	ra,40(sp)
    800023ea:	7402                	ld	s0,32(sp)
    800023ec:	64e2                	ld	s1,24(sp)
    800023ee:	6942                	ld	s2,16(sp)
    800023f0:	69a2                	ld	s3,8(sp)
    800023f2:	6145                	add	sp,sp,48
    800023f4:	8082                	ret
      p->killed = 1;
    800023f6:	4785                	li	a5,1
    800023f8:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    800023fa:	4c98                	lw	a4,24(s1)
    800023fc:	00f70963          	beq	a4,a5,8000240e <kill+0x6a>
      release(&p->lock);
    80002400:	8526                	mv	a0,s1
    80002402:	fffff097          	auipc	ra,0xfffff
    80002406:	870080e7          	jalr	-1936(ra) # 80000c72 <release>
      return 0;
    8000240a:	4501                	li	a0,0
    8000240c:	bff1                	j	800023e8 <kill+0x44>
        p->state = RUNNABLE;
    8000240e:	4789                	li	a5,2
    80002410:	cc9c                	sw	a5,24(s1)
    80002412:	b7fd                	j	80002400 <kill+0x5c>

0000000080002414 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002414:	7179                	add	sp,sp,-48
    80002416:	f406                	sd	ra,40(sp)
    80002418:	f022                	sd	s0,32(sp)
    8000241a:	ec26                	sd	s1,24(sp)
    8000241c:	e84a                	sd	s2,16(sp)
    8000241e:	e44e                	sd	s3,8(sp)
    80002420:	e052                	sd	s4,0(sp)
    80002422:	1800                	add	s0,sp,48
    80002424:	84aa                	mv	s1,a0
    80002426:	892e                	mv	s2,a1
    80002428:	89b2                	mv	s3,a2
    8000242a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000242c:	fffff097          	auipc	ra,0xfffff
    80002430:	578080e7          	jalr	1400(ra) # 800019a4 <myproc>
  if(user_dst){
    80002434:	c08d                	beqz	s1,80002456 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002436:	86d2                	mv	a3,s4
    80002438:	864e                	mv	a2,s3
    8000243a:	85ca                	mv	a1,s2
    8000243c:	6928                	ld	a0,80(a0)
    8000243e:	fffff097          	auipc	ra,0xfffff
    80002442:	1fe080e7          	jalr	510(ra) # 8000163c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002446:	70a2                	ld	ra,40(sp)
    80002448:	7402                	ld	s0,32(sp)
    8000244a:	64e2                	ld	s1,24(sp)
    8000244c:	6942                	ld	s2,16(sp)
    8000244e:	69a2                	ld	s3,8(sp)
    80002450:	6a02                	ld	s4,0(sp)
    80002452:	6145                	add	sp,sp,48
    80002454:	8082                	ret
    memmove((char *)dst, src, len);
    80002456:	000a061b          	sext.w	a2,s4
    8000245a:	85ce                	mv	a1,s3
    8000245c:	854a                	mv	a0,s2
    8000245e:	fffff097          	auipc	ra,0xfffff
    80002462:	8b8080e7          	jalr	-1864(ra) # 80000d16 <memmove>
    return 0;
    80002466:	8526                	mv	a0,s1
    80002468:	bff9                	j	80002446 <either_copyout+0x32>

000000008000246a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000246a:	7179                	add	sp,sp,-48
    8000246c:	f406                	sd	ra,40(sp)
    8000246e:	f022                	sd	s0,32(sp)
    80002470:	ec26                	sd	s1,24(sp)
    80002472:	e84a                	sd	s2,16(sp)
    80002474:	e44e                	sd	s3,8(sp)
    80002476:	e052                	sd	s4,0(sp)
    80002478:	1800                	add	s0,sp,48
    8000247a:	892a                	mv	s2,a0
    8000247c:	84ae                	mv	s1,a1
    8000247e:	89b2                	mv	s3,a2
    80002480:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002482:	fffff097          	auipc	ra,0xfffff
    80002486:	522080e7          	jalr	1314(ra) # 800019a4 <myproc>
  if(user_src){
    8000248a:	c08d                	beqz	s1,800024ac <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000248c:	86d2                	mv	a3,s4
    8000248e:	864e                	mv	a2,s3
    80002490:	85ca                	mv	a1,s2
    80002492:	6928                	ld	a0,80(a0)
    80002494:	fffff097          	auipc	ra,0xfffff
    80002498:	234080e7          	jalr	564(ra) # 800016c8 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000249c:	70a2                	ld	ra,40(sp)
    8000249e:	7402                	ld	s0,32(sp)
    800024a0:	64e2                	ld	s1,24(sp)
    800024a2:	6942                	ld	s2,16(sp)
    800024a4:	69a2                	ld	s3,8(sp)
    800024a6:	6a02                	ld	s4,0(sp)
    800024a8:	6145                	add	sp,sp,48
    800024aa:	8082                	ret
    memmove(dst, (char*)src, len);
    800024ac:	000a061b          	sext.w	a2,s4
    800024b0:	85ce                	mv	a1,s3
    800024b2:	854a                	mv	a0,s2
    800024b4:	fffff097          	auipc	ra,0xfffff
    800024b8:	862080e7          	jalr	-1950(ra) # 80000d16 <memmove>
    return 0;
    800024bc:	8526                	mv	a0,s1
    800024be:	bff9                	j	8000249c <either_copyin+0x32>

00000000800024c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800024c0:	715d                	add	sp,sp,-80
    800024c2:	e486                	sd	ra,72(sp)
    800024c4:	e0a2                	sd	s0,64(sp)
    800024c6:	fc26                	sd	s1,56(sp)
    800024c8:	f84a                	sd	s2,48(sp)
    800024ca:	f44e                	sd	s3,40(sp)
    800024cc:	f052                	sd	s4,32(sp)
    800024ce:	ec56                	sd	s5,24(sp)
    800024d0:	e85a                	sd	s6,16(sp)
    800024d2:	e45e                	sd	s7,8(sp)
    800024d4:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800024d6:	00006517          	auipc	a0,0x6
    800024da:	bf250513          	add	a0,a0,-1038 # 800080c8 <digits+0x88>
    800024de:	ffffe097          	auipc	ra,0xffffe
    800024e2:	094080e7          	jalr	148(ra) # 80000572 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800024e6:	0000f497          	auipc	s1,0xf
    800024ea:	32a48493          	add	s1,s1,810 # 80011810 <proc+0x158>
    800024ee:	00010917          	auipc	s2,0x10
    800024f2:	13290913          	add	s2,s2,306 # 80012620 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800024f6:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    800024f8:	00006997          	auipc	s3,0x6
    800024fc:	d6898993          	add	s3,s3,-664 # 80008260 <digits+0x220>
    printf("%d %s %s", p->pid, state, p->name);
    80002500:	00006a97          	auipc	s5,0x6
    80002504:	d68a8a93          	add	s5,s5,-664 # 80008268 <digits+0x228>
    printf("\n");
    80002508:	00006a17          	auipc	s4,0x6
    8000250c:	bc0a0a13          	add	s4,s4,-1088 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002510:	00006b97          	auipc	s7,0x6
    80002514:	d90b8b93          	add	s7,s7,-624 # 800082a0 <states.0>
    80002518:	a00d                	j	8000253a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000251a:	ee06a583          	lw	a1,-288(a3)
    8000251e:	8556                	mv	a0,s5
    80002520:	ffffe097          	auipc	ra,0xffffe
    80002524:	052080e7          	jalr	82(ra) # 80000572 <printf>
    printf("\n");
    80002528:	8552                	mv	a0,s4
    8000252a:	ffffe097          	auipc	ra,0xffffe
    8000252e:	048080e7          	jalr	72(ra) # 80000572 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002532:	16848493          	add	s1,s1,360
    80002536:	03248263          	beq	s1,s2,8000255a <procdump+0x9a>
    if(p->state == UNUSED)
    8000253a:	86a6                	mv	a3,s1
    8000253c:	ec04a783          	lw	a5,-320(s1)
    80002540:	dbed                	beqz	a5,80002532 <procdump+0x72>
      state = "???";
    80002542:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002544:	fcfb6be3          	bltu	s6,a5,8000251a <procdump+0x5a>
    80002548:	02079713          	sll	a4,a5,0x20
    8000254c:	01d75793          	srl	a5,a4,0x1d
    80002550:	97de                	add	a5,a5,s7
    80002552:	6390                	ld	a2,0(a5)
    80002554:	f279                	bnez	a2,8000251a <procdump+0x5a>
      state = "???";
    80002556:	864e                	mv	a2,s3
    80002558:	b7c9                	j	8000251a <procdump+0x5a>
  }
}
    8000255a:	60a6                	ld	ra,72(sp)
    8000255c:	6406                	ld	s0,64(sp)
    8000255e:	74e2                	ld	s1,56(sp)
    80002560:	7942                	ld	s2,48(sp)
    80002562:	79a2                	ld	s3,40(sp)
    80002564:	7a02                	ld	s4,32(sp)
    80002566:	6ae2                	ld	s5,24(sp)
    80002568:	6b42                	ld	s6,16(sp)
    8000256a:	6ba2                	ld	s7,8(sp)
    8000256c:	6161                	add	sp,sp,80
    8000256e:	8082                	ret

0000000080002570 <swtch>:
    80002570:	00153023          	sd	ra,0(a0)
    80002574:	00253423          	sd	sp,8(a0)
    80002578:	e900                	sd	s0,16(a0)
    8000257a:	ed04                	sd	s1,24(a0)
    8000257c:	03253023          	sd	s2,32(a0)
    80002580:	03353423          	sd	s3,40(a0)
    80002584:	03453823          	sd	s4,48(a0)
    80002588:	03553c23          	sd	s5,56(a0)
    8000258c:	05653023          	sd	s6,64(a0)
    80002590:	05753423          	sd	s7,72(a0)
    80002594:	05853823          	sd	s8,80(a0)
    80002598:	05953c23          	sd	s9,88(a0)
    8000259c:	07a53023          	sd	s10,96(a0)
    800025a0:	07b53423          	sd	s11,104(a0)
    800025a4:	0005b083          	ld	ra,0(a1)
    800025a8:	0085b103          	ld	sp,8(a1)
    800025ac:	6980                	ld	s0,16(a1)
    800025ae:	6d84                	ld	s1,24(a1)
    800025b0:	0205b903          	ld	s2,32(a1)
    800025b4:	0285b983          	ld	s3,40(a1)
    800025b8:	0305ba03          	ld	s4,48(a1)
    800025bc:	0385ba83          	ld	s5,56(a1)
    800025c0:	0405bb03          	ld	s6,64(a1)
    800025c4:	0485bb83          	ld	s7,72(a1)
    800025c8:	0505bc03          	ld	s8,80(a1)
    800025cc:	0585bc83          	ld	s9,88(a1)
    800025d0:	0605bd03          	ld	s10,96(a1)
    800025d4:	0685bd83          	ld	s11,104(a1)
    800025d8:	8082                	ret

00000000800025da <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800025da:	1141                	add	sp,sp,-16
    800025dc:	e406                	sd	ra,8(sp)
    800025de:	e022                	sd	s0,0(sp)
    800025e0:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    800025e2:	00006597          	auipc	a1,0x6
    800025e6:	ce658593          	add	a1,a1,-794 # 800082c8 <states.0+0x28>
    800025ea:	00010517          	auipc	a0,0x10
    800025ee:	ede50513          	add	a0,a0,-290 # 800124c8 <tickslock>
    800025f2:	ffffe097          	auipc	ra,0xffffe
    800025f6:	53c080e7          	jalr	1340(ra) # 80000b2e <initlock>
}
    800025fa:	60a2                	ld	ra,8(sp)
    800025fc:	6402                	ld	s0,0(sp)
    800025fe:	0141                	add	sp,sp,16
    80002600:	8082                	ret

0000000080002602 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002602:	1141                	add	sp,sp,-16
    80002604:	e422                	sd	s0,8(sp)
    80002606:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002608:	00003797          	auipc	a5,0x3
    8000260c:	70878793          	add	a5,a5,1800 # 80005d10 <kernelvec>
    80002610:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002614:	6422                	ld	s0,8(sp)
    80002616:	0141                	add	sp,sp,16
    80002618:	8082                	ret

000000008000261a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000261a:	1141                	add	sp,sp,-16
    8000261c:	e406                	sd	ra,8(sp)
    8000261e:	e022                	sd	s0,0(sp)
    80002620:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80002622:	fffff097          	auipc	ra,0xfffff
    80002626:	382080e7          	jalr	898(ra) # 800019a4 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000262a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000262e:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002630:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002634:	00005697          	auipc	a3,0x5
    80002638:	9cc68693          	add	a3,a3,-1588 # 80007000 <_trampoline>
    8000263c:	00005717          	auipc	a4,0x5
    80002640:	9c470713          	add	a4,a4,-1596 # 80007000 <_trampoline>
    80002644:	8f15                	sub	a4,a4,a3
    80002646:	040007b7          	lui	a5,0x4000
    8000264a:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000264c:	07b2                	sll	a5,a5,0xc
    8000264e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002650:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002654:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002656:	18002673          	csrr	a2,satp
    8000265a:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000265c:	6d30                	ld	a2,88(a0)
    8000265e:	6138                	ld	a4,64(a0)
    80002660:	6585                	lui	a1,0x1
    80002662:	972e                	add	a4,a4,a1
    80002664:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002666:	6d38                	ld	a4,88(a0)
    80002668:	00000617          	auipc	a2,0x0
    8000266c:	13c60613          	add	a2,a2,316 # 800027a4 <usertrap>
    80002670:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002672:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002674:	8612                	mv	a2,tp
    80002676:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002678:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000267c:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002680:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002684:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002688:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000268a:	6f18                	ld	a4,24(a4)
    8000268c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002690:	692c                	ld	a1,80(a0)
    80002692:	81b1                	srl	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002694:	00005717          	auipc	a4,0x5
    80002698:	9fc70713          	add	a4,a4,-1540 # 80007090 <userret>
    8000269c:	8f15                	sub	a4,a4,a3
    8000269e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    800026a0:	577d                	li	a4,-1
    800026a2:	177e                	sll	a4,a4,0x3f
    800026a4:	8dd9                	or	a1,a1,a4
    800026a6:	02000537          	lui	a0,0x2000
    800026aa:	157d                	add	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800026ac:	0536                	sll	a0,a0,0xd
    800026ae:	9782                	jalr	a5
}
    800026b0:	60a2                	ld	ra,8(sp)
    800026b2:	6402                	ld	s0,0(sp)
    800026b4:	0141                	add	sp,sp,16
    800026b6:	8082                	ret

00000000800026b8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800026b8:	1101                	add	sp,sp,-32
    800026ba:	ec06                	sd	ra,24(sp)
    800026bc:	e822                	sd	s0,16(sp)
    800026be:	e426                	sd	s1,8(sp)
    800026c0:	1000                	add	s0,sp,32
  acquire(&tickslock);
    800026c2:	00010497          	auipc	s1,0x10
    800026c6:	e0648493          	add	s1,s1,-506 # 800124c8 <tickslock>
    800026ca:	8526                	mv	a0,s1
    800026cc:	ffffe097          	auipc	ra,0xffffe
    800026d0:	4f2080e7          	jalr	1266(ra) # 80000bbe <acquire>
  ticks++;
    800026d4:	00007517          	auipc	a0,0x7
    800026d8:	95c50513          	add	a0,a0,-1700 # 80009030 <ticks>
    800026dc:	411c                	lw	a5,0(a0)
    800026de:	2785                	addw	a5,a5,1
    800026e0:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    800026e2:	00000097          	auipc	ra,0x0
    800026e6:	c58080e7          	jalr	-936(ra) # 8000233a <wakeup>
  release(&tickslock);
    800026ea:	8526                	mv	a0,s1
    800026ec:	ffffe097          	auipc	ra,0xffffe
    800026f0:	586080e7          	jalr	1414(ra) # 80000c72 <release>
}
    800026f4:	60e2                	ld	ra,24(sp)
    800026f6:	6442                	ld	s0,16(sp)
    800026f8:	64a2                	ld	s1,8(sp)
    800026fa:	6105                	add	sp,sp,32
    800026fc:	8082                	ret

00000000800026fe <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026fe:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002702:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80002704:	0807df63          	bgez	a5,800027a2 <devintr+0xa4>
{
    80002708:	1101                	add	sp,sp,-32
    8000270a:	ec06                	sd	ra,24(sp)
    8000270c:	e822                	sd	s0,16(sp)
    8000270e:	e426                	sd	s1,8(sp)
    80002710:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    80002712:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80002716:	46a5                	li	a3,9
    80002718:	00d70d63          	beq	a4,a3,80002732 <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    8000271c:	577d                	li	a4,-1
    8000271e:	177e                	sll	a4,a4,0x3f
    80002720:	0705                	add	a4,a4,1
    return 0;
    80002722:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002724:	04e78e63          	beq	a5,a4,80002780 <devintr+0x82>
  }
}
    80002728:	60e2                	ld	ra,24(sp)
    8000272a:	6442                	ld	s0,16(sp)
    8000272c:	64a2                	ld	s1,8(sp)
    8000272e:	6105                	add	sp,sp,32
    80002730:	8082                	ret
    int irq = plic_claim();
    80002732:	00003097          	auipc	ra,0x3
    80002736:	6e6080e7          	jalr	1766(ra) # 80005e18 <plic_claim>
    8000273a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000273c:	47a9                	li	a5,10
    8000273e:	02f50763          	beq	a0,a5,8000276c <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80002742:	4785                	li	a5,1
    80002744:	02f50963          	beq	a0,a5,80002776 <devintr+0x78>
    return 1;
    80002748:	4505                	li	a0,1
    } else if(irq){
    8000274a:	dcf9                	beqz	s1,80002728 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    8000274c:	85a6                	mv	a1,s1
    8000274e:	00006517          	auipc	a0,0x6
    80002752:	b8250513          	add	a0,a0,-1150 # 800082d0 <states.0+0x30>
    80002756:	ffffe097          	auipc	ra,0xffffe
    8000275a:	e1c080e7          	jalr	-484(ra) # 80000572 <printf>
      plic_complete(irq);
    8000275e:	8526                	mv	a0,s1
    80002760:	00003097          	auipc	ra,0x3
    80002764:	6dc080e7          	jalr	1756(ra) # 80005e3c <plic_complete>
    return 1;
    80002768:	4505                	li	a0,1
    8000276a:	bf7d                	j	80002728 <devintr+0x2a>
      uartintr();
    8000276c:	ffffe097          	auipc	ra,0xffffe
    80002770:	214080e7          	jalr	532(ra) # 80000980 <uartintr>
    if(irq)
    80002774:	b7ed                	j	8000275e <devintr+0x60>
      virtio_disk_intr();
    80002776:	00004097          	auipc	ra,0x4
    8000277a:	b50080e7          	jalr	-1200(ra) # 800062c6 <virtio_disk_intr>
    if(irq)
    8000277e:	b7c5                	j	8000275e <devintr+0x60>
    if(cpuid() == 0){
    80002780:	fffff097          	auipc	ra,0xfffff
    80002784:	1f8080e7          	jalr	504(ra) # 80001978 <cpuid>
    80002788:	c901                	beqz	a0,80002798 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    8000278a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000278e:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002790:	14479073          	csrw	sip,a5
    return 2;
    80002794:	4509                	li	a0,2
    80002796:	bf49                	j	80002728 <devintr+0x2a>
      clockintr();
    80002798:	00000097          	auipc	ra,0x0
    8000279c:	f20080e7          	jalr	-224(ra) # 800026b8 <clockintr>
    800027a0:	b7ed                	j	8000278a <devintr+0x8c>
}
    800027a2:	8082                	ret

00000000800027a4 <usertrap>:
{
    800027a4:	1101                	add	sp,sp,-32
    800027a6:	ec06                	sd	ra,24(sp)
    800027a8:	e822                	sd	s0,16(sp)
    800027aa:	e426                	sd	s1,8(sp)
    800027ac:	e04a                	sd	s2,0(sp)
    800027ae:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027b0:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800027b4:	1007f793          	and	a5,a5,256
    800027b8:	e3ad                	bnez	a5,8000281a <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027ba:	00003797          	auipc	a5,0x3
    800027be:	55678793          	add	a5,a5,1366 # 80005d10 <kernelvec>
    800027c2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800027c6:	fffff097          	auipc	ra,0xfffff
    800027ca:	1de080e7          	jalr	478(ra) # 800019a4 <myproc>
    800027ce:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800027d0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027d2:	14102773          	csrr	a4,sepc
    800027d6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027d8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800027dc:	47a1                	li	a5,8
    800027de:	04f71c63          	bne	a4,a5,80002836 <usertrap+0x92>
    if(p->killed)
    800027e2:	591c                	lw	a5,48(a0)
    800027e4:	e3b9                	bnez	a5,8000282a <usertrap+0x86>
    p->trapframe->epc += 4;
    800027e6:	6cb8                	ld	a4,88(s1)
    800027e8:	6f1c                	ld	a5,24(a4)
    800027ea:	0791                	add	a5,a5,4
    800027ec:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027ee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800027f2:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800027f6:	10079073          	csrw	sstatus,a5
    syscall();
    800027fa:	00000097          	auipc	ra,0x0
    800027fe:	2e0080e7          	jalr	736(ra) # 80002ada <syscall>
  if(p->killed)
    80002802:	589c                	lw	a5,48(s1)
    80002804:	ebc1                	bnez	a5,80002894 <usertrap+0xf0>
  usertrapret();
    80002806:	00000097          	auipc	ra,0x0
    8000280a:	e14080e7          	jalr	-492(ra) # 8000261a <usertrapret>
}
    8000280e:	60e2                	ld	ra,24(sp)
    80002810:	6442                	ld	s0,16(sp)
    80002812:	64a2                	ld	s1,8(sp)
    80002814:	6902                	ld	s2,0(sp)
    80002816:	6105                	add	sp,sp,32
    80002818:	8082                	ret
    panic("usertrap: not from user mode");
    8000281a:	00006517          	auipc	a0,0x6
    8000281e:	ad650513          	add	a0,a0,-1322 # 800082f0 <states.0+0x50>
    80002822:	ffffe097          	auipc	ra,0xffffe
    80002826:	d06080e7          	jalr	-762(ra) # 80000528 <panic>
      exit(-1);
    8000282a:	557d                	li	a0,-1
    8000282c:	00000097          	auipc	ra,0x0
    80002830:	848080e7          	jalr	-1976(ra) # 80002074 <exit>
    80002834:	bf4d                	j	800027e6 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002836:	00000097          	auipc	ra,0x0
    8000283a:	ec8080e7          	jalr	-312(ra) # 800026fe <devintr>
    8000283e:	892a                	mv	s2,a0
    80002840:	c501                	beqz	a0,80002848 <usertrap+0xa4>
  if(p->killed)
    80002842:	589c                	lw	a5,48(s1)
    80002844:	c3a1                	beqz	a5,80002884 <usertrap+0xe0>
    80002846:	a815                	j	8000287a <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002848:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000284c:	5c90                	lw	a2,56(s1)
    8000284e:	00006517          	auipc	a0,0x6
    80002852:	ac250513          	add	a0,a0,-1342 # 80008310 <states.0+0x70>
    80002856:	ffffe097          	auipc	ra,0xffffe
    8000285a:	d1c080e7          	jalr	-740(ra) # 80000572 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000285e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002862:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002866:	00006517          	auipc	a0,0x6
    8000286a:	ada50513          	add	a0,a0,-1318 # 80008340 <states.0+0xa0>
    8000286e:	ffffe097          	auipc	ra,0xffffe
    80002872:	d04080e7          	jalr	-764(ra) # 80000572 <printf>
    p->killed = 1;
    80002876:	4785                	li	a5,1
    80002878:	d89c                	sw	a5,48(s1)
    exit(-1);
    8000287a:	557d                	li	a0,-1
    8000287c:	fffff097          	auipc	ra,0xfffff
    80002880:	7f8080e7          	jalr	2040(ra) # 80002074 <exit>
  if(which_dev == 2)
    80002884:	4789                	li	a5,2
    80002886:	f8f910e3          	bne	s2,a5,80002806 <usertrap+0x62>
    yield();
    8000288a:	00000097          	auipc	ra,0x0
    8000288e:	8f4080e7          	jalr	-1804(ra) # 8000217e <yield>
    80002892:	bf95                	j	80002806 <usertrap+0x62>
  int which_dev = 0;
    80002894:	4901                	li	s2,0
    80002896:	b7d5                	j	8000287a <usertrap+0xd6>

0000000080002898 <kerneltrap>:
{
    80002898:	7179                	add	sp,sp,-48
    8000289a:	f406                	sd	ra,40(sp)
    8000289c:	f022                	sd	s0,32(sp)
    8000289e:	ec26                	sd	s1,24(sp)
    800028a0:	e84a                	sd	s2,16(sp)
    800028a2:	e44e                	sd	s3,8(sp)
    800028a4:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028a6:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028aa:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028ae:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800028b2:	1004f793          	and	a5,s1,256
    800028b6:	cb85                	beqz	a5,800028e6 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028b8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800028bc:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    800028be:	ef85                	bnez	a5,800028f6 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800028c0:	00000097          	auipc	ra,0x0
    800028c4:	e3e080e7          	jalr	-450(ra) # 800026fe <devintr>
    800028c8:	cd1d                	beqz	a0,80002906 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800028ca:	4789                	li	a5,2
    800028cc:	06f50a63          	beq	a0,a5,80002940 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800028d0:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028d4:	10049073          	csrw	sstatus,s1
}
    800028d8:	70a2                	ld	ra,40(sp)
    800028da:	7402                	ld	s0,32(sp)
    800028dc:	64e2                	ld	s1,24(sp)
    800028de:	6942                	ld	s2,16(sp)
    800028e0:	69a2                	ld	s3,8(sp)
    800028e2:	6145                	add	sp,sp,48
    800028e4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800028e6:	00006517          	auipc	a0,0x6
    800028ea:	a7a50513          	add	a0,a0,-1414 # 80008360 <states.0+0xc0>
    800028ee:	ffffe097          	auipc	ra,0xffffe
    800028f2:	c3a080e7          	jalr	-966(ra) # 80000528 <panic>
    panic("kerneltrap: interrupts enabled");
    800028f6:	00006517          	auipc	a0,0x6
    800028fa:	a9250513          	add	a0,a0,-1390 # 80008388 <states.0+0xe8>
    800028fe:	ffffe097          	auipc	ra,0xffffe
    80002902:	c2a080e7          	jalr	-982(ra) # 80000528 <panic>
    printf("scause %p\n", scause);
    80002906:	85ce                	mv	a1,s3
    80002908:	00006517          	auipc	a0,0x6
    8000290c:	aa050513          	add	a0,a0,-1376 # 800083a8 <states.0+0x108>
    80002910:	ffffe097          	auipc	ra,0xffffe
    80002914:	c62080e7          	jalr	-926(ra) # 80000572 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002918:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000291c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002920:	00006517          	auipc	a0,0x6
    80002924:	a9850513          	add	a0,a0,-1384 # 800083b8 <states.0+0x118>
    80002928:	ffffe097          	auipc	ra,0xffffe
    8000292c:	c4a080e7          	jalr	-950(ra) # 80000572 <printf>
    panic("kerneltrap");
    80002930:	00006517          	auipc	a0,0x6
    80002934:	aa050513          	add	a0,a0,-1376 # 800083d0 <states.0+0x130>
    80002938:	ffffe097          	auipc	ra,0xffffe
    8000293c:	bf0080e7          	jalr	-1040(ra) # 80000528 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002940:	fffff097          	auipc	ra,0xfffff
    80002944:	064080e7          	jalr	100(ra) # 800019a4 <myproc>
    80002948:	d541                	beqz	a0,800028d0 <kerneltrap+0x38>
    8000294a:	fffff097          	auipc	ra,0xfffff
    8000294e:	05a080e7          	jalr	90(ra) # 800019a4 <myproc>
    80002952:	4d18                	lw	a4,24(a0)
    80002954:	478d                	li	a5,3
    80002956:	f6f71de3          	bne	a4,a5,800028d0 <kerneltrap+0x38>
    yield();
    8000295a:	00000097          	auipc	ra,0x0
    8000295e:	824080e7          	jalr	-2012(ra) # 8000217e <yield>
    80002962:	b7bd                	j	800028d0 <kerneltrap+0x38>

0000000080002964 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002964:	1101                	add	sp,sp,-32
    80002966:	ec06                	sd	ra,24(sp)
    80002968:	e822                	sd	s0,16(sp)
    8000296a:	e426                	sd	s1,8(sp)
    8000296c:	1000                	add	s0,sp,32
    8000296e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002970:	fffff097          	auipc	ra,0xfffff
    80002974:	034080e7          	jalr	52(ra) # 800019a4 <myproc>
  switch (n) {
    80002978:	4795                	li	a5,5
    8000297a:	0497e163          	bltu	a5,s1,800029bc <argraw+0x58>
    8000297e:	048a                	sll	s1,s1,0x2
    80002980:	00006717          	auipc	a4,0x6
    80002984:	a8870713          	add	a4,a4,-1400 # 80008408 <states.0+0x168>
    80002988:	94ba                	add	s1,s1,a4
    8000298a:	409c                	lw	a5,0(s1)
    8000298c:	97ba                	add	a5,a5,a4
    8000298e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002990:	6d3c                	ld	a5,88(a0)
    80002992:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002994:	60e2                	ld	ra,24(sp)
    80002996:	6442                	ld	s0,16(sp)
    80002998:	64a2                	ld	s1,8(sp)
    8000299a:	6105                	add	sp,sp,32
    8000299c:	8082                	ret
    return p->trapframe->a1;
    8000299e:	6d3c                	ld	a5,88(a0)
    800029a0:	7fa8                	ld	a0,120(a5)
    800029a2:	bfcd                	j	80002994 <argraw+0x30>
    return p->trapframe->a2;
    800029a4:	6d3c                	ld	a5,88(a0)
    800029a6:	63c8                	ld	a0,128(a5)
    800029a8:	b7f5                	j	80002994 <argraw+0x30>
    return p->trapframe->a3;
    800029aa:	6d3c                	ld	a5,88(a0)
    800029ac:	67c8                	ld	a0,136(a5)
    800029ae:	b7dd                	j	80002994 <argraw+0x30>
    return p->trapframe->a4;
    800029b0:	6d3c                	ld	a5,88(a0)
    800029b2:	6bc8                	ld	a0,144(a5)
    800029b4:	b7c5                	j	80002994 <argraw+0x30>
    return p->trapframe->a5;
    800029b6:	6d3c                	ld	a5,88(a0)
    800029b8:	6fc8                	ld	a0,152(a5)
    800029ba:	bfe9                	j	80002994 <argraw+0x30>
  panic("argraw");
    800029bc:	00006517          	auipc	a0,0x6
    800029c0:	a2450513          	add	a0,a0,-1500 # 800083e0 <states.0+0x140>
    800029c4:	ffffe097          	auipc	ra,0xffffe
    800029c8:	b64080e7          	jalr	-1180(ra) # 80000528 <panic>

00000000800029cc <fetchaddr>:
{
    800029cc:	1101                	add	sp,sp,-32
    800029ce:	ec06                	sd	ra,24(sp)
    800029d0:	e822                	sd	s0,16(sp)
    800029d2:	e426                	sd	s1,8(sp)
    800029d4:	e04a                	sd	s2,0(sp)
    800029d6:	1000                	add	s0,sp,32
    800029d8:	84aa                	mv	s1,a0
    800029da:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800029dc:	fffff097          	auipc	ra,0xfffff
    800029e0:	fc8080e7          	jalr	-56(ra) # 800019a4 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800029e4:	653c                	ld	a5,72(a0)
    800029e6:	02f4f863          	bgeu	s1,a5,80002a16 <fetchaddr+0x4a>
    800029ea:	00848713          	add	a4,s1,8
    800029ee:	02e7e663          	bltu	a5,a4,80002a1a <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800029f2:	46a1                	li	a3,8
    800029f4:	8626                	mv	a2,s1
    800029f6:	85ca                	mv	a1,s2
    800029f8:	6928                	ld	a0,80(a0)
    800029fa:	fffff097          	auipc	ra,0xfffff
    800029fe:	cce080e7          	jalr	-818(ra) # 800016c8 <copyin>
    80002a02:	00a03533          	snez	a0,a0
    80002a06:	40a00533          	neg	a0,a0
}
    80002a0a:	60e2                	ld	ra,24(sp)
    80002a0c:	6442                	ld	s0,16(sp)
    80002a0e:	64a2                	ld	s1,8(sp)
    80002a10:	6902                	ld	s2,0(sp)
    80002a12:	6105                	add	sp,sp,32
    80002a14:	8082                	ret
    return -1;
    80002a16:	557d                	li	a0,-1
    80002a18:	bfcd                	j	80002a0a <fetchaddr+0x3e>
    80002a1a:	557d                	li	a0,-1
    80002a1c:	b7fd                	j	80002a0a <fetchaddr+0x3e>

0000000080002a1e <fetchstr>:
{
    80002a1e:	7179                	add	sp,sp,-48
    80002a20:	f406                	sd	ra,40(sp)
    80002a22:	f022                	sd	s0,32(sp)
    80002a24:	ec26                	sd	s1,24(sp)
    80002a26:	e84a                	sd	s2,16(sp)
    80002a28:	e44e                	sd	s3,8(sp)
    80002a2a:	1800                	add	s0,sp,48
    80002a2c:	892a                	mv	s2,a0
    80002a2e:	84ae                	mv	s1,a1
    80002a30:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002a32:	fffff097          	auipc	ra,0xfffff
    80002a36:	f72080e7          	jalr	-142(ra) # 800019a4 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002a3a:	86ce                	mv	a3,s3
    80002a3c:	864a                	mv	a2,s2
    80002a3e:	85a6                	mv	a1,s1
    80002a40:	6928                	ld	a0,80(a0)
    80002a42:	fffff097          	auipc	ra,0xfffff
    80002a46:	d14080e7          	jalr	-748(ra) # 80001756 <copyinstr>
  if(err < 0)
    80002a4a:	00054763          	bltz	a0,80002a58 <fetchstr+0x3a>
  return strlen(buf);
    80002a4e:	8526                	mv	a0,s1
    80002a50:	ffffe097          	auipc	ra,0xffffe
    80002a54:	3ec080e7          	jalr	1004(ra) # 80000e3c <strlen>
}
    80002a58:	70a2                	ld	ra,40(sp)
    80002a5a:	7402                	ld	s0,32(sp)
    80002a5c:	64e2                	ld	s1,24(sp)
    80002a5e:	6942                	ld	s2,16(sp)
    80002a60:	69a2                	ld	s3,8(sp)
    80002a62:	6145                	add	sp,sp,48
    80002a64:	8082                	ret

0000000080002a66 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002a66:	1101                	add	sp,sp,-32
    80002a68:	ec06                	sd	ra,24(sp)
    80002a6a:	e822                	sd	s0,16(sp)
    80002a6c:	e426                	sd	s1,8(sp)
    80002a6e:	1000                	add	s0,sp,32
    80002a70:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002a72:	00000097          	auipc	ra,0x0
    80002a76:	ef2080e7          	jalr	-270(ra) # 80002964 <argraw>
    80002a7a:	c088                	sw	a0,0(s1)
  return 0;
}
    80002a7c:	4501                	li	a0,0
    80002a7e:	60e2                	ld	ra,24(sp)
    80002a80:	6442                	ld	s0,16(sp)
    80002a82:	64a2                	ld	s1,8(sp)
    80002a84:	6105                	add	sp,sp,32
    80002a86:	8082                	ret

0000000080002a88 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002a88:	1101                	add	sp,sp,-32
    80002a8a:	ec06                	sd	ra,24(sp)
    80002a8c:	e822                	sd	s0,16(sp)
    80002a8e:	e426                	sd	s1,8(sp)
    80002a90:	1000                	add	s0,sp,32
    80002a92:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002a94:	00000097          	auipc	ra,0x0
    80002a98:	ed0080e7          	jalr	-304(ra) # 80002964 <argraw>
    80002a9c:	e088                	sd	a0,0(s1)
  return 0;
}
    80002a9e:	4501                	li	a0,0
    80002aa0:	60e2                	ld	ra,24(sp)
    80002aa2:	6442                	ld	s0,16(sp)
    80002aa4:	64a2                	ld	s1,8(sp)
    80002aa6:	6105                	add	sp,sp,32
    80002aa8:	8082                	ret

0000000080002aaa <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002aaa:	1101                	add	sp,sp,-32
    80002aac:	ec06                	sd	ra,24(sp)
    80002aae:	e822                	sd	s0,16(sp)
    80002ab0:	e426                	sd	s1,8(sp)
    80002ab2:	e04a                	sd	s2,0(sp)
    80002ab4:	1000                	add	s0,sp,32
    80002ab6:	84ae                	mv	s1,a1
    80002ab8:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002aba:	00000097          	auipc	ra,0x0
    80002abe:	eaa080e7          	jalr	-342(ra) # 80002964 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002ac2:	864a                	mv	a2,s2
    80002ac4:	85a6                	mv	a1,s1
    80002ac6:	00000097          	auipc	ra,0x0
    80002aca:	f58080e7          	jalr	-168(ra) # 80002a1e <fetchstr>
}
    80002ace:	60e2                	ld	ra,24(sp)
    80002ad0:	6442                	ld	s0,16(sp)
    80002ad2:	64a2                	ld	s1,8(sp)
    80002ad4:	6902                	ld	s2,0(sp)
    80002ad6:	6105                	add	sp,sp,32
    80002ad8:	8082                	ret

0000000080002ada <syscall>:
[SYS_symlink] sys_symlink,
};

void
syscall(void)
{
    80002ada:	1101                	add	sp,sp,-32
    80002adc:	ec06                	sd	ra,24(sp)
    80002ade:	e822                	sd	s0,16(sp)
    80002ae0:	e426                	sd	s1,8(sp)
    80002ae2:	e04a                	sd	s2,0(sp)
    80002ae4:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002ae6:	fffff097          	auipc	ra,0xfffff
    80002aea:	ebe080e7          	jalr	-322(ra) # 800019a4 <myproc>
    80002aee:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002af0:	05853903          	ld	s2,88(a0)
    80002af4:	0a893783          	ld	a5,168(s2)
    80002af8:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002afc:	37fd                	addw	a5,a5,-1
    80002afe:	4755                	li	a4,21
    80002b00:	00f76f63          	bltu	a4,a5,80002b1e <syscall+0x44>
    80002b04:	00369713          	sll	a4,a3,0x3
    80002b08:	00006797          	auipc	a5,0x6
    80002b0c:	91878793          	add	a5,a5,-1768 # 80008420 <syscalls>
    80002b10:	97ba                	add	a5,a5,a4
    80002b12:	639c                	ld	a5,0(a5)
    80002b14:	c789                	beqz	a5,80002b1e <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002b16:	9782                	jalr	a5
    80002b18:	06a93823          	sd	a0,112(s2)
    80002b1c:	a839                	j	80002b3a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002b1e:	15848613          	add	a2,s1,344
    80002b22:	5c8c                	lw	a1,56(s1)
    80002b24:	00006517          	auipc	a0,0x6
    80002b28:	8c450513          	add	a0,a0,-1852 # 800083e8 <states.0+0x148>
    80002b2c:	ffffe097          	auipc	ra,0xffffe
    80002b30:	a46080e7          	jalr	-1466(ra) # 80000572 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002b34:	6cbc                	ld	a5,88(s1)
    80002b36:	577d                	li	a4,-1
    80002b38:	fbb8                	sd	a4,112(a5)
  }
}
    80002b3a:	60e2                	ld	ra,24(sp)
    80002b3c:	6442                	ld	s0,16(sp)
    80002b3e:	64a2                	ld	s1,8(sp)
    80002b40:	6902                	ld	s2,0(sp)
    80002b42:	6105                	add	sp,sp,32
    80002b44:	8082                	ret

0000000080002b46 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002b46:	1101                	add	sp,sp,-32
    80002b48:	ec06                	sd	ra,24(sp)
    80002b4a:	e822                	sd	s0,16(sp)
    80002b4c:	1000                	add	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002b4e:	fec40593          	add	a1,s0,-20
    80002b52:	4501                	li	a0,0
    80002b54:	00000097          	auipc	ra,0x0
    80002b58:	f12080e7          	jalr	-238(ra) # 80002a66 <argint>
    return -1;
    80002b5c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002b5e:	00054963          	bltz	a0,80002b70 <sys_exit+0x2a>
  exit(n);
    80002b62:	fec42503          	lw	a0,-20(s0)
    80002b66:	fffff097          	auipc	ra,0xfffff
    80002b6a:	50e080e7          	jalr	1294(ra) # 80002074 <exit>
  return 0;  // not reached
    80002b6e:	4781                	li	a5,0
}
    80002b70:	853e                	mv	a0,a5
    80002b72:	60e2                	ld	ra,24(sp)
    80002b74:	6442                	ld	s0,16(sp)
    80002b76:	6105                	add	sp,sp,32
    80002b78:	8082                	ret

0000000080002b7a <sys_getpid>:

uint64
sys_getpid(void)
{
    80002b7a:	1141                	add	sp,sp,-16
    80002b7c:	e406                	sd	ra,8(sp)
    80002b7e:	e022                	sd	s0,0(sp)
    80002b80:	0800                	add	s0,sp,16
  return myproc()->pid;
    80002b82:	fffff097          	auipc	ra,0xfffff
    80002b86:	e22080e7          	jalr	-478(ra) # 800019a4 <myproc>
}
    80002b8a:	5d08                	lw	a0,56(a0)
    80002b8c:	60a2                	ld	ra,8(sp)
    80002b8e:	6402                	ld	s0,0(sp)
    80002b90:	0141                	add	sp,sp,16
    80002b92:	8082                	ret

0000000080002b94 <sys_fork>:

uint64
sys_fork(void)
{
    80002b94:	1141                	add	sp,sp,-16
    80002b96:	e406                	sd	ra,8(sp)
    80002b98:	e022                	sd	s0,0(sp)
    80002b9a:	0800                	add	s0,sp,16
  return fork();
    80002b9c:	fffff097          	auipc	ra,0xfffff
    80002ba0:	1cc080e7          	jalr	460(ra) # 80001d68 <fork>
}
    80002ba4:	60a2                	ld	ra,8(sp)
    80002ba6:	6402                	ld	s0,0(sp)
    80002ba8:	0141                	add	sp,sp,16
    80002baa:	8082                	ret

0000000080002bac <sys_wait>:

uint64
sys_wait(void)
{
    80002bac:	1101                	add	sp,sp,-32
    80002bae:	ec06                	sd	ra,24(sp)
    80002bb0:	e822                	sd	s0,16(sp)
    80002bb2:	1000                	add	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002bb4:	fe840593          	add	a1,s0,-24
    80002bb8:	4501                	li	a0,0
    80002bba:	00000097          	auipc	ra,0x0
    80002bbe:	ece080e7          	jalr	-306(ra) # 80002a88 <argaddr>
    80002bc2:	87aa                	mv	a5,a0
    return -1;
    80002bc4:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002bc6:	0007c863          	bltz	a5,80002bd6 <sys_wait+0x2a>
  return wait(p);
    80002bca:	fe843503          	ld	a0,-24(s0)
    80002bce:	fffff097          	auipc	ra,0xfffff
    80002bd2:	66a080e7          	jalr	1642(ra) # 80002238 <wait>
}
    80002bd6:	60e2                	ld	ra,24(sp)
    80002bd8:	6442                	ld	s0,16(sp)
    80002bda:	6105                	add	sp,sp,32
    80002bdc:	8082                	ret

0000000080002bde <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002bde:	7179                	add	sp,sp,-48
    80002be0:	f406                	sd	ra,40(sp)
    80002be2:	f022                	sd	s0,32(sp)
    80002be4:	ec26                	sd	s1,24(sp)
    80002be6:	1800                	add	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002be8:	fdc40593          	add	a1,s0,-36
    80002bec:	4501                	li	a0,0
    80002bee:	00000097          	auipc	ra,0x0
    80002bf2:	e78080e7          	jalr	-392(ra) # 80002a66 <argint>
    80002bf6:	87aa                	mv	a5,a0
    return -1;
    80002bf8:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002bfa:	0207c063          	bltz	a5,80002c1a <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002bfe:	fffff097          	auipc	ra,0xfffff
    80002c02:	da6080e7          	jalr	-602(ra) # 800019a4 <myproc>
    80002c06:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002c08:	fdc42503          	lw	a0,-36(s0)
    80002c0c:	fffff097          	auipc	ra,0xfffff
    80002c10:	0e4080e7          	jalr	228(ra) # 80001cf0 <growproc>
    80002c14:	00054863          	bltz	a0,80002c24 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002c18:	8526                	mv	a0,s1
}
    80002c1a:	70a2                	ld	ra,40(sp)
    80002c1c:	7402                	ld	s0,32(sp)
    80002c1e:	64e2                	ld	s1,24(sp)
    80002c20:	6145                	add	sp,sp,48
    80002c22:	8082                	ret
    return -1;
    80002c24:	557d                	li	a0,-1
    80002c26:	bfd5                	j	80002c1a <sys_sbrk+0x3c>

0000000080002c28 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002c28:	7139                	add	sp,sp,-64
    80002c2a:	fc06                	sd	ra,56(sp)
    80002c2c:	f822                	sd	s0,48(sp)
    80002c2e:	f426                	sd	s1,40(sp)
    80002c30:	f04a                	sd	s2,32(sp)
    80002c32:	ec4e                	sd	s3,24(sp)
    80002c34:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002c36:	fcc40593          	add	a1,s0,-52
    80002c3a:	4501                	li	a0,0
    80002c3c:	00000097          	auipc	ra,0x0
    80002c40:	e2a080e7          	jalr	-470(ra) # 80002a66 <argint>
    return -1;
    80002c44:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002c46:	06054563          	bltz	a0,80002cb0 <sys_sleep+0x88>
  acquire(&tickslock);
    80002c4a:	00010517          	auipc	a0,0x10
    80002c4e:	87e50513          	add	a0,a0,-1922 # 800124c8 <tickslock>
    80002c52:	ffffe097          	auipc	ra,0xffffe
    80002c56:	f6c080e7          	jalr	-148(ra) # 80000bbe <acquire>
  ticks0 = ticks;
    80002c5a:	00006917          	auipc	s2,0x6
    80002c5e:	3d692903          	lw	s2,982(s2) # 80009030 <ticks>
  while(ticks - ticks0 < n){
    80002c62:	fcc42783          	lw	a5,-52(s0)
    80002c66:	cf85                	beqz	a5,80002c9e <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002c68:	00010997          	auipc	s3,0x10
    80002c6c:	86098993          	add	s3,s3,-1952 # 800124c8 <tickslock>
    80002c70:	00006497          	auipc	s1,0x6
    80002c74:	3c048493          	add	s1,s1,960 # 80009030 <ticks>
    if(myproc()->killed){
    80002c78:	fffff097          	auipc	ra,0xfffff
    80002c7c:	d2c080e7          	jalr	-724(ra) # 800019a4 <myproc>
    80002c80:	591c                	lw	a5,48(a0)
    80002c82:	ef9d                	bnez	a5,80002cc0 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002c84:	85ce                	mv	a1,s3
    80002c86:	8526                	mv	a0,s1
    80002c88:	fffff097          	auipc	ra,0xfffff
    80002c8c:	532080e7          	jalr	1330(ra) # 800021ba <sleep>
  while(ticks - ticks0 < n){
    80002c90:	409c                	lw	a5,0(s1)
    80002c92:	412787bb          	subw	a5,a5,s2
    80002c96:	fcc42703          	lw	a4,-52(s0)
    80002c9a:	fce7efe3          	bltu	a5,a4,80002c78 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002c9e:	00010517          	auipc	a0,0x10
    80002ca2:	82a50513          	add	a0,a0,-2006 # 800124c8 <tickslock>
    80002ca6:	ffffe097          	auipc	ra,0xffffe
    80002caa:	fcc080e7          	jalr	-52(ra) # 80000c72 <release>
  return 0;
    80002cae:	4781                	li	a5,0
}
    80002cb0:	853e                	mv	a0,a5
    80002cb2:	70e2                	ld	ra,56(sp)
    80002cb4:	7442                	ld	s0,48(sp)
    80002cb6:	74a2                	ld	s1,40(sp)
    80002cb8:	7902                	ld	s2,32(sp)
    80002cba:	69e2                	ld	s3,24(sp)
    80002cbc:	6121                	add	sp,sp,64
    80002cbe:	8082                	ret
      release(&tickslock);
    80002cc0:	00010517          	auipc	a0,0x10
    80002cc4:	80850513          	add	a0,a0,-2040 # 800124c8 <tickslock>
    80002cc8:	ffffe097          	auipc	ra,0xffffe
    80002ccc:	faa080e7          	jalr	-86(ra) # 80000c72 <release>
      return -1;
    80002cd0:	57fd                	li	a5,-1
    80002cd2:	bff9                	j	80002cb0 <sys_sleep+0x88>

0000000080002cd4 <sys_kill>:

uint64
sys_kill(void)
{
    80002cd4:	1101                	add	sp,sp,-32
    80002cd6:	ec06                	sd	ra,24(sp)
    80002cd8:	e822                	sd	s0,16(sp)
    80002cda:	1000                	add	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002cdc:	fec40593          	add	a1,s0,-20
    80002ce0:	4501                	li	a0,0
    80002ce2:	00000097          	auipc	ra,0x0
    80002ce6:	d84080e7          	jalr	-636(ra) # 80002a66 <argint>
    80002cea:	87aa                	mv	a5,a0
    return -1;
    80002cec:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002cee:	0007c863          	bltz	a5,80002cfe <sys_kill+0x2a>
  return kill(pid);
    80002cf2:	fec42503          	lw	a0,-20(s0)
    80002cf6:	fffff097          	auipc	ra,0xfffff
    80002cfa:	6ae080e7          	jalr	1710(ra) # 800023a4 <kill>
}
    80002cfe:	60e2                	ld	ra,24(sp)
    80002d00:	6442                	ld	s0,16(sp)
    80002d02:	6105                	add	sp,sp,32
    80002d04:	8082                	ret

0000000080002d06 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002d06:	1101                	add	sp,sp,-32
    80002d08:	ec06                	sd	ra,24(sp)
    80002d0a:	e822                	sd	s0,16(sp)
    80002d0c:	e426                	sd	s1,8(sp)
    80002d0e:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002d10:	0000f517          	auipc	a0,0xf
    80002d14:	7b850513          	add	a0,a0,1976 # 800124c8 <tickslock>
    80002d18:	ffffe097          	auipc	ra,0xffffe
    80002d1c:	ea6080e7          	jalr	-346(ra) # 80000bbe <acquire>
  xticks = ticks;
    80002d20:	00006497          	auipc	s1,0x6
    80002d24:	3104a483          	lw	s1,784(s1) # 80009030 <ticks>
  release(&tickslock);
    80002d28:	0000f517          	auipc	a0,0xf
    80002d2c:	7a050513          	add	a0,a0,1952 # 800124c8 <tickslock>
    80002d30:	ffffe097          	auipc	ra,0xffffe
    80002d34:	f42080e7          	jalr	-190(ra) # 80000c72 <release>
  return xticks;
}
    80002d38:	02049513          	sll	a0,s1,0x20
    80002d3c:	9101                	srl	a0,a0,0x20
    80002d3e:	60e2                	ld	ra,24(sp)
    80002d40:	6442                	ld	s0,16(sp)
    80002d42:	64a2                	ld	s1,8(sp)
    80002d44:	6105                	add	sp,sp,32
    80002d46:	8082                	ret

0000000080002d48 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002d48:	7179                	add	sp,sp,-48
    80002d4a:	f406                	sd	ra,40(sp)
    80002d4c:	f022                	sd	s0,32(sp)
    80002d4e:	ec26                	sd	s1,24(sp)
    80002d50:	e84a                	sd	s2,16(sp)
    80002d52:	e44e                	sd	s3,8(sp)
    80002d54:	e052                	sd	s4,0(sp)
    80002d56:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002d58:	00005597          	auipc	a1,0x5
    80002d5c:	78058593          	add	a1,a1,1920 # 800084d8 <syscalls+0xb8>
    80002d60:	0000f517          	auipc	a0,0xf
    80002d64:	78050513          	add	a0,a0,1920 # 800124e0 <bcache>
    80002d68:	ffffe097          	auipc	ra,0xffffe
    80002d6c:	dc6080e7          	jalr	-570(ra) # 80000b2e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002d70:	00017797          	auipc	a5,0x17
    80002d74:	77078793          	add	a5,a5,1904 # 8001a4e0 <bcache+0x8000>
    80002d78:	00018717          	auipc	a4,0x18
    80002d7c:	9d070713          	add	a4,a4,-1584 # 8001a748 <bcache+0x8268>
    80002d80:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002d84:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002d88:	0000f497          	auipc	s1,0xf
    80002d8c:	77048493          	add	s1,s1,1904 # 800124f8 <bcache+0x18>
    b->next = bcache.head.next;
    80002d90:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002d92:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002d94:	00005a17          	auipc	s4,0x5
    80002d98:	74ca0a13          	add	s4,s4,1868 # 800084e0 <syscalls+0xc0>
    b->next = bcache.head.next;
    80002d9c:	2b893783          	ld	a5,696(s2)
    80002da0:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002da2:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002da6:	85d2                	mv	a1,s4
    80002da8:	01048513          	add	a0,s1,16
    80002dac:	00001097          	auipc	ra,0x1
    80002db0:	606080e7          	jalr	1542(ra) # 800043b2 <initsleeplock>
    bcache.head.next->prev = b;
    80002db4:	2b893783          	ld	a5,696(s2)
    80002db8:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002dba:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002dbe:	45848493          	add	s1,s1,1112
    80002dc2:	fd349de3          	bne	s1,s3,80002d9c <binit+0x54>
  }
}
    80002dc6:	70a2                	ld	ra,40(sp)
    80002dc8:	7402                	ld	s0,32(sp)
    80002dca:	64e2                	ld	s1,24(sp)
    80002dcc:	6942                	ld	s2,16(sp)
    80002dce:	69a2                	ld	s3,8(sp)
    80002dd0:	6a02                	ld	s4,0(sp)
    80002dd2:	6145                	add	sp,sp,48
    80002dd4:	8082                	ret

0000000080002dd6 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002dd6:	7179                	add	sp,sp,-48
    80002dd8:	f406                	sd	ra,40(sp)
    80002dda:	f022                	sd	s0,32(sp)
    80002ddc:	ec26                	sd	s1,24(sp)
    80002dde:	e84a                	sd	s2,16(sp)
    80002de0:	e44e                	sd	s3,8(sp)
    80002de2:	1800                	add	s0,sp,48
    80002de4:	892a                	mv	s2,a0
    80002de6:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002de8:	0000f517          	auipc	a0,0xf
    80002dec:	6f850513          	add	a0,a0,1784 # 800124e0 <bcache>
    80002df0:	ffffe097          	auipc	ra,0xffffe
    80002df4:	dce080e7          	jalr	-562(ra) # 80000bbe <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002df8:	00018497          	auipc	s1,0x18
    80002dfc:	9a04b483          	ld	s1,-1632(s1) # 8001a798 <bcache+0x82b8>
    80002e00:	00018797          	auipc	a5,0x18
    80002e04:	94878793          	add	a5,a5,-1720 # 8001a748 <bcache+0x8268>
    80002e08:	02f48f63          	beq	s1,a5,80002e46 <bread+0x70>
    80002e0c:	873e                	mv	a4,a5
    80002e0e:	a021                	j	80002e16 <bread+0x40>
    80002e10:	68a4                	ld	s1,80(s1)
    80002e12:	02e48a63          	beq	s1,a4,80002e46 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002e16:	449c                	lw	a5,8(s1)
    80002e18:	ff279ce3          	bne	a5,s2,80002e10 <bread+0x3a>
    80002e1c:	44dc                	lw	a5,12(s1)
    80002e1e:	ff3799e3          	bne	a5,s3,80002e10 <bread+0x3a>
      b->refcnt++;
    80002e22:	40bc                	lw	a5,64(s1)
    80002e24:	2785                	addw	a5,a5,1
    80002e26:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e28:	0000f517          	auipc	a0,0xf
    80002e2c:	6b850513          	add	a0,a0,1720 # 800124e0 <bcache>
    80002e30:	ffffe097          	auipc	ra,0xffffe
    80002e34:	e42080e7          	jalr	-446(ra) # 80000c72 <release>
      acquiresleep(&b->lock);
    80002e38:	01048513          	add	a0,s1,16
    80002e3c:	00001097          	auipc	ra,0x1
    80002e40:	5b0080e7          	jalr	1456(ra) # 800043ec <acquiresleep>
      return b;
    80002e44:	a8b9                	j	80002ea2 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e46:	00018497          	auipc	s1,0x18
    80002e4a:	94a4b483          	ld	s1,-1718(s1) # 8001a790 <bcache+0x82b0>
    80002e4e:	00018797          	auipc	a5,0x18
    80002e52:	8fa78793          	add	a5,a5,-1798 # 8001a748 <bcache+0x8268>
    80002e56:	00f48863          	beq	s1,a5,80002e66 <bread+0x90>
    80002e5a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002e5c:	40bc                	lw	a5,64(s1)
    80002e5e:	cf81                	beqz	a5,80002e76 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e60:	64a4                	ld	s1,72(s1)
    80002e62:	fee49de3          	bne	s1,a4,80002e5c <bread+0x86>
  panic("bget: no buffers");
    80002e66:	00005517          	auipc	a0,0x5
    80002e6a:	68250513          	add	a0,a0,1666 # 800084e8 <syscalls+0xc8>
    80002e6e:	ffffd097          	auipc	ra,0xffffd
    80002e72:	6ba080e7          	jalr	1722(ra) # 80000528 <panic>
      b->dev = dev;
    80002e76:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002e7a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002e7e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002e82:	4785                	li	a5,1
    80002e84:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e86:	0000f517          	auipc	a0,0xf
    80002e8a:	65a50513          	add	a0,a0,1626 # 800124e0 <bcache>
    80002e8e:	ffffe097          	auipc	ra,0xffffe
    80002e92:	de4080e7          	jalr	-540(ra) # 80000c72 <release>
      acquiresleep(&b->lock);
    80002e96:	01048513          	add	a0,s1,16
    80002e9a:	00001097          	auipc	ra,0x1
    80002e9e:	552080e7          	jalr	1362(ra) # 800043ec <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002ea2:	409c                	lw	a5,0(s1)
    80002ea4:	cb89                	beqz	a5,80002eb6 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002ea6:	8526                	mv	a0,s1
    80002ea8:	70a2                	ld	ra,40(sp)
    80002eaa:	7402                	ld	s0,32(sp)
    80002eac:	64e2                	ld	s1,24(sp)
    80002eae:	6942                	ld	s2,16(sp)
    80002eb0:	69a2                	ld	s3,8(sp)
    80002eb2:	6145                	add	sp,sp,48
    80002eb4:	8082                	ret
    virtio_disk_rw(b, 0);
    80002eb6:	4581                	li	a1,0
    80002eb8:	8526                	mv	a0,s1
    80002eba:	00003097          	auipc	ra,0x3
    80002ebe:	188080e7          	jalr	392(ra) # 80006042 <virtio_disk_rw>
    b->valid = 1;
    80002ec2:	4785                	li	a5,1
    80002ec4:	c09c                	sw	a5,0(s1)
  return b;
    80002ec6:	b7c5                	j	80002ea6 <bread+0xd0>

0000000080002ec8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002ec8:	1101                	add	sp,sp,-32
    80002eca:	ec06                	sd	ra,24(sp)
    80002ecc:	e822                	sd	s0,16(sp)
    80002ece:	e426                	sd	s1,8(sp)
    80002ed0:	1000                	add	s0,sp,32
    80002ed2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002ed4:	0541                	add	a0,a0,16
    80002ed6:	00001097          	auipc	ra,0x1
    80002eda:	5b0080e7          	jalr	1456(ra) # 80004486 <holdingsleep>
    80002ede:	cd01                	beqz	a0,80002ef6 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002ee0:	4585                	li	a1,1
    80002ee2:	8526                	mv	a0,s1
    80002ee4:	00003097          	auipc	ra,0x3
    80002ee8:	15e080e7          	jalr	350(ra) # 80006042 <virtio_disk_rw>
}
    80002eec:	60e2                	ld	ra,24(sp)
    80002eee:	6442                	ld	s0,16(sp)
    80002ef0:	64a2                	ld	s1,8(sp)
    80002ef2:	6105                	add	sp,sp,32
    80002ef4:	8082                	ret
    panic("bwrite");
    80002ef6:	00005517          	auipc	a0,0x5
    80002efa:	60a50513          	add	a0,a0,1546 # 80008500 <syscalls+0xe0>
    80002efe:	ffffd097          	auipc	ra,0xffffd
    80002f02:	62a080e7          	jalr	1578(ra) # 80000528 <panic>

0000000080002f06 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002f06:	1101                	add	sp,sp,-32
    80002f08:	ec06                	sd	ra,24(sp)
    80002f0a:	e822                	sd	s0,16(sp)
    80002f0c:	e426                	sd	s1,8(sp)
    80002f0e:	e04a                	sd	s2,0(sp)
    80002f10:	1000                	add	s0,sp,32
    80002f12:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002f14:	01050913          	add	s2,a0,16
    80002f18:	854a                	mv	a0,s2
    80002f1a:	00001097          	auipc	ra,0x1
    80002f1e:	56c080e7          	jalr	1388(ra) # 80004486 <holdingsleep>
    80002f22:	c925                	beqz	a0,80002f92 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002f24:	854a                	mv	a0,s2
    80002f26:	00001097          	auipc	ra,0x1
    80002f2a:	51c080e7          	jalr	1308(ra) # 80004442 <releasesleep>

  acquire(&bcache.lock);
    80002f2e:	0000f517          	auipc	a0,0xf
    80002f32:	5b250513          	add	a0,a0,1458 # 800124e0 <bcache>
    80002f36:	ffffe097          	auipc	ra,0xffffe
    80002f3a:	c88080e7          	jalr	-888(ra) # 80000bbe <acquire>
  b->refcnt--;
    80002f3e:	40bc                	lw	a5,64(s1)
    80002f40:	37fd                	addw	a5,a5,-1
    80002f42:	0007871b          	sext.w	a4,a5
    80002f46:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002f48:	e71d                	bnez	a4,80002f76 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002f4a:	68b8                	ld	a4,80(s1)
    80002f4c:	64bc                	ld	a5,72(s1)
    80002f4e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002f50:	68b8                	ld	a4,80(s1)
    80002f52:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002f54:	00017797          	auipc	a5,0x17
    80002f58:	58c78793          	add	a5,a5,1420 # 8001a4e0 <bcache+0x8000>
    80002f5c:	2b87b703          	ld	a4,696(a5)
    80002f60:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002f62:	00017717          	auipc	a4,0x17
    80002f66:	7e670713          	add	a4,a4,2022 # 8001a748 <bcache+0x8268>
    80002f6a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002f6c:	2b87b703          	ld	a4,696(a5)
    80002f70:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002f72:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002f76:	0000f517          	auipc	a0,0xf
    80002f7a:	56a50513          	add	a0,a0,1386 # 800124e0 <bcache>
    80002f7e:	ffffe097          	auipc	ra,0xffffe
    80002f82:	cf4080e7          	jalr	-780(ra) # 80000c72 <release>
}
    80002f86:	60e2                	ld	ra,24(sp)
    80002f88:	6442                	ld	s0,16(sp)
    80002f8a:	64a2                	ld	s1,8(sp)
    80002f8c:	6902                	ld	s2,0(sp)
    80002f8e:	6105                	add	sp,sp,32
    80002f90:	8082                	ret
    panic("brelse");
    80002f92:	00005517          	auipc	a0,0x5
    80002f96:	57650513          	add	a0,a0,1398 # 80008508 <syscalls+0xe8>
    80002f9a:	ffffd097          	auipc	ra,0xffffd
    80002f9e:	58e080e7          	jalr	1422(ra) # 80000528 <panic>

0000000080002fa2 <bpin>:

void
bpin(struct buf *b) {
    80002fa2:	1101                	add	sp,sp,-32
    80002fa4:	ec06                	sd	ra,24(sp)
    80002fa6:	e822                	sd	s0,16(sp)
    80002fa8:	e426                	sd	s1,8(sp)
    80002faa:	1000                	add	s0,sp,32
    80002fac:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002fae:	0000f517          	auipc	a0,0xf
    80002fb2:	53250513          	add	a0,a0,1330 # 800124e0 <bcache>
    80002fb6:	ffffe097          	auipc	ra,0xffffe
    80002fba:	c08080e7          	jalr	-1016(ra) # 80000bbe <acquire>
  b->refcnt++;
    80002fbe:	40bc                	lw	a5,64(s1)
    80002fc0:	2785                	addw	a5,a5,1
    80002fc2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002fc4:	0000f517          	auipc	a0,0xf
    80002fc8:	51c50513          	add	a0,a0,1308 # 800124e0 <bcache>
    80002fcc:	ffffe097          	auipc	ra,0xffffe
    80002fd0:	ca6080e7          	jalr	-858(ra) # 80000c72 <release>
}
    80002fd4:	60e2                	ld	ra,24(sp)
    80002fd6:	6442                	ld	s0,16(sp)
    80002fd8:	64a2                	ld	s1,8(sp)
    80002fda:	6105                	add	sp,sp,32
    80002fdc:	8082                	ret

0000000080002fde <bunpin>:

void
bunpin(struct buf *b) {
    80002fde:	1101                	add	sp,sp,-32
    80002fe0:	ec06                	sd	ra,24(sp)
    80002fe2:	e822                	sd	s0,16(sp)
    80002fe4:	e426                	sd	s1,8(sp)
    80002fe6:	1000                	add	s0,sp,32
    80002fe8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002fea:	0000f517          	auipc	a0,0xf
    80002fee:	4f650513          	add	a0,a0,1270 # 800124e0 <bcache>
    80002ff2:	ffffe097          	auipc	ra,0xffffe
    80002ff6:	bcc080e7          	jalr	-1076(ra) # 80000bbe <acquire>
  b->refcnt--;
    80002ffa:	40bc                	lw	a5,64(s1)
    80002ffc:	37fd                	addw	a5,a5,-1
    80002ffe:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003000:	0000f517          	auipc	a0,0xf
    80003004:	4e050513          	add	a0,a0,1248 # 800124e0 <bcache>
    80003008:	ffffe097          	auipc	ra,0xffffe
    8000300c:	c6a080e7          	jalr	-918(ra) # 80000c72 <release>
}
    80003010:	60e2                	ld	ra,24(sp)
    80003012:	6442                	ld	s0,16(sp)
    80003014:	64a2                	ld	s1,8(sp)
    80003016:	6105                	add	sp,sp,32
    80003018:	8082                	ret

000000008000301a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000301a:	1101                	add	sp,sp,-32
    8000301c:	ec06                	sd	ra,24(sp)
    8000301e:	e822                	sd	s0,16(sp)
    80003020:	e426                	sd	s1,8(sp)
    80003022:	e04a                	sd	s2,0(sp)
    80003024:	1000                	add	s0,sp,32
    80003026:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003028:	00d5d59b          	srlw	a1,a1,0xd
    8000302c:	00018797          	auipc	a5,0x18
    80003030:	b907a783          	lw	a5,-1136(a5) # 8001abbc <sb+0x1c>
    80003034:	9dbd                	addw	a1,a1,a5
    80003036:	00000097          	auipc	ra,0x0
    8000303a:	da0080e7          	jalr	-608(ra) # 80002dd6 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000303e:	0074f713          	and	a4,s1,7
    80003042:	4785                	li	a5,1
    80003044:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003048:	14ce                	sll	s1,s1,0x33
    8000304a:	90d9                	srl	s1,s1,0x36
    8000304c:	00950733          	add	a4,a0,s1
    80003050:	05874703          	lbu	a4,88(a4)
    80003054:	00e7f6b3          	and	a3,a5,a4
    80003058:	c69d                	beqz	a3,80003086 <bfree+0x6c>
    8000305a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000305c:	94aa                	add	s1,s1,a0
    8000305e:	fff7c793          	not	a5,a5
    80003062:	8f7d                	and	a4,a4,a5
    80003064:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003068:	00001097          	auipc	ra,0x1
    8000306c:	25e080e7          	jalr	606(ra) # 800042c6 <log_write>
  brelse(bp);
    80003070:	854a                	mv	a0,s2
    80003072:	00000097          	auipc	ra,0x0
    80003076:	e94080e7          	jalr	-364(ra) # 80002f06 <brelse>
}
    8000307a:	60e2                	ld	ra,24(sp)
    8000307c:	6442                	ld	s0,16(sp)
    8000307e:	64a2                	ld	s1,8(sp)
    80003080:	6902                	ld	s2,0(sp)
    80003082:	6105                	add	sp,sp,32
    80003084:	8082                	ret
    panic("freeing free block");
    80003086:	00005517          	auipc	a0,0x5
    8000308a:	48a50513          	add	a0,a0,1162 # 80008510 <syscalls+0xf0>
    8000308e:	ffffd097          	auipc	ra,0xffffd
    80003092:	49a080e7          	jalr	1178(ra) # 80000528 <panic>

0000000080003096 <balloc>:
{
    80003096:	711d                	add	sp,sp,-96
    80003098:	ec86                	sd	ra,88(sp)
    8000309a:	e8a2                	sd	s0,80(sp)
    8000309c:	e4a6                	sd	s1,72(sp)
    8000309e:	e0ca                	sd	s2,64(sp)
    800030a0:	fc4e                	sd	s3,56(sp)
    800030a2:	f852                	sd	s4,48(sp)
    800030a4:	f456                	sd	s5,40(sp)
    800030a6:	f05a                	sd	s6,32(sp)
    800030a8:	ec5e                	sd	s7,24(sp)
    800030aa:	e862                	sd	s8,16(sp)
    800030ac:	e466                	sd	s9,8(sp)
    800030ae:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800030b0:	00018797          	auipc	a5,0x18
    800030b4:	af47a783          	lw	a5,-1292(a5) # 8001aba4 <sb+0x4>
    800030b8:	cbc1                	beqz	a5,80003148 <balloc+0xb2>
    800030ba:	8baa                	mv	s7,a0
    800030bc:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800030be:	00018b17          	auipc	s6,0x18
    800030c2:	ae2b0b13          	add	s6,s6,-1310 # 8001aba0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030c6:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800030c8:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030ca:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800030cc:	6c89                	lui	s9,0x2
    800030ce:	a831                	j	800030ea <balloc+0x54>
    brelse(bp);
    800030d0:	854a                	mv	a0,s2
    800030d2:	00000097          	auipc	ra,0x0
    800030d6:	e34080e7          	jalr	-460(ra) # 80002f06 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800030da:	015c87bb          	addw	a5,s9,s5
    800030de:	00078a9b          	sext.w	s5,a5
    800030e2:	004b2703          	lw	a4,4(s6)
    800030e6:	06eaf163          	bgeu	s5,a4,80003148 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800030ea:	41fad79b          	sraw	a5,s5,0x1f
    800030ee:	0137d79b          	srlw	a5,a5,0x13
    800030f2:	015787bb          	addw	a5,a5,s5
    800030f6:	40d7d79b          	sraw	a5,a5,0xd
    800030fa:	01cb2583          	lw	a1,28(s6)
    800030fe:	9dbd                	addw	a1,a1,a5
    80003100:	855e                	mv	a0,s7
    80003102:	00000097          	auipc	ra,0x0
    80003106:	cd4080e7          	jalr	-812(ra) # 80002dd6 <bread>
    8000310a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000310c:	004b2503          	lw	a0,4(s6)
    80003110:	000a849b          	sext.w	s1,s5
    80003114:	8762                	mv	a4,s8
    80003116:	faa4fde3          	bgeu	s1,a0,800030d0 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000311a:	00777693          	and	a3,a4,7
    8000311e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003122:	41f7579b          	sraw	a5,a4,0x1f
    80003126:	01d7d79b          	srlw	a5,a5,0x1d
    8000312a:	9fb9                	addw	a5,a5,a4
    8000312c:	4037d79b          	sraw	a5,a5,0x3
    80003130:	00f90633          	add	a2,s2,a5
    80003134:	05864603          	lbu	a2,88(a2)
    80003138:	00c6f5b3          	and	a1,a3,a2
    8000313c:	cd91                	beqz	a1,80003158 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000313e:	2705                	addw	a4,a4,1
    80003140:	2485                	addw	s1,s1,1
    80003142:	fd471ae3          	bne	a4,s4,80003116 <balloc+0x80>
    80003146:	b769                	j	800030d0 <balloc+0x3a>
  panic("balloc: out of blocks");
    80003148:	00005517          	auipc	a0,0x5
    8000314c:	3e050513          	add	a0,a0,992 # 80008528 <syscalls+0x108>
    80003150:	ffffd097          	auipc	ra,0xffffd
    80003154:	3d8080e7          	jalr	984(ra) # 80000528 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003158:	97ca                	add	a5,a5,s2
    8000315a:	8e55                	or	a2,a2,a3
    8000315c:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003160:	854a                	mv	a0,s2
    80003162:	00001097          	auipc	ra,0x1
    80003166:	164080e7          	jalr	356(ra) # 800042c6 <log_write>
        brelse(bp);
    8000316a:	854a                	mv	a0,s2
    8000316c:	00000097          	auipc	ra,0x0
    80003170:	d9a080e7          	jalr	-614(ra) # 80002f06 <brelse>
  bp = bread(dev, bno);
    80003174:	85a6                	mv	a1,s1
    80003176:	855e                	mv	a0,s7
    80003178:	00000097          	auipc	ra,0x0
    8000317c:	c5e080e7          	jalr	-930(ra) # 80002dd6 <bread>
    80003180:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003182:	40000613          	li	a2,1024
    80003186:	4581                	li	a1,0
    80003188:	05850513          	add	a0,a0,88
    8000318c:	ffffe097          	auipc	ra,0xffffe
    80003190:	b2e080e7          	jalr	-1234(ra) # 80000cba <memset>
  log_write(bp);
    80003194:	854a                	mv	a0,s2
    80003196:	00001097          	auipc	ra,0x1
    8000319a:	130080e7          	jalr	304(ra) # 800042c6 <log_write>
  brelse(bp);
    8000319e:	854a                	mv	a0,s2
    800031a0:	00000097          	auipc	ra,0x0
    800031a4:	d66080e7          	jalr	-666(ra) # 80002f06 <brelse>
}
    800031a8:	8526                	mv	a0,s1
    800031aa:	60e6                	ld	ra,88(sp)
    800031ac:	6446                	ld	s0,80(sp)
    800031ae:	64a6                	ld	s1,72(sp)
    800031b0:	6906                	ld	s2,64(sp)
    800031b2:	79e2                	ld	s3,56(sp)
    800031b4:	7a42                	ld	s4,48(sp)
    800031b6:	7aa2                	ld	s5,40(sp)
    800031b8:	7b02                	ld	s6,32(sp)
    800031ba:	6be2                	ld	s7,24(sp)
    800031bc:	6c42                	ld	s8,16(sp)
    800031be:	6ca2                	ld	s9,8(sp)
    800031c0:	6125                	add	sp,sp,96
    800031c2:	8082                	ret

00000000800031c4 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800031c4:	7139                	add	sp,sp,-64
    800031c6:	fc06                	sd	ra,56(sp)
    800031c8:	f822                	sd	s0,48(sp)
    800031ca:	f426                	sd	s1,40(sp)
    800031cc:	f04a                	sd	s2,32(sp)
    800031ce:	ec4e                	sd	s3,24(sp)
    800031d0:	e852                	sd	s4,16(sp)
    800031d2:	e456                	sd	s5,8(sp)
    800031d4:	0080                	add	s0,sp,64
    800031d6:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800031d8:	47a9                	li	a5,10
    800031da:	06b7f263          	bgeu	a5,a1,8000323e <bmap+0x7a>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800031de:	ff55849b          	addw	s1,a1,-11
    800031e2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800031e6:	67c1                	lui	a5,0x10
    800031e8:	0ff78793          	add	a5,a5,255 # 100ff <_entry-0x7ffeff01>
    800031ec:	16e7e563          	bltu	a5,a4,80003356 <bmap+0x192>
    // bn block is in singly-indirect blocks
    if (bn < SINGLYBNUM) {
    800031f0:	0ff00793          	li	a5,255
    800031f4:	0ae7e363          	bltu	a5,a4,8000329a <bmap+0xd6>
      // Load indirect block, allocating if necessary.
      if((addr = ip->addrs[NDIRECT]) == 0)
    800031f8:	5d6c                	lw	a1,124(a0)
    800031fa:	c5b5                	beqz	a1,80003266 <bmap+0xa2>
        ip->addrs[NDIRECT] = addr = balloc(ip->dev);
      bp = bread(ip->dev, addr);
    800031fc:	00092503          	lw	a0,0(s2)
    80003200:	00000097          	auipc	ra,0x0
    80003204:	bd6080e7          	jalr	-1066(ra) # 80002dd6 <bread>
    80003208:	8a2a                	mv	s4,a0
      a = (uint*)bp->data;
    8000320a:	05850793          	add	a5,a0,88
      if((addr = a[bn]) == 0){
    8000320e:	02049713          	sll	a4,s1,0x20
    80003212:	01e75493          	srl	s1,a4,0x1e
    80003216:	94be                	add	s1,s1,a5
    80003218:	0004a983          	lw	s3,0(s1)
    8000321c:	04098f63          	beqz	s3,8000327a <bmap+0xb6>
        a[bn] = addr = balloc(ip->dev);
        log_write(bp);
      }
    brelse(bp);
    80003220:	8552                	mv	a0,s4
    80003222:	00000097          	auipc	ra,0x0
    80003226:	ce4080e7          	jalr	-796(ra) # 80002f06 <brelse>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
    8000322a:	854e                	mv	a0,s3
    8000322c:	70e2                	ld	ra,56(sp)
    8000322e:	7442                	ld	s0,48(sp)
    80003230:	74a2                	ld	s1,40(sp)
    80003232:	7902                	ld	s2,32(sp)
    80003234:	69e2                	ld	s3,24(sp)
    80003236:	6a42                	ld	s4,16(sp)
    80003238:	6aa2                	ld	s5,8(sp)
    8000323a:	6121                	add	sp,sp,64
    8000323c:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000323e:	02059793          	sll	a5,a1,0x20
    80003242:	01e7d593          	srl	a1,a5,0x1e
    80003246:	00b504b3          	add	s1,a0,a1
    8000324a:	0504a983          	lw	s3,80(s1)
    8000324e:	fc099ee3          	bnez	s3,8000322a <bmap+0x66>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80003252:	4108                	lw	a0,0(a0)
    80003254:	00000097          	auipc	ra,0x0
    80003258:	e42080e7          	jalr	-446(ra) # 80003096 <balloc>
    8000325c:	0005099b          	sext.w	s3,a0
    80003260:	0534a823          	sw	s3,80(s1)
    80003264:	b7d9                	j	8000322a <bmap+0x66>
        ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003266:	4108                	lw	a0,0(a0)
    80003268:	00000097          	auipc	ra,0x0
    8000326c:	e2e080e7          	jalr	-466(ra) # 80003096 <balloc>
    80003270:	0005059b          	sext.w	a1,a0
    80003274:	06b92e23          	sw	a1,124(s2)
    80003278:	b751                	j	800031fc <bmap+0x38>
        a[bn] = addr = balloc(ip->dev);
    8000327a:	00092503          	lw	a0,0(s2)
    8000327e:	00000097          	auipc	ra,0x0
    80003282:	e18080e7          	jalr	-488(ra) # 80003096 <balloc>
    80003286:	0005099b          	sext.w	s3,a0
    8000328a:	0134a023          	sw	s3,0(s1)
        log_write(bp);
    8000328e:	8552                	mv	a0,s4
    80003290:	00001097          	auipc	ra,0x1
    80003294:	036080e7          	jalr	54(ra) # 800042c6 <log_write>
    80003298:	b761                	j	80003220 <bmap+0x5c>
  bn -= SINGLYBNUM;
    8000329a:	ef55849b          	addw	s1,a1,-267
    if ((addr = ip->addrs[NDIRECT+1]) == 0)
    8000329e:	08052583          	lw	a1,128(a0)
    800032a2:	c1a5                	beqz	a1,80003302 <bmap+0x13e>
    bp = bread(ip->dev, addr);
    800032a4:	00092503          	lw	a0,0(s2)
    800032a8:	00000097          	auipc	ra,0x0
    800032ac:	b2e080e7          	jalr	-1234(ra) # 80002dd6 <bread>
    800032b0:	89aa                	mv	s3,a0
    a = (uint*)bp->data;
    800032b2:	05850a13          	add	s4,a0,88
    if ((addr = a[bn/SINGLYBNUM]) == 0) {
    800032b6:	0084d79b          	srlw	a5,s1,0x8
    800032ba:	078a                	sll	a5,a5,0x2
    800032bc:	9a3e                	add	s4,s4,a5
    800032be:	000a2a83          	lw	s5,0(s4) # 2000 <_entry-0x7fffe000>
    800032c2:	040a8a63          	beqz	s5,80003316 <bmap+0x152>
    brelse(bp);
    800032c6:	854e                	mv	a0,s3
    800032c8:	00000097          	auipc	ra,0x0
    800032cc:	c3e080e7          	jalr	-962(ra) # 80002f06 <brelse>
    bp = bread(ip->dev,addr);
    800032d0:	85d6                	mv	a1,s5
    800032d2:	00092503          	lw	a0,0(s2)
    800032d6:	00000097          	auipc	ra,0x0
    800032da:	b00080e7          	jalr	-1280(ra) # 80002dd6 <bread>
    800032de:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800032e0:	05850793          	add	a5,a0,88
    if ((addr = a[bn%SINGLYBNUM]) == 0) {
    800032e4:	0ff4f593          	zext.b	a1,s1
    800032e8:	058a                	sll	a1,a1,0x2
    800032ea:	00b784b3          	add	s1,a5,a1
    800032ee:	0004a983          	lw	s3,0(s1)
    800032f2:	04098263          	beqz	s3,80003336 <bmap+0x172>
    brelse(bp);
    800032f6:	8552                	mv	a0,s4
    800032f8:	00000097          	auipc	ra,0x0
    800032fc:	c0e080e7          	jalr	-1010(ra) # 80002f06 <brelse>
    return addr;
    80003300:	b72d                	j	8000322a <bmap+0x66>
      ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
    80003302:	4108                	lw	a0,0(a0)
    80003304:	00000097          	auipc	ra,0x0
    80003308:	d92080e7          	jalr	-622(ra) # 80003096 <balloc>
    8000330c:	0005059b          	sext.w	a1,a0
    80003310:	08b92023          	sw	a1,128(s2)
    80003314:	bf41                	j	800032a4 <bmap+0xe0>
      a[bn/SINGLYBNUM] = addr = balloc(ip->dev);
    80003316:	00092503          	lw	a0,0(s2)
    8000331a:	00000097          	auipc	ra,0x0
    8000331e:	d7c080e7          	jalr	-644(ra) # 80003096 <balloc>
    80003322:	00050a9b          	sext.w	s5,a0
    80003326:	015a2023          	sw	s5,0(s4)
      log_write(bp);
    8000332a:	854e                	mv	a0,s3
    8000332c:	00001097          	auipc	ra,0x1
    80003330:	f9a080e7          	jalr	-102(ra) # 800042c6 <log_write>
    80003334:	bf49                	j	800032c6 <bmap+0x102>
      a[bn%SINGLYBNUM] = addr = balloc(ip->dev);
    80003336:	00092503          	lw	a0,0(s2)
    8000333a:	00000097          	auipc	ra,0x0
    8000333e:	d5c080e7          	jalr	-676(ra) # 80003096 <balloc>
    80003342:	0005099b          	sext.w	s3,a0
    80003346:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000334a:	8552                	mv	a0,s4
    8000334c:	00001097          	auipc	ra,0x1
    80003350:	f7a080e7          	jalr	-134(ra) # 800042c6 <log_write>
    80003354:	b74d                	j	800032f6 <bmap+0x132>
  panic("bmap: out of range");
    80003356:	00005517          	auipc	a0,0x5
    8000335a:	1ea50513          	add	a0,a0,490 # 80008540 <syscalls+0x120>
    8000335e:	ffffd097          	auipc	ra,0xffffd
    80003362:	1ca080e7          	jalr	458(ra) # 80000528 <panic>

0000000080003366 <iget>:
{
    80003366:	7179                	add	sp,sp,-48
    80003368:	f406                	sd	ra,40(sp)
    8000336a:	f022                	sd	s0,32(sp)
    8000336c:	ec26                	sd	s1,24(sp)
    8000336e:	e84a                	sd	s2,16(sp)
    80003370:	e44e                	sd	s3,8(sp)
    80003372:	e052                	sd	s4,0(sp)
    80003374:	1800                	add	s0,sp,48
    80003376:	89aa                	mv	s3,a0
    80003378:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    8000337a:	00018517          	auipc	a0,0x18
    8000337e:	84650513          	add	a0,a0,-1978 # 8001abc0 <icache>
    80003382:	ffffe097          	auipc	ra,0xffffe
    80003386:	83c080e7          	jalr	-1988(ra) # 80000bbe <acquire>
  empty = 0;
    8000338a:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    8000338c:	00018497          	auipc	s1,0x18
    80003390:	84c48493          	add	s1,s1,-1972 # 8001abd8 <icache+0x18>
    80003394:	00019697          	auipc	a3,0x19
    80003398:	2d468693          	add	a3,a3,724 # 8001c668 <log>
    8000339c:	a039                	j	800033aa <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000339e:	02090b63          	beqz	s2,800033d4 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800033a2:	08848493          	add	s1,s1,136
    800033a6:	02d48a63          	beq	s1,a3,800033da <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800033aa:	449c                	lw	a5,8(s1)
    800033ac:	fef059e3          	blez	a5,8000339e <iget+0x38>
    800033b0:	4098                	lw	a4,0(s1)
    800033b2:	ff3716e3          	bne	a4,s3,8000339e <iget+0x38>
    800033b6:	40d8                	lw	a4,4(s1)
    800033b8:	ff4713e3          	bne	a4,s4,8000339e <iget+0x38>
      ip->ref++;
    800033bc:	2785                	addw	a5,a5,1
    800033be:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    800033c0:	00018517          	auipc	a0,0x18
    800033c4:	80050513          	add	a0,a0,-2048 # 8001abc0 <icache>
    800033c8:	ffffe097          	auipc	ra,0xffffe
    800033cc:	8aa080e7          	jalr	-1878(ra) # 80000c72 <release>
      return ip;
    800033d0:	8926                	mv	s2,s1
    800033d2:	a03d                	j	80003400 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800033d4:	f7f9                	bnez	a5,800033a2 <iget+0x3c>
    800033d6:	8926                	mv	s2,s1
    800033d8:	b7e9                	j	800033a2 <iget+0x3c>
  if(empty == 0)
    800033da:	02090c63          	beqz	s2,80003412 <iget+0xac>
  ip->dev = dev;
    800033de:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800033e2:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800033e6:	4785                	li	a5,1
    800033e8:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800033ec:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    800033f0:	00017517          	auipc	a0,0x17
    800033f4:	7d050513          	add	a0,a0,2000 # 8001abc0 <icache>
    800033f8:	ffffe097          	auipc	ra,0xffffe
    800033fc:	87a080e7          	jalr	-1926(ra) # 80000c72 <release>
}
    80003400:	854a                	mv	a0,s2
    80003402:	70a2                	ld	ra,40(sp)
    80003404:	7402                	ld	s0,32(sp)
    80003406:	64e2                	ld	s1,24(sp)
    80003408:	6942                	ld	s2,16(sp)
    8000340a:	69a2                	ld	s3,8(sp)
    8000340c:	6a02                	ld	s4,0(sp)
    8000340e:	6145                	add	sp,sp,48
    80003410:	8082                	ret
    panic("iget: no inodes");
    80003412:	00005517          	auipc	a0,0x5
    80003416:	14650513          	add	a0,a0,326 # 80008558 <syscalls+0x138>
    8000341a:	ffffd097          	auipc	ra,0xffffd
    8000341e:	10e080e7          	jalr	270(ra) # 80000528 <panic>

0000000080003422 <fsinit>:
fsinit(int dev) {
    80003422:	7179                	add	sp,sp,-48
    80003424:	f406                	sd	ra,40(sp)
    80003426:	f022                	sd	s0,32(sp)
    80003428:	ec26                	sd	s1,24(sp)
    8000342a:	e84a                	sd	s2,16(sp)
    8000342c:	e44e                	sd	s3,8(sp)
    8000342e:	1800                	add	s0,sp,48
    80003430:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003432:	4585                	li	a1,1
    80003434:	00000097          	auipc	ra,0x0
    80003438:	9a2080e7          	jalr	-1630(ra) # 80002dd6 <bread>
    8000343c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000343e:	00017997          	auipc	s3,0x17
    80003442:	76298993          	add	s3,s3,1890 # 8001aba0 <sb>
    80003446:	02000613          	li	a2,32
    8000344a:	05850593          	add	a1,a0,88
    8000344e:	854e                	mv	a0,s3
    80003450:	ffffe097          	auipc	ra,0xffffe
    80003454:	8c6080e7          	jalr	-1850(ra) # 80000d16 <memmove>
  brelse(bp);
    80003458:	8526                	mv	a0,s1
    8000345a:	00000097          	auipc	ra,0x0
    8000345e:	aac080e7          	jalr	-1364(ra) # 80002f06 <brelse>
  if(sb.magic != FSMAGIC)
    80003462:	0009a703          	lw	a4,0(s3)
    80003466:	102037b7          	lui	a5,0x10203
    8000346a:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000346e:	02f71263          	bne	a4,a5,80003492 <fsinit+0x70>
  initlog(dev, &sb);
    80003472:	00017597          	auipc	a1,0x17
    80003476:	72e58593          	add	a1,a1,1838 # 8001aba0 <sb>
    8000347a:	854a                	mv	a0,s2
    8000347c:	00001097          	auipc	ra,0x1
    80003480:	be0080e7          	jalr	-1056(ra) # 8000405c <initlog>
}
    80003484:	70a2                	ld	ra,40(sp)
    80003486:	7402                	ld	s0,32(sp)
    80003488:	64e2                	ld	s1,24(sp)
    8000348a:	6942                	ld	s2,16(sp)
    8000348c:	69a2                	ld	s3,8(sp)
    8000348e:	6145                	add	sp,sp,48
    80003490:	8082                	ret
    panic("invalid file system");
    80003492:	00005517          	auipc	a0,0x5
    80003496:	0d650513          	add	a0,a0,214 # 80008568 <syscalls+0x148>
    8000349a:	ffffd097          	auipc	ra,0xffffd
    8000349e:	08e080e7          	jalr	142(ra) # 80000528 <panic>

00000000800034a2 <iinit>:
{
    800034a2:	7179                	add	sp,sp,-48
    800034a4:	f406                	sd	ra,40(sp)
    800034a6:	f022                	sd	s0,32(sp)
    800034a8:	ec26                	sd	s1,24(sp)
    800034aa:	e84a                	sd	s2,16(sp)
    800034ac:	e44e                	sd	s3,8(sp)
    800034ae:	1800                	add	s0,sp,48
  initlock(&icache.lock, "icache");
    800034b0:	00005597          	auipc	a1,0x5
    800034b4:	0d058593          	add	a1,a1,208 # 80008580 <syscalls+0x160>
    800034b8:	00017517          	auipc	a0,0x17
    800034bc:	70850513          	add	a0,a0,1800 # 8001abc0 <icache>
    800034c0:	ffffd097          	auipc	ra,0xffffd
    800034c4:	66e080e7          	jalr	1646(ra) # 80000b2e <initlock>
  for(i = 0; i < NINODE; i++) {
    800034c8:	00017497          	auipc	s1,0x17
    800034cc:	72048493          	add	s1,s1,1824 # 8001abe8 <icache+0x28>
    800034d0:	00019997          	auipc	s3,0x19
    800034d4:	1a898993          	add	s3,s3,424 # 8001c678 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    800034d8:	00005917          	auipc	s2,0x5
    800034dc:	0b090913          	add	s2,s2,176 # 80008588 <syscalls+0x168>
    800034e0:	85ca                	mv	a1,s2
    800034e2:	8526                	mv	a0,s1
    800034e4:	00001097          	auipc	ra,0x1
    800034e8:	ece080e7          	jalr	-306(ra) # 800043b2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800034ec:	08848493          	add	s1,s1,136
    800034f0:	ff3498e3          	bne	s1,s3,800034e0 <iinit+0x3e>
}
    800034f4:	70a2                	ld	ra,40(sp)
    800034f6:	7402                	ld	s0,32(sp)
    800034f8:	64e2                	ld	s1,24(sp)
    800034fa:	6942                	ld	s2,16(sp)
    800034fc:	69a2                	ld	s3,8(sp)
    800034fe:	6145                	add	sp,sp,48
    80003500:	8082                	ret

0000000080003502 <ialloc>:
{
    80003502:	7139                	add	sp,sp,-64
    80003504:	fc06                	sd	ra,56(sp)
    80003506:	f822                	sd	s0,48(sp)
    80003508:	f426                	sd	s1,40(sp)
    8000350a:	f04a                	sd	s2,32(sp)
    8000350c:	ec4e                	sd	s3,24(sp)
    8000350e:	e852                	sd	s4,16(sp)
    80003510:	e456                	sd	s5,8(sp)
    80003512:	e05a                	sd	s6,0(sp)
    80003514:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003516:	00017717          	auipc	a4,0x17
    8000351a:	69672703          	lw	a4,1686(a4) # 8001abac <sb+0xc>
    8000351e:	4785                	li	a5,1
    80003520:	04e7f863          	bgeu	a5,a4,80003570 <ialloc+0x6e>
    80003524:	8aaa                	mv	s5,a0
    80003526:	8b2e                	mv	s6,a1
    80003528:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000352a:	00017a17          	auipc	s4,0x17
    8000352e:	676a0a13          	add	s4,s4,1654 # 8001aba0 <sb>
    80003532:	00495593          	srl	a1,s2,0x4
    80003536:	018a2783          	lw	a5,24(s4)
    8000353a:	9dbd                	addw	a1,a1,a5
    8000353c:	8556                	mv	a0,s5
    8000353e:	00000097          	auipc	ra,0x0
    80003542:	898080e7          	jalr	-1896(ra) # 80002dd6 <bread>
    80003546:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003548:	05850993          	add	s3,a0,88
    8000354c:	00f97793          	and	a5,s2,15
    80003550:	079a                	sll	a5,a5,0x6
    80003552:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003554:	00099783          	lh	a5,0(s3)
    80003558:	c785                	beqz	a5,80003580 <ialloc+0x7e>
    brelse(bp);
    8000355a:	00000097          	auipc	ra,0x0
    8000355e:	9ac080e7          	jalr	-1620(ra) # 80002f06 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003562:	0905                	add	s2,s2,1
    80003564:	00ca2703          	lw	a4,12(s4)
    80003568:	0009079b          	sext.w	a5,s2
    8000356c:	fce7e3e3          	bltu	a5,a4,80003532 <ialloc+0x30>
  panic("ialloc: no inodes");
    80003570:	00005517          	auipc	a0,0x5
    80003574:	02050513          	add	a0,a0,32 # 80008590 <syscalls+0x170>
    80003578:	ffffd097          	auipc	ra,0xffffd
    8000357c:	fb0080e7          	jalr	-80(ra) # 80000528 <panic>
      memset(dip, 0, sizeof(*dip));
    80003580:	04000613          	li	a2,64
    80003584:	4581                	li	a1,0
    80003586:	854e                	mv	a0,s3
    80003588:	ffffd097          	auipc	ra,0xffffd
    8000358c:	732080e7          	jalr	1842(ra) # 80000cba <memset>
      dip->type = type;
    80003590:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003594:	8526                	mv	a0,s1
    80003596:	00001097          	auipc	ra,0x1
    8000359a:	d30080e7          	jalr	-720(ra) # 800042c6 <log_write>
      brelse(bp);
    8000359e:	8526                	mv	a0,s1
    800035a0:	00000097          	auipc	ra,0x0
    800035a4:	966080e7          	jalr	-1690(ra) # 80002f06 <brelse>
      return iget(dev, inum);
    800035a8:	0009059b          	sext.w	a1,s2
    800035ac:	8556                	mv	a0,s5
    800035ae:	00000097          	auipc	ra,0x0
    800035b2:	db8080e7          	jalr	-584(ra) # 80003366 <iget>
}
    800035b6:	70e2                	ld	ra,56(sp)
    800035b8:	7442                	ld	s0,48(sp)
    800035ba:	74a2                	ld	s1,40(sp)
    800035bc:	7902                	ld	s2,32(sp)
    800035be:	69e2                	ld	s3,24(sp)
    800035c0:	6a42                	ld	s4,16(sp)
    800035c2:	6aa2                	ld	s5,8(sp)
    800035c4:	6b02                	ld	s6,0(sp)
    800035c6:	6121                	add	sp,sp,64
    800035c8:	8082                	ret

00000000800035ca <iupdate>:
{
    800035ca:	1101                	add	sp,sp,-32
    800035cc:	ec06                	sd	ra,24(sp)
    800035ce:	e822                	sd	s0,16(sp)
    800035d0:	e426                	sd	s1,8(sp)
    800035d2:	e04a                	sd	s2,0(sp)
    800035d4:	1000                	add	s0,sp,32
    800035d6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800035d8:	415c                	lw	a5,4(a0)
    800035da:	0047d79b          	srlw	a5,a5,0x4
    800035de:	00017597          	auipc	a1,0x17
    800035e2:	5da5a583          	lw	a1,1498(a1) # 8001abb8 <sb+0x18>
    800035e6:	9dbd                	addw	a1,a1,a5
    800035e8:	4108                	lw	a0,0(a0)
    800035ea:	fffff097          	auipc	ra,0xfffff
    800035ee:	7ec080e7          	jalr	2028(ra) # 80002dd6 <bread>
    800035f2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800035f4:	05850793          	add	a5,a0,88
    800035f8:	40d8                	lw	a4,4(s1)
    800035fa:	8b3d                	and	a4,a4,15
    800035fc:	071a                	sll	a4,a4,0x6
    800035fe:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003600:	04449703          	lh	a4,68(s1)
    80003604:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003608:	04649703          	lh	a4,70(s1)
    8000360c:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003610:	04849703          	lh	a4,72(s1)
    80003614:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003618:	04a49703          	lh	a4,74(s1)
    8000361c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003620:	44f8                	lw	a4,76(s1)
    80003622:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003624:	03400613          	li	a2,52
    80003628:	05048593          	add	a1,s1,80
    8000362c:	00c78513          	add	a0,a5,12
    80003630:	ffffd097          	auipc	ra,0xffffd
    80003634:	6e6080e7          	jalr	1766(ra) # 80000d16 <memmove>
  log_write(bp);
    80003638:	854a                	mv	a0,s2
    8000363a:	00001097          	auipc	ra,0x1
    8000363e:	c8c080e7          	jalr	-884(ra) # 800042c6 <log_write>
  brelse(bp);
    80003642:	854a                	mv	a0,s2
    80003644:	00000097          	auipc	ra,0x0
    80003648:	8c2080e7          	jalr	-1854(ra) # 80002f06 <brelse>
}
    8000364c:	60e2                	ld	ra,24(sp)
    8000364e:	6442                	ld	s0,16(sp)
    80003650:	64a2                	ld	s1,8(sp)
    80003652:	6902                	ld	s2,0(sp)
    80003654:	6105                	add	sp,sp,32
    80003656:	8082                	ret

0000000080003658 <idup>:
{
    80003658:	1101                	add	sp,sp,-32
    8000365a:	ec06                	sd	ra,24(sp)
    8000365c:	e822                	sd	s0,16(sp)
    8000365e:	e426                	sd	s1,8(sp)
    80003660:	1000                	add	s0,sp,32
    80003662:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003664:	00017517          	auipc	a0,0x17
    80003668:	55c50513          	add	a0,a0,1372 # 8001abc0 <icache>
    8000366c:	ffffd097          	auipc	ra,0xffffd
    80003670:	552080e7          	jalr	1362(ra) # 80000bbe <acquire>
  ip->ref++;
    80003674:	449c                	lw	a5,8(s1)
    80003676:	2785                	addw	a5,a5,1
    80003678:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    8000367a:	00017517          	auipc	a0,0x17
    8000367e:	54650513          	add	a0,a0,1350 # 8001abc0 <icache>
    80003682:	ffffd097          	auipc	ra,0xffffd
    80003686:	5f0080e7          	jalr	1520(ra) # 80000c72 <release>
}
    8000368a:	8526                	mv	a0,s1
    8000368c:	60e2                	ld	ra,24(sp)
    8000368e:	6442                	ld	s0,16(sp)
    80003690:	64a2                	ld	s1,8(sp)
    80003692:	6105                	add	sp,sp,32
    80003694:	8082                	ret

0000000080003696 <ilock>:
{
    80003696:	1101                	add	sp,sp,-32
    80003698:	ec06                	sd	ra,24(sp)
    8000369a:	e822                	sd	s0,16(sp)
    8000369c:	e426                	sd	s1,8(sp)
    8000369e:	e04a                	sd	s2,0(sp)
    800036a0:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800036a2:	c115                	beqz	a0,800036c6 <ilock+0x30>
    800036a4:	84aa                	mv	s1,a0
    800036a6:	451c                	lw	a5,8(a0)
    800036a8:	00f05f63          	blez	a5,800036c6 <ilock+0x30>
  acquiresleep(&ip->lock);
    800036ac:	0541                	add	a0,a0,16
    800036ae:	00001097          	auipc	ra,0x1
    800036b2:	d3e080e7          	jalr	-706(ra) # 800043ec <acquiresleep>
  if(ip->valid == 0){
    800036b6:	40bc                	lw	a5,64(s1)
    800036b8:	cf99                	beqz	a5,800036d6 <ilock+0x40>
}
    800036ba:	60e2                	ld	ra,24(sp)
    800036bc:	6442                	ld	s0,16(sp)
    800036be:	64a2                	ld	s1,8(sp)
    800036c0:	6902                	ld	s2,0(sp)
    800036c2:	6105                	add	sp,sp,32
    800036c4:	8082                	ret
    panic("ilock");
    800036c6:	00005517          	auipc	a0,0x5
    800036ca:	ee250513          	add	a0,a0,-286 # 800085a8 <syscalls+0x188>
    800036ce:	ffffd097          	auipc	ra,0xffffd
    800036d2:	e5a080e7          	jalr	-422(ra) # 80000528 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800036d6:	40dc                	lw	a5,4(s1)
    800036d8:	0047d79b          	srlw	a5,a5,0x4
    800036dc:	00017597          	auipc	a1,0x17
    800036e0:	4dc5a583          	lw	a1,1244(a1) # 8001abb8 <sb+0x18>
    800036e4:	9dbd                	addw	a1,a1,a5
    800036e6:	4088                	lw	a0,0(s1)
    800036e8:	fffff097          	auipc	ra,0xfffff
    800036ec:	6ee080e7          	jalr	1774(ra) # 80002dd6 <bread>
    800036f0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800036f2:	05850593          	add	a1,a0,88
    800036f6:	40dc                	lw	a5,4(s1)
    800036f8:	8bbd                	and	a5,a5,15
    800036fa:	079a                	sll	a5,a5,0x6
    800036fc:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800036fe:	00059783          	lh	a5,0(a1)
    80003702:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003706:	00259783          	lh	a5,2(a1)
    8000370a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000370e:	00459783          	lh	a5,4(a1)
    80003712:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003716:	00659783          	lh	a5,6(a1)
    8000371a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000371e:	459c                	lw	a5,8(a1)
    80003720:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003722:	03400613          	li	a2,52
    80003726:	05b1                	add	a1,a1,12
    80003728:	05048513          	add	a0,s1,80
    8000372c:	ffffd097          	auipc	ra,0xffffd
    80003730:	5ea080e7          	jalr	1514(ra) # 80000d16 <memmove>
    brelse(bp);
    80003734:	854a                	mv	a0,s2
    80003736:	fffff097          	auipc	ra,0xfffff
    8000373a:	7d0080e7          	jalr	2000(ra) # 80002f06 <brelse>
    ip->valid = 1;
    8000373e:	4785                	li	a5,1
    80003740:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003742:	04449783          	lh	a5,68(s1)
    80003746:	fbb5                	bnez	a5,800036ba <ilock+0x24>
      panic("ilock: no type");
    80003748:	00005517          	auipc	a0,0x5
    8000374c:	e6850513          	add	a0,a0,-408 # 800085b0 <syscalls+0x190>
    80003750:	ffffd097          	auipc	ra,0xffffd
    80003754:	dd8080e7          	jalr	-552(ra) # 80000528 <panic>

0000000080003758 <iunlock>:
{
    80003758:	1101                	add	sp,sp,-32
    8000375a:	ec06                	sd	ra,24(sp)
    8000375c:	e822                	sd	s0,16(sp)
    8000375e:	e426                	sd	s1,8(sp)
    80003760:	e04a                	sd	s2,0(sp)
    80003762:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003764:	c905                	beqz	a0,80003794 <iunlock+0x3c>
    80003766:	84aa                	mv	s1,a0
    80003768:	01050913          	add	s2,a0,16
    8000376c:	854a                	mv	a0,s2
    8000376e:	00001097          	auipc	ra,0x1
    80003772:	d18080e7          	jalr	-744(ra) # 80004486 <holdingsleep>
    80003776:	cd19                	beqz	a0,80003794 <iunlock+0x3c>
    80003778:	449c                	lw	a5,8(s1)
    8000377a:	00f05d63          	blez	a5,80003794 <iunlock+0x3c>
  releasesleep(&ip->lock);
    8000377e:	854a                	mv	a0,s2
    80003780:	00001097          	auipc	ra,0x1
    80003784:	cc2080e7          	jalr	-830(ra) # 80004442 <releasesleep>
}
    80003788:	60e2                	ld	ra,24(sp)
    8000378a:	6442                	ld	s0,16(sp)
    8000378c:	64a2                	ld	s1,8(sp)
    8000378e:	6902                	ld	s2,0(sp)
    80003790:	6105                	add	sp,sp,32
    80003792:	8082                	ret
    panic("iunlock");
    80003794:	00005517          	auipc	a0,0x5
    80003798:	e2c50513          	add	a0,a0,-468 # 800085c0 <syscalls+0x1a0>
    8000379c:	ffffd097          	auipc	ra,0xffffd
    800037a0:	d8c080e7          	jalr	-628(ra) # 80000528 <panic>

00000000800037a4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800037a4:	715d                	add	sp,sp,-80
    800037a6:	e486                	sd	ra,72(sp)
    800037a8:	e0a2                	sd	s0,64(sp)
    800037aa:	fc26                	sd	s1,56(sp)
    800037ac:	f84a                	sd	s2,48(sp)
    800037ae:	f44e                	sd	s3,40(sp)
    800037b0:	f052                	sd	s4,32(sp)
    800037b2:	ec56                	sd	s5,24(sp)
    800037b4:	e85a                	sd	s6,16(sp)
    800037b6:	e45e                	sd	s7,8(sp)
    800037b8:	e062                	sd	s8,0(sp)
    800037ba:	0880                	add	s0,sp,80
    800037bc:	89aa                	mv	s3,a0
  int i, j, k;
  struct buf *bp,*bp2;
  uint *a, *a2;

  for(i = 0; i < NDIRECT; i++){
    800037be:	05050493          	add	s1,a0,80
    800037c2:	07c50913          	add	s2,a0,124
    800037c6:	a021                	j	800037ce <itrunc+0x2a>
    800037c8:	0491                	add	s1,s1,4
    800037ca:	01248d63          	beq	s1,s2,800037e4 <itrunc+0x40>
    if(ip->addrs[i]){
    800037ce:	408c                	lw	a1,0(s1)
    800037d0:	dde5                	beqz	a1,800037c8 <itrunc+0x24>
      bfree(ip->dev, ip->addrs[i]);
    800037d2:	0009a503          	lw	a0,0(s3)
    800037d6:	00000097          	auipc	ra,0x0
    800037da:	844080e7          	jalr	-1980(ra) # 8000301a <bfree>
      ip->addrs[i] = 0;
    800037de:	0004a023          	sw	zero,0(s1)
    800037e2:	b7dd                	j	800037c8 <itrunc+0x24>
    }
  }

  // free the singly-indirect blocks
  if(ip->addrs[NDIRECT]){
    800037e4:	07c9a583          	lw	a1,124(s3)
    800037e8:	e59d                	bnez	a1,80003816 <itrunc+0x72>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  // free the doubly-indirect blocks
  if (ip->addrs[NDIRECT+1]) {
    800037ea:	0809a583          	lw	a1,128(s3)
    800037ee:	eda5                	bnez	a1,80003866 <itrunc+0xc2>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT+1]);
    ip->addrs[NDIRECT+1] = 0;
  }

  ip->size = 0;
    800037f0:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800037f4:	854e                	mv	a0,s3
    800037f6:	00000097          	auipc	ra,0x0
    800037fa:	dd4080e7          	jalr	-556(ra) # 800035ca <iupdate>
}
    800037fe:	60a6                	ld	ra,72(sp)
    80003800:	6406                	ld	s0,64(sp)
    80003802:	74e2                	ld	s1,56(sp)
    80003804:	7942                	ld	s2,48(sp)
    80003806:	79a2                	ld	s3,40(sp)
    80003808:	7a02                	ld	s4,32(sp)
    8000380a:	6ae2                	ld	s5,24(sp)
    8000380c:	6b42                	ld	s6,16(sp)
    8000380e:	6ba2                	ld	s7,8(sp)
    80003810:	6c02                	ld	s8,0(sp)
    80003812:	6161                	add	sp,sp,80
    80003814:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003816:	0009a503          	lw	a0,0(s3)
    8000381a:	fffff097          	auipc	ra,0xfffff
    8000381e:	5bc080e7          	jalr	1468(ra) # 80002dd6 <bread>
    80003822:	8a2a                	mv	s4,a0
    for(j = 0; j < SINGLYBNUM; j++){
    80003824:	05850493          	add	s1,a0,88
    80003828:	45850913          	add	s2,a0,1112
    8000382c:	a021                	j	80003834 <itrunc+0x90>
    8000382e:	0491                	add	s1,s1,4
    80003830:	01248b63          	beq	s1,s2,80003846 <itrunc+0xa2>
      if(a[j])
    80003834:	408c                	lw	a1,0(s1)
    80003836:	dde5                	beqz	a1,8000382e <itrunc+0x8a>
        bfree(ip->dev, a[j]);
    80003838:	0009a503          	lw	a0,0(s3)
    8000383c:	fffff097          	auipc	ra,0xfffff
    80003840:	7de080e7          	jalr	2014(ra) # 8000301a <bfree>
    80003844:	b7ed                	j	8000382e <itrunc+0x8a>
    brelse(bp);
    80003846:	8552                	mv	a0,s4
    80003848:	fffff097          	auipc	ra,0xfffff
    8000384c:	6be080e7          	jalr	1726(ra) # 80002f06 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003850:	07c9a583          	lw	a1,124(s3)
    80003854:	0009a503          	lw	a0,0(s3)
    80003858:	fffff097          	auipc	ra,0xfffff
    8000385c:	7c2080e7          	jalr	1986(ra) # 8000301a <bfree>
    ip->addrs[NDIRECT] = 0;
    80003860:	0609ae23          	sw	zero,124(s3)
    80003864:	b759                	j	800037ea <itrunc+0x46>
    bp = bread(ip->dev,ip->addrs[NDIRECT+1]);
    80003866:	0009a503          	lw	a0,0(s3)
    8000386a:	fffff097          	auipc	ra,0xfffff
    8000386e:	56c080e7          	jalr	1388(ra) # 80002dd6 <bread>
    80003872:	8c2a                	mv	s8,a0
    for (j = 0; j < SINGLYBNUM; j++) {
    80003874:	05850a13          	add	s4,a0,88
    80003878:	45850b13          	add	s6,a0,1112
    8000387c:	a82d                	j	800038b6 <itrunc+0x112>
        for (k = 0; k < SINGLYBNUM; k++) {
    8000387e:	0491                	add	s1,s1,4
    80003880:	00990b63          	beq	s2,s1,80003896 <itrunc+0xf2>
          if (a2[k])
    80003884:	408c                	lw	a1,0(s1)
    80003886:	dde5                	beqz	a1,8000387e <itrunc+0xda>
            bfree(ip->dev,a2[k]);
    80003888:	0009a503          	lw	a0,0(s3)
    8000388c:	fffff097          	auipc	ra,0xfffff
    80003890:	78e080e7          	jalr	1934(ra) # 8000301a <bfree>
    80003894:	b7ed                	j	8000387e <itrunc+0xda>
        brelse(bp2);
    80003896:	855e                	mv	a0,s7
    80003898:	fffff097          	auipc	ra,0xfffff
    8000389c:	66e080e7          	jalr	1646(ra) # 80002f06 <brelse>
        bfree(ip->dev,a[j]);
    800038a0:	000aa583          	lw	a1,0(s5)
    800038a4:	0009a503          	lw	a0,0(s3)
    800038a8:	fffff097          	auipc	ra,0xfffff
    800038ac:	772080e7          	jalr	1906(ra) # 8000301a <bfree>
    for (j = 0; j < SINGLYBNUM; j++) {
    800038b0:	0a11                	add	s4,s4,4
    800038b2:	034b0263          	beq	s6,s4,800038d6 <itrunc+0x132>
      if (a[j]) {
    800038b6:	8ad2                	mv	s5,s4
    800038b8:	000a2583          	lw	a1,0(s4)
    800038bc:	d9f5                	beqz	a1,800038b0 <itrunc+0x10c>
        bp2 = bread(ip->dev,a[j]);
    800038be:	0009a503          	lw	a0,0(s3)
    800038c2:	fffff097          	auipc	ra,0xfffff
    800038c6:	514080e7          	jalr	1300(ra) # 80002dd6 <bread>
    800038ca:	8baa                	mv	s7,a0
        for (k = 0; k < SINGLYBNUM; k++) {
    800038cc:	05850493          	add	s1,a0,88
    800038d0:	45850913          	add	s2,a0,1112
    800038d4:	bf45                	j	80003884 <itrunc+0xe0>
    brelse(bp);
    800038d6:	8562                	mv	a0,s8
    800038d8:	fffff097          	auipc	ra,0xfffff
    800038dc:	62e080e7          	jalr	1582(ra) # 80002f06 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT+1]);
    800038e0:	0809a583          	lw	a1,128(s3)
    800038e4:	0009a503          	lw	a0,0(s3)
    800038e8:	fffff097          	auipc	ra,0xfffff
    800038ec:	732080e7          	jalr	1842(ra) # 8000301a <bfree>
    ip->addrs[NDIRECT+1] = 0;
    800038f0:	0809a023          	sw	zero,128(s3)
    800038f4:	bdf5                	j	800037f0 <itrunc+0x4c>

00000000800038f6 <iput>:
{
    800038f6:	1101                	add	sp,sp,-32
    800038f8:	ec06                	sd	ra,24(sp)
    800038fa:	e822                	sd	s0,16(sp)
    800038fc:	e426                	sd	s1,8(sp)
    800038fe:	e04a                	sd	s2,0(sp)
    80003900:	1000                	add	s0,sp,32
    80003902:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003904:	00017517          	auipc	a0,0x17
    80003908:	2bc50513          	add	a0,a0,700 # 8001abc0 <icache>
    8000390c:	ffffd097          	auipc	ra,0xffffd
    80003910:	2b2080e7          	jalr	690(ra) # 80000bbe <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003914:	4498                	lw	a4,8(s1)
    80003916:	4785                	li	a5,1
    80003918:	02f70363          	beq	a4,a5,8000393e <iput+0x48>
  ip->ref--;
    8000391c:	449c                	lw	a5,8(s1)
    8000391e:	37fd                	addw	a5,a5,-1
    80003920:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003922:	00017517          	auipc	a0,0x17
    80003926:	29e50513          	add	a0,a0,670 # 8001abc0 <icache>
    8000392a:	ffffd097          	auipc	ra,0xffffd
    8000392e:	348080e7          	jalr	840(ra) # 80000c72 <release>
}
    80003932:	60e2                	ld	ra,24(sp)
    80003934:	6442                	ld	s0,16(sp)
    80003936:	64a2                	ld	s1,8(sp)
    80003938:	6902                	ld	s2,0(sp)
    8000393a:	6105                	add	sp,sp,32
    8000393c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000393e:	40bc                	lw	a5,64(s1)
    80003940:	dff1                	beqz	a5,8000391c <iput+0x26>
    80003942:	04a49783          	lh	a5,74(s1)
    80003946:	fbf9                	bnez	a5,8000391c <iput+0x26>
    acquiresleep(&ip->lock);
    80003948:	01048913          	add	s2,s1,16
    8000394c:	854a                	mv	a0,s2
    8000394e:	00001097          	auipc	ra,0x1
    80003952:	a9e080e7          	jalr	-1378(ra) # 800043ec <acquiresleep>
    release(&icache.lock);
    80003956:	00017517          	auipc	a0,0x17
    8000395a:	26a50513          	add	a0,a0,618 # 8001abc0 <icache>
    8000395e:	ffffd097          	auipc	ra,0xffffd
    80003962:	314080e7          	jalr	788(ra) # 80000c72 <release>
    itrunc(ip);
    80003966:	8526                	mv	a0,s1
    80003968:	00000097          	auipc	ra,0x0
    8000396c:	e3c080e7          	jalr	-452(ra) # 800037a4 <itrunc>
    ip->type = 0;
    80003970:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003974:	8526                	mv	a0,s1
    80003976:	00000097          	auipc	ra,0x0
    8000397a:	c54080e7          	jalr	-940(ra) # 800035ca <iupdate>
    ip->valid = 0;
    8000397e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003982:	854a                	mv	a0,s2
    80003984:	00001097          	auipc	ra,0x1
    80003988:	abe080e7          	jalr	-1346(ra) # 80004442 <releasesleep>
    acquire(&icache.lock);
    8000398c:	00017517          	auipc	a0,0x17
    80003990:	23450513          	add	a0,a0,564 # 8001abc0 <icache>
    80003994:	ffffd097          	auipc	ra,0xffffd
    80003998:	22a080e7          	jalr	554(ra) # 80000bbe <acquire>
    8000399c:	b741                	j	8000391c <iput+0x26>

000000008000399e <iunlockput>:
{
    8000399e:	1101                	add	sp,sp,-32
    800039a0:	ec06                	sd	ra,24(sp)
    800039a2:	e822                	sd	s0,16(sp)
    800039a4:	e426                	sd	s1,8(sp)
    800039a6:	1000                	add	s0,sp,32
    800039a8:	84aa                	mv	s1,a0
  iunlock(ip);
    800039aa:	00000097          	auipc	ra,0x0
    800039ae:	dae080e7          	jalr	-594(ra) # 80003758 <iunlock>
  iput(ip);
    800039b2:	8526                	mv	a0,s1
    800039b4:	00000097          	auipc	ra,0x0
    800039b8:	f42080e7          	jalr	-190(ra) # 800038f6 <iput>
}
    800039bc:	60e2                	ld	ra,24(sp)
    800039be:	6442                	ld	s0,16(sp)
    800039c0:	64a2                	ld	s1,8(sp)
    800039c2:	6105                	add	sp,sp,32
    800039c4:	8082                	ret

00000000800039c6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800039c6:	1141                	add	sp,sp,-16
    800039c8:	e422                	sd	s0,8(sp)
    800039ca:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    800039cc:	411c                	lw	a5,0(a0)
    800039ce:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800039d0:	415c                	lw	a5,4(a0)
    800039d2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800039d4:	04451783          	lh	a5,68(a0)
    800039d8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800039dc:	04a51783          	lh	a5,74(a0)
    800039e0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800039e4:	04c56783          	lwu	a5,76(a0)
    800039e8:	e99c                	sd	a5,16(a1)
}
    800039ea:	6422                	ld	s0,8(sp)
    800039ec:	0141                	add	sp,sp,16
    800039ee:	8082                	ret

00000000800039f0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800039f0:	457c                	lw	a5,76(a0)
    800039f2:	0ed7e963          	bltu	a5,a3,80003ae4 <readi+0xf4>
{
    800039f6:	7159                	add	sp,sp,-112
    800039f8:	f486                	sd	ra,104(sp)
    800039fa:	f0a2                	sd	s0,96(sp)
    800039fc:	eca6                	sd	s1,88(sp)
    800039fe:	e8ca                	sd	s2,80(sp)
    80003a00:	e4ce                	sd	s3,72(sp)
    80003a02:	e0d2                	sd	s4,64(sp)
    80003a04:	fc56                	sd	s5,56(sp)
    80003a06:	f85a                	sd	s6,48(sp)
    80003a08:	f45e                	sd	s7,40(sp)
    80003a0a:	f062                	sd	s8,32(sp)
    80003a0c:	ec66                	sd	s9,24(sp)
    80003a0e:	e86a                	sd	s10,16(sp)
    80003a10:	e46e                	sd	s11,8(sp)
    80003a12:	1880                	add	s0,sp,112
    80003a14:	8baa                	mv	s7,a0
    80003a16:	8c2e                	mv	s8,a1
    80003a18:	8ab2                	mv	s5,a2
    80003a1a:	84b6                	mv	s1,a3
    80003a1c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003a1e:	9f35                	addw	a4,a4,a3
    return 0;
    80003a20:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003a22:	0ad76063          	bltu	a4,a3,80003ac2 <readi+0xd2>
  if(off + n > ip->size)
    80003a26:	00e7f463          	bgeu	a5,a4,80003a2e <readi+0x3e>
    n = ip->size - off;
    80003a2a:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a2e:	0a0b0963          	beqz	s6,80003ae0 <readi+0xf0>
    80003a32:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a34:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003a38:	5cfd                	li	s9,-1
    80003a3a:	a82d                	j	80003a74 <readi+0x84>
    80003a3c:	020a1d93          	sll	s11,s4,0x20
    80003a40:	020ddd93          	srl	s11,s11,0x20
    80003a44:	05890613          	add	a2,s2,88
    80003a48:	86ee                	mv	a3,s11
    80003a4a:	963a                	add	a2,a2,a4
    80003a4c:	85d6                	mv	a1,s5
    80003a4e:	8562                	mv	a0,s8
    80003a50:	fffff097          	auipc	ra,0xfffff
    80003a54:	9c4080e7          	jalr	-1596(ra) # 80002414 <either_copyout>
    80003a58:	05950d63          	beq	a0,s9,80003ab2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003a5c:	854a                	mv	a0,s2
    80003a5e:	fffff097          	auipc	ra,0xfffff
    80003a62:	4a8080e7          	jalr	1192(ra) # 80002f06 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a66:	013a09bb          	addw	s3,s4,s3
    80003a6a:	009a04bb          	addw	s1,s4,s1
    80003a6e:	9aee                	add	s5,s5,s11
    80003a70:	0569f763          	bgeu	s3,s6,80003abe <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003a74:	000ba903          	lw	s2,0(s7)
    80003a78:	00a4d59b          	srlw	a1,s1,0xa
    80003a7c:	855e                	mv	a0,s7
    80003a7e:	fffff097          	auipc	ra,0xfffff
    80003a82:	746080e7          	jalr	1862(ra) # 800031c4 <bmap>
    80003a86:	0005059b          	sext.w	a1,a0
    80003a8a:	854a                	mv	a0,s2
    80003a8c:	fffff097          	auipc	ra,0xfffff
    80003a90:	34a080e7          	jalr	842(ra) # 80002dd6 <bread>
    80003a94:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a96:	3ff4f713          	and	a4,s1,1023
    80003a9a:	40ed07bb          	subw	a5,s10,a4
    80003a9e:	413b06bb          	subw	a3,s6,s3
    80003aa2:	8a3e                	mv	s4,a5
    80003aa4:	2781                	sext.w	a5,a5
    80003aa6:	0006861b          	sext.w	a2,a3
    80003aaa:	f8f679e3          	bgeu	a2,a5,80003a3c <readi+0x4c>
    80003aae:	8a36                	mv	s4,a3
    80003ab0:	b771                	j	80003a3c <readi+0x4c>
      brelse(bp);
    80003ab2:	854a                	mv	a0,s2
    80003ab4:	fffff097          	auipc	ra,0xfffff
    80003ab8:	452080e7          	jalr	1106(ra) # 80002f06 <brelse>
      tot = -1;
    80003abc:	59fd                	li	s3,-1
  }
  return tot;
    80003abe:	0009851b          	sext.w	a0,s3
}
    80003ac2:	70a6                	ld	ra,104(sp)
    80003ac4:	7406                	ld	s0,96(sp)
    80003ac6:	64e6                	ld	s1,88(sp)
    80003ac8:	6946                	ld	s2,80(sp)
    80003aca:	69a6                	ld	s3,72(sp)
    80003acc:	6a06                	ld	s4,64(sp)
    80003ace:	7ae2                	ld	s5,56(sp)
    80003ad0:	7b42                	ld	s6,48(sp)
    80003ad2:	7ba2                	ld	s7,40(sp)
    80003ad4:	7c02                	ld	s8,32(sp)
    80003ad6:	6ce2                	ld	s9,24(sp)
    80003ad8:	6d42                	ld	s10,16(sp)
    80003ada:	6da2                	ld	s11,8(sp)
    80003adc:	6165                	add	sp,sp,112
    80003ade:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ae0:	89da                	mv	s3,s6
    80003ae2:	bff1                	j	80003abe <readi+0xce>
    return 0;
    80003ae4:	4501                	li	a0,0
}
    80003ae6:	8082                	ret

0000000080003ae8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003ae8:	457c                	lw	a5,76(a0)
    80003aea:	10d7e963          	bltu	a5,a3,80003bfc <writei+0x114>
{
    80003aee:	7159                	add	sp,sp,-112
    80003af0:	f486                	sd	ra,104(sp)
    80003af2:	f0a2                	sd	s0,96(sp)
    80003af4:	eca6                	sd	s1,88(sp)
    80003af6:	e8ca                	sd	s2,80(sp)
    80003af8:	e4ce                	sd	s3,72(sp)
    80003afa:	e0d2                	sd	s4,64(sp)
    80003afc:	fc56                	sd	s5,56(sp)
    80003afe:	f85a                	sd	s6,48(sp)
    80003b00:	f45e                	sd	s7,40(sp)
    80003b02:	f062                	sd	s8,32(sp)
    80003b04:	ec66                	sd	s9,24(sp)
    80003b06:	e86a                	sd	s10,16(sp)
    80003b08:	e46e                	sd	s11,8(sp)
    80003b0a:	1880                	add	s0,sp,112
    80003b0c:	8b2a                	mv	s6,a0
    80003b0e:	8c2e                	mv	s8,a1
    80003b10:	8ab2                	mv	s5,a2
    80003b12:	8936                	mv	s2,a3
    80003b14:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003b16:	9f35                	addw	a4,a4,a3
    80003b18:	0ed76463          	bltu	a4,a3,80003c00 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003b1c:	040437b7          	lui	a5,0x4043
    80003b20:	c0078793          	add	a5,a5,-1024 # 4042c00 <_entry-0x7bfbd400>
    80003b24:	0ee7e063          	bltu	a5,a4,80003c04 <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b28:	0c0b8863          	beqz	s7,80003bf8 <writei+0x110>
    80003b2c:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b2e:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003b32:	5cfd                	li	s9,-1
    80003b34:	a091                	j	80003b78 <writei+0x90>
    80003b36:	02099d93          	sll	s11,s3,0x20
    80003b3a:	020ddd93          	srl	s11,s11,0x20
    80003b3e:	05848513          	add	a0,s1,88
    80003b42:	86ee                	mv	a3,s11
    80003b44:	8656                	mv	a2,s5
    80003b46:	85e2                	mv	a1,s8
    80003b48:	953a                	add	a0,a0,a4
    80003b4a:	fffff097          	auipc	ra,0xfffff
    80003b4e:	920080e7          	jalr	-1760(ra) # 8000246a <either_copyin>
    80003b52:	07950263          	beq	a0,s9,80003bb6 <writei+0xce>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003b56:	8526                	mv	a0,s1
    80003b58:	00000097          	auipc	ra,0x0
    80003b5c:	76e080e7          	jalr	1902(ra) # 800042c6 <log_write>
    brelse(bp);
    80003b60:	8526                	mv	a0,s1
    80003b62:	fffff097          	auipc	ra,0xfffff
    80003b66:	3a4080e7          	jalr	932(ra) # 80002f06 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b6a:	01498a3b          	addw	s4,s3,s4
    80003b6e:	0129893b          	addw	s2,s3,s2
    80003b72:	9aee                	add	s5,s5,s11
    80003b74:	057a7663          	bgeu	s4,s7,80003bc0 <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003b78:	000b2483          	lw	s1,0(s6)
    80003b7c:	00a9559b          	srlw	a1,s2,0xa
    80003b80:	855a                	mv	a0,s6
    80003b82:	fffff097          	auipc	ra,0xfffff
    80003b86:	642080e7          	jalr	1602(ra) # 800031c4 <bmap>
    80003b8a:	0005059b          	sext.w	a1,a0
    80003b8e:	8526                	mv	a0,s1
    80003b90:	fffff097          	auipc	ra,0xfffff
    80003b94:	246080e7          	jalr	582(ra) # 80002dd6 <bread>
    80003b98:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b9a:	3ff97713          	and	a4,s2,1023
    80003b9e:	40ed07bb          	subw	a5,s10,a4
    80003ba2:	414b86bb          	subw	a3,s7,s4
    80003ba6:	89be                	mv	s3,a5
    80003ba8:	2781                	sext.w	a5,a5
    80003baa:	0006861b          	sext.w	a2,a3
    80003bae:	f8f674e3          	bgeu	a2,a5,80003b36 <writei+0x4e>
    80003bb2:	89b6                	mv	s3,a3
    80003bb4:	b749                	j	80003b36 <writei+0x4e>
      brelse(bp);
    80003bb6:	8526                	mv	a0,s1
    80003bb8:	fffff097          	auipc	ra,0xfffff
    80003bbc:	34e080e7          	jalr	846(ra) # 80002f06 <brelse>
  }

  if(off > ip->size)
    80003bc0:	04cb2783          	lw	a5,76(s6)
    80003bc4:	0127f463          	bgeu	a5,s2,80003bcc <writei+0xe4>
    ip->size = off;
    80003bc8:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003bcc:	855a                	mv	a0,s6
    80003bce:	00000097          	auipc	ra,0x0
    80003bd2:	9fc080e7          	jalr	-1540(ra) # 800035ca <iupdate>

  return tot;
    80003bd6:	000a051b          	sext.w	a0,s4
}
    80003bda:	70a6                	ld	ra,104(sp)
    80003bdc:	7406                	ld	s0,96(sp)
    80003bde:	64e6                	ld	s1,88(sp)
    80003be0:	6946                	ld	s2,80(sp)
    80003be2:	69a6                	ld	s3,72(sp)
    80003be4:	6a06                	ld	s4,64(sp)
    80003be6:	7ae2                	ld	s5,56(sp)
    80003be8:	7b42                	ld	s6,48(sp)
    80003bea:	7ba2                	ld	s7,40(sp)
    80003bec:	7c02                	ld	s8,32(sp)
    80003bee:	6ce2                	ld	s9,24(sp)
    80003bf0:	6d42                	ld	s10,16(sp)
    80003bf2:	6da2                	ld	s11,8(sp)
    80003bf4:	6165                	add	sp,sp,112
    80003bf6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003bf8:	8a5e                	mv	s4,s7
    80003bfa:	bfc9                	j	80003bcc <writei+0xe4>
    return -1;
    80003bfc:	557d                	li	a0,-1
}
    80003bfe:	8082                	ret
    return -1;
    80003c00:	557d                	li	a0,-1
    80003c02:	bfe1                	j	80003bda <writei+0xf2>
    return -1;
    80003c04:	557d                	li	a0,-1
    80003c06:	bfd1                	j	80003bda <writei+0xf2>

0000000080003c08 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003c08:	1141                	add	sp,sp,-16
    80003c0a:	e406                	sd	ra,8(sp)
    80003c0c:	e022                	sd	s0,0(sp)
    80003c0e:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003c10:	4639                	li	a2,14
    80003c12:	ffffd097          	auipc	ra,0xffffd
    80003c16:	180080e7          	jalr	384(ra) # 80000d92 <strncmp>
}
    80003c1a:	60a2                	ld	ra,8(sp)
    80003c1c:	6402                	ld	s0,0(sp)
    80003c1e:	0141                	add	sp,sp,16
    80003c20:	8082                	ret

0000000080003c22 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003c22:	7139                	add	sp,sp,-64
    80003c24:	fc06                	sd	ra,56(sp)
    80003c26:	f822                	sd	s0,48(sp)
    80003c28:	f426                	sd	s1,40(sp)
    80003c2a:	f04a                	sd	s2,32(sp)
    80003c2c:	ec4e                	sd	s3,24(sp)
    80003c2e:	e852                	sd	s4,16(sp)
    80003c30:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003c32:	04451703          	lh	a4,68(a0)
    80003c36:	4785                	li	a5,1
    80003c38:	00f71a63          	bne	a4,a5,80003c4c <dirlookup+0x2a>
    80003c3c:	892a                	mv	s2,a0
    80003c3e:	89ae                	mv	s3,a1
    80003c40:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c42:	457c                	lw	a5,76(a0)
    80003c44:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003c46:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c48:	e79d                	bnez	a5,80003c76 <dirlookup+0x54>
    80003c4a:	a8a5                	j	80003cc2 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003c4c:	00005517          	auipc	a0,0x5
    80003c50:	97c50513          	add	a0,a0,-1668 # 800085c8 <syscalls+0x1a8>
    80003c54:	ffffd097          	auipc	ra,0xffffd
    80003c58:	8d4080e7          	jalr	-1836(ra) # 80000528 <panic>
      panic("dirlookup read");
    80003c5c:	00005517          	auipc	a0,0x5
    80003c60:	98450513          	add	a0,a0,-1660 # 800085e0 <syscalls+0x1c0>
    80003c64:	ffffd097          	auipc	ra,0xffffd
    80003c68:	8c4080e7          	jalr	-1852(ra) # 80000528 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c6c:	24c1                	addw	s1,s1,16
    80003c6e:	04c92783          	lw	a5,76(s2)
    80003c72:	04f4f763          	bgeu	s1,a5,80003cc0 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c76:	4741                	li	a4,16
    80003c78:	86a6                	mv	a3,s1
    80003c7a:	fc040613          	add	a2,s0,-64
    80003c7e:	4581                	li	a1,0
    80003c80:	854a                	mv	a0,s2
    80003c82:	00000097          	auipc	ra,0x0
    80003c86:	d6e080e7          	jalr	-658(ra) # 800039f0 <readi>
    80003c8a:	47c1                	li	a5,16
    80003c8c:	fcf518e3          	bne	a0,a5,80003c5c <dirlookup+0x3a>
    if(de.inum == 0)
    80003c90:	fc045783          	lhu	a5,-64(s0)
    80003c94:	dfe1                	beqz	a5,80003c6c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003c96:	fc240593          	add	a1,s0,-62
    80003c9a:	854e                	mv	a0,s3
    80003c9c:	00000097          	auipc	ra,0x0
    80003ca0:	f6c080e7          	jalr	-148(ra) # 80003c08 <namecmp>
    80003ca4:	f561                	bnez	a0,80003c6c <dirlookup+0x4a>
      if(poff)
    80003ca6:	000a0463          	beqz	s4,80003cae <dirlookup+0x8c>
        *poff = off;
    80003caa:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003cae:	fc045583          	lhu	a1,-64(s0)
    80003cb2:	00092503          	lw	a0,0(s2)
    80003cb6:	fffff097          	auipc	ra,0xfffff
    80003cba:	6b0080e7          	jalr	1712(ra) # 80003366 <iget>
    80003cbe:	a011                	j	80003cc2 <dirlookup+0xa0>
  return 0;
    80003cc0:	4501                	li	a0,0
}
    80003cc2:	70e2                	ld	ra,56(sp)
    80003cc4:	7442                	ld	s0,48(sp)
    80003cc6:	74a2                	ld	s1,40(sp)
    80003cc8:	7902                	ld	s2,32(sp)
    80003cca:	69e2                	ld	s3,24(sp)
    80003ccc:	6a42                	ld	s4,16(sp)
    80003cce:	6121                	add	sp,sp,64
    80003cd0:	8082                	ret

0000000080003cd2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003cd2:	711d                	add	sp,sp,-96
    80003cd4:	ec86                	sd	ra,88(sp)
    80003cd6:	e8a2                	sd	s0,80(sp)
    80003cd8:	e4a6                	sd	s1,72(sp)
    80003cda:	e0ca                	sd	s2,64(sp)
    80003cdc:	fc4e                	sd	s3,56(sp)
    80003cde:	f852                	sd	s4,48(sp)
    80003ce0:	f456                	sd	s5,40(sp)
    80003ce2:	f05a                	sd	s6,32(sp)
    80003ce4:	ec5e                	sd	s7,24(sp)
    80003ce6:	e862                	sd	s8,16(sp)
    80003ce8:	e466                	sd	s9,8(sp)
    80003cea:	1080                	add	s0,sp,96
    80003cec:	84aa                	mv	s1,a0
    80003cee:	8b2e                	mv	s6,a1
    80003cf0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003cf2:	00054703          	lbu	a4,0(a0)
    80003cf6:	02f00793          	li	a5,47
    80003cfa:	02f70263          	beq	a4,a5,80003d1e <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003cfe:	ffffe097          	auipc	ra,0xffffe
    80003d02:	ca6080e7          	jalr	-858(ra) # 800019a4 <myproc>
    80003d06:	15053503          	ld	a0,336(a0)
    80003d0a:	00000097          	auipc	ra,0x0
    80003d0e:	94e080e7          	jalr	-1714(ra) # 80003658 <idup>
    80003d12:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003d14:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003d18:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003d1a:	4b85                	li	s7,1
    80003d1c:	a875                	j	80003dd8 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003d1e:	4585                	li	a1,1
    80003d20:	4505                	li	a0,1
    80003d22:	fffff097          	auipc	ra,0xfffff
    80003d26:	644080e7          	jalr	1604(ra) # 80003366 <iget>
    80003d2a:	8a2a                	mv	s4,a0
    80003d2c:	b7e5                	j	80003d14 <namex+0x42>
      iunlockput(ip);
    80003d2e:	8552                	mv	a0,s4
    80003d30:	00000097          	auipc	ra,0x0
    80003d34:	c6e080e7          	jalr	-914(ra) # 8000399e <iunlockput>
      return 0;
    80003d38:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003d3a:	8552                	mv	a0,s4
    80003d3c:	60e6                	ld	ra,88(sp)
    80003d3e:	6446                	ld	s0,80(sp)
    80003d40:	64a6                	ld	s1,72(sp)
    80003d42:	6906                	ld	s2,64(sp)
    80003d44:	79e2                	ld	s3,56(sp)
    80003d46:	7a42                	ld	s4,48(sp)
    80003d48:	7aa2                	ld	s5,40(sp)
    80003d4a:	7b02                	ld	s6,32(sp)
    80003d4c:	6be2                	ld	s7,24(sp)
    80003d4e:	6c42                	ld	s8,16(sp)
    80003d50:	6ca2                	ld	s9,8(sp)
    80003d52:	6125                	add	sp,sp,96
    80003d54:	8082                	ret
      iunlock(ip);
    80003d56:	8552                	mv	a0,s4
    80003d58:	00000097          	auipc	ra,0x0
    80003d5c:	a00080e7          	jalr	-1536(ra) # 80003758 <iunlock>
      return ip;
    80003d60:	bfe9                	j	80003d3a <namex+0x68>
      iunlockput(ip);
    80003d62:	8552                	mv	a0,s4
    80003d64:	00000097          	auipc	ra,0x0
    80003d68:	c3a080e7          	jalr	-966(ra) # 8000399e <iunlockput>
      return 0;
    80003d6c:	8a4e                	mv	s4,s3
    80003d6e:	b7f1                	j	80003d3a <namex+0x68>
  len = path - s;
    80003d70:	40998633          	sub	a2,s3,s1
    80003d74:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003d78:	099c5863          	bge	s8,s9,80003e08 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003d7c:	4639                	li	a2,14
    80003d7e:	85a6                	mv	a1,s1
    80003d80:	8556                	mv	a0,s5
    80003d82:	ffffd097          	auipc	ra,0xffffd
    80003d86:	f94080e7          	jalr	-108(ra) # 80000d16 <memmove>
    80003d8a:	84ce                	mv	s1,s3
  while(*path == '/')
    80003d8c:	0004c783          	lbu	a5,0(s1)
    80003d90:	01279763          	bne	a5,s2,80003d9e <namex+0xcc>
    path++;
    80003d94:	0485                	add	s1,s1,1
  while(*path == '/')
    80003d96:	0004c783          	lbu	a5,0(s1)
    80003d9a:	ff278de3          	beq	a5,s2,80003d94 <namex+0xc2>
    ilock(ip);
    80003d9e:	8552                	mv	a0,s4
    80003da0:	00000097          	auipc	ra,0x0
    80003da4:	8f6080e7          	jalr	-1802(ra) # 80003696 <ilock>
    if(ip->type != T_DIR){
    80003da8:	044a1783          	lh	a5,68(s4)
    80003dac:	f97791e3          	bne	a5,s7,80003d2e <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003db0:	000b0563          	beqz	s6,80003dba <namex+0xe8>
    80003db4:	0004c783          	lbu	a5,0(s1)
    80003db8:	dfd9                	beqz	a5,80003d56 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003dba:	4601                	li	a2,0
    80003dbc:	85d6                	mv	a1,s5
    80003dbe:	8552                	mv	a0,s4
    80003dc0:	00000097          	auipc	ra,0x0
    80003dc4:	e62080e7          	jalr	-414(ra) # 80003c22 <dirlookup>
    80003dc8:	89aa                	mv	s3,a0
    80003dca:	dd41                	beqz	a0,80003d62 <namex+0x90>
    iunlockput(ip);
    80003dcc:	8552                	mv	a0,s4
    80003dce:	00000097          	auipc	ra,0x0
    80003dd2:	bd0080e7          	jalr	-1072(ra) # 8000399e <iunlockput>
    ip = next;
    80003dd6:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003dd8:	0004c783          	lbu	a5,0(s1)
    80003ddc:	01279763          	bne	a5,s2,80003dea <namex+0x118>
    path++;
    80003de0:	0485                	add	s1,s1,1
  while(*path == '/')
    80003de2:	0004c783          	lbu	a5,0(s1)
    80003de6:	ff278de3          	beq	a5,s2,80003de0 <namex+0x10e>
  if(*path == 0)
    80003dea:	cb9d                	beqz	a5,80003e20 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003dec:	0004c783          	lbu	a5,0(s1)
    80003df0:	89a6                	mv	s3,s1
  len = path - s;
    80003df2:	4c81                	li	s9,0
    80003df4:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003df6:	01278963          	beq	a5,s2,80003e08 <namex+0x136>
    80003dfa:	dbbd                	beqz	a5,80003d70 <namex+0x9e>
    path++;
    80003dfc:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80003dfe:	0009c783          	lbu	a5,0(s3)
    80003e02:	ff279ce3          	bne	a5,s2,80003dfa <namex+0x128>
    80003e06:	b7ad                	j	80003d70 <namex+0x9e>
    memmove(name, s, len);
    80003e08:	2601                	sext.w	a2,a2
    80003e0a:	85a6                	mv	a1,s1
    80003e0c:	8556                	mv	a0,s5
    80003e0e:	ffffd097          	auipc	ra,0xffffd
    80003e12:	f08080e7          	jalr	-248(ra) # 80000d16 <memmove>
    name[len] = 0;
    80003e16:	9cd6                	add	s9,s9,s5
    80003e18:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003e1c:	84ce                	mv	s1,s3
    80003e1e:	b7bd                	j	80003d8c <namex+0xba>
  if(nameiparent){
    80003e20:	f00b0de3          	beqz	s6,80003d3a <namex+0x68>
    iput(ip);
    80003e24:	8552                	mv	a0,s4
    80003e26:	00000097          	auipc	ra,0x0
    80003e2a:	ad0080e7          	jalr	-1328(ra) # 800038f6 <iput>
    return 0;
    80003e2e:	4a01                	li	s4,0
    80003e30:	b729                	j	80003d3a <namex+0x68>

0000000080003e32 <dirlink>:
{
    80003e32:	7139                	add	sp,sp,-64
    80003e34:	fc06                	sd	ra,56(sp)
    80003e36:	f822                	sd	s0,48(sp)
    80003e38:	f426                	sd	s1,40(sp)
    80003e3a:	f04a                	sd	s2,32(sp)
    80003e3c:	ec4e                	sd	s3,24(sp)
    80003e3e:	e852                	sd	s4,16(sp)
    80003e40:	0080                	add	s0,sp,64
    80003e42:	892a                	mv	s2,a0
    80003e44:	8a2e                	mv	s4,a1
    80003e46:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e48:	4601                	li	a2,0
    80003e4a:	00000097          	auipc	ra,0x0
    80003e4e:	dd8080e7          	jalr	-552(ra) # 80003c22 <dirlookup>
    80003e52:	e93d                	bnez	a0,80003ec8 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e54:	04c92483          	lw	s1,76(s2)
    80003e58:	c49d                	beqz	s1,80003e86 <dirlink+0x54>
    80003e5a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e5c:	4741                	li	a4,16
    80003e5e:	86a6                	mv	a3,s1
    80003e60:	fc040613          	add	a2,s0,-64
    80003e64:	4581                	li	a1,0
    80003e66:	854a                	mv	a0,s2
    80003e68:	00000097          	auipc	ra,0x0
    80003e6c:	b88080e7          	jalr	-1144(ra) # 800039f0 <readi>
    80003e70:	47c1                	li	a5,16
    80003e72:	06f51163          	bne	a0,a5,80003ed4 <dirlink+0xa2>
    if(de.inum == 0)
    80003e76:	fc045783          	lhu	a5,-64(s0)
    80003e7a:	c791                	beqz	a5,80003e86 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e7c:	24c1                	addw	s1,s1,16
    80003e7e:	04c92783          	lw	a5,76(s2)
    80003e82:	fcf4ede3          	bltu	s1,a5,80003e5c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003e86:	4639                	li	a2,14
    80003e88:	85d2                	mv	a1,s4
    80003e8a:	fc240513          	add	a0,s0,-62
    80003e8e:	ffffd097          	auipc	ra,0xffffd
    80003e92:	f40080e7          	jalr	-192(ra) # 80000dce <strncpy>
  de.inum = inum;
    80003e96:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e9a:	4741                	li	a4,16
    80003e9c:	86a6                	mv	a3,s1
    80003e9e:	fc040613          	add	a2,s0,-64
    80003ea2:	4581                	li	a1,0
    80003ea4:	854a                	mv	a0,s2
    80003ea6:	00000097          	auipc	ra,0x0
    80003eaa:	c42080e7          	jalr	-958(ra) # 80003ae8 <writei>
    80003eae:	872a                	mv	a4,a0
    80003eb0:	47c1                	li	a5,16
  return 0;
    80003eb2:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003eb4:	02f71863          	bne	a4,a5,80003ee4 <dirlink+0xb2>
}
    80003eb8:	70e2                	ld	ra,56(sp)
    80003eba:	7442                	ld	s0,48(sp)
    80003ebc:	74a2                	ld	s1,40(sp)
    80003ebe:	7902                	ld	s2,32(sp)
    80003ec0:	69e2                	ld	s3,24(sp)
    80003ec2:	6a42                	ld	s4,16(sp)
    80003ec4:	6121                	add	sp,sp,64
    80003ec6:	8082                	ret
    iput(ip);
    80003ec8:	00000097          	auipc	ra,0x0
    80003ecc:	a2e080e7          	jalr	-1490(ra) # 800038f6 <iput>
    return -1;
    80003ed0:	557d                	li	a0,-1
    80003ed2:	b7dd                	j	80003eb8 <dirlink+0x86>
      panic("dirlink read");
    80003ed4:	00004517          	auipc	a0,0x4
    80003ed8:	71c50513          	add	a0,a0,1820 # 800085f0 <syscalls+0x1d0>
    80003edc:	ffffc097          	auipc	ra,0xffffc
    80003ee0:	64c080e7          	jalr	1612(ra) # 80000528 <panic>
    panic("dirlink");
    80003ee4:	00005517          	auipc	a0,0x5
    80003ee8:	81c50513          	add	a0,a0,-2020 # 80008700 <syscalls+0x2e0>
    80003eec:	ffffc097          	auipc	ra,0xffffc
    80003ef0:	63c080e7          	jalr	1596(ra) # 80000528 <panic>

0000000080003ef4 <namei>:

struct inode*
namei(char *path)
{
    80003ef4:	1101                	add	sp,sp,-32
    80003ef6:	ec06                	sd	ra,24(sp)
    80003ef8:	e822                	sd	s0,16(sp)
    80003efa:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003efc:	fe040613          	add	a2,s0,-32
    80003f00:	4581                	li	a1,0
    80003f02:	00000097          	auipc	ra,0x0
    80003f06:	dd0080e7          	jalr	-560(ra) # 80003cd2 <namex>
}
    80003f0a:	60e2                	ld	ra,24(sp)
    80003f0c:	6442                	ld	s0,16(sp)
    80003f0e:	6105                	add	sp,sp,32
    80003f10:	8082                	ret

0000000080003f12 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003f12:	1141                	add	sp,sp,-16
    80003f14:	e406                	sd	ra,8(sp)
    80003f16:	e022                	sd	s0,0(sp)
    80003f18:	0800                	add	s0,sp,16
    80003f1a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003f1c:	4585                	li	a1,1
    80003f1e:	00000097          	auipc	ra,0x0
    80003f22:	db4080e7          	jalr	-588(ra) # 80003cd2 <namex>
}
    80003f26:	60a2                	ld	ra,8(sp)
    80003f28:	6402                	ld	s0,0(sp)
    80003f2a:	0141                	add	sp,sp,16
    80003f2c:	8082                	ret

0000000080003f2e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003f2e:	1101                	add	sp,sp,-32
    80003f30:	ec06                	sd	ra,24(sp)
    80003f32:	e822                	sd	s0,16(sp)
    80003f34:	e426                	sd	s1,8(sp)
    80003f36:	e04a                	sd	s2,0(sp)
    80003f38:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003f3a:	00018917          	auipc	s2,0x18
    80003f3e:	72e90913          	add	s2,s2,1838 # 8001c668 <log>
    80003f42:	01892583          	lw	a1,24(s2)
    80003f46:	02892503          	lw	a0,40(s2)
    80003f4a:	fffff097          	auipc	ra,0xfffff
    80003f4e:	e8c080e7          	jalr	-372(ra) # 80002dd6 <bread>
    80003f52:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003f54:	02c92603          	lw	a2,44(s2)
    80003f58:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003f5a:	00c05f63          	blez	a2,80003f78 <write_head+0x4a>
    80003f5e:	00018717          	auipc	a4,0x18
    80003f62:	73a70713          	add	a4,a4,1850 # 8001c698 <log+0x30>
    80003f66:	87aa                	mv	a5,a0
    80003f68:	060a                	sll	a2,a2,0x2
    80003f6a:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003f6c:	4314                	lw	a3,0(a4)
    80003f6e:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003f70:	0711                	add	a4,a4,4
    80003f72:	0791                	add	a5,a5,4
    80003f74:	fec79ce3          	bne	a5,a2,80003f6c <write_head+0x3e>
  }
  bwrite(buf);
    80003f78:	8526                	mv	a0,s1
    80003f7a:	fffff097          	auipc	ra,0xfffff
    80003f7e:	f4e080e7          	jalr	-178(ra) # 80002ec8 <bwrite>
  brelse(buf);
    80003f82:	8526                	mv	a0,s1
    80003f84:	fffff097          	auipc	ra,0xfffff
    80003f88:	f82080e7          	jalr	-126(ra) # 80002f06 <brelse>
}
    80003f8c:	60e2                	ld	ra,24(sp)
    80003f8e:	6442                	ld	s0,16(sp)
    80003f90:	64a2                	ld	s1,8(sp)
    80003f92:	6902                	ld	s2,0(sp)
    80003f94:	6105                	add	sp,sp,32
    80003f96:	8082                	ret

0000000080003f98 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f98:	00018797          	auipc	a5,0x18
    80003f9c:	6fc7a783          	lw	a5,1788(a5) # 8001c694 <log+0x2c>
    80003fa0:	0af05d63          	blez	a5,8000405a <install_trans+0xc2>
{
    80003fa4:	7139                	add	sp,sp,-64
    80003fa6:	fc06                	sd	ra,56(sp)
    80003fa8:	f822                	sd	s0,48(sp)
    80003faa:	f426                	sd	s1,40(sp)
    80003fac:	f04a                	sd	s2,32(sp)
    80003fae:	ec4e                	sd	s3,24(sp)
    80003fb0:	e852                	sd	s4,16(sp)
    80003fb2:	e456                	sd	s5,8(sp)
    80003fb4:	e05a                	sd	s6,0(sp)
    80003fb6:	0080                	add	s0,sp,64
    80003fb8:	8b2a                	mv	s6,a0
    80003fba:	00018a97          	auipc	s5,0x18
    80003fbe:	6dea8a93          	add	s5,s5,1758 # 8001c698 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fc2:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003fc4:	00018997          	auipc	s3,0x18
    80003fc8:	6a498993          	add	s3,s3,1700 # 8001c668 <log>
    80003fcc:	a00d                	j	80003fee <install_trans+0x56>
    brelse(lbuf);
    80003fce:	854a                	mv	a0,s2
    80003fd0:	fffff097          	auipc	ra,0xfffff
    80003fd4:	f36080e7          	jalr	-202(ra) # 80002f06 <brelse>
    brelse(dbuf);
    80003fd8:	8526                	mv	a0,s1
    80003fda:	fffff097          	auipc	ra,0xfffff
    80003fde:	f2c080e7          	jalr	-212(ra) # 80002f06 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fe2:	2a05                	addw	s4,s4,1
    80003fe4:	0a91                	add	s5,s5,4
    80003fe6:	02c9a783          	lw	a5,44(s3)
    80003fea:	04fa5e63          	bge	s4,a5,80004046 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003fee:	0189a583          	lw	a1,24(s3)
    80003ff2:	014585bb          	addw	a1,a1,s4
    80003ff6:	2585                	addw	a1,a1,1
    80003ff8:	0289a503          	lw	a0,40(s3)
    80003ffc:	fffff097          	auipc	ra,0xfffff
    80004000:	dda080e7          	jalr	-550(ra) # 80002dd6 <bread>
    80004004:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004006:	000aa583          	lw	a1,0(s5)
    8000400a:	0289a503          	lw	a0,40(s3)
    8000400e:	fffff097          	auipc	ra,0xfffff
    80004012:	dc8080e7          	jalr	-568(ra) # 80002dd6 <bread>
    80004016:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004018:	40000613          	li	a2,1024
    8000401c:	05890593          	add	a1,s2,88
    80004020:	05850513          	add	a0,a0,88
    80004024:	ffffd097          	auipc	ra,0xffffd
    80004028:	cf2080e7          	jalr	-782(ra) # 80000d16 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000402c:	8526                	mv	a0,s1
    8000402e:	fffff097          	auipc	ra,0xfffff
    80004032:	e9a080e7          	jalr	-358(ra) # 80002ec8 <bwrite>
    if(recovering == 0)
    80004036:	f80b1ce3          	bnez	s6,80003fce <install_trans+0x36>
      bunpin(dbuf);
    8000403a:	8526                	mv	a0,s1
    8000403c:	fffff097          	auipc	ra,0xfffff
    80004040:	fa2080e7          	jalr	-94(ra) # 80002fde <bunpin>
    80004044:	b769                	j	80003fce <install_trans+0x36>
}
    80004046:	70e2                	ld	ra,56(sp)
    80004048:	7442                	ld	s0,48(sp)
    8000404a:	74a2                	ld	s1,40(sp)
    8000404c:	7902                	ld	s2,32(sp)
    8000404e:	69e2                	ld	s3,24(sp)
    80004050:	6a42                	ld	s4,16(sp)
    80004052:	6aa2                	ld	s5,8(sp)
    80004054:	6b02                	ld	s6,0(sp)
    80004056:	6121                	add	sp,sp,64
    80004058:	8082                	ret
    8000405a:	8082                	ret

000000008000405c <initlog>:
{
    8000405c:	7179                	add	sp,sp,-48
    8000405e:	f406                	sd	ra,40(sp)
    80004060:	f022                	sd	s0,32(sp)
    80004062:	ec26                	sd	s1,24(sp)
    80004064:	e84a                	sd	s2,16(sp)
    80004066:	e44e                	sd	s3,8(sp)
    80004068:	1800                	add	s0,sp,48
    8000406a:	892a                	mv	s2,a0
    8000406c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000406e:	00018497          	auipc	s1,0x18
    80004072:	5fa48493          	add	s1,s1,1530 # 8001c668 <log>
    80004076:	00004597          	auipc	a1,0x4
    8000407a:	58a58593          	add	a1,a1,1418 # 80008600 <syscalls+0x1e0>
    8000407e:	8526                	mv	a0,s1
    80004080:	ffffd097          	auipc	ra,0xffffd
    80004084:	aae080e7          	jalr	-1362(ra) # 80000b2e <initlock>
  log.start = sb->logstart;
    80004088:	0149a583          	lw	a1,20(s3)
    8000408c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000408e:	0109a783          	lw	a5,16(s3)
    80004092:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004094:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004098:	854a                	mv	a0,s2
    8000409a:	fffff097          	auipc	ra,0xfffff
    8000409e:	d3c080e7          	jalr	-708(ra) # 80002dd6 <bread>
  log.lh.n = lh->n;
    800040a2:	4d30                	lw	a2,88(a0)
    800040a4:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800040a6:	00c05f63          	blez	a2,800040c4 <initlog+0x68>
    800040aa:	87aa                	mv	a5,a0
    800040ac:	00018717          	auipc	a4,0x18
    800040b0:	5ec70713          	add	a4,a4,1516 # 8001c698 <log+0x30>
    800040b4:	060a                	sll	a2,a2,0x2
    800040b6:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800040b8:	4ff4                	lw	a3,92(a5)
    800040ba:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800040bc:	0791                	add	a5,a5,4
    800040be:	0711                	add	a4,a4,4
    800040c0:	fec79ce3          	bne	a5,a2,800040b8 <initlog+0x5c>
  brelse(buf);
    800040c4:	fffff097          	auipc	ra,0xfffff
    800040c8:	e42080e7          	jalr	-446(ra) # 80002f06 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800040cc:	4505                	li	a0,1
    800040ce:	00000097          	auipc	ra,0x0
    800040d2:	eca080e7          	jalr	-310(ra) # 80003f98 <install_trans>
  log.lh.n = 0;
    800040d6:	00018797          	auipc	a5,0x18
    800040da:	5a07af23          	sw	zero,1470(a5) # 8001c694 <log+0x2c>
  write_head(); // clear the log
    800040de:	00000097          	auipc	ra,0x0
    800040e2:	e50080e7          	jalr	-432(ra) # 80003f2e <write_head>
}
    800040e6:	70a2                	ld	ra,40(sp)
    800040e8:	7402                	ld	s0,32(sp)
    800040ea:	64e2                	ld	s1,24(sp)
    800040ec:	6942                	ld	s2,16(sp)
    800040ee:	69a2                	ld	s3,8(sp)
    800040f0:	6145                	add	sp,sp,48
    800040f2:	8082                	ret

00000000800040f4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800040f4:	1101                	add	sp,sp,-32
    800040f6:	ec06                	sd	ra,24(sp)
    800040f8:	e822                	sd	s0,16(sp)
    800040fa:	e426                	sd	s1,8(sp)
    800040fc:	e04a                	sd	s2,0(sp)
    800040fe:	1000                	add	s0,sp,32
  acquire(&log.lock);
    80004100:	00018517          	auipc	a0,0x18
    80004104:	56850513          	add	a0,a0,1384 # 8001c668 <log>
    80004108:	ffffd097          	auipc	ra,0xffffd
    8000410c:	ab6080e7          	jalr	-1354(ra) # 80000bbe <acquire>
  while(1){
    if(log.committing){
    80004110:	00018497          	auipc	s1,0x18
    80004114:	55848493          	add	s1,s1,1368 # 8001c668 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004118:	4979                	li	s2,30
    8000411a:	a039                	j	80004128 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000411c:	85a6                	mv	a1,s1
    8000411e:	8526                	mv	a0,s1
    80004120:	ffffe097          	auipc	ra,0xffffe
    80004124:	09a080e7          	jalr	154(ra) # 800021ba <sleep>
    if(log.committing){
    80004128:	50dc                	lw	a5,36(s1)
    8000412a:	fbed                	bnez	a5,8000411c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000412c:	5098                	lw	a4,32(s1)
    8000412e:	2705                	addw	a4,a4,1
    80004130:	0027179b          	sllw	a5,a4,0x2
    80004134:	9fb9                	addw	a5,a5,a4
    80004136:	0017979b          	sllw	a5,a5,0x1
    8000413a:	54d4                	lw	a3,44(s1)
    8000413c:	9fb5                	addw	a5,a5,a3
    8000413e:	00f95963          	bge	s2,a5,80004150 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004142:	85a6                	mv	a1,s1
    80004144:	8526                	mv	a0,s1
    80004146:	ffffe097          	auipc	ra,0xffffe
    8000414a:	074080e7          	jalr	116(ra) # 800021ba <sleep>
    8000414e:	bfe9                	j	80004128 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004150:	00018517          	auipc	a0,0x18
    80004154:	51850513          	add	a0,a0,1304 # 8001c668 <log>
    80004158:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000415a:	ffffd097          	auipc	ra,0xffffd
    8000415e:	b18080e7          	jalr	-1256(ra) # 80000c72 <release>
      break;
    }
  }
}
    80004162:	60e2                	ld	ra,24(sp)
    80004164:	6442                	ld	s0,16(sp)
    80004166:	64a2                	ld	s1,8(sp)
    80004168:	6902                	ld	s2,0(sp)
    8000416a:	6105                	add	sp,sp,32
    8000416c:	8082                	ret

000000008000416e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000416e:	7139                	add	sp,sp,-64
    80004170:	fc06                	sd	ra,56(sp)
    80004172:	f822                	sd	s0,48(sp)
    80004174:	f426                	sd	s1,40(sp)
    80004176:	f04a                	sd	s2,32(sp)
    80004178:	ec4e                	sd	s3,24(sp)
    8000417a:	e852                	sd	s4,16(sp)
    8000417c:	e456                	sd	s5,8(sp)
    8000417e:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004180:	00018497          	auipc	s1,0x18
    80004184:	4e848493          	add	s1,s1,1256 # 8001c668 <log>
    80004188:	8526                	mv	a0,s1
    8000418a:	ffffd097          	auipc	ra,0xffffd
    8000418e:	a34080e7          	jalr	-1484(ra) # 80000bbe <acquire>
  log.outstanding -= 1;
    80004192:	509c                	lw	a5,32(s1)
    80004194:	37fd                	addw	a5,a5,-1
    80004196:	0007891b          	sext.w	s2,a5
    8000419a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000419c:	50dc                	lw	a5,36(s1)
    8000419e:	e7b9                	bnez	a5,800041ec <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800041a0:	04091e63          	bnez	s2,800041fc <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800041a4:	00018497          	auipc	s1,0x18
    800041a8:	4c448493          	add	s1,s1,1220 # 8001c668 <log>
    800041ac:	4785                	li	a5,1
    800041ae:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800041b0:	8526                	mv	a0,s1
    800041b2:	ffffd097          	auipc	ra,0xffffd
    800041b6:	ac0080e7          	jalr	-1344(ra) # 80000c72 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800041ba:	54dc                	lw	a5,44(s1)
    800041bc:	06f04763          	bgtz	a5,8000422a <end_op+0xbc>
    acquire(&log.lock);
    800041c0:	00018497          	auipc	s1,0x18
    800041c4:	4a848493          	add	s1,s1,1192 # 8001c668 <log>
    800041c8:	8526                	mv	a0,s1
    800041ca:	ffffd097          	auipc	ra,0xffffd
    800041ce:	9f4080e7          	jalr	-1548(ra) # 80000bbe <acquire>
    log.committing = 0;
    800041d2:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800041d6:	8526                	mv	a0,s1
    800041d8:	ffffe097          	auipc	ra,0xffffe
    800041dc:	162080e7          	jalr	354(ra) # 8000233a <wakeup>
    release(&log.lock);
    800041e0:	8526                	mv	a0,s1
    800041e2:	ffffd097          	auipc	ra,0xffffd
    800041e6:	a90080e7          	jalr	-1392(ra) # 80000c72 <release>
}
    800041ea:	a03d                	j	80004218 <end_op+0xaa>
    panic("log.committing");
    800041ec:	00004517          	auipc	a0,0x4
    800041f0:	41c50513          	add	a0,a0,1052 # 80008608 <syscalls+0x1e8>
    800041f4:	ffffc097          	auipc	ra,0xffffc
    800041f8:	334080e7          	jalr	820(ra) # 80000528 <panic>
    wakeup(&log);
    800041fc:	00018497          	auipc	s1,0x18
    80004200:	46c48493          	add	s1,s1,1132 # 8001c668 <log>
    80004204:	8526                	mv	a0,s1
    80004206:	ffffe097          	auipc	ra,0xffffe
    8000420a:	134080e7          	jalr	308(ra) # 8000233a <wakeup>
  release(&log.lock);
    8000420e:	8526                	mv	a0,s1
    80004210:	ffffd097          	auipc	ra,0xffffd
    80004214:	a62080e7          	jalr	-1438(ra) # 80000c72 <release>
}
    80004218:	70e2                	ld	ra,56(sp)
    8000421a:	7442                	ld	s0,48(sp)
    8000421c:	74a2                	ld	s1,40(sp)
    8000421e:	7902                	ld	s2,32(sp)
    80004220:	69e2                	ld	s3,24(sp)
    80004222:	6a42                	ld	s4,16(sp)
    80004224:	6aa2                	ld	s5,8(sp)
    80004226:	6121                	add	sp,sp,64
    80004228:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000422a:	00018a97          	auipc	s5,0x18
    8000422e:	46ea8a93          	add	s5,s5,1134 # 8001c698 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004232:	00018a17          	auipc	s4,0x18
    80004236:	436a0a13          	add	s4,s4,1078 # 8001c668 <log>
    8000423a:	018a2583          	lw	a1,24(s4)
    8000423e:	012585bb          	addw	a1,a1,s2
    80004242:	2585                	addw	a1,a1,1
    80004244:	028a2503          	lw	a0,40(s4)
    80004248:	fffff097          	auipc	ra,0xfffff
    8000424c:	b8e080e7          	jalr	-1138(ra) # 80002dd6 <bread>
    80004250:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004252:	000aa583          	lw	a1,0(s5)
    80004256:	028a2503          	lw	a0,40(s4)
    8000425a:	fffff097          	auipc	ra,0xfffff
    8000425e:	b7c080e7          	jalr	-1156(ra) # 80002dd6 <bread>
    80004262:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004264:	40000613          	li	a2,1024
    80004268:	05850593          	add	a1,a0,88
    8000426c:	05848513          	add	a0,s1,88
    80004270:	ffffd097          	auipc	ra,0xffffd
    80004274:	aa6080e7          	jalr	-1370(ra) # 80000d16 <memmove>
    bwrite(to);  // write the log
    80004278:	8526                	mv	a0,s1
    8000427a:	fffff097          	auipc	ra,0xfffff
    8000427e:	c4e080e7          	jalr	-946(ra) # 80002ec8 <bwrite>
    brelse(from);
    80004282:	854e                	mv	a0,s3
    80004284:	fffff097          	auipc	ra,0xfffff
    80004288:	c82080e7          	jalr	-894(ra) # 80002f06 <brelse>
    brelse(to);
    8000428c:	8526                	mv	a0,s1
    8000428e:	fffff097          	auipc	ra,0xfffff
    80004292:	c78080e7          	jalr	-904(ra) # 80002f06 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004296:	2905                	addw	s2,s2,1
    80004298:	0a91                	add	s5,s5,4
    8000429a:	02ca2783          	lw	a5,44(s4)
    8000429e:	f8f94ee3          	blt	s2,a5,8000423a <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800042a2:	00000097          	auipc	ra,0x0
    800042a6:	c8c080e7          	jalr	-884(ra) # 80003f2e <write_head>
    install_trans(0); // Now install writes to home locations
    800042aa:	4501                	li	a0,0
    800042ac:	00000097          	auipc	ra,0x0
    800042b0:	cec080e7          	jalr	-788(ra) # 80003f98 <install_trans>
    log.lh.n = 0;
    800042b4:	00018797          	auipc	a5,0x18
    800042b8:	3e07a023          	sw	zero,992(a5) # 8001c694 <log+0x2c>
    write_head();    // Erase the transaction from the log
    800042bc:	00000097          	auipc	ra,0x0
    800042c0:	c72080e7          	jalr	-910(ra) # 80003f2e <write_head>
    800042c4:	bdf5                	j	800041c0 <end_op+0x52>

00000000800042c6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800042c6:	1101                	add	sp,sp,-32
    800042c8:	ec06                	sd	ra,24(sp)
    800042ca:	e822                	sd	s0,16(sp)
    800042cc:	e426                	sd	s1,8(sp)
    800042ce:	e04a                	sd	s2,0(sp)
    800042d0:	1000                	add	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800042d2:	00018717          	auipc	a4,0x18
    800042d6:	3c272703          	lw	a4,962(a4) # 8001c694 <log+0x2c>
    800042da:	47f5                	li	a5,29
    800042dc:	08e7c063          	blt	a5,a4,8000435c <log_write+0x96>
    800042e0:	84aa                	mv	s1,a0
    800042e2:	00018797          	auipc	a5,0x18
    800042e6:	3a27a783          	lw	a5,930(a5) # 8001c684 <log+0x1c>
    800042ea:	37fd                	addw	a5,a5,-1
    800042ec:	06f75863          	bge	a4,a5,8000435c <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800042f0:	00018797          	auipc	a5,0x18
    800042f4:	3987a783          	lw	a5,920(a5) # 8001c688 <log+0x20>
    800042f8:	06f05a63          	blez	a5,8000436c <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    800042fc:	00018917          	auipc	s2,0x18
    80004300:	36c90913          	add	s2,s2,876 # 8001c668 <log>
    80004304:	854a                	mv	a0,s2
    80004306:	ffffd097          	auipc	ra,0xffffd
    8000430a:	8b8080e7          	jalr	-1864(ra) # 80000bbe <acquire>
  for (i = 0; i < log.lh.n; i++) {
    8000430e:	02c92603          	lw	a2,44(s2)
    80004312:	06c05563          	blez	a2,8000437c <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004316:	44cc                	lw	a1,12(s1)
    80004318:	00018717          	auipc	a4,0x18
    8000431c:	38070713          	add	a4,a4,896 # 8001c698 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004320:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004322:	4314                	lw	a3,0(a4)
    80004324:	04b68d63          	beq	a3,a1,8000437e <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    80004328:	2785                	addw	a5,a5,1
    8000432a:	0711                	add	a4,a4,4
    8000432c:	fec79be3          	bne	a5,a2,80004322 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004330:	0621                	add	a2,a2,8
    80004332:	060a                	sll	a2,a2,0x2
    80004334:	00018797          	auipc	a5,0x18
    80004338:	33478793          	add	a5,a5,820 # 8001c668 <log>
    8000433c:	97b2                	add	a5,a5,a2
    8000433e:	44d8                	lw	a4,12(s1)
    80004340:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004342:	8526                	mv	a0,s1
    80004344:	fffff097          	auipc	ra,0xfffff
    80004348:	c5e080e7          	jalr	-930(ra) # 80002fa2 <bpin>
    log.lh.n++;
    8000434c:	00018717          	auipc	a4,0x18
    80004350:	31c70713          	add	a4,a4,796 # 8001c668 <log>
    80004354:	575c                	lw	a5,44(a4)
    80004356:	2785                	addw	a5,a5,1
    80004358:	d75c                	sw	a5,44(a4)
    8000435a:	a835                	j	80004396 <log_write+0xd0>
    panic("too big a transaction");
    8000435c:	00004517          	auipc	a0,0x4
    80004360:	2bc50513          	add	a0,a0,700 # 80008618 <syscalls+0x1f8>
    80004364:	ffffc097          	auipc	ra,0xffffc
    80004368:	1c4080e7          	jalr	452(ra) # 80000528 <panic>
    panic("log_write outside of trans");
    8000436c:	00004517          	auipc	a0,0x4
    80004370:	2c450513          	add	a0,a0,708 # 80008630 <syscalls+0x210>
    80004374:	ffffc097          	auipc	ra,0xffffc
    80004378:	1b4080e7          	jalr	436(ra) # 80000528 <panic>
  for (i = 0; i < log.lh.n; i++) {
    8000437c:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    8000437e:	00878693          	add	a3,a5,8
    80004382:	068a                	sll	a3,a3,0x2
    80004384:	00018717          	auipc	a4,0x18
    80004388:	2e470713          	add	a4,a4,740 # 8001c668 <log>
    8000438c:	9736                	add	a4,a4,a3
    8000438e:	44d4                	lw	a3,12(s1)
    80004390:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004392:	faf608e3          	beq	a2,a5,80004342 <log_write+0x7c>
  }
  release(&log.lock);
    80004396:	00018517          	auipc	a0,0x18
    8000439a:	2d250513          	add	a0,a0,722 # 8001c668 <log>
    8000439e:	ffffd097          	auipc	ra,0xffffd
    800043a2:	8d4080e7          	jalr	-1836(ra) # 80000c72 <release>
}
    800043a6:	60e2                	ld	ra,24(sp)
    800043a8:	6442                	ld	s0,16(sp)
    800043aa:	64a2                	ld	s1,8(sp)
    800043ac:	6902                	ld	s2,0(sp)
    800043ae:	6105                	add	sp,sp,32
    800043b0:	8082                	ret

00000000800043b2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800043b2:	1101                	add	sp,sp,-32
    800043b4:	ec06                	sd	ra,24(sp)
    800043b6:	e822                	sd	s0,16(sp)
    800043b8:	e426                	sd	s1,8(sp)
    800043ba:	e04a                	sd	s2,0(sp)
    800043bc:	1000                	add	s0,sp,32
    800043be:	84aa                	mv	s1,a0
    800043c0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800043c2:	00004597          	auipc	a1,0x4
    800043c6:	28e58593          	add	a1,a1,654 # 80008650 <syscalls+0x230>
    800043ca:	0521                	add	a0,a0,8
    800043cc:	ffffc097          	auipc	ra,0xffffc
    800043d0:	762080e7          	jalr	1890(ra) # 80000b2e <initlock>
  lk->name = name;
    800043d4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800043d8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800043dc:	0204a423          	sw	zero,40(s1)
}
    800043e0:	60e2                	ld	ra,24(sp)
    800043e2:	6442                	ld	s0,16(sp)
    800043e4:	64a2                	ld	s1,8(sp)
    800043e6:	6902                	ld	s2,0(sp)
    800043e8:	6105                	add	sp,sp,32
    800043ea:	8082                	ret

00000000800043ec <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800043ec:	1101                	add	sp,sp,-32
    800043ee:	ec06                	sd	ra,24(sp)
    800043f0:	e822                	sd	s0,16(sp)
    800043f2:	e426                	sd	s1,8(sp)
    800043f4:	e04a                	sd	s2,0(sp)
    800043f6:	1000                	add	s0,sp,32
    800043f8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800043fa:	00850913          	add	s2,a0,8
    800043fe:	854a                	mv	a0,s2
    80004400:	ffffc097          	auipc	ra,0xffffc
    80004404:	7be080e7          	jalr	1982(ra) # 80000bbe <acquire>
  while (lk->locked) {
    80004408:	409c                	lw	a5,0(s1)
    8000440a:	cb89                	beqz	a5,8000441c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000440c:	85ca                	mv	a1,s2
    8000440e:	8526                	mv	a0,s1
    80004410:	ffffe097          	auipc	ra,0xffffe
    80004414:	daa080e7          	jalr	-598(ra) # 800021ba <sleep>
  while (lk->locked) {
    80004418:	409c                	lw	a5,0(s1)
    8000441a:	fbed                	bnez	a5,8000440c <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000441c:	4785                	li	a5,1
    8000441e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004420:	ffffd097          	auipc	ra,0xffffd
    80004424:	584080e7          	jalr	1412(ra) # 800019a4 <myproc>
    80004428:	5d1c                	lw	a5,56(a0)
    8000442a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000442c:	854a                	mv	a0,s2
    8000442e:	ffffd097          	auipc	ra,0xffffd
    80004432:	844080e7          	jalr	-1980(ra) # 80000c72 <release>
}
    80004436:	60e2                	ld	ra,24(sp)
    80004438:	6442                	ld	s0,16(sp)
    8000443a:	64a2                	ld	s1,8(sp)
    8000443c:	6902                	ld	s2,0(sp)
    8000443e:	6105                	add	sp,sp,32
    80004440:	8082                	ret

0000000080004442 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004442:	1101                	add	sp,sp,-32
    80004444:	ec06                	sd	ra,24(sp)
    80004446:	e822                	sd	s0,16(sp)
    80004448:	e426                	sd	s1,8(sp)
    8000444a:	e04a                	sd	s2,0(sp)
    8000444c:	1000                	add	s0,sp,32
    8000444e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004450:	00850913          	add	s2,a0,8
    80004454:	854a                	mv	a0,s2
    80004456:	ffffc097          	auipc	ra,0xffffc
    8000445a:	768080e7          	jalr	1896(ra) # 80000bbe <acquire>
  lk->locked = 0;
    8000445e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004462:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004466:	8526                	mv	a0,s1
    80004468:	ffffe097          	auipc	ra,0xffffe
    8000446c:	ed2080e7          	jalr	-302(ra) # 8000233a <wakeup>
  release(&lk->lk);
    80004470:	854a                	mv	a0,s2
    80004472:	ffffd097          	auipc	ra,0xffffd
    80004476:	800080e7          	jalr	-2048(ra) # 80000c72 <release>
}
    8000447a:	60e2                	ld	ra,24(sp)
    8000447c:	6442                	ld	s0,16(sp)
    8000447e:	64a2                	ld	s1,8(sp)
    80004480:	6902                	ld	s2,0(sp)
    80004482:	6105                	add	sp,sp,32
    80004484:	8082                	ret

0000000080004486 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004486:	7179                	add	sp,sp,-48
    80004488:	f406                	sd	ra,40(sp)
    8000448a:	f022                	sd	s0,32(sp)
    8000448c:	ec26                	sd	s1,24(sp)
    8000448e:	e84a                	sd	s2,16(sp)
    80004490:	e44e                	sd	s3,8(sp)
    80004492:	1800                	add	s0,sp,48
    80004494:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004496:	00850913          	add	s2,a0,8
    8000449a:	854a                	mv	a0,s2
    8000449c:	ffffc097          	auipc	ra,0xffffc
    800044a0:	722080e7          	jalr	1826(ra) # 80000bbe <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800044a4:	409c                	lw	a5,0(s1)
    800044a6:	ef99                	bnez	a5,800044c4 <holdingsleep+0x3e>
    800044a8:	4481                	li	s1,0
  release(&lk->lk);
    800044aa:	854a                	mv	a0,s2
    800044ac:	ffffc097          	auipc	ra,0xffffc
    800044b0:	7c6080e7          	jalr	1990(ra) # 80000c72 <release>
  return r;
}
    800044b4:	8526                	mv	a0,s1
    800044b6:	70a2                	ld	ra,40(sp)
    800044b8:	7402                	ld	s0,32(sp)
    800044ba:	64e2                	ld	s1,24(sp)
    800044bc:	6942                	ld	s2,16(sp)
    800044be:	69a2                	ld	s3,8(sp)
    800044c0:	6145                	add	sp,sp,48
    800044c2:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800044c4:	0284a983          	lw	s3,40(s1)
    800044c8:	ffffd097          	auipc	ra,0xffffd
    800044cc:	4dc080e7          	jalr	1244(ra) # 800019a4 <myproc>
    800044d0:	5d04                	lw	s1,56(a0)
    800044d2:	413484b3          	sub	s1,s1,s3
    800044d6:	0014b493          	seqz	s1,s1
    800044da:	bfc1                	j	800044aa <holdingsleep+0x24>

00000000800044dc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800044dc:	1141                	add	sp,sp,-16
    800044de:	e406                	sd	ra,8(sp)
    800044e0:	e022                	sd	s0,0(sp)
    800044e2:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800044e4:	00004597          	auipc	a1,0x4
    800044e8:	17c58593          	add	a1,a1,380 # 80008660 <syscalls+0x240>
    800044ec:	00018517          	auipc	a0,0x18
    800044f0:	2c450513          	add	a0,a0,708 # 8001c7b0 <ftable>
    800044f4:	ffffc097          	auipc	ra,0xffffc
    800044f8:	63a080e7          	jalr	1594(ra) # 80000b2e <initlock>
}
    800044fc:	60a2                	ld	ra,8(sp)
    800044fe:	6402                	ld	s0,0(sp)
    80004500:	0141                	add	sp,sp,16
    80004502:	8082                	ret

0000000080004504 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004504:	1101                	add	sp,sp,-32
    80004506:	ec06                	sd	ra,24(sp)
    80004508:	e822                	sd	s0,16(sp)
    8000450a:	e426                	sd	s1,8(sp)
    8000450c:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000450e:	00018517          	auipc	a0,0x18
    80004512:	2a250513          	add	a0,a0,674 # 8001c7b0 <ftable>
    80004516:	ffffc097          	auipc	ra,0xffffc
    8000451a:	6a8080e7          	jalr	1704(ra) # 80000bbe <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000451e:	00018497          	auipc	s1,0x18
    80004522:	2aa48493          	add	s1,s1,682 # 8001c7c8 <ftable+0x18>
    80004526:	00019717          	auipc	a4,0x19
    8000452a:	24270713          	add	a4,a4,578 # 8001d768 <ftable+0xfb8>
    if(f->ref == 0){
    8000452e:	40dc                	lw	a5,4(s1)
    80004530:	cf99                	beqz	a5,8000454e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004532:	02848493          	add	s1,s1,40
    80004536:	fee49ce3          	bne	s1,a4,8000452e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000453a:	00018517          	auipc	a0,0x18
    8000453e:	27650513          	add	a0,a0,630 # 8001c7b0 <ftable>
    80004542:	ffffc097          	auipc	ra,0xffffc
    80004546:	730080e7          	jalr	1840(ra) # 80000c72 <release>
  return 0;
    8000454a:	4481                	li	s1,0
    8000454c:	a819                	j	80004562 <filealloc+0x5e>
      f->ref = 1;
    8000454e:	4785                	li	a5,1
    80004550:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004552:	00018517          	auipc	a0,0x18
    80004556:	25e50513          	add	a0,a0,606 # 8001c7b0 <ftable>
    8000455a:	ffffc097          	auipc	ra,0xffffc
    8000455e:	718080e7          	jalr	1816(ra) # 80000c72 <release>
}
    80004562:	8526                	mv	a0,s1
    80004564:	60e2                	ld	ra,24(sp)
    80004566:	6442                	ld	s0,16(sp)
    80004568:	64a2                	ld	s1,8(sp)
    8000456a:	6105                	add	sp,sp,32
    8000456c:	8082                	ret

000000008000456e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000456e:	1101                	add	sp,sp,-32
    80004570:	ec06                	sd	ra,24(sp)
    80004572:	e822                	sd	s0,16(sp)
    80004574:	e426                	sd	s1,8(sp)
    80004576:	1000                	add	s0,sp,32
    80004578:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000457a:	00018517          	auipc	a0,0x18
    8000457e:	23650513          	add	a0,a0,566 # 8001c7b0 <ftable>
    80004582:	ffffc097          	auipc	ra,0xffffc
    80004586:	63c080e7          	jalr	1596(ra) # 80000bbe <acquire>
  if(f->ref < 1)
    8000458a:	40dc                	lw	a5,4(s1)
    8000458c:	02f05263          	blez	a5,800045b0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004590:	2785                	addw	a5,a5,1
    80004592:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004594:	00018517          	auipc	a0,0x18
    80004598:	21c50513          	add	a0,a0,540 # 8001c7b0 <ftable>
    8000459c:	ffffc097          	auipc	ra,0xffffc
    800045a0:	6d6080e7          	jalr	1750(ra) # 80000c72 <release>
  return f;
}
    800045a4:	8526                	mv	a0,s1
    800045a6:	60e2                	ld	ra,24(sp)
    800045a8:	6442                	ld	s0,16(sp)
    800045aa:	64a2                	ld	s1,8(sp)
    800045ac:	6105                	add	sp,sp,32
    800045ae:	8082                	ret
    panic("filedup");
    800045b0:	00004517          	auipc	a0,0x4
    800045b4:	0b850513          	add	a0,a0,184 # 80008668 <syscalls+0x248>
    800045b8:	ffffc097          	auipc	ra,0xffffc
    800045bc:	f70080e7          	jalr	-144(ra) # 80000528 <panic>

00000000800045c0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800045c0:	7139                	add	sp,sp,-64
    800045c2:	fc06                	sd	ra,56(sp)
    800045c4:	f822                	sd	s0,48(sp)
    800045c6:	f426                	sd	s1,40(sp)
    800045c8:	f04a                	sd	s2,32(sp)
    800045ca:	ec4e                	sd	s3,24(sp)
    800045cc:	e852                	sd	s4,16(sp)
    800045ce:	e456                	sd	s5,8(sp)
    800045d0:	0080                	add	s0,sp,64
    800045d2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800045d4:	00018517          	auipc	a0,0x18
    800045d8:	1dc50513          	add	a0,a0,476 # 8001c7b0 <ftable>
    800045dc:	ffffc097          	auipc	ra,0xffffc
    800045e0:	5e2080e7          	jalr	1506(ra) # 80000bbe <acquire>
  if(f->ref < 1)
    800045e4:	40dc                	lw	a5,4(s1)
    800045e6:	06f05163          	blez	a5,80004648 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800045ea:	37fd                	addw	a5,a5,-1
    800045ec:	0007871b          	sext.w	a4,a5
    800045f0:	c0dc                	sw	a5,4(s1)
    800045f2:	06e04363          	bgtz	a4,80004658 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800045f6:	0004a903          	lw	s2,0(s1)
    800045fa:	0094ca83          	lbu	s5,9(s1)
    800045fe:	0104ba03          	ld	s4,16(s1)
    80004602:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004606:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000460a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000460e:	00018517          	auipc	a0,0x18
    80004612:	1a250513          	add	a0,a0,418 # 8001c7b0 <ftable>
    80004616:	ffffc097          	auipc	ra,0xffffc
    8000461a:	65c080e7          	jalr	1628(ra) # 80000c72 <release>

  if(ff.type == FD_PIPE){
    8000461e:	4785                	li	a5,1
    80004620:	04f90d63          	beq	s2,a5,8000467a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004624:	3979                	addw	s2,s2,-2
    80004626:	4785                	li	a5,1
    80004628:	0527e063          	bltu	a5,s2,80004668 <fileclose+0xa8>
    begin_op();
    8000462c:	00000097          	auipc	ra,0x0
    80004630:	ac8080e7          	jalr	-1336(ra) # 800040f4 <begin_op>
    iput(ff.ip);
    80004634:	854e                	mv	a0,s3
    80004636:	fffff097          	auipc	ra,0xfffff
    8000463a:	2c0080e7          	jalr	704(ra) # 800038f6 <iput>
    end_op();
    8000463e:	00000097          	auipc	ra,0x0
    80004642:	b30080e7          	jalr	-1232(ra) # 8000416e <end_op>
    80004646:	a00d                	j	80004668 <fileclose+0xa8>
    panic("fileclose");
    80004648:	00004517          	auipc	a0,0x4
    8000464c:	02850513          	add	a0,a0,40 # 80008670 <syscalls+0x250>
    80004650:	ffffc097          	auipc	ra,0xffffc
    80004654:	ed8080e7          	jalr	-296(ra) # 80000528 <panic>
    release(&ftable.lock);
    80004658:	00018517          	auipc	a0,0x18
    8000465c:	15850513          	add	a0,a0,344 # 8001c7b0 <ftable>
    80004660:	ffffc097          	auipc	ra,0xffffc
    80004664:	612080e7          	jalr	1554(ra) # 80000c72 <release>
  }
}
    80004668:	70e2                	ld	ra,56(sp)
    8000466a:	7442                	ld	s0,48(sp)
    8000466c:	74a2                	ld	s1,40(sp)
    8000466e:	7902                	ld	s2,32(sp)
    80004670:	69e2                	ld	s3,24(sp)
    80004672:	6a42                	ld	s4,16(sp)
    80004674:	6aa2                	ld	s5,8(sp)
    80004676:	6121                	add	sp,sp,64
    80004678:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000467a:	85d6                	mv	a1,s5
    8000467c:	8552                	mv	a0,s4
    8000467e:	00000097          	auipc	ra,0x0
    80004682:	348080e7          	jalr	840(ra) # 800049c6 <pipeclose>
    80004686:	b7cd                	j	80004668 <fileclose+0xa8>

0000000080004688 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004688:	715d                	add	sp,sp,-80
    8000468a:	e486                	sd	ra,72(sp)
    8000468c:	e0a2                	sd	s0,64(sp)
    8000468e:	fc26                	sd	s1,56(sp)
    80004690:	f84a                	sd	s2,48(sp)
    80004692:	f44e                	sd	s3,40(sp)
    80004694:	0880                	add	s0,sp,80
    80004696:	84aa                	mv	s1,a0
    80004698:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000469a:	ffffd097          	auipc	ra,0xffffd
    8000469e:	30a080e7          	jalr	778(ra) # 800019a4 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800046a2:	409c                	lw	a5,0(s1)
    800046a4:	37f9                	addw	a5,a5,-2
    800046a6:	4705                	li	a4,1
    800046a8:	04f76763          	bltu	a4,a5,800046f6 <filestat+0x6e>
    800046ac:	892a                	mv	s2,a0
    ilock(f->ip);
    800046ae:	6c88                	ld	a0,24(s1)
    800046b0:	fffff097          	auipc	ra,0xfffff
    800046b4:	fe6080e7          	jalr	-26(ra) # 80003696 <ilock>
    stati(f->ip, &st);
    800046b8:	fb840593          	add	a1,s0,-72
    800046bc:	6c88                	ld	a0,24(s1)
    800046be:	fffff097          	auipc	ra,0xfffff
    800046c2:	308080e7          	jalr	776(ra) # 800039c6 <stati>
    iunlock(f->ip);
    800046c6:	6c88                	ld	a0,24(s1)
    800046c8:	fffff097          	auipc	ra,0xfffff
    800046cc:	090080e7          	jalr	144(ra) # 80003758 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800046d0:	46e1                	li	a3,24
    800046d2:	fb840613          	add	a2,s0,-72
    800046d6:	85ce                	mv	a1,s3
    800046d8:	05093503          	ld	a0,80(s2)
    800046dc:	ffffd097          	auipc	ra,0xffffd
    800046e0:	f60080e7          	jalr	-160(ra) # 8000163c <copyout>
    800046e4:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800046e8:	60a6                	ld	ra,72(sp)
    800046ea:	6406                	ld	s0,64(sp)
    800046ec:	74e2                	ld	s1,56(sp)
    800046ee:	7942                	ld	s2,48(sp)
    800046f0:	79a2                	ld	s3,40(sp)
    800046f2:	6161                	add	sp,sp,80
    800046f4:	8082                	ret
  return -1;
    800046f6:	557d                	li	a0,-1
    800046f8:	bfc5                	j	800046e8 <filestat+0x60>

00000000800046fa <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800046fa:	7179                	add	sp,sp,-48
    800046fc:	f406                	sd	ra,40(sp)
    800046fe:	f022                	sd	s0,32(sp)
    80004700:	ec26                	sd	s1,24(sp)
    80004702:	e84a                	sd	s2,16(sp)
    80004704:	e44e                	sd	s3,8(sp)
    80004706:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004708:	00854783          	lbu	a5,8(a0)
    8000470c:	c3d5                	beqz	a5,800047b0 <fileread+0xb6>
    8000470e:	84aa                	mv	s1,a0
    80004710:	89ae                	mv	s3,a1
    80004712:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004714:	411c                	lw	a5,0(a0)
    80004716:	4705                	li	a4,1
    80004718:	04e78963          	beq	a5,a4,8000476a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000471c:	470d                	li	a4,3
    8000471e:	04e78d63          	beq	a5,a4,80004778 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004722:	4709                	li	a4,2
    80004724:	06e79e63          	bne	a5,a4,800047a0 <fileread+0xa6>
    ilock(f->ip);
    80004728:	6d08                	ld	a0,24(a0)
    8000472a:	fffff097          	auipc	ra,0xfffff
    8000472e:	f6c080e7          	jalr	-148(ra) # 80003696 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004732:	874a                	mv	a4,s2
    80004734:	5094                	lw	a3,32(s1)
    80004736:	864e                	mv	a2,s3
    80004738:	4585                	li	a1,1
    8000473a:	6c88                	ld	a0,24(s1)
    8000473c:	fffff097          	auipc	ra,0xfffff
    80004740:	2b4080e7          	jalr	692(ra) # 800039f0 <readi>
    80004744:	892a                	mv	s2,a0
    80004746:	00a05563          	blez	a0,80004750 <fileread+0x56>
      f->off += r;
    8000474a:	509c                	lw	a5,32(s1)
    8000474c:	9fa9                	addw	a5,a5,a0
    8000474e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004750:	6c88                	ld	a0,24(s1)
    80004752:	fffff097          	auipc	ra,0xfffff
    80004756:	006080e7          	jalr	6(ra) # 80003758 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    8000475a:	854a                	mv	a0,s2
    8000475c:	70a2                	ld	ra,40(sp)
    8000475e:	7402                	ld	s0,32(sp)
    80004760:	64e2                	ld	s1,24(sp)
    80004762:	6942                	ld	s2,16(sp)
    80004764:	69a2                	ld	s3,8(sp)
    80004766:	6145                	add	sp,sp,48
    80004768:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000476a:	6908                	ld	a0,16(a0)
    8000476c:	00000097          	auipc	ra,0x0
    80004770:	3bc080e7          	jalr	956(ra) # 80004b28 <piperead>
    80004774:	892a                	mv	s2,a0
    80004776:	b7d5                	j	8000475a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004778:	02451783          	lh	a5,36(a0)
    8000477c:	03079693          	sll	a3,a5,0x30
    80004780:	92c1                	srl	a3,a3,0x30
    80004782:	4725                	li	a4,9
    80004784:	02d76863          	bltu	a4,a3,800047b4 <fileread+0xba>
    80004788:	0792                	sll	a5,a5,0x4
    8000478a:	00018717          	auipc	a4,0x18
    8000478e:	f8670713          	add	a4,a4,-122 # 8001c710 <devsw>
    80004792:	97ba                	add	a5,a5,a4
    80004794:	639c                	ld	a5,0(a5)
    80004796:	c38d                	beqz	a5,800047b8 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004798:	4505                	li	a0,1
    8000479a:	9782                	jalr	a5
    8000479c:	892a                	mv	s2,a0
    8000479e:	bf75                	j	8000475a <fileread+0x60>
    panic("fileread");
    800047a0:	00004517          	auipc	a0,0x4
    800047a4:	ee050513          	add	a0,a0,-288 # 80008680 <syscalls+0x260>
    800047a8:	ffffc097          	auipc	ra,0xffffc
    800047ac:	d80080e7          	jalr	-640(ra) # 80000528 <panic>
    return -1;
    800047b0:	597d                	li	s2,-1
    800047b2:	b765                	j	8000475a <fileread+0x60>
      return -1;
    800047b4:	597d                	li	s2,-1
    800047b6:	b755                	j	8000475a <fileread+0x60>
    800047b8:	597d                	li	s2,-1
    800047ba:	b745                	j	8000475a <fileread+0x60>

00000000800047bc <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800047bc:	00954783          	lbu	a5,9(a0)
    800047c0:	10078e63          	beqz	a5,800048dc <filewrite+0x120>
{
    800047c4:	715d                	add	sp,sp,-80
    800047c6:	e486                	sd	ra,72(sp)
    800047c8:	e0a2                	sd	s0,64(sp)
    800047ca:	fc26                	sd	s1,56(sp)
    800047cc:	f84a                	sd	s2,48(sp)
    800047ce:	f44e                	sd	s3,40(sp)
    800047d0:	f052                	sd	s4,32(sp)
    800047d2:	ec56                	sd	s5,24(sp)
    800047d4:	e85a                	sd	s6,16(sp)
    800047d6:	e45e                	sd	s7,8(sp)
    800047d8:	e062                	sd	s8,0(sp)
    800047da:	0880                	add	s0,sp,80
    800047dc:	892a                	mv	s2,a0
    800047de:	8b2e                	mv	s6,a1
    800047e0:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800047e2:	411c                	lw	a5,0(a0)
    800047e4:	4705                	li	a4,1
    800047e6:	02e78263          	beq	a5,a4,8000480a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800047ea:	470d                	li	a4,3
    800047ec:	02e78563          	beq	a5,a4,80004816 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800047f0:	4709                	li	a4,2
    800047f2:	0ce79d63          	bne	a5,a4,800048cc <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800047f6:	0ac05b63          	blez	a2,800048ac <filewrite+0xf0>
    int i = 0;
    800047fa:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800047fc:	6b85                	lui	s7,0x1
    800047fe:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004802:	6c05                	lui	s8,0x1
    80004804:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004808:	a851                	j	8000489c <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    8000480a:	6908                	ld	a0,16(a0)
    8000480c:	00000097          	auipc	ra,0x0
    80004810:	22a080e7          	jalr	554(ra) # 80004a36 <pipewrite>
    80004814:	a045                	j	800048b4 <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004816:	02451783          	lh	a5,36(a0)
    8000481a:	03079693          	sll	a3,a5,0x30
    8000481e:	92c1                	srl	a3,a3,0x30
    80004820:	4725                	li	a4,9
    80004822:	0ad76f63          	bltu	a4,a3,800048e0 <filewrite+0x124>
    80004826:	0792                	sll	a5,a5,0x4
    80004828:	00018717          	auipc	a4,0x18
    8000482c:	ee870713          	add	a4,a4,-280 # 8001c710 <devsw>
    80004830:	97ba                	add	a5,a5,a4
    80004832:	679c                	ld	a5,8(a5)
    80004834:	cbc5                	beqz	a5,800048e4 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80004836:	4505                	li	a0,1
    80004838:	9782                	jalr	a5
    8000483a:	a8ad                	j	800048b4 <filewrite+0xf8>
      if(n1 > max)
    8000483c:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004840:	00000097          	auipc	ra,0x0
    80004844:	8b4080e7          	jalr	-1868(ra) # 800040f4 <begin_op>
      ilock(f->ip);
    80004848:	01893503          	ld	a0,24(s2)
    8000484c:	fffff097          	auipc	ra,0xfffff
    80004850:	e4a080e7          	jalr	-438(ra) # 80003696 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004854:	8756                	mv	a4,s5
    80004856:	02092683          	lw	a3,32(s2)
    8000485a:	01698633          	add	a2,s3,s6
    8000485e:	4585                	li	a1,1
    80004860:	01893503          	ld	a0,24(s2)
    80004864:	fffff097          	auipc	ra,0xfffff
    80004868:	284080e7          	jalr	644(ra) # 80003ae8 <writei>
    8000486c:	84aa                	mv	s1,a0
    8000486e:	00a05763          	blez	a0,8000487c <filewrite+0xc0>
        f->off += r;
    80004872:	02092783          	lw	a5,32(s2)
    80004876:	9fa9                	addw	a5,a5,a0
    80004878:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000487c:	01893503          	ld	a0,24(s2)
    80004880:	fffff097          	auipc	ra,0xfffff
    80004884:	ed8080e7          	jalr	-296(ra) # 80003758 <iunlock>
      end_op();
    80004888:	00000097          	auipc	ra,0x0
    8000488c:	8e6080e7          	jalr	-1818(ra) # 8000416e <end_op>

      if(r != n1){
    80004890:	009a9f63          	bne	s5,s1,800048ae <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80004894:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004898:	0149db63          	bge	s3,s4,800048ae <filewrite+0xf2>
      int n1 = n - i;
    8000489c:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800048a0:	0004879b          	sext.w	a5,s1
    800048a4:	f8fbdce3          	bge	s7,a5,8000483c <filewrite+0x80>
    800048a8:	84e2                	mv	s1,s8
    800048aa:	bf49                	j	8000483c <filewrite+0x80>
    int i = 0;
    800048ac:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800048ae:	033a1d63          	bne	s4,s3,800048e8 <filewrite+0x12c>
    800048b2:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    800048b4:	60a6                	ld	ra,72(sp)
    800048b6:	6406                	ld	s0,64(sp)
    800048b8:	74e2                	ld	s1,56(sp)
    800048ba:	7942                	ld	s2,48(sp)
    800048bc:	79a2                	ld	s3,40(sp)
    800048be:	7a02                	ld	s4,32(sp)
    800048c0:	6ae2                	ld	s5,24(sp)
    800048c2:	6b42                	ld	s6,16(sp)
    800048c4:	6ba2                	ld	s7,8(sp)
    800048c6:	6c02                	ld	s8,0(sp)
    800048c8:	6161                	add	sp,sp,80
    800048ca:	8082                	ret
    panic("filewrite");
    800048cc:	00004517          	auipc	a0,0x4
    800048d0:	dc450513          	add	a0,a0,-572 # 80008690 <syscalls+0x270>
    800048d4:	ffffc097          	auipc	ra,0xffffc
    800048d8:	c54080e7          	jalr	-940(ra) # 80000528 <panic>
    return -1;
    800048dc:	557d                	li	a0,-1
}
    800048de:	8082                	ret
      return -1;
    800048e0:	557d                	li	a0,-1
    800048e2:	bfc9                	j	800048b4 <filewrite+0xf8>
    800048e4:	557d                	li	a0,-1
    800048e6:	b7f9                	j	800048b4 <filewrite+0xf8>
    ret = (i == n ? n : -1);
    800048e8:	557d                	li	a0,-1
    800048ea:	b7e9                	j	800048b4 <filewrite+0xf8>

00000000800048ec <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800048ec:	7179                	add	sp,sp,-48
    800048ee:	f406                	sd	ra,40(sp)
    800048f0:	f022                	sd	s0,32(sp)
    800048f2:	ec26                	sd	s1,24(sp)
    800048f4:	e84a                	sd	s2,16(sp)
    800048f6:	e44e                	sd	s3,8(sp)
    800048f8:	e052                	sd	s4,0(sp)
    800048fa:	1800                	add	s0,sp,48
    800048fc:	84aa                	mv	s1,a0
    800048fe:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004900:	0005b023          	sd	zero,0(a1)
    80004904:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004908:	00000097          	auipc	ra,0x0
    8000490c:	bfc080e7          	jalr	-1028(ra) # 80004504 <filealloc>
    80004910:	e088                	sd	a0,0(s1)
    80004912:	c551                	beqz	a0,8000499e <pipealloc+0xb2>
    80004914:	00000097          	auipc	ra,0x0
    80004918:	bf0080e7          	jalr	-1040(ra) # 80004504 <filealloc>
    8000491c:	00aa3023          	sd	a0,0(s4)
    80004920:	c92d                	beqz	a0,80004992 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004922:	ffffc097          	auipc	ra,0xffffc
    80004926:	1ac080e7          	jalr	428(ra) # 80000ace <kalloc>
    8000492a:	892a                	mv	s2,a0
    8000492c:	c125                	beqz	a0,8000498c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000492e:	4985                	li	s3,1
    80004930:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004934:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004938:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000493c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004940:	00004597          	auipc	a1,0x4
    80004944:	d6058593          	add	a1,a1,-672 # 800086a0 <syscalls+0x280>
    80004948:	ffffc097          	auipc	ra,0xffffc
    8000494c:	1e6080e7          	jalr	486(ra) # 80000b2e <initlock>
  (*f0)->type = FD_PIPE;
    80004950:	609c                	ld	a5,0(s1)
    80004952:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004956:	609c                	ld	a5,0(s1)
    80004958:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000495c:	609c                	ld	a5,0(s1)
    8000495e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004962:	609c                	ld	a5,0(s1)
    80004964:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004968:	000a3783          	ld	a5,0(s4)
    8000496c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004970:	000a3783          	ld	a5,0(s4)
    80004974:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004978:	000a3783          	ld	a5,0(s4)
    8000497c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004980:	000a3783          	ld	a5,0(s4)
    80004984:	0127b823          	sd	s2,16(a5)
  return 0;
    80004988:	4501                	li	a0,0
    8000498a:	a025                	j	800049b2 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000498c:	6088                	ld	a0,0(s1)
    8000498e:	e501                	bnez	a0,80004996 <pipealloc+0xaa>
    80004990:	a039                	j	8000499e <pipealloc+0xb2>
    80004992:	6088                	ld	a0,0(s1)
    80004994:	c51d                	beqz	a0,800049c2 <pipealloc+0xd6>
    fileclose(*f0);
    80004996:	00000097          	auipc	ra,0x0
    8000499a:	c2a080e7          	jalr	-982(ra) # 800045c0 <fileclose>
  if(*f1)
    8000499e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800049a2:	557d                	li	a0,-1
  if(*f1)
    800049a4:	c799                	beqz	a5,800049b2 <pipealloc+0xc6>
    fileclose(*f1);
    800049a6:	853e                	mv	a0,a5
    800049a8:	00000097          	auipc	ra,0x0
    800049ac:	c18080e7          	jalr	-1000(ra) # 800045c0 <fileclose>
  return -1;
    800049b0:	557d                	li	a0,-1
}
    800049b2:	70a2                	ld	ra,40(sp)
    800049b4:	7402                	ld	s0,32(sp)
    800049b6:	64e2                	ld	s1,24(sp)
    800049b8:	6942                	ld	s2,16(sp)
    800049ba:	69a2                	ld	s3,8(sp)
    800049bc:	6a02                	ld	s4,0(sp)
    800049be:	6145                	add	sp,sp,48
    800049c0:	8082                	ret
  return -1;
    800049c2:	557d                	li	a0,-1
    800049c4:	b7fd                	j	800049b2 <pipealloc+0xc6>

00000000800049c6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800049c6:	1101                	add	sp,sp,-32
    800049c8:	ec06                	sd	ra,24(sp)
    800049ca:	e822                	sd	s0,16(sp)
    800049cc:	e426                	sd	s1,8(sp)
    800049ce:	e04a                	sd	s2,0(sp)
    800049d0:	1000                	add	s0,sp,32
    800049d2:	84aa                	mv	s1,a0
    800049d4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800049d6:	ffffc097          	auipc	ra,0xffffc
    800049da:	1e8080e7          	jalr	488(ra) # 80000bbe <acquire>
  if(writable){
    800049de:	02090d63          	beqz	s2,80004a18 <pipeclose+0x52>
    pi->writeopen = 0;
    800049e2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800049e6:	21848513          	add	a0,s1,536
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	950080e7          	jalr	-1712(ra) # 8000233a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800049f2:	2204b783          	ld	a5,544(s1)
    800049f6:	eb95                	bnez	a5,80004a2a <pipeclose+0x64>
    release(&pi->lock);
    800049f8:	8526                	mv	a0,s1
    800049fa:	ffffc097          	auipc	ra,0xffffc
    800049fe:	278080e7          	jalr	632(ra) # 80000c72 <release>
    kfree((char*)pi);
    80004a02:	8526                	mv	a0,s1
    80004a04:	ffffc097          	auipc	ra,0xffffc
    80004a08:	fcc080e7          	jalr	-52(ra) # 800009d0 <kfree>
  } else
    release(&pi->lock);
}
    80004a0c:	60e2                	ld	ra,24(sp)
    80004a0e:	6442                	ld	s0,16(sp)
    80004a10:	64a2                	ld	s1,8(sp)
    80004a12:	6902                	ld	s2,0(sp)
    80004a14:	6105                	add	sp,sp,32
    80004a16:	8082                	ret
    pi->readopen = 0;
    80004a18:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004a1c:	21c48513          	add	a0,s1,540
    80004a20:	ffffe097          	auipc	ra,0xffffe
    80004a24:	91a080e7          	jalr	-1766(ra) # 8000233a <wakeup>
    80004a28:	b7e9                	j	800049f2 <pipeclose+0x2c>
    release(&pi->lock);
    80004a2a:	8526                	mv	a0,s1
    80004a2c:	ffffc097          	auipc	ra,0xffffc
    80004a30:	246080e7          	jalr	582(ra) # 80000c72 <release>
}
    80004a34:	bfe1                	j	80004a0c <pipeclose+0x46>

0000000080004a36 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004a36:	711d                	add	sp,sp,-96
    80004a38:	ec86                	sd	ra,88(sp)
    80004a3a:	e8a2                	sd	s0,80(sp)
    80004a3c:	e4a6                	sd	s1,72(sp)
    80004a3e:	e0ca                	sd	s2,64(sp)
    80004a40:	fc4e                	sd	s3,56(sp)
    80004a42:	f852                	sd	s4,48(sp)
    80004a44:	f456                	sd	s5,40(sp)
    80004a46:	f05a                	sd	s6,32(sp)
    80004a48:	ec5e                	sd	s7,24(sp)
    80004a4a:	e862                	sd	s8,16(sp)
    80004a4c:	1080                	add	s0,sp,96
    80004a4e:	84aa                	mv	s1,a0
    80004a50:	8aae                	mv	s5,a1
    80004a52:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004a54:	ffffd097          	auipc	ra,0xffffd
    80004a58:	f50080e7          	jalr	-176(ra) # 800019a4 <myproc>
    80004a5c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004a5e:	8526                	mv	a0,s1
    80004a60:	ffffc097          	auipc	ra,0xffffc
    80004a64:	15e080e7          	jalr	350(ra) # 80000bbe <acquire>
  while(i < n){
    80004a68:	0b405363          	blez	s4,80004b0e <pipewrite+0xd8>
  int i = 0;
    80004a6c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004a6e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004a70:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004a74:	21c48b93          	add	s7,s1,540
    80004a78:	a089                	j	80004aba <pipewrite+0x84>
      release(&pi->lock);
    80004a7a:	8526                	mv	a0,s1
    80004a7c:	ffffc097          	auipc	ra,0xffffc
    80004a80:	1f6080e7          	jalr	502(ra) # 80000c72 <release>
      return -1;
    80004a84:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004a86:	854a                	mv	a0,s2
    80004a88:	60e6                	ld	ra,88(sp)
    80004a8a:	6446                	ld	s0,80(sp)
    80004a8c:	64a6                	ld	s1,72(sp)
    80004a8e:	6906                	ld	s2,64(sp)
    80004a90:	79e2                	ld	s3,56(sp)
    80004a92:	7a42                	ld	s4,48(sp)
    80004a94:	7aa2                	ld	s5,40(sp)
    80004a96:	7b02                	ld	s6,32(sp)
    80004a98:	6be2                	ld	s7,24(sp)
    80004a9a:	6c42                	ld	s8,16(sp)
    80004a9c:	6125                	add	sp,sp,96
    80004a9e:	8082                	ret
      wakeup(&pi->nread);
    80004aa0:	8562                	mv	a0,s8
    80004aa2:	ffffe097          	auipc	ra,0xffffe
    80004aa6:	898080e7          	jalr	-1896(ra) # 8000233a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004aaa:	85a6                	mv	a1,s1
    80004aac:	855e                	mv	a0,s7
    80004aae:	ffffd097          	auipc	ra,0xffffd
    80004ab2:	70c080e7          	jalr	1804(ra) # 800021ba <sleep>
  while(i < n){
    80004ab6:	05495d63          	bge	s2,s4,80004b10 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80004aba:	2204a783          	lw	a5,544(s1)
    80004abe:	dfd5                	beqz	a5,80004a7a <pipewrite+0x44>
    80004ac0:	0309a783          	lw	a5,48(s3)
    80004ac4:	fbdd                	bnez	a5,80004a7a <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004ac6:	2184a783          	lw	a5,536(s1)
    80004aca:	21c4a703          	lw	a4,540(s1)
    80004ace:	2007879b          	addw	a5,a5,512
    80004ad2:	fcf707e3          	beq	a4,a5,80004aa0 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004ad6:	4685                	li	a3,1
    80004ad8:	01590633          	add	a2,s2,s5
    80004adc:	faf40593          	add	a1,s0,-81
    80004ae0:	0509b503          	ld	a0,80(s3)
    80004ae4:	ffffd097          	auipc	ra,0xffffd
    80004ae8:	be4080e7          	jalr	-1052(ra) # 800016c8 <copyin>
    80004aec:	03650263          	beq	a0,s6,80004b10 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004af0:	21c4a783          	lw	a5,540(s1)
    80004af4:	0017871b          	addw	a4,a5,1
    80004af8:	20e4ae23          	sw	a4,540(s1)
    80004afc:	1ff7f793          	and	a5,a5,511
    80004b00:	97a6                	add	a5,a5,s1
    80004b02:	faf44703          	lbu	a4,-81(s0)
    80004b06:	00e78c23          	sb	a4,24(a5)
      i++;
    80004b0a:	2905                	addw	s2,s2,1
    80004b0c:	b76d                	j	80004ab6 <pipewrite+0x80>
  int i = 0;
    80004b0e:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004b10:	21848513          	add	a0,s1,536
    80004b14:	ffffe097          	auipc	ra,0xffffe
    80004b18:	826080e7          	jalr	-2010(ra) # 8000233a <wakeup>
  release(&pi->lock);
    80004b1c:	8526                	mv	a0,s1
    80004b1e:	ffffc097          	auipc	ra,0xffffc
    80004b22:	154080e7          	jalr	340(ra) # 80000c72 <release>
  return i;
    80004b26:	b785                	j	80004a86 <pipewrite+0x50>

0000000080004b28 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004b28:	715d                	add	sp,sp,-80
    80004b2a:	e486                	sd	ra,72(sp)
    80004b2c:	e0a2                	sd	s0,64(sp)
    80004b2e:	fc26                	sd	s1,56(sp)
    80004b30:	f84a                	sd	s2,48(sp)
    80004b32:	f44e                	sd	s3,40(sp)
    80004b34:	f052                	sd	s4,32(sp)
    80004b36:	ec56                	sd	s5,24(sp)
    80004b38:	e85a                	sd	s6,16(sp)
    80004b3a:	0880                	add	s0,sp,80
    80004b3c:	84aa                	mv	s1,a0
    80004b3e:	892e                	mv	s2,a1
    80004b40:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004b42:	ffffd097          	auipc	ra,0xffffd
    80004b46:	e62080e7          	jalr	-414(ra) # 800019a4 <myproc>
    80004b4a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004b4c:	8526                	mv	a0,s1
    80004b4e:	ffffc097          	auipc	ra,0xffffc
    80004b52:	070080e7          	jalr	112(ra) # 80000bbe <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b56:	2184a703          	lw	a4,536(s1)
    80004b5a:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b5e:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b62:	02f71463          	bne	a4,a5,80004b8a <piperead+0x62>
    80004b66:	2244a783          	lw	a5,548(s1)
    80004b6a:	c385                	beqz	a5,80004b8a <piperead+0x62>
    if(pr->killed){
    80004b6c:	030a2783          	lw	a5,48(s4)
    80004b70:	ebc9                	bnez	a5,80004c02 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b72:	85a6                	mv	a1,s1
    80004b74:	854e                	mv	a0,s3
    80004b76:	ffffd097          	auipc	ra,0xffffd
    80004b7a:	644080e7          	jalr	1604(ra) # 800021ba <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b7e:	2184a703          	lw	a4,536(s1)
    80004b82:	21c4a783          	lw	a5,540(s1)
    80004b86:	fef700e3          	beq	a4,a5,80004b66 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004b8a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004b8c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004b8e:	05505463          	blez	s5,80004bd6 <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004b92:	2184a783          	lw	a5,536(s1)
    80004b96:	21c4a703          	lw	a4,540(s1)
    80004b9a:	02f70e63          	beq	a4,a5,80004bd6 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004b9e:	0017871b          	addw	a4,a5,1
    80004ba2:	20e4ac23          	sw	a4,536(s1)
    80004ba6:	1ff7f793          	and	a5,a5,511
    80004baa:	97a6                	add	a5,a5,s1
    80004bac:	0187c783          	lbu	a5,24(a5)
    80004bb0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004bb4:	4685                	li	a3,1
    80004bb6:	fbf40613          	add	a2,s0,-65
    80004bba:	85ca                	mv	a1,s2
    80004bbc:	050a3503          	ld	a0,80(s4)
    80004bc0:	ffffd097          	auipc	ra,0xffffd
    80004bc4:	a7c080e7          	jalr	-1412(ra) # 8000163c <copyout>
    80004bc8:	01650763          	beq	a0,s6,80004bd6 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004bcc:	2985                	addw	s3,s3,1
    80004bce:	0905                	add	s2,s2,1
    80004bd0:	fd3a91e3          	bne	s5,s3,80004b92 <piperead+0x6a>
    80004bd4:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004bd6:	21c48513          	add	a0,s1,540
    80004bda:	ffffd097          	auipc	ra,0xffffd
    80004bde:	760080e7          	jalr	1888(ra) # 8000233a <wakeup>
  release(&pi->lock);
    80004be2:	8526                	mv	a0,s1
    80004be4:	ffffc097          	auipc	ra,0xffffc
    80004be8:	08e080e7          	jalr	142(ra) # 80000c72 <release>
  return i;
}
    80004bec:	854e                	mv	a0,s3
    80004bee:	60a6                	ld	ra,72(sp)
    80004bf0:	6406                	ld	s0,64(sp)
    80004bf2:	74e2                	ld	s1,56(sp)
    80004bf4:	7942                	ld	s2,48(sp)
    80004bf6:	79a2                	ld	s3,40(sp)
    80004bf8:	7a02                	ld	s4,32(sp)
    80004bfa:	6ae2                	ld	s5,24(sp)
    80004bfc:	6b42                	ld	s6,16(sp)
    80004bfe:	6161                	add	sp,sp,80
    80004c00:	8082                	ret
      release(&pi->lock);
    80004c02:	8526                	mv	a0,s1
    80004c04:	ffffc097          	auipc	ra,0xffffc
    80004c08:	06e080e7          	jalr	110(ra) # 80000c72 <release>
      return -1;
    80004c0c:	59fd                	li	s3,-1
    80004c0e:	bff9                	j	80004bec <piperead+0xc4>

0000000080004c10 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004c10:	df010113          	add	sp,sp,-528
    80004c14:	20113423          	sd	ra,520(sp)
    80004c18:	20813023          	sd	s0,512(sp)
    80004c1c:	ffa6                	sd	s1,504(sp)
    80004c1e:	fbca                	sd	s2,496(sp)
    80004c20:	f7ce                	sd	s3,488(sp)
    80004c22:	f3d2                	sd	s4,480(sp)
    80004c24:	efd6                	sd	s5,472(sp)
    80004c26:	ebda                	sd	s6,464(sp)
    80004c28:	e7de                	sd	s7,456(sp)
    80004c2a:	e3e2                	sd	s8,448(sp)
    80004c2c:	ff66                	sd	s9,440(sp)
    80004c2e:	fb6a                	sd	s10,432(sp)
    80004c30:	f76e                	sd	s11,424(sp)
    80004c32:	0c00                	add	s0,sp,528
    80004c34:	892a                	mv	s2,a0
    80004c36:	dea43c23          	sd	a0,-520(s0)
    80004c3a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004c3e:	ffffd097          	auipc	ra,0xffffd
    80004c42:	d66080e7          	jalr	-666(ra) # 800019a4 <myproc>
    80004c46:	84aa                	mv	s1,a0

  begin_op();
    80004c48:	fffff097          	auipc	ra,0xfffff
    80004c4c:	4ac080e7          	jalr	1196(ra) # 800040f4 <begin_op>

  if((ip = namei(path)) == 0){
    80004c50:	854a                	mv	a0,s2
    80004c52:	fffff097          	auipc	ra,0xfffff
    80004c56:	2a2080e7          	jalr	674(ra) # 80003ef4 <namei>
    80004c5a:	c92d                	beqz	a0,80004ccc <exec+0xbc>
    80004c5c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004c5e:	fffff097          	auipc	ra,0xfffff
    80004c62:	a38080e7          	jalr	-1480(ra) # 80003696 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004c66:	04000713          	li	a4,64
    80004c6a:	4681                	li	a3,0
    80004c6c:	e4840613          	add	a2,s0,-440
    80004c70:	4581                	li	a1,0
    80004c72:	8552                	mv	a0,s4
    80004c74:	fffff097          	auipc	ra,0xfffff
    80004c78:	d7c080e7          	jalr	-644(ra) # 800039f0 <readi>
    80004c7c:	04000793          	li	a5,64
    80004c80:	00f51a63          	bne	a0,a5,80004c94 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004c84:	e4842703          	lw	a4,-440(s0)
    80004c88:	464c47b7          	lui	a5,0x464c4
    80004c8c:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004c90:	04f70463          	beq	a4,a5,80004cd8 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004c94:	8552                	mv	a0,s4
    80004c96:	fffff097          	auipc	ra,0xfffff
    80004c9a:	d08080e7          	jalr	-760(ra) # 8000399e <iunlockput>
    end_op();
    80004c9e:	fffff097          	auipc	ra,0xfffff
    80004ca2:	4d0080e7          	jalr	1232(ra) # 8000416e <end_op>
  }
  return -1;
    80004ca6:	557d                	li	a0,-1
}
    80004ca8:	20813083          	ld	ra,520(sp)
    80004cac:	20013403          	ld	s0,512(sp)
    80004cb0:	74fe                	ld	s1,504(sp)
    80004cb2:	795e                	ld	s2,496(sp)
    80004cb4:	79be                	ld	s3,488(sp)
    80004cb6:	7a1e                	ld	s4,480(sp)
    80004cb8:	6afe                	ld	s5,472(sp)
    80004cba:	6b5e                	ld	s6,464(sp)
    80004cbc:	6bbe                	ld	s7,456(sp)
    80004cbe:	6c1e                	ld	s8,448(sp)
    80004cc0:	7cfa                	ld	s9,440(sp)
    80004cc2:	7d5a                	ld	s10,432(sp)
    80004cc4:	7dba                	ld	s11,424(sp)
    80004cc6:	21010113          	add	sp,sp,528
    80004cca:	8082                	ret
    end_op();
    80004ccc:	fffff097          	auipc	ra,0xfffff
    80004cd0:	4a2080e7          	jalr	1186(ra) # 8000416e <end_op>
    return -1;
    80004cd4:	557d                	li	a0,-1
    80004cd6:	bfc9                	j	80004ca8 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004cd8:	8526                	mv	a0,s1
    80004cda:	ffffd097          	auipc	ra,0xffffd
    80004cde:	d8e080e7          	jalr	-626(ra) # 80001a68 <proc_pagetable>
    80004ce2:	8b2a                	mv	s6,a0
    80004ce4:	d945                	beqz	a0,80004c94 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004ce6:	e6842d03          	lw	s10,-408(s0)
    80004cea:	e8045783          	lhu	a5,-384(s0)
    80004cee:	cfe5                	beqz	a5,80004de6 <exec+0x1d6>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004cf0:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004cf2:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004cf4:	6c85                	lui	s9,0x1
    80004cf6:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004cfa:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004cfe:	6a85                	lui	s5,0x1
    80004d00:	a0b5                	j	80004d6c <exec+0x15c>
      panic("loadseg: address should exist");
    80004d02:	00004517          	auipc	a0,0x4
    80004d06:	9a650513          	add	a0,a0,-1626 # 800086a8 <syscalls+0x288>
    80004d0a:	ffffc097          	auipc	ra,0xffffc
    80004d0e:	81e080e7          	jalr	-2018(ra) # 80000528 <panic>
    if(sz - i < PGSIZE)
    80004d12:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004d14:	8726                	mv	a4,s1
    80004d16:	012c06bb          	addw	a3,s8,s2
    80004d1a:	4581                	li	a1,0
    80004d1c:	8552                	mv	a0,s4
    80004d1e:	fffff097          	auipc	ra,0xfffff
    80004d22:	cd2080e7          	jalr	-814(ra) # 800039f0 <readi>
    80004d26:	2501                	sext.w	a0,a0
    80004d28:	24a49063          	bne	s1,a0,80004f68 <exec+0x358>
  for(i = 0; i < sz; i += PGSIZE){
    80004d2c:	012a893b          	addw	s2,s5,s2
    80004d30:	03397563          	bgeu	s2,s3,80004d5a <exec+0x14a>
    pa = walkaddr(pagetable, va + i);
    80004d34:	02091593          	sll	a1,s2,0x20
    80004d38:	9181                	srl	a1,a1,0x20
    80004d3a:	95de                	add	a1,a1,s7
    80004d3c:	855a                	mv	a0,s6
    80004d3e:	ffffc097          	auipc	ra,0xffffc
    80004d42:	308080e7          	jalr	776(ra) # 80001046 <walkaddr>
    80004d46:	862a                	mv	a2,a0
    if(pa == 0)
    80004d48:	dd4d                	beqz	a0,80004d02 <exec+0xf2>
    if(sz - i < PGSIZE)
    80004d4a:	412984bb          	subw	s1,s3,s2
    80004d4e:	0004879b          	sext.w	a5,s1
    80004d52:	fcfcf0e3          	bgeu	s9,a5,80004d12 <exec+0x102>
    80004d56:	84d6                	mv	s1,s5
    80004d58:	bf6d                	j	80004d12 <exec+0x102>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004d5a:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d5e:	2d85                	addw	s11,s11,1
    80004d60:	038d0d1b          	addw	s10,s10,56
    80004d64:	e8045783          	lhu	a5,-384(s0)
    80004d68:	08fdd063          	bge	s11,a5,80004de8 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004d6c:	2d01                	sext.w	s10,s10
    80004d6e:	03800713          	li	a4,56
    80004d72:	86ea                	mv	a3,s10
    80004d74:	e1040613          	add	a2,s0,-496
    80004d78:	4581                	li	a1,0
    80004d7a:	8552                	mv	a0,s4
    80004d7c:	fffff097          	auipc	ra,0xfffff
    80004d80:	c74080e7          	jalr	-908(ra) # 800039f0 <readi>
    80004d84:	03800793          	li	a5,56
    80004d88:	1cf51e63          	bne	a0,a5,80004f64 <exec+0x354>
    if(ph.type != ELF_PROG_LOAD)
    80004d8c:	e1042783          	lw	a5,-496(s0)
    80004d90:	4705                	li	a4,1
    80004d92:	fce796e3          	bne	a5,a4,80004d5e <exec+0x14e>
    if(ph.memsz < ph.filesz)
    80004d96:	e3843603          	ld	a2,-456(s0)
    80004d9a:	e3043783          	ld	a5,-464(s0)
    80004d9e:	1ef66063          	bltu	a2,a5,80004f7e <exec+0x36e>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004da2:	e2043783          	ld	a5,-480(s0)
    80004da6:	963e                	add	a2,a2,a5
    80004da8:	1cf66e63          	bltu	a2,a5,80004f84 <exec+0x374>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004dac:	85a6                	mv	a1,s1
    80004dae:	855a                	mv	a0,s6
    80004db0:	ffffc097          	auipc	ra,0xffffc
    80004db4:	638080e7          	jalr	1592(ra) # 800013e8 <uvmalloc>
    80004db8:	e0a43423          	sd	a0,-504(s0)
    80004dbc:	1c050763          	beqz	a0,80004f8a <exec+0x37a>
    if(ph.vaddr % PGSIZE != 0)
    80004dc0:	e2043b83          	ld	s7,-480(s0)
    80004dc4:	df043783          	ld	a5,-528(s0)
    80004dc8:	00fbf7b3          	and	a5,s7,a5
    80004dcc:	18079e63          	bnez	a5,80004f68 <exec+0x358>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004dd0:	e1842c03          	lw	s8,-488(s0)
    80004dd4:	e3042983          	lw	s3,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004dd8:	00098463          	beqz	s3,80004de0 <exec+0x1d0>
    80004ddc:	4901                	li	s2,0
    80004dde:	bf99                	j	80004d34 <exec+0x124>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004de0:	e0843483          	ld	s1,-504(s0)
    80004de4:	bfad                	j	80004d5e <exec+0x14e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004de6:	4481                	li	s1,0
  iunlockput(ip);
    80004de8:	8552                	mv	a0,s4
    80004dea:	fffff097          	auipc	ra,0xfffff
    80004dee:	bb4080e7          	jalr	-1100(ra) # 8000399e <iunlockput>
  end_op();
    80004df2:	fffff097          	auipc	ra,0xfffff
    80004df6:	37c080e7          	jalr	892(ra) # 8000416e <end_op>
  p = myproc();
    80004dfa:	ffffd097          	auipc	ra,0xffffd
    80004dfe:	baa080e7          	jalr	-1110(ra) # 800019a4 <myproc>
    80004e02:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004e04:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004e08:	6985                	lui	s3,0x1
    80004e0a:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004e0c:	99a6                	add	s3,s3,s1
    80004e0e:	77fd                	lui	a5,0xfffff
    80004e10:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004e14:	6609                	lui	a2,0x2
    80004e16:	964e                	add	a2,a2,s3
    80004e18:	85ce                	mv	a1,s3
    80004e1a:	855a                	mv	a0,s6
    80004e1c:	ffffc097          	auipc	ra,0xffffc
    80004e20:	5cc080e7          	jalr	1484(ra) # 800013e8 <uvmalloc>
    80004e24:	892a                	mv	s2,a0
    80004e26:	e0a43423          	sd	a0,-504(s0)
    80004e2a:	e509                	bnez	a0,80004e34 <exec+0x224>
  if(pagetable)
    80004e2c:	e1343423          	sd	s3,-504(s0)
    80004e30:	4a01                	li	s4,0
    80004e32:	aa1d                	j	80004f68 <exec+0x358>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004e34:	75f9                	lui	a1,0xffffe
    80004e36:	95aa                	add	a1,a1,a0
    80004e38:	855a                	mv	a0,s6
    80004e3a:	ffffc097          	auipc	ra,0xffffc
    80004e3e:	7d0080e7          	jalr	2000(ra) # 8000160a <uvmclear>
  stackbase = sp - PGSIZE;
    80004e42:	7bfd                	lui	s7,0xfffff
    80004e44:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004e46:	e0043783          	ld	a5,-512(s0)
    80004e4a:	6388                	ld	a0,0(a5)
    80004e4c:	c52d                	beqz	a0,80004eb6 <exec+0x2a6>
    80004e4e:	e8840993          	add	s3,s0,-376
    80004e52:	f8840c13          	add	s8,s0,-120
    80004e56:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004e58:	ffffc097          	auipc	ra,0xffffc
    80004e5c:	fe4080e7          	jalr	-28(ra) # 80000e3c <strlen>
    80004e60:	0015079b          	addw	a5,a0,1
    80004e64:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004e68:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80004e6c:	13796263          	bltu	s2,s7,80004f90 <exec+0x380>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004e70:	e0043d03          	ld	s10,-512(s0)
    80004e74:	000d3a03          	ld	s4,0(s10)
    80004e78:	8552                	mv	a0,s4
    80004e7a:	ffffc097          	auipc	ra,0xffffc
    80004e7e:	fc2080e7          	jalr	-62(ra) # 80000e3c <strlen>
    80004e82:	0015069b          	addw	a3,a0,1
    80004e86:	8652                	mv	a2,s4
    80004e88:	85ca                	mv	a1,s2
    80004e8a:	855a                	mv	a0,s6
    80004e8c:	ffffc097          	auipc	ra,0xffffc
    80004e90:	7b0080e7          	jalr	1968(ra) # 8000163c <copyout>
    80004e94:	10054063          	bltz	a0,80004f94 <exec+0x384>
    ustack[argc] = sp;
    80004e98:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004e9c:	0485                	add	s1,s1,1
    80004e9e:	008d0793          	add	a5,s10,8
    80004ea2:	e0f43023          	sd	a5,-512(s0)
    80004ea6:	008d3503          	ld	a0,8(s10)
    80004eaa:	c909                	beqz	a0,80004ebc <exec+0x2ac>
    if(argc >= MAXARG)
    80004eac:	09a1                	add	s3,s3,8
    80004eae:	fb8995e3          	bne	s3,s8,80004e58 <exec+0x248>
  ip = 0;
    80004eb2:	4a01                	li	s4,0
    80004eb4:	a855                	j	80004f68 <exec+0x358>
  sp = sz;
    80004eb6:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004eba:	4481                	li	s1,0
  ustack[argc] = 0;
    80004ebc:	00349793          	sll	a5,s1,0x3
    80004ec0:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffddf90>
    80004ec4:	97a2                	add	a5,a5,s0
    80004ec6:	ee07bc23          	sd	zero,-264(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004eca:	00148693          	add	a3,s1,1
    80004ece:	068e                	sll	a3,a3,0x3
    80004ed0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004ed4:	ff097913          	and	s2,s2,-16
  sz = sz1;
    80004ed8:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004edc:	f57968e3          	bltu	s2,s7,80004e2c <exec+0x21c>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004ee0:	e8840613          	add	a2,s0,-376
    80004ee4:	85ca                	mv	a1,s2
    80004ee6:	855a                	mv	a0,s6
    80004ee8:	ffffc097          	auipc	ra,0xffffc
    80004eec:	754080e7          	jalr	1876(ra) # 8000163c <copyout>
    80004ef0:	0a054463          	bltz	a0,80004f98 <exec+0x388>
  p->trapframe->a1 = sp;
    80004ef4:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004ef8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004efc:	df843783          	ld	a5,-520(s0)
    80004f00:	0007c703          	lbu	a4,0(a5)
    80004f04:	cf11                	beqz	a4,80004f20 <exec+0x310>
    80004f06:	0785                	add	a5,a5,1
    if(*s == '/')
    80004f08:	02f00693          	li	a3,47
    80004f0c:	a039                	j	80004f1a <exec+0x30a>
      last = s+1;
    80004f0e:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004f12:	0785                	add	a5,a5,1
    80004f14:	fff7c703          	lbu	a4,-1(a5)
    80004f18:	c701                	beqz	a4,80004f20 <exec+0x310>
    if(*s == '/')
    80004f1a:	fed71ce3          	bne	a4,a3,80004f12 <exec+0x302>
    80004f1e:	bfc5                	j	80004f0e <exec+0x2fe>
  safestrcpy(p->name, last, sizeof(p->name));
    80004f20:	4641                	li	a2,16
    80004f22:	df843583          	ld	a1,-520(s0)
    80004f26:	158a8513          	add	a0,s5,344
    80004f2a:	ffffc097          	auipc	ra,0xffffc
    80004f2e:	ee0080e7          	jalr	-288(ra) # 80000e0a <safestrcpy>
  oldpagetable = p->pagetable;
    80004f32:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004f36:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004f3a:	e0843783          	ld	a5,-504(s0)
    80004f3e:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004f42:	058ab783          	ld	a5,88(s5)
    80004f46:	e6043703          	ld	a4,-416(s0)
    80004f4a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004f4c:	058ab783          	ld	a5,88(s5)
    80004f50:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004f54:	85e6                	mv	a1,s9
    80004f56:	ffffd097          	auipc	ra,0xffffd
    80004f5a:	bae080e7          	jalr	-1106(ra) # 80001b04 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004f5e:	0004851b          	sext.w	a0,s1
    80004f62:	b399                	j	80004ca8 <exec+0x98>
    80004f64:	e0943423          	sd	s1,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004f68:	e0843583          	ld	a1,-504(s0)
    80004f6c:	855a                	mv	a0,s6
    80004f6e:	ffffd097          	auipc	ra,0xffffd
    80004f72:	b96080e7          	jalr	-1130(ra) # 80001b04 <proc_freepagetable>
  return -1;
    80004f76:	557d                	li	a0,-1
  if(ip){
    80004f78:	d20a08e3          	beqz	s4,80004ca8 <exec+0x98>
    80004f7c:	bb21                	j	80004c94 <exec+0x84>
    80004f7e:	e0943423          	sd	s1,-504(s0)
    80004f82:	b7dd                	j	80004f68 <exec+0x358>
    80004f84:	e0943423          	sd	s1,-504(s0)
    80004f88:	b7c5                	j	80004f68 <exec+0x358>
    80004f8a:	e0943423          	sd	s1,-504(s0)
    80004f8e:	bfe9                	j	80004f68 <exec+0x358>
  ip = 0;
    80004f90:	4a01                	li	s4,0
    80004f92:	bfd9                	j	80004f68 <exec+0x358>
    80004f94:	4a01                	li	s4,0
  if(pagetable)
    80004f96:	bfc9                	j	80004f68 <exec+0x358>
  sz = sz1;
    80004f98:	e0843983          	ld	s3,-504(s0)
    80004f9c:	bd41                	j	80004e2c <exec+0x21c>

0000000080004f9e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004f9e:	7179                	add	sp,sp,-48
    80004fa0:	f406                	sd	ra,40(sp)
    80004fa2:	f022                	sd	s0,32(sp)
    80004fa4:	ec26                	sd	s1,24(sp)
    80004fa6:	e84a                	sd	s2,16(sp)
    80004fa8:	1800                	add	s0,sp,48
    80004faa:	892e                	mv	s2,a1
    80004fac:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004fae:	fdc40593          	add	a1,s0,-36
    80004fb2:	ffffe097          	auipc	ra,0xffffe
    80004fb6:	ab4080e7          	jalr	-1356(ra) # 80002a66 <argint>
    80004fba:	04054063          	bltz	a0,80004ffa <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004fbe:	fdc42703          	lw	a4,-36(s0)
    80004fc2:	47bd                	li	a5,15
    80004fc4:	02e7ed63          	bltu	a5,a4,80004ffe <argfd+0x60>
    80004fc8:	ffffd097          	auipc	ra,0xffffd
    80004fcc:	9dc080e7          	jalr	-1572(ra) # 800019a4 <myproc>
    80004fd0:	fdc42703          	lw	a4,-36(s0)
    80004fd4:	01a70793          	add	a5,a4,26
    80004fd8:	078e                	sll	a5,a5,0x3
    80004fda:	953e                	add	a0,a0,a5
    80004fdc:	611c                	ld	a5,0(a0)
    80004fde:	c395                	beqz	a5,80005002 <argfd+0x64>
    return -1;
  if(pfd)
    80004fe0:	00090463          	beqz	s2,80004fe8 <argfd+0x4a>
    *pfd = fd;
    80004fe4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004fe8:	4501                	li	a0,0
  if(pf)
    80004fea:	c091                	beqz	s1,80004fee <argfd+0x50>
    *pf = f;
    80004fec:	e09c                	sd	a5,0(s1)
}
    80004fee:	70a2                	ld	ra,40(sp)
    80004ff0:	7402                	ld	s0,32(sp)
    80004ff2:	64e2                	ld	s1,24(sp)
    80004ff4:	6942                	ld	s2,16(sp)
    80004ff6:	6145                	add	sp,sp,48
    80004ff8:	8082                	ret
    return -1;
    80004ffa:	557d                	li	a0,-1
    80004ffc:	bfcd                	j	80004fee <argfd+0x50>
    return -1;
    80004ffe:	557d                	li	a0,-1
    80005000:	b7fd                	j	80004fee <argfd+0x50>
    80005002:	557d                	li	a0,-1
    80005004:	b7ed                	j	80004fee <argfd+0x50>

0000000080005006 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005006:	1101                	add	sp,sp,-32
    80005008:	ec06                	sd	ra,24(sp)
    8000500a:	e822                	sd	s0,16(sp)
    8000500c:	e426                	sd	s1,8(sp)
    8000500e:	1000                	add	s0,sp,32
    80005010:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005012:	ffffd097          	auipc	ra,0xffffd
    80005016:	992080e7          	jalr	-1646(ra) # 800019a4 <myproc>
    8000501a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000501c:	0d050793          	add	a5,a0,208
    80005020:	4501                	li	a0,0
    80005022:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005024:	6398                	ld	a4,0(a5)
    80005026:	cb19                	beqz	a4,8000503c <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005028:	2505                	addw	a0,a0,1
    8000502a:	07a1                	add	a5,a5,8
    8000502c:	fed51ce3          	bne	a0,a3,80005024 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005030:	557d                	li	a0,-1
}
    80005032:	60e2                	ld	ra,24(sp)
    80005034:	6442                	ld	s0,16(sp)
    80005036:	64a2                	ld	s1,8(sp)
    80005038:	6105                	add	sp,sp,32
    8000503a:	8082                	ret
      p->ofile[fd] = f;
    8000503c:	01a50793          	add	a5,a0,26
    80005040:	078e                	sll	a5,a5,0x3
    80005042:	963e                	add	a2,a2,a5
    80005044:	e204                	sd	s1,0(a2)
      return fd;
    80005046:	b7f5                	j	80005032 <fdalloc+0x2c>

0000000080005048 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005048:	715d                	add	sp,sp,-80
    8000504a:	e486                	sd	ra,72(sp)
    8000504c:	e0a2                	sd	s0,64(sp)
    8000504e:	fc26                	sd	s1,56(sp)
    80005050:	f84a                	sd	s2,48(sp)
    80005052:	f44e                	sd	s3,40(sp)
    80005054:	f052                	sd	s4,32(sp)
    80005056:	ec56                	sd	s5,24(sp)
    80005058:	0880                	add	s0,sp,80
    8000505a:	8aae                	mv	s5,a1
    8000505c:	8a32                	mv	s4,a2
    8000505e:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005060:	fb040593          	add	a1,s0,-80
    80005064:	fffff097          	auipc	ra,0xfffff
    80005068:	eae080e7          	jalr	-338(ra) # 80003f12 <nameiparent>
    8000506c:	892a                	mv	s2,a0
    8000506e:	12050c63          	beqz	a0,800051a6 <create+0x15e>
    return 0;

  ilock(dp);
    80005072:	ffffe097          	auipc	ra,0xffffe
    80005076:	624080e7          	jalr	1572(ra) # 80003696 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000507a:	4601                	li	a2,0
    8000507c:	fb040593          	add	a1,s0,-80
    80005080:	854a                	mv	a0,s2
    80005082:	fffff097          	auipc	ra,0xfffff
    80005086:	ba0080e7          	jalr	-1120(ra) # 80003c22 <dirlookup>
    8000508a:	84aa                	mv	s1,a0
    8000508c:	c539                	beqz	a0,800050da <create+0x92>
    iunlockput(dp);
    8000508e:	854a                	mv	a0,s2
    80005090:	fffff097          	auipc	ra,0xfffff
    80005094:	90e080e7          	jalr	-1778(ra) # 8000399e <iunlockput>
    ilock(ip);
    80005098:	8526                	mv	a0,s1
    8000509a:	ffffe097          	auipc	ra,0xffffe
    8000509e:	5fc080e7          	jalr	1532(ra) # 80003696 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800050a2:	4789                	li	a5,2
    800050a4:	02fa9463          	bne	s5,a5,800050cc <create+0x84>
    800050a8:	0444d783          	lhu	a5,68(s1)
    800050ac:	37f9                	addw	a5,a5,-2
    800050ae:	17c2                	sll	a5,a5,0x30
    800050b0:	93c1                	srl	a5,a5,0x30
    800050b2:	4705                	li	a4,1
    800050b4:	00f76c63          	bltu	a4,a5,800050cc <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800050b8:	8526                	mv	a0,s1
    800050ba:	60a6                	ld	ra,72(sp)
    800050bc:	6406                	ld	s0,64(sp)
    800050be:	74e2                	ld	s1,56(sp)
    800050c0:	7942                	ld	s2,48(sp)
    800050c2:	79a2                	ld	s3,40(sp)
    800050c4:	7a02                	ld	s4,32(sp)
    800050c6:	6ae2                	ld	s5,24(sp)
    800050c8:	6161                	add	sp,sp,80
    800050ca:	8082                	ret
    iunlockput(ip);
    800050cc:	8526                	mv	a0,s1
    800050ce:	fffff097          	auipc	ra,0xfffff
    800050d2:	8d0080e7          	jalr	-1840(ra) # 8000399e <iunlockput>
    return 0;
    800050d6:	4481                	li	s1,0
    800050d8:	b7c5                	j	800050b8 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    800050da:	85d6                	mv	a1,s5
    800050dc:	00092503          	lw	a0,0(s2)
    800050e0:	ffffe097          	auipc	ra,0xffffe
    800050e4:	422080e7          	jalr	1058(ra) # 80003502 <ialloc>
    800050e8:	84aa                	mv	s1,a0
    800050ea:	c139                	beqz	a0,80005130 <create+0xe8>
  ilock(ip);
    800050ec:	ffffe097          	auipc	ra,0xffffe
    800050f0:	5aa080e7          	jalr	1450(ra) # 80003696 <ilock>
  ip->major = major;
    800050f4:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    800050f8:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    800050fc:	4985                	li	s3,1
    800050fe:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    80005102:	8526                	mv	a0,s1
    80005104:	ffffe097          	auipc	ra,0xffffe
    80005108:	4c6080e7          	jalr	1222(ra) # 800035ca <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000510c:	033a8a63          	beq	s5,s3,80005140 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    80005110:	40d0                	lw	a2,4(s1)
    80005112:	fb040593          	add	a1,s0,-80
    80005116:	854a                	mv	a0,s2
    80005118:	fffff097          	auipc	ra,0xfffff
    8000511c:	d1a080e7          	jalr	-742(ra) # 80003e32 <dirlink>
    80005120:	06054b63          	bltz	a0,80005196 <create+0x14e>
  iunlockput(dp);
    80005124:	854a                	mv	a0,s2
    80005126:	fffff097          	auipc	ra,0xfffff
    8000512a:	878080e7          	jalr	-1928(ra) # 8000399e <iunlockput>
  return ip;
    8000512e:	b769                	j	800050b8 <create+0x70>
    panic("create: ialloc");
    80005130:	00003517          	auipc	a0,0x3
    80005134:	59850513          	add	a0,a0,1432 # 800086c8 <syscalls+0x2a8>
    80005138:	ffffb097          	auipc	ra,0xffffb
    8000513c:	3f0080e7          	jalr	1008(ra) # 80000528 <panic>
    dp->nlink++;  // for ".."
    80005140:	04a95783          	lhu	a5,74(s2)
    80005144:	2785                	addw	a5,a5,1
    80005146:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000514a:	854a                	mv	a0,s2
    8000514c:	ffffe097          	auipc	ra,0xffffe
    80005150:	47e080e7          	jalr	1150(ra) # 800035ca <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005154:	40d0                	lw	a2,4(s1)
    80005156:	00003597          	auipc	a1,0x3
    8000515a:	58258593          	add	a1,a1,1410 # 800086d8 <syscalls+0x2b8>
    8000515e:	8526                	mv	a0,s1
    80005160:	fffff097          	auipc	ra,0xfffff
    80005164:	cd2080e7          	jalr	-814(ra) # 80003e32 <dirlink>
    80005168:	00054f63          	bltz	a0,80005186 <create+0x13e>
    8000516c:	00492603          	lw	a2,4(s2)
    80005170:	00003597          	auipc	a1,0x3
    80005174:	57058593          	add	a1,a1,1392 # 800086e0 <syscalls+0x2c0>
    80005178:	8526                	mv	a0,s1
    8000517a:	fffff097          	auipc	ra,0xfffff
    8000517e:	cb8080e7          	jalr	-840(ra) # 80003e32 <dirlink>
    80005182:	f80557e3          	bgez	a0,80005110 <create+0xc8>
      panic("create dots");
    80005186:	00003517          	auipc	a0,0x3
    8000518a:	56250513          	add	a0,a0,1378 # 800086e8 <syscalls+0x2c8>
    8000518e:	ffffb097          	auipc	ra,0xffffb
    80005192:	39a080e7          	jalr	922(ra) # 80000528 <panic>
    panic("create: dirlink");
    80005196:	00003517          	auipc	a0,0x3
    8000519a:	56250513          	add	a0,a0,1378 # 800086f8 <syscalls+0x2d8>
    8000519e:	ffffb097          	auipc	ra,0xffffb
    800051a2:	38a080e7          	jalr	906(ra) # 80000528 <panic>
    return 0;
    800051a6:	84aa                	mv	s1,a0
    800051a8:	bf01                	j	800050b8 <create+0x70>

00000000800051aa <sys_dup>:
{
    800051aa:	7179                	add	sp,sp,-48
    800051ac:	f406                	sd	ra,40(sp)
    800051ae:	f022                	sd	s0,32(sp)
    800051b0:	ec26                	sd	s1,24(sp)
    800051b2:	e84a                	sd	s2,16(sp)
    800051b4:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800051b6:	fd840613          	add	a2,s0,-40
    800051ba:	4581                	li	a1,0
    800051bc:	4501                	li	a0,0
    800051be:	00000097          	auipc	ra,0x0
    800051c2:	de0080e7          	jalr	-544(ra) # 80004f9e <argfd>
    return -1;
    800051c6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800051c8:	02054363          	bltz	a0,800051ee <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800051cc:	fd843903          	ld	s2,-40(s0)
    800051d0:	854a                	mv	a0,s2
    800051d2:	00000097          	auipc	ra,0x0
    800051d6:	e34080e7          	jalr	-460(ra) # 80005006 <fdalloc>
    800051da:	84aa                	mv	s1,a0
    return -1;
    800051dc:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800051de:	00054863          	bltz	a0,800051ee <sys_dup+0x44>
  filedup(f);
    800051e2:	854a                	mv	a0,s2
    800051e4:	fffff097          	auipc	ra,0xfffff
    800051e8:	38a080e7          	jalr	906(ra) # 8000456e <filedup>
  return fd;
    800051ec:	87a6                	mv	a5,s1
}
    800051ee:	853e                	mv	a0,a5
    800051f0:	70a2                	ld	ra,40(sp)
    800051f2:	7402                	ld	s0,32(sp)
    800051f4:	64e2                	ld	s1,24(sp)
    800051f6:	6942                	ld	s2,16(sp)
    800051f8:	6145                	add	sp,sp,48
    800051fa:	8082                	ret

00000000800051fc <sys_read>:
{
    800051fc:	7179                	add	sp,sp,-48
    800051fe:	f406                	sd	ra,40(sp)
    80005200:	f022                	sd	s0,32(sp)
    80005202:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005204:	fe840613          	add	a2,s0,-24
    80005208:	4581                	li	a1,0
    8000520a:	4501                	li	a0,0
    8000520c:	00000097          	auipc	ra,0x0
    80005210:	d92080e7          	jalr	-622(ra) # 80004f9e <argfd>
    return -1;
    80005214:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005216:	04054163          	bltz	a0,80005258 <sys_read+0x5c>
    8000521a:	fe440593          	add	a1,s0,-28
    8000521e:	4509                	li	a0,2
    80005220:	ffffe097          	auipc	ra,0xffffe
    80005224:	846080e7          	jalr	-1978(ra) # 80002a66 <argint>
    return -1;
    80005228:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000522a:	02054763          	bltz	a0,80005258 <sys_read+0x5c>
    8000522e:	fd840593          	add	a1,s0,-40
    80005232:	4505                	li	a0,1
    80005234:	ffffe097          	auipc	ra,0xffffe
    80005238:	854080e7          	jalr	-1964(ra) # 80002a88 <argaddr>
    return -1;
    8000523c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000523e:	00054d63          	bltz	a0,80005258 <sys_read+0x5c>
  return fileread(f, p, n);
    80005242:	fe442603          	lw	a2,-28(s0)
    80005246:	fd843583          	ld	a1,-40(s0)
    8000524a:	fe843503          	ld	a0,-24(s0)
    8000524e:	fffff097          	auipc	ra,0xfffff
    80005252:	4ac080e7          	jalr	1196(ra) # 800046fa <fileread>
    80005256:	87aa                	mv	a5,a0
}
    80005258:	853e                	mv	a0,a5
    8000525a:	70a2                	ld	ra,40(sp)
    8000525c:	7402                	ld	s0,32(sp)
    8000525e:	6145                	add	sp,sp,48
    80005260:	8082                	ret

0000000080005262 <sys_write>:
{
    80005262:	7179                	add	sp,sp,-48
    80005264:	f406                	sd	ra,40(sp)
    80005266:	f022                	sd	s0,32(sp)
    80005268:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000526a:	fe840613          	add	a2,s0,-24
    8000526e:	4581                	li	a1,0
    80005270:	4501                	li	a0,0
    80005272:	00000097          	auipc	ra,0x0
    80005276:	d2c080e7          	jalr	-724(ra) # 80004f9e <argfd>
    return -1;
    8000527a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000527c:	04054163          	bltz	a0,800052be <sys_write+0x5c>
    80005280:	fe440593          	add	a1,s0,-28
    80005284:	4509                	li	a0,2
    80005286:	ffffd097          	auipc	ra,0xffffd
    8000528a:	7e0080e7          	jalr	2016(ra) # 80002a66 <argint>
    return -1;
    8000528e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005290:	02054763          	bltz	a0,800052be <sys_write+0x5c>
    80005294:	fd840593          	add	a1,s0,-40
    80005298:	4505                	li	a0,1
    8000529a:	ffffd097          	auipc	ra,0xffffd
    8000529e:	7ee080e7          	jalr	2030(ra) # 80002a88 <argaddr>
    return -1;
    800052a2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052a4:	00054d63          	bltz	a0,800052be <sys_write+0x5c>
  return filewrite(f, p, n);
    800052a8:	fe442603          	lw	a2,-28(s0)
    800052ac:	fd843583          	ld	a1,-40(s0)
    800052b0:	fe843503          	ld	a0,-24(s0)
    800052b4:	fffff097          	auipc	ra,0xfffff
    800052b8:	508080e7          	jalr	1288(ra) # 800047bc <filewrite>
    800052bc:	87aa                	mv	a5,a0
}
    800052be:	853e                	mv	a0,a5
    800052c0:	70a2                	ld	ra,40(sp)
    800052c2:	7402                	ld	s0,32(sp)
    800052c4:	6145                	add	sp,sp,48
    800052c6:	8082                	ret

00000000800052c8 <sys_close>:
{
    800052c8:	1101                	add	sp,sp,-32
    800052ca:	ec06                	sd	ra,24(sp)
    800052cc:	e822                	sd	s0,16(sp)
    800052ce:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800052d0:	fe040613          	add	a2,s0,-32
    800052d4:	fec40593          	add	a1,s0,-20
    800052d8:	4501                	li	a0,0
    800052da:	00000097          	auipc	ra,0x0
    800052de:	cc4080e7          	jalr	-828(ra) # 80004f9e <argfd>
    return -1;
    800052e2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800052e4:	02054463          	bltz	a0,8000530c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800052e8:	ffffc097          	auipc	ra,0xffffc
    800052ec:	6bc080e7          	jalr	1724(ra) # 800019a4 <myproc>
    800052f0:	fec42783          	lw	a5,-20(s0)
    800052f4:	07e9                	add	a5,a5,26
    800052f6:	078e                	sll	a5,a5,0x3
    800052f8:	953e                	add	a0,a0,a5
    800052fa:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800052fe:	fe043503          	ld	a0,-32(s0)
    80005302:	fffff097          	auipc	ra,0xfffff
    80005306:	2be080e7          	jalr	702(ra) # 800045c0 <fileclose>
  return 0;
    8000530a:	4781                	li	a5,0
}
    8000530c:	853e                	mv	a0,a5
    8000530e:	60e2                	ld	ra,24(sp)
    80005310:	6442                	ld	s0,16(sp)
    80005312:	6105                	add	sp,sp,32
    80005314:	8082                	ret

0000000080005316 <sys_fstat>:
{
    80005316:	1101                	add	sp,sp,-32
    80005318:	ec06                	sd	ra,24(sp)
    8000531a:	e822                	sd	s0,16(sp)
    8000531c:	1000                	add	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000531e:	fe840613          	add	a2,s0,-24
    80005322:	4581                	li	a1,0
    80005324:	4501                	li	a0,0
    80005326:	00000097          	auipc	ra,0x0
    8000532a:	c78080e7          	jalr	-904(ra) # 80004f9e <argfd>
    return -1;
    8000532e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005330:	02054563          	bltz	a0,8000535a <sys_fstat+0x44>
    80005334:	fe040593          	add	a1,s0,-32
    80005338:	4505                	li	a0,1
    8000533a:	ffffd097          	auipc	ra,0xffffd
    8000533e:	74e080e7          	jalr	1870(ra) # 80002a88 <argaddr>
    return -1;
    80005342:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005344:	00054b63          	bltz	a0,8000535a <sys_fstat+0x44>
  return filestat(f, st);
    80005348:	fe043583          	ld	a1,-32(s0)
    8000534c:	fe843503          	ld	a0,-24(s0)
    80005350:	fffff097          	auipc	ra,0xfffff
    80005354:	338080e7          	jalr	824(ra) # 80004688 <filestat>
    80005358:	87aa                	mv	a5,a0
}
    8000535a:	853e                	mv	a0,a5
    8000535c:	60e2                	ld	ra,24(sp)
    8000535e:	6442                	ld	s0,16(sp)
    80005360:	6105                	add	sp,sp,32
    80005362:	8082                	ret

0000000080005364 <sys_link>:
{
    80005364:	7169                	add	sp,sp,-304
    80005366:	f606                	sd	ra,296(sp)
    80005368:	f222                	sd	s0,288(sp)
    8000536a:	ee26                	sd	s1,280(sp)
    8000536c:	ea4a                	sd	s2,272(sp)
    8000536e:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005370:	08000613          	li	a2,128
    80005374:	ed040593          	add	a1,s0,-304
    80005378:	4501                	li	a0,0
    8000537a:	ffffd097          	auipc	ra,0xffffd
    8000537e:	730080e7          	jalr	1840(ra) # 80002aaa <argstr>
    return -1;
    80005382:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005384:	10054e63          	bltz	a0,800054a0 <sys_link+0x13c>
    80005388:	08000613          	li	a2,128
    8000538c:	f5040593          	add	a1,s0,-176
    80005390:	4505                	li	a0,1
    80005392:	ffffd097          	auipc	ra,0xffffd
    80005396:	718080e7          	jalr	1816(ra) # 80002aaa <argstr>
    return -1;
    8000539a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000539c:	10054263          	bltz	a0,800054a0 <sys_link+0x13c>
  begin_op();
    800053a0:	fffff097          	auipc	ra,0xfffff
    800053a4:	d54080e7          	jalr	-684(ra) # 800040f4 <begin_op>
  if((ip = namei(old)) == 0){
    800053a8:	ed040513          	add	a0,s0,-304
    800053ac:	fffff097          	auipc	ra,0xfffff
    800053b0:	b48080e7          	jalr	-1208(ra) # 80003ef4 <namei>
    800053b4:	84aa                	mv	s1,a0
    800053b6:	c551                	beqz	a0,80005442 <sys_link+0xde>
  ilock(ip);
    800053b8:	ffffe097          	auipc	ra,0xffffe
    800053bc:	2de080e7          	jalr	734(ra) # 80003696 <ilock>
  if(ip->type == T_DIR){
    800053c0:	04449703          	lh	a4,68(s1)
    800053c4:	4785                	li	a5,1
    800053c6:	08f70463          	beq	a4,a5,8000544e <sys_link+0xea>
  ip->nlink++;
    800053ca:	04a4d783          	lhu	a5,74(s1)
    800053ce:	2785                	addw	a5,a5,1
    800053d0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800053d4:	8526                	mv	a0,s1
    800053d6:	ffffe097          	auipc	ra,0xffffe
    800053da:	1f4080e7          	jalr	500(ra) # 800035ca <iupdate>
  iunlock(ip);
    800053de:	8526                	mv	a0,s1
    800053e0:	ffffe097          	auipc	ra,0xffffe
    800053e4:	378080e7          	jalr	888(ra) # 80003758 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800053e8:	fd040593          	add	a1,s0,-48
    800053ec:	f5040513          	add	a0,s0,-176
    800053f0:	fffff097          	auipc	ra,0xfffff
    800053f4:	b22080e7          	jalr	-1246(ra) # 80003f12 <nameiparent>
    800053f8:	892a                	mv	s2,a0
    800053fa:	c935                	beqz	a0,8000546e <sys_link+0x10a>
  ilock(dp);
    800053fc:	ffffe097          	auipc	ra,0xffffe
    80005400:	29a080e7          	jalr	666(ra) # 80003696 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005404:	00092703          	lw	a4,0(s2)
    80005408:	409c                	lw	a5,0(s1)
    8000540a:	04f71d63          	bne	a4,a5,80005464 <sys_link+0x100>
    8000540e:	40d0                	lw	a2,4(s1)
    80005410:	fd040593          	add	a1,s0,-48
    80005414:	854a                	mv	a0,s2
    80005416:	fffff097          	auipc	ra,0xfffff
    8000541a:	a1c080e7          	jalr	-1508(ra) # 80003e32 <dirlink>
    8000541e:	04054363          	bltz	a0,80005464 <sys_link+0x100>
  iunlockput(dp);
    80005422:	854a                	mv	a0,s2
    80005424:	ffffe097          	auipc	ra,0xffffe
    80005428:	57a080e7          	jalr	1402(ra) # 8000399e <iunlockput>
  iput(ip);
    8000542c:	8526                	mv	a0,s1
    8000542e:	ffffe097          	auipc	ra,0xffffe
    80005432:	4c8080e7          	jalr	1224(ra) # 800038f6 <iput>
  end_op();
    80005436:	fffff097          	auipc	ra,0xfffff
    8000543a:	d38080e7          	jalr	-712(ra) # 8000416e <end_op>
  return 0;
    8000543e:	4781                	li	a5,0
    80005440:	a085                	j	800054a0 <sys_link+0x13c>
    end_op();
    80005442:	fffff097          	auipc	ra,0xfffff
    80005446:	d2c080e7          	jalr	-724(ra) # 8000416e <end_op>
    return -1;
    8000544a:	57fd                	li	a5,-1
    8000544c:	a891                	j	800054a0 <sys_link+0x13c>
    iunlockput(ip);
    8000544e:	8526                	mv	a0,s1
    80005450:	ffffe097          	auipc	ra,0xffffe
    80005454:	54e080e7          	jalr	1358(ra) # 8000399e <iunlockput>
    end_op();
    80005458:	fffff097          	auipc	ra,0xfffff
    8000545c:	d16080e7          	jalr	-746(ra) # 8000416e <end_op>
    return -1;
    80005460:	57fd                	li	a5,-1
    80005462:	a83d                	j	800054a0 <sys_link+0x13c>
    iunlockput(dp);
    80005464:	854a                	mv	a0,s2
    80005466:	ffffe097          	auipc	ra,0xffffe
    8000546a:	538080e7          	jalr	1336(ra) # 8000399e <iunlockput>
  ilock(ip);
    8000546e:	8526                	mv	a0,s1
    80005470:	ffffe097          	auipc	ra,0xffffe
    80005474:	226080e7          	jalr	550(ra) # 80003696 <ilock>
  ip->nlink--;
    80005478:	04a4d783          	lhu	a5,74(s1)
    8000547c:	37fd                	addw	a5,a5,-1
    8000547e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005482:	8526                	mv	a0,s1
    80005484:	ffffe097          	auipc	ra,0xffffe
    80005488:	146080e7          	jalr	326(ra) # 800035ca <iupdate>
  iunlockput(ip);
    8000548c:	8526                	mv	a0,s1
    8000548e:	ffffe097          	auipc	ra,0xffffe
    80005492:	510080e7          	jalr	1296(ra) # 8000399e <iunlockput>
  end_op();
    80005496:	fffff097          	auipc	ra,0xfffff
    8000549a:	cd8080e7          	jalr	-808(ra) # 8000416e <end_op>
  return -1;
    8000549e:	57fd                	li	a5,-1
}
    800054a0:	853e                	mv	a0,a5
    800054a2:	70b2                	ld	ra,296(sp)
    800054a4:	7412                	ld	s0,288(sp)
    800054a6:	64f2                	ld	s1,280(sp)
    800054a8:	6952                	ld	s2,272(sp)
    800054aa:	6155                	add	sp,sp,304
    800054ac:	8082                	ret

00000000800054ae <sys_unlink>:
{
    800054ae:	7151                	add	sp,sp,-240
    800054b0:	f586                	sd	ra,232(sp)
    800054b2:	f1a2                	sd	s0,224(sp)
    800054b4:	eda6                	sd	s1,216(sp)
    800054b6:	e9ca                	sd	s2,208(sp)
    800054b8:	e5ce                	sd	s3,200(sp)
    800054ba:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800054bc:	08000613          	li	a2,128
    800054c0:	f3040593          	add	a1,s0,-208
    800054c4:	4501                	li	a0,0
    800054c6:	ffffd097          	auipc	ra,0xffffd
    800054ca:	5e4080e7          	jalr	1508(ra) # 80002aaa <argstr>
    800054ce:	18054163          	bltz	a0,80005650 <sys_unlink+0x1a2>
  begin_op();
    800054d2:	fffff097          	auipc	ra,0xfffff
    800054d6:	c22080e7          	jalr	-990(ra) # 800040f4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800054da:	fb040593          	add	a1,s0,-80
    800054de:	f3040513          	add	a0,s0,-208
    800054e2:	fffff097          	auipc	ra,0xfffff
    800054e6:	a30080e7          	jalr	-1488(ra) # 80003f12 <nameiparent>
    800054ea:	84aa                	mv	s1,a0
    800054ec:	c979                	beqz	a0,800055c2 <sys_unlink+0x114>
  ilock(dp);
    800054ee:	ffffe097          	auipc	ra,0xffffe
    800054f2:	1a8080e7          	jalr	424(ra) # 80003696 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800054f6:	00003597          	auipc	a1,0x3
    800054fa:	1e258593          	add	a1,a1,482 # 800086d8 <syscalls+0x2b8>
    800054fe:	fb040513          	add	a0,s0,-80
    80005502:	ffffe097          	auipc	ra,0xffffe
    80005506:	706080e7          	jalr	1798(ra) # 80003c08 <namecmp>
    8000550a:	14050a63          	beqz	a0,8000565e <sys_unlink+0x1b0>
    8000550e:	00003597          	auipc	a1,0x3
    80005512:	1d258593          	add	a1,a1,466 # 800086e0 <syscalls+0x2c0>
    80005516:	fb040513          	add	a0,s0,-80
    8000551a:	ffffe097          	auipc	ra,0xffffe
    8000551e:	6ee080e7          	jalr	1774(ra) # 80003c08 <namecmp>
    80005522:	12050e63          	beqz	a0,8000565e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005526:	f2c40613          	add	a2,s0,-212
    8000552a:	fb040593          	add	a1,s0,-80
    8000552e:	8526                	mv	a0,s1
    80005530:	ffffe097          	auipc	ra,0xffffe
    80005534:	6f2080e7          	jalr	1778(ra) # 80003c22 <dirlookup>
    80005538:	892a                	mv	s2,a0
    8000553a:	12050263          	beqz	a0,8000565e <sys_unlink+0x1b0>
  ilock(ip);
    8000553e:	ffffe097          	auipc	ra,0xffffe
    80005542:	158080e7          	jalr	344(ra) # 80003696 <ilock>
  if(ip->nlink < 1)
    80005546:	04a91783          	lh	a5,74(s2)
    8000554a:	08f05263          	blez	a5,800055ce <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000554e:	04491703          	lh	a4,68(s2)
    80005552:	4785                	li	a5,1
    80005554:	08f70563          	beq	a4,a5,800055de <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005558:	4641                	li	a2,16
    8000555a:	4581                	li	a1,0
    8000555c:	fc040513          	add	a0,s0,-64
    80005560:	ffffb097          	auipc	ra,0xffffb
    80005564:	75a080e7          	jalr	1882(ra) # 80000cba <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005568:	4741                	li	a4,16
    8000556a:	f2c42683          	lw	a3,-212(s0)
    8000556e:	fc040613          	add	a2,s0,-64
    80005572:	4581                	li	a1,0
    80005574:	8526                	mv	a0,s1
    80005576:	ffffe097          	auipc	ra,0xffffe
    8000557a:	572080e7          	jalr	1394(ra) # 80003ae8 <writei>
    8000557e:	47c1                	li	a5,16
    80005580:	0af51563          	bne	a0,a5,8000562a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005584:	04491703          	lh	a4,68(s2)
    80005588:	4785                	li	a5,1
    8000558a:	0af70863          	beq	a4,a5,8000563a <sys_unlink+0x18c>
  iunlockput(dp);
    8000558e:	8526                	mv	a0,s1
    80005590:	ffffe097          	auipc	ra,0xffffe
    80005594:	40e080e7          	jalr	1038(ra) # 8000399e <iunlockput>
  ip->nlink--;
    80005598:	04a95783          	lhu	a5,74(s2)
    8000559c:	37fd                	addw	a5,a5,-1
    8000559e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800055a2:	854a                	mv	a0,s2
    800055a4:	ffffe097          	auipc	ra,0xffffe
    800055a8:	026080e7          	jalr	38(ra) # 800035ca <iupdate>
  iunlockput(ip);
    800055ac:	854a                	mv	a0,s2
    800055ae:	ffffe097          	auipc	ra,0xffffe
    800055b2:	3f0080e7          	jalr	1008(ra) # 8000399e <iunlockput>
  end_op();
    800055b6:	fffff097          	auipc	ra,0xfffff
    800055ba:	bb8080e7          	jalr	-1096(ra) # 8000416e <end_op>
  return 0;
    800055be:	4501                	li	a0,0
    800055c0:	a84d                	j	80005672 <sys_unlink+0x1c4>
    end_op();
    800055c2:	fffff097          	auipc	ra,0xfffff
    800055c6:	bac080e7          	jalr	-1108(ra) # 8000416e <end_op>
    return -1;
    800055ca:	557d                	li	a0,-1
    800055cc:	a05d                	j	80005672 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800055ce:	00003517          	auipc	a0,0x3
    800055d2:	13a50513          	add	a0,a0,314 # 80008708 <syscalls+0x2e8>
    800055d6:	ffffb097          	auipc	ra,0xffffb
    800055da:	f52080e7          	jalr	-174(ra) # 80000528 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800055de:	04c92703          	lw	a4,76(s2)
    800055e2:	02000793          	li	a5,32
    800055e6:	f6e7f9e3          	bgeu	a5,a4,80005558 <sys_unlink+0xaa>
    800055ea:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800055ee:	4741                	li	a4,16
    800055f0:	86ce                	mv	a3,s3
    800055f2:	f1840613          	add	a2,s0,-232
    800055f6:	4581                	li	a1,0
    800055f8:	854a                	mv	a0,s2
    800055fa:	ffffe097          	auipc	ra,0xffffe
    800055fe:	3f6080e7          	jalr	1014(ra) # 800039f0 <readi>
    80005602:	47c1                	li	a5,16
    80005604:	00f51b63          	bne	a0,a5,8000561a <sys_unlink+0x16c>
    if(de.inum != 0)
    80005608:	f1845783          	lhu	a5,-232(s0)
    8000560c:	e7a1                	bnez	a5,80005654 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000560e:	29c1                	addw	s3,s3,16
    80005610:	04c92783          	lw	a5,76(s2)
    80005614:	fcf9ede3          	bltu	s3,a5,800055ee <sys_unlink+0x140>
    80005618:	b781                	j	80005558 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    8000561a:	00003517          	auipc	a0,0x3
    8000561e:	10650513          	add	a0,a0,262 # 80008720 <syscalls+0x300>
    80005622:	ffffb097          	auipc	ra,0xffffb
    80005626:	f06080e7          	jalr	-250(ra) # 80000528 <panic>
    panic("unlink: writei");
    8000562a:	00003517          	auipc	a0,0x3
    8000562e:	10e50513          	add	a0,a0,270 # 80008738 <syscalls+0x318>
    80005632:	ffffb097          	auipc	ra,0xffffb
    80005636:	ef6080e7          	jalr	-266(ra) # 80000528 <panic>
    dp->nlink--;
    8000563a:	04a4d783          	lhu	a5,74(s1)
    8000563e:	37fd                	addw	a5,a5,-1
    80005640:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005644:	8526                	mv	a0,s1
    80005646:	ffffe097          	auipc	ra,0xffffe
    8000564a:	f84080e7          	jalr	-124(ra) # 800035ca <iupdate>
    8000564e:	b781                	j	8000558e <sys_unlink+0xe0>
    return -1;
    80005650:	557d                	li	a0,-1
    80005652:	a005                	j	80005672 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005654:	854a                	mv	a0,s2
    80005656:	ffffe097          	auipc	ra,0xffffe
    8000565a:	348080e7          	jalr	840(ra) # 8000399e <iunlockput>
  iunlockput(dp);
    8000565e:	8526                	mv	a0,s1
    80005660:	ffffe097          	auipc	ra,0xffffe
    80005664:	33e080e7          	jalr	830(ra) # 8000399e <iunlockput>
  end_op();
    80005668:	fffff097          	auipc	ra,0xfffff
    8000566c:	b06080e7          	jalr	-1274(ra) # 8000416e <end_op>
  return -1;
    80005670:	557d                	li	a0,-1
}
    80005672:	70ae                	ld	ra,232(sp)
    80005674:	740e                	ld	s0,224(sp)
    80005676:	64ee                	ld	s1,216(sp)
    80005678:	694e                	ld	s2,208(sp)
    8000567a:	69ae                	ld	s3,200(sp)
    8000567c:	616d                	add	sp,sp,240
    8000567e:	8082                	ret

0000000080005680 <sys_open>:

uint64
sys_open(void)
{
    80005680:	7129                	add	sp,sp,-320
    80005682:	fe06                	sd	ra,312(sp)
    80005684:	fa22                	sd	s0,304(sp)
    80005686:	f626                	sd	s1,296(sp)
    80005688:	f24a                	sd	s2,288(sp)
    8000568a:	ee4e                	sd	s3,280(sp)
    8000568c:	0280                	add	s0,sp,320
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000568e:	08000613          	li	a2,128
    80005692:	f5040593          	add	a1,s0,-176
    80005696:	4501                	li	a0,0
    80005698:	ffffd097          	auipc	ra,0xffffd
    8000569c:	412080e7          	jalr	1042(ra) # 80002aaa <argstr>
    return -1;
    800056a0:	597d                	li	s2,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800056a2:	0c054163          	bltz	a0,80005764 <sys_open+0xe4>
    800056a6:	f4c40593          	add	a1,s0,-180
    800056aa:	4505                	li	a0,1
    800056ac:	ffffd097          	auipc	ra,0xffffd
    800056b0:	3ba080e7          	jalr	954(ra) # 80002a66 <argint>
    800056b4:	0a054863          	bltz	a0,80005764 <sys_open+0xe4>

  begin_op();
    800056b8:	fffff097          	auipc	ra,0xfffff
    800056bc:	a3c080e7          	jalr	-1476(ra) # 800040f4 <begin_op>

  if(omode & O_CREATE){
    800056c0:	f4c42783          	lw	a5,-180(s0)
    800056c4:	2007f793          	and	a5,a5,512
    800056c8:	cbdd                	beqz	a5,8000577e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    800056ca:	4681                	li	a3,0
    800056cc:	4601                	li	a2,0
    800056ce:	4589                	li	a1,2
    800056d0:	f5040513          	add	a0,s0,-176
    800056d4:	00000097          	auipc	ra,0x0
    800056d8:	974080e7          	jalr	-1676(ra) # 80005048 <create>
    800056dc:	84aa                	mv	s1,a0
    if(ip == 0){
    800056de:	c959                	beqz	a0,80005774 <sys_open+0xf4>
        return -1;
      }
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800056e0:	04449703          	lh	a4,68(s1)
    800056e4:	478d                	li	a5,3
    800056e6:	00f71763          	bne	a4,a5,800056f4 <sys_open+0x74>
    800056ea:	0464d703          	lhu	a4,70(s1)
    800056ee:	47a5                	li	a5,9
    800056f0:	16e7e863          	bltu	a5,a4,80005860 <sys_open+0x1e0>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800056f4:	fffff097          	auipc	ra,0xfffff
    800056f8:	e10080e7          	jalr	-496(ra) # 80004504 <filealloc>
    800056fc:	89aa                	mv	s3,a0
    800056fe:	18050163          	beqz	a0,80005880 <sys_open+0x200>
    80005702:	00000097          	auipc	ra,0x0
    80005706:	904080e7          	jalr	-1788(ra) # 80005006 <fdalloc>
    8000570a:	892a                	mv	s2,a0
    8000570c:	16054563          	bltz	a0,80005876 <sys_open+0x1f6>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005710:	04449703          	lh	a4,68(s1)
    80005714:	478d                	li	a5,3
    80005716:	18f70063          	beq	a4,a5,80005896 <sys_open+0x216>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000571a:	4789                	li	a5,2
    8000571c:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005720:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005724:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005728:	f4c42783          	lw	a5,-180(s0)
    8000572c:	0017c713          	xor	a4,a5,1
    80005730:	8b05                	and	a4,a4,1
    80005732:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005736:	0037f713          	and	a4,a5,3
    8000573a:	00e03733          	snez	a4,a4
    8000573e:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005742:	4007f793          	and	a5,a5,1024
    80005746:	c791                	beqz	a5,80005752 <sys_open+0xd2>
    80005748:	04449703          	lh	a4,68(s1)
    8000574c:	4789                	li	a5,2
    8000574e:	14f70b63          	beq	a4,a5,800058a4 <sys_open+0x224>
    itrunc(ip);
  }

  iunlock(ip);
    80005752:	8526                	mv	a0,s1
    80005754:	ffffe097          	auipc	ra,0xffffe
    80005758:	004080e7          	jalr	4(ra) # 80003758 <iunlock>
  end_op();
    8000575c:	fffff097          	auipc	ra,0xfffff
    80005760:	a12080e7          	jalr	-1518(ra) # 8000416e <end_op>

  return fd;
}
    80005764:	854a                	mv	a0,s2
    80005766:	70f2                	ld	ra,312(sp)
    80005768:	7452                	ld	s0,304(sp)
    8000576a:	74b2                	ld	s1,296(sp)
    8000576c:	7912                	ld	s2,288(sp)
    8000576e:	69f2                	ld	s3,280(sp)
    80005770:	6131                	add	sp,sp,320
    80005772:	8082                	ret
      end_op();
    80005774:	fffff097          	auipc	ra,0xfffff
    80005778:	9fa080e7          	jalr	-1542(ra) # 8000416e <end_op>
      return -1;
    8000577c:	b7e5                	j	80005764 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    8000577e:	f5040513          	add	a0,s0,-176
    80005782:	ffffe097          	auipc	ra,0xffffe
    80005786:	772080e7          	jalr	1906(ra) # 80003ef4 <namei>
    8000578a:	84aa                	mv	s1,a0
    8000578c:	c549                	beqz	a0,80005816 <sys_open+0x196>
    ilock(ip);
    8000578e:	ffffe097          	auipc	ra,0xffffe
    80005792:	f08080e7          	jalr	-248(ra) # 80003696 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005796:	04449703          	lh	a4,68(s1)
    8000579a:	4785                	li	a5,1
    8000579c:	08f70363          	beq	a4,a5,80005822 <sys_open+0x1a2>
    if ((omode & O_NOFOLLOW) == 0) {
    800057a0:	f4c42783          	lw	a5,-180(s0)
    800057a4:	8b91                	and	a5,a5,4
    800057a6:	ff8d                	bnez	a5,800056e0 <sys_open+0x60>
      while (ip->type == T_SYMLINK && nloop < loop_limit) {
    800057a8:	4791                	li	a5,4
    800057aa:	4929                	li	s2,10
    800057ac:	4991                	li	s3,4
    800057ae:	f2f719e3          	bne	a4,a5,800056e0 <sys_open+0x60>
          if (readi(ip, 0, (uint64)symlink, 0, MAXPATH) != MAXPATH) {
    800057b2:	08000713          	li	a4,128
    800057b6:	4681                	li	a3,0
    800057b8:	ec840613          	add	a2,s0,-312
    800057bc:	4581                	li	a1,0
    800057be:	8526                	mv	a0,s1
    800057c0:	ffffe097          	auipc	ra,0xffffe
    800057c4:	230080e7          	jalr	560(ra) # 800039f0 <readi>
    800057c8:	08000793          	li	a5,128
    800057cc:	06f51a63          	bne	a0,a5,80005840 <sys_open+0x1c0>
          iunlockput(ip);
    800057d0:	8526                	mv	a0,s1
    800057d2:	ffffe097          	auipc	ra,0xffffe
    800057d6:	1cc080e7          	jalr	460(ra) # 8000399e <iunlockput>
          if ((ip = namei(symlink)) == 0) {
    800057da:	ec840513          	add	a0,s0,-312
    800057de:	ffffe097          	auipc	ra,0xffffe
    800057e2:	716080e7          	jalr	1814(ra) # 80003ef4 <namei>
    800057e6:	84aa                	mv	s1,a0
    800057e8:	c53d                	beqz	a0,80005856 <sys_open+0x1d6>
          ilock(ip);
    800057ea:	ffffe097          	auipc	ra,0xffffe
    800057ee:	eac080e7          	jalr	-340(ra) # 80003696 <ilock>
      while (ip->type == T_SYMLINK && nloop < loop_limit) {
    800057f2:	04449783          	lh	a5,68(s1)
    800057f6:	ef3795e3          	bne	a5,s3,800056e0 <sys_open+0x60>
    800057fa:	397d                	addw	s2,s2,-1
    800057fc:	fa091be3          	bnez	s2,800057b2 <sys_open+0x132>
        iunlockput(ip);
    80005800:	8526                	mv	a0,s1
    80005802:	ffffe097          	auipc	ra,0xffffe
    80005806:	19c080e7          	jalr	412(ra) # 8000399e <iunlockput>
        end_op();
    8000580a:	fffff097          	auipc	ra,0xfffff
    8000580e:	964080e7          	jalr	-1692(ra) # 8000416e <end_op>
        return -1;
    80005812:	597d                	li	s2,-1
    80005814:	bf81                	j	80005764 <sys_open+0xe4>
      end_op();
    80005816:	fffff097          	auipc	ra,0xfffff
    8000581a:	958080e7          	jalr	-1704(ra) # 8000416e <end_op>
      return -1;
    8000581e:	597d                	li	s2,-1
    80005820:	b791                	j	80005764 <sys_open+0xe4>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005822:	f4c42783          	lw	a5,-180(s0)
    80005826:	ea078de3          	beqz	a5,800056e0 <sys_open+0x60>
      iunlockput(ip);
    8000582a:	8526                	mv	a0,s1
    8000582c:	ffffe097          	auipc	ra,0xffffe
    80005830:	172080e7          	jalr	370(ra) # 8000399e <iunlockput>
      end_op();
    80005834:	fffff097          	auipc	ra,0xfffff
    80005838:	93a080e7          	jalr	-1734(ra) # 8000416e <end_op>
      return -1;
    8000583c:	597d                	li	s2,-1
    8000583e:	b71d                	j	80005764 <sys_open+0xe4>
            iunlockput(ip);
    80005840:	8526                	mv	a0,s1
    80005842:	ffffe097          	auipc	ra,0xffffe
    80005846:	15c080e7          	jalr	348(ra) # 8000399e <iunlockput>
            end_op();
    8000584a:	fffff097          	auipc	ra,0xfffff
    8000584e:	924080e7          	jalr	-1756(ra) # 8000416e <end_op>
            return -1;
    80005852:	597d                	li	s2,-1
    80005854:	bf01                	j	80005764 <sys_open+0xe4>
            end_op();
    80005856:	fffff097          	auipc	ra,0xfffff
    8000585a:	918080e7          	jalr	-1768(ra) # 8000416e <end_op>
            return -1;
    8000585e:	bfd5                	j	80005852 <sys_open+0x1d2>
    iunlockput(ip);
    80005860:	8526                	mv	a0,s1
    80005862:	ffffe097          	auipc	ra,0xffffe
    80005866:	13c080e7          	jalr	316(ra) # 8000399e <iunlockput>
    end_op();
    8000586a:	fffff097          	auipc	ra,0xfffff
    8000586e:	904080e7          	jalr	-1788(ra) # 8000416e <end_op>
    return -1;
    80005872:	597d                	li	s2,-1
    80005874:	bdc5                	j	80005764 <sys_open+0xe4>
      fileclose(f);
    80005876:	854e                	mv	a0,s3
    80005878:	fffff097          	auipc	ra,0xfffff
    8000587c:	d48080e7          	jalr	-696(ra) # 800045c0 <fileclose>
    iunlockput(ip);
    80005880:	8526                	mv	a0,s1
    80005882:	ffffe097          	auipc	ra,0xffffe
    80005886:	11c080e7          	jalr	284(ra) # 8000399e <iunlockput>
    end_op();
    8000588a:	fffff097          	auipc	ra,0xfffff
    8000588e:	8e4080e7          	jalr	-1820(ra) # 8000416e <end_op>
    return -1;
    80005892:	597d                	li	s2,-1
    80005894:	bdc1                	j	80005764 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005896:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    8000589a:	04649783          	lh	a5,70(s1)
    8000589e:	02f99223          	sh	a5,36(s3)
    800058a2:	b549                	j	80005724 <sys_open+0xa4>
    itrunc(ip);
    800058a4:	8526                	mv	a0,s1
    800058a6:	ffffe097          	auipc	ra,0xffffe
    800058aa:	efe080e7          	jalr	-258(ra) # 800037a4 <itrunc>
    800058ae:	b555                	j	80005752 <sys_open+0xd2>

00000000800058b0 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800058b0:	7175                	add	sp,sp,-144
    800058b2:	e506                	sd	ra,136(sp)
    800058b4:	e122                	sd	s0,128(sp)
    800058b6:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800058b8:	fffff097          	auipc	ra,0xfffff
    800058bc:	83c080e7          	jalr	-1988(ra) # 800040f4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800058c0:	08000613          	li	a2,128
    800058c4:	f7040593          	add	a1,s0,-144
    800058c8:	4501                	li	a0,0
    800058ca:	ffffd097          	auipc	ra,0xffffd
    800058ce:	1e0080e7          	jalr	480(ra) # 80002aaa <argstr>
    800058d2:	02054963          	bltz	a0,80005904 <sys_mkdir+0x54>
    800058d6:	4681                	li	a3,0
    800058d8:	4601                	li	a2,0
    800058da:	4585                	li	a1,1
    800058dc:	f7040513          	add	a0,s0,-144
    800058e0:	fffff097          	auipc	ra,0xfffff
    800058e4:	768080e7          	jalr	1896(ra) # 80005048 <create>
    800058e8:	cd11                	beqz	a0,80005904 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800058ea:	ffffe097          	auipc	ra,0xffffe
    800058ee:	0b4080e7          	jalr	180(ra) # 8000399e <iunlockput>
  end_op();
    800058f2:	fffff097          	auipc	ra,0xfffff
    800058f6:	87c080e7          	jalr	-1924(ra) # 8000416e <end_op>
  return 0;
    800058fa:	4501                	li	a0,0
}
    800058fc:	60aa                	ld	ra,136(sp)
    800058fe:	640a                	ld	s0,128(sp)
    80005900:	6149                	add	sp,sp,144
    80005902:	8082                	ret
    end_op();
    80005904:	fffff097          	auipc	ra,0xfffff
    80005908:	86a080e7          	jalr	-1942(ra) # 8000416e <end_op>
    return -1;
    8000590c:	557d                	li	a0,-1
    8000590e:	b7fd                	j	800058fc <sys_mkdir+0x4c>

0000000080005910 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005910:	7135                	add	sp,sp,-160
    80005912:	ed06                	sd	ra,152(sp)
    80005914:	e922                	sd	s0,144(sp)
    80005916:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005918:	ffffe097          	auipc	ra,0xffffe
    8000591c:	7dc080e7          	jalr	2012(ra) # 800040f4 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005920:	08000613          	li	a2,128
    80005924:	f7040593          	add	a1,s0,-144
    80005928:	4501                	li	a0,0
    8000592a:	ffffd097          	auipc	ra,0xffffd
    8000592e:	180080e7          	jalr	384(ra) # 80002aaa <argstr>
    80005932:	04054a63          	bltz	a0,80005986 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005936:	f6c40593          	add	a1,s0,-148
    8000593a:	4505                	li	a0,1
    8000593c:	ffffd097          	auipc	ra,0xffffd
    80005940:	12a080e7          	jalr	298(ra) # 80002a66 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005944:	04054163          	bltz	a0,80005986 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005948:	f6840593          	add	a1,s0,-152
    8000594c:	4509                	li	a0,2
    8000594e:	ffffd097          	auipc	ra,0xffffd
    80005952:	118080e7          	jalr	280(ra) # 80002a66 <argint>
     argint(1, &major) < 0 ||
    80005956:	02054863          	bltz	a0,80005986 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000595a:	f6841683          	lh	a3,-152(s0)
    8000595e:	f6c41603          	lh	a2,-148(s0)
    80005962:	458d                	li	a1,3
    80005964:	f7040513          	add	a0,s0,-144
    80005968:	fffff097          	auipc	ra,0xfffff
    8000596c:	6e0080e7          	jalr	1760(ra) # 80005048 <create>
     argint(2, &minor) < 0 ||
    80005970:	c919                	beqz	a0,80005986 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005972:	ffffe097          	auipc	ra,0xffffe
    80005976:	02c080e7          	jalr	44(ra) # 8000399e <iunlockput>
  end_op();
    8000597a:	ffffe097          	auipc	ra,0xffffe
    8000597e:	7f4080e7          	jalr	2036(ra) # 8000416e <end_op>
  return 0;
    80005982:	4501                	li	a0,0
    80005984:	a031                	j	80005990 <sys_mknod+0x80>
    end_op();
    80005986:	ffffe097          	auipc	ra,0xffffe
    8000598a:	7e8080e7          	jalr	2024(ra) # 8000416e <end_op>
    return -1;
    8000598e:	557d                	li	a0,-1
}
    80005990:	60ea                	ld	ra,152(sp)
    80005992:	644a                	ld	s0,144(sp)
    80005994:	610d                	add	sp,sp,160
    80005996:	8082                	ret

0000000080005998 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005998:	7135                	add	sp,sp,-160
    8000599a:	ed06                	sd	ra,152(sp)
    8000599c:	e922                	sd	s0,144(sp)
    8000599e:	e526                	sd	s1,136(sp)
    800059a0:	e14a                	sd	s2,128(sp)
    800059a2:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800059a4:	ffffc097          	auipc	ra,0xffffc
    800059a8:	000080e7          	jalr	ra # 800019a4 <myproc>
    800059ac:	892a                	mv	s2,a0
  
  begin_op();
    800059ae:	ffffe097          	auipc	ra,0xffffe
    800059b2:	746080e7          	jalr	1862(ra) # 800040f4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800059b6:	08000613          	li	a2,128
    800059ba:	f6040593          	add	a1,s0,-160
    800059be:	4501                	li	a0,0
    800059c0:	ffffd097          	auipc	ra,0xffffd
    800059c4:	0ea080e7          	jalr	234(ra) # 80002aaa <argstr>
    800059c8:	04054b63          	bltz	a0,80005a1e <sys_chdir+0x86>
    800059cc:	f6040513          	add	a0,s0,-160
    800059d0:	ffffe097          	auipc	ra,0xffffe
    800059d4:	524080e7          	jalr	1316(ra) # 80003ef4 <namei>
    800059d8:	84aa                	mv	s1,a0
    800059da:	c131                	beqz	a0,80005a1e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800059dc:	ffffe097          	auipc	ra,0xffffe
    800059e0:	cba080e7          	jalr	-838(ra) # 80003696 <ilock>
  if(ip->type != T_DIR){
    800059e4:	04449703          	lh	a4,68(s1)
    800059e8:	4785                	li	a5,1
    800059ea:	04f71063          	bne	a4,a5,80005a2a <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800059ee:	8526                	mv	a0,s1
    800059f0:	ffffe097          	auipc	ra,0xffffe
    800059f4:	d68080e7          	jalr	-664(ra) # 80003758 <iunlock>
  iput(p->cwd);
    800059f8:	15093503          	ld	a0,336(s2)
    800059fc:	ffffe097          	auipc	ra,0xffffe
    80005a00:	efa080e7          	jalr	-262(ra) # 800038f6 <iput>
  end_op();
    80005a04:	ffffe097          	auipc	ra,0xffffe
    80005a08:	76a080e7          	jalr	1898(ra) # 8000416e <end_op>
  p->cwd = ip;
    80005a0c:	14993823          	sd	s1,336(s2)
  return 0;
    80005a10:	4501                	li	a0,0
}
    80005a12:	60ea                	ld	ra,152(sp)
    80005a14:	644a                	ld	s0,144(sp)
    80005a16:	64aa                	ld	s1,136(sp)
    80005a18:	690a                	ld	s2,128(sp)
    80005a1a:	610d                	add	sp,sp,160
    80005a1c:	8082                	ret
    end_op();
    80005a1e:	ffffe097          	auipc	ra,0xffffe
    80005a22:	750080e7          	jalr	1872(ra) # 8000416e <end_op>
    return -1;
    80005a26:	557d                	li	a0,-1
    80005a28:	b7ed                	j	80005a12 <sys_chdir+0x7a>
    iunlockput(ip);
    80005a2a:	8526                	mv	a0,s1
    80005a2c:	ffffe097          	auipc	ra,0xffffe
    80005a30:	f72080e7          	jalr	-142(ra) # 8000399e <iunlockput>
    end_op();
    80005a34:	ffffe097          	auipc	ra,0xffffe
    80005a38:	73a080e7          	jalr	1850(ra) # 8000416e <end_op>
    return -1;
    80005a3c:	557d                	li	a0,-1
    80005a3e:	bfd1                	j	80005a12 <sys_chdir+0x7a>

0000000080005a40 <sys_exec>:

uint64
sys_exec(void)
{
    80005a40:	7121                	add	sp,sp,-448
    80005a42:	ff06                	sd	ra,440(sp)
    80005a44:	fb22                	sd	s0,432(sp)
    80005a46:	f726                	sd	s1,424(sp)
    80005a48:	f34a                	sd	s2,416(sp)
    80005a4a:	ef4e                	sd	s3,408(sp)
    80005a4c:	eb52                	sd	s4,400(sp)
    80005a4e:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005a50:	08000613          	li	a2,128
    80005a54:	f5040593          	add	a1,s0,-176
    80005a58:	4501                	li	a0,0
    80005a5a:	ffffd097          	auipc	ra,0xffffd
    80005a5e:	050080e7          	jalr	80(ra) # 80002aaa <argstr>
    return -1;
    80005a62:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005a64:	0c054a63          	bltz	a0,80005b38 <sys_exec+0xf8>
    80005a68:	e4840593          	add	a1,s0,-440
    80005a6c:	4505                	li	a0,1
    80005a6e:	ffffd097          	auipc	ra,0xffffd
    80005a72:	01a080e7          	jalr	26(ra) # 80002a88 <argaddr>
    80005a76:	0c054163          	bltz	a0,80005b38 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80005a7a:	10000613          	li	a2,256
    80005a7e:	4581                	li	a1,0
    80005a80:	e5040513          	add	a0,s0,-432
    80005a84:	ffffb097          	auipc	ra,0xffffb
    80005a88:	236080e7          	jalr	566(ra) # 80000cba <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005a8c:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005a90:	89a6                	mv	s3,s1
    80005a92:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005a94:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005a98:	00391513          	sll	a0,s2,0x3
    80005a9c:	e4040593          	add	a1,s0,-448
    80005aa0:	e4843783          	ld	a5,-440(s0)
    80005aa4:	953e                	add	a0,a0,a5
    80005aa6:	ffffd097          	auipc	ra,0xffffd
    80005aaa:	f26080e7          	jalr	-218(ra) # 800029cc <fetchaddr>
    80005aae:	02054a63          	bltz	a0,80005ae2 <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80005ab2:	e4043783          	ld	a5,-448(s0)
    80005ab6:	c3b9                	beqz	a5,80005afc <sys_exec+0xbc>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005ab8:	ffffb097          	auipc	ra,0xffffb
    80005abc:	016080e7          	jalr	22(ra) # 80000ace <kalloc>
    80005ac0:	85aa                	mv	a1,a0
    80005ac2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005ac6:	cd11                	beqz	a0,80005ae2 <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005ac8:	6605                	lui	a2,0x1
    80005aca:	e4043503          	ld	a0,-448(s0)
    80005ace:	ffffd097          	auipc	ra,0xffffd
    80005ad2:	f50080e7          	jalr	-176(ra) # 80002a1e <fetchstr>
    80005ad6:	00054663          	bltz	a0,80005ae2 <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80005ada:	0905                	add	s2,s2,1
    80005adc:	09a1                	add	s3,s3,8
    80005ade:	fb491de3          	bne	s2,s4,80005a98 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ae2:	f5040913          	add	s2,s0,-176
    80005ae6:	6088                	ld	a0,0(s1)
    80005ae8:	c539                	beqz	a0,80005b36 <sys_exec+0xf6>
    kfree(argv[i]);
    80005aea:	ffffb097          	auipc	ra,0xffffb
    80005aee:	ee6080e7          	jalr	-282(ra) # 800009d0 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005af2:	04a1                	add	s1,s1,8
    80005af4:	ff2499e3          	bne	s1,s2,80005ae6 <sys_exec+0xa6>
  return -1;
    80005af8:	597d                	li	s2,-1
    80005afa:	a83d                	j	80005b38 <sys_exec+0xf8>
      argv[i] = 0;
    80005afc:	0009079b          	sext.w	a5,s2
    80005b00:	078e                	sll	a5,a5,0x3
    80005b02:	fd078793          	add	a5,a5,-48
    80005b06:	97a2                	add	a5,a5,s0
    80005b08:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005b0c:	e5040593          	add	a1,s0,-432
    80005b10:	f5040513          	add	a0,s0,-176
    80005b14:	fffff097          	auipc	ra,0xfffff
    80005b18:	0fc080e7          	jalr	252(ra) # 80004c10 <exec>
    80005b1c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b1e:	f5040993          	add	s3,s0,-176
    80005b22:	6088                	ld	a0,0(s1)
    80005b24:	c911                	beqz	a0,80005b38 <sys_exec+0xf8>
    kfree(argv[i]);
    80005b26:	ffffb097          	auipc	ra,0xffffb
    80005b2a:	eaa080e7          	jalr	-342(ra) # 800009d0 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b2e:	04a1                	add	s1,s1,8
    80005b30:	ff3499e3          	bne	s1,s3,80005b22 <sys_exec+0xe2>
    80005b34:	a011                	j	80005b38 <sys_exec+0xf8>
  return -1;
    80005b36:	597d                	li	s2,-1
}
    80005b38:	854a                	mv	a0,s2
    80005b3a:	70fa                	ld	ra,440(sp)
    80005b3c:	745a                	ld	s0,432(sp)
    80005b3e:	74ba                	ld	s1,424(sp)
    80005b40:	791a                	ld	s2,416(sp)
    80005b42:	69fa                	ld	s3,408(sp)
    80005b44:	6a5a                	ld	s4,400(sp)
    80005b46:	6139                	add	sp,sp,448
    80005b48:	8082                	ret

0000000080005b4a <sys_pipe>:

uint64
sys_pipe(void)
{
    80005b4a:	7139                	add	sp,sp,-64
    80005b4c:	fc06                	sd	ra,56(sp)
    80005b4e:	f822                	sd	s0,48(sp)
    80005b50:	f426                	sd	s1,40(sp)
    80005b52:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005b54:	ffffc097          	auipc	ra,0xffffc
    80005b58:	e50080e7          	jalr	-432(ra) # 800019a4 <myproc>
    80005b5c:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005b5e:	fd840593          	add	a1,s0,-40
    80005b62:	4501                	li	a0,0
    80005b64:	ffffd097          	auipc	ra,0xffffd
    80005b68:	f24080e7          	jalr	-220(ra) # 80002a88 <argaddr>
    return -1;
    80005b6c:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005b6e:	0e054063          	bltz	a0,80005c4e <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005b72:	fc840593          	add	a1,s0,-56
    80005b76:	fd040513          	add	a0,s0,-48
    80005b7a:	fffff097          	auipc	ra,0xfffff
    80005b7e:	d72080e7          	jalr	-654(ra) # 800048ec <pipealloc>
    return -1;
    80005b82:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005b84:	0c054563          	bltz	a0,80005c4e <sys_pipe+0x104>
  fd0 = -1;
    80005b88:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005b8c:	fd043503          	ld	a0,-48(s0)
    80005b90:	fffff097          	auipc	ra,0xfffff
    80005b94:	476080e7          	jalr	1142(ra) # 80005006 <fdalloc>
    80005b98:	fca42223          	sw	a0,-60(s0)
    80005b9c:	08054c63          	bltz	a0,80005c34 <sys_pipe+0xea>
    80005ba0:	fc843503          	ld	a0,-56(s0)
    80005ba4:	fffff097          	auipc	ra,0xfffff
    80005ba8:	462080e7          	jalr	1122(ra) # 80005006 <fdalloc>
    80005bac:	fca42023          	sw	a0,-64(s0)
    80005bb0:	06054963          	bltz	a0,80005c22 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005bb4:	4691                	li	a3,4
    80005bb6:	fc440613          	add	a2,s0,-60
    80005bba:	fd843583          	ld	a1,-40(s0)
    80005bbe:	68a8                	ld	a0,80(s1)
    80005bc0:	ffffc097          	auipc	ra,0xffffc
    80005bc4:	a7c080e7          	jalr	-1412(ra) # 8000163c <copyout>
    80005bc8:	02054063          	bltz	a0,80005be8 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005bcc:	4691                	li	a3,4
    80005bce:	fc040613          	add	a2,s0,-64
    80005bd2:	fd843583          	ld	a1,-40(s0)
    80005bd6:	0591                	add	a1,a1,4
    80005bd8:	68a8                	ld	a0,80(s1)
    80005bda:	ffffc097          	auipc	ra,0xffffc
    80005bde:	a62080e7          	jalr	-1438(ra) # 8000163c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005be2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005be4:	06055563          	bgez	a0,80005c4e <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005be8:	fc442783          	lw	a5,-60(s0)
    80005bec:	07e9                	add	a5,a5,26
    80005bee:	078e                	sll	a5,a5,0x3
    80005bf0:	97a6                	add	a5,a5,s1
    80005bf2:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005bf6:	fc042783          	lw	a5,-64(s0)
    80005bfa:	07e9                	add	a5,a5,26
    80005bfc:	078e                	sll	a5,a5,0x3
    80005bfe:	00f48533          	add	a0,s1,a5
    80005c02:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005c06:	fd043503          	ld	a0,-48(s0)
    80005c0a:	fffff097          	auipc	ra,0xfffff
    80005c0e:	9b6080e7          	jalr	-1610(ra) # 800045c0 <fileclose>
    fileclose(wf);
    80005c12:	fc843503          	ld	a0,-56(s0)
    80005c16:	fffff097          	auipc	ra,0xfffff
    80005c1a:	9aa080e7          	jalr	-1622(ra) # 800045c0 <fileclose>
    return -1;
    80005c1e:	57fd                	li	a5,-1
    80005c20:	a03d                	j	80005c4e <sys_pipe+0x104>
    if(fd0 >= 0)
    80005c22:	fc442783          	lw	a5,-60(s0)
    80005c26:	0007c763          	bltz	a5,80005c34 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005c2a:	07e9                	add	a5,a5,26
    80005c2c:	078e                	sll	a5,a5,0x3
    80005c2e:	97a6                	add	a5,a5,s1
    80005c30:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005c34:	fd043503          	ld	a0,-48(s0)
    80005c38:	fffff097          	auipc	ra,0xfffff
    80005c3c:	988080e7          	jalr	-1656(ra) # 800045c0 <fileclose>
    fileclose(wf);
    80005c40:	fc843503          	ld	a0,-56(s0)
    80005c44:	fffff097          	auipc	ra,0xfffff
    80005c48:	97c080e7          	jalr	-1668(ra) # 800045c0 <fileclose>
    return -1;
    80005c4c:	57fd                	li	a5,-1
}
    80005c4e:	853e                	mv	a0,a5
    80005c50:	70e2                	ld	ra,56(sp)
    80005c52:	7442                	ld	s0,48(sp)
    80005c54:	74a2                	ld	s1,40(sp)
    80005c56:	6121                	add	sp,sp,64
    80005c58:	8082                	ret

0000000080005c5a <sys_symlink>:

uint64
sys_symlink(void)
{  
    80005c5a:	712d                	add	sp,sp,-288
    80005c5c:	ee06                	sd	ra,280(sp)
    80005c5e:	ea22                	sd	s0,272(sp)
    80005c60:	e626                	sd	s1,264(sp)
    80005c62:	1200                	add	s0,sp,288
  char path[MAXPATH], target[MAXPATH];
  struct inode *ip;
  // 读取参数
  if(argstr(0, target, MAXPATH) < 0)
    80005c64:	08000613          	li	a2,128
    80005c68:	ee040593          	add	a1,s0,-288
    80005c6c:	4501                	li	a0,0
    80005c6e:	ffffd097          	auipc	ra,0xffffd
    80005c72:	e3c080e7          	jalr	-452(ra) # 80002aaa <argstr>
    return -1;
    80005c76:	57fd                	li	a5,-1
  if(argstr(0, target, MAXPATH) < 0)
    80005c78:	06054563          	bltz	a0,80005ce2 <sys_symlink+0x88>
  if(argstr(1, path, MAXPATH) < 0)
    80005c7c:	08000613          	li	a2,128
    80005c80:	f6040593          	add	a1,s0,-160
    80005c84:	4505                	li	a0,1
    80005c86:	ffffd097          	auipc	ra,0xffffd
    80005c8a:	e24080e7          	jalr	-476(ra) # 80002aaa <argstr>
    return -1;
    80005c8e:	57fd                	li	a5,-1
  if(argstr(1, path, MAXPATH) < 0)
    80005c90:	04054963          	bltz	a0,80005ce2 <sys_symlink+0x88>
  // 开启事务
  begin_op();
    80005c94:	ffffe097          	auipc	ra,0xffffe
    80005c98:	460080e7          	jalr	1120(ra) # 800040f4 <begin_op>
  // 为这个符号链接新建一个 inode
  if((ip = create(path, T_SYMLINK, 0, 0)) == 0) {
    80005c9c:	4681                	li	a3,0
    80005c9e:	4601                	li	a2,0
    80005ca0:	4591                	li	a1,4
    80005ca2:	f6040513          	add	a0,s0,-160
    80005ca6:	fffff097          	auipc	ra,0xfffff
    80005caa:	3a2080e7          	jalr	930(ra) # 80005048 <create>
    80005cae:	84aa                	mv	s1,a0
    80005cb0:	cd1d                	beqz	a0,80005cee <sys_symlink+0x94>
    end_op();
    return -1;
  }
  // 在符号链接的 data 中写入被链接的文件
  if(writei(ip, 0, (uint64)target, 0, MAXPATH) < MAXPATH) {
    80005cb2:	08000713          	li	a4,128
    80005cb6:	4681                	li	a3,0
    80005cb8:	ee040613          	add	a2,s0,-288
    80005cbc:	4581                	li	a1,0
    80005cbe:	ffffe097          	auipc	ra,0xffffe
    80005cc2:	e2a080e7          	jalr	-470(ra) # 80003ae8 <writei>
    80005cc6:	07f00793          	li	a5,127
    80005cca:	02a7d863          	bge	a5,a0,80005cfa <sys_symlink+0xa0>
    iunlockput(ip);
    end_op();
    return -1;
  }
  // 提交事务
  iunlockput(ip);
    80005cce:	8526                	mv	a0,s1
    80005cd0:	ffffe097          	auipc	ra,0xffffe
    80005cd4:	cce080e7          	jalr	-818(ra) # 8000399e <iunlockput>
  end_op();
    80005cd8:	ffffe097          	auipc	ra,0xffffe
    80005cdc:	496080e7          	jalr	1174(ra) # 8000416e <end_op>
  return 0;
    80005ce0:	4781                	li	a5,0
}
    80005ce2:	853e                	mv	a0,a5
    80005ce4:	60f2                	ld	ra,280(sp)
    80005ce6:	6452                	ld	s0,272(sp)
    80005ce8:	64b2                	ld	s1,264(sp)
    80005cea:	6115                	add	sp,sp,288
    80005cec:	8082                	ret
    end_op();
    80005cee:	ffffe097          	auipc	ra,0xffffe
    80005cf2:	480080e7          	jalr	1152(ra) # 8000416e <end_op>
    return -1;
    80005cf6:	57fd                	li	a5,-1
    80005cf8:	b7ed                	j	80005ce2 <sys_symlink+0x88>
    iunlockput(ip);
    80005cfa:	8526                	mv	a0,s1
    80005cfc:	ffffe097          	auipc	ra,0xffffe
    80005d00:	ca2080e7          	jalr	-862(ra) # 8000399e <iunlockput>
    end_op();
    80005d04:	ffffe097          	auipc	ra,0xffffe
    80005d08:	46a080e7          	jalr	1130(ra) # 8000416e <end_op>
    return -1;
    80005d0c:	57fd                	li	a5,-1
    80005d0e:	bfd1                	j	80005ce2 <sys_symlink+0x88>

0000000080005d10 <kernelvec>:
    80005d10:	7111                	add	sp,sp,-256
    80005d12:	e006                	sd	ra,0(sp)
    80005d14:	e40a                	sd	sp,8(sp)
    80005d16:	e80e                	sd	gp,16(sp)
    80005d18:	ec12                	sd	tp,24(sp)
    80005d1a:	f016                	sd	t0,32(sp)
    80005d1c:	f41a                	sd	t1,40(sp)
    80005d1e:	f81e                	sd	t2,48(sp)
    80005d20:	fc22                	sd	s0,56(sp)
    80005d22:	e0a6                	sd	s1,64(sp)
    80005d24:	e4aa                	sd	a0,72(sp)
    80005d26:	e8ae                	sd	a1,80(sp)
    80005d28:	ecb2                	sd	a2,88(sp)
    80005d2a:	f0b6                	sd	a3,96(sp)
    80005d2c:	f4ba                	sd	a4,104(sp)
    80005d2e:	f8be                	sd	a5,112(sp)
    80005d30:	fcc2                	sd	a6,120(sp)
    80005d32:	e146                	sd	a7,128(sp)
    80005d34:	e54a                	sd	s2,136(sp)
    80005d36:	e94e                	sd	s3,144(sp)
    80005d38:	ed52                	sd	s4,152(sp)
    80005d3a:	f156                	sd	s5,160(sp)
    80005d3c:	f55a                	sd	s6,168(sp)
    80005d3e:	f95e                	sd	s7,176(sp)
    80005d40:	fd62                	sd	s8,184(sp)
    80005d42:	e1e6                	sd	s9,192(sp)
    80005d44:	e5ea                	sd	s10,200(sp)
    80005d46:	e9ee                	sd	s11,208(sp)
    80005d48:	edf2                	sd	t3,216(sp)
    80005d4a:	f1f6                	sd	t4,224(sp)
    80005d4c:	f5fa                	sd	t5,232(sp)
    80005d4e:	f9fe                	sd	t6,240(sp)
    80005d50:	b49fc0ef          	jal	80002898 <kerneltrap>
    80005d54:	6082                	ld	ra,0(sp)
    80005d56:	6122                	ld	sp,8(sp)
    80005d58:	61c2                	ld	gp,16(sp)
    80005d5a:	7282                	ld	t0,32(sp)
    80005d5c:	7322                	ld	t1,40(sp)
    80005d5e:	73c2                	ld	t2,48(sp)
    80005d60:	7462                	ld	s0,56(sp)
    80005d62:	6486                	ld	s1,64(sp)
    80005d64:	6526                	ld	a0,72(sp)
    80005d66:	65c6                	ld	a1,80(sp)
    80005d68:	6666                	ld	a2,88(sp)
    80005d6a:	7686                	ld	a3,96(sp)
    80005d6c:	7726                	ld	a4,104(sp)
    80005d6e:	77c6                	ld	a5,112(sp)
    80005d70:	7866                	ld	a6,120(sp)
    80005d72:	688a                	ld	a7,128(sp)
    80005d74:	692a                	ld	s2,136(sp)
    80005d76:	69ca                	ld	s3,144(sp)
    80005d78:	6a6a                	ld	s4,152(sp)
    80005d7a:	7a8a                	ld	s5,160(sp)
    80005d7c:	7b2a                	ld	s6,168(sp)
    80005d7e:	7bca                	ld	s7,176(sp)
    80005d80:	7c6a                	ld	s8,184(sp)
    80005d82:	6c8e                	ld	s9,192(sp)
    80005d84:	6d2e                	ld	s10,200(sp)
    80005d86:	6dce                	ld	s11,208(sp)
    80005d88:	6e6e                	ld	t3,216(sp)
    80005d8a:	7e8e                	ld	t4,224(sp)
    80005d8c:	7f2e                	ld	t5,232(sp)
    80005d8e:	7fce                	ld	t6,240(sp)
    80005d90:	6111                	add	sp,sp,256
    80005d92:	10200073          	sret
    80005d96:	00000013          	nop
    80005d9a:	00000013          	nop
    80005d9e:	0001                	nop

0000000080005da0 <timervec>:
    80005da0:	34051573          	csrrw	a0,mscratch,a0
    80005da4:	e10c                	sd	a1,0(a0)
    80005da6:	e510                	sd	a2,8(a0)
    80005da8:	e914                	sd	a3,16(a0)
    80005daa:	6d0c                	ld	a1,24(a0)
    80005dac:	7110                	ld	a2,32(a0)
    80005dae:	6194                	ld	a3,0(a1)
    80005db0:	96b2                	add	a3,a3,a2
    80005db2:	e194                	sd	a3,0(a1)
    80005db4:	4589                	li	a1,2
    80005db6:	14459073          	csrw	sip,a1
    80005dba:	6914                	ld	a3,16(a0)
    80005dbc:	6510                	ld	a2,8(a0)
    80005dbe:	610c                	ld	a1,0(a0)
    80005dc0:	34051573          	csrrw	a0,mscratch,a0
    80005dc4:	30200073          	mret
	...

0000000080005dca <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005dca:	1141                	add	sp,sp,-16
    80005dcc:	e422                	sd	s0,8(sp)
    80005dce:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005dd0:	0c0007b7          	lui	a5,0xc000
    80005dd4:	4705                	li	a4,1
    80005dd6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005dd8:	c3d8                	sw	a4,4(a5)
}
    80005dda:	6422                	ld	s0,8(sp)
    80005ddc:	0141                	add	sp,sp,16
    80005dde:	8082                	ret

0000000080005de0 <plicinithart>:

void
plicinithart(void)
{
    80005de0:	1141                	add	sp,sp,-16
    80005de2:	e406                	sd	ra,8(sp)
    80005de4:	e022                	sd	s0,0(sp)
    80005de6:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005de8:	ffffc097          	auipc	ra,0xffffc
    80005dec:	b90080e7          	jalr	-1136(ra) # 80001978 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005df0:	0085171b          	sllw	a4,a0,0x8
    80005df4:	0c0027b7          	lui	a5,0xc002
    80005df8:	97ba                	add	a5,a5,a4
    80005dfa:	40200713          	li	a4,1026
    80005dfe:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005e02:	00d5151b          	sllw	a0,a0,0xd
    80005e06:	0c2017b7          	lui	a5,0xc201
    80005e0a:	97aa                	add	a5,a5,a0
    80005e0c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005e10:	60a2                	ld	ra,8(sp)
    80005e12:	6402                	ld	s0,0(sp)
    80005e14:	0141                	add	sp,sp,16
    80005e16:	8082                	ret

0000000080005e18 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005e18:	1141                	add	sp,sp,-16
    80005e1a:	e406                	sd	ra,8(sp)
    80005e1c:	e022                	sd	s0,0(sp)
    80005e1e:	0800                	add	s0,sp,16
  int hart = cpuid();
    80005e20:	ffffc097          	auipc	ra,0xffffc
    80005e24:	b58080e7          	jalr	-1192(ra) # 80001978 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005e28:	00d5151b          	sllw	a0,a0,0xd
    80005e2c:	0c2017b7          	lui	a5,0xc201
    80005e30:	97aa                	add	a5,a5,a0
  return irq;
}
    80005e32:	43c8                	lw	a0,4(a5)
    80005e34:	60a2                	ld	ra,8(sp)
    80005e36:	6402                	ld	s0,0(sp)
    80005e38:	0141                	add	sp,sp,16
    80005e3a:	8082                	ret

0000000080005e3c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005e3c:	1101                	add	sp,sp,-32
    80005e3e:	ec06                	sd	ra,24(sp)
    80005e40:	e822                	sd	s0,16(sp)
    80005e42:	e426                	sd	s1,8(sp)
    80005e44:	1000                	add	s0,sp,32
    80005e46:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005e48:	ffffc097          	auipc	ra,0xffffc
    80005e4c:	b30080e7          	jalr	-1232(ra) # 80001978 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005e50:	00d5151b          	sllw	a0,a0,0xd
    80005e54:	0c2017b7          	lui	a5,0xc201
    80005e58:	97aa                	add	a5,a5,a0
    80005e5a:	c3c4                	sw	s1,4(a5)
}
    80005e5c:	60e2                	ld	ra,24(sp)
    80005e5e:	6442                	ld	s0,16(sp)
    80005e60:	64a2                	ld	s1,8(sp)
    80005e62:	6105                	add	sp,sp,32
    80005e64:	8082                	ret

0000000080005e66 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005e66:	1141                	add	sp,sp,-16
    80005e68:	e406                	sd	ra,8(sp)
    80005e6a:	e022                	sd	s0,0(sp)
    80005e6c:	0800                	add	s0,sp,16
  if(i >= NUM)
    80005e6e:	479d                	li	a5,7
    80005e70:	06a7c863          	blt	a5,a0,80005ee0 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005e74:	00018717          	auipc	a4,0x18
    80005e78:	18c70713          	add	a4,a4,396 # 8001e000 <disk>
    80005e7c:	972a                	add	a4,a4,a0
    80005e7e:	6789                	lui	a5,0x2
    80005e80:	97ba                	add	a5,a5,a4
    80005e82:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005e86:	e7ad                	bnez	a5,80005ef0 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005e88:	00451793          	sll	a5,a0,0x4
    80005e8c:	0001a717          	auipc	a4,0x1a
    80005e90:	17470713          	add	a4,a4,372 # 80020000 <disk+0x2000>
    80005e94:	6314                	ld	a3,0(a4)
    80005e96:	96be                	add	a3,a3,a5
    80005e98:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005e9c:	6314                	ld	a3,0(a4)
    80005e9e:	96be                	add	a3,a3,a5
    80005ea0:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005ea4:	6314                	ld	a3,0(a4)
    80005ea6:	96be                	add	a3,a3,a5
    80005ea8:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005eac:	6318                	ld	a4,0(a4)
    80005eae:	97ba                	add	a5,a5,a4
    80005eb0:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005eb4:	00018717          	auipc	a4,0x18
    80005eb8:	14c70713          	add	a4,a4,332 # 8001e000 <disk>
    80005ebc:	972a                	add	a4,a4,a0
    80005ebe:	6789                	lui	a5,0x2
    80005ec0:	97ba                	add	a5,a5,a4
    80005ec2:	4705                	li	a4,1
    80005ec4:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005ec8:	0001a517          	auipc	a0,0x1a
    80005ecc:	15050513          	add	a0,a0,336 # 80020018 <disk+0x2018>
    80005ed0:	ffffc097          	auipc	ra,0xffffc
    80005ed4:	46a080e7          	jalr	1130(ra) # 8000233a <wakeup>
}
    80005ed8:	60a2                	ld	ra,8(sp)
    80005eda:	6402                	ld	s0,0(sp)
    80005edc:	0141                	add	sp,sp,16
    80005ede:	8082                	ret
    panic("free_desc 1");
    80005ee0:	00003517          	auipc	a0,0x3
    80005ee4:	86850513          	add	a0,a0,-1944 # 80008748 <syscalls+0x328>
    80005ee8:	ffffa097          	auipc	ra,0xffffa
    80005eec:	640080e7          	jalr	1600(ra) # 80000528 <panic>
    panic("free_desc 2");
    80005ef0:	00003517          	auipc	a0,0x3
    80005ef4:	86850513          	add	a0,a0,-1944 # 80008758 <syscalls+0x338>
    80005ef8:	ffffa097          	auipc	ra,0xffffa
    80005efc:	630080e7          	jalr	1584(ra) # 80000528 <panic>

0000000080005f00 <virtio_disk_init>:
{
    80005f00:	1101                	add	sp,sp,-32
    80005f02:	ec06                	sd	ra,24(sp)
    80005f04:	e822                	sd	s0,16(sp)
    80005f06:	e426                	sd	s1,8(sp)
    80005f08:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005f0a:	00003597          	auipc	a1,0x3
    80005f0e:	85e58593          	add	a1,a1,-1954 # 80008768 <syscalls+0x348>
    80005f12:	0001a517          	auipc	a0,0x1a
    80005f16:	21650513          	add	a0,a0,534 # 80020128 <disk+0x2128>
    80005f1a:	ffffb097          	auipc	ra,0xffffb
    80005f1e:	c14080e7          	jalr	-1004(ra) # 80000b2e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005f22:	100017b7          	lui	a5,0x10001
    80005f26:	4398                	lw	a4,0(a5)
    80005f28:	2701                	sext.w	a4,a4
    80005f2a:	747277b7          	lui	a5,0x74727
    80005f2e:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005f32:	0ef71063          	bne	a4,a5,80006012 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005f36:	100017b7          	lui	a5,0x10001
    80005f3a:	43dc                	lw	a5,4(a5)
    80005f3c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005f3e:	4705                	li	a4,1
    80005f40:	0ce79963          	bne	a5,a4,80006012 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005f44:	100017b7          	lui	a5,0x10001
    80005f48:	479c                	lw	a5,8(a5)
    80005f4a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005f4c:	4709                	li	a4,2
    80005f4e:	0ce79263          	bne	a5,a4,80006012 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005f52:	100017b7          	lui	a5,0x10001
    80005f56:	47d8                	lw	a4,12(a5)
    80005f58:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005f5a:	554d47b7          	lui	a5,0x554d4
    80005f5e:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005f62:	0af71863          	bne	a4,a5,80006012 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f66:	100017b7          	lui	a5,0x10001
    80005f6a:	4705                	li	a4,1
    80005f6c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f6e:	470d                	li	a4,3
    80005f70:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005f72:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005f74:	c7ffe6b7          	lui	a3,0xc7ffe
    80005f78:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd75f>
    80005f7c:	8f75                	and	a4,a4,a3
    80005f7e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f80:	472d                	li	a4,11
    80005f82:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f84:	473d                	li	a4,15
    80005f86:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005f88:	6705                	lui	a4,0x1
    80005f8a:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005f8c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005f90:	5bdc                	lw	a5,52(a5)
    80005f92:	2781                	sext.w	a5,a5
  if(max == 0)
    80005f94:	c7d9                	beqz	a5,80006022 <virtio_disk_init+0x122>
  if(max < NUM)
    80005f96:	471d                	li	a4,7
    80005f98:	08f77d63          	bgeu	a4,a5,80006032 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005f9c:	100014b7          	lui	s1,0x10001
    80005fa0:	47a1                	li	a5,8
    80005fa2:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005fa4:	6609                	lui	a2,0x2
    80005fa6:	4581                	li	a1,0
    80005fa8:	00018517          	auipc	a0,0x18
    80005fac:	05850513          	add	a0,a0,88 # 8001e000 <disk>
    80005fb0:	ffffb097          	auipc	ra,0xffffb
    80005fb4:	d0a080e7          	jalr	-758(ra) # 80000cba <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005fb8:	00018717          	auipc	a4,0x18
    80005fbc:	04870713          	add	a4,a4,72 # 8001e000 <disk>
    80005fc0:	00c75793          	srl	a5,a4,0xc
    80005fc4:	2781                	sext.w	a5,a5
    80005fc6:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005fc8:	0001a797          	auipc	a5,0x1a
    80005fcc:	03878793          	add	a5,a5,56 # 80020000 <disk+0x2000>
    80005fd0:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005fd2:	00018717          	auipc	a4,0x18
    80005fd6:	0ae70713          	add	a4,a4,174 # 8001e080 <disk+0x80>
    80005fda:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005fdc:	00019717          	auipc	a4,0x19
    80005fe0:	02470713          	add	a4,a4,36 # 8001f000 <disk+0x1000>
    80005fe4:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005fe6:	4705                	li	a4,1
    80005fe8:	00e78c23          	sb	a4,24(a5)
    80005fec:	00e78ca3          	sb	a4,25(a5)
    80005ff0:	00e78d23          	sb	a4,26(a5)
    80005ff4:	00e78da3          	sb	a4,27(a5)
    80005ff8:	00e78e23          	sb	a4,28(a5)
    80005ffc:	00e78ea3          	sb	a4,29(a5)
    80006000:	00e78f23          	sb	a4,30(a5)
    80006004:	00e78fa3          	sb	a4,31(a5)
}
    80006008:	60e2                	ld	ra,24(sp)
    8000600a:	6442                	ld	s0,16(sp)
    8000600c:	64a2                	ld	s1,8(sp)
    8000600e:	6105                	add	sp,sp,32
    80006010:	8082                	ret
    panic("could not find virtio disk");
    80006012:	00002517          	auipc	a0,0x2
    80006016:	76650513          	add	a0,a0,1894 # 80008778 <syscalls+0x358>
    8000601a:	ffffa097          	auipc	ra,0xffffa
    8000601e:	50e080e7          	jalr	1294(ra) # 80000528 <panic>
    panic("virtio disk has no queue 0");
    80006022:	00002517          	auipc	a0,0x2
    80006026:	77650513          	add	a0,a0,1910 # 80008798 <syscalls+0x378>
    8000602a:	ffffa097          	auipc	ra,0xffffa
    8000602e:	4fe080e7          	jalr	1278(ra) # 80000528 <panic>
    panic("virtio disk max queue too short");
    80006032:	00002517          	auipc	a0,0x2
    80006036:	78650513          	add	a0,a0,1926 # 800087b8 <syscalls+0x398>
    8000603a:	ffffa097          	auipc	ra,0xffffa
    8000603e:	4ee080e7          	jalr	1262(ra) # 80000528 <panic>

0000000080006042 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006042:	7159                	add	sp,sp,-112
    80006044:	f486                	sd	ra,104(sp)
    80006046:	f0a2                	sd	s0,96(sp)
    80006048:	eca6                	sd	s1,88(sp)
    8000604a:	e8ca                	sd	s2,80(sp)
    8000604c:	e4ce                	sd	s3,72(sp)
    8000604e:	e0d2                	sd	s4,64(sp)
    80006050:	fc56                	sd	s5,56(sp)
    80006052:	f85a                	sd	s6,48(sp)
    80006054:	f45e                	sd	s7,40(sp)
    80006056:	f062                	sd	s8,32(sp)
    80006058:	ec66                	sd	s9,24(sp)
    8000605a:	e86a                	sd	s10,16(sp)
    8000605c:	1880                	add	s0,sp,112
    8000605e:	8a2a                	mv	s4,a0
    80006060:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006062:	00c52c03          	lw	s8,12(a0)
    80006066:	001c1c1b          	sllw	s8,s8,0x1
    8000606a:	1c02                	sll	s8,s8,0x20
    8000606c:	020c5c13          	srl	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    80006070:	0001a517          	auipc	a0,0x1a
    80006074:	0b850513          	add	a0,a0,184 # 80020128 <disk+0x2128>
    80006078:	ffffb097          	auipc	ra,0xffffb
    8000607c:	b46080e7          	jalr	-1210(ra) # 80000bbe <acquire>
  for(int i = 0; i < 3; i++){
    80006080:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80006082:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006084:	00018b97          	auipc	s7,0x18
    80006088:	f7cb8b93          	add	s7,s7,-132 # 8001e000 <disk>
    8000608c:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000608e:	4a8d                	li	s5,3
    80006090:	a0b5                	j	800060fc <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80006092:	00fb8733          	add	a4,s7,a5
    80006096:	975a                	add	a4,a4,s6
    80006098:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000609c:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    8000609e:	0207c563          	bltz	a5,800060c8 <virtio_disk_rw+0x86>
  for(int i = 0; i < 3; i++){
    800060a2:	2605                	addw	a2,a2,1 # 2001 <_entry-0x7fffdfff>
    800060a4:	0591                	add	a1,a1,4
    800060a6:	19560c63          	beq	a2,s5,8000623e <virtio_disk_rw+0x1fc>
    idx[i] = alloc_desc();
    800060aa:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    800060ac:	0001a717          	auipc	a4,0x1a
    800060b0:	f6c70713          	add	a4,a4,-148 # 80020018 <disk+0x2018>
    800060b4:	87ca                	mv	a5,s2
    if(disk.free[i]){
    800060b6:	00074683          	lbu	a3,0(a4)
    800060ba:	fee1                	bnez	a3,80006092 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    800060bc:	2785                	addw	a5,a5,1
    800060be:	0705                	add	a4,a4,1
    800060c0:	fe979be3          	bne	a5,s1,800060b6 <virtio_disk_rw+0x74>
    idx[i] = alloc_desc();
    800060c4:	57fd                	li	a5,-1
    800060c6:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    800060c8:	00c05e63          	blez	a2,800060e4 <virtio_disk_rw+0xa2>
    800060cc:	060a                	sll	a2,a2,0x2
    800060ce:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    800060d2:	0009a503          	lw	a0,0(s3)
    800060d6:	00000097          	auipc	ra,0x0
    800060da:	d90080e7          	jalr	-624(ra) # 80005e66 <free_desc>
      for(int j = 0; j < i; j++)
    800060de:	0991                	add	s3,s3,4
    800060e0:	ffa999e3          	bne	s3,s10,800060d2 <virtio_disk_rw+0x90>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800060e4:	0001a597          	auipc	a1,0x1a
    800060e8:	04458593          	add	a1,a1,68 # 80020128 <disk+0x2128>
    800060ec:	0001a517          	auipc	a0,0x1a
    800060f0:	f2c50513          	add	a0,a0,-212 # 80020018 <disk+0x2018>
    800060f4:	ffffc097          	auipc	ra,0xffffc
    800060f8:	0c6080e7          	jalr	198(ra) # 800021ba <sleep>
  for(int i = 0; i < 3; i++){
    800060fc:	f9040993          	add	s3,s0,-112
{
    80006100:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80006102:	864a                	mv	a2,s2
    80006104:	b75d                	j	800060aa <virtio_disk_rw+0x68>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80006106:	0001a697          	auipc	a3,0x1a
    8000610a:	efa6b683          	ld	a3,-262(a3) # 80020000 <disk+0x2000>
    8000610e:	96ba                	add	a3,a3,a4
    80006110:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006114:	00018817          	auipc	a6,0x18
    80006118:	eec80813          	add	a6,a6,-276 # 8001e000 <disk>
    8000611c:	0001a697          	auipc	a3,0x1a
    80006120:	ee468693          	add	a3,a3,-284 # 80020000 <disk+0x2000>
    80006124:	6290                	ld	a2,0(a3)
    80006126:	963a                	add	a2,a2,a4
    80006128:	00c65583          	lhu	a1,12(a2)
    8000612c:	0015e593          	or	a1,a1,1
    80006130:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80006134:	f9842603          	lw	a2,-104(s0)
    80006138:	628c                	ld	a1,0(a3)
    8000613a:	972e                	add	a4,a4,a1
    8000613c:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006140:	20050593          	add	a1,a0,512
    80006144:	0592                	sll	a1,a1,0x4
    80006146:	95c2                	add	a1,a1,a6
    80006148:	577d                	li	a4,-1
    8000614a:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000614e:	00461713          	sll	a4,a2,0x4
    80006152:	6290                	ld	a2,0(a3)
    80006154:	963a                	add	a2,a2,a4
    80006156:	03078793          	add	a5,a5,48
    8000615a:	97c2                	add	a5,a5,a6
    8000615c:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    8000615e:	629c                	ld	a5,0(a3)
    80006160:	97ba                	add	a5,a5,a4
    80006162:	4605                	li	a2,1
    80006164:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006166:	629c                	ld	a5,0(a3)
    80006168:	97ba                	add	a5,a5,a4
    8000616a:	4809                	li	a6,2
    8000616c:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80006170:	629c                	ld	a5,0(a3)
    80006172:	97ba                	add	a5,a5,a4
    80006174:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006178:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    8000617c:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006180:	6698                	ld	a4,8(a3)
    80006182:	00275783          	lhu	a5,2(a4)
    80006186:	8b9d                	and	a5,a5,7
    80006188:	0786                	sll	a5,a5,0x1
    8000618a:	973e                	add	a4,a4,a5
    8000618c:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    80006190:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006194:	6698                	ld	a4,8(a3)
    80006196:	00275783          	lhu	a5,2(a4)
    8000619a:	2785                	addw	a5,a5,1
    8000619c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800061a0:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800061a4:	100017b7          	lui	a5,0x10001
    800061a8:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800061ac:	004a2783          	lw	a5,4(s4)
    800061b0:	02c79163          	bne	a5,a2,800061d2 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    800061b4:	0001a917          	auipc	s2,0x1a
    800061b8:	f7490913          	add	s2,s2,-140 # 80020128 <disk+0x2128>
  while(b->disk == 1) {
    800061bc:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800061be:	85ca                	mv	a1,s2
    800061c0:	8552                	mv	a0,s4
    800061c2:	ffffc097          	auipc	ra,0xffffc
    800061c6:	ff8080e7          	jalr	-8(ra) # 800021ba <sleep>
  while(b->disk == 1) {
    800061ca:	004a2783          	lw	a5,4(s4)
    800061ce:	fe9788e3          	beq	a5,s1,800061be <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    800061d2:	f9042903          	lw	s2,-112(s0)
    800061d6:	20090713          	add	a4,s2,512
    800061da:	0712                	sll	a4,a4,0x4
    800061dc:	00018797          	auipc	a5,0x18
    800061e0:	e2478793          	add	a5,a5,-476 # 8001e000 <disk>
    800061e4:	97ba                	add	a5,a5,a4
    800061e6:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800061ea:	0001a997          	auipc	s3,0x1a
    800061ee:	e1698993          	add	s3,s3,-490 # 80020000 <disk+0x2000>
    800061f2:	00491713          	sll	a4,s2,0x4
    800061f6:	0009b783          	ld	a5,0(s3)
    800061fa:	97ba                	add	a5,a5,a4
    800061fc:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006200:	854a                	mv	a0,s2
    80006202:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006206:	00000097          	auipc	ra,0x0
    8000620a:	c60080e7          	jalr	-928(ra) # 80005e66 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000620e:	8885                	and	s1,s1,1
    80006210:	f0ed                	bnez	s1,800061f2 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006212:	0001a517          	auipc	a0,0x1a
    80006216:	f1650513          	add	a0,a0,-234 # 80020128 <disk+0x2128>
    8000621a:	ffffb097          	auipc	ra,0xffffb
    8000621e:	a58080e7          	jalr	-1448(ra) # 80000c72 <release>
}
    80006222:	70a6                	ld	ra,104(sp)
    80006224:	7406                	ld	s0,96(sp)
    80006226:	64e6                	ld	s1,88(sp)
    80006228:	6946                	ld	s2,80(sp)
    8000622a:	69a6                	ld	s3,72(sp)
    8000622c:	6a06                	ld	s4,64(sp)
    8000622e:	7ae2                	ld	s5,56(sp)
    80006230:	7b42                	ld	s6,48(sp)
    80006232:	7ba2                	ld	s7,40(sp)
    80006234:	7c02                	ld	s8,32(sp)
    80006236:	6ce2                	ld	s9,24(sp)
    80006238:	6d42                	ld	s10,16(sp)
    8000623a:	6165                	add	sp,sp,112
    8000623c:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000623e:	f9042503          	lw	a0,-112(s0)
    80006242:	20050793          	add	a5,a0,512
    80006246:	0792                	sll	a5,a5,0x4
  if(write)
    80006248:	00018817          	auipc	a6,0x18
    8000624c:	db880813          	add	a6,a6,-584 # 8001e000 <disk>
    80006250:	00f80733          	add	a4,a6,a5
    80006254:	019036b3          	snez	a3,s9
    80006258:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    8000625c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80006260:	0b873823          	sd	s8,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006264:	7679                	lui	a2,0xffffe
    80006266:	963e                	add	a2,a2,a5
    80006268:	0001a697          	auipc	a3,0x1a
    8000626c:	d9868693          	add	a3,a3,-616 # 80020000 <disk+0x2000>
    80006270:	6298                	ld	a4,0(a3)
    80006272:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006274:	0a878593          	add	a1,a5,168
    80006278:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000627a:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000627c:	6298                	ld	a4,0(a3)
    8000627e:	9732                	add	a4,a4,a2
    80006280:	45c1                	li	a1,16
    80006282:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006284:	6298                	ld	a4,0(a3)
    80006286:	9732                	add	a4,a4,a2
    80006288:	4585                	li	a1,1
    8000628a:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    8000628e:	f9442703          	lw	a4,-108(s0)
    80006292:	628c                	ld	a1,0(a3)
    80006294:	962e                	add	a2,a2,a1
    80006296:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffdd00e>
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000629a:	0712                	sll	a4,a4,0x4
    8000629c:	6290                	ld	a2,0(a3)
    8000629e:	963a                	add	a2,a2,a4
    800062a0:	058a0593          	add	a1,s4,88
    800062a4:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800062a6:	6294                	ld	a3,0(a3)
    800062a8:	96ba                	add	a3,a3,a4
    800062aa:	40000613          	li	a2,1024
    800062ae:	c690                	sw	a2,8(a3)
  if(write)
    800062b0:	e40c9be3          	bnez	s9,80006106 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800062b4:	0001a697          	auipc	a3,0x1a
    800062b8:	d4c6b683          	ld	a3,-692(a3) # 80020000 <disk+0x2000>
    800062bc:	96ba                	add	a3,a3,a4
    800062be:	4609                	li	a2,2
    800062c0:	00c69623          	sh	a2,12(a3)
    800062c4:	bd81                	j	80006114 <virtio_disk_rw+0xd2>

00000000800062c6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800062c6:	1101                	add	sp,sp,-32
    800062c8:	ec06                	sd	ra,24(sp)
    800062ca:	e822                	sd	s0,16(sp)
    800062cc:	e426                	sd	s1,8(sp)
    800062ce:	e04a                	sd	s2,0(sp)
    800062d0:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    800062d2:	0001a517          	auipc	a0,0x1a
    800062d6:	e5650513          	add	a0,a0,-426 # 80020128 <disk+0x2128>
    800062da:	ffffb097          	auipc	ra,0xffffb
    800062de:	8e4080e7          	jalr	-1820(ra) # 80000bbe <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800062e2:	10001737          	lui	a4,0x10001
    800062e6:	533c                	lw	a5,96(a4)
    800062e8:	8b8d                	and	a5,a5,3
    800062ea:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800062ec:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800062f0:	0001a797          	auipc	a5,0x1a
    800062f4:	d1078793          	add	a5,a5,-752 # 80020000 <disk+0x2000>
    800062f8:	6b94                	ld	a3,16(a5)
    800062fa:	0207d703          	lhu	a4,32(a5)
    800062fe:	0026d783          	lhu	a5,2(a3)
    80006302:	06f70163          	beq	a4,a5,80006364 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006306:	00018917          	auipc	s2,0x18
    8000630a:	cfa90913          	add	s2,s2,-774 # 8001e000 <disk>
    8000630e:	0001a497          	auipc	s1,0x1a
    80006312:	cf248493          	add	s1,s1,-782 # 80020000 <disk+0x2000>
    __sync_synchronize();
    80006316:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000631a:	6898                	ld	a4,16(s1)
    8000631c:	0204d783          	lhu	a5,32(s1)
    80006320:	8b9d                	and	a5,a5,7
    80006322:	078e                	sll	a5,a5,0x3
    80006324:	97ba                	add	a5,a5,a4
    80006326:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006328:	20078713          	add	a4,a5,512
    8000632c:	0712                	sll	a4,a4,0x4
    8000632e:	974a                	add	a4,a4,s2
    80006330:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80006334:	e731                	bnez	a4,80006380 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006336:	20078793          	add	a5,a5,512
    8000633a:	0792                	sll	a5,a5,0x4
    8000633c:	97ca                	add	a5,a5,s2
    8000633e:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80006340:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006344:	ffffc097          	auipc	ra,0xffffc
    80006348:	ff6080e7          	jalr	-10(ra) # 8000233a <wakeup>

    disk.used_idx += 1;
    8000634c:	0204d783          	lhu	a5,32(s1)
    80006350:	2785                	addw	a5,a5,1
    80006352:	17c2                	sll	a5,a5,0x30
    80006354:	93c1                	srl	a5,a5,0x30
    80006356:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000635a:	6898                	ld	a4,16(s1)
    8000635c:	00275703          	lhu	a4,2(a4)
    80006360:	faf71be3          	bne	a4,a5,80006316 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80006364:	0001a517          	auipc	a0,0x1a
    80006368:	dc450513          	add	a0,a0,-572 # 80020128 <disk+0x2128>
    8000636c:	ffffb097          	auipc	ra,0xffffb
    80006370:	906080e7          	jalr	-1786(ra) # 80000c72 <release>
}
    80006374:	60e2                	ld	ra,24(sp)
    80006376:	6442                	ld	s0,16(sp)
    80006378:	64a2                	ld	s1,8(sp)
    8000637a:	6902                	ld	s2,0(sp)
    8000637c:	6105                	add	sp,sp,32
    8000637e:	8082                	ret
      panic("virtio_disk_intr status");
    80006380:	00002517          	auipc	a0,0x2
    80006384:	45850513          	add	a0,a0,1112 # 800087d8 <syscalls+0x3b8>
    80006388:	ffffa097          	auipc	ra,0xffffa
    8000638c:	1a0080e7          	jalr	416(ra) # 80000528 <panic>
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
