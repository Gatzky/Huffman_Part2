//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Mon Sep  7 21:25:49 2020
//Host        : DESKTOP-EK3AEV4 running 64-bit major release  (build 9200)
//Command     : generate_target Huffman_On_Ip_wrapper.bd
//Design      : Huffman_On_Ip_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module Huffman_On_Ip_wrapper
   (diff_clock_rtl_0_clk_n,
    diff_clock_rtl_0_clk_p,
    reset_rtl_0,
    uart_rtl_0_baudoutn,
    uart_rtl_0_ctsn,
    uart_rtl_0_dcdn,
    uart_rtl_0_ddis,
    uart_rtl_0_dsrn,
    uart_rtl_0_dtrn,
    uart_rtl_0_out1n,
    uart_rtl_0_out2n,
    uart_rtl_0_ri,
    uart_rtl_0_rtsn,
    uart_rtl_0_rxd,
    uart_rtl_0_rxrdyn,
    uart_rtl_0_txd,
    uart_rtl_0_txrdyn,
    uart_rtl_1_baudoutn,
    uart_rtl_1_ctsn,
    uart_rtl_1_dcdn,
    uart_rtl_1_ddis,
    uart_rtl_1_dsrn,
    uart_rtl_1_dtrn,
    uart_rtl_1_out1n,
    uart_rtl_1_out2n,
    uart_rtl_1_ri,
    uart_rtl_1_rtsn,
    uart_rtl_1_rxd,
    uart_rtl_1_rxrdyn,
    uart_rtl_1_txd,
    uart_rtl_1_txrdyn);
  input diff_clock_rtl_0_clk_n;
  input diff_clock_rtl_0_clk_p;
  input reset_rtl_0;
  output uart_rtl_0_baudoutn;
  input uart_rtl_0_ctsn;
  input uart_rtl_0_dcdn;
  output uart_rtl_0_ddis;
  input uart_rtl_0_dsrn;
  output uart_rtl_0_dtrn;
  output uart_rtl_0_out1n;
  output uart_rtl_0_out2n;
  input uart_rtl_0_ri;
  output uart_rtl_0_rtsn;
  input uart_rtl_0_rxd;
  output uart_rtl_0_rxrdyn;
  output uart_rtl_0_txd;
  output uart_rtl_0_txrdyn;
  output uart_rtl_1_baudoutn;
  input uart_rtl_1_ctsn;
  input uart_rtl_1_dcdn;
  output uart_rtl_1_ddis;
  input uart_rtl_1_dsrn;
  output uart_rtl_1_dtrn;
  output uart_rtl_1_out1n;
  output uart_rtl_1_out2n;
  input uart_rtl_1_ri;
  output uart_rtl_1_rtsn;
  input uart_rtl_1_rxd;
  output uart_rtl_1_rxrdyn;
  output uart_rtl_1_txd;
  output uart_rtl_1_txrdyn;

  wire diff_clock_rtl_0_clk_n;
  wire diff_clock_rtl_0_clk_p;
  wire reset_rtl_0;
  wire uart_rtl_0_baudoutn;
  wire uart_rtl_0_ctsn;
  wire uart_rtl_0_dcdn;
  wire uart_rtl_0_ddis;
  wire uart_rtl_0_dsrn;
  wire uart_rtl_0_dtrn;
  wire uart_rtl_0_out1n;
  wire uart_rtl_0_out2n;
  wire uart_rtl_0_ri;
  wire uart_rtl_0_rtsn;
  wire uart_rtl_0_rxd;
  wire uart_rtl_0_rxrdyn;
  wire uart_rtl_0_txd;
  wire uart_rtl_0_txrdyn;
  wire uart_rtl_1_baudoutn;
  wire uart_rtl_1_ctsn;
  wire uart_rtl_1_dcdn;
  wire uart_rtl_1_ddis;
  wire uart_rtl_1_dsrn;
  wire uart_rtl_1_dtrn;
  wire uart_rtl_1_out1n;
  wire uart_rtl_1_out2n;
  wire uart_rtl_1_ri;
  wire uart_rtl_1_rtsn;
  wire uart_rtl_1_rxd;
  wire uart_rtl_1_rxrdyn;
  wire uart_rtl_1_txd;
  wire uart_rtl_1_txrdyn;

  Huffman_On_Ip Huffman_On_Ip_i
       (.diff_clock_rtl_0_clk_n(diff_clock_rtl_0_clk_n),
        .diff_clock_rtl_0_clk_p(diff_clock_rtl_0_clk_p),
        .reset_rtl_0(reset_rtl_0),
        .uart_rtl_0_baudoutn(uart_rtl_0_baudoutn),
        .uart_rtl_0_ctsn(uart_rtl_0_ctsn),
        .uart_rtl_0_dcdn(uart_rtl_0_dcdn),
        .uart_rtl_0_ddis(uart_rtl_0_ddis),
        .uart_rtl_0_dsrn(uart_rtl_0_dsrn),
        .uart_rtl_0_dtrn(uart_rtl_0_dtrn),
        .uart_rtl_0_out1n(uart_rtl_0_out1n),
        .uart_rtl_0_out2n(uart_rtl_0_out2n),
        .uart_rtl_0_ri(uart_rtl_0_ri),
        .uart_rtl_0_rtsn(uart_rtl_0_rtsn),
        .uart_rtl_0_rxd(uart_rtl_0_rxd),
        .uart_rtl_0_rxrdyn(uart_rtl_0_rxrdyn),
        .uart_rtl_0_txd(uart_rtl_0_txd),
        .uart_rtl_0_txrdyn(uart_rtl_0_txrdyn),
        .uart_rtl_1_baudoutn(uart_rtl_1_baudoutn),
        .uart_rtl_1_ctsn(uart_rtl_1_ctsn),
        .uart_rtl_1_dcdn(uart_rtl_1_dcdn),
        .uart_rtl_1_ddis(uart_rtl_1_ddis),
        .uart_rtl_1_dsrn(uart_rtl_1_dsrn),
        .uart_rtl_1_dtrn(uart_rtl_1_dtrn),
        .uart_rtl_1_out1n(uart_rtl_1_out1n),
        .uart_rtl_1_out2n(uart_rtl_1_out2n),
        .uart_rtl_1_ri(uart_rtl_1_ri),
        .uart_rtl_1_rtsn(uart_rtl_1_rtsn),
        .uart_rtl_1_rxd(uart_rtl_1_rxd),
        .uart_rtl_1_rxrdyn(uart_rtl_1_rxrdyn),
        .uart_rtl_1_txd(uart_rtl_1_txd),
        .uart_rtl_1_txrdyn(uart_rtl_1_txrdyn));
endmodule
