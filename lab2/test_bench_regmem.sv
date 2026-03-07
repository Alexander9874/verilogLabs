`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2026 03:30:37 PM
// Design Name: 
// Module Name: test_bench_regmem
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


module test_bench_regmem();
    logic CLOCK;
    logic WRITE;
    logic [4:0] WRITE_ADRESS;
    logic [4:0] ADRESS0;
    logic [4:0] ADRESS1;
    logic [31:0] DATA_IN;
    logic [31:0] DATA_OUT0;
    logic [31:0] DATA_OUT1;
    logic [31:0] MEM_EXPECTED [31:0];
    localparam iterations_max = 10000;
    
    REGMEM _regmem (
        .CLOCK        (CLOCK),
        .WRITE        (WRITE),
        .WRITE_ADRESS (WRITE_ADRESS),
        .ADRESS0      (ADRESS0),
        .ADRESS1      (ADRESS1),
        .DATA_IN      (DATA_IN),
        .DATA_OUT0    (DATA_OUT0),
        .DATA_OUT1    (DATA_OUT1)
    );
    
    always #10 CLOCK = ~CLOCK;
    
    initial begin
        $display ("REGMEM TEST BENCH BEGIN");
        CLOCK <= 0;
        #5;
        WRITE <= 1;
        for(int i = 0; i < 32; i++) begin
            WRITE_ADRESS = i;
            DATA_IN <= 0;
            ADRESS0 <= i;
            ADRESS1 <= i;
            MEM_EXPECTED[i] <= 0;
            #20;
            assert (DATA_OUT0 == 0)
            else $error ("DATA_OUT0: initial reset failed");
            assert (DATA_OUT1 == 0)
            else $error ("DATA_OUT1: initial reset failed");
        end
        #4;
        for(int i = 0; i < iterations_max; i++) begin
            WRITE_ADRESS = $urandom;
            MEM_EXPECTED[WRITE_ADRESS] = $urandom;
            DATA_IN <= MEM_EXPECTED[WRITE_ADRESS];
            if(WRITE_ADRESS == 0)
                MEM_EXPECTED[WRITE_ADRESS] <= 0;
//            $display("WRITE:\tMEM_EXPECTED[%d] = %d\n", WRITE_ADRESS, MEM_EXPECTED[WRITE_ADRESS]);
            for (int j = 0; j < 10; j++) begin
                ADRESS0 <= $urandom;
                ADRESS1 <= $urandom;
                #2;
                assert (DATA_OUT0 == MEM_EXPECTED[ADRESS0])
                else $error ("ADRESS0 = %d\tDATA_OUT0 = %d (%d)\n", ADRESS0, DATA_OUT0, MEM_EXPECTED[ADRESS0]);
                assert (DATA_OUT1 == MEM_EXPECTED[ADRESS1])
                else $error ("ADRESS1 = %d\tDATA_OUT1 = %d (%d)\n", ADRESS1, DATA_OUT1, MEM_EXPECTED[ADRESS1]);
//                $display("READ:\tADRESS0 = %d\tDATA_OUT0 = %d\n", ADRESS0, DATA_OUT0);
//                $display("READ:\tADRESS1 = %d\tDATA_OUT1 = %d\n", ADRESS1, DATA_OUT1);
            end
        end
        $display ("REGMEM TEST BENCH END");
        $finish;
    end
endmodule
