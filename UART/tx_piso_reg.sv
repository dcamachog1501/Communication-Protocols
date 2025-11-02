module piso_reg(

    input [7:0] IN,
    input SHIFT,RST,LOAD,CLK,
    output reg OUT

);

  reg [7:0] TEMP;

  always @(posedge CLK,posedge RST)
    begin
        if(RST)
        begin
          TEMP=8'b0;
      		OUT=0;
        end
      	
        else if (LOAD)
        begin
          TEMP=IN;
          OUT= TEMP[0];
        end
      
        else if(SHIFT)
        begin
            TEMP= TEMP>>1;
          	OUT= TEMP[0];
        end
    end
endmodule