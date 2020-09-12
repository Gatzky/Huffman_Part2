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
          BUILD_GEN_VAL = 4'b0101, BUILD_PUT_VAL =  4'b0110, ENCODE_DATA = 4'b0111, SEND_TREE = 4'b1000;

input clock;
input reset;
input [bitInByte:0] inputData;

output reg [bitInByte:0] outputData;
output reg dataReady;

reg [bitInByte:0]tempProbabilityList[dataLength:0]; 
reg [bitInByte:0]probabilityList[dataLength:0];
reg [bitInByte:0]tempSymbolsList[dataLength:0];
reg [bitInByte:0]symbolsList[dataLength:0];

reg [bitInByte:0]huffmanList[dataLength:0];
reg [bitInByte:0]tempHuffmanToShift[dataLength:0];
reg [bitInByte:0]tempHuffman[dataLength:0];

reg [bitInByte:0]encodedData[dataLength:0];
reg [bitInByte:0]receivedData[dataLength:0];
reg [bitInByte:0]tempData[dataLength:0];

reg [3:0] state;
reg [bitInByte:0]flag;
reg [bitInByte:0]count;
reg [bitInByte:0]differentSymbolsNumber; 
reg [bitInByte:0]huffmanLongestWord;
reg [bitInByte:0]huffmanFinishedWords;
reg [bitInByte:0]huffmanShortestWordPos;
reg [bitInByte:0]huffmanChangedValue;
reg [bitInByte:0]huffmanNewValue;

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
                count <= 0;
                differentSymbolsNumber <= 255;
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
                            if (tempSymbolsList[differentSymbolsNumber] == i) begin
                                tempProbabilityList[differentSymbolsNumber] = tempProbabilityList[differentSymbolsNumber] + 1;
                            end
                            else begin
                                differentSymbolsNumber = differentSymbolsNumber + 1;
                                tempSymbolsList[differentSymbolsNumber] = i;
                                tempProbabilityList[differentSymbolsNumber] = 1;
                            end
                                    
                            tempData[count] <= i;
                            count = count + 1;
                        end
                        j = j + 1;
                    end
                    else begin
                        i <= i + 1;
                        j <= 0;
                    end
                end
                else begin
                    differentSymbolsNumber = differentSymbolsNumber + 1;
                    i <= 0;
                    j <= 0;
                    state <= SORT_PROB_SYM;
                    count <= 255; 
                end     
            end
            
            SORT_PROB_SYM:begin
                if (i < dataLength) begin
                    if (j <= differentSymbolsNumber) begin
                        if (tempProbabilityList[j] == i) begin    
                            probabilityList[differentSymbolsNumber-1-count] <= i;
                            symbolsList[differentSymbolsNumber-1-count] <= tempSymbolsList[j];
                            count = count + 1;
                        end
                        j = j + 1;
                    end
                    else begin
                        i <= i + 1;
                        j <= 0;
                    end
                end
                else begin
                    state <= BUILD_INIT;
                    i <= 0;
                    j <= 0;
                    count <= 0;
                end
            end
            
            BUILD_INIT:begin
                huffmanLongestWord = 1;
                huffmanFinishedWords = 2;
                huffmanShortestWordPos = 255;
                huffmanChangedValue = 0;
                huffmanNewValue = 0;
                i = 0;
                if (differentSymbolsNumber == 1) begin
                    tempHuffman[0] <= 8'bZZZZZZZ0;
                    state <= ENCODE_DATA;
                end
                else if (differentSymbolsNumber == 2) begin
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
                if (i < huffmanFinishedWords) begin
                    if(tempHuffman[i][huffmanLongestWord] === 1'bZ) begin
                        huffmanShortestWordPos <= i;
                        huffmanChangedValue <= tempHuffman[i];
                    end
                    i <= i + 1;
                end
                else begin
                    if(huffmanShortestWordPos == 0) begin
                        huffmanLongestWord = huffmanLongestWord + 1;
                    end
                    huffmanFinishedWords = huffmanFinishedWords + 1;
                    huffmanChangedValue = (huffmanChangedValue << 1);
                    huffmanNewValue = huffmanChangedValue;
                    huffmanNewValue[0] =  1'b1;
                    state = BUILD_PUT_VAL;
                    i = 0;
                end
            end
            
            BUILD_PUT_VAL:begin
                if (i <= dataLength) begin
                    if(i < huffmanShortestWordPos) begin
                        tempHuffmanToShift[i] <= tempHuffman[i];
                    end
                    else if(i == huffmanShortestWordPos) begin
                        tempHuffmanToShift[i] <= huffmanChangedValue;
                    end
                    else if(i == (huffmanShortestWordPos + 1)) begin
                        tempHuffmanToShift[i] <= huffmanNewValue;
                    end
                    else if(i > (huffmanShortestWordPos + 1)) begin
                        tempHuffmanToShift[i] <= tempHuffman[i-1];
                    end
                    i = i + 1;
                end
                else begin
                    i = 0;
                    huffmanShortestWordPos <= 0;
                    if(huffmanFinishedWords >= differentSymbolsNumber) begin
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
                if(i <= dataLength) begin
                    if (j <= differentSymbolsNumber) begin
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
                    outputData <= encodedData[i];
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
