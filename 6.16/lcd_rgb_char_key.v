module lcd_rgb_char_key(
	input sys_clk,
	input sys_rst_n,
	input[3:0]key,
	output lcd_hs,
	output lcd_vs,
	output lcd_de,
	output[15:0]lcd_rgb,
	output lcd_bl,
	output lcd_rst,
	output lcd_pclk
	);
wire lcd_clk_w;
wire locked_w;
wire rst_n_w;
wire[15:0]pixel_data_w;
wire[9:0]pixel_xpos_w;
wire[9:0]pixel_ypos_w;
assign rst_n_w=sys_rst_n&&locked_w;

lcd_pll u_lcd_pll(
	.inclk0(sys_clk),
	.areset(~sys_rst_n),
	.c0(lcd_clk_w),
	.locked(locked_w)
	);
lcd_driver u_lcd_driver(
	.lcd_clk(lcd_clk_w),
	.sys_rst_n(rst_n_w),
	.lcd_hs(lcd_hs),
	.lcd_vs(lcd_vs),
	.lcd_de(lcd_de),
	.lcd_rgb(lcd_rgb),
	.lcd_bl(lcd_bl),
	.lcd_rst(lcd_rst),
	.lcd_pclk(lcd_pclk),
	.pixel_data(pixel_data_w),
	.pixel_xpos(pixel_xpos_w),
	.pixel_ypos(pixel_ypos_w)
	);
lcd_display u_lcd_display(
	.lcd_clk(lcd_clk_w),
	.sys_rst_n(rst_n_w),
	.key(key),
	.pixel_xpos(pixel_xpos_w),
	.pixel_ypos(pixel_ypos_w),
	.pixel_data(pixel_data_w)
	);
endmodule
