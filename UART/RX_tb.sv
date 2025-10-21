`include "UART_RX.sv"

module RX_tb;

    reg rst,clk;
    reg data_in,stop_bit_error,parity_error;
    reg [7:0] rx_out;

    reg [7:0] temp_data;

    reg [7:0] received_data;
    reg received_parity_error,received_stop_error;

    int counter;

    UART_RX receive (.RST(rst),.BAUD(clk),.DATA_IN(data_in),.STOP_BIT_ERROR(stop_bit_error),.PARITY_ERROR(parity_error),.RX_OUT(rx_out));

    always
        #10clk=~clk;
    
  	initial
    begin
      
      $dumpfile("dump.vcd"); 
      $dumpvars;
      
    end

    always @(negedge clk)
    begin
      
      if(counter == 9)
        received_data = rx_out;
      else if (counter == 10)
        received_parity_error = parity_error;
      else if (counter == 11)
        received_stop_error = stop_bit_error;

    end

    initial
    begin

        clk=0;
        data_in = 1;
        rst = 1;
        #100;
        rst = 0;

        received_data = 8'b0;
        received_stop_error = 0;
        received_parity_error = 0;

        for(int i = 0; i < 5; i++)
        begin

            //Setting the data to be sent
            temp_data = $random();

            counter = 0;

            while(counter < 12)
            begin
              case(counter)
                               0: data_in = 0;
                 1,2,3,4,5,6,7,8: data_in = temp_data[counter - 1];
                               9: data_in = ^temp_data;
                              10: data_in = 1;
              endcase
              @(negedge clk);
              counter++;
            end

            if(received_data != temp_data)
                $error("TEST FAILED! DATA MISMATCH ->Expected Output: %0b, Received Output: %0b",temp_data,received_data);
            else if (received_parity_error)
                $error("TEST FAILED! PARITY MISMATCH -> Expected Parity: %0b",^temp_data);
          	else if (received_stop_error)
                $error("TEST FAILED! STOP BIT MISMATCH -> Expected: 1");
            else
              $display("TEST PASSED! Expected Output: %0b, Received Output: %0b",temp_data,received_data);
        end
        $finish();
    end
endmodule