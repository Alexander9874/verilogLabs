`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2026 12:14:43 PM
// Design Name: 
// Module Name: TB_mux4_1
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


module TB_mux4_1();
    logic [3:0] x;
    logic [1:0] a;
    logic y;
    mux4_1 DUT (
        .x0 (x[0]),
        .x1 (x[1]),
        .x2 (x[2]),
        .x3 (x[3]),
        .a0 (a[0]),
        .a1 (a[1]),
        .y (y)
        );
    initial begin : test
        $display("Test begin");
        #100;
        x <= 4'h0;
        for(int i=0; i<4; i++) begin
            for (int j=0; j<2**4; j++) begin
                x <= j;
                a <= i;
                #100;
                assert (y == x[i])
                else $error("Error!!!!");
            end
        end
        $display("Test end");
        $stop;
    end
endmodule
