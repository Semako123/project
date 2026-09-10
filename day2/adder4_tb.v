// adder4_tb.v
`timescale 1ns/1ps

module adder4_tb;
    reg  [3:0] a, b;
    reg        cin;
    wire [3:0] sum;
    wire       cout;

    adder4 uut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    task check(input [3:0] ta, input [3:0] tb, input tcin);
        reg [4:0] expected;
        begin
            a = ta; b = tb; cin = tcin;
            #10;
            expected = ta + tb + tcin;
            if ({cout, sum} !== expected)
                $display("FAIL: a=%b b=%b cin=%b -> got {cout,sum}=%b%b, expected %b",
                          ta, tb, tcin, cout, sum, expected);
            else
                $display("PASS: a=%b b=%b cin=%b -> sum=%b cout=%b", ta, tb, tcin, sum, cout);
        end
    endtask

    initial begin
        $dumpfile("adder4.vcd");
        $dumpvars(0, adder4_tb);

        check(4'b0001, 4'b0001, 1'b0); // simple add, no carry
        check(4'b0111, 4'b0001, 1'b0); // internal carry propagation
        check(4'b1111, 4'b0001, 1'b0); // full ripple, cout should go high
        check(4'b1111, 4'b1111, 1'b1); // max values + carry-in, stress overflow
        check(4'b0000, 4'b0000, 1'b1); // cin alone should propagate through
        check(4'b1010, 4'b0101, 1'b0); // no carry anywhere
        check(4'b1000, 4'b1000, 1'b0); // carry only from top bit

        $finish;
    end
endmodule