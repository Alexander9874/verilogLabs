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
    parameter int WIDTH = 8,
    parameter int DEPTH = 16
    )(
    input  logic             clk,
    input  logic             rst,
    input  logic             wr,
    input  logic             rd,
    input  logic [WIDTH-1:0] din,
    output logic [WIDTH-1:0] dout,
    output logic             empty,
    output logic             full
    );
 
    localparam int ADDR_WIDTH = $clog2(DEPTH);

    logic [ADDR_WIDTH:0] ra;
    logic [ADDR_WIDTH:0] wa;
    logic                wr_en;
    logic                rd_en;
    
    counter #(.WIDTH(ADDR_WIDTH + 1)) _read_addr_counter (
        .clk (clk),
        .ce  (rd_en),
        .r   (rst),
        .q   (ra)
        );
 
    counter #(.WIDTH(ADDR_WIDTH + 1)) _write_addr_counter (
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
        .ra  (ra[ADDR_WIDTH-1:0]),
        .wa  (wa[ADDR_WIDTH-1:0]),
        .wr  (wr_en),
        .wd  (din),
        .rd  (dout)
        );
        
    assign empty = (ra == wa);
    assign full  = (ra[ADDR_WIDTH-1:0] == wa[ADDR_WIDTH-1:0]) &&
                   (ra[ADDR_WIDTH]     != wa[ADDR_WIDTH]);
    assign wr_en = wr & ~full;
    assign rd_en = rd & ~empty;
 
endmodule
