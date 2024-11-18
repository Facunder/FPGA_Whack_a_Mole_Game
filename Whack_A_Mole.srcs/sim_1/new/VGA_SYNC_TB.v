`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/30 14:04:26
// Design Name: 
// Module Name: VGA_SYNC_TB
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


module VGA_SYNC_TB(

    );
    reg Clk; 
    wire Hsync; 
    wire Vsync; 
    wire Dat_act; 
    wire [9:0] Hcount; 
    wire [9:0] Vcount; 
  VGA_SYNC UTB(
    Clk, 
    Hsync,
    Vsync,
    Dat_act,
    Hcount,
    Vcount
);
initial begin
    Clk = 0;
    forever begin
        #5
        Clk = ~Clk;
    end
end
endmodule
