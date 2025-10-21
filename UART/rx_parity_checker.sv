module parity_checker(

    input [7:0] DATA_IN,
    input PARITY_IN,
    input CLK,RST,CHECK_PARITY,
    output reg PARITY_ERROR

);

    always @(posedge CLK, posedge RST)
    begin
        if(RST)
            PARITY_ERROR = 0;
        
        else if (CHECK_PARITY)
            PARITY_ERROR = ^(DATA_IN) & PARITY_IN;
    end

endmodule