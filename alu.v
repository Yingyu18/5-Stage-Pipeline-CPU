
module alu(ctl, a, b, result, shamt);
  input  [2:0]  ctl ; 
  input  [4:0]  shamt;
  input  [31:0] a, b ;
  output [31:0] result ;

  wire [31:0] sll_ans, temp ;
  wire [30:0] c ;
  wire [1:0] sel ;
  wire set, cout, binvert ;
  assign sel = ctl[1:0];
  assign binvert = ctl[2];

  ALU_1bit alu_01( .dataOut(temp[0]), .cout(c[0]), .dataA(a[0]), .dataB(b[0]), .cin(binvert), .sel(sel), .binvert(binvert), .less(set) ) ;
  ALU_1bit alu_02( .dataOut(temp[1]), .cout(c[1]), .dataA(a[1]), .dataB(b[1]), .cin(c[0]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_03( .dataOut(temp[2]), .cout(c[2]), .dataA(a[2]), .dataB(b[2]), .cin(c[1]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_04( .dataOut(temp[3]), .cout(c[3]), .dataA(a[3]), .dataB(b[3]), .cin(c[2]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_05( .dataOut(temp[4]), .cout(c[4]), .dataA(a[4]), .dataB(b[4]), .cin(c[3]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_06( .dataOut(temp[5]), .cout(c[5]), .dataA(a[5]), .dataB(b[5]), .cin(c[4]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_07( .dataOut(temp[6]), .cout(c[6]), .dataA(a[6]), .dataB(b[6]), .cin(c[5]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_08( .dataOut(temp[7]), .cout(c[7]), .dataA(a[7]), .dataB(b[7]), .cin(c[6]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_09( .dataOut(temp[8]), .cout(c[8]), .dataA(a[8]), .dataB(b[8]), .cin(c[7]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_10( .dataOut(temp[9]), .cout(c[9]), .dataA(a[9]), .dataB(b[9]), .cin(c[8]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_11( .dataOut(temp[10]), .cout(c[10]), .dataA(a[10]), .dataB(b[10]), .cin(c[9]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_12( .dataOut(temp[11]), .cout(c[11]), .dataA(a[11]), .dataB(b[11]), .cin(c[10]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_13( .dataOut(temp[12]), .cout(c[12]), .dataA(a[12]), .dataB(b[12]), .cin(c[11]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_14( .dataOut(temp[13]), .cout(c[13]), .dataA(a[13]), .dataB(b[13]), .cin(c[12]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_15( .dataOut(temp[14]), .cout(c[14]), .dataA(a[14]), .dataB(b[14]), .cin(c[13]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_16( .dataOut(temp[15]), .cout(c[15]), .dataA(a[15]), .dataB(b[15]), .cin(c[14]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_17( .dataOut(temp[16]), .cout(c[16]), .dataA(a[16]), .dataB(b[16]), .cin(c[15]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_18( .dataOut(temp[17]), .cout(c[17]), .dataA(a[17]), .dataB(b[17]), .cin(c[16]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_19( .dataOut(temp[18]), .cout(c[18]), .dataA(a[18]), .dataB(b[18]), .cin(c[17]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_20( .dataOut(temp[19]), .cout(c[19]), .dataA(a[19]), .dataB(b[19]), .cin(c[18]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_21( .dataOut(temp[20]), .cout(c[20]), .dataA(a[20]), .dataB(b[20]), .cin(c[19]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_22( .dataOut(temp[21]), .cout(c[21]), .dataA(a[21]), .dataB(b[21]), .cin(c[20]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_23( .dataOut(temp[22]), .cout(c[22]), .dataA(a[22]), .dataB(b[22]), .cin(c[21]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_24( .dataOut(temp[23]), .cout(c[23]), .dataA(a[23]), .dataB(b[23]), .cin(c[22]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_25( .dataOut(temp[24]), .cout(c[24]), .dataA(a[24]), .dataB(b[24]), .cin(c[23]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_26( .dataOut(temp[25]), .cout(c[25]), .dataA(a[25]), .dataB(b[25]), .cin(c[24]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_27( .dataOut(temp[26]), .cout(c[26]), .dataA(a[26]), .dataB(b[26]), .cin(c[25]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_28( .dataOut(temp[27]), .cout(c[27]), .dataA(a[27]), .dataB(b[27]), .cin(c[26]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_29( .dataOut(temp[28]), .cout(c[28]), .dataA(a[28]), .dataB(b[28]), .cin(c[27]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_30( .dataOut(temp[29]), .cout(c[29]), .dataA(a[29]), .dataB(b[29]), .cin(c[28]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_1bit alu_31( .dataOut(temp[30]), .cout(c[30]), .dataA(a[30]), .dataB(b[30]), .cin(c[29]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  ALU_MSB alu_32( .dataOut(temp[31]), .set(set), .cout(cout), .dataA(a[31]), .dataB(b[31]), .cin(c[30]), .sel(sel), .binvert(binvert), .less(1'b0) ) ;
  
  Shifter shifter( .dataA(b), .dataB(shamt), .dataOut(sll_ans) );

 assign result = (ctl == 3'b011)? sll_ans : temp ;

endmodule
