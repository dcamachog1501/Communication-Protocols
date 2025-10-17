`include "mux_4_to_1.sv"
`include "parity_gen.sv"
`include "piso_reg.sv"
`include "tx_fsm.sv"


module UART_TX(
    input TX_START,RST,BAUD,
    input [7:0] DATA_IN,
    output TX_OUT,TX_BUSY
);

    wire shift,load;
    wire [1:0] sel;
    wire [3:0] mux_in;

    assign mux_in[0] = 0;
    assign mux_in[3] = 1;

    tx_fsm fsm (.TX_START(TX_START), .RST(RST), .BAUD(BAUD), .SHIFT(shift), .LOAD(load), .SEL(sel), .TX_BUSY(TX_BUSY));
  	parity_gen p_gen (.IN(DATA_IN), .RST(RST), .LOAD(load), .OUT(mux_in[2]), .CLK(BAUD));
    piso_reg piso_reg (.IN(DATA_IN), .SHIFT(shift) , .RST(RST) ,.LOAD(load), .OUT(mux_in[1]), .CLK(BAUD));
    mux_4_to_1 mux (.IN(mux_in), .SEL(sel), .OUT(TX_OUT));

endmodule