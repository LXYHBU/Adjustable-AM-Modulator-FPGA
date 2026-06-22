module AM(
    input Clk,
    input Rst,
    input [2:0]depth,
    input [11:0]sin_carrier,//载波
    input [11:0]sin_modulate,//调制波
    output [23:0] AM_out
);
////////////////////////////////////////调制////////////////////////////////////////////////
reg [11:0]A=11'd2047 ;
reg signed[12:0]depth_con ;
always @(posedge Clk) begin
  if(!Rst)
    depth_con<=0;
  else 
        case (depth)
        //0: depth_con<=0;//0%
        //1: depth_con<=13;//10%
        //2: depth_con<=28;//20%
        0: depth_con<=45*16;
        1: depth_con<=64*16;
        2: depth_con<=85*16;
        3: depth_con<=110*16;
        4: depth_con<=138*16;
        5: depth_con<=171*16;
        6: depth_con<=209*16;
        //7: depth_con<=255;//100%
        default: depth_con<=0;
    endcase
end
wire signed[24:0]modulate_mul8ma;
wire signed[11:0] modulate_mulma;
reg [11:0] modulate_withdc;
mult_gen_0 inst3 (
  .CLK(Clk),  // input wire CLK
  .A(sin_modulate),      // input wire [11 : 0] A
  .B(depth_con),      // input wire [12 : 0] B
  .P(modulate_mul8ma)      // output wire [24 : 0] P
);
assign modulate_mulma = modulate_mul8ma >> 12;//缩放
always@(posedge Clk)begin
    modulate_withdc <=  modulate_mulma + A;//叠加直流
end
mult_gen_1 inst4 (//乘载波
  .CLK(Clk),  // input wire CLK
  .A(modulate_withdc),      // input wire [11 : 0] A
  .B(sin_carrier),      // input wire [11 : 0] B
  .P(AM_out)      // output wire [23 : 0] P
);
/*reg [23:0] AM_abs;
always @(posedge Clk ) begin//全波整流
  if(AM_out[23] == 1) begin  // 符号位为1（负数）
    AM_abs <= -{AM_out};     // 取绝对值
  end else begin
    AM_abs <= AM_out;        // 正数直接保留
  end
end*/
endmodule
