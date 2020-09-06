/* test bench */
`timescale 1ns / 1ps

module huff_encoder_tb();

reg clock;
reg reset;
reg [2:0] inputData;
reg dataEnable;
wire [6:0] outputData;
wire [7:0] outputProbabilityList;
wire dataReady;
wire [1:0] state;

integer i,handle;
integer seed = 1;

// Instantiate the module
SynthHuffman UUT (clock, reset, inputData, dataEnable, outputData, outputProbabilityList, dataReady, state);

initial begin 
	forever #10 clock = ~clock;
end
	
	initial begin
		// Initialize Inputs
		
		//$log("verilog.log");
		clock = 0;
		inputData = 0;
		dataEnable = 0;
		
		handle = $fopen ("Output.txt");
		handle = handle | 1;
		
		//$fmonitor(1,"clock:",clock," data_recv:",data_recv,"   code_map:",code_map_recv,"   data_enable:", data_enable,"   data_out:%b",data_out,"   data_in:%b",data_in);
		
		for(i=0;i<22;i=i+1) begin 
				#20 dataEnable=1;
				inputData = $random(seed);
		end
		
		#10
		inputData = 'bz;
		dataEnable = 0;
		
		#2100;
		$finish;
		$fclose(handle);

	end
      
endmodule
