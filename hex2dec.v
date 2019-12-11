`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/24 16:47:12
// Design Name: 
// Module Name: hex2dec
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//  16 hex ==> 10 dec
//  n bit ==> 32 bit
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module hex2dec(
    input   wire            clk,
    input   wire            rst,
    input   wire    [23:0]  hex_in,
    output  wire    [31:0]  dec_out
    );
    // reg [31:0]  dec_register;
    reg [31:0]  ShiftReg = 32'h00000000;
    reg [23:0]  counter = 23;
    reg [4:0]   count24;
    reg         pulse;

    always @(posedge clk) begin
        if (rst)
            pulse <= 1;
        else
            pulse <= 0;
    end

    always @(posedge clk) begin
    if (rst && ~pulse)
        count24 <= 23;
    else
        if (count24 >= 0 && count24 <= 23)
            count24 <= count24 - 1'b1;
        else
            count24 <= 5'd31;
    end

    always @(posedge clk) begin
    if (rst && ~pulse)
        ShiftReg <= 32'h00000000;
    else
        if (count24 >= 0 && count24 <= 23)
        begin
            ShiftReg = (ShiftReg << 1);
            ShiftReg[0] = hex_in[count24];
            if (count24 >0) begin
                if (ShiftReg[31:28] > 4)
                    ShiftReg[31:28] = ShiftReg[31:28] + 3;
                else
                    ShiftReg[31:28] = ShiftReg[31:28];

                if (ShiftReg[27:24] > 4)
                    ShiftReg[27:24] = ShiftReg[27:24] + 3;
                else
                    ShiftReg[27:24] = ShiftReg[27:24];

                if (ShiftReg[23:20] > 4)
                    ShiftReg[23:20] = ShiftReg[23:20] + 3;
                else
                    ShiftReg[23:20] = ShiftReg[23:20];

                if (ShiftReg[19:16] > 4)
                    ShiftReg[19:16] = ShiftReg[19:16] + 3;
                else
                    ShiftReg[19:16] = ShiftReg[19:16];

                if (ShiftReg[15:12] > 4)
                    ShiftReg[15:12] = ShiftReg[15:12] + 3;
                else
                    ShiftReg[15:12] = ShiftReg[15:12];

                if (ShiftReg[11:8] > 4)
                    ShiftReg[11:8] = ShiftReg[11:8] + 3;
                else
                    ShiftReg[11:8] = ShiftReg[11:8];

                if (ShiftReg[7:4] > 4)
                    ShiftReg[7:4] = ShiftReg[7:4] + 3;
                else
                    ShiftReg[7:4] = ShiftReg[7:4];

                if (ShiftReg[3:0] > 4)
                    ShiftReg[3:0] = ShiftReg[3:0] + 3;
                else
                    ShiftReg[3:0] = ShiftReg[3:0];     
            end
            
        end
        else
            ShiftReg = ShiftReg;

    end

    assign dec_out = ShiftReg;

endmodule
