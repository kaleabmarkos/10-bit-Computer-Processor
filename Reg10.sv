module Reg10 (
    input logic [9:0] D,
    input logic EN,
	input logic CLKb,
    output logic [9:0] Q
);
    // Declare register
   
	always_ff @(negedge CLKb)
		begin
			if (EN)
				Q <= D;
		end

endmodule