`timescale 1ns/1ps
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

    
endmodule
