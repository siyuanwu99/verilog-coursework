`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/21 20:55:31
// Design Name: 
// Module Name: frequency
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
module frequency(
    input           sys_clk, // clk
    input           clk,    // clk_100 clk[21]
    input           rst,
    input           clean,
    input           unknown,    // input signal
    output  [23:0]  freq
);
wire [23:0]  sys_counter;
wire [23:0]  freq_counter;
reg [23:0]  freq_register;
reg [50:0]  intermediary;

assign freq = freq_register;

hz_counter sys_count (
    .ref_clk(clk),
    .unknown(sys_clk),
    .count(sys_counter)
);

hz_counter freq_count(
    .ref_clk(clk),
    .unknown(unknown),
    .count(freq_counter)
);

always @ (negedge clk or posedge rst or posedge clean) begin
    if (rst || clean)
        freq_register <= 0;
    else if (clk == 0) begin
            intermediary = freq_counter * 100_000_000 >> 21;
            freq_register = intermediary[23:0];  //!! real 100 000 000
        end
        else
            freq_register <= freq;
end
endmodule // frequency
