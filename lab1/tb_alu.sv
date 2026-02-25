`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2026 04:15:13 PM
// Design Name: 
// Module Name: TB_ALU
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


module TB_ALU;
    localparam WIDTH = 3;
    localparam OPCODE = 4'b0100;

    logic [WIDTH-1:0] A;
    logic [WIDTH-1:0] B;
    logic [WIDTH-1:0] R;
    logic ZF;
    
    ALU #(.WIDTH(WIDTH)) DUT (
        .OPCODE(OPCODE),
        .A(A),
        .B(B),
        .R(R),
        .ZF(ZF)
    );
    
    initial begin
        $display("TEST BEGIN: WIDTH = %0d", WIDTH);

        for (int i = 0; i < 2**WIDTH; i++) begin
            for(int j = 0; j < 2**WIDTH; j++) begin
                A <= i;
                B <= j;
                #100;
            end
        end
        $display("TEST EDN");
    end
endmodule
