module v_da(
    input da_clk,
    input Rst,
    input  [23:0] ad_ch1_data, // 来自AD通道1的数据
    input  [11:0] ad_ch2_data, // 来自AD通道2的数据
    output reg [13:0] da1_out, // DA通道1输出数据
    output reg [13:0] da2_out  // DA通道2输出数据
);
// 处理AM_out（23位）→14位DA
reg [23:0] scaled_data;
reg signed [13:0] da1_temp;

always @(posedge da_clk or negedge Rst) begin
    if (!Rst) begin
        scaled_data <= 0;
        da1_temp <= 0;
        da1_out <= 0;
    end else begin
        // 步骤1：缩放（假设AM_out峰值约2^22，右移9位到14位范围）
        scaled_data <= ad_ch1_data >>> 9;  // 算术右移，保留符号
        
        // 步骤2：四舍五入（加2^8再右移1位）
        da1_temp <= (scaled_data + 23'd256) >>> 1;
        
        // 步骤3：限制范围（防止溢出）
        if (da1_temp > 14'sd8191)
            da1_out <= 14'sd8191;  // 上限
        else if (da1_temp < -14'sd8192)
            da1_out <= -14'sd8192; // 下限
        else
            da1_out <= da1_temp;
    end
end

always @(posedge da_clk or negedge Rst) begin
    if (!Rst) da2_out <= 14'b0;
    else da2_out <= {ad_ch2_data,2'b00};
end
endmodule
