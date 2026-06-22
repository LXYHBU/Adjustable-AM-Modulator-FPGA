`timescale 1ns / 1ps
module ADDA_tb();
reg Clk;
reg Rst;
reg [11:0] ad1_in;
reg [11:0] ad2_in;
wire [13:0] da1_out;
wire [13:0] da2_out;
wire ad1_clk;
wire ad2_clk;
wire da1_clk;
wire da1_wrt;
wire da2_clk;
wire da2_wrt;
initial begin
    Clk=0;
    Rst=1;
    ad1_in=12'd0;
    ad2_in=12'd0;
    #100;
    Rst=0;
    #100 ;
    Rst=1;
    #500;
end
always #10 Clk=~Clk;
always #10 ad1_in<=ad1_in+12'd1;
always #10 ad2_in<=ad2_in+12'd10;
ADDA inst0(
    .Clk(Clk),
    .Rst(Rst),
    //AD9238
    .ad1_in(ad1_in),
    .ad1_clk(ad1_clk),

    .ad2_in(ad2_in),
    .ad2_clk(ad2_clk),

    //AN9767
    .da1_out(da1_out),
    .da1_clk(da1_clk),
    .da1_wrt(da1_wrt),

    .da2_out(da2_out),
    .da2_clk(da2_clk),
    .da2_wrt(da2_wrt)

);
endmodule
