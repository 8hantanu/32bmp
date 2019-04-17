`timescale 1ns / 1ps

module main_mem(
    input clk,
    input [31:0] addr,
    input rd_enbl,
    input wrt_enbl,
    input [31:0] dat_in,
    output reg [31:0] dat_out
);

    reg [31:0] mem [1024*1024*1024*4-1:0];

    always @(addr) begin
        dat_out = mem[addr];
    end

    always @(dat_in) begin
        if(wrt_enbl & !rd_enbl)
            mem[addr] = dat_in;
    end

endmodule
