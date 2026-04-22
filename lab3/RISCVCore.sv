`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2026 11:36:02 PM
// Design Name: 
// Module Name: RISCVCore
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


module RISCVCore(
    input logic Reset,
    input logic CLK
    );
    
    // Control
    logic [3:0]ALUControl;
    logic PCLoad;
    logic PCCountEnable;
    logic ResultSrc;
    logic MemWrite;
    logic ALUSrc;
    logic RegWrite;
    logic [1:0] ImmSrc;
    
    
    logic [31:0] SrcA;
    logic [31:0] SrcB;
    logic [31:0] ALUResult;
    logic        Zero;
    
    logic [31:0] Instr;
    logic [31:0] Result;
    logic [31:0] WriteData;
    
    logic [31:0] PC;
    logic [31:0] PCTarget;
    
    logic [31:0] ImmExt;
    
    logic [31:0] ReadData;
    
    ALU _alu (
        .OPCODE (ALUControl),
        .A      (SrcA),
        .B      (SrcB),
        .R      (ALUResult),
        .ZF     (Zero)
        );

    RegMem _regmem (
        .CLOCK(CLK),
        .WRITE(RegWrite),
        .WRITE_ADRESS(Instr[11:7]),
        .ADRESS0(Instr[19:15]),
        .ADRESS1(Instr[24:20]),
        .DATA_IN(Result),
        .DATA_OUT0(SrcA),
        .DATA_OUT1(WriteData)
        );
    
    Counter _counter (
        .CLOCK(CLK),
        .RESET(Reset),
        .LOAD(PCLoad),
        .COUNT_ENABLE(PCCountEnable),
        .DATA_IN(PCTarget),
        .DATA_OUT(PC)
        );

    ISEU _iseu (
        .iseu_input(Instr[31:7]),
        .iseu_fmt(ImmSrc),
        .iseu_output(ImmExt)
        );
        
//    InstMem _instmem (
//        .clka(~CLK),
//        .addra(PC),
//        .douta(Instr)
//        );
    
//    DataMem _datamem (
//        .clka(~CLK),
//        .addra(ALUResult),
//        .dina(WriteData),
//        .douta(ReadData),
//        .wea({4{MemWrite}})
//        );

    InstructionMemory _instmem(
        .address(PC),
        .data_out(Instr)
        );
        
    DataMemory _datamem(
        .clk(CLK),
        .write_enable(MemWrite),
        .write_data(WriteData),
        .address(ALUResult),
        .data_out(ReadData)
        );
        
    ControlUnit _controlunit(
        .opcode(Instr[6:0]),
        .funct3(Instr[14:12]),
        .funct7_5(Instr[30]),
        .zero(Zero),
        
        .PCCountEnable(PCCountEnable),
        .PCLoad(PCLoad),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite)
        );

    always_comb begin
        SrcB <= ALUSrc ? ImmExt : WriteData;
        Result <= ResultSrc ? ReadData : ALUResult;
        PCTarget <= ImmExt + PC;
    end
        
endmodule
