`timescale 1ns/1ps

`include "Data_Cache/L1_Data_Cache.v"
`include "Data_Cache/L1_Data_Cache_Controller.v"

`include "Data_Cache/L2_Data_Cache.v"
`include "Data_Cache/L2_Data_Cache_Controller.v"

`include "Data_Cache/L3_Data_Cache.v"
`include "Data_Cache/L3_Data_Cache_Controller.v"

//---------------------------
//  大模組: Cache_Subsystem
//---------------------------
module Data_Cache #(
    // L1 參數
    parameter L1_DATA_LENGTH = 32,
    parameter L1_CACHE_SIZE  = 48 * 1024,
    parameter L1_LINE_SIZE   = 64,
    parameter L1_WAYS        = 12,

    // L2 參數
    parameter L2_DATA_LENGTH = 32,
    parameter L2_CACHE_SIZE  = 1 * 1024 * 1024,  // 1MB
    parameter L2_LINE_SIZE   = 64,
    parameter L2_WAYS        = 16,

    // L3 參數
    parameter L3_DATA_LENGTH = 32,
    parameter L3_CACHE_SIZE  = 8 * 1024 * 1024,  // 8MB
    parameter L3_LINE_SIZE   = 64,
    parameter L3_WAYS        = 16
)(
    input  wire clk,
    input  wire rst,
    input  wire flush,

    //---------------------------------------------
    // 與 CPU 溝通介面 (針對 L1)
    //---------------------------------------------
    // CPU => L1: Load
    input  wire                      cpu_load_valid,
    input  wire [31:0]               cpu_load_addr,
    output wire [L1_DATA_LENGTH-1:0] cpu_load_data_out,
    output wire                      cpu_load_miss_detected,

    // CPU => L1: Store
    input  wire                      cpu_store_valid,
    input  wire [31:0]               cpu_store_addr,
    input  wire [L1_DATA_LENGTH-1:0] cpu_store_data_in,
    output wire                      cpu_store_miss_detected,

    //---------------------------------------------
    // 與 AXI 總線 (DRAM) 溝通介面 (針對 L3)
    //---------------------------------------------
    // AXI Write Address
    output wire                      axi_awvalid,
    input  wire                      axi_awready,
    output wire [31:0]              axi_awaddr,
    // ... 其他 AXI AW channel 信號 (awburst, awsize, awlen) 如需可加
    // AXI Write Data
    output wire                      axi_wvalid,
    input  wire                      axi_wready,
    output wire [L3_LINE_SIZE*8-1:0] axi_wdata,
    output wire [L3_LINE_SIZE-1:0]   axi_wstrb,
    output wire                      axi_wlast,
    // AXI Write Response
    input  wire                      axi_bvalid,
    output wire                      axi_bready,

    // AXI Read Address
    output wire                      axi_arvalid,
    input  wire                      axi_arready,
    output wire [31:0]              axi_araddr,
    // ... 其他 AXI AR channel 信號 (arburst, arsize, arlen) 如需可加
    // AXI Read Data
    input  wire                      axi_rvalid,
    output wire                      axi_rready,
    input  wire [L3_LINE_SIZE*8-1:0] axi_rdata,
    // ... 可能還有 rlast, rid, rresp
    //---------------------------------------------
    // 其他 (可加 flush_done, debug, etc.)
    //---------------------------------------------
    output wire l1_refill_complete,
    output wire l2_refill_complete,
    output wire l3_refill_complete
);

//
//======================================================================
// 1) L1 Cache + Controller
//======================================================================
wire [L1_DATA_LENGTH-1:0] l1_load_data_out;
wire l1_load_miss_detected;
wire l1_store_miss_detected;

wire l1_query_valid;
wire [31:0] l1_query_addr;
wire l1_query_hit;
wire [$clog2(L1_WAYS)-1:0] l1_query_hit_way;
wire [L1_DATA_LENGTH-1:0] l1_query_data_out;

wire l1_do_store;
wire [L1_DATA_LENGTH-1:0] l1_store_data_in;
wire [$clog2(L1_WAYS)-1:0] l1_store_way;
wire [31:0] l1_store_addr;

wire l1_do_update_line;
wire l1_do_update_tag_and_valid;
wire l1_do_clear_dirty;
wire [31:0] l1_update_addr;
wire [L1_LINE_SIZE*8-1:0] l1_update_line_data;
wire [$clog2(L1_WAYS)-1:0] l1_update_way;
wire l1_update_dirty_bit;

// Victim
wire [$clog2(L1_WAYS)-1:0] l1_victim_way;
wire [31:0] l1_victim_addr;
wire [31:0] l1_victim_tag_out;
wire l1_victim_dirty_out;
wire [L1_LINE_SIZE*8-1:0] l1_victim_line_data_out;

// L1 <-> L2 (or Memory) 介面
wire l1_l2_req;
wire l1_l2_we;
wire [31:0] l1_l2_addr;
wire [L1_LINE_SIZE*8-1:0] l1_l2_write_data;
wire [L1_LINE_SIZE*8-1:0] l1_l2_read_data;
wire l1_l2_data_valid;
wire l1_l2_ready;
wire l1_refill_done;

//
// L1_Cache
//
L1_Data_Cache #(
    .DATA_LENGTH(L1_DATA_LENGTH),
    .CACHE_SIZE (L1_CACHE_SIZE),
    .LINE_SIZE  (L1_LINE_SIZE),
    .WAYS       (L1_WAYS)
) u_l1_cache (
    .clk   (clk),
    .rst   (rst),
    .flush (flush),

    // Query
    .query_valid    (l1_query_valid),
    .query_addr     (l1_query_addr),
    .query_data_out (l1_query_data_out),
    .query_hit      (l1_query_hit),
    .query_hit_way  (l1_query_hit_way),

    // store
    .do_store       (l1_do_store),
    .store_data_in  (l1_store_data_in),
    .store_way      (l1_store_way),
    .store_addr     (l1_store_addr),

    // refill / update
    .do_update_line          (l1_do_update_line),
    .do_update_tag_and_valid (l1_do_update_tag_and_valid),
    .do_clear_dirty          (l1_do_clear_dirty),
    .update_addr             (l1_update_addr),
    .update_line_data        (l1_update_line_data),
    .update_way              (l1_update_way),
    .update_dirty_bit        (l1_update_dirty_bit),

    // debug(可省)
    .valid_per_way   (),
    .dirty_per_way   (),
    .dbg_current_tag (),
    .dbg_current_data(),

    // Victim
    .victim_way            (l1_victim_way),
    .victim_addr           (l1_victim_addr),
    .victim_tag_out        (l1_victim_tag_out),
    .victim_dirty_out      (l1_victim_dirty_out),
    .victim_line_data_out  (l1_victim_line_data_out)
);

//
// L1_Cache_Controller
//
L1_Data_Cache_Controller #(
    .DATA_LENGTH(L1_DATA_LENGTH),
    .CACHE_SIZE (L1_CACHE_SIZE),
    .LINE_SIZE  (L1_LINE_SIZE),
    .WAYS       (L1_WAYS)
) u_l1_ctl (
    .clk   (clk),
    .rst   (rst),
    .flush (flush),

    // CPU介面
    .load_valid        (cpu_load_valid),
    .load_addr         (cpu_load_addr),
    .load_data_out     (l1_load_data_out),
    .load_miss_detected(l1_load_miss_detected),

    .store_valid        (cpu_store_valid),
    .store_addr         (cpu_store_addr),
    .store_data_in      (cpu_store_data_in),
    .store_miss_detected(l1_store_miss_detected),

    // L2 (Memory) 介面
    .l2_req       (l1_l2_req),
    .l2_we        (l1_l2_we),
    .l2_addr      (l1_l2_addr),
    .l2_write_data(l1_l2_write_data),
    .l2_read_data (l1_l2_read_data),
    .l2_data_valid(l1_l2_data_valid),
    .l2_ready     (l1_l2_ready),
    .refill_complete(l1_refill_done),

    // 與 L1 Cache
    .cache_query_valid   (l1_query_valid),
    .cache_query_addr    (l1_query_addr),
    .cache_query_hit     (l1_query_hit),
    .cache_query_hit_way (l1_query_hit_way),
    .cache_query_data_out(l1_query_data_out),

    .cache_do_store      (l1_do_store),
    .cache_store_data_in (l1_store_data_in),
    .cache_store_way     (l1_store_way),
    .cache_store_addr    (l1_store_addr),

    .cache_do_update_line         (l1_do_update_line),
    .cache_do_update_tag_and_valid(l1_do_update_tag_and_valid),
    .cache_do_clear_dirty         (l1_do_clear_dirty),
    .cache_update_addr            (l1_update_addr),
    .cache_update_line_data       (l1_update_line_data),
    .cache_update_way             (l1_update_way),
    .cache_update_dirty_bit       (l1_update_dirty_bit),

    .cache_victim_way       (l1_victim_way),
    .cache_victim_addr      (l1_victim_addr),
    .cache_victim_tag_out   (l1_victim_tag_out),
    .cache_victim_dirty_out (l1_victim_dirty_out),
    .cache_victim_line_data_out (l1_victim_line_data_out)
);

// 把 L1 結果接回 CPU
assign cpu_load_data_out      = l1_load_data_out;
assign cpu_load_miss_detected = l1_load_miss_detected;
assign cpu_store_miss_detected= l1_store_miss_detected;
assign l1_refill_complete     = l1_refill_done;

//
//======================================================================
// 2) L2 Cache + Controller
//======================================================================
// L2 <-> L1 介面(從 L1 的 l2_req => L2的 "上層req")
wire l2_load_valid;
wire [31:0] l2_load_addr;
wire [L2_DATA_LENGTH-1:0] l2_load_data_out;
wire l2_load_miss_detected;

wire l2_store_valid;
wire [31:0] l2_store_addr;
wire [L2_DATA_LENGTH-1:0] l2_store_data_in;
wire l2_store_miss_detected;

// L2 Query
wire l2_query_valid;
wire [31:0] l2_query_addr;
wire l2_query_hit;
wire [$clog2(L2_WAYS)-1:0] l2_query_hit_way;
wire [L2_DATA_LENGTH-1:0]  l2_query_data_out;

// L2 refill etc.
wire l2_do_store;
wire [L2_DATA_LENGTH-1:0] l2_store_data_in_;
wire [$clog2(L2_WAYS)-1:0]l2_store_way_;
wire [31:0] l2_store_addr_;

wire l2_do_update_line;
wire l2_do_update_tag_and_valid;
wire l2_do_clear_dirty;
wire [31:0] l2_update_addr;
wire [L2_LINE_SIZE*8-1:0] l2_update_line_data;
wire [$clog2(L2_WAYS)-1:0] l2_update_way;
wire l2_update_dirty_bit;

// Victim
wire [$clog2(L2_WAYS)-1:0] l2_victim_way;
wire [31:0] l2_victim_addr;
wire [31:0] l2_victim_tag_out;
wire l2_victim_dirty_out;
wire [L2_LINE_SIZE*8-1:0] l2_victim_line_data_out;

// L2 <-> L3
wire l2_mem_req;
wire l2_mem_we;
wire [31:0] l2_mem_addr;
wire [L2_LINE_SIZE*8-1:0] l2_mem_write_data;
wire [L2_LINE_SIZE*8-1:0] l2_mem_read_data;
wire l2_mem_data_valid;
wire l2_mem_ready;
wire l2_refill_done;

//-------------------------------------
// 把 L1對下層( l1_l2_req ) 轉成 "CPU -> L2" load/store
// 這個做法是簡化：只要看到 l1_l2_req=1 / l1_l2_we=0 => load_valid=1
// l1_l2_req=1 / l1_l2_we=1 => store_valid=1
// (實際上你可以再做仲裁 or handshake 機制)
//-------------------------------------
assign l2_load_valid     = (l1_l2_req && !l1_l2_we);
assign l2_load_addr      = l1_l2_addr;
assign l2_store_valid    = (l1_l2_req &&  l1_l2_we);
assign l2_store_addr     = l1_l2_addr;
assign l2_store_data_in  = l1_l2_write_data[31:0]; // 只示範word store, 或整行?

// 連回 l2_l1_read_data, l2_data_valid
// 這裡要在 L2 Controller refill完後把 data => l1_l2_read_data
// 這裡簡化：當 L2 refill完成，就給 l1_l2_data_valid=1 + l1_l2_read_data
// (實作看下面 L2->L3, 之後 L2 fill => l1 refill)

// L2_Cache
L2_Data_Cache #(
    .DATA_LENGTH(L2_DATA_LENGTH),
    .CACHE_SIZE (L2_CACHE_SIZE),
    .LINE_SIZE  (L2_LINE_SIZE),
    .WAYS       (L2_WAYS)
) u_l2_cache (
    .clk    (clk),
    .rst    (rst),
    .flush  (flush),

    .query_valid        (l2_query_valid),
    .query_addr         (l2_query_addr),
    .query_data_out     (l2_query_data_out),
    .query_hit          (l2_query_hit),
    .query_hit_way      (l2_query_hit_way),

    .do_store           (l2_do_store),
    .store_data_in      (l2_store_data_in_),
    .store_way          (l2_store_way_),
    .store_addr         (l2_store_addr_),

    .do_update_line          (l2_do_update_line),
    .do_update_tag_and_valid (l2_do_update_tag_and_valid),
    .do_clear_dirty          (l2_do_clear_dirty),
    .update_addr             (l2_update_addr),
    .update_line_data        (l2_update_line_data),
    .update_way              (l2_update_way),
    .update_dirty_bit        (l2_update_dirty_bit),

    .valid_per_way(),
    .dirty_per_way(),
    .dbg_current_tag(),
    .dbg_current_data(),

    .victim_way             (l2_victim_way),
    .victim_addr            (l2_victim_addr),
    .victim_tag_out         (l2_victim_tag_out),
    .victim_dirty_out       (l2_victim_dirty_out),
    .victim_line_data_out   (l2_victim_line_data_out)
);

L2_Data_Cache_Controller #(
    .DATA_LENGTH(L2_DATA_LENGTH),
    .CACHE_SIZE (L2_CACHE_SIZE),
    .LINE_SIZE  (L2_LINE_SIZE),
    .WAYS       (L2_WAYS)
) u_l2_ctl (
    .clk   (clk),
    .rst   (rst),
    .flush (flush),

    // 上層 => L2
    .load_valid        (l2_load_valid),
    .load_addr         (l2_load_addr),
    .load_data_out     (l2_load_data_out),
    .load_miss_detected(l2_load_miss_detected),

    .store_valid       (l2_store_valid),
    .store_addr        (l2_store_addr),
    .store_data_in     (l2_store_data_in),
    .store_miss_detected(l2_store_miss_detected),

    // Memory(其實連到 L3) 介面
    .mem_req           (l2_mem_req),
    .mem_we            (l2_mem_we),
    .mem_addr          (l2_mem_addr),
    .mem_write_data    (l2_mem_write_data),
    .mem_read_data     (l2_mem_read_data),
    .mem_data_valid    (l2_mem_data_valid),
    .mem_ready         (l2_mem_ready),
    .refill_complete   (l2_refill_done),

    // 與 L2 Cache 連線
    .cache_query_valid     (l2_query_valid),
    .cache_query_addr      (l2_query_addr),
    .cache_query_hit       (l2_query_hit),
    .cache_query_hit_way   (l2_query_hit_way),
    .cache_query_data_out  (l2_query_data_out),

    .cache_do_store        (l2_do_store),
    .cache_store_data_in   (l2_store_data_in_),
    .cache_store_way       (l2_store_way_),
    .cache_store_addr      (l2_store_addr_),

    .cache_do_update_line          (l2_do_update_line),
    .cache_do_update_tag_and_valid (l2_do_update_tag_and_valid),
    .cache_do_clear_dirty          (l2_do_clear_dirty),
    .cache_update_addr             (l2_update_addr),
    .cache_update_line_data        (l2_update_line_data),
    .cache_update_way              (l2_update_way),
    .cache_update_dirty_bit        (l2_update_dirty_bit),

    .cache_victim_way       (l2_victim_way),
    .cache_victim_addr      (l2_victim_addr),
    .cache_victim_tag_out   (l2_victim_tag_out),
    .cache_victim_dirty_out (l2_victim_dirty_out),
    .cache_victim_line_data_out (l2_victim_line_data_out)
);

// 當 L2 refill完成 → 代表有資料給 L1
// 簡化：把 l2_load_data_out => l1_l2_read_data
// 你也可以在 L2 Controller store_miss / load_miss refill lines => 
//   next cycle => l1_l2_data_valid=1, l1_l2_read_data=...
assign l1_l2_ready      = 1'b1; // simplified
assign l1_l2_data_valid = (l2_load_miss_detected || l2_store_miss_detected)
                          ? l2_refill_done : 1'b0;

// 這裡示範只回傳一個 word from L2 => L1
assign l1_l2_read_data  = { { (L1_LINE_SIZE*8 - 32){1'b0} }, l2_load_data_out };

// or 你也可把 l2_cache 整行讀出 => l1_l2_read_data

assign l2_refill_complete = l2_refill_done;  // debug
//
//======================================================================
// 3) L3 Cache + Controller (AXI Master)
//======================================================================
wire l3_load_valid;
wire [31:0] l3_load_addr;
wire [L3_DATA_LENGTH-1:0] l3_load_data_out;
wire l3_load_miss_detected;

wire l3_store_valid;
wire [31:0] l3_store_addr;
wire [L3_DATA_LENGTH-1:0] l3_store_data_in;
wire l3_store_miss_detected;

// L3 query
wire l3_query_valid;
wire [31:0] l3_query_addr;
wire l3_query_hit;
wire [$clog2(L3_WAYS)-1:0] l3_query_hit_way;
wire [L3_DATA_LENGTH-1:0]  l3_query_data_out;
wire l3_do_store;
wire [L3_DATA_LENGTH-1:0] l3_store_data_in_;
wire [$clog2(L3_WAYS)-1:0]l3_store_way_;
wire [31:0] l3_store_addr_;

wire l3_do_update_line;
wire l3_do_update_tag_and_valid;
wire l3_do_clear_dirty;
wire [31:0] l3_update_addr;
wire [L3_LINE_SIZE*8-1:0] l3_update_line_data;
wire [$clog2(L3_WAYS)-1:0] l3_update_way;
wire l3_update_dirty_bit;

// Victim
wire [$clog2(L3_WAYS)-1:0] l3_victim_way;
wire [31:0] l3_victim_addr;
wire [31:0] l3_victim_tag_out;
wire l3_victim_dirty_out;
wire [L3_LINE_SIZE*8-1:0] l3_victim_line_data_out;

wire l3_mem_req;        // => AXI AW/AR
wire l3_mem_we;         
wire [31:0] l3_mem_addr;
wire [L3_LINE_SIZE*8-1:0] l3_mem_write_data;
wire [L3_LINE_SIZE*8-1:0] l3_mem_read_data;
wire l3_mem_data_valid;
wire l3_mem_ready;
wire l3_refill_done;

//-------------------------------------
// L2 -> L3
//-------------------------------------
assign l3_load_valid = (l2_mem_req && !l2_mem_we);
assign l3_load_addr  = l2_mem_addr;
assign l3_store_valid= (l2_mem_req &&  l2_mem_we);
assign l3_store_addr = l2_mem_addr;
assign l3_store_data_in = l2_mem_write_data[31:0]; // 只示範word

// L3_Cache
L3_Data_Cache #(
    .DATA_LENGTH(L3_DATA_LENGTH),
    .CACHE_SIZE (L3_CACHE_SIZE),
    .LINE_SIZE  (L3_LINE_SIZE),
    .WAYS       (L3_WAYS)
) u_l3_cache (
    .clk    (clk),
    .rst    (rst),
    .flush  (flush),

    .query_valid    (l3_query_valid),
    .query_addr     (l3_query_addr),
    .query_data_out (l3_query_data_out),
    .query_hit      (l3_query_hit),
    .query_hit_way  (l3_query_hit_way),

    .do_store       (l3_do_store),
    .store_data_in  (l3_store_data_in_),
    .store_way      (l3_store_way_),
    .store_addr     (l3_store_addr_),

    .do_update_line          (l3_do_update_line),
    .do_update_tag_and_valid (l3_do_update_tag_and_valid),
    .do_clear_dirty          (l3_do_clear_dirty),
    .update_addr             (l3_update_addr),
    .update_line_data        (l3_update_line_data),
    .update_way              (l3_update_way),
    .update_dirty_bit        (l3_update_dirty_bit),

    // debug(省略)
    .valid_per_way   (),
    .dirty_per_way   (),
    .dbg_current_tag (),
    .dbg_current_data(),

    // Victim
    .victim_way             (l3_victim_way),
    .victim_addr            (l3_victim_addr),
    .victim_tag_out         (l3_victim_tag_out),
    .victim_dirty_out       (l3_victim_dirty_out),
    .victim_line_data_out   (l3_victim_line_data_out)
);

L3_Data_Cache_Controller #(
    .DATA_LENGTH(L3_DATA_LENGTH),
    .CACHE_SIZE (L3_CACHE_SIZE),
    .LINE_SIZE  (L3_LINE_SIZE),
    .WAYS       (L3_WAYS)
) u_l3_ctl (
    .clk   (clk),
    .rst   (rst),
    .flush (flush),

    // 上層 => L3
    .load_valid        (l3_load_valid),
    .load_addr         (l3_load_addr),
    .load_data_out     (l3_load_data_out),
    .load_miss_detected(l3_load_miss_detected),

    .store_valid       (l3_store_valid),
    .store_addr        (l3_store_addr),
    .store_data_in     (l3_store_data_in),
    .store_miss_detected(l3_store_miss_detected),

    // AXI介面
    .axi_awvalid (axi_awvalid),
    .axi_awready (axi_awready),
    .axi_awaddr  (axi_awaddr),
    // ... 其他 AW
    .axi_wvalid  (axi_wvalid),
    .axi_wready  (axi_wready),
    .axi_wdata   (axi_wdata),
    .axi_wstrb   (axi_wstrb),
    .axi_wlast   (axi_wlast),
    .axi_bvalid  (axi_bvalid),
    .axi_bready  (axi_bready),

    .axi_arvalid (axi_arvalid),
    .axi_arready (axi_arready),
    .axi_araddr  (axi_araddr),
    .axi_rvalid  (axi_rvalid),
    .axi_rready  (axi_rready),
    .axi_rdata   (axi_rdata),
    // ... 其他 R

    .refill_complete(l3_refill_done),

    // 與 L3_Cache
    .cache_query_valid   (l3_query_valid),
    .cache_query_addr    (l3_query_addr),
    .cache_query_hit     (l3_query_hit),
    .cache_query_hit_way (l3_query_hit_way),
    .cache_query_data_out(l3_query_data_out),

    .cache_do_store      (l3_do_store),
    .cache_store_data_in (l3_store_data_in_),
    .cache_store_way     (l3_store_way_),
    .cache_store_addr    (l3_store_addr_),

    .cache_do_update_line         (l3_do_update_line),
    .cache_do_update_tag_and_valid(l3_do_update_tag_and_valid),
    .cache_do_clear_dirty         (l3_do_clear_dirty),
    .cache_update_addr            (l3_update_addr),
    .cache_update_line_data       (l3_update_line_data),
    .cache_update_way             (l3_update_way),
    .cache_update_dirty_bit       (l3_update_dirty_bit),

    .cache_victim_way      (l3_victim_way),
    .cache_victim_addr     (l3_victim_addr),
    .cache_victim_tag_out  (l3_victim_tag_out),
    .cache_victim_dirty_out(l3_victim_dirty_out),
    .cache_victim_line_data_out(l3_victim_line_data_out)
);

// 將 L3 refill 完成後的資料回傳給 L2 
assign l2_mem_ready      = 1'b1;   // simplified
assign l2_mem_data_valid = (l3_load_miss_detected || l3_store_miss_detected) 
                           ? l3_refill_done : 1'b0;
// 同理 l2_mem_read_data = l3_load_data_out(簡化)
assign l2_mem_read_data  = { {(L2_LINE_SIZE*8 - 32){1'b0}}, l3_load_data_out };

// 最終給頂層輸出
assign l3_refill_complete = l3_refill_done;

// 其餘: l2_refill_complete = l2_refill_done  (若需要可接出)
//        l1_refill_complete = l1_refill_done
assign l2_refill_complete = l2_refill_done;
assign l1_refill_complete = l1_refill_done;

endmodule
