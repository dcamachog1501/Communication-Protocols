module parity_gen(
    input [7:0] IN,
    input RST,LOAD,CLK,
    output reg OUT
);

  always @(posedge RST, posedge CLK)
    begin
        if(RST)
            OUT = 0;
        
        else if(LOAD)
            OUT = ^IN;
    end
endmodule