# Toolchain 前綴
RISCV_PREFIX = riscv64-unknown-elf-

# 編譯器和工具
CC = $(RISCV_PREFIX)gcc
OBJCOPY = $(RISCV_PREFIX)objcopy

# 源文件和目標文件
SRCS = rv32i_test.s
TARGET = rv32i_test
HEX = $(TARGET).hex
ELF = $(TARGET).elf
BIN = $(TARGET).bin

# 編譯目標 ISA 和 ABI
ISA = rv32i
ABI = ilp32

# 編譯選項
CFLAGS = -march=$(ISA) -mabi=$(ABI) -nostartfiles -Wl,--no-relax

# 規則
all: $(HEX)

$(ELF): $(SRCS)
	$(CC) $(CFLAGS) -o $@ $<

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

$(HEX): $(BIN)
	# 每行 1 byte，65536 行輸出
	xxd -p -c 1 $< | awk '{printf "%s\n", $$1}' > $@

clean:
	rm -f $(ELF) $(BIN) $(HEX)
