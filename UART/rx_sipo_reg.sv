module sipo_reg(

    input DATA_IN,CLK,RST,SHIFT,
    output reg[7:0] DATA_OUT

);

    always @(posedge CLK, posedge RST)
    begin

        if(RST)
            DATA_OUT = 8'b0;
        else if (SHIFT)
          DATA_OUT = {DATA_IN,DATA_OUT[7:1]};

    end

endmodule