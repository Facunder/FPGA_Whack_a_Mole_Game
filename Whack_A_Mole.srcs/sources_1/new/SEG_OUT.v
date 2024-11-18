`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/18 09:48:05
// Design Name: 
// Module Name: SEG_OUT
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

module SEG_OUT(
    input [1:0] Clk,    //equal Seg_clk
    input [7:0] Score_nums,
    //input [1:0] level_nums,
    output [6:0] Seg,
    output [3:0] Seg_sel
    );
    wire [3:0] Score_num0, Score_num1, Score_num2, Score_num3;
    
    assign Score_num3 = Score_nums / 1000;
    assign Score_num2 = (Score_nums - Score_num3 * 1000) / 100;
    assign Score_num1 = (Score_nums - Score_num3 * 1000 - Score_num2 * 100) / 10;
    assign Score_num0 = Score_nums - Score_num3 * 1000 - Score_num2 * 100 - Score_num1 * 10;
    
    FOUR_NUMBER_SEG_OUT   Uinstance6_1(
                            .Clk(Clk),
                            .Num0(Score_num0),
                            .Num1(Score_num1),
                            .Num2(Score_num2),
                            .Num3(Score_num3),
                            .Seg(Seg),
                            .Seg_sel(Seg_sel)
                            );
endmodule
