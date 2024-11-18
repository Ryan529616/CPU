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
