onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib Huffman_On_Ip_opt

do {wave.do}

view wave
view structure
view signals

do {Huffman_On_Ip.udo}

run -all

quit -force
