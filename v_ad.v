module v_ad(
    input ad1_clk,
    input ad2_clk,
    input Rst,
    input [11:0] ad1_in,
    input [11:0] ad2_in,
    output reg [11:0] ad_ch1,
    output reg [11:0] ad_ch2
);
always @(posedge ad1_clk or negedge Rst) begin
    if(!Rst)
        ad_ch1<=12'b0;
    else 
        ad_ch1<=ad1_in;
end
always @(posedge ad2_clk or negedge Rst) begin
    if(!Rst)
        ad_ch2<=12'b0;
    else 
        ad_ch2<=ad2_in;
end
endmodule
