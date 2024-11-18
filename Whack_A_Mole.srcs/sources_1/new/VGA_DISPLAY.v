`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/08 15:42:43
// Design Name: 
// Module Name: VGA_DISPLAY
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

//'hole' equals 'gopher'
module VGA_DISPLAY(
    //VGA_SYNC info
    input Clk, //for synchronous circuit
    input Vga_Clk,
    input Dat_act,
    input [9:0] Hcount,
    input [9:0] Vcount,
    //display info
    input Rst_,
    //input [1:0] Level_in,
    input Hole_hold_signal_in,
    input [1:0] Hole_Num_in,    //4 for test
    input Invalid_op,
    input [1:0] Hit_Num,
    output [15:0] Vga_RGB
    );
    
    reg [15:0] Data;
    wire En_background;
    wire En_hole;
    wire En_hammer;
    wire [15:0] Data_background;
    wire [15:0] Data_hole;
    wire [15:0] Data_hammer;
    
    //reg [1:0] Level;
    reg [1:0] Hole_Num;
    reg Hole_hold_signal;
    reg [16:0] Addr_background; //240*400
    reg [11:0] Addr_hole;   //60*60
    reg [11:0] Addr_hammer; //60*60
    reg [9:0] Hole_H_mid, Hole_V_mid;
    //hammer logical position
    reg [9:0] Hammer_H_mid_in;
    reg [9:0] Hammer_V_mid_in;
    //hammer latch frame position
    reg [9:0] Hammer_H_mid;
    reg [9:0] Hammer_V_mid;
  
    
    parameter Hdat_begin = 10'd143, 
              Vdat_begin = 10'd43;
    parameter H_mid = 10'd463, 
              V_mid = 10'd274;      //h&v field centre 
    parameter Background_H = 10'd400,
              Background_V = 10'd240,
              Hole_H = 10'd60,
              Hole_V = 10'd60,
              Hammer_H = 10'd60,
              Hammer_V = 10'd60;
    parameter BLACK   =   16'h0000,   
               WHITE   =   16'hFFFF,
               GRAY= 16'hD69A;
              
    //final screen disp rgb
    assign Vga_RGB = (Dat_act) ? Data : BLACK; 
    
    //each displayed object Enable signal
    assign En_background = (Hcount >= H_mid - Background_H / 2) && (Hcount < H_mid + Background_H / 2) 
                            && (Vcount >= V_mid - Background_V / 2) && (Vcount < V_mid + Background_V / 2);
    assign En_hole = (Hcount >= Hole_H_mid - Hole_H / 2) && (Hcount < Hole_H_mid + Hole_H / 2)
                            && (Vcount >= Hole_V_mid - Hole_V / 2) && (Vcount < Hole_V_mid + Hole_V / 2);    
    assign En_hammer = (Hcount >= Hammer_H_mid - Hammer_H / 2) && (Hcount < Hammer_H_mid + Hammer_H / 2)
                            && (Vcount >= Hammer_V_mid - Hammer_V / 2) && (Vcount < Hammer_V_mid + Hammer_V / 2);    
                                       
     //read picture coe
     PIC_background UIP1(Vga_Clk, Addr_background, Data_background);
     PIC_gopher UIP2(Vga_Clk, Addr_hole, Data_hole);
     PIC_hammer UIP3(Vga_Clk, Addr_hammer, Data_hammer);
     
     //1 frame 12ms, must latch frame input info before display
     always@(posedge Vga_Clk)begin
        //change only before display
        if(Hcount < Hdat_begin && Vcount < Vdat_begin) begin
            //Level <= Level_in;
            Hole_hold_signal <= Hole_hold_signal_in;
            Hole_Num <= Hole_Num_in;
            Hammer_H_mid <= Hammer_H_mid_in;
            Hammer_V_mid <= Hammer_V_mid_in;
        end
        //in display range latch frame
        else begin
            //Level <= Level;
            Hole_hold_signal <= Hole_hold_signal;
            Hole_Num <= Hole_Num;
            Hammer_H_mid <= Hammer_H_mid;
            Hammer_V_mid <= Hammer_V_mid;
        end
     end
     
     //background picRGB addr update
     always@(posedge Vga_Clk)begin
        if(En_background) begin
            if(Addr_background == 17'd95999)
                Addr_background <= 17'd0;
            else
                Addr_background <= Addr_background + 1;
        end
        else
            Addr_background <= Addr_background;    
     end
     
     //hole picRGB addr update
     always@(posedge Vga_Clk)begin
        if(Hole_hold_signal && En_hole)begin
            if(Addr_hole == 12'd3599)
                Addr_hole <= 12'd0;
            else
                Addr_hole <= Addr_hole + 1;
        end
        else
            Addr_hole <= Addr_hole;
     end
      
      //hammer picRGB addr update
      always@(posedge Vga_Clk)begin
        if(En_hammer) begin
            if(Addr_hammer == 12'd3599)
                Addr_hammer <= 12'd0;
            else
                Addr_hammer <= Addr_hammer + 1;
        end
        else
            Addr_hammer <= Addr_hammer;  
      end
      
//     //hammer appear position control
    reg [23 : 0] Hammer_Appear_Count;    //16 * 1000 * 1000 * 10ns=160ms;
    always@(posedge Clk)begin
        if(!Rst_ )begin
            Hammer_H_mid_in <= 10'd463; 
            Hammer_V_mid_in <= 10'd354; 
            Hammer_Appear_Count <= 24'b0;
        end
        else if(!Invalid_op) begin//button pressed
            case(Hit_Num)
                  2'b00 : begin Hammer_H_mid_in <= 10'd363; Hammer_V_mid_in <= 10'd274; Hammer_Appear_Count <= 24'b0; end
                  2'b01 : begin Hammer_H_mid_in <= 10'd463; Hammer_V_mid_in <= 10'd274; Hammer_Appear_Count <= 24'b0; end
                  2'b10 : begin Hammer_H_mid_in <= 10'd563; Hammer_V_mid_in <= 10'd274; Hammer_Appear_Count <= 24'b0; end
                  2'b11 : begin Hammer_H_mid_in <= 10'd463; Hammer_V_mid_in <= 10'd214; Hammer_Appear_Count <= 24'b0; end
            endcase
        end
        else if(Hammer_Appear_Count == 24'b111_111_111_111_111_111_111_111) begin
            Hammer_H_mid_in <= 10'd463; 
            Hammer_V_mid_in <= 10'd354; 
            Hammer_Appear_Count <= Hammer_Appear_Count;
        end
        else begin
            Hammer_H_mid_in <= Hammer_H_mid_in;
            Hammer_V_mid_in <= Hammer_V_mid_in;
            Hammer_Appear_Count <= Hammer_Appear_Count + 1;
        end
    end
   
//     //common method   
//     always@(Rst_ or Hit_Num) begin
//        if(!Rst_) begin 
//            Hammer_H_mid_in <= 10'd463; 
//            Hammer_V_mid_in <= 10'd354; 
//        end
//        else 
//            case(Hit_Num)
//                  2'b00 : begin Hammer_H_mid_in <= 10'd363; Hammer_V_mid_in <= 10'd274; end
//                  2'b01 : begin Hammer_H_mid_in <= 10'd463; Hammer_V_mid_in <= 10'd274; end
//                  2'b10 : begin Hammer_H_mid_in <= 10'd563; Hammer_V_mid_in <= 10'd274; end
//                  2'b11 : begin Hammer_H_mid_in <= 10'd463; Hammer_V_mid_in <= 10'd214; end
//            endcase
//     end
     
     //hole position 
     always@(posedge Vga_Clk)begin
        if(Hole_hold_signal) begin
            case(Hole_Num)
//                3'b000 : begin Hole_H_mid <= 10'd363; Hole_V_mid <= 10'd354; end
//                3'b001 : begin Hole_H_mid <= 10'd563; Hole_V_mid <= 10'd354; end
//                3'b010 : begin Hole_H_mid <= 10'd363; Hole_V_mid <= 10'd274; end
//                3'b011 : begin Hole_H_mid <= 10'd463; Hole_V_mid <= 10'd274; end
//                3'b100 : begin Hole_H_mid <= 10'd563; Hole_V_mid <= 10'd274; end
//                3'b101 : begin Hole_H_mid <= 10'd363; Hole_V_mid <= 10'd194; end
//                3'b110 : begin Hole_H_mid <= 10'd463; Hole_V_mid <= 10'd194; end
//                3'b111 : begin Hole_H_mid <= 10'd563; Hole_V_mid <= 10'd194; end
                  2'b00 : begin Hole_H_mid <= 10'd363; Hole_V_mid <= 10'd274; end
                  2'b01 : begin Hole_H_mid <= 10'd463; Hole_V_mid <= 10'd274; end
                  2'b10 : begin Hole_H_mid <= 10'd563; Hole_V_mid <= 10'd274; end
                  2'b11 : begin Hole_H_mid <= 10'd463; Hole_V_mid <= 10'd194; end
            endcase
        end
     end
     
     //data updata
     //Layer priority hammer >> hole >> background
     always@(posedge Vga_Clk)begin
        if(En_hammer && Data_hammer != 16'hFFFF)
            Data <= Data_hammer;
        else if(Hole_hold_signal && En_hole && Data_hole != 16'hFFFF)
            Data <= Data_hole;
        else if(En_background)
            Data <= Data_background;
        else 
            Data <= WHITE;
     end
     
endmodule
