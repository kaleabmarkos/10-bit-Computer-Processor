module registerFile (
    input logic [9:0] D,
    input logic ENW, ENR0, ENR1, CLKb,
    input logic [1:0] WRA, RDA0, RDA1,
    output logic [9:0] Q0, Q1
);
    // Declare registers
    logic [9:0] registers [3:0];
	
	// Start all registers at all zeroes
	initial
	begin
		registers[0] = '0;
		registers[1] = '0;
		registers[2] = '0;
		registers[3] = '0;
	end

    // Write operation
    always_ff @(negedge CLKb) begin
        if (ENW) begin
            registers[WRA] <= D;
        end
    end

    // Read operation (combinational)
    always_comb begin
        if (ENR0) begin
            Q0 = registers[RDA0];
        end
		else begin
			Q0 = 10'bz;
		end
		
        if (ENR1) begin
            Q1 = registers[RDA1];
        end
		else begin
			Q1 = 10'bz;
		end
    end
endmodule
