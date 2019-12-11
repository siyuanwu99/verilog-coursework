`timescale 1ns / 1ps
module uart_rx(

               input               clk          ,		
               input               rst_n        ,	
               input               din          ,
               output  reg[7:0]    dout         ,		
               output  reg         dout_vld     
               );

parameter    	   BPS	  =	10400;
reg   [14:0]        cnt0         ;
wire                add_cnt0     ;
wire                end_cnt0     ;

reg   [ 3:0]        cnt1         ;
wire                add_cnt1     ;
wire                end_cnt1     ;

reg                 rx0          ;	
reg                 rx1          ;	
reg                 rx2          ;	
wire                rx_en        ;

reg                 flag_add     ;


always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		rx0 <= 1'b1;
        rx1 <= 1'b1;
        rx2 <= 1'b1;
	end
	else begin
		rx0 <= din;
        rx1 <= rx0;
        rx2 <= rx1;
	end
end

assign rx_en = rx2 & ~rx1;	

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt0 <= 0;
    end
    else if(add_cnt0)begin
        if(end_cnt0)
            cnt0 <= 0;
        else
            cnt0 <= cnt0 + 1;
    end
end

assign add_cnt0 = flag_add;
assign end_cnt0 = add_cnt0 && cnt0==BPS-1 ;

always @(posedge clk or negedge rst_n)begin 
    if(!rst_n)begin
        cnt1 <= 0;
    end
    else if(add_cnt1)begin
        if(end_cnt1)
            cnt1 <= 0;
        else
            cnt1 <= cnt1 + 1;
    end
end

assign add_cnt1 = end_cnt0;
assign end_cnt1 = add_cnt1 && cnt1==9-1 ; 

always @ (posedge clk or negedge rst_n)begin
	if(!rst_n) begin
		flag_add <= 1'b0;
	end
	else if(rx_en) begin		
		flag_add <= 1'b1;	
	end
    else if(end_cnt1) begin		
		flag_add <= 1'b0;	
	end
end

always @ (posedge clk or negedge rst_n)begin
	if(!rst_n) begin
		dout <= 8'd0;
	end
	else if(add_cnt0 && cnt0==BPS/2-1 && cnt1!=0) begin	
	    dout[cnt1-1]<= rx2 ;
	end
end



always @ (posedge clk or negedge rst_n)begin
	if(!rst_n) begin
		dout_vld <= 1'b0;
	end
    else if(end_cnt1) begin		
		dout_vld <= 1'b1;	
	end
	else begin	
        dout_vld <= 1'b0;			
	end
end

endmodule