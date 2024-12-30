module PC_Generator (
    input wire        clk,
    input wire        rst,
    input wire        stall,
    input wire        PC_Write,
    input wire        branch_taken,
    input wire        branch_prediction,
    input wire [31:0] imm,
    output reg [31:0] pc

);

    always @(posedge clk or posedge rst) begin
        if(rst) begin 
            pc <= 32'b0;
        end
        else if (PC_Write || ~stall) begin
            if (branch_taken) pc <= pc + imm;
            else if (branch_prediction) pc <= pc + imm;
            else pc <= pc + 4;
        end
        else pc <= pc; 
    end
endmodule