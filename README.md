# 5-Stage-Pipeline-CPU
使用Verilog HDL與Modelsim模擬器，以ALU Design 為基礎，<br>
設計一個Pipelined MIPS-Lite CPU，<br>
內含16道指令(add, sub, and, or, sll, slt,  lw, sw, beq, bne, j, multu, mfhi, mflo, nop)。<br>
此為團隊作品，分工上程式碼全部由本人撰寫，組員負責報告撰寫及繪製架構圖。<br>
<br>
<br>

## 開發平台
Windows10<br>
<br>
<br>

## 開發環境
ModelSim PE Student Edition 10.4a<br>
<br>
<br>

## 使用方法
修改data_mem.txt及instr_mem.txt內容<br>
data_mem.txt為設置資料內容<br>
instr_mem.txt則為指定執行之指令內容<br>
使用ModelSim創建project<br>
對tb_Pipelined.v進行模擬<br>
<br>
<br>

## 架構圖
![](https://github.com/sha310139/5-Stage-Pipeline-CPU/blob/main/results/datapath.jpg)
<br>
<br>

## 模組實作細節
<br>
(1)	ALU<br>
以32個1-bit ALU組成32-bits ALU，<br>
具有32-bits AND、OR、ADD、SUB、SLT的功能，<br>
惟多一個ctl的控制訊號輸入，此訊號為alu_ctl的output ALUOperation，<br>
共三位元，最低兩個位元當作ALU_1bit的sel，最高位元為binvert的輸入。<br>
<br>
(2)	Shifter<br>
以160個二對一多工器(Barrel shifter)實現32位元之移位，<br>
用於sll指令，包含於alu模組中。<br>
<br>
(3)	Multiplier
實現32位元乘法，需透過alu_ctl控制訊號操作。<br>
使用always block偵測時脈變化，由alu_ctl的MUL訊號控制做乘法或輸出，<br>
若訊號為1’b1，開始做乘法運算，32 cycles後將結果輸出。<br>
<br>
(4)	alu_ctl<br>
根據ALUOp及Funct訊號決定ALUOperation以配送至ALU。<br>
ALUOp為00時表強制加法，01為強制減法，<br>
若為10則靠Funct判斷ALU的操作(ALUOperation)。<br>
<br>
(5)	Control_pipelined<br>
根據6 bits的opcode產生對應的控制訊號：<br>

                  RegDst	 ALUSrc   MemtoReg  RegWrite  MemRead  MemWrite   Branch   Jump   ALUOp
    R_FORMAT	1	    0	      0	       1	 1	   0	    0	    0	   10
    LW	        0	    1	      1	       1	 1	   0	    0	    0	   00
    SW	        x	    1	      x	       0	 0	   1	    0	    0	   00
    BEQ	        x	    0	      x	       0	 0	   0	    1	    0	   01
    J	        x	    0	      x	       0	 0	   0	    1	    1	   01
<br>
(6)	Add32<br>
實現32位元加法，此模組用於PC及branch的位址加法。<br>
<br>
(7)	branch<br>
根據Branch及Zero訊號給定PCSrc的值，PCSrc為是否執行branch的依據。<br>
<br>
(8)	Memory<br>
依據MemRead及MemWrite控制Memory的寫入或讀取，<br>
若( MemRead, MemWrite ) = ( 0, 1 )，執行寫入的功能，將wd寫入至mem[ addr ]。<br>
若( MemRead, MemWrite ) = ( 1, 0 )，執行讀取的功能，表需寫回Register File，將mem[ addr ]傳給rd。<br>
<br>
(9)	mips_pipelined<br>
整合所有module以及處理訊號傳送。<br>
<br>
(10)	mux2<br>
二對一多工器，根據訊號擇一輸出，主要用在選擇PC要fetch下一道指令<br>
的位址、ALU的operand2輸入、欲寫回的暫存器以及內容。<br>
<br>
(11)	Mux3<br>
三對一多工器，用於選擇EX階的運算結果(Hi/Lo/alu)。<br>
<br>
(12)	Reg_file<br>
儲存暫存器內容，以及負責暫存器資料之寫入與讀取。<br>
<br>
(13)	Reg32<br>
32位元暫存器，在此當作PC使用。<br>
<br>
(14)	Sign_extend<br>
將16位元的立即值做有號數擴充成32位元。<br>
<br>
(15)	IF_ID<br>
IF階與ID階間的暫存器，在clk為posedge時更新其儲存資料。存放IF階欲傳送至ID階之資料。<br>
<br>
(16)	ID_EX<br>
ID階與EX階間的暫存器，在clk為posedge時更新其儲存資料。存放IF階欲傳送至ID階之資料。<br>
<br>
(17)	EX_MEM<br>
EX階與MEM階間的暫存器，在clk為posedge時更新其儲存資料。存放IF階欲傳送至ID階之資料。<br>
<br>
(18)	MEM_WB<br>
MEM階與WB階間的暫存器，在clk為posedge時更新其儲存資料。存放IF階欲傳送至ID階之資料。<br>
<br>
(19)	tb_pipelined<br>
依序將instruction memory、data memory以及register file設定初始值。<br>
接著以迴圈的方式讀input檔，並判斷目前訊號為何者，<br>
輸出該模組實作之相對應答案。同時控制時脈與決定延遲時間，才能順利輸出正確結果。<br>
<br>

## 結果
    <1>  sw      $zero, $s2, 24
    <2>  lw      $s1, $t7, 0
    <3>  addiu   $s2, $s0, 3 
    <4>  sll     $s3, $s0, 2   
    <5>  and     $s1, $s0, $s1  
    <6>  slt     $t0, $s3, $s4 
    <7>  add     $s2, $s0, $s2  
    <8>  sub     $s2, $s0, $s2
    <9>  or      $s2, $s0, $s2
    <10> beq     $t7, $s2, 3
    <11> bne     $t7, $s2, 3
    

![](https://github.com/sha310139/5-Stage-Pipeline-CPU/blob/main/results/result1.PNG)
![](https://github.com/sha310139/5-Stage-Pipeline-CPU/blob/main/results/result2.PNG)
<br>
上方為11道指令於terminal輸出的結果，能觀察出指令之暫存器數值與輸出結果相符合。<br>
下方為11道指令顯示之waveform圖形。<br>
<br>
![](https://github.com/sha310139/5-Stage-Pipeline-CPU/blob/main/results/waveform1.PNG)
![](https://github.com/sha310139/5-Stage-Pipeline-CPU/blob/main/results/waveform2.PNG)


