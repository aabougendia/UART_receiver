`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_timer ();

    localparam CLK_PERIOD = 2.5ns;
    localparam BIT_TIME = 10 * CLK_PERIOD;

    logic clk, n_rst;
    logic enable_timer;
    logic shift_strobe, packet_done;

    timer DUT(.clk(clk), .n_rst(n_rst), .enable_timer(enable_timer),
              .shift_strobe(shift_strobe), .packet_done(packet_done));

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

    integer i;
    initial begin
        n_rst = 1;
        @(negedge clk);

        // IDLE
        n_rst = 0;
        @(negedge clk);
        @(negedge clk);
        n_rst = 1;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);

        enable_timer = 1;
        @(negedge clk);

        for(int i = 0; i < 10; i++)
            #BIT_TIME;
            


        $finish;
    end
endmodule

/* verilator coverage_on */

