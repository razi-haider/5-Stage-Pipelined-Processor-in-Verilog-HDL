`timescale 1ns / 1ps

module RISC_V_Processor(clk, reset);

input clk;
input reset;

                                    // Control Unit Instantiation
// Variables for Control Unit
wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
wire [1:0] ALUOp;
// Control Unit
Control_Unit CU(opcode, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp);

                                    // AND Gate Control Unit
assign and_result = Branch & zero;


                                    // Program Counter Instantiation
// Variables for Program Counter                         
wire [63:0] PC_in, PC_out;
// Program Counter
Program_Counter PC(clk, reset, PC_in, PC_out);


                                    // Adder 1 and Adder 2 Instantiation
// Variables for Adder 1 and Adder 2
wire imm_four = 64'b100;
wire [63:0] adder_one_output;
wire [63:0] adder_two_output;
// Adder 1
// Calling the Adder which adds 4 Immediate to the Program Counter
Adder Add1(PC_out, imm_four, adder_one_output);

// Adder 2 --> which adds the Immediate value to the Program Counter
Adder Add2(PC_out, ImmediateData << 1, adder_two_output);


                                    // Mux Instantiation for Adders
Mux MUX1(adder_one_output, adder_two_output, and_result, PC_in);


                                    // Instruction Memory Instantiation
// Variable for Instruction Memory Block
wire [31:0] Instruction;
// Instruction Memory Unit
Instruction_Memory iMMi
(
PC_out, Instruction
);                                


                                    // Immediate Generator Instantiation
// Variable for Immediate Generator
wire [63:0] ImmediateData;        
// Immediate Generator Data Block                        
ImmGen IG(Instruction, ImmediateData);

                                
                                    // Instruction Parser Instantiation
// Variables for Instruction Parser                                
wire [6:0] opcode;
wire [4:0] rd;
wire [2:0] funct3;
wire [4:0] rs1;
wire [4:0] rs2;
wire [6:0] funct7;
// Instruction Parser Block
InsParser IP(Instruction, opcode, rd, funct3, rs1, rs2, funct7);


                                    // Registers Instantiation 
// Variables for Register        
wire [63:0] ReadData1;
wire [63:0] ReadData2;
// Registers Block                        
RegisterFile RG(WriteData, rs1, rs2, rd, RegWrite, clk, reset, ReadData1, ReadData2);                           
            
           
                                    // Mux for Register Instatiation
// Variable for Mux
wire [63:0] mux_out; 
// Register Multiplexer Block                                 
Mux RegMux(ReadData2, ImmediateData, ALUSrc, mux_out);        
                                    
          
                                    // ALU Control Instantiation
// Variable for ALU Control
wire [3:0] Operation;                           
// ALU Control                       
ALU_Control ALUC(ALUOp, Instruction, Operation);


                                    // Main ALU Instantiation
// Variables for ALU
wire [63:0] result;
wire zero;
// Arithmetic Logic Unit Block
ALU_64_bit alu(ReadData1, mux_out, Operation, result, zero);


                                    // Data Memory Instantiation
// Variable for Data Memory
wire [63:0] ReadData; 
// Data Memory Block                               
Data_Memory DataMem(result, ReadData2, clk, MemWrite, MemRead, ReadData);


                                    // Multiplexer for Data Memory 
// Variable for Mux
wire [63:0] WriteData;
// Data Memory Multiplexer Block                                
Mux DataMemMux(result, ReadData, MemtoReg, WriteData);

endmodule