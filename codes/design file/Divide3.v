`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/03 01:25:25
// Design Name: 
// Module Name: Divide3
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


module Divide3(clk,rst,clk_out);
   input clk,rst;
   output reg clk_out;
   reg[31:0] cnt;
   
   parameter period = 100;

   always@(posedge clk,negedge rst)
   begin
      if(!rst) begin
         cnt <=0;
         clk_out<=0;
      end
      else begin
         if(cnt == (period>>1)-1)begin
            clk_out <= ~clk_out;
            cnt <= 0;
         end
         else cnt <= cnt+1;
      end
   end

endmodule
