`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/29 10:32:52
// Design Name: 
// Module Name: GEN_RAND_TB
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


module GEN_RAND_TB(

    );
    reg Clk;
    reg En;
    wire [2:0] Rand_3bit;
    wire [7:0] Rand_8bit;

    GEN_RAND UTB(
    Clk,
    En,   //enable signal gen by actual button press
    Rand_3bit,
    Rand_8bit  //1000ms ?3000ms - 200*10ms
    );
    initial begin
        Clk = 0;
        forever begin
            #5 
            Clk = ~Clk;
        end
    end
    initial begin
        En = 0;
        #40 
        En = 1;
        #10
        En = 0;
        #50
        En = 1;
        #10
        En = 0;
        #200
        En = 1;
        #10
        En = 0;
         
    end
endmodule
