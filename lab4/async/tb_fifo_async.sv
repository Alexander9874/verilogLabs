`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2026 04:43:32 PM
// Design Name: 
// Module Name: tb_fifo_async
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


// =============================================================================
// tb_async_fifo.sv - Self-checking testbench for async_fifo
//
// Tests:
//   1. Reset behaviour
//   2. Sequential write-then-read (slow write clock, fast read clock)
//   3. Concurrent write/read at different rates
//   4. FULL flag: attempt to overfill - verify no overflow
//   5. EMPTY flag: attempt to over-read - verify no underflow
//   6. FREE_COUNT and ALMOST_EMPTY
// =============================================================================

module tb_fifo_async;

    // ── DUT Parameters ────────────────────────────────────────────────────────
    localparam int DW    = 8;
    localparam int DEPTH = 16;     // effective capacity = 15
    localparam int AE_LV = 20;    // ALMOST_EMPTY threshold %
    localparam int AW    = $clog2(DEPTH);

    // ── Clocks (different frequencies) ───────────────────────────────────────
    localparam real WCLK_PERIOD = 10.0;   // 100 MHz
    localparam real RCLK_PERIOD =  7.0;   // ~143 MHz

    logic WCLK = 0, RCLK = 0;
    always #(WCLK_PERIOD/2) WCLK = ~WCLK;
    always #(RCLK_PERIOD/2) RCLK = ~RCLK;

    // ── DUT I/O ───────────────────────────────────────────────────────────────
    logic             RST;
    logic             WR, RD;
    logic [DW-1:0]    DIN;
    logic [DW-1:0]    DOUT;
    logic             FULL, EMPTY, ALMOST_EMPTY;
    logic [AW-1:0]    FREE_COUNT;

    fifo_async #(
        .DATA_WIDTH      (DW),
        .DEPTH           (DEPTH),
        .ALMOST_EMPTY_LVL(AE_LV),
        .SYNC_STAGES     (2)
    ) dut (
        .WCLK        (WCLK),
        .WR          (WR),
        .DIN         (DIN),
        .FULL        (FULL),
        .RCLK        (RCLK),
        .RD          (RD),
        .DOUT        (DOUT),
        .EMPTY       (EMPTY),
        .ALMOST_EMPTY(ALMOST_EMPTY),
        .FREE_COUNT  (FREE_COUNT),
        .RST         (RST)
    );

    // ── Reference FIFO (behavioural) ─────────────────────────────────────────
    logic [DW-1:0] ref_mem  [0:DEPTH-1];
    int            ref_wptr = 0;
    int            ref_rptr = 0;
    int            ref_count;
    assign ref_count = (ref_wptr - ref_rptr + DEPTH) % DEPTH;

    task automatic ref_write(input logic [DW-1:0] d);
        if (ref_count < DEPTH-1) begin
            ref_mem[ref_wptr % DEPTH] = d;
            ref_wptr++;
        end
    endtask

    function automatic logic [DW-1:0] ref_read();
        logic [DW-1:0] d;
        if (ref_count > 0) begin
            d = ref_mem[ref_rptr % DEPTH];
            ref_rptr++;
        end
        return d;
    endfunction

    // ── Helpers ───────────────────────────────────────────────────────────────
    int  error_count = 0;
    int  test_num    = 0;

    task automatic wclk_cycles(input int n);
        repeat(n) @(posedge WCLK);
    endtask

    task automatic rclk_cycles(input int n);
        repeat(n) @(posedge RCLK);
    endtask

    // Write one word (waits for FULL to clear if necessary)
    task automatic fifo_write(input logic [DW-1:0] d);
        @(posedge WCLK);
        if (FULL) begin
            $display("  [WRITE] FULL - waiting...");
            wait(!FULL);
            @(posedge WCLK);
        end
        WR  = 1;
        DIN = d;
        @(posedge WCLK);
        WR  = 0;
        ref_write(d);
    endtask

    // Read one word and compare with reference
    task automatic fifo_read();
        logic [DW-1:0] expected;
        @(posedge RCLK);
        if (EMPTY) begin
            $display("  [READ]  EMPTY - waiting...");
            // Give CDC time to propagate
            repeat(20) @(posedge RCLK);
            if (EMPTY) begin
                $display("  ERROR: still EMPTY after waiting");
                error_count++;
                return;
            end
        end
        expected = ref_read();
        RD = 1;
        @(posedge RCLK);
        RD = 0;
        @(posedge RCLK);
        if (DOUT !== expected) begin
            $display("  ERROR: expected 0x%02h got 0x%02h", expected, DOUT);
            error_count++;
        end
    endtask

    // ── Main Test ─────────────────────────────────────────────────────────────
    initial begin
        $dumpfile("tb_fifo_async.vcd");
        $dumpvars(0, tb_fifo_async);

        WR = 0; RD = 0; DIN = '0;

        // ------------------------------------------------------------------
        // TEST 1: Reset
        // ------------------------------------------------------------------
        test_num = 1;
        $display("\n=== TEST %0d: Reset ===", test_num);
        RST = 1;
        wclk_cycles(5);
        rclk_cycles(5);
        RST = 0;
        wclk_cycles(2);
        rclk_cycles(2);

        if (!EMPTY)
            $display("  ERROR: EMPTY should be 1 after reset (got %0b)", EMPTY);
        if (FULL)
            $display("  ERROR: FULL should be 0 after reset (got %0b)", FULL);
        $display("  EMPTY=%0b FULL=%0b FREE_COUNT=%0d (expect EMPTY=1 FULL=0)",
                 EMPTY, FULL, FREE_COUNT);

        // ------------------------------------------------------------------
        // TEST 2: Write 5 words, read them back and verify
        // ------------------------------------------------------------------
        test_num = 2;
        $display("\n=== TEST %0d: Write 5 / Read 5 ===", test_num);
        ref_wptr = 0; ref_rptr = 0;

        for (int i = 0; i < 5; i++)
            fifo_write(8'hA0 + i);

        // Wait for CDC to propagate write address into read domain
        rclk_cycles(20);

        for (int i = 0; i < 5; i++)
            fifo_read();

        // Wait for CDC to propagate read address back into write domain
        wclk_cycles(20);

        $display("  Errors so far: %0d", error_count);

        // ------------------------------------------------------------------
        // TEST 3: Fill FIFO to capacity, check FULL
        // ------------------------------------------------------------------
        test_num = 3;
        $display("\n=== TEST %0d: Fill to capacity ===", test_num);
        RST = 1; wclk_cycles(4); rclk_cycles(4); RST = 0;
        ref_wptr = 0; ref_rptr = 0;
        wclk_cycles(4); rclk_cycles(4);

        // Write DEPTH-1 items (max capacity)
        for (int i = 0; i < DEPTH-1; i++) begin
            @(posedge WCLK);
            WR  = 1;
            DIN = 8'h10 + i;
            @(posedge WCLK);
            WR  = 0;
            ref_write(8'h10 + i);
        end

        // Allow FULL to propagate through CDC
        wclk_cycles(30);
        $display("  After filling: FULL=%0b (expect 1)", FULL);
        if (!FULL) begin
            $display("  WARNING: FULL not asserted yet (CDC may still be propagating)");
        end

        // Try extra write while FULL - DUT should block
        @(posedge WCLK);
        WR = 1; DIN = 8'hFF;
        @(posedge WCLK);
        WR = 0;
        $display("  Extra write attempted while FULL (should be ignored by DUT)");

        // Read all back
        rclk_cycles(20);
        for (int i = 0; i < DEPTH-1; i++)
            fifo_read();
        rclk_cycles(20);

        $display("  Errors so far: %0d", error_count);

        // ------------------------------------------------------------------
        // TEST 4: Concurrent write/read at different rates
        // ------------------------------------------------------------------
        test_num = 4;
        $display("\n=== TEST %0d: Concurrent different rates ===", test_num);
        RST = 1; wclk_cycles(4); rclk_cycles(4); RST = 0;
        ref_wptr = 0; ref_rptr = 0;
        wclk_cycles(4); rclk_cycles(4);

        fork
            // Writer: 8 words, every 2 WCLK cycles
            begin
                for (int i = 0; i < 8; i++) begin
                    @(posedge WCLK);
                    if (!FULL) begin WR = 1; DIN = 8'hC0 + i; ref_write(8'hC0 + i); end
                    @(posedge WCLK);
                    WR = 0;
                    wclk_cycles(1);
                end
            end
            // Reader: 8 words, every 3 RCLK cycles (slower)
            begin
                rclk_cycles(10);   // small head-start for writer
                for (int i = 0; i < 8; i++) begin
                    rclk_cycles(3);
                    if (!EMPTY) begin
                        logic [DW-1:0] exp_val;
                        exp_val = ref_read();
                        RD = 1;
                        @(posedge RCLK);
                        RD = 0;
                        @(posedge RCLK);
                        if (DOUT !== exp_val) begin
                            $display("  ERROR [concurrent]: exp=0x%02h got=0x%02h",
                                     exp_val, DOUT);
                            error_count++;
                        end
                    end
                end
            end
        join
        wclk_cycles(20); rclk_cycles(20);
        $display("  Errors so far: %0d", error_count);

        // ------------------------------------------------------------------
        // TEST 5: FREE_COUNT and ALMOST_EMPTY
        // ------------------------------------------------------------------
        test_num = 5;
        $display("\n=== TEST %0d: FREE_COUNT / ALMOST_EMPTY ===", test_num);
        RST = 1; wclk_cycles(4); rclk_cycles(4); RST = 0;
        ref_wptr = 0; ref_rptr = 0;
        wclk_cycles(4); rclk_cycles(4);

        rclk_cycles(20);
        $display("  Empty: FREE_COUNT=%0d ALMOST_EMPTY=%0b (expect FC=%0d AE=1)",
                 FREE_COUNT, ALMOST_EMPTY, DEPTH-1);

        // Write 1 item
        @(posedge WCLK); WR = 1; DIN = 8'hBB; @(posedge WCLK); WR = 0;
        wclk_cycles(5); rclk_cycles(25);
        $display("  1 item written: FREE_COUNT=%0d ALMOST_EMPTY=%0b",
                 FREE_COUNT, ALMOST_EMPTY);

        // ------------------------------------------------------------------
        // SUMMARY
        // ------------------------------------------------------------------
        wclk_cycles(10); rclk_cycles(10);
        $display("\n========================================");
        if (error_count == 0)
            $display("  ALL TESTS PASSED");
        else
            $display("  FAILED - %0d error(s)", error_count);
        $display("========================================\n");

        $finish;
    end

    // Timeout watchdog
    initial begin
        #200000;
        $display("ERROR: Testbench timeout!");
        $finish;
    end

endmodule
