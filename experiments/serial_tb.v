
//WRONG TB CHANGES HAVE BEEN MADE
`timescale 1ns/1ps

module serial_tb;
    reg clk, in, reset;
    wire done;

    top_module uut (.clk(clk), .in(in), .reset(reset), .done(done));

    always #5 clk = ~clk;

    // print every cycle
    always @(posedge clk) begin
        #1;
        $display("t=%0t | in=%b | state=%0d | count=%0d | done=%b",
                  $time, in, uut.state, uut.count, done);
    end

    // send one bit per clock cycle
    task send_bit(input b);
        begin
            in = b;
            @(posedge clk); #1;
        end
    endtask

    // send a full byte frame: start(0) + 8 data bits + stop(1)
    task send_byte(input [7:0] data);
        integer i;
        begin
            send_bit(0); // start bit
            for (i = 0; i < 8; i = i + 1)
                send_bit(data[i]); // LSB first
            send_bit(1); // stop bit
        end
    endtask

    initial begin
        $dumpfile("serial.vcd");
        $dumpvars(0, serial_tb);

        clk = 0; reset = 1; in = 1; // idle line is high
        @(posedge clk); @(posedge clk); #1;
        reset = 0;

        $display("--- idle line ---");
        send_bit(1); send_bit(1); send_bit(1);

        $display("--- valid byte 0x55 ---");
        send_byte(8'h55); // 01010101
        send_bit(1); // idle after

        $display("--- valid byte 0xAB ---");
        send_byte(8'hAB); // 10101011
        send_bit(1);

        $display("--- missing stop bit (error case) ---");
        send_bit(0); // start bit
        send_bit(1); send_bit(0); send_bit(1); send_bit(0); // 4 data bits
        send_bit(1); send_bit(0); send_bit(1); send_bit(0); // 4 more data bits
        send_bit(0); // wrong stop bit (should be 1) -- FSM should NOT assert done
        send_bit(0); // still no stop -- FSM waits
        send_bit(1); // stop bit finally arrives -- FSM recovers

        $display("--- valid byte after error recovery ---");
        send_byte(8'hAB);
        send_bit(1);

        $display("--- reset mid-frame ---");
        send_bit(0); // start bit
        send_bit(1); send_bit(0); // 2 data bits
        reset = 1;
        @(posedge clk); #1;
        reset = 0;
        $display("--- after reset ---");
        send_byte(8'h55);
        send_bit(1);

        $finish;
    end
endmodule