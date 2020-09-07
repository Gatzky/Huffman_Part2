`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Bartlomiej Gac 
// Module Name: sort_data_tb
//////////////////////////////////////////////////////////////////////////////////

module sort_data_tb();

parameter bitInByte = 7;        // Number of bits in bytes decrement by one - this simplification let miss phrase bIB -1 during array declaration
parameter dataLength = 7;     // Length of data, which will be coded

reg clock;
reg [bitInByte:0]symProbLength;
reg [bitInByte:0]symbolsList[dataLength:0];
reg [bitInByte:0]huffmanList[dataLength:0];
reg [bitInByte:0]receivedData[dataLength:0];
wire[bitInByte:0]encodedData[dataLength:0];

sort_data UUT(clock, symProbLength, symbolsList, huffmanList, receivedData, encodedData);

initial begin
    clock <= 1'b0;
    symProbLength <= 6;
    receivedData[0] <= 2;
    receivedData[1] <= 1;
    receivedData[2] <= 7;
    receivedData[3] <= 5;
    receivedData[4] <= 2;
    receivedData[5] <= 1;
    receivedData[6] <= 7;
    receivedData[7] <= 5;
    symbolsList[0] <= 7;
    symbolsList[1] <= 2;
    symbolsList[2] <= 5;
    symbolsList[3] <= 1;
    symbolsList[4] <= 0;
    symbolsList[5] <= 0;
    symbolsList[6] <= 0;
    symbolsList[7] <= 0;
    huffmanList[0] <= 11;
    huffmanList[1] <= 12;
    huffmanList[2] <= 13;
    huffmanList[3] <= 14;
    huffmanList[4] <= 0;
    huffmanList[5] <= 0;
    huffmanList[6] <= 0;
    huffmanList[7] <= 0;
    
end

always
    #5 clock <= ~clock;
    
always@(posedge clock) begin
    //TO DO
end
    
endmodule
