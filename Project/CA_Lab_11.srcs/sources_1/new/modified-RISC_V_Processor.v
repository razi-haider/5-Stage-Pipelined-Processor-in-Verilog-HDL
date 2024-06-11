
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2023 12:27:32 PM
// Design Name: 
// Module Name: modified-RISC_V_Processor
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


`timescale 1ns / 1ps

module modified_RISC_V_Processor(clk, reset, ALUOp, PC_in, PC_out, Instruction, ImmediateData, rd, rs1, rs2, ReadData1, ReadData2, Data_Mem_ReadData, mux_out, WriteData, result);

input clk;
input reset;

// Variable for Mux
output wire [63:0] WriteData;

// Variable for Immediate Generator
output wire [63:0] ImmediateData;        

wire [6:0] opcode;


                                    // Program Counter Instantiation
// Variables for Program Counter                         
output wire [63:0] PC_in, PC_out;
// Program Counter
Program_Counter PC(clk, reset, PC_in, PC_out);

// Adder 1
// Calling the Adder which adds 4 Immediate to the Program Counter
wire imm_four = 64'd4;
wire [63:0] adder_one_output;
Adder Add1(PC_out, imm_four, adder_one_output);


                                    // Adder 1 and Adder 2 Instantiation
// Variables for Adder 1 and Adder 2

wire [63:0] adder_two_output;

                                    // Instruction Memory Instantiation
// Variable for Instruction Memory Block
output wire [31:0] Instruction;
// Instruction Memory Unit
Instruction_Memory iMMi
(
PC_out, Instruction
);                                

                                    // Instruction Parser Instantiation
// Variables for Instruction Parser                                
output wire [4:0] rd;
wire [2:0] funct3;
output wire [4:0] rs1;
output wire [4:0] rs2;
wire [6:0] funct7;
// Instruction Parser Block
InsParser IP(Instruction, opcode, rd, funct3, rs1, rs2, funct7);


                                    // Control Unit Instantiation
// Variables for Control Unit
wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
output wire [1:0] ALUOp;
// Control Unit
Control_Unit CU(opcode, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp);

                                    // Registers Instantiation 
// Variables for Register        
output wire [63:0] ReadData1;
output wire [63:0] ReadData2;
// Registers Block                        
RegisterFile RG(WriteData, rs1, rs2, rd, RegWrite, clk, reset, ReadData1, ReadData2);                           

                                    // Immediate Generator Instantiation
// Immediate Generator Data Block                        
ImmGen IG(Instruction, ImmediateData);

                                    // ALU Control Instantiation
// Variable for ALU Control
wire [3:0] Operation;                           
// ALU Control                       
ALU_Control ALUC(ALUOp, {Instruction[30], Instruction[14:12]}, Operation);

                                    // Mux for Register Instatiation
// Variable for Mux
output wire [63:0] mux_out; 
// Register Multiplexer Block                                 
Mux RegMux(ReadData2, ImmediateData, ALUSrc, mux_out);        

                                    // Main ALU Instantiation
// Variables for ALU
output wire [63:0] result;
wire zero;

                                    // AND Gate Control Unit
assign and_result = Branch & zero;

// Arithmetic Logic Unit Block
ALU_64_bit alu(ReadData1, mux_out, Operation, result, zero);

                                    // Data Memory Instantiation
// Variable for Data Memory
output wire [63:0] Data_Mem_ReadData; 
// Data Memory Block                               
Data_Memory DataMem(result, ReadData2, clk, MemWrite, MemRead, Data_Mem_ReadData);

                                    // Multiplexer for Data Memory 
// Data Memory Multiplexer Block                                
Mux DataMemMux(result, Data_Mem_ReadData, MemtoReg, WriteData);

// Adder 2 --> which adds the Immediate value to the Program Counter
Adder Add2(PC_out, (ImmediateData << 1), adder_two_output);

                                    // Mux Instantiation for Adders
Mux MUX1(adder_one_output, adder_two_output, and_result, PC_in);





                                


            
           
                                    
          







endmodule