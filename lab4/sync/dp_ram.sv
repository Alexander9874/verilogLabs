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
    parameter int WIDTH   = 8,
    parameter int DEPTH   = 16,
    localparam ADDR_WIDTH = $clog2(DEPTH)
    ) (
    input  logic                  clk,
    input  logic [ADDR_WIDTH-1:0] ra,
    input  logic [ADDR_WIDTH-1:0] wa,
    input  logic                  wr,
    input  logic [WIDTH-1:0]      wd,
    output logic [WIDTH-1:0]      rd
    );

    logic [WIDTH-1:0] mem [0:DEPTH-1];
  
    always_ff @(posedge clk) begin
        if (wr)
            mem[wa] <= wd;
    end
 
    assign rd = mem[ra];
 
endmodule
