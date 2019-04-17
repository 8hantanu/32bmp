`timescale 1ns / 1ps

module alu(
    input clk,
    input [31:0] i0,
    input [31:0] i1,
    input [5:0]  alu_fn,
    output reg [31:0] otp,
    output reg zero,
    output reg ovrflo
);

    always @(i0 or i1 or alu_fn) begin

        case(alu_fn)

            6'b0000xx: begin
                case(alu_fn[1:0])
                    2'b00: begin // add
                        otp = i0 + i1;
                        zero = otp == 0 ? 1 : 0;
                        if ((i0 >= 0 && i1 >= 0 && otp < 0) || (i0 < 0 && i1 < 0 && otp >= 0))
                            ovrflo = 1;
                        else
                            ovrflo = 0;
                    end
                    2'b01: begin // sub
                        otp = i0 - i1;
                        zero = otp == 0 ? 1 : 0;
                        if ((i0 >= 0 && i1 < 0 && otp < 0) || (i0 < 0 && i1 >= 0 && otp > 0))
                            ovrflo = 1;
                        else
                            ovrflo = 0;
                    end
                    2'b10:  begin // mul
                        otp = i0*i1;
                        zero = otp == 0 ? 1 : 0;
                        ovrflo = 0;
                    end
                endcase
            end

            6'b0001xx: begin
                case (alu_fn[1:0])
                    2'b00: begin // and
                        otp = i0 & i1;
                        ovrflo = 0;
                        zero = otp == 0 ? 1 : 0;
                    end
                    2'b01: begin // or
                        otp = i0 | i1;
                        ovrflo = 0;
                        zero = otp == 0 ? 1 : 0;
                    end
                    2'b10: begin // xor
                        otp = i0 ^ i1;
                        ovrflo = 0;
                        zero = otp == 0 ? 1 : 0;
                    end
                endcase
            end

            6'b0010xx: begin
                case(alu_fn[1:0])
                    2'b00: begin // sll
                        otp = i0 << i1;
                        zero = otp == 0 ? 1 : 0;
                        ovrflo = 0;
                    end
                    2'b01: begin // srl
                        otp = i0 >> i1;
                        zero = otp == 0 ? 1 : 0;
                        ovrflo = 0;
                    end
                    2'b11: begin // slt
                        otp = i0 < i1 ? 1 : 0;
                        zero = otp == 0 ? 1 : 0;
                        ovrflo = 0;
                    end
                endcase
            end

            default: begin
                otp = {32{1'b0}};
            end

        endcase
        $display("i0%h - i1%h - otp %h alu_fn %i1", i0, i1, otp, alu_fn);
    end

endmodule
