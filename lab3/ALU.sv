`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 02/25/2026 02:02:53 PM
//// Design Name: 
//// Module Name: ALU
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////


module ALU #(parameter WIDTH = 32)(
    input  logic [3:0] OPCODE,
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    output logic [WIDTH-1:0] R,
    output logic ZF
    );

    always_comb begin
        unique case (OPCODE)    
            4'b0000: R = A + B;
            4'b1000: R = A - B;
            4'b0100: R = A ^ B;
            4'b0110: R = A | B;
            4'b0111: R = A & B;
            4'b0001: R = A << B;
            4'b0101: R = A >> B;
            4'b1101: R = $signed(A) >>> B;
            4'b0010: R = $signed(A) < $signed(B);
            4'b0011: R = A < B;
            default: R = 0;
        endcase
    end
    
    assign ZF = (R == 0);
endmodule
