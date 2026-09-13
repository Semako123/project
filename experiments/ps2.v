module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done); //
	
    parameter UNKNOWN = 0, COUNTING = 1, DONE = 2;
    reg [1:0] count, state, next_state;
   
    // State transition logic (combinational)
    always @(*) begin
        next_state = UNKNOWN;
        case(state)
            UNKNOWN: next_state = in[3] ? COUNTING : UNKNOWN;
            COUNTING: next_state = count == 1 ? DONE: COUNTING; 
            DONE: next_state = in[3] ? COUNTING : UNKNOWN;
        endcase
    end

    // State flip-flops (seqauential)
    always @(posedge clk) begin
        if (reset) begin
            state <= UNKNOWN;
            count <= 0;
        end
        else begin
            state <= next_state;
            if (state == COUNTING) count <= (count == 2) ? 0 : count + 1;
        end
    end
 
    // Output logic
    assign done = (state == DONE);
endmodule
