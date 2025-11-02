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
    bit count_en;

    reg [2:0] count;

    always @(posedge BAUD or posedge RST)
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
                IDLE   : next_state = (TX_START)? START : IDLE;
                START  : next_state = DATA;
                DATA   : next_state = (count == 7)? PARITY : DATA;
                PARITY : next_state = STOP;
                STOP   : next_state=(TX_START)? START : IDLE;
            endcase

            count = (count_en)? count + 1 : 0;
        end
    end

  	always @(negedge BAUD or posedge RST)
    begin

        if(RST)
        begin
            SHIFT = 0;
            LOAD = 0;
            SEL = 2'b11;
            TX_BUSY = 0;
        end

        else
        begin
			current_state = next_state;
            case(current_state)

                IDLE : begin
                    SHIFT = 0;
                    LOAD = 0;
                    SEL = 2'b11;
                    TX_BUSY = 0;
                    count_en = 0;
                end

                START : begin
                    SHIFT = 0;
                    LOAD = 1;
                    SEL = 2'b00;
                    TX_BUSY = 1;
                    count_en = 0;
                end

                DATA : begin
                    SHIFT = 1;
                    LOAD = 0;
                    SEL = 2'b01;
                    TX_BUSY = 1;
                    count_en = 1;
                end

                PARITY : begin
                    SHIFT = 0;
                    LOAD = 0;
                    SEL = 2'b10;
                    TX_BUSY = 1;
                    count_en = 0;
                end

                STOP : begin
                    SHIFT = 0;
                    LOAD = 0;
                    SEL = 2'b11;
                    TX_BUSY = 1;
                    count_en = 0;
                end
            endcase
        end
    end
endmodule