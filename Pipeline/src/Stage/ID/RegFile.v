module RegFile(
    input           clk,
    input           RegWrite,
    input   [4:0]   Read_register_1,
    input   [4:0]   Read_register_2,
    input   [4:0]   Write_register,
    input   [31:0]  Write_data,
    output  [31:0]  Read_data_1,
    output  [31:0]  Read_data_2
);
    reg [31:0] Registers [0:31];

    always @(posedge clk) begin
        if (RegWrite) Registers[Write_register] <= Write_data;
    end

    assign Read_data_1 = Registers[Read_register_1];
    assign Read_data_2 = Registers[Read_register_2];

endmodule

