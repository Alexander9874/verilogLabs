`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2026 06:59:47 PM
// Design Name: 
// Module Name: pll_wrapper
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


module pll_wrapper (
    input  logic clk_in,    // 425
    input  logic rst,
    input  logic pwrdwn,

    output logic clkout0,   // 41
    output logic clkout1,   // 14
    output logic clkout2,   // 54
    output logic clkout3,   // 18
    output logic clkout4,   // 14
    output logic clkout5,   // 26
    output logic locked
);

    logic clkfb;
    
    PLLE2_BASE #(
        .BANDWIDTH("OPTIMIZED"),
        .CLKFBOUT_MULT(63),
        .CLKFBOUT_PHASE(0.0),
        .CLKIN1_PERIOD(2.353),
        
        .CLKOUT0_DIVIDE(26),
        .CLKOUT1_DIVIDE(79),
        .CLKOUT2_DIVIDE(20),
        .CLKOUT3_DIVIDE(61),
        .CLKOUT4_DIVIDE(79),
        .CLKOUT5_DIVIDE(42),

        .CLKOUT0_DUTY_CYCLE(0.385),
        .CLKOUT1_DUTY_CYCLE(0.127),
        .CLKOUT2_DUTY_CYCLE(0.500),
        .CLKOUT3_DUTY_CYCLE(0.164),
        .CLKOUT4_DUTY_CYCLE(0.127),
        .CLKOUT5_DUTY_CYCLE(0.238),

        .CLKOUT0_PHASE(0.0),
        .CLKOUT1_PHASE(0.0),
        .CLKOUT2_PHASE(0.0),
        .CLKOUT3_PHASE(0.0),
        .CLKOUT4_PHASE(0.0),
        .CLKOUT5_PHASE(0.0),

        .DIVCLK_DIVIDE(25),
        .REF_JITTER1(0.0),
        .STARTUP_WAIT("FALSE")
    )
    _PLLE2_BASE (
        .CLKOUT0(clkout0),
        .CLKOUT1(clkout1),
        .CLKOUT2(clkout2),
        .CLKOUT3(clkout3),
        .CLKOUT4(clkout4),
        .CLKOUT5(clkout5),

        .CLKFBOUT(clkfb),

        .LOCKED(locked),

        .CLKIN1(clk_in),

        .PWRDWN(pwrdwn),
        .RST(rst),

        .CLKFBIN(clkfb)
    );

endmodule