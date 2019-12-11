`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/14 10:19:05
// Design Name: 
// Module Name: adconvertor
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


module adconvertor(
    input wire      clk,
    input wire      rst,
    input wire      button, // 1 --> freq ; 0 --> peak
    input wire      s_data,     // data from AD7476
    output wire     sclk,       // clk for AD7476  12.5MHz, 80ns 
    output wire     cs_signal,
    output wire     tx_pin_out,
    output [6:0]    seg1,
    output [6:0]    seg2,
    output [7:0]    seg_en
    );
    reg             clk_100;    // 100 ms clk 
    reg [2:0]       clk_div;    // 12.5Mhz clk
    reg [25:0]      clk_swap;   // generate 10 ms clk 
    reg [4:0]       counter;
    wire [15:0]     data_wire;  // line between 2 regs
    reg  [31:0]     data_to_display;
    wire [15:0]     peak_wire;  // save peak value
    wire [23:0]     freq_wire;  // save freq value
    wire [31:0]     freq_dec_wire; // 10-freq, 6bit
    wire [31:0]     peak_dec_reg;    // 10-peak
    wire            Schmitt_trig_signal;
    reg             ready;  // if uart transport is ready
    reg             ready_flag; // help to detect the pos edge of clk


    // segment displays
    display dis(
        .clk(clk_swap[17:16]), // 2.62ms  //!!real 19 18, sim 13 12
        .rst(rst),
        .button(button),
        .seg1(seg1),
        .seg2(seg2),
        .enable(seg_en),
        .data_in(data_to_display[31:0])
    );

    // ad data reader
    ad_reader reader(
        .sclk(sclk),
        .rst(rst),
        .cs_signal(cs_signal),
        .s_data(s_data),
        .data(data_wire)
    );

    // peak-to-peak detector
    peak2peak peak(
        .clk(cs_signal),
        .rst(rst),
        .clean(~clk_swap[21] && clk_swap[20] && ~clk_swap[19] && clk_swap[18]),
        .peak(peak_wire),
        .data(data_wire),
        .valid(Schmitt_trig_signal)
    );

    // frequency detector
    frequency freq1(
        .sys_clk(clk),
        .clean(~clk_swap[21] && clk_swap[20] && ~clk_swap[19] && clk_swap[18]),
        .clk(clk_100),
        .rst(rst),
        .unknown(Schmitt_trig_signal),
        .freq(freq_wire)
    );
    
    // div clk $ \frac{1}{4} $
    assign sclk = clk_div[2];
    always @ (posedge clk) begin
        if (clk_div <= 3'b111)
            clk_div <= clk_div + 1'b1;
        else
            clk_div <= 3'b000;
    end

    // generate clk_100 for 100ms
    always @ (posedge clk) begin
        if (rst) begin
            clk_swap <= 5'h00000;
        end
        else if (clk_swap < 50000000)begin //!! real 500,000,00
            clk_swap <= clk_swap + 1;
        end
        else begin
            clk_swap <= 5'h00000;
        end
    end

    always @(*) begin
        clk_100 <= clk_swap[21]; // !! real 21
    end

    // chip select, decide sample rate
    assign cs_signal = ~clk_swap[7]; //small: no more than 11(4khz)

    // display
    always @(posedge clk_swap[23] or posedge rst) begin // !!23
        if (rst) begin
            data_to_display <= 16'hffff;
        end
        else if (button == 1'b1)
            data_to_display <= freq_dec_wire;
        else
            data_to_display <= peak_dec_reg;
    end

    hex2dec h2d_freq (
        .clk(clk),
        .rst(~clk_100),
        .hex_in(freq_wire),
        .dec_out(freq_dec_wire)
    );

    hex2dec2 h2d_peak (
        .clk(clk),
        .rst(~clk_100),
        .hex_in(peak_wire),
        .dec_out(peak_dec_reg)
    );


    // using uart module 
    top send (
        .sys_clk_in(clk),
        .rst(rst),
        .control_signal(clk_swap[23]),
        .freq_data_in(freq_dec_wire),
        .peak_data_in(peak_dec_reg),
        .tx_pin_out(tx_pin_out)
    );


endmodule
