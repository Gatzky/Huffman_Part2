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
parameter dataLength = 7;     // Length of data, decrement by one, which will be coded
parameter INIT = 3'b000, STRATEGY = 3'b001, GEN_VALUE = 3'b010, PUT_VALUE = 3'b011, END_STATE =  3'b100;


integer i = 32'h0;	
integer j = 32'h0;

input clock;
input [bitInByte:0]symProbLength;

input [bitInByte:0]inHuffmanList[dataLength:0];		//List used to perform the algorithm on
output reg [bitInByte:0]outHuffmanList[dataLength:0];		//List used to perform the algorithm on
reg [bitInByte:0]tempHuffmanList[dataLength:0];		//List used to perform the algorithm on
reg [bitInByte:0]tempHuffmanList2[dataLength:0];		//List used to perform the algorithm on

reg [bitInByte:0] endFlag = 0;
reg [bitInByte:0] state = 0;
reg [bitInByte:0] longestWord = 0;
reg [bitInByte:0] finishedWord = 0;
reg [bitInByte:0] shortestWordPos = 0;
reg [bitInByte:0] changedValue = 0;
reg [bitInByte:0] newValue = 0;
reg test = 0;
reg [bitInByte:0] value = 0;
reg value_0 = 0;
reg bool = 0;

always @ (posedge clock) begin
    case(state)
        INIT:begin
            tempHuffmanList <= inHuffmanList;
            longestWord <= 1;
            finishedWord <= 2;
            shortestWordPos <= 255;
            state <= STRATEGY;
            changedValue <= 0;
            test <= 0;
            value <= 0;
            value_0 <= 0;
            bool <= 0;
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
                value = tempHuffmanList[i];
                value_0 = tempHuffmanList[i][longestWord];
                bool = (tempHuffmanList[i][longestWord] === 1'bZ);
                if(tempHuffmanList[i][longestWord] === 1'bZ) begin
                    shortestWordPos <= i;
                    changedValue <= tempHuffmanList[i];
                    test <= ~test;
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
