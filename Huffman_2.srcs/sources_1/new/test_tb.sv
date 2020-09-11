`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2020 10:11:23
// Design Name: 
// Module Name: test_tb
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


module test_tb();

parameter bitInByte = 7;        // Number of bits in bytes decrement by one - this simplification let miss phrase bIB -1 during array declaration
parameter dataLength = 7;     // Length of data, decrement by one, which will be coded

integer i = 32'h0;	
integer j = 32'h0;

reg clock;
reg [bitInByte:0]symProbLength;
reg [bitInByte:0]inHuffmanList[dataLength:0];		//List used to perform the algorithm on
wire [bitInByte:0]outHuffmanList[dataLength:0];		//List used to perform the algorithm on

test UUT(clock, symProbLength, inHuffmanList, outHuffmanList);

initial begin
    clock <= 1'b0;
    symProbLength <= 5;
    inHuffmanList[0] <= 8'bZZZZZZZZ;
    inHuffmanList[1] <= 8'bZZZZZZZZ;
    inHuffmanList[2] <= 8'bZZZZZZZZ;
    inHuffmanList[3] <= 8'bZZZZZZZZ;
    inHuffmanList[4] <= 8'bZZZZZZZZ;
    inHuffmanList[5] <= 8'bZZZZZZZZ;
    inHuffmanList[6] <= 8'bZZZZZZZZ;
    inHuffmanList[7] <= 8'bZZZZZZZZ;
end

always
    #5 clock <= ~clock;

endmodule
