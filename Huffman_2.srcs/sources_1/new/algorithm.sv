`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.09.2020 15:58:48
// Design Name: 
// Module Name: algorithm
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

module algorithm(clock, symProbLength, huffmanList);

parameter bitInByte = 7;        // Number of bits in bytes decrement by one - this simplification let miss phrase bIB -1 during array declaration
parameter dataLength = 9;     // Length of data, which will be coded

input clock;
input [bitInByte:0]symProbLength;
output reg [bitInByte:0]huffmanList[dataLength:0];
reg [bitInByte:0] template;
reg [bitInByte:0] start_flag = 0;

integer i = 0;
integer j = 0;

always @ (posedge clock) begin
    if (start_flag == 0) begin
        start_flag <= 1;
        huffmanList <= {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
        i = 0;
        j = 0;
        template <= 8'b11111111;
    end
    else begin
        
        if (i < symProbLength) begin
            huffmanList[i] <= (template >> (dataLength - 2 - i));
            i <= i + 1;
        end
        else begin
            i <= 0;
        end
        
        if (i < (symProbLength - 1)) begin
            huffmanList[i] = huffmanList[i] - 1;
            i <= i +1;
        end
        
        huffmanList[symProbLength-1] <= huffmanList[symProbLength-2] + 1;
        huffmanList[0] <= 0;
        
    end
    

    /*template <= 8'b00000000;
    if (i <= symProbLength) begin
        if (j <= i) begin
            huffmanList[i] <= ((template << j) | 8'b00000001);
            j = j + 1;
        end
        else begin
            i <= i +1;
            j <= 0;
        end     
    end*/
  
end

endmodule
