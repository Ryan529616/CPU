module MEM_WB (
    input         clk,
    input         flush,
    input         stall,

    input         PC2Reg_in,
    input         MemtoReg_in,
    input         RegWrite_in,
    input   [2:0] funct3_in,
    input   [4:0] rd_in,

    input  [31:0] rd_data_in,

    input  [31:0] Mem_out_in,

    output        PC2Reg_out,
    output        MemtoReg_out,
    output        RegWrite_out,
    output  [2:0] funct3_out,
    output  [4:0] rd_out,

    output [31:0] rd_data_out,

    output [31:0] Mem_out_out

);

    always@(posedge clk)begin
        if(flush) begin
            funct3_out     <= 3'b0;
            PC2Reg_out     <= 1'b0;
            MemtoReg_out   <= 1'b0;
            RegWrite_out   <= 1'b0;
            rd_out         <= 5'b0;
            Mem_out_out    <= 32'b0;
            rd_data_out    <= 32'b0;
        end
        else if(stall) begin
            funct3_out     <= funct3_out;
            PC2Reg_out     <= PC2Reg_out;
            MemtoReg_out   <= MemtoReg_out;
            RegWrite_out   <= RegWrite_out;
            rd_out         <= rd_out;
            Mem_out_out    <= Mem_out_out;
            rd_data_out    <= rd_data_out;
        end
        else begin
            funct3_out     <= funct3_in;
            PC2Reg_out     <= PC2Reg_in;
            MemtoReg_out   <= MemtoReg_in;
            RegWrite_out   <= RegWrite_in;
            rd_out         <= rd_in;
            Mem_out_out    <= Mem_out_in;
            rd_data_out    <= rd_data_in;
        end
    end

endmodule

