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

    localparam ARRAY_OFFSET = 32'd4336;

    // Instantiate the DUT (Top Module)
    Top dut (
        .clk(clk),
        .rst(rst),
        .data(Mem_out),
        .rd_data(rd_data),
        .instruction(instruction), 
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Read_data_2(Read_data_2),
        .pc(pc)
    );

    Data_Memory data_memory(
        .clk(clk), 
        .address(rd_data), 
        .write_data(Read_data_2), 
        .read_data(Mem_out),
        .MemRead(MemRead), 
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

    function int get_memory(input int index);
        if (index < 0 || index > 65535) begin
            return -1; // 錯誤處理
        end
        return {data_memory.sram.mem[index + 3], data_memory.sram.mem[index + 2], 
                data_memory.sram.mem[index + 1], data_memory.sram.mem[index]};
    endfunction

    function void set_memory(input int index, input int value);
        if (index >= 0 && index <= 65535) begin
            data_memory.sram.mem[index] = value[7:0];
            data_memory.sram.mem[index + 1] = value[15:8];
            data_memory.sram.mem[index + 2] = value[23:16];
            data_memory.sram.mem[index + 3] = value[31:24];
        end
    endfunction


    initial begin
        $readmemh("quicksort.hex", instruction_memory.sram.mem);
        $readmemh("quicksort.hex", data_memory.sram.mem);

        // 顯示排序前的數據
        $display("Initial Array:");
        for (int i = 0; i < 10; i++) begin
            $display("Index %0d: %0d", i, get_memory(ARRAY_OFFSET + i * 4)); // 將位址按字節對齊
        end

        rst = 1;
        #20 rst = 0;

        // 等待排序完成
        repeat (100000) @(posedge clk);

        // 顯示排序後的數據
        $display("Sorted Array:");
        for (int i = 0; i < 10; i++) begin
            $display("Index %0d: %0d", i, get_memory(ARRAY_OFFSET + i * 4)); // 將位址按字節對齊
        end
        #50 $finish;
    end

        initial begin
            $fsdbDumpfile("CPU_Testbench.fsdb");
            $fsdbDumpvars(0, CPU_Testbench);
        end
endmodule
