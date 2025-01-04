/*
------------------------------------------------------------------------
--
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
// File Version     :        $Revision: #37 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi/axi_dev_br/src/DW_axi.v#37 $ 
--
-- File     : DW_axi.v
-- Abstract : Top Level File for DW_axi
--
------------------------------------------------------------------------
*/

`include "DW_axi_all_includes.vh"

//spyglass disable_block Topology_02
//SMD: No asynchronous pin to pin paths
//SJ: In DW_axi multiple inputs are directly invloved in evaluating the ouput. There is desired behavior and will not cause any functional issue, hence waived.
//==============================================================================
// Start License Usage
//==============================================================================
// Key Used   : DesignWare (IP access)
//==============================================================================
// End License Usage
//==============================================================================
module DW_axi (

  aclk
               ,aresetn
               // Write Address Channel from Manager1
               ,awvalid_m1
               ,awaddr_m1
               ,awid_m1
               ,awlen_m1
               ,awsize_m1
               ,awburst_m1
               ,awlock_m1
               ,awcache_m1
               ,awprot_m1
               ,awready_m1
               // Write Data Channel from Manager1
               ,wvalid_m1
               ,wid_m1
               ,wdata_m1
               ,wstrb_m1
               ,wlast_m1
               ,wready_m1
               // Write Response Channel from Manager1
               ,bvalid_m1
               ,bid_m1
               ,bresp_m1
               ,bready_m1
               // Read Address Channel from Manager1
               ,arvalid_m1
               ,arid_m1
               ,araddr_m1
               ,arlen_m1
               ,arsize_m1
               ,arburst_m1
               ,arlock_m1
               ,arcache_m1
               ,arprot_m1
               ,arready_m1
               // Read Data Channel from Manager1
               ,rvalid_m1
               ,rid_m1
               ,rdata_m1
               ,rresp_m1
               ,rlast_m1
               ,rready_m1
               // Write Address Channel from Manager2
               ,awvalid_m2
               ,awaddr_m2
               ,awid_m2
               ,awlen_m2
               ,awsize_m2
               ,awburst_m2
               ,awlock_m2
               ,awcache_m2
               ,awprot_m2
               ,awready_m2
               // Write Data Channel from Manager2
               ,wvalid_m2
               ,wid_m2
               ,wdata_m2
               ,wstrb_m2
               ,wlast_m2
               ,wready_m2
               // Write Response Channel from Manager2
               ,bvalid_m2
               ,bid_m2
               ,bresp_m2
               ,bready_m2
               // Read Address Channel from Manager2
               ,arvalid_m2
               ,arid_m2
               ,araddr_m2
               ,arlen_m2
               ,arsize_m2
               ,arburst_m2
               ,arlock_m2
               ,arcache_m2
               ,arprot_m2
               ,arready_m2
               // Read Data Channel from Manager2
               ,rvalid_m2
               ,rid_m2
               ,rdata_m2
               ,rresp_m2
               ,rlast_m2
               ,rready_m2
               // Write Address Channel from Subordinate1
               ,awvalid_s1
               ,awaddr_s1
               ,awid_s1
               ,awlen_s1
               ,awsize_s1
               ,awburst_s1
               ,awlock_s1
               ,awcache_s1
               ,awprot_s1
               ,awready_s1
               // Write Data Channel from Subordinate1
               ,wvalid_s1
               ,wid_s1
               ,wdata_s1
               ,wstrb_s1
               ,wlast_s1
               ,wready_s1
               // Write Response Channel from Subordinate1
               ,bvalid_s1
               ,bid_s1
               ,bresp_s1
               ,bready_s1
               // Read Address Channel from Subordinate1
               ,arvalid_s1
               ,arid_s1
               ,araddr_s1
               ,arlen_s1
               ,arsize_s1
               ,arburst_s1
               ,arlock_s1
               ,arcache_s1
               ,arprot_s1
               ,arready_s1
               // Read Data Channel from Subordinate1
               ,rvalid_s1
               ,rid_s1
               ,rdata_s1
               ,rresp_s1
               ,rlast_s1
               ,rready_s1
               ,// Default Secondary Port Signals
               // Default subordinate write address channel
               dbg_awid_s0
               ,dbg_awaddr_s0
               ,dbg_awlen_s0
               ,dbg_awsize_s0
               ,dbg_awburst_s0
               ,dbg_awlock_s0
               ,dbg_awcache_s0
               ,dbg_awprot_s0
               ,dbg_awvalid_s0
               ,dbg_awready_s0
               ,// Default subordinate write data channel
               dbg_wid_s0
               ,dbg_wdata_s0
               ,dbg_wstrb_s0
               ,dbg_wlast_s0
               ,dbg_wvalid_s0
               ,dbg_wready_s0
               ,// Default subordinate write burst response channel
               dbg_bid_s0
               ,dbg_bresp_s0
               ,dbg_bvalid_s0
               ,dbg_bready_s0
               ,// Default subordinate read address channel
               dbg_arid_s0
               ,dbg_araddr_s0
               ,dbg_arlen_s0
               ,dbg_arsize_s0
               ,dbg_arburst_s0
               ,dbg_arlock_s0
               ,dbg_arcache_s0
               ,dbg_arprot_s0
               ,dbg_arvalid_s0
               ,dbg_arready_s0
               ,// Default subordinate read data channel
               dbg_rid_s0
               ,dbg_rdata_s0
               ,dbg_rresp_s0
               ,dbg_rvalid_s0
               ,dbg_rlast_s0
               ,dbg_rready_s0
               ,//Debug Interface
               dbg_active_trans
               );
//spyglass enable_block Topology_02


  input                       aclk;
  input                       aresetn;



  

// Write Address Channel from Manager 1
  input                       awvalid_m1;
  input  [`AXI_AW-1:0]        awaddr_m1;
  input  [`AXI_IDW_M1-1:0]     awid_m1;
  input  [`AXI_BLW-1:0]       awlen_m1;
  input  [`AXI_BSW-1:0]       awsize_m1;
  input  [`AXI_BTW-1:0]       awburst_m1;
  input  [`AXI_LTW-1:0]       awlock_m1;
  input  [`AXI_CTW-1:0]       awcache_m1;
  input  [`AXI_PTW-1:0]       awprot_m1;

  output                      awready_m1;
  
// Write Data Channel from Manager 1
  input                       wvalid_m1;

  input  [`AXI_IDW_M1-1:0]     wid_m1;
  input  [`AXI_DW-1:0]        wdata_m1;
  input  [`AXI_SW-1:0]        wstrb_m1;
  input                       wlast_m1;

  output                      wready_m1;
// Write Response Channel from Manager 1
  output                      bvalid_m1;
  output [`AXI_IDW_M1-1:0]     bid_m1;
  output [`AXI_BRW-1:0]       bresp_m1;
  input                       bready_m1;
// Read Address Channel from Manager 1
  input                       arvalid_m1;
  input  [`AXI_IDW_M1-1:0]     arid_m1;
  input  [`AXI_AW-1:0]        araddr_m1;
  input  [`AXI_BLW-1:0]       arlen_m1;
  input  [`AXI_BSW-1:0]       arsize_m1;
  input  [`AXI_BTW-1:0]       arburst_m1;
  input  [`AXI_LTW-1:0]       arlock_m1;
  input  [`AXI_CTW-1:0]       arcache_m1;
  input  [`AXI_PTW-1:0]       arprot_m1;
  output                      arready_m1;

// Read Data Channel from Manager 1
  output                      rvalid_m1;
  output [`AXI_IDW_M1-1:0]     rid_m1;
  output [`AXI_DW-1:0]        rdata_m1;
  output                      rlast_m1;
  output [`AXI_RRW-1:0]       rresp_m1;
  input                       rready_m1;

  

// Write Address Channel from Manager2
  input                       awvalid_m2;
  input  [`AXI_AW-1:0]        awaddr_m2;

  input  [`AXI_IDW_M2-1:0]     awid_m2;
 
  input  [`AXI_BLW-1:0]       awlen_m2;
  input  [`AXI_BSW-1:0]       awsize_m2;
  input  [`AXI_BTW-1:0]       awburst_m2;
  input  [`AXI_LTW-1:0]       awlock_m2;
  input  [`AXI_CTW-1:0]       awcache_m2;
  input  [`AXI_PTW-1:0]       awprot_m2;
  output                      awready_m2;

  
  

// Write Data Channel from Manager2
  input                       wvalid_m2;

  input  [`AXI_IDW_M2-1:0]     wid_m2;

  input  [`AXI_DW-1:0]        wdata_m2;
  input  [`AXI_SW-1:0]        wstrb_m2;
  input                       wlast_m2;
  output                      wready_m2;
// Write Response Channel from Manager2
  output                      bvalid_m2;

  output [`AXI_IDW_M2-1:0]     bid_m2;

  output [`AXI_BRW-1:0]       bresp_m2;
  input                       bready_m2;
// Read Address Channel from Manager2
  input                       arvalid_m2;
  input  [`AXI_IDW_M2-1:0]     arid_m2;

  input  [`AXI_AW-1:0]        araddr_m2;
  input  [`AXI_BLW-1:0]       arlen_m2;
  input  [`AXI_BSW-1:0]       arsize_m2;
  input  [`AXI_BTW-1:0]       arburst_m2;
  input  [`AXI_LTW-1:0]       arlock_m2;
  input  [`AXI_CTW-1:0]       arcache_m2;
  input  [`AXI_PTW-1:0]       arprot_m2;
  output                      arready_m2;

  
  
// Read Data Channel from Manager2
  output                      rvalid_m2;

  output [`AXI_IDW_M2-1:0]     rid_m2;

  output [`AXI_DW-1:0]        rdata_m2;
  output                      rlast_m2;
  output [`AXI_RRW-1:0]       rresp_m2;
  input                       rready_m2;


  


 

  
  







  
  




  


 

  
  







  
  




  


 

  
  






  
  




  


 

  
  






  
  




  


 

  
  






  
  




  


 

  
  






  
  




  


 

  
  






  
  




  


 

  
  






  
  




  


 

  
  






  
  




  


 

  
  






  
  




  


 

  
  






  
  




  


 

  
  






  
  




  


 

  
  






  
  




  


 

  
  






  
  




// Write Address Channel from Subordinate 1
  output                      awvalid_s1;
  output [`AXI_AW-1:0]        awaddr_s1;

  output [`AXI_SIDW-1:0]     awid_s1;

  output [`AXI_BLW-1:0]       awlen_s1;
  output [`AXI_BSW-1:0]       awsize_s1;
  output [`AXI_BTW-1:0]       awburst_s1;
  output [`AXI_LTW-1:0]       awlock_s1;
  output [`AXI_CTW-1:0]       awcache_s1;
  output [`AXI_PTW-1:0]       awprot_s1;
  input                       awready_s1;

  
  

// Write Data Channel from Subordinate 1
  output                      wvalid_s1;

  output [`AXI_SIDW-1:0]     wid_s1;

  output [`AXI_DW-1:0]        wdata_s1;
  output [`AXI_SW-1:0]        wstrb_s1;
  output                      wlast_s1;
  input                       wready_s1;
// Write Response Channel from Subordinate 1
  input                       bvalid_s1;

  input  [`AXI_SIDW-1:0]     bid_s1;

  input  [`AXI_BRW-1:0]       bresp_s1;
  output                      bready_s1;
// Read Address Channel from Subordinate 1
  output                      arvalid_s1;

  output [`AXI_SIDW-1:0]     arid_s1;

  output [`AXI_AW-1:0]        araddr_s1;
  output [`AXI_BLW-1:0]       arlen_s1;
  output [`AXI_BSW-1:0]       arsize_s1;
  output [`AXI_BTW-1:0]       arburst_s1;
  output [`AXI_LTW-1:0]       arlock_s1;
  output [`AXI_CTW-1:0]       arcache_s1;
  output [`AXI_PTW-1:0]       arprot_s1;
  input                       arready_s1;
  

// Read Data Channel from Subordinate 1
  input                       rvalid_s1;

  input  [`AXI_SIDW-1:0]     rid_s1;

  input  [`AXI_DW-1:0]        rdata_s1;
  input                       rlast_s1;
  input  [`AXI_RRW-1:0]       rresp_s1;
  output                      rready_s1;



  
  
  



  




  






  
  
  



  




  






  
  
  



  




  






  
  
  



  




  






  
  
  



  




  






  
  
  



  




  






  
  
  



  




  






  
  
  



  




  






  
  
  



  




  






  
  
  



  




  






  
  
  



  




  






  
  
  



  




  






  
  
  



  




  






  
  
  



  




  






  
  
  



  




  




  output [`AXI_SIDW-1:0] dbg_awid_s0;
  output [`AXI_AW-1:0]   dbg_awaddr_s0;
  output [`AXI_BLW-1:0]  dbg_awlen_s0;
  output [`AXI_BSW-1:0]  dbg_awsize_s0;
  output [`AXI_BTW-1:0]  dbg_awburst_s0;
  output [`AXI_LTW-1:0]  dbg_awlock_s0;
  output [`AXI_CTW-1:0]   dbg_awcache_s0;
  output [`AXI_PTW-1:0]  dbg_awprot_s0;
  output                  dbg_awvalid_s0;
  output                  dbg_awready_s0;

  // Default subordinate write data channel
  output [`AXI_SIDW-1:0]   dbg_wid_s0;
  output [`AXI_DW-1:0]     dbg_wdata_s0;
  output [`AXI_SW-1:0]     dbg_wstrb_s0;
  output                    dbg_wlast_s0;
  output                    dbg_wvalid_s0;
  output                    dbg_wready_s0;

  // Default Subordinate write burst response channel
  output [`AXI_SIDW-1:0]   dbg_bid_s0;
  output [`AXI_BRW-1:0]    dbg_bresp_s0;
  output                    dbg_bvalid_s0;
  output                    dbg_bready_s0;

  // Default subordinate read address channel
  output [`AXI_SIDW-1:0] dbg_arid_s0;
  output [`AXI_AW-1:0]   dbg_araddr_s0;
  output [`AXI_BLW-1:0]  dbg_arlen_s0;
  output [`AXI_BSW-1:0]  dbg_arsize_s0;
  output [`AXI_BTW-1:0]  dbg_arburst_s0;
  output [`AXI_LTW-1:0]  dbg_arlock_s0;
  output [`AXI_CTW-1:0]  dbg_arcache_s0;
  output [`AXI_PTW-1:0]  dbg_arprot_s0;
  output                  dbg_arvalid_s0;
  output                  dbg_arready_s0;

  // Default subordinate read data channel
  output [`AXI_SIDW-1:0] dbg_rid_s0;
  output [`AXI_DW-1:0]   dbg_rdata_s0;
  output [`AXI_RRW-1:0]  dbg_rresp_s0;
  output                  dbg_rvalid_s0;
  output                  dbg_rlast_s0;
  output                  dbg_rready_s0;
  output                  dbg_active_trans;

  

  wire                                      arready_s0;
  wire                                      arvalid_s0;
  wire [`AXI_AR_PYLD_S_W-1:0]               arpayload_s0;
  wire [`AXI_AR_S0_NMV-1:0]                    bus_arvalid_s0;
  wire [(`AXI_AR_S0_NMV*`AXI_AR_PYLD_S_W)-1:0] bus_arpayload_s0;
  wire [`AXI_AR_S0_NMV-1:0]               bus_sp_arready_s0;
  wire                                       rcpl_tx_s0;
 
  wire                                      rvalid_s0;
  wire [`AXI_R_PYLD_S_W-1:0]                rpayload_s0;
  wire                                      rready_s0;
  wire [`AXI_NMV_S0-1:0]                    bus_rready_s0;
  wire [`AXI_NMV_S0-1:0]                    sp_rvalid_s0;
  wire                                            r_shrd_ch_req_s0;
  wire [`AXI_R_PYLD_M_W-1:0]                sp_rpayload_s0;
 
  wire                                      awready_s0;
  wire                                      awvalid_s0;
  wire [`AXI_AW_PYLD_S_W-1:0]               awpayload_s0;
  wire [`AXI_AW_S0_NMV-1:0]                    bus_awvalid_s0;
  wire [(`AXI_AW_S0_NMV*`AXI_AW_PYLD_S_W)-1:0] bus_awpayload_s0;
  wire [`AXI_AW_S0_NMV-1:0]               bus_sp_awready_s0;
  wire                                                aw_shrd_lyr_granted_s0;
 
  wire                                      wready_s0;
  wire                                      wvalid_s0;
  wire [`AXI_W_PYLD_S_W-1:0]                wpayload_s0;
  wire [`AXI_W_S0_NMV-1:0]                    bus_wvalid_s0;
  wire [(`AXI_W_S0_NMV*`AXI_W_PYLD_S_W)-1:0]  bus_wpayload_s0;
  wire [`AXI_W_S0_NMV-1:0]               bus_sp_wready_s0;
 
  wire                                      bvalid_s0;
  wire [`AXI_B_PYLD_S_W-1:0]               bpayload_s0;
  wire                                      bready_s0;
  wire [`AXI_NMV_S0-1:0]                    bus_bready_s0;
  wire [`AXI_NMV_S0-1:0]                    sp_bvalid_s0;
  wire                                            b_shrd_ch_req_s0;
  wire [`AXI_B_PYLD_M_W-1:0]                sp_bpayload_s0;
  wire                                       wcpl_tx_s0;
  wire                                      arready_s1;
  wire                                      arvalid_s1;
  wire [`AXI_AR_PYLD_S_W-1:0]               arpayload_s1;
  wire [`AXI_AR_S1_NMV-1:0]                    bus_arvalid_s1;
  wire [(`AXI_AR_S1_NMV*`AXI_AR_PYLD_S_W)-1:0] bus_arpayload_s1;
  wire [`AXI_AR_S1_NMV-1:0]               bus_sp_arready_s1;
  wire                                       rcpl_tx_s1;
 
  wire                                      rvalid_s1;
  wire [`AXI_R_PYLD_S_W-1:0]                rpayload_s1;
  wire                                      rready_s1;
  wire [`AXI_NMV_S1-1:0]                    bus_rready_s1;
  wire [`AXI_NMV_S1-1:0]                    sp_rvalid_s1;
  wire                                            r_shrd_ch_req_s1;
  wire [`AXI_R_PYLD_M_W-1:0]                sp_rpayload_s1;
 
  wire                                      awready_s1;
  wire                                      awvalid_s1;
  wire [`AXI_AW_PYLD_S_W-1:0]               awpayload_s1;
  wire [`AXI_AW_S1_NMV-1:0]                    bus_awvalid_s1;
  wire [(`AXI_AW_S1_NMV*`AXI_AW_PYLD_S_W)-1:0] bus_awpayload_s1;
  wire [`AXI_AW_S1_NMV-1:0]               bus_sp_awready_s1;
  wire                                                aw_shrd_lyr_granted_s1;
 
  wire                                      wready_s1;
  wire                                      wvalid_s1;
  wire [`AXI_W_PYLD_S_W-1:0]                wpayload_s1;
  wire [`AXI_W_S1_NMV-1:0]                    bus_wvalid_s1;
  wire [(`AXI_W_S1_NMV*`AXI_W_PYLD_S_W)-1:0]  bus_wpayload_s1;
  wire [`AXI_W_S1_NMV-1:0]               bus_sp_wready_s1;
 
  wire                                      bvalid_s1;
  wire [`AXI_B_PYLD_S_W-1:0]               bpayload_s1;
  wire                                      bready_s1;
  wire [`AXI_NMV_S1-1:0]                    bus_bready_s1;
  wire [`AXI_NMV_S1-1:0]                    sp_bvalid_s1;
  wire                                            b_shrd_ch_req_s1;
  wire [`AXI_B_PYLD_M_W-1:0]                sp_bpayload_s1;
  wire                                       wcpl_tx_s1;
  wire                                      arvalid_m1;
  wire [`AXI_AR_PYLD_M_W-1:0]               arpayload_m1;
  wire                                      arready_m1;
  wire [`AXI_NSP1V_M1-1:0]                           bus_arready_m1;
  wire [`AXI_NSP1V_M1-1:0]                    mp_arvalid_m1;
  wire [`AXI_NSP1V_M1-1:0]                    mp_arvalid_m1_q;
  wire                                              ar_shrd_ch_req_m1;
  wire [`AXI_AR_PYLD_S_W-1:0]                   mp_arpayload_m1;
 
 
  wire                                      rready_m1;
  wire                                      rvalid_m1;
  wire [`AXI_R_PYLD_M_W-1:0]               rpayload_m1;
  wire [`AXI_R_M1_NSV-1:0]                    bus_rvalid_m1;
  wire [(`AXI_R_M1_NSV*`AXI_R_PYLD_M_W)-1:0]    bus_rpayload_m1;
  wire [`AXI_R_M1_NSV-1:0]            bus_mp_rready_m1;
 
  wire                                      awvalid_m1;
  wire [`AXI_AW_PYLD_M_W-1:0]               awpayload_m1;
  wire                                      awready_m1;
  wire [`AXI_NSP1V_M1-1:0]                    bus_awready_m1;
  wire [`AXI_NSP1V_M1-1:0]                    aw_shrd_lyr_granted_m1_s_bus;
  wire [`AXI_NSP1V_M1-1:0]                    issued_wtx_shrd_sys_m1_s_bus;
  wire [`AXI_NSP1V_M1-1:0]                    mp_awvalid_m1;
  wire [`AXI_NSP1V_M1-1:0]                    mp_awvalid_m1_q;
  wire                                      aw_shrd_ch_req_m1;
  wire [(`AXI_AW_PYLD_S_W)-1:0]             mp_awpayload_m1;
 
  wire                                      wvalid_m1;
  wire [`AXI_W_PYLD_M_W-1:0]               wpayload_m1;
  wire                                      wready_m1;
  wire [`AXI_NSP1V_M1-1:0]                    bus_wready_m1;
  wire [`AXI_NSP1V_M1-1:0]                    mp_wvalid_m1;
  wire                                              w_shrd_ch_req_m1;
  wire [(`AXI_W_PYLD_S_W)-1:0]              mp_wpayload_m1;
 
  wire                                      bready_m1;
  wire                                      bvalid_m1;
  wire [`AXI_B_PYLD_M_W-1:0]               bpayload_m1;
  wire [`AXI_B_M1_NSV-1:0]                    bus_bvalid_m1;
  wire [(`AXI_B_M1_NSV*`AXI_B_PYLD_M_W)-1:0]    bus_bpayload_m1;
  wire [`AXI_B_M1_NSV-1:0]            bus_mp_bready_m1;
 wire                                       has_ar_pending_trans_m1;
 wire                                       has_aw_pending_trans_m1;
  wire                                      arvalid_m2;
  wire [`AXI_AR_PYLD_M_W-1:0]               arpayload_m2;
  wire                                      arready_m2;
  wire [`AXI_NSP1V_M2-1:0]                           bus_arready_m2;
  wire [`AXI_NSP1V_M2-1:0]                    mp_arvalid_m2;
  wire [`AXI_NSP1V_M2-1:0]                    mp_arvalid_m2_q;
  wire                                              ar_shrd_ch_req_m2;
  wire [`AXI_AR_PYLD_S_W-1:0]                   mp_arpayload_m2;
 
 
  wire                                      rready_m2;
  wire                                      rvalid_m2;
  wire [`AXI_R_PYLD_M_W-1:0]               rpayload_m2;
  wire [`AXI_R_M2_NSV-1:0]                    bus_rvalid_m2;
  wire [(`AXI_R_M2_NSV*`AXI_R_PYLD_M_W)-1:0]    bus_rpayload_m2;
  wire [`AXI_R_M2_NSV-1:0]            bus_mp_rready_m2;
 
  wire                                      awvalid_m2;
  wire [`AXI_AW_PYLD_M_W-1:0]               awpayload_m2;
  wire                                      awready_m2;
  wire [`AXI_NSP1V_M2-1:0]                    bus_awready_m2;
  wire [`AXI_NSP1V_M2-1:0]                    aw_shrd_lyr_granted_m2_s_bus;
  wire [`AXI_NSP1V_M2-1:0]                    issued_wtx_shrd_sys_m2_s_bus;
  wire [`AXI_NSP1V_M2-1:0]                    mp_awvalid_m2;
  wire [`AXI_NSP1V_M2-1:0]                    mp_awvalid_m2_q;
  wire                                      aw_shrd_ch_req_m2;
  wire [(`AXI_AW_PYLD_S_W)-1:0]             mp_awpayload_m2;
 
  wire                                      wvalid_m2;
  wire [`AXI_W_PYLD_M_W-1:0]               wpayload_m2;
  wire                                      wready_m2;
  wire [`AXI_NSP1V_M2-1:0]                    bus_wready_m2;
  wire [`AXI_NSP1V_M2-1:0]                    mp_wvalid_m2;
  wire                                              w_shrd_ch_req_m2;
  wire [(`AXI_W_PYLD_S_W)-1:0]              mp_wpayload_m2;
 
  wire                                      bready_m2;
  wire                                      bvalid_m2;
  wire [`AXI_B_PYLD_M_W-1:0]               bpayload_m2;
  wire [`AXI_B_M2_NSV-1:0]                    bus_bvalid_m2;
  wire [(`AXI_B_M2_NSV*`AXI_B_PYLD_M_W)-1:0]    bus_bpayload_m2;
  wire [`AXI_B_M2_NSV-1:0]            bus_mp_bready_m2;
 wire                                       has_ar_pending_trans_m2;
 wire                                       has_aw_pending_trans_m2;
 wire                                       has_ar_pending_trans_m3;
 wire                                       has_aw_pending_trans_m3;
 wire                                       has_ar_pending_trans_m4;
 wire                                       has_aw_pending_trans_m4;
 wire                                       has_ar_pending_trans_m5;
 wire                                       has_aw_pending_trans_m5;
 wire                                       has_ar_pending_trans_m6;
 wire                                       has_aw_pending_trans_m6;
 wire                                       has_ar_pending_trans_m7;
 wire                                       has_aw_pending_trans_m7;
 wire                                       has_ar_pending_trans_m8;
 wire                                       has_aw_pending_trans_m8;
 wire                                       has_ar_pending_trans_m9;
 wire                                       has_aw_pending_trans_m9;
 wire                                        has_ar_pending_trans_m10;
 wire                                        has_aw_pending_trans_m10;
 wire                                        has_ar_pending_trans_m11;
 wire                                        has_aw_pending_trans_m11;
 wire                                        has_ar_pending_trans_m12;
 wire                                        has_aw_pending_trans_m12;
 wire                                        has_ar_pending_trans_m13;
 wire                                        has_aw_pending_trans_m13;
 wire                                        has_ar_pending_trans_m14;
 wire                                        has_aw_pending_trans_m14;
 wire                                        has_ar_pending_trans_m15;
 wire                                        has_aw_pending_trans_m15;
 wire                                        has_ar_pending_trans_m16;
 wire                                        has_aw_pending_trans_m16;


  // Wire declarations for default slave.  
  // Only need to declare signals which make up the payload
  // signals for each channel i.e. all except ready and valid.

  // Read address channel.
  wire  [`AXI_SIDW-1:0]     arid_s0;
  wire  [`AXI_AW-1:0]       araddr_s0;
  wire  [`AXI_BLW-1:0]      arlen_s0;
  wire  [`AXI_BSW-1:0]      arsize_s0;
  wire  [`AXI_BTW-1:0]      arburst_s0;
  wire  [`AXI_LTW-1:0]      arlock_s0;
  wire  [`AXI_CTW-1:0]      arcache_s0;  
  wire  [`AXI_PTW-1:0]      arprot_s0;

  // Read data channel.
  wire [`AXI_SIDW-1:0]     rid_s0;
  wire [`AXI_DW-1:0]       rdata_s0;
  wire                      rlast_s0;
  wire [`AXI_RRW-1:0]      rresp_s0;
  // Write address channel.
  wire  [`AXI_SIDW-1:0]     awid_s0;
  wire  [`AXI_AW-1:0]       awaddr_s0;
  wire  [`AXI_BLW-1:0]      awlen_s0;
  wire  [`AXI_BSW-1:0]      awsize_s0;
  wire  [`AXI_BTW-1:0]      awburst_s0;
  wire  [`AXI_LTW-1:0]      awlock_s0;
  wire  [`AXI_CTW-1:0]      awcache_s0;  
  wire  [`AXI_PTW-1:0]      awprot_s0;

  // Write data channel.
  wire [`AXI_SIDW-1:0]     wid_s0;
  wire [`AXI_DW-1:0]       wdata_s0;
  wire [`AXI_SW-1:0]       wstrb_s0;
  wire                      wlast_s0;

  // Burst response channel.
  wire [`AXI_SIDW-1:0]     bid_s0;
  wire [`AXI_BRW-1:0]      bresp_s0;


  wire [`AXI_NSP1V_M1-1:0] bus_tz_secure_m1;
  wire [`AXI_NSP1V_M2-1:0] bus_tz_secure_m2;
// Ready signals from each slaves dedicated secondary port back to the shared
// secondary port (i.e. shared to dedicated link).
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
// Ready signals from each masters dedicated primary port back to the shared
// primary port (i.e. shared to dedicated link).
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
    wire [`AXI_R_PYLD_M_W-1:0]               rpayload_s0_m1;
    wire [`AXI_B_PYLD_M_W-1:0]               bpayload_s0_m1;
    wire                                      arready_s0_m1;
    wire                                      arvalid_s0_m1;
    wire [`AXI_AR_PYLD_S_W-1:0]               arpayload_s0_m1;
    wire                                      rvalid_s0_m1;
    wire                                      rready_s0_m1;
    wire                                      awready_s0_m1;
    wire                                      awvalid_s0_m1;
    wire [`AXI_AW_PYLD_S_W-1:0]               awpayload_s0_m1;
    wire                                      wready_s0_m1;
    wire                                      wvalid_s0_m1;
    wire [`AXI_W_PYLD_S_W-1:0]               wpayload_s0_m1;
    wire                                      bvalid_s0_m1;
    wire                                      bready_s0_m1;
    wire [`AXI_R_PYLD_M_W-1:0]               rpayload_s1_m1;
    wire [`AXI_B_PYLD_M_W-1:0]               bpayload_s1_m1;
    wire                                      arready_s1_m1;
    wire                                      arvalid_s1_m1;
    wire [`AXI_AR_PYLD_S_W-1:0]               arpayload_s1_m1;
    wire                                      rvalid_s1_m1;
    wire                                      rready_s1_m1;
    wire                                      awready_s1_m1;
    wire                                      awvalid_s1_m1;
    wire [`AXI_AW_PYLD_S_W-1:0]               awpayload_s1_m1;
    wire                                      wready_s1_m1;
    wire                                      wvalid_s1_m1;
    wire [`AXI_W_PYLD_S_W-1:0]               wpayload_s1_m1;
    wire                                      bvalid_s1_m1;
    wire                                      bready_s1_m1;
    wire [`AXI_R_PYLD_M_W-1:0]               rpayload_s0_m2;
    wire [`AXI_B_PYLD_M_W-1:0]               bpayload_s0_m2;
    wire                                      arready_s0_m2;
    wire                                      arvalid_s0_m2;
    wire [`AXI_AR_PYLD_S_W-1:0]               arpayload_s0_m2;
    wire                                      rvalid_s0_m2;
    wire                                      rready_s0_m2;
    wire                                      awready_s0_m2;
    wire                                      awvalid_s0_m2;
    wire [`AXI_AW_PYLD_S_W-1:0]               awpayload_s0_m2;
    wire                                      wready_s0_m2;
    wire                                      wvalid_s0_m2;
    wire [`AXI_W_PYLD_S_W-1:0]               wpayload_s0_m2;
    wire                                      bvalid_s0_m2;
    wire                                      bready_s0_m2;
    wire [`AXI_R_PYLD_M_W-1:0]               rpayload_s1_m2;
    wire [`AXI_B_PYLD_M_W-1:0]               bpayload_s1_m2;
    wire                                      arready_s1_m2;
    wire                                      arvalid_s1_m2;
    wire [`AXI_AR_PYLD_S_W-1:0]               arpayload_s1_m2;
    wire                                      rvalid_s1_m2;
    wire                                      rready_s1_m2;
    wire                                      awready_s1_m2;
    wire                                      awvalid_s1_m2;
    wire [`AXI_AW_PYLD_S_W-1:0]               awpayload_s1_m2;
    wire                                      wready_s1_m2;
    wire                                      wvalid_s1_m2;
    wire [`AXI_W_PYLD_S_W-1:0]               wpayload_s1_m2;
    wire                                      bvalid_s1_m2;
    wire                                      bready_s1_m2;
    wire                                  blank_arready_s0;
    wire                                  blank_arvalid_s0;
    wire                                  blank_arpayload_s0;
    wire                                  blank_arqos_s0;
    wire                                  blank_rvalid_s0;
    wire                                  blank_rpayload_s0;
    wire                                  blank_rready_s0;
    wire                                  blank_awready_s0;
    wire                                  blank_awvalid_s0;
    wire                                  blank_awpayload_s0;
    wire                                  blank_awqos_s0;
    wire                                  blank_wready_s0;
    wire                                  blank_wvalid_s0;
    wire                                  blank_wpayload_s0;
    wire                                  blank_bvalid_s0;
    wire                                  blank_bpayload_s0;
    wire                                  blank_bready_s0;
    wire                                  blank_arlocktx_s0;
    wire                                  blank_awlocktx_s0;
    wire                                  blank_arready_s1;
    wire                                  blank_arvalid_s1;
    wire                                  blank_arpayload_s1;
    wire                                  blank_arqos_s1;
    wire                                  blank_rvalid_s1;
    wire                                  blank_rpayload_s1;
    wire                                  blank_rready_s1;
    wire                                  blank_awready_s1;
    wire                                  blank_awvalid_s1;
    wire                                  blank_awpayload_s1;
    wire                                  blank_awqos_s1;
    wire                                  blank_wready_s1;
    wire                                  blank_wvalid_s1;
    wire                                  blank_wpayload_s1;
    wire                                  blank_bvalid_s1;
    wire                                  blank_bpayload_s1;
    wire                                  blank_bready_s1;
    wire                                  blank_arlocktx_s1;
    wire                                  blank_awlocktx_s1;
    wire                                  blank_arvalid_m1;
    wire                                  blank_arready_m1;
    wire                                  blank_arpayload_m1;
    wire                                  blank_arqos_m1;
    wire                                  blank_rvalid_m1;
    wire                                  blank_rpayload_m1;
    wire                                  blank_rready_m1;
    wire                                  blank_awvalid_m1;
    wire                                  blank_awready_m1;
    wire                                  blank_awpayload_m1;
    wire                                  blank_awqos_m1;
    wire                                  blank_wvalid_m1;
    wire                                  blank_wready_m1;
    wire                                  blank_wpayload_m1;
    wire                                  blank_bvalid_m1;
    wire                                  blank_bpayload_m1;
    wire                                  blank_bready_m1;
    wire                                  blank_arvalid_m2;
    wire                                  blank_arready_m2;
    wire                                  blank_arpayload_m2;
    wire                                  blank_arqos_m2;
    wire                                  blank_rvalid_m2;
    wire                                  blank_rpayload_m2;
    wire                                  blank_rready_m2;
    wire                                  blank_awvalid_m2;
    wire                                  blank_awready_m2;
    wire                                  blank_awpayload_m2;
    wire                                  blank_awqos_m2;
    wire                                  blank_wvalid_m2;
    wire                                  blank_wready_m2;
    wire                                  blank_wpayload_m2;
    wire                                  blank_bvalid_m2;
    wire                                  blank_bpayload_m2;
    wire                                  blank_bready_m2;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 


  // AR CHANNEL SHARED LAYER SIGNALS

  // Bus of of signals from each master containing a valid signal for each
  // slave connected to the shared AR channel. 
  // Note : the *eb signals contain a dummy extra bit, which makes assignments easier later.
  // The dummy bit is eventually removed in the assignment to the corresponding signal of
  // the correct length.
  // Signals will always be declared but will only be used/synthesised when required.
  
  wire [`AXI_AR_SHARED_LAYER_NS:0]   arvalid_s_shrd_m1_bus_eb;
  wire [`AXI_AR_SHARED_LAYER_NS-1:0] arvalid_s_shrd_m1_bus;
  
  wire [`AXI_AR_SHARED_LAYER_NS:0]   arvalid_s_shrd_m2_bus_eb;
  wire [`AXI_AR_SHARED_LAYER_NS-1:0] arvalid_s_shrd_m2_bus;
  
  wire [`AXI_AR_SHARED_LAYER_NS:0]   arvalid_s_shrd_m3_bus_eb;
  wire [`AXI_AR_SHARED_LAYER_NS-1:0] arvalid_s_shrd_m3_bus;
  
  wire [`AXI_AR_SHARED_LAYER_NS:0]   arvalid_s_shrd_m4_bus_eb;
  wire [`AXI_AR_SHARED_LAYER_NS-1:0] arvalid_s_shrd_m4_bus;
  
  wire [`AXI_AR_SHARED_LAYER_NS:0]   arvalid_s_shrd_m5_bus_eb;
  wire [`AXI_AR_SHARED_LAYER_NS-1:0] arvalid_s_shrd_m5_bus;
  
  wire [`AXI_AR_SHARED_LAYER_NS:0]   arvalid_s_shrd_m6_bus_eb;
  wire [`AXI_AR_SHARED_LAYER_NS-1:0] arvalid_s_shrd_m6_bus;
  
  wire [`AXI_AR_SHARED_LAYER_NS:0]   arvalid_s_shrd_m7_bus_eb;
  wire [`AXI_AR_SHARED_LAYER_NS-1:0] arvalid_s_shrd_m7_bus;
  
  wire [`AXI_AR_SHARED_LAYER_NS:0]   arvalid_s_shrd_m8_bus_eb;
  wire [`AXI_AR_SHARED_LAYER_NS-1:0] arvalid_s_shrd_m8_bus;
  
  wire [`AXI_AR_SHARED_LAYER_NS:0]   arvalid_s_shrd_m9_bus_eb;
  wire [`AXI_AR_SHARED_LAYER_NS-1:0] arvalid_s_shrd_m9_bus;
  
  wire [`AXI_AR_SHARED_LAYER_NS:0]   arvalid_s_shrd_m10_bus_eb;
  wire [`AXI_AR_SHARED_LAYER_NS-1:0] arvalid_s_shrd_m10_bus;
  
  wire [`AXI_AR_SHARED_LAYER_NS:0]   arvalid_s_shrd_m11_bus_eb;
  wire [`AXI_AR_SHARED_LAYER_NS-1:0] arvalid_s_shrd_m11_bus;
  
  wire [`AXI_AR_SHARED_LAYER_NS:0]   arvalid_s_shrd_m12_bus_eb;
  wire [`AXI_AR_SHARED_LAYER_NS-1:0] arvalid_s_shrd_m12_bus;
  
  wire [`AXI_AR_SHARED_LAYER_NS:0]   arvalid_s_shrd_m13_bus_eb;
  wire [`AXI_AR_SHARED_LAYER_NS-1:0] arvalid_s_shrd_m13_bus;
  
  wire [`AXI_AR_SHARED_LAYER_NS:0]   arvalid_s_shrd_m14_bus_eb;
  wire [`AXI_AR_SHARED_LAYER_NS-1:0] arvalid_s_shrd_m14_bus;
  
  wire [`AXI_AR_SHARED_LAYER_NS:0]   arvalid_s_shrd_m15_bus_eb;
  wire [`AXI_AR_SHARED_LAYER_NS-1:0] arvalid_s_shrd_m15_bus;
  
  wire [`AXI_AR_SHARED_LAYER_NS:0]   arvalid_s_shrd_m16_bus_eb;
  wire [`AXI_AR_SHARED_LAYER_NS-1:0] arvalid_s_shrd_m16_bus;

  // *_eb signals contain redundant bits which make configurable assigns easier.
  // Redundant bits removed before connection with destination signals.
  wire [(`AXI_AR_SHARED_LAYER_NS*`AXI_AR_SHARED_LAYER_NM):0] bus_arvalid_sp_shrd_eb;
  wire [(`AXI_AR_SHARED_LAYER_NS*`AXI_AR_SHARED_LAYER_NM)-1:0] bus_arvalid_sp_shrd;
  wire [`AXI_AR_SHARED_LAYER_NM:0] bus_ar_shrd_ch_req_eb;
  wire [`AXI_AR_SHARED_LAYER_NM-1:0] bus_ar_shrd_ch_req;
  wire [(`AXI_AR_PYLD_S_W*`AXI_AR_SHARED_LAYER_NM):0] bus_arpayload_shrd_eb;
  wire [(`AXI_AR_PYLD_S_W*`AXI_AR_SHARED_LAYER_NM)-1:0] bus_arpayload_shrd;
  wire [`AXI_AR_SHARED_LAYER_NM:0] bus_arlocktx_shrd_sp_eb;
  wire [`AXI_AR_SHARED_LAYER_NM-1:0] bus_arlocktx_shrd_sp;
  wire [`AXI_AR_SHARED_LAYER_NM-1:0] bus_arready_shrd_sp_o;

    wire [`AXI_AR_SHARED_LAYER_NS:0]   bus_rcpl_tx_shrd_eb;
    wire [`AXI_AR_SHARED_LAYER_NS-1:0] bus_rcpl_tx_shrd; 

  wire [`AXI_MST_PRIORITY_W*`AXI_AR_SHARED_LAYER_NM:0] ar_shrd_bus_mst_priorities_eb;
  wire [`AXI_MST_PRIORITY_W*`AXI_AR_SHARED_LAYER_NM-1:0] ar_shrd_bus_mst_priorities;
  wire [`AXI_AR_SHARED_LAYER_NS-1:0] bus_arvalid_shrd;
  wire [`AXI_AR_SHARED_LAYER_NS:0] bus_arready_shrd_sp_i_eb;
  wire [`AXI_AR_SHARED_LAYER_NS-1:0] bus_arready_shrd_sp_i;
  wire [`AXI_AR_PYLD_S_W-1:0] arpayload_shrd;
  
  wire arvalid_shrd_s0; 
  wire arvalid_shrd_s1; 
  wire arvalid_shrd_s2; 
  wire arvalid_shrd_s3; 
  wire arvalid_shrd_s4; 
  wire arvalid_shrd_s5; 
  wire arvalid_shrd_s6; 
  wire arvalid_shrd_s7; 
  wire arvalid_shrd_s8; 
  wire arvalid_shrd_s9; 
  wire arvalid_shrd_s10; 
  wire arvalid_shrd_s11; 
  wire arvalid_shrd_s12; 
  wire arvalid_shrd_s13; 
  wire arvalid_shrd_s14; 
  wire arvalid_shrd_s15; 
  wire arvalid_shrd_s16; 
  wire arvalid_shrd_sdummy; // Redundant bit, not synthesised.
  
  wire arvalid_ddctd_s0; 
  wire arvalid_ddctd_s1; 
  wire arvalid_ddctd_s2; 
  wire arvalid_ddctd_s3; 
  wire arvalid_ddctd_s4; 
  wire arvalid_ddctd_s5; 
  wire arvalid_ddctd_s6; 
  wire arvalid_ddctd_s7; 
  wire arvalid_ddctd_s8; 
  wire arvalid_ddctd_s9; 
  wire arvalid_ddctd_s10; 
  wire arvalid_ddctd_s11; 
  wire arvalid_ddctd_s12; 
  wire arvalid_ddctd_s13; 
  wire arvalid_ddctd_s14; 
  wire arvalid_ddctd_s15; 
  wire arvalid_ddctd_s16; 

  // Arready signals from shared SP layer to primary ports.
  wire arready_shrd_sp_dummy; // Redundant bit, not synthesised.
  wire arready_shrd_sp_m1; 
  wire arready_shrd_sp_m2; 
  wire arready_shrd_sp_m3; 
  wire arready_shrd_sp_m4; 
  wire arready_shrd_sp_m5; 
  wire arready_shrd_sp_m6; 
  wire arready_shrd_sp_m7; 
  wire arready_shrd_sp_m8; 
  wire arready_shrd_sp_m9; 
  wire arready_shrd_sp_m10; 
  wire arready_shrd_sp_m11; 
  wire arready_shrd_sp_m12; 
  wire arready_shrd_sp_m13; 
  wire arready_shrd_sp_m14; 
  wire arready_shrd_sp_m15; 
  wire arready_shrd_sp_m16; 


  // AW CHANNEL SHARED LAYER SIGNALS

  // Bus of of signals from each master containing a valid signal for each
  // slave connected to the shared AW channel. 
  // Note : the *eb signals contain a dummy extra bit, which makes assignments easier later.
  // The dummy bit is eventually removed in the assignment to the corresponding signal of
  // the correct length.
  // Signals will always be declared but will only be used/synthesised when required.
  
  wire [`AXI_AW_SHARED_LAYER_NS:0]   awvalid_s_shrd_m1_bus_eb;
  wire [`AXI_AW_SHARED_LAYER_NS-1:0] awvalid_s_shrd_m1_bus;
  
  wire [`AXI_AW_SHARED_LAYER_NS:0]   awvalid_s_shrd_m2_bus_eb;
  wire [`AXI_AW_SHARED_LAYER_NS-1:0] awvalid_s_shrd_m2_bus;
  
  wire [`AXI_AW_SHARED_LAYER_NS:0]   awvalid_s_shrd_m3_bus_eb;
  wire [`AXI_AW_SHARED_LAYER_NS-1:0] awvalid_s_shrd_m3_bus;
  
  wire [`AXI_AW_SHARED_LAYER_NS:0]   awvalid_s_shrd_m4_bus_eb;
  wire [`AXI_AW_SHARED_LAYER_NS-1:0] awvalid_s_shrd_m4_bus;
  
  wire [`AXI_AW_SHARED_LAYER_NS:0]   awvalid_s_shrd_m5_bus_eb;
  wire [`AXI_AW_SHARED_LAYER_NS-1:0] awvalid_s_shrd_m5_bus;
  
  wire [`AXI_AW_SHARED_LAYER_NS:0]   awvalid_s_shrd_m6_bus_eb;
  wire [`AXI_AW_SHARED_LAYER_NS-1:0] awvalid_s_shrd_m6_bus;
  
  wire [`AXI_AW_SHARED_LAYER_NS:0]   awvalid_s_shrd_m7_bus_eb;
  wire [`AXI_AW_SHARED_LAYER_NS-1:0] awvalid_s_shrd_m7_bus;
  
  wire [`AXI_AW_SHARED_LAYER_NS:0]   awvalid_s_shrd_m8_bus_eb;
  wire [`AXI_AW_SHARED_LAYER_NS-1:0] awvalid_s_shrd_m8_bus;
  
  wire [`AXI_AW_SHARED_LAYER_NS:0]   awvalid_s_shrd_m9_bus_eb;
  wire [`AXI_AW_SHARED_LAYER_NS-1:0] awvalid_s_shrd_m9_bus;
  
  wire [`AXI_AW_SHARED_LAYER_NS:0]   awvalid_s_shrd_m10_bus_eb;
  wire [`AXI_AW_SHARED_LAYER_NS-1:0] awvalid_s_shrd_m10_bus;
  
  wire [`AXI_AW_SHARED_LAYER_NS:0]   awvalid_s_shrd_m11_bus_eb;
  wire [`AXI_AW_SHARED_LAYER_NS-1:0] awvalid_s_shrd_m11_bus;
  
  wire [`AXI_AW_SHARED_LAYER_NS:0]   awvalid_s_shrd_m12_bus_eb;
  wire [`AXI_AW_SHARED_LAYER_NS-1:0] awvalid_s_shrd_m12_bus;
  
  wire [`AXI_AW_SHARED_LAYER_NS:0]   awvalid_s_shrd_m13_bus_eb;
  wire [`AXI_AW_SHARED_LAYER_NS-1:0] awvalid_s_shrd_m13_bus;
  
  wire [`AXI_AW_SHARED_LAYER_NS:0]   awvalid_s_shrd_m14_bus_eb;
  wire [`AXI_AW_SHARED_LAYER_NS-1:0] awvalid_s_shrd_m14_bus;
  
  wire [`AXI_AW_SHARED_LAYER_NS:0]   awvalid_s_shrd_m15_bus_eb;
  wire [`AXI_AW_SHARED_LAYER_NS-1:0] awvalid_s_shrd_m15_bus;
  
  wire [`AXI_AW_SHARED_LAYER_NS:0]   awvalid_s_shrd_m16_bus_eb;
  wire [`AXI_AW_SHARED_LAYER_NS-1:0] awvalid_s_shrd_m16_bus;

  // *_eb signals contain redundant bits which make configurable assigns easier.
  // Redundant bits removed before connection with destination signals.
  wire [(`AXI_AW_SHARED_LAYER_NS*`AXI_AW_SHARED_LAYER_NM):0] bus_awvalid_sp_shrd_eb;
  wire [(`AXI_AW_SHARED_LAYER_NS*`AXI_AW_SHARED_LAYER_NM)-1:0] bus_awvalid_sp_shrd;
  wire [`AXI_AW_SHARED_LAYER_NM:0] bus_aw_shrd_ch_req_eb;
  wire [`AXI_AW_SHARED_LAYER_NM-1:0] bus_aw_shrd_ch_req;
  wire [(`AXI_AW_PYLD_S_W*`AXI_AW_SHARED_LAYER_NM):0] bus_awpayload_shrd_eb;
  wire [(`AXI_AW_PYLD_S_W*`AXI_AW_SHARED_LAYER_NM)-1:0] bus_awpayload_shrd;
  wire [`AXI_AW_SHARED_LAYER_NM:0] bus_awlocktx_shrd_sp_eb;
  wire [`AXI_AW_SHARED_LAYER_NM-1:0] bus_awlocktx_shrd_sp;
  wire [`AXI_AW_SHARED_LAYER_NM-1:0] bus_awready_shrd_sp_o;

    wire [`AXI_AW_SHARED_LAYER_NS:0]   bus_wcpl_tx_shrd_eb;
    wire [`AXI_AW_SHARED_LAYER_NS-1:0] bus_wcpl_tx_shrd;

    // Signals to take t/x issued information from the shared AW channel
    // and connect to dedicated W channels.
    // Note the rewiring necessary to go from a one hot master bus of 
    // shared AW visibility, to a one hot master bus of dedicated
    // per slave visibility.
    wire [`AXI_AW_SHARED_LAYER_NS-1:0] issued_wtx_shrd_bus;
    wire [`AXI_AW_SHARED_LAYER_NM-1:0] issued_wtx_shrd_mst_oh;
    
  wire issued_wtx_shrd_sys_m1_s0;
  wire issued_wtx_shrd_sys_m2_s0;
  wire issued_wtx_shrd_sys_m3_s0;
  wire issued_wtx_shrd_sys_m4_s0;
  wire issued_wtx_shrd_sys_m5_s0;
  wire issued_wtx_shrd_sys_m6_s0;
  wire issued_wtx_shrd_sys_m7_s0;
  wire issued_wtx_shrd_sys_m8_s0;
  wire issued_wtx_shrd_sys_m9_s0;
  wire issued_wtx_shrd_sys_m10_s0;
  wire issued_wtx_shrd_sys_m11_s0;
  wire issued_wtx_shrd_sys_m12_s0;
  wire issued_wtx_shrd_sys_m13_s0;
  wire issued_wtx_shrd_sys_m14_s0;
  wire issued_wtx_shrd_sys_m15_s0;
  wire issued_wtx_shrd_sys_m16_s0;
  wire issued_wtx_shrd_sys_m_dummy_s0;
  wire issued_wtx_shrd_sys_m1_s1;
  wire issued_wtx_shrd_sys_m2_s1;
  wire issued_wtx_shrd_sys_m3_s1;
  wire issued_wtx_shrd_sys_m4_s1;
  wire issued_wtx_shrd_sys_m5_s1;
  wire issued_wtx_shrd_sys_m6_s1;
  wire issued_wtx_shrd_sys_m7_s1;
  wire issued_wtx_shrd_sys_m8_s1;
  wire issued_wtx_shrd_sys_m9_s1;
  wire issued_wtx_shrd_sys_m10_s1;
  wire issued_wtx_shrd_sys_m11_s1;
  wire issued_wtx_shrd_sys_m12_s1;
  wire issued_wtx_shrd_sys_m13_s1;
  wire issued_wtx_shrd_sys_m14_s1;
  wire issued_wtx_shrd_sys_m15_s1;
  wire issued_wtx_shrd_sys_m16_s1;
  wire issued_wtx_shrd_sys_m_dummy_s1;
  wire issued_wtx_shrd_sys_m1_s2;
  wire issued_wtx_shrd_sys_m2_s2;
  wire issued_wtx_shrd_sys_m3_s2;
  wire issued_wtx_shrd_sys_m4_s2;
  wire issued_wtx_shrd_sys_m5_s2;
  wire issued_wtx_shrd_sys_m6_s2;
  wire issued_wtx_shrd_sys_m7_s2;
  wire issued_wtx_shrd_sys_m8_s2;
  wire issued_wtx_shrd_sys_m9_s2;
  wire issued_wtx_shrd_sys_m10_s2;
  wire issued_wtx_shrd_sys_m11_s2;
  wire issued_wtx_shrd_sys_m12_s2;
  wire issued_wtx_shrd_sys_m13_s2;
  wire issued_wtx_shrd_sys_m14_s2;
  wire issued_wtx_shrd_sys_m15_s2;
  wire issued_wtx_shrd_sys_m16_s2;
  wire issued_wtx_shrd_sys_m_dummy_s2;
  wire issued_wtx_shrd_sys_m1_s3;
  wire issued_wtx_shrd_sys_m2_s3;
  wire issued_wtx_shrd_sys_m3_s3;
  wire issued_wtx_shrd_sys_m4_s3;
  wire issued_wtx_shrd_sys_m5_s3;
  wire issued_wtx_shrd_sys_m6_s3;
  wire issued_wtx_shrd_sys_m7_s3;
  wire issued_wtx_shrd_sys_m8_s3;
  wire issued_wtx_shrd_sys_m9_s3;
  wire issued_wtx_shrd_sys_m10_s3;
  wire issued_wtx_shrd_sys_m11_s3;
  wire issued_wtx_shrd_sys_m12_s3;
  wire issued_wtx_shrd_sys_m13_s3;
  wire issued_wtx_shrd_sys_m14_s3;
  wire issued_wtx_shrd_sys_m15_s3;
  wire issued_wtx_shrd_sys_m16_s3;
  wire issued_wtx_shrd_sys_m_dummy_s3;
  wire issued_wtx_shrd_sys_m1_s4;
  wire issued_wtx_shrd_sys_m2_s4;
  wire issued_wtx_shrd_sys_m3_s4;
  wire issued_wtx_shrd_sys_m4_s4;
  wire issued_wtx_shrd_sys_m5_s4;
  wire issued_wtx_shrd_sys_m6_s4;
  wire issued_wtx_shrd_sys_m7_s4;
  wire issued_wtx_shrd_sys_m8_s4;
  wire issued_wtx_shrd_sys_m9_s4;
  wire issued_wtx_shrd_sys_m10_s4;
  wire issued_wtx_shrd_sys_m11_s4;
  wire issued_wtx_shrd_sys_m12_s4;
  wire issued_wtx_shrd_sys_m13_s4;
  wire issued_wtx_shrd_sys_m14_s4;
  wire issued_wtx_shrd_sys_m15_s4;
  wire issued_wtx_shrd_sys_m16_s4;
  wire issued_wtx_shrd_sys_m_dummy_s4;
  wire issued_wtx_shrd_sys_m1_s5;
  wire issued_wtx_shrd_sys_m2_s5;
  wire issued_wtx_shrd_sys_m3_s5;
  wire issued_wtx_shrd_sys_m4_s5;
  wire issued_wtx_shrd_sys_m5_s5;
  wire issued_wtx_shrd_sys_m6_s5;
  wire issued_wtx_shrd_sys_m7_s5;
  wire issued_wtx_shrd_sys_m8_s5;
  wire issued_wtx_shrd_sys_m9_s5;
  wire issued_wtx_shrd_sys_m10_s5;
  wire issued_wtx_shrd_sys_m11_s5;
  wire issued_wtx_shrd_sys_m12_s5;
  wire issued_wtx_shrd_sys_m13_s5;
  wire issued_wtx_shrd_sys_m14_s5;
  wire issued_wtx_shrd_sys_m15_s5;
  wire issued_wtx_shrd_sys_m16_s5;
  wire issued_wtx_shrd_sys_m_dummy_s5;
  wire issued_wtx_shrd_sys_m1_s6;
  wire issued_wtx_shrd_sys_m2_s6;
  wire issued_wtx_shrd_sys_m3_s6;
  wire issued_wtx_shrd_sys_m4_s6;
  wire issued_wtx_shrd_sys_m5_s6;
  wire issued_wtx_shrd_sys_m6_s6;
  wire issued_wtx_shrd_sys_m7_s6;
  wire issued_wtx_shrd_sys_m8_s6;
  wire issued_wtx_shrd_sys_m9_s6;
  wire issued_wtx_shrd_sys_m10_s6;
  wire issued_wtx_shrd_sys_m11_s6;
  wire issued_wtx_shrd_sys_m12_s6;
  wire issued_wtx_shrd_sys_m13_s6;
  wire issued_wtx_shrd_sys_m14_s6;
  wire issued_wtx_shrd_sys_m15_s6;
  wire issued_wtx_shrd_sys_m16_s6;
  wire issued_wtx_shrd_sys_m_dummy_s6;
  wire issued_wtx_shrd_sys_m1_s7;
  wire issued_wtx_shrd_sys_m2_s7;
  wire issued_wtx_shrd_sys_m3_s7;
  wire issued_wtx_shrd_sys_m4_s7;
  wire issued_wtx_shrd_sys_m5_s7;
  wire issued_wtx_shrd_sys_m6_s7;
  wire issued_wtx_shrd_sys_m7_s7;
  wire issued_wtx_shrd_sys_m8_s7;
  wire issued_wtx_shrd_sys_m9_s7;
  wire issued_wtx_shrd_sys_m10_s7;
  wire issued_wtx_shrd_sys_m11_s7;
  wire issued_wtx_shrd_sys_m12_s7;
  wire issued_wtx_shrd_sys_m13_s7;
  wire issued_wtx_shrd_sys_m14_s7;
  wire issued_wtx_shrd_sys_m15_s7;
  wire issued_wtx_shrd_sys_m16_s7;
  wire issued_wtx_shrd_sys_m_dummy_s7;
  wire issued_wtx_shrd_sys_m1_s8;
  wire issued_wtx_shrd_sys_m2_s8;
  wire issued_wtx_shrd_sys_m3_s8;
  wire issued_wtx_shrd_sys_m4_s8;
  wire issued_wtx_shrd_sys_m5_s8;
  wire issued_wtx_shrd_sys_m6_s8;
  wire issued_wtx_shrd_sys_m7_s8;
  wire issued_wtx_shrd_sys_m8_s8;
  wire issued_wtx_shrd_sys_m9_s8;
  wire issued_wtx_shrd_sys_m10_s8;
  wire issued_wtx_shrd_sys_m11_s8;
  wire issued_wtx_shrd_sys_m12_s8;
  wire issued_wtx_shrd_sys_m13_s8;
  wire issued_wtx_shrd_sys_m14_s8;
  wire issued_wtx_shrd_sys_m15_s8;
  wire issued_wtx_shrd_sys_m16_s8;
  wire issued_wtx_shrd_sys_m_dummy_s8;
  wire issued_wtx_shrd_sys_m1_s9;
  wire issued_wtx_shrd_sys_m2_s9;
  wire issued_wtx_shrd_sys_m3_s9;
  wire issued_wtx_shrd_sys_m4_s9;
  wire issued_wtx_shrd_sys_m5_s9;
  wire issued_wtx_shrd_sys_m6_s9;
  wire issued_wtx_shrd_sys_m7_s9;
  wire issued_wtx_shrd_sys_m8_s9;
  wire issued_wtx_shrd_sys_m9_s9;
  wire issued_wtx_shrd_sys_m10_s9;
  wire issued_wtx_shrd_sys_m11_s9;
  wire issued_wtx_shrd_sys_m12_s9;
  wire issued_wtx_shrd_sys_m13_s9;
  wire issued_wtx_shrd_sys_m14_s9;
  wire issued_wtx_shrd_sys_m15_s9;
  wire issued_wtx_shrd_sys_m16_s9;
  wire issued_wtx_shrd_sys_m_dummy_s9;
  wire issued_wtx_shrd_sys_m1_s10;
  wire issued_wtx_shrd_sys_m2_s10;
  wire issued_wtx_shrd_sys_m3_s10;
  wire issued_wtx_shrd_sys_m4_s10;
  wire issued_wtx_shrd_sys_m5_s10;
  wire issued_wtx_shrd_sys_m6_s10;
  wire issued_wtx_shrd_sys_m7_s10;
  wire issued_wtx_shrd_sys_m8_s10;
  wire issued_wtx_shrd_sys_m9_s10;
  wire issued_wtx_shrd_sys_m10_s10;
  wire issued_wtx_shrd_sys_m11_s10;
  wire issued_wtx_shrd_sys_m12_s10;
  wire issued_wtx_shrd_sys_m13_s10;
  wire issued_wtx_shrd_sys_m14_s10;
  wire issued_wtx_shrd_sys_m15_s10;
  wire issued_wtx_shrd_sys_m16_s10;
  wire issued_wtx_shrd_sys_m_dummy_s10;
  wire issued_wtx_shrd_sys_m1_s11;
  wire issued_wtx_shrd_sys_m2_s11;
  wire issued_wtx_shrd_sys_m3_s11;
  wire issued_wtx_shrd_sys_m4_s11;
  wire issued_wtx_shrd_sys_m5_s11;
  wire issued_wtx_shrd_sys_m6_s11;
  wire issued_wtx_shrd_sys_m7_s11;
  wire issued_wtx_shrd_sys_m8_s11;
  wire issued_wtx_shrd_sys_m9_s11;
  wire issued_wtx_shrd_sys_m10_s11;
  wire issued_wtx_shrd_sys_m11_s11;
  wire issued_wtx_shrd_sys_m12_s11;
  wire issued_wtx_shrd_sys_m13_s11;
  wire issued_wtx_shrd_sys_m14_s11;
  wire issued_wtx_shrd_sys_m15_s11;
  wire issued_wtx_shrd_sys_m16_s11;
  wire issued_wtx_shrd_sys_m_dummy_s11;
  wire issued_wtx_shrd_sys_m1_s12;
  wire issued_wtx_shrd_sys_m2_s12;
  wire issued_wtx_shrd_sys_m3_s12;
  wire issued_wtx_shrd_sys_m4_s12;
  wire issued_wtx_shrd_sys_m5_s12;
  wire issued_wtx_shrd_sys_m6_s12;
  wire issued_wtx_shrd_sys_m7_s12;
  wire issued_wtx_shrd_sys_m8_s12;
  wire issued_wtx_shrd_sys_m9_s12;
  wire issued_wtx_shrd_sys_m10_s12;
  wire issued_wtx_shrd_sys_m11_s12;
  wire issued_wtx_shrd_sys_m12_s12;
  wire issued_wtx_shrd_sys_m13_s12;
  wire issued_wtx_shrd_sys_m14_s12;
  wire issued_wtx_shrd_sys_m15_s12;
  wire issued_wtx_shrd_sys_m16_s12;
  wire issued_wtx_shrd_sys_m_dummy_s12;
  wire issued_wtx_shrd_sys_m1_s13;
  wire issued_wtx_shrd_sys_m2_s13;
  wire issued_wtx_shrd_sys_m3_s13;
  wire issued_wtx_shrd_sys_m4_s13;
  wire issued_wtx_shrd_sys_m5_s13;
  wire issued_wtx_shrd_sys_m6_s13;
  wire issued_wtx_shrd_sys_m7_s13;
  wire issued_wtx_shrd_sys_m8_s13;
  wire issued_wtx_shrd_sys_m9_s13;
  wire issued_wtx_shrd_sys_m10_s13;
  wire issued_wtx_shrd_sys_m11_s13;
  wire issued_wtx_shrd_sys_m12_s13;
  wire issued_wtx_shrd_sys_m13_s13;
  wire issued_wtx_shrd_sys_m14_s13;
  wire issued_wtx_shrd_sys_m15_s13;
  wire issued_wtx_shrd_sys_m16_s13;
  wire issued_wtx_shrd_sys_m_dummy_s13;
  wire issued_wtx_shrd_sys_m1_s14;
  wire issued_wtx_shrd_sys_m2_s14;
  wire issued_wtx_shrd_sys_m3_s14;
  wire issued_wtx_shrd_sys_m4_s14;
  wire issued_wtx_shrd_sys_m5_s14;
  wire issued_wtx_shrd_sys_m6_s14;
  wire issued_wtx_shrd_sys_m7_s14;
  wire issued_wtx_shrd_sys_m8_s14;
  wire issued_wtx_shrd_sys_m9_s14;
  wire issued_wtx_shrd_sys_m10_s14;
  wire issued_wtx_shrd_sys_m11_s14;
  wire issued_wtx_shrd_sys_m12_s14;
  wire issued_wtx_shrd_sys_m13_s14;
  wire issued_wtx_shrd_sys_m14_s14;
  wire issued_wtx_shrd_sys_m15_s14;
  wire issued_wtx_shrd_sys_m16_s14;
  wire issued_wtx_shrd_sys_m_dummy_s14;
  wire issued_wtx_shrd_sys_m1_s15;
  wire issued_wtx_shrd_sys_m2_s15;
  wire issued_wtx_shrd_sys_m3_s15;
  wire issued_wtx_shrd_sys_m4_s15;
  wire issued_wtx_shrd_sys_m5_s15;
  wire issued_wtx_shrd_sys_m6_s15;
  wire issued_wtx_shrd_sys_m7_s15;
  wire issued_wtx_shrd_sys_m8_s15;
  wire issued_wtx_shrd_sys_m9_s15;
  wire issued_wtx_shrd_sys_m10_s15;
  wire issued_wtx_shrd_sys_m11_s15;
  wire issued_wtx_shrd_sys_m12_s15;
  wire issued_wtx_shrd_sys_m13_s15;
  wire issued_wtx_shrd_sys_m14_s15;
  wire issued_wtx_shrd_sys_m15_s15;
  wire issued_wtx_shrd_sys_m16_s15;
  wire issued_wtx_shrd_sys_m_dummy_s15;
  wire issued_wtx_shrd_sys_m1_s16;
  wire issued_wtx_shrd_sys_m2_s16;
  wire issued_wtx_shrd_sys_m3_s16;
  wire issued_wtx_shrd_sys_m4_s16;
  wire issued_wtx_shrd_sys_m5_s16;
  wire issued_wtx_shrd_sys_m6_s16;
  wire issued_wtx_shrd_sys_m7_s16;
  wire issued_wtx_shrd_sys_m8_s16;
  wire issued_wtx_shrd_sys_m9_s16;
  wire issued_wtx_shrd_sys_m10_s16;
  wire issued_wtx_shrd_sys_m11_s16;
  wire issued_wtx_shrd_sys_m12_s16;
  wire issued_wtx_shrd_sys_m13_s16;
  wire issued_wtx_shrd_sys_m14_s16;
  wire issued_wtx_shrd_sys_m15_s16;
  wire issued_wtx_shrd_sys_m16_s16;
  wire issued_wtx_shrd_sys_m_dummy_s16;
  wire [`AXI_AW_SHARED_LAYER_NM-1:0] issued_wtx_shrd_mst_oh_irs_apl_s0;
  wire [`AXI_NMV_S0:0] issued_wtx_shrd_mst_oh_s0_eb;
  wire [`AXI_NMV_S0-1:0] issued_wtx_shrd_mst_oh_s0;
  wire issued_wtx_shrd_sys_s0;
  wire [`AXI_AW_SHARED_LAYER_NM-1:0] issued_wtx_shrd_mst_oh_irs_apl_s1;
  wire [`AXI_NMV_S1:0] issued_wtx_shrd_mst_oh_s1_eb;
  wire [`AXI_NMV_S1-1:0] issued_wtx_shrd_mst_oh_s1;
  wire issued_wtx_shrd_sys_s1;
  wire [`AXI_AW_SHARED_LAYER_NM-1:0] issued_wtx_shrd_mst_oh_irs_apl_s2;
  wire [`AXI_NMV_S2:0] issued_wtx_shrd_mst_oh_s2_eb;
  wire [`AXI_NMV_S2-1:0] issued_wtx_shrd_mst_oh_s2;
  wire issued_wtx_shrd_sys_s2;
  wire [`AXI_AW_SHARED_LAYER_NM-1:0] issued_wtx_shrd_mst_oh_irs_apl_s3;
  wire [`AXI_NMV_S3:0] issued_wtx_shrd_mst_oh_s3_eb;
  wire [`AXI_NMV_S3-1:0] issued_wtx_shrd_mst_oh_s3;
  wire issued_wtx_shrd_sys_s3;
  wire [`AXI_AW_SHARED_LAYER_NM-1:0] issued_wtx_shrd_mst_oh_irs_apl_s4;
  wire [`AXI_NMV_S4:0] issued_wtx_shrd_mst_oh_s4_eb;
  wire [`AXI_NMV_S4-1:0] issued_wtx_shrd_mst_oh_s4;
  wire issued_wtx_shrd_sys_s4;
  wire [`AXI_AW_SHARED_LAYER_NM-1:0] issued_wtx_shrd_mst_oh_irs_apl_s5;
  wire [`AXI_NMV_S5:0] issued_wtx_shrd_mst_oh_s5_eb;
  wire [`AXI_NMV_S5-1:0] issued_wtx_shrd_mst_oh_s5;
  wire issued_wtx_shrd_sys_s5;
  wire [`AXI_AW_SHARED_LAYER_NM-1:0] issued_wtx_shrd_mst_oh_irs_apl_s6;
  wire [`AXI_NMV_S6:0] issued_wtx_shrd_mst_oh_s6_eb;
  wire [`AXI_NMV_S6-1:0] issued_wtx_shrd_mst_oh_s6;
  wire issued_wtx_shrd_sys_s6;
  wire [`AXI_AW_SHARED_LAYER_NM-1:0] issued_wtx_shrd_mst_oh_irs_apl_s7;
  wire [`AXI_NMV_S7:0] issued_wtx_shrd_mst_oh_s7_eb;
  wire [`AXI_NMV_S7-1:0] issued_wtx_shrd_mst_oh_s7;
  wire issued_wtx_shrd_sys_s7;
  wire [`AXI_AW_SHARED_LAYER_NM-1:0] issued_wtx_shrd_mst_oh_irs_apl_s8;
  wire [`AXI_NMV_S8:0] issued_wtx_shrd_mst_oh_s8_eb;
  wire [`AXI_NMV_S8-1:0] issued_wtx_shrd_mst_oh_s8;
  wire issued_wtx_shrd_sys_s8;
  wire [`AXI_AW_SHARED_LAYER_NM-1:0] issued_wtx_shrd_mst_oh_irs_apl_s9;
  wire [`AXI_NMV_S9:0] issued_wtx_shrd_mst_oh_s9_eb;
  wire [`AXI_NMV_S9-1:0] issued_wtx_shrd_mst_oh_s9;
  wire issued_wtx_shrd_sys_s9;
  wire [`AXI_AW_SHARED_LAYER_NM-1:0] issued_wtx_shrd_mst_oh_irs_apl_s10;
  wire [`AXI_NMV_S10:0] issued_wtx_shrd_mst_oh_s10_eb;
  wire [`AXI_NMV_S10-1:0] issued_wtx_shrd_mst_oh_s10;
  wire issued_wtx_shrd_sys_s10;
  wire [`AXI_AW_SHARED_LAYER_NM-1:0] issued_wtx_shrd_mst_oh_irs_apl_s11;
  wire [`AXI_NMV_S11:0] issued_wtx_shrd_mst_oh_s11_eb;
  wire [`AXI_NMV_S11-1:0] issued_wtx_shrd_mst_oh_s11;
  wire issued_wtx_shrd_sys_s11;
  wire [`AXI_AW_SHARED_LAYER_NM-1:0] issued_wtx_shrd_mst_oh_irs_apl_s12;
  wire [`AXI_NMV_S12:0] issued_wtx_shrd_mst_oh_s12_eb;
  wire [`AXI_NMV_S12-1:0] issued_wtx_shrd_mst_oh_s12;
  wire issued_wtx_shrd_sys_s12;
  wire [`AXI_AW_SHARED_LAYER_NM-1:0] issued_wtx_shrd_mst_oh_irs_apl_s13;
  wire [`AXI_NMV_S13:0] issued_wtx_shrd_mst_oh_s13_eb;
  wire [`AXI_NMV_S13-1:0] issued_wtx_shrd_mst_oh_s13;
  wire issued_wtx_shrd_sys_s13;
  wire [`AXI_AW_SHARED_LAYER_NM-1:0] issued_wtx_shrd_mst_oh_irs_apl_s14;
  wire [`AXI_NMV_S14:0] issued_wtx_shrd_mst_oh_s14_eb;
  wire [`AXI_NMV_S14-1:0] issued_wtx_shrd_mst_oh_s14;
  wire issued_wtx_shrd_sys_s14;
  wire [`AXI_AW_SHARED_LAYER_NM-1:0] issued_wtx_shrd_mst_oh_irs_apl_s15;
  wire [`AXI_NMV_S15:0] issued_wtx_shrd_mst_oh_s15_eb;
  wire [`AXI_NMV_S15-1:0] issued_wtx_shrd_mst_oh_s15;
  wire issued_wtx_shrd_sys_s15;
  wire [`AXI_AW_SHARED_LAYER_NM-1:0] issued_wtx_shrd_mst_oh_irs_apl_s16;
  wire [`AXI_NMV_S16:0] issued_wtx_shrd_mst_oh_s16_eb;
  wire [`AXI_NMV_S16-1:0] issued_wtx_shrd_mst_oh_s16;
  wire issued_wtx_shrd_sys_s16;
  wire issued_wtx_shrd_sys_s_dummy;

  wire [`AXI_MST_PRIORITY_W*`AXI_AW_SHARED_LAYER_NM:0] aw_shrd_bus_mst_priorities_eb;
  wire [`AXI_MST_PRIORITY_W*`AXI_AW_SHARED_LAYER_NM-1:0] aw_shrd_bus_mst_priorities;
  wire [`AXI_AW_SHARED_LAYER_NS-1:0] bus_awvalid_shrd;
  wire [`AXI_AW_SHARED_LAYER_NS:0] bus_awready_shrd_sp_i_eb;
  wire [`AXI_AW_SHARED_LAYER_NS-1:0] bus_awready_shrd_sp_i;
  wire [`AXI_AW_PYLD_S_W-1:0] awpayload_shrd;
  
  wire awvalid_shrd_s0; 
  wire awvalid_shrd_s1; 
  wire awvalid_shrd_s2; 
  wire awvalid_shrd_s3; 
  wire awvalid_shrd_s4; 
  wire awvalid_shrd_s5; 
  wire awvalid_shrd_s6; 
  wire awvalid_shrd_s7; 
  wire awvalid_shrd_s8; 
  wire awvalid_shrd_s9; 
  wire awvalid_shrd_s10; 
  wire awvalid_shrd_s11; 
  wire awvalid_shrd_s12; 
  wire awvalid_shrd_s13; 
  wire awvalid_shrd_s14; 
  wire awvalid_shrd_s15; 
  wire awvalid_shrd_s16; 
  wire awvalid_shrd_sdummy; // Redundant bit, not synthesised.
  
  wire awvalid_ddctd_s0; 
  wire awvalid_ddctd_s1; 
  wire awvalid_ddctd_s2; 
  wire awvalid_ddctd_s3; 
  wire awvalid_ddctd_s4; 
  wire awvalid_ddctd_s5; 
  wire awvalid_ddctd_s6; 
  wire awvalid_ddctd_s7; 
  wire awvalid_ddctd_s8; 
  wire awvalid_ddctd_s9; 
  wire awvalid_ddctd_s10; 
  wire awvalid_ddctd_s11; 
  wire awvalid_ddctd_s12; 
  wire awvalid_ddctd_s13; 
  wire awvalid_ddctd_s14; 
  wire awvalid_ddctd_s15; 
  wire awvalid_ddctd_s16; 

  // Arready signals from shared SP layer to primary ports.
  wire awready_shrd_sp_dummy; // Redundant bit, not synthesised.
  wire awready_shrd_sp_m1; 
  wire awready_shrd_sp_m2; 
  wire awready_shrd_sp_m3; 
  wire awready_shrd_sp_m4; 
  wire awready_shrd_sp_m5; 
  wire awready_shrd_sp_m6; 
  wire awready_shrd_sp_m7; 
  wire awready_shrd_sp_m8; 
  wire awready_shrd_sp_m9; 
  wire awready_shrd_sp_m10; 
  wire awready_shrd_sp_m11; 
  wire awready_shrd_sp_m12; 
  wire awready_shrd_sp_m13; 
  wire awready_shrd_sp_m14; 
  wire awready_shrd_sp_m15; 
  wire awready_shrd_sp_m16; 


  // W CHANNEL SHARED LAYER SIGNALS

  // Bus of of signals from each master containing a valid signal for each
  // slave connected to the shared W channel. 
  // Note : the *eb signals contain a dummy extra bit, which makes assignments easier later.
  // The dummy bit is eventually removed in the assignment to the corresponding signal of
  // the correct length.
  // Signals will always be declared but will only be used/synthesised when required.
  
  wire [`AXI_W_SHARED_LAYER_NS:0]   wvalid_s_shrd_m1_bus_eb;
  wire [`AXI_W_SHARED_LAYER_NS-1:0] wvalid_s_shrd_m1_bus;
  
  wire [`AXI_W_SHARED_LAYER_NS:0]   wvalid_s_shrd_m2_bus_eb;
  wire [`AXI_W_SHARED_LAYER_NS-1:0] wvalid_s_shrd_m2_bus;
  
  wire [`AXI_W_SHARED_LAYER_NS:0]   wvalid_s_shrd_m3_bus_eb;
  wire [`AXI_W_SHARED_LAYER_NS-1:0] wvalid_s_shrd_m3_bus;
  
  wire [`AXI_W_SHARED_LAYER_NS:0]   wvalid_s_shrd_m4_bus_eb;
  wire [`AXI_W_SHARED_LAYER_NS-1:0] wvalid_s_shrd_m4_bus;
  
  wire [`AXI_W_SHARED_LAYER_NS:0]   wvalid_s_shrd_m5_bus_eb;
  wire [`AXI_W_SHARED_LAYER_NS-1:0] wvalid_s_shrd_m5_bus;
  
  wire [`AXI_W_SHARED_LAYER_NS:0]   wvalid_s_shrd_m6_bus_eb;
  wire [`AXI_W_SHARED_LAYER_NS-1:0] wvalid_s_shrd_m6_bus;
  
  wire [`AXI_W_SHARED_LAYER_NS:0]   wvalid_s_shrd_m7_bus_eb;
  wire [`AXI_W_SHARED_LAYER_NS-1:0] wvalid_s_shrd_m7_bus;
  
  wire [`AXI_W_SHARED_LAYER_NS:0]   wvalid_s_shrd_m8_bus_eb;
  wire [`AXI_W_SHARED_LAYER_NS-1:0] wvalid_s_shrd_m8_bus;
  
  wire [`AXI_W_SHARED_LAYER_NS:0]   wvalid_s_shrd_m9_bus_eb;
  wire [`AXI_W_SHARED_LAYER_NS-1:0] wvalid_s_shrd_m9_bus;
  
  wire [`AXI_W_SHARED_LAYER_NS:0]   wvalid_s_shrd_m10_bus_eb;
  wire [`AXI_W_SHARED_LAYER_NS-1:0] wvalid_s_shrd_m10_bus;
  
  wire [`AXI_W_SHARED_LAYER_NS:0]   wvalid_s_shrd_m11_bus_eb;
  wire [`AXI_W_SHARED_LAYER_NS-1:0] wvalid_s_shrd_m11_bus;
  
  wire [`AXI_W_SHARED_LAYER_NS:0]   wvalid_s_shrd_m12_bus_eb;
  wire [`AXI_W_SHARED_LAYER_NS-1:0] wvalid_s_shrd_m12_bus;
  
  wire [`AXI_W_SHARED_LAYER_NS:0]   wvalid_s_shrd_m13_bus_eb;
  wire [`AXI_W_SHARED_LAYER_NS-1:0] wvalid_s_shrd_m13_bus;
  
  wire [`AXI_W_SHARED_LAYER_NS:0]   wvalid_s_shrd_m14_bus_eb;
  wire [`AXI_W_SHARED_LAYER_NS-1:0] wvalid_s_shrd_m14_bus;
  
  wire [`AXI_W_SHARED_LAYER_NS:0]   wvalid_s_shrd_m15_bus_eb;
  wire [`AXI_W_SHARED_LAYER_NS-1:0] wvalid_s_shrd_m15_bus;
  
  wire [`AXI_W_SHARED_LAYER_NS:0]   wvalid_s_shrd_m16_bus_eb;
  wire [`AXI_W_SHARED_LAYER_NS-1:0] wvalid_s_shrd_m16_bus;

  // *_eb signals contain redundant bits which make configurable assigns easier.
  // Redundant bits removed before connection with destination signals.
  wire [(`AXI_W_SHARED_LAYER_NS*`AXI_W_SHARED_LAYER_NM):0] bus_wvalid_sp_shrd_eb;
  wire [(`AXI_W_SHARED_LAYER_NS*`AXI_W_SHARED_LAYER_NM)-1:0] bus_wvalid_sp_shrd;
  wire [`AXI_W_SHARED_LAYER_NM:0] bus_w_shrd_ch_req_eb;
  wire [`AXI_W_SHARED_LAYER_NM-1:0] bus_w_shrd_ch_req;
  wire [(`AXI_W_PYLD_S_W*`AXI_W_SHARED_LAYER_NM):0] bus_wpayload_shrd_eb;
  wire [(`AXI_W_PYLD_S_W*`AXI_W_SHARED_LAYER_NM)-1:0] bus_wpayload_shrd;
  wire [`AXI_W_SHARED_LAYER_NM:0] bus_wlocktx_shrd_sp_eb;
  wire [`AXI_W_SHARED_LAYER_NM-1:0] bus_wlocktx_shrd_sp;
  wire [`AXI_W_SHARED_LAYER_NM-1:0] bus_wready_shrd_sp_o;

  wire [`AXI_MST_PRIORITY_W*`AXI_W_SHARED_LAYER_NM:0] w_shrd_bus_mst_priorities_eb;
  wire [`AXI_MST_PRIORITY_W*`AXI_W_SHARED_LAYER_NM-1:0] w_shrd_bus_mst_priorities;
  wire [`AXI_W_SHARED_LAYER_NS-1:0] bus_wvalid_shrd;
  wire [`AXI_W_SHARED_LAYER_NS:0] bus_wready_shrd_sp_i_eb;
  wire [`AXI_W_SHARED_LAYER_NS-1:0] bus_wready_shrd_sp_i;
  wire [`AXI_W_PYLD_S_W-1:0] wpayload_shrd;
  
  wire wvalid_shrd_s0; 
  wire wvalid_shrd_s1; 
  wire wvalid_shrd_s2; 
  wire wvalid_shrd_s3; 
  wire wvalid_shrd_s4; 
  wire wvalid_shrd_s5; 
  wire wvalid_shrd_s6; 
  wire wvalid_shrd_s7; 
  wire wvalid_shrd_s8; 
  wire wvalid_shrd_s9; 
  wire wvalid_shrd_s10; 
  wire wvalid_shrd_s11; 
  wire wvalid_shrd_s12; 
  wire wvalid_shrd_s13; 
  wire wvalid_shrd_s14; 
  wire wvalid_shrd_s15; 
  wire wvalid_shrd_s16; 
  wire wvalid_shrd_sdummy; // Redundant bit, not synthesised.
  
  wire wvalid_ddctd_s0; 
  wire wvalid_ddctd_s1; 
  wire wvalid_ddctd_s2; 
  wire wvalid_ddctd_s3; 
  wire wvalid_ddctd_s4; 
  wire wvalid_ddctd_s5; 
  wire wvalid_ddctd_s6; 
  wire wvalid_ddctd_s7; 
  wire wvalid_ddctd_s8; 
  wire wvalid_ddctd_s9; 
  wire wvalid_ddctd_s10; 
  wire wvalid_ddctd_s11; 
  wire wvalid_ddctd_s12; 
  wire wvalid_ddctd_s13; 
  wire wvalid_ddctd_s14; 
  wire wvalid_ddctd_s15; 
  wire wvalid_ddctd_s16; 

  // Arready signals from shared SP layer to primary ports.
  wire wready_shrd_sp_dummy; // Redundant bit, not synthesised.
  wire wready_shrd_sp_m1; 
  wire wready_shrd_sp_m2; 
  wire wready_shrd_sp_m3; 
  wire wready_shrd_sp_m4; 
  wire wready_shrd_sp_m5; 
  wire wready_shrd_sp_m6; 
  wire wready_shrd_sp_m7; 
  wire wready_shrd_sp_m8; 
  wire wready_shrd_sp_m9; 
  wire wready_shrd_sp_m10; 
  wire wready_shrd_sp_m11; 
  wire wready_shrd_sp_m12; 
  wire wready_shrd_sp_m13; 
  wire wready_shrd_sp_m14; 
  wire wready_shrd_sp_m15; 
  wire wready_shrd_sp_m16; 
// When the shared to dedicated link exists on the AW channel, it
// is necessary to map the one hot master granted bus from the
// dedicated AW, which will reflect only the masters connected
// to the dedicated (with shared masters represented by a
// single grant bit (msb), to a value that is representative
// of all masters visible to that slave.
// This decoding requires ifdefs and as such is done at the
// top level and sent back to the relevant secondary port.
// spyglass disable_block W497
// SMD: Not all bits of the bus are set
// SJ : Upper 4 bits of issued_wtx_mst_sys_oh_s* bus are not set as
//      they are never used in the design. This is as per the requirement.
//      Hence this can be waived.
  wire [`AXI_AW_S0_NMV-1:0] issued_wtx_mst_oh_o_s0; 
  wire [`AXI_NMV_S0-1:0] issued_wtx_mst_oh_i_s0; 
  wire [`AXI_NMV_S0:0] issued_wtx_mst_oh_i_eb_s0; 
 
  wire [`AXI_MAX_NUM_USR_MSTS-1:0] issued_wtx_mst_sys_oh_s0; 
  wire issued_wtx_mst_oh_dummy1_s0; 
  wire [`AXI_AW_S1_NMV-1:0] issued_wtx_mst_oh_o_s1; 
  wire [`AXI_NMV_S1-1:0] issued_wtx_mst_oh_i_s1; 
  wire [`AXI_NMV_S1:0] issued_wtx_mst_oh_i_eb_s1; 
 
  wire [`AXI_MAX_NUM_USR_MSTS-1:0] issued_wtx_mst_sys_oh_s1; 
  wire issued_wtx_mst_oh_dummy1_s1; 
// spyglass enable_block W497
 
// Bit from each dedicated W channel, asserted when the
// shared W channel is next to send a first write beat
// to that slave. Used to work around a deadlock issue
// with the shared to dedicated link on the W channel.
  wire shrd_w_nxt_fb_pend_s0; 
  wire shrd_w_nxt_fb_pend_s1; 
  wire shrd_w_nxt_fb_pend_s2; 
  wire shrd_w_nxt_fb_pend_s3; 
  wire shrd_w_nxt_fb_pend_s4; 
  wire shrd_w_nxt_fb_pend_s5; 
  wire shrd_w_nxt_fb_pend_s6; 
  wire shrd_w_nxt_fb_pend_s7; 
  wire shrd_w_nxt_fb_pend_s8; 
  wire shrd_w_nxt_fb_pend_s9; 
  wire shrd_w_nxt_fb_pend_s10; 
  wire shrd_w_nxt_fb_pend_s11; 
  wire shrd_w_nxt_fb_pend_s12; 
  wire shrd_w_nxt_fb_pend_s13; 
  wire shrd_w_nxt_fb_pend_s14; 
  wire shrd_w_nxt_fb_pend_s15; 
  wire shrd_w_nxt_fb_pend_s16; 
 
  wire                              shrd_w_nxt_fb_pend_bus_dummy;
  wire [`AXI_W_SHARED_LAYER_NS-1:0] shrd_w_nxt_fb_pend_bus;

  // R CHANNEL SHARED LAYER SIGNALS

  // Bus of of signals from each slave containing a valid signal for each
  // slave connected to the shared R channel. 
  // Note : the *eb signals contain a dummy extra bit, which makes assignments easier later.
  // The dummy bit is eventually removed in the assignment to the corresponding signal of
  // the correct length.
  // Signals will always be declared but will only be used/synthesised when required.
  
  wire [`AXI_R_SHARED_LAYER_NM:0] rvalid_m_shrd_s0_bus_eb;
  wire [`AXI_R_SHARED_LAYER_NM-1:0] rvalid_m_shrd_s0_bus;
    
  
  wire [`AXI_R_SHARED_LAYER_NM:0] rvalid_m_shrd_s1_bus_eb;
  wire [`AXI_R_SHARED_LAYER_NM-1:0] rvalid_m_shrd_s1_bus;
    
  
  wire [`AXI_R_SHARED_LAYER_NM:0] rvalid_m_shrd_s2_bus_eb;
  wire [`AXI_R_SHARED_LAYER_NM-1:0] rvalid_m_shrd_s2_bus;
    
  
  wire [`AXI_R_SHARED_LAYER_NM:0] rvalid_m_shrd_s3_bus_eb;
  wire [`AXI_R_SHARED_LAYER_NM-1:0] rvalid_m_shrd_s3_bus;
    
  
  wire [`AXI_R_SHARED_LAYER_NM:0] rvalid_m_shrd_s4_bus_eb;
  wire [`AXI_R_SHARED_LAYER_NM-1:0] rvalid_m_shrd_s4_bus;
    
  
  wire [`AXI_R_SHARED_LAYER_NM:0] rvalid_m_shrd_s5_bus_eb;
  wire [`AXI_R_SHARED_LAYER_NM-1:0] rvalid_m_shrd_s5_bus;
    
  
  wire [`AXI_R_SHARED_LAYER_NM:0] rvalid_m_shrd_s6_bus_eb;
  wire [`AXI_R_SHARED_LAYER_NM-1:0] rvalid_m_shrd_s6_bus;
    
  
  wire [`AXI_R_SHARED_LAYER_NM:0] rvalid_m_shrd_s7_bus_eb;
  wire [`AXI_R_SHARED_LAYER_NM-1:0] rvalid_m_shrd_s7_bus;
    
  
  wire [`AXI_R_SHARED_LAYER_NM:0] rvalid_m_shrd_s8_bus_eb;
  wire [`AXI_R_SHARED_LAYER_NM-1:0] rvalid_m_shrd_s8_bus;
    
  
  wire [`AXI_R_SHARED_LAYER_NM:0] rvalid_m_shrd_s9_bus_eb;
  wire [`AXI_R_SHARED_LAYER_NM-1:0] rvalid_m_shrd_s9_bus;
    
  
  wire [`AXI_R_SHARED_LAYER_NM:0] rvalid_m_shrd_s10_bus_eb;
  wire [`AXI_R_SHARED_LAYER_NM-1:0] rvalid_m_shrd_s10_bus;
    
  
  wire [`AXI_R_SHARED_LAYER_NM:0] rvalid_m_shrd_s11_bus_eb;
  wire [`AXI_R_SHARED_LAYER_NM-1:0] rvalid_m_shrd_s11_bus;
    
  
  wire [`AXI_R_SHARED_LAYER_NM:0] rvalid_m_shrd_s12_bus_eb;
  wire [`AXI_R_SHARED_LAYER_NM-1:0] rvalid_m_shrd_s12_bus;
    
  
  wire [`AXI_R_SHARED_LAYER_NM:0] rvalid_m_shrd_s13_bus_eb;
  wire [`AXI_R_SHARED_LAYER_NM-1:0] rvalid_m_shrd_s13_bus;
    
  
  wire [`AXI_R_SHARED_LAYER_NM:0] rvalid_m_shrd_s14_bus_eb;
  wire [`AXI_R_SHARED_LAYER_NM-1:0] rvalid_m_shrd_s14_bus;
    
  
  wire [`AXI_R_SHARED_LAYER_NM:0] rvalid_m_shrd_s15_bus_eb;
  wire [`AXI_R_SHARED_LAYER_NM-1:0] rvalid_m_shrd_s15_bus;
    
  
  wire [`AXI_R_SHARED_LAYER_NM:0] rvalid_m_shrd_s16_bus_eb;
  wire [`AXI_R_SHARED_LAYER_NM-1:0] rvalid_m_shrd_s16_bus;
    

  // *_eb signals contain redundant bits which make configurable assigns easier.
  // Redundant bits removed before connection with destination signals.
  wire [(`AXI_R_SHARED_LAYER_NS*`AXI_R_SHARED_LAYER_NM):0] bus_rvalid_mp_shrd_eb;
  wire [(`AXI_R_SHARED_LAYER_NS*`AXI_R_SHARED_LAYER_NM)-1:0] bus_rvalid_mp_shrd;
  wire [`AXI_R_SHARED_LAYER_NS:0] bus_r_shrd_ch_req_eb;
  wire [`AXI_R_SHARED_LAYER_NS-1:0] bus_r_shrd_ch_req;
  wire [(`AXI_R_PYLD_M_W*`AXI_R_SHARED_LAYER_NS):0] bus_rpayload_shrd_eb;
  wire [(`AXI_R_PYLD_M_W*`AXI_R_SHARED_LAYER_NS)-1:0] bus_rpayload_shrd;
  wire [`AXI_R_SHARED_LAYER_NS-1:0] bus_rready_shrd_mp_o;

  // 
  wire [`AXI_R_SHARED_LAYER_NM-1:0] rcpl_tx_shrd_bus;
  wire [`AXI_MIDW-1:0] rcpl_id_shrd;

  // Signals to take t/x completed information from the shared R channel
  // and connect to dedicated address channels.
  // Note the rewiring necessary to go from a one hot master bus of 
  // shared R visibility, to a one hot master bus of dedicated
  // per master visibility.
  
  wire rcpl_tx_shrd_sys_m1;
  wire rcpl_tx_shrd_sys_m2;
  wire rcpl_tx_shrd_sys_m3;
  wire rcpl_tx_shrd_sys_m4;
  wire rcpl_tx_shrd_sys_m5;
  wire rcpl_tx_shrd_sys_m6;
  wire rcpl_tx_shrd_sys_m7;
  wire rcpl_tx_shrd_sys_m8;
  wire rcpl_tx_shrd_sys_m9;
  wire rcpl_tx_shrd_sys_m10;
  wire rcpl_tx_shrd_sys_m11;
  wire rcpl_tx_shrd_sys_m12;
  wire rcpl_tx_shrd_sys_m13;
  wire rcpl_tx_shrd_sys_m14;
  wire rcpl_tx_shrd_sys_m15;
  wire rcpl_tx_shrd_sys_m16;
  wire rcpl_tx_shrd_sys_dummy;

  wire [`AXI_SLV_PRIORITY_W*`AXI_R_SHARED_LAYER_NS:0] r_shrd_bus_slv_priorities_eb;
  wire [`AXI_SLV_PRIORITY_W*`AXI_R_SHARED_LAYER_NS-1:0] r_shrd_bus_slv_priorities;
  wire [`AXI_R_SHARED_LAYER_NM-1:0] bus_rvalid_shrd;
  wire [`AXI_R_SHARED_LAYER_NM:0] bus_rready_shrd_mp_i_eb;
  wire [`AXI_R_SHARED_LAYER_NM-1:0] bus_rready_shrd_mp_i;
  wire [`AXI_R_PYLD_M_W-1:0] rpayload_shrd;
  // Same width as rpayload_shrd if there is no bi-directional
  // command support, this signal is not used in that case.
  wire [`AXI_R_PYLD_M_W-1:0] rpayload_icm_shrd;
  
  wire rvalid_shrd_m1; 
  wire rvalid_shrd_m2; 
  wire rvalid_shrd_m3; 
  wire rvalid_shrd_m4; 
  wire rvalid_shrd_m5; 
  wire rvalid_shrd_m6; 
  wire rvalid_shrd_m7; 
  wire rvalid_shrd_m8; 
  wire rvalid_shrd_m9; 
  wire rvalid_shrd_m10; 
  wire rvalid_shrd_m11; 
  wire rvalid_shrd_m12; 
  wire rvalid_shrd_m13; 
  wire rvalid_shrd_m14; 
  wire rvalid_shrd_m15; 
  wire rvalid_shrd_m16; 
  wire rvalid_shrd_mdummy; // Redundant bit, not synthesised.
  
  wire rvalid_ddctd_m1; 
  wire rvalid_ddctd_m2; 
  wire rvalid_ddctd_m3; 
  wire rvalid_ddctd_m4; 
  wire rvalid_ddctd_m5; 
  wire rvalid_ddctd_m6; 
  wire rvalid_ddctd_m7; 
  wire rvalid_ddctd_m8; 
  wire rvalid_ddctd_m9; 
  wire rvalid_ddctd_m10; 
  wire rvalid_ddctd_m11; 
  wire rvalid_ddctd_m12; 
  wire rvalid_ddctd_m13; 
  wire rvalid_ddctd_m14; 
  wire rvalid_ddctd_m15; 
  wire rvalid_ddctd_m16; 

  // Arready signals from shared MP layer to secondary ports.
  wire rready_shrd_mp_dummy; // Redundant bit, not synthesised.
  wire rready_shrd_mp_s0;  
  wire rready_shrd_mp_s1;  
  wire rready_shrd_mp_s2;  
  wire rready_shrd_mp_s3;  
  wire rready_shrd_mp_s4;  
  wire rready_shrd_mp_s5;  
  wire rready_shrd_mp_s6;  
  wire rready_shrd_mp_s7;  
  wire rready_shrd_mp_s8;  
  wire rready_shrd_mp_s9;  
  wire rready_shrd_mp_s10;  
  wire rready_shrd_mp_s11;  
  wire rready_shrd_mp_s12;  
  wire rready_shrd_mp_s13;  
  wire rready_shrd_mp_s14;  
  wire rready_shrd_mp_s15;  
  wire rready_shrd_mp_s16;  

  // B CHANNEL SHARED LAYER SIGNALS

  // Bus of of signals from each slave containing a valid signal for each
  // slave connected to the shared B channel. 
  // Note : the *eb signals contain a dummy extra bit, which makes assignments easier later.
  // The dummy bit is eventually removed in the assignment to the corresponding signal of
  // the correct length.
  // Signals will always be declared but will only be used/synthesised when required.
  
  wire [`AXI_B_SHARED_LAYER_NM:0] bvalid_m_shrd_s0_bus_eb;
  wire [`AXI_B_SHARED_LAYER_NM-1:0] bvalid_m_shrd_s0_bus;
    
  
  wire [`AXI_B_SHARED_LAYER_NM:0] bvalid_m_shrd_s1_bus_eb;
  wire [`AXI_B_SHARED_LAYER_NM-1:0] bvalid_m_shrd_s1_bus;
    
  
  wire [`AXI_B_SHARED_LAYER_NM:0] bvalid_m_shrd_s2_bus_eb;
  wire [`AXI_B_SHARED_LAYER_NM-1:0] bvalid_m_shrd_s2_bus;
    
  
  wire [`AXI_B_SHARED_LAYER_NM:0] bvalid_m_shrd_s3_bus_eb;
  wire [`AXI_B_SHARED_LAYER_NM-1:0] bvalid_m_shrd_s3_bus;
    
  
  wire [`AXI_B_SHARED_LAYER_NM:0] bvalid_m_shrd_s4_bus_eb;
  wire [`AXI_B_SHARED_LAYER_NM-1:0] bvalid_m_shrd_s4_bus;
    
  
  wire [`AXI_B_SHARED_LAYER_NM:0] bvalid_m_shrd_s5_bus_eb;
  wire [`AXI_B_SHARED_LAYER_NM-1:0] bvalid_m_shrd_s5_bus;
    
  
  wire [`AXI_B_SHARED_LAYER_NM:0] bvalid_m_shrd_s6_bus_eb;
  wire [`AXI_B_SHARED_LAYER_NM-1:0] bvalid_m_shrd_s6_bus;
    
  
  wire [`AXI_B_SHARED_LAYER_NM:0] bvalid_m_shrd_s7_bus_eb;
  wire [`AXI_B_SHARED_LAYER_NM-1:0] bvalid_m_shrd_s7_bus;
    
  
  wire [`AXI_B_SHARED_LAYER_NM:0] bvalid_m_shrd_s8_bus_eb;
  wire [`AXI_B_SHARED_LAYER_NM-1:0] bvalid_m_shrd_s8_bus;
    
  
  wire [`AXI_B_SHARED_LAYER_NM:0] bvalid_m_shrd_s9_bus_eb;
  wire [`AXI_B_SHARED_LAYER_NM-1:0] bvalid_m_shrd_s9_bus;
    
  
  wire [`AXI_B_SHARED_LAYER_NM:0] bvalid_m_shrd_s10_bus_eb;
  wire [`AXI_B_SHARED_LAYER_NM-1:0] bvalid_m_shrd_s10_bus;
    
  
  wire [`AXI_B_SHARED_LAYER_NM:0] bvalid_m_shrd_s11_bus_eb;
  wire [`AXI_B_SHARED_LAYER_NM-1:0] bvalid_m_shrd_s11_bus;
    
  
  wire [`AXI_B_SHARED_LAYER_NM:0] bvalid_m_shrd_s12_bus_eb;
  wire [`AXI_B_SHARED_LAYER_NM-1:0] bvalid_m_shrd_s12_bus;
    
  
  wire [`AXI_B_SHARED_LAYER_NM:0] bvalid_m_shrd_s13_bus_eb;
  wire [`AXI_B_SHARED_LAYER_NM-1:0] bvalid_m_shrd_s13_bus;
    
  
  wire [`AXI_B_SHARED_LAYER_NM:0] bvalid_m_shrd_s14_bus_eb;
  wire [`AXI_B_SHARED_LAYER_NM-1:0] bvalid_m_shrd_s14_bus;
    
  
  wire [`AXI_B_SHARED_LAYER_NM:0] bvalid_m_shrd_s15_bus_eb;
  wire [`AXI_B_SHARED_LAYER_NM-1:0] bvalid_m_shrd_s15_bus;
    
  
  wire [`AXI_B_SHARED_LAYER_NM:0] bvalid_m_shrd_s16_bus_eb;
  wire [`AXI_B_SHARED_LAYER_NM-1:0] bvalid_m_shrd_s16_bus;
    

  // *_eb signals contain redundant bits which make configurable assigns easier.
  // Redundant bits removed before connection with destination signals.
  wire [(`AXI_B_SHARED_LAYER_NS*`AXI_B_SHARED_LAYER_NM):0] bus_bvalid_mp_shrd_eb;
  wire [(`AXI_B_SHARED_LAYER_NS*`AXI_B_SHARED_LAYER_NM)-1:0] bus_bvalid_mp_shrd;
  wire [`AXI_B_SHARED_LAYER_NS:0] bus_b_shrd_ch_req_eb;
  wire [`AXI_B_SHARED_LAYER_NS-1:0] bus_b_shrd_ch_req;
  wire [(`AXI_B_PYLD_M_W*`AXI_B_SHARED_LAYER_NS):0] bus_bpayload_shrd_eb;
  wire [(`AXI_B_PYLD_M_W*`AXI_B_SHARED_LAYER_NS)-1:0] bus_bpayload_shrd;
  wire [`AXI_B_SHARED_LAYER_NS-1:0] bus_bready_shrd_mp_o;

  // 
  wire [`AXI_B_SHARED_LAYER_NM-1:0] wcpl_tx_shrd_bus;
  wire [`AXI_MIDW-1:0] wcpl_id_shrd;

  // Signals to take t/x completed information from the shared B channel
  // and connect to dedicated address channels.
  // Note the rewiring necessary to go from a one hot master bus of 
  // shared B visibility, to a one hot master bus of dedicated
  // per master visibility.
  
  wire wcpl_tx_shrd_sys_m1;
  wire wcpl_tx_shrd_sys_m2;
  wire wcpl_tx_shrd_sys_m3;
  wire wcpl_tx_shrd_sys_m4;
  wire wcpl_tx_shrd_sys_m5;
  wire wcpl_tx_shrd_sys_m6;
  wire wcpl_tx_shrd_sys_m7;
  wire wcpl_tx_shrd_sys_m8;
  wire wcpl_tx_shrd_sys_m9;
  wire wcpl_tx_shrd_sys_m10;
  wire wcpl_tx_shrd_sys_m11;
  wire wcpl_tx_shrd_sys_m12;
  wire wcpl_tx_shrd_sys_m13;
  wire wcpl_tx_shrd_sys_m14;
  wire wcpl_tx_shrd_sys_m15;
  wire wcpl_tx_shrd_sys_m16;
  wire wcpl_tx_shrd_sys_dummy;

  wire [`AXI_SLV_PRIORITY_W*`AXI_B_SHARED_LAYER_NS:0] b_shrd_bus_slv_priorities_eb;
  wire [`AXI_SLV_PRIORITY_W*`AXI_B_SHARED_LAYER_NS-1:0] b_shrd_bus_slv_priorities;
  wire [`AXI_B_SHARED_LAYER_NM-1:0] bus_bvalid_shrd;
  wire [`AXI_B_SHARED_LAYER_NM:0] bus_bready_shrd_mp_i_eb;
  wire [`AXI_B_SHARED_LAYER_NM-1:0] bus_bready_shrd_mp_i;
  wire [`AXI_B_PYLD_M_W-1:0] bpayload_shrd;
  // Same width as bpayload_shrd if there is no bi-directional
  // command support, this signal is not used in that case.
  wire [`AXI_B_PYLD_M_W-1:0] bpayload_icm_shrd;
  
  wire bvalid_shrd_m1; 
  wire bvalid_shrd_m2; 
  wire bvalid_shrd_m3; 
  wire bvalid_shrd_m4; 
  wire bvalid_shrd_m5; 
  wire bvalid_shrd_m6; 
  wire bvalid_shrd_m7; 
  wire bvalid_shrd_m8; 
  wire bvalid_shrd_m9; 
  wire bvalid_shrd_m10; 
  wire bvalid_shrd_m11; 
  wire bvalid_shrd_m12; 
  wire bvalid_shrd_m13; 
  wire bvalid_shrd_m14; 
  wire bvalid_shrd_m15; 
  wire bvalid_shrd_m16; 
  wire bvalid_shrd_mdummy; // Redundant bit, not synthesised.
  
  wire bvalid_ddctd_m1; 
  wire bvalid_ddctd_m2; 
  wire bvalid_ddctd_m3; 
  wire bvalid_ddctd_m4; 
  wire bvalid_ddctd_m5; 
  wire bvalid_ddctd_m6; 
  wire bvalid_ddctd_m7; 
  wire bvalid_ddctd_m8; 
  wire bvalid_ddctd_m9; 
  wire bvalid_ddctd_m10; 
  wire bvalid_ddctd_m11; 
  wire bvalid_ddctd_m12; 
  wire bvalid_ddctd_m13; 
  wire bvalid_ddctd_m14; 
  wire bvalid_ddctd_m15; 
  wire bvalid_ddctd_m16; 

  // Arready signals from shared MP layer to secondary ports.
  wire bready_shrd_mp_dummy; // Redundant bit, not synthesised.
  wire bready_shrd_mp_s0;  
  wire bready_shrd_mp_s1;  
  wire bready_shrd_mp_s2;  
  wire bready_shrd_mp_s3;  
  wire bready_shrd_mp_s4;  
  wire bready_shrd_mp_s5;  
  wire bready_shrd_mp_s6;  
  wire bready_shrd_mp_s7;  
  wire bready_shrd_mp_s8;  
  wire bready_shrd_mp_s9;  
  wire bready_shrd_mp_s10;  
  wire bready_shrd_mp_s11;  
  wire bready_shrd_mp_s12;  
  wire bready_shrd_mp_s13;  
  wire bready_shrd_mp_s14;  
  wire bready_shrd_mp_s15;  
  wire bready_shrd_mp_s16;  
// Wires for the U_DW_axi_irs_arbpl_aw_shrd_ddctd_sx modules.

// --------------------------------------------------  
// Connect secondary port wires to per primary port wires.  
wire blank_aw_shrd_lyr_granted_m1_s_bus;
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_aw_shrd_lyr_granted_m1_s_bus, aw_shrd_lyr_granted_m1_s_bus} = {1'b0
  , aw_shrd_lyr_granted_s1
  , aw_shrd_lyr_granted_s0
};
// spyglass enable_block W528 W123

// --------------------------------------------------  
// Connect secondary port wires to per primary port wires.  
wire blank_aw_shrd_lyr_granted_m2_s_bus;
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_aw_shrd_lyr_granted_m2_s_bus, aw_shrd_lyr_granted_m2_s_bus} = {1'b0
  , aw_shrd_lyr_granted_s1
  , aw_shrd_lyr_granted_s0
};
// spyglass enable_block W528 W123

// --------------------------------------------------  
// Create a bus for each master, which contains the 
// issued_wtx_shrd_sys_mx_sy bits for that master from 
// all slaves.
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
wire blank_issued_wtx_shrd_sys_m1_s_bus;
  assign {blank_issued_wtx_shrd_sys_m1_s_bus, issued_wtx_shrd_sys_m1_s_bus} = {1'b0
  , (`AXI_S1_ON_AW_SHARED_VAL ? issued_wtx_shrd_sys_m1_s1 : 1'b0)
  , (`AXI_S0_ON_AW_SHARED_VAL ? issued_wtx_shrd_sys_m1_s0 : 1'b0)
};
// spyglass enable_block W528 W123

// --------------------------------------------------  
// Create a bus for each master, which contains the 
// issued_wtx_shrd_sys_mx_sy bits for that master from 
// all slaves.
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
wire blank_issued_wtx_shrd_sys_m2_s_bus;
  assign {blank_issued_wtx_shrd_sys_m2_s_bus, issued_wtx_shrd_sys_m2_s_bus} = {1'b0
  , (`AXI_S1_ON_AW_SHARED_VAL ? issued_wtx_shrd_sys_m2_s1 : 1'b0)
  , (`AXI_S0_ON_AW_SHARED_VAL ? issued_wtx_shrd_sys_m2_s0 : 1'b0)
};
// spyglass enable_block W528 W123





// --------------------------------------------------  
// Connect secondary port wires to per primary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_rvalid_m1, bus_rvalid_m1} = {1'b0
      ,rvalid_s1_m1
      ,rvalid_s0_m1
};
// spyglass enable_block W528 W123

// --------------------------------------------------  
// Connect secondary port wires to per primary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_rvalid_m2, bus_rvalid_m2} = {1'b0
      ,rvalid_s1_m2
      ,rvalid_s0_m2
};
// spyglass enable_block W528 W123
// --------------------------------------------------  
// Connect secondary port output signals, to individual    
// per primary port signals.                            
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.

  assign {blank_rvalid_s0 
  , rvalid_s0_m2
  , rvalid_s0_m1
 } = {1'b0, sp_rvalid_s0}; 

  assign {blank_rvalid_s1 
  , rvalid_s1_m2
  , rvalid_s1_m1
 } = {1'b0, sp_rvalid_s1}; 
// spyglass enable_block W528
// spyglass enable_block W164a

// --------------------------------------------------  
// Connect secondary port wires to per primary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_bvalid_m1, bus_bvalid_m1} = {1'b0
      ,bvalid_s1_m1
      ,bvalid_s0_m1
};
// spyglass enable_block W528 W123

// --------------------------------------------------  
// Connect secondary port wires to per primary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_bvalid_m2, bus_bvalid_m2} = {1'b0
      ,bvalid_s1_m2
      ,bvalid_s0_m2
};
// spyglass enable_block W528 W123
// --------------------------------------------------  
// Connect secondary port output signals, to individual    
// per primary port signals.                            
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.

  assign {blank_bvalid_s0 
  , bvalid_s0_m2
  , bvalid_s0_m1
 } = {1'b0, sp_bvalid_s0}; 

  assign {blank_bvalid_s1 
  , bvalid_s1_m2
  , bvalid_s1_m1
 } = {1'b0, sp_bvalid_s1}; 
// spyglass enable_block W528
// spyglass enable_block W164a

// --------------------------------------------------  
// Connect secondary port wires to per primary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_arready_m1, bus_arready_m1} = {1'b0
      ,(`AXI_AR_LAYER_S1_M1 ? arready_shrd_sp_m1 : arready_s1_m1)
      ,(`AXI_AR_LAYER_S0_M1 ? arready_shrd_sp_m1 : arready_s0_m1)
};
// spyglass enable_block W528 W123

// --------------------------------------------------  
// Connect secondary port wires to per primary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_arready_m2, bus_arready_m2} = {1'b0
      ,(`AXI_AR_LAYER_S1_M2 ? arready_shrd_sp_m2 : arready_s1_m2)
      ,(`AXI_AR_LAYER_S0_M2 ? arready_shrd_sp_m2 : arready_s0_m2)
};
// spyglass enable_block W528 W123
// --------------------------------------------------  
// Connect secondary port output signals, to individual    
// per primary port signals.                            
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.

  assign {blank_arready_s0 
    , arready_s0_m2
    , arready_s0_m1
 } = {1'b0, bus_sp_arready_s0}; 

  assign {blank_arready_s1 
    , arready_s1_m2
    , arready_s1_m1
 } = {1'b0, bus_sp_arready_s1}; 
// spyglass enable_block W528
// spyglass enable_block W164a

// --------------------------------------------------  
// Connect secondary port wires to per primary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_awready_m1, bus_awready_m1} = {1'b0
      ,(`AXI_AW_LAYER_S1_M1 ? awready_shrd_sp_m1 : awready_s1_m1)
      ,(`AXI_AW_LAYER_S0_M1 ? awready_shrd_sp_m1 : awready_s0_m1)
};
// spyglass enable_block W528 W123

// --------------------------------------------------  
// Connect secondary port wires to per primary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_awready_m2, bus_awready_m2} = {1'b0
      ,(`AXI_AW_LAYER_S1_M2 ? awready_shrd_sp_m2 : awready_s1_m2)
      ,(`AXI_AW_LAYER_S0_M2 ? awready_shrd_sp_m2 : awready_s0_m2)
};
// spyglass enable_block W528 W123
// --------------------------------------------------  
// Connect secondary port output signals, to individual    
// per primary port signals.                            
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.

  assign {blank_awready_s0 
    , awready_s0_m2
    , awready_s0_m1
 } = {1'b0, bus_sp_awready_s0}; 

  assign {blank_awready_s1 
    , awready_s1_m2
    , awready_s1_m1
 } = {1'b0, bus_sp_awready_s1}; 
// spyglass enable_block W528
// spyglass enable_block W164a

// --------------------------------------------------  
// Connect secondary port wires to per primary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_wready_m1, bus_wready_m1} = {1'b0
      ,(`AXI_W_LAYER_S1_M1 ? wready_shrd_sp_m1 : wready_s1_m1)
      ,(`AXI_W_LAYER_S0_M1 ? wready_shrd_sp_m1 : wready_s0_m1)
};
// spyglass enable_block W528 W123

// --------------------------------------------------  
// Connect secondary port wires to per primary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_wready_m2, bus_wready_m2} = {1'b0
      ,(`AXI_W_LAYER_S1_M2 ? wready_shrd_sp_m2 : wready_s1_m2)
      ,(`AXI_W_LAYER_S0_M2 ? wready_shrd_sp_m2 : wready_s0_m2)
};
// spyglass enable_block W528 W123
// --------------------------------------------------  
// Connect secondary port output signals, to individual    
// per primary port signals.                            
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.

  assign {blank_wready_s0 
    , wready_s0_m2
    , wready_s0_m1
 } = {1'b0, bus_sp_wready_s0}; 

  assign {blank_wready_s1 
    , wready_s1_m2
    , wready_s1_m1
 } = {1'b0, bus_sp_wready_s1}; 
// spyglass enable_block W528
// spyglass enable_block W164a
 
// --------------------------------------------------  
// Connect secondary port wires to per primary port wires.  
// Shared layer always connects as most significant numbered slave.  
// If BIDI is enabled, pass icm with payload to all dedicated master  
// ports, they will strip off extra bits as required.
  wire dummy_bus_rpayload_m1;
 // Done to remove lint error STAR 9000441836
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {dummy_bus_rpayload_m1, bus_rpayload_m1} = { 1'b0
    , rpayload_s1_m1
    , rpayload_s0_m1
 };
// spyglass enable_block W528
 
// --------------------------------------------------  
// Connect secondary port wires to per primary port wires.  
// Shared layer always connects as most significant numbered slave.  
// If BIDI is enabled, pass icm with payload to all dedicated master  
// ports, they will strip off extra bits as required.
  wire dummy_bus_rpayload_m2;
 // Done to remove lint error STAR 9000441836
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {dummy_bus_rpayload_m2, bus_rpayload_m2} = { 1'b0
    , rpayload_s1_m2
    , rpayload_s0_m2
 };
// spyglass enable_block W528
 
 
 
 
 
 
 
 
 
 
 
 
 
 
// --------------------------------------------------  
// Connect secondary port output signals, to individual    
// per primary port signals.                            
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_rpayload_s0 
    , rpayload_s0_m2
    , rpayload_s0_m1
 } = {1'b0, {`AXI_NUM_MASTERS{sp_rpayload_s0}}}; 
  assign {blank_rpayload_s1 
    , rpayload_s1_m2
    , rpayload_s1_m1
 } = {1'b0, {`AXI_NUM_MASTERS{sp_rpayload_s1}}}; 
// spyglass enable_block W528
// spyglass enable_block W164a
 
// --------------------------------------------------  
// Connect secondary port wires to per primary port wires.  
// Shared layer always connects as most significant numbered slave.  
// If BIDI is enabled, pass icm with payload to all dedicated master  
// ports, they will strip off extra bits as required.
  wire dummy_bus_bpayload_m1;
 // Done to remove lint error STAR 9000441836
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {dummy_bus_bpayload_m1, bus_bpayload_m1} = { 1'b0
    , bpayload_s1_m1
    , bpayload_s0_m1
 };
// spyglass enable_block W528
 
// --------------------------------------------------  
// Connect secondary port wires to per primary port wires.  
// Shared layer always connects as most significant numbered slave.  
// If BIDI is enabled, pass icm with payload to all dedicated master  
// ports, they will strip off extra bits as required.
  wire dummy_bus_bpayload_m2;
 // Done to remove lint error STAR 9000441836
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {dummy_bus_bpayload_m2, bus_bpayload_m2} = { 1'b0
    , bpayload_s1_m2
    , bpayload_s0_m2
 };
// spyglass enable_block W528
 
 
 
 
 
 
 
 
 
 
 
 
 
 
// --------------------------------------------------  
// Connect secondary port output signals, to individual    
// per primary port signals.                            
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_bpayload_s0 
    , bpayload_s0_m2
    , bpayload_s0_m1
 } = {1'b0, {`AXI_NUM_MASTERS{sp_bpayload_s0}}}; 
  assign {blank_bpayload_s1 
    , bpayload_s1_m2
    , bpayload_s1_m1
 } = {1'b0, {`AXI_NUM_MASTERS{sp_bpayload_s1}}}; 
// spyglass enable_block W528
// spyglass enable_block W164a


// --------------------------------------------------  
// Connect primary port wires to per secondary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_arvalid_s0, bus_arvalid_s0} = {
     1'b0
      , arvalid_s0_m2
      , arvalid_s0_m1
};
// spyglass enable_block W528 W123


// --------------------------------------------------  
// Connect primary port wires to per secondary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_arvalid_s1, bus_arvalid_s1} = {
     1'b0
      , arvalid_s1_m2
      , arvalid_s1_m1
};
// spyglass enable_block W528 W123

















// --------------------------------------------------  
// Connect primary port output signals, to individual   
// per secondary port signals.
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
  assign { blank_arvalid_m1
  , arvalid_s1_m1
  , arvalid_s0_m1
  } = {1'b0, {{mp_arvalid_m1}}};
// spyglass enable_block W164a
// spyglass enable_block W528 W123


// --------------------------------------------------  
// Connect primary port output signals, to individual   
// per secondary port signals.
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
  assign { blank_arvalid_m2
  , arvalid_s1_m2
  , arvalid_s0_m2
  } = {1'b0, {{mp_arvalid_m2}}};
// spyglass enable_block W164a
// spyglass enable_block W528 W123
















// --------------------------------------------------  
// Connect primary port wires to per secondary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_arpayload_s0, bus_arpayload_s0} = {
     1'b0
      , arpayload_s0_m2
      , arpayload_s0_m1
};
// spyglass enable_block W528 W123


// --------------------------------------------------  
// Connect primary port wires to per secondary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_arpayload_s1, bus_arpayload_s1} = {
     1'b0
      , arpayload_s1_m2
      , arpayload_s1_m1
};
// spyglass enable_block W528 W123

















// --------------------------------------------------  
// Connect primary port output signals, to individual   
// per secondary port signals.
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
  assign { blank_arpayload_m1
  , arpayload_s1_m1
  , arpayload_s0_m1
  } = {1'b0, {`AXI_NSP1V_M1{mp_arpayload_m1}}};
// spyglass enable_block W164a
// spyglass enable_block W528 W123


// --------------------------------------------------  
// Connect primary port output signals, to individual   
// per secondary port signals.
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
  assign { blank_arpayload_m2
  , arpayload_s1_m2
  , arpayload_s0_m2
  } = {1'b0, {`AXI_NSP1V_M2{mp_arpayload_m2}}};
// spyglass enable_block W164a
// spyglass enable_block W528 W123

















































// --------------------------------------------------  
// Connect primary port wires to per secondary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_rready_s0, bus_rready_s0} = {
     1'b0
      , (`AXI_R_LAYER_M2_S0 ? rready_shrd_mp_s0 : rready_s0_m2)
      , (`AXI_R_LAYER_M1_S0 ? rready_shrd_mp_s0 : rready_s0_m1)
};
// spyglass enable_block W528 W123


// --------------------------------------------------  
// Connect primary port wires to per secondary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_rready_s1, bus_rready_s1} = {
     1'b0
      , (`AXI_R_LAYER_M2_S1 ? rready_shrd_mp_s1 : rready_s1_m2)
      , (`AXI_R_LAYER_M1_S1 ? rready_shrd_mp_s1 : rready_s1_m1)
};
// spyglass enable_block W528 W123

















// --------------------------------------------------  
// Connect primary port output signals, to individual   
// per secondary port signals.
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
  assign { blank_rready_m1
    , rready_s1_m1
    , rready_s0_m1
  } = {1'b0, {bus_mp_rready_m1}};
// spyglass enable_block W164a
// spyglass enable_block W528 W123


// --------------------------------------------------  
// Connect primary port output signals, to individual   
// per secondary port signals.
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
  assign { blank_rready_m2
    , rready_s1_m2
    , rready_s0_m2
  } = {1'b0, {bus_mp_rready_m2}};
// spyglass enable_block W164a
// spyglass enable_block W528 W123
















// --------------------------------------------------  
// Connect primary port wires to per secondary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_awvalid_s0, bus_awvalid_s0} = {
     1'b0
      , awvalid_s0_m2
      , awvalid_s0_m1
};
// spyglass enable_block W528 W123


// --------------------------------------------------  
// Connect primary port wires to per secondary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_awvalid_s1, bus_awvalid_s1} = {
     1'b0
      , awvalid_s1_m2
      , awvalid_s1_m1
};
// spyglass enable_block W528 W123

















// --------------------------------------------------  
// Connect primary port output signals, to individual   
// per secondary port signals.
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
  assign { blank_awvalid_m1
  , awvalid_s1_m1
  , awvalid_s0_m1
  } = {1'b0, {{mp_awvalid_m1}}};
// spyglass enable_block W164a
// spyglass enable_block W528 W123


// --------------------------------------------------  
// Connect primary port output signals, to individual   
// per secondary port signals.
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
  assign { blank_awvalid_m2
  , awvalid_s1_m2
  , awvalid_s0_m2
  } = {1'b0, {{mp_awvalid_m2}}};
// spyglass enable_block W164a
// spyglass enable_block W528 W123
















// --------------------------------------------------  
// Connect primary port wires to per secondary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_awpayload_s0, bus_awpayload_s0} = {
     1'b0
      , awpayload_s0_m2
      , awpayload_s0_m1
};
// spyglass enable_block W528 W123


// --------------------------------------------------  
// Connect primary port wires to per secondary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_awpayload_s1, bus_awpayload_s1} = {
     1'b0
      , awpayload_s1_m2
      , awpayload_s1_m1
};
// spyglass enable_block W528 W123

















// --------------------------------------------------  
// Connect primary port output signals, to individual   
// per secondary port signals.
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
  assign { blank_awpayload_m1
  , awpayload_s1_m1
  , awpayload_s0_m1
  } = {1'b0, {`AXI_NSP1V_M1{mp_awpayload_m1}}};
// spyglass enable_block W164a
// spyglass enable_block W528 W123


// --------------------------------------------------  
// Connect primary port output signals, to individual   
// per secondary port signals.
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
  assign { blank_awpayload_m2
  , awpayload_s1_m2
  , awpayload_s0_m2
  } = {1'b0, {`AXI_NSP1V_M2{mp_awpayload_m2}}};
// spyglass enable_block W164a
// spyglass enable_block W528 W123

















































// --------------------------------------------------  
// Connect primary port wires to per secondary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_wvalid_s0, bus_wvalid_s0} = {
     1'b0
      , wvalid_s0_m2
      , wvalid_s0_m1
};
// spyglass enable_block W528 W123


// --------------------------------------------------  
// Connect primary port wires to per secondary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_wvalid_s1, bus_wvalid_s1} = {
     1'b0
      , wvalid_s1_m2
      , wvalid_s1_m1
};
// spyglass enable_block W528 W123

















// --------------------------------------------------  
// Connect primary port output signals, to individual   
// per secondary port signals.
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
  assign { blank_wvalid_m1
  , wvalid_s1_m1
  , wvalid_s0_m1
  } = {1'b0, {{mp_wvalid_m1}}};
// spyglass enable_block W164a
// spyglass enable_block W528 W123


// --------------------------------------------------  
// Connect primary port output signals, to individual   
// per secondary port signals.
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
  assign { blank_wvalid_m2
  , wvalid_s1_m2
  , wvalid_s0_m2
  } = {1'b0, {{mp_wvalid_m2}}};
// spyglass enable_block W164a
// spyglass enable_block W528 W123
















// --------------------------------------------------  
// Connect primary port wires to per secondary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_wpayload_s0, bus_wpayload_s0} = {
     1'b0
      , wpayload_s0_m2
      , wpayload_s0_m1
};
// spyglass enable_block W528 W123


// --------------------------------------------------  
// Connect primary port wires to per secondary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_wpayload_s1, bus_wpayload_s1} = {
     1'b0
      , wpayload_s1_m2
      , wpayload_s1_m1
};
// spyglass enable_block W528 W123

















// --------------------------------------------------  
// Connect primary port output signals, to individual   
// per secondary port signals.
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
  assign { blank_wpayload_m1
  , wpayload_s1_m1
  , wpayload_s0_m1
  } = {1'b0, {`AXI_NSP1V_M1{mp_wpayload_m1}}};
// spyglass enable_block W164a
// spyglass enable_block W528 W123


// --------------------------------------------------  
// Connect primary port output signals, to individual   
// per secondary port signals.
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
  assign { blank_wpayload_m2
  , wpayload_s1_m2
  , wpayload_s0_m2
  } = {1'b0, {`AXI_NSP1V_M2{mp_wpayload_m2}}};
// spyglass enable_block W164a
// spyglass enable_block W528 W123
















// --------------------------------------------------  
// Connect primary port wires to per secondary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_bready_s0, bus_bready_s0} = {
     1'b0
      , (`AXI_B_LAYER_M2_S0 ? bready_shrd_mp_s0 : bready_s0_m2)
      , (`AXI_B_LAYER_M1_S0 ? bready_shrd_mp_s0 : bready_s0_m1)
};
// spyglass enable_block W528 W123


// --------------------------------------------------  
// Connect primary port wires to per secondary port wires.  
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {blank_bready_s1, bus_bready_s1} = {
     1'b0
      , (`AXI_B_LAYER_M2_S1 ? bready_shrd_mp_s1 : bready_s1_m2)
      , (`AXI_B_LAYER_M1_S1 ? bready_shrd_mp_s1 : bready_s1_m1)
};
// spyglass enable_block W528 W123

















// --------------------------------------------------  
// Connect primary port output signals, to individual   
// per secondary port signals.
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
  assign { blank_bready_m1
    , bready_s1_m1
    , bready_s0_m1
  } = {1'b0, {bus_mp_bready_m1}};
// spyglass enable_block W164a
// spyglass enable_block W528 W123


// --------------------------------------------------  
// Connect primary port output signals, to individual   
// per secondary port signals.
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.
  assign { blank_bready_m2
    , bready_s1_m2
    , bready_s0_m2
  } = {1'b0, {bus_mp_bready_m2}};
// spyglass enable_block W164a
// spyglass enable_block W528 W123















wire [`AXI_NUM_MASTERS:0] bus_arpendtrans;
assign bus_arpendtrans = {1'b0
      ,has_ar_pending_trans_m2
      ,has_ar_pending_trans_m1
};
wire [`AXI_NUM_MASTERS:0] bus_awpendtrans;
assign bus_awpendtrans = {1'b0
     ,has_aw_pending_trans_m2
     ,has_aw_pending_trans_m1
};
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
wire [`AXI_NUM_MASTERS:0] bus_awvalid_m;
assign bus_awvalid_m = {1'b0
     ,awvalid_m2
     ,awvalid_m1
};
wire [`AXI_NUM_MASTERS:0] bus_arvalid_m;
assign bus_arvalid_m = {1'b0
     ,arvalid_m2
     ,arvalid_m1
};
wire [`AXI_NUM_MASTERS:0] bus_wvalid_m;
assign bus_wvalid_m = {1'b0
     ,wvalid_m2
     ,wvalid_m1
};
// spyglass enable_block W528
 
       // Default Slave 
     
// spyglass disable_block W528 W123
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
// spyglass disable_block W287a UndrivenInTerm-ML
// SMD: Some inputs to instance are not driven or unconnected
// SJ: This warning can be ignored. 
 DW_axi_dfltslv
  #(`AXI_SIDW) U_DW_axi_dfltslv (
    // Inputs - System
    .aclk_i               (aclk),                  
    .aresetn_i            (aresetn),               
    
    // Inputs - Read address channel signals
    .arvalid_i            (arvalid_s0),               
    .arid_i               (arid_s0),
    .arlen_i              (arlen_s0),
    .araddr_i             (araddr_s0),
    .arsize_i             (arsize_s0),
    .arlock_i             (arlock_s0),
    .arburst_i            (arburst_s0),
    .arcache_i            (arcache_s0),
    .arprot_i             (arprot_s0),

    // Outputs - Read address channel signals
    .arready_o            (arready_s0),

    // Inputs - Read data channel signals
    .rready_i             (rready_s0),
      
    // Outputs - Read data channel signals
    .rvalid_o             (rvalid_s0),
    .rid_o                (rid_s0),
    .rresp_o              (rresp_s0),
    .rlast_o              (rlast_s0),
    .rdata_o              (rdata_s0),

    // Inputs - Write address channel signals
    .awvalid_i            (awvalid_s0),
    .awid_i               (awid_s0),
    .awlen_i              (awlen_s0),
    .awaddr_i             (awaddr_s0),
    .awsize_i             (awsize_s0),
    .awlock_i             (awlock_s0),
    .awburst_i            (awburst_s0),
    .awcache_i            (awcache_s0),
    .awprot_i             (awprot_s0),


    // Outputs - Write address channel signals
    .awready_o            (awready_s0),
      
    // Inputs - Write data channel signals
    .wvalid_i             (wvalid_s0),
    .wlast_i              (wlast_s0),
    .wid_i                (wid_s0),
    .wdata_i              (wdata_s0),
    .wstrb_i              (wstrb_s0),
    
    // outputs - Write data channel signals
    .wready_o             (wready_s0),

    // Inputs - write response channel signals
    .bready_i             (bready_s0),

    // Outputs - write response channel signals
    .bvalid_o             (bvalid_s0),
    .bid_o                (bid_s0),
    .bresp_o              (bresp_s0)
   );

// spyglass enable_block W528 W123
// spyglass enable_block W287a UndrivenInTerm-ML

// Dummy wires for default slave sideband signals.
   

  // Assign Default slave write address channel
  assign dbg_awid_s0     = awid_s0;
  assign dbg_awaddr_s0   = awaddr_s0;
  assign dbg_awlen_s0    = awlen_s0;
  assign dbg_awsize_s0   = awsize_s0;
  assign dbg_awburst_s0  = awburst_s0;
  assign dbg_awlock_s0   = awlock_s0;
  assign dbg_awcache_s0  = awcache_s0;
  assign dbg_awprot_s0   = awprot_s0;
  assign dbg_awvalid_s0  = awvalid_s0;
  assign dbg_awready_s0  = awready_s0;
  
  // Assign Default slave write data channel
  assign dbg_wid_s0      = wid_s0;
  assign dbg_wdata_s0    = wdata_s0;
  assign dbg_wstrb_s0    = wstrb_s0;
  assign dbg_wlast_s0    = wlast_s0;
  assign dbg_wvalid_s0   = wvalid_s0;
  assign dbg_wready_s0   = wready_s0;

  // Assign Default slave write burst response channel
  assign dbg_bid_s0       = bid_s0;
  assign dbg_bresp_s0     = bresp_s0;
  assign dbg_bvalid_s0    = bvalid_s0;
  assign dbg_bready_s0    = bready_s0;

  // Assign Default slave read address channel
  assign dbg_arid_s0     = arid_s0;
  assign dbg_araddr_s0   = araddr_s0; 
  assign dbg_arlen_s0    = arlen_s0;
  assign dbg_arsize_s0   = arsize_s0;
  assign dbg_arburst_s0  = arburst_s0;
  assign dbg_arlock_s0   = arlock_s0;
  assign dbg_arcache_s0  = arcache_s0;
  assign dbg_arprot_s0   = arprot_s0;
  assign dbg_arvalid_s0  = arvalid_s0;
  assign dbg_arready_s0  = arready_s0;

  // Assign Default slave read data channel
  assign dbg_rid_s0       = rid_s0;
  assign dbg_rdata_s0     = rdata_s0;
  assign dbg_rresp_s0     = rresp_s0;
  assign dbg_rvalid_s0    = rvalid_s0;
  assign dbg_rlast_s0     = rlast_s0;
  assign dbg_rready_s0    = rready_s0;

  
 
  
 
 wire     [`AXI_QOSW-1:0]        arqos_m1_reg;
 wire     [`AXI_QOSW-1:0]        arqos_m1_r;
 wire     [`AXI_QOSW-1:0]        arqos_m1_q;
 
 
  assign arpayload_m1 = {
   arid_m1,
   araddr_m1,
   arlen_m1,
   arsize_m1,
   arburst_m1,
   arlock_m1,
   arcache_m1,
    arprot_m1 };
 
 wire    [`AXI_QOSW-1:0]        awqos_m1_reg;
 wire    [`AXI_QOSW-1:0]        awqos_m1_r;
 wire    [`AXI_QOSW-1:0]        awqos_m1_q;
 
 
  assign awpayload_m1 = {
   awid_m1,
   awaddr_m1,
   awlen_m1,
   awsize_m1,
   awburst_m1,
   awlock_m1,
   awcache_m1,
   awprot_m1 };
 
  assign wpayload_m1 = {
    wid_m1,
    wdata_m1,    wstrb_m1,    wlast_m1 };

// spyglass disable_block W164b
// SMD: Identifies assignments in which the LHS width is greater than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
  assign {
    rid_m1,    rdata_m1,    rresp_m1,    rlast_m1 }  = `AXI_M1_ON_R_SHARED_ONLY_VAL ? (`AXI_IS_ICM_M1 ? rpayload_icm_shrd : rpayload_shrd) : rpayload_m1;
// spyglass enable_block W164a
// spyglass enable_block W164b
// spyglass disable_block W164b
// SMD: Identifies assignments in which the LHS width is greater than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
  assign {
    bid_m1,    bresp_m1 }  = `AXI_M1_ON_B_SHARED_ONLY_VAL ? (`AXI_IS_ICM_M1 ? bpayload_icm_shrd : bpayload_shrd) : bpayload_m1;
// spyglass enable_block W164a
// spyglass enable_block W164b
 
 wire     [`AXI_QOSW-1:0]        arqos_m2_reg;
 wire     [`AXI_QOSW-1:0]        arqos_m2_r;
 wire     [`AXI_QOSW-1:0]        arqos_m2_q;
 
 
  assign arpayload_m2 = {
   arid_m2,
   araddr_m2,
   arlen_m2,
   arsize_m2,
   arburst_m2,
   arlock_m2,
   arcache_m2,
    arprot_m2 };
 
 wire    [`AXI_QOSW-1:0]        awqos_m2_reg;
 wire    [`AXI_QOSW-1:0]        awqos_m2_r;
 wire    [`AXI_QOSW-1:0]        awqos_m2_q;
 
 
  assign awpayload_m2 = {
   awid_m2,
   awaddr_m2,
   awlen_m2,
   awsize_m2,
   awburst_m2,
   awlock_m2,
   awcache_m2,
   awprot_m2 };
 
  assign wpayload_m2 = {
    wid_m2,
    wdata_m2,    wstrb_m2,    wlast_m2 };

// spyglass disable_block W164b
// SMD: Identifies assignments in which the LHS width is greater than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
  assign {
    rid_m2,    rdata_m2,    rresp_m2,    rlast_m2 }  = `AXI_M2_ON_R_SHARED_ONLY_VAL ? (`AXI_IS_ICM_M2 ? rpayload_icm_shrd : rpayload_shrd) : rpayload_m2;
// spyglass enable_block W164a
// spyglass enable_block W164b
// spyglass disable_block W164b
// SMD: Identifies assignments in which the LHS width is greater than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
  assign {
    bid_m2,    bresp_m2 }  = `AXI_M2_ON_B_SHARED_ONLY_VAL ? (`AXI_IS_ICM_M2 ? bpayload_icm_shrd : bpayload_shrd) : bpayload_m2;
// spyglass enable_block W164a
// spyglass enable_block W164b

// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
  assign {
    arid_s0,    araddr_s0,    arlen_s0,    arsize_s0,    arburst_s0,    arlock_s0,    arcache_s0,    arprot_s0 }  = `AXI_S0_ON_AR_SHARED_ONLY_VAL ? arpayload_shrd : arpayload_s0;
// spyglass enable_block W164a
// spyglass enable_block W528

// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
  assign {
    awid_s0,    awaddr_s0,    awlen_s0,    awsize_s0,    awburst_s0,    awlock_s0,    awcache_s0,    awprot_s0 }  = `AXI_S0_ON_AW_SHARED_ONLY_VAL ? awpayload_shrd : awpayload_s0;
// spyglass enable_block W164a
// spyglass enable_block W528

// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
  assign {
    wid_s0,    wdata_s0,    wstrb_s0,    wlast_s0 }  = `AXI_S0_ON_W_SHARED_ONLY_VAL ? wpayload_shrd : wpayload_s0;
// spyglass enable_block W164a
// spyglass enable_block W528

  assign rpayload_s0 = {
    rid_s0,    rdata_s0,    rresp_s0,    rlast_s0 };


  assign bpayload_s0 = {
    bid_s0,    bresp_s0 };


// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
    arid_s1,    araddr_s1,    arlen_s1,    arsize_s1,    arburst_s1,    arlock_s1,    arcache_s1,    arprot_s1 }  = `AXI_S1_ON_AR_SHARED_ONLY_VAL ? arpayload_shrd : arpayload_s1;
// spyglass enable_block W164a
// spyglass enable_block W528

// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
    awid_s1,    awaddr_s1,    awlen_s1,    awsize_s1,    awburst_s1,    awlock_s1,    awcache_s1,    awprot_s1 }  = `AXI_S1_ON_AW_SHARED_ONLY_VAL ? awpayload_shrd : awpayload_s1;
// spyglass enable_block W164a
// spyglass enable_block W528

// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
// spyglass disable_block W164a
// SMD: Identifies assignments in which the LHS width is less than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
 assign {
    wid_s1,    wdata_s1,    wstrb_s1,    wlast_s1 }  = `AXI_S1_ON_W_SHARED_ONLY_VAL ? wpayload_shrd : wpayload_s1;
// spyglass enable_block W164a
// spyglass enable_block W528

  assign rpayload_s1 = {
    rid_s1,    rdata_s1,    rresp_s1,    rlast_s1 };


  assign bpayload_s1 = {
    bid_s1,    bresp_s1 };

    wire [`AXI_SLV_PRIORITY_W-1:0] priority_s0;
    assign priority_s0 = 0;
    wire [`AXI_SLV_PRIORITY_W-1:0] priority_s1;
//spyglass disable_block W164a
//SMD: Operator widths should be same in arithmetic operation
//SJ: RHS is a parameter which has default width of 32
   assign priority_s1 = `AXI_PRIORITY_S1;
//spyglass enable_block W164a

    wire [`AXI_MST_PRIORITY_W-1:0] priority_m1;
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
//spyglass disable_block W164a
//SMD: Operator widths should be same in arithmetic operation
//SJ: RHS is a parameter which has default width of 32
   assign priority_m1 = `AXI_PRIORITY_M1;
//spyglass enable_block W164a
// spyglass enable_block W528
    wire [`AXI_MST_PRIORITY_W-1:0] priority_m2;
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
//spyglass disable_block W164a
//SMD: Operator widths should be same in arithmetic operation
//SJ: RHS is a parameter which has default width of 32
   assign priority_m2 = `AXI_PRIORITY_M2;
//spyglass enable_block W164a
// spyglass enable_block W528

 
  wire [(`AXI_MST_PRIORITY_W*`AXI_AR_S0_NMV)-1:0] ar_bus_mst_priorities_s0;
  wire ar_blank_priority_s0;
  //Done to remove lint error STAR 9000441836
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {ar_blank_priority_s0, ar_bus_mst_priorities_s0} = {1'b0
      , priority_m2
      , priority_m1
  };
// spyglass enable_block W528
  wire [(`AXI_MST_PRIORITY_W*`AXI_AR_S1_NMV)-1:0] ar_bus_mst_priorities_s1;
  wire ar_blank_priority_s1;
  //Done to remove lint error STAR 9000441836
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {ar_blank_priority_s1, ar_bus_mst_priorities_s1} = {1'b0
      , priority_m2
      , priority_m1
  };
// spyglass enable_block W528
  wire [(`AXI_MST_PRIORITY_W*`AXI_AW_S0_NMV)-1:0] aw_bus_mst_priorities_s0;
  wire aw_blank_priority_s0;
  //Done to remove lint error STAR 9000441836
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {aw_blank_priority_s0, aw_bus_mst_priorities_s0} = {1'b0
      , priority_m2
      , priority_m1
  };
// spyglass enable_block W528
  wire [(`AXI_MST_PRIORITY_W*`AXI_AW_S1_NMV)-1:0] aw_bus_mst_priorities_s1;
  wire aw_blank_priority_s1;
  //Done to remove lint error STAR 9000441836
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {aw_blank_priority_s1, aw_bus_mst_priorities_s1} = {1'b0
      , priority_m2
      , priority_m1
  };
// spyglass enable_block W528
  wire [(`AXI_MST_PRIORITY_W*`AXI_W_S0_NMV)-1:0] w_bus_mst_priorities_s0;
  wire w_blank_priority_s0;
  //Done to remove lint error STAR 9000441836
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {w_blank_priority_s0, w_bus_mst_priorities_s0} = {1'b0
      , priority_m2
      , priority_m1
  };
// spyglass enable_block W528
  wire [(`AXI_MST_PRIORITY_W*`AXI_W_S1_NMV)-1:0] w_bus_mst_priorities_s1;
  wire w_blank_priority_s1;
  //Done to remove lint error STAR 9000441836
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {w_blank_priority_s1, w_bus_mst_priorities_s1} = {1'b0
      , priority_m2
      , priority_m1
  };
// spyglass enable_block W528
  wire [(`AXI_SLV_PRIORITY_W*`AXI_R_M1_NSV)-1:0] r_bus_slv_priorities_m1;
  wire r_blank_priority_m1;
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {r_blank_priority_m1,r_bus_slv_priorities_m1} = {1'b0
        , priority_s1
        , priority_s0
 };
// spyglass enable_block W528
  wire [(`AXI_SLV_PRIORITY_W*`AXI_R_M2_NSV)-1:0] r_bus_slv_priorities_m2;
  wire r_blank_priority_m2;
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {r_blank_priority_m2,r_bus_slv_priorities_m2} = {1'b0
        , priority_s1
        , priority_s0
 };
// spyglass enable_block W528
  wire [(`AXI_SLV_PRIORITY_W*`AXI_B_M1_NSV)-1:0] b_bus_slv_priorities_m1;
  wire b_blank_priority_m1;
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {b_blank_priority_m1,b_bus_slv_priorities_m1} = {1'b0
        , priority_s1
        , priority_s0
 };
// spyglass enable_block W528
  wire [(`AXI_SLV_PRIORITY_W*`AXI_B_M2_NSV)-1:0] b_bus_slv_priorities_m2;
  wire b_blank_priority_m2;
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  assign {b_blank_priority_m2,b_bus_slv_priorities_m2} = {1'b0
        , priority_s1
        , priority_s0
 };
// spyglass enable_block W528

/*----------------------------------------------------------------------
 * SHARED SP WIRE CONNECTIONS
 * Create connections to/from the shared SP block.
 * Code will be removed if shared layers are not configured.
*/

//Done to remove lint error STAR 9000441836: if the AW is not on shred layer then we need to fix the signals to zero

  // Select between shared and dedicated channel valid signals for
  // each slave.
       assign arvalid_s1 = `AXI_S1_ON_AR_SHARED_ONLY_VAL
                                 ? arvalid_shrd_s1 
                                 : arvalid_ddctd_s1;
       assign arvalid_s0 = `AXI_S0_ON_AR_SHARED_ONLY_VAL
                                 ? arvalid_shrd_s0 
                                 : arvalid_ddctd_s0;
//Done to remove lint error STAR 9000441836: if the AW is not on shred layer then we need to fix the signals to zero
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
 
        assign  issued_wtx_shrd_sys_s16 = 1'b0;
        assign  issued_wtx_shrd_mst_oh_s16 = {`AXI_NMV_S16{1'b0}};
 
        assign  issued_wtx_shrd_sys_s15 = 1'b0;
        assign  issued_wtx_shrd_mst_oh_s15 = {`AXI_NMV_S15{1'b0}};
 
        assign  issued_wtx_shrd_sys_s14 = 1'b0;
        assign  issued_wtx_shrd_mst_oh_s14 = {`AXI_NMV_S14{1'b0}};
 
        assign  issued_wtx_shrd_sys_s13 = 1'b0;
        assign  issued_wtx_shrd_mst_oh_s13 = {`AXI_NMV_S13{1'b0}};
 
        assign  issued_wtx_shrd_sys_s12 = 1'b0;
        assign  issued_wtx_shrd_mst_oh_s12 = {`AXI_NMV_S12{1'b0}};
 
        assign  issued_wtx_shrd_sys_s11 = 1'b0;
        assign  issued_wtx_shrd_mst_oh_s11 = {`AXI_NMV_S11{1'b0}};
 
        assign  issued_wtx_shrd_sys_s10 = 1'b0;
        assign  issued_wtx_shrd_mst_oh_s10 = {`AXI_NMV_S10{1'b0}};
 
        assign  issued_wtx_shrd_sys_s9 = 1'b0;
        assign  issued_wtx_shrd_mst_oh_s9 = {`AXI_NMV_S9{1'b0}};
 
        assign  issued_wtx_shrd_sys_s8 = 1'b0;
        assign  issued_wtx_shrd_mst_oh_s8 = {`AXI_NMV_S8{1'b0}};
 
        assign  issued_wtx_shrd_sys_s7 = 1'b0;
        assign  issued_wtx_shrd_mst_oh_s7 = {`AXI_NMV_S7{1'b0}};
 
        assign  issued_wtx_shrd_sys_s6 = 1'b0;
        assign  issued_wtx_shrd_mst_oh_s6 = {`AXI_NMV_S6{1'b0}};
 
        assign  issued_wtx_shrd_sys_s5 = 1'b0;
        assign  issued_wtx_shrd_mst_oh_s5 = {`AXI_NMV_S5{1'b0}};
 
        assign  issued_wtx_shrd_sys_s4 = 1'b0;
        assign  issued_wtx_shrd_mst_oh_s4 = {`AXI_NMV_S4{1'b0}};
 
        assign  issued_wtx_shrd_sys_s3 = 1'b0;
        assign  issued_wtx_shrd_mst_oh_s3 = {`AXI_NMV_S3{1'b0}};
 
        assign  issued_wtx_shrd_sys_s2 = 1'b0;
        assign  issued_wtx_shrd_mst_oh_s2 = {`AXI_NMV_S2{1'b0}};
 
        assign  issued_wtx_shrd_sys_s1 = 1'b0;
        assign  issued_wtx_shrd_mst_oh_s1 = {`AXI_NMV_S1{1'b0}};
 
        assign  issued_wtx_shrd_sys_s0 = 1'b0;
        assign  issued_wtx_shrd_mst_oh_s0 = {`AXI_NMV_S0{1'b0}};
// spyglass enable_block W528

  // Select between shared and dedicated channel valid signals for
  // each slave.
       assign awvalid_s1 = `AXI_S1_ON_AW_SHARED_ONLY_VAL
                                 ? awvalid_shrd_s1 
                                 : awvalid_ddctd_s1;
       assign awvalid_s0 = `AXI_S0_ON_AW_SHARED_ONLY_VAL
                                 ? awvalid_shrd_s0 
                                 : awvalid_ddctd_s0;
//Done to remove lint error STAR 9000441836: if the AW is not on shred layer then we need to fix the signals to zero

  // Select between shared and dedicated channel valid signals for
  // each slave.
       assign wvalid_s1 = `AXI_S1_ON_W_SHARED_ONLY_VAL
                                 ? wvalid_shrd_s1 
                                 : wvalid_ddctd_s1;
       assign wvalid_s0 = `AXI_S0_ON_W_SHARED_ONLY_VAL
                                 ? wvalid_shrd_s0 
                                 : wvalid_ddctd_s0;
 
// When the shared to dedicated link exists on the AW channel, it
// is necessary to map the one hot master granted bus from the
// dedicated AW, which will reflect only the masters connected
// to the dedicated with shared masters represented by a
// single grant bit (msb), to a value that is representative
// of all masters visible to that slave.
// This decoding requires ifdefs and as such is done at the
// top level and sent back to the relevant secondary port.
 
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
  // Translate issued_wtx_mst_oh_o_s0 to a bit per
  // system master bus. This signal decodes when dedicated
  // masters issue a t/x to the slave.
  // spyglass disable_block W164b
  // SMD: Identifies assignments in which the LHS width is greater than the RHS width
  // SJ : This is not a functional issue, this is as per the requirement.
  //      Hence this can be waived.
  assign {issued_wtx_mst_oh_dummy1_s0
    , issued_wtx_mst_sys_oh_s0[1]
    , issued_wtx_mst_sys_oh_s0[0]
 } = issued_wtx_mst_oh_o_s0;
  // spyglass enable_block W164b
 
//Done to remove lint error STAR 9000441836:
  // Translate issued_wtx_mst_oh_o_s1 to a bit per
  // system master bus. This signal decodes when dedicated
  // masters issue a t/x to the slave.
  // spyglass disable_block W164b
  // SMD: Identifies assignments in which the LHS width is greater than the RHS width
  // SJ : This is not a functional issue, this is as per the requirement.
  //      Hence this can be waived.
  assign {issued_wtx_mst_oh_dummy1_s1
    , issued_wtx_mst_sys_oh_s1[1]
    , issued_wtx_mst_sys_oh_s1[0]
 } = issued_wtx_mst_oh_o_s1;
  // spyglass enable_block W164b
 
//Done to remove lint error STAR 9000441836:
// spyglass enable_block W528
  // Translate issued_wtx_mst_sys_oh_s0 to a bit per
  // master visible to slave 0 value.
  assign issued_wtx_mst_oh_i_eb_s0 = { 1'b0
    , issued_wtx_mst_sys_oh_s0[1]
    , issued_wtx_mst_sys_oh_s0[0]
  };
  // Remove extra bit. 
  assign issued_wtx_mst_oh_i_s0 
  = issued_wtx_mst_oh_i_eb_s0[`AXI_NMV_S0-1:0];
   
  // Translate issued_wtx_mst_sys_oh_s1 to a bit per
  // master visible to slave 1 value.
  assign issued_wtx_mst_oh_i_eb_s1 = { 1'b0
    , issued_wtx_mst_sys_oh_s1[1]
    , issued_wtx_mst_sys_oh_s1[0]
  };
  // Remove extra bit. 
  assign issued_wtx_mst_oh_i_s1 
  = issued_wtx_mst_oh_i_eb_s1[`AXI_NMV_S1-1:0];
   

/*----------------------------------------------------------------------
 * SHARED MP WIRE CONNECTIONS
 * Create connections to/from the shared MP block.
 * Code will be removed if shared layers are not configured.
*/


  // Done to remove lint error STAR 9000441836The shared R channel outputs a t/x completion bit for each master on the
  // shared channel. Here we tied bits to  low if Masters' R  is not SHARED
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
 
        assign rcpl_tx_shrd_sys_m16 = 1'b0;
     
 
        assign rcpl_tx_shrd_sys_m15 = 1'b0;
     
 
        assign rcpl_tx_shrd_sys_m14 = 1'b0;
     
 
        assign rcpl_tx_shrd_sys_m13 = 1'b0;
     
 
        assign rcpl_tx_shrd_sys_m12 = 1'b0;
     
 
        assign rcpl_tx_shrd_sys_m11 = 1'b0;
     
 
        assign rcpl_tx_shrd_sys_m10 = 1'b0;
     
 
        assign rcpl_tx_shrd_sys_m9 = 1'b0;
     
 
        assign rcpl_tx_shrd_sys_m8 = 1'b0;
     
 
        assign rcpl_tx_shrd_sys_m7 = 1'b0;
     
 
        assign rcpl_tx_shrd_sys_m6 = 1'b0;
     
 
        assign rcpl_tx_shrd_sys_m5 = 1'b0;
     
 
        assign rcpl_tx_shrd_sys_m4 = 1'b0;
     
 
        assign rcpl_tx_shrd_sys_m3 = 1'b0;
     
 
        assign rcpl_tx_shrd_sys_m2 = 1'b0;
     
 
        assign rcpl_tx_shrd_sys_m1 = 1'b0;
     
// spyglass enable_block W528
//Done to remove lint error STAR 9000441836 id shrd
assign rcpl_id_shrd = {{`AXI_MIDW{1'b0}}};

  // Select between shared and dedicated channel valid signals for
  // each master.
       assign rvalid_m2 = `AXI_M2_ON_R_SHARED_ONLY_VAL
                                 ? rvalid_shrd_m2 
                                 : rvalid_ddctd_m2;
       assign rvalid_m1 = `AXI_M1_ON_R_SHARED_ONLY_VAL
                                 ? rvalid_shrd_m1 
                                 : rvalid_ddctd_m1;

  // Done to remove lint error STAR 9000441836The shared B channel outputs a t/x completion bit for each master on the
  // shared channel. Here we tied bits to  low if Masters' B  is not SHARED
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
 
        assign wcpl_tx_shrd_sys_m16 = 1'b0;
     
 
        assign wcpl_tx_shrd_sys_m15 = 1'b0;
     
 
        assign wcpl_tx_shrd_sys_m14 = 1'b0;
     
 
        assign wcpl_tx_shrd_sys_m13 = 1'b0;
     
 
        assign wcpl_tx_shrd_sys_m12 = 1'b0;
     
 
        assign wcpl_tx_shrd_sys_m11 = 1'b0;
     
 
        assign wcpl_tx_shrd_sys_m10 = 1'b0;
     
 
        assign wcpl_tx_shrd_sys_m9 = 1'b0;
     
 
        assign wcpl_tx_shrd_sys_m8 = 1'b0;
     
 
        assign wcpl_tx_shrd_sys_m7 = 1'b0;
     
 
        assign wcpl_tx_shrd_sys_m6 = 1'b0;
     
 
        assign wcpl_tx_shrd_sys_m5 = 1'b0;
     
 
        assign wcpl_tx_shrd_sys_m4 = 1'b0;
     
 
        assign wcpl_tx_shrd_sys_m3 = 1'b0;
     
 
        assign wcpl_tx_shrd_sys_m2 = 1'b0;
     
 
        assign wcpl_tx_shrd_sys_m1 = 1'b0;
     
// spyglass enable_block W528
//Done to remove lint error STAR 9000441836 id shrd
assign wcpl_id_shrd = {{`AXI_MIDW{1'b0}}};

  // Select between shared and dedicated channel valid signals for
  // each master.
       assign bvalid_m2 = `AXI_M2_ON_B_SHARED_ONLY_VAL
                                 ? bvalid_shrd_m2 
                                 : bvalid_ddctd_m2;
       assign bvalid_m1 = `AXI_M1_ON_B_SHARED_ONLY_VAL
                                 ? bvalid_shrd_m1 
                                 : bvalid_ddctd_m1;

 

  DW_axi_sp
   #(`AXI_NMV_S0, 
`AXI_LOG2_LCL_NM, `AXI_AR_S0_NMV, `AXI_AR_S0_NMV_LOG2, `AXI_AR_S0_NMV_P1_LOG2, `AXI_AW_S0_NMV, `AXI_AW_S0_NMV_LOG2, `AXI_AW_S0_NMV_P1_LOG2, `AXI_W_S0_NMV, `AXI_W_S0_NMV_LOG2, `AXI_W_S0_NMV_P1_LOG2, `AXI_AR_ARB_TYPE_S0, `AXI_AW_ARB_TYPE_S0, `AXI_W_ARB_TYPE_S0, `AXI_AR_MCA_EN_S0, `AXI_AW_MCA_EN_S0, `AXI_W_MCA_EN_S0, `AXI_AR_MCA_NC_S0, `AXI_AW_MCA_NC_S0, `AXI_W_MCA_NC_S0, `AXI_AR_MCA_NC_W_S0, `AXI_AW_MCA_NC_W_S0, `AXI_W_MCA_NC_W_S0, `AXI_VV_S0_BY_M1, `AXI_VV_S0_BY_M2, `AXI_VV_S0_BY_M3, `AXI_VV_S0_BY_M4, `AXI_VV_S0_BY_M5, `AXI_VV_S0_BY_M6, `AXI_VV_S0_BY_M7, `AXI_VV_S0_BY_M8, `AXI_VV_S0_BY_M9, `AXI_VV_S0_BY_M10, `AXI_VV_S0_BY_M11, `AXI_VV_S0_BY_M12, `AXI_VV_S0_BY_M13, `AXI_VV_S0_BY_M14, `AXI_VV_S0_BY_M15, `AXI_VV_S0_BY_M16, 1, 1, 1, `AXI_MAX_FARC_S0, `AXI_LOG2_MAX_FARC_P1_S0, `AXI_MAX_FAWC_S0, `AXI_LOG2_MAX_FAWC_S0, `AXI_LOG2_MAX_FAWC_P1_S0, `AXI_NOREQ_LOCKING,`AXI_AW_LAYER_S0_M1 ,`AXI_AW_LAYER_S0_M2 ,`AXI_AW_LAYER_S0_M3 ,`AXI_AW_LAYER_S0_M4 ,`AXI_AW_LAYER_S0_M5 ,`AXI_AW_LAYER_S0_M6 ,`AXI_AW_LAYER_S0_M7 ,`AXI_AW_LAYER_S0_M8 ,`AXI_AW_LAYER_S0_M9 ,`AXI_AW_LAYER_S0_M10 ,`AXI_AW_LAYER_S0_M11 ,`AXI_AW_LAYER_S0_M12 ,`AXI_AW_LAYER_S0_M13 ,`AXI_AW_LAYER_S0_M14 ,`AXI_AW_LAYER_S0_M15 ,`AXI_AW_LAYER_S0_M16 ,`AXI_AR_LAYER_S0_M1 ,`AXI_AR_LAYER_S0_M2 ,`AXI_AR_LAYER_S0_M3 ,`AXI_AR_LAYER_S0_M4 ,`AXI_AR_LAYER_S0_M5 ,`AXI_AR_LAYER_S0_M6 ,`AXI_AR_LAYER_S0_M7 ,`AXI_AR_LAYER_S0_M8 ,`AXI_AR_LAYER_S0_M9 ,`AXI_AR_LAYER_S0_M10 ,`AXI_AR_LAYER_S0_M11 ,`AXI_AR_LAYER_S0_M12 ,`AXI_AR_LAYER_S0_M13 ,`AXI_AR_LAYER_S0_M14 ,`AXI_AR_LAYER_S0_M15 ,`AXI_AR_LAYER_S0_M16 ,`AXI_W_LAYER_S0_M1 ,`AXI_W_LAYER_S0_M2 ,`AXI_W_LAYER_S0_M3 ,`AXI_W_LAYER_S0_M4 ,`AXI_W_LAYER_S0_M5 ,`AXI_W_LAYER_S0_M6 ,`AXI_W_LAYER_S0_M7 ,`AXI_W_LAYER_S0_M8 ,`AXI_W_LAYER_S0_M9 ,`AXI_W_LAYER_S0_M10 ,`AXI_W_LAYER_S0_M11 ,`AXI_W_LAYER_S0_M12 ,`AXI_W_LAYER_S0_M13 ,`AXI_W_LAYER_S0_M14 ,`AXI_W_LAYER_S0_M15 ,`AXI_W_LAYER_S0_M16 ,`AXI_R_LAYER_M1_S0 ,`AXI_R_LAYER_M2_S0 ,`AXI_R_LAYER_M3_S0 ,`AXI_R_LAYER_M4_S0 ,`AXI_R_LAYER_M5_S0 ,`AXI_R_LAYER_M6_S0 ,`AXI_R_LAYER_M7_S0 ,`AXI_R_LAYER_M8_S0 ,`AXI_R_LAYER_M9_S0 ,`AXI_R_LAYER_M10_S0 ,`AXI_R_LAYER_M11_S0 ,`AXI_R_LAYER_M12_S0 ,`AXI_R_LAYER_M13_S0 ,`AXI_R_LAYER_M14_S0 ,`AXI_R_LAYER_M15_S0 ,`AXI_R_LAYER_M16_S0 ,`AXI_B_LAYER_M1_S0 ,`AXI_B_LAYER_M2_S0 ,`AXI_B_LAYER_M3_S0 ,`AXI_B_LAYER_M4_S0 ,`AXI_B_LAYER_M5_S0 ,`AXI_B_LAYER_M6_S0 ,`AXI_B_LAYER_M7_S0 ,`AXI_B_LAYER_M8_S0 ,`AXI_B_LAYER_M9_S0 ,`AXI_B_LAYER_M10_S0 ,`AXI_B_LAYER_M11_S0 ,`AXI_B_LAYER_M12_S0 ,`AXI_B_LAYER_M13_S0 ,`AXI_B_LAYER_M14_S0 ,`AXI_B_LAYER_M15_S0 ,`AXI_B_LAYER_M16_S0 , `AXI_AW_S0_HAS_SHRD_DDCTD_LNK_VAL, `AXI_W_S0_HAS_SHRD_DDCTD_LNK_VAL, `AXI_S0_ON_AR_SHARED_ONLY_VAL, `AXI_S0_ON_AW_SHARED_ONLY_VAL, `AXI_S0_ON_W_SHARED_ONLY_VAL
  )

  // spyglass disable_block W528
  // SMD: A signal or variable is set but never read
  // SJ: This warning can be ignored. 
  // spyglass disable_block W287a UndrivenInTerm-ML
  // SMD: Some inputs to instance are not driven or unconnected
  // SJ: This warning can be ignored.  
 
  U_DW_axi_sp_s0 (
    .aclk_i                   (aclk),
    .aresetn_i                (aresetn),
    .ar_bus_mst_priorities_i  (ar_bus_mst_priorities_s0),
    .aw_bus_mst_priorities_i  (aw_bus_mst_priorities_s0),
    .w_bus_mst_priorities_i   (w_bus_mst_priorities_s0),

// Read Address Channel
    .arready_i                (arready_s0),
    .arvalid_o                (arvalid_ddctd_s0),
    .arpayload_o              (arpayload_s0),
    .bus_arvalid_i            (bus_arvalid_s0),
    .bus_arpayload_i          (bus_arpayload_s0),
    .bus_arready_o            (bus_sp_arready_s0),
    .rcpl_tx_shrd_o           (rcpl_tx_s0),
// Read Data Channel
    .rvalid_i                 (rvalid_s0),
    .rpayload_i               (rpayload_s0),
    .rready_o                 (rready_s0),
    .bus_rready_i             (bus_rready_s0),
    .bus_rvalid_o             (sp_rvalid_s0),
    .r_shrd_ch_req_o          (r_shrd_ch_req_s0),
    .rpayload_o               (sp_rpayload_s0),
// Write Address Channel
    .awready_i                (awready_s0),
    .awvalid_o                (awvalid_ddctd_s0),
    .awpayload_o              (awpayload_s0),
    .bus_awvalid_i            (bus_awvalid_s0),
    .bus_awpayload_i          (bus_awpayload_s0),
    .bus_awready_o            (bus_sp_awready_s0),
    .aw_shrd_lyr_granted_o    (aw_shrd_lyr_granted_s0),
    .issued_wtx_mst_oh_o      (issued_wtx_mst_oh_o_s0),
    .issued_wtx_mst_oh_i      (issued_wtx_mst_oh_i_s0),
// Write Data Channel
    .wready_i                 (wready_s0),
    .wvalid_o                 (wvalid_ddctd_s0),
    .wpayload_o               (wpayload_s0),
    .bus_wvalid_i             (bus_wvalid_s0),
    .bus_wpayload_i           (bus_wpayload_s0),
    .bus_wready_o             (bus_sp_wready_s0),
    .issued_tx_shrd_i         (issued_wtx_shrd_sys_s0),
    .issued_tx_shrd_mst_oh_i  (issued_wtx_shrd_mst_oh_s0),
    .shrd_w_nxt_fb_pend_o     (shrd_w_nxt_fb_pend_s0),
//Burst Response Channel
    .bvalid_i                 (bvalid_s0),
    .bpayload_i               (bpayload_s0),
    .bready_o                 (bready_s0),
    .bus_bready_i             (bus_bready_s0),
    .bus_bvalid_o             (sp_bvalid_s0),
    .bpayload_o               (sp_bpayload_s0),
    .b_shrd_ch_req_o          (b_shrd_ch_req_s0),
    .wcpl_tx_shrd_o           (wcpl_tx_s0)
  );
  // spyglass enable_block W528
  // spyglass enable_block W287a UndrivenInTerm-ML



  DW_axi_sp
   #(`AXI_NMV_S1, 
`AXI_LOG2_NMV_S1, `AXI_AR_S1_NMV, `AXI_AR_S1_NMV_LOG2, `AXI_AR_S1_NMV_P1_LOG2, `AXI_AW_S1_NMV, `AXI_AW_S1_NMV_LOG2, `AXI_AW_S1_NMV_P1_LOG2, `AXI_W_S1_NMV, `AXI_W_S1_NMV_LOG2, `AXI_W_S1_NMV_P1_LOG2, `AXI_AR_ARB_TYPE_S1, `AXI_AW_ARB_TYPE_S1, `AXI_W_ARB_TYPE_S1, `AXI_AR_MCA_EN_S1, `AXI_AW_MCA_EN_S1, `AXI_W_MCA_EN_S1, `AXI_AR_MCA_NC_S1, `AXI_AW_MCA_NC_S1, `AXI_W_MCA_NC_S1, `AXI_AR_MCA_NC_W_S1, `AXI_AW_MCA_NC_W_S1, `AXI_W_MCA_NC_W_S1, `AXI_VV_S1_BY_M1, `AXI_VV_S1_BY_M2, `AXI_VV_S1_BY_M3, `AXI_VV_S1_BY_M4, `AXI_VV_S1_BY_M5, `AXI_VV_S1_BY_M6, `AXI_VV_S1_BY_M7, `AXI_VV_S1_BY_M8, `AXI_VV_S1_BY_M9, `AXI_VV_S1_BY_M10, `AXI_VV_S1_BY_M11, `AXI_VV_S1_BY_M12, `AXI_VV_S1_BY_M13, `AXI_VV_S1_BY_M14, `AXI_VV_S1_BY_M15, `AXI_VV_S1_BY_M16, `AXI_WID_S1, `AXI_LOG2_WID_S1, `AXI_LOG2_WID_P1_S1, `AXI_MAX_FARC_S1, `AXI_LOG2_MAX_FARC_P1_S1, `AXI_MAX_FAWC_S1, `AXI_LOG2_MAX_FAWC_S1, `AXI_LOG2_MAX_FAWC_P1_S1, `AXI_HAS_LOCKING,`AXI_AW_LAYER_S1_M1 ,`AXI_AW_LAYER_S1_M2 ,`AXI_AW_LAYER_S1_M3 ,`AXI_AW_LAYER_S1_M4 ,`AXI_AW_LAYER_S1_M5 ,`AXI_AW_LAYER_S1_M6 ,`AXI_AW_LAYER_S1_M7 ,`AXI_AW_LAYER_S1_M8 ,`AXI_AW_LAYER_S1_M9 ,`AXI_AW_LAYER_S1_M10 ,`AXI_AW_LAYER_S1_M11 ,`AXI_AW_LAYER_S1_M12 ,`AXI_AW_LAYER_S1_M13 ,`AXI_AW_LAYER_S1_M14 ,`AXI_AW_LAYER_S1_M15 ,`AXI_AW_LAYER_S1_M16 ,`AXI_AR_LAYER_S1_M1 ,`AXI_AR_LAYER_S1_M2 ,`AXI_AR_LAYER_S1_M3 ,`AXI_AR_LAYER_S1_M4 ,`AXI_AR_LAYER_S1_M5 ,`AXI_AR_LAYER_S1_M6 ,`AXI_AR_LAYER_S1_M7 ,`AXI_AR_LAYER_S1_M8 ,`AXI_AR_LAYER_S1_M9 ,`AXI_AR_LAYER_S1_M10 ,`AXI_AR_LAYER_S1_M11 ,`AXI_AR_LAYER_S1_M12 ,`AXI_AR_LAYER_S1_M13 ,`AXI_AR_LAYER_S1_M14 ,`AXI_AR_LAYER_S1_M15 ,`AXI_AR_LAYER_S1_M16 ,`AXI_W_LAYER_S1_M1 ,`AXI_W_LAYER_S1_M2 ,`AXI_W_LAYER_S1_M3 ,`AXI_W_LAYER_S1_M4 ,`AXI_W_LAYER_S1_M5 ,`AXI_W_LAYER_S1_M6 ,`AXI_W_LAYER_S1_M7 ,`AXI_W_LAYER_S1_M8 ,`AXI_W_LAYER_S1_M9 ,`AXI_W_LAYER_S1_M10 ,`AXI_W_LAYER_S1_M11 ,`AXI_W_LAYER_S1_M12 ,`AXI_W_LAYER_S1_M13 ,`AXI_W_LAYER_S1_M14 ,`AXI_W_LAYER_S1_M15 ,`AXI_W_LAYER_S1_M16 ,`AXI_R_LAYER_M1_S1 ,`AXI_R_LAYER_M2_S1 ,`AXI_R_LAYER_M3_S1 ,`AXI_R_LAYER_M4_S1 ,`AXI_R_LAYER_M5_S1 ,`AXI_R_LAYER_M6_S1 ,`AXI_R_LAYER_M7_S1 ,`AXI_R_LAYER_M8_S1 ,`AXI_R_LAYER_M9_S1 ,`AXI_R_LAYER_M10_S1 ,`AXI_R_LAYER_M11_S1 ,`AXI_R_LAYER_M12_S1 ,`AXI_R_LAYER_M13_S1 ,`AXI_R_LAYER_M14_S1 ,`AXI_R_LAYER_M15_S1 ,`AXI_R_LAYER_M16_S1 ,`AXI_B_LAYER_M1_S1 ,`AXI_B_LAYER_M2_S1 ,`AXI_B_LAYER_M3_S1 ,`AXI_B_LAYER_M4_S1 ,`AXI_B_LAYER_M5_S1 ,`AXI_B_LAYER_M6_S1 ,`AXI_B_LAYER_M7_S1 ,`AXI_B_LAYER_M8_S1 ,`AXI_B_LAYER_M9_S1 ,`AXI_B_LAYER_M10_S1 ,`AXI_B_LAYER_M11_S1 ,`AXI_B_LAYER_M12_S1 ,`AXI_B_LAYER_M13_S1 ,`AXI_B_LAYER_M14_S1 ,`AXI_B_LAYER_M15_S1 ,`AXI_B_LAYER_M16_S1 , `AXI_AW_S1_HAS_SHRD_DDCTD_LNK_VAL, `AXI_W_S1_HAS_SHRD_DDCTD_LNK_VAL, `AXI_S1_ON_AR_SHARED_ONLY_VAL, `AXI_S1_ON_AW_SHARED_ONLY_VAL, `AXI_S1_ON_W_SHARED_ONLY_VAL
  )

  // spyglass disable_block W528
  // SMD: A signal or variable is set but never read
  // SJ: This warning can be ignored. 
  // spyglass disable_block W287a UndrivenInTerm-ML
  // SMD: Some inputs to instance are not driven or unconnected
  // SJ: This warning can be ignored.  
 
  U_DW_axi_sp_s1 (
    .aclk_i                   (aclk),
    .aresetn_i                (aresetn),
    .ar_bus_mst_priorities_i  (ar_bus_mst_priorities_s1),
    .aw_bus_mst_priorities_i  (aw_bus_mst_priorities_s1),
    .w_bus_mst_priorities_i   (w_bus_mst_priorities_s1),

// Read Address Channel
    .arready_i                (arready_s1),
    .arvalid_o                (arvalid_ddctd_s1),
    .arpayload_o              (arpayload_s1),
    .bus_arvalid_i            (bus_arvalid_s1),
    .bus_arpayload_i          (bus_arpayload_s1),
    .bus_arready_o            (bus_sp_arready_s1),
    .rcpl_tx_shrd_o           (rcpl_tx_s1),
// Read Data Channel
    .rvalid_i                 (rvalid_s1),
    .rpayload_i               (rpayload_s1),
    .rready_o                 (rready_s1),
    .bus_rready_i             (bus_rready_s1),
    .bus_rvalid_o             (sp_rvalid_s1),
    .r_shrd_ch_req_o          (r_shrd_ch_req_s1),
    .rpayload_o               (sp_rpayload_s1),
// Write Address Channel
    .awready_i                (awready_s1),
    .awvalid_o                (awvalid_ddctd_s1),
    .awpayload_o              (awpayload_s1),
    .bus_awvalid_i            (bus_awvalid_s1),
    .bus_awpayload_i          (bus_awpayload_s1),
    .bus_awready_o            (bus_sp_awready_s1),
    .aw_shrd_lyr_granted_o    (aw_shrd_lyr_granted_s1),
    .issued_wtx_mst_oh_o      (issued_wtx_mst_oh_o_s1),
    .issued_wtx_mst_oh_i      (issued_wtx_mst_oh_i_s1),
// Write Data Channel
    .wready_i                 (wready_s1),
    .wvalid_o                 (wvalid_ddctd_s1),
    .wpayload_o               (wpayload_s1),
    .bus_wvalid_i             (bus_wvalid_s1),
    .bus_wpayload_i           (bus_wpayload_s1),
    .bus_wready_o             (bus_sp_wready_s1),
    .issued_tx_shrd_i         (issued_wtx_shrd_sys_s1),
    .issued_tx_shrd_mst_oh_i  (issued_wtx_shrd_mst_oh_s1),
    .shrd_w_nxt_fb_pend_o     (shrd_w_nxt_fb_pend_s1),
//Burst Response Channel
    .bvalid_i                 (bvalid_s1),
    .bpayload_i               (bpayload_s1),
    .bready_o                 (bready_s1),
    .bus_bready_i             (bus_bready_s1),
    .bus_bvalid_o             (sp_bvalid_s1),
    .bpayload_o               (sp_bpayload_s1),
    .b_shrd_ch_req_o          (b_shrd_ch_req_s1),
    .wcpl_tx_shrd_o           (wcpl_tx_s1)
  );
  // spyglass enable_block W528
  // spyglass enable_block W287a UndrivenInTerm-ML

































  DW_axi_mp
   #(`AXI_SYS_NUM_FOR_M1 - 1, `AXI_IS_ICM_M1, `AXI_NSP1V_M1, `AXI_LOG2_NSP1V_M1, `AXI_R_M1_NSV, `AXI_R_M1_NSV_LOG2, `AXI_R_M1_NSV_P1_LOG2, `AXI_B_M1_NSV, `AXI_B_M1_NSV_LOG2, `AXI_B_M1_NSV_P1_LOG2, `AXI_R_ARB_TYPE_M1, `AXI_B_ARB_TYPE_M1, `AXI_R_MCA_EN_M1, `AXI_B_MCA_EN_M1, `AXI_R_MCA_NC_M1, `AXI_B_MCA_NC_M1, `AXI_R_MCA_NC_W_M1, `AXI_B_MCA_NC_W_M1, 1,  /* Default slave always visible in normal mode. */ `AXI_NV_S1_BY_M1, `AXI_NV_S2_BY_M1, `AXI_NV_S3_BY_M1, `AXI_NV_S4_BY_M1, `AXI_NV_S5_BY_M1, `AXI_NV_S6_BY_M1, `AXI_NV_S7_BY_M1, `AXI_NV_S8_BY_M1, `AXI_NV_S9_BY_M1, `AXI_NV_S10_BY_M1, `AXI_NV_S11_BY_M1, `AXI_NV_S12_BY_M1, `AXI_NV_S13_BY_M1, `AXI_NV_S14_BY_M1, `AXI_NV_S15_BY_M1, `AXI_NV_S16_BY_M1, 1,  /* Default slave always visible in boot mode. */ `AXI_BV_S1_BY_M1, `AXI_BV_S2_BY_M1, `AXI_BV_S3_BY_M1, `AXI_BV_S4_BY_M1, `AXI_BV_S5_BY_M1, `AXI_BV_S6_BY_M1, `AXI_BV_S7_BY_M1, `AXI_BV_S8_BY_M1, `AXI_BV_S9_BY_M1, `AXI_BV_S10_BY_M1, `AXI_BV_S11_BY_M1, `AXI_BV_S12_BY_M1, `AXI_BV_S13_BY_M1, `AXI_BV_S14_BY_M1, `AXI_BV_S15_BY_M1, `AXI_BV_S16_BY_M1, `AXI_MAX_RCA_ID_M1, `AXI_MAX_WCA_ID_M1, `AXI_MAX_URIDA_M1, `AXI_MAX_UWIDA_M1, `AXI_LOG2_MAX_RCA_ID_P1_M1, `AXI_LOG2_MAX_WCA_ID_P1_M1, `AXI_LOG2_MAX_URIDA_M1, `AXI_LOG2_MAX_UWIDA_M1, `AXI_RI_LIMIT_M1
,`AXI_AR_LAYER_S0_M1 ,`AXI_AR_LAYER_S1_M1 ,`AXI_AR_LAYER_S2_M1 ,`AXI_AR_LAYER_S3_M1 ,`AXI_AR_LAYER_S4_M1 ,`AXI_AR_LAYER_S5_M1 ,`AXI_AR_LAYER_S6_M1 ,`AXI_AR_LAYER_S7_M1 ,`AXI_AR_LAYER_S8_M1 ,`AXI_AR_LAYER_S9_M1 ,`AXI_AR_LAYER_S10_M1 ,`AXI_AR_LAYER_S11_M1 ,`AXI_AR_LAYER_S12_M1 ,`AXI_AR_LAYER_S13_M1 ,`AXI_AR_LAYER_S14_M1 ,`AXI_AR_LAYER_S15_M1 ,`AXI_AR_LAYER_S16_M1 ,`AXI_AW_LAYER_S0_M1 ,`AXI_AW_LAYER_S1_M1 ,`AXI_AW_LAYER_S2_M1 ,`AXI_AW_LAYER_S3_M1 ,`AXI_AW_LAYER_S4_M1 ,`AXI_AW_LAYER_S5_M1 ,`AXI_AW_LAYER_S6_M1 ,`AXI_AW_LAYER_S7_M1 ,`AXI_AW_LAYER_S8_M1 ,`AXI_AW_LAYER_S9_M1 ,`AXI_AW_LAYER_S10_M1 ,`AXI_AW_LAYER_S11_M1 ,`AXI_AW_LAYER_S12_M1 ,`AXI_AW_LAYER_S13_M1 ,`AXI_AW_LAYER_S14_M1 ,`AXI_AW_LAYER_S15_M1 ,`AXI_AW_LAYER_S16_M1 ,`AXI_W_LAYER_S0_M1 ,`AXI_W_LAYER_S1_M1 ,`AXI_W_LAYER_S2_M1 ,`AXI_W_LAYER_S3_M1 ,`AXI_W_LAYER_S4_M1 ,`AXI_W_LAYER_S5_M1 ,`AXI_W_LAYER_S6_M1 ,`AXI_W_LAYER_S7_M1 ,`AXI_W_LAYER_S8_M1 ,`AXI_W_LAYER_S9_M1 ,`AXI_W_LAYER_S10_M1 ,`AXI_W_LAYER_S11_M1 ,`AXI_W_LAYER_S12_M1 ,`AXI_W_LAYER_S13_M1 ,`AXI_W_LAYER_S14_M1 ,`AXI_W_LAYER_S15_M1 ,`AXI_W_LAYER_S16_M1 ,`AXI_AW_S0_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S1_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S2_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S3_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S4_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S5_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S6_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S7_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S8_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S9_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S10_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S11_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S12_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S13_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S14_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S15_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S16_HAS_SHRD_DDCTD_LNK_VAL , `AXI_M1_ON_R_SHARED_ONLY_VAL, `AXI_M1_ON_B_SHARED_ONLY_VAL, `ACT_ID_BUF_POINTER_W_AW_M1, `LOG2_ACT_ID_BUF_POINTER_W_AW_M1, `ACT_ID_BUF_POINTER_W_AR_M1, `LOG2_ACT_ID_BUF_POINTER_W_AR_M1
  )

  // spyglass disable_block UndrivenInTerm-ML 
  // SMD: Detects undriven but loaded input terminal of an instance
  // SJ: This warning can be ignored. 
 
  U_DW_axi_mp_m1 (
  // spyglass disable_block W528
  // SMD: A signal or variable is set but never read
  // SJ: This warning can be ignored. 


    .aclk_i                      (aclk),
    .aresetn_i                   (aresetn),
    .r_bus_slv_priorities_i      (r_bus_slv_priorities_m1),
    .b_bus_slv_priorities_i      (b_bus_slv_priorities_m1),

// Read Address Channel
    .arvalid_i                   (arvalid_m1),
    .arpayload_i                 (arpayload_m1),
    .arready_o                   (arready_m1),
    .bus_arready_i               (bus_arready_m1),
    .bus_arvalid_o               (mp_arvalid_m1_q),
    .ar_shrd_ch_req_o            (ar_shrd_ch_req_m1),
    .arpayload_o                 (mp_arpayload_m1),
// Read Data Channel
    .rready_i                    (rready_m1),
    .rvalid_o                    (rvalid_ddctd_m1),
    .rpayload_o                  (rpayload_m1),
    .bus_rvalid_i                (bus_rvalid_m1),
    .bus_rpayload_i              (bus_rpayload_m1),
    .bus_rready_o                (bus_mp_rready_m1),
    .rcpl_tx_shrd_i              (rcpl_tx_shrd_sys_m1),
    .rcpl_id_shrd_i              (rcpl_id_shrd[`AXI_MIDW-1:0]),
// Write Address Channel
    .awvalid_i                   (awvalid_m1),
    .awpayload_i                 (awpayload_m1),
    .awready_o                   (awready_m1),
    .bus_awready_i               (bus_awready_m1),
    .aw_shrd_lyr_granted_s_bus_i (aw_shrd_lyr_granted_m1_s_bus),
    .issued_wtx_shrd_sys_s_bus_i (issued_wtx_shrd_sys_m1_s_bus),
    .bus_awvalid_o               (mp_awvalid_m1_q),
    .aw_shrd_ch_req_o            (aw_shrd_ch_req_m1),
    .awpayload_o                 (mp_awpayload_m1),
// Write Data Channel
    .wvalid_i                    (wvalid_m1),
    .wpayload_i                  (wpayload_m1),
    .wready_o                    (wready_m1),
    .bus_wready_i                (bus_wready_m1),
    .bus_wvalid_o                (mp_wvalid_m1),
    .w_shrd_ch_req_o             (w_shrd_ch_req_m1),
    .wpayload_o                  (mp_wpayload_m1),
//Burst Response Channel
    .bready_i                    (bready_m1),
    .bvalid_o                    (bvalid_ddctd_m1),
    .bpayload_o                  (bpayload_m1),
    .bus_bvalid_i                (bus_bvalid_m1),
    .bus_bpayload_i              (bus_bpayload_m1),
    .bus_bready_o                (bus_mp_bready_m1),
    .wcpl_tx_shrd_i              (wcpl_tx_shrd_sys_m1),
    .has_ar_pending_trans_o      (has_ar_pending_trans_m1),
    .has_aw_pending_trans_o      (has_aw_pending_trans_m1),
    .wcpl_id_shrd_i              (wcpl_id_shrd[`AXI_MIDW-1:0])
  // spyglass enable_block W528
  // spyglass enable_block UndrivenInTerm-ML 
  );
 
assign mp_arvalid_m1 = mp_arvalid_m1_q;
  
 
assign mp_awvalid_m1 = mp_awvalid_m1_q;
  
  


  DW_axi_mp
   #(`AXI_SYS_NUM_FOR_M2 - 1, `AXI_IS_ICM_M2, `AXI_NSP1V_M2, `AXI_LOG2_NSP1V_M2, `AXI_R_M2_NSV, `AXI_R_M2_NSV_LOG2, `AXI_R_M2_NSV_P1_LOG2, `AXI_B_M2_NSV, `AXI_B_M2_NSV_LOG2, `AXI_B_M2_NSV_P1_LOG2, `AXI_R_ARB_TYPE_M2, `AXI_B_ARB_TYPE_M2, `AXI_R_MCA_EN_M2, `AXI_B_MCA_EN_M2, `AXI_R_MCA_NC_M2, `AXI_B_MCA_NC_M2, `AXI_R_MCA_NC_W_M2, `AXI_B_MCA_NC_W_M2, 1,  /* Default slave always visible in normal mode. */ `AXI_NV_S1_BY_M2, `AXI_NV_S2_BY_M2, `AXI_NV_S3_BY_M2, `AXI_NV_S4_BY_M2, `AXI_NV_S5_BY_M2, `AXI_NV_S6_BY_M2, `AXI_NV_S7_BY_M2, `AXI_NV_S8_BY_M2, `AXI_NV_S9_BY_M2, `AXI_NV_S10_BY_M2, `AXI_NV_S11_BY_M2, `AXI_NV_S12_BY_M2, `AXI_NV_S13_BY_M2, `AXI_NV_S14_BY_M2, `AXI_NV_S15_BY_M2, `AXI_NV_S16_BY_M2, 1,  /* Default slave always visible in boot mode. */ `AXI_BV_S1_BY_M2, `AXI_BV_S2_BY_M2, `AXI_BV_S3_BY_M2, `AXI_BV_S4_BY_M2, `AXI_BV_S5_BY_M2, `AXI_BV_S6_BY_M2, `AXI_BV_S7_BY_M2, `AXI_BV_S8_BY_M2, `AXI_BV_S9_BY_M2, `AXI_BV_S10_BY_M2, `AXI_BV_S11_BY_M2, `AXI_BV_S12_BY_M2, `AXI_BV_S13_BY_M2, `AXI_BV_S14_BY_M2, `AXI_BV_S15_BY_M2, `AXI_BV_S16_BY_M2, `AXI_MAX_RCA_ID_M2, `AXI_MAX_WCA_ID_M2, `AXI_MAX_URIDA_M2, `AXI_MAX_UWIDA_M2, `AXI_LOG2_MAX_RCA_ID_P1_M2, `AXI_LOG2_MAX_WCA_ID_P1_M2, `AXI_LOG2_MAX_URIDA_M2, `AXI_LOG2_MAX_UWIDA_M2, `AXI_RI_LIMIT_M2
,`AXI_AR_LAYER_S0_M2 ,`AXI_AR_LAYER_S1_M2 ,`AXI_AR_LAYER_S2_M2 ,`AXI_AR_LAYER_S3_M2 ,`AXI_AR_LAYER_S4_M2 ,`AXI_AR_LAYER_S5_M2 ,`AXI_AR_LAYER_S6_M2 ,`AXI_AR_LAYER_S7_M2 ,`AXI_AR_LAYER_S8_M2 ,`AXI_AR_LAYER_S9_M2 ,`AXI_AR_LAYER_S10_M2 ,`AXI_AR_LAYER_S11_M2 ,`AXI_AR_LAYER_S12_M2 ,`AXI_AR_LAYER_S13_M2 ,`AXI_AR_LAYER_S14_M2 ,`AXI_AR_LAYER_S15_M2 ,`AXI_AR_LAYER_S16_M2 ,`AXI_AW_LAYER_S0_M2 ,`AXI_AW_LAYER_S1_M2 ,`AXI_AW_LAYER_S2_M2 ,`AXI_AW_LAYER_S3_M2 ,`AXI_AW_LAYER_S4_M2 ,`AXI_AW_LAYER_S5_M2 ,`AXI_AW_LAYER_S6_M2 ,`AXI_AW_LAYER_S7_M2 ,`AXI_AW_LAYER_S8_M2 ,`AXI_AW_LAYER_S9_M2 ,`AXI_AW_LAYER_S10_M2 ,`AXI_AW_LAYER_S11_M2 ,`AXI_AW_LAYER_S12_M2 ,`AXI_AW_LAYER_S13_M2 ,`AXI_AW_LAYER_S14_M2 ,`AXI_AW_LAYER_S15_M2 ,`AXI_AW_LAYER_S16_M2 ,`AXI_W_LAYER_S0_M2 ,`AXI_W_LAYER_S1_M2 ,`AXI_W_LAYER_S2_M2 ,`AXI_W_LAYER_S3_M2 ,`AXI_W_LAYER_S4_M2 ,`AXI_W_LAYER_S5_M2 ,`AXI_W_LAYER_S6_M2 ,`AXI_W_LAYER_S7_M2 ,`AXI_W_LAYER_S8_M2 ,`AXI_W_LAYER_S9_M2 ,`AXI_W_LAYER_S10_M2 ,`AXI_W_LAYER_S11_M2 ,`AXI_W_LAYER_S12_M2 ,`AXI_W_LAYER_S13_M2 ,`AXI_W_LAYER_S14_M2 ,`AXI_W_LAYER_S15_M2 ,`AXI_W_LAYER_S16_M2 ,`AXI_AW_S0_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S1_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S2_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S3_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S4_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S5_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S6_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S7_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S8_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S9_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S10_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S11_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S12_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S13_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S14_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S15_HAS_SHRD_DDCTD_LNK_VAL ,`AXI_AW_S16_HAS_SHRD_DDCTD_LNK_VAL , `AXI_M2_ON_R_SHARED_ONLY_VAL, `AXI_M2_ON_B_SHARED_ONLY_VAL, `ACT_ID_BUF_POINTER_W_AW_M2, `LOG2_ACT_ID_BUF_POINTER_W_AW_M2, `ACT_ID_BUF_POINTER_W_AR_M2, `LOG2_ACT_ID_BUF_POINTER_W_AR_M2
  )

  // spyglass disable_block UndrivenInTerm-ML 
  // SMD: Detects undriven but loaded input terminal of an instance
  // SJ: This warning can be ignored. 
 
  U_DW_axi_mp_m2 (
  // spyglass disable_block W528
  // SMD: A signal or variable is set but never read
  // SJ: This warning can be ignored. 


    .aclk_i                      (aclk),
    .aresetn_i                   (aresetn),
    .r_bus_slv_priorities_i      (r_bus_slv_priorities_m2),
    .b_bus_slv_priorities_i      (b_bus_slv_priorities_m2),

// Read Address Channel
    .arvalid_i                   (arvalid_m2),
    .arpayload_i                 (arpayload_m2),
    .arready_o                   (arready_m2),
    .bus_arready_i               (bus_arready_m2),
    .bus_arvalid_o               (mp_arvalid_m2_q),
    .ar_shrd_ch_req_o            (ar_shrd_ch_req_m2),
    .arpayload_o                 (mp_arpayload_m2),
// Read Data Channel
    .rready_i                    (rready_m2),
    .rvalid_o                    (rvalid_ddctd_m2),
    .rpayload_o                  (rpayload_m2),
    .bus_rvalid_i                (bus_rvalid_m2),
    .bus_rpayload_i              (bus_rpayload_m2),
    .bus_rready_o                (bus_mp_rready_m2),
    .rcpl_tx_shrd_i              (rcpl_tx_shrd_sys_m2),
    .rcpl_id_shrd_i              (rcpl_id_shrd[`AXI_MIDW-1:0]),
// Write Address Channel
    .awvalid_i                   (awvalid_m2),
    .awpayload_i                 (awpayload_m2),
    .awready_o                   (awready_m2),
    .bus_awready_i               (bus_awready_m2),
    .aw_shrd_lyr_granted_s_bus_i (aw_shrd_lyr_granted_m2_s_bus),
    .issued_wtx_shrd_sys_s_bus_i (issued_wtx_shrd_sys_m2_s_bus),
    .bus_awvalid_o               (mp_awvalid_m2_q),
    .aw_shrd_ch_req_o            (aw_shrd_ch_req_m2),
    .awpayload_o                 (mp_awpayload_m2),
// Write Data Channel
    .wvalid_i                    (wvalid_m2),
    .wpayload_i                  (wpayload_m2),
    .wready_o                    (wready_m2),
    .bus_wready_i                (bus_wready_m2),
    .bus_wvalid_o                (mp_wvalid_m2),
    .w_shrd_ch_req_o             (w_shrd_ch_req_m2),
    .wpayload_o                  (mp_wpayload_m2),
//Burst Response Channel
    .bready_i                    (bready_m2),
    .bvalid_o                    (bvalid_ddctd_m2),
    .bpayload_o                  (bpayload_m2),
    .bus_bvalid_i                (bus_bvalid_m2),
    .bus_bpayload_i              (bus_bpayload_m2),
    .bus_bready_o                (bus_mp_bready_m2),
    .wcpl_tx_shrd_i              (wcpl_tx_shrd_sys_m2),
    .has_ar_pending_trans_o      (has_ar_pending_trans_m2),
    .has_aw_pending_trans_o      (has_aw_pending_trans_m2),
    .wcpl_id_shrd_i              (wcpl_id_shrd[`AXI_MIDW-1:0])
  // spyglass enable_block W528
  // spyglass enable_block UndrivenInTerm-ML 
  );
 
assign mp_arvalid_m2 = mp_arvalid_m2_q;
  
 
assign mp_awvalid_m2 = mp_awvalid_m2_q;
  
  

































// ---------------------------------------------------------------------
// To avoid a deadlock condition with shared to dedicated links on the 
// AW channel, when the shared layer is pipelened and also the AW 
// channel has the arbiter pipeline stage enabled, the arb pl internal
// register slice that sits between the shared AW layer and any
// connected dedicatd layers must be unique to each shared to dedicated
// link, as opposed to a common pipeline stage for all shared to
// dedicated links. This prevents a situation where a t/x is accepted
// into the shared layer pipeline, but is blocked from reaching its
// destination by a t/x to a shared to dedicated link. This situation
// introduces the possibility of deadlock on the AW channel, and needs
//  to be prevented.
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
 assign  issued_wtx_shrd_mst_oh_irs_apl_s0 = {`AXI_AW_SHARED_LAYER_NM{1'b0}} ; 
// spyglass enable_block W528
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
 assign  issued_wtx_shrd_mst_oh_irs_apl_s1 = {`AXI_AW_SHARED_LAYER_NM{1'b0}} ; 
// spyglass enable_block W528
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
 assign  issued_wtx_shrd_mst_oh_irs_apl_s2 = {`AXI_AW_SHARED_LAYER_NM{1'b0}} ; 
// spyglass enable_block W528
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
 assign  issued_wtx_shrd_mst_oh_irs_apl_s3 = {`AXI_AW_SHARED_LAYER_NM{1'b0}} ; 
// spyglass enable_block W528
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
 assign  issued_wtx_shrd_mst_oh_irs_apl_s4 = {`AXI_AW_SHARED_LAYER_NM{1'b0}} ; 
// spyglass enable_block W528
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
 assign  issued_wtx_shrd_mst_oh_irs_apl_s5 = {`AXI_AW_SHARED_LAYER_NM{1'b0}} ; 
// spyglass enable_block W528
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
 assign  issued_wtx_shrd_mst_oh_irs_apl_s6 = {`AXI_AW_SHARED_LAYER_NM{1'b0}} ; 
// spyglass enable_block W528
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
 assign  issued_wtx_shrd_mst_oh_irs_apl_s7 = {`AXI_AW_SHARED_LAYER_NM{1'b0}} ; 
// spyglass enable_block W528
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
 assign  issued_wtx_shrd_mst_oh_irs_apl_s8 = {`AXI_AW_SHARED_LAYER_NM{1'b0}} ; 
// spyglass enable_block W528
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
 assign  issued_wtx_shrd_mst_oh_irs_apl_s9 = {`AXI_AW_SHARED_LAYER_NM{1'b0}} ; 
// spyglass enable_block W528
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
 assign  issued_wtx_shrd_mst_oh_irs_apl_s10 = {`AXI_AW_SHARED_LAYER_NM{1'b0}} ; 
// spyglass enable_block W528
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
 assign  issued_wtx_shrd_mst_oh_irs_apl_s11 = {`AXI_AW_SHARED_LAYER_NM{1'b0}} ; 
// spyglass enable_block W528
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
 assign  issued_wtx_shrd_mst_oh_irs_apl_s12 = {`AXI_AW_SHARED_LAYER_NM{1'b0}} ; 
// spyglass enable_block W528
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
 assign  issued_wtx_shrd_mst_oh_irs_apl_s13 = {`AXI_AW_SHARED_LAYER_NM{1'b0}} ; 
// spyglass enable_block W528
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
 assign  issued_wtx_shrd_mst_oh_irs_apl_s14 = {`AXI_AW_SHARED_LAYER_NM{1'b0}} ; 
// spyglass enable_block W528
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
 assign  issued_wtx_shrd_mst_oh_irs_apl_s15 = {`AXI_AW_SHARED_LAYER_NM{1'b0}} ; 
// spyglass enable_block W528
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: This warning can be ignored.
 assign  issued_wtx_shrd_mst_oh_irs_apl_s16 = {`AXI_AW_SHARED_LAYER_NM{1'b0}} ; 
// spyglass enable_block W528

  assign dbg_active_trans = (|bus_awpendtrans[`AXI_NUM_MASTERS-1:0]) | (|bus_arpendtrans[`AXI_NUM_MASTERS-1:0]) | (|bus_awvalid_m[`AXI_NUM_MASTERS-1:0]) | (|bus_arvalid_m[`AXI_NUM_MASTERS-1:0]) ;



  `undef AXI_HAS_S0
  `undef AXI_HAS_S1
  `undef AXI_HAS_M1
  `undef AXI_HAS_M2
  `undef AXI_V_S0_BY_M1
  `undef AXI_V_S0_BY_M2
  `undef AXI_V_S1_BY_M1
  `undef AXI_V_S1_BY_M2
endmodule 