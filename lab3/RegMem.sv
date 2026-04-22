`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2026 03:29:35 PM
// Design Name: 
// Module Name: REGMEM
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


module RegMem #(parameter WIDTH = 32)(
    input  CLOCK,
    input  WRITE,
    input  logic [4:0] WRITE_ADRESS,
    input  logic [4:0] ADRESS0,
    input  logic [4:0] ADRESS1,
    input  logic [WIDTH-1:0] DATA_IN,
    output logic [WIDTH-1:0] DATA_OUT0,
    output logic [WIDTH-1:0] DATA_OUT1
    );
    logic [WIDTH-1:0] regmem [31:1];
    always_ff @(posedge CLOCK) begin
        if (WRITE) begin
            regmem[WRITE_ADRESS] <= DATA_IN;
        end
    end
//    always_comb begin
//        DATA_OUT0 <= ADRESS0 ? mem[ADRESS0] : '0;
//        DATA_OUT1 <= ADRESS1 ? mem[ADRESS1] : '0;
//    end
    assign DATA_OUT0 = ADRESS0 ? regmem[ADRESS0] : 0;
    assign DATA_OUT1 = ADRESS1 ? regmem[ADRESS1] : 0;
endmodule