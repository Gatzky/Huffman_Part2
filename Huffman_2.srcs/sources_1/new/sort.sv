`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.09.2020 11:50:51
// Design Name: 
// Module Name: sort
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

module sort(clock, input_array, output_array, output_symbol_array, output_prob_array);

parameter bitInByte = 7;
parameter dataLength = 10;     // Length of data, which will be coded
parameter maxValue = 255;

input clock;
input [bitInByte:0]input_array[dataLength:0];
output reg [bitInByte:0]output_array[dataLength:0];
output reg [bitInByte:0]output_symbol_array[dataLength:0];
output reg [bitInByte:0]output_prob_array[dataLength:0];

reg start_flag = 0;
reg [bitInByte:0]smallest = 255;
reg [bitInByte:0]output_count = 0;
reg [bitInByte:0]output_count_prob = 0;

reg [bitInByte:0]symbol_prob_count = 255;
reg [bitInByte:0]symbol_array[dataLength:0];
reg [bitInByte:0]prob_array[dataLength:0];

reg [bitInByte:0] i = 0;
reg [bitInByte:0] j = 0;
reg [bitInByte:0] k = 0;
reg [bitInByte:0] l = 0;

always @ (posedge clock) begin
    if (start_flag == 0) begin
        start_flag <= 1;
        symbol_array <= {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
        prob_array <= {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
        output_symbol_array <= {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
        output_prob_array <= {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    end
    
    if (i < maxValue) begin
        if (j <= dataLength) begin
            if (input_array[j] == i) begin
                if (symbol_array[symbol_prob_count] == i) begin
                    prob_array[symbol_prob_count] = prob_array[symbol_prob_count] + 1;
                end
                else begin
                    symbol_prob_count = symbol_prob_count + 1;
                    symbol_array[symbol_prob_count] = i;
                    prob_array[symbol_prob_count] = 1;
                end
                    
                output_array[output_count] <= i;
                output_count = output_count + 1;
            end
            j = j + 1;
        end
        else begin
            i <= i + 1;
            j <= 0;
        end
    end
    else begin        
        if (k < dataLength) begin
            if (l <= symbol_prob_count) begin
                if (prob_array[l] == k) begin    
                    output_prob_array[output_count_prob] <= k;
                    output_symbol_array[output_count_prob] <= symbol_array[output_count_prob];
                    output_count_prob = output_count_prob + 1;
                end
                l = l + 1;
            end
            else begin
                k <= k + 1;
                l <= 0;
            end
        end
    end
end

endmodule
