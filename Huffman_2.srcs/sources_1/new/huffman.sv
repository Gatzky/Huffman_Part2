`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Bartlomiej Gac 
// Module Name: huffman
//////////////////////////////////////////////////////////////////////////////////

module huffman(clock, reset, inputData, dataEnable, outputData, outputProbabilityList, dataReady, state);

parameter bitInByte = 7;        // Number of bits in bytes decrement by one - this simplification let miss phrase bIB -1 during array declaration
parameter charMaxValue = 255;   // Maximum value, which can be written on 8 bits
parameter dataLength = 7;     // Length of data, which will be coded
parameter INIT = 3'b000, GET_DATA = 3'b001, SORT_DATA = 3'b010, SORT_PROB_SYM = 3'b011, BUILD_TREE =  3'b100, ENCODE_DATA = 3'b101, SEND_TREE = 3'b111;

input clock;
input reset;
input [bitInByte:0] inputData;
input dataEnable;
output reg [bitInByte:0] outputData;
output reg [bitInByte:0] outputProbabilityList;
output reg dataReady;
output reg [2:0] state;

reg [bitInByte:0]tempProbabilityList[dataLength:0];
reg [bitInByte:0]tempSymbolsList[dataLength:0];
reg [bitInByte:0]probabilityList[dataLength:0];
reg [bitInByte:0]symbolsList[dataLength:0];
reg [bitInByte:0]huffmanList[dataLength:0];		//List used to perform the algorithm on
reg [bitInByte:0]encodedData[dataLength:0];		//List used to perform the algorithm on
reg [bitInByte:0]receivedData[dataLength:0];		//List used to perform the algorithm on
reg [bitInByte:0]Count;
reg [bitInByte:0]Col;
reg [bitInByte:0]tempData[dataLength:0];
reg [bitInByte:0]symProbLength;
reg [bitInByte:0]template = 8'b11111111;

reg [bitInByte:0]col = 'b0;						   //Column length

//Loop variables
integer i = 32'h0;	
integer j = 32'h0;
integer k = 32'h0;
integer l = 32'h0;
    							
//Flag
reg flag = 0;


always @ (posedge clock) begin
    if(reset==1'b1) begin
        dataReady <= 1'b0;
        state <= INIT;
    end
    else begin
        case(state)
            INIT:begin
                dataReady <= 0;
                
                Count <= 0;
                Col <= 0;
                symProbLength <= 255;
    
                for(i=0;i<=dataLength;i=i+1) begin
                    tempProbabilityList[i] <= 'b0;
                    tempSymbolsList[i] <= 'b0;
                    probabilityList[i] <= 'b0;
                    symbolsList[i] <= 'b0;
                    receivedData[i] <= 'b0;
                    huffmanList[i] <= 'b0;
                    tempData[i] <= 'b0;
                    encodedData[i] <= 'b0;
                end
                   
                i <= 0;                 
                state <= GET_DATA;
            end
            
            GET_DATA:begin
                if(i<=dataLength) begin
                    receivedData[i]<=inputData;
                    i<=i+1;
                end
                else begin
                    i=0;
                    state<=SORT_DATA;
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
                    state <= BUILD_TREE;
                    i <= 0;
                    j <= 0;
                    Count <= 0;
                end
            end
            
            BUILD_TREE:begin
                if (i <= symProbLength) begin
                    huffmanList[i] <= (template >> (dataLength - i)) - 1;
                    i <= i + 1;
                end
                else begin
                    i <= 0;
                    huffmanList[symProbLength] <= huffmanList[symProbLength-1] + 1;
                    huffmanList[0] <= 0;
                    state <= ENCODE_DATA;
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
                    end
                end
                else begin
                    i <= 0;
                    j <= 0;
                    state <= SEND_TREE;
                end
            end
            
            SEND_TREE:begin
                if(i < charMaxValue) begin
                    dataReady <= 1;
                    outputData <= huffmanList[i];
                    outputProbabilityList <= probabilityList[i];
                    i = i + 1;
                end
                else begin
                    dataReady <= 0;
                    i <= 0;
                    state <= INIT;
                end
            end
        endcase
    end
end

endmodule
