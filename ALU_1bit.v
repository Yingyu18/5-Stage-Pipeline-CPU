
module ALU_1bit( dataOut, cout, dataA, dataB, cin, sel, binvert, less );

  input dataA, dataB ;
  input cin, binvert, less ;
  input[1:0] sel ;
  output dataOut ;
  output cout ;
  wire   e1, e2, e3, e4, temp ;

  and ( e1, dataA, dataB ) ;
  or ( e2, dataA, dataB ) ;

  xor ( temp, dataB, binvert ) ;
  FA FullAdder( .a(dataA), .b(temp), .c(cin), .cout(cout), .sum(e3) ) ;
  
  assign e4 = less ;

  MUX_ALU_1bit U_MUX_ALU_1bit( .dataOut(dataOut), .e1(e1), .e2(e2), .e3(e3), .e4(e4), .sel(sel) ) ;
						
endmodule
