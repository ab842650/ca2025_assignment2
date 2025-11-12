
test.elf:     file format elf32-littleriscv


Disassembly of section .text:

00010000 <_start>:
.globl _start
.type _start, @function

_start:
    # Set up stack pointer
    la sp, __stack_top
   10000:	00001117          	auipc	sp,0x1
   10004:	74010113          	addi	sp,sp,1856 # 11740 <__stack_top>

    # Clear BSS
    la t0, __bss_start
   10008:	00000297          	auipc	t0,0x0
   1000c:	73828293          	addi	t0,t0,1848 # 10740 <__bss_end>
    la t1, __bss_end
   10010:	00000317          	auipc	t1,0x0
   10014:	73030313          	addi	t1,t1,1840 # 10740 <__bss_end>
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
   10028:	2b0000ef          	jal	102d8 <main>

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

0001003c <mul32x32>:
   1003c:	fe010113          	addi	sp,sp,-32
    32,    23,    16,    11,    8,     6,     4,    3,    2,    1};



static inline void mul32x32(uint32_t a, uint32_t b, uint32_t *hi, uint32_t *lo)
{
   10040:	00812c23          	sw	s0,24(sp)
   10044:	01212823          	sw	s2,16(sp)
    uint32_t a_lo = a & 0xFFFFu, a_hi = a >> 16;
   10048:	01051413          	slli	s0,a0,0x10
    uint32_t b_lo = b & 0xFFFFu, b_hi = b >> 16;
   1004c:	01059913          	slli	s2,a1,0x10
    uint32_t a_lo = a & 0xFFFFu, a_hi = a >> 16;
   10050:	01045413          	srli	s0,s0,0x10
    uint32_t b_lo = b & 0xFFFFu, b_hi = b >> 16;
   10054:	01095913          	srli	s2,s2,0x10
{
   10058:	01312623          	sw	s3,12(sp)
   1005c:	01412423          	sw	s4,8(sp)
    uint32_t a_lo = a & 0xFFFFu, a_hi = a >> 16;
   10060:	01055993          	srli	s3,a0,0x10
    uint32_t b_lo = b & 0xFFFFu, b_hi = b >> 16;
   10064:	0105da13          	srli	s4,a1,0x10

    uint32_t p0 = a_lo * b_lo;
   10068:	00040513          	mv	a0,s0
   1006c:	00090593          	mv	a1,s2
{
   10070:	00112e23          	sw	ra,28(sp)
   10074:	00912a23          	sw	s1,20(sp)
   10078:	01512223          	sw	s5,4(sp)
   1007c:	01612023          	sw	s6,0(sp)
   10080:	00068a93          	mv	s5,a3
   10084:	00060b13          	mv	s6,a2
    uint32_t p0 = a_lo * b_lo;
   10088:	1fc000ef          	jal	10284 <__mulsi3>
   1008c:	00050493          	mv	s1,a0
    uint32_t p1 = a_lo * b_hi;
   10090:	000a0593          	mv	a1,s4
   10094:	00040513          	mv	a0,s0
   10098:	1ec000ef          	jal	10284 <__mulsi3>
   1009c:	00050413          	mv	s0,a0
    uint32_t p2 = a_hi * b_lo;
   100a0:	00090593          	mv	a1,s2
   100a4:	00098513          	mv	a0,s3
   100a8:	1dc000ef          	jal	10284 <__mulsi3>
   
    uint32_t p3 = a_hi * b_hi;


    uint32_t mid = (p0 >> 16) + (p1 & 0xFFFFu) + (p2 & 0xFFFFu);
   100ac:	01041793          	slli	a5,s0,0x10
   100b0:	0104d913          	srli	s2,s1,0x10
   100b4:	0107d793          	srli	a5,a5,0x10
   100b8:	00f90933          	add	s2,s2,a5

    uint32_t lo_res = (p0 & 0xFFFFu) | (mid << 16);
    uint32_t hi_res = p3 + (p1 >> 16) + (p2 >> 16) + (mid >> 16);
   100bc:	01045413          	srli	s0,s0,0x10
    uint32_t mid = (p0 >> 16) + (p1 & 0xFFFFu) + (p2 & 0xFFFFu);
   100c0:	01051793          	slli	a5,a0,0x10
    uint32_t hi_res = p3 + (p1 >> 16) + (p2 >> 16) + (mid >> 16);
   100c4:	01055513          	srli	a0,a0,0x10
    uint32_t mid = (p0 >> 16) + (p1 & 0xFFFFu) + (p2 & 0xFFFFu);
   100c8:	0107d793          	srli	a5,a5,0x10
    uint32_t hi_res = p3 + (p1 >> 16) + (p2 >> 16) + (mid >> 16);
   100cc:	00a40433          	add	s0,s0,a0
    uint32_t p3 = a_hi * b_hi;
   100d0:	000a0593          	mv	a1,s4
   100d4:	00098513          	mv	a0,s3
    uint32_t mid = (p0 >> 16) + (p1 & 0xFFFFu) + (p2 & 0xFFFFu);
   100d8:	00f90933          	add	s2,s2,a5
    uint32_t p3 = a_hi * b_hi;
   100dc:	1a8000ef          	jal	10284 <__mulsi3>
    uint32_t hi_res = p3 + (p1 >> 16) + (p2 >> 16) + (mid >> 16);
   100e0:	01095793          	srli	a5,s2,0x10
   100e4:	00a40433          	add	s0,s0,a0
   100e8:	00f40433          	add	s0,s0,a5
    uint32_t lo_res = (p0 & 0xFFFFu) | (mid << 16);
   100ec:	01049493          	slli	s1,s1,0x10

    *hi = hi_res;
   100f0:	008b2023          	sw	s0,0(s6)
    *lo = lo_res;
}
   100f4:	01c12083          	lw	ra,28(sp)
   100f8:	01812403          	lw	s0,24(sp)
    uint32_t lo_res = (p0 & 0xFFFFu) | (mid << 16);
   100fc:	01091913          	slli	s2,s2,0x10
   10100:	0104d493          	srli	s1,s1,0x10
   10104:	0124e4b3          	or	s1,s1,s2
    *lo = lo_res;
   10108:	009aa023          	sw	s1,0(s5)
}
   1010c:	01012903          	lw	s2,16(sp)
   10110:	01412483          	lw	s1,20(sp)
   10114:	00c12983          	lw	s3,12(sp)
   10118:	00812a03          	lw	s4,8(sp)
   1011c:	00412a83          	lw	s5,4(sp)
   10120:	00012b03          	lw	s6,0(sp)
   10124:	02010113          	addi	sp,sp,32
   10128:	00008067          	ret

0001012c <print_dec>:
{
   1012c:	fe010113          	addi	sp,sp,-32
    *p = '\n';
   10130:	00a00793          	li	a5,10
   10134:	00f10fa3          	sb	a5,31(sp)
    if (val == 0) {
   10138:	0a051663          	bnez	a0,101e4 <print_dec+0xb8>
        *p = '0';
   1013c:	03000793          	li	a5,48
   10140:	00f10f23          	sb	a5,30(sp)
        p--;
   10144:	01d10713          	addi	a4,sp,29
    p++;
   10148:	00170713          	addi	a4,a4,1
    printstr(p, (buf + sizeof(buf) - p));
   1014c:	02010793          	addi	a5,sp,32
   10150:	40e787b3          	sub	a5,a5,a4
   10154:	04000893          	li	a7,64
   10158:	00100513          	li	a0,1
   1015c:	00e005b3          	add	a1,zero,a4
   10160:	00078613          	mv	a2,a5
   10164:	00000073          	ecall
}
   10168:	02010113          	addi	sp,sp,32
   1016c:	00008067          	ret
        remainder |= (dividend >> i) & 1;
   10170:	00d55633          	srl	a2,a0,a3
        remainder <<= 1;
   10174:	00179793          	slli	a5,a5,0x1
        remainder |= (dividend >> i) & 1;
   10178:	00167613          	andi	a2,a2,1
   1017c:	00f667b3          	or	a5,a2,a5
        if (remainder >= divisor) {
   10180:	00f87463          	bgeu	a6,a5,10188 <print_dec+0x5c>
            remainder -= divisor;
   10184:	ff678793          	addi	a5,a5,-10
    for (int i = 31; i >= 0; i--) {
   10188:	fff68693          	addi	a3,a3,-1
   1018c:	ff1692e3          	bne	a3,a7,10170 <print_dec+0x44>
            *p = '0' + umod(val, 10);
   10190:	03078793          	addi	a5,a5,48
   10194:	00f70023          	sb	a5,0(a4)
    unsigned long quotient = 0;
   10198:	00000613          	li	a2,0
            p--;
   1019c:	fff70713          	addi	a4,a4,-1
    for (int i = 31; i >= 0; i--) {
   101a0:	01f00693          	li	a3,31
    unsigned long remainder = 0;
   101a4:	00000793          	li	a5,0
        remainder |= (dividend >> i) & 1;
   101a8:	00d555b3          	srl	a1,a0,a3
        remainder <<= 1;
   101ac:	00179793          	slli	a5,a5,0x1
        remainder |= (dividend >> i) & 1;
   101b0:	0015f593          	andi	a1,a1,1
   101b4:	00f5e7b3          	or	a5,a1,a5
        if (remainder >= divisor) {
   101b8:	00f87863          	bgeu	a6,a5,101c8 <print_dec+0x9c>
            quotient |= (1UL << i);
   101bc:	00d315b3          	sll	a1,t1,a3
            remainder -= divisor;
   101c0:	ff678793          	addi	a5,a5,-10
            quotient |= (1UL << i);
   101c4:	00b66633          	or	a2,a2,a1
    for (int i = 31; i >= 0; i--) {
   101c8:	fff68693          	addi	a3,a3,-1
   101cc:	fd169ee3          	bne	a3,a7,101a8 <print_dec+0x7c>
        while (val > 0) {
   101d0:	f6060ce3          	beqz	a2,10148 <print_dec+0x1c>
   101d4:	00060513          	mv	a0,a2
    for (int i = 31; i >= 0; i--) {
   101d8:	01f00693          	li	a3,31
    unsigned long remainder = 0;
   101dc:	00000793          	li	a5,0
   101e0:	f91ff06f          	j	10170 <print_dec+0x44>
    p--;
   101e4:	01e10713          	addi	a4,sp,30
        if (remainder >= divisor) {
   101e8:	00900813          	li	a6,9
    for (int i = 31; i >= 0; i--) {
   101ec:	fff00893          	li	a7,-1
            quotient |= (1UL << i);
   101f0:	00100313          	li	t1,1
   101f4:	fe5ff06f          	j	101d8 <print_dec+0xac>

000101f8 <memcpy>:
    while (n--)
   101f8:	00000793          	li	a5,0
   101fc:	00f61463          	bne	a2,a5,10204 <memcpy+0xc>
}
   10200:	00008067          	ret
        *d++ = *s++;
   10204:	00f58733          	add	a4,a1,a5
   10208:	00074683          	lbu	a3,0(a4)
   1020c:	00f50733          	add	a4,a0,a5
   10210:	00178793          	addi	a5,a5,1
   10214:	00d70023          	sb	a3,0(a4)
   10218:	fe5ff06f          	j	101fc <memcpy+0x4>

0001021c <clz>:
    c = (x < 0x00010000) << 4;
   1021c:	00010737          	lui	a4,0x10
   10220:	00e53733          	sltu	a4,a0,a4
   10224:	00471713          	slli	a4,a4,0x4
    x <<= c;  // off 16
   10228:	00e517b3          	sll	a5,a0,a4
    c = (x < 0x01000000) << 3;
   1022c:	010006b7          	lui	a3,0x1000
   10230:	00d7b6b3          	sltu	a3,a5,a3
   10234:	00369693          	slli	a3,a3,0x3
    r += c;
   10238:	00e68533          	add	a0,a3,a4
    x <<= c;  // off 8
   1023c:	00d797b3          	sll	a5,a5,a3
    c = (x < 0x10000000) << 2;
   10240:	10000737          	lui	a4,0x10000
   10244:	00e7b733          	sltu	a4,a5,a4
   10248:	00271713          	slli	a4,a4,0x2
    x <<= c;  // off 4
   1024c:	00e797b3          	sll	a5,a5,a4
    r += c;
   10250:	00e50533          	add	a0,a0,a4
    c = (x < 0x40000000) << 1;
   10254:	40000737          	lui	a4,0x40000
   10258:	00e7b733          	sltu	a4,a5,a4
   1025c:	00171713          	slli	a4,a4,0x1
    x <<= c;  // off 2
   10260:	00e797b3          	sll	a5,a5,a4
    r += c;
   10264:	00e50533          	add	a0,a0,a4
    c = x < 0x80000000;
   10268:	fff7c713          	not	a4,a5
   1026c:	01f75713          	srli	a4,a4,0x1f
    x <<= c;  // off 1
   10270:	00e797b3          	sll	a5,a5,a4
    r += c;
   10274:	00e50533          	add	a0,a0,a4
    r += x == 0;
   10278:	0017b793          	seqz	a5,a5
}
   1027c:	00a78533          	add	a0,a5,a0
   10280:	00008067          	ret

00010284 <__mulsi3>:
{
   10284:	00050793          	mv	a5,a0
    uint32_t result = 0;
   10288:	00000513          	li	a0,0
    while (b) {
   1028c:	00059463          	bnez	a1,10294 <__mulsi3+0x10>
}
   10290:	00008067          	ret
        if (b & 1)
   10294:	0015f713          	andi	a4,a1,1
   10298:	40e00733          	neg	a4,a4
   1029c:	00f77733          	and	a4,a4,a5
   102a0:	00e50533          	add	a0,a0,a4
        a <<= 1;
   102a4:	00179793          	slli	a5,a5,0x1
        b >>= 1;
   102a8:	0015d593          	srli	a1,a1,0x1
   102ac:	fe1ff06f          	j	1028c <__mulsi3+0x8>

000102b0 <get_cycles>:
.text

.globl get_cycles
.align 2
get_cycles:
    csrr a1, cycleh
   102b0:	c80025f3          	rdcycleh	a1
    csrr a0, cycle
   102b4:	c0002573          	rdcycle	a0
    csrr a2, cycleh
   102b8:	c8002673          	rdcycleh	a2
    bne a1, a2, get_cycles
   102bc:	fec59ae3          	bne	a1,a2,102b0 <get_cycles>
    ret
   102c0:	00008067          	ret

000102c4 <get_instret>:

# Read 64-bit instruction retired counter
.globl get_instret
.align 2
get_instret:
    csrr a1, instreth
   102c4:	c82025f3          	rdinstreth	a1
    csrr a0, instret
   102c8:	c0202573          	rdinstret	a0
    csrr a2, instreth
   102cc:	c8202673          	rdinstreth	a2
    bne a1, a2, get_instret
   102d0:	fec59ae3          	bne	a1,a2,102c4 <get_instret>
    ret
   102d4:	00008067          	ret

Disassembly of section .text.startup:

000102d8 <main>:

    return y;
}

int main(void)
{
   102d8:	f8010113          	addi	sp,sp,-128
   102dc:	06112e23          	sw	ra,124(sp)
   102e0:	06812c23          	sw	s0,120(sp)
   102e4:	06912a23          	sw	s1,116(sp)
   102e8:	07212823          	sw	s2,112(sp)
   102ec:	07312623          	sw	s3,108(sp)
   102f0:	07412423          	sw	s4,104(sp)
   102f4:	07512223          	sw	s5,100(sp)
   102f8:	07612023          	sw	s6,96(sp)
   102fc:	05712e23          	sw	s7,92(sp)
   10300:	05812c23          	sw	s8,88(sp)
   10304:	05912a23          	sw	s9,84(sp)
   10308:	000104b7          	lui	s1,0x10
   1030c:	05a12823          	sw	s10,80(sp)
   10310:	05b12623          	sw	s11,76(sp)
    uint64_t start_cycles = get_cycles();
   10314:	f9dff0ef          	jal	102b0 <get_cycles>
   10318:	5f848913          	addi	s2,s1,1528 # 105f8 <RSQRT_INPUTS>
   1031c:	00a12623          	sw	a0,12(sp)
    uint64_t start_instret = get_instret();
   10320:	fa5ff0ef          	jal	102c4 <get_instret>
   10324:	00050993          	mv	s3,a0
    for (int i = 0; i < 50; i++) {
   10328:	0c890a13          	addi	s4,s2,200
   1032c:	5f848493          	addi	s1,s1,1528
   10330:	fff00a93          	li	s5,-1
            *p = (digit < 10) ? ('0' + digit) : ('a' + digit - 10);
   10334:	00900b13          	li	s6,9
    uint32_t exp = 31u - clz(x);
   10338:	01f00b93          	li	s7,31
                                    : (x - (1u << exp)) << (16 - exp);
   1033c:	00100c13          	li	s8,1
    uint32_t y_next = (exp < 31u) ? rsqrt_table[exp + 1u] : 1u;
   10340:	01e00c93          	li	s9,30
    mul32x32(y, term, &hi, &lo);
   10344:	02c10413          	addi	s0,sp,44
        uint32_t y = rsqrt(RSQRT_INPUTS[i]);
   10348:	00092d03          	lw	s10,0(s2)
    if (x == 0)
   1034c:	020d1c63          	bnez	s10,10384 <main+0xac>
    *p = '\n';
   10350:	00a00793          	li	a5,10
   10354:	02f10fa3          	sb	a5,63(sp)
        return 0xFFFFFFFF;
   10358:	fff00793          	li	a5,-1
    uint32_t result = 0;
   1035c:	03e10713          	addi	a4,sp,62
            int digit = val & 0xf;
   10360:	00f7f693          	andi	a3,a5,15
            *p = (digit < 10) ? ('0' + digit) : ('a' + digit - 10);
   10364:	05768613          	addi	a2,a3,87 # 1000057 <__stack_top+0xfee917>
   10368:	00db6463          	bltu	s6,a3,10370 <main+0x98>
   1036c:	03068613          	addi	a2,a3,48
   10370:	00c70023          	sb	a2,0(a4) # 40000000 <__stack_top+0x3ffee8c0>
            val >>= 4;
   10374:	0047d793          	srli	a5,a5,0x4
            p--;
   10378:	fff70713          	addi	a4,a4,-1
        while (val > 0) {
   1037c:	fe0792e3          	bnez	a5,10360 <main+0x88>
   10380:	1280006f          	j	104a8 <main+0x1d0>
    if (x == UINT32_MAX)
   10384:	015d1a63          	bne	s10,s5,10398 <main+0xc0>
    *p = '\n';
   10388:	00a00793          	li	a5,10
   1038c:	02f10fa3          	sb	a5,63(sp)
        return 1;
   10390:	00100793          	li	a5,1
   10394:	fc9ff06f          	j	1035c <main+0x84>
    uint32_t exp = 31u - clz(x);
   10398:	000d0513          	mv	a0,s10
   1039c:	e81ff0ef          	jal	1021c <clz>
   103a0:	40ab86b3          	sub	a3,s7,a0
    uint32_t y_base = rsqrt_table[exp]; /* Value at 2^exp */
   103a4:	00269793          	slli	a5,a3,0x2
   103a8:	00f487b3          	add	a5,s1,a5
   103ac:	0c87ad83          	lw	s11,200(a5)
                                    : (x - (1u << exp)) << (16 - exp);
   103b0:	00dc17b3          	sll	a5,s8,a3
   103b4:	40fd07b3          	sub	a5,s10,a5
    uint32_t y_next = (exp < 31u) ? rsqrt_table[exp + 1u] : 1u;
   103b8:	1edce863          	bltu	s9,a3,105a8 <main+0x2d0>
   103bc:	02000713          	li	a4,32
   103c0:	40a70733          	sub	a4,a4,a0
   103c4:	00271713          	slli	a4,a4,0x2
   103c8:	00e48733          	add	a4,s1,a4
                                    : (x - (1u << exp)) << (16 - exp);
   103cc:	00f00613          	li	a2,15
    uint32_t y_next = (exp < 31u) ? rsqrt_table[exp + 1u] : 1u;
   103d0:	0c872703          	lw	a4,200(a4)
                                    : (x - (1u << exp)) << (16 - exp);
   103d4:	1cd67e63          	bgeu	a2,a3,105b0 <main+0x2d8>
    uint32_t fraction = (exp >= 16) ? (x - (1u << exp)) >> (exp - 16)
   103d8:	00f00693          	li	a3,15
   103dc:	40a686b3          	sub	a3,a3,a0
                                    : (x - (1u << exp)) << (16 - exp);
   103e0:	00d7d7b3          	srl	a5,a5,a3
    uint32_t y = y_base - (umul((y_base - y_next), fraction) >> 16);
   103e4:	40ed8733          	sub	a4,s11,a4
    uint32_t result = 0;
   103e8:	00000693          	li	a3,0
    while (b) {
   103ec:	1c079863          	bnez	a5,105bc <main+0x2e4>
    uint32_t y = y_base - (umul((y_base - y_next), fraction) >> 16);
   103f0:	0106d693          	srli	a3,a3,0x10
   103f4:	40dd87b3          	sub	a5,s11,a3
    mul32x32(y, y, &y2_hi, &y2_lo);
   103f8:	00078593          	mv	a1,a5
   103fc:	00078513          	mv	a0,a5
   10400:	01410693          	addi	a3,sp,20
   10404:	01010613          	addi	a2,sp,16
    uint32_t y = y_base - (umul((y_base - y_next), fraction) >> 16);
   10408:	00f12423          	sw	a5,8(sp)
    mul32x32(y, y, &y2_hi, &y2_lo);
   1040c:	c31ff0ef          	jal	1003c <mul32x32>
    mul32x32(x, y2_hi, &hi1, &lo1);
   10410:	01012583          	lw	a1,16(sp)
   10414:	01c10693          	addi	a3,sp,28
   10418:	01810613          	addi	a2,sp,24
   1041c:	000d0513          	mv	a0,s10
   10420:	c1dff0ef          	jal	1003c <mul32x32>
    uint32_t termA = (lo1 << 16);
   10424:	01c12783          	lw	a5,28(sp)
    mul32x32(x, y2_lo, &hi2, &lo2);
   10428:	01412583          	lw	a1,20(sp)
   1042c:	02410693          	addi	a3,sp,36
   10430:	02010613          	addi	a2,sp,32
   10434:	000d0513          	mv	a0,s10
    uint32_t termA = (lo1 << 16);
   10438:	01079d93          	slli	s11,a5,0x10
    mul32x32(x, y2_lo, &hi2, &lo2);
   1043c:	c01ff0ef          	jal	1003c <mul32x32>
    uint32_t termB = (hi2 << 16) | (lo2 >> 16);
   10440:	02012783          	lw	a5,32(sp)
   10444:	02615703          	lhu	a4,38(sp)
    mul32x32(y, term, &hi, &lo);
   10448:	00812503          	lw	a0,8(sp)
    uint32_t term = (3u << 16) - xy2;
   1044c:	000305b7          	lui	a1,0x30
    uint32_t termB = (hi2 << 16) | (lo2 >> 16);
   10450:	01079793          	slli	a5,a5,0x10
   10454:	00e7e7b3          	or	a5,a5,a4
    uint32_t term = (3u << 16) - xy2;
   10458:	41b585b3          	sub	a1,a1,s11
    mul32x32(y, term, &hi, &lo);
   1045c:	00040693          	mv	a3,s0
   10460:	40f585b3          	sub	a1,a1,a5
   10464:	02810613          	addi	a2,sp,40
   10468:	bd5ff0ef          	jal	1003c <mul32x32>
    uint32_t lo_plus = lo + (1u << 16);
   1046c:	02c12783          	lw	a5,44(sp)
    uint32_t hi_plus = hi + (lo_plus < lo);
   10470:	02812683          	lw	a3,40(sp)
   10474:	00010737          	lui	a4,0x10
   10478:	00e78733          	add	a4,a5,a4
   1047c:	00f737b3          	sltu	a5,a4,a5
   10480:	00d787b3          	add	a5,a5,a3
    return (hi_plus << 15) | (lo_plus >> 17);
   10484:	01175713          	srli	a4,a4,0x11
   10488:	00f79793          	slli	a5,a5,0xf
   1048c:	00e7e7b3          	or	a5,a5,a4
    *p = '\n';
   10490:	00a00713          	li	a4,10
   10494:	02e10fa3          	sb	a4,63(sp)
    if (val == 0) {
   10498:	ec0792e3          	bnez	a5,1035c <main+0x84>
        *p = '0';
   1049c:	03000793          	li	a5,48
   104a0:	02f10f23          	sb	a5,62(sp)
        p--;
   104a4:	03d10713          	addi	a4,sp,61
    p++;
   104a8:	00170713          	addi	a4,a4,1 # 10001 <_start+0x1>
    printstr(p, (buf + sizeof(buf) - p));
   104ac:	04010793          	addi	a5,sp,64
   104b0:	40e787b3          	sub	a5,a5,a4
   104b4:	04000893          	li	a7,64
   104b8:	00100513          	li	a0,1
   104bc:	00e005b3          	add	a1,zero,a4
   104c0:	00078613          	mv	a2,a5
   104c4:	00000073          	ecall
    for (int i = 0; i < 50; i++) {
   104c8:	00490913          	addi	s2,s2,4
   104cc:	e7491ee3          	bne	s2,s4,10348 <main+0x70>
        print_hex(y);
    }
    uint64_t end_cycles = get_cycles();
   104d0:	de1ff0ef          	jal	102b0 <get_cycles>
   104d4:	00050a13          	mv	s4,a0
    uint64_t end_instret = get_instret();
   104d8:	dedff0ef          	jal	102c4 <get_instret>

    uint64_t cycles_elapsed = end_cycles - start_cycles;
    uint64_t instret_elapsed = end_instret - start_instret;
    TEST_LOGGER("  Cycles: ");
   104dc:	000105b7          	lui	a1,0x10
    uint64_t instret_elapsed = end_instret - start_instret;
   104e0:	413504b3          	sub	s1,a0,s3
    TEST_LOGGER("  Cycles: ");
   104e4:	00b00613          	li	a2,11
   104e8:	5d858593          	addi	a1,a1,1496 # 105d8 <main+0x300>
   104ec:	00040513          	mv	a0,s0
   104f0:	d09ff0ef          	jal	101f8 <memcpy>
   104f4:	00a00993          	li	s3,10
   104f8:	04000893          	li	a7,64
   104fc:	00100513          	li	a0,1
   10500:	008005b3          	add	a1,zero,s0
   10504:	00098613          	mv	a2,s3
   10508:	00000073          	ecall
    print_dec((unsigned long) cycles_elapsed);
   1050c:	00c12783          	lw	a5,12(sp)
   10510:	40fa0533          	sub	a0,s4,a5
   10514:	c19ff0ef          	jal	1012c <print_dec>
    TEST_LOGGER("  Instructions: ");
   10518:	000105b7          	lui	a1,0x10
   1051c:	01100613          	li	a2,17
   10520:	5e458593          	addi	a1,a1,1508 # 105e4 <main+0x30c>
   10524:	00040513          	mv	a0,s0
   10528:	cd1ff0ef          	jal	101f8 <memcpy>
   1052c:	01000793          	li	a5,16
   10530:	04000893          	li	a7,64
   10534:	00100513          	li	a0,1
   10538:	008005b3          	add	a1,zero,s0
   1053c:	00078613          	mv	a2,a5
   10540:	00000073          	ecall
    print_dec((unsigned long) instret_elapsed);
   10544:	00048513          	mv	a0,s1
   10548:	be5ff0ef          	jal	1012c <print_dec>
    TEST_LOGGER("\n");
   1054c:	00100793          	li	a5,1
   10550:	03311623          	sh	s3,44(sp)
   10554:	04000893          	li	a7,64
   10558:	00100513          	li	a0,1
   1055c:	008005b3          	add	a1,zero,s0
   10560:	00078613          	mv	a2,a5
   10564:	00000073          	ecall
    return 0;
   10568:	07c12083          	lw	ra,124(sp)
   1056c:	07812403          	lw	s0,120(sp)
   10570:	07412483          	lw	s1,116(sp)
   10574:	07012903          	lw	s2,112(sp)
   10578:	06c12983          	lw	s3,108(sp)
   1057c:	06812a03          	lw	s4,104(sp)
   10580:	06412a83          	lw	s5,100(sp)
   10584:	06012b03          	lw	s6,96(sp)
   10588:	05c12b83          	lw	s7,92(sp)
   1058c:	05812c03          	lw	s8,88(sp)
   10590:	05412c83          	lw	s9,84(sp)
   10594:	05012d03          	lw	s10,80(sp)
   10598:	04c12d83          	lw	s11,76(sp)
   1059c:	00000513          	li	a0,0
   105a0:	08010113          	addi	sp,sp,128
   105a4:	00008067          	ret
    uint32_t y_next = (exp < 31u) ? rsqrt_table[exp + 1u] : 1u;
   105a8:	00100713          	li	a4,1
   105ac:	e2dff06f          	j	103d8 <main+0x100>
                                    : (x - (1u << exp)) << (16 - exp);
   105b0:	ff150513          	addi	a0,a0,-15
   105b4:	00a797b3          	sll	a5,a5,a0
   105b8:	e2dff06f          	j	103e4 <main+0x10c>
        if (b & 1)
   105bc:	0017f613          	andi	a2,a5,1
   105c0:	40c00633          	neg	a2,a2
   105c4:	00e67633          	and	a2,a2,a4
   105c8:	00c686b3          	add	a3,a3,a2
        a <<= 1;
   105cc:	00171713          	slli	a4,a4,0x1
        b >>= 1;
   105d0:	0017d793          	srli	a5,a5,0x1
   105d4:	e19ff06f          	j	103ec <main+0x114>
