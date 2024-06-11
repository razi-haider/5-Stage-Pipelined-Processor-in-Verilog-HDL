`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2023 12:05:45 PM
// Design Name: 
// Module Name: tb_RISC_V_Processor
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


module tb_RISC_V_Processor();
reg reset, clk;

RISC_V_Processor Processor(clk, reset);

always
    begin
    #10
        clk = ~clk;    
    end
    
initial begin
    clk = 0; reset = 0;
    #10 reset = 0;
    #10 reset = 0;
    #10 reset = 0;
    #10 reset = 0;
    #10 reset = 0;
    #10 reset = 0;
    #10 reset = 1;
    #10 reset = 0;

end
endmodule
