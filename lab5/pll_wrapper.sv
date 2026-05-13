`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2026 05:42:36 PM
// Design Name: 
// Module Name: PLL
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
    input  logic clk_in,    // 425 MHz
    input  logic rst,
    input  logic pwrdwn,

    output logic clkout0,   // 41 MHz
    output logic clkout1,   // 14 MHz
    output logic clkout2,   // 54 MHz
    output logic clkout3,   // 18 MHz
    output logic clkout4,   // 14 MHz
    output logic clkout5,   // 26 MHz
    output logic locked
    );

    logic clkfb;
    
    PLLE2_BASE #(
        // M = 63
        // Fvco = 425 * 63 / 25 = 1071 MHz
        .CLKFBOUT_MULT(63),
        
        // T = 1000 / 425 = 2.353 ns
        .CLKIN1_PERIOD(2.353),  
        
        .CLKOUT0_DIVIDE(26),    // O0 = 26: Fout0 = 1071 / 26 = 41 MHz
        .CLKOUT1_DIVIDE(79),    // O1 = 79: Fout1 = 1071 / 79 = 14 MHz
        .CLKOUT2_DIVIDE(20),    // O2 = 20: Fout2 = 1071 / 20 = 54 MHz
        .CLKOUT3_DIVIDE(61),    // O3 = 61: Fout3 = 1071 / 61 = 18 MHz
        .CLKOUT4_DIVIDE(79),    // O4 = 79: Fout4 = 1071 / 79 = 14 MHz
        .CLKOUT5_DIVIDE(42),    // O5 = 42: Fout5 = 1071 / 42 = 26 MHz

        // DUTY_CYCLE: T_high = 0.5 * T_fout2 (T_fout2 - max freq.)
        // DUTY_CYCLE_i = 0.5 * O2 / Oi = 10 / Oi
        .CLKOUT0_DUTY_CYCLE(0.385), // 10 / 26  = 0.385
        .CLKOUT1_DUTY_CYCLE(0.127), // 10 / 79  = 0.127
        // CLKOUT1_DUTY_CYCLE is set to 0.127000 on instance tb_pll_wrapper._pll_wrapper._PLLE2_BASE.plle2_adv_1.clkout_duty_chk and is not in the allowed range 0.189873 to 0.816456.
        .CLKOUT2_DUTY_CYCLE(0.500), // 10 / 20  = 0.5
        .CLKOUT3_DUTY_CYCLE(0.164), // 10 / 61  = 0.164
        .CLKOUT4_DUTY_CYCLE(0.127), // 10 / 79  = 0.127
        // CLKOUT4_DUTY_CYCLE is set to 0.127000 on instance tb_pll_wrapper._pll_wrapper._PLLE2_BASE.plle2_adv_1.clkout_duty_chk and is not in the allowed range 0.189873 to 0.816456.
        .CLKOUT5_DUTY_CYCLE(0.238), // 10 / 42  = 0.238
        
        // D = 25
        .DIVCLK_DIVIDE(25),
        
        .CLKOUT0_PHASE(0.0),
        .CLKOUT1_PHASE(0.0),
        .CLKOUT2_PHASE(0.0),
        .CLKOUT3_PHASE(0.0),
        .CLKOUT4_PHASE(0.0),
        .CLKOUT5_PHASE(0.0),

        .REF_JITTER1(0.0),
        .BANDWIDTH("OPTIMIZED"),
        .CLKFBOUT_PHASE(0.0),
        .STARTUP_WAIT("FALSE")
    ) _PLLE2_BASE (
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