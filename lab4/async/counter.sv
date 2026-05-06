`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2026 03:49:24 PM
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


module counter #(parameter int WIDTH = 4) (
    input  logic             CLK,
    input  logic             CE,
    input  logic             R,
    output logic [WIDTH-1:0] Q
    );

    always_ff @(posedge CLK) begin
        if (R)
            Q <= '0;
        else if (CE)
            Q <= Q + 1'b1;
    end

endmodule
