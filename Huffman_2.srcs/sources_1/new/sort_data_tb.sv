`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Bartlomiej Gac 
// Module Name: sort_data_tb
//////////////////////////////////////////////////////////////////////////////////

module sort_data_tb();

parameter bitInByte = 7;        // Number of bits in bytes decrement by one - this simplification let miss phrase bIB -1 during array declaration
parameter dataLength = 10;     // Length of data, which will be coded

reg clock;
reg dataEnable;
reg [bitInByte:0]receivedData[dataLength:0];

wire [bitInByte:0]huffmanList[dataLength:0];		//List used to perform the algorithm on
wire [1:0] nextState;
wire dataReady;

reg [bitInByte:0]inSymbolsList[dataLength:0];
wire [bitInByte:0]outSymbolsList[dataLength:0];

reg [bitInByte:0]inProbabilityList[dataLength:0];
wire [bitInByte:0]outProbabilityList[dataLength:0];

reg [bitInByte:0] inCol;
wire [bitInByte:0] outCol;

reg [bitInByte:0] inCount;
wire [bitInByte:0] outCount;

integer i = 32'h0;
integer j = 32'h0;
integer k = 32'h0;
    
sort_data UUT(clock, dataEnable, receivedData, huffmanList, nextState, dataReady, inSymbolsList, outSymbolsList, inProbabilityList, outProbabilityList, inCol, outCol, inCount, outCount);

initial begin
    clock <= 1'b0;
    dataEnable <= 1'b1;
    for (i=0; i<=dataLength; i=i+1) begin
        receivedData[i] = 0;
        inSymbolsList[i] = 0;
        inProbabilityList[1] = 0;
    end
end

always
    #5 clock <= ~clock;
    
always@(posedge clock) begin
    //TO DO
end
    
endmodule
