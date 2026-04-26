`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2026 10:52:29 AM
// Design Name: 
// Module Name: dp_ram
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


module dp_ram #(
    parameter int WIDTH = 8,
    parameter int DEPTH = 16
    )(
    input  logic                     clk,
    input  logic [$clog2(DEPTH)-1:0] ra,
    input  logic [$clog2(DEPTH)-1:0] wa,
    input  logic                     wr,
    input  logic [WIDTH-1:0]         wd,
    output logic [WIDTH-1:0]         rd
    );
    logic [WIDTH-1:0] mem [0:DEPTH-1];
 
//    initial begin
//        for (int i = 0; i < DEPTH; i++)
//            mem[i] = '0;
//    end
 
    always_ff @(posedge clk) begin
        if (wr)
            mem[wa] <= wd;
    end
 
    assign rd = mem[ra];
 
endmodule