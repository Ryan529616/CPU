###################################################################

# Created by write_sdc on Thu Aug 29 03:19:14 2024

###################################################################
set sdc_version 2.1

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current uA
set_operating_conditions tt0p8v25c -library saed14rvt_tt0p8v25c
set_wire_load_model -name tc8000 -library saed14rvt_tt0p8v25c
set_max_fanout 20 [get_ports clk]
set_max_fanout 20 [get_ports rst]
create_clock [get_ports clk]  -period 1  -waveform {0 0.5}
set_clock_latency 0.1  [get_clocks clk]
set_clock_uncertainty 0.05  [get_clocks clk]
set_input_delay -clock clk  0.2  [get_ports clk]
set_input_delay -clock clk  0.2  [get_ports rst]
