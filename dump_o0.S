
test.elf:     file format elf32-littleriscv


Disassembly of section .text:

00010000 <_start>:
.globl _start
.type _start, @function

_start:
    # Set up stack pointer
    la sp, __stack_top
   10000:	00002117          	auipc	sp,0x2
   10004:	da010113          	addi	sp,sp,-608 # 11da0 <__stack_top>

    # Clear BSS
    la t0, __bss_start
   10008:	00001297          	auipc	t0,0x1
   1000c:	d8928293          	addi	t0,t0,-631 # 10d91 <__bss_end>
    la t1, __bss_end
   10010:	00001317          	auipc	t1,0x1
   10014:	d8130313          	addi	t1,t1,-639 # 10d91 <__bss_end>
1:
    bge t0, t1, 2f
   10018:	0062d863          	bge	t0,t1,10028 <_start+0x28>
    sw zero, 0(t0)
   1001c:	0002a023          	sw	zero,0(t0)
    addi t0, t0, 4
   10020:	00428293          	addi	t0,t0,4
    j 1b
   10024:	ff5ff06f          	j	10018 <_start+0x18>

2:
    # Call main
    call main
   10028:	20d000ef          	jal	10a34 <main>

    # Exit syscall (if main returns)
    li a7, 93    # exit syscall number
   1002c:	05d00893          	li	a7,93
    li a0, 0     # exit code
   10030:	00000513          	li	a0,0
    ecall
   10034:	00000073          	ecall

    # Infinite loop (should never reach here)
3:
    j 3b
   10038:	0000006f          	j	10038 <_start+0x38>

0001003c <memcpy>:
   1003c:	fd010113          	addi	sp,sp,-48
extern uint64_t get_cycles(void);
extern uint64_t get_instret(void);

/* Bare metal memcpy implementation */
void *memcpy(void *dest, const void *src, size_t n)
{
   10040:	02112623          	sw	ra,44(sp)
   10044:	02812423          	sw	s0,40(sp)
   10048:	03010413          	addi	s0,sp,48
   1004c:	fca42e23          	sw	a0,-36(s0)
   10050:	fcb42c23          	sw	a1,-40(s0)
   10054:	fcc42a23          	sw	a2,-44(s0)
    uint8_t *d = (uint8_t *) dest;
   10058:	fdc42783          	lw	a5,-36(s0)
   1005c:	fef42623          	sw	a5,-20(s0)
    const uint8_t *s = (const uint8_t *) src;
   10060:	fd842783          	lw	a5,-40(s0)
   10064:	fef42423          	sw	a5,-24(s0)
    while (n--)
   10068:	0240006f          	j	1008c <memcpy+0x50>
        *d++ = *s++;
   1006c:	fe842703          	lw	a4,-24(s0)
   10070:	00170793          	addi	a5,a4,1
   10074:	fef42423          	sw	a5,-24(s0)
   10078:	fec42783          	lw	a5,-20(s0)
   1007c:	00178693          	addi	a3,a5,1
   10080:	fed42623          	sw	a3,-20(s0)
   10084:	00074703          	lbu	a4,0(a4)
   10088:	00e78023          	sb	a4,0(a5)
    while (n--)
   1008c:	fd442783          	lw	a5,-44(s0)
   10090:	fff78713          	addi	a4,a5,-1
   10094:	fce42a23          	sw	a4,-44(s0)
   10098:	fc079ae3          	bnez	a5,1006c <memcpy+0x30>
    return dest;
   1009c:	fdc42783          	lw	a5,-36(s0)
}
   100a0:	00078513          	mv	a0,a5
   100a4:	02c12083          	lw	ra,44(sp)
   100a8:	02812403          	lw	s0,40(sp)
   100ac:	03010113          	addi	sp,sp,48
   100b0:	00008067          	ret

000100b4 <clz>:


uint32_t clz(uint32_t x)
{
   100b4:	fd010113          	addi	sp,sp,-48
   100b8:	02112623          	sw	ra,44(sp)
   100bc:	02812423          	sw	s0,40(sp)
   100c0:	03010413          	addi	s0,sp,48
   100c4:	fca42e23          	sw	a0,-36(s0)
    int r = 0, c;
   100c8:	fe042623          	sw	zero,-20(s0)
    c = (x < 0x00010000) << 4;
   100cc:	fdc42703          	lw	a4,-36(s0)
   100d0:	000107b7          	lui	a5,0x10
   100d4:	00f77663          	bgeu	a4,a5,100e0 <clz+0x2c>
   100d8:	01000793          	li	a5,16
   100dc:	0080006f          	j	100e4 <clz+0x30>
   100e0:	00000793          	li	a5,0
   100e4:	fef42423          	sw	a5,-24(s0)
    r += c;
   100e8:	fec42703          	lw	a4,-20(s0)
   100ec:	fe842783          	lw	a5,-24(s0)
   100f0:	00f707b3          	add	a5,a4,a5
   100f4:	fef42623          	sw	a5,-20(s0)
    x <<= c;  // off 16
   100f8:	fe842783          	lw	a5,-24(s0)
   100fc:	fdc42703          	lw	a4,-36(s0)
   10100:	00f717b3          	sll	a5,a4,a5
   10104:	fcf42e23          	sw	a5,-36(s0)
    c = (x < 0x01000000) << 3;
   10108:	fdc42703          	lw	a4,-36(s0)
   1010c:	010007b7          	lui	a5,0x1000
   10110:	00f77663          	bgeu	a4,a5,1011c <clz+0x68>
   10114:	00800793          	li	a5,8
   10118:	0080006f          	j	10120 <clz+0x6c>
   1011c:	00000793          	li	a5,0
   10120:	fef42423          	sw	a5,-24(s0)
    r += c;
   10124:	fec42703          	lw	a4,-20(s0)
   10128:	fe842783          	lw	a5,-24(s0)
   1012c:	00f707b3          	add	a5,a4,a5
   10130:	fef42623          	sw	a5,-20(s0)
    x <<= c;  // off 8
   10134:	fe842783          	lw	a5,-24(s0)
   10138:	fdc42703          	lw	a4,-36(s0)
   1013c:	00f717b3          	sll	a5,a4,a5
   10140:	fcf42e23          	sw	a5,-36(s0)
    c = (x < 0x10000000) << 2;
   10144:	fdc42703          	lw	a4,-36(s0)
   10148:	100007b7          	lui	a5,0x10000
   1014c:	00f77663          	bgeu	a4,a5,10158 <clz+0xa4>
   10150:	00400793          	li	a5,4
   10154:	0080006f          	j	1015c <clz+0xa8>
   10158:	00000793          	li	a5,0
   1015c:	fef42423          	sw	a5,-24(s0)
    r += c;
   10160:	fec42703          	lw	a4,-20(s0)
   10164:	fe842783          	lw	a5,-24(s0)
   10168:	00f707b3          	add	a5,a4,a5
   1016c:	fef42623          	sw	a5,-20(s0)
    x <<= c;  // off 4
   10170:	fe842783          	lw	a5,-24(s0)
   10174:	fdc42703          	lw	a4,-36(s0)
   10178:	00f717b3          	sll	a5,a4,a5
   1017c:	fcf42e23          	sw	a5,-36(s0)
    c = (x < 0x40000000) << 1;
   10180:	fdc42703          	lw	a4,-36(s0)
   10184:	400007b7          	lui	a5,0x40000
   10188:	00f77663          	bgeu	a4,a5,10194 <clz+0xe0>
   1018c:	00200793          	li	a5,2
   10190:	0080006f          	j	10198 <clz+0xe4>
   10194:	00000793          	li	a5,0
   10198:	fef42423          	sw	a5,-24(s0)
    r += c;
   1019c:	fec42703          	lw	a4,-20(s0)
   101a0:	fe842783          	lw	a5,-24(s0)
   101a4:	00f707b3          	add	a5,a4,a5
   101a8:	fef42623          	sw	a5,-20(s0)
    x <<= c;  // off 2
   101ac:	fe842783          	lw	a5,-24(s0)
   101b0:	fdc42703          	lw	a4,-36(s0)
   101b4:	00f717b3          	sll	a5,a4,a5
   101b8:	fcf42e23          	sw	a5,-36(s0)
    c = x < 0x80000000;
   101bc:	fdc42783          	lw	a5,-36(s0)
   101c0:	fff7c793          	not	a5,a5
   101c4:	01f7d793          	srli	a5,a5,0x1f
   101c8:	0ff7f793          	zext.b	a5,a5
   101cc:	fef42423          	sw	a5,-24(s0)
    r += c;
   101d0:	fec42703          	lw	a4,-20(s0)
   101d4:	fe842783          	lw	a5,-24(s0)
   101d8:	00f707b3          	add	a5,a4,a5
   101dc:	fef42623          	sw	a5,-20(s0)
    x <<= c;  // off 1
   101e0:	fe842783          	lw	a5,-24(s0)
   101e4:	fdc42703          	lw	a4,-36(s0)
   101e8:	00f717b3          	sll	a5,a4,a5
   101ec:	fcf42e23          	sw	a5,-36(s0)
    r += x == 0;
   101f0:	fdc42783          	lw	a5,-36(s0)
   101f4:	0017b793          	seqz	a5,a5
   101f8:	0ff7f793          	zext.b	a5,a5
   101fc:	00078713          	mv	a4,a5
   10200:	fec42783          	lw	a5,-20(s0)
   10204:	00e787b3          	add	a5,a5,a4
   10208:	fef42623          	sw	a5,-20(s0)
    return r;
   1020c:	fec42783          	lw	a5,-20(s0)
}
   10210:	00078513          	mv	a0,a5
   10214:	02c12083          	lw	ra,44(sp)
   10218:	02812403          	lw	s0,40(sp)
   1021c:	03010113          	addi	sp,sp,48
   10220:	00008067          	ret

00010224 <udiv>:

/* Software division for RV32I (no M extension) */
static unsigned long udiv(unsigned long dividend, unsigned long divisor)
{
   10224:	fd010113          	addi	sp,sp,-48
   10228:	02112623          	sw	ra,44(sp)
   1022c:	02812423          	sw	s0,40(sp)
   10230:	03010413          	addi	s0,sp,48
   10234:	fca42e23          	sw	a0,-36(s0)
   10238:	fcb42c23          	sw	a1,-40(s0)
    if (divisor == 0)
   1023c:	fd842783          	lw	a5,-40(s0)
   10240:	00079663          	bnez	a5,1024c <udiv+0x28>
        return 0;
   10244:	00000793          	li	a5,0
   10248:	08c0006f          	j	102d4 <udiv+0xb0>

    unsigned long quotient = 0;
   1024c:	fe042623          	sw	zero,-20(s0)
    unsigned long remainder = 0;
   10250:	fe042423          	sw	zero,-24(s0)

    for (int i = 31; i >= 0; i--) {
   10254:	01f00793          	li	a5,31
   10258:	fef42223          	sw	a5,-28(s0)
   1025c:	06c0006f          	j	102c8 <udiv+0xa4>
        remainder <<= 1;
   10260:	fe842783          	lw	a5,-24(s0)
   10264:	00179793          	slli	a5,a5,0x1
   10268:	fef42423          	sw	a5,-24(s0)
        remainder |= (dividend >> i) & 1;
   1026c:	fe442783          	lw	a5,-28(s0)
   10270:	fdc42703          	lw	a4,-36(s0)
   10274:	00f757b3          	srl	a5,a4,a5
   10278:	0017f793          	andi	a5,a5,1
   1027c:	fe842703          	lw	a4,-24(s0)
   10280:	00f767b3          	or	a5,a4,a5
   10284:	fef42423          	sw	a5,-24(s0)

        if (remainder >= divisor) {
   10288:	fe842703          	lw	a4,-24(s0)
   1028c:	fd842783          	lw	a5,-40(s0)
   10290:	02f76663          	bltu	a4,a5,102bc <udiv+0x98>
            remainder -= divisor;
   10294:	fe842703          	lw	a4,-24(s0)
   10298:	fd842783          	lw	a5,-40(s0)
   1029c:	40f707b3          	sub	a5,a4,a5
   102a0:	fef42423          	sw	a5,-24(s0)
            quotient |= (1UL << i);
   102a4:	fe442783          	lw	a5,-28(s0)
   102a8:	00100713          	li	a4,1
   102ac:	00f717b3          	sll	a5,a4,a5
   102b0:	fec42703          	lw	a4,-20(s0)
   102b4:	00f767b3          	or	a5,a4,a5
   102b8:	fef42623          	sw	a5,-20(s0)
    for (int i = 31; i >= 0; i--) {
   102bc:	fe442783          	lw	a5,-28(s0)
   102c0:	fff78793          	addi	a5,a5,-1 # 3fffffff <__stack_top+0x3ffee25f>
   102c4:	fef42223          	sw	a5,-28(s0)
   102c8:	fe442783          	lw	a5,-28(s0)
   102cc:	f807dae3          	bgez	a5,10260 <udiv+0x3c>
        }
    }

    return quotient;
   102d0:	fec42783          	lw	a5,-20(s0)
}
   102d4:	00078513          	mv	a0,a5
   102d8:	02c12083          	lw	ra,44(sp)
   102dc:	02812403          	lw	s0,40(sp)
   102e0:	03010113          	addi	sp,sp,48
   102e4:	00008067          	ret

000102e8 <umod>:

static unsigned long umod(unsigned long dividend, unsigned long divisor)
{
   102e8:	fd010113          	addi	sp,sp,-48
   102ec:	02112623          	sw	ra,44(sp)
   102f0:	02812423          	sw	s0,40(sp)
   102f4:	03010413          	addi	s0,sp,48
   102f8:	fca42e23          	sw	a0,-36(s0)
   102fc:	fcb42c23          	sw	a1,-40(s0)
    if (divisor == 0)
   10300:	fd842783          	lw	a5,-40(s0)
   10304:	00079663          	bnez	a5,10310 <umod+0x28>
        return 0;
   10308:	00000793          	li	a5,0
   1030c:	0700006f          	j	1037c <umod+0x94>

    unsigned long remainder = 0;
   10310:	fe042623          	sw	zero,-20(s0)

    for (int i = 31; i >= 0; i--) {
   10314:	01f00793          	li	a5,31
   10318:	fef42423          	sw	a5,-24(s0)
   1031c:	0540006f          	j	10370 <umod+0x88>
        remainder <<= 1;
   10320:	fec42783          	lw	a5,-20(s0)
   10324:	00179793          	slli	a5,a5,0x1
   10328:	fef42623          	sw	a5,-20(s0)
        remainder |= (dividend >> i) & 1;
   1032c:	fe842783          	lw	a5,-24(s0)
   10330:	fdc42703          	lw	a4,-36(s0)
   10334:	00f757b3          	srl	a5,a4,a5
   10338:	0017f793          	andi	a5,a5,1
   1033c:	fec42703          	lw	a4,-20(s0)
   10340:	00f767b3          	or	a5,a4,a5
   10344:	fef42623          	sw	a5,-20(s0)

        if (remainder >= divisor) {
   10348:	fec42703          	lw	a4,-20(s0)
   1034c:	fd842783          	lw	a5,-40(s0)
   10350:	00f76a63          	bltu	a4,a5,10364 <umod+0x7c>
            remainder -= divisor;
   10354:	fec42703          	lw	a4,-20(s0)
   10358:	fd842783          	lw	a5,-40(s0)
   1035c:	40f707b3          	sub	a5,a4,a5
   10360:	fef42623          	sw	a5,-20(s0)
    for (int i = 31; i >= 0; i--) {
   10364:	fe842783          	lw	a5,-24(s0)
   10368:	fff78793          	addi	a5,a5,-1
   1036c:	fef42423          	sw	a5,-24(s0)
   10370:	fe842783          	lw	a5,-24(s0)
   10374:	fa07d6e3          	bgez	a5,10320 <umod+0x38>
        }
    }

    return remainder;
   10378:	fec42783          	lw	a5,-20(s0)
}
   1037c:	00078513          	mv	a0,a5
   10380:	02c12083          	lw	ra,44(sp)
   10384:	02812403          	lw	s0,40(sp)
   10388:	03010113          	addi	sp,sp,48
   1038c:	00008067          	ret

00010390 <umul>:

/* Software multiplication for RV32I (no M extension) */
static uint32_t umul(uint32_t a, uint32_t b)
{
   10390:	fd010113          	addi	sp,sp,-48
   10394:	02112623          	sw	ra,44(sp)
   10398:	02812423          	sw	s0,40(sp)
   1039c:	03010413          	addi	s0,sp,48
   103a0:	fca42e23          	sw	a0,-36(s0)
   103a4:	fcb42c23          	sw	a1,-40(s0)
    uint32_t result = 0;
   103a8:	fe042623          	sw	zero,-20(s0)
    while (b) {
   103ac:	0380006f          	j	103e4 <umul+0x54>
        if (b & 1)
   103b0:	fd842783          	lw	a5,-40(s0)
   103b4:	0017f793          	andi	a5,a5,1
   103b8:	00078a63          	beqz	a5,103cc <umul+0x3c>
            result += a;
   103bc:	fec42703          	lw	a4,-20(s0)
   103c0:	fdc42783          	lw	a5,-36(s0)
   103c4:	00f707b3          	add	a5,a4,a5
   103c8:	fef42623          	sw	a5,-20(s0)
        a <<= 1;
   103cc:	fdc42783          	lw	a5,-36(s0)
   103d0:	00179793          	slli	a5,a5,0x1
   103d4:	fcf42e23          	sw	a5,-36(s0)
        b >>= 1;
   103d8:	fd842783          	lw	a5,-40(s0)
   103dc:	0017d793          	srli	a5,a5,0x1
   103e0:	fcf42c23          	sw	a5,-40(s0)
    while (b) {
   103e4:	fd842783          	lw	a5,-40(s0)
   103e8:	fc0794e3          	bnez	a5,103b0 <umul+0x20>
    }
    return result;
   103ec:	fec42783          	lw	a5,-20(s0)
}
   103f0:	00078513          	mv	a0,a5
   103f4:	02c12083          	lw	ra,44(sp)
   103f8:	02812403          	lw	s0,40(sp)
   103fc:	03010113          	addi	sp,sp,48
   10400:	00008067          	ret

00010404 <__mulsi3>:

/* Provide __mulsi3 for GCC */
uint32_t __mulsi3(uint32_t a, uint32_t b)
{
   10404:	fe010113          	addi	sp,sp,-32
   10408:	00112e23          	sw	ra,28(sp)
   1040c:	00812c23          	sw	s0,24(sp)
   10410:	02010413          	addi	s0,sp,32
   10414:	fea42623          	sw	a0,-20(s0)
   10418:	feb42423          	sw	a1,-24(s0)
    return umul(a, b);
   1041c:	fe842583          	lw	a1,-24(s0)
   10420:	fec42503          	lw	a0,-20(s0)
   10424:	f6dff0ef          	jal	10390 <umul>
   10428:	00050793          	mv	a5,a0
}
   1042c:	00078513          	mv	a0,a5
   10430:	01c12083          	lw	ra,28(sp)
   10434:	01812403          	lw	s0,24(sp)
   10438:	02010113          	addi	sp,sp,32
   1043c:	00008067          	ret

00010440 <print_hex>:

/* Simple integer to hex string conversion */
static void print_hex(unsigned long val)
{
   10440:	fc010113          	addi	sp,sp,-64
   10444:	02112e23          	sw	ra,60(sp)
   10448:	02812c23          	sw	s0,56(sp)
   1044c:	04010413          	addi	s0,sp,64
   10450:	fca42623          	sw	a0,-52(s0)
    char buf[20];
    char *p = buf + sizeof(buf) - 1;
   10454:	fd440793          	addi	a5,s0,-44
   10458:	01378793          	addi	a5,a5,19
   1045c:	fef42623          	sw	a5,-20(s0)
    *p = '\n';
   10460:	fec42783          	lw	a5,-20(s0)
   10464:	00a00713          	li	a4,10
   10468:	00e78023          	sb	a4,0(a5)
    p--;
   1046c:	fec42783          	lw	a5,-20(s0)
   10470:	fff78793          	addi	a5,a5,-1
   10474:	fef42623          	sw	a5,-20(s0)

    if (val == 0) {
   10478:	fcc42783          	lw	a5,-52(s0)
   1047c:	06079e63          	bnez	a5,104f8 <print_hex+0xb8>
        *p = '0';
   10480:	fec42783          	lw	a5,-20(s0)
   10484:	03000713          	li	a4,48
   10488:	00e78023          	sb	a4,0(a5)
        p--;
   1048c:	fec42783          	lw	a5,-20(s0)
   10490:	fff78793          	addi	a5,a5,-1
   10494:	fef42623          	sw	a5,-20(s0)
   10498:	0680006f          	j	10500 <print_hex+0xc0>
    } else {
        while (val > 0) {
            int digit = val & 0xf;
   1049c:	fcc42783          	lw	a5,-52(s0)
   104a0:	00f7f793          	andi	a5,a5,15
   104a4:	fef42423          	sw	a5,-24(s0)
            *p = (digit < 10) ? ('0' + digit) : ('a' + digit - 10);
   104a8:	fe842703          	lw	a4,-24(s0)
   104ac:	00900793          	li	a5,9
   104b0:	00e7cc63          	blt	a5,a4,104c8 <print_hex+0x88>
   104b4:	fe842783          	lw	a5,-24(s0)
   104b8:	0ff7f793          	zext.b	a5,a5
   104bc:	03078793          	addi	a5,a5,48
   104c0:	0ff7f793          	zext.b	a5,a5
   104c4:	0140006f          	j	104d8 <print_hex+0x98>
   104c8:	fe842783          	lw	a5,-24(s0)
   104cc:	0ff7f793          	zext.b	a5,a5
   104d0:	05778793          	addi	a5,a5,87
   104d4:	0ff7f793          	zext.b	a5,a5
   104d8:	fec42703          	lw	a4,-20(s0)
   104dc:	00f70023          	sb	a5,0(a4)
            p--;
   104e0:	fec42783          	lw	a5,-20(s0)
   104e4:	fff78793          	addi	a5,a5,-1
   104e8:	fef42623          	sw	a5,-20(s0)
            val >>= 4;
   104ec:	fcc42783          	lw	a5,-52(s0)
   104f0:	0047d793          	srli	a5,a5,0x4
   104f4:	fcf42623          	sw	a5,-52(s0)
        while (val > 0) {
   104f8:	fcc42783          	lw	a5,-52(s0)
   104fc:	fa0790e3          	bnez	a5,1049c <print_hex+0x5c>
        }
    }

    p++;
   10500:	fec42783          	lw	a5,-20(s0)
   10504:	00178793          	addi	a5,a5,1
   10508:	fef42623          	sw	a5,-20(s0)
    printstr(p, (buf + sizeof(buf) - p));
   1050c:	fd440793          	addi	a5,s0,-44
   10510:	01478793          	addi	a5,a5,20
   10514:	fec42703          	lw	a4,-20(s0)
   10518:	40e78733          	sub	a4,a5,a4
   1051c:	fec42783          	lw	a5,-20(s0)
   10520:	04000893          	li	a7,64
   10524:	00100513          	li	a0,1
   10528:	00f005b3          	add	a1,zero,a5
   1052c:	00070613          	mv	a2,a4
   10530:	00000073          	ecall
}
   10534:	00000013          	nop
   10538:	03c12083          	lw	ra,60(sp)
   1053c:	03812403          	lw	s0,56(sp)
   10540:	04010113          	addi	sp,sp,64
   10544:	00008067          	ret

00010548 <print_dec>:

/* Simple integer to decimal string conversion */
static void print_dec(unsigned long val)
{
   10548:	fc010113          	addi	sp,sp,-64
   1054c:	02112e23          	sw	ra,60(sp)
   10550:	02812c23          	sw	s0,56(sp)
   10554:	04010413          	addi	s0,sp,64
   10558:	fca42623          	sw	a0,-52(s0)
    char buf[20];
    char *p = buf + sizeof(buf) - 1;
   1055c:	fd840793          	addi	a5,s0,-40
   10560:	01378793          	addi	a5,a5,19
   10564:	fef42623          	sw	a5,-20(s0)
    *p = '\n';
   10568:	fec42783          	lw	a5,-20(s0)
   1056c:	00a00713          	li	a4,10
   10570:	00e78023          	sb	a4,0(a5)
    p--;
   10574:	fec42783          	lw	a5,-20(s0)
   10578:	fff78793          	addi	a5,a5,-1
   1057c:	fef42623          	sw	a5,-20(s0)

    if (val == 0) {
   10580:	fcc42783          	lw	a5,-52(s0)
   10584:	06079063          	bnez	a5,105e4 <print_dec+0x9c>
        *p = '0';
   10588:	fec42783          	lw	a5,-20(s0)
   1058c:	03000713          	li	a4,48
   10590:	00e78023          	sb	a4,0(a5)
        p--;
   10594:	fec42783          	lw	a5,-20(s0)
   10598:	fff78793          	addi	a5,a5,-1
   1059c:	fef42623          	sw	a5,-20(s0)
   105a0:	04c0006f          	j	105ec <print_dec+0xa4>
    } else {
        while (val > 0) {
            *p = '0' + umod(val, 10);
   105a4:	00a00593          	li	a1,10
   105a8:	fcc42503          	lw	a0,-52(s0)
   105ac:	d3dff0ef          	jal	102e8 <umod>
   105b0:	00050793          	mv	a5,a0
   105b4:	0ff7f793          	zext.b	a5,a5
   105b8:	03078793          	addi	a5,a5,48
   105bc:	0ff7f713          	zext.b	a4,a5
   105c0:	fec42783          	lw	a5,-20(s0)
   105c4:	00e78023          	sb	a4,0(a5)
            p--;
   105c8:	fec42783          	lw	a5,-20(s0)
   105cc:	fff78793          	addi	a5,a5,-1
   105d0:	fef42623          	sw	a5,-20(s0)
            val = udiv(val, 10);
   105d4:	00a00593          	li	a1,10
   105d8:	fcc42503          	lw	a0,-52(s0)
   105dc:	c49ff0ef          	jal	10224 <udiv>
   105e0:	fca42623          	sw	a0,-52(s0)
        while (val > 0) {
   105e4:	fcc42783          	lw	a5,-52(s0)
   105e8:	fa079ee3          	bnez	a5,105a4 <print_dec+0x5c>
        }
    }

    p++;
   105ec:	fec42783          	lw	a5,-20(s0)
   105f0:	00178793          	addi	a5,a5,1
   105f4:	fef42623          	sw	a5,-20(s0)
    printstr(p, (buf + sizeof(buf) - p));
   105f8:	fd840793          	addi	a5,s0,-40
   105fc:	01478793          	addi	a5,a5,20
   10600:	fec42703          	lw	a4,-20(s0)
   10604:	40e78733          	sub	a4,a5,a4
   10608:	fec42783          	lw	a5,-20(s0)
   1060c:	04000893          	li	a7,64
   10610:	00100513          	li	a0,1
   10614:	00f005b3          	add	a1,zero,a5
   10618:	00070613          	mv	a2,a4
   1061c:	00000073          	ecall
}
   10620:	00000013          	nop
   10624:	03c12083          	lw	ra,60(sp)
   10628:	03812403          	lw	s0,56(sp)
   1062c:	04010113          	addi	sp,sp,64
   10630:	00008067          	ret

00010634 <print_char>:
static void print_char(char c)
{
   10634:	fe010113          	addi	sp,sp,-32
   10638:	00112e23          	sw	ra,28(sp)
   1063c:	00812c23          	sw	s0,24(sp)
   10640:	02010413          	addi	s0,sp,32
   10644:	00050793          	mv	a5,a0
   10648:	fef407a3          	sb	a5,-17(s0)
    printstr(&c, 1);
   1064c:	fef40793          	addi	a5,s0,-17
   10650:	00100713          	li	a4,1
   10654:	04000893          	li	a7,64
   10658:	00100513          	li	a0,1
   1065c:	00f005b3          	add	a1,zero,a5
   10660:	00070613          	mv	a2,a4
   10664:	00000073          	ecall
}
   10668:	00000013          	nop
   1066c:	01c12083          	lw	ra,28(sp)
   10670:	01812403          	lw	s0,24(sp)
   10674:	02010113          	addi	sp,sp,32
   10678:	00008067          	ret

0001067c <mul32x32>:
    32,    23,    16,    11,    8,     6,     4,    3,    2,    1};



static inline void mul32x32(uint32_t a, uint32_t b, uint32_t *hi, uint32_t *lo)
{
   1067c:	fb010113          	addi	sp,sp,-80
   10680:	04112623          	sw	ra,76(sp)
   10684:	04812423          	sw	s0,72(sp)
   10688:	05010413          	addi	s0,sp,80
   1068c:	faa42e23          	sw	a0,-68(s0)
   10690:	fab42c23          	sw	a1,-72(s0)
   10694:	fac42a23          	sw	a2,-76(s0)
   10698:	fad42823          	sw	a3,-80(s0)
    uint32_t a_lo = a & 0xFFFFu, a_hi = a >> 16;
   1069c:	fbc42783          	lw	a5,-68(s0)
   106a0:	01079793          	slli	a5,a5,0x10
   106a4:	0107d793          	srli	a5,a5,0x10
   106a8:	fef42623          	sw	a5,-20(s0)
   106ac:	fbc42783          	lw	a5,-68(s0)
   106b0:	0107d793          	srli	a5,a5,0x10
   106b4:	fef42423          	sw	a5,-24(s0)
    uint32_t b_lo = b & 0xFFFFu, b_hi = b >> 16;
   106b8:	fb842783          	lw	a5,-72(s0)
   106bc:	01079793          	slli	a5,a5,0x10
   106c0:	0107d793          	srli	a5,a5,0x10
   106c4:	fef42223          	sw	a5,-28(s0)
   106c8:	fb842783          	lw	a5,-72(s0)
   106cc:	0107d793          	srli	a5,a5,0x10
   106d0:	fef42023          	sw	a5,-32(s0)

    uint32_t p0 = a_lo * b_lo;
   106d4:	fe442583          	lw	a1,-28(s0)
   106d8:	fec42503          	lw	a0,-20(s0)
   106dc:	d29ff0ef          	jal	10404 <__mulsi3>
   106e0:	00050793          	mv	a5,a0
   106e4:	fcf42e23          	sw	a5,-36(s0)
    uint32_t p1 = a_lo * b_hi;
   106e8:	fe042583          	lw	a1,-32(s0)
   106ec:	fec42503          	lw	a0,-20(s0)
   106f0:	d15ff0ef          	jal	10404 <__mulsi3>
   106f4:	00050793          	mv	a5,a0
   106f8:	fcf42c23          	sw	a5,-40(s0)
    uint32_t p2 = a_hi * b_lo;
   106fc:	fe442583          	lw	a1,-28(s0)
   10700:	fe842503          	lw	a0,-24(s0)
   10704:	d01ff0ef          	jal	10404 <__mulsi3>
   10708:	00050793          	mv	a5,a0
   1070c:	fcf42a23          	sw	a5,-44(s0)
    uint32_t p3 = a_hi * b_hi;
   10710:	fe042583          	lw	a1,-32(s0)
   10714:	fe842503          	lw	a0,-24(s0)
   10718:	cedff0ef          	jal	10404 <__mulsi3>
   1071c:	00050793          	mv	a5,a0
   10720:	fcf42823          	sw	a5,-48(s0)


    uint32_t mid = (p0 >> 16) + (p1 & 0xFFFFu) + (p2 & 0xFFFFu);
   10724:	fdc42783          	lw	a5,-36(s0)
   10728:	0107d713          	srli	a4,a5,0x10
   1072c:	fd842783          	lw	a5,-40(s0)
   10730:	01079793          	slli	a5,a5,0x10
   10734:	0107d793          	srli	a5,a5,0x10
   10738:	00f70733          	add	a4,a4,a5
   1073c:	fd442783          	lw	a5,-44(s0)
   10740:	01079793          	slli	a5,a5,0x10
   10744:	0107d793          	srli	a5,a5,0x10
   10748:	00f707b3          	add	a5,a4,a5
   1074c:	fcf42623          	sw	a5,-52(s0)

    uint32_t lo_res = (p0 & 0xFFFFu) | (mid << 16);
   10750:	fdc42783          	lw	a5,-36(s0)
   10754:	01079713          	slli	a4,a5,0x10
   10758:	01075713          	srli	a4,a4,0x10
   1075c:	fcc42783          	lw	a5,-52(s0)
   10760:	01079793          	slli	a5,a5,0x10
   10764:	00f767b3          	or	a5,a4,a5
   10768:	fcf42423          	sw	a5,-56(s0)
    uint32_t hi_res = p3 + (p1 >> 16) + (p2 >> 16) + (mid >> 16);
   1076c:	fd842783          	lw	a5,-40(s0)
   10770:	0107d713          	srli	a4,a5,0x10
   10774:	fd042783          	lw	a5,-48(s0)
   10778:	00f70733          	add	a4,a4,a5
   1077c:	fd442783          	lw	a5,-44(s0)
   10780:	0107d793          	srli	a5,a5,0x10
   10784:	00f70733          	add	a4,a4,a5
   10788:	fcc42783          	lw	a5,-52(s0)
   1078c:	0107d793          	srli	a5,a5,0x10
   10790:	00f707b3          	add	a5,a4,a5
   10794:	fcf42223          	sw	a5,-60(s0)

    *hi = hi_res;
   10798:	fb442783          	lw	a5,-76(s0)
   1079c:	fc442703          	lw	a4,-60(s0)
   107a0:	00e7a023          	sw	a4,0(a5)
    *lo = lo_res;
   107a4:	fb042783          	lw	a5,-80(s0)
   107a8:	fc842703          	lw	a4,-56(s0)
   107ac:	00e7a023          	sw	a4,0(a5)
}
   107b0:	00000013          	nop
   107b4:	04c12083          	lw	ra,76(sp)
   107b8:	04812403          	lw	s0,72(sp)
   107bc:	05010113          	addi	sp,sp,80
   107c0:	00008067          	ret

000107c4 <newton_step_q16_inline>:

static inline uint32_t newton_step_q16_inline(uint32_t y, uint32_t x)
{
   107c4:	fa010113          	addi	sp,sp,-96
   107c8:	04112e23          	sw	ra,92(sp)
   107cc:	04812c23          	sw	s0,88(sp)
   107d0:	06010413          	addi	s0,sp,96
   107d4:	faa42623          	sw	a0,-84(s0)
   107d8:	fab42423          	sw	a1,-88(s0)
    // y2 = y*y
    uint32_t y2_hi, y2_lo;
    mul32x32(y, y, &y2_hi, &y2_lo);
   107dc:	fd040713          	addi	a4,s0,-48
   107e0:	fd440793          	addi	a5,s0,-44
   107e4:	00070693          	mv	a3,a4
   107e8:	00078613          	mv	a2,a5
   107ec:	fac42583          	lw	a1,-84(s0)
   107f0:	fac42503          	lw	a0,-84(s0)
   107f4:	e89ff0ef          	jal	1067c <mul32x32>

    // (x * y2_hi) << 16 → termA
    uint32_t hi1, lo1;
    mul32x32(x, y2_hi, &hi1, &lo1);
   107f8:	fd442783          	lw	a5,-44(s0)
   107fc:	fc840693          	addi	a3,s0,-56
   10800:	fcc40713          	addi	a4,s0,-52
   10804:	00070613          	mv	a2,a4
   10808:	00078593          	mv	a1,a5
   1080c:	fa842503          	lw	a0,-88(s0)
   10810:	e6dff0ef          	jal	1067c <mul32x32>
    uint32_t termA = (lo1 << 16);
   10814:	fc842783          	lw	a5,-56(s0)
   10818:	01079793          	slli	a5,a5,0x10
   1081c:	fef42623          	sw	a5,-20(s0)

    // (x * y2_lo) >> 16 → termB
    uint32_t hi2, lo2;
    mul32x32(x, y2_lo, &hi2, &lo2);
   10820:	fd042783          	lw	a5,-48(s0)
   10824:	fc040693          	addi	a3,s0,-64
   10828:	fc440713          	addi	a4,s0,-60
   1082c:	00070613          	mv	a2,a4
   10830:	00078593          	mv	a1,a5
   10834:	fa842503          	lw	a0,-88(s0)
   10838:	e45ff0ef          	jal	1067c <mul32x32>
    uint32_t termB = (hi2 << 16) | (lo2 >> 16);
   1083c:	fc442783          	lw	a5,-60(s0)
   10840:	01079713          	slli	a4,a5,0x10
   10844:	fc042783          	lw	a5,-64(s0)
   10848:	0107d793          	srli	a5,a5,0x10
   1084c:	00f767b3          	or	a5,a4,a5
   10850:	fef42423          	sw	a5,-24(s0)

    uint32_t xy2 = termA + termB;  // mod 2^32
   10854:	fec42703          	lw	a4,-20(s0)
   10858:	fe842783          	lw	a5,-24(s0)
   1085c:	00f707b3          	add	a5,a4,a5
   10860:	fef42223          	sw	a5,-28(s0)
    uint32_t term = (3u << 16) - xy2;
   10864:	00030737          	lui	a4,0x30
   10868:	fe442783          	lw	a5,-28(s0)
   1086c:	40f707b3          	sub	a5,a4,a5
   10870:	fef42023          	sw	a5,-32(s0)

    // y * term → >>17
    uint32_t hi, lo;
    mul32x32(y, term, &hi, &lo);
   10874:	fb840713          	addi	a4,s0,-72
   10878:	fbc40793          	addi	a5,s0,-68
   1087c:	00070693          	mv	a3,a4
   10880:	00078613          	mv	a2,a5
   10884:	fe042583          	lw	a1,-32(s0)
   10888:	fac42503          	lw	a0,-84(s0)
   1088c:	df1ff0ef          	jal	1067c <mul32x32>
    uint32_t lo_plus = lo + (1u << 16);
   10890:	fb842703          	lw	a4,-72(s0)
   10894:	000107b7          	lui	a5,0x10
   10898:	00f707b3          	add	a5,a4,a5
   1089c:	fcf42e23          	sw	a5,-36(s0)
    uint32_t hi_plus = hi + (lo_plus < lo);
   108a0:	fb842783          	lw	a5,-72(s0)
   108a4:	fdc42703          	lw	a4,-36(s0)
   108a8:	00f737b3          	sltu	a5,a4,a5
   108ac:	0ff7f793          	zext.b	a5,a5
   108b0:	00078713          	mv	a4,a5
   108b4:	fbc42783          	lw	a5,-68(s0)
   108b8:	00f707b3          	add	a5,a4,a5
   108bc:	fcf42c23          	sw	a5,-40(s0)
    return (hi_plus << 15) | (lo_plus >> 17);
   108c0:	fd842783          	lw	a5,-40(s0)
   108c4:	00f79713          	slli	a4,a5,0xf
   108c8:	fdc42783          	lw	a5,-36(s0)
   108cc:	0117d793          	srli	a5,a5,0x11
   108d0:	00f767b3          	or	a5,a4,a5
}
   108d4:	00078513          	mv	a0,a5
   108d8:	05c12083          	lw	ra,92(sp)
   108dc:	05812403          	lw	s0,88(sp)
   108e0:	06010113          	addi	sp,sp,96
   108e4:	00008067          	ret

000108e8 <rsqrt>:

static uint32_t rsqrt(uint32_t x)
{
   108e8:	fc010113          	addi	sp,sp,-64
   108ec:	02112e23          	sw	ra,60(sp)
   108f0:	02812c23          	sw	s0,56(sp)
   108f4:	04010413          	addi	s0,sp,64
   108f8:	fca42623          	sw	a0,-52(s0)
    if (x == 0)
   108fc:	fcc42783          	lw	a5,-52(s0)
   10900:	00079663          	bnez	a5,1090c <rsqrt+0x24>
        return 0xFFFFFFFF;
   10904:	fff00793          	li	a5,-1
   10908:	1180006f          	j	10a20 <rsqrt+0x138>
    if (x == UINT32_MAX)
   1090c:	fcc42703          	lw	a4,-52(s0)
   10910:	fff00793          	li	a5,-1
   10914:	00f71663          	bne	a4,a5,10920 <rsqrt+0x38>
        return 1;
   10918:	00100793          	li	a5,1
   1091c:	1040006f          	j	10a20 <rsqrt+0x138>
    uint32_t exp = 31u - clz(x);
   10920:	fcc42503          	lw	a0,-52(s0)
   10924:	f90ff0ef          	jal	100b4 <clz>
   10928:	00050713          	mv	a4,a0
   1092c:	01f00793          	li	a5,31
   10930:	40e787b3          	sub	a5,a5,a4
   10934:	fef42623          	sw	a5,-20(s0)


    uint32_t y_base = rsqrt_table[exp]; /* Value at 2^exp */
   10938:	000117b7          	lui	a5,0x11
   1093c:	cf478713          	addi	a4,a5,-780 # 10cf4 <rsqrt_table>
   10940:	fec42783          	lw	a5,-20(s0)
   10944:	00279793          	slli	a5,a5,0x2
   10948:	00f707b3          	add	a5,a4,a5
   1094c:	0007a783          	lw	a5,0(a5)
   10950:	fef42423          	sw	a5,-24(s0)
    uint32_t y_next = (exp < 31u) ? rsqrt_table[exp + 1u] : 1u;
   10954:	fec42703          	lw	a4,-20(s0)
   10958:	01e00793          	li	a5,30
   1095c:	02e7e263          	bltu	a5,a4,10980 <rsqrt+0x98>
   10960:	fec42783          	lw	a5,-20(s0)
   10964:	00178793          	addi	a5,a5,1
   10968:	00011737          	lui	a4,0x11
   1096c:	cf470713          	addi	a4,a4,-780 # 10cf4 <rsqrt_table>
   10970:	00279793          	slli	a5,a5,0x2
   10974:	00f707b3          	add	a5,a4,a5
   10978:	0007a783          	lw	a5,0(a5)
   1097c:	0080006f          	j	10984 <rsqrt+0x9c>
   10980:	00100793          	li	a5,1
   10984:	fef42223          	sw	a5,-28(s0)

    uint32_t fraction = (exp >= 16) ? (x - (1u << exp)) >> (exp - 16)
                                    : (x - (1u << exp)) << (16 - exp);
   10988:	fec42703          	lw	a4,-20(s0)
   1098c:	00f00793          	li	a5,15
   10990:	02e7f463          	bgeu	a5,a4,109b8 <rsqrt+0xd0>
    uint32_t fraction = (exp >= 16) ? (x - (1u << exp)) >> (exp - 16)
   10994:	fec42783          	lw	a5,-20(s0)
   10998:	00100713          	li	a4,1
   1099c:	00f717b3          	sll	a5,a4,a5
   109a0:	fcc42703          	lw	a4,-52(s0)
   109a4:	40f70733          	sub	a4,a4,a5
   109a8:	fec42783          	lw	a5,-20(s0)
   109ac:	ff078793          	addi	a5,a5,-16
                                    : (x - (1u << exp)) << (16 - exp);
   109b0:	00f757b3          	srl	a5,a4,a5
   109b4:	0280006f          	j	109dc <rsqrt+0xf4>
   109b8:	fec42783          	lw	a5,-20(s0)
   109bc:	00100713          	li	a4,1
   109c0:	00f717b3          	sll	a5,a4,a5
   109c4:	fcc42703          	lw	a4,-52(s0)
   109c8:	40f70733          	sub	a4,a4,a5
   109cc:	01000693          	li	a3,16
   109d0:	fec42783          	lw	a5,-20(s0)
   109d4:	40f687b3          	sub	a5,a3,a5
   109d8:	00f717b3          	sll	a5,a4,a5
    uint32_t fraction = (exp >= 16) ? (x - (1u << exp)) >> (exp - 16)
   109dc:	fef42023          	sw	a5,-32(s0)


    /* Linear interpolation */
    uint32_t y = y_base - (umul((y_base - y_next), fraction) >> 16);
   109e0:	fe842703          	lw	a4,-24(s0)
   109e4:	fe442783          	lw	a5,-28(s0)
   109e8:	40f707b3          	sub	a5,a4,a5
   109ec:	fe042583          	lw	a1,-32(s0)
   109f0:	00078513          	mv	a0,a5
   109f4:	99dff0ef          	jal	10390 <umul>
   109f8:	00050793          	mv	a5,a0
   109fc:	0107d793          	srli	a5,a5,0x10
   10a00:	fe842703          	lw	a4,-24(s0)
   10a04:	40f707b3          	sub	a5,a4,a5
   10a08:	fcf42e23          	sw	a5,-36(s0)


    y = newton_step_q16_inline(y, x);
   10a0c:	fcc42583          	lw	a1,-52(s0)
   10a10:	fdc42503          	lw	a0,-36(s0)
   10a14:	db1ff0ef          	jal	107c4 <newton_step_q16_inline>
   10a18:	fca42e23          	sw	a0,-36(s0)

    return y;
   10a1c:	fdc42783          	lw	a5,-36(s0)
}
   10a20:	00078513          	mv	a0,a5
   10a24:	03c12083          	lw	ra,60(sp)
   10a28:	03812403          	lw	s0,56(sp)
   10a2c:	04010113          	addi	sp,sp,64
   10a30:	00008067          	ret

00010a34 <main>:

int main(void)
{
   10a34:	f9010113          	addi	sp,sp,-112
   10a38:	06112623          	sw	ra,108(sp)
   10a3c:	06812423          	sw	s0,104(sp)
   10a40:	07010413          	addi	s0,sp,112
    uint64_t start_cycles = get_cycles();
   10a44:	1c0000ef          	jal	10c04 <get_cycles>
   10a48:	fea42023          	sw	a0,-32(s0)
   10a4c:	feb42223          	sw	a1,-28(s0)
    uint64_t start_instret = get_instret();
   10a50:	1c8000ef          	jal	10c18 <get_instret>
   10a54:	fca42c23          	sw	a0,-40(s0)
   10a58:	fcb42e23          	sw	a1,-36(s0)
    for (int i = 0; i < 50; i++) {
   10a5c:	fe042623          	sw	zero,-20(s0)
   10a60:	03c0006f          	j	10a9c <main+0x68>
        uint32_t y = rsqrt(RSQRT_INPUTS[i]);
   10a64:	000117b7          	lui	a5,0x11
   10a68:	c2c78713          	addi	a4,a5,-980 # 10c2c <RSQRT_INPUTS>
   10a6c:	fec42783          	lw	a5,-20(s0)
   10a70:	00279793          	slli	a5,a5,0x2
   10a74:	00f707b3          	add	a5,a4,a5
   10a78:	0007a783          	lw	a5,0(a5)
   10a7c:	00078513          	mv	a0,a5
   10a80:	e69ff0ef          	jal	108e8 <rsqrt>
   10a84:	faa42a23          	sw	a0,-76(s0)
        print_hex(y);
   10a88:	fb442503          	lw	a0,-76(s0)
   10a8c:	9b5ff0ef          	jal	10440 <print_hex>
    for (int i = 0; i < 50; i++) {
   10a90:	fec42783          	lw	a5,-20(s0)
   10a94:	00178793          	addi	a5,a5,1
   10a98:	fef42623          	sw	a5,-20(s0)
   10a9c:	fec42703          	lw	a4,-20(s0)
   10aa0:	03100793          	li	a5,49
   10aa4:	fce7d0e3          	bge	a5,a4,10a64 <main+0x30>
    }
    uint64_t end_cycles = get_cycles();
   10aa8:	15c000ef          	jal	10c04 <get_cycles>
   10aac:	fca42823          	sw	a0,-48(s0)
   10ab0:	fcb42a23          	sw	a1,-44(s0)
    uint64_t end_instret = get_instret();
   10ab4:	164000ef          	jal	10c18 <get_instret>
   10ab8:	fca42423          	sw	a0,-56(s0)
   10abc:	fcb42623          	sw	a1,-52(s0)

    uint64_t cycles_elapsed = end_cycles - start_cycles;
   10ac0:	fd042603          	lw	a2,-48(s0)
   10ac4:	fd442683          	lw	a3,-44(s0)
   10ac8:	fe042503          	lw	a0,-32(s0)
   10acc:	fe442583          	lw	a1,-28(s0)
   10ad0:	40a60733          	sub	a4,a2,a0
   10ad4:	00070813          	mv	a6,a4
   10ad8:	01063833          	sltu	a6,a2,a6
   10adc:	40b687b3          	sub	a5,a3,a1
   10ae0:	410786b3          	sub	a3,a5,a6
   10ae4:	00068793          	mv	a5,a3
   10ae8:	fce42023          	sw	a4,-64(s0)
   10aec:	fcf42223          	sw	a5,-60(s0)
    uint64_t instret_elapsed = end_instret - start_instret;
   10af0:	fc842603          	lw	a2,-56(s0)
   10af4:	fcc42683          	lw	a3,-52(s0)
   10af8:	fd842503          	lw	a0,-40(s0)
   10afc:	fdc42583          	lw	a1,-36(s0)
   10b00:	40a60733          	sub	a4,a2,a0
   10b04:	00070813          	mv	a6,a4
   10b08:	01063833          	sltu	a6,a2,a6
   10b0c:	40b687b3          	sub	a5,a3,a1
   10b10:	410786b3          	sub	a3,a5,a6
   10b14:	00068793          	mv	a5,a3
   10b18:	fae42c23          	sw	a4,-72(s0)
   10b1c:	faf42e23          	sw	a5,-68(s0)
    TEST_LOGGER("  Cycles: ");
   10b20:	000117b7          	lui	a5,0x11
   10b24:	d7478793          	addi	a5,a5,-652 # 10d74 <rsqrt_table+0x80>
   10b28:	0007a683          	lw	a3,0(a5)
   10b2c:	0047a703          	lw	a4,4(a5)
   10b30:	fad42423          	sw	a3,-88(s0)
   10b34:	fae42623          	sw	a4,-84(s0)
   10b38:	0087d703          	lhu	a4,8(a5)
   10b3c:	fae41823          	sh	a4,-80(s0)
   10b40:	00a7c783          	lbu	a5,10(a5)
   10b44:	faf40923          	sb	a5,-78(s0)
   10b48:	fa840793          	addi	a5,s0,-88
   10b4c:	00a00713          	li	a4,10
   10b50:	04000893          	li	a7,64
   10b54:	00100513          	li	a0,1
   10b58:	00f005b3          	add	a1,zero,a5
   10b5c:	00070613          	mv	a2,a4
   10b60:	00000073          	ecall
    print_dec((unsigned long) cycles_elapsed);
   10b64:	fc042783          	lw	a5,-64(s0)
   10b68:	00078513          	mv	a0,a5
   10b6c:	9ddff0ef          	jal	10548 <print_dec>
    TEST_LOGGER("  Instructions: ");
   10b70:	000117b7          	lui	a5,0x11
   10b74:	d8078793          	addi	a5,a5,-640 # 10d80 <rsqrt_table+0x8c>
   10b78:	0007a583          	lw	a1,0(a5)
   10b7c:	0047a603          	lw	a2,4(a5)
   10b80:	0087a683          	lw	a3,8(a5)
   10b84:	00c7a703          	lw	a4,12(a5)
   10b88:	f8b42a23          	sw	a1,-108(s0)
   10b8c:	f8c42c23          	sw	a2,-104(s0)
   10b90:	f8d42e23          	sw	a3,-100(s0)
   10b94:	fae42023          	sw	a4,-96(s0)
   10b98:	0107c783          	lbu	a5,16(a5)
   10b9c:	faf40223          	sb	a5,-92(s0)
   10ba0:	f9440793          	addi	a5,s0,-108
   10ba4:	01000713          	li	a4,16
   10ba8:	04000893          	li	a7,64
   10bac:	00100513          	li	a0,1
   10bb0:	00f005b3          	add	a1,zero,a5
   10bb4:	00070613          	mv	a2,a4
   10bb8:	00000073          	ecall
    print_dec((unsigned long) instret_elapsed);
   10bbc:	fb842783          	lw	a5,-72(s0)
   10bc0:	00078513          	mv	a0,a5
   10bc4:	985ff0ef          	jal	10548 <print_dec>
    TEST_LOGGER("\n");
   10bc8:	00a00793          	li	a5,10
   10bcc:	f8f41823          	sh	a5,-112(s0)
   10bd0:	f9040793          	addi	a5,s0,-112
   10bd4:	00100713          	li	a4,1
   10bd8:	04000893          	li	a7,64
   10bdc:	00100513          	li	a0,1
   10be0:	00f005b3          	add	a1,zero,a5
   10be4:	00070613          	mv	a2,a4
   10be8:	00000073          	ecall
    return 0;
   10bec:	00000793          	li	a5,0
   10bf0:	00078513          	mv	a0,a5
   10bf4:	06c12083          	lw	ra,108(sp)
   10bf8:	06812403          	lw	s0,104(sp)
   10bfc:	07010113          	addi	sp,sp,112
   10c00:	00008067          	ret

00010c04 <get_cycles>:
.text

.globl get_cycles
.align 2
get_cycles:
    csrr a1, cycleh
   10c04:	c80025f3          	rdcycleh	a1
    csrr a0, cycle
   10c08:	c0002573          	rdcycle	a0
    csrr a2, cycleh
   10c0c:	c8002673          	rdcycleh	a2
    bne a1, a2, get_cycles
   10c10:	fec59ae3          	bne	a1,a2,10c04 <get_cycles>
    ret
   10c14:	00008067          	ret

00010c18 <get_instret>:

# Read 64-bit instruction retired counter
.globl get_instret
.align 2
get_instret:
    csrr a1, instreth
   10c18:	c82025f3          	rdinstreth	a1
    csrr a0, instret
   10c1c:	c0202573          	rdinstret	a0
    csrr a2, instreth
   10c20:	c8202673          	rdinstreth	a2
    bne a1, a2, get_instret
   10c24:	fec59ae3          	bne	a1,a2,10c18 <get_instret>
    ret
   10c28:	00008067          	ret
