module EX_MEM (
    input         clk,
    input         flush,
    input         MemRead_in,
    input  [1:0]  MemWrite_in,
    input  [31:0] Read_data_2_in,
    input  [31:0] rd_data_in,

    output [31:0] MemRead_out,
    output [1:0]  MemWrite_out,
    output [31:0] Read_data_2_out,
    output [31:0] rd_data_out
);
    always@(posedge clk)begin
        if(flush) begin
            MemRead_out     <= 1'b0;
            MemWrite_out    <= 1'b0;
            Read_data_2_out <= 32'b0;
            rd_data_out     <= 32'b0;
        end
        else begin
            MemRead_out     <= MemRead_in;
            MemWrite_out    <= MemWrite_in;
            Read_data_2_out <= Read_data_2_in;
            rd_data_out     <= rd_data_in;
        end
    end
endmodule