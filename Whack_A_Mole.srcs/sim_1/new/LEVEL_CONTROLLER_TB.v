`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/29 09:53:40
// Design Name: 
// Module Name: LEVEL_CONTROLLER_TB
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


module LEVEL_CONTROLLER_TB(
    
    );
      reg Clk;
      reg Rst_;
      reg Start_ds;
      reg Pass;
      reg Fail;
      wire Level_start;
      wire [1:0] Level;
      wire [1:0] each_Score;
      wire [6:0] Hold_Time;
    LEVEL_CONTROLLER UTB (
      Clk,
      Rst_,
      Start_ds,
      Pass,
      Fail,
      Level_start,
      Level,
      each_Score,
      Hold_Time 
    );
    initial begin
            Clk = 1;
        forever
        #5
        Clk = !Clk;
    end
    initial begin
        Rst_ = 1;
        #50
        Rst_ = 0;
        #50
        Rst_ = 1;
    end
    initial begin
        Start_ds = 0;
        Pass = 0;
        Fail = 0;
        #200
        Start_ds = 1;
        #10
        Start_ds = 0;
        #50
        Pass = 1;
        #10
        Pass = 0;
        #100
        Start_ds = 1;
        #10
        Start_ds = 0;
        #50
        Pass = 1;
        #10
        Pass = 0;
        #100
        Start_ds = 1;
        #10
        Start_ds = 0;
        #50
        Pass = 1;
        #10
        Pass = 0;
        
    end
endmodule
