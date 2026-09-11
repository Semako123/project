// trafficlight_tb.v
`timescale 1ns/1ps

module trafficlight_tb;
    reg  clk, rst;
    wire [1:0] light;

    trafficlight uut (
        .clk(clk),
        .rst(rst),
        .light(light)
    );

    always #5 clk = ~clk;

    // helper to name the light state for readable output
    function [55:0] light_name;
        input [1:0] l;
        case(l)
            2'b00: light_name = "GREEN";
            2'b01: light_name = "YELLOW";
            2'b10: light_name = "RED";
            default: light_name = "UNKNOWN";
        endcase
    endfunction

    integer i;

    initial begin
        $dumpfile("trafficlight.vcd");
        $dumpvars(0, trafficlight_tb);

        clk = 0; rst = 1;
        @(posedge clk); #1;
        rst = 0;

        // run for 30 cycles, print light state each cycle
        // expected pattern: GREEN x3, YELLOW x1, RED x2, GREEN x3 ...
        for (i = 0; i < 30; i = i + 1) begin
            @(posedge clk); #1;
            $display("cycle %0d: %s (%b)", i, light_name(light), light);
        end

        // test that reset actually works mid-sequence
        rst = 1;
        @(posedge clk); #1;
        $display("after reset: %s (should be GREEN)", light_name(light));
        rst = 0;

        // run 6 more cycles and check pattern restarts cleanly
        for (i = 0; i < 20; i = i + 1) begin
            @(posedge clk); #1;
            $display("post-reset cycle %0d: %s", i, light_name(light));
        end

        $finish;
    end
endmodule