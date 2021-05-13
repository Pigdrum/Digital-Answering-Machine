`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/15 13:30:24
// Design Name: 
// Module Name: BeginState
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
模块功能：实现抢答环节的逻辑，锁存抢答状态，抢答选手，主持人决定
*/

module BeginState(
   input clk,
   input resetButton,
   input [2:0]process_state,
   input isOverTime,
   input[3:0] people,
   input[3:0]lock_set_gain, input[3:0]lock_set_lose,
   input host, input isRight, input isWrong,
   
   input[7:0] positive_scores1, input[7:0]positive_scores2, input[7:0]positive_scores3, input[7:0]positive_scores4,
   input[7:0]negtive_scores1, input[7:0]negtive_scores2, input[7:0]negtive_scores3, input[7:0]negtive_scores4,
   
   output reg[3:0]lock_people,
   output reg isWin,output reg isFoul,output reg[1:0] isAdd,
   output reg[3:0] max
   );
   
   reg isScoresChange;//判定是否已经进行判分操作
   reg next_isScoresChange, next_isFoul;
   reg [3:0]next_lock_people;
   reg next_isWin;
   reg [1:0]next_isAdd;
   reg[3:0]next_max;
   wire clk_out;
   
   
   //相当于D锁存器
   always@(posedge clk,negedge resetButton)
   begin
      if(!resetButton)
      begin
         lock_people <= 4'b0000;
         isFoul <= 1'b0;
         max <= 4'b0000;
         isWin<=0;
         isScoresChange<=0;
         isAdd <= 0;
      end 
      else if(process_state == 3'b010)
      begin
         isAdd <= next_isAdd;isScoresChange<=next_isScoresChange;
         lock_people <= next_lock_people;
         isFoul <= next_isFoul;
         isWin <= next_isWin;
         max<=next_max;
      end
      else begin
          lock_people <= 0;
          isFoul <= 0;
          isWin <= next_isWin;
          max<=next_max;
      end
   end
    
    //次态函数
   always@(people,resetButton,isScoresChange,lock_people,isFoul,host,isRight,isWrong)
   begin
      //复位键
      if(!resetButton)begin
         next_isWin = 0;next_lock_people=0;
         next_isFoul=0;
         next_isScoresChange = 1'b1;
         next_isAdd = 2'b00;
         next_max = 4'b0000;
      end
      //抢答状态
      else if(process_state == 3'b010)
      begin
         if(!host||isOverTime)begin
              next_isWin = 0;
              next_isAdd = 2'b00;
              next_isFoul = people?1'b1:1'b0;
              next_isScoresChange = 1'b1;
              if(!lock_people||(!isFoul&&lock_people))//没人抢答，或者有人抢答但没人犯规（主持人关闭抢答通道但选手尚未复位）
                 next_lock_people = people;
              //犯规抢答，只记录第一个人
              else if(!people) next_lock_people = 4'b0000;
              else next_lock_people = lock_people;
         end    
         else begin
            next_isWin = 0;
            if(isFoul)begin//主持人开始，但有人犯规
               next_isFoul = 1'b1;
               next_lock_people = lock_people;
               next_isScoresChange = 1'b1;
               next_isAdd = 2'b00;
            end
            else begin
               next_isFoul = 1'b0;
               if(!lock_people)begin //无人抢答
                  next_lock_people = people;
                  next_isAdd = 0;
                  if(people) next_isScoresChange = 1'b0;
                  else next_isScoresChange = 1'b1;
               end
               else begin //有人抢答
                  next_lock_people = lock_people;
                  if((!isScoresChange)&&(isRight||isWrong)) begin//主持人判定了是否正确
                     next_isScoresChange = 1'b1;
                     if(isRight)begin//如果正确了
                        next_isAdd = 2'b10;
                     end
                     else begin//如果答错了
                        next_isAdd = 2'b01;
                     end  
                  end
                  else begin 
                     next_isScoresChange = isScoresChange;
                     next_isAdd = isAdd;
                  end//主持人尚未判定是否正确
               end
            end
         end
         //如果有人胜利
         if((positive_scores1>=negtive_scores1+10&&positive_scores1>=10)||
            (positive_scores2>=negtive_scores2+10&&positive_scores2>=10)||
            (positive_scores3>=negtive_scores3+10&&positive_scores3>=10)||
            (positive_scores4>=negtive_scores4+10&&positive_scores4>=10)) begin
               next_isWin = 1'b1;
               if((positive_scores1>=negtive_scores1+10&&positive_scores1>=10))next_max = 4'b0001;
               else if(positive_scores2>=negtive_scores2+10&&positive_scores2>=10)next_max = 4'b0010;
               else if(positive_scores3>=negtive_scores3+10&&positive_scores3>=10)next_max = 4'b0100;
               else next_max = 4'b1000;
            end
         else next_isWin = 0; 
      end
      //非抢答状态
      else begin
              next_isWin = 0;next_lock_people=0;
              next_isFoul=0;
              next_isScoresChange = 1'b1;
              next_isAdd = 2'b00;
              next_max = max;
      end
   end
endmodule
