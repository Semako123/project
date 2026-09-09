`timescale 1ns/1ps

module adder4_tb;

    logic [3:0] a;
    logic [3:0] b;
    logic       cin;

    logic [3:0] sum;
    logic       cout;

    logic [4:0] expected;
    integer errors;

    // DUT
    adder4 dut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        errors = 0;

        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                for (int k = 0; k < 2; k++) begin

                    a   = i;
                    b   = j;
                    cin = k;

                    #1;

                    expected = a + b + cin;

                    if ({cout, sum} !== expected) begin
                        $display(
                            "FAIL: a=%0d b=%0d cin=%0d | expected=%05b | got=%05b",
                            a, b, cin, expected, {cout, sum}
                        );
                        errors++;
                    end
                end
            end
        end

        if (errors == 0)
            $display("PASS: All 512 test cases passed!");
        else
            $display("FAIL: %0d test cases failed.", errors);

        $finish;
    end

endmodule