`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2026 12:15:57 PM
// Design Name: 
// Module Name: tb_fifo_async
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


module tb_fifo_async;

    localparam int WIDTH                = 8;
    localparam int DEPTH                = 16;
    localparam int ALMOST_EMPTY_PERCENT = 20;
    localparam int STAGES               = 2;

    logic                     wclk;
    logic                     rclk;
    logic                     rst;
    logic                     wr;
    logic                     rd;
    logic [WIDTH-1:0]         din;
    logic [WIDTH-1:0]         dout;
    logic                     empty;
    logic                     full;
    logic                     almost_empty;
    logic [$clog2(DEPTH)-1:0] free_count;

    fifo_async #(
        .WIDTH               (WIDTH),
        .DEPTH               (DEPTH),
        .ALMOST_EMPTY_PERCENT(ALMOST_EMPTY_PERCENT),
        .STAGES              (STAGES)
        ) dut (
        .wclk         (wclk),
        .rclk         (rclk),
        .rst          (rst),
        .wr           (wr),
        .rd           (rd),
        .din          (din),
        .dout         (dout),
        .empty        (empty),
        .full         (full),
        .almost_empty (almost_empty),
        .free_count   (free_count)
        );

    initial begin
        wclk = 1'b0;
        forever #5 wclk = ~wclk;
    end

    initial begin
        rclk = 1'b0;
        #2;
        forever #12 rclk = ~rclk;
    end

    initial begin
        $display("TB BEGIN");
    
        wr  = 1'b0;
        rd  = 1'b0;
        din = '0;
        rst = 1'b1;
        #50;
        rst = 1'b0;

        repeat(10) @(posedge wclk);
        repeat(10) @(posedge rclk);

        for (int i = 0; i < 15; i++) begin
            @(posedge wclk);
            while (full) begin
                $display("FIFO is FULL 88, waiting (time %0t)", $time);
                @(posedge wclk);
            end
            wr  <= 1'b1;
            din <= i;
            @(posedge wclk);
            wr  <= 1'b0;
        end

        repeat(5) @(posedge wclk);
        repeat(10) @(posedge rclk);

        for (int i = 0; i < 15; i++) begin
            @(posedge rclk);
            while (empty) begin
                $display("FIFO is EMPTY 103, waiting (time %0t)", $time);
                @(posedge rclk);
            end
            rd <= 1'b1;
            @(posedge rclk);
            assert(dout == i)
            else $error("ERROR 109: dout = %0d (%0d) (time %0t)", dout, i, $time);
            rd <= 1'b0;
        end
        
        repeat(5) @(posedge wclk);
        repeat(5) @(posedge rclk);

        rst = 1'b1;
        wr  = 1'b0;
        rd  = 1'b0;
        #50;
        rst = 1'b0;

        repeat(10) @(posedge wclk);
        repeat(10) @(posedge rclk);

        fork
            begin
                for (int i = 0; i < 24; i++) begin
                    @(posedge wclk);
                    while (full) begin
                        $display("FIFO is FULL 127, waiting (time %0t)", $time);
                        @(posedge wclk);
                    end
                    wr  <= 1'b1;
                    din <= i;
                    @(posedge wclk);
                    wr  <= 1'b0;
                end
            end

            begin
                for (int j = 0; j < 24; j++) begin
                    @(posedge rclk);
                    while (empty) begin
                        $display("FIFO is EMPTY 141, waiting (time %0t)", $time);
                        @(posedge rclk);
                    end
                    rd <= 1'b1;
                    @(posedge rclk);
                    assert(dout == j)
                    else $error("ERROR 147: dout = %0d (%0d) (time %0t)", dout, j, $time);
                    rd <= 1'b0;
                end
            end
        join

        repeat(5) @(posedge wclk);
        repeat(5) @(posedge rclk);
        
        $display("TB END");
   
        $finish;
    end

endmodule
