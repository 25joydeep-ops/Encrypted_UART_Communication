//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.1 (win64) Build 5076996 Wed May 22 18:37:14 MDT 2024
//Date        : Wed Jul 16 15:35:42 2025
//Host        : DESKTOP-1D0JV2P running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (clk_0,
    rst_0,
    rx_0,
    rx_1,
    tx_0,
    tx_1,
    tx_busy_0,
    tx_busy_1);
  input clk_0;
  input rst_0;
  input rx_0;
  input rx_1;
  output tx_0;
  output tx_1;
  output tx_busy_0;
  output tx_busy_1;

  wire clk_0;
  wire rst_0;
  wire rx_0;
  wire rx_1;
  wire tx_0;
  wire tx_1;
  wire tx_busy_0;
  wire tx_busy_1;

  design_1 design_1_i
       (.clk_0(clk_0),
        .rst_0(rst_0),
        .rx_0(rx_0),
        .rx_1(rx_1),
        .tx_0(tx_0),
        .tx_1(tx_1),
        .tx_busy_0(tx_busy_0),
        .tx_busy_1(tx_busy_1));
endmodule
