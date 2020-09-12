`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2020 10:05:41
// Design Name: 
// Module Name: test
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


module test(clock, symProbLength, inHuffmanList, outHuffmanList);

parameter bitInByte = 7;        // Number of bits in bytes decrement by one - this simplification let miss phrase bIB -1 during array declaration
parameter dataLength = 10;     // Length of data, decrement by one, which will be coded
parameter INIT = 4'b0000, GET_DATA = 4'b0001, SORT_DATA = 4'b0010, SORT_PROB_SYM = 4'b0011, BUILD_INIT = 4'b0100, 
          BUILD_STRATEGY = 4'b0101, BUILD_GEN_VAL = 4'b0110, BUILD_PUT_VAL =  4'b0111, ENCODE_DATA = 4'b1000, SEND_TREE = 4'b1001;

integer i = 32'h0;	

input clock;
input [bitInByte:0]symProbLength;

input [bitInByte:0]inHuffmanList[dataLength:0];		//List used to perform the algorithm on
output reg [bitInByte:0]outHuffmanList[dataLength:0];		//List used to perform the algorithm on

reg [bitInByte:0]tempHuffmanList[dataLength:0];		//List used to perform the algorithm on
reg [bitInByte:0]tempHuffmanList2[dataLength:0];		//List used to perform the algorithm on

reg [bitInByte:0] state = 0;
reg [bitInByte:0] longestWord = 0;
reg [bitInByte:0] finishedWord = 0;
reg [bitInByte:0] shortestWordPos = 0;
reg [bitInByte:0] changedValue = 0;
reg [bitInByte:0] newValue = 0;

always @ (posedge clock) begin
    case(state)
        INIT:begin
            tempHuffmanList <= inHuffmanList;
            tempHuffmanList2 <= inHuffmanList;
            state <= STRATEGY;
            longestWord <= 1;
            finishedWord <= 2;
            shortestWordPos <= 255;
            changedValue <= 0;
            newValue <= 0;
        end 
        STRATEGY:begin
            if (symProbLength == 1) begin
                tempHuffmanList[0] <= 8'bZZZZZZZ0;
                state <= END_STATE;
            end
            else if (symProbLength == 2) begin
                tempHuffmanList[0] <= 8'bZZZZZZZ0;
                tempHuffmanList[1] <= 8'bZZZZZZZ1;
                state <= END_STATE;
            end
            else begin
                tempHuffmanList[0] <= 8'bZZZZZZZ0;
                tempHuffmanList[1] <= 8'bZZZZZZZ1;
                state <= GEN_VALUE;
            end
        end
        GEN_VALUE:begin
            if (i < finishedWord) begin
                if(tempHuffmanList[i][longestWord] === 1'bZ) begin
                    shortestWordPos <= i;
                    changedValue <= tempHuffmanList[i];
                end
                i <= i + 1;
            end
            else begin
                if(shortestWordPos == 0) begin
                    longestWord = longestWord + 1;
                end
                finishedWord = finishedWord + 1;
                changedValue = (changedValue << 1);
                newValue = changedValue;
                newValue[0] =  1'b1;
                state = PUT_VALUE;
                i = 0;
            end
        end
        PUT_VALUE:begin
            if (i <= dataLength) begin
                if(i < shortestWordPos) begin
                    tempHuffmanList2[i] <= tempHuffmanList[i];
                end
                else if(i == shortestWordPos) begin
                    tempHuffmanList2[i] <= changedValue;
                end
                else if(i == (shortestWordPos + 1)) begin
                    tempHuffmanList2[i] <= newValue;
                end
                else if(i > (shortestWordPos + 1)) begin
                    tempHuffmanList2[i] <= tempHuffmanList[i-1];
                end
                i = i + 1;
            end
            else begin
                i = 0;
                shortestWordPos <= 0;
                if(finishedWord >= symProbLength) begin
                    outHuffmanList <= tempHuffmanList2;
                    state = END_STATE;
                end
                else begin
                    tempHuffmanList <= tempHuffmanList2;
                    state = GEN_VALUE;
                end
            end
        end
    endcase
end


endmodule
