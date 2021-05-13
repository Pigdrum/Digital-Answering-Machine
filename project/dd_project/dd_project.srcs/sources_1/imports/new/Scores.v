`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/03 15:32:15
// Design Name: 
// Module Name: Scores
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

//模块功能：对相应选手进行评分并存储
module Scores(
    input clk,
    input resetButton,
    input[2:0] process_state,
    input[1:0] isAdd,
    input[3:0] lock_people,
    input[3:0] lock_set_gain,
    input[3:0] lock_set_lose,
    
    output reg[127:0]people_one,
    output reg[127:0]people_two,
    output reg[127:0]people_three,
    output reg[127:0]people_four,
    
    output reg[7:0]positive_scores1,
    output reg[7:0]negtive_scores1,
    output reg[7:0]positive_scores2,
    output reg[7:0]negtive_scores2,
    output reg[7:0]positive_scores3,
    output reg[7:0]negtive_scores3,
    output reg[7:0]positive_scores4,
    output reg[7:0]negtive_scores4,
    
    output reg[7:0] roundNumber
        );
        
          reg[1:0]delay_add1;
          reg[1:0]delay_add2;
          reg delayAdd;
          wire pos=delayAdd;
          
          //上升沿采样
          always@(posedge clk,negedge resetButton)
          begin
            if(!resetButton)begin
               delay_add1 <= 0;
               delay_add2 <= 0;
               delayAdd = 0;      
            end
            else if(process_state == 3'b010)
            begin
               delay_add1 <= isAdd;
               delay_add2 <= delay_add1;
               if((isAdd)&&(!delay_add2))delayAdd = 1;
               else delayAdd = 0;
            end
            else begin
               delay_add1 <= 0;
               delay_add2 <= 0;
               delayAdd = 0;
            end
         end
         
         
         //加分主模块
         always@(posedge pos,negedge resetButton)
         begin 
         if(!resetButton)begin
             positive_scores1 <= 8'd0;
             positive_scores2 <= 8'd0;
             positive_scores3 <= 8'd0;
             positive_scores4 <= 8'd0;
             negtive_scores1 <= 8'd0;
             negtive_scores2 <= 8'd0;
             negtive_scores3 <= 8'd0;
             negtive_scores4 <= 8'd0;
             roundNumber<= 8'd0;
             people_one <= 128'd0;
             people_two <= 128'd0;
             people_three <= 128'd0;
             people_four <= 128'd0;
         end
         //回答正确
         else if(isAdd[1])begin
                roundNumber <= roundNumber + 1;
                case(lock_people)
                     4'b0001:begin 
                        positive_scores1 <=( positive_scores1 + { 4'b0000,lock_set_gain } );
                        people_one <= (people_one << 2) + 2'b01;
                        people_two <= people_two << 2;
                        people_three <= people_three << 2;
                        people_four <= people_four << 2;
                     end
                     4'b0010:begin 
                        positive_scores2 <= positive_scores2+{4'b0000,lock_set_gain};
                        people_one <= people_one << 2;
                        people_two <= (people_two << 2) + 2'b01;
                        people_three <= people_three << 2;
                        people_four <= people_four << 2;
                     end
                     4'b0100:begin 
                        positive_scores3 <= positive_scores3 + {4'b0000,lock_set_gain};
                        people_one <= people_one << 2;
                        people_two <= people_two << 2;
                        people_three <= (people_three << 2) + 2'b01;
                        people_four <= people_four << 2;
                     end
                     4'b1000:begin 
                        positive_scores4 <= positive_scores4+{4'b0000,lock_set_gain};
                        people_one <= people_one << 2;
                        people_two <= people_two << 2;
                        people_three <= people_three << 2;
                        people_four <= (people_four << 2) + 2'b01;
                     end
                endcase
             end
             //回答错误
             else if(isAdd[0])begin
                roundNumber <= roundNumber + 1;
                case(lock_people)
                     4'b0001:begin 
                        negtive_scores1 <= negtive_scores1 + {4'b0000,lock_set_lose};
                        people_one <= (people_one << 2) + 2'b10;
                        people_two <= people_two << 2;
                        people_three <= people_three << 2;
                        people_four <= people_four << 2;
                     end
                     4'b0010:begin 
                        negtive_scores2 <= negtive_scores2 + {4'b0000,lock_set_lose};
                        people_one <= people_one << 2;  
                        people_two <= (people_two << 2) + 2'b10;
                        people_three <= people_three << 2;
                        people_four <= people_four << 2;
                     end
                     4'b0100:begin 
                        negtive_scores3 <= negtive_scores3 + {4'b0000,lock_set_lose};
                        people_one <= people_one << 2;
                        people_two <= people_two << 2;
                        people_three <= (people_three << 2) + 2'b10;
                        people_four <= people_four << 2;
                     end
                     4'b1000:begin 
                        negtive_scores4 <= negtive_scores4 + {4'b0000,lock_set_lose};
                        people_one <= people_one << 2;
                        people_two <= people_two << 2;
                        people_three <= people_three << 2;
                        people_four <= (people_four << 2) + 2'b10;
                     end
                endcase
             end
         end
         
endmodule
