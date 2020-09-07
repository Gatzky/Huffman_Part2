vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/blk_mem_gen_v8_4_3

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap blk_mem_gen_v8_4_3 modelsim_lib/msim/blk_mem_gen_v8_4_3

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../Huffman_2.srcs/sources_1/bd/Huffman_On_IP/ipshared/c923" "+incdir+../../../../Huffman_2.srcs/sources_1/bd/Huffman_On_IP/ipshared/ec67/hdl" \
"../../../bd/Huffman_On_Ip/ipshared/bcbe/hdl/HuffmanAXI_v1_0_S00_AXI.v" \
"../../../bd/Huffman_On_Ip/ipshared/bcbe/hdl/HuffmanAXI_v1_0.v" \
"../../../bd/Huffman_On_Ip/ip/Huffman_On_Ip_HuffmanAXI_0_0/sim/Huffman_On_Ip_HuffmanAXI_0_0.v" \
"../../../bd/Huffman_On_Ip/ip/Huffman_On_Ip_axi_uart16550_0_0_1/Huffman_On_Ip_axi_uart16550_0_0_sim_netlist.v" \
"../../../bd/Huffman_On_Ip/ip/Huffman_On_Ip_axi_uart16550_1_0/Huffman_On_Ip_axi_uart16550_1_0_sim_netlist.v" \
"g:/SDUP_Zdalne/Huffman_Part2/Huffman_2.srcs/sources_1/bd/Huffman_On_Ip/ip/Huffman_On_Ip_microblaze_0_0_1/Huffman_On_Ip_microblaze_0_0_sim_netlist.v" \
"../../../bd/Huffman_On_Ip/ip/Huffman_On_Ip_dlmb_v10_0_1/Huffman_On_Ip_dlmb_v10_0_sim_netlist.v" \
"../../../bd/Huffman_On_Ip/ip/Huffman_On_Ip_ilmb_v10_0_1/Huffman_On_Ip_ilmb_v10_0_sim_netlist.v" \
"../../../bd/Huffman_On_Ip/ip/Huffman_On_Ip_dlmb_bram_if_cntlr_0_1/Huffman_On_Ip_dlmb_bram_if_cntlr_0_sim_netlist.v" \
"../../../bd/Huffman_On_Ip/ip/Huffman_On_Ip_ilmb_bram_if_cntlr_0_1/Huffman_On_Ip_ilmb_bram_if_cntlr_0_sim_netlist.v" \

vlog -work blk_mem_gen_v8_4_3 -64 -incr "+incdir+../../../../Huffman_2.srcs/sources_1/bd/Huffman_On_IP/ipshared/c923" "+incdir+../../../../Huffman_2.srcs/sources_1/bd/Huffman_On_IP/ipshared/ec67/hdl" \
"../../../../Huffman_2.srcs/sources_1/bd/Huffman_On_IP/ipshared/c001/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../Huffman_2.srcs/sources_1/bd/Huffman_On_IP/ipshared/c923" "+incdir+../../../../Huffman_2.srcs/sources_1/bd/Huffman_On_IP/ipshared/ec67/hdl" \
"../../../bd/Huffman_On_Ip/ip/Huffman_On_Ip_lmb_bram_0_1/sim/Huffman_On_Ip_lmb_bram_0.v" \
"../../../bd/Huffman_On_Ip/ip/Huffman_On_Ip_mdm_1_0_1/Huffman_On_Ip_mdm_1_0_sim_netlist.v" \
"g:/SDUP_Zdalne/Huffman_Part2/Huffman_2.srcs/sources_1/bd/Huffman_On_Ip/ip/Huffman_On_Ip_clk_wiz_1_0_1/Huffman_On_Ip_clk_wiz_1_0_sim_netlist.v" \
"../../../bd/Huffman_On_Ip/ip/Huffman_On_Ip_rst_clk_wiz_1_100M_0_1/Huffman_On_Ip_rst_clk_wiz_1_100M_0_sim_netlist.v" \
"g:/SDUP_Zdalne/Huffman_Part2/Huffman_2.srcs/sources_1/bd/Huffman_On_Ip/ip/Huffman_On_Ip_xbar_0_1/Huffman_On_Ip_xbar_0_sim_netlist.v" \
"../../../bd/Huffman_On_Ip/sim/Huffman_On_Ip.v" \

vlog -work xil_defaultlib \
"glbl.v"

