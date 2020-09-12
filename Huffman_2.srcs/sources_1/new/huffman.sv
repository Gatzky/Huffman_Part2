`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Bartlomiej Gac 
// Module Name: huffman
//////////////////////////////////////////////////////////////////////////////////

module huffman(clock, reset, inputData, outputData, dataReady);

parameter bitInByte = 7;        // Number of bits in bytes decrement by one - this simplification let miss phrase bIB -1 during array declaration
parameter charMaxValue = 255;   // Maximum value, which can be written on 8 bits
parameter dataLength = 7;     // Length of data, decrement by one, which will be coded
parameter INIT = 4'b0000, GET_DATA = 4'b0001, SORT_DATA = 4'b0010, SORT_PROB_SYM = 4'b0011, BUILD_INIT = 4'b0100, 
          BUILD_STRATEGY = 4'b0101, BUILD_GEN_VAL = 4'b0110, BUILD_PUT_VAL =  4'b0111, ENCODE_DATA = 4'b1000, SEND_TREE = 4'b1001;

input clock;
input reset;
input [bitInByte:0] inputData;

output reg [bitInByte:0] outputData;
output reg dataReady;

reg [3:0] state;

reg [bitInByte:0]tempProbabilityList[dataLength:0]; 
reg [bitInByte:0]probabilityList[dataLength:0];
reg [bitInByte:0]tempSymbolsList[dataLength:0];
reg [bitInByte:0]symbolsList[dataLength:0];

reg [bitInByte:0]huffmanList[dataLength:0];		//List used to perform the algorithm on
reg [bitInByte:0]tempHuffmanToShift[dataLength:0];
reg [bitInByte:0]tempHuffman[dataLength:0];

reg [bitInByte:0]encodedData[dataLength:0];		//List used to perform the algorithm on
reg [bitInByte:0]receivedData[dataLength:0];		//List used to perform the algorithm on

reg [bitInByte:0]tempData[dataLength:0];

reg [bitInByte:0]flag;
reg [bitInByte:0]Count;
reg [bitInByte:0]symProbLength;
reg [bitInByte:0]longestWord = 0;
reg [bitInByte:0]finishedWord = 0;
reg [bitInByte:0]shortestWordPos = 0;
reg [bitInByte:0]changedValue = 0;
reg [bitInByte:0]newValue = 0;

//Loop variables
integer i = 32'h0;	
integer j = 32'h0;

always @ (posedge clock) begin
    if(reset==1'b1) begin
        dataReady <= 1'b0;
        state <= INIT;
    end
    else begin
        case(state)
            INIT:begin
                
                flag <= 0;
                dataReady <= 0;
                Count <= 0;
                symProbLength <= 255;
                outputData <= 0;
    
                for(i=0;i<=dataLength;i=i+1) begin
                    tempProbabilityList[i] <= 'b0;
                    tempSymbolsList[i] <= 'b0;
                    probabilityList[i] <= 'b0;
                    symbolsList[i] <= 'b0;
                    receivedData[i] <= 'b0;
                    huffmanList[i] <= 'bZZZZZZZZ;
                    tempHuffmanToShift[i] <= 'bZZZZZZZZ;
                    tempHuffman[i] <= 'bZZZZZZZZ;
                    tempData[i] <= 'b0;
                    encodedData[i] <= 'b0;
                end
                
                i <= 0;                 
                state <= GET_DATA;
            end
            
            GET_DATA:begin
                if (inputData == 32'h3E) begin
                    flag <= 1;
                end
                
                if (flag == 1) begin
                    if(i<=dataLength) begin
                        receivedData[i]<=inputData;
                        i<=i+1;
                    end
                    else begin
                        i=0;
                        state<=SORT_DATA;
                    end
                end
            end
                
            SORT_DATA:begin
                if (i < charMaxValue) begin
                    if (j <= dataLength) begin
                        if (receivedData[j] == i) begin
                            if (tempSymbolsList[symProbLength] == i) begin
                                tempProbabilityList[symProbLength] = tempProbabilityList[symProbLength] + 1;
                            end
                            else begin
                                symProbLength = symProbLength + 1;
                                tempSymbolsList[symProbLength] = i;
                                tempProbabilityList[symProbLength] = 1;
                            end
                                    
                            tempData[Count] <= i;
                            Count = Count + 1;
                        end
                        j = j + 1;
                    end
                    else begin
                        i <= i + 1;
                        j <= 0;
                    end
                end
                else begin
                    symProbLength = symProbLength + 1;
                    i <= 0;
                    j <= 0;
                    state <= SORT_PROB_SYM;
                    Count <= 0; 
                end     
            end
            
            SORT_PROB_SYM:begin
                if (i < dataLength) begin
                    if (j <= symProbLength) begin
                        if (tempProbabilityList[j] == i) begin    
                            probabilityList[Count] <= i;
                            symbolsList[Count] <= tempSymbolsList[j];
                            Count = Count + 1;
                        end
                        j = j + 1;
                    end
                    else begin
                        i <= i + 1;
                        j <= 0;
                    end
                end
                else begin
                    state <= BUILD_STRATEGY;
                    i <= 0;
                    j <= 0;
                    Count <= 0;
                end
            end
            
            BUILD_INIT:begin
                longestWord <= 1;
                finishedWord <= 2;
                shortestWordPos <= 255;
                changedValue <= 0;
                newValue <= 0;
                state <= BUILD_STRATEGY;
                i <= 0;
            end
            
            BUILD_STRATEGY:begin
                if (symProbLength == 1) begin
                    tempHuffman[0] <= 8'bZZZZZZZ0;
                    state <= ENCODE_DATA;
                end
                else if (symProbLength == 2) begin
                    tempHuffman[0] <= 8'bZZZZZZZ0;
                    tempHuffman[1] <= 8'bZZZZZZZ1;
                    state <= ENCODE_DATA;
                end
                else begin
                    tempHuffman[0] <= 8'bZZZZZZZ0;
                    tempHuffman[1] <= 8'bZZZZZZZ1;
                    state <= BUILD_GEN_VAL;
                end
            end
            
            BUILD_GEN_VAL:begin
                if (i < finishedWord) begin
                    if(tempHuffman[i][longestWord] === 1'bZ) begin
                        shortestWordPos <= i;
                        changedValue <= tempHuffman[i];
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
                    state = BUILD_PUT_VAL;
                    i = 0;
                end
            end
            
            BUILD_PUT_VAL:begin
                if (i <= dataLength) begin
                    if(i < shortestWordPos) begin
                        tempHuffmanToShift[i] <= tempHuffman[i];
                    end
                    else if(i == shortestWordPos) begin
                        tempHuffmanToShift[i] <= changedValue;
                    end
                    else if(i == (shortestWordPos + 1)) begin
                        tempHuffmanToShift[i] <= newValue;
                    end
                    else if(i > (shortestWordPos + 1)) begin
                        tempHuffmanToShift[i] <= tempHuffman[i-1];
                    end
                    i = i + 1;
                end
                else begin
                    i = 0;
                    shortestWordPos <= 0;
                    if(finishedWord >= symProbLength) begin
                        huffmanList <= tempHuffmanToShift;
                        state = ENCODE_DATA;
                    end
                    else begin
                        tempHuffman <= tempHuffmanToShift;
                        state = BUILD_GEN_VAL;
                    end
                end
            end
            
            ENCODE_DATA:begin
                if(i < dataLength) begin
                    if (j < symProbLength) begin
                        if (symbolsList[j] == receivedData[i]) begin
                            encodedData[i] <= huffmanList[j];
                        end
                        j = j + 1;
                    end
                    else begin
                        i = i + 1;
                        j = 0;
                    end
                end
                else begin
                    i <= 0;
                    j <= 0;
                    state <= SEND_TREE;
                end
            end
            
            SEND_TREE:begin
                if(i <= dataLength) begin
                    dataReady <= 1;
                    outputData <= encodedData[i];;
                    i = i + 1;
                end
                else begin
                    i <= 0;
                    state <= INIT;
                end
            end
        endcase
    end
end

endmodule
