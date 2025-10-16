module piso_reg(

    input [7:0] IN,
    input SHIFT,RST,LOAD,
    output reg OUT

);

    reg [7:0] TEMP;

    always @(posedge SHIFT or posedge LOAD or posedge RST)
    begin
        if(RST)
            TEMP<=8'b0;
        
        else if(LOAD)
            TEMP<=IN;
        
        else if(SHIFT)
        begin
            
            TEMP<= TEMP>>1;
            OUT<= TEMP[0];

        end
    end
endmodule