`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2019 09:10:03 AM
// Design Name: 
// Module Name: setting
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

//模块功能：根据用户输入实现时间、人数、加分、减分的设定
module setting(
    input clk, input rst,
    input[3:0] row, output[3:0] col,
    
    output reg[2:0] participants_number,
    output reg[7:0] total_times,
    output reg[3:0] points_add, output reg[3:0] points_deduce,
    
    output reg set_done,
    output reg[2:0]total_stage_number, 
    output reg[2:0]this_stage_number
    );
    
    
wire[3:0] keyboard_val;
wire key_flag;
keyboard u1(clk, rst, row, col, key_flag, keyboard_val);


always@(posedge clk)
    if(total_stage_number == 3'd4)
        set_done <= 1'b1;
    else
        set_done <= 1'b0;

// initialize the value, if do not get into setting, initialize the default value

always@(posedge clk,negedge rst)

begin
    if(!rst)begin
        total_stage_number <= 3'd0;
        this_stage_number <= 3'd1;
        participants_number <= 3'd4;
        total_times <= 8'd30;
        points_add <= 4'd1;
        points_deduce <= 4'd1;
    end
   else
   begin
        if (key_flag && total_stage_number == 3'd0)
           case(keyboard_val)
                4'hA: total_stage_number <= 3'd1;
                default: total_stage_number <= 3'd4;
           endcase
        else if (key_flag && total_stage_number == 3'd1)
        begin
            case (keyboard_val)
                4'h2:
                    participants_number <= 3'd2;
                4'h3:
                    participants_number <= 3'd3;
                4'h4:
                    participants_number <= 3'd4;
                default:
                    participants_number <= 3'd4;
            endcase
            total_stage_number <= 3'd2;
        end
        else if (key_flag && total_stage_number == 3'd2 && this_stage_number == 3'd1)
        begin
            case (keyboard_val)
                4'h1:
                    total_times <= 8'd10;
                4'h2:
                    total_times <= 8'd20;
                4'h3:
                    total_times <= 8'd30;
                4'h4:
                    total_times <= 8'd40;
                4'h5:
                    total_times <= 8'd50;
                4'h6:
                    total_times <= 8'd60;
                4'h7:
                    total_times <= 8'd70;
                4'h8:
                    total_times <= 8'd80;
                4'h9:
                    total_times <= 8'd90;
                default:
                    total_times <= 8'd30;
            endcase
            this_stage_number <= 3'd2;
        end
        else if (key_flag && total_stage_number == 3'd2 && this_stage_number == 3'd2)
        begin
            case (keyboard_val)
            4'h1:
                total_times <= total_times + 8'd1;
            4'h2:
                total_times <= total_times + 8'd2;
            4'h3:
                total_times <= total_times + 8'd3;
            4'h4:
                total_times <= total_times + 8'd4;
            4'h5:
                total_times <= total_times + 8'd5;
            4'h6:
                total_times <= total_times + 8'd6;
            4'h7:
                total_times <= total_times + 8'd7;
            4'h8:
                total_times <= total_times + 8'd8;
            4'h9:
                total_times <= total_times + 8'd9;
            default:
                total_times <= total_times + 8'd0;
            endcase
            this_stage_number <= 3'd1;
            total_stage_number <= 3'd3;
        end
        else if (key_flag && total_stage_number == 3'd3 && this_stage_number == 3'd1)
        begin
            case (keyboard_val)
                4'h1:
                    points_add <= 4'd1;
                4'h2:
                    points_add <= 4'd2;
                4'h3:
                    points_add <= 4'd3;
                4'h4:
                    points_add <= 4'd4;
                4'h5:
                    points_add <= 4'd5;
                4'h6:
                    points_add <= 4'd6;
                4'h7:
                    points_add <= 4'd7;
                4'h8:
                    points_add <= 4'd8;
                4'h9:
                    points_add <= 4'd9;
                default:
                    points_add <= 4'd1;
            endcase
            this_stage_number = 3'd2;
        end
        else if (key_flag && total_stage_number == 3'd3 && this_stage_number == 3'd2)
        begin
            case (keyboard_val)
                4'h0:
                    points_deduce <= 4'd0;
                4'h1:
                    points_deduce <= 4'd1;
                4'h2:
                    points_deduce <= 4'd2;
                4'h3:
                    points_deduce <= 4'd3;
                4'h4:
                    points_deduce <= 4'd4;
                4'h5:
                    points_deduce <= 4'd5;
                4'h6:
                    points_deduce <= 4'd6;
                4'h7:
                    points_deduce <= 4'd7;
                4'h8:
                    points_deduce <= 4'd8;
                4'h9:
                    points_deduce <= 4'd9;
                default:
                    points_deduce <= 4'd1;
            endcase
            this_stage_number <= 3'd1;
            total_stage_number <= 3'd4;
        end
    end
end

endmodule
