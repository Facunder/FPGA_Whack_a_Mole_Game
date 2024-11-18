`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/04 16:49:38
// Design Name: 
// Module Name: FOUR_NUMBER_SEG_OUT
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

module FOUR_NUMBER_SEG_OUT(
    input [1:0] Clk,
    input [3:0] Num0,
    input [3:0] Num1,
    input [3:0] Num2,
    input [3:0] Num3,
    output [6:0] Seg,
    output [3:0] Seg_sel
    );
    wire [3:0] Num_in;
    reg [3:0] Num_in_reg;
    reg [3:0] Seg_sel_reg;
    //sel signal chosen by 4bit flowing clock
    always@(Clk)begin
        case(Clk)
            2'b00 : begin
                        Num_in_reg <= Num0;
                        Seg_sel_reg <= 4'b1110;
                    end
            2'b01 : begin
                        Num_in_reg <= Num1;
                        Seg_sel_reg <= 4'b1101;
                    end
            2'b10 : begin
                        Num_in_reg <= Num2;
                        Seg_sel_reg <= 4'b1011;
                    end
            2'b11 : begin
                        Num_in_reg <= Num3;
                        Seg_sel_reg <= 4'b0111;
                    end
        endcase
    end
    assign Seg_sel = Seg_sel_reg;
    assign Num_in = Num_in_reg;
    //Num to Seg by combinational logic
    SINGLE_NUM_SEG_OUT Uinstance6_1_1(
                                   .Num(Num_in),
                                   .Seg(Seg)
                                   );
endmodule
