module MEM (
    input clk,
    input MemRead,
    input [1:0] MemWrite,
    input [31:0] Read_data_2,
    input [31:0] rd_data,
    input  [4:0]  rd_in,
    output [4:0]  rd_out,
    output [31:0] Mem_out
);
    Data_Memory data_memory(
        .clk(clk), 
        .address(rd_data), 
        .write_data(Read_data_2), 
        .read_data(Mem_out),
        .MemREAD(MemRead), 
        .MemWrite(MemWrite)
    );
endmodule