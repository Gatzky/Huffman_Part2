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

module SynthHuffman(clock, reset, inputData, dataEnable, outputData, outputProbabilityList, dataReady);

parameter bitInByte = 7;        // Number of bits in bytes decrement by one - this simplification let miss phrase bIB -1 during array declaration
parameter charMaxValue = 20;   // Maximum value, which can be written on 8 bits
parameter dataLength = 255;     // Length of data, which will be coded
parameter INIT = 3'b001, GET_DATA = 3'b001, BUILD_TREE =  3'b010, SEND_TREE = 3'b100;

input clock;
input reset;
input [bitInByte:0] inputData;
input dataEnable;
output reg [bitInByte:0] outputData;
output reg [bitInByte:0] outputProbabilityList;
output reg dataReady;

reg [1:0] state;
reg [bitInByte:0]probabilityList[charMaxValue:0];				
reg [bitInByte:0]symbolsList[charMaxValue:0];							

reg [bitInByte:0]huffmanList[charMaxValue:0];		//List used to perform the algorithm on
reg [bitInByte:0]pairList[2*charMaxValue+2:0];	    //The pair list, an abstraction for the tree concept. even - decode 0. odd - decode 1.
												
integer step = 0;                                   //Number of steps of tree building algorithm

reg [bitInByte:0]col = 'b0;						   //Column length

//Loop variables
integer i= 32'h0;	
integer j= 32'h0;
integer k= 32'h0;
    							
//Flag
reg flag = 0;										
    
integer pair_count= 0;

always @ (posedge clock)
begin
    if(reset==1'b1) begin
        dataReady <= 1'b0;
        state <= INIT;
    end
    else begin
        case(state)
            INIT:begin
                symbolsList[0] <= 'b0;
                probabilityList[0] <= 'b0;
                
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
                                    probabilityList[k] <= symbolsList[k];
                                            
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
              
                    pairList[step] <= huffmanList[col-1];			//Add in pair table
                    pairList[step+1] <= huffmanList[col];
                    step <= step + 2;
                
                    col <= col - 1;		//removing least symbol
                    pair_count <= pair_count +2;
                
                    for(k = 0;k>=0;k=k-1) begin
                        if ((probabilityList[k] < probabilityList[j]) & (k > col)) begin
                            huffmanList[j] <= huffmanList[k];
                            probabilityList[j] <= probabilityList[k];
                            huffmanList[k] <= huffmanList[j];
                            probabilityList[k] <= probabilityList[j];
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
               for(k=0;k<charMaxValue;k=k+1) begin
                    outputData <= huffmanList[k];
               end
               for(k=0;k<charMaxValue;k=k+1) begin
                    outputProbabilityList <= probabilityList[k];
               end
               
               //dataReady <= 0;
            end
        endcase
    end
end

endmodule
