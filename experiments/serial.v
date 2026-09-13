module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 
    reg [3:0] state, next_state;
    reg [2:0] count;
    parameter UNKNOWN = 0, COUNTING = 1, DONE = 2, CHECK = 3, RECOVERY = 4; 
    
    // State transition logic (combinational)
    always @(*) begin 
        next_state = state;
        case(state)
            UNKNOWN: next_state = in == 0 ? COUNTING : UNKNOWN;
            COUNTING: begin
                if (count == 7) next_state = CHECK;
            end
            CHECK: next_state = in == 1 ? DONE : RECOVERY;
            RECOVERY: next_state = in == 1 ? UNKNOWN: RECOVERY;
            DONE: next_state = in == 0 ? COUNTING : UNKNOWN;
        endcase
    end

    // State flip-flops (sequential)
    always @(posedge clk) begin
        if (reset) begin
            state <= UNKNOWN;
            count <= 0;
        end
        else begin
            state <= next_state;
            if (state == COUNTING) count <= count == 7 ? 0 : count + 1;
        end
    end
            
 
    // Output logic
    assign done = (state == DONE);

endmodule
