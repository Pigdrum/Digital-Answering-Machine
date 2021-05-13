`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/03 21:59:13
// Design Name: 
// Module Name: begin_tb
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


module begin_tb(

    );
    reg clk,resetButton;
    reg[2:0] state = 3'b010;
    reg isOverTime;
    reg[3:0] people,lock_set_gain = 4'b0011,lock_set_lose = 4'b0010;//�����֣�������
    reg host,isRight,isWrong;
    reg [3:0]lock_set_people = 4'b1111;    
    
    
    wire [7:0]positive_scores1,negtive_scores1,positive_scores2,negtive_scores2,positive_scores3,negtive_scores3,positive_scores4,negtive_scores4,roundNumber;
    wire [3:0]lock_people,max;
    wire isWin,isFoul;
    wire [1:0] isAdd;
    wire[127:0]people_one,people_two,people_three,people_four;
    
    BeginState u3(clk,resetButton,state,isOverTime,lock_set_people&people,lock_set_gain,lock_set_lose,host,isRight,isWrong,
           positive_scores1,positive_scores2,positive_scores3,positive_scores4,
           negtive_scores1,negtive_scores2,negtive_scores3,negtive_scores4,//input
         lock_people,isWin,isFoul,isAdd,max);
    
    
    Scores score(clk,resetButton,state,isAdd,lock_people,lock_set_gain,lock_set_lose, 
       people_one,people_two,people_three,people_four,
       positive_scores1,negtive_scores1,positive_scores2,negtive_scores2,positive_scores3,negtive_scores3,positive_scores4,negtive_scores4,roundNumber);
       
    initial begin
       clk = 0;
       resetButton = 0;
       isOverTime = 0;
       people = 0;
       people = 0;
       host=0;
       isRight=0;
       isWrong = 0;
       forever #1 clk = ~clk;
    end
    
    initial fork
       #2 people = 4'b0001;//resetButton�źż���
       #7 people = 4'b0000;
       
       #8 resetButton = 1;
       
       #10 people = 4'b0001;//1��ѡ�ַ���
       #14 people = 4'b0011;//2��ѡ�ּ������棬ֻ��¼1��
       #20 people = 4'b0000;//�ָ�
       
       #25 host = 1;
       #29 people = 4'b0001;//1��ѡ������
       #36 people = 4'b0011;//2��ѡ�ּ�������������Ч
       #40 people = 4'b1000;//4��ѡ������������Ч
       #43 people = 4'b0000;
       #47 isWrong = 1;//�ж�Ϊ���
       #53 isWrong = 1;
       #53 host = 0;
       
       #60 host = 1;
       #65 people = 4'b0010;//2������
       #69 isWrong = 1;//�ش����
       #74 host = 0;
       #74 people = 0;
       #74 isWrong = 0;
       
       #80 host = 1;
       #86 people = 4'b0010;//2������
       #90 isRight = 1;//�ش���ȷ
       #98 isRight = 0;
       #98 people = 4'b0000;
       #110 host = 0;
       
       #120 host = 1;
       #130 people = 4'b0010;//2������
       #140 isRight = 1;//�ش���ȷ
       #150 isRight = 0;
       #160 people = 4'b0000;
       #170 host = 0;
       
        #180 host = 1;
        #190 people = 4'b0010;//2������
        #200 isRight = 1;//�ش���ȷ
        #210 isRight = 0;
        #220 people = 4'b0000;
        #230 host = 0;
        
        #240 host = 1;
        #250 people = 4'b0010;//2������
        #260 isRight = 1;//�ش���ȷ
        #270 isRight = 0;
        #280 people = 4'b0000;
        #290 host = 0;
                 
    join
    
    
    
    
    
endmodule
