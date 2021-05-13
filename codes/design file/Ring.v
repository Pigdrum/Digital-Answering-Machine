`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/23 23:23:40
// Design Name: 
// Module Name: Ring
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

//ģ�鹦�ܣ����Ʒ���������
module Ring(input clk,input[2:0] state,input rst,input host,input[3:0] lock_people,input isFoul,output reg ring);
   wire[2:0] select;//������״̬
   reg[15:0] time_end;//��������Ƶ
   
   //����ѡ�������ز���
   reg [3:0]delay_ringPeople1;
   reg[3:0]delay_ringPeople2;
   reg ringSelect;

   //�����������ز���
   reg delay_ringHost1;
   reg delay_ringHost2;
   reg selectRing_host;
   
   
   wire clk_out; 
   Divide3_begin u2(clk,rst,clk_out);//����ʱ��
   
   assign select = {selectRing_host,ringSelect,isFoul};
    
    //����
    always@(posedge clk_out,negedge rst)
     begin
        if(!rst)begin
           delay_ringPeople1 <= 0;
           delay_ringPeople2 <= 0;
           delay_ringHost1 <= 0;
           delay_ringHost2 <= 0;
           selectRing_host = 0;
           ringSelect = 0;
        end
        else if(state==3'b010)
        begin
           delay_ringPeople1 <= lock_people;
           delay_ringPeople2 <= delay_ringPeople1;
           delay_ringHost1 <= host;
           delay_ringHost2 <= delay_ringHost1;
           if(host&~delay_ringHost2)selectRing_host = 1;
           else selectRing_host = 0;
           if((lock_people)&&(!delay_ringPeople2))ringSelect = 1;
           else ringSelect = 0;
        end
        else begin
           delay_ringPeople1 <= 0;
           delay_ringPeople2 <= 0;
           delay_ringHost1 <= 0;
           delay_ringHost2 <= 0;
           selectRing_host = 0;
           ringSelect = 0;
        end
     end
     
   //����������Ƶ��
   always@(select)
      begin
         if(select[0] == 1)time_end = 16'd19181;//���˷���
         else if(select[1] == 1)time_end = 16'd15408;//��������
         else if(select[2] == 1)time_end = 16'd27000;
         else time_end = 16'd65535;
      end 
   reg [17:0] time_cnt;
   //��������ʹ��ʱ�����������ռ�����ֵ����Ƶϵ��������
   always@(posedge clk or negedge rst) begin
          if(!rst) begin
              time_cnt <= 1'b0;
          end else if(!select) begin
              time_cnt <= 1'b0;
          end else if(time_cnt>=time_end) begin
              time_cnt <= 1'b0;
          end else begin
              time_cnt <= time_cnt + 1'b1;
          end
      end
   //���ݼ����������ڣ���ת�����������ź�
      always@(posedge clk or negedge rst) begin
          if(!rst) begin
              ring <= 1'b0;
          end else if(time_cnt==time_end) begin
              ring <= ~ring;    //���������������ת�����η�תΪ1Hz
          end else begin
              ring <= ring;
          end
      end

endmodule
