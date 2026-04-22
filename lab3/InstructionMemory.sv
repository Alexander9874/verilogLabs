`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2026 12:56:35 AM
// Design Name: 
// Module Name: InstructionMemory
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


module InstructionMemory(
    input  logic [31:0]   address,
    output logic [31:0]   data_out
    );

    logic [31:0]data [63:0];

    initial
    begin
        $readmemh("instructions.txt", data);
    end

    always_comb
    begin
        assign data_out = data[address[31:2]];
    end

endmodule