module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);
    
    reg [2:0] state, next_state ;
    reg [2:0] count;
    parameter START = 0, COUNTING = 1, DISC = 2, FLAG = 3, ERR = 4;  
    
    always @(*) begin
        next_state = state;
        case(state) 
            START: next_state = in == 1 ? COUNTING : START;
            COUNTING: begin
                if (in == 0) begin
                    if (count == 4) next_state = DISC;
                    else if (count == 5) next_state = FLAG;
                    else next_state = START;
                end
                else next_state = count == 5 ? ERR : COUNTING;
            end
            ERR: next_state = in == 0 ? START : ERR;
            default: next_state = in == 0 ? START : COUNTING;
        endcase
    end
    
    always @(posedge clk) begin
        if (reset) begin 
            state <= START;
            count <= 0;
        end
        else begin
            state <= next_state;
            case(state)
                COUNTING: count <= count == 5 ? 0 : count + 1;
                default: count <= 0;
            endcase
        end
    end
    
    assign disc = (state == DISC);    
    assign flag = (state == FLAG); 
    assign err = (state == ERR); 
 

endmodule
 