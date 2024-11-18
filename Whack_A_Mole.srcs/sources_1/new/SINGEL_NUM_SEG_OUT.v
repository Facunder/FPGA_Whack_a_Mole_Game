`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/04 19:33:39
// Design Name: 
// Module Name: SINGEL_NUM_SEG_OUT
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


module SINGEL_NUM_SEG_OUT(
    input [3:0] Num,    //input decimmalism num
    output reg [6:0] Seg    //7 Seg out -low_enable
    );
    always @(Num)begin
        case(Num)
            4'h0: Seg <= 7'b1000000;
            4'h1: Seg <= 7'b1111001;
            4'h2: Seg <= 7'b0100100;
            4'h3: Seg <= 7'b0110000;
            4'h4: Seg <= 7'b0011001;
            4'h5: Seg <= 7'b0010010;
            4'h6: Seg <= 7'b0000010;
            4'h7: Seg <= 7'b1111000;
            4'h8: Seg <= 7'b0000000;
            4'h9: Seg <= 7'b0010000;
            default: Seg <= 7'b0111111; //if error display "-"
        endcase
    end
endmodule
