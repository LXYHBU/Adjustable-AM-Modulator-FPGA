module key_filter(
    input Clk,
    input Rst,
    input Key,
    output reg P_flag
);    
    reg R_flag;
    parameter IDLE=0;
    parameter P_FILTER=1;
    parameter WAIT_R=2;
    parameter R_FILTER=3;
    reg [1:0] state;
    wire nedge,pedge,time_20ms_reached;
    reg dff1,dff2,r_key;
    
    parameter MCNT=1_000_000-1;
    reg [24:0]cnt;
    always@(posedge Clk or posedge Rst)begin
        if(Rst)
            cnt<=0;
        else if((state==P_FILTER)||(state==R_FILTER))begin
            if(cnt==MCNT)
                cnt<=0;
            else cnt<=cnt+1;
        end
        else if((P_flag==1)||(R_flag==1))
            cnt<=0;
        else cnt<=0;
    end
    always@(posedge Clk)begin
        dff1<=Key;
    end
    always@(posedge Clk)begin
        dff2<=dff1;
    end
    always@(posedge Clk)begin
        r_key<=dff2;
    end
    assign nedge=(dff2==0)&&(r_key==1);
    assign pedge=(dff2==1)&&(r_key==0);
    assign time_20ms_reached=(cnt>=MCNT);
    always@(posedge Clk or posedge Rst)begin
        if(Rst)begin
            state<=IDLE;
            R_flag<=0;
            P_flag<=0;
        end
        else begin
            case(state)
            IDLE:begin
                R_flag<=0;
                if(nedge)
                    state<=P_FILTER;
                else state<=state;
            end
            P_FILTER:begin
                if(time_20ms_reached)begin
                    state<=WAIT_R;
                    P_flag<=1;
                end
                else if(pedge)
                    state<=IDLE;
                else state<=state;
            end
            WAIT_R:begin
                P_flag<=0;
                if(pedge)
                    state<=R_FILTER;
                else state<=state;
            end
            R_FILTER:begin
                if(time_20ms_reached)begin
                    state<=IDLE;
                    R_flag<=1;
                end
                else if(nedge)
                    state<=WAIT_R;
                else state<=state;
            end
               
            endcase
        end
    end  
endmodule

