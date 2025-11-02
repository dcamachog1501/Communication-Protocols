`include "rx_start_detector.sv"
`include "rx_fsm.sv"
`include "rx_parity_checker.sv"
`include "rx_sipo_reg.sv"
`include "rx_stop_detector.sv"

module UART_RX(

    input RST,BAUD,DATA_IN,
    output STOP_BIT_ERROR,PARITY_ERROR,DONE,
    output [7:0] RX_OUT
);
    wire check_start,start_detected,shift,check_stop,check_parity,sample;
  
    start_detector strt_detect(.DATA_IN(DATA_IN),
                               .CHECK_START(check_start),
                               .START_DETECTED(start_detected));

    sipo_reg sipo(.DATA_IN(DATA_IN),
                  .CLK(sample),
                  .RST(RST),
                  .SHIFT(shift),
                  .DATA_OUT(RX_OUT));

    parity_checker parity_chk(.DATA_IN(RX_OUT),
                              .PARITY_IN(DATA_IN),
                              .CLK(sample),.RST(RST),
                              .CHECK_PARITY(check_parity),
                              .PARITY_ERROR(PARITY_ERROR));

    stop_detector stp_detect(.DATA_IN(DATA_IN),
                             .CHECK_STOP(check_stop),
                             .STOP_BIT_ERROR(STOP_BIT_ERROR));

    rx_fsm fsm(.START_DETECTED(start_detected),
               .PARITY_ERROR(PARITY_ERROR),
               .BAUD(BAUD),
               .RST(RST),
               .SHIFT(shift),
               .CHECK_PARITY(check_parity),
               .CHECK_START(check_start),
               .CHECK_STOP(check_stop),
               .SAMPLE(sample),
               .DONE(DONE));

endmodule