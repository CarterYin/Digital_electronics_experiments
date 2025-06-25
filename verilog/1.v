module lcd_display(
    input               lcd_clk,    // 时钟
    input               sys_rst_n,       // 复位，低电平有效
    input      [10:0]   pixel_xpos,  // 像素点横坐标
    input      [10:0]   pixel_ypos,  // 像素点纵坐标
    output reg [15:0]   pixel_data   // 像素点数据
);

// parameter define
localparam PIC_X_START = 11'd1;      // 图片起始横坐标
localparam PIC_Y_START = 11'd1;      // 图片起始纵坐标
localparam PIC_WIDTH   = 11'd100;    // 图片宽度
localparam PIC_HEIGHT  = 11'd100;    // 图片高度

localparam CHAR_X_START = 11'd1;     // 字符起始横坐标
localparam CHAR_Y_START = 11'd100;   // 字符起始纵坐标
localparam CHAR_WIDTH  = 11'd64;
localparam CHAR_HEIGHT = 11'd16;  

localparam BACK_COLOR = 16'hF8FF;    // 背景色（浅蓝色）
localparam CHAR_COLOR = 16'hF800;    // 字符颜色（红色）

// reg define
reg [127:0] char [15:0];             // 字符数组
reg [13:0] rom_addr;                 // ROM 地址

// wire define
wire [10:0] x_cnt;                  // 横坐标计数器
wire [10:0] y_cnt;                  // 纵坐标计数器
wire        rom_rd_en;             // ROM 使能信号
wire [15:0] rom_rd_data;           // ROM 数据

// 坐标相对于字符区域起始坐标的偏移量
assign x_cnt = pixel_xpos - CHAR_X_START;
assign y_cnt = pixel_ypos - CHAR_Y_START;
assign rom_rd_en = 1'b1; // 始终使能读取

// 字符数组赋值，显示“正点原子”
always @(posedge lcd_clk) begin
	char[ 0] <= 128'h00000000000000000000000000000000;
	char[ 1] <= 128'h00000000000000000000000000000000;
	char[ 2] <= 128'h00000000000000000000000000000000;
	char[ 3] <= 128'hFC3E03E003800FC83008061C03801878;
	char[ 4] <= 128'h3008080C038030183008180603806018;
	char[ 5] <= 128'h3008300204C060083008300204C06008;
	char[ 6] <= 128'h3008300004C060003008600004C07000;
	char[ 7] <= 128'h300860000C403C003008600008601F00;
	char[ 8] <= 128'h30086000086007C030086000086001F0;
	char[ 9] <= 128'h3008600018200078300860001FF00018;
	char[10] <= 128'h300860001030001C300860001030400C;
	char[11] <= 128'h300830021030400C300830022018600C;
	char[12] <= 128'h300810042018200C1810180820183018;
	char[13] <= 128'h1C200C10601C383007C003E0F83E27E0;
	char[14] <= 128'h00000000000000000000000000000000;
	char[15] <= 128'h00000000000000000000000000000000;
end

// 为 LCD 不同显示区域绘制不同颜色：图片、字符和背景
always @(posedge lcd_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        pixel_data <= BACK_COLOR;
    else if ((pixel_xpos >= PIC_X_START) && (pixel_xpos < PIC_X_START + PIC_WIDTH) &&
             (pixel_ypos >= PIC_Y_START) && (pixel_ypos < PIC_Y_START + PIC_HEIGHT))
        pixel_data <= rom_rd_data; // 显示图片
    else if ((pixel_xpos >= CHAR_X_START) && (pixel_xpos < CHAR_X_START + CHAR_WIDTH) &&
             (pixel_ypos >= CHAR_Y_START) && (pixel_ypos < CHAR_Y_START + CHAR_HEIGHT)) begin
        if (char[y_cnt][CHAR_WIDTH - 1 - x_cnt])
            pixel_data <= CHAR_COLOR; // 字符颜色
        else
            pixel_data <= BACK_COLOR; // 字符区域背景
    end else
        pixel_data <= BACK_COLOR; // 整个背景
end

// 根据当前扫描点的横纵坐标为 ROM 地址赋值
always @(posedge lcd_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        rom_addr <= 14'd0;
    else if ((pixel_ypos >= PIC_Y_START) && (pixel_ypos < PIC_Y_START + PIC_HEIGHT) &&
             (pixel_xpos >= PIC_X_START) && (pixel_xpos < PIC_X_START + PIC_WIDTH))
        rom_addr <= rom_addr + 1'b1;
    else if (pixel_ypos >= PIC_Y_START + PIC_HEIGHT)
        rom_addr <= 14'd0;
end

// ROM 实例化：存储图片
rom_10000x16b u_rom_10000x16b(
    .address (rom_addr),
    .clock   (lcd_clk),
    .rden    (rom_rd_en),
    .q       (rom_rd_data)
);

endmodule

