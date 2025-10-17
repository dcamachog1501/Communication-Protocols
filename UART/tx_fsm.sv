module tx_fsm(
    input TX_START,RST,BAUD,
    output reg SHIFT,LOAD,TX_BUSY,
    output reg [1:0] SEL
);

  typedef enum logic [2:0] {IDLE   = 3'b000,
                            START  = 3'b001,
                            DATA   = 3'b010,
                            PARITY = 3'b011,
                            STOP   = 3'b100} State;

    State current_state, next_state;

    reg [2:0] count;

    always @(posedge BAUD or posedge RST)
    begin

        if(RST)
        begin
            current_state = IDLE;
            next_state = IDLE;
            count = 0;
        end

        else if(BAUD)
        begin
            case(current_state)

                IDLE   : begin
                            next_state = (TX_START)? START : IDLE;
                            SEL = 2'b00;
                end

                START  : begin
                            next_state = DATA;
                            SEL = 2'b00;
                end

                DATA   : begin
                            next_state = (count == 7)? PARITY : DATA;
                            SEL = 2'b01;
                end

                PARITY : begin
                            next_state = STOP;
                            SEL = 2'b10;
                end

                STOP   : begin
                  			next_state=(TX_START)? START : IDLE;
                            SEL = 2'b11;
                end

            endcase

            count = (current_state == DATA)? count + 1 : 0;
        end
    end

    always @(negedge BAUD)
    begin
        if(current_state == DATA)
            SHIFT = 0;

         current_state = next_state;
    end

    always @(posedge BAUD or posedge RST)
    begin

        if(RST)
        begin
            SHIFT = 0;
            LOAD = 0;
            SEL = 2'b00;
            TX_BUSY = 0;
        end

        else if(BAUD)
        begin

            case(current_state)

                IDLE : begin
                    SHIFT = 0;
                    LOAD = 0;
                    SEL = 2'b00;
                    TX_BUSY = 0;
                end

                START : begin
                    SHIFT = 0;
                    LOAD = 1;
                    SEL = 2'b00;
                    TX_BUSY = 1;
                end

                DATA : begin
                    SHIFT = 1;
                    LOAD = 0;
                    SEL = 2'b01;
                    TX_BUSY = 1;
                end

                PARITY : begin
                    SHIFT = 0;
                    LOAD = 0;
                    SEL = 2'b10;
                    TX_BUSY = 1;
                end

                STOP : begin
                    SHIFT = 0;
                    LOAD = 0;
                    SEL = 2'b11;
                    TX_BUSY = 1;
                end
            endcase
        end
    end
endmodule