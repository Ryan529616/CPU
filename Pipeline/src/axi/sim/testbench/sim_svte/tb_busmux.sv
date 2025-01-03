/* ---------------------------------------------------------------------
**
// ------------------------------------------------------------------------------
// 
// Copyright 2001 - 2023 Synopsys, INC.
// 
// This Synopsys IP and all associated documentation are proprietary to
// Synopsys, Inc. and may only be used pursuant to the terms and conditions of a
// written license agreement with Synopsys, Inc. All other use, reproduction,
// modification, or distribution of the Synopsys IP or the associated
// documentation is strictly prohibited.
// Inclusivity & Diversity - Visit SolvNetPlus to read the "Synopsys Statement on
//            Inclusivity and Diversity" (Refer to article 000036315 at
//                        https://solvnetplus.synopsys.com)
// 
// Component Name   : DW_axi
// Component Version: 4.06a
// Release Type     : GA
// Build ID         : 18.26.9.4
// ------------------------------------------------------------------------------

// 
// Release version :  4.06a
// File Version     :        $Revision: #3 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi/axi_dev_br/sim/testbench/sim_svte/tb_busmux.sv#3 $ 
**
** ---------------------------------------------------------------------
**
** File     : tb_busmux.v
** Created  : Thu May 26 13:27:47 MEST 2005
** Modified : $Date: 2021/07/21 $
** Abstract : Parameterized one-hot mux 
**
** ---------------------------------------------------------------------
*/


module tb_busmux ( sel, din, dout );

   parameter BUS_COUNT = 2;   // Number of input buses.
   parameter MUX_WIDTH = 3;   // Bit width of data buses.
   parameter SEL_WIDTH = 1;   // Width of select line.

   input [SEL_WIDTH-1:0]           sel;  // Select signal.

   input [MUX_WIDTH*BUS_COUNT-1:0] din;  // Concatenated input buses.
   wire  [MUX_WIDTH*BUS_COUNT-1:0] din;  

   output [MUX_WIDTH-1:0] dout; // Output data bus.
   reg    [MUX_WIDTH-1:0] dout;             


   reg [BUS_COUNT-1:0] sel_oh; // One-hot select signals.


   // Create one hot version of sel input.
   // Used as select line for the mux.
   always @(sel) 
   begin : sel_oh_PROC
     integer busnum;

     sel_oh = {BUS_COUNT{1'b0}};

     for(busnum=0 ; busnum<=(BUS_COUNT-1) ; busnum=busnum+1) begin
       if(sel == busnum) sel_oh[busnum] = 1'b1;
     end

   end


   // One of the subtleties that might not be obvious that makes 
   // this work so well is the use of the blocking assignment (=) 
   // that allows dout to be built up incrementally. 
   // The one-hot select builds up into the wide "or" function 
   // you'd code by hand.
   always @ (sel_oh or din) begin : mux_logic
      integer i, j;
      dout = {MUX_WIDTH{1'b0}};
      for (i = 0; i <= (BUS_COUNT-1); i = i + 1) begin
        for (j = 0; j <= (MUX_WIDTH-1); j = j + 1) begin
          dout[j] = dout[j] | din[MUX_WIDTH*i +j]&sel_oh[i];
        end
      end
   end // always


  `ifdef PARAM_VARS_PROC
  // -------------------------------------------------------
  // Initial block added to declare and connect variables
  // to hold all parameters in this module for easy viewing
  // during debug in a wave viewer.
  // -------------------------------------------------------
  // synopsys translate_off 
  // VCS coverage off 
  initial begin : param_vars_PROC

    integer  BUS_COUNT_param; 
    integer  MUX_WIDTH_param; 
    integer  SEL_WIDTH_param; 


    BUS_COUNT_param = BUS_COUNT; 
    MUX_WIDTH_param = MUX_WIDTH; 
    SEL_WIDTH_param = SEL_WIDTH; 

  end // param_vars_PROC 

  // VCS coverage on 
  // synopsys translate_on 

  `endif // PARAM_VARS_PROC 
endmodule // tb_busmux

