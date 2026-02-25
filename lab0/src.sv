`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2026 12:11:36 PM
// Design Name: 
// Module Name: mux4_1
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


module mux4_1(
    input x0,
    input x1,
    input x2,
    input x3,
    input x4,
    input a0,
    input a1,
    output y
    );

    assign #10 y =  {a1,a0} == 2'b00 ? x0 :
                    {a1,a0} == 2'b01 ? x1 :
                    {a1,a0} == 2'b10 ? x2 : x3;
endmodule

