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
    localparam WIDTH = 4;

    logic [WIDTH-1:0] A;
    logic [WIDTH-1:0] B;
    logic [WIDTH-1:0] R;
    logic [WIDTH-1:0] OPCODE;
    logic ZF;
    
    ALU #(.WIDTH(WIDTH)) DUT (
        .OPCODE(OPCODE),
        .A(A),
        .B(B),
        .R(R),
        .ZF(ZF)
    );
    
    initial begin
        $display("ALU TEST BEGIN: WIDTH = %0d", WIDTH);
        A <= 4;
        B <= 2;
        OPCODE = 4'b0000;
        #10;
        OPCODE = 4'b1000;
        #10;
        OPCODE = 4'b0100;
        #10;
        OPCODE = 4'b0110;
        #10;
        OPCODE = 4'b0111;
        #10;
        OPCODE = 4'b0001;
        #10;
        OPCODE = 4'b0101;
        #10;
        OPCODE = 4'b1101;
        #10;
        OPCODE = 4'b0010;
        #10;
        OPCODE = 4'b0011;
        #10;
        
        A <= 13;
        B <= 1;
        OPCODE = 4'b0000;
        #10;
        OPCODE = 4'b1000;
        #10;
        OPCODE = 4'b0100;
        #10;
        OPCODE = 4'b0110;
        #10;
        OPCODE = 4'b0111;
        #10;
        OPCODE = 4'b0001;
        #10;
        OPCODE = 4'b0101;
        #10;
        OPCODE = 4'b1101;
        #10;
        OPCODE = 4'b0010;
        #10;
        OPCODE = 4'b0011;
        #10;
        
        OPCODE = 4'B1111;
        #10;
        
        $display("TEST EDN");
    end
endmodule