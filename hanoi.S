    .equ STDOUT, 1
    .equ WRITE,  64
    .equ EXIT,   93

    .section .text
    .globl  hanoi_main

# ---------------- main (Gray code Hanoi, 3 disks, direct-ecall I/O) ----------------
hanoi_main:
    addi    sp, sp, -32
    sw      x8,  0(sp)
    sw      x9,  4(sp)
    sw      x18, 8(sp)
    sw      x19, 12(sp)
    sw      x20, 16(sp)

    # pos[0..2] at sp+20,24,28
    sw      x0, 20(sp)
    sw      x0, 24(sp)
    sw      x0, 28(sp)

    addi    x8, x0, 1          # n = 1..7 (2^3-1 moves)
game_loop:
    addi    x5, x0, 8          # 2^3 = 8
    bge     x8, x5, finish

    # gray(n) = n ^ (n>>1)
    srli    x5, x8, 1
    xor     x6, x8, x5         # g(n)

    addi    x7, x8, -1
    srli    x28, x7, 1
    xor     x7, x7, x28        # g(n-1)

    xor     x5, x6, x7

    addi    x9, x0, 0
    andi    x6, x5, 1
    bne     x6, x0, disk_found

    addi    x9, x0, 1
    andi    x6, x5, 2
    bne     x6, x0, disk_found

    addi    x9, x0, 2
disk_found:
    slli    x5, x9, 2
    addi    x5, x5, 20
    add     x5, sp, x5
    lw      x18, 0(x5)

    bne     x9, x0, handle_large

    addi    x19, x18, 2
    addi    x6,  x0, 3
    blt     x19, x6, display
    sub     x19, x19, x6
    j       display

handle_large:
    lw      x6, 20(sp)         # pos[0]
    addi    x19, x0, 3
    sub     x19, x19, x18
    sub     x19, x19, x6

display:
    # src/dst peg char = 'A' + index
    addi    t3, x18, 65        # 用 t3 保存 src  (不要用 x11=a1)
    addi    t4, x19, 65        # 用 t4 保存 dst  (不要用 x12=a2)

    # write("Move Disk ")
    li      a0, 1
    la      a1, str1
    li      a2, 10
    li      a7, 64
    ecall


    addi    t0, x9, 1
    addi    t0, t0, 48         # '0' + (disk+1)
    addi    sp, sp, -16
    sb      t0, 0(sp)
    li      a0, 1
    addi    a1, sp, 0
    li      a2, 1
    li      a7, 64
    ecall
    addi    sp, sp, 16

    # write(" from ")
    li      a0, 1
    la      a1, str2
    li      a2, 6
    li      a7, 64
    ecall

    addi    sp, sp, -16
    sb      t3, 0(sp)
    li      a0, 1
    addi    a1, sp, 0
    li      a2, 1
    li      a7, 64
    ecall
    addi    sp, sp, 16

    # write(" to ")
    li      a0, 1
    la      a1, str3
    li      a2, 4
    li      a7, 64
    ecall


    addi    sp, sp, -16
    sb      t4, 0(sp)
    li      a0, 1
    addi    a1, sp, 0
    li      a2, 1
    li      a7, 64
    ecall
    addi    sp, sp, 16

    # newline
    addi    sp, sp, -16
    li      t0, 10
    sb      t0, 0(sp)
    li      a0, 1
    addi    a1, sp, 0
    li      a2, 1
    li      a7, 64
    ecall
    addi    sp, sp, 16


store_and_next:
    # pos[d] = next
    slli    x5, x9, 2
    addi    x5, x5, 20
    add     x5, sp, x5
    sw      x19, 0(x5)

    addi    x8, x8, 1
    jal     x0, game_loop

finish:
    lw      x8,  0(sp)
    lw      x9,  4(sp)
    lw      x18, 8(sp)
    lw      x19, 12(sp)
    lw      x20, 16(sp)
    addi    sp,  sp, 32
    li      a0, 0
    ret

    .section .rodata
obdata:     .byte   0x3c, 0x3b, 0x3a
str1:       .asciz  "Move Disk "
str2:       .asciz  " from "
str3:       .asciz  " to "