module upcount2 (
    input logic CLR,
    input logic CLKb,
    output logic [1:0] CNT
);

always_ff @(negedge CLKb/* or posedge CLR*/)
begin
    if (CLR)
        CNT <= 'b00;
    else if (CNT == 2'b11)
        CNT <= 'b00;
    else
        CNT <= CNT + 1;
end

endmodule
