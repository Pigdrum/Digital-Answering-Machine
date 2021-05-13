`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/11 16:43:40
// Design Name: 
// Module Name: Main
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

//顶层模块
module Main(
   input[3:0] row,
   output[3:0] col,
   
   input resetButton,//低电频有效
   input reviewButton, //进入复核模式，高电频有效
   input host, //主持人按键，高电频有效
   input isRight, //主持人决定是否正确，高电频有效
   input isWrong, //主持人决定是否错误，高电频有效
   input[3:0] people,//选手抢答按键，高电频有效，独热码
   input clk,//系统时钟信号

   output[7:0] seg_out,//七段数码管显示,低电频有效
   output[7:0] seg_en, //七段数码管使能，低电频有效
   output ring, //高电频有效
   output[3:0] led//选手前的led灯，高电频有效
);
   
 
   reg[2:0] process_state;//000---初始   001---设置   010---比赛开始   011---有人获胜   100---复核
   reg[2:0] next_process_state;
   wire[3:0] max;//表示最后胜利的人，独热码
   wire isWin;//是否有人胜利了，高电频有效
   wire[3:0]lock_set_people;//锁存设置人数 ，独热码
   wire[7:0]lock_set_time;//锁存设置时间，二进制
   wire[3:0]lock_set_gain;//锁存设置得分，二进制
   wire[3:0]lock_set_lose;//锁存设置失分，二进制
   
   wire[3:0]lock_people;//锁存抢答人数，独热码
   wire isFoul;//是否犯规，高电频有效
   
   //最多63回合,标记每一回合得分情况 低比特01表示得分，10表示失分，00表示不加不减
   //每两比特存储一局
   wire[127:0]people_one;//选手1                                       
   wire[127:0]people_two;//选手2
   wire[127:0]people_three;//选手3
   wire[127:0]people_four;//选手4
   
   //存每位选手正分与负分，二进制存储
   wire[7:0]positive_scores1;//选手1正分
   wire[7:0]negtive_scores1;//选手1负分，下同
   wire[7:0]positive_scores2;
   wire[7:0]negtive_scores2;
   wire[7:0]positive_scores3;
   wire[7:0]negtive_scores3;
   wire[7:0]positive_scores4;
   wire[7:0]negtive_scores4;
   
   wire [1:0]isAdd;//抢答成功选手得分情况，01表示失分，10表示得分，00表示未判定
   wire[7:0]roundNumber;//总轮数
   wire[2:0] state;//状态线网类型
   wire isOverTime;//1是超时    0是未超时
   wire clk_state;//状态机时钟
   parameter s1 = 3'b001,s2 = 3'b010,s3 = 3'b011,s4 = 3'b100;
   
   Divide3 uuu(clk,resetButton,clk_state);//给状态分频，以让每个状态在切换前能够处理完其功能
   
   wire set_done;//表示设置完成，进入抢答阶段，高电频有效
   wire[2:0] participants_number;//设置参与人数，二进制
   wire [2:0]total_stage_number;//设置阶段的总状态，二进制
   wire[2:0]this_stage_number;//设置阶段的单独状态，二进制
       
   decodePeople de(participants_number,resetButton,lock_set_people);//将二进制的人数转为独热码人数形式
   
   
   //总的状态机
   assign state = process_state;
   always@(posedge clk_state,negedge resetButton)
      begin
         if(!resetButton)
            process_state <=s1;
         else process_state <= next_process_state;
      end
      
   always@(isWin,host,reviewButton,set_done)
   begin
      case(process_state)
      s1: if(set_done) next_process_state = s2;else next_process_state = s1;
      s2: if(isWin) next_process_state = s3;else next_process_state = s2;
      s3: if(reviewButton)next_process_state = s4;else next_process_state = s3;
      s4: if(reviewButton)next_process_state = s4;else next_process_state = s3;
      endcase
   end
   
   
   //设置模块
   setting u_setting(clk,resetButton,row,
                    col,participants_number,lock_set_time,lock_set_gain,lock_set_lose,set_done,          
                    total_stage_number,this_stage_number
                    );
   
   //抢答模块
   BeginState u3(clk,resetButton,state,isOverTime,lock_set_people&people,lock_set_gain,lock_set_lose,host,isRight,isWrong,
       positive_scores1,positive_scores2,positive_scores3,positive_scores4,
       negtive_scores1,negtive_scores2,negtive_scores3,negtive_scores4,//input
     lock_people,isWin,isFoul,isAdd,max);//output
     
   //蜂鸣器模块
   Ring uuuu(clk,state,resetButton,host,lock_people,isFoul,ring);
   
   //赋分模块
   Scores score(clk,resetButton,state,isAdd,lock_people,lock_set_gain,lock_set_lose, 
   people_one,people_two,people_three,people_four,
   positive_scores1,negtive_scores1,positive_scores2,negtive_scores2,positive_scores3,negtive_scores3,positive_scores4,negtive_scores4,roundNumber);
   
   //显示模块
   show u4(clk,state,resetButton,lock_people,positive_scores1,positive_scores2,positive_scores3,positive_scores4,max,roundNumber,
   people_one,people_two,people_three,people_four,
   participants_number,lock_set_time,total_stage_number,this_stage_number,
   negtive_scores1,negtive_scores2,negtive_scores3,negtive_scores4,isFoul,lock_set_time,host,isAdd,lock_set_gain,lock_set_lose,//input
   seg_out,seg_en,led,isOverTime);
   
   
endmodule
