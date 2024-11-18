`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/30 14:22:01
// Design Name: 
// Module Name: FOUR_NUMBER_SEG_OUT_TB
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


module FOUR_NUMBER_SEG_OUT_TB(

    );
    reg [1:0] Clk;
    reg [3:0] Num0;
    reg [3:0] Num1;
    reg [3:0] Num2;
    reg [3:0] Num3;
    wire [6:0] Seg;
    wire [3:0] Seg_sel;

    FOUR_NUMBER_SEG_OUT UTB(
    Clk,
    Num0,
    Num1,
    Num2,
    Num3,
    Seg,
    Seg_sel
    );
initial begin
    Clk = 2'b00;
    forever begin
        #5 
        Clk <= Clk + 1;
    end
end
initial begin
    Num0 = 4'd5;
    Num1 = 4'd6;
    Num2 = 4'd7;
    Num3 = 4'd8;
end
endmodule
