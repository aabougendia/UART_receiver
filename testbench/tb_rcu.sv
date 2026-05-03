`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_rcu ();

    localparam CLK_PERIOD = 2.5ns;

    logic clk, n_rst;
    logic new_packet_detected, packet_done, framing_error;
    logic sbc_clear, sbc_enable, load_buffer, enable_timer;

    rcu DUT(.clk(clk), .n_rst(n_rst), .new_packet_detected(new_packet_detected), .packet_done(packet_done), .framing_error(framing_error),
            .sbc_clear(sbc_clear), .sbc_enable(sbc_enable), .load_buffer(load_buffer), .enable_timer(enable_timer));

    // clockgen
    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end

    task reset_dut;
    begin
        n_rst = 0;
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        n_rst = 1;
        @(negedge clk);
        @(negedge clk);
    end
    endtask

    initial begin
        n_rst = 1;
        @(negedge clk);

        // IDLE
        n_rst = 0;
        packet_done = 0;
        framing_error = 0;
        new_packet_detected = 0;
        @(negedge clk);
        @(negedge clk);
        n_rst = 1;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);

        // START_PCKT
        new_packet_detected = 1;
        @(negedge clk);
        // WAIT_PCKT_DONE
        new_packet_detected = 0;
        @(negedge clk);

        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);

        // SBC_ENABLE
        packet_done = 1;
        @(negedge clk);

        // CHECK_ERR
        packet_done = 0;
        @(negedge clk);

        // LOAD_DATA
        @(negedge clk);
        // IDLE
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);


        // START_PCKT
        new_packet_detected = 1;
        @(negedge clk);
        // WAIT_PCKT_DONE
        new_packet_detected = 0;
        @(negedge clk);

        @(negedge clk);
        @(negedge clk);
        @(negedge clk);


        // SBC_ENABLE
        packet_done = 1;
        framing_error = 1;
        @(negedge clk);

        // CHECK_ERR
        packet_done = 0;
        @(negedge clk);

        // IDLE
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);

   // START_PCKT
        new_packet_detected = 1;
        @(negedge clk);
        // WAIT_PCKT_DONE
        new_packet_detected = 0;
        @(negedge clk);

        @(negedge clk);
        @(negedge clk);
        @(negedge clk);

        n_rst = 0;
        @(negedge clk);
        

        // IDLE
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);


        $finish;
    end
endmodule

/* verilator coverage_on */

