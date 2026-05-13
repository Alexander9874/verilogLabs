`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2026 11:13:50 AM
// Design Name: 
// Module Name: fifo_sync
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


module fifo_sync #(
    parameter int WIDTH                = 8,
    parameter int DEPTH                = 16,
    parameter int ALMOST_EMPTY_PERCENT = 20,
    localparam int ADDR_WIDTH          = $clog2(DEPTH),
    localparam int THRESHOLD           = (DEPTH * ALMOST_EMPTY_PERCENT) / 100
    ) (
    input  logic                  clk,
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

    logic [ADDR_WIDTH-1:0] ra;
    logic [ADDR_WIDTH-1:0] wa;
    
    logic wr_en;
    logic rd_en;
    
    assign empty = (ra == wa);
    assign full  = (ra == (ADDR_WIDTH)'(wa + 1));
    
    assign wr_en = wr & ~full;
    assign rd_en = rd & ~empty;
    
    counter #(.WIDTH(ADDR_WIDTH)) _read_counter (
        .clk (clk),
        .ce  (rd_en),
        .r   (rst),
        .q   (ra)
        );
 
    counter #(.WIDTH(ADDR_WIDTH)) _write_counter (
        .clk (clk),
        .ce  (wr_en),
        .r   (rst),
        .q   (wa)
        );

    dp_ram #(
        .WIDTH (WIDTH),
        .DEPTH (DEPTH)
        ) _dp_ram (
        .clk (clk),
        .ra  (ra),
        .wa  (wa),
        .wr  (wr_en),
        .wd  (din),
        .rd  (dout)
        );
        
    logic [ADDR_WIDTH-1:0] count;
    assign count = (wa - ra) & (DEPTH - 1);
    assign free_count = (ADDR_WIDTH)'(DEPTH - count - 1);
    assign almost_empty = (count <= THRESHOLD);
 
endmodule
