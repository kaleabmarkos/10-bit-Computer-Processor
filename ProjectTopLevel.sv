module Project2TopLevel (
    input logic [9:0] Data,    		// Input: External data input
    input logic CLK, CLK50, PKb,
	output logic [9:0] LEDB,
	output logic [6:0] DHEX0, DHEX1, DHEX2, THEX,
	output logic LED_D
);
	//intermediate logic
	logic CLKb;
	
	//for controller
	logic ENW, ENR, Ain, Gin, Gout, Ext, IRin, Clr;
	logic [9:0] INSTR;
	logic [1:0] Rin, Rout, T;
	logic [3:0] ALUcont;
	
	//for register file
	logic [9:0] Q1;
	
	//Implement the shared data bus (maybe move above)
	wire [9:0] DataBus;

	
//*******************************************************

  // Tristate Buffer to load data from switches to DataBus

always_comb begin
    if (Ext) begin
        DataBus = Data;
    end
    else begin
        DataBus = 10'bz;
    end
end

  
//*******************************************************
	
	//debouncer in:(A_noisy, CLK50M) out:(A)
	debouncer deb(.A_noisy(CLK), .CLK50M(CLK50), .A(CLKb));
	
	//Regfile in:(D[9:0], ENW, ENR0, ENR1, CLKb, WRA[1:0], RDA0[1:0], RDA1[1:0]) out:(Q0[9:0], Q1[9:0])
	registerFile RF(.D(DataBus[9:0]), .ENW(ENW), .ENR0(ENR), .ENR1(1'b1), .CLKb(CLKb), .WRA(Rin[1:0]), .RDA0(Rout[1:0]), .RDA1(Data[1:0]), .Q0(DataBus[9:0]), .Q1(Q1[9:0]));
	
	//Reg10 in:(D[9:0], EN, CLKb) out:(Q[9:0])
   Reg10 IR(.D(DataBus[9:0]), .EN(IRin), .CLKb(CLKb), .Q(INSTR[9:0]));
	
	//upcount2 in:(CLR, CLKb) out:(CNT[1:0])
   upcount2 counter(.CLR(Clr),.CLKb(CLKb),.CNT(T[1:0]));

	//ALU in:(OP[9:0], FN[3:0], Ain, Gin, Gout, CLKb) out:(RES[9:0])
   ALU MyALU (.OP(DataBus[9:0]), .FN(ALUcont[3:0]), .Ain(Ain), .Gin(Gin), .Gout(Gout), .CLKb(CLKb), .RES(DataBus[9:0]));

	//controller in:(INSTR[9:0], T[1:0]) out:(IMM[9:0], Rin[1:0], Rout[1:0], ALUcont[3:0], ENW, ENR, Ain, Gin, Gout, Ext, IRin, Clr)
	controller PC(.INST(INSTR[9:0]), .T(T[1:0]), .IMM(DataBus[9:0]), .Rin(Rin[1:0]), .Rout(Rout[1:0]), .ENW(ENW), .ENR(ENR), .Ain(Ain), .Gin(Gin), .Gout(Gout), .ALUcont(ALUcont[3:0]), .Ext(Ext), .IRin(IRin), .Clr(Clr));
	
	//OutputLogic in:(BUS[9:0], REG[9:0], TIME[1:0], PEEKb, Clr) out:(LEDB[9:0], THEX[6:0], DHEX2[6:0], DHEX1[6:0], DHEX0[6:0], DONE)
	OutputLogic OL(.BUS(DataBus[9:0]), .REG(Q1[9:0]), .TIME(T[1:0]), .PEEKb(PKb), .Clr(Clr), .LEDB(LEDB[9:0]), .THEX(THEX[6:0]), .DHEX2(DHEX2[6:0]), .DHEX1(DHEX1[6:0]), .DHEX0(DHEX0[6:0]), .DONE(LED_D));

endmodule
