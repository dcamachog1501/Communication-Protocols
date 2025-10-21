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
          TEMP=IN;
      
        else if(SHIFT)
        begin
            
          	OUT= TEMP[0];
            TEMP= TEMP>>1;
            
        end
    end
endmodule