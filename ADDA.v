module ADDA(
    input Clk,
    input Rst,
    //AD9238
    input [11:0] ad1_in,
    output ad1_clk,

    input [11:0] ad2_in,
    output ad2_clk,

    //AN9767
    output [13:0] da1_out,
    output da1_clk,
    output da1_wrt,

    output [13:0] da2_out,
    output da2_clk,
    output da2_wrt,
    input Key 


);
/////////////////////////PLL时钟////////////////////////////
//ADC
wire AD_CLK;
assign ad1_clk=AD_CLK;
assign ad2_clk=AD_CLK;
//DAC
//wire DA_CLK;
assign da1_clk=AD_CLK;
assign da2_clk=AD_CLK;
assign da1_wrt=AD_CLK;
assign da2_wrt=AD_CLK;
//assign da1_clk=DA_CLK;
//assign da2_clk=DA_CLK;
//assign da1_wrt=DA_CLK;
//assign da2_wrt=DA_CLK;
clk_wiz_0 inst0
(
    .clk_out1(AD_CLK),    //65M
    .clk_out2(),    //125M
    .reset(0), 
    .locked(),  
    .clk_in1(Clk)
); 
/////////////////////////AD采集////////////////////////////
wire [11:0] ad_ch1;
wire [11:0] ad_ch2;
v_ad inst1(
    .ad1_clk(ad1_clk),
    .ad2_clk(ad2_clk),
    .Rst(Rst),
    .ad1_in(ad1_in),//input [11:0] ad1_in
    .ad2_in(ad2_in),//input [11:0] ad2_in,
    .ad_ch1(ad_ch1),//out [11:0] ad_ch1锁存后的
    .ad_ch2(ad_ch2) //out [11:0] ad_ch2
);
/////////////////////////AM调制////////////////////////////
reg [2:0]depth;//按键控制
wire [23:0] AM_middle_out;
AM inst2(
    .Clk(AD_CLK),
    .Rst(Rst),
    .depth(depth),
    .sin_carrier(ad_ch1),//载波
    .sin_modulate(ad_ch2),//调制波
    .AM_out(AM_middle_out)
);
/////////////////////////DA输出////////////////////////////
v_da inst3(
    .da_clk(AD_CLK),
    .Rst(Rst),
    .ad_ch1_data(AM_middle_out), // 来自AD通道1的数据ad_ch1
    .ad_ch2_data(ad_ch2), // 来自AD通道2的数据ad_ch2
    .da1_out(da1_out), // DA通道1输出数据
    .da2_out(da2_out)  // DA通道2输出数据
);
/////////////////////////按键////////////////////////////
wire P_flag;
key_filter inst4(
    .Clk(AD_CLK),
    .Rst(Rst),
    .Key(Key),
    .P_flag(P_flag)
);    
always @(posedge AD_CLK or negedge Rst) begin
    if(!Rst)
        depth<=0;
    else if(P_flag)begin
        if(depth>6)
            depth<=0;
        else 
            depth<=depth+1;
    end
end
endmodule
