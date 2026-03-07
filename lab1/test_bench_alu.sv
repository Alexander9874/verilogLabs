`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2026 04:15:13 PM
// Design Name: 
// Module Name: TB_ALU
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

module TB_ALU;
    localparam WIDTH = 8;

    const logic [3:0] opcode_array [9:0] = '{4'b0000, 4'b1000,
                                             4'b0100, 4'b0110,
                                             4'b0111, 4'b0001,
                                             4'b0101, 4'b1101,
                                             4'b0010, 4'b0011};
    logic [WIDTH-1:0] A;
    logic [WIDTH-1:0] B;
    logic [WIDTH-1:0] R;
    logic [WIDTH-1:0] OPCODE;
    logic ZF;
    
    ALU #(.WIDTH(WIDTH)) DUT (
        .OPCODE(OPCODE),
        .A(A),
        .B(B),
        .R(R),
        .ZF(ZF)
    );
    
    initial begin
        $display("ALU TEST BEGIN: WIDTH = %0d", WIDTH);
        for(int i = 0; i < 10; i++) begin
            OPCODE = opcode_array[i];
            for(int j = 0; j < 2**(WIDTH) - 1; j++) begin
                for(int k = 0; k < 2**(WIDTH) - 1; k++) begin
                    A <= j;
                    B <= k;
                    #10;
                    unique case (OPCODE)
                        4'b0000:
                            assert ($signed(R) == ($signed(A) + $signed(B)))
                            else $error("\tOPCODE = %b (ADD)\tA = %b\tB = %b\tR = %b (%b)\n", OPCODE, A, B, R, $signed(A) + $signed(B));
                        4'b1000:
                            assert ($signed(R) == ($signed(A) - $signed(B)))
                            else $error("\tOPCODE = %b (SUB)\tA = %b\tB = %b\tR = %b (%b)\n", OPCODE, A, B, R, $signed(A) - $signed(B));
                        4'b0100:
                            assert (R == (A ^ B))
                            else $error("\tOPCODE = %b (XOR)\tA = %b\tB = %b\tR = %b (%b)\n", OPCODE, A, B, R, A ^ B);
                        4'b0110:
                            assert (R == (A | B))
                            else $error("\tOPCODE = %b (OR)\tA = %b\tB = %b\tR = %b (%b)\n", OPCODE, A, B, R, A | B);
                        4'b0111:
                            assert (R == (A & B))
                            else $error("\tOPCODE = %b (AND)\tA = %b\tB = %b\tR = %b (%b)\n", OPCODE, A, B, R, A & B);
                        4'b0001:
                            assert (R == (A << B))
                            else $error("\tOPCODE = %b (SLL)\tA = %b\tB = %b\tR = %b (%b)\n", OPCODE, A, B, R, A << B);
                        4'b0101:
                            assert (R == (A >> B))
                            else $error("\tOPCODE = %b (SRL)\tA = %b\tB = %b\tR = %b (%b)\n", OPCODE, A, B, R, A >> B);
                        4'b1101:
                            assert ($signed(R) == ($signed(A) >>> B))
                            else $error("\tOPCODE = %b (SRA)\tA = %b\tB = %b\tR = %b (%b)\t\tA[WIDTH] = %b\n", OPCODE, A, B, R, $signed(A) >>> B, OPCODE[3] & A[WIDTH - 1]);
                        4'b0010:
                            assert (R == (($signed(A) < $signed(B)) ? 1 : 0))
                            else $error("\tOPCODE = %b (SLT)\tA = %b\tB = %b\tR = %b (%b)\n", OPCODE, A, B, R, WIDTH'(($signed(A) < $signed(B)) ? 1 : 0));
                        4'b0011:
                            assert (R == ((A < B) ? 1 : 0))
                            else $error("\tOPCODE = %b (SLTU)\tA = %b\tB = %b\tR = %b (%b)\n", OPCODE, A, B, R, WIDTH'((A < B) ? 1 : 0));
                        default:
                            assert (R == 0)
                            else $error("\tOPCODE = %b (NONE)\tA = %b\tB = %b\tR = %b (%b)\n", OPCODE, A, B, R, 0);
                    endcase
                end
            end
        end
        $display("TEST END");
    end
endmodule
