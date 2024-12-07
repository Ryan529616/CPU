module IF_ID(
    input             clk,
    input      [31:0] pc,
    input      [31:0] instruction,
    output reg [31:0] pc_out,
    output reg [31:0] instruction_out
);
    always@(posedge clk)begin
        pc_out <= pc;
        instruction_out <= instruction;
    end

endmodule