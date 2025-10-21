module rx_fsm(

   input START_DETECTED,PARITY_ERROR,BAUD,RST,
   output reg SHIFT,CHECK_PARITY,CHECK_START,CHECK_STOP

);

   typedef enum bit[1:0] {IDLE   = 2'b00,
                          DATA   = 2'b01,
                          PARITY = 2'b10,
                          STOP   = 2'b11} State;

   reg [1:0] current_state,next_state;
   reg [2:0] count;
   reg count_en;

   always @(posedge BAUD, posedge RST)
   begin
      
      if(RST)
      begin
         current_state = IDLE;
         next_state = IDLE;
         count = 0;
      end

      else
      begin
         
         case(current_state)
            IDLE : next_state = (START_DETECTED)? DATA : IDLE;
            DATA : next_state = (count == 7)? PARITY : DATA;
            PARITY : next_state = (PARITY_ERROR)? IDLE : STOP;
            STOP : next_state = IDLE;
         endcase

         count = (count_en)? count + 1 : 0;

      end
   end

   always @(negedge BAUD or posedge RST)
   begin
      current_state = next_state;

      if(RST)
      begin
         SHIFT=0;
         CHECK_PARITY=0;
         CHECK_START=1;
         CHECK_STOP=0;
      end
      else
      begin
         case(current_state)

            IDLE:begin
               SHIFT=0;
               CHECK_PARITY=0;
               CHECK_START=1;
               CHECK_STOP=0;
               count_en=0;
            end

            DATA:begin
               SHIFT=1;
               CHECK_PARITY=0;
               CHECK_START=0;
               CHECK_STOP=0;
               count_en=1;
            end

            PARITY:begin
               SHIFT=0;
               CHECK_PARITY=1;
               CHECK_START=0;
               CHECK_STOP=0;
               count_en=0;
            end

            STOP:begin
               SHIFT=0;
               CHECK_PARITY=0;
               CHECK_START=0;
               CHECK_STOP=1;
               count_en=0;
            end
         endcase
      end
   end
endmodule