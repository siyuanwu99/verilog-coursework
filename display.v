`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/08 10:50:21
// Design Name: 
// Module Name: display
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
module display(
    input [1:0] clk,
    input rst,
    input button,
    input  wire [31:0] data_in,
    output reg [6:0] seg1,
    output reg [6:0] seg2,
    output reg [7:0] enable
    );

    reg [3:0]   digit1;
    reg [3:0]   digit2;

    parameter // set parameters for 7-seg code
    ss = 7'b0000000,
    s0 = 7'b0111111,
    s1 = 7'b0000110,
    s2 = 7'b1011011,
    s3 = 7'b1001111,
    s4 = 7'b1100110,
    s5 = 7'b1101101,
    s6 = 7'b1111101,
    s7 = 7'b0000111,
    s8 = 7'b1111111,
    s9 = 7'b1100111,
    sr = 7'b1110111,
    sa = 7'b1110111,
    sb = 7'b1111100,
    sc = 7'b0111001,
    sd = 7'b0111110,
    se = 7'b1111001,
    sf = 7'b1110001;
    
    always @ (*)
    if (rst) begin
        enable = 8'b11111111;
        digit1 = 1'h0;
        digit2 = 1'h0;
    end
    else
        case (clk)
            2'b00: 
                begin 
                digit1 = data_in[3:0]; 
                digit2 = data_in[19:16];
                if (button == 1'b1) // if true: display 6-bit freq
                    enable = 8'b00010001; 
                else // if false: display 4-bit peak value
                    enable = 8'b00000001;
                end
            2'b01: 
                begin 
                digit1 = data_in[7:4]; 
                digit2 = data_in[23:20];
                if (button == 1'b1)
                    enable = 8'b00100010; 
                else
                    enable = 8'b00000010;
                end
            2'b10: 
                begin
                digit1 = data_in[11:8];
                digit2 = data_in[27:24];
                enable = 8'b00000100;
                end
            2'b11:
                begin
                digit1 = data_in[15:12];
                digit2 = data_in[31:28];
                enable = 8'b00001000;
                end
            default 
                begin 
                digit1 = data_in[3:0]; 
                digit2 = data_in[19:16];
                enable = 8'b00000000; 
                end
    endcase  

                
    always@(*)
    case(digit1)
        4'h0: seg1 = s0;
        4'h1: seg1 = s1;
        4'h2: seg1 = s2;
        4'h3: seg1 = s3;
        4'h4: seg1 = s4;
        4'h5: seg1 = s5;
        4'h6: seg1 = s6;
        4'h7: seg1 = s7;
        4'h8: seg1 = s8;
        4'h9: seg1 = s9;
        default: seg1 = ss;
    endcase

    always@(*)
    case(digit2)
        4'h0: seg2 = s0;
        4'h1: seg2 = s1;
        4'h2: seg2 = s2;
        4'h3: seg2 = s3;
        4'h4: seg2 = s4;
        4'h5: seg2 = s5;
        4'h6: seg2 = s6;
        4'h7: seg2 = s7;
        4'h8: seg2 = s8;
        4'h9: seg2 = s9;
        default: seg2 = ss;
    endcase
endmodule