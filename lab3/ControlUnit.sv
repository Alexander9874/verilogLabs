`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2026 04:45:30 PM
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(
    input logic  [6:0]  opcode,
    input logic  [2:0]  funct3,
    input logic         funct7_5,
    input logic         zero,
    
    output logic        PCCountEnable,
    output logic        PCLoad,
    output logic        ResultSrc,
    output logic        MemWrite,
    output logic [3:0]  ALUControl,
    output logic        ALUSrc,
    output logic [1:0]  ImmSrc,
    output logic        RegWrite
    );

    always_comb begin
        unique case(opcode)
            
            // FMT R (ALU)
            7'b0110011: begin
                PCCountEnable = 1'b1;
                PCLoad        = 1'b0;
                ResultSrc     = 1'b0;
                MemWrite      = 1'b0;
                ALUControl    = {funct7_5, funct3};
                ALUSrc        = 1'b0;
                //ImmSrc      = 2'bxx;
                RegWrite      = 1'b1;
            end
            
            // FMT I (IMM ALU)
            7'b0010011: begin
                PCCountEnable = 1'b1;
                PCLoad        = 1'b0;
                ResultSrc     = 1'b0;
                MemWrite      = 1'b0;
                ALUControl    = {funct3 == 3'b101 ? funct7_5 : 0, funct3};
                ALUSrc        = 1'b1;
                ImmSrc        = 2'b00;
                RegWrite      = 1'b1;
            end
            
            // FMT I (IMM LOAD)
            7'b0000011: begin
                // LW load 32 only
                // funct3 - any
                PCCountEnable = 1'b1;
                PCLoad        = 1'b0;
                ResultSrc     = 1'b1;
                MemWrite      = 1'b0;
                ALUControl    = 4'b0000;
                ALUSrc        = 1'b1;
                ImmSrc        = 2'b00;
                RegWrite      = 1'b1;
            end
            
            // FMT S (STORE DATA)
            7'b0100011: begin
                // SW store 32 only
                // funct3 - any
                PCCountEnable = 1'b1;
                PCLoad        = 1'b0;
                // ResultSrc     = 1'bx;
                MemWrite      = 1'b1;
                ALUControl    = 4'b0000;
                ALUSrc        = 1'b1;
                ImmSrc        = 2'b01;
                RegWrite      = 1'b0;
            end  
            
            // FMT B (BRANCH)          
            7'b1100011: begin
                // ResultSrc     = 1'bx;
                MemWrite      = 1'b0;
                ALUSrc        = 1'b0;
                ImmSrc        = 2'b10;
                RegWrite      = 1'b0;
            
            
                PCCountEnable = 1'b1;
                PCLoad        = 1'b0;            
                
                
                unique casex(funct3)
                    // BEQ
                    3'b000: begin
                        ALUControl    = 4'b1000;
                        PCCountEnable = ~zero;
                        PCLoad        = zero;
                    end
                                        
                    // BNE
                    3'b001: begin
                        ALUControl    = 4'b1000;
                        PCCountEnable = zero;
                        PCLoad        = ~zero;
                    end
                                        
                    // BLT
                    3'b100: begin
                        ALUControl    = 4'b0010;
                        PCCountEnable = zero;
                        PCLoad        = ~zero;
                    end
                    
                    // BGE
                    3'b101: begin
                        ALUControl    = 4'b0010;
                        PCCountEnable = ~zero;
                        PCLoad        = zero;
                    end
                                        
                    // BLTU
                    3'b110: begin
                        ALUControl    = 4'b0011;
                        PCCountEnable = zero;
                        PCLoad        = ~zero;
                    end
                    
                    // BGEU
                    3'b111: begin
                        ALUControl    = 4'b0011;
                        PCCountEnable = ~zero;
                        PCLoad        = zero;
                    end
                    
                    default: begin
                        // ALUControl    = 4'bxxxx;
                        PCCountEnable = 1'b1;
                        PCLoad        = 1'b0;
                    end
                
                endcase
            end    
            
//            // FMT J (JUMP)          
//            7'b1101111: begin
//            end 
            
            // FMT ?
            default: begin
            end         
        endcase 
    end
    
endmodule
