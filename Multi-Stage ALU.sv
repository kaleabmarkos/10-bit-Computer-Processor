module ALU #(
    parameter ADD = 4'b0010,
    parameter SUB = 4'b0011,
    parameter INV = 4'b0100,
    parameter FLP = 4'b0101,
    parameter AND = 4'b0110,
    parameter OR = 4'b0111,
    parameter XOR = 4'b1000,
    parameter LSL = 4'b1001,
    parameter LSR = 4'b1010,
    parameter ASR = 4'b1011
)
(
  input logic [9:0] OP,
  input logic [3:0] FN,
  input logic Ain, Gin, Gout, CLKb,
  output logic [9:0] RES
);

  // Internal signals
  logic [9:0] A, B, _RES, _G;
  //logic ALUcout;


  // D flip-flop with enable instantiation
  always_ff @(negedge CLKb or posedge Ain) begin
    if (Ain)
      A <= OP;
  end
  
  //maybe?
  assign B = OP;

  // ALU combinational logic
  always_comb begin
    case (FN)
      ADD: _RES = A + B;
      SUB: _RES = A - B;
      AND: _RES = A & B;
      OR: _RES = A | B;
      XOR: _RES = A ^ B;
      FLP: _RES = ~B;
      INV: _RES = ~B + 1'b1;
      LSL: _RES = A << B;
      LSR: _RES = A >> B;
      ASR: _RES = $signed(A) >>> B;
		default: _RES = 10'b0; 	//Default to 0 for undefined FN
    endcase

 //   ALUcout = (FN == 4'b0001) ? (A >= B) : 1'b0;  // Carry out for SUB operation
  end

  // D flip-flop with enable instantiation for Gout
  always_ff @(negedge CLKb)
  begin
		if (Gin) begin
			_G <= _RES;
		end
  end
  
  assign RES = Gout ? _G : 'z;

endmodule


