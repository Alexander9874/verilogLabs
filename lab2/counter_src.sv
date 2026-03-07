`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2026 03:29:02 PM
// Design Name: 
// Module Name: COUNTER
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


module COUNTER #(parameter WIDTH = 32)(
    input  CLOCK,
    input  RESET,
    input  LOAD,
    input  COUNT_ENABLE,
    input  logic[WIDTH-1:0] DATA_IN,
    output logic[31:0]      DATA_OUT
    );
    always_ff @(posedge CLOCK or negedge RESET) begin
        priority case (1)
            !RESET:       DATA_OUT <= '0;
            LOAD:         DATA_OUT <= DATA_IN;
            COUNT_ENABLE: DATA_OUT <= DATA_OUT + 4;
            default;
        endcase 
    end
endmodule
