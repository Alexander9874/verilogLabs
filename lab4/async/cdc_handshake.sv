`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2026 04:00:33 PM
// Design Name: 
// Module Name: cdc_handshake
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


module cdc_handshake #(
    parameter int DATA_WIDTH  = 4,
    parameter int SYNC_STAGES = 2
) (
    input  logic                  src_clk,
    input  logic                  src_rst,
    input  logic [DATA_WIDTH-1:0] src_data,
    input  logic                  src_send,
    output logic                  src_busy,

    input  logic                  dst_clk,
    input  logic                  dst_rst,
    output logic [DATA_WIDTH-1:0] dst_data,
    output logic                  dst_valid
);
    logic                  req;
    logic [DATA_WIDTH-1:0] xfer_data;

    logic                      dst_ack;
    logic [SYNC_STAGES-2:0]    xack_pipe;
    logic                      old_ack;

    always_ff @(posedge src_clk) begin
        if (src_rst) begin
            {old_ack, xack_pipe} <= '0;
        end else begin
            {old_ack, xack_pipe} <= {xack_pipe, dst_ack};
        end
    end

    assign src_busy = req | old_ack;

    always_ff @(posedge src_clk) begin
        if (src_rst) begin
            req       <= 1'b0;
            xfer_data <= '0;
        end else begin
            if (!src_busy && src_send) begin
                req       <= 1'b1;
                xfer_data <= src_data;
            end else if (old_ack) begin
                req <= 1'b0;
            end
        end
    end

    logic [SYNC_STAGES-2:0]    xreq_pipe;
    logic                      new_req;
    logic                      last_req;

    always_ff @(posedge dst_clk) begin
        if (dst_rst) begin
            {new_req, xreq_pipe} <= '0;
            last_req             <= 1'b0;
        end else begin
            {new_req, xreq_pipe} <= {xreq_pipe, req};
            last_req             <= new_req;
        end
    end

    always_ff @(posedge dst_clk) begin
        if (dst_rst) begin
            dst_data  <= '0;
            dst_valid <= 1'b0;
            dst_ack   <= 1'b0;
        end else begin
            dst_valid <= 1'b0;

            if (!last_req && new_req) begin
                dst_data  <= xfer_data;
                dst_valid <= 1'b1;
                dst_ack   <= 1'b1;
            end else if (!new_req) begin
                dst_ack <= 1'b0;
            end
        end
    end

endmodule

