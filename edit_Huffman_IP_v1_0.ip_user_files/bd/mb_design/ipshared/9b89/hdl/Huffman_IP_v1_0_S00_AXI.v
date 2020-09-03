
`timescale 1 ns / 1 ps

	module Huffman_IP_v1_0_S00_AXI #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 4
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line

		// Global Clock Signal
		input wire  S_AXI_ACLK,
		// Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		// Write address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		// Write channel Protection type. This signal indicates the
    		// privilege and security level of the transaction, and whether
    		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_AWPROT,
		// Write address valid. This signal indicates that the master signaling
    		// valid write address and control information.
		input wire  S_AXI_AWVALID,
		// Write address ready. This signal indicates that the slave is ready
    		// to accept an address and associated control signals.
		output wire  S_AXI_AWREADY,
		// Write data (issued by master, acceped by Slave) 
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
		// Write strobes. This signal indicates which byte lanes hold
    		// valid data. There is one write strobe bit for each eight
    		// bits of the write data bus.    
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
		// Write valid. This signal indicates that valid write
    		// data and strobes are available.
		input wire  S_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    		// can accept the write data.
		output wire  S_AXI_WREADY,
		// Write response. This signal indicates the status
    		// of the write transaction.
		output wire [1 : 0] S_AXI_BRESP,
		// Write response valid. This signal indicates that the channel
    		// is signaling a valid write response.
		output wire  S_AXI_BVALID,
		// Response ready. This signal indicates that the master
    		// can accept a write response.
		input wire  S_AXI_BREADY,
		// Read address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		// Protection type. This signal indicates the privilege
    		// and security level of the transaction, and whether the
    		// transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_ARPROT,
		// Read address valid. This signal indicates that the channel
    		// is signaling valid read address and control information.
		input wire  S_AXI_ARVALID,
		// Read address ready. This signal indicates that the slave is
    		// ready to accept an address and associated control signals.
		output wire  S_AXI_ARREADY,
		// Read data (issued by slave)
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		// Read response. This signal indicates the status of the
    		// read transfer.
		output wire [1 : 0] S_AXI_RRESP,
		// Read valid. This signal indicates that the channel is
    		// signaling the required read data.
		output wire  S_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    		// accept the read data and response information.
		input wire  S_AXI_RREADY
	);

	// AXI4LITE signals
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	reg  	axi_awready;
	reg  	axi_wready;
	reg [1 : 0] 	axi_bresp;
	reg  	axi_bvalid;
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
	reg  	axi_arready;
	reg [C_S_AXI_DATA_WIDTH-1 : 0] 	axi_rdata;
	reg [1 : 0] 	axi_rresp;
	reg  	axi_rvalid;

	// Example-specific design signals
	// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	// ADDR_LSB is used for addressing 32/64 bit registers/memories
	// ADDR_LSB = 2 for 32 bits (n downto 2)
	// ADDR_LSB = 3 for 64 bits (n downto 3)
	localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
	localparam integer OPT_MEM_ADDR_BITS = 1;
	//----------------------------------------------
	//-- Signals for user logic register space example
	//------------------------------------------------
	//-- Number of Slave Registers 4
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg0;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg1;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg2;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg3;
	wire	 slv_reg_rden;
	wire	 slv_reg_wren;
	reg [C_S_AXI_DATA_WIDTH-1:0]	 reg_data_out;
	integer	 byte_index;
	reg	 aw_en;

	// I/O Connections assignments

	assign S_AXI_AWREADY	= axi_awready;
	assign S_AXI_WREADY	= axi_wready;
	assign S_AXI_BRESP	= axi_bresp;
	assign S_AXI_BVALID	= axi_bvalid;
	assign S_AXI_ARREADY	= axi_arready;
	assign S_AXI_RDATA	= axi_rdata;
	assign S_AXI_RRESP	= axi_rresp;
	assign S_AXI_RVALID	= axi_rvalid;
	// Implement axi_awready generation
	// axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	// de-asserted when reset is low.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awready <= 1'b0;
	      aw_en <= 1'b1;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // slave is ready to accept write address when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_awready <= 1'b1;
	          aw_en <= 1'b0;
	        end
	        else if (S_AXI_BREADY && axi_bvalid)
	            begin
	              aw_en <= 1'b1;
	              axi_awready <= 1'b0;
	            end
	      else           
	        begin
	          axi_awready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_awaddr latching
	// This process is used to latch the address when both 
	// S_AXI_AWVALID and S_AXI_WVALID are valid. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awaddr <= 0;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // Write Address latching 
	          axi_awaddr <= S_AXI_AWADDR;
	        end
	    end 
	end       

	// Implement axi_wready generation
	// axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	// de-asserted when reset is low. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_wready <= 1'b0;
	    end 
	  else
	    begin    
	      if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en )
	        begin
	          // slave is ready to accept write data when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_wready <= 1'b1;
	        end
	      else
	        begin
	          axi_wready <= 1'b0;
	        end
	    end 
	end       

	// Implement memory mapped register select and write logic generation
	// The write data is accepted and written to memory mapped registers when
	// axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	// select byte enables of slave registers while writing.
	// These registers are cleared when reset (active low) is applied.
	// Slave register write enable is asserted when valid address and data are available
	// and the slave is ready to accept the write address and write data.
	assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      slv_reg0 <= 0;
	      slv_reg1 <= 0;
	      //slv_reg2 <= 0;
	      //slv_reg3 <= 0;
	    end 
	  else begin
	    if (slv_reg_wren)
	      begin
	        case ( axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
	          2'h0:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 0
	                slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          2'h1:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 1
	                slv_reg1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          2'h2:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 2
	                //slv_reg2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          2'h3:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 3
	                //slv_reg3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          default : begin
	                      slv_reg0 <= slv_reg0;
	                      slv_reg1 <= slv_reg1;
	                      slv_reg2 <= slv_reg2;
	                      slv_reg3 <= slv_reg3;
	                    end
	        endcase
	      end
	  end
	end    

	// Implement write response logic generation
	// The write response and response valid signals are asserted by the slave 
	// when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	// This marks the acceptance of address and indicates the status of 
	// write transaction.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_bvalid  <= 0;
	      axi_bresp   <= 2'b0;
	    end 
	  else
	    begin    
	      if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
	        begin
	          // indicates a valid write response is available
	          axi_bvalid <= 1'b1;
	          axi_bresp  <= 2'b0; // 'OKAY' response 
	        end                   // work error responses in future
	      else
	        begin
	          if (S_AXI_BREADY && axi_bvalid) 
	            //check if bready is asserted while bvalid is high) 
	            //(there is a possibility that bready is always asserted high)   
	            begin
	              axi_bvalid <= 1'b0; 
	            end  
	        end
	    end
	end   

	// Implement axi_arready generation
	// axi_arready is asserted for one S_AXI_ACLK clock cycle when
	// S_AXI_ARVALID is asserted. axi_awready is 
	// de-asserted when reset (active low) is asserted. 
	// The read address is also latched when S_AXI_ARVALID is 
	// asserted. axi_araddr is reset to zero on reset assertion.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_arready <= 1'b0;
	      axi_araddr  <= 32'b0;
	    end 
	  else
	    begin    
	      if (~axi_arready && S_AXI_ARVALID)
	        begin
	          // indicates that the slave has acceped the valid read address
	          axi_arready <= 1'b1;
	          // Read address latching
	          axi_araddr  <= S_AXI_ARADDR;
	        end
	      else
	        begin
	          axi_arready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_arvalid generation
	// axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	// S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	// data are available on the axi_rdata bus at this instance. The 
	// assertion of axi_rvalid marks the validity of read data on the 
	// bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	// is deasserted on reset (active low). axi_rresp and axi_rdata are 
	// cleared to zero on reset (active low).  
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rvalid <= 0;
	      axi_rresp  <= 0;
	    end 
	  else
	    begin    
	      if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
	        begin
	          // Valid read data is available at the read data bus
	          axi_rvalid <= 1'b1;
	          axi_rresp  <= 2'b0; // 'OKAY' response
	        end   
	      else if (axi_rvalid && S_AXI_RREADY)
	        begin
	          // Read data is accepted by the master
	          axi_rvalid <= 1'b0;
	        end                
	    end
	end    

	// Implement memory mapped register select and read logic generation
	// Slave register read enable is asserted when valid address is available
	// and the slave is ready to accept the read address.
	assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
	always @(*)
	begin
	      // Address decoding for reading registers
	      case ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
	        2'h0   : reg_data_out <= slv_reg0;
	        2'h1   : reg_data_out <= slv_reg1;
	        2'h2   : reg_data_out <= slv_reg2;
	        2'h3   : reg_data_out <= slv_reg3;
	        default : reg_data_out <= 0;
	      endcase
	end

	// Output register or memory read data
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rdata  <= 0;
	    end 
	  else
	    begin    
	      // When there is a valid read address (S_AXI_ARVALID) with 
	      // acceptance of read address by the slave (axi_arready), 
	      // output the read dada 
	      if (slv_reg_rden)
	        begin
	          axi_rdata <= reg_data_out;     // register read data
	        end   
	    end
	end    

	// Add user logic here
	
        //Reset signal for cordic processor
        wire ARESET;
        assign ARESET = ~S_AXI_ARESETN;
        
        //Transfer output from cordic processor to output registers
        wire [C_S_AXI_DATA_WIDTH-1:0] slv_wire2;
        wire [C_S_AXI_DATA_WIDTH-1:0] slv_wire3;
        always @( posedge S_AXI_ACLK )
        begin
            slv_reg2 <= slv_wire2;
            slv_reg3 <= slv_wire3;
        end
        
        //Assign zeros to unused bits
        assign slv_wire2[31:17] = 15'b0;
        assign slv_wire3[31:2] = 30'b0;
    
        HuffmanEncoder HuffmanEncoder_inst( S_AXI_ACLK, //clock,
                                            slv_reg0,           //inputData
                                            slv_reg1[0],        //dataEnable
                                            slv_wire2[16:0],    //outputData,
                                            slv_wire3[0],    //dataReady,
                                            slv_wire3[1]    //codeMapReady
                                            ); 
    
        // User logic ends

	endmodule
	
    //****************************************************************************/
    
    module HuffmanEncoder
    #(
        parameter bitInByte = 7,        // Number of bits in bytes decrement by one - this simplification let miss phrase bIB -1 during array declaration
        parameter charMaxValue = 255,   // Maximum value, which can be written on 8 bits
        parameter dataLength = 100      // Length of data, which will be coded
    )
    (
        input wire clock,								
        input wire [bitInByte:0]inputData,				
        input wire dataEnable,			
                    
        output reg [2*bitInByte+2:0]outputData,
        output reg dataReady,				
        output reg codeMapReady						
    );	
    
    /**
        @enum States
        @brief State of FSM machine
    */						
        enum{
            INIT =  32'b001,
            GET_DATA,
            BUILD_TREE,
            DECODE_TREE,
            SEND_SYMBOLS,
            SEND_CODE,
            SEND_LENGTH
        }States;
    
        reg [bitInByte:0]probabilityList[charMaxValue:0];				
        reg [bitInByte:0]temp2;
        reg [bitInByte:0]symbolsList[charMaxValue:0];		
        reg [bitInByte:0]Sym,temp1;						
    
        reg [0:2*bitInByte+2]codesList[charMaxValue:0];		
        reg [bitInByte:0]codeLength[charMaxValue:0];		
    
        reg [bitInByte:0]huffmanList[charMaxValue:0];		//List used to perform the algorithm on
        reg [bitInByte:0]pairList[2*charMaxValue+2:0];	    //The pair list, an abstraction for the tree concept. even - decode 0. odd - decode 1.
    
        reg [2:0]state = INIT;													
        reg [bitInByte:0]pos,newpos = 0;				    //Variables to hold values of positions in pair table
        integer step = 0;                                   //Number of steps of tree building algorithm
    
        reg [bitInByte:0]col = 'b0;						   //Column length
        reg [bitInByte:0]Data[dataLength:0];
    
        //Loop variables
        integer i= 32'h0;	
        integer j= 32'h0;
        integer k= 32'h0;
                                    
        //Flag
        reg flag = 0;										
        
        integer pair_count= 0, sym_count = 0;
    
    
    always @(posedge clock) begin
    
        case(state)
        
        
        INIT: begin
        symbolsList[0] = 'b0;
        probabilityList[0] = 'b0;
        
        for(j=0;j<charMaxValue;j=j+1) begin
        codesList[j] = 'bz;
        probabilityList[j] = 'b0;
        symbolsList[j] = 'bz;
        codeLength[j] = 'b0;
        end
        
        
        outputData = 'bz;
        state = GET_DATA;
        end
        
        
        GET_DATA: begin
        if(dataEnable) begin
            Data[i] = inputData;
            i=i+1'b1;
            
                for(j=0;j<=charMaxValue; j=j+1) begin
                    if(inputData == symbolsList[j]) begin
                        probabilityList[j] = probabilityList[j] + 1;
                        
                        begin:SORT
                            for(k=j-1;k>=0;k=k-1) begin
                                if(probabilityList[k] <= probabilityList[j]) begin
                                    temp1 = symbolsList[j];
                                    temp2 = probabilityList[j];
                                    symbolsList[j] = symbolsList[k];
                                    probabilityList[j] = probabilityList[k];
                                    symbolsList[k] = temp1;
                                    probabilityList[k] = temp2;
                                    
                                    huffmanList[j] = symbolsList[j];
                                    huffmanList[k] = symbolsList[k];
                                    
                                end
                            end
                        end		
                        flag=1;
                    end	
                end		
                
                    
                if(!flag) begin
                    symbolsList[col] = inputData;
                    huffmanList[col] = inputData;
                    probabilityList[col] = 'b1;
                    col = col+1;
                end		
                
                flag= 0;
                
            if(i == dataLength)	begin	
            state = BUILD_TREE;
            sym_count = col;
            //$display("col:",col);
            //for(i=0;i<col_length;i=i+1)
            //$display(huffmanList[i],"  ", probabilityList[i]);
            col = col -1 ;
            end
        end
        end
        
        
        BUILD_TREE: begin
            codeMapReady = 0;
            dataReady = 0;
            if(col) begin			//One step per cycle
                probabilityList[col-1] = probabilityList[col] + probabilityList[col-1];		//Added probabilities
            
                pairList[step] = huffmanList[col-1];			//Add in pair table
                pairList[step+1] = huffmanList[col];
            
                col = col - 1;		//removing least symbol
                pair_count = pair_count +2;
            
                begin:SORT1
                    for(k=col-1;k>=0;k=k-1) begin
                        if(probabilityList[k] < probabilityList[j]) begin
                            temp1 = huffmanList[j];
                            temp2 = probabilityList[j];
                            huffmanList[j] = huffmanList[k];
                            probabilityList[j] = probabilityList[k];
                            huffmanList[k] = temp1;
                            probabilityList[k] = temp2;
                        end
                    end
                end
                
                step = step + 2;
            end	
            
            else 
                if(col == 0) begin
                state = DECODE_TREE; 
                //for(i=0;i<2*col_length;i=i+1)
                //$display(pairList[i]);
                //$display(sym_count, "  ",pair_count);
                i=0;
                j=0;
                
                Sym = symbolsList[0];
                end
            end
        
        
        DECODE_TREE: begin
            codeMapReady = 1;
            dataReady = 1;
            //One symbol per cycle decoding
            //i - symbol number, j - iteration for code
            
            if(Sym == pairList[j]) begin
            
                if(j%2 == 0) begin
                    codesList[i]= codesList[i]<<1 | 'b0;
                    j=j+2;
                end
                    
                else begin
                    codesList[i]= codesList[i]<<1 | 'b1;
                    Sym = pairList[j-1]; 
                    j=j+1;
                end	
                
                codeLength[i] = codeLength[i] + 1;
            end
            
            else
                j=j+1;
            
            if(j>pair_count-1) begin
                i=i+1;
                j=0;
                Sym = symbolsList[i];
                end
            
            if(i==sym_count)	begin
                state = SEND_LENGTH;
                //for(k=0;k<col_length;k=k+1)
                //$display(symbolsList[k],"  ","%b",codesList[k],"  ",codeLength[k]);
                i=0;
            end
            
        end
    
    
        SEND_LENGTH: begin
        //send data in reverse order	
            outputData = codeLength[i];
            i = i+1;
            
            if(i == sym_count) begin
                state = SEND_CODE;
                i = 0;
                end
            
            dataReady = 1;	
            codeMapReady = 0;
        end
        
        SEND_CODE: begin
            dataReady = 0;
            codeMapReady = 1;	
            outputData = codesList[i];
            i = i+1;
            
            if(i == sym_count) begin
                state = SEND_SYMBOLS;
                i = 0;
                end
            end
        
        SEND_SYMBOLS: begin
            dataReady = 1;
            codeMapReady = 1;
            outputData = symbolsList[i];
            i = i+1;	
            if(i == sym_count)
                state = GET_DATA;
            end
        
        endcase
    end
    
    endmodule
