`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/06 10:44:37
// Design Name: 
// Module Name: SIGNAL_D_SHACK
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

//signel jitter about 10ms，hold for about 100ms
module SIGNAL_D_SHACK(
    input Clk,
    input Signal_s, //with jitter
    output Signal_ds);
    
    wire Detect_signal;
    reg [1:0] State;
    reg [1:0] State_r;
    
    //wire Detect_signal;
    reg [18:0] Count = 0;
    //reg [1:0] State;
    //reg [1:0] State_r;
    parameter s0 = 2'b00;   //no signal or detect btn off(s3->s0)
    parameter s1 = 2'b01;   //s0->s1 first time detct signal valid
    parameter s2 = 2'b11;   //s1->s2 signal keep valid 
    parameter s3 = 2'b10;   //s2->s3 first time detect signal invalid & btn off
    
    //5ms(5e6ns = 5e5 T) gen a 10ns detect signal
    assign Detect_signal = (Count == 19'd500_000);
    always@(posedge Clk)begin
        if(Count >= 19'd500_000)
            Count <= 0;
        else 
            Count <= Count + 1;         
    end
    
    //gen delay signal for single clock output
    always@(posedge Clk)begin
        State_r <= State;
    end
    
    //state change
    always@(posedge Clk)begin
        if(Detect_signal)begin
            case(State)
                s0 : if(Signal_s)
                        State <= s1;
                     else
                        State <= s0;
                s1 : if(Signal_s)
                        State <= s2;
                     else
                        State <= s0;
                s2 : if(!Signal_s)
                        State <= s3;
                     else
                        State <= s2;
                s3 : if(!Signal_s)
                        State <= s0;
                     else
                        State <= s2;    //fake btn off - jitter
                default : State <= s0;
            endcase
        end
    end
    
    //产生无抖动单周期输出信号
    assign Signal_ds = (State == s2) && (State_r == s1); 
endmodule
