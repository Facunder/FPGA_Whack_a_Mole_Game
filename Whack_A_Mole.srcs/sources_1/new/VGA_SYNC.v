`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/08 10:13:57
// Design Name: 
// Module Name: VGA_SYNC
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


module VGA_SYNC(
    input Clk, //VGA system input 25MHz scaning clock
    output Hsync, //VGA V-align signal
    output Vsync, //VGA  H-align signal
    output Dat_act, //can display data
    output reg [9:0] Hcount = 0, //VGA V coutner
    output reg [9:0] Vcount = 0 //VGA H counter
);
    wire Hcount_ov;
    wire Vcount_ov;
    //VGA H\V parameters list
    parameter Hsync_end = 10'd95,//start align pulse
    Hdat_begin = 10'd143,//H disp begin
    Hdat_end = 10'd783,//H disp end
    Hpixel_end = 10'd799,
    Vsync_end = 10'd1,
    Vdat_begin = 10'd34,//view
    Vdat_end = 10'd514,//view
    Vline_end = 10'd524;
//************************sync scan*******************************
    //Vertical align
    always @(posedge Clk) begin
        if (Hcount_ov)
            Hcount <= 10'd0;
        else
            Hcount <= Hcount + 10'd1;
        end
    assign Hcount_ov = (Hcount == Hpixel_end);
    //Horizontal align
    always @(posedge Clk) begin
        if (Hcount_ov) begin
            if (Vcount_ov)
                Vcount <= 10'd0;
            else
                Vcount <= Vcount + 10'd1;
        end
    end
    assign Vcount_ov = (Vcount == Vline_end);

    //Dat_act: if in the showing region
    //Hsync\Vsync£ºdecaide in (through the H/Vsync_end)
    assign Dat_act = ((Hcount >= Hdat_begin) && (Hcount < Hdat_end)) &&
            ((Vcount >= Vdat_begin) && (Vcount < Vdat_end));
    assign Hsync = (Hcount > Hsync_end);
    assign Vsync = (Vcount > Vsync_end);
endmodule
