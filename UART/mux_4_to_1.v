module mux_4_to_1(
    input [3:0] IN,
    input [1:0] SEL,
    output reg OUT
);

    always @(*) 
    begin

        case(SEL)

            2'b00: OUT=IN[0];
            2'b01: OUT=IN[1];
            2'b10: OUT=IN[2];
            2'b11: OUT=IN[3];

        endcase
        
    end

endmodule