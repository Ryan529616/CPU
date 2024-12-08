module IF_ID(
    input                     clk,
    input          [31:0] pc_in,
    input          [31:0] imm_in,
    input          [31:0] instruction_in,
    output reg [31:0] pc_out,
    output reg [31:0] imm_out,
    output reg [31:0] instruction_out
);
    always@(posedge clk)begin
        pc_out <= pc_in;
        imm_out <= imm_in;
        instruction_out <= instruction_in;
    end

endmodule