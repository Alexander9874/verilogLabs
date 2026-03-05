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
    input logic [WIDTH-1:0] A,
    input logic [WIDTH-1:0] B,
    input logic C,
    output logic [WIDTH-1:0] R
    );
    logic [WIDTH:0] c;
    always_comb begin
        c[0] = C;
        for (int i = 0; i < WIDTH; i++) begin
            R[i] = A[i] ^ B[i] ^ c[i];
            c[i+1] = A[i] & B[i] | A[i] & c[i] | B[i] & c[i];
        end
    end
endmodule

module SLL #(parameter WIDTH = 8)(
    input logic [WIDTH-1:0] A,
    input logic [WIDTH-1:0] B,
    output logic [WIDTH-1:0] R
    );
    always_comb begin
        if (B >= WIDTH)
            R = 0;
        else
            R = A << B;
    end
endmodule

// A[WIDTH] ? SRA : SRL
module SRX #(parameter WIDTH = 8)(
    input logic [WIDTH:0] A,
    input logic [WIDTH-1:0] B,
    output logic [WIDTH-1:0] R
    );
    always_comb begin
        if (B >= WIDTH)
            R = {WIDTH{A[WIDTH]}};
        else
            R = $signed(A) >>> B;
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
    logic [WIDTH-1:0] R_SLL;
    logic [WIDTH-1:0] R_SRX;

    ADD  #(WIDTH) _add  (.A(A), .B(OPCODE[3] ? ~B : B), .C(OPCODE[3]), .R(R_ADD));
    XOR  #(WIDTH) _xor  (.A(A), .B(B), .R(R_XOR));
    SLL  #(WIDTH) _sll  (.A(A), .B(B), .R(R_SLL));
    SRX  #(WIDTH) _srx  (.A({OPCODE[3] & A[WIDTH-1], A}), .B(B), .R(R_SRX));

    always_comb begin
        unique casex (OPCODE)    
            4'bx000: R = R_ADD;
            4'b0100: R = A ^ B;
            4'b0110: R = A | B;
            4'b0111: R = A & B;
            4'b0001: R = R_SLL;
            4'bx101: R = R_SRX;
            4'b0010: R = ($signed(A) < $signed(B)) ? 1 : 0;
            4'b0011: R = (A < B) ? 1 : 0;
            default: R = 0;
        endcase
    end
    
    assign ZF = (R == 0);
endmodule
