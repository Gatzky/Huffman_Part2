`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Bartlomiej Gac 
// Module Name: get_data
//////////////////////////////////////////////////////////////////////////////////

module get_data(clock, inputData, nextState, receivedData);

parameter bitInByte = 7;        // Number of bits in bytes decrement by one - this simplification let miss phrase bIB -1 during array declaration
parameter charMaxValue = 255;   // Maximum value, which can be written on 8 bits
parameter dataLength = 10;     // Length of data, which will be coded
parameter SORT_DATA = 3'b010;

input clock;
input [bitInByte:0] inputData;
output reg [2:0] nextState;
output reg [bitInByte:0]receivedData[dataLength:0];

integer i = 32'h0;

always @ (posedge clock) begin
    if(i<=dataLength) begin
        receivedData[i]<=inputData;
        i<=i+1;
    end
    else begin
        i=0;
        nextState<=SORT_DATA;
    end
end

endmodule
