// mux2to1_tb.v

`timescale 1ns/1ps

module mux2to1_tb;
    reg s, a, b;
    wire out;

    // instantiate the module under test
    mux2to1 uut (
        .s(s),
        .a(a),
        .b(b),
        .out(out)
    );

    initial begin
        // dump waveform for GTKWave
        $dumpfile("mux2to1.vcd");
        $dumpvars(0, mux2to1_tb);

        // test case 1: s=0 -> should output b
        a = 1; b = 0; s = 0; #10;
        if (out !== b) $display("FAIL: s=0 expected out=%b, got %b", b, out);
        else $display("PASS: s=0, out=%b", out);

        // test case 2: s=1 -> should output a
        a = 1; b = 0; s = 1; #10;
        if (out !== a) $display("FAIL: s=1 expected out=%b, got %b", a, out);
        else $display("PASS: s=1, out=%b", out);

        // test case 3: swap values, s=0
        a = 0; b = 1; s = 0; #10;
        if (out !== b) $display("FAIL: s=0 (swapped) expected out=%b, got %b", b, out);
        else $display("PASS: s=0 (swapped), out=%b", out);

        // test case 4: swap values, s=1
        a = 0; b = 1; s = 1; #10;
        if (out !== a) $display("FAIL: s=1 (swapped) expected out=%b, got %b", a, out);
        else $display("PASS: s=1 (swapped), out=%b", out);

        $finish;
    end
endmodule