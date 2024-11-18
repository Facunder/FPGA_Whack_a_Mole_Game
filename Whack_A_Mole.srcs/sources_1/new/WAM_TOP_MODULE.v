//WAM A Hole Game Complished by: Lin YuZheng
//2023 Fudan University ME ASIC Project
/*
WAM_TOP_MODULE
--CUT_CLK_FREQUENCY
--WAM_CORE
----SIGNAL_D_SHACK
----GEN_RAND
----HIT_ONCE
----LEVEL_CONTROLLER
--VGA_SYNC
--VGA_DISPLAY
----PIC_background
----PIC_gopher
----PIC_hammer
--SEG_OUT
----FOUR_NUMBER_SEG_OUT
------SINGLE_NUM_SEG_OUT
*/
module WAM_TOP_MODULE(
    //Function
    input Clk,
    input Rst_,
    input Start,
    input [3:0] Hits_Btn,   //4 btn for test
    //input [7:0] Hits_Btn,
    //USB kyboard Ps/2 ?
    //input [7:0] Keyboard_sync,
    //input [3:0] Buttons,
    //VGA
    output Hsync, Vsync,
    output [3:0] Vga_red, Vga_green, Vga_blue,
    //7-Seg LED
    output [6:0] Seg,
    output [3:0] Seg_sel,
    output [1:0] Level
    );
    wire Vga_Clk;
    wire [1:0] Seg_Clk;
    wire [7:0] Score;
    //wire [1:0] Level;
    wire Hole_hold_signal;  //for display
    wire [1:0] Hole_Num;    //for display 4 hole for test
    //for VGA display Hammer
    wire Invalid_op;
    wire [1:0] Hit_Num;
    //wire [2:0] Hole_Num;    //for display

    wire Dat_act;
    wire [9:0] Hcount, Vcount;
    wire [15:0] Vga_RGB;
    
    assign Vga_red = Vga_RGB[15:12];
    assign Vga_green = Vga_RGB[10:7];
    assign Vga_blue = Vga_RGB[4:1];
/********************************Gen Clk with multi frequency***************************************/   
CUT_CLK_FREQUENCY   Uinstance1(
                        .Clk(Clk),
                        .Vga_Clk(Vga_Clk),
                        .Seg_Clk(Seg_Clk)
                    );
/*********************************Core Module**************************************/
WAM_CORE    Uinstance2(
                        .Clk(Clk),
                        .Rst_(Rst_),
                        .Start(Start),
                        .Hits(Hits_Btn),
                        //display
                        .Hole_hold_signal(Hole_hold_signal),    //for display
                        .Hole_Num(Hole_Num),  //8 Gophers for display
                        .Invalid_op(Invalid_op),
                        .Hit_Num(Hit_Num),
                        .Score(Score),
                        .Level(Level)                     
                    );

/********************************VGA / LED-Light display gophers***************************************/
VGA_SYNC    Uinstance4(
                        .Clk(Vga_Clk),
                        .Hsync(Hsync),
                        .Vsync(Vsync),
                        .Dat_act(Dat_act),
                        .Hcount(Hcount),
                        .Vcount(Vcount)
                    );
VGA_DISPLAY    Uinstance5(
                        .Clk(Clk),
                        .Vga_Clk(Vga_Clk),
                        .Dat_act(Dat_act),
                        .Hcount(Hcount),
                        .Vcount(Vcount),
                        .Rst_(Rst_),
                        //.Level_in(Level),
                        .Hole_hold_signal_in(Hole_hold_signal),
                        .Hole_Num_in(Hole_Num),
                        .Invalid_op(Invalid_op),
                        .Hit_Num(Hit_Num),
                        .Vga_RGB(Vga_RGB)
                    );                    
/********************************7 Segment display score***************************************/ 
SEG_OUT     Uinstance6(
                        .Clk(Seg_Clk),  
                        .Score_nums(Score),
                        //.level_nums(Level),
                        .Seg(Seg),
                        .Seg_sel(Seg_sel)
                    );   
//reg [6:0] Seg_r;
//assign Seg = Seg_r;
//always@(Score)begin
//    case(Score[3:0])
//            4'h0: Seg_r <= 7'b1000000;
//            4'h1: Seg_r <= 7'b1111001;
//            4'h2: Seg_r <= 7'b0100100;
//            4'h3: Seg_r <= 7'b0110000;
//            4'h4: Seg_r <= 7'b0011001;
//            4'h5: Seg_r <= 7'b0010010;
//            4'h6: Seg_r <= 7'b0000010;
//            4'h7: Seg_r <= 7'b1111000;
//            4'h8: Seg_r <= 7'b0000000;
//            4'h9: Seg_r <= 7'b0010000;
//            default: Seg_r <= 7'b0111111; 
//            endcase
//end
//assign Seg_sel = 4'b0000;
endmodule
