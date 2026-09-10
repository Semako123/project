module adder(input a, input b, output cout, output sum, input cin);
    assign {cout, sum} = a + b + cin;
endmodule

module adder4(input [3:0]a, input [3:0]b, input cin, output [3:0]sum, output cout);
    wire cout0, cout1, cout2;
    adder adder1(.a(a[0]), .b(b[0]), .cin(cin), .cout(cout0), .sum(sum[0]));
    adder adder2(.a(a[1]), .b(b[1]), .cin(cout0), .cout(cout1), .sum(sum[1]));
    adder adder3(.a(a[2]), .b(b[2]), .cin(cout1), .cout(cout2), .sum(sum[2]));
    adder adder4(.a(a[3]), .b(b[3]), .cin(cout2), .cout(cout), .sum(sum[3]));
endmodule