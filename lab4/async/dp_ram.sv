`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2026 03:50:51 PM
// Design Name: 
// Module Name: dp_ram
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


module dp_ram #(
    parameter int DATA_WIDTH = 8,
    parameter int DEPTH      = 16,
    localparam    ADDR_WIDTH = $clog2(DEPTH)
    ) (
    input  logic                  WCLK,
    input  logic                  RCLK,
    input  logic [ADDR_WIDTH-1:0] WA,
    input  logic [ADDR_WIDTH-1:0] RA,
    input  logic                  WR,
    input  logic [DATA_WIDTH-1:0] WD,
    output logic [DATA_WIDTH-1:0] RD
    );

    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    always_ff @(posedge WCLK) begin
        if (WR)
            mem[WA] <= WD;
    end

    assign RD = mem[RA];

endmodule
