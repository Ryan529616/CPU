module Stall_Control_Unit (
    input  wire icache_stall,
    input  wire dcache_stall,
    output wire stall
);
    assign stall = icache_stall | dcache_stall;
    
endmodule