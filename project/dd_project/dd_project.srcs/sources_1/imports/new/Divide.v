`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/11 23:25:43
// Design Name: 
// Module Name: Divide
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


module Divide(clk,rst,clk_out);
   input clk,rst;
   output reg clk_out;
   reg[31:0] cnt;


   parameter period = 200000;

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
