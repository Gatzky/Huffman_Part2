`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Bartlomiej Gac 
// Module Name: sort_data
//////////////////////////////////////////////////////////////////////////////////

module sort_data(clock, dataEnable, receivedData, huffmanList, nextState, dataReady, inSymbolsList, outSymbolsList, inProbabilityList, outProbabilityList, inCol, outCol, inCount, outCount);

parameter bitInByte = 7;        // Number of bits in bytes decrement by one - this simplification let miss phrase bIB -1 during array declaration
parameter dataLength = 10;     // Length of data, which will be coded
parameter BUILD_TREE =  3'b011;

input clock;
input dataEnable;
input [bitInByte:0]receivedData[dataLength:0];

output reg [bitInByte:0]huffmanList[dataLength:0];		//List used to perform the algorithm on
output reg [1:0] nextState;
output reg dataReady;

input [bitInByte:0]inSymbolsList[dataLength:0];
output reg [bitInByte:0]outSymbolsList[dataLength:0];
reg [bitInByte:0]tempSymbolsList[dataLength:0];

input [bitInByte:0]inProbabilityList[dataLength:0];
output reg [bitInByte:0]outProbabilityList[dataLength:0];
reg [bitInByte:0]tempProbabilityList[dataLength:0];

input [bitInByte:0] inCol;
output reg [bitInByte:0] outCol;
reg [bitInByte:0] tempCol;

input [bitInByte:0] inCount;
output reg [bitInByte:0] outCount;
reg [bitInByte:0] tempCount;

reg flag = 0;
reg start_flag = 0;
reg [bitInByte:0]tempData;

integer i = 32'h0;
integer j = 32'h0;
integer k = 32'h0;

always @ (posedge clock) begin
    if (start_flag == 0) begin
        tempCount <= inCount;
        tempSymbolsList <= inSymbolsList;
        tempProbabilityList <= inProbabilityList;
        tempCol <= inCol;
        start_flag <= 1;
    end

    if(dataEnable) begin
        tempCount <= tempCount + 1'b1;
        if (i <= dataLength) begin
            tempData <= receivedData[i];
            if(j <= dataLength) begin
                if(tempData == tempSymbolsList[j]) begin
                    tempProbabilityList[j] <= tempProbabilityList[j] + 1;
                    if (k >= 0) begin
                        tempSymbolsList[j] <= tempSymbolsList[k];
                        tempProbabilityList[j] <= tempProbabilityList[k];
                        tempSymbolsList[k] <= tempSymbolsList[j];
                        tempProbabilityList[k] <= tempProbabilityList[j];
                                            
                        huffmanList[j] <= tempSymbolsList[j];
                        huffmanList[k] <= tempSymbolsList[k];  
                    end
                    else begin
                        flag <= 1;
                        j = j + 1;
                        k <= j - 1;
                    end
                end
            end
            else begin
                i = i + 1;
            end
        end
        else begin
            if(!flag) begin
                tempSymbolsList[tempCol] <= tempData;
                huffmanList[tempCol] <= tempData;
                tempProbabilityList[tempCol] <= 'b1;
                tempCol <= tempCol+1;
            end		 
            flag <= 0;
            if(i == dataLength)	begin
                outCount <= tempCount;
                outSymbolsList <= tempSymbolsList;
                outProbabilityList <= tempProbabilityList;	
                nextState <= BUILD_TREE;
                outCol <= tempCol -1 ;
            end
        end
    end
end

endmodule
