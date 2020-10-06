
module MUX_ALU_1bit( dataOut, e1, e2, e3, e4, sel );

  input e1, e2, e3, e4 ;
  input[1:0] sel ;
  output dataOut ;
  
  assign dataOut = ( sel == 2'b00 ) ? e1 :
		   ( sel == 2'b01 ) ? e2 :
		   ( sel == 2'b10 ) ? e3 :
		   ( sel == 2'b11 ) ? e4 :
				      1'b0 ;
						
endmodule
