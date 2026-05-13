`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2026 04:15:59 PM
// Design Name: 
// Module Name: fifo_async
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


module fifo_async #(
    parameter int WIDTH                = 8,
    parameter int DEPTH                = 16,
    parameter int ALMOST_EMPTY_PERCENT = 20,
    parameter int STAGES               = 2,
    localparam int ADDR_WIDTH          = $clog2(DEPTH),
    localparam int THRESHOLD           = (DEPTH * ALMOST_EMPTY_PERCENT) / 100
    ) (
    input  logic                  wclk,
    input  logic                  rclk,
    input  logic                  rst,
    input  logic                  wr,
    input  logic                  rd,
    input  logic [WIDTH-1:0]      din,

    output logic [WIDTH-1:0]      dout,
    output logic                  empty,
    output logic                  full,
    output logic                  almost_empty,
    output logic [ADDR_WIDTH-1:0] free_count
    );

    logic rst_wclk;
    logic rst_rclk;

    reset_sync #(.STAGES(STAGES)) _write_reset_sync (
        .clk(wclk),
        .async_rst(rst),
        .sync_rst(rst_wclk)
        );

    reset_sync #(.STAGES(STAGES)) _read_reset_sync (
        .clk(rclk),
        .async_rst(rst),
        .sync_rst(rst_rclk)
        );

    logic [ADDR_WIDTH-1:0] ra;
    logic [ADDR_WIDTH-1:0] wa;    

    logic                  w2r_busy;
    logic                  r2w_busy;
    logic                  w2r_send;
    logic                  r2w_send;
    logic [ADDR_WIDTH-1:0] w2r_last_sent;
    logic [ADDR_WIDTH-1:0] r2w_last_sent;
    logic [ADDR_WIDTH-1:0] w2r_wa;
    logic [ADDR_WIDTH-1:0] r2w_ra;
    

    assign w2r_send = ~w2r_busy & (wa != w2r_last_sent);
    assign r2w_send = ~r2w_busy & (ra != r2w_last_sent);

    always_ff @(posedge wclk)
        if (rst_wclk) w2r_last_sent <= '0;
        else if (w2r_send) w2r_last_sent <= wa;
        
    always_ff @(posedge rclk)
        if (rst_rclk) r2w_last_sent <= '0;
        else if (r2w_send) r2w_last_sent <= ra;

    cdc_handshake #(
        .WIDTH(ADDR_WIDTH),
        .STAGES(STAGES)
        ) _w2r_cdc (
        .src_clk(wclk),
        .src_rst(rst_wclk),
        .src_data(wa),
        .src_send(w2r_send),
        .src_busy(w2r_busy),
        .dst_clk(rclk),
        .dst_rst(rst_rclk),
        .dst_data(w2r_wa)
    );

    cdc_handshake #(
        .WIDTH(ADDR_WIDTH),
        .STAGES(STAGES)
        ) _r2w_cdc (
        .src_clk(rclk),
        .src_rst(rst_rclk),
        .src_data(ra),
        .src_send(r2w_send),
        .src_busy(r2w_busy),
        .dst_clk(wclk),
        .dst_rst(rst_wclk),
        .dst_data(r2w_ra)
    );
    
        
    logic wr_en;
    logic rd_en;

    assign empty = (w2r_wa == ra);
    assign full  = ((wa + 1'b1) == r2w_ra);
    
    assign wr_en = wr & ~full;
    assign rd_en = rd & ~empty;

    counter #(.WIDTH(ADDR_WIDTH)) _write_counter (
        .clk(wclk),
        .ce(wr_en),
        .r(rst_wclk),
        .q(wa)
        );

    counter #(.WIDTH(ADDR_WIDTH)) _read_counter (
        .clk(rclk),
        .ce(rd_en),
        .r(rst_rclk),
        .q(ra)
        );

    dp_ram #(
        .WIDTH (WIDTH),
        .DEPTH (DEPTH)
        ) _dp_ram (
        .clk(wclk),
        .wa(wa),
	.ra(ra),
        .wr(wr_en),
	.wd(din),
        .rd(dout)
        );

    logic [ADDR_WIDTH-1:0] count;
    assign count = (w2r_wa - ra) & (DEPTH - 1);
    assign free_count = (ADDR_WIDTH)'(DEPTH - count - 1);
    assign almost_empty = (count <= THRESHOLD);

endmodule
