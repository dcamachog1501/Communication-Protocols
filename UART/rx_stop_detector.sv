module stop_detector(

    input DATA_IN,CLK,RST,CHECK_STOP,
    output reg STOP_BIT_ERROR

);

    always @(posedge CLK, posedge RST)
    begin

        if(RST)
            STOP_BIT_ERROR = 0;
        else
            STOP_BIT_ERROR = DATA_IN;

    end
    
endmodule