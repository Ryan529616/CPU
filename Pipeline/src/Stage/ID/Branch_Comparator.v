module Branch_Comparator (
    input [2:0]   funct3,
    input [6:0]   opcode,
    input [31:0] Read_data_1,
    input [31:0] Read_data_2,
    output reg   branch_taken  
);
    always @(*) begin
        if( opcode == `BRANCH) begin
            case(funct3)
                3'b000:  branch_taken = (Read_data_1 == Read_data_2);
                3'b001:  branch_taken = (Read_data_1 != Read_data_2);
                3'b100:  branch_taken = ($signed(Read_data_1) < $signed(Read_data_2));
                3'b101:  branch_taken = ($signed(Read_data_1) >= $signed(Read_data_2));
                3'b110:  branch_taken = (Read_data_1 < Read_data_2);
                3'b111:  branch_taken = (Read_data_1 >= Read_data_2);
                default: branch_taken = 1'b0;
            endcase
        end
        else branch_taken = 1'b0;
    end
endmodule