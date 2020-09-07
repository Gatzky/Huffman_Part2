`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Bartlomiej Gac 
// Module Name: huffman_tb
//////////////////////////////////////////////////////////////////////////////////

module huffman_tb();

parameter bitInByte = 7;

reg clock;
reg reset;
reg [bitInByte:0] inputData;
wire [bitInByte:0] outputData;
wire dataReady;

reg [2:0] count = 0;

// Instantiate the module
huffman UUT(clock, reset, inputData, outputData, dataReady);

initial begin
    clock <= 1'b0;
    reset <= 1'b0;
    inputData <= 8'b00000000;
    #5 reset <= 1'b1;
    #5 reset <= 1'b0;
end

always
    #5 clock <= ~clock;
    
always@(posedge clock) begin
    #100 inputData <= 32'h3E;
    #10 inputData <= 32'h71;
    #10 inputData <= 32'h17;
    #10 inputData <= 32'h33;
    #10 inputData <= 32'h17;
    #10 inputData <= 32'hAB;
    #10 inputData <= 32'hCF;
    #10 inputData <= 32'h71;
    #10 inputData <= 32'h71;
end

always@(posedge dataReady) begin
    $display("input: {0x71, 0x17, 0x33, 0x17, 0xAB, 0xCF, 0x71, 0x71");
    #10 $display("input = 0x71, output=%b", outputData);
    #10 $display("input = 0x17, output=%b", outputData);
    #10 $display("input = 0x33, output=%b", outputData);
    #10 $display("input = 0x17, output=%b", outputData);
    #10 $display("input = 0xAB, output=%b", outputData);
    #10 $display("input = 0xCF, output=%b", outputData);
    #10 $display("input = 0x71, output=%b", outputData);
    #10 $display("input = 0x71, output=%b", outputData);
end

endmodule
