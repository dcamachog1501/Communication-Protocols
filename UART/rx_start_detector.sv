module start_detector(

    input DATA_IN,CLK,RST,CHECK_START,
    output reg START_DETECTED

);

    always @(posedge CLK, posedge RST)
    begin

        if(RST || ~ CHECK_START)
            START_DETECTED = 0;
        else
            START_DETECTED = ~DATA_IN;
    end
    
endmodule