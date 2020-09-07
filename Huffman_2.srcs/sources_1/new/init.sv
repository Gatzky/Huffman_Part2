`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Bartlomiej Gac 
// Module Name: init
//////////////////////////////////////////////////////////////////////////////////

module init(clock, probabilityList, symbolsList, huffmanList, state, dataReady);

parameter bitInByte = 7;        // Number of bits in bytes decrement by one - this simplification let miss phrase bIB -1 during array declaration
parameter dataLength = 10;     // Length of data, which will be coded
parameter GET_DATA = 3'b001;

input clock;
output reg [bitInByte:0]probabilityList[dataLength:0];
output reg [bitInByte:0]symbolsList[dataLength:0];
output reg [bitInByte:0]huffmanList[dataLength:0];		//List used to perform the algorithm on
output reg [2:0] state;
output reg dataReady;

integer i= 32'h0;

always @ (posedge clock) begin
    dataReady <= 0;
    
    for(i=0;i<=dataLength;i=i+1) begin
        probabilityList[i] <= 'b0;
        symbolsList[i] <= 'bz;
        huffmanList[i] <= 'b0;
    end
                    
    state <= GET_DATA;
end
    
endmodule
