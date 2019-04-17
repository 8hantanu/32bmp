`timescale 1ns / 1ps

module mux(
    input sel;
    input [31:0] in0;
    input [31:0] in1;
    output [31:0] out;
);

    assign out = sel == 0 ? in0 : in1;

endmodule
