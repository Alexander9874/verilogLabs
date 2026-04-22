`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2026 09:24:31 PM
// Design Name: 
// Module Name: TM_RISCV32
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


module TM_RISCV32(
    );
    
    logic CLK;
    logic RESET;
    
    always #1000 CLK = ~CLK;
    
    RISCVCore _core (
        .CLK(CLK),
        .Reset(RESET)
        );
    
    initial begin
        $display ("TEST BENCH BEGIN");
        CLK = 0;
        RESET = 0;
        #100;
        RESET = 1;
        while(1) begin
            $display ("TEST BENCH RUNNING");
            #1000;
        end
    end
    
endmodule
