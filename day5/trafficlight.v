module trafficlight(
    input clk,
    input rst,    // synchronous reset to GREEN
    output [1:0] light   // 2'b00 = GREEN, 2'b01 = YELLOW, 2'b10 = RED
);
    parameter GREEN = 0, YELLOW = 1, RED = 2;
    reg [1:0] state, next_state, counter;

    always @(*) begin
        next_state = state;
        case(state) 
            RED: if (counter >= 2) next_state = GREEN;
            YELLOW: if (counter >= 1) next_state = RED;
            GREEN: if (counter >= 3) next_state = YELLOW;
        endcase
    end

    always @(posedge clk) begin
        if (rst) begin 
            state <= GREEN;
            counter <= 0;
        end
        else begin
            state <= next_state;
            if (state == next_state) counter <= counter + 1;
            else counter <= 1;
        end
    end

    assign light = state;

endmodule 