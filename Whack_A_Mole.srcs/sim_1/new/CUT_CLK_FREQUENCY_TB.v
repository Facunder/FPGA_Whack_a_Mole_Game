`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/30 23:54:36
// Design Name: 
// Module Name: CUT_CLK_FREQUENCY_TB
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


module CUT_CLK_FREQUENCY_TB(

    );
    reg Clk;
    wire Vga_Clk;
    wire [1:0] Seg_Clk;
    CUT_CLK_FREQUENCY UTB(
    //crystal - 100MHz
        Clk,
    //VGAœÒÀÿ…®√Ë∆µ¬  ±÷”
        Vga_Clk,
    //∆ﬂ∂Œ¬Î∂ØÃ¨…®√Ë∆µ¬ 
        Seg_Clk
    );
    initial begin
        Clk = 0;
        forever begin
            #5
            Clk = ~Clk;
        end
    end
endmodule
