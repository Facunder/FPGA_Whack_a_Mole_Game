`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/26 11:54:54
// Design Name: 
// Module Name: CUT_CLK_FREQUENCY
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


module CUT_CLK_FREQUENCY(
    //crystal - 100MHz
    input Clk,
    //VGA scan freq
    output Vga_Clk,
    //Seg scan freq
    output [1:0] Seg_Clk
    );
    
    reg [27:0] ClkCount = 0; 
    always@(posedge Clk) begin
        ClkCount <= ClkCount + 1;
    end
    
    assign Seg_Clk[0] = ClkCount[18];
    assign Seg_Clk[1] = ClkCount[19];
    assign Vga_Clk = ClkCount [1];  //25MHz
    
endmodule
