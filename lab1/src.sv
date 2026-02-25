`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2026 02:02:53 PM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ADD #(parameter WIDTH = 8)(
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    output logic [WIDTH-1:0] R
    );
    assign R = A + B;
endmodule

module SUB #(parameter WIDTH = 8)(
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    output logic [WIDTH-1:0] R
    );
    ADD #(.WIDTH(WIDTH)) add (
        .A (A),
        .B (~B + 1),
        .R (R)
    );
endmodule

module XOR #(parameter WIDTH = 8)(
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    output logic [WIDTH-1:0] R
    );
    always_comb begin
        R <= A ^ B;
    end
endmodule

module OR #(parameter WIDTH = 8)(
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    output logic [WIDTH-1:0] R
    );
    always_comb begin
        R <= A | B;
    end
endmodule

module AND #(parameter WIDTH = 8)(
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    output logic [WIDTH-1:0] R
    );
    always_comb begin
        R <= A & B;
    end
endmodule

module SLL #(parameter WIDTH = 8)(
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    output logic [WIDTH-1:0] R
    );
    always_comb begin
        R <= A << B;
    end
endmodule

module SRL #(parameter WIDTH = 8)(
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    output logic [WIDTH-1:0] R
    );
    always_comb begin
        R <= A >> B;
    end
endmodule

module SRA #(parameter WIDTH = 8)(
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    output logic [WIDTH-1:0] R
    );
    always_comb begin
        if (B >= WIDTH)
            R = {WIDTH{A[WIDTH-1]}};
        else
            R = $signed(A) >>> B;
    end
endmodule

module SLT #(parameter WIDTH = 8)(
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    output logic [WIDTH-1:0] R
    );
    always_comb begin
        unique case ({A[WIDTH-1], B[WIDTH-1]})
            2'b00,
            2'b11:
                R = (A < B) ? 1 : 0;
            2'b01:
                R = 0;
            2'b10:
                R = 1;
            default: R = 0;
        endcase
    end
endmodule

module SLTU #(parameter WIDTH = 8)(
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    output logic [WIDTH-1:0] R
    );
    always_comb begin
        R = (A < B) ? 1 : 0;
    end
endmodule


module ALU #(parameter WIDTH = 8)(
    input  logic [3:0] OPCODE,
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    output logic [WIDTH-1:0] R,
    output logic ZF
);
    logic [WIDTH-1:0] R_ADD;
    logic [WIDTH-1:0] R_SUB;
    logic [WIDTH-1:0] R_XOR;
    logic [WIDTH-1:0] R_OR;
    logic [WIDTH-1:0] R_AND;
    logic [WIDTH-1:0] R_SLL;
    logic [WIDTH-1:0] R_SRL;
    logic [WIDTH-1:0] R_SRA;
    logic [WIDTH-1:0] R_SLT;
    logic [WIDTH-1:0] R_SLTU;

    ADD  #(WIDTH) _add  (.A(A), .B(B), .R(R_ADD));
    SUB  #(WIDTH) _sub  (.A(A), .B(B), .R(R_SUB));
    XOR  #(WIDTH) _xor  (.A(A), .B(B), .R(R_XOR));
    OR   #(WIDTH) _or   (.A(A), .B(B), .R(R_OR));
    AND  #(WIDTH) _and  (.A(A), .B(B), .R(R_AND));
    SLL  #(WIDTH) _sll  (.A(A), .B(B), .R(R_SLL));
    SRL  #(WIDTH) _srl  (.A(A), .B(B), .R(R_SRL));
    SRA  #(WIDTH) _sra  (.A(A), .B(B), .R(R_SRA));
    SLT  #(WIDTH) _slt  (.A(A), .B(B), .R(R_SLT));
//    SLTU #(WIDTH) _sltu (.A(A), .B(B), .R(R_SLTU));

    always_comb begin
        unique case (OPCODE)
            4'b0000: R = R_ADD;
            4'b1000: R = R_SUB;
            4'b0100: R = R_OR;
            4'b0110: R = R_AND;
            4'b0111: R = R_AND;
            4'b0001: R = R_SLL;
            4'b0101: R = R_SRL;
            4'b1101: R = R_SRA;
            4'b0010: R = R_SLT;
//            4'b0011: R = R_SLTU;
            4'b0011: R = (A < B) ? 1 : 0;
            default: R = 0;
        endcase
    end

    assign ZF = (R == '0);

endmodule
