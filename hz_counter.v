`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/24 11:43:22
// Design Name: 
// Module Name: hz_counter
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
module hz_counter(
    input               ref_clk,
    input               unknown,
    output  reg [23:0]  count
);

always @ (negedge ref_clk or posedge unknown) begin
    if (ref_clk == 0)
        count <= 0;
    else if (ref_clk == 1)
            count <= count + 1;
        else
            count <= count;
end


endmodule