`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_sr_9bit ();

    localparam CLK_PERIOD = 2.5ns;
    localparam BIT_TIME = 10 * CLK_PERIOD;

    logic clk, n_rst;
    logic shift_strobe, serial_in;
    logic [7:0] packet_data;
    logic stop_bit;

    sr_9bit DUT(.clk(clk), .n_rst(n_rst),
                .shift_strobe(shift_strobe), .serial_in(serial_in),
                .packet_data(packet_data), .stop_bit(stop_bit));

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

task shift_byte(input [8:0] data);
    integer i;

    // start bit
    serial_in = 0;
    #(BIT_TIME);


    for(i = 0; i < 8; i++) begin
        // payload
        serial_in = data[i];
        #(BIT_TIME / 2.0);
        shift_strobe = 1;
        #(CLK_PERIOD)
        shift_strobe = 0;
        #(BIT_TIME / 2.0 - CLK_PERIOD);

    end

    // stop bit
    serial_in = 1;
    #(BIT_TIME);
endtask
    initial begin
        n_rst = 1;
        @(negedge clk);

        // IDLE
        n_rst = 0;
        shift_strobe = 0;
        @(negedge clk);
        @(negedge clk);
        n_rst = 1;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);

        shift_byte(8'h4B);
        shift_byte(8'hC3);
         
        @(negedge clk);
        n_rst = 0;

        shift_byte(8'h4B);

        $finish;
    end
endmodule

/* verilator coverage_on */

