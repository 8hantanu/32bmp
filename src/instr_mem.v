`timescale 1ns / 1ps

module instr_mem(
    input clk,
    input [31:0] addr,
    input rd_enbl,
    input wrt_enbl,
    input [31:0] dat_in,
    output reg [31:0] dat_out
);

    reg [31:0] mem[8191:0];

    initial begin
        mem[0] <= 32'b00000000011000100000100000000000;
        mem[1] <= 32'b00000000110001010010000000000000;
        mem[2] <= 32'b00000000100000010000100000000001;
        mem[3] <= 32'b01000000001000010000000001000000;
        mem[4] <= 32'b01001100001000100000000000000011;
        mem[5] <= 32'b01000000101001010000000000010000;
        mem[6] <= 32'b00000000100001010010100000000001;
        mem[7] <= 32'b00000000100000010000100000000000;
        mem[8] <= 32'b00000001000000010001000000000001;
    end

    always @(addr) begin
        dat_out = mem[addr];
    end

endmodule
