`timescale 1ns / 1ps

module reg_mem(
    input clk,
    input [4:0] rd_addr0,
    input [4:0] rd_addr1,
    input [4:0] wrt_addr,
    input wrt_enbl,
    input [31:0] wrt_dat,
    output reg [31:0] rd_dat0,
    output reg [31:0] rd_dat1
);

    reg [31:0] reg_mem [31:0];

    initial begin
        reg_mem[0] = 32'h00000002;
        reg_mem[1] = 32'h00000000;
        reg_mem[2] = 32'h00000050;
        reg_mem[3] = 32'h00000000;
        reg_mem[4] = 32'h00000006;
        reg_mem[5] = 32'h00000040;
        reg_mem[6] = 32'h00000000;
        reg_mem[7] = 32'h00000009;
        reg_mem[8] = 32'h00000001;
    end

    always @(rd_addr0 or rd_addr1) begin
        rd_dat0 = 32'h00000000;
        rd_dat1 = 32'h00000000;
        if (rd_addr0 != 5'b11111)
            rd_dat0 = reg_mem[rd_addr0];
        if (rd_addr1 != 5'b11111)
            rd_dat1 = reg_mem[rd_addr1];
    end

    always @(negedge(clk)) begin
        if (wrt_enbl)
            if (wrt_addr != 5'b11111)
                reg_mem[wrt_addr] = wrt_dat;
    end

endmodule
