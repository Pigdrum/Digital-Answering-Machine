set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {people[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {people[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {people[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {people[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_en[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_en[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_en[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_en[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_en[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_en[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_en[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_en[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_out[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_out[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_out[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_out[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports host]
set_property IOSTANDARD LVCMOS33 [get_ports isRight]
set_property IOSTANDARD LVCMOS33 [get_ports isWrong]
set_property IOSTANDARD LVCMOS33 [get_ports ring]

#每个选手开关上面对应位置
set_property PACKAGE_PIN L13 [get_ports {led[3]}]
set_property PACKAGE_PIN M13 [get_ports {led[2]}]
set_property PACKAGE_PIN K14 [get_ports {led[1]}]
set_property PACKAGE_PIN K13 [get_ports {led[0]}]
#3-0从左到右，第二个开关开始
set_property PACKAGE_PIN W9 [get_ports {people[3]}]
set_property PACKAGE_PIN Y7 [get_ports {people[2]}]
set_property PACKAGE_PIN Y8 [get_ports {people[1]}]
set_property PACKAGE_PIN AB8 [get_ports {people[0]}]

#七段数码管使能
set_property PACKAGE_PIN A18 [get_ports {seg_en[0]}]
set_property PACKAGE_PIN A20 [get_ports {seg_en[1]}]
set_property PACKAGE_PIN B20 [get_ports {seg_en[2]}]
set_property PACKAGE_PIN E18 [get_ports {seg_en[3]}]
set_property PACKAGE_PIN F18 [get_ports {seg_en[4]}]
set_property PACKAGE_PIN D19 [get_ports {seg_en[5]}]
set_property PACKAGE_PIN E19 [get_ports {seg_en[6]}]
set_property PACKAGE_PIN C19 [get_ports {seg_en[7]}]

#七段数码管显示
set_property PACKAGE_PIN E13 [get_ports {seg_out[7]}]
set_property PACKAGE_PIN C15 [get_ports {seg_out[6]}]
set_property PACKAGE_PIN C14 [get_ports {seg_out[5]}]
set_property PACKAGE_PIN E17 [get_ports {seg_out[4]}]
set_property PACKAGE_PIN F16 [get_ports {seg_out[3]}]
set_property PACKAGE_PIN F14 [get_ports {seg_out[2]}]
set_property PACKAGE_PIN F13 [get_ports {seg_out[1]}]
set_property PACKAGE_PIN F15 [get_ports {seg_out[0]}]

#蜂鸣器
set_property PACKAGE_PIN A19 [get_ports ring]

#系统时钟
set_property PACKAGE_PIN Y18 [get_ports clk]

#主持人开关，右边第3个
set_property PACKAGE_PIN T4 [get_ports host]
#正确判定，右边第二个
set_property PACKAGE_PIN R4 [get_ports isRight]
#错误判定，右边第一个
set_property PACKAGE_PIN W4 [get_ports isWrong]

#复核开关，右边第5个
set_property PACKAGE_PIN U5 [get_ports reviewButton]
set_property IOSTANDARD LVCMOS33 [get_ports reviewButton]

#用于使用矩阵键盘：
set_property IOSTANDARD LVCMOS33 [get_ports {col[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {col[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {col[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {col[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {row[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {row[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {row[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {row[0]}]
set_property PACKAGE_PIN K4 [get_ports {row[0]}]
set_property PACKAGE_PIN J4 [get_ports {row[1]}]
set_property PACKAGE_PIN L3 [get_ports {row[2]}]
set_property PACKAGE_PIN K3 [get_ports {row[3]}]
set_property PACKAGE_PIN M2 [get_ports {col[0]}]
set_property PACKAGE_PIN K6 [get_ports {col[1]}]
set_property PACKAGE_PIN J6 [get_ports {col[2]}]
set_property PACKAGE_PIN L5 [get_ports {col[3]}]

#复位开关，右边第4个
set_property IOSTANDARD LVCMOS33 [get_ports resetButton]
set_property PACKAGE_PIN T5 [get_ports resetButton]


