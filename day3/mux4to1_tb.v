// mux4to1_tb.v
`timescale 1ns/1ps

module mux4to1_tb;
    reg  in0, in1, in2, in3;
    reg  [1:0] sel;
    wire out;

    mux4to1 uut (
        .in0(in0), .in1(in1), .in2(in2), .in3(in3),
        .sel(sel),
        .out(out)
    );

    task check(input tin0, input tin1, input tin2, input tin3, input [1:0] tsel, input expected);
        begin
            in0 = tin0; in1 = tin1; in2 = tin2; in3 = tin3; sel = tsel;
            #10;
            if (out !== expected)
                $display("FAIL: sel=%b -> got out=%b, expected %b", tsel, out, expected);
            else
                $display("PASS: sel=%b -> out=%b", tsel, out);
        end
    endtask

    initial begin
        $dumpfile("mux4to1.vcd");
        $dumpvars(0, mux4to1_tb);

        // in0=1, in1=0, in2=1, in3=0 -- fixed pattern, sweep sel through all 4 values
        check(1, 0, 1, 0, 2'b00, 1); // sel=00 -> should pick in0 (1)
        check(1, 0, 1, 0, 2'b01, 0); // sel=01 -> should pick in1 (0)
        check(1, 0, 1, 0, 2'b10, 1); // sel=10 -> should pick in2 (1)
        check(1, 0, 1, 0, 2'b11, 0); // sel=11 -> should pick in3 (0)

        // different data pattern, same sweep, catches a mux that's accidentally hardwired to one input
        check(0, 1, 0, 1, 2'b00, 0);
        check(0, 1, 0, 1, 2'b01, 1);
        check(0, 1, 0, 1, 2'b10, 0);
        check(0, 1, 0, 1, 2'b11, 1);

        $finish;
    end
endmodule