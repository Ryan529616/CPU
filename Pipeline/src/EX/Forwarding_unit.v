<<<<<<< HEAD
module Forwarding_unit(
    input        EX_MEM_RegWrite,
    input        MEM_WB_RegWrite,
    input  [4:0] rs1,
    input  [4:0] rs2,
    input  [4:0] EX_MEM_rd,
    input  [4:0] MEM_WB_rd,
    output [1:0] ForwardA,
    output [1:0] ForwardB
);

    always@*begin
        if(EX_MEM_RegWrite && (EX_MEM_rd != 5'b0) && (rs1 == EX_MEM_rd))ForwardA = 2'b10;
        else if(MEM_WB_RegWrite && (MEM_WB_rd != 5'b0) && !(EX_MEM_RegWrite &&(EX_MEM_rd != 5'b0) && (EX_MEM_rd == rs1)) && (rs1 == MEM_WB_rd))ForwardA = 2'b01;
        else ForwardA = 2'b00;

        if(EX_MEM_RegWrite && (EX_MEM_rd != 5'b0) && (rs2 == EX_MEM_rd))ForwardB = 2'b10;
        else if(MEM_WB_RegWrite && (MEM_WB_rd != 5'b0) && !(EX_MEM_RegWrite &&(EX_MEM_rd != 5'b0) && (EX_MEM_rd == rs2)) && (rs2 == MEM_WB_rd))ForwardB = 2'b01;
        else ForwardB = 2'b00;
    end

=======
module Forwarding_unit(
    input        EX_MEM_RegWrite,
    input        MEM_WB_RegWrite,
    input  [4:0] rs1,
    input  [4:0] rs2,
    input  [4:0] EX_MEM_rd,
    input  [4:0] MEM_WB_rd,
    output [1:0] ForwardA,
    output [1:0] ForwardB
);

    always@*begin
        if(EX_MEM_RegWrite && (EX_MEM_rd != 5'b0) && (rs1 == EX_MEM_rd))ForwardA = 2'b10;
        else if(MEM_WB_RegWrite && (MEM_WB_rd != 5'b0) && !(EX_MEM_RegWrite &&(EX_MEM_rd != 5'b0) && (EX_MEM_rd == rs1)) && (rs1 == MEM_WB_rd))ForwardA = 2'b01;
        else ForwardA = 2'b00;

        if(EX_MEM_RegWrite && (EX_MEM_rd != 5'b0) && (rs2 == EX_MEM_rd))ForwardB = 2'b10;
        else if(MEM_WB_RegWrite && (MEM_WB_rd != 5'b0) && !(EX_MEM_RegWrite &&(EX_MEM_rd != 5'b0) && (EX_MEM_rd == rs2)) && (rs2 == MEM_WB_rd))ForwardB = 2'b01;
        else ForwardB = 2'b00;
    end

>>>>>>> bdb7ead (2024/12/8)
endmodule