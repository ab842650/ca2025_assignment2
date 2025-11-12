    .section .bss
    .align 2
FAIL_REC_BUF:
    .space 256             

    .section .text
    .globl problemB_main


problemB_main:
    addi sp, sp, -16
    sw   ra, 12(sp)         
    sw   s0,  8(sp)          
    sw   s1,  4(sp)
    sw   s2,  0(sp)

    jal  ra, test            # a0 = pass(1)/fail(0)


    lw   ra, 12(sp)
    lw   s0,  8(sp)
    lw   s1,  4(sp)
    lw   s2,  0(sp)
    addi sp, sp, 16
    ret

# -----------------------
# clz(a0=x) -> a0 = clz(x)
# -----------------------
clz:
    li t0,32
    # --- k = 8 ---
    srli  t1, a0, 8
    sltu  t2, x0, t1
    sub   t3, x0, t2
    slli  t4, t2, 3
    sub   t0, t0, t4
    xori  t5, t3, -1
    and   a0, a0, t5
    and   t1, t1, t3
    or    a0, a0, t1
    # --- k = 4 ---
    srli  t1, a0, 4
    sltu  t2, x0, t1
    sub   t3, x0, t2
    slli  t4, t2, 2
    sub   t0, t0, t4
    xori  t5, t3, -1
    and   a0, a0, t5
    and   t1, t1, t3
    or    a0, a0, t1
    # --- k = 2 ---
    srli  t1, a0, 2
    sltu  t2, x0, t1
    sub   t3, x0, t2
    slli  t4, t2, 1
    sub   t0, t0, t4
    xori  t5, t3, -1
    and   a0, a0, t5
    and   t1, t1, t3
    or    a0, a0, t1
    # --- k = 1 ---
    srli  t1, a0, 1
    sltu  t2, x0, t1
    sub   t3, x0, t2
    sub   t0, t0, t2
    xori  t5, t3, -1
    and   a0, a0, t5
    and   t1, t1, t3
    or    a0, a0, t1

    sub   a0, t0, a0
    ret

uf8_decode:
    andi t1,a0,0x0f
    srli t2,a0,4
    li   t3,15
    sub  t0,t3,t2
    li   t3,0x7fff
    srl  t3,t3,t0
    slli t0,t3,4
    sll  t1,t1,t2
    add  a0,t1,t0
    ret

uf8_encode:
    addi sp, sp, -24
    sw   s2, 0(sp)
    sw   s3, 4(sp)
    sw   s4, 8(sp)
    sw   s5, 12(sp)
    sw   s6, 16(sp)
    sw   s7, 20(sp)
    
    mv   s2,a0
    addi t0,s2,-16
    sltz t0,t0
    bnez t0,restore_regs     

    # e = floor(log2(v/16)) + 1
    srli t2,s2,4
    addi t2,t2,1
    mv   a0,t2
    addi sp,sp,-4
    sw   ra,0(sp)
    jal  ra,clz
    lw   ra,0(sp)
    addi sp,sp,4

    mv   s3,a0
    li   t0,31
    sub  s3,t0,s3            # s3 = e = 31 - clz
    addi t0,s3,-15
    sgtz t0,t0
    beqz t0,compute_offset
    li   s3,15

compute_offset:
    li   t0,1
    sll  t0,t0,s3
    addi t0,t0,-1
    slli s4,t0,4             # offset

    sub  t0,s2,s4
    srl  s5,t0,s3            # mantissa

    slli t0,s3,4
    andi t1,s5,0x0f
    or   a0,t0,t1

restore_regs:
    lw   s2,  0(sp)
    lw   s3,  4(sp)
    lw   s4,  8(sp)
    lw   s5, 12(sp)
    lw   s6, 16(sp)
    lw   s7, 20(sp)
    addi sp, sp, 24
    ret

test:
    addi sp, sp, -32
    sw   s2, 0(sp)
    sw   s3, 4(sp)
    sw   s4, 8(sp)
    sw   s5, 12(sp)
    sw   s6, 16(sp)
    sw   s7, 20(sp)
    sw   s0, 24(sp)
    sw   ra, 28(sp)

    li   s2, 0               # i
    li   s3, -1              # previous_value
    li   s4, 1               # passed = 1
    la   s7, FAIL_REC_BUF

test_loop:
    li   t0, 256
    beq  s2, t0, test_done

    mv   a0, s2
    jal  ra, uf8_decode
    mv   s5, a0

    mv   a0, s5
    jal  ra, uf8_encode
    mv   s6, a0

    bne  s2, s6, record_fail

    # RV32I 沒 blez：用 (s5 < s3) 或 (s5 == s3)
    blt  s5, s3, record_fail
    beq  s5, s3, record_fail

    mv   s3, s5
    addi s2, s2, 1
    j    test_loop

record_fail:
    sw   s2, 0(s7)
    sw   s5, 4(s7)
    sw   s6, 8(s7)
    li   s4, 0
    addi s7, s7, 12
    addi s2, s2, 1
    j    test_loop

test_done:
    mv   a0, s4              

    lw   s2, 0(sp)
    lw   s3, 4(sp)
    lw   s4, 8(sp)
    lw   s5, 12(sp)
    lw   s6, 16(sp)
    lw   s7, 20(sp)
    lw   s0, 24(sp)
    lw   ra, 28(sp)
    addi sp, sp, 32
    ret