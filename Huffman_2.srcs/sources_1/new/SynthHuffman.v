`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.09.2020 15:54:26
// Design Name: 
// Module Name: SynthHuffman
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

module SynthHuffman(clock, reset, inputData, dataEnable, outputData, outputProbabilityList, dataReady, state);

parameter bitInByte = 7;        // Number of bits in bytes decrement by one - this simplification let miss phrase bIB -1 during array declaration
parameter charMaxValue = 255;   // Maximum value, which can be written on 8 bits
parameter dataLength = 10;     // Length of data, which will be coded
parameter INIT = 2'b00, GET_DATA = 2'b01, BUILD_TREE =  2'b10, SEND_TREE = 2'b11;

input clock;
input reset;
input [bitInByte:0] inputData;
input dataEnable;
output reg [bitInByte:0] outputData;
output reg [bitInByte:0] outputProbabilityList;
output reg dataReady;

output reg [1:0] state;
reg [bitInByte:0]probabilityList[charMaxValue:0];				
reg [bitInByte:0]symbolsList[charMaxValue:0];							
reg [bitInByte:0]huffmanList[charMaxValue:0];		//List used to perform the algorithm on

reg [bitInByte:0]col = 'b0;						   //Column length

//Loop variables
integer i= 32'h0;	
integer j= 32'h0;
integer k= 32'h0;
    							
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

                for(j=0;j<charMaxValue;j=j+1) begin
                   probabilityList[j] <= 'b0;
                   symbolsList[j] <= 'bz;
                end
                
                state <= GET_DATA;
            end
            
            GET_DATA:begin
                if(dataEnable) begin
                    i <= i+1'b1; 
                    for(j=0; j<=charMaxValue; j=j+1) begin
                        if(inputData == symbolsList[j]) begin
                            probabilityList[j] <= probabilityList[j] + 1;  
                            for(k=j-1; k>=0; k=k-1) begin
                                if(probabilityList[k] <= probabilityList[j]) begin
                                    symbolsList[j] <= symbolsList[k];
                                    probabilityList[j] <= probabilityList[k];
                                    symbolsList[k] <= symbolsList[j];
                                    probabilityList[k] <= probabilityList[j];
                                            
                                    huffmanList[j] <= symbolsList[j];
                                    huffmanList[k] <= symbolsList[k];            
                                end
                            end	
                            flag <= 1;
                       end	
                    end
                
                    if(!flag) begin
                        symbolsList[col] <= inputData;
                        huffmanList[col] <= inputData;
                        probabilityList[col] <= 'b1;
                        col <= col+1;
                    end		 
                    flag <= 0;
                    if(i == dataLength)	begin	
                        state <= BUILD_TREE;
                        col <= col -1 ;
                   end
                end
            end
            
            BUILD_TREE:begin
                dataReady <= 0;
                if(col) begin			//One step per cycle
                    probabilityList[col-1] <= probabilityList[col] + probabilityList[col-1];		//Added probabilities
                
                    col <= col - 1;		//removing least symbol
                
                    for(k = 255;k>=0;k=k-1) begin
                        if (k < col) begin
                            if (probabilityList[k] < probabilityList[j]) begin
                                huffmanList[j] <= huffmanList[k];
                                probabilityList[j] <= probabilityList[k];
                                huffmanList[k] <= huffmanList[j];
                                probabilityList[k] <= probabilityList[j];
                            end
                        end
                    end
                end
                else begin
                    state <= SEND_TREE; 
                    i <= 0;
                    j <= 0;
                end
            end
            SEND_TREE:begin
               dataReady <= 1;
               for(k=0;k<=dataLength;k=k+1) begin
                    outputData <= huffmanList[k];
               end
               for(k=0;k<=dataLength;k=k+1) begin
                    outputProbabilityList <= probabilityList[k];
               end
               state <= INIT;
            end
        endcase
    end
end

endmodule
