//	Title: MIPS Single-Cycle Processor
//	Editor: Selene (Computer System and Architecture Lab, ICE, CYCU)


module mips_pipelined( clk, rst );
	input clk, rst;
	
	// instruction bus
	wire[31:0] instr, instr_out;
	
	// break out important fields from instruction
	wire [5:0] opcode, funct, funct_out;
        wire [4:0] rs, rt, rt_out, rd, rd_out, shamt, shamt_out;
        wire [15:0] immed;
        wire [31:0] extend_immed, extend_immed_un, immed_result, extend_out, b_offset;
        wire [25:0] jumpoffset;
	wire [63:0] MulAns;
	
	// datapath signals
        wire [4:0] rfile_wn, wn_1, wn_2;
        wire [31:0] rfile_rd1, rd1_out, rfile_rd2, rd2_out, rd2ToWD, rfile_wd, alu_b, alu_ans, alu_out,
				aluToADDR, ADDR_out, b_tgt, b_tgt_out, pc_next, HiOut, LoOut, 
                pc, pc_incr, pc_add, dmem_rdata, dmem_rdata_out, jump_addr, branch_addr;

	// control signals
        wire RegWrite, Branch, PCSrc, RegDst, MemtoReg, MemRead, MemWrite, ALUSrc, Zero, Jump, Multu, ExtendSel;
        wire [1:0] ALUOp, ALU_Out_Sel;
        wire [2:0] Operation;
	
		wire [1:0] WB_reg, WB_reg_1, WB_reg_2, WB_reg_3;
		wire [1:0] MEM_reg, MEM_reg_1, MEM_reg_2;
		wire [3:0] EX_reg, EX_reg_1;
	
        assign opcode = instr_out[31:26];
        assign rs = instr_out[25:21];
        assign rt = instr_out[20:16];
        assign rd = instr_out[15:11];
        assign shamt = instr_out[10:6];
        assign funct = instr_out[5:0];
        assign immed = instr_out[15:0];
        assign jumpoffset = instr_out[25:0];
	
	// branch offset shifter
        assign b_offset = extend_immed << 2;
	
	// jump offset shifter & concatenation
	assign jump_addr = { pc_incr[31:28], jumpoffset <<2 };
	
	assign WB_reg = { MemtoReg, RegWrite };   
	assign MEM_reg = { MemWrite, MemRead };  
	assign EX_reg = { ALUSrc, RegDst, ALUOp };   // [1:0]是ALUOP

	
	// module instantiations
	reg32 PC( .clk(clk), .rst(rst), .en_reg(1'b1), .d_in(pc_next), .d_out(pc) );  
	
	and BR_AND(PCSrc, Branch, Zero);
	
	branch_equ equ( .opcode(opcode), .zero(Zero), .a(rfile_rd1), .b(rfile_rd2) );

	mux2 #(5) RFMUX( .sel(EX_reg_1[2]), .a(rt_out), .b(rd_out), .y(rfile_wn) );
	
	mux2 #(32) PCMUX( .sel(PCSrc), .a(pc_incr), .b(b_tgt), .y(branch_addr) );	
	
	mux2 #(32) JMUX( .sel(Jump), .a(branch_addr), .b(jump_addr), .y(pc_next) );
	
	mux2 #(32) ALUMUX( .sel(EX_reg_1[3]), .a(rd2_out), .b(extend_out), .y(alu_b) );
	
	mux2 #(32) WRMUX( .sel(WB_reg_3[1]), .a(ADDR_out), .b(dmem_rdata_out), .y(rfile_wd) );
	
	mux3 #(32) OUTMUX( .sel(ALU_Out_Sel), .a(alu_ans), .b(HiOut), .c(LoOut), .y(alu_out) );
	
	mux2 #(32) EXTENDMUX( .sel(ExtendSel), .a(extend_immed), .b(extend_immed_un), .y(immed_result) );
	
	add32 PCADD( .a(pc), .b(32'd4), .result(pc_incr) );
	
	add32 BRADD( .a(pc_add), .b(b_offset), .result(b_tgt) );
	
	memory InstrMem( .clk(clk), .MemRead(1'b1), .MemWrite(1'b0), .wd(32'd0), .addr(pc), .rd(instr) );
	
	memory DatMem( .clk(clk), .MemRead(MEM_reg_2[0]), .MemWrite(MEM_reg_2[1]), .wd(rd2ToWD), .addr(aluToADDR), .rd(dmem_rdata) );	 
	
	control_pipelined CTL(.opcode(opcode), .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), 
                       .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite), .Branch(Branch), 
                       .Jump(Jump), .ALUOp(ALUOp), .ExtendSel(ExtendSel) );
					   
	alu_ctl ALUCTL( .ALUOp(EX_reg_1[1:0]), .Funct(funct_out), .ALUOperation(Operation), .Multu(Multu), .sel(ALU_Out_Sel) );
	
	reg_file RegFile( .clk(clk), .RegWrite(WB_reg_3[0]), .RN1(rs), .RN2(rt), .WN(wn_2), .WD(rfile_wd), .RD1(rfile_rd1), .RD2(rfile_rd2) );
	
	sign_extend SignExt( .immed_in(immed), .ext_immed_out(extend_immed) );
	
	unsign_extend UnsignExt( .immed_in(immed), .ext_immed_out(extend_immed_un) );

    alu ALU( .ctl(Operation), .a(rd1_out), .b(alu_b), .shamt(shamt_out), .result(alu_ans) );
	
	multiplier multiplier( .clk(clk), .dataA(rd1_out), .dataB(rd2_out), .dataOut(MulAns), .Multu(Multu), .reset(reset) );
	
	HiLo HiLo( .clk(clk), .MulAns(MulAns), .HiOut(HiOut), .LoOut(LoOut), .reset(reset) );

	IF_ID IF_ID_Reg( .clk(clk), .rst(rst), .en_reg(1'b1), .pc_out(pc_add), .ins_out(instr_out), .pc_in(pc_incr), .ins_in(instr) );
	
	ID_EX ID_EX_Reg( .clk(clk), .rst(rst), .en_reg(1'b1), .WB_out(WB_reg_1), .MEM_out(MEM_reg_1), .EX_out(EX_reg_1), .shamt_out(shamt_out), .funct_out(funct_out),
					 .RD1_out(rd1_out), .RD2_out(rd2_out), .immed_out(extend_out), .rt_out(rt_out), .rd_out(rd_out),
					 .WB_in(WB_reg), .MEM_in(MEM_reg), .EX_in(EX_reg), .shamt_in(shamt), .funct_in(funct), .RD1_in(rfile_rd1), .RD2_in(rfile_rd2), 
					 .immed_in(immed_result), .rt_in(rt), .rd_in(rd) );
					 
	EX_MEM EX_MEM_Reg( .clk(clk), .rst(rst), .en_reg(1'b1), .WB_out(WB_reg_2), .MEM_out(MEM_reg_2), 
					   .alu_out(aluToADDR), .RD2_out(rd2ToWD), .WN_out(wn_1), .WB_in(WB_reg_1), .MEM_in(MEM_reg_1),
					   .alu_in(alu_out), .RD2_in(rd2_out), .WN_in(rfile_wn) );
	
	MEM_WB MEM_WB_Reg( .clk(clk), .rst(rst), .en_reg(1'b1), .WB_out(WB_reg_3), .RD_out(dmem_rdata_out), .ADDR_out(ADDR_out), .WN_out(wn_2),
								.WB_in(WB_reg_2), .RD_in(dmem_rdata), .ADDR_in(aluToADDR), .WN_in(wn_1) );


	
				   
endmodule
