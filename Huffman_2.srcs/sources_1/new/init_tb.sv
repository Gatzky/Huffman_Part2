`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Bartlomiej Gac 
// Module Name: init_tb
//////////////////////////////////////////////////////////////////////////////////

module init_tb();

parameter bitInByte = 7;        // Number of bits in bytes decrement by one - this simplification let miss phrase bIB -1 during array declaration
parameter dataLength = 10;     // Length of data, which will be coded

reg clock;
wire [bitInByte:0]probabilityList[dataLength:0];				
wire [bitInByte:0]symbolsList[dataLength:0];
wire [bitInByte:0]huffmanList[dataLength:0];	
wire [2:0] nextState;
wire dataReady;

// Instantiate the module
init UUT (clock, probabilityList, symbolsList, huffmanList, nextState, dataReady);

initial begin
    clock <= 1'b0;
end

always
    #5 clock <= ~clock;

endmodule
