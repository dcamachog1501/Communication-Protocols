`include "UART_TX.sv"

module TX_tb();

    reg tx_start,rst,baud,tx_out,tx_busy;
  	reg [7:0] data_in;

    integer i;
    reg [10:0] received_output;
  	reg [7:0] received_data;
    reg received_parity;

    UART_TX trans (.TX_START(tx_start) ,.RST(rst) , .BAUD(baud) , .DATA_IN(data_in), .TX_OUT(tx_out) , .TX_BUSY(tx_busy));
	
  	always #10baud = ~baud;
  
  	initial
    begin
      
      $dumpfile("dump.vcd"); 
      $dumpvars;
      
    end

    initial 
    begin
		baud = 0;
        tx_start = 0;
        data_in = 8'b0;

        rst = 1'b1;
        #100
        rst = 1'b0;

        for(i = 0; i<5; i=i+1)
        begin

            received_output=8'b0;
            data_in = $random();
            tx_start = 1;
          	@(posedge tx_busy);
            tx_start = 0;
          	@(negedge tx_busy);

            received_data = received_output[8:1];
            received_parity = received_output[9];

            if(received_data != data_in)
                $error("TEST FAILED! DATA MISMATCH ->Expected Output: %0b, Received Output: %0b",data_in,received_data);
            else if (received_parity != ^data_in)
                $error("TEST FAILED! PARITY MISMATCH -> Expected Parity: %0b, Received Parity: %0b",^data_in,received_parity);
            else if (received_output[0] != 0)
                $error("TEST FAILED! START BIT MISMATCH -> Expected: 0, Received: %0b",received_output[0]);
            else if (received_output[11] != 0)
                $error("TEST FAILED! STOP BIT MISMATCH -> Expected: 1, Received: %0b",received_output[11]);
            else
                $display("TEST PASSED! Expected Output: %0b, Received Output: %0b",data_in,received_data);
            
        end
      $finish();
    end

    always @(negedge baud)
    begin
        
        if(tx_busy)
        begin
          received_output = {tx_out,received_output[10:1]};
        end

    end
endmodule