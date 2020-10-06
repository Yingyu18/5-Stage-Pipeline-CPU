
module EX_MEM ( clk, rst, en_reg, WB_out, MEM_out, alu_out, RD2_out, WN_out,
				  WB_in,  MEM_in,  alu_in,  RD2_in,  WN_in );
    input clk, rst, en_reg;
	
	input [1:0]  WB_in;
	input [1:0]  MEM_in;
	input [4:0]	 WN_in;
    input [31:0] RD2_in, alu_in;
	
	output [1:0]  WB_out;
	output [1:0]  MEM_out;
	output [4:0]  WN_out;
    output [31:0] RD2_out, alu_out;
	
	reg	  [1:0]  WB_out;
	reg   [1:0]  MEM_out;
	reg   [4:0]  WN_out;
    reg   [31:0] RD2_out, alu_out;
	
   
    always @( posedge clk ) begin
        if ( rst ) begin
		WB_out    <= 2'b0;
		MEM_out   <= 2'b0;
		alu_out   <= 32'b0; 
		RD2_out   <= 32'b0; 
		WN_out    <= 5'b0; 
	end
        else if ( en_reg ) begin
		WB_out    <=  WB_in;
		MEM_out   <=  MEM_in;
		alu_out   <=  alu_in; 
		RD2_out   <=  RD2_in; 
		WN_out    <=  WN_in; 
	end
    end
endmodule
	

