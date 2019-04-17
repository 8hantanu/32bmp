`timescale 1ns / 1ps

module prog_cntr(
    input clk,
    input rst,
    input zero,
    input brnch,
    input jmp,
    input [25:0] jmp_addr,
    input [15:0] brnch_offs,
    input [31:0] reg_addr,
    output reg [31:0] pc
);

    wire [31:0] pc_incr;
    reg [1:0] pc_ctrl;

    initial pc <= 32'h00000000;

    assign pc_incr = pc + 1;

    always @(posedge clk) begin
        if(rst == 1)
            pc <= 32'h00000000;
        else begin
            pc_ctrl = brnch & zero == 1 ? 2'b10 : 2'b00;
            pc_ctrl = jmp ? 2'b11 : pc_ctrl;
            case(pc_ctrl)
                2'b00:   pc <= pc_incr;  //Increment of program counter by 4
                2'b11:   pc <= {pc_incr[31:26],jmp_addr}; //jmp addr calculation
                2'b01:   pc <= reg_addr; //Initial addr
                2'b10:   pc <= pc_incr + {{14{brnch_offs[15]}},brnch_offs[15:0]};
                default: pc <= pc_incr;
            endcase
        end
    end

endmodule
