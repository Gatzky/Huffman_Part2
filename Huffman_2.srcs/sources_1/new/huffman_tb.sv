`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Bartlomiej Gac 
// Module Name: huffman_tb
//////////////////////////////////////////////////////////////////////////////////

module huffman_tb();

parameter bitInByte = 7;
parameter dataLength = 10;     // Length of data, which will be coded

reg clock;
reg reset;
reg [7:0] inputData;
reg dataEnable;
wire [7:0] outputData;
wire dataReady;

reg [2:0] count = 0;

// Instantiate the module
huffman UUT(clock, reset, inputData, outputData, dataReady);

initial begin
    clock <= 1'b0;
    reset <= 1'b0;
    dataEnable <= 1'b1;
    inputData <= 8'b00000000;
    #5 reset <= 1'b1;
    #5 reset <= 1'b0;
end

always
    #5 clock <= ~clock;
    
always@(posedge clock) begin
    #10 inputData <= 2;
    #10 inputData <= 4;
    #10 inputData <= 7;
    #10 inputData <= 10;
    #10 inputData <= 21;
end

always@(posedge dataReady) begin
    $display("input: {2, 4, 7, 10, 21, 2, 4, 4");
    #10 $display("input = 2, output=%b", outputData);
    #10 $display("input = 4, output=%b", outputData);
    #10 $display("input = 7, output=%b", outputData);
    #10 $display("input = 10, output=%b", outputData);
    #10 $display("input = 21, output=%b", outputData);
    #10 $display("input = 2, output=%b", outputData);
    #10 $display("input = 4, output=%b", outputData);
    #10 $display("input = 4, output=%b", outputData);
end

endmodule
