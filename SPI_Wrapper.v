module SPI_Wrapper(MOSI,MISO,SS_n,rst_n,clk);
input MOSI,SS_n,clk,rst_n;
output MISO;
wire tx_valid,rx_valid;
wire [9:0] din;
wire [7:0] dout;
SPI_Slave mod(MOSI,tx_valid,dout,rst_n,clk,SS_n,MISO,rx_valid,din);
RAM  mod2(din,clk,rst_n,rx_valid,tx_valid,dout);
endmodule
