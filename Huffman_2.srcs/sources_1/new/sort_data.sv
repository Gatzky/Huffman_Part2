`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Bartlomiej Gac 
// Module Name: sort_data
//////////////////////////////////////////////////////////////////////////////////

module sort_data(clock, symProbLength, symbolsList, huffmanList, receivedData, encodedData);

parameter bitInByte = 7;        // Number of bits in bytes decrement by one - this simplification let miss phrase bIB -1 during array declaration
parameter dataLength = 7;     // Length of data, which will be coded

input clock;
input [bitInByte:0]symProbLength;
input [bitInByte:0]symbolsList[dataLength:0];
input [bitInByte:0]huffmanList[dataLength:0];
input [bitInByte:0]receivedData[dataLength:0];
output reg [bitInByte:0]encodedData[dataLength:0];
reg [bitInByte:0] template;
reg [bitInByte:0] start_flag = 0;

integer i = 0;
integer j = 0;

always @ (posedge clock) begin
    if (start_flag == 0) begin
        start_flag <= 1;
        encodedData <= {0, 0, 0, 0, 0, 0, 0, 0};
    end
    
    if(i < dataLength) begin
        if (j < symProbLength) begin
            if (symbolsList[j] == receivedData[i]) begin
                encodedData[i] <= huffmanList[j];
            end
            j = j + 1;
        end
        i = i + 1;
        //else begin
          //  i = i + 1;
        //end
    end
    else begin
        i <= 0;
        j <= 0;
    end
end

endmodule
