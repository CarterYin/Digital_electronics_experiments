module lcd_driver(
	input lcd_clk,
	input sys_rst_n,
	output lcd_hs,
	output lcd_vs,
	output lcd_de,
	output[15:0]lcd_rgb,
	output lcd_bl,
	output lcd_rst,
	output lcd_pclk,
	input[15:0]pixel_data,
	output[10:0]pixel_xpos,
	output[10:0]pixel_ypos
	);
parameter H_SYNC=11'd128;
parameter H_BACK=11'd88;
parameter H_DISP=11'd800;
parameter H_FRONT=11'd40;
parameter H_TOTAL=11'd1056;
parameter V_SYNC=11'd2;
parameter V_BACK=11'd33;
parameter V_DISP=11'd480;
parameter V_FRONT=11'd10;
parameter V_TOTAL=11'd525;
reg[10:0]cnt_h;
reg[10:0]cnt_v;
wire lcd_en;
wire data_req;
assign lcd_bl=1'b1;
assign lcd_rst=1'b1;
assign lcd_pclk=lcd_clk;
assign lcd_de=lcd_en;
assign lcd_hs=1'b1;
assign lcd_vs=1'b1;
assign lcd_en=(((cnt_h>=H_SYNC+H_BACK)&&(cnt_h<H_SYNC+H_BACK+H_DISP))&&((cnt_v>=V_SYNC+V_BACK)&&(cnt_v<V_SYNC+V_BACK+V_DISP)))?1'b1:1'b0;
assign lcd_rgb=lcd_en?pixel_data:16'd0;
assign data_req=(((cnt_h>=H_SYNC+H_BACK-1'b1)&&(cnt_h<H_SYNC+H_BACK+H_DISP-1'b1))&&((cnt_v>=V_SYNC+V_BACK)&&(cnt_v<V_SYNC+V_BACK+V_DISP)))?1'b1:1'b0;
assign pixel_xpos=data_req?(cnt_h-(H_SYNC+H_BACK-1'b1)):11'd0;
assign pixel_ypos=data_req?(cnt_v-(V_SYNC+V_BACK-1'b1)):11'd0;

always @(posedge lcd_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		cnt_h<=11'd0;
	else begin
		if(cnt_h<H_TOTAL-1'b1)
			cnt_h<=cnt_h+1'b1;
		else
			cnt_h<=11'd0;
	end
end
always @(posedge lcd_clk or negedge sys_rst_n)begin
	if(!sys_rst_n)
		cnt_v<=11'd0;
	else if(cnt_h==H_TOTAL-1'b1)begin
		if(cnt_v<V_TOTAL-1'b1)
			cnt_v<=cnt_v+1'b1;
		else
			cnt_v<=11'd0;
	end
end
endmodule
