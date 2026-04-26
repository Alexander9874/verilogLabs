`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2026 10:54:03 AM
// Design Name: 
// Module Name: counter
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


module counter #(
    parameter int WIDTH = 4
)(
    input  logic             clk,
    input  logic             ce,
    input  logic             r,
    output logic [WIDTH-1:0] q
);
    always_ff @(posedge clk) begin
        if (r)
            q <= '0;
        else if (ce)
            q <= q + 1'b1;
    end
endmodule
