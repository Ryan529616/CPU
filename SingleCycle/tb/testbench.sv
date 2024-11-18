`timescale 1ns / 10ps

`define CYCLE 10
`define MAX_CLOCK_CYCLE 1000000
`define REG_FILE dut.regfile.Registers
`define IM dut.instruction_memory.sram.mem
`define DM dut.data_memory.sram.mem

`define SO_FILE_NAME "libemu.so"
`define PROG_PATH "quicksort.hex"

/* SV-DPI function declaration */
import "DPI-C" function void difftest_init(input string so_file_name);
import "DPI-C" function void difftest_memcpy_from_dut(input logic [7:0] MEM[65536]);
import "DPI-C" function void difftest_get_regs(input logic [31:0] regFile[32]);
import "DPI-C" function void difftest_set_regs();
// TODO: memory checker for store instrutions
// import "DPI-C" function void difftest_check_mem_word(
// input logic [ 3:0] wb_en,
// input logic [15:0] write_addr,
// input logic [31:0] write_data,
// inout bit          flag
// );
import "DPI-C" function void difftest_step(inout bit success_flag);
import "DPI-C" function void difftest_end();

module testbench;
    logic clock, reset;
    bit difftest_success_flag;
    integer i;

    /* instantiate top module */
    Top dut (
        .clk (clock),
        .rst (reset)
    );

    /* clock generating */ always #(`CYCLE / 2) clock = ~clock;
    
    initial begin
        // checking the path for test program
        if (!`PROG_PATH) begin
            $error("Please specify the path of your test program!\nAbort!");
            $finish;
        end

        /* initialize variables */
        clock                 = 0;
        reset                 = 1;
        difftest_success_flag = 1'b1;

        /* initialize memory contect of dut */

        for (i = 0; i < 65536; i++) begin
            `IM[i] = 32'h0;
            `DM[i] = 32'h0;
        end
        $readmemh(`PROG_PATH, `IM);
        $readmemh(`PROG_PATH, `DM);

        /* start simulaation, pull down reest signal */
        #(6) reset = 1;  // set low for half cycle
        #(`CYCLE - 6) reset = 0;  // set high an keep until end of simulation

        /* initialize difftest framework */
        difftest_init(`SO_FILE_NAME);
        difftest_get_regs(`REG_FILE);
        difftest_set_regs();
        difftest_memcpy_from_dut(`IM);

        /* difftest main loop */
        do begin
            /* step one cycle in dut */
            #(`CYCLE / 2) clock = 1;
            #(`CYCLE / 2) clock = 0;
            /* get registers of dut */
            difftest_get_regs(`REG_FILE);
            /* call difftest_step() */
            difftest_step(difftest_success_flag);
        end while (difftest_success_flag == 1'b1);
    end

    /* conditions which will terminate the simulation */
    initial begin
        #(`MAX_CLOCK_CYCLE);
        if (difftest_success_flag == 1'b1) begin
            print_success();
        end else begin
            print_fail();
        end
        difftest_end();
        $finish;
    end

    /* generate waveform file */
    initial begin
        $fsdbDumpfile("top.fsdb");
        $fsdbDumpvars(0, testbench);
    end

    /* utils */
    function automatic void print_success();
        $display(
            "                                        ⠰⣣⣿⣣⢟⡴⣿⢏⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⡜⣿⣿⣿⣿⣿⣧       ");
        $display(
            "                                       ⣴⣿⣿⠃⠞⣼⣿⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢹⣿⣿⣿⣿⠋⠠       ");
        $display(
            "                                     ⢀⡜⣯⣶⢇⣘⢰⣿⡏⣿⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⡇⣿⡟⡟⡇⢀⡆⠀⠀⠀⠀⠀⠀ ");
        $display(
            "                                     ⣼⢧⣿⡿⣼⡟⢸⣿⢡⠁⣿⣿⣿⣿⣿⡇⣿⣿⣿⣿⢿⣿⢝⠟⣿⠀⠈⡅       ");
        $display(
            "                                    ⣦⣿⢸⣿⢧⡟⡠⠗⠋⠟⠞⢻⣿⣿⠙⣿⡇⢹⣿⡇⡎⣋⣿⢀⣠⢻⢾⠀⠣       ");
        $display(
            "                                   ⣼⢽⣿⢸⣿⢈⡞⢠⢾⠍⠑⡐⣌⢿⣿⡷⡽⣇⡷⠻⣆⡡⢿⣿⢸⣿⣿⣿⡆⠀⠀⢀     ");
        $display(
            "                                  ⣰⣿⡾⣿⢸⡿⣟⢠⡏⠨⡄⠀⣇⣿⣮⡻⢇⢿⢖⣴⡒⠢⡀⠘⣿⢸⣿⣿⡿⣼⡷⡄⣼⡄    ");
        $display(
            "                                 ⢰⣿⣿⡇⣿⡸⡇⣗⢸⣇⠔⢀⣸⣿⣿⣿⣿⣿⣿⡎⢛⡅⠀⣷⡀⡹⣼⣿⣟⣼⡿⣱⡇⣿⡇    ");
        $display(
            "    **************************** ⣼⣿⣿⣿⡼⣇⠇⣟⠳⠟⠿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠉⣉⢠⣿⡇⣃⡿⢫⣾⢟⣵⣿⡇⣿⡇    ");
        $display(
            "    **                        ** ⢿⣿⣿⣿⣷⡹⡜⢿⣳⢰⣜⣽⣿⡿⠷⢿⣿⣿⣟⢿⣶⣶⣿⡟⡐⢜⣵⡿⣫⣾⣿⣿⣧⣿⢧⢰⡀  ");
        $display(
            "    **  Waku Waku !!          **⠆⢸⣿⣿⣿⣿⣷⡱⡘⢿⣿⣿⣿⡿⣼⣿⣿⢸⣿⡿⣦⡌⠛⣳⡞⣠⡾⣫⣾⣿⣿⣿⣿⢸⡿⡐⣾⣇  ");
        $display(
            "    **                        ** ⠘⣿⣿⣿⣿⣿⣿⡄⠀⠙⠿⣿⡇⣿⣿⣿⢸⣿⣿⣾⣽⣷⢟⢜⣫⣾⣿⣿⣿⣿⣿⡟⢼⢣⢳⣸⣿  ");
        $display(
            "    **  Simulation PASS !!    **   ⠹⣿⣿⣿⣿⣿⣿⠀⠀⡿⢺⣽⠒⠾⢭⣼⣿⣿⣿⠿⠫⣱⣿⣿⣿⣿⣿⣿⣿⣿⢇⢏⠏⠈⢹⡿ ");
        $display(
            "    **                        **     ⠹⣿⣿⣿⣿⡿⣠⠶⣿⣷⡜⡏⣿⣶⠶⣶⢾⢿⢇⣼⣿⣿⣿⣿⣿⣿⣿⣿⠏⠊⠀⠀⠀⣾⠇");
        $display(
            "    ****************************      ⠈⠻⣿⡿⣼⡿⣿⣶⣯⠃⡎⠩⠰⣛⠿⣷⡍⣼⣿⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⢀⠋ ");
        $display(
            "                                      ⠈⠃⠿⠿⠾⠝⠿⠰⠑⠀⠿⠿⠿⠶⠿⠼⠿⠿⠿⠿⠿⠟⠉⠀⠀⠀        ");
    endfunction

    function automatic void print_fail();
        $display(
            "    ****************************");
        $display(
            "    **                        **");
        $display(
            "    **         OOPS !!        **");
        $display(
            "    **                        **");
        $display(
            "    **  Simulation Failed !!  **");
        $display(
            "    **                        **");
        $display(
            "    ****************************");
    
        $display("\n");
    endfunction

    function automatic void print_exceed_sim_time();
        $display(
            "                                     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⠶⠟⠛⠉⠁⠉⠛⠃⠀⠈⣿⠻⠷⠶⣦⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡄⠀⠀⠀⠀⠀⠈⠙⢿⣦⣄⣀⣤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠾⠋⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣇⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⡉⢹⣿⣿⣿⣷⣶⣶⣤⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⠋⠀⣼⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡄⠀⠀⠀⠀⠀⠀⠀⠘⣿⣧⠀⢩⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠀⠀⠀⠀⠀⠀⠀⣴⠏⠀⠀⢸⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣧⠀⠀⠀⠀⠀⠀⢀⠀⠘⣿⣷⡀⢉⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠀⠀⠀⠀⠀⣠⣾⠃⠀⠀⠀⣿⠃⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⣿⠀⠀⠀⢹⣇⠀⠀⠀⠀⠀⠘⣇⠀⠘⢿⣷⡉⠉⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠀⣀⣠⣴⣾⡿⠁⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⢰⡇⠀⠀⠸⣇⠀⠀⠀⢻⡄⠀⠀⠀⠀⠀⢻⡀⠀⠈⠻⣿⣮⡉⢹⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⢰⣿⣿⣿⣿⣿⠁⠀⢀⠀⠁⠀⢻⡆⠀⠀⠀⠀⠀⠀⢸⣧⠀⠀⠀⢻⡄⠀⠀⠀⢿⡀⠀⠀⠀⠀⠸⡇⠀⠀⠀⠘⡿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠘⣿⣿⣿⣿⠇⠀⠀⣾⠀⠀⠀⢸⣧⠀⠀⠀⠀⠀⠀⠈⣿⣦⠀⠀⠈⢿⣄⠀⠀⠈⢷⡀⠀⠀⠀⠀⣷⠀⠀⠀⠀⢷⡀⠙⢿⣷⡀⠀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⢻⣿⣿⡏⠀⢠⡀⢻⠀⠀⠀⢸⣿⣦⡀⠀⠀⠀⠀⠀⢿⡉⢷⡄⠀⠘⢿⣦⡀⠀⠈⢷⡀⠀⠀⠀⢻⠀⠀⠀⠀⠈⣧⠀⠈⢻⣷⡀⠀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠘⣿⡿⠀⠀⣸⠀⣸⡇⠀⠀⢸⡇⠈⢷⣄⡀⠀⠀⠀⢺⣇⠀⠙⢦⣄⠈⢷⡹⢦⡀⠈⣷⠀⠀⠀⢸⡇⠀⠀⠀⠀⠸⣇⠀⠀⠹⣷⡀⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⠀⣸⡇⠀⠀⡯⢠⣿⢿⡄⠀⢸⡇⠀⠀⠈⠛⠶⣦⣄⣀⣹⣿⡓⠳⠎⠛⠲⠿⢦⣽⣶⣼⣇⠀⠀⢸⡇⠀⠀⠀⠀⠀⢻⡄⠀⠀⢻⣧⠀⠀⠀⠀⠀");
        $display(
            "                                     ⠀⢠⣿⠀⠀⠀⡇⣼⠏⠀⠻⣆⢘⣧⣴⠖⠋⠀⠀⠀⠀⠉⠁⠉⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡁⠀⢸⡇⠀⠀⠀⠀⠀⠘⣷⠀⠀⠈⣿⣇⠀⠀⠀⠀");
        $display(
            "                                     ⠀⣼⡟⠀⠀⠀⣿⡟⠀⠀⠀⠙⠳⠥⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣤⣼⡇⠀⢸⡇⠀⠀⠀⠀⠀⠀⢹⡇⠀⠀⡟⢿⣆⠀⠀⠀");
        $display(
            "                                     ⢀⣿⡇⠀⠀⠀⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⡤⢶⣾⣿⣿⣏⡹⠿⣇⠀⢸⡇⠀⠀⠀⠀⠀⠀⠘⣧⠀⠀⣧⠸⣿⡀⠀⠀");
        $display(
            "                                     ⢸⣿⢣⠀⠀⠀⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⣯⠵⠶⠛⠉⠁⠀⠀⠀⠀⢿⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⢻⠀⠀⣿⠀⣿⣧⠀⠀");
        $display(
            "                                     ⣸⡏⢹⠀⠀⠀⢿⡇⠀⠀⠀⣠⣤⣶⣾⣿⣻⣿⡿⠖⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⢀⠀⣀⠀⢸⡀⢸⠀⠀⠀⠀⠀⠀⠀⠀⢸⡆⠀⡿⢰⡏⣿⡀⠀");
        $display(
            "                                     ⣿⡇⢸⡄⠀⠀⢸⣿⢀⣴⣟⣡⡽⠟⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡆⠸⣗⠻⠗⠻⠇⢸⡇⣸⠁⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⡇⢸⠇⢸⣧⠀");
        $display(
            "                                     ⣿⡅⠘⣇⠀⠀⠀⣿⡘⠛⠉⠁⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀⠀⢈⡇⣿⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⢠⣃⡿⠀⠀⣿⠀");
        $display(
            "    ****************************     ⣿⢷⡀⢹⡄⠀⠀⢹⡇⠀⠀⣸⡆⠶⠄⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⡶⠃⠀⠀⠀⠀⠀⢸⣧⡇⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠘⣼⠃⠀⠀⢻⡄");
        $display(
            "    **                        **     ⣿⠈⣧⠈⢷⠀⠀⠈⣿⠀⠀⠈⠀⠀⠀⠀⢀⠀⠀⢀⣀⣤⠴⠖⢚⣩⠽⠋⠀⠀⠀⠀⠀⠀⠀⠀⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⣸⠀⣰⠏⠀⠀⠀⢼⡇");
        $display(
            "    **  Time Out !!           **     ⣿⠀⠘⣇⠘⣧⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠉⠛⠛⠷⠖⠒⠒⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⢁⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⡿⢰⠟⠀⠀⠀⠀⣿⡄");
        $display(
            "    **                        **     ⣿⡄⠀⠘⣦⠘⣇⠀⠈⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⠾⠋⢀⣽⡇⠀⠀⠀⠀⠀⠀⠀⠀⢨⡷⠋⠀⠀⠀⠀⠀⣿⠀");
        $display(
            "    **  Simulation Failed !!  **     ⢸⣧⠀⠀⠘⢧⡘⢧⡀⠘⠻⠶⢤⣤⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⣀⣀⣠⣴⣾⠟⠋⢀⣠⠶⢻⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠃⠀⠀⠀⠀⠀⣰⡏⠀");
        $display(
            "    **                        **      ⢿⡆⠀⠀⡈⢳⣄⠱⣄⠀⠀⠀⠀⠀⣽⠉⠉⢉⣉⠙⢿⣉⠉⠻⣿⡿⠋⢀⣠⠖⠋⠁⠀⣾⠁⠀⠀⠀⠀⠀⠀⠀⠀⢰⡟⠀⠀⠀⠀⠀⣠⡟⠀⠀");
        $display(
            "    ****************************      ⠈⢿⡄⠐⣧⠀⠙⢦⡈⠀⠀⠀⠀⠀⢻⣆⠀⠀⠙⢦⣀⠉⠳⢤⣘⣧⠶⠋⠁⠀⠀⠀⣰⡿⠀⠀⠀⠀⠀⠀⠀⢀⣠⠿⠃⠀⠀⠀⢀⣴⠟⠁⠀⠀");
        $display(
            "                                       ⠈⢿⣄⢿⣧⡀⠀⠛⢦⣄⠀⠀⠀⢸⣿⣷⣄⡀⠀⠉⠳⠶⣶⠞⠁⠀⠀⠀⢀⣠⣾⣿⠀⠀⠀⠀⠀⠀⣠⣴⡏⠁⠀⠀⢀⣠⡴⠟⠁⠀⠀⠀⠀");
        $display(
            "                                         ⠻⣾⣿⣛⣦⣄⠀⠈⠛⠲⠦⣄⣿⡇⠈⠙⠛⠶⠶⢶⣿⠀⠀⠀⢀⣴⣿⣿⣿⣯⣀⣀⣤⣤⣶⣿⣿⣿⣿⡛⠛⠋⠉⠉⠀⠀⠀⠀⠀  ");
        $display(
            "                                      ⠀⠀⠀⠀⠀⠘⣻⣷⣄⣙⡛⠶⠦⣤⣤⣄⣸⣷⡄⠀⠀⠀⢠⠏⣻⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠛⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀");
        $display("\n");
    endfunction
endmodule

