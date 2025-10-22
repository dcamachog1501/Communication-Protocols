module start_detector(

    input DATA_IN,CHECK_START,
    output reg START_DETECTED

);

  always @(*)
    begin
      if(CHECK_START)
        START_DETECTED = ~DATA_IN;
      else
        START_DETECTED=0;
    end
    
endmodule