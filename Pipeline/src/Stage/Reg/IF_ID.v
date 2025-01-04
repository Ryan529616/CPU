module IF_ID(
    input             clk,
    input             IF_ID_Write,
    input             stall,
    input             flush,
    input      [31:0] pc_in,
    input      [31:0] imm_in,
    input      [31:0] instruction_in,
    output reg [31:0] pc_out,
    output reg [31:0] imm_out,
    output reg [31:0] instruction_out
);
    always@(posedge clk)begin
        if(flush) begin
            pc_out <= 32'b0;
            imm_out <= 32'b0;
            instruction_out <= 32'b0;
        end
        else if(IF_ID_Write || ~stall) begin 
            pc_out <= pc_out;
            imm_out <= imm_out;
            instruction_out <= instruction_out;
        end
        else begin
            pc_out <= pc_out;
            imm_out <= imm_out;
            instruction_out <= instruction_out;
        end
    end

endmodule