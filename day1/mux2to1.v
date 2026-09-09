module mux2to1(input s, input b, input a, output out);
    assign out = s ? a : b;
endmodule