module rx_fsm(

   input START_DETECTED,PARITY_ERROR,BAUD,RST,
   output reg SHIFT,CHECK_PARITY,CHECK_START,CHECK_STOP,DONE,
   output SAMPLE

);

   wire DATA_DONE,NEXT;

   typedef enum bit[1:0] {IDLE   = 2'b00,
                          DATA   = 2'b01,
                          PARITY = 2'b10,
                          STOP   = 2'b11} State;

   reg [1:0] current_state,next_state;
   reg [3:0] count;
   reg [3:0] b_count;
   reg count_en;

   assign SAMPLE = b_count == 7;
   assign NEXT = b_count == 15;
   assign DATA_DONE = count == 8;

   always @(posedge BAUD, posedge RST)
   begin
      
      if(RST)
      begin
         current_state = IDLE;
         next_state = IDLE;
         count = 0;
         b_count = 0;
      end

      else
      begin
         
         if(NEXT)
         begin
            case(current_state)
               IDLE : next_state = (START_DETECTED)? DATA : IDLE;
               DATA : next_state = (DATA_DONE)? PARITY : DATA;
               PARITY : next_state = (PARITY_ERROR)? IDLE : STOP;
               STOP : next_state = IDLE;
            endcase
         end
         b_count = b_count + 1;
         count = (count_en)? (count + SAMPLE) : 0;
         
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
         DONE=0;
      end
      else
      begin
         case(current_state)

            IDLE:begin
               SHIFT=0;
               CHECK_PARITY=0;
               CHECK_START=1;
               CHECK_STOP=0;
               DONE=0;
               count_en=0;
            end

            DATA:begin
               SHIFT=1;
               CHECK_PARITY=0;
               CHECK_START=0;
               CHECK_STOP=0;
               DONE=0;
               count_en=1;
            end

            PARITY:begin
               SHIFT=0;
               CHECK_PARITY=1;
               CHECK_START=0;
               CHECK_STOP=0;
               DONE=0;
               count_en=0;
            end

            STOP:begin
               SHIFT=0;
               CHECK_PARITY=0;
               CHECK_START=0;
               CHECK_STOP=1;
               DONE=1;
               count_en=0;
            end
         endcase
      end
   end
endmodule