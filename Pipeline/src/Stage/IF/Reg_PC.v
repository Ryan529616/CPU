module Reg_PC (
    input               clk,
    input               rst,
    input           [31:0]  next_pc,
    output reg  [31:0]  pc
);
    reg init_done;
    always @(posedge clk or posedge rst) begin
        if(rst) begin 
            pc <= 32'b0;
            init_done <= 1'b0;
        end
        else if (!init_done) init_done <= 1'b1;
        else    pc <= next_pc;
    end

endmodule
