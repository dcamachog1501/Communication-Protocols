module tx_fsm(
    input TX_START,RST,BAUD,
    output reg SHIFT,LOAD,SEL,TX_BUSY
);

    typedef enum {IDLE,START,DATA,PARITY,STOP} States;

    reg [2:0] current_state,next_state;

    reg [2:0] count;

    always @(posedge BAUD or posedge RST)
    begin

        if(RST)
        begin
            current_state <= IDLE;
            next_state <= IDLE;
            count <= 0;
        end

        else if(BAUD)
        begin
            case(current_state)

                IDLE   : next_state <= (TX_START)? START : IDLE;
                START  : next_state <= DATA;
                DATA   : next_state <= (count == 7)? PARITY : DATA;
                PARITY : next_state <= STOP;
                STOP   : next_state <= IDLE;

            endcase

            count <= (current_state == DATA)? count + 1 : 0;
        end
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

            current_state = next_state;

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