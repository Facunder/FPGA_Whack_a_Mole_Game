`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/05 22:31:27
// Design Name: 
// Module Name: WAM_CORE
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


module WAM_CORE(
    input Clk,
    input Start,
    input Rst_,
    input [3:0] Hits,
    //display
    output Hole_hold_signal,    //for display
    output [1:0] Hole_Num,  //4 Gophers for test
    //for VGA display Hammer
    output Invalid_op,
    output [1:0] Hit_Num,
    //output [2:0] Hole_Num,  //8 Gophers for display
    output [7:0] Score,
    output [1:0] Level 
    );
    
    wire [1:0] each_Score;
    wire [6:0] Hold_Time;    //Gopher Hold Time T2 = Hold_Time*10ms
    wire Level_start;
    wire Start_ds;
    wire [3:0] Hits_ds; 
    wire Pass, Fail;
    wire Hit_signal;    
    
    wire [1:0] Rand_Hole_Num;
    wire [7:0] Rand_Gap_Time;
    wire En_rand;
    
    parameter LN = 2'b00, L1 = 2'b01, L2 = 2'b10, L3 = 2'b11;
    
    //button in dis-shack - Start Hits*8
    SIGNAL_D_SHACK  Uinstance_ds0(.Clk(Clk),    .Signal_s(Start),   .Signal_ds(Start_ds));
    SIGNAL_D_SHACK  Uinstance_ds1(.Clk(Clk),    .Signal_s(Hits[0]),   .Signal_ds(Hits_ds[0]));
    SIGNAL_D_SHACK  Uinstance_ds2(.Clk(Clk),    .Signal_s(Hits[1]),   .Signal_ds(Hits_ds[1]));
    SIGNAL_D_SHACK  Uinstance_ds3(.Clk(Clk),    .Signal_s(Hits[2]),   .Signal_ds(Hits_ds[2]));
    SIGNAL_D_SHACK  Uinstance_ds4(.Clk(Clk),    .Signal_s(Hits[3]),   .Signal_ds(Hits_ds[3]));
//    SIGNAL_D_SHACK  Uinstance_ds5(.Clk(Clk),    .Signal_s(Hits[4]),   .Signal_ds(Hits_ds[4]));
//    SIGNAL_D_SHACK  Uinstance_ds6(.Clk(Clk),    .Signal_s(Hits[5]),   .Signal_ds(Hits_ds[5]));
//    SIGNAL_D_SHACK  Uinstance_ds7(.Clk(Clk),    .Signal_s(Hits[6]),   .Signal_ds(Hits_ds[6]));
//    SIGNAL_D_SHACK  Uinstance_ds8(.Clk(Clk),    .Signal_s(Hits[7]),   .Signal_ds(Hits_ds[7]));
    
    //random Number generator
    assign En_rand = (|Hits_ds) || Start_ds;
    GEN_RAND    Uinstance2_1(
                            .Clk(Clk),
                            .En(En_rand),
                            .Rand_3bit(Rand_Hole_Num),
                            .Rand_8bit(Rand_Gap_Time)
                            );
                            
    //hit gopher main process
    HIT_ONCE    Uinstance2_2(
                            //input 
                            .Clk(Clk),              //xilinx 100MHz
                            .Rst_(Rst_),
                            .Level_start(Level_start),
                            .each_Score(each_Score),
                            .Hold_Time(Hold_Time),  //follow levels
                            .Rand_Hole_Num(Rand_Hole_Num),   //random
                            .Rand_Gap_Time(Rand_Gap_Time),   //random
                            .Hits(Hits_ds),       //player operate
                            //output
                            .Hole_hold_signal(Hole_hold_signal),    //for display
                            .Hole_Num(Hole_Num),  //for display
                            .Invalid_op(Invalid_op),
                            .Hit_Num(Hit_Num),
                            .Score(Score),
                            .Fail(Fail),            //for level trans
                            .Pass(Pass)             //for level trans
                            );
    
    //Level controller                        
    LEVEL_CONTROLLER     Uinstance2_3(
                            .Clk(Clk),
                            .Rst_(Rst_),
                            .Start_ds(Start_ds),
                            .Pass(Pass),
                            .Fail(Fail),
                            .Level_start(Level_start),
                            .Level(Level),
                            .each_Score(each_Score),
                            .Hold_Time(Hold_Time) 
                            );
endmodule