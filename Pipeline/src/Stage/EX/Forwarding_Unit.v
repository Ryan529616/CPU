module Forwarding_Unit(
    input  wire       EX_MEM_RegWrite,
    input  wire       MEM_WB_RegWrite,
    input  wire [4:0] rs1,
    input  wire [4:0] rs2,
    input  wire [4:0] EX_MEM_rd,
    input  wire [4:0] MEM_WB_rd,
    output wire [1:0] ForwardA,
    output wire [1:0] ForwardB
);

    always@*begin
        if(EX_MEM_RegWrite && (EX_MEM_rd != 5'b0) && (rs1 == EX_MEM_rd)) ForwardA = 2'b10;
        else if(MEM_WB_RegWrite && (MEM_WB_rd != 5'b0) && !(EX_MEM_RegWrite &&(EX_MEM_rd != 5'b0) && (EX_MEM_rd == rs1)) && (rs1 == MEM_WB_rd)) ForwardA = 2'b01;
        else ForwardA = 2'b00;

        if(EX_MEM_RegWrite && (EX_MEM_rd != 5'b0) && (rs2 == EX_MEM_rd)) ForwardB = 2'b10;
        else if(MEM_WB_RegWrite && (MEM_WB_rd != 5'b0) && !(EX_MEM_RegWrite && (EX_MEM_rd != 5'b0) && (EX_MEM_rd == rs2)) && (rs2 == MEM_WB_rd)) ForwardB = 2'b01;
        else ForwardB = 2'b00;
    end

endmodule