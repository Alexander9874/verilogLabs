`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2026 03:30:04 PM
// Design Name: 
// Module Name: test_bench_counter
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


module test_bench_counter();
    logic CLOCK;
    logic [2:0]  INPUT_SIGNALS;
    logic [31:0] DATA_IN;
    logic [31:0] DATA_OUT;
    logic [31:0] DATA_OUT_EXPECTED;
    localparam  iterations_max = 10000;
    
    COUNTER _counter (
        .CLOCK        (CLOCK),
        .RESET        (INPUT_SIGNALS[0]),
        .LOAD         (INPUT_SIGNALS[1]),
        .COUNT_ENABLE (INPUT_SIGNALS[2]),
        .DATA_IN      (DATA_IN),
        .DATA_OUT     (DATA_OUT)
        );
        
    always #10 CLOCK = ~CLOCK;
    
    initial begin
        $display ("COUNTER TEST BENCH BEGIN");
        CLOCK = 0;
        INPUT_SIGNALS = 0;
        #5
        assert (DATA_OUT == 0)
        else $error("initial reset failed");
        for(int i = 0; i < iterations_max; i++) begin
            INPUT_SIGNALS = $urandom;
            unique casex (INPUT_SIGNALS)
            // RESET
            3'bxx0:
                DATA_OUT_EXPECTED = 0;
            // LOAD
            3'bx11: begin 
                DATA_OUT_EXPECTED = $urandom;
                DATA_IN = DATA_OUT_EXPECTED;
            end
            // COUNT
            3'b101:
                DATA_OUT_EXPECTED = DATA_OUT + 4;
            // DO NOTHING
            3'b001:
                DATA_OUT_EXPECTED = DATA_OUT;
            endcase
            #20
            assert (DATA_OUT == DATA_OUT_EXPECTED)
            else $error (
                "RESET = %b\tLOAD = %b\tCOUNT = %d\tDATA_OUT = %d (%d)\n",
                INPUT_SIGNALS[0], INPUT_SIGNALS[1], INPUT_SIGNALS[2], DATA_OUT, DATA_OUT_EXPECTED
            );
        end
        $display ("COUNTER TEST BENCH END");
        $finish;
    end
endmodule
