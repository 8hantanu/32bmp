`timescale 1ns / 1ps

module alu_ctrl(
    input      [31:0] instr,
    input      [2:0]  alu_op,
    output reg [5:0]  alu_fn
);

    always @(instr or alu_op) begin
        if (alu_op == 3'b010)
            alu_fn <= instr[5:0];
        else if (alu_op == 3'b000)
            alu_fn <= 6'b000000;
        else if (alu_op == 3'b001)
            alu_fn <= 6'b000001;
        else if (alu_op == 3'b011)
            alu_fn <= 6'b000000;
        else if (alu_op == 3'b100)
            alu_fn <= 6'b000100;
        else if (alu_op == 3'b101)
            alu_fn <= 6'b000110;
        else if (alu_op == 3'b110)
            alu_fn <= 6'b001011;
    end

endmodule
