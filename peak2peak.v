`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/21 20:55:31
// Design Name: 
// Module Name: peak2peak
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


module peak2peak(
    input       [15:0]  data,
    input               clk,
    input               rst,
    input               clean,
    output  reg [15:0]  peak,
    output  reg         valid
    );
    reg [15:0]      max_register;
    reg [15:0]      min_register;
    reg [15:0]      high_gate;
    reg [15:0]      low_gate;
    reg [31:0]      intermediary;

    always @(posedge rst or posedge clk or posedge clean) begin
        if (rst || clean) begin
            max_register <= 0;
            min_register <= 16'hffff;
        end
        else begin
            if (data >= max_register ) begin
                max_register <= data;
            end
            else
                max_register <= max_register;

            if (data <= min_register) begin
                min_register <= data; //origin: data
            end
            else
                min_register <= min_register;
        end        
    end

    always @ (*) begin
        if (max_register > min_register) begin
            intermediary = 2 * (max_register - min_register) * 3400;
            intermediary = intermediary >> 12;
            peak = intermediary[15:0];
        end
        else
            peak = 16'h0000;
        end
    
    // Schmitt trigger
    always @ (*) begin
        high_gate <= 2 * max_register / 3 + 1 * min_register / 3;
        low_gate <= 1 * max_register / 3 + 2 * min_register / 3;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            valid <= 0;
        end
        else if (data >= high_gate)
                valid <= 1;
            else if (data <= low_gate)
                    valid <= 0;
                else
                    valid <= valid;
    end

endmodule
