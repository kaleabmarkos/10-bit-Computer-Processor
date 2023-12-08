module OutputLogic (
    input logic [9:0] BUS,     // Current data on the shared bus
    input logic [9:0] REG,     // Output of the second read port on the register file
    input logic [1:0] TIME,    // Current timestep of the processor
    input logic PEEKb,         // Logic signal for "peek" operation
    input logic Clr,           // Clear signal from the controller
    
    output logic [9:0] LEDB,   // LED to display current values on the data bus
    output logic [6:0] THEX,   // 7-segment display for the current timestep
    
    // 7-segment displays for data peeking or register peeking
    output logic [6:0] DHEX2,
	output logic [6:0] DHEX1,
	output logic [6:0] DHEX0,
    
    output logic DONE           // LED to indicate instruction completion
);
    // LED B to display the current values on the data bus
    assign LEDB = BUS[9:0];  // Display the lower 7 bits of the data bus (changed to all 10 bits of the data bus)
    
    // 7-segment display for the current timestep
    always_comb begin
        case (TIME)
            2'b00: THEX = /*7'b0000001*/7'b1000000;  // Display "0"
            2'b01: THEX = /*7'b1001111*/7'b1111001;  // Display "1"
            2'b10: THEX = /*7'b0010010*/7'b0100100;  // Display "2"
            2'b11: THEX = /*7'b0000110*/7'b0110000;  // Display "3"
            default: THEX = 7'b1111111; // Display blank for unsupported values
        endcase
    end

    // 7-segment displays for data peeking or register peeking
    always_comb begin
        if (PEEKb) begin
            // Display the 10-bit value on the data bus in three 7-segment displays
			// DHEX2 = BUS[9:8];
			case (BUS[9:8])
				2'b00: DHEX2 = 7'b1000000; //0
				2'b01: DHEX2 = 7'b1111001; //1
				2'b10: DHEX2 = 7'b0100100; //2
				2'b11: DHEX2 = 7'b0110000; //3
				default: DHEX2 = 7'b1111111; //All Off
			endcase

            //DHEX1 = BUS[7:4];
			case (BUS[7:4])
				4'b0000: DHEX1 = 7'b1000000; //0
				4'b0001: DHEX1 = 7'b1111001; //1
				4'b0010: DHEX1 = 7'b0100100; //2
				4'b0011: DHEX1 = 7'b0110000; //3
				4'b0100: DHEX1 = 7'b0011001; //4
				4'b0101: DHEX1 = 7'b0010010; //5
				4'b0110: DHEX1 = 7'b0000010; //6
				4'b0111: DHEX1 = 7'b1111000; //7
				4'b1000: DHEX1 = 7'b0000000; //8
				4'b1001: DHEX1 = 7'b0010000; //9
				4'b1010: DHEX1 = 7'b0001000; //A
				4'b1011: DHEX1 = 7'b0000011; //B
				4'b1100: DHEX1 = 7'b1000110; //C
				4'b1101: DHEX1 = 7'b0100001; //D
				4'b1110: DHEX1 = 7'b0000110; //E
				4'b1111: DHEX1 = 7'b0001110; //F
				default: DHEX1 = 7'b1111111; //All Off
			endcase
			
            //DHEX0 = BUS[3:0];
			case (BUS[3:0])
				4'b0000: DHEX0 = 7'b1000000; //0
				4'b0001: DHEX0 = 7'b1111001; //1
				4'b0010: DHEX0 = 7'b0100100; //2
				4'b0011: DHEX0 = 7'b0110000; //3
				4'b0100: DHEX0 = 7'b0011001; //4
				4'b0101: DHEX0 = 7'b0010010; //5
				4'b0110: DHEX0 = 7'b0000010; //6
				4'b0111: DHEX0 = 7'b1111000; //7
				4'b1000: DHEX0 = 7'b0000000; //8
				4'b1001: DHEX0 = 7'b0010000; //9
				4'b1010: DHEX0 = 7'b0001000; //A
				4'b1011: DHEX0 = 7'b0000011; //B
				4'b1100: DHEX0 = 7'b1000110; //C
				4'b1101: DHEX0 = 7'b0100001; //D
				4'b1110: DHEX0 = 7'b0000110; //E
				4'b1111: DHEX0 = 7'b0001110; //F
				default: DHEX0 = 7'b1111111; //All Off
			endcase
        end
		
		else begin
            // Display the 10-bit output of the second read port of the register file
            //DHEX2 = REG[9:8];
			case (REG[9:8])
				2'b00: DHEX2 = 7'b1000000; //0
				2'b01: DHEX2 = 7'b1111001; //1
				2'b10: DHEX2 = 7'b0100100; //2
				2'b11: DHEX2 = 7'b0110000; //3
				default: DHEX2 = 7'b1111111; //All Off
			endcase

            //DHEX1 = REG[7:4];
			case (REG[7:4])
				4'b0000: DHEX1 = 7'b1000000; //0
				4'b0001: DHEX1 = 7'b1111001; //1
				4'b0010: DHEX1 = 7'b0100100; //2
				4'b0011: DHEX1 = 7'b0110000; //3
				4'b0100: DHEX1 = 7'b0011001; //4
				4'b0101: DHEX1 = 7'b0010010; //5
				4'b0110: DHEX1 = 7'b0000010; //6
				4'b0111: DHEX1 = 7'b1111000; //7
				4'b1000: DHEX1 = 7'b0000000; //8
				4'b1001: DHEX1 = 7'b0010000; //9
				4'b1010: DHEX1 = 7'b0001000; //A
				4'b1011: DHEX1 = 7'b0000011; //B
				4'b1100: DHEX1 = 7'b1000110; //C
				4'b1101: DHEX1 = 7'b0100001; //D
				4'b1110: DHEX1 = 7'b0000110; //E
				4'b1111: DHEX1 = 7'b0001110; //F
				default: DHEX1 = 7'b1111111; //All Off
			endcase
			
            //DHEX0 = REG[3:0];
			case (REG[3:0])
				4'b0000: DHEX0 = 7'b1000000; //0
				4'b0001: DHEX0 = 7'b1111001; //1
				4'b0010: DHEX0 = 7'b0100100; //2
				4'b0011: DHEX0 = 7'b0110000; //3
				4'b0100: DHEX0 = 7'b0011001; //4
				4'b0101: DHEX0 = 7'b0010010; //5
				4'b0110: DHEX0 = 7'b0000010; //6
				4'b0111: DHEX0 = 7'b1111000; //7
				4'b1000: DHEX0 = 7'b0000000; //8
				4'b1001: DHEX0 = 7'b0010000; //9
				4'b1010: DHEX0 = 7'b0001000; //A
				4'b1011: DHEX0 = 7'b0000011; //B
				4'b1100: DHEX0 = 7'b1000110; //C
				4'b1101: DHEX0 = 7'b0100001; //D
				4'b1110: DHEX0 = 7'b0000110; //E
				4'b1111: DHEX0 = 7'b0001110; //F
				default: DHEX0 = 7'b1111111; //All Off
			endcase
        end
    end

    // LED to indicate instruction completion
    always_comb begin
        if (Clr) begin
            DONE = 1'b1;
        end else begin
            DONE = 1'b0;
        end
    end
endmodule
