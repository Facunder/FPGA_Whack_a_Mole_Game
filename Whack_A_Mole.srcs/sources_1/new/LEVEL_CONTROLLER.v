`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/18 09:45:59
// Design Name: 
// Module Name: LEVEL_CONTROLLER
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

module LEVEL_CONTROLLER(
    input Clk,
    input Rst_,
    input Start_ds,
    input Pass,
    input Fail,
    output Level_start,
    output [1:0] Level,
    output [1:0] each_Score,
    output [6:0] Hold_Time
    );
    
    parameter LN = 2'b00, L1 = 2'b01, L2 = 2'b10, L3 = 2'b11;
    //3 part state
    reg Level_start_temp;
    reg Level_start_r;
    reg [1:0] Level_r;
    reg [1:0] each_Score_r;
    reg [6:0] Hold_Time_r;
    reg [1:0] next_Level;
    reg Level_start_rd;
    
    assign Level_start = Level_start_rd;
    assign Level = Level_r;
    assign each_Score = each_Score_r;
    assign Hold_Time = Hold_Time_r;
    
    always@(posedge Clk)begin
        if(!Rst_)
            Level_start_r <= 1'b0;
        else if(Level_start_temp == 1'b1 && Start_ds)
            Level_start_r <= 1'b1;
        else
            Level_start_r <= 1'b0;
    end
    
    //delay a cycle Levl start signal
    always@(posedge Clk)begin
        if(!Rst_)
            Level_start_rd <= 1'b0;
        else
            Level_start_rd <= Level_start_r;
    end
    
    always@(posedge Clk)begin
        if(!Rst_) begin     //switch off Rst_ = 0
            Level_r <= LN;
            Level_start_temp <= 1'b1;
        end
        else begin
            if(Level != next_Level) begin    //each level start by start button
                if(next_Level == LN)
                    Level_start_temp <= 1'b0;
                else
                    Level_start_temp <= 1'b1;
                Level_r <= next_Level;
            end
            else if(Level_start == 1'b1)
                Level_start_temp <= 1'b0;
            else
                Level_start_temp <= Level_start_temp;
        end
    end
    
    always@(Level or Rst_)begin
        if(!Rst_) begin
            each_Score_r <= 2'b0;
            Hold_Time_r <= 7'b0;  
        end
        else begin
            case(Level)
                LN : begin
                        each_Score_r <= 2'b00;
                        Hold_Time_r <= 7'b0;
                     end
                L1 : begin
                        each_Score_r <= 2'b01;
                        Hold_Time_r <= 7'd120;
                     end
                L2 : begin 
                        each_Score_r <= 2'b10;
                        Hold_Time_r <= 7'd90;
                     end
                L3 : begin 
                        each_Score_r <= 2'b11;
                        Hold_Time_r <= 7'd60;
                     end
            endcase
        end
    end
    
    always@(Level or Start_ds or Pass or Fail)begin
        case(Level)
            LN : if(Start_ds == 1)
                    next_Level <= L1;
                 else
                    next_Level <= LN;
            L1 : if(Pass == 1)
                    next_Level <= L2;
                 else if(Fail == 1)
                    next_Level <= LN;
                 else
                    next_Level <= L1;
            L2 : if(Pass == 1)
                    next_Level <= L3;
                 else if(Fail == 1)
                    next_Level <= LN;
                 else
                    next_Level <= L2;
            L3 : if(Pass == 1 || Fail == 1)
                    next_Level <= LN;
                 else
                    next_Level <= L3; 
        endcase
    end
endmodule
