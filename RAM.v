module RAM #(parameter add_size=8,parameter mem_depth=256) 
(din,clk,rst_n,rx_valid,tx_valid,dout);
input clk,rst_n,rx_valid;
input [9:0] din;
output reg tx_valid;
output reg [7:0] dout;
reg [7:0] mem [0:mem_depth-1];
reg [add_size-1:0] write_add,read_add;
integer i;
always@(posedge clk or negedge rst_n)
begin
if (!rst_n) 
begin
for(i=0;i<mem_depth;i=i+1)
mem[i]<=8'b0;
tx_valid<=1'b0; 
end
else 
begin 
if(rx_valid) 
	begin
	case(din[9:8])
	2'b00:write_add<=din[7:0];
	2'b01:mem[write_add]<=din[7:0];
	2'b10:read_add<=din[7:0];
	default:begin tx_valid=1'b0;dout='b0;end
	endcase
	end
if(2'b11==din[9:8])
	begin
	tx_valid<=1'b1;dout<=mem[read_add];
	end
end
end
endmodule
