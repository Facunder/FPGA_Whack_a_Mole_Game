`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/06 11:18:40
// Design Name: 
// Module Name: SIGNAL_D_SHACK_TB
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


module SIGNAL_D_SHACK_TB(

    );
    reg Clk;
    reg Signal;
    wire Signal_ds;

    SIGNAL_D_SHACK  UTB(
                        .Clk(Clk),
                        .Signal_s(Signal),
                        .Signal_ds(Signal_ds)   
                        );
    
    initial begin
        Clk = 0;
        forever
        #5
        Clk = !Clk;
    end
    initial begin
        Signal = 0;
        #100000
        Signal = 1;
        #2
        Signal = 0;
        #3000
        Signal = 1;
        #100
        Signal = 0;
        #7000
        Signal = 1;
        #1240000
        Signal = 0;
        #2630000
        Signal = 1;
        #1500000
        Signal = 0;
        #1200035
        Signal = 1;
        #1000230
        Signal = 0;
        #3000000
        Signal = 1;
        #1000000
        Signal = 0;
        #700
        Signal = 1;
        #1240
        Signal = 0;
        #2630
        Signal = 1;
        #1500
        Signal = 0;
        #1235
        Signal = 1;
        #100_000_000
        Signal = 0;
        #10000
        Signal = 1;
        #200
        Signal = 0;
        #3000
        Signal = 1;
        #100
        Signal = 0;
        #7000
        Signal = 1;
        #1240000
        Signal = 0;
        #2630000
        Signal = 1;
        #1500000
        Signal = 0;
        #1200035
        Signal = 1;
        #1000230
        Signal = 0;
        #3000000
        Signal = 1;
        #1000000
        Signal = 0;
        #700
        Signal = 1;
        #1240
        Signal = 0;
        #2630
        Signal = 1;
        #1500
        Signal = 0;
        #1235
        Signal = 1;
        #600
        Signal = 0;
        #100000
        Signal = 1;
        #2
        Signal = 0;
        #3000
        Signal = 1;
        #100
        Signal = 0;
        #7000
        Signal = 1;
        #1240000
        Signal = 0;
        #2630000
        Signal = 1;
        #1500000
        Signal = 0;
        #1200035
        Signal = 1;
        #1000230
        Signal = 0;
        #3000000
        Signal = 1;
        #1000000
        Signal = 0;
        #700
        Signal = 1;
        #1240
        Signal = 0;
        #2630
        Signal = 1;
        #1500
        Signal = 0;
        #1235
        Signal = 1;
        #100_000_000
        Signal = 0;
        #10000
        Signal = 1;
        #200
        Signal = 0;
        #3000
        Signal = 1;
        #100
        Signal = 0;
        #7000
        Signal = 1;
        #1240000
        Signal = 0;
        #2630000
        Signal = 1;
        #1500000
        Signal = 0;
        #1200035
        Signal = 1;
        #1000230
        Signal = 0;
        #3000000
        Signal = 1;
        #1000000
        Signal = 0;
        #700
        Signal = 1;
        #1240
        Signal = 0;
        #2630
        Signal = 1;
        #1500
        Signal = 0;
        #1235
        Signal = 1;
        #600
        Signal = 0;
    end
endmodule
