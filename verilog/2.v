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
localparam CHAR_WIDTH  = 11'd128;
localparam CHAR_HEIGHT = 11'd64;  

localparam BACK_COLOR = 16'hF8FF;    // 背景色（浅蓝色）
localparam CHAR_COLOR = 16'hF800;    // 字符颜色（红色）

// reg define
reg [127:0] char [63:0];             // 字符数组
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
char[ 3] <= 128'h00000000000000000000000000000000;
char[ 4] <= 128'h00000000000000000000000000000000;
char[ 5] <= 128'h00000000000000000000000000000000;
char[ 6] <= 128'h00000000000000000000000000000000;
char[ 7] <= 128'h00000000000000000000000000000000;
char[ 8] <= 128'h00000000000000000000000000000000;
char[ 9] <= 128'h00000000000000000000000000000000;
char[10] <= 128'h00000000000000000000000000000000;
char[11] <= 128'h7FF807FE0003FC100003C000001FE000;
char[12] <= 128'h7FF807FE000FFFF00003C000007FF880;
char[13] <= 128'h0FC000F0003C07F00003C00000F03F80;
char[14] <= 128'h07800060007801F00007E00001C00F80;
char[15] <= 128'h0780006000E000F80007E00003C00780;
char[16] <= 128'h0780006001C000780006E000078003C0;
char[17] <= 128'h0780006003C000380006E000078001C0;
char[18] <= 128'h0780006003800018000CF000070001C0;
char[19] <= 128'h0780006007800018000CF0000F0000C0;
char[20] <= 128'h078000600700000C000C70000F0000C0;
char[21] <= 128'h078000600F00000C000C70000F000000;
char[22] <= 128'h078000600E000008001878000F000000;
char[23] <= 128'h078000601E000000001878000F000000;
char[24] <= 128'h078000601E000000001878000F800000;
char[25] <= 128'h078000601E0000000018380007C00000;
char[26] <= 128'h078000601E00000000303C0007E00000;
char[27] <= 128'h078000603C00000000303C0007F00000;
char[28] <= 128'h078000603C00000000303C0003FC0000;
char[29] <= 128'h078000603C00000000301C0001FF0000;
char[30] <= 128'h078000603C00000000601E00007FC000;
char[31] <= 128'h078000603C00000000601E00003FF000;
char[32] <= 128'h078000603C00000000601E00000FFC00;
char[33] <= 128'h078000603C00000000600E000003FE00;
char[34] <= 128'h078000603C00000000E00E000000FF00;
char[35] <= 128'h078000603C00000000C00F0000003F80;
char[36] <= 128'h078000603C00000000C00F0000000FC0;
char[37] <= 128'h078000603C00000000FFFF00000007E0;
char[38] <= 128'h078000603C00000001FFFF00000003E0;
char[39] <= 128'h078000603C00000001800780000001E0;
char[40] <= 128'h078000601E00000001800780000001F0;
char[41] <= 128'h078000601E00000001800780000000F0;
char[42] <= 128'h078000601E00000803800780080000F0;
char[43] <= 128'h078000601E00000C030003C0180000F0;
char[44] <= 128'h078000601E00000C030003C0180000F0;
char[45] <= 128'h078000600F000008030003C01C0000F0;
char[46] <= 128'h078000600F000018070003C00C0000F0;
char[47] <= 128'h078000E007800010060001E00E0000E0;
char[48] <= 128'h038000C007800030060001E00E0001E0;
char[49] <= 128'h03C001C003C00060060001E00F0001C0;
char[50] <= 128'h01C0038001E000C00E0001E00F8003C0;
char[51] <= 128'h01E0070000F001C00E0001F00FC00780;
char[52] <= 128'h00F81E00007C07001F0001F807F81F00;
char[53] <= 128'h003FFC00001FFE007FC00FFE061FFC00;
char[54] <= 128'h000FE0000007F8007FC00FFE0407F000;
char[55] <= 128'h00000000000000000000000000000000;
char[56] <= 128'h00000000000000000000000000000000;
char[57] <= 128'h00000000000000000000000000000000;
char[58] <= 128'h00000000000000000000000000000000;
char[59] <= 128'h00000000000000000000000000000000;
char[60] <= 128'h00000000000000000000000000000000;
char[61] <= 128'h00000000000000000000000000000000;
char[62] <= 128'h00000000000000000000000000000000;
char[63] <= 128'h00000000000000000000000000000000;
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

