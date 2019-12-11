`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/14 18:43:09
// Design Name: 
// Module Name: ad_reader
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


module ad_reader(
    input           sclk,
    input           rst,
    input           cs_signal,
    input           s_data,
    output reg [15:0] data
    );

    reg cs;
    reg [3:0] counter;      // count time
    // reg cs_pulse_1;
    // reg cs_pulse;

    // chip select signal, valid when it's low
    always @(posedge sclk) begin
        if (rst) begin
            cs <= 1'b1;
        end
        else begin
            if (~cs_signal)
                cs <= 1'b0;
            else
                cs <= 1'b1;
            
            if (counter == 4'b1111 ) 
                cs <= 1'b1;
            end
        end

    
    always @(negedge sclk) begin
        if (rst||cs_signal) begin
            counter <= 1'b0;
        end
        else if (~cs) begin
            counter <= counter + 1'b1;
            end
            else
                counter <= counter;
    end


    always @(posedge sclk) begin
        if (rst) begin
            data = 4'h0000;
        end
        else if (counter > 3 && ~cs) begin
            data[15 - counter] = s_data;
        end
    end
endmodule
