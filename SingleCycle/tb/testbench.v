`timescale 1ns/1ps
<<<<<<< HEAD
`include "../src/Top.v"
module CPU_Testbench;

    reg clk;
    reg rst;
    integer i; // Loop variable for memory check

    // Instantiate the DUT (Top Module)
    Top dut (
        .clk(clk),
        .rst(rst)
    );
    integer i,j;
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
        $readmemh("rv32i_test.hex", dut.instruction_memory.sram.mem);

        // Load data into data memory
        $readmemh("rv32i_test.hex", dut.data_memory.sram.mem);

        // Run for sufficient time
        repeat (10000) @(posedge clk);

        // Verify the results
        check_registers();
        check_memory();
        $finish;
    end

    // Function to check final register values
    task check_registers;
        begin
            $display("Checking Register File...");
            check_value("x1", dut.regfile.Registers[1], 32'h0000000A);
            check_value("x2", dut.regfile.Registers[2], 32'h00000014);
            check_value("x3", dut.regfile.Registers[3], 32'h0000001E);
            check_value("x4", dut.regfile.Registers[4], 32'h0000000A);
            check_value("x5", dut.regfile.Registers[5], 32'h12345000);
            check_value("x6", dut.regfile.Registers[6], 32'h00000000);
            check_value("x7", dut.regfile.Registers[7], 32'h0000001E);
            check_value("x8", dut.regfile.Registers[8], 32'h0000001E);
            check_value("x9", dut.regfile.Registers[9], 32'h0000000A);
            check_value("x10", dut.regfile.Registers[10], 32'h0000000F);
            check_value("x11", dut.regfile.Registers[11], 32'h00000005);
            check_value("x12", dut.regfile.Registers[12], 32'h00000028);
            check_value("x13", dut.regfile.Registers[13], 32'h00000005);
            check_value("x14", dut.regfile.Registers[14], 32'h00000005);
            check_value("x15", dut.regfile.Registers[15], 32'h00000001);
            check_value("x16", dut.regfile.Registers[16], 32'h00000000);
            check_value("x17", dut.regfile.Registers[17], 32'h00000001);
            check_value("x18", dut.regfile.Registers[18], 32'h00000000);
            check_value("x19", dut.regfile.Registers[19], 32'h00000001);
            check_value("x20", dut.regfile.Registers[20], 32'h00001000);
            check_value("x21", dut.regfile.Registers[21], 32'h0000000A);
            check_value("x22", dut.regfile.Registers[22], 32'h00000014);
            check_value("x23", dut.regfile.Registers[23], 32'h00001004);
            check_value("x31", dut.regfile.Registers[31], 32'h00000000);
        end
    endtask

    // Function to check memory values

    task check_memory;
        begin
            $display("Checking Data Memory...");
            // Memory indexed directly with address offset
            check_value("Memory[0x00001000]", dut.data_memory.sram.mem[32'h00001000], 8'h0A);
            check_value("Memory[0x00001004]", dut.data_memory.sram.mem[32'h00001004], 8'h14);
        end
    endtask



    // Function to compare values and display results
    task check_value(input [31:0] name, input [31:0] value, input [31:0] expected);
        if (value !== expected) begin
            $display("ERROR: %s = 0x%h, expected 0x%h", name, value, expected);
        end else begin
            $display("PASS: %s = 0x%h", name, value);
        end
    endtask

    // Waveform generation
    initial begin
        $fsdbDumpfile("cpu_tb.fsdb");
        $fsdbDumpvars(0, CPU_Testbench);
    end

    
=======
`include "Imme_Ext.v"
`include "defines.v"

module Imme_Ext_Testbench;

    reg [31:0] instruction;
    wire [31:0] imm;

    Imme_Ext uut (
        .instruction(instruction),
        .imm(imm)
    );

    initial begin
        $display("Testing Immediate Extension...");

        // 測試 LUI 指令
        instruction = {20'h12345, 5'b0, 7'b0110111}; // rd = 0
        #10;
        if (imm !== 32'h12345000)
            $display("ERROR: LUI failed! Got: %h, Expected: 12345000", imm);
        else
            $display("PASS: LUI");

        // 測試 AUIPC 指令
        instruction = {20'h12345, 5'b0, 7'b0010111}; // AUIPC 指令格式
        #10;
        if (imm !== 32'h12345000)
            $display("ERROR: AUIPC failed! Got: %h, Expected: 12345000", imm);
        else
            $display("PASS: AUIPC");

        // 測試 JAL 指令
        instruction = {1'b1, 10'b1111111110, 1'b1, 8'hFF, 5'b0, 7'b1101111}; // rd = 0
        #10;
        if (imm !== 32'hFFFFFFFC)
            $display("ERROR: JAL failed! Got: %h, Expected: FFFFFFFC", imm);
        else
            $display("PASS: JAL");

        // 測試 JALR 指令
        instruction = {12'hFFF, 5'b0, 3'b0, 5'b0, 7'b1100111}; // rs1 = 0, rd = 0
        #10;
        if (imm !== 32'hFFFFFFFE)
            $display("ERROR: JALR failed! Got: %h, Expected: FFFFFFFE", imm);
        else
            $display("PASS: JALR");

        // 測試 Branch 指令 (BEQ, offset = -8)
        instruction = {1'b1, 6'b111111, 5'b0, 5'b0, 3'b0, 4'b1111, 1'b1, 7'b1100011}; // BEQ
        #10;
        if (imm !== 32'hFFFFFFFE)
            $display("ERROR: Branch failed! Got: %h, Expected: FFFFFFFE", imm);
        else
            $display("PASS: Branch");

        // 測試 Load 指令 (LB, offset = 0x7F)
        instruction = {12'h07F, 5'b0, 3'b0, 5'b0, 7'b0000011}; // rs1 = 0, rd = 0

        #10;
        if (imm !== 32'h0000007F)
            $display("ERROR: Load failed! Got: %h, Expected: 0000007F", imm);
        else
            $display("PASS: Load");

        // 測試 Store 指令 (SB, offset = -128)
        instruction = {7'b1111111, 10'b0, 3'b000, 5'b0, 7'b0100011}; // Store 指令格式
        #10;
        if (imm !== 32'hFFFFFFE0)
            $display("ERROR: Store failed! Got: %h, Expected: FFFFFFE0", imm);
        else
            $display("PASS: Store");

        // 測試 I-type 指令 (ADDI, imm = 0x123)
        instruction = {12'h123, 5'b0, 3'b000, 5'b0, 7'b0010011}; // ADDI 指令格式
        #10;
        if (imm !== 32'h00000123)
            $display("ERROR: I-type failed! Got: %h, Expected: 00000123", imm);
        else
            $display("PASS: I-type");

        // 測試負數立即數擴展 (I-type, imm = -1)
        instruction = {12'hFFF, 5'b0, 3'b000, 5'b0, 7'b0010011}; // ADDI x, x, -1
        #10;
        if (imm !== 32'hFFFFFFFF)
            $display("ERROR: I-type negative failed! Got: %h, Expected: FFFFFFFF", imm);
        else
            $display("PASS: I-type negative");

        $display("Testing Complete.");
        $finish;
    end

>>>>>>> bdb7ead (2024/12/8)
endmodule
