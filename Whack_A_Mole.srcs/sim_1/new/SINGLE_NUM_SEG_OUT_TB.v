`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/30 14:47:51
// Design Name: 
// Module Name: SINGLE_NUM_SEG_OUT_TB
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


module SINGLE_NUM_SEG_OUT_TB(

    );
    reg [3:0] Num;
    wire [6:0] Seg;
    
SINGLE_NUM_SEG_OUT UTB(
    Num,    //input decimmalism num
    Seg    //7 Seg out -low_enable
    );
    initial begin
        Num = 4'd0;
        #10
        Num = 4'd1;
        #10
        Num = 4'd2;
        #10
        Num = 4'd3;
        #10
        Num = 4'd4;
        #10
        Num = 4'd5;
        #10
        Num = 4'd6;
        #10
        Num = 4'd7;
        #10
        Num = 4'd8;
        #10
        Num = 4'd9;
        #10
        Num = 4'd10;
        #10
        Num = 4'd11;
    end
endmodule
