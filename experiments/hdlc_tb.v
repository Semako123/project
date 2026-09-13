`timescale 1ns/1ps

module tb;

    reg clk;
    reg reset;
    reg in;

    wire disc;
    wire flag;
    wire err;

    top_module dut (
        .clk(clk),
        .reset(reset),
        .in(in),
        .disc(disc),
        .flag(flag),
        .err(err)
    );

    always #5 clk = ~clk;

    task send_bit(input b);
        begin
            in = b;
            @(posedge clk);
            #1;

            $display(
                "time=%0t | in=%b | state=%0d | count=%0d | disc=%b flag=%b err=%b",
                $time, in, dut.state, dut.count,
                disc, flag, err
            );
        end
    endtask

    task reset_fsm;
        begin
            reset = 1;
            in = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
    endtask

    initial begin

        $dumpfile("fsm.vcd");
        $dumpvars(0, tb);

        clk = 0;
        reset = 0;
        in = 0;

        // --------------------------------
        // TEST 1
        // 0111110
        // --------------------------------

        $display("\n===== TEST 1: 0111110 =====");

        reset_fsm();

        send_bit(0);
        send_bit(1);
        send_bit(1);
        send_bit(1);
        send_bit(1);
        send_bit(1);
        send_bit(0);


        // --------------------------------
        // TEST 2
        // 01111110
        // --------------------------------

        $display("\n===== TEST 2: 01111110 =====");

        reset_fsm();

        send_bit(0);
        send_bit(1);
        send_bit(1);
        send_bit(1);
        send_bit(1);
        send_bit(1);
        send_bit(1);
        send_bit(0);


        // --------------------------------
        // TEST 3
        // 01111111
        // --------------------------------

        $display("\n===== TEST 3: 01111111 =====");

        reset_fsm();

        send_bit(0);
        send_bit(1);
        send_bit(1);
        send_bit(1);
        send_bit(1);
        send_bit(1);
        send_bit(1);
        send_bit(1);


        // --------------------------------
        // TEST 4
        // arbitrary stream
        // --------------------------------

        $display("\n===== TEST 4: arbitrary stream =====");

        reset_fsm();

        send_bit(0);
        send_bit(1);
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(1);
        send_bit(1);
        send_bit(0);


        // --------------------------------
        // TEST 5
        // error continues
        // --------------------------------

        $display("\n===== TEST 5: 01111111111 =====");

        reset_fsm();

        send_bit(0);
        send_bit(1);
        send_bit(1);
        send_bit(1);
        send_bit(1);
        send_bit(1);
        send_bit(1);
        send_bit(1);
        send_bit(1);
        send_bit(1);
        send_bit(1);


        // --------------------------------

        $display("\n===== DONE =====");

        #10;
        $finish;

    end

endmodule