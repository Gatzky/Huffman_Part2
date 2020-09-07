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
wire [7:0] outputProbabilityList;
wire dataReady;
wire [1:0] state;
wire [bitInByte:0]outHuffmanList[dataLength:0];		//List used to perform the algorithm on

reg [2:0] count = 0;

// Instantiate the module
huffman UUT (clock, reset, dataReady, state);

initial begin
    clock <= 1'b0;
    reset <= 1'b0;
    #5 reset <= 1'b1;
    #5 reset <= 1'b0;
end

always
    #5 clock <= ~clock;
    
always@(posedge clock) begin
    /*if (state != 1) begin
        count = count + 1;
        if (count == 5) begin
            count = 0;
            inputData <= inputData + 100;
            inputData <= inputData + 100;
        end
    end
    else begin
        count = 0;
    end*/
end

always@(posedge dataReady) begin
    //inputData <= inputData + 100;
    //dataEnable <= 1'b0;
end

endmodule
