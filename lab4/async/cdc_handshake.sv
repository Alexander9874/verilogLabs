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
    parameter int WIDTH  = 4,
    parameter int STAGES = 2
    ) (
    input  logic             src_clk,
    input  logic             src_rst,
    input  logic [WIDTH-1:0] src_data,
    input  logic             src_send,
    output logic             src_busy,

    input  logic             dst_clk,
    input  logic             dst_rst,
    output logic [WIDTH-1:0] dst_data
    );

    logic              req;
    logic [WIDTH-1:0]  data;
    logic              dst_ack;
    logic [STAGES-2:0] ack_pipe;
    logic              old_ack;

    assign src_busy = req | old_ack;

    always_ff @(posedge src_clk) begin
        if (src_rst) begin
	    old_ack  <= '0;
	    ack_pipe <= '0;
	    req      <= '0;
        data     <= '0;
        end
	else begin
            {old_ack, ack_pipe} <= {ack_pipe, dst_ack};
	    if (!src_busy && src_send) begin
                req  <= 1'b1;
                data <= src_data;
            end
	    else if (old_ack) begin
                req <= '0;
            end
        end
    end

    logic [STAGES-2:0] req_pipe;
    logic              new_req;
    logic              last_req;

    always_ff @(posedge dst_clk) begin
        if (dst_rst) begin
            new_req  <= '0;
            req_pipe <= '0;
	        last_req <= '0;
            dst_data <= '0;
            dst_ack  <= '0;
        end
	else begin
            {new_req, req_pipe} <= {req_pipe, req};
            last_req <= new_req;

            if (!last_req && new_req) begin
                dst_data <= data;
                dst_ack  <= 1'b1;
            end
	    else if (!new_req) begin
                dst_ack <= '0;
            end
        end
    end

endmodule
