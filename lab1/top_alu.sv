`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2026 02:00:19 PM
// Design Name: 
// Module Name: top_alu
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


module top_alu(
    input clk
    );
    localparam WIDTH = 32;
    logic [3:0] OPCODE;
    logic [WIDTH-1:0] A;
    logic [WIDTH-1:0] B;
    logic [WIDTH-1:0] R;
    logic ZF;
    
    ALU #(.WIDTH(WIDTH)) alu_inst (
        .OPCODE(OPCODE),
        .A(A),
        .B(B),
        .R(R),
        .ZF(ZF)
    );
    
    vio_0 vio_inst (
        .clk (clk),
        .probe_in0 (R),
        .probe_in1 (ZF),
        .probe_out0 (OPCODE),
        .probe_out1 (A),
        .probe_out2 (B)
    );
endmodule
