`timescale 1ns / 1ps

module proc(
    input clk,
    input rst
);

    wire [31:0] alu_op, alu_out, pc, instr, sign_extn_out;
    wire [31:0] reg_dat0, reg_dat1;, reg_wrt_dat, dat_mem_in, dat_mem_out;
    wire [1:0]  pc_ctrl;
    wire [2:0]  alu_op;
    wire [4:0]  reg_addr0, reg_addr1, reg_wrt_addr;
    wire [5:0]  alu_ctrl_op;
    wire reg_wrt_dst, mem_rd_enbl, mem_to_reg, mem_wrt_enbl, reg_wrt_enbl;
    wire alu_src, brnch_ctrl, jmp_ctrl, zero_ctrl, ovrflo_sgnl;

    assign reg_addr0 = instr[25:21];
    assign reg_addr1 = instr[20:16];
    assign dat_mem_in = reg_dat1;

    prog_cntr pc(
        .clk(clk),
        .rst(rst),
        .zero(zero_ctrl),
        .brnch(brnch_ctrl),
        .jmp(jmp_ctrl),
        .jmp_addr(instr[25:0]),
        .brnch_offs(instr[15:0]),
        .reg_addr(reg_dat0),
        .pc(pc)
    );

    instr_mem instrmem(
        .clk(clk),
        .addr(pc),
        .rd_enbl(1'b1),
        .wrt_enbl(1'b0),
        .dat_in(32'h000000),
        .dat_out(instr)
    );

    ctrl_unit control(
        .instr(instr),
        .reg_dst(reg_wrt_dst),
        .alu_src(alu_src),
        .reg_wrt(reg_wrt_enbl),
        .mem_rd(mem_rd_enbl),
        .mem_wrt(mem_wrt_enbl),
        .mem_to_reg(mem_to_reg),
        .brnch(brnch_ctrl),
        .jmp(jmp_ctrl),
        .alu_op(alu_op)
    );

    reg_mux regwrtdst(
        .in0(reg_addr1),
        .in1(instr[15:11]),
        .sel(reg_wrt_dst),
        .out(reg_wrt_addr)
    );

    reg_mem registers(
        .clk(clk),
        .rd_addr0(reg_addr0),
        .rd_addr1(reg_addr1),
        .wrt_addr(reg_wrt_addr),
        .wrt_enbl(reg_wrt_enbl),
        .wrt_dat(reg_wrt_dat),
        .rd_dat0(reg_dat0),
        .rd_dat1(reg_dat1)
    );

    sign_extn sign(
        .in(instr[15:0]),
        .out(sign_extn_out)
    );

    mux alusrc(
        .sel(alu_src),
        .in0(reg_dat1),
        .in1(sign_extn_out),
        .out(alu_op)
    );

    alu_ctrl aluctrl(
        .instr(instr),
        .alu_op(alu_op),
        .alu_fn(alu_ctrl_op)
    );

    alu alu(
        .clk(clk),
        .i0(reg_dat0),
        .i1(alu_op),
        .alu_fn(alu_ctrl_op),
        .otp(alu_out),
        .zero(zero_ctrl),
        .ovrflo(ovrflo_sgnl)
    );

    main_mem memory(
        .clk(clk),
        .addr(alu_out),
        .rd_enbl(mem_rd_enbl),
        .wrt_enbl(mem_wrt_enbl),
        .dat_in(dat_mem_in),
        .dat_out(dat_mem_out)
    );

    mux wrtsel(
        .sel(mem_to_reg),
        .in1(dat_mem_out),
        .in0(alu_out),
        .out(reg_wrt_dat)
    );


    always @(posedge clk) begin
        $display("reg_addr0- %d - reg_addr1 - %d",reg_addr0,reg_addr1);
        $display("INSTRUCTION=%h - reg_dat0=%h - reg_dat1=%h  - alu_ctrl_op=%d - mem_wrt_enbl=%d - dat_mem_in=%d - alu_out=%h",
            instr,
            reg_dat0,
            reg_dat1,
            alu_ctrl_op,
            mem_wrt_enbl,
            dat_mem_in,
            alu_out);
    end

endmodule
