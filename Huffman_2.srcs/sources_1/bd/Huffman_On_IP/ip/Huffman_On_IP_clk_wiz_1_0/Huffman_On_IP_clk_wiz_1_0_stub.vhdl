-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Mon Sep  7 21:12:45 2020
-- Host        : DESKTOP-EK3AEV4 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               g:/SDUP_Zdalne/Huffman_Part2/Huffman_2.srcs/sources_1/bd/Huffman_On_IP/ip/Huffman_On_IP_clk_wiz_1_0/Huffman_On_IP_clk_wiz_1_0_stub.vhdl
-- Design      : Huffman_On_IP_clk_wiz_1_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Huffman_On_IP_clk_wiz_1_0 is
  Port ( 
    clk_out1 : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1_p : in STD_LOGIC;
    clk_in1_n : in STD_LOGIC
  );

end Huffman_On_IP_clk_wiz_1_0;

architecture stub of Huffman_On_IP_clk_wiz_1_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out1,reset,locked,clk_in1_p,clk_in1_n";
begin
end;
