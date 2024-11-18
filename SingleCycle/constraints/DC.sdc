# 設置時鐘
# 創建一個名為 'clk' 的時鐘，週期為 10ns（100MHz）
create_clock -name clk -period 1 [get_ports clk]

# 設置時鐘不確定性（Clock Uncertainty）
# 這是考慮時鐘抖動和其他不確定因素的時間裕量
set_clock_uncertainty 0.05 [get_clocks clk]

# 設置時鐘延遲（Clock Latency）
# 包含時鐘分佈網路的延遲
set_clock_latency 0.1 [get_clocks clk]

# 設置輸入延遲（Input Delay）
# 設置輸入端口相對於時鐘的延遲
set_input_delay 0.2 -clock clk [all_inputs]

# 設置輸出延遲（Output Delay）
# 設置輸出端口相對於時鐘的延遲
#set_output_delay 0.2 -clock clk [all_outputs]

# 設置操作條件（Operating Conditions）
# 設置最小和最大操作條件，指定對應的製程角度和環境條件
set_operating_conditions -min_library saed14rvt_tt0p8v25c -min tt0p8v25c  -max_library saed14rvt_tt0p8v25c -max tt0p8v25c


# 設置線路負載模型（Wire Load Model）
# 使用在設計中的線路負載模型
set_wire_load_model -name "tc8000" -library "saed14rvt_tt0p8v25c"

# 設置多循環路徑（Multicycle Path）
# 如果某些路徑需要多個時鐘週期來完成，設置多循環路徑
# 在這個簡單設計中可能不需要，但如果需要可以這樣設置
# set_multicycle_path 2 -setup -from [get_clocks clk] -to [get_clocks clk]
# set_multicycle_path 1 -hold -from [get_clocks clk] -to [get_clocks clk]

# 設置假設路徑（False Paths）
# 如果某些路徑不需要進行時序分析，設置為假設路徑
# set_false_path -from [get_ports rst] -to [get_ports count]

# 設置最大扇出（Max Fanout）
# 限制輸入信號的最大扇出數量
set_max_fanout 20 [all_inputs]

# 設置最大/最小延遲（Max/Min Delay）
# 設置某些關鍵路徑的最大或最小延遲
# set_max_delay 5.0 -from [get_ports rst] -to [get_ports count]
# set_min_delay 1.0 -from [get_ports rst] -to [get_ports count]

# 設置時鐘分區（Clock Groups）
# 如果設計有多個時鐘域且不需要同步，設置時鐘分區
# set_clock_groups -asynchronous -group [get_clocks clk] -group [get_clocks clk2]

# 禁止某些單元或網絡（Dont Touch）
# 保護設計中的特定網絡或單元不被綜合工具優化
set_dont_touch_network [get_clocks clk]
# set_dont_touch [get_cells critical_cell]

# 設置時序例外（Timing Exceptions）
# 如果有特定的時序要求，可以設置例外情況
# set_case_analysis 0 [get_ports mode_select]
