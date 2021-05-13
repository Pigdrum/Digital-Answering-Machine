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

//����ģ��
module Main(
   input[3:0] row,
   output[3:0] col,
   
   input resetButton,//�͵�Ƶ��Ч
   input reviewButton, //���븴��ģʽ���ߵ�Ƶ��Ч
   input host, //�����˰������ߵ�Ƶ��Ч
   input isRight, //�����˾����Ƿ���ȷ���ߵ�Ƶ��Ч
   input isWrong, //�����˾����Ƿ���󣬸ߵ�Ƶ��Ч
   input[3:0] people,//ѡ�����𰴼����ߵ�Ƶ��Ч��������
   input clk,//ϵͳʱ���ź�

   output[7:0] seg_out,//�߶��������ʾ,�͵�Ƶ��Ч
   output[7:0] seg_en, //�߶������ʹ�ܣ��͵�Ƶ��Ч
   output ring, //�ߵ�Ƶ��Ч
   output[3:0] led//ѡ��ǰ��led�ƣ��ߵ�Ƶ��Ч
);
   
 
   reg[2:0] process_state;//000---��ʼ   001---����   010---������ʼ   011---���˻�ʤ   100---����
   reg[2:0] next_process_state;
   wire[3:0] max;//��ʾ���ʤ�����ˣ�������
   wire isWin;//�Ƿ�����ʤ���ˣ��ߵ�Ƶ��Ч
   wire[3:0]lock_set_people;//������������ ��������
   wire[7:0]lock_set_time;//��������ʱ�䣬������
   wire[3:0]lock_set_gain;//�������õ÷֣�������
   wire[3:0]lock_set_lose;//��������ʧ�֣�������
   
   wire[3:0]lock_people;//��������������������
   wire isFoul;//�Ƿ񷸹棬�ߵ�Ƶ��Ч
   
   //���63�غ�,���ÿһ�غϵ÷���� �ͱ���01��ʾ�÷֣�10��ʾʧ�֣�00��ʾ���Ӳ���
   //ÿ�����ش洢һ��
   wire[127:0]people_one;//ѡ��1                                       
   wire[127:0]people_two;//ѡ��2
   wire[127:0]people_three;//ѡ��3
   wire[127:0]people_four;//ѡ��4
   
   //��ÿλѡ�������븺�֣������ƴ洢
   wire[7:0]positive_scores1;//ѡ��1����
   wire[7:0]negtive_scores1;//ѡ��1���֣���ͬ
   wire[7:0]positive_scores2;
   wire[7:0]negtive_scores2;
   wire[7:0]positive_scores3;
   wire[7:0]negtive_scores3;
   wire[7:0]positive_scores4;
   wire[7:0]negtive_scores4;
   
   wire [1:0]isAdd;//����ɹ�ѡ�ֵ÷������01��ʾʧ�֣�10��ʾ�÷֣�00��ʾδ�ж�
   wire[7:0]roundNumber;//������
   wire[2:0] state;//״̬��������
   wire isOverTime;//1�ǳ�ʱ    0��δ��ʱ
   wire clk_state;//״̬��ʱ��
   parameter s1 = 3'b001,s2 = 3'b010,s3 = 3'b011,s4 = 3'b100;
   
   Divide3 uuu(clk,resetButton,clk_state);//��״̬��Ƶ������ÿ��״̬���л�ǰ�ܹ��������书��
   
   wire set_done;//��ʾ������ɣ���������׶Σ��ߵ�Ƶ��Ч
   wire[2:0] participants_number;//���ò���������������
   wire [2:0]total_stage_number;//���ý׶ε���״̬��������
   wire[2:0]this_stage_number;//���ý׶εĵ���״̬��������
       
   decodePeople de(participants_number,resetButton,lock_set_people);//�������Ƶ�����תΪ������������ʽ
   
   
   //�ܵ�״̬��
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
   
   
   //����ģ��
   setting u_setting(clk,resetButton,row,
                    col,participants_number,lock_set_time,lock_set_gain,lock_set_lose,set_done,          
                    total_stage_number,this_stage_number
                    );
   
   //����ģ��
   BeginState u3(clk,resetButton,state,isOverTime,lock_set_people&people,lock_set_gain,lock_set_lose,host,isRight,isWrong,
       positive_scores1,positive_scores2,positive_scores3,positive_scores4,
       negtive_scores1,negtive_scores2,negtive_scores3,negtive_scores4,//input
     lock_people,isWin,isFoul,isAdd,max);//output
     
   //������ģ��
   Ring uuuu(clk,state,resetButton,host,lock_people,isFoul,ring);
   
   //����ģ��
   Scores score(clk,resetButton,state,isAdd,lock_people,lock_set_gain,lock_set_lose, 
   people_one,people_two,people_three,people_four,
   positive_scores1,negtive_scores1,positive_scores2,negtive_scores2,positive_scores3,negtive_scores3,positive_scores4,negtive_scores4,roundNumber);
   
   //��ʾģ��
   show u4(clk,state,resetButton,lock_people,positive_scores1,positive_scores2,positive_scores3,positive_scores4,max,roundNumber,
   people_one,people_two,people_three,people_four,
   participants_number,lock_set_time,total_stage_number,this_stage_number,
   negtive_scores1,negtive_scores2,negtive_scores3,negtive_scores4,isFoul,lock_set_time,host,isAdd,lock_set_gain,lock_set_lose,//input
   seg_out,seg_en,led,isOverTime);
   
   
endmodule
