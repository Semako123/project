module shift_reg4(
    input clk,
    input rst,       // synchronous reset, active high
    input shift_in,  // new bit coming in each cycle
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (rst) q <= 4'b0;
        else q <= {q[2:0], shift_in};
    end
endmodule