`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2026 11:44:12 AM
// Design Name: 
// Module Name: ISEU
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


module ISEU #(parameter XLEN = 32)
(  
    input  logic [31:7]  iseu_input,
    input  logic [1:0]   iseu_fmt,
    output logic [31:0]  iseu_output
);
    always_comb
    begin
        unique case(iseu_fmt)
            // FMT I (Immediate)
            2'b000: iseu_output = $signed({iseu_input[31:20]});
            // FMT S (Store)
            2'b001: iseu_output = $signed({iseu_input[31:25], iseu_input[11:7]});
            // FMT B (Branch)
            2'b010: iseu_output = $signed({iseu_input[31], iseu_input[7], iseu_input[30:25], iseu_input[11:8], 1'b0});
            // FMT J (Jump)
//            2'b011: iseu_output = $signed({iseu_input[31], iseu_input[19:12], iseu_input[20], iseu_input[30:21], 1'b0});
//            // FMT U (Upper Immediate)
//            3'b100: iseu_output = {iseu_input[31:12], 12'b0};
            default: iseu_output = 0;
        endcase
    end
endmodule
