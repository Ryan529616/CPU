module RegFile(
    input           clk,
    input           rst,
    input           RegWrite,
    input   [4:0]   Read_register_1,
    input   [4:0]   Read_register_2,
    input   [4:0]   Write_register,
    input   [31:0]  Write_data,
    output  [31:0]  Read_data_1,
    output  [31:0]  Read_data_2
);
    integer i;
    reg [31:0] Registers [0:31];

    always @(posedge clk or posedge rst) begin
        if (rst) for (i = 0; i < 32; i = i + 1) Registers[i] <= 32'b0;
        else if (RegWrite) begin
            Registers[Write_register] <= Write_data;
            Registers[0] <= 32'b0;
        end
    end

    genvar idx;
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : expose_registers
            wire [31:0] debug_register = Registers[idx];
        end
    endgenerate

    assign Read_data_1 = Registers[Read_register_1];
    assign Read_data_2 = Registers[Read_register_2];

endmodule

