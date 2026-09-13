`timescale 1ns/1ps

module top_module_tb;
    reg clk, reset;
    reg [7:0] in;
    wire done;

    top_module uut (.clk(clk), .in(in), .reset(reset), .done(done));

    always #5 clk = ~clk;

    // print every cycle
    always @(posedge clk) begin
        #1;
        $display("t=%0t | in=0x%h in[3]=%b | state=%0d | done=%b",
                  $time, in, in[3], uut.state, done);
    end

    task send_byte(input [7:0] b);
        begin
            in = b;
            @(posedge clk); #1;
        end
    endtask

    initial begin
        $dumpfile("ps2.vcd");
        $dumpvars(0, top_module_tb);
        clk = 0; reset = 1; in = 0;

        // hold reset for 2 cycles
        @(posedge clk); @(posedge clk); #1;
        reset = 0;

        $display("--- first message ---");
        send_byte(8'hd6); // in[3]=1, byte 1
        send_byte(8'h65); // byte 2
        send_byte(8'h17); // byte 3
        // done should fire here (next cycle)
        send_byte(8'h00); // idle byte, should see done=1 on this cycle

        $display("--- gap ---");
        send_byte(8'h00);
        send_byte(8'h00);

        $display("--- reset mid-stream ---");
        send_byte(8'hd6); // byte 1
        reset = 1;
        @(posedge clk); #1;
        reset = 0;

        $display("--- after reset ---");
        send_byte(8'haa); // in[3]=1, byte 1
        send_byte(8'h96); // byte 2
        send_byte(8'hd6); // byte 3, in[3]=1 (new message starts immediately)
        send_byte(8'h6b); // byte 2 of new message
        send_byte(8'h21); // byte 3 of new message
        send_byte(8'h00); // idle

        $finish;
    end
endmodulex