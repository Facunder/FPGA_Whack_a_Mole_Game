`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/06 14:02:07
// Design Name: 
// Module Name: GEN_RAND
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


module GEN_RAND(
    input Clk,
    input En,   //button as enable signal - real random
    output [2:0] Rand_3bit,
    output [7:0] Rand_8bit  //min1000ms max3000ms - 200*10m - 255
    );
    
    reg [2:0] num1 = 3'b0;
    reg [7:0] num2 = 7'b0;
    reg [7:0] Count = 7'b0;
    
    //LFSR
    always@(posedge Clk)begin
        if(Count < 7'b1_111_111)
            Count <= Count + 1;
        else
            Count <= 7'b0;
    end
    
    always@(posedge Clk)begin
        if(En)
            num1 <= Count[2:0];
        else begin
            num1[0] <= num1[2] ^ num1[1];
            num1[1] <= num1[0];
            num1[2] <= num1[1];
        end
    end
    
    always@(posedge Clk)begin
        if(En)
            num2 <= Count;
        else begin
            num2[0] <= num2[7] ^ num2[5] ^ num2[4] ^ num2[3];
            num2[1] <= num2[0];
            num2[2] <= num2[1];
            num2[3] <= num2[2];
            num2[4] <= num2[3];
            num2[5] <= num2[4];
            num2[6] <= num2[5];
            num2[7] <= num2[6];
        end        
    end
    assign Rand_3bit = num1;
    assign Rand_8bit = num2;
endmodule
