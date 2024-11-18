`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/07 16:34:03
// Design Name: 
// Module Name: HIT_ONCE_TB
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


module HIT_ONCE_TB(
    
    );
    reg Clk;
    reg Rst_;
    reg Level_start;
    reg [1:0] each_Score;
    reg [6:0] Hold_Time;
    reg [1:0] Rand_Hole_Num;
    reg [7:0] Rand_Gap_Time;
    reg [3:0] Hits;
    wire Hole_hold_signal;
    wire [1:0] Hole_Num;
    wire Invalid_op;
    wire [1:0] Hit_Num;
    wire [7:0] Score;
    wire Fail, Pass;

    
HIT_ONCE UTB(
    Clk,              //xilinx 100MHz
    Rst_,
    Level_start,
    each_Score,
    Hold_Time,  //follow levels
    //input [2:0] Rand_Hole_Num,   //random
    Rand_Hole_Num,   //random 4 for test
    Rand_Gap_Time,   //random
    Hits,       //player operate - 4 for test;
    //input [7:0] Hits,
    Hole_hold_signal,    //for display
    Hole_Num,  //for display - 4 for test 
    //for VGA display Hammer operation
    Invalid_op,
    Hit_Num,
    Score,
    Fail,            //for level trans
    Pass             //for level trans
    );
    
    initial begin
        Clk = 0;
        forever
        #5 Clk = !Clk;
    end
    initial begin
        Rst_ = 1;
        Level_start = 0;
        each_Score = 2'b10;
        Hold_Time = 7'd100;
        #100
        Rst_ = 0;
        #100
        Rst_ = 1;
        #100
        Level_start = 1;
        #100
        Level_start = 0;
    end
    initial begin
        Rand_Gap_Time = 8'b0;
        forever
        if(Rand_Gap_Time != 8'd10)
            #10_000_000 Rand_Gap_Time = Rand_Gap_Time + 1;
        else
            #10_000_000 Rand_Gap_Time = 0;
    end
    initial begin
        Rand_Hole_Num = 2'b00;
        forever
        if(Rand_Hole_Num != 2'd3)
            #10_000_000 Rand_Hole_Num = Rand_Hole_Num + 1;
        else
            #10_000_000 Rand_Hole_Num = 0;
    end
        initial begin
        Hits = 4'b0000;
        #1000_000_000
        Hits = 4'b0001;
        #10
        Hits = 4'b0000;
        
        #1000_000_000
        Hits = 4'b0001;
        #10
        Hits = 4'b0000;
        
        #1000_000_000
        Hits = 4'b0100;
        #10
        Hits = 4'b0000;
        
        #1000_000_000
        Hits = 4'b0100;
        #10
        Hits = 4'b0000;
        
        #1000_000_000
        Hits = 4'b0100;
        #10
        Hits = 4'b0000;
        
        #1000_000_000
        Hits = 4'b0001;
        #10
        Hits = 4'b0000;
        
        #1000_000_000
        Hits = 4'b0001;
        #10
        Hits = 4'b0000;
        
        #1000_000_000
        Hits = 4'b0100;
        #10
        Hits = 4'b0000;
        
        #1000_000_000
        Hits = 4'b0100;
        #10
        Hits = 4'b0000;
        
        #1000_000_000
        Hits = 4'b0100;
        #10
        Hits = 4'b0000;
    end
//    initial begin
//        Hits = 8'b0000_0000;
//        #1000_000_000
//        Hits = 8'b0000_0001;
//        #10
//        Hits = 8'b0000_0000;
        
//        #1000_000_000
//        Hits = 8'b0001_0000;
//        #10
//        Hits = 8'b0000_0000;
        
//        #1000_000_000
//        Hits = 8'b0000_0100;
//        #10
//        Hits = 8'b0000_0000;
        
//        #1000_000_000
//        Hits = 8'b0000_0100;
//        #10
//        Hits = 8'b0000_0000;
        
//        #1000_000_000
//        Hits = 8'b0000_0100;
//        #10
//        Hits = 8'b0000_0000;
//    end
endmodule
