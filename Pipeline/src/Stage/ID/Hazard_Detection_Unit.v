module Hazard_Detection_Unit (
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd_ex,
    input wire MemRead_ex,
    input wire branch_taken,
    input wire branch_prediction,
    output reg nop,
    output reg flush,
    output reg IF_ID_Write,
    output reg PC_Write
);

    always @(*) begin
        nop = 1'b0;
        flush = 1'b0;
        IF_ID_Write = 1'b1;
        PC_Write = 1'b1;

        if (branch_prediction != branch_taken) begin
            flush = 1'b1;
            IF_ID_Write = 1'b0;
        end
        else if (MemRead_ex && ((rd_ex == rs1) || (rd_ex == rs2))) begin
            nop = 1'b1;
            IF_ID_Write = 1'b0;
            PC_Write = 1'b0;
        end
    end
endmodule
