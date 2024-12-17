.globl _start
_start:
    # 初始化測試數據
    li x1, 10         # 測試數據 10
    li x2, 5          # 測試數據 5

    # 算術指令測試
    add x3, x1, x2    # x3 = x1 + x2
    li x10, 0x100  # 直接加载 result_add 的地址
    sw x3, 0(x10)    # 存储 x3 到 0x10000

    sub x4, x1, x2    # x4 = x1 - x2
    la x10, 0x101
    sw x4, 0(x10)

    # 邏輯運算指令測試
    and x5, x1, x2    # x5 = x1 & x2
    la x10, 0x102
    sw x5, 0(x10)

    or x6, x1, x2     # x6 = x1 | x2
    la x10, 0x103
    sw x6, 0(x10)

    xor x7, x1, x2    # x7 = x1 ^ x2
    la x10, 0x104
    sw x7, 0(x10)

    # 移位指令測試
    sll x8, x1, x2    # x8 = x1 << (x2[4:0])
    la x10, 0x105
    sw x8, 0(x10)

    srl x9, x1, x2    # x9 = x1 >> (x2[4:0]) (logical)
    la x10, 0x106
    sw x9, 0(x10)

    sra x31, x1, x2   # x10 = x1 >> (x2[4:0]) (arithmetic)
    la x10, 0x107
    sw x31, 0(x10)

    # 比較指令測試
    slt x11, x1, x2   # x11 = (x1 < x2) ? 1 : 0
    la x10, 0x108
    sw x11, 0(x10)

    sltu x12, x1, x2  # x12 = (x1 < x2 unsigned) ? 1 : 0
    la x10, 0x109
    sw x12, 0(x10)

    # 分支指令測試
    li x13, 0
    li x14, 1

    beq x1, x2, branch_equal
    la x10, 0x10A
    sw x13, 0(x10)
    addi x15, x0, 1
    j branch_end
branch_equal:
    la x10, 0x10B
    sw x14, 0(x10)
branch_end:

    bne x1, x2, branch_not_equal
    la x10, 0x10C
    sw x13, 0(x10)
    j branch_ne_end
branch_not_equal:
    la x10, 0x10D
    sw x14, 0(x10)
    addi x16, x0, 1
branch_ne_end:

    blt x1, x2, branch_lt
    la x10, 0x10E
    sw x13, 0(x10)
    addi x17, x0, 1
    j branch_lt_end
branch_lt:
    la x10, 0x10F   
    sw x14, 0(x10)
branch_lt_end:

    bge x1, x2, branch_ge
    la x10, 0x110
    sw x13, 0(x10)
    j branch_ge_end
branch_ge:
    la x10, 0x111
    sw x14, 0(x10)
    addi x18, x0, 1
branch_ge_end:

    bltu x1, x2, branch_ltu
    la x10, 0x112
    sw x13, 0(x10)
    addi x19, x0, 1
    j branch_ltu_end
branch_ltu:
    la x10, 0x113
    sw x14, 0(x10)
branch_ltu_end:

    bgeu x1, x2, branch_geu
    la x10, 0x114
    sw x13, 0(x10)
    j branch_geu_end
branch_geu:
    la x10, 0x115
    sw x14, 0(x10)
    addi x20, x0, 1
branch_geu_end:

    # 跳躍指令測試
    jal x21, jump_label
    la x10, 0x116
    sw x14, 0(x10)
    addi x21, x0, 42
    j load

jump_label:
    addi x22, x0, 42   # 返回後 x15 = 42
    jalr x0, x21, 0
    la x10, 0x117
    sw x16, 0(x10)

load:
    # 記憶體指令測試
    li x23, 0x200     # 模擬的記憶體地址
    sw x1, 0(x23)      # 存儲 x1
    lw x23, 0(x23)     # 加載到 x18
    addi x10, x0, 256

