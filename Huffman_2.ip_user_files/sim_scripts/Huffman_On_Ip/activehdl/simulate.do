onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+Huffman_On_Ip -L xil_defaultlib -L blk_mem_gen_v8_4_3 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.Huffman_On_Ip xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {Huffman_On_Ip.udo}

run -all

endsim

quit -force
