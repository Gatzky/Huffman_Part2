`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Bartlomiej Gac 
// Module Name: send_tree
//////////////////////////////////////////////////////////////////////////////////

module send_tree(clock, inProbabilityList, inHuffmanList, outputData, outputProbabilityList, dataReady, nextState);

parameter bitInByte = 7;        // Number of bits in bytes decrement by one - this simplification let miss phrase bIB -1 during array declaration
parameter charMaxValue = 255;   // Maximum value, which can be written on 8 bits
parameter dataLength = 10;     // Length of data, which will be coded
parameter INIT = 3'b000;

input clock;
input [bitInByte:0]inProbabilityList[charMaxValue:0];
input [bitInByte:0]inHuffmanList[charMaxValue:0];
output reg [bitInByte:0] outputData;
output reg [bitInByte:0] outputProbabilityList;
output reg dataReady;
output reg [1:0] nextState;

integer i = 32'h0;
integer j = 32'h0;
    
always @ (posedge clock) begin
    if(i < charMaxValue) begin
        dataReady <= 1;
        outputData <= inHuffmanList[i];
        outputProbabilityList <= inProbabilityList[i];
        i = i + 1;
    end
    else begin
        dataReady <= 0;
        i <= 0;
        nextState <= INIT;
    end
end

endmodule
