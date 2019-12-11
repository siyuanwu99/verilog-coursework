`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/06 21:26:51
// Design Name: 
// Module Name: top
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
// maybe this file is nessary, cause I have 4 * 4 + 6 * 4 + f + p to display
// 8 bit each time, 
//////////////////////////////////////////////////////////////////////////////////

module top(
    input               sys_clk_in,
    input               rst,  // enable when low
    input               control_signal,
    input       [31:0]  freq_data_in, // 6*BCD
    input       [31:0]  peak_data_in, // 4*BCD
    output wire         tx_pin_out
);
reg [4:0]   status;
reg [7:0]   tx_data;   
wire        tx_ready;   // transport finished
reg [19:0]  clk_256;
reg         ready;
// reg         flag;
// reg         vld;


// clock division
always @ (posedge sys_clk_in) begin
    if (clk_256 < 1000000)
        clk_256 <= clk_256 + 1;
    else
        clk_256 = 0;
    end


always @(*) begin
    if (rst)
        ready <= 1'b0;
    else if (control_signal && (status < 5'd29))
        ready <= 1'b1;
    else
        ready <= 1'b0;
end

// logic: using ready and tx_ready to implement multi send

always @ (posedge tx_ready or posedge rst or negedge control_signal) begin
    if (rst || ~control_signal) begin
        status <= 0;
    end
    else if (status < 5'd29) 
            if (tx_ready)
                status <= status + 1;
            else
                status <= status;
        else
            status <=5'd29;
end

always @ (posedge sys_clk_in) begin
    case (status)
        5'd0: tx_data = 8'h66;
        5'd1: tx_data = 8'h66;
        5'd2: tx_data = {4'b0011, freq_data_in[23:20]};
        5'd3: tx_data = {4'b0011, freq_data_in[23:20]};
        5'd4: tx_data = {4'b0011, freq_data_in[19:16]};
        5'd5: tx_data = {4'b0011, freq_data_in[19:16]};
        5'd6: tx_data = {4'b0011, freq_data_in[15:12]};
        5'd7: tx_data = {4'b0011, freq_data_in[15:12]};
        5'd8: tx_data = {4'b0011, freq_data_in[11:8]};
        5'd9: tx_data = {4'b0011, freq_data_in[11:8]};
        5'd10: tx_data = {4'b0011, freq_data_in[7:4]};
        5'd11: tx_data = {4'b0011, freq_data_in[7:4]};
        5'd12: tx_data = {4'b0011, freq_data_in[3:0]};
        5'd13: tx_data = {4'b0011, freq_data_in[3:0]};
        5'd14: tx_data = 8'h00;
        5'd15: tx_data = 8'h00;
        5'd16: tx_data = 8'h70;
        5'd17: tx_data = 8'h70;
        5'd18: tx_data = {4'b0011, peak_data_in[15:12]};
        5'd19: tx_data = {4'b0011, peak_data_in[15:12]};
        5'd20: tx_data = {4'b0011, peak_data_in[11:8]};
        5'd21: tx_data = {4'b0011, peak_data_in[11:8]};
        5'd22: tx_data = {4'b0011, peak_data_in[7:4]};
        5'd23: tx_data = {4'b0011, peak_data_in[7:4]};
        5'd24: tx_data = {4'b0011, peak_data_in[3:0]};
        5'd25: tx_data = {4'b0011, peak_data_in[3:0]};
        5'd26: tx_data = 8'h0d;
        5'd27: tx_data = 8'h0d;
        5'd28: tx_data = 8'h0d;
        default: tx_data = 8'h00;
    endcase
end
   
uart_tx tx (
            .clk(sys_clk_in),
            .rst_n(~rst),
            .din(tx_data),
            .din_vld(ready), // valid high
            .rdy(tx_ready),
            .dout(tx_pin_out)
            );
            
endmodule
