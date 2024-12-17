`timescale 1ns/1ps
`include "Top.v"
`include "Instruction_Memory.v"
`include "Data_Memory.v"
module CPU_Testbench;

    reg clk;
    reg rst;
    wire [31:0] rd_data;
    wire [31:0] pc;
    wire [31:0] instruction;
    wire [31:0] Mem_out;
    wire MemRead;
    wire [1:0] MemWrite;
    wire [31:0] Read_data_2;

    integer i;
    // Instantiate the DUT (Top Module)
    Top dut (
        .clk(clk),
        .rst(rst),
        .data(Mem_out),
        .rd_data(rd_data),
        .instruction(instruction), 
        .MemREAD(MemRead),
        .MemWrite(MemWrite),
        .Read_data_2(Read_data_2),
        .pc(pc)

    );

    Data_Memory data_memory(
        .clk(clk), 
        .address(rd_data), 
        .write_data(Read_data_2), 
        .read_data(Mem_out),
        .MemREAD(MemRead), 
        .MemWrite(MemWrite)
    );

    Instruction_Memory instruction_memory(
        .clk(clk), 
        .pc(pc), 
        .instruction(instruction)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Initialize memory and simulation
    initial begin
        rst = 1;
        #20 rst = 0;


        // Load instructions into instruction memory
        $readmemh("rv32i_test.hex", instruction_memory.sram.mem);

        // Load data into data memory
        $readmemh("rv32i_test.hex", data_memory.sram.mem);

        // Run for sufficient time
        repeat (100) @(posedge clk);

        // Verify the results
        check_registers();
        check_hand_calculated();
        $finish;
    end

    // Function to check final register values
    task check_registers;
        begin
            $display("Checking Register File...");
            check_value("x1", dut.regfile.Registers[1], 32'h0000000A);
            check_value("x2", dut.regfile.Registers[2], 32'h00000005);
            check_value("x3", dut.regfile.Registers[3], 32'h0000000F);
            check_value("x4", dut.regfile.Registers[4], 32'h00000005);
            check_value("x5", dut.regfile.Registers[5], 32'h00000000);
            check_value("x6", dut.regfile.Registers[6], 32'h0000000F);
            check_value("x7", dut.regfile.Registers[7], 32'h0000000F);
            check_value("x8", dut.regfile.Registers[8], 32'h00000140);
            check_value("x9", dut.regfile.Registers[9], 32'h00000000);
            check_value("x10", dut.regfile.Registers[10], 32'h00000100);
            check_value("x11", dut.regfile.Registers[11], 32'h00000000);
            check_value("x12", dut.regfile.Registers[12], 32'h00000000);
            check_value("x13", dut.regfile.Registers[13], 32'h00000000);
            check_value("x14", dut.regfile.Registers[14], 32'h00000001);
            check_value("x15", dut.regfile.Registers[15], 32'h00000001);
            check_value("x16", dut.regfile.Registers[16], 32'h00000001);
            check_value("x17", dut.regfile.Registers[17], 32'h00000001);
            check_value("x18", dut.regfile.Registers[18], 32'h00000001);
            check_value("x19", dut.regfile.Registers[19], 32'h00000001);
            check_value("x20", dut.regfile.Registers[20], 32'h00000001);
            check_value("x21", dut.regfile.Registers[21], 32'h0000002a);
            check_value("x22", dut.regfile.Registers[22], 32'h0000002a);
            check_value("x23", dut.regfile.Registers[23], 32'h0000000A);
            check_value("x24", dut.regfile.Registers[24], 32'h00000000);
            check_value("x25", dut.regfile.Registers[25], 32'h00000000);
            check_value("x26", dut.regfile.Registers[26], 32'h00000000);
            check_value("x27", dut.regfile.Registers[27], 32'h00000000);
            check_value("x28", dut.regfile.Registers[28], 32'h00000000);
            check_value("x29", dut.regfile.Registers[29], 32'h00000000);
            check_value("x30", dut.regfile.Registers[30], 32'h00000000);
            check_value("x31", dut.regfile.Registers[31], 32'h00000000);
        end
    endtask


    // Function to compare memory with hand-calculated expected values
    task check_hand_calculated;
        begin
            $display("Checking Hand Calculated Results...");
            check_value("result_add", data_memory.sram.mem['h100], 32'h0000000F);
            check_value("result_sub", data_memory.sram.mem['h101], 32'h00000005);
            check_value("result_and", data_memory.sram.mem['h102], 32'h00000000);
            check_value("result_or",  data_memory.sram.mem['h103], 32'h0000000F);
            check_value("result_xor", data_memory.sram.mem['h104], 32'h0000000F);
            check_value("result_sll", data_memory.sram.mem['h105], 32'h00000140);
            check_value("result_srl", data_memory.sram.mem['h106], 32'h00000000);
            check_value("result_sra", data_memory.sram.mem['h107], 0);
            check_value("result_slt", data_memory.sram.mem['h108], 0);
            check_value("result_sltu", data_memory.sram.mem['h109], 0);
            check_value("result_beq", data_memory.sram.mem['h110], 1);
            check_value("result_bne", data_memory.sram.mem['h111], 1);
            check_value("result_blt", data_memory.sram.mem['h112], 1);
            check_value("result_bge", data_memory.sram.mem['h113], 1);
            check_value("result_bltu", data_memory.sram.mem['h114], 1);
            check_value("result_bgeu", data_memory.sram.mem['h115], 1);
            check_value("result_jal", data_memory.sram.mem['h116], 42);
            check_value("result_jalr", data_memory.sram.mem['h117], 0);
            check_value("result_lw", data_memory.sram.mem['h118], 10);
        end
    endtask

    // Function to compare values and display results
    task check_value(input [90:0] name, input [31:0] value, input [31:0] expected);
        if (value !== expected) begin
            $display("ERROR: %s = 0x%h, expected 0x%h", name, value, expected);
        end else begin
            $display("PASS: %s = 0x%h", name, value);
        end
    endtask
    
endmodule
