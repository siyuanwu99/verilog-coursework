`timescale 10ns / 10ns
module uart_top_tb;
    wire sclk_out;
    reg clk_in, rst_in;
    reg s_data_in;
    wire cs_signal_out;
    wire [6:0] seg1_out;
    wire [6:0] seg2_out;
    wire [7:0] enable_out;
    reg counter;
    reg button;

    
    initial begin
        clk_in = 1'b0;
        rst_in = 1'b0;
        counter = 0;
        button = 0;
        #2 rst_in = 1'b1;   //20ns
        #20 rst_in = 1'b0;  //200ns
    end

    always #1 clk_in <= ~clk_in;

    always begin
        #18000000 button = 1'b1;  //24ms
        #18000000 button = 1'b0;  //24ms
    end


    initial
    begin
        s_data_in = 1'b1; //init receive pin
        #50 // 500ns
        @( negedge cs_signal_out) s_data_in = 1'b0;
        @( negedge sclk_out ) s_data_in = 1'b0; // 1
        @( negedge sclk_out ) s_data_in = 1'b0; // 2
        @( negedge sclk_out ) s_data_in = 1'b0; // 3
        @( negedge sclk_out ) s_data_in = 1'b1; // 1
        @( negedge sclk_out ) s_data_in = 1'b0; // 2
        @( negedge sclk_out ) s_data_in = 1'b1; // 3
        @( negedge sclk_out ) s_data_in = 1'b0; // 4
        @( negedge sclk_out ) s_data_in = 1'b1; // 5
        @( negedge sclk_out ) s_data_in = 1'b0; // 6
        @( negedge sclk_out ) s_data_in = 1'b1; // 7
        @( negedge sclk_out ) s_data_in = 1'b0; // 8
        @( negedge sclk_out ) s_data_in = 1'b1; // 9
        @( negedge sclk_out ) s_data_in = 1'b0; // 10
        @( negedge sclk_out ) s_data_in = 1'b1; // 11
        @( negedge sclk_out ) s_data_in = 1'b0; // 12
        @( negedge sclk_out ) s_data_in = 1'b1;
        @( negedge sclk_out ) s_data_in = 1'b1;
    end
        
    always # 5000 counter = ~counter;  // 0.5ms
        
        // wait for receiving message
    always @( cs_signal_out) begin
        if (counter == 0) begin
            @( negedge cs_signal_out) s_data_in = 1'b0;
            @( negedge sclk_out ) s_data_in = 1'b0;
            @( negedge sclk_out ) s_data_in = 1'b0;
            @( negedge sclk_out ) s_data_in = 1'b0;
            @( negedge sclk_out ) s_data_in = 1'b0; //1
            @( negedge sclk_out ) s_data_in = 1'b0;
            @( negedge sclk_out ) s_data_in = 1'b0;
            @( negedge sclk_out ) s_data_in = 1'b0;
            @( negedge sclk_out ) s_data_in = 1'b0;
            @( negedge sclk_out ) s_data_in = 1'b0;
            @( negedge sclk_out ) s_data_in = 1'b1;
            @( negedge sclk_out ) s_data_in = 1'b1;
            @( negedge sclk_out ) s_data_in = 1'b0;
            @( negedge sclk_out ) s_data_in = 1'b1;
            @( negedge sclk_out ) s_data_in = 1'b0;
            @( negedge sclk_out ) s_data_in = 1'b1; //12
            @( negedge sclk_out ) s_data_in = 1'b1;
            @( negedge sclk_out ) s_data_in = 1'b1;
        end
        else begin
            @( negedge cs_signal_out) s_data_in = 1'b0;
            @( negedge sclk_out ) s_data_in = 1'b0;
            @( negedge sclk_out ) s_data_in = 1'b0;
            @( negedge sclk_out ) s_data_in = 1'b0;
            @( negedge sclk_out ) s_data_in = 1'b1; //1
            @( negedge sclk_out ) s_data_in = 1'b1;
            @( negedge sclk_out ) s_data_in = 1'b1;
            @( negedge sclk_out ) s_data_in = 1'b1;
            @( negedge sclk_out ) s_data_in = 1'b1;
            @( negedge sclk_out ) s_data_in = 1'b1;
            @( negedge sclk_out ) s_data_in = 1'b1;
            @( negedge sclk_out ) s_data_in = 1'b1;
            @( negedge sclk_out ) s_data_in = 1'b1;
            @( negedge sclk_out ) s_data_in = 1'b1;
            @( negedge sclk_out ) s_data_in = 1'b1;
            @( negedge sclk_out ) s_data_in = 1'b1; //12
            @( negedge sclk_out ) s_data_in = 1'b1;
            @( negedge sclk_out ) s_data_in = 1'b1;
        end
    end


    adconvertor adc(
        .clk(clk_in),
        .rst(rst_in),
        .s_data(s_data_in),
        .button(button),
        .cs_signal(cs_signal_out),
        .sclk(sclk_out),
        .seg1(seg1_out),
        .seg2(seg2_out),
        .seg_en(enable_out)
    );
endmodule
