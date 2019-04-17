`timescale 1ns / 1ps

module reg_mux(
    input wire [4:0] in0,
    input wire [4:0] in1,
    input wire sel,
    output reg[4:0] out
);

    always @(*) begin
        if(sel == 0)
            out <= in0;
        else
            out <= in1;
    end

endmodule
