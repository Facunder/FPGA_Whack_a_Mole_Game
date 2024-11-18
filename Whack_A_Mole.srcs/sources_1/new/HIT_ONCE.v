`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/06 14:01:51
// Design Name: 
// Module Name: HIT_ONCE
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


module HIT_ONCE(
    input Clk,              //xilinx 100MHz
    input Rst_,
    input Level_start,
    input [1:0] each_Score,
    input [6:0] Hold_Time,  //follow levels
    //input [2:0] Rand_Hole_Num,   //random
    input [1:0] Rand_Hole_Num,   //random 4 for test
    input [7:0] Rand_Gap_Time,   //random
    input [3:0] Hits,       //player operate - 4 for test;
    //input [7:0] Hits,
    output reg Hole_hold_signal,    //for display
    output reg [1:0] Hole_Num,  //for display - 4 for test 
    //for VGA display Hammer operation
    output reg Invalid_op,
    output reg [1:0] Hit_Num,
    output reg [7:0] Score,
    output reg Fail,            //for level trans
    output reg Pass             //for level trans
    );
    wire Clk_10ms;          //a clock with 10ms cycle
    //reg Invalid_op;
    reg Can_Hit;
    reg Level_stop;
    reg [7:0] Gap_Time;
    reg Hit_success_signal; //after one successful hit
    reg Hole_end_signal;    //after one hole end
    //reg [2:0] Hit_Num;      //player input opeartion - button num
    //reg [1:0] Hit_Num;      //player input opeartion - button num - 4 for test
    reg [19:0] Clk_10ms_Count = 10'b0;
    reg [3:0] Get_Count;    //successful hit num
    reg [2:0] Play_Count;   //8 chances per level
    
    //Score update
    always@(posedge Clk)begin
        if(!Rst_)
            Score <= 8'b00_000_000;
        else if(Hit_success_signal)
            Score <= Score + each_Score;
        else
            Score <= Score;
    end
    
    //Get_Count update
    always@(posedge Clk)begin
        if(!Rst_ || Level_start)
            Get_Count <= 4'b0_000;
        else
            if(Hit_success_signal)
                Get_Count <= Get_Count + 1;
            else
                Get_Count <= Get_Count;   
    end
    
    //Play Count <= 8
    always@(posedge Clk) begin
        if(!Rst_ || Level_start)begin
            Play_Count <= 3'b000;
            Level_stop <= 1'b0;
            Gap_Time <= Rand_Gap_Time;
            Hole_Num <= Rand_Hole_Num;
            Pass <= 1'b0;
            Fail <= 1'b0;
        end
        else if(Hole_end_signal)begin
            //update rand data
            Gap_Time <= Rand_Gap_Time;
            Hole_Num <= Rand_Hole_Num;
            if(Play_Count < 3'b111)begin
                Play_Count <= Play_Count + 1;
                Level_stop <= Level_stop;
                Pass <= 1'b0;
                Fail <= 1'b0;
            end
            else begin  //8 chances over
                Play_Count <= 3'b000;   //reset
                Level_stop <= 1'b1;
                //one level over - Fail or Pass
                if(Get_Count >= 4'd4)   //10ns Level res signal
                    Pass <= 1'b1;
                else
                    Fail <= 1'b1;
                end
        end
        else begin
            Play_Count <= Play_Count;
            Level_stop <= Level_stop;
            Pass <= 1'b0;
            Fail <= 1'b0;
        end
    end    
    
    //1024 * 1024 * 10ns ~= 10ms clock
    assign Clk_10ms = Clk_10ms_Count[19];
    always@(posedge Clk)begin
        if(Clk_10ms_Count == 20'b11_111_111_111_111_111_111)
            Clk_10ms_Count <= 20'b0;
        else
            Clk_10ms_Count <= Clk_10ms_Count + 1;
    end
    
    //Hole appear 
    //Hole: Gap - Hold - Gap - Hold ...
    reg [8:0] Gap_Count = 9'b000_000_000;
    reg [6:0] Hold_Count = 7'b0_000_000;
    always@(posedge Clk_10ms)begin
        //Gap_Count
        if(!Rst_ || Level_start || Level_stop)
            Gap_Count <= 9'b000_000_000;
        else if(Hole_hold_signal == 1'b0 && Gap_Count != Gap_Time + 9'd100)  //Gap_Time 0-200 * 10ms, need 1-3s
                Gap_Count <= Gap_Count + 1;
        else    
            Gap_Count <= 9'b000_000_000;
        //Hold_Count
        if(!Rst_ || Level_start || Level_stop)
            Hold_Count <= 7'b0_000_000;
        else if(Hole_hold_signal == 1'b1 && Hold_Count != Hold_Time)
            Hold_Count <= Hold_Count + 1;
        else
            Hold_Count <= 7'b0_000_000;
    end
    
    always@(posedge Clk)begin
        if(!Rst_ || Level_start || Level_stop) begin
            Hole_hold_signal <= 1'b0;
            Hole_end_signal <= 1'b0;
        end
        else if(!Hole_hold_signal && Gap_Count == Gap_Time + 9'b100)begin  //appear
            Hole_hold_signal <= 1'b1;
            Hole_end_signal <= 1'b0;
        end
        else if(Hit_success_signal || Hole_hold_signal && Hold_Count == Hold_Time)begin
            Hole_hold_signal <= 1'b0;
            Hole_end_signal <= 1'b1;    //a Clk cycle
        end
        else begin
            Hole_hold_signal <= Hole_hold_signal;   //state
            Hole_end_signal <= 1'b0;    //pulse
        end
    end
    
    //success hit decide
    always@(posedge Clk)begin
        if(!Rst_)
            Hit_success_signal <= 1'b0;
        else if(Hole_hold_signal && (!Invalid_op && Hit_Num == Hole_Num) && !Hit_success_signal)
            Hit_success_signal <= 1'b1;     // a Clk cycle
        else
            Hit_success_signal <= 1'b0;
    end
    
    //decide player operation
    always@(posedge Clk)begin   
        if(!Rst_) begin
            Hit_Num <= 2'b01;
            Invalid_op <= 1'b1;
        end         
        if(Can_Hit)
            case(Hits)
//                8'b0000_0000 : Invalid_op <= 1'b1;
//                8'b0000_0001 : begin Hit_Num <= 3'b000; Invalid_op <= 1'b0; end
//                8'b0000_0010 : begin Hit_Num <= 3'b001; Invalid_op <= 1'b0; end
//                8'b0000_0100 : begin Hit_Num <= 3'b010; Invalid_op <= 1'b0; end
//                8'b0000_1000 : begin Hit_Num <= 3'b011; Invalid_op <= 1'b0; end
//                8'b0001_0000 : begin Hit_Num <= 3'b100; Invalid_op <= 1'b0; end
//                8'b0010_0000 : begin Hit_Num <= 3'b101; Invalid_op <= 1'b0; end
//                8'b0100_0000 : begin Hit_Num <= 3'b110; Invalid_op <= 1'b0; end
//                8'b1000_0000 : begin Hit_Num <= 3'b111; Invalid_op <= 1'b0; end
                  4'b0000 : Invalid_op <= 1'b1;
                  4'b0001 : begin Hit_Num <= 2'b00; Invalid_op <= 1'b0; end
                  4'b0010 : begin Hit_Num <= 2'b01; Invalid_op <= 1'b0; end
                  4'b0100 : begin Hit_Num <= 2'b10; Invalid_op <= 1'b0; end
                  4'b1000 : begin Hit_Num <= 2'b11; Invalid_op <= 1'b0; end
                default : Invalid_op <= 1'b1;       //invalid operation 
            endcase
       else
            Invalid_op <= 1'b1;
    end
    
    //operation interval 200ms limit - panish
    reg [4:0] Interval_op_Count; //Can't operate within Interval_op_Count*10ms
    always@(posedge Clk_10ms)begin
        if(Can_Hit)
            Interval_op_Count <= 5'b00_000;
        else
            Interval_op_Count <= Interval_op_Count + 1;
    end
    always@(posedge Clk)begin
        if(!Rst_ || Level_start)
            Can_Hit <= 1'b1;
        else if(Invalid_op == 1'b0)                              //detect operation
            Can_Hit <= 1'b0;
        else if(!(|Hits) && Interval_op_Count == 5'd20) //no op and stop operate for 200ms
            Can_Hit <= 1'b1;
        else
            Can_Hit <= Can_Hit;
    end   
    
endmodule
