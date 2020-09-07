`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Bartlomiej Gac 
// Module Name: get_data_tb
//////////////////////////////////////////////////////////////////////////////////

module get_data_tb();

parameter bitInByte = 7;        // Number of bits in bytes decrement by one - this simplification let miss phrase bIB -1 during array declaration
parameter dataLength = 10;     // Length of data, which will be coded

reg clock;
reg [bitInByte:0] inputData;
wire [2:0] nextState;
wire [bitInByte:0]receivedData[dataLength:0];

get_data UUT(clock, inputData, nextState, receivedData);

initial begin
    clock <= 1'b0;
    inputData <= 8'b000000000;
end

always
    #5 clock <= ~clock;
    
always@(posedge clock) begin
    #5 inputData <= inputData + 100; 
end

endmodule
