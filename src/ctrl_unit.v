`timescale 1ns / 1ps

module ctrl_unit(
    input [31:0] instr,
    output reg reg_dst,     // Destination for I and R type instr
    output reg alu_src,     // Decides between Register input to alu and I Type add immediate
    output reg mem_to_reg,  // Decides between SW and alu output
    output reg reg_wrt,     // Write enable for Register File
    output reg mem_rd,      // Read from data memory
    output reg mem_wrt,     // Write to data memory
    output reg brnch,       // 1 if instr is beq and decides prog counter
    output reg jmp,         // 1 if instr is J type
    output reg [2:0] alu_op // alu Opcode
);

    wire [5:0] opcode;
    assign opcode = instr [31:26];
    reg [10:0] ctrl_sgnls[63:0];

    initial begin
        ctrl_sgnls[6'b000000] = 11'b10010000100; // rtype
        ctrl_sgnls[6'b010000] = 11'b01010000110; // addi
        ctrl_sgnls[6'b010001] = 11'b01010001000; // andi
        ctrl_sgnls[6'b010010] = 11'b01010001010; // xori
        ctrl_sgnls[6'b010011] = 11'b00000010010; // beq
        //ctrl_sgnls[6'b010100] = 11'i1; //bne
        ctrl_sgnls[6'b010101] = 11'b01111000000; // lw
        ctrl_sgnls[6'b010110] = 11'b01001000000; // sw
        ctrl_sgnls[6'b010111] = 11'b10010000100; // slt
        ctrl_sgnls[6'b011000] = 11'b01010001100; // slti
        ctrl_sgnls[6'b110000] = 11'b00000011111; // jmp
    end

    always @(instr) begin
        reg_dst     = ctrl_sgnls[opcode][10];
        alu_src     = ctrl_sgnls[opcode][9];
        mem_to_reg  = ctrl_sgnls[opcode][8];
        reg_wrt     = ctrl_sgnls[opcode][7];
        mem_wrt     = ctrl_sgnls[opcode][6];
        mem_rd      = ctrl_sgnls[opcode][5];
        brnch       = ctrl_sgnls[opcode][4];
        alu_op      = ctrl_sgnls[opcode][3:1];
        jmp         = ctrl_sgnls[opcode][0];
    end

endmodule
