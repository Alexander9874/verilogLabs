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
    input  logic [WIDTH:0] A,
    input  logic [WIDTH:0] B,
    input  logic C,
    output logic [WIDTH:0] R
    );
    logic [WIDTH+1:0] c;
    always_comb begin
        c[0] <= C;
        for (int i = 0; i <= WIDTH; i++) begin
            R[i]  <= A[i] ^ B[i] ^ c[i];
            c[i+1] = A[i] & B[i] | A[i] & c[i] | B[i] & c[i];
        end
    end
endmodule

// A[WIDTH] ? SRA : SRL
module SRX #(parameter WIDTH = 8)(
    input logic  [WIDTH:0]   A,
    input logic  [WIDTH-1:0] B,
    output logic [WIDTH-1:0] R
    );
    always_comb begin
        if (B >= WIDTH)
            R <= {WIDTH{A[WIDTH]}};
        else
            R <= $signed(A) >>> B;
    end
endmodule

module REVERS #(parameter WIDTH = 8)(
    input logic  [WIDTH-1:0] A,
    output logic [WIDTH-1:0] R
    );
    always_comb begin
        for (int i = 0; i < WIDTH; i++) begin
            R[i] <= A[WIDTH - 1 - i];
        end
    end
endmodule

module ALU #(parameter WIDTH = 8)(
    input  logic [3:0] OPCODE,
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    output logic [WIDTH-1:0] R,
    output logic ZF
    );
    logic [WIDTH:0] ADD_A;
    logic [WIDTH:0] ADD_B;
    logic           ADD_C;
    logic [WIDTH:0] ADD_R;
    ADD  #(WIDTH) _add  (.A(ADD_A), .B(ADD_B), .C(ADD_C), .R(ADD_R));

    logic [WIDTH:0] SRX_A;
    logic [WIDTH:0] SRX_R;
    SRX  #(WIDTH) _srx  (.A(SRX_A), .B(B), .R(SRX_R));
    
    logic [WIDTH:0] SLL_A;
    logic [WIDTH:0] SLL_R;
    REVERS #(WIDTH) _revers0 (.A(A), .R(SLL_A));
    REVERS #(WIDTH) _revers1 (.A(SRX_R), .R(SLL_R));

    always_comb begin
        unique casex (OPCODE)    
            4'bx000: begin
                ADD_A <= {A[WIDTH - 1], A};
                ADD_B <= OPCODE[3] ? ~{B[WIDTH - 1], B} : {B[WIDTH - 1], B};
                ADD_C <= OPCODE[3];
                R <= ADD_R;
            end
            4'b0100: R <= A ^ B;
            4'b0110: R <= A | B;
            4'b0111: R <= A & B;
            4'b0001: begin
                SRX_A <= {1'b0, SLL_A};
                R <= SLL_R;
            end
            4'bx101: begin
                SRX_A <= {OPCODE[3] & A[WIDTH-1], A};
                R <= SRX_R;
            end
            4'b001x: begin 
                ADD_A = {OPCODE[0] ? 0 : A[WIDTH - 1], A};
                ADD_B = ~{OPCODE[0] ? 0 : B[WIDTH - 1], B};
                ADD_C = 1;
                R <= ADD_R[WIDTH];
            end 
            default: R <= 0;
        endcase
    end
    
    assign ZF = (R == 0);
endmodule
