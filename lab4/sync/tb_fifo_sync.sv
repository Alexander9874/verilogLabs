`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2026 11:33:10 AM
// Design Name: 
// Module Name: tb_fifo_sync
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


module tb_fifo_sync;
    localparam int WIDTH  = 32;
    localparam int DEPTH  = 16;
    localparam int ADDR_W = $clog2(DEPTH);
    
    int num_read   = 0;
    int num_wright = 0;

    logic             clk = 0;
    logic             rst;
    logic             wr;
    logic             rd;
    logic [WIDTH-1:0] din;
    logic [WIDTH-1:0] dout;
    logic             empty;
    logic             full;

    fifo_sync #(
        .WIDTH (WIDTH),
        .DEPTH (DEPTH)
    ) _fifo_sync (
        .clk   (clk),
        .rst   (rst),
        .wr    (wr),
        .rd    (rd),
        .din   (din),
        .dout  (dout),
        .empty (empty),
        .full  (full)
    );

    always #5 clk = ~clk;

    initial begin
        $display("TB BEGIN");
        
        rst = 1;
        wr = 0;
        rd = 0;
        
        #6;
                
        assert (empty == 1 && full == 0)
        else $error("66: empty = 1, full = 0");
        
        rst = 0;
        wr = 1;
        rd = 0;
        
        for(int i = 0; i < DEPTH; i++) begin
            din = num_wright++;
            #10;
            if (i != DEPTH - 1)
                assert (empty == 0 && full == 0)
                else $error("77: empty = 0, full = 0");
            else
                assert (empty == 0 && full == 1)
                else $error("80: empty = 0, full = 1");
        end
        
        #10
        assert (empty == 0 && full == 1)
        else $error("85: empty = 0, full = 1");
        assert (dout == num_read)
        else $error("87: dout = num_read");
        
        rst = 0;
        wr = 0;
        rd = 1;
        
        for(int i = 0; i < DEPTH; i++) begin
            assert (dout == num_read)
            else $error("95: dout = num_read");
            #10;
            num_read++;
            if (i != DEPTH - 1)
                assert (empty == 0 && full == 0)
                else $error("100: empty = 0, full = 0");
            else
                assert (empty == 1 && full == 0)
                else $error("103: empty = 1, full = 0");
        end
        
        assert (dout == 0)
        else $error("107: dout = num_read");
        #10;
        assert (empty == 1 && full == 0)
        else $error("110: empty = 1, full = 0");
        assert (dout == 0)
        else $error("112: dout = num_read");
        #10;

        rst = 0;
        wr = 1;
        rd = 0;
        din = num_wright++;
        #10;
        assert (empty == 0 && full == 0)
        else $error("121: empty = 0, full = 0");
        
        rst = 0;
        wr = 1;
        rd = 1;
        
        for(int i = 0; i < 4; i++) begin
            din = num_wright++;
            assert (dout == num_read)
            else $error("130: dout = num_read");
            #10;
            num_read++;
            assert (empty == 0 && full == 0)
            else $error("134: empty = 0, full = 0");
        end
        
        rst = 1;
        wr = 0;
        rd = 0;
        #15;
        assert (empty == 1 && full == 0)
        else $error("142: empty = 1, full = 0");
        
        $display("TB FINISH");
        $finish;
    end

endmodule