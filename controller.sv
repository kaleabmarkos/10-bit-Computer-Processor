module controller #(
    parameter LOAD = 4'b0000,
    parameter COPY = 4'b0001,
    parameter ADD = 4'b0010,
    parameter SUB = 4'b0011,
    parameter INV = 4'b0100,
    parameter FLIP = 4'b0101,
    parameter AND = 4'b0110,
    parameter OR = 4'b0111,
    parameter XOR = 4'b1000,
    parameter LSL = 4'b1001,
    parameter LSR = 4'b1010,
    parameter ASR = 4'b1011,
    parameter ADDI = 4'b1100,
    parameter SUBI = 4'b1101
)
(
    input logic [9:0] INST,     //instruction from register
    input logic [1:0] T,        //count from counter

    output logic [9:0] IMM,     //to write immediate value to bus
    output logic [1:0] Rin,     //address of register to input to
    output logic [1:0] Rout,    //address of register to output from
    output logic ENW,           //enable writing to register (from bus)
    output logic ENR,           //enable reading from register (to bus)
    output logic Ain,           //save input from bus into ALU's A
    output logic Gin,           //save output from ALU (get answer)
    output logic Gout,          //push answer to bus
    output logic [3:0] ALUcont, //ALU control signal
    output logic Ext,           //push switch data to bus
    output logic IRin,          //save switch data from bus
    output logic Clr            //reset counter and display done in output logic
);

always_comb begin
    //start all variables at the default
    IMM = 10'bzzzzzzzzzz;
    Rin = 2'b0;
    Rout = 2'b0;
    ENW = 1'b0;
    ENR = 1'b0;
    Ain = 1'b0;
    Gin = 1'b0;
    Gout = 1'b0;
    ALUcont = 4'bzzzz;
    Ext = 1'b0;
    IRin = 1'b0;
    Clr = 1'b0;

    //Step 0 (Load data from switches to IR)
    if (T == 2'b00) begin
        Ext = 1;
        IRin = 1;

    //Step 1
    end else if (T == 2'b01) begin
        // LOAD
        if (INST[9:8] == 2'b00 && INST[3:0] == LOAD) begin
				//Enable data from switches and load into specified register
            Ext = 1;
            Rin = INST[7:6];
            ENW = 1;
            Clr = 1;
        end
        
        // COPY
        else if (INST[9:8] == 2'b00 && INST[3:0] == COPY) begin
				//Enable output from register YY and input to register XX
            Rout = INST[5:4];
            ENR = 1;
            Rin = INST[7:6];
            ENW = 1;
            Clr = 1;
        end

        // Other ALU operations
        else begin
				//On all other operations, move data from register XX to bus (and save to A in ALU)
            Rout = INST[7:6];
            ENR = 1;
            Ain = 1;
        end
    end

    //Step 2
    else if (T == 2'b10) begin
        Gin = 1;

        // Normal ALU operations
        if (INST[9:8] == 2'b00) begin
				//Enable output from second register and prepare ALU
            Rout = INST[5:4];
            ENR = 1;
            ALUcont = INST[3:0];

        // ADDI operation
        end else if (INST[9:8] == 2'b10) begin
				//Instead of output from a register, push data from switches to the bus
            ENR = 0;
            IMM[5:0] = INST[5:0];
            IMM[9:6] = 4'b0000;
            ALUcont = 4'b0010;

        // SUBI operation
        end else begin
				//Instead of output from a register, push data from switches to the bus
            ENR = 0;
            IMM[5:0] = INST[5:0];
            IMM[9:6] = 4'b0000;
            ALUcont = 4'b0011;
        
        end

    //Step 3
    end else if ( T == 2'b11 ) begin
		  //move the answer from the ALU to the specified register
        Gout = 1;
        Rin = INST[7:6];
        ENW = 1;
        Clr = 1;
    end else begin
        // Do nothing
    end
end

endmodule
