module stop_detector(

    input DATA_IN,CHECK_STOP,
    output reg STOP_BIT_ERROR

);

  always @(DATA_IN)
    begin
      if(CHECK_STOP)
        STOP_BIT_ERROR = ~DATA_IN;
      else
        STOP_BIT_ERROR=0;
    end
    
endmodule