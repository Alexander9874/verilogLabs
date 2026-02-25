`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2026 02:11:35 PM
// Design Name: 
// Module Name: TB_OPERS
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


module TB_OPERS;

    localparam WIDTH = 3;

    logic [WIDTH-1:0] A;
    logic [WIDTH-1:0] B;
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

    ADD #(.WIDTH(WIDTH)) DUT_ADD (
        .A(A),
        .B(B),
        .R(R_ADD)
    );
    
    SUB #(.WIDTH(WIDTH)) DUT_SUB (
        .A(A),
        .B(B),
        .R(R_SUB)
    );
    
    XOR #(.WIDTH(WIDTH)) DUT_XOR (
        .A(A),
        .B(B),
        .R(R_XOR)
    );
    
    OR #(.WIDTH(WIDTH)) DUT_OR (
        .A(A),
        .B(B),
        .R(R_OR)
    );

    AND #(.WIDTH(WIDTH)) DUT_AND (
        .A(A),
        .B(B),
        .R(R_AND)
    );
    
    SLL #(.WIDTH(WIDTH)) DUT_SLL (
        .A(A),
        .B(B),
        .R(R_SLL)
    );
    
    SRL #(.WIDTH(WIDTH)) DUT_SRL (
        .A(A),
        .B(B),
        .R(R_SRL)
    );
    
    SRA #(.WIDTH(WIDTH)) DUT_SRA (
        .A(A),
        .B(B),
        .R(R_SRA)
    );
    
    SLT #(.WIDTH(WIDTH)) DUT_SLT (
        .A(A),
        .B(B),
        .R(R_SLT)
    );
    
    SLTU #(.WIDTH(WIDTH)) DUT_SLTU (
        .A(A),
        .B(B),
        .R(R_SLTU)
    );
    
    initial begin
        $display("TEST BEGIN: WIDTH = %0d", WIDTH);

        for (int i = 0; i < 2**WIDTH; i++) begin
            for(int j = 0; j < 2**WIDTH; j++) begin
                A <= i;
                B <= j;
                #100;
//                assert (R == i + j)
//                else $error("ERROR!");
            end
        end
        $display("TEST EDN");
    end
endmodule
