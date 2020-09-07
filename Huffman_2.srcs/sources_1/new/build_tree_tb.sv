`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Bartlomiej Gac 
// Module Name: build_tree_tb
//////////////////////////////////////////////////////////////////////////////////

module build_tree_tb();

parameter bitInByte = 7;        // Number of bits in bytes decrement by one - this simplification let miss phrase bIB -1 during array declaration
parameter dataLength = 10;     // Length of data, which will be coded

reg clock;
wire dataReady;
wire [1:0] nextState;

reg [bitInByte:0] inCol;
wire [bitInByte:0] outCol;

reg [bitInByte:0]inProbabilityList[dataLength:0];
wire [bitInByte:0]outProbabilityList[dataLength:0];

reg [bitInByte:0]inHuffmanList[dataLength:0];
wire [bitInByte:0]outHuffmanList[dataLength:0];

reg [bitInByte:0] inCount;
wire [bitInByte:0] outCount;

integer i= 32'h0;	

build_tree UUT(clock, dataReady, nextState, inCol, outCol, inProbabilityList, outProbabilityList, inHuffmanList, outHuffmanList, inCount, outCount);

initial begin
    clock <= 1'b0;
    inCol <= 10;
    inCount <= dataLength;
    for (i=0; i<=dataLength; i=i+2) begin
        inProbabilityList[i] = 1;
        inProbabilityList[i+1] = 2;
        inHuffmanList[i] = 1;
        inHuffmanList[i+1] = 2;
    end
end

always
    #5 clock <= ~clock;
    
always@(posedge clock) begin
    //TO DO
end

endmodule
