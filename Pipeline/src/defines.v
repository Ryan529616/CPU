<<<<<<< HEAD
// defines.v
`ifndef DEFINES_V
`define DEFINES_V

`define LUI     7'b0110111
`define AUIPC   7'b0010111
`define JAL     7'b1101111
`define JALR    7'b1100111
`define BRANCH  7'b1100011
`define LOAD    7'b0000011
`define STORE   7'b0100011 
`define OP_IMM  7'b0010011
`define OP      7'b0110011

`define IDLE    5'b00000
`define ADD     5'b00001
`define SUB     5'b00010
`define SLL     5'b00011
`define SLT     5'b00100
`define SLTU    5'b00101
`define XOR     5'b00110
`define SRL     5'b00111
`define SRA     5'b01000
`define OR      5'b01001
`define AND     5'b01010
`define BEQ     5'b01011
`define BNE     5'b01100
`define BLT     5'b01101
`define BGE     5'b01110
`define BLTU    5'b01111
`define BGEU    5'b10000
`define LUI_ALUOP 5'b10001

`define WRITE_IDLE  2'b00
`define WRITE_BYTE  2'b01
`define WRITE_HALF  2'b10
`define WRITE_WORD  2'b11

`define R_type  7'b0110011
`define I_type  7'b0010011
`define S_type  7'b0100011
`define B_type  7'b1100011
`define J_type  7'b1101111

`define LB 3'b000
`define LH 3'b001
`define LW 3'b010
`define LBU 3'b100
`define LHU 3'b101

`define SB 3'b000
`define SH 3'b001
`define SW 3'b010

`endif

=======
// defines.v
`ifndef DEFINES_V
`define DEFINES_V

`define LUI     7'b0110111
`define AUIPC   7'b0010111
`define JAL     7'b1101111
`define JALR    7'b1100111
`define BRANCH  7'b1100011
`define LOAD    7'b0000011
`define STORE   7'b0100011 
`define OP_IMM  7'b0010011
`define OP      7'b0110011

`define IDLE    5'b00000
`define ADD     5'b00001
`define SUB     5'b00010
`define SLL     5'b00011
`define SLT     5'b00100
`define SLTU    5'b00101
`define XOR     5'b00110
`define SRL     5'b00111
`define SRA     5'b01000
`define OR      5'b01001
`define AND     5'b01010
`define BEQ     5'b01011
`define BNE     5'b01100
`define BLT     5'b01101
`define BGE     5'b01110
`define BLTU    5'b01111
`define BGEU    5'b10000
`define LUI_ALUOP 5'b10001

`define WRITE_IDLE  2'b00
`define WRITE_BYTE  2'b01
`define WRITE_HALF  2'b10
`define WRITE_WORD  2'b11

`define R_type  7'b0110011
`define I_type  7'b0010011
`define S_type  7'b0100011
`define B_type  7'b1100011
`define J_type  7'b1101111

`define LB 3'b000
`define LH 3'b001
`define LW 3'b010
`define LBU 3'b100
`define LHU 3'b101

`define SB 3'b000
`define SH 3'b001
`define SW 3'b010

`endif

>>>>>>> bdb7ead (2024/12/8)
