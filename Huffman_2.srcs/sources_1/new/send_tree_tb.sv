`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Bartlomiej Gac 
// Module Name: send_tree_tb
//////////////////////////////////////////////////////////////////////////////////

module send_tree_tb();

parameter bitInByte = 7;        // Number of bits in bytes decrement by one - this simplification let miss phrase bIB -1 during array declaration
parameter dataLength = 10;     // Length of data, which will be coded

reg clock;
reg [bitInByte:0]inProbabilityList[dataLength:0];
reg [bitInByte:0]inHuffmanList[dataLength:0];
wire [bitInByte:0] outputData;
wire dataReady;
wire [1:0] nextState;

integer i= 32'h0;	

send_tree UUT (clock, inProbabilityList, inHuffmanList, outputData, outputProbabilityList, dataReady, nextState);

initial begin
    clock <= 1'b0;
    for (i=0; i<=dataLength; i=i+1) begin
        inProbabilityList[i] = i;
        inHuffmanList[i] = (dataLength - i);
    end
end

always
    #5 clock <= ~clock;
    
always@(posedge clock) begin
    
end

endmodule
