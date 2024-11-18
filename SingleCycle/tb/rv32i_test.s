.section .text
.global _start

_start:
    # 基本加法和立即數操作
    addi x1, x0, 10         # x1 = 10
    addi x2, x0, 20         # x2 = 20
    add x3, x1, x2          # x3 = 30
    sub x4, x2, x1          # x4 = 10
    lui x5, 0x12345         # x5 = 0x12345000

    # 邏輯操作
    and x6, x1, x2          # x6 = x1 & x2 = 0
    or x7, x1, x2           # x7 = x1 | x2 = 30
    xor x8, x1, x2          # x8 = x1 ^ x2 = 30
    andi x9, x1, 0xF        # x9 = x1 & 0xF = 10
    ori x10, x1, 0xF        # x10 = x1 | 0xF = 15
    xori x11, x1, 0xF       # x11 = x1 ^ 0xF = 5

    # 移位操作
    slli x12, x1, 2         # x12 = x1 << 2 = 40
    srli x13, x1, 1         # x13 = x1 >> 1 = 5
    srai x14, x1, 1         # x14 = x1 >> 1 (signed) = 5

    # 比較操作
    slt x15, x1, x2         # x15 = x1 < x2 = 1
    sltu x16, x2, x1        # x16 = x2 < x1 = 0
    slti x17, x1, 20        # x17 = x1 < 20 = 1
    sltiu x18, x2, 10       # x18 = x2 < 10 = 0

    # 分支測試
    beq x1, x1, branch_eq   # 跳轉
    addi x19, x0, 1         # 不執行
branch_eq:
    bne x1, x0, branch_ne   # 跳轉
    addi x19, x0, 1         # 不執行
branch_ne:
    blt x1, x2, branch_lt   # 跳轉
    addi x19, x0, 1         # 不執行
branch_lt:
    bge x1, x2, branch_ge   # 不跳轉
    addi x19, x0, 1         # 執行
branch_ge:
    bltu x1, x2, branch_ltu # 跳轉
    addi x19, x0, 1         # 不執行
branch_ltu:
    bgeu x1, x2, branch_geu # 不跳轉
    addi x19, x0, 1         # 執行
branch_geu:

    # 記憶體操作
    lui x20, 0x00001        # x20 = 0x00001000
    sw x1, 0(x20)           # [0x00001000] = x1
    lw x21, 0(x20)          # x21 = [0x00001000] = x1
    addi x23, x20, 4        # x23 = x20 + 4
    sb x2, 0(x23)           # [0x00001004] = x2 (byte)
    lb x22, 0(x23)          # x22 = [0x00001004] = 20 (sign extend)

    # 結束模擬
    addi x31, x0, 0         # x31 = 0 作為指示標誌
