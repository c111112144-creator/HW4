## ===============================
## EGO-XZ7 VGA 螢幕輸出 (640x480@60Hz)
## 對應 vga_triangle.vhd
## ===============================

## -------- 系統時鐘 100 MHz --------
set_property PACKAGE_PIN Y9 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name clk -waveform {0 5} [get_ports clk]

## -------- 重設按鈕 (低有效, BTNC) --------
set_property PACKAGE_PIN F22 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

## -------- VGA 訊號輸出 (使用 PMOD JE, Bank 35, 3.3V) --------
## R[2:0]
set_property PACKAGE_PIN U4 [get_ports {vga_r[2]}]
set_property PACKAGE_PIN T6 [get_ports {vga_r[1]}]
set_property PACKAGE_PIN R6 [get_ports {vga_r[0]}]

## G[2:0]
set_property PACKAGE_PIN AB1 [get_ports {vga_g[2]}]
set_property PACKAGE_PIN AB2 [get_ports {vga_g[1]}]
set_property PACKAGE_PIN AA7 [get_ports {vga_g[0]}]

## B[2:0]
set_property PACKAGE_PIN T4 [get_ports {vga_b[2]}]
set_property PACKAGE_PIN AB7 [get_ports {vga_b[1]}]
set_property PACKAGE_PIN AB4 [get_ports {vga_b[0]}]

## 同步訊號
set_property PACKAGE_PIN V4 [get_ports vga_hs]
set_property PACKAGE_PIN U6 [get_ports vga_vs]

## -------- I/O 標準設定 --------
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports vga_hs]
set_property IOSTANDARD LVCMOS33 [get_ports vga_vs]

set_property PACKAGE_PIN P16 [get_ports b]
set_property IOSTANDARD LVCMOS33 [get_ports b]