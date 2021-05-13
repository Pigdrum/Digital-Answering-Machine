`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/26 03:55:07
// Design Name: 
// Module Name: decodePeople
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


module decodePeople(input[2:0]in,input rst,output reg[3:0]out
    );
    always begin
        if(!rst)out = 4'b1111;
        else begin
            case(in)
                3'd2:out = 4'b0011;
                3'd3:out = 4'b0111;
                default:out = 4'b1111;
            endcase
        end
    end
endmodule
