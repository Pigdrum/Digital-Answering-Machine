`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/15 13:31:22
// Design Name: 
// Module Name: show2
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

/*
���߶��������ʾ���н׶ε�����
*/
module show(
   input clk,
   input [2:0]state,
   input resetButton,
   input[3:0]lock_people,
   
   input [7:0]positive_scores1, input [7:0]positive_scores2, input [7:0]positive_scores3, input [7:0]positive_scores4,
   input[3:0]max,
   input [7:0]round,
   input[127:0]people_one,input[127:0]people_two,input[127:0]people_three,input[127:0]people_four,
   
   input[2:0]participants_number,
   input[7:0]total_times,
   input[2:0]total_stage_number,input[2:0]this_stage_number,
   
   input[7:0]negtive_scores1, input[7:0]negtive_scores2, input[7:0]negtive_scores3, input[7:0]negtive_scores4,
   input isFoul,
   input[7:0] lock_set_time,
   input host,
   input[1:0]isAdd,
   input[3:0]lock_set_gain,input[3:0]lock_set_lose,
   
   output reg[7:0]seg_out,
   output reg[7:0]seg_en,
   output[3:0]led,
   output reg isOverTime
   );
   
   reg[1:0] people_count;//����׶�ѡ�֣�������
   reg[1:0] people_count2;//ʤ��չʾ�׶�ѡ�֣�������
   reg[1:0] people_count3;//���˽׶�ѡ�֣�������
   reg[2:0]seg_count;//�߶�����ܵڼ�����ʾ
   reg[7:0] remainTime;//ʣ��ʱ��
   reg isShow;//��3�׶εı��������Ϊ1�Ļ��Ѿ�������չʾ��ȫ
   reg[7:0]currentRound;//round - ��ǰ����
   reg [127:0]people1;//���ĵ�2����λ���1��ѡ�ֵ�ǰ�÷�״̬
   reg [127:0]people2;
   reg [127:0]people3;
   reg [127:0]people4;
   
   wire clk_seg,clk_out;//�ֱ�Ϊ�߶������ѡ�ĸ��ķ�Ƶ��1s�ķ�Ƶ
   wire[7:0] bcd_currentRound;//ת��Ϊbcd��
   wire[7:0] bcd_remainTime;
   wire[7:0] currentRound1 = currentRound;
   wire[7:0] remain = remainTime;
   //ʵ�ʵ÷֣���������֣�
   wire [7:0]pos1_neg1 = positive_scores1 - negtive_scores1;
   wire [7:0]pos2_neg2 = positive_scores2 - negtive_scores2;
   wire [7:0]pos3_neg3 = positive_scores3 - negtive_scores3;
   wire [7:0]pos4_neg4 = positive_scores4 - negtive_scores4;
   //ʵ�ʵ÷֣�����Ǹ��֣�
   wire [7:0]neg1_pos1 = negtive_scores1 - positive_scores1;
   wire [7:0]neg2_pos2 = negtive_scores2 - positive_scores2;
   wire [7:0]neg3_pos3 = negtive_scores3 - positive_scores3;
   wire [7:0]neg4_pos4 = negtive_scores4 - positive_scores4;
   
   wire [7:0]bcd_pos1_neg1;
   wire [7:0]bcd_pos2_neg2;
   wire [7:0]bcd_pos3_neg3;
   wire [7:0]bcd_pos4_neg4;
   wire [7:0]bcd_neg1_pos1;
   wire [7:0]bcd_neg2_pos2;
   wire [7:0]bcd_neg3_pos3;
   wire [7:0]bcd_neg4_pos4;
   
   //��8���صĶ�������ת��Ϊbcd�룬�Է�����ʾ�׶ΰѶ�λʮ��������ʾ���߶��������
   binaryToBCD time1(remain,bcd_remainTime);
   binaryToBCD subs11(pos1_neg1,bcd_pos1_neg1);
   binaryToBCD subs12(pos2_neg2,bcd_pos2_neg2);
   binaryToBCD subs13(pos3_neg3,bcd_pos3_neg3);
   binaryToBCD subs14(pos4_neg4,bcd_pos4_neg4);
   binaryToBCD subs21(neg1_pos1,bcd_neg1_pos1);
   binaryToBCD subs22(neg2_pos2,bcd_neg2_pos2);
   binaryToBCD subs23(neg3_pos3,bcd_neg3_pos3);
   binaryToBCD subs24(neg4_pos4,bcd_neg4_pos4);
   binaryToBCD round1((round-currentRound1) , bcd_currentRound);
   
   //led����ʾ������߷����ѡ��ǰ�ĵ�
   assign led = lock_people;
   
    Divide2 uu(clk,resetButton,clk_out);//1s��������ʱ�ͺ������ʾʹ��
    Divide u0(clk,resetButton,clk_seg);//���߶������ѡ����һ��
   
   always@(posedge clk_out,negedge resetButton) begin
     if(!resetButton) begin
        people_count = 0;//��ʼ��1��
        people_count2 <= 2'd0;
        people_count3 <= 2'd0;
        
        remainTime = lock_set_time;
        isOverTime = 1'b0;
        
        isShow <= 1'b0;//ǰ�ĸ��Ƿ���ʾ���
        
        currentRound <= round - 1;
     end
     //����׶�
     else if(state == 3'b010)
        begin
        //������ʾÿ���˷���
         if(!host)begin
            remainTime = lock_set_time;
            if(people_count ==2'd3)people_count=0;
            else people_count = people_count+1;
         end
         //����ʱ
         else begin
            people_count=0;
            //��ʱ
            if(remain == 8'd0)begin
               remainTime = remainTime;
               isOverTime = 1'b1;
            end
            //��������
            else if(lock_people) begin
               remainTime = remainTime;
               isOverTime = 1'b0;
            end
            //û������
            else begin
               isOverTime = 1'b0;
               remainTime = remainTime-1;
            end
         end
      end
      //ʤ��չʾ�׶Σ�������ʾÿ�����ܷ֣�ͣ�������һ����
     else if(state == 3'b011)
     begin
         people_count3 <= 2'd0;//��ʼ��review�׶�
         currentRound <= round - 1;//��ʼ��review�׶�
         //չʾ��ϣ���ʾʤ��ѡ��
         if(isShow == 1'b1)begin
            case(max)
                4'b0001:people_count2 = 2'd0;
                4'b0010:people_count2 = 2'd1;
                4'b0100:people_count2 = 2'd2;
                default:people_count2 = 2'd3;
            endcase
         end
         //������
         else if(people_count2 == 2'd3)
            isShow<=1'b1;
         else people_count2 <= people_count2+1;
     end
     //���˽׶�
      else if(state == 3'b100)
      begin
      //��ʼ��ʤ���׶�
          people_count2 <= 2'd0;
          isShow<=1'b0;
         //���һ��
         if(!currentRound)begin
            //ģ4������
            if(people_count3 == 2'd3)begin
                people_count3 <= 2'd0;
                currentRound <= round - 1;
            end
            else begin
                people_count3 <= people_count3 + 1;
            end
         end
         //ģ4������
         else if(people_count3 == 2'd3)begin
            currentRound <= currentRound - 1;
            people_count3 <= 2'd0;
         end
         else begin
            people_count3 <= people_count3 + 1;
         end    
      end
   end
   
   always@(currentRound,state)
   begin
      case(state)
      //ʤ���׶�review�׶�
      3'b011:begin
                people1 = people_one >> 2 * ( round - 1 );
                people2 = people_two >> 2 * ( round - 1 );
                people3 = people_three >> 2 * ( round - 1 );
                people4 = people_four>> 2 * ( round - 1 );
             end
      //review�׶Σ�������ʾÿ���˵÷�
      3'b100:begin
                people1 = ( people_one >> ( 2 * currentRound ) );
                people2 = ( people_two >> ( 2 * currentRound ) );
                people3 = ( people_three >> ( 2 * currentRound ) );
                people4 = ( people_four >> ( 2 * currentRound ) );  
             end
       //�����׶�
       default:begin
               people1 = 0;
               people2 = 0;
               people3 = 0;
               people4 = 0;
               end
       endcase         
   end
   
   //�߶������ʹ�ܵ�ѡ��
   always@(posedge clk_seg,negedge resetButton)begin
      if(!resetButton)begin 
            seg_count = 0;
      end
      else begin 
      case(state) 
          3'b001:
              begin
                 if(seg_count == 3'd7) seg_count = 0;
                 else seg_count = seg_count + 1;
              end
           3'b010:
               begin
                  if(seg_count == 3'd7) seg_count = 0;
                  else seg_count = seg_count + 1;
               end
          3'b011:
               begin
                 if(seg_count == 3'd5) seg_count = 0;
                 else seg_count = seg_count + 1;
              end    
          3'b100:      
              begin
                 if(seg_count == 3'd6)seg_count = 0;
                 else seg_count = seg_count + 1;
              end
          default:seg_count = 8'd0;
          endcase
      end
   end
  //�߶������ʹ��
   always@(seg_count)begin
      if(!resetButton)seg_en = 8'b1111_1111;
      else
      begin
         case(seg_count)
            3'd0:seg_en = 8'b1111_1110;
            3'd1:seg_en = 8'b1111_1101;
            3'd2:seg_en = 8'b1111_1011;
            3'd3:seg_en = 8'b1111_0111;
            3'd4:seg_en = 8'b1110_1111;
            3'd5:seg_en = 8'b1101_1111;
            3'd6:seg_en = 8'b1011_1111;
            3'd7:seg_en = 8'b0111_1111;
            default:seg_en = 8'b0000_0000;
         endcase
      end
   end

    parameter ZERO = 8'b1100_0000; // display 0
    parameter ONE = 8'b1111_1001;
    parameter TWO = 8'b1010_0100;
    parameter THREE = 8'b1011_0000;
    parameter FOUR = 8'b1001_1001;
    parameter FIVE = 8'b1001_0010;
    parameter SIX = 8'b1000_0010;
    parameter SEVEN = 8'b1111_1000;
    parameter EIGHT = 8'b1000_0000;
    parameter NINE = 8'b1001_0000; // display 9
    parameter NULL = 8'b1011_1111; // display -
    parameter NOTHING = 8'b1111_1111;  // display nothing
    
    
   
   always@(seg_count,host,lock_people,isFoul,isAdd,resetButton,state,
   positive_scores1,positive_scores2,positive_scores3,positive_scores4,
   negtive_scores1,negtive_scores2,negtive_scores3,negtive_scores4)
   begin
   case(state)
    3'b010:
     begin
      case(seg_count)
         3'd0:seg_out = 8'b1010_0100;
         3'd1:begin
                 case(bcd_remainTime[7:4])
                    4'd0:seg_out = 8'b1100_0000;
                    4'd1:seg_out = 8'b1111_1001;
                    4'd2:seg_out = 8'b1010_0100;
                    4'd3:seg_out = 8'b1011_0000;
                    4'd4:seg_out = 8'b1001_1001;
                    4'd5:seg_out = 8'b1001_0010;
                    4'd6:seg_out = 8'b1000_0010;
                    4'd7:seg_out = 8'b1111_1000;
                    4'd8:seg_out = 8'b1000_0000;
                    4'd9:seg_out = 8'b1001_0000;
                    default:seg_out = 8'b1011_1111;
                 endcase
              end
         3'd2:begin 
                 case(bcd_remainTime[3:0])
                    4'd0:seg_out = 8'b1100_0000;
                    4'd1:seg_out = 8'b1111_1001;
                    4'd2:seg_out = 8'b1010_0100;
                    4'd3:seg_out = 8'b1011_0000;
                    4'd4:seg_out = 8'b1001_1001;
                    4'd5:seg_out = 8'b1001_0010;
                    4'd6:seg_out = 8'b1000_0010;
                    4'd7:seg_out = 8'b1111_1000;
                    4'd8:seg_out = 8'b1000_0000;
                    4'd9:seg_out = 8'b1001_0000;
                    default:seg_out = 8'b1011_1111;
                 endcase                 
              end 
         3'd3:begin
                 if(!host&&!isFoul)begin
                    case(people_count)
                       2'd0:seg_out = 8'b1111_1001;
                       2'd1:seg_out = 8'b1010_0100;
                       2'd2:seg_out = 8'b1011_0000;
                       2'd3:seg_out = 8'b1001_1001;
                       default:seg_out = 8'b1100_0000;
                    endcase
                 end
                 else begin
                    case(lock_people)
                       4'b0001:seg_out = 8'b1111_1001;
                       4'b0010:seg_out = 8'b1010_0100;
                       4'b0100:seg_out = 8'b1011_0000;
                       4'b1000:seg_out = 8'b1001_1001;
                       default:seg_out = 8'b1100_0000;
                    endcase
                 end
              end 
         3'd4:seg_out = 8'b1111_0110;
         3'd5:begin
                 if(!host&&!isFoul)begin//û��������
                    case(people_count)
                       2'd0:begin
                               if(positive_scores1>=negtive_scores1)seg_out = 8'b1100_0000;
                               else seg_out = 8'b1011_1111;
                            end
                       2'd1:begin 
                               if(positive_scores2>=negtive_scores2)seg_out = 8'b1100_0000;
                               else seg_out = 8'b1011_1111;  
                            end
                       2'd2:begin 
                               if(positive_scores3>=negtive_scores3)seg_out = 8'b1100_0000;
                               else seg_out = 8'b1011_1111;  
                            end
                       2'd3:begin 
                               if(positive_scores4>=negtive_scores4)seg_out = 8'b1100_0000;
                               else seg_out = 8'b1011_1111;  
                            end
                       default:seg_out = 8'b1100_1111;
                    endcase
                 end
                 else if(isFoul)seg_out = 8'b1011_1111;
                 else begin
                    if(!isAdd[0]) seg_out = 8'b1100_0000;
                    else seg_out = 8'b1011_1111;
                 end
              end
         3'd6:begin
                 if(!host&&!isFoul)begin//û���˷���
                    case(people_count)//������ʾÿ���˵�ǰ�÷�
                       2'd0:begin
                          if(positive_scores1>=negtive_scores1)begin
                             case(bcd_pos1_neg1[7:4])
                                4'd0:seg_out = 8'b1100_0000;
                                4'd1:seg_out = 8'b1111_1001;
                                4'd2:seg_out = 8'b1010_0100;
                                4'd3:seg_out = 8'b1011_0000;
                                4'd4:seg_out = 8'b1001_1001;
                                4'd5:seg_out = 8'b1001_0010;
                                4'd6:seg_out = 8'b1000_0010;
                                4'd7:seg_out = 8'b1111_1000;
                                4'd8:seg_out = 8'b1000_0000;
                                4'd9:seg_out = 8'b1001_0000;
                                default:seg_out = 8'b1011_1111;
                             endcase                                  
                          end
                          else begin
                             case(bcd_neg1_pos1[7:4])
                                4'd0:seg_out = 8'b1100_0000;
                                4'd1:seg_out = 8'b1111_1001;
                                4'd2:seg_out = 8'b1010_0100;
                                4'd3:seg_out = 8'b1011_0000;
                                4'd4:seg_out = 8'b1001_1001;
                                4'd5:seg_out = 8'b1001_0010;
                                4'd6:seg_out = 8'b1000_0010;
                                4'd7:seg_out = 8'b1111_1000;
                                4'd8:seg_out = 8'b1000_0000;
                                4'd9:seg_out = 8'b1001_0000;
                                default:seg_out = 8'b1011_1111;                          
                             endcase                                  
                          end
                       end
                       2'd1:begin
                               if(positive_scores2>=negtive_scores2)begin
                                  case(bcd_pos2_neg2[7:4])
                                     4'd0:seg_out = 8'b1100_0000;
                                     4'd1:seg_out = 8'b1111_1001;
                                     4'd2:seg_out = 8'b1010_0100;
                                     4'd3:seg_out = 8'b1011_0000;
                                     4'd4:seg_out = 8'b1001_1001;
                                     4'd5:seg_out = 8'b1001_0010;
                                     4'd6:seg_out = 8'b1000_0010;
                                     4'd7:seg_out = 8'b1111_1000;
                                     4'd8:seg_out = 8'b1000_0000;
                                     4'd9:seg_out = 8'b1001_0000;
                                     default:seg_out = 8'b1011_1111;
                                  endcase                                  
                               end
                               else begin
                                  case(bcd_neg2_pos2[7:4])
                                     4'd0:seg_out = 8'b1100_0000;
                                     4'd1:seg_out = 8'b1111_1001;
                                     4'd2:seg_out = 8'b1010_0100;
                                     4'd3:seg_out = 8'b1011_0000;
                                     4'd4:seg_out = 8'b1001_1001;
                                     4'd5:seg_out = 8'b1001_0010;
                                     4'd6:seg_out = 8'b1000_0010;
                                     4'd7:seg_out = 8'b1111_1000;
                                     4'd8:seg_out = 8'b1000_0000;
                                     4'd9:seg_out = 8'b1001_0000;
                                     default:seg_out = 8'b1011_1111;                          
                                  endcase                                  
                               end
                            end
                       2'd2:begin 
                          if(positive_scores3>=negtive_scores3)begin
                                  case(bcd_pos3_neg3[7:4])
                                     4'd0:seg_out = 8'b1100_0000;
                                     4'd1:seg_out = 8'b1111_1001;
                                     4'd2:seg_out = 8'b1010_0100;
                                     4'd3:seg_out = 8'b1011_0000;
                                     4'd4:seg_out = 8'b1001_1001;
                                     4'd5:seg_out = 8'b1001_0010;
                                     4'd6:seg_out = 8'b1000_0010;
                                     4'd7:seg_out = 8'b1111_1000;
                                     4'd8:seg_out = 8'b1000_0000;
                                     4'd9:seg_out = 8'b1001_0000;
                                     default:seg_out = 8'b1011_1111;                          
                                  endcase                             
                          
                          end
                          else begin 
                             case(bcd_neg3_pos3[7:4])
                                 4'd0:seg_out = 8'b1100_0000;
                                 4'd1:seg_out = 8'b1111_1001;
                                 4'd2:seg_out = 8'b1010_0100;
                                 4'd3:seg_out = 8'b1011_0000;
                                 4'd4:seg_out = 8'b1001_1001;
                                 4'd5:seg_out = 8'b1001_0010;
                                 4'd6:seg_out = 8'b1000_0010;
                                 4'd7:seg_out = 8'b1111_1000;
                                 4'd8:seg_out = 8'b1000_0000;
                                 4'd9:seg_out = 8'b1001_0000;
                                 default:seg_out = 8'b1011_1111;                          
                             endcase           
                          end  
                       end
                       2'd3:begin
                           if(positive_scores4>=negtive_scores4)begin
                              case(bcd_pos4_neg4[7:4])
                                 4'd0:seg_out = 8'b1100_0000;
                                 4'd1:seg_out = 8'b1111_1001;
                                 4'd2:seg_out = 8'b1010_0100;
                                 4'd3:seg_out = 8'b1011_0000;
                                 4'd4:seg_out = 8'b1001_1001;
                                 4'd5:seg_out = 8'b1001_0010;
                                 4'd6:seg_out = 8'b1000_0010;
                                 4'd7:seg_out = 8'b1111_1000;
                                 4'd8:seg_out = 8'b1000_0000;
                                 4'd9:seg_out = 8'b1001_0000;
                                 default:seg_out = 8'b1011_1111;                          
                              endcase                                                        
                           end
                        else begin 
                           case(bcd_neg4_pos4[7:4])
                              4'd0:seg_out = 8'b1100_0000;
                              4'd1:seg_out = 8'b1111_1001;
                              4'd2:seg_out = 8'b1010_0100;
                              4'd3:seg_out = 8'b1011_0000;
                              4'd4:seg_out = 8'b1001_1001;
                              4'd5:seg_out = 8'b1001_0010;
                              4'd6:seg_out = 8'b1000_0010;
                              4'd7:seg_out = 8'b1111_1000;
                              4'd8:seg_out = 8'b1000_0000;
                              4'd9:seg_out = 8'b1001_0000;
                              default:seg_out = 8'b1011_1111;                          
                            endcase           
                        end   
                       end
                       default:seg_out = 8'b1100_1111;
                    endcase
                 end
                 else if(isFoul)seg_out = 8'b1011_1111;
                 else seg_out = 8'b1100_0000;
              end
         3'd7:begin
               if(!host&&!isFoul)begin//û��������
                  case(people_count)//������ʾÿ���˵�ǰ�÷�
                     2'd0:begin
                        if(positive_scores1>=negtive_scores1)begin
                           case(bcd_pos1_neg1[3:0])
                              4'd0:seg_out = 8'b1100_0000;
                              4'd1:seg_out = 8'b1111_1001;
                              4'd2:seg_out = 8'b1010_0100;
                              4'd3:seg_out = 8'b1011_0000;
                              4'd4:seg_out = 8'b1001_1001;
                              4'd5:seg_out = 8'b1001_0010;
                              4'd6:seg_out = 8'b1000_0010;
                              4'd7:seg_out = 8'b1111_1000;
                              4'd8:seg_out = 8'b1000_0000;
                              4'd9:seg_out = 8'b1001_0000;
                              default:seg_out = 8'b1011_1111;
                           endcase                                  
                        end
                        else begin
                           case(bcd_neg1_pos1[3:0])
                              4'd0:seg_out = 8'b1100_0000;
                              4'd1:seg_out = 8'b1111_1001;
                              4'd2:seg_out = 8'b1010_0100;
                              4'd3:seg_out = 8'b1011_0000;
                              4'd4:seg_out = 8'b1001_1001;
                              4'd5:seg_out = 8'b1001_0010;
                              4'd6:seg_out = 8'b1000_0010;
                              4'd7:seg_out = 8'b1111_1000;
                              4'd8:seg_out = 8'b1000_0000;
                              4'd9:seg_out = 8'b1001_0000;
                              default:seg_out = 8'b1011_1111;                          
                           endcase                                  
                        end
                     end
                     2'd1:begin
                             if(positive_scores2>=negtive_scores2)begin
                                case(bcd_pos2_neg2[3:0])
                                   4'd0:seg_out = 8'b1100_0000;
                                   4'd1:seg_out = 8'b1111_1001;
                                   4'd2:seg_out = 8'b1010_0100;
                                   4'd3:seg_out = 8'b1011_0000;
                                   4'd4:seg_out = 8'b1001_1001;
                                   4'd5:seg_out = 8'b1001_0010;
                                   4'd6:seg_out = 8'b1000_0010;
                                   4'd7:seg_out = 8'b1111_1000;
                                   4'd8:seg_out = 8'b1000_0000;
                                   4'd9:seg_out = 8'b1001_0000;
                                   default:seg_out = 8'b1011_1111;
                                endcase                                  
                             end
                             else begin
                                case(bcd_neg2_pos2[3:0])
                                   4'd0:seg_out = 8'b1100_0000;
                                   4'd1:seg_out = 8'b1111_1001;
                                   4'd2:seg_out = 8'b1010_0100;
                                   4'd3:seg_out = 8'b1011_0000;
                                   4'd4:seg_out = 8'b1001_1001;
                                   4'd5:seg_out = 8'b1001_0010;
                                   4'd6:seg_out = 8'b1000_0010;
                                   4'd7:seg_out = 8'b1111_1000;
                                   4'd8:seg_out = 8'b1000_0000;
                                   4'd9:seg_out = 8'b1001_0000;
                                   default:seg_out = 8'b1011_1111;                          
                                endcase                                  
                             end
                          end
                     2'd2:begin 
                        if(positive_scores3>=negtive_scores3)begin
                                case(bcd_pos3_neg3[3:0])
                                   4'd0:seg_out = 8'b1100_0000;
                                   4'd1:seg_out = 8'b1111_1001;
                                   4'd2:seg_out = 8'b1010_0100;
                                   4'd3:seg_out = 8'b1011_0000;
                                   4'd4:seg_out = 8'b1001_1001;
                                   4'd5:seg_out = 8'b1001_0010;
                                   4'd6:seg_out = 8'b1000_0010;
                                   4'd7:seg_out = 8'b1111_1000;
                                   4'd8:seg_out = 8'b1000_0000;
                                   4'd9:seg_out = 8'b1001_0000;
                                   default:seg_out = 8'b1011_1111;                          
                                endcase                             
                        
                        end
                        else begin 
                           case(bcd_neg3_pos3[3:0])
                               4'd0:seg_out = 8'b1100_0000;
                               4'd1:seg_out = 8'b1111_1001;
                               4'd2:seg_out = 8'b1010_0100;
                               4'd3:seg_out = 8'b1011_0000;
                               4'd4:seg_out = 8'b1001_1001;
                               4'd5:seg_out = 8'b1001_0010;
                               4'd6:seg_out = 8'b1000_0010;
                               4'd7:seg_out = 8'b1111_1000;
                               4'd8:seg_out = 8'b1000_0000;
                               4'd9:seg_out = 8'b1001_0000;
                               default:seg_out = 8'b1011_1111;                          
                           endcase           
                        end  
                     end
                     2'd3:begin
                         if(positive_scores4>=negtive_scores4)begin
                            case(bcd_pos4_neg4[3:0])
                               4'd0:seg_out = 8'b1100_0000;
                               4'd1:seg_out = 8'b1111_1001;
                               4'd2:seg_out = 8'b1010_0100;
                               4'd3:seg_out = 8'b1011_0000;
                               4'd4:seg_out = 8'b1001_1001;
                               4'd5:seg_out = 8'b1001_0010;
                               4'd6:seg_out = 8'b1000_0010;
                               4'd7:seg_out = 8'b1111_1000;
                               4'd8:seg_out = 8'b1000_0000;
                               4'd9:seg_out = 8'b1001_0000;
                               default:seg_out = 8'b1011_1111;                          
                            endcase                                                        
                         end
                      else begin 
                         case(bcd_neg4_pos4[3:0])
                            4'd0:seg_out = 8'b1100_0000;
                            4'd1:seg_out = 8'b1111_1001;
                            4'd2:seg_out = 8'b1010_0100;
                            4'd3:seg_out = 8'b1011_0000;
                            4'd4:seg_out = 8'b1001_1001;
                            4'd5:seg_out = 8'b1001_0010;
                            4'd6:seg_out = 8'b1000_0010;
                            4'd7:seg_out = 8'b1111_1000;
                            4'd8:seg_out = 8'b1000_0000;
                            4'd9:seg_out = 8'b1001_0000;
                            default:seg_out = 8'b1011_1111;                          
                          endcase           
                      end   
                     end
                     default:seg_out = 8'b1101_1111;
                  endcase
               end
               else if(isFoul)seg_out = 8'b1011_1111;
               else begin
                  if(!isAdd)seg_out = 8'b1100_0000;
                  else if(isAdd[1])begin
                     case(lock_set_gain)
                       4'd1:seg_out = 8'b1111_1001;
                       4'd2:seg_out = 8'b1010_0100;
                       4'd3:seg_out = 8'b1011_0000;
                       4'd4:seg_out = 8'b1001_1001;
                       4'd5:seg_out = 8'b1001_0010;
                       4'd6:seg_out = 8'b1000_0010;
                       4'd7:seg_out = 8'b1111_1000;
                       4'd8:seg_out = 8'b1000_0000;
                       4'd9:seg_out = 8'b1001_0000;
                        default:seg_out = 8'b1100_0000;
                     endcase
                  end
                  else begin
                     case(lock_set_lose)
                        4'd1:seg_out = 8'b1111_1001;
                        4'd2:seg_out = 8'b1010_0100;
                        4'd3:seg_out = 8'b1011_0000;
                        4'd4:seg_out = 8'b1001_1001;
                        4'd5:seg_out = 8'b1001_0010;
                        4'd6:seg_out = 8'b1000_0010;
                        4'd7:seg_out = 8'b1111_1000;
                        4'd8:seg_out = 8'b1000_0000;
                        4'd9:seg_out = 8'b1001_0000;
                        default:seg_out = 8'b1100_0000;
                        endcase
                  end
               end
            end   
         endcase
       end       
    3'b011:begin
    case(seg_count)
     3'd0:seg_out = 8'b1011_0000;
     3'd1:begin
            case(people_count2)//������ʾÿ���˵����
              3'd0:seg_out = 8'b1111_1001;
              3'd1:seg_out = 8'b1010_0100;
              3'd2:seg_out = 8'b1011_0000;
              3'd3:seg_out = 8'b1001_1001;
              default:seg_out = 8'b1100_0000;
            endcase
          end
     3'd2:seg_out = 8'b1111_0110;
     3'd3:begin
            case(people_count2)
                2'd0:begin
                        if(positive_scores1>=negtive_scores1)seg_out = 8'b1100_0000;
                        else seg_out = 8'b1011_1111;
                     end
                2'd1:begin 
                        if(positive_scores2>=negtive_scores2)seg_out = 8'b1100_0000;
                        else seg_out = 8'b1011_1111;  
                     end
                2'd2:begin 
                        if(positive_scores3>=negtive_scores3)seg_out = 8'b1100_0000;
                        else seg_out = 8'b1011_1111;  
                     end
                2'd3:begin 
                        if(positive_scores4>=negtive_scores4)seg_out = 8'b1100_0000;
                        else seg_out = 8'b1011_1111;  
                     end
                default:seg_out = 8'b1100_1111;
            endcase
          end
     3'd4:begin
             case(people_count2)//������ʾÿ���˵�ǰ�÷֣�ʮλ��
                2'd0:begin
                   if(positive_scores1>=negtive_scores1)begin
                      case(bcd_pos1_neg1[7:4])
                         4'd0:seg_out = 8'b1100_0000;
                         4'd1:seg_out = 8'b1111_1001;
                         4'd2:seg_out = 8'b1010_0100;
                         4'd3:seg_out = 8'b1011_0000;
                         4'd4:seg_out = 8'b1001_1001;
                         4'd5:seg_out = 8'b1001_0010;
                         4'd6:seg_out = 8'b1000_0010;
                         4'd7:seg_out = 8'b1111_1000;
                         4'd8:seg_out = 8'b1000_0000;
                         4'd9:seg_out = 8'b1001_0000;
                         default:seg_out = 8'b1011_1111;
                      endcase                                  
                   end
                   else begin
                      case(bcd_neg1_pos1[7:4])
                         4'd0:seg_out = 8'b1100_0000;
                         4'd1:seg_out = 8'b1111_1001;
                         4'd2:seg_out = 8'b1010_0100;
                         4'd3:seg_out = 8'b1011_0000;
                         4'd4:seg_out = 8'b1001_1001;
                         4'd5:seg_out = 8'b1001_0010;
                         4'd6:seg_out = 8'b1000_0010;
                         4'd7:seg_out = 8'b1111_1000;
                         4'd8:seg_out = 8'b1000_0000;
                         4'd9:seg_out = 8'b1001_0000;
                         default:seg_out = 8'b1011_1111;                          
                      endcase                                  
                   end
                end
                2'd1:begin
                        if(positive_scores2>=negtive_scores2)begin
                           case(bcd_pos2_neg2[7:4])
                              4'd0:seg_out = 8'b1100_0000;
                              4'd1:seg_out = 8'b1111_1001;
                              4'd2:seg_out = 8'b1010_0100;
                              4'd3:seg_out = 8'b1011_0000;
                              4'd4:seg_out = 8'b1001_1001;
                              4'd5:seg_out = 8'b1001_0010;
                              4'd6:seg_out = 8'b1000_0010;
                              4'd7:seg_out = 8'b1111_1000;
                              4'd8:seg_out = 8'b1000_0000;
                              4'd9:seg_out = 8'b1001_0000;
                              default:seg_out = 8'b1011_1111;
                           endcase                                  
                        end
                        else begin
                           case(bcd_neg2_pos2[7:4])
                              4'd0:seg_out = 8'b1100_0000;
                              4'd1:seg_out = 8'b1111_1001;
                              4'd2:seg_out = 8'b1010_0100;
                              4'd3:seg_out = 8'b1011_0000;
                              4'd4:seg_out = 8'b1001_1001;
                              4'd5:seg_out = 8'b1001_0010;
                              4'd6:seg_out = 8'b1000_0010;
                              4'd7:seg_out = 8'b1111_1000;
                              4'd8:seg_out = 8'b1000_0000;
                              4'd9:seg_out = 8'b1001_0000;
                              default:seg_out = 8'b1011_1111;                          
                           endcase                                  
                        end
                     end
                2'd2:begin 
                   if(positive_scores3>=negtive_scores3)begin
                           case(bcd_pos3_neg3[7:4])
                              4'd0:seg_out = 8'b1100_0000;
                              4'd1:seg_out = 8'b1111_1001;
                              4'd2:seg_out = 8'b1010_0100;
                              4'd3:seg_out = 8'b1011_0000;
                              4'd4:seg_out = 8'b1001_1001;
                              4'd5:seg_out = 8'b1001_0010;
                              4'd6:seg_out = 8'b1000_0010;
                              4'd7:seg_out = 8'b1111_1000;
                              4'd8:seg_out = 8'b1000_0000;
                              4'd9:seg_out = 8'b1001_0000;
                              default:seg_out = 8'b1011_1111;                          
                           endcase                             
                   
                   end
                   else begin 
                      case(bcd_neg3_pos3[7:4])
                          4'd0:seg_out = 8'b1100_0000;
                          4'd1:seg_out = 8'b1111_1001;
                          4'd2:seg_out = 8'b1010_0100;
                          4'd3:seg_out = 8'b1011_0000;
                          4'd4:seg_out = 8'b1001_1001;
                          4'd5:seg_out = 8'b1001_0010;
                          4'd6:seg_out = 8'b1000_0010;
                          4'd7:seg_out = 8'b1111_1000;
                          4'd8:seg_out = 8'b1000_0000;
                          4'd9:seg_out = 8'b1001_0000;
                          default:seg_out = 8'b1011_1111;                          
                      endcase           
                   end  
                end
                2'd3:begin
                    if(positive_scores4>=negtive_scores4)begin
                       case(bcd_pos4_neg4[7:4])
                          4'd0:seg_out = 8'b1100_0000;
                          4'd1:seg_out = 8'b1111_1001;
                          4'd2:seg_out = 8'b1010_0100;
                          4'd3:seg_out = 8'b1011_0000;
                          4'd4:seg_out = 8'b1001_1001;
                          4'd5:seg_out = 8'b1001_0010;
                          4'd6:seg_out = 8'b1000_0010;
                          4'd7:seg_out = 8'b1111_1000;
                          4'd8:seg_out = 8'b1000_0000;
                          4'd9:seg_out = 8'b1001_0000;
                          default:seg_out = 8'b1011_1111;                          
                       endcase                                                        
                    end
                 else begin 
                    case(bcd_neg4_pos4[7:4])
                       4'd0:seg_out = 8'b1100_0000;
                       4'd1:seg_out = 8'b1111_1001;
                       4'd2:seg_out = 8'b1010_0100;
                       4'd3:seg_out = 8'b1011_0000;
                       4'd4:seg_out = 8'b1001_1001;
                       4'd5:seg_out = 8'b1001_0010;
                       4'd6:seg_out = 8'b1000_0010;
                       4'd7:seg_out = 8'b1111_1000;
                       4'd8:seg_out = 8'b1000_0000;
                       4'd9:seg_out = 8'b1001_0000;
                       default:seg_out = 8'b1011_1111;                          
                     endcase           
                 end   
                end
                default:seg_out = 8'b1100_1111;
             endcase
          end
     3'd5:begin
        case(people_count2)//������ʾÿ���˵�ǰ�÷֣���λ��
           2'd0:begin
              if(positive_scores1>=negtive_scores1)begin
                 case(bcd_pos1_neg1[3:0])
                    4'd0:seg_out = 8'b1100_0000;
                    4'd1:seg_out = 8'b1111_1001;
                    4'd2:seg_out = 8'b1010_0100;
                    4'd3:seg_out = 8'b1011_0000;
                    4'd4:seg_out = 8'b1001_1001;
                    4'd5:seg_out = 8'b1001_0010;
                    4'd6:seg_out = 8'b1000_0010;
                    4'd7:seg_out = 8'b1111_1000;
                    4'd8:seg_out = 8'b1000_0000;
                    4'd9:seg_out = 8'b1001_0000;
                    default:seg_out = 8'b1011_1111;
                 endcase                                  
              end
              else begin
                 case(bcd_neg1_pos1[3:0])
                    4'd0:seg_out = 8'b1100_0000;
                    4'd1:seg_out = 8'b1111_1001;
                    4'd2:seg_out = 8'b1010_0100;
                    4'd3:seg_out = 8'b1011_0000;
                    4'd4:seg_out = 8'b1001_1001;
                    4'd5:seg_out = 8'b1001_0010;
                    4'd6:seg_out = 8'b1000_0010;
                    4'd7:seg_out = 8'b1111_1000;
                    4'd8:seg_out = 8'b1000_0000;
                    4'd9:seg_out = 8'b1001_0000;
                    default:seg_out = 8'b1011_1111;                          
                 endcase                                  
              end
           end
           2'd1:begin
                   if(positive_scores2>=negtive_scores2)begin
                      case(bcd_pos2_neg2[3:0])
                         4'd0:seg_out = 8'b1100_0000;
                         4'd1:seg_out = 8'b1111_1001;
                         4'd2:seg_out = 8'b1010_0100;
                         4'd3:seg_out = 8'b1011_0000;
                         4'd4:seg_out = 8'b1001_1001;
                         4'd5:seg_out = 8'b1001_0010;
                         4'd6:seg_out = 8'b1000_0010;
                         4'd7:seg_out = 8'b1111_1000;
                         4'd8:seg_out = 8'b1000_0000;
                         4'd9:seg_out = 8'b1001_0000;
                         default:seg_out = 8'b1011_1111;
                      endcase                                  
                   end
                   else begin
                      case(bcd_neg2_pos2[3:0])
                         4'd0:seg_out = 8'b1100_0000;
                         4'd1:seg_out = 8'b1111_1001;
                         4'd2:seg_out = 8'b1010_0100;
                         4'd3:seg_out = 8'b1011_0000;
                         4'd4:seg_out = 8'b1001_1001;
                         4'd5:seg_out = 8'b1001_0010;
                         4'd6:seg_out = 8'b1000_0010;
                         4'd7:seg_out = 8'b1111_1000;
                         4'd8:seg_out = 8'b1000_0000;
                         4'd9:seg_out = 8'b1001_0000;
                         default:seg_out = 8'b1011_1111;                          
                      endcase                                  
                   end
                end
           2'd2:begin 
              if(positive_scores3>=negtive_scores3)begin
                      case(bcd_pos3_neg3[3:0])
                         4'd0:seg_out = 8'b1100_0000;
                         4'd1:seg_out = 8'b1111_1001;
                         4'd2:seg_out = 8'b1010_0100;
                         4'd3:seg_out = 8'b1011_0000;
                         4'd4:seg_out = 8'b1001_1001;
                         4'd5:seg_out = 8'b1001_0010;
                         4'd6:seg_out = 8'b1000_0010;
                         4'd7:seg_out = 8'b1111_1000;
                         4'd8:seg_out = 8'b1000_0000;
                         4'd9:seg_out = 8'b1001_0000;
                         default:seg_out = 8'b1011_1111;                          
                      endcase                             
              
              end
              else begin 
                 case(bcd_neg3_pos3[3:0])
                     4'd0:seg_out = 8'b1100_0000;
                     4'd1:seg_out = 8'b1111_1001;
                     4'd2:seg_out = 8'b1010_0100;
                     4'd3:seg_out = 8'b1011_0000;
                     4'd4:seg_out = 8'b1001_1001;
                     4'd5:seg_out = 8'b1001_0010;
                     4'd6:seg_out = 8'b1000_0010;
                     4'd7:seg_out = 8'b1111_1000;
                     4'd8:seg_out = 8'b1000_0000;
                     4'd9:seg_out = 8'b1001_0000;
                     default:seg_out = 8'b1011_1111;                          
                 endcase           
              end  
           end
           2'd3:begin
               if(positive_scores4>=negtive_scores4)begin
                  case(bcd_pos4_neg4[3:0])
                     4'd0:seg_out = 8'b1100_0000;
                     4'd1:seg_out = 8'b1111_1001;
                     4'd2:seg_out = 8'b1010_0100;
                     4'd3:seg_out = 8'b1011_0000;
                     4'd4:seg_out = 8'b1001_1001;
                     4'd5:seg_out = 8'b1001_0010;
                     4'd6:seg_out = 8'b1000_0010;
                     4'd7:seg_out = 8'b1111_1000;
                     4'd8:seg_out = 8'b1000_0000;
                     4'd9:seg_out = 8'b1001_0000;
                     default:seg_out = 8'b1011_1111;                          
                  endcase                                                        
               end
            else begin 
               case(bcd_neg4_pos4[3:0])
                  4'd0:seg_out = 8'b1100_0000;
                  4'd1:seg_out = 8'b1111_1001;
                  4'd2:seg_out = 8'b1010_0100;
                  4'd3:seg_out = 8'b1011_0000;
                  4'd4:seg_out = 8'b1001_1001;
                  4'd5:seg_out = 8'b1001_0010;
                  4'd6:seg_out = 8'b1000_0010;
                  4'd7:seg_out = 8'b1111_1000;
                  4'd8:seg_out = 8'b1000_0000;
                  4'd9:seg_out = 8'b1001_0000;
                  default:seg_out = 8'b1011_1111;                          
                endcase           
            end   
           end
           default:seg_out = 8'b1101_1111;
        endcase
        end
    endcase
    end
    3'b100:begin
       case(seg_count)
          3'd0:seg_out = 8'b1001_1001;
          3'd1:begin
             case(bcd_currentRound[7:4])
                  4'd0:seg_out = 8'b1100_0000;
                  4'd1:seg_out = 8'b1111_1001;
                  4'd2:seg_out = 8'b1010_0100;
                  4'd3:seg_out = 8'b1011_0000;
                  4'd4:seg_out = 8'b1001_1001;
                  4'd5:seg_out = 8'b1001_0010;
                  4'd6:seg_out = 8'b1000_0010;
                  4'd7:seg_out = 8'b1111_1000;
                  4'd8:seg_out = 8'b1000_0000;
                  4'd9:seg_out = 8'b1001_0000;
                  default:seg_out = 8'b1011_1111;
             endcase
          end
          3'd2:begin
             case(bcd_currentRound[3:0])
                4'd0:seg_out = 8'b1100_0000;
                4'd1:seg_out = 8'b1111_1001;
                4'd2:seg_out = 8'b1010_0100;
                4'd3:seg_out = 8'b1011_0000;
                4'd4:seg_out = 8'b1001_1001;
                4'd5:seg_out = 8'b1001_0010;
                4'd6:seg_out = 8'b1000_0010;
                4'd7:seg_out = 8'b1111_1000;
                4'd8:seg_out = 8'b1000_0000;
                4'd9:seg_out = 8'b1001_0000;
                default:seg_out = 8'b1011_1111;
             endcase
          end
          3'd3:begin
             case(people_count3)//������ʾÿ���˵����
                3'd0:seg_out = 8'b1111_1001;
                3'd1:seg_out = 8'b1010_0100;
                3'd2:seg_out = 8'b1011_0000;
                3'd3:seg_out = 8'b1001_1001;
                default:seg_out = 8'b1100_0000;
             endcase
          end
          3'd4:seg_out = 8'b1111_0110;
          3'd5:begin
             case(people_count3)
                3'd0:begin
                       if(people1[1:0]==2'b10)seg_out = 8'b1011_1111;
                       else seg_out = 8'b1100_0000;
                     end
                3'd1:begin
                       if(people2[1:0]==2'b10)seg_out = 8'b1011_1111;
                       else seg_out = 8'b1100_0000;
                     end
                3'd2:begin
                       if(people3[1:0]==2'b10)seg_out = 8'b1011_1111;
                       else seg_out = 8'b1100_0000;
                     end
                3'd3:begin
                       if(people4[1:0]==2'b10)seg_out = 8'b1011_1111;
                       else seg_out = 8'b1100_0000;
                     end
                endcase
              end
          3'd6:begin
             case(people_count3)
               3'd0:begin
                  case(people1[1:0])
                      2'b00:seg_out = 8'b1100_0000;
                      2'b01:begin
                              case(lock_set_gain)
                                4'd1:seg_out = 8'b1111_1001;
                                4'd2:seg_out = 8'b1010_0100;
                                4'd3:seg_out = 8'b1011_0000;
                                4'd4:seg_out = 8'b1001_1001;
                                4'd5:seg_out = 8'b1001_0010;
                                4'd6:seg_out = 8'b1000_0010;
                                4'd7:seg_out = 8'b1111_1000;
                                4'd8:seg_out = 8'b1000_0000;
                                4'd9:seg_out = 8'b1001_0000;
                                 default:seg_out = 8'b1100_0000;
                              endcase
                            end
                      2'b10:begin
                              case(lock_set_lose)
                                4'd1:seg_out = 8'b1111_1001;
                                4'd2:seg_out = 8'b1010_0100;
                                4'd3:seg_out = 8'b1011_0000;
                                4'd4:seg_out = 8'b1001_1001;
                                4'd5:seg_out = 8'b1001_0010;
                                4'd6:seg_out = 8'b1000_0010;
                                4'd7:seg_out = 8'b1111_1000;
                                4'd8:seg_out = 8'b1000_0000;
                                4'd9:seg_out = 8'b1001_0000;
                                default:seg_out = 8'b1100_0000;
                              endcase
                            end
                     default:seg_out = 8'b1011_1111;
                  endcase
               end
               3'd1:begin
                     case(people2[1:0])
                        2'b00:seg_out = 8'b1100_0000;
                        2'b01:begin
                                case(lock_set_gain)
                                  4'd1:seg_out = 8'b1111_1001;
                                  4'd2:seg_out = 8'b1010_0100;
                                  4'd3:seg_out = 8'b1011_0000;
                                  4'd4:seg_out = 8'b1001_1001;
                                  4'd5:seg_out = 8'b1001_0010;
                                  4'd6:seg_out = 8'b1000_0010;
                                  4'd7:seg_out = 8'b1111_1000;
                                  4'd8:seg_out = 8'b1000_0000;
                                  4'd9:seg_out = 8'b1001_0000;
                                   default:seg_out = 8'b1100_0000;
                                endcase
                              end
                        2'b10:begin
                                case(lock_set_lose)
                                  4'd1:seg_out = 8'b1111_1001;
                                  4'd2:seg_out = 8'b1010_0100;
                                  4'd3:seg_out = 8'b1011_0000;
                                  4'd4:seg_out = 8'b1001_1001;
                                  4'd5:seg_out = 8'b1001_0010;
                                  4'd6:seg_out = 8'b1000_0010;
                                  4'd7:seg_out = 8'b1111_1000;
                                  4'd8:seg_out = 8'b1000_0000;
                                  4'd9:seg_out = 8'b1001_0000;
                                  default:seg_out = 8'b1100_0000;
                                endcase
                              end
                        default:seg_out = 8'b1011_1111;
                     endcase
                    end
               3'd2:begin
                     case(people3[1:0])
                         2'b00:seg_out = 8'b1100_0000;
                         2'b01:begin
                                 case(lock_set_gain)
                                   4'd1:seg_out = 8'b1111_1001;
                                   4'd2:seg_out = 8'b1010_0100;
                                   4'd3:seg_out = 8'b1011_0000;
                                   4'd4:seg_out = 8'b1001_1001;
                                   4'd5:seg_out = 8'b1001_0010;
                                   4'd6:seg_out = 8'b1000_0010;
                                   4'd7:seg_out = 8'b1111_1000;
                                   4'd8:seg_out = 8'b1000_0000;
                                   4'd9:seg_out = 8'b1001_0000;
                                    default:seg_out = 8'b1100_0000;
                                 endcase
                               end
                         2'b10:begin
                                 case(lock_set_lose)
                                   4'd1:seg_out = 8'b1111_1001;
                                   4'd2:seg_out = 8'b1010_0100;
                                   4'd3:seg_out = 8'b1011_0000;
                                   4'd4:seg_out = 8'b1001_1001;
                                   4'd5:seg_out = 8'b1001_0010;
                                   4'd6:seg_out = 8'b1000_0010;
                                   4'd7:seg_out = 8'b1111_1000;
                                   4'd8:seg_out = 8'b1000_0000;
                                   4'd9:seg_out = 8'b1001_0000;
                                   default:seg_out = 8'b1100_0000;
                                 endcase
                               end
                        default:seg_out = 8'b1011_1111;
                     endcase
                    end   
               3'd3:begin
                     case(people4[1:0])
                         2'b00:seg_out = 8'b1100_0000;
                         2'b01:begin
                                 case(lock_set_gain)
                                   4'd1:seg_out = 8'b1111_1001;
                                   4'd2:seg_out = 8'b1010_0100;
                                   4'd3:seg_out = 8'b1011_0000;
                                   4'd4:seg_out = 8'b1001_1001;
                                   4'd5:seg_out = 8'b1001_0010;
                                   4'd6:seg_out = 8'b1000_0010;
                                   4'd7:seg_out = 8'b1111_1000;
                                   4'd8:seg_out = 8'b1000_0000;
                                   4'd9:seg_out = 8'b1001_0000;
                                    default:seg_out = 8'b1100_0000;
                                 endcase
                               end
                         2'b10:begin
                                 case(lock_set_lose)
                                   4'd1:seg_out = 8'b1111_1001;
                                   4'd2:seg_out = 8'b1010_0100;
                                   4'd3:seg_out = 8'b1011_0000;
                                   4'd4:seg_out = 8'b1001_1001;
                                   4'd5:seg_out = 8'b1001_0010;
                                   4'd6:seg_out = 8'b1000_0010;
                                   4'd7:seg_out = 8'b1111_1000;
                                   4'd8:seg_out = 8'b1000_0000;
                                   4'd9:seg_out = 8'b1001_0000;
                                   default:seg_out = 8'b1100_0000;
                                 endcase
                               end
                         default:seg_out = 8'b1011_1111;
                     endcase
                    end                  
             endcase
          end
       endcase
    end
    3'b001:begin
     case(seg_count)
               7:
                   case(lock_set_lose)
                       4'd0: seg_out <= ZERO;
                       4'd1: seg_out <= ONE;
                       4'd2: seg_out <= TWO;
                       4'd3: seg_out <= THREE;
                       4'd4: seg_out <= FOUR;
                       4'd5: seg_out <= FIVE;
                       4'd6: seg_out <= SIX;
                       4'd7: seg_out <= SEVEN;
                       4'd8: seg_out <= EIGHT;
                       4'd9: seg_out <= NINE;
                       default: seg_out <= NULL;
                   endcase
               6:
                   case(lock_set_gain)
                       4'd1: seg_out <= ONE;
                       4'd2: seg_out <= TWO;
                       4'd3: seg_out <= THREE;
                       4'd4: seg_out <= FOUR;
                       4'd5: seg_out <= FIVE;
                       4'd6: seg_out <= SIX;
                       4'd7: seg_out <= SEVEN;
                       4'd8: seg_out <= EIGHT;
                       4'd9: seg_out <= NINE;
                       default: seg_out <= NULL;
                   endcase
               5:
                   case(participants_number)
                       3'd2: seg_out <= TWO;
                       3'd3: seg_out <= THREE;
                       3'd4: seg_out <= FOUR;
                       default: seg_out <= NULL;
                   endcase
               4:
               begin
                   if(total_times < 8'd10)
                       case(total_times - 8'd0)
                           8'd0: seg_out <= ZERO;
                           8'd1: seg_out <= ONE;
                           8'd2: seg_out <= TWO;
                           8'd3: seg_out <= THREE;
                           8'd4: seg_out <= FOUR;
                           8'd5: seg_out <= FIVE;
                           8'd6: seg_out <= SIX;
                           8'd7: seg_out <= SEVEN;
                           8'd8: seg_out <= EIGHT;
                           8'd9: seg_out <= NINE;
                           default: seg_out <= NULL;
                       endcase
                   else if(total_times < 8'd20)
                       case(total_times - 8'd10)
                           8'd0: seg_out <= ZERO;
                           8'd1: seg_out <= ONE;
                           8'd2: seg_out <= TWO;
                           8'd3: seg_out <= THREE;
                           8'd4: seg_out <= FOUR;
                           8'd5: seg_out <= FIVE;
                           8'd6: seg_out <= SIX;
                           8'd7: seg_out <= SEVEN;
                           8'd8: seg_out <= EIGHT;
                           8'd9: seg_out <= NINE;
                           default: seg_out <= NULL;
                       endcase
                   else if(total_times < 8'd30)
                       case(total_times - 8'd20)
                           8'd0: seg_out <= ZERO;
                           8'd1: seg_out <= ONE;
                           8'd2: seg_out <= TWO;
                           8'd3: seg_out <= THREE;
                           8'd4: seg_out <= FOUR;
                           8'd5: seg_out <= FIVE;
                           8'd6: seg_out <= SIX;
                           8'd7: seg_out <= SEVEN;
                           8'd8: seg_out <= EIGHT;
                           8'd9: seg_out <= NINE;
                           default: seg_out <= NULL;
                       endcase
                   else if(total_times < 8'd40)
                       case(total_times - 8'd30)
                           8'd0: seg_out <= ZERO;
                           8'd1: seg_out <= ONE;
                           8'd2: seg_out <= TWO;
                           8'd3: seg_out <= THREE;
                           8'd4: seg_out <= FOUR;
                           8'd5: seg_out <= FIVE;
                           8'd6: seg_out <= SIX;
                           8'd7: seg_out <= SEVEN;
                           8'd8: seg_out <= EIGHT;
                           8'd9: seg_out <= NINE;
                           default: seg_out <= NULL;
                       endcase
                   else if(total_times < 8'd50)
                       case(total_times - 8'd40)
                           8'd0: seg_out <= ZERO;
                           8'd1: seg_out <= ONE;
                           8'd2: seg_out <= TWO;
                           8'd3: seg_out <= THREE;
                           8'd4: seg_out <= FOUR;
                           8'd5: seg_out <= FIVE;
                           8'd6: seg_out <= SIX;
                           8'd7: seg_out <= SEVEN;
                           8'd8: seg_out <= EIGHT;
                           8'd9: seg_out <= NINE;
                           default: seg_out <= NULL;
                       endcase
                   else if(total_times < 8'd60)
                       case(total_times - 8'd50)
                           8'd0: seg_out <= ZERO;
                           8'd1: seg_out <= ONE;
                           8'd2: seg_out <= TWO;
                           8'd3: seg_out <= THREE;
                           8'd4: seg_out <= FOUR;
                           8'd5: seg_out <= FIVE;
                           8'd6: seg_out <= SIX;
                           8'd7: seg_out <= SEVEN;
                           8'd8: seg_out <= EIGHT;
                           8'd9: seg_out <= NINE;
                           default: seg_out <= NULL;
                       endcase
                   else if(total_times < 8'd70)
                       case(total_times - 8'd60)
                           8'd0: seg_out <= ZERO;
                           8'd1: seg_out <= ONE;
                           8'd2: seg_out <= TWO;
                           8'd3: seg_out <= THREE;
                           8'd4: seg_out <= FOUR;
                           8'd5: seg_out <= FIVE;
                           8'd6: seg_out <= SIX;
                           8'd7: seg_out <= SEVEN;
                           8'd8: seg_out <= EIGHT;
                           8'd9: seg_out <= NINE;
                           default: seg_out <= NULL;
                       endcase
                   else if(total_times < 8'd80)
                       case(total_times - 8'd70)
                           8'd0: seg_out <= ZERO;
                           8'd1: seg_out <= ONE;
                           8'd2: seg_out <= TWO;
                           8'd3: seg_out <= THREE;
                           8'd4: seg_out <= FOUR;
                           8'd5: seg_out <= FIVE;
                           8'd6: seg_out <= SIX;
                           8'd7: seg_out <= SEVEN;
                           8'd8: seg_out <= EIGHT;
                           8'd9: seg_out <= NINE;
                           default: seg_out <= NULL;
                       endcase
                   else if(total_times < 8'd90)
                       case(total_times - 8'd80)
                           8'd0: seg_out <= ZERO;
                           8'd1: seg_out <= ONE;
                           8'd2: seg_out <= TWO;
                           8'd3: seg_out <= THREE;
                           8'd4: seg_out <= FOUR;
                           8'd5: seg_out <= FIVE;
                           8'd6: seg_out <= SIX;
                           8'd7: seg_out <= SEVEN;
                           8'd8: seg_out <= EIGHT;
                           8'd9: seg_out <= NINE;
                           default: seg_out <= NULL;
                       endcase
                   else
                       case(total_times - 8'd90)
                           8'd0: seg_out <= ZERO;
                           8'd1: seg_out <= ONE;
                           8'd2: seg_out <= TWO;
                           8'd3: seg_out <= THREE;
                           8'd4: seg_out <= FOUR;
                           8'd5: seg_out <= FIVE;
                           8'd6: seg_out <= SIX;
                           8'd7: seg_out <= SEVEN;
                           8'd8: seg_out <= EIGHT;
                           8'd9: seg_out <= NINE;
                           default: seg_out <= NULL;
                       endcase
               end
               3:
               begin
                   if(total_times < 8'd10)
                       seg_out <= ZERO;
                   else if(total_times < 8'd20)
                       seg_out <= ONE;
                   else if(total_times < 8'd30)
                       seg_out <= TWO;
                   else if(total_times < 8'd40)
                       seg_out <= THREE;
                   else if(total_times < 8'd50)
                       seg_out <= FOUR;
                   else if(total_times < 8'd60)
                       seg_out <= FIVE;
                   else if(total_times < 8'd70)
                       seg_out <= SIX;
                   else if(total_times < 8'd80)
                       seg_out <= SEVEN;
                   else if(total_times < 8'd90)
                       seg_out <= EIGHT;
                   else
                       seg_out <= NINE;  
               end
               2:
                   case(this_stage_number)
                       3'd1: seg_out <= ONE;
                       3'd2: seg_out <= TWO;
                       default: seg_out <= NOTHING;
                   endcase
               1:
                   case(total_stage_number)
                       3'd0: seg_out <= ZERO;
                       3'd1: seg_out <= ONE;
                       3'd2: seg_out <= TWO;
                       3'd3: seg_out <= THREE;
                       3'd4: seg_out <= FOUR;
                       default: seg_out <= NOTHING;
                   endcase
               0:seg_out <= ONE;
               default: seg_out <= NULL;
           endcase
    end
    default:seg_out = 8'b1000_0001;
    endcase
   end
endmodule

