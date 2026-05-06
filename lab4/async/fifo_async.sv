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
    parameter  int DATA_WIDTH        = 8,
    parameter  int DEPTH             = 16,
    parameter  int ALMOST_EMPTY_LVL  = 20,
    parameter  int SYNC_STAGES       = 2,
    localparam int ADDR_W            = $clog2(DEPTH)
) (
    input  logic                  WCLK,
    input  logic                  WR,
    input  logic [DATA_WIDTH-1:0] DIN,
    output logic                  FULL,

    input  logic                  RCLK,
    input  logic                  RD,
    output logic [DATA_WIDTH-1:0] DOUT,
    output logic                  EMPTY,
    output logic                  ALMOST_EMPTY,
    output logic [ADDR_W-1:0]     FREE_COUNT,

    input  logic                  RST
);

    localparam int AE_THRESH = (DEPTH * ALMOST_EMPTY_LVL) / 100;

    logic rst_wclk, rst_rclk;

    reset_sync #(.STAGES(SYNC_STAGES)) u_rst_wclk (
        .clk(WCLK), .async_rst(RST), .sync_rst(rst_wclk));

    reset_sync #(.STAGES(SYNC_STAGES)) u_rst_rclk (
        .clk(RCLK), .async_rst(RST), .sync_rst(rst_rclk));

    logic [ADDR_W-1:0] WA;
    logic              wr_en;

    assign wr_en = WR & ~FULL;

    counter #(.WIDTH(ADDR_W)) u_waddr (
        .CLK(WCLK), .CE(wr_en), .R(rst_wclk), .Q(WA));

    logic [ADDR_W-1:0] RA;
    logic              rd_en;

    assign rd_en = RD & ~EMPTY;

    counter #(.WIDTH(ADDR_W)) u_raddr (
        .CLK(RCLK), .CE(rd_en), .R(rst_rclk), .Q(RA));

    dp_ram #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH     (DEPTH)
    ) u_ram (
        .WCLK(WCLK), .RCLK(RCLK),
        .WA(WA), .RA(RA),
        .WR(wr_en), .WD(DIN),
        .RD(DOUT)
    );

    logic              w2r_busy;
    logic [ADDR_W-1:0] wa_last_sent;
    logic              wa_send;
    logic [ADDR_W-1:0] WA_r;
    logic w2r_valid_unused;

    assign wa_send = ~w2r_busy & (WA != wa_last_sent);

    always_ff @(posedge WCLK)
        if (rst_wclk) wa_last_sent <= '0;
        else if (wa_send) wa_last_sent <= WA;

    cdc_handshake #(.DATA_WIDTH(ADDR_W), .SYNC_STAGES(SYNC_STAGES)) u_w2r (
        .src_clk(WCLK), .src_rst(rst_wclk),
        .src_data(WA), .src_send(wa_send), .src_busy(w2r_busy),
        .dst_clk(RCLK), .dst_rst(rst_rclk),
        .dst_data(WA_r), .dst_valid(w2r_valid_unused)
    );

    logic              r2w_busy;
    logic [ADDR_W-1:0] ra_last_sent;
    logic              ra_send;
    logic [ADDR_W-1:0] RA_w;
    logic r2w_valid_unused;

    assign ra_send = ~r2w_busy & (RA != ra_last_sent);

    always_ff @(posedge RCLK)
        if (rst_rclk) ra_last_sent <= '0;
        else if (ra_send) ra_last_sent <= RA;

    cdc_handshake #(.DATA_WIDTH(ADDR_W), .SYNC_STAGES(SYNC_STAGES)) u_r2w (
        .src_clk(RCLK), .src_rst(rst_rclk),
        .src_data(RA), .src_send(ra_send), .src_busy(r2w_busy),
        .dst_clk(WCLK), .dst_rst(rst_wclk),
        .dst_data(RA_w), .dst_valid(r2w_valid_unused)
    );

    assign EMPTY = (WA_r == RA);

    assign FULL  = ((WA + 1'b1) == RA_w);

    logic [ADDR_W-1:0] used_count;
    assign used_count = WA_r - RA;
    assign FREE_COUNT = (ADDR_W'(DEPTH - 1)) - used_count;

    assign ALMOST_EMPTY = (FREE_COUNT > ADDR_W'(AE_THRESH));

endmodule
