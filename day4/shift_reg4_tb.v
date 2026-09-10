// shift_reg4_tb.v
`timescale 1ns/1ps

module shift_reg4_tb;
    reg        clk, rst, shift_in;
    wire [3:0] q;

    shift_reg4 uut (
        .clk(clk),
        .rst(rst),
        .shift_in(shift_in),
        .q(q)
    );

    // generate a clock: toggle every 5ns -> 10ns period
    always #5 clk = ~clk;

    task check(input [3:0] expected);
        begin
            @(posedge clk); #1; // sample just after the clock edge
            if (q !== expected)
                $display("FAIL: got q=%b, expected %b", q, expected);
            else
                $display("PASS: q=%b", q);
        end
    endtask

    initial begin
        $dumpfile("shift_reg4.vcd");
        $dumpvars(0, shift_reg4_tb);

        clk = 0; rst = 1; shift_in = 0;
        @(posedge clk); #1;
        if (q !== 4'b0000) $display("FAIL: reset didn't clear q, got %b", q);
        else $display("PASS: reset -> q=0000");

        rst = 0;

        // shift in the pattern 1,0,1,1 one bit per cycle, check q after each
        shift_in = 1; check(4'b0001);
        shift_in = 0; check(4'b0010);
        shift_in = 1; check(4'b0101);
        shift_in = 1; check(4'b1011);

        // one more shift should drop the oldest bit off the top
        shift_in = 0; check(4'b0110);

        $finish;
    end
endmodule