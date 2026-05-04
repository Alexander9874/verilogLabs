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
    always #1.176470588 clk_in = ~clk_in;

    initial begin
        rst    = 1;
        pwrdwn = 0;
        #10;
        rst    = 0;

        if (!locked)
            @(posedge locked);

        $display("PLL locked at time %0.3f ns", $realtime);
        if ($realtime > 3_869_508.5)
            $display("WARNING: lock occurred later than expected (3,869,508.5 ns)");
        else
            $display("Lock time within expected window.");

        measure_period("clkout0", clkout0);
        measure_period("clkout1", clkout1);
        measure_period("clkout2", clkout2);
        measure_period("clkout3", clkout3);
        measure_period("clkout4", clkout4);
        measure_period("clkout5", clkout5);

        $finish;
    end

    initial begin
        #4_000_000;
        if (!locked) begin
            $display("ERROR: PLL did not lock within 4 ms");
            $finish;
        end
    end

    task automatic measure_period(string name, ref logic clk);
        realtime t1, t2, period;
        @(posedge clk);
        t1 = $realtime;
        @(posedge clk);
        t2 = $realtime;
        period = t2 - t1;
        $display("%s: period = %0.4f ns, frequency = %0.4f MHz",
                 name, period, 1000.0 / period);
    endtask

endmodule