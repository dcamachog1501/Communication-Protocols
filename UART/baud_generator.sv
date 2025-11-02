module baud_generator#(parameter RX_BRD =27,
                       parameter TX_BRD = 434)
(
input RST,CLK,
output reg CLK_RX,CLK_TX
);
	
  	parameter CNT_TX_WIDTH = $clog2(TX_BRD);
  	parameter CNT_RX_WIDTH = $clog2(RX_BRD);
  
  	reg[CNT_TX_WIDTH - 1:0] counter_tx;
  	reg[CNT_RX_WIDTH - 1:0] counter_rx;

    always @(posedge CLK, posedge RST)
    begin
        if(RST)
        begin
            CLK_RX = 0;
            counter_rx = 0; 
        end
        
      else if(counter_rx == (RX_BRD-1))
        begin
            CLK_RX = 1;
            counter_rx=0;
        end

        else
        begin
          	CLK_RX = 0;
            counter_rx++;
        end

        
    end

    always @(posedge CLK, posedge RST)
    begin
        if(RST)
        begin
          	CLK_TX = 1;
            counter_tx = 0;
        end

      else if(counter_tx == (TX_BRD - 1))
        begin
            CLK_TX=1;
            counter_tx = 0;
        end

        else
        begin
          	CLK_TX=0;
            counter_tx ++;
        end
    end
endmodule