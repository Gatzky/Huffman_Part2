`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.09.2020 16:03:12
// Design Name: 
// Module Name: algorithm_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module algorithm_tb();

parameter bitInByte = 7;        // Number of bits in bytes decrement by one - this simplification let miss phrase bIB -1 during array declaration
parameter dataLength = 9;     // Length of data, which will be coded

reg clock;
reg [bitInByte:0]symProbLength;
wire [bitInByte:0]huffmanList[dataLength:0];

algorithm UUT(clock, symProbLength, huffmanList);

initial begin
    clock <= 1'b0;
    symProbLength <= 4;
end

always
    #5 clock <= ~clock;

endmodule
