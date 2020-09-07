`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Bartlomiej Gac 
// Module Name: huffman
//////////////////////////////////////////////////////////////////////////////////

module huffman(clock, reset, inputData, dataEnable, outputData, outputProbabilityList, dataReady, state);

parameter bitInByte = 7;        // Number of bits in bytes decrement by one - this simplification let miss phrase bIB -1 during array declaration
parameter charMaxValue = 255;   // Maximum value, which can be written on 8 bits
parameter dataLength = 10;     // Length of data, which will be coded
parameter INIT = 3'b000, GET_DATA = 3'b001, SORT_DATA = 3'b010, BUILD_TREE =  3'b011, SEND_TREE = 3'b100;

input clock;
input reset;
input [bitInByte:0] inputData;
input dataEnable;
output reg [bitInByte:0] outputData;
output reg [bitInByte:0] outputProbabilityList;
output reg dataReady;
output reg [1:0] state;

reg [bitInByte:0]probabilityList[dataLength:0];
reg [bitInByte:0]symbolsList[dataLength:0];
reg [bitInByte:0]huffmanList[dataLength:0];		//List used to perform the algorithm on
reg [bitInByte:0]receivedData[dataLength:0];		//List used to perform the algorithm on
reg [bitInByte:0]Count;
reg [bitInByte:0]Col;
reg [bitInByte:0]tempData;

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
    
                for(i=0;i<=dataLength;i=i+1) begin
                    probabilityList[i] <= 'b0;
                    symbolsList[i] <= 'bz;
                    huffmanList[i] <= 'b0;
                end
                                    
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
                if(dataEnable) begin
                    Count <= Count + 1'b1;
                    if (i <= dataLength) begin
                        tempData <= receivedData[i];
                        if(j <= dataLength) begin
                            if(tempData == symbolsList[j]) begin
                                probabilityList[j] <= probabilityList[j] + 1;
                                if (k >= 0) begin
                                    symbolsList[j] <= symbolsList[k];
                                    probabilityList[j] <= probabilityList[k];
                                    symbolsList[k] <= symbolsList[j];
                                    probabilityList[k] <= probabilityList[j];
                                                        
                                    huffmanList[j] <= symbolsList[j];
                                    huffmanList[k] <= symbolsList[k];  
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
                            symbolsList[Col] <= tempData;
                            huffmanList[Col] <= tempData;
                            probabilityList[Col] <= 'b1;
                            Col <= Col+1;
                        end		 
                        flag <= 0;
                        if(i == dataLength)	begin
                            state <= BUILD_TREE;
                            Col <= Col -1 ;
                        end
                    end
                end
            end
            
            BUILD_TREE:begin
                dataReady <= 0;
                if(Col) begin			//One step per cycle
                    probabilityList[Col-1] <= probabilityList[Col] + probabilityList[Col-1];		//Added probabilities
                    Col <= Col - 1;		//removing least symbol
                        
                    if ( k > 0) begin 
                        if (probabilityList[k] < probabilityList[Count]) begin
                            huffmanList[Count] <= huffmanList[k];
                            probabilityList[Count] <= probabilityList[k];
                            huffmanList[k] <= huffmanList[Count];
                            probabilityList[k] <= probabilityList[Count];
                        end
                        k = k - 1;
                    end
                    else begin
                        k <= Col - 1;
                    end
                end
                else begin
                    state <= SEND_TREE;
                    Count <= 0;
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
