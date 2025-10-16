module parity_gen(
    input [7:0] IN,
    input RST,LOAD,
    output reg OUT
);

    always @(posedge RST or posedge LOAD)
    begin
        if(RST)
            OUT <= 0;
        
        else if(LOAD)
            OUT <= ^IN;
    end
endmodule