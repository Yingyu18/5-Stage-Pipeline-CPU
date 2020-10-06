
module multiplier( clk, dataA, dataB, dataOut, Multu, reset );

  input clk;
  input reset;
  input Multu;
  input [31:0] dataA;
  input [31:0] dataB;
  output [63:0] dataOut;

  reg        state;
  reg [7:0]  counter;
  reg [63:0] dataOut;
  reg [63:0] temp;
  reg [63:0] mcnd;
  reg [31:0] mpy;
  
  parameter MULTU = 6'd25;

  always@( posedge clk or reset )
  begin
    if ( reset )
		temp = 64'b0 ;
	else
	begin
		if ( Multu )
		begin
			mcnd <= {32'b0, dataA};
			mpy  <= {32'b0, dataB};
			temp <= 64'b0;
			counter <= 8'b0;
			state = 1'b1;
		end
		
		if ( state == 1'b1 )
		begin
			if ( counter == 8'd32 )
			begin
				dataOut = temp;
				state = 1'b0;
			end
			else if ( counter < 8'd32 )
			begin
				if ( mpy[0] == 1'b1 )
					temp = temp + mcnd;
				mcnd = mcnd << 1;
				mpy = mpy >> 1;
			end
			counter = counter + 1;
		end
    end
  end

endmodule

