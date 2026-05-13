`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2026 07:01:30 PM
// Design Name: 
// Module Name: tb_pll_wrapper
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


module tb_pll_wrapper;

    logic clk_in;
    logic rst;
    logic pwrdwn;
    logic clkout0;
    logic clkout1;
    logic clkout2;
    logic clkout3;
    logic clkout4;
    logic clkout5;
    logic locked;

    pll_wrapper _pll_wrapper (
        .clk_in  (clk_in),
        .rst     (rst),
        .pwrdwn  (pwrdwn),
        .clkout0 (clkout0),
        .clkout1 (clkout1),
        .clkout2 (clkout2),
        .clkout3 (clkout3),
        .clkout4 (clkout4),
        .clkout5 (clkout5),
        .locked  (locked)
    );

    initial clk_in = 0;
    
    // T = 1000 / 425 = 2.353 ns
    // T / 2 = 1.176
    always #1.176 clk_in = ~clk_in;

    initial begin
        $display("TB BEGIN");
    
        rst    = 1;
        pwrdwn = 0;
        #10;
        rst    = 0;

        if (!locked)
            @(posedge locked);

        $display("Locked %0.3f ns", $realtime);

        measure_period("clkout0", clkout0);
        measure_period("clkout1", clkout1);
        measure_period("clkout2", clkout2);
        measure_period("clkout3", clkout3);
        measure_period("clkout4", clkout4);
        measure_period("clkout5", clkout5);

        pwrdwn = 1;
        #50;

        $display("TB END");

        $finish;
    end

    task automatic measure_period(string name, ref logic clk);
        realtime up1, up2, down1, period, pulse_duration;
        @(posedge clk);
        up1 = $realtime;
        @(negedge clk);
        down1 = $realtime;
        @(posedge clk);
        up2 = $realtime;
        period = up2 - up1;
        pulse_duration = down1 - up1;
        $display("%s:\tT = %0.4f ns,  \tF = %0.4f MHz,\t PW = %0.4f ns,\tD = %0.4f",
                 name, period, 1000.0 / period, pulse_duration, pulse_duration / period);
    endtask

endmodule