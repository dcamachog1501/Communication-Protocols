`include "UART_RX.sv"
`include "UART_TX.sv"
`include "baud_generator.sv"
	
module complete_tb();

    reg tx_start,rst,tx_out,tx_busy;
  	reg [7:0] tx_data_in;

    reg stop_bit_error,parity_error,done;
    reg [7:0] rx_out;

    reg tx_clk,rx_clk,clk;

    UART_TX trans (.TX_START(tx_start) ,.RST(rst) , .BAUD(tx_clk) , .DATA_IN(tx_data_in), .TX_OUT(tx_out) , .TX_BUSY(tx_busy));
    UART_RX receive (.RST(rst),.BAUD(rx_clk),.DATA_IN(tx_out),.STOP_BIT_ERROR(stop_bit_error),.PARITY_ERROR(parity_error),.RX_OUT(rx_out),.DONE(done));
    baud_generator brg (.RST(rst),.CLK(clk),.CLK_TX(tx_clk),.CLK_RX(rx_clk));

    int bits_sent;
	
  	initial
    begin
      
      $dumpfile("dump.vcd"); 
      $dumpvars;
      
    end
  	
  	always
      #10clk=~clk;
  
    initial
    begin
		clk = 0;
        bits_sent = 0;
      	
      	tx_start = 0;

        rst = 1;
        #100;
        rst = 0;
      	#100;
      $dumpoff();
      for(int i = 0; i <5; i++)
        begin
		  $dumpoff();
          if(i == 4)
            $dumpon();
          
          tx_data_in = 8'b01100011;//$random();
          $display("Data to Transmit: %8b",tx_data_in);
            tx_start = 1;
          @(posedge done);
          $display("Data Received: %8b",rx_out);

        end
      	$finish();
    end
   
endmodule