`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2026 04:04:15 PM
// Design Name: 
// Module Name: reset_sync
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


module reset_sync #(
    parameter int STAGES = 2
    ) (
    input  logic clk,
    input  logic async_rst,
    output logic sync_rst
    );

    logic [STAGES-1:0] pipe;

    always_ff @(posedge clk or posedge async_rst) begin
        if (async_rst)
            pipe <= {STAGES{1'b1}};
        else
            pipe <= {pipe[STAGES-2:0], 1'b0};
    end

    assign sync_rst = pipe[STAGES-1];

endmodule
