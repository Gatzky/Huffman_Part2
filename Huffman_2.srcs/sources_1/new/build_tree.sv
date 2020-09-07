`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Bartlomiej Gac 
// Module Name: build_tree
//////////////////////////////////////////////////////////////////////////////////

module build_tree(clock, dataReady, nextState, inCol, outCol, inProbabilityList, outProbabilityList, inHuffmanList, outHuffmanList, inCount, outCount);

parameter bitInByte = 7;        // Number of bits in bytes decrement by one - this simplification let miss phrase bIB -1 during array declaration
parameter dataLength = 10;     // Length of data, which will be coded
parameter SEND_TREE = 3'b100;

input clock;
output reg dataReady;
output reg [1:0] nextState;

input [bitInByte:0] inCol;
output reg [bitInByte:0] outCol;
reg [bitInByte:0] tempCol;

input [bitInByte:0]inProbabilityList[dataLength:0];
output reg [bitInByte:0]outProbabilityList[dataLength:0];
reg [bitInByte:0]tempProbabilityList[dataLength:0];

input [bitInByte:0]inHuffmanList[dataLength:0];
output reg [bitInByte:0]outHuffmanList[dataLength:0];
reg [bitInByte:0] tempHuffmanList[dataLength:0];

input [bitInByte:0] inCount;
output reg [bitInByte:0] outCount;

reg start_flag = 0;
integer k;
    
always @ (posedge clock) begin
    if (start_flag == 0) begin
        tempCol <= inCol;
        tempProbabilityList <= inProbabilityList;
        tempHuffmanList <= inHuffmanList;
        k <= dataLength;
        start_flag <= 1;
    end

    dataReady <= 0;
    if(tempCol) begin			//One step per cycle
        tempProbabilityList[tempCol-1] <= tempProbabilityList[tempCol] + tempProbabilityList[tempCol-1];		//Added probabilities
        tempCol <= tempCol - 1;		//removing least symbol
            
        if ( k > 0) begin 
            if (tempProbabilityList[k] < tempProbabilityList[inCount]) begin
                tempHuffmanList[inCount] <= tempHuffmanList[k];
                tempProbabilityList[inCount] <= tempProbabilityList[k];
                tempHuffmanList[k] <= tempHuffmanList[inCount];
                tempProbabilityList[k] <= tempProbabilityList[inCount];
            end
            k = k - 1;
        end
        else begin
            k <= tempCol - 1;
            outCol <= tempCol;
        end
    end
    else begin
        nextState <= SEND_TREE;
        outCount <= 0;
        outCol <= tempCol;
        outHuffmanList <= tempHuffmanList;
        outProbabilityList <= tempProbabilityList;
    end
end
    
endmodule
