`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.09.2020 12:02:10
// Design Name: 
// Module Name: sort_tb
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


module sort_tb();

parameter bitInByte = 7;
parameter dataLength = 10;     // Length of data, which will be coded

reg clock;
reg [bitInByte:0]input_array[dataLength:0];
wire [bitInByte:0]output_array[dataLength:0];
wire [bitInByte:0]output_symbol_array[dataLength:0];
wire [bitInByte:0]output_prob_array[dataLength:0];

sort UUT(clock, input_array, output_array, output_symbol_array, output_prob_array);

initial begin
    clock <= 1'b0;
    input_array <= {1, 2, 1, 3, 5, 7, 9, 1, 2, 5, 10};
end

always
    #5 clock <= ~clock;

endmodule
