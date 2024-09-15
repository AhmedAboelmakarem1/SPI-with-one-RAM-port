module SPI_Slave(MOSI,tx_valid,tx_data,rst_n,clk,SS_n,MISO,rx_valid,rx_data);
input MOSI,tx_valid,rst_n,clk,SS_n;
input [7:0] tx_data;
output reg MISO,rx_valid;
output reg[9:0] rx_data;
reg [2:0] cs,ns;
reg flag;
reg [3:0] count1;
reg [3:0] count2;
localparam idle=3'b000;
localparam chk_cmd=3'b001;
localparam write=3'b010;
localparam read_add=3'b011;
localparam read_data=3'b100;
always@(posedge clk or negedge rst_n) begin
if(!rst_n) 
begin cs<=3'b000;flag=1'b0;end
else 
cs<=ns;
end
always@(cs,MOSI,SS_n)begin
case(cs)
idle: ns=SS_n?idle:chk_cmd;
chk_cmd: 	
	begin
	if(SS_n==1'b0 && MOSI==1'b0)
	ns=write;
	else if(SS_n==1'b0 && MOSI==1'b1 && flag==1'b0)
	begin ns=read_add;flag=1'b1 ;end 
	else if(SS_n==1'b0 && MOSI==1'b1 && flag==1'b1)
	begin ns=read_data;flag=1'b0 ;end 
	else if(SS_n==1'b1)
	ns=idle;
	end
write:
	begin
	if(SS_n==1'b0)
	ns=write;
	else if(SS_n==1'b1)
	ns=idle;
	end
read_add:
	begin
	if(SS_n==1'b0)
	ns=read_add;
	else if(SS_n==1'b1)
	ns=idle;
	end
read_data:
	begin
	if(SS_n==1'b0)
	ns=read_data;
	else if(SS_n==1'b1)
	ns=idle;
	end
default: ns=3'b000;
endcase
end
always@(posedge clk)
begin
case(cs)
idle:
	begin
	count1=4'b0;count2=4'b0;
	end
chk_cmd:
	begin
	rx_valid=1'b0;rx_data='b0;MISO=1'b0;
	end
write:
	begin
	if(count1<4'd10)
	begin rx_data[4'd9-count1]=MOSI;rx_valid=1'b0;count1=count1+1; end
	else if(count1==4'd10)
	begin rx_valid=1'b1;count1=1'b0;end
	end
read_add:
	begin
	if(count1<4'd10)
	begin rx_data[4'd9-count1]=MOSI;rx_valid=1'b0;count1=count1+1;  end
	else if(count1==4'd10)
	begin rx_valid=1'b1;count1=1'b0;end
	end
read_data:
	begin
	if(tx_valid && count2<4'd8)
	begin MISO=tx_data[4'd7-count2];count2=count2+1;end
	else if(count1<4'd10)
	begin rx_data[4'd9-count1]=MOSI;count1=count1+1; end
	else if(count1==4'd10)
	begin rx_valid=1'b1;count1=1'b0;end
	end
default:begin rx_valid=1'b0;rx_data='b0;MISO=1'b0; end
endcase
end
endmodule




