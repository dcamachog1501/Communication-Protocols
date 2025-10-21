module UART_RX(

    input RST,BAUD,DATA_IN,
    ouput STOP_BIT_ERROR,PARITY_ERROR,
    output [7:0] RX_OUT
);
    wire check_start,start_detected,shift,check_stop;

    start_detector strt_detect(.DATA_IN(DATA_IN),.CLK(BAUD),.RST(RST),.CHECK_START(check_start),.START_DETECTED(start_detected));
    sipo_reg sipo(.DATA_IN(DATA_IN),.CLK(BAUD),.RST(RST),.SHIFT(shift),.DATA_OUT(RX_OUT));
    parity_checker parity_chk(.DATA_IN(RX_OUT),.PARITY_IN(DATA_IN),.CLK(BAUD),.RST(RST),.CHECK_PARITY(check_parity),.PARITY_ERROR(PARITY_ERROR));
    stop_detector stp_detect(.DATA_IN(DATA_IN),.CLK(BAUD),.RST(RST),.CHECK_STOP(check_stop),.STOP_BIT_ERROR(STOP_BIT_ERROR));
    rx_fsm fsm(.START_DETECTED(start_detected),.PARITY_ERROR(PARITY_ERROR),.BAUD(BAUD),.RST(RST),.SHIFT(shift),.CHECK_PARITY(check_parity),.CHECK_START(check_start),.CHECK_STOP(check_stop));

endmodule