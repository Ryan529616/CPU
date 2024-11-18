`timescale 1ns/1ps

module ALU_Src1_MUX (
    input             ALU_Src,
    input       [1:0] FowardA,
    input      [31:0] Read_data_1,
    input      [31:0] rd_data,
    input      [31:0] Write_data,
    output reg [31:0] ALU_in1
);
    always@*begin
        case(ForwardA)
            2'b00: ALU_in1 = Read_data_1;
            2'b01: ALU_in1 = Write_data;
            2'b10: ALU_in1 = rd_data;
        endcase
    end
endmodule
