<<<<<<< HEAD
# 設置工作路徑
define_design_lib WORK -path ./work

# 設置設計名稱
set my_design Top

# 設置標準單元庫
set target_library "/home/summer/library/SAED/14/stdcell_rvt/db_ccs/saed14rvt_tt0p8v25c.db \
                   /home/summer/library/SAED/14/stdcell_rvt/db_ccs/saed14rvt_ss0p72vm40c.db \
                   /home/summer/library/SAED/14/stdcell_rvt/db_ccs/saed14rvt_ff0p88v125c.db \
                   /home/summer/library/SAED/14/io/lib/io_std/db_ccs/saed14io_fc_tt0p8v25c_1p8v.db \
                   /home/summer/library/SAED/14/io/lib/io_std/db_ccs/saed14io_wb_tt0p8v25c_1p8v.db \
                   /home/summer/library/SAED/14/io/lib/io_std/db_ccs/saed14io_fc_ss0p72vm40c_1p62v.db \
                   /home/summer/library/SAED/14/io/lib/io_std/db_ccs/saed14io_wb_ss0p72vm40c_1p62v.db \
                   /home/summer/library/SAED/14/io/lib/io_std/db_ccs/saed14io_fc_ff0p88v125c_1p96v.db \
                   /home/summer/library/SAED/14/io/lib/io_std/db_ccs/saed14io_wb_ff0p88v125c_1p96v.db \
                   /home/summer/library/SAED/14/sram/lib/sram/logic_synth/dual/saed14sram_tt0p8v25c.db \
                   /home/summer/library/SAED/14/sram/lib/sram/logic_synth/dual/saed14sram_ss0p72vm40c.db \
                   /home/summer/library/SAED/14/sram/lib/sram/logic_synth/dual/saed14sram_ff0p88v125c.db \
                   /home/summer/library/SAED/14/pll/lib/logic_synth/saed14pll_tt0p8v25c.db \
                   /home/summer/library/SAED/14/pll/lib/logic_synth/saed14pll_ss0p72vm40c.db \
                   /home/summer/library/SAED/14/pll/lib/logic_synth/saed14pll_ff0p88v125c.db"
set link_library "* /home/summer/library/SAED/14/stdcell_rvt/db_ccs/saed14rvt_tt0p8v25c.db"


# 設置工作目錄
set search_path "./src"

# 讀取RTL源文件
analyze -format verilog {Top.v}

# 對源文件進行編譯
elaborate $my_design

# 讀取設計約束 (SDC) 文件
source ./constraints/DC.sdc

# 設置輸出目錄
set output_directory ./netlist

# 進行設計綜合
compile -map_effort high


# 輸出結果
write -format verilog -hierarchy -output $output_directory/${my_design}_netlist.v
write_sdc $output_directory/${my_design}.sdc
report_timing > ./reports/timing_report.rpt
report_area > ./reports/area_report.rpt
report_power > ./reports/power_report.rpt
report_clocks > ./reports/clock_report.rpt
report_reference > ./reports/reference_report.rpt

# 動態時序分析 (STA)
# 如果有需求，動態時序分析可以在此進行 (使用PrimeTime等工具)

# 形式驗證 (可選)
# 如果需要形式驗證，請使用 Synopsys Formality 或其他工具

# DRC/LVS 檢查 (可選)
# 在完成設計綜合後，進行DRC和LVS檢查，確保設計符合製造規則並與電路圖保持一致
=======
set target_library "
                    /home/summer/cell_library/SAED/14/stdcell_rvt/db_ccs/saed14rvt_tt0p8v125c.db \
                    /home/summer/cell_library/SAED/14/stdcell_rvt/db_ccs/saed14rvt_tt0p8v25c.db \
                    /home/summer/cell_library/SAED/14/stdcell_rvt/db_ccs/saed14rvt_tt0p6v25c.db \
                    /home/summer/cell_library/SAED/14/stdcell_rvt/db_ccs/saed14rvt_tt0p6vm40c.db \
                    /home/summer/cell_library/SAED/14/stdcell_rvt/db_ccs/saed14rvt_tt0p8vm40c.db \
                    /home/summer/cell_library/SAED/14/stdcell_rvt/db_ccs/saed14rvt_tt0p6v125c.db \
                    /home/summer/cell_library/SAED/14/stdcell_rvt/db_ccs/saed14rvt_ff0p7vm40c.db \
                    /home/summer/cell_library/SAED/14/stdcell_rvt/db_ccs/saed14rvt_ff0p88v25c.db \
                    /home/summer/cell_library/SAED/14/stdcell_rvt/db_ccs/saed14rvt_ff0p88vm40c.db \
                    /home/summer/cell_library/SAED/14/stdcell_rvt/db_ccs/saed14rvt_ff0p7v25c.db \
                    /home/summer/cell_library/SAED/14/stdcell_rvt/db_ccs/saed14rvt_ff0p88v125c.db \
                    /home/summer/cell_library/SAED/14/stdcell_rvt/db_ccs/saed14rvt_ff0p7v125c.db \
                    /home/summer/cell_library/SAED/14/stdcell_rvt/db_ccs/saed14rvt_ss0p6vm40c.db \
                    /home/summer/cell_library/SAED/14/stdcell_rvt/db_ccs/saed14rvt_ss0p72v25c.db \
                    /home/summer/cell_library/SAED/14/stdcell_rvt/db_ccs/saed14rvt_ss0p6v125c.db \
                    /home/summer/cell_library/SAED/14/stdcell_rvt/db_ccs/saed14rvt_ss0p72vm40c.db \
                    /home/summer/cell_library/SAED/14/stdcell_rvt/db_ccs/saed14rvt_ss0p6v25c.db \
                    /home/summer/cell_library/SAED/14/stdcell_rvt/db_ccs/saed14rvt_ss0p72v125c.db \
                    /home/summer/cell_library/SAED/14/io/lib/io_std/db_ccs/saed14io_fc_ss0p72v125c_1p62v.db \
                    /home/summer/cell_library/SAED/14/io/lib/io_std/db_ccs/saed14io_fc_ff0p88v25c_1p96v.db \
                    /home/summer/cell_library/SAED/14/io/lib/io_std/db_ccs/saed14io_fc_ss0p72vm40c_1p62v.db \
                    /home/summer/cell_library/SAED/14/io/lib/io_std/db_ccs/saed14io_fc_tt0p8vm40c_1p8v.db \
                    /home/summer/cell_library/SAED/14/io/lib/io_std/db_ccs/saed14io_fc_ss0p72v25c_1p62v.db \
                    /home/summer/cell_library/SAED/14/io/lib/io_std/db_ccs/saed14io_fc_tt0p8v125c_1p8v.db \
                    /home/summer/cell_library/SAED/14/io/lib/io_std/db_ccs/saed14io_fc_ff0p88v125c_1p96v.db \
                    /home/summer/cell_library/SAED/14/io/lib/io_std/db_ccs/saed14io_fc_ff0p88vm40c_1p96v.db \
                    /home/summer/cell_library/SAED/14/io/lib/io_std/db_ccs/saed14io_fc_tt0p8v25c_1p8v.db \
                    /home/summer/cell_library/SAED/14/sram/lib/sram/logic_synth/dual/saed14sram_tt0p8v25c.db \
                    /home/summer/cell_library/SAED/14/sram/lib/sram/logic_synth/dual/saed14sram_ss0p72vm40c.db \
                    /home/summer/cell_library/SAED/14/sram/lib/sram/logic_synth/dual/saed14sram_ff0p88v125c.db \
                    /home/summer/cell_library/SAED/14/pll/lib/logic_synth/saed14pll_tt0p8v25c.db \
                    /home/summer/cell_library/SAED/14/pll/lib/logic_synth/saed14pll_ss0p72vm40c.db \
                    /home/summer/cell_library/SAED/14/pll/lib/logic_synth/saed14pll_ff0p88v125c.db"
set link_library "* $target_library dw_foundation.sldb"
set symbol_library    "generic.sdb"
set synthetic_library "dw_foundation.sldb"
set case_analysis_with_logic_constants true
set hdlin_translate_off_skip_text "TRUE"
set edifout_netlist_only "TRUE"
set verilogout_no_tri true
set_host_options -max_cores 16
history keep 100
alias h history

#setup the design library
define_design_lib work -path ../work
analyze -f verilog -library work -format verilog ../src/Top.v
elaborate Top -architecture verilog -library work


#setup design environment
set_operating_conditions -min_library saed14rvt_ff0p88v125c -min ff0p88v125c  -max_library saed14rvt_ss0p6vm40c -max ss0p6vm40c
remove_wire_load_model
#set_leakage_optimization true
#set_attribute [get_libs typical.db:typical] default_threshold_voltage_group LVt -type string

set clock_period 1.5
#setup timing constraints
create_clock -name clk -period $clock_period [get_ports clk]
set_fix_hold [get_clocks clk]
set_dont_touch_network [get_clocks clk]
set_ideal_network [get_clocks clk]
set_clock_uncertainty 0.01 [get_clocks clk]
set all_inputs_except_clk_rst [remove_from_collection [all_inputs] [get_ports {clk rst}]]
set_input_delay -clock clk -max 0.05 $all_inputs_except_clk_rst
set_output_delay -clock clk -max 0.05 [all_outputs]


#compile the design
set compile_enable_ccd true
compile_ultra -retime -timing_high_effort_script
#compile_ultra -incremental -retime

#write the design
change_names  -hierarchy -rules verilog
define_name_rules -case_insensitive
define_name_rules name_rule -case_insensitive
change_names -hierarchy -rules name_rule
write_file -format verilog -hier -o ../netlist/CPU.v
write_sdc ../constraint/CPU.sdc
write_sdf -version 2.1 ../syn/CPU.sdf
write -hierarchy -format ddc

report_timing > ../reports/timing_report.rpt
report_area > ../reports/area_report.rpt
report_power > ../reports/power_report.rpt
report_clocks > ../reports/clock_report.rpt
report_reference > ../reports/reference_report.rpt
>>>>>>> bdb7ead (2024/12/8)
