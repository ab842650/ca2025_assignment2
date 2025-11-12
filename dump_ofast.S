
test.elf:     file format elf32-littleriscv


Disassembly of section .text:

00010000 <_start>:
.globl _start
.type _start, @function

_start:
    # Set up stack pointer
    la sp, __stack_top
   10000:	00002117          	auipc	sp,0x2
   10004:	8d010113          	addi	sp,sp,-1840 # 118d0 <__stack_top>

    # Clear BSS
    la t0, __bss_start
   10008:	00001297          	auipc	t0,0x1
   1000c:	8c028293          	addi	t0,t0,-1856 # 108c8 <__bss_end>
    la t1, __bss_end
   10010:	00001317          	auipc	t1,0x1
   10014:	8b830313          	addi	t1,t1,-1864 # 108c8 <__bss_end>
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
   10028:	240000ef          	jal	10268 <main>

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

0001003c <print_dec>:
   1003c:	fe010113          	addi	sp,sp,-32
/* Simple integer to decimal string conversion */
static void print_dec(unsigned long val)
{
    char buf[20];
    char *p = buf + sizeof(buf) - 1;
    *p = '\n';
   10040:	00a00793          	li	a5,10
   10044:	00f10fa3          	sb	a5,31(sp)
    p--;

    if (val == 0) {
   10048:	02051c63          	bnez	a0,10080 <print_dec+0x44>
        *p = '0';
   1004c:	03000793          	li	a5,48
   10050:	00f10f23          	sb	a5,30(sp)
        p--;
   10054:	01d10313          	addi	t1,sp,29
            p--;
            val = udiv(val, 10);
        }
    }

    p++;
   10058:	00130313          	addi	t1,t1,1
    printstr(p, (buf + sizeof(buf) - p));
   1005c:	02010793          	addi	a5,sp,32
   10060:	406787b3          	sub	a5,a5,t1
   10064:	04000893          	li	a7,64
   10068:	00100513          	li	a0,1
   1006c:	006005b3          	add	a1,zero,t1
   10070:	00078613          	mv	a2,a5
   10074:	00000073          	ecall
}
   10078:	02010113          	addi	sp,sp,32
   1007c:	00008067          	ret
    p--;
   10080:	01e10313          	addi	t1,sp,30
        if (remainder >= divisor) {
   10084:	00900593          	li	a1,9
    for (int i = 31; i >= 0; i--) {
   10088:	fff00613          	li	a2,-1
            quotient |= (1UL << i);
   1008c:	00100893          	li	a7,1
    for (int i = 31; i >= 0; i--) {
   10090:	01f00713          	li	a4,31
    unsigned long remainder = 0;
   10094:	00000793          	li	a5,0
        remainder |= (dividend >> i) & 1;
   10098:	00e556b3          	srl	a3,a0,a4
        remainder <<= 1;
   1009c:	00179793          	slli	a5,a5,0x1
        remainder |= (dividend >> i) & 1;
   100a0:	0016f693          	andi	a3,a3,1
   100a4:	00f6e7b3          	or	a5,a3,a5
    for (int i = 31; i >= 0; i--) {
   100a8:	fff70713          	addi	a4,a4,-1
        if (remainder >= divisor) {
   100ac:	00f5f463          	bgeu	a1,a5,100b4 <print_dec+0x78>
            remainder -= divisor;
   100b0:	ff678793          	addi	a5,a5,-10
    for (int i = 31; i >= 0; i--) {
   100b4:	fec712e3          	bne	a4,a2,10098 <print_dec+0x5c>
            *p = '0' + umod(val, 10);
   100b8:	03078793          	addi	a5,a5,48
   100bc:	00f30023          	sb	a5,0(t1)
    unsigned long quotient = 0;
   100c0:	00000813          	li	a6,0
            p--;
   100c4:	fff30313          	addi	t1,t1,-1
    for (int i = 31; i >= 0; i--) {
   100c8:	01f00713          	li	a4,31
    unsigned long remainder = 0;
   100cc:	00000793          	li	a5,0
        remainder |= (dividend >> i) & 1;
   100d0:	00e556b3          	srl	a3,a0,a4
   100d4:	0016f693          	andi	a3,a3,1
        remainder <<= 1;
   100d8:	00179793          	slli	a5,a5,0x1
        remainder |= (dividend >> i) & 1;
   100dc:	00f6e7b3          	or	a5,a3,a5
            quotient |= (1UL << i);
   100e0:	00e896b3          	sll	a3,a7,a4
    for (int i = 31; i >= 0; i--) {
   100e4:	fff70713          	addi	a4,a4,-1
        if (remainder >= divisor) {
   100e8:	00f5f663          	bgeu	a1,a5,100f4 <print_dec+0xb8>
            remainder -= divisor;
   100ec:	ff678793          	addi	a5,a5,-10
            quotient |= (1UL << i);
   100f0:	00d86833          	or	a6,a6,a3
    for (int i = 31; i >= 0; i--) {
   100f4:	fcc71ee3          	bne	a4,a2,100d0 <print_dec+0x94>
        while (val > 0) {
   100f8:	f60800e3          	beqz	a6,10058 <print_dec+0x1c>
   100fc:	00080513          	mv	a0,a6
   10100:	f91ff06f          	j	10090 <print_dec+0x54>

00010104 <memcpy>:
    while (n--)
   10104:	fff60813          	addi	a6,a2,-1
   10108:	08060e63          	beqz	a2,101a4 <memcpy+0xa0>
   1010c:	00600793          	li	a5,6
   10110:	00158713          	addi	a4,a1,1
   10114:	0707fa63          	bgeu	a5,a6,10188 <memcpy+0x84>
   10118:	00b567b3          	or	a5,a0,a1
   1011c:	0037f793          	andi	a5,a5,3
   10120:	00158713          	addi	a4,a1,1
   10124:	06079263          	bnez	a5,10188 <memcpy+0x84>
   10128:	40e507b3          	sub	a5,a0,a4
   1012c:	0037b793          	sltiu	a5,a5,3
   10130:	04079c63          	bnez	a5,10188 <memcpy+0x84>
   10134:	ffc67893          	andi	a7,a2,-4
   10138:	011586b3          	add	a3,a1,a7
   1013c:	00050793          	mv	a5,a0
        *d++ = *s++;
   10140:	0005a703          	lw	a4,0(a1)
   10144:	00458593          	addi	a1,a1,4
   10148:	00478793          	addi	a5,a5,4
   1014c:	fee7ae23          	sw	a4,-4(a5)
    while (n--)
   10150:	feb698e3          	bne	a3,a1,10140 <memcpy+0x3c>
   10154:	41180833          	sub	a6,a6,a7
   10158:	011507b3          	add	a5,a0,a7
   1015c:	05160463          	beq	a2,a7,101a4 <memcpy+0xa0>
        *d++ = *s++;
   10160:	0006c703          	lbu	a4,0(a3)
   10164:	00e78023          	sb	a4,0(a5)
    while (n--)
   10168:	02080e63          	beqz	a6,101a4 <memcpy+0xa0>
        *d++ = *s++;
   1016c:	0016c603          	lbu	a2,1(a3)
    while (n--)
   10170:	00100713          	li	a4,1
        *d++ = *s++;
   10174:	00c780a3          	sb	a2,1(a5)
    while (n--)
   10178:	02e80663          	beq	a6,a4,101a4 <memcpy+0xa0>
        *d++ = *s++;
   1017c:	0026c703          	lbu	a4,2(a3)
   10180:	00e78123          	sb	a4,2(a5)
    while (n--)
   10184:	00008067          	ret
   10188:	00c50633          	add	a2,a0,a2
    uint8_t *d = (uint8_t *) dest;
   1018c:	00050793          	mv	a5,a0
        *d++ = *s++;
   10190:	fff74683          	lbu	a3,-1(a4)
   10194:	00178793          	addi	a5,a5,1
   10198:	00170713          	addi	a4,a4,1
   1019c:	fed78fa3          	sb	a3,-1(a5)
    while (n--)
   101a0:	fec798e3          	bne	a5,a2,10190 <memcpy+0x8c>
}
   101a4:	00008067          	ret

000101a8 <clz>:
    c = (x < 0x00010000) << 4;
   101a8:	000105b7          	lui	a1,0x10
   101ac:	00b535b3          	sltu	a1,a0,a1
   101b0:	00459593          	slli	a1,a1,0x4
    x <<= c;  // off 16
   101b4:	00b517b3          	sll	a5,a0,a1
    c = (x < 0x01000000) << 3;
   101b8:	01000737          	lui	a4,0x1000
   101bc:	00e7b733          	sltu	a4,a5,a4
   101c0:	00371713          	slli	a4,a4,0x3
    x <<= c;  // off 8
   101c4:	00e797b3          	sll	a5,a5,a4
    c = (x < 0x10000000) << 2;
   101c8:	10000637          	lui	a2,0x10000
   101cc:	00c7b633          	sltu	a2,a5,a2
   101d0:	00261613          	slli	a2,a2,0x2
    x <<= c;  // off 4
   101d4:	00c797b3          	sll	a5,a5,a2
    c = (x < 0x40000000) << 1;
   101d8:	400006b7          	lui	a3,0x40000
   101dc:	00d7b6b3          	sltu	a3,a5,a3
   101e0:	00169693          	slli	a3,a3,0x1
    x <<= c;  // off 2
   101e4:	00d797b3          	sll	a5,a5,a3
    r += c;
   101e8:	00b70533          	add	a0,a4,a1
    c = x < 0x80000000;
   101ec:	fff7c713          	not	a4,a5
   101f0:	01f75713          	srli	a4,a4,0x1f
    r += c;
   101f4:	00c50533          	add	a0,a0,a2
    r += c;
   101f8:	00d50533          	add	a0,a0,a3
    x <<= c;  // off 1
   101fc:	00e797b3          	sll	a5,a5,a4
    r += x == 0;
   10200:	0017b793          	seqz	a5,a5
    r += c;
   10204:	00e50533          	add	a0,a0,a4
}
   10208:	00a78533          	add	a0,a5,a0
   1020c:	00008067          	ret

00010210 <__mulsi3>:
{
   10210:	00050713          	mv	a4,a0
    uint32_t result = 0;
   10214:	00000513          	li	a0,0
    while (b) {
   10218:	02058263          	beqz	a1,1023c <__mulsi3+0x2c>
        if (b & 1)
   1021c:	0015f793          	andi	a5,a1,1
   10220:	40f007b3          	neg	a5,a5
   10224:	00e7f7b3          	and	a5,a5,a4
        b >>= 1;
   10228:	0015d593          	srli	a1,a1,0x1
        if (b & 1)
   1022c:	00f50533          	add	a0,a0,a5
        a <<= 1;
   10230:	00171713          	slli	a4,a4,0x1
    while (b) {
   10234:	fe0594e3          	bnez	a1,1021c <__mulsi3+0xc>
   10238:	00008067          	ret
}
   1023c:	00008067          	ret

00010240 <get_cycles>:
.text

.globl get_cycles
.align 2
get_cycles:
    csrr a1, cycleh
   10240:	c80025f3          	rdcycleh	a1
    csrr a0, cycle
   10244:	c0002573          	rdcycle	a0
    csrr a2, cycleh
   10248:	c8002673          	rdcycleh	a2
    bne a1, a2, get_cycles
   1024c:	fec59ae3          	bne	a1,a2,10240 <get_cycles>
    ret
   10250:	00008067          	ret

00010254 <get_instret>:

# Read 64-bit instruction retired counter
.globl get_instret
.align 2
get_instret:
    csrr a1, instreth
   10254:	c82025f3          	rdinstreth	a1
    csrr a0, instret
   10258:	c0202573          	rdinstret	a0
    csrr a2, instreth
   1025c:	c8202673          	rdinstreth	a2
    bne a1, a2, get_instret
   10260:	fec59ae3          	bne	a1,a2,10254 <get_instret>
    ret
   10264:	00008067          	ret

Disassembly of section .text.startup:

00010268 <main>:

    return y;
}

int main(void)
{
   10268:	f8010113          	addi	sp,sp,-128
   1026c:	06112e23          	sw	ra,124(sp)
   10270:	06912a23          	sw	s1,116(sp)
   10274:	07412423          	sw	s4,104(sp)
   10278:	05812c23          	sw	s8,88(sp)
   1027c:	05912a23          	sw	s9,84(sp)
   10280:	05a12823          	sw	s10,80(sp)
   10284:	05b12623          	sw	s11,76(sp)
   10288:	06812c23          	sw	s0,120(sp)
   1028c:	07212823          	sw	s2,112(sp)
   10290:	07312623          	sw	s3,108(sp)
   10294:	07512223          	sw	s5,100(sp)
   10298:	07612023          	sw	s6,96(sp)
   1029c:	05712e23          	sw	s7,92(sp)
    uint64_t start_cycles = get_cycles();
   102a0:	fa1ff0ef          	jal	10240 <get_cycles>
   102a4:	00050a13          	mv	s4,a0
    uint64_t start_instret = get_instret();
   102a8:	00010c37          	lui	s8,0x10
   102ac:	fa9ff0ef          	jal	10254 <get_instret>
   102b0:	780c0793          	addi	a5,s8,1920 # 10780 <RSQRT_INPUTS>
   102b4:	00f12a23          	sw	a5,20(sp)
   102b8:	00000493          	li	s1,0
    uint32_t y_next = (exp < 31u) ? rsqrt_table[exp + 1u] : 1u;
   102bc:	01412c23          	sw	s4,24(sp)
   102c0:	00a12e23          	sw	a0,28(sp)
    if (x == 0)
   102c4:	00478c93          	addi	s9,a5,4
            *p = (digit < 10) ? ('0' + digit) : ('a' + digit - 10);
   102c8:	00900d13          	li	s10,9
    c = (x < 0x00010000) << 4;
   102cc:	00010db7          	lui	s11,0x10
    if (x == 0)
   102d0:	30048c63          	beqz	s1,105e8 <main+0x380>
    if (x == UINT32_MAX)
   102d4:	fff00793          	li	a5,-1
   102d8:	36f48063          	beq	s1,a5,10638 <main+0x3d0>
    c = (x < 0x00010000) << 4;
   102dc:	01b4b733          	sltu	a4,s1,s11
   102e0:	00471713          	slli	a4,a4,0x4
    x <<= c;  // off 16
   102e4:	00e497b3          	sll	a5,s1,a4
    c = (x < 0x01000000) << 3;
   102e8:	010006b7          	lui	a3,0x1000
   102ec:	00d7b6b3          	sltu	a3,a5,a3
   102f0:	00369693          	slli	a3,a3,0x3
    x <<= c;  // off 8
   102f4:	00d797b3          	sll	a5,a5,a3
    c = (x < 0x10000000) << 2;
   102f8:	10000637          	lui	a2,0x10000
   102fc:	00c7b5b3          	sltu	a1,a5,a2
   10300:	00259593          	slli	a1,a1,0x2
    x <<= c;  // off 4
   10304:	00b797b3          	sll	a5,a5,a1
    c = (x < 0x40000000) << 1;
   10308:	40000637          	lui	a2,0x40000
   1030c:	00c7b633          	sltu	a2,a5,a2
   10310:	00161613          	slli	a2,a2,0x1
    x <<= c;  // off 2
   10314:	00c797b3          	sll	a5,a5,a2
    r += c;
   10318:	00d70733          	add	a4,a4,a3
    c = x < 0x80000000;
   1031c:	fff7c693          	not	a3,a5
   10320:	01f6d693          	srli	a3,a3,0x1f
    r += c;
   10324:	00b70733          	add	a4,a4,a1
    r += c;
   10328:	00c70733          	add	a4,a4,a2
    x <<= c;  // off 1
   1032c:	00d797b3          	sll	a5,a5,a3
    r += c;
   10330:	00d70733          	add	a4,a4,a3
    r += x == 0;
   10334:	0017b793          	seqz	a5,a5
   10338:	00e787b3          	add	a5,a5,a4
    uint32_t y_base = rsqrt_table[exp]; /* Value at 2^exp */
   1033c:	01412583          	lw	a1,20(sp)
    uint32_t exp = 31u - clz(x);
   10340:	01f00713          	li	a4,31
   10344:	40f70633          	sub	a2,a4,a5
    uint32_t y_base = rsqrt_table[exp]; /* Value at 2^exp */
   10348:	00261693          	slli	a3,a2,0x2
   1034c:	00d586b3          	add	a3,a1,a3
                                    : (x - (1u << exp)) << (16 - exp);
   10350:	00100713          	li	a4,1
    uint32_t y_base = rsqrt_table[exp]; /* Value at 2^exp */
   10354:	0c86a903          	lw	s2,200(a3) # 10000c8 <__stack_top+0xfee7f8>
                                    : (x - (1u << exp)) << (16 - exp);
   10358:	00c71733          	sll	a4,a4,a2
    uint32_t y_next = (exp < 31u) ? rsqrt_table[exp + 1u] : 1u;
   1035c:	01e00693          	li	a3,30
                                    : (x - (1u << exp)) << (16 - exp);
   10360:	40e48733          	sub	a4,s1,a4
    uint32_t y_next = (exp < 31u) ? rsqrt_table[exp + 1u] : 1u;
   10364:	2cc6e063          	bltu	a3,a2,10624 <main+0x3bc>
   10368:	02000693          	li	a3,32
   1036c:	40f686b3          	sub	a3,a3,a5
   10370:	00269693          	slli	a3,a3,0x2
   10374:	00d586b3          	add	a3,a1,a3
                                    : (x - (1u << exp)) << (16 - exp);
   10378:	00f00593          	li	a1,15
    uint32_t y_next = (exp < 31u) ? rsqrt_table[exp + 1u] : 1u;
   1037c:	0c86a683          	lw	a3,200(a3)
                                    : (x - (1u << exp)) << (16 - exp);
   10380:	2ac5e463          	bltu	a1,a2,10628 <main+0x3c0>
   10384:	ff178793          	addi	a5,a5,-15
   10388:	00f71733          	sll	a4,a4,a5
    uint32_t y = y_base - (umul((y_base - y_next), fraction) >> 16);
   1038c:	40d906b3          	sub	a3,s2,a3
    while (b) {
   10390:	02070663          	beqz	a4,103bc <main+0x154>
    uint32_t result = 0;
   10394:	00000613          	li	a2,0
        if (b & 1)
   10398:	00177793          	andi	a5,a4,1
   1039c:	40f007b3          	neg	a5,a5
   103a0:	00d7f7b3          	and	a5,a5,a3
        b >>= 1;
   103a4:	00175713          	srli	a4,a4,0x1
        if (b & 1)
   103a8:	00f60633          	add	a2,a2,a5
        a <<= 1;
   103ac:	00169693          	slli	a3,a3,0x1
    while (b) {
   103b0:	fe0714e3          	bnez	a4,10398 <main+0x130>
    uint32_t y = y_base - (umul((y_base - y_next), fraction) >> 16);
   103b4:	01065613          	srli	a2,a2,0x10
   103b8:	40c90933          	sub	s2,s2,a2
    uint32_t a_lo = a & 0xFFFFu, a_hi = a >> 16;
   103bc:	01091993          	slli	s3,s2,0x10
   103c0:	0109d993          	srli	s3,s3,0x10
    uint32_t p0 = a_lo * b_lo;
   103c4:	00098593          	mv	a1,s3
   103c8:	00098513          	mv	a0,s3
   103cc:	e45ff0ef          	jal	10210 <__mulsi3>
    uint32_t a_lo = a & 0xFFFFu, a_hi = a >> 16;
   103d0:	01095913          	srli	s2,s2,0x10
    uint32_t p0 = a_lo * b_lo;
   103d4:	00050b13          	mv	s6,a0
    uint32_t p1 = a_lo * b_hi;
   103d8:	00090593          	mv	a1,s2
   103dc:	00098513          	mv	a0,s3
   103e0:	e31ff0ef          	jal	10210 <__mulsi3>
    uint32_t mid = (p0 >> 16) + (p1 & 0xFFFFu) + (p2 & 0xFFFFu);
   103e4:	01051413          	slli	s0,a0,0x10
   103e8:	01045413          	srli	s0,s0,0x10
   103ec:	010b5793          	srli	a5,s6,0x10
   103f0:	00141413          	slli	s0,s0,0x1
   103f4:	00f40433          	add	s0,s0,a5
    uint32_t lo_res = (p0 & 0xFFFFu) | (mid << 16);
   103f8:	010b1b13          	slli	s6,s6,0x10
   103fc:	01041793          	slli	a5,s0,0x10
    uint32_t hi_res = p3 + (p1 >> 16) + (p2 >> 16) + (mid >> 16);
   10400:	01055c13          	srli	s8,a0,0x10
    uint32_t p3 = a_hi * b_hi;
   10404:	00090593          	mv	a1,s2
    uint32_t lo_res = (p0 & 0xFFFFu) | (mid << 16);
   10408:	010b5b13          	srli	s6,s6,0x10
    uint32_t p3 = a_hi * b_hi;
   1040c:	00090513          	mv	a0,s2
    uint32_t lo_res = (p0 & 0xFFFFu) | (mid << 16);
   10410:	00fb6b33          	or	s6,s6,a5
    uint32_t hi_res = p3 + (p1 >> 16) + (p2 >> 16) + (mid >> 16);
   10414:	001c1c13          	slli	s8,s8,0x1
    uint32_t p3 = a_hi * b_hi;
   10418:	df9ff0ef          	jal	10210 <__mulsi3>
    uint32_t hi_res = p3 + (p1 >> 16) + (p2 >> 16) + (mid >> 16);
   1041c:	01045413          	srli	s0,s0,0x10
   10420:	00ac0c33          	add	s8,s8,a0
   10424:	008c0c33          	add	s8,s8,s0
    uint32_t a_lo = a & 0xFFFFu, a_hi = a >> 16;
   10428:	01049b93          	slli	s7,s1,0x10
    uint32_t b_lo = b & 0xFFFFu, b_hi = b >> 16;
   1042c:	010c1613          	slli	a2,s8,0x10
   10430:	01065613          	srli	a2,a2,0x10
    uint32_t a_lo = a & 0xFFFFu, a_hi = a >> 16;
   10434:	010bdb93          	srli	s7,s7,0x10
    uint32_t p0 = a_lo * b_lo;
   10438:	00060593          	mv	a1,a2
   1043c:	000b8513          	mv	a0,s7
    uint32_t b_lo = b & 0xFFFFu, b_hi = b >> 16;
   10440:	010b1413          	slli	s0,s6,0x10
    uint32_t p0 = a_lo * b_lo;
   10444:	00c12823          	sw	a2,16(sp)
    uint32_t b_lo = b & 0xFFFFu, b_hi = b >> 16;
   10448:	01045413          	srli	s0,s0,0x10
    uint32_t p0 = a_lo * b_lo;
   1044c:	dc5ff0ef          	jal	10210 <__mulsi3>
   10450:	000b8593          	mv	a1,s7
   10454:	00050a93          	mv	s5,a0
   10458:	00040513          	mv	a0,s0
   1045c:	db5ff0ef          	jal	10210 <__mulsi3>
    uint32_t b_lo = b & 0xFFFFu, b_hi = b >> 16;
   10460:	010b5b13          	srli	s6,s6,0x10
    uint32_t p0 = a_lo * b_lo;
   10464:	00050793          	mv	a5,a0
    uint32_t p1 = a_lo * b_hi;
   10468:	000b8593          	mv	a1,s7
   1046c:	000b0513          	mv	a0,s6
    uint32_t a_lo = a & 0xFFFFu, a_hi = a >> 16;
   10470:	0104d493          	srli	s1,s1,0x10
    uint32_t p0 = a_lo * b_lo;
   10474:	00f12623          	sw	a5,12(sp)
    uint32_t p1 = a_lo * b_hi;
   10478:	d99ff0ef          	jal	10210 <__mulsi3>
   1047c:	00050693          	mv	a3,a0
    uint32_t p2 = a_hi * b_lo;
   10480:	00048593          	mv	a1,s1
   10484:	00040513          	mv	a0,s0
    uint32_t p1 = a_lo * b_hi;
   10488:	00068413          	mv	s0,a3
    uint32_t p2 = a_hi * b_lo;
   1048c:	d85ff0ef          	jal	10210 <__mulsi3>
    uint32_t mid = (p0 >> 16) + (p1 & 0xFFFFu) + (p2 & 0xFFFFu);
   10490:	00c12783          	lw	a5,12(sp)
   10494:	01041893          	slli	a7,s0,0x10
   10498:	0108d893          	srli	a7,a7,0x10
    uint32_t p2 = a_hi * b_lo;
   1049c:	00050a13          	mv	s4,a0
    uint32_t mid = (p0 >> 16) + (p1 & 0xFFFFu) + (p2 & 0xFFFFu);
   104a0:	01051813          	slli	a6,a0,0x10
   104a4:	0107d793          	srli	a5,a5,0x10
   104a8:	01178bb3          	add	s7,a5,a7
   104ac:	01085813          	srli	a6,a6,0x10
    uint32_t hi_res = p3 + (p1 >> 16) + (p2 >> 16) + (mid >> 16);
   104b0:	010a5693          	srli	a3,s4,0x10
    uint32_t termA = (lo1 << 16);
   104b4:	010a9713          	slli	a4,s5,0x10
    uint32_t p3 = a_hi * b_hi;
   104b8:	00048593          	mv	a1,s1
    uint32_t term = (3u << 16) - xy2;
   104bc:	000307b7          	lui	a5,0x30
    uint32_t p3 = a_hi * b_hi;
   104c0:	000b0513          	mv	a0,s6
    uint32_t hi_res = p3 + (p1 >> 16) + (p2 >> 16) + (mid >> 16);
   104c4:	01045413          	srli	s0,s0,0x10
    uint32_t mid = (p0 >> 16) + (p1 & 0xFFFFu) + (p2 & 0xFFFFu);
   104c8:	010b8bb3          	add	s7,s7,a6
    uint32_t hi_res = p3 + (p1 >> 16) + (p2 >> 16) + (mid >> 16);
   104cc:	00d40433          	add	s0,s0,a3
    uint32_t term = (3u << 16) - xy2;
   104d0:	40e784b3          	sub	s1,a5,a4
    uint32_t p3 = a_hi * b_hi;
   104d4:	d3dff0ef          	jal	10210 <__mulsi3>
    uint32_t hi_res = p3 + (p1 >> 16) + (p2 >> 16) + (mid >> 16);
   104d8:	010bd713          	srli	a4,s7,0x10
   104dc:	00a407b3          	add	a5,s0,a0
   104e0:	00e787b3          	add	a5,a5,a4
    uint32_t termB = (hi2 << 16) | (lo2 >> 16);
   104e4:	010b9b93          	slli	s7,s7,0x10
   104e8:	010bdb93          	srli	s7,s7,0x10
   104ec:	01079793          	slli	a5,a5,0x10
   104f0:	0177e7b3          	or	a5,a5,s7
    uint32_t term = (3u << 16) - xy2;
   104f4:	40f484b3          	sub	s1,s1,a5
    uint32_t b_lo = b & 0xFFFFu, b_hi = b >> 16;
   104f8:	01049b13          	slli	s6,s1,0x10
   104fc:	010b5b13          	srli	s6,s6,0x10
    uint32_t p0 = a_lo * b_lo;
   10500:	00098593          	mv	a1,s3
   10504:	000b0513          	mv	a0,s6
   10508:	d09ff0ef          	jal	10210 <__mulsi3>
    uint32_t b_lo = b & 0xFFFFu, b_hi = b >> 16;
   1050c:	0104d493          	srli	s1,s1,0x10
    uint32_t p0 = a_lo * b_lo;
   10510:	00050413          	mv	s0,a0
    uint32_t p1 = a_lo * b_hi;
   10514:	00098593          	mv	a1,s3
   10518:	00048513          	mv	a0,s1
   1051c:	cf5ff0ef          	jal	10210 <__mulsi3>
   10520:	00050993          	mv	s3,a0
    uint32_t p2 = a_hi * b_lo;
   10524:	00090593          	mv	a1,s2
   10528:	000b0513          	mv	a0,s6
   1052c:	ce5ff0ef          	jal	10210 <__mulsi3>
    uint32_t mid = (p0 >> 16) + (p1 & 0xFFFFu) + (p2 & 0xFFFFu);
   10530:	01099613          	slli	a2,s3,0x10
   10534:	01045793          	srli	a5,s0,0x10
    uint32_t p2 = a_hi * b_lo;
   10538:	00050713          	mv	a4,a0
    uint32_t mid = (p0 >> 16) + (p1 & 0xFFFFu) + (p2 & 0xFFFFu);
   1053c:	01065613          	srli	a2,a2,0x10
   10540:	01051693          	slli	a3,a0,0x10
   10544:	0106d693          	srli	a3,a3,0x10
    uint32_t hi_res = p3 + (p1 >> 16) + (p2 >> 16) + (mid >> 16);
   10548:	01075713          	srli	a4,a4,0x10
    uint32_t p3 = a_hi * b_hi;
   1054c:	00048513          	mv	a0,s1
   10550:	00090593          	mv	a1,s2
    uint32_t mid = (p0 >> 16) + (p1 & 0xFFFFu) + (p2 & 0xFFFFu);
   10554:	00c784b3          	add	s1,a5,a2
    uint32_t hi_res = p3 + (p1 >> 16) + (p2 >> 16) + (mid >> 16);
   10558:	0109d993          	srli	s3,s3,0x10
    uint32_t mid = (p0 >> 16) + (p1 & 0xFFFFu) + (p2 & 0xFFFFu);
   1055c:	00d484b3          	add	s1,s1,a3
    uint32_t hi_res = p3 + (p1 >> 16) + (p2 >> 16) + (mid >> 16);
   10560:	00e989b3          	add	s3,s3,a4
    uint32_t lo_res = (p0 & 0xFFFFu) | (mid << 16);
   10564:	01041413          	slli	s0,s0,0x10
    uint32_t p3 = a_hi * b_hi;
   10568:	ca9ff0ef          	jal	10210 <__mulsi3>
    uint32_t lo_res = (p0 & 0xFFFFu) | (mid << 16);
   1056c:	01049793          	slli	a5,s1,0x10
   10570:	01045413          	srli	s0,s0,0x10
   10574:	00f46433          	or	s0,s0,a5
   10578:	01b40733          	add	a4,s0,s11
    uint32_t hi_res = p3 + (p1 >> 16) + (p2 >> 16) + (mid >> 16);
   1057c:	00a989b3          	add	s3,s3,a0
   10580:	0104d493          	srli	s1,s1,0x10
    uint32_t hi_plus = hi + (lo_plus < lo);
   10584:	008737b3          	sltu	a5,a4,s0
    uint32_t hi_res = p3 + (p1 >> 16) + (p2 >> 16) + (mid >> 16);
   10588:	009989b3          	add	s3,s3,s1
    uint32_t hi_plus = hi + (lo_plus < lo);
   1058c:	013787b3          	add	a5,a5,s3
    return (hi_plus << 15) | (lo_plus >> 17);
   10590:	00f79793          	slli	a5,a5,0xf
   10594:	01175713          	srli	a4,a4,0x11
    *p = '\n';
   10598:	00a00693          	li	a3,10
   1059c:	02d10fa3          	sb	a3,63(sp)
    return (hi_plus << 15) | (lo_plus >> 17);
   105a0:	00e7e7b3          	or	a5,a5,a4
    if (val == 0) {
   105a4:	04079863          	bnez	a5,105f4 <main+0x38c>
        *p = '0';
   105a8:	03000793          	li	a5,48
   105ac:	02f10f23          	sb	a5,62(sp)
        p--;
   105b0:	03e10713          	addi	a4,sp,62
    printstr(p, (buf + sizeof(buf) - p));
   105b4:	04010793          	addi	a5,sp,64
   105b8:	40e787b3          	sub	a5,a5,a4
   105bc:	04000893          	li	a7,64
   105c0:	00100513          	li	a0,1
   105c4:	00e005b3          	add	a1,zero,a4
   105c8:	00078613          	mv	a2,a5
   105cc:	00000073          	ecall
    for (int i = 0; i < 50; i++) {
   105d0:	000117b7          	lui	a5,0x11
   105d4:	84878793          	addi	a5,a5,-1976 # 10848 <rsqrt_table>
   105d8:	06fc8863          	beq	s9,a5,10648 <main+0x3e0>
        uint32_t y = rsqrt(RSQRT_INPUTS[i]);
   105dc:	000ca483          	lw	s1,0(s9)
   105e0:	004c8c93          	addi	s9,s9,4
    if (x == 0)
   105e4:	ce0498e3          	bnez	s1,102d4 <main+0x6c>
    *p = '\n';
   105e8:	00a00793          	li	a5,10
   105ec:	02f10fa3          	sb	a5,63(sp)
        return 0xFFFFFFFF;
   105f0:	fff00793          	li	a5,-1
    uint32_t result = 0;
   105f4:	03e10713          	addi	a4,sp,62
   105f8:	0080006f          	j	10600 <main+0x398>
            p--;
   105fc:	00068713          	mv	a4,a3
            *p = (digit < 10) ? ('0' + digit) : ('a' + digit - 10);
   10600:	00f7f613          	andi	a2,a5,15
   10604:	05760693          	addi	a3,a2,87 # 40000057 <__stack_top+0x3ffee787>
            val >>= 4;
   10608:	0047d793          	srli	a5,a5,0x4
            *p = (digit < 10) ? ('0' + digit) : ('a' + digit - 10);
   1060c:	00cd6463          	bltu	s10,a2,10614 <main+0x3ac>
   10610:	03060693          	addi	a3,a2,48
   10614:	00d70023          	sb	a3,0(a4) # 1000000 <__stack_top+0xfee730>
            p--;
   10618:	fff70693          	addi	a3,a4,-1
        while (val > 0) {
   1061c:	fe0790e3          	bnez	a5,105fc <main+0x394>
   10620:	f95ff06f          	j	105b4 <main+0x34c>
    uint32_t y_next = (exp < 31u) ? rsqrt_table[exp + 1u] : 1u;
   10624:	00100693          	li	a3,1
    uint32_t fraction = (exp >= 16) ? (x - (1u << exp)) >> (exp - 16)
   10628:	00f00613          	li	a2,15
   1062c:	40f607b3          	sub	a5,a2,a5
                                    : (x - (1u << exp)) << (16 - exp);
   10630:	00f75733          	srl	a4,a4,a5
   10634:	d59ff06f          	j	1038c <main+0x124>
    *p = '\n';
   10638:	00a00793          	li	a5,10
   1063c:	02f10fa3          	sb	a5,63(sp)
        return 1;
   10640:	00100793          	li	a5,1
   10644:	fb1ff06f          	j	105f4 <main+0x38c>
        print_hex(y);
    }
    uint64_t end_cycles = get_cycles();
   10648:	01c12a83          	lw	s5,28(sp)
   1064c:	01812a03          	lw	s4,24(sp)
   10650:	bf1ff0ef          	jal	10240 <get_cycles>
   10654:	00050493          	mv	s1,a0
    uint64_t end_instret = get_instret();
   10658:	bfdff0ef          	jal	10254 <get_instret>

    uint64_t cycles_elapsed = end_cycles - start_cycles;
    uint64_t instret_elapsed = end_instret - start_instret;
    TEST_LOGGER("  Cycles: ");
   1065c:	000107b7          	lui	a5,0x10
   10660:	76078793          	addi	a5,a5,1888 # 10760 <main+0x4f8>
   10664:	0007a603          	lw	a2,0(a5)
   10668:	0047a683          	lw	a3,4(a5)
   1066c:	0087d703          	lhu	a4,8(a5)
   10670:	00a7c783          	lbu	a5,10(a5)
    uint64_t instret_elapsed = end_instret - start_instret;
   10674:	41550ab3          	sub	s5,a0,s5
    TEST_LOGGER("  Cycles: ");
   10678:	02c12623          	sw	a2,44(sp)
   1067c:	02f10b23          	sb	a5,54(sp)
   10680:	02d12823          	sw	a3,48(sp)
   10684:	02e11a23          	sh	a4,52(sp)
   10688:	00a00913          	li	s2,10
   1068c:	02c10793          	addi	a5,sp,44
   10690:	04000893          	li	a7,64
   10694:	00100513          	li	a0,1
   10698:	00f005b3          	add	a1,zero,a5
   1069c:	00090613          	mv	a2,s2
   106a0:	00000073          	ecall
    print_dec((unsigned long) cycles_elapsed);
   106a4:	41448533          	sub	a0,s1,s4
   106a8:	995ff0ef          	jal	1003c <print_dec>
    TEST_LOGGER("  Instructions: ");
   106ac:	000107b7          	lui	a5,0x10
   106b0:	76c78793          	addi	a5,a5,1900 # 1076c <main+0x504>
   106b4:	00c7a703          	lw	a4,12(a5)
   106b8:	0007a583          	lw	a1,0(a5)
   106bc:	0047a603          	lw	a2,4(a5)
   106c0:	0087a683          	lw	a3,8(a5)
   106c4:	0107c783          	lbu	a5,16(a5)
   106c8:	02e12c23          	sw	a4,56(sp)
   106cc:	02b12623          	sw	a1,44(sp)
   106d0:	02f10e23          	sb	a5,60(sp)
   106d4:	02c12823          	sw	a2,48(sp)
   106d8:	02d12a23          	sw	a3,52(sp)
   106dc:	01000793          	li	a5,16
   106e0:	02c10713          	addi	a4,sp,44
   106e4:	04000893          	li	a7,64
   106e8:	00100513          	li	a0,1
   106ec:	00e005b3          	add	a1,zero,a4
   106f0:	00078613          	mv	a2,a5
   106f4:	00000073          	ecall
    print_dec((unsigned long) instret_elapsed);
   106f8:	000a8513          	mv	a0,s5
   106fc:	941ff0ef          	jal	1003c <print_dec>
    TEST_LOGGER("\n");
   10700:	00100793          	li	a5,1
   10704:	03211623          	sh	s2,44(sp)
   10708:	02c10713          	addi	a4,sp,44
   1070c:	04000893          	li	a7,64
   10710:	00100513          	li	a0,1
   10714:	00e005b3          	add	a1,zero,a4
   10718:	00078613          	mv	a2,a5
   1071c:	00000073          	ecall
    return 0;
   10720:	07c12083          	lw	ra,124(sp)
   10724:	07812403          	lw	s0,120(sp)
   10728:	07412483          	lw	s1,116(sp)
   1072c:	07012903          	lw	s2,112(sp)
   10730:	06c12983          	lw	s3,108(sp)
   10734:	06812a03          	lw	s4,104(sp)
   10738:	06412a83          	lw	s5,100(sp)
   1073c:	06012b03          	lw	s6,96(sp)
   10740:	05c12b83          	lw	s7,92(sp)
   10744:	05812c03          	lw	s8,88(sp)
   10748:	05412c83          	lw	s9,84(sp)
   1074c:	05012d03          	lw	s10,80(sp)
   10750:	04c12d83          	lw	s11,76(sp)
   10754:	00000513          	li	a0,0
   10758:	08010113          	addi	sp,sp,128
   1075c:	00008067          	ret
