`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.09.2020 18:45:46
// Design Name: 
// Module Name: SynthHuffman_tb
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


module SynthHuffman_tb();

parameter bitInByte = 7;

reg clock;
reg reset;
reg [7:0] inputData;
reg dataEnable;
wire [7:0] outputData;
wire [7:0] outputProbabilityList;
wire dataReady;

// Instantiate the module
SynthHuffman UUT (clock, reset, inputData, dataEnable, outputData, outputProbabilityList, dataReady);

initial begin
    clock = 1'b0;
    reset = 1'b0;
    inputData = 8'b00000011;
    dataEnable = 1'b1;
    #5 reset = 1'b1;
    #5 reset = 1'b0;
end

always
    #1 clock <= ~clock;

always@(posedge clock) begin
    #100 inputData = inputData + 1;
end

endmodule
