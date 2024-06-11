`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2023 12:22:04 PM
// Design Name: 
// Module Name: tb_task2
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


module tb_task2();
reg reset, clk;
wire [63:0] PC_in;
wire [63:0] PC_out;
wire [31:0] Instruction;
wire [4:0] rs1; 
wire [4:0] rs2; 
wire [4:0] rd;
wire [63:0] WriteData;
wire [63:0] ReadData1;
wire [63:0] ReadData2;
wire [63:0] ImmediateData;
wire [63:0] result;
wire [63:0] Data_Mem_Read_Data;
wire [1:0] ALUOp;

modified_RISC_V_Processor mod(clk, reset, ALUOp, PC_in, PC_out, Instruction, ImmediateData, rd, rs1, rs2, ReadData1, ReadData2, Data_Mem_ReadData, mux_out, WriteData, result);
    
initial begin
    clk = 0; reset = 0;
    #10 reset = 0;
    #10 reset = 1;
    #10 reset = 0;
    #120 reset = 1;
    #10 reset = 1;
    #10 reset = 0;

end

always
    #10 clk = ~clk;    

endmodule
