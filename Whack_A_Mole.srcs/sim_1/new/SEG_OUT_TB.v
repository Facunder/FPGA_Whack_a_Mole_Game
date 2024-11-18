`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/18 09:48:26
// Design Name: 
// Module Name: SEG_OUT_TB
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


module SEG_OUT_TB(

    );
    reg [1:0] Clk;
    reg [7:0] Score_nums;
    wire [6:0] Seg;
    wire [3:0] Seg_sel;
    SEG_OUT UTB1 (
                    .Clk(Clk),
                    .Score_nums(Score_nums),
                    .Seg(Seg),
                    .Seg_sel(Seg_sel)
                );
    initial begin
        Clk = 2'b00;
        forever begin
            #5
            Clk = Clk + 1;
        end
    end
    initial begin
        Score_nums = 8'd113;
        #33
        Score_nums = 8'd43;
        #33
        Score_nums = 8'd22;
        #22
        Score_nums = 8'd8;
    end
endmodule
