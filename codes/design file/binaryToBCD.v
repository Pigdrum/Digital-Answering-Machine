`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/14 20:00:40
// Design Name: 
// Module Name: binaryToBCD
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


module binaryToBCD(input[7:0] binary, output reg [7:0]bcd);
  integer i;
  always@*
  begin
     bcd = 8'd0;
     for (i = 7; i>=0;i = i-1)begin
     if(bcd[7:4]>=4'd5) bcd[7:4] = bcd[7:4]+3;
     $monitor("%d",bcd[7:4]);
     if(bcd[3:0]>=4'd5) bcd[3:0] = bcd[3:0]+3;
     bcd[7:4] = bcd[7:4]<<1;
     bcd[4] = bcd[3];
     bcd[3:0] = bcd[3:0]<<1;
     bcd[0] = binary[i];
     end
  end
endmodule
