`timescale 1ns / 10ps
/* verilator coverage_off */

// localparam CLK_PERIOD = 2.5;
// localparam BIT_TIME = 10 * CLK_PERIOD;





module tb_rcv_block ();

    localparam CLK_PERIOD = 2.5ns;
    localparam BIT_PERIOD = 15;
    localparam BIT_TIME = BIT_PERIOD * CLK_PERIOD;
    localparam FAST_BIT_TIME = BIT_TIME * 0.96;
    localparam SLOW_BIT_TIME = BIT_TIME * 1.04;

    // localparam ERR_FAST_BIT_TIME = BIT_TIME * 90 / 100;
    // localparam ERR_SLOW_BIT_TIME = BIT_TIME * 110 / 100;
    localparam DATA_SIZE = 5;

    logic clk, n_rst;
    logic serial_in, data_read;
    logic [7:0] rx_data;
    logic [3:0] data_size;
    logic [13:0] bit_period;
    logic data_ready, overrun_error, framing_error;


    task send_packet;
    input [DATA_SIZE - 1:0] data;
    input stop_bit;
    input time data_period;
    // input is_overrun;       
        
    integer i;
    begin
        // First synchronize to away from clock's rising edge
        @(negedge clk);
        
        // Send start bit
        serial_in = 1'b0;
        #(data_period);
        
        // Send data bits
        for(i = 0; i < data_size; i = i + 1) begin
            serial_in = data[i];
            #(data_period);
        end
        
        // Send stop bit
        serial_in = stop_bit;
        #(data_period);

        // if(!is_overrun) begin
        //     data_read = 1;
        //     #(CLK_PERIOD);
        // end
        // data_read = 0;
        // serial_in = 1;
        // #(CLK_PERIOD);
        // #(CLK_PERIOD);
        // #(CLK_PERIOD);


    end
    endtask

    rcv_block DUT(.clk(clk), .n_rst(n_rst), .serial_in(serial_in), .data_read(data_read), .data_size(data_size),
                  .bit_period(bit_period), .rx_data(rx_data), .data_ready(data_ready), .overrun_error(overrun_error),
                  .framing_error(framing_error));

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
    string test_case;
    initial begin
        n_rst = 1;
        @(negedge clk);

        // IDLE
        test_case = "setup";
        bit_period = BIT_PERIOD;
        data_size = DATA_SIZE;
        n_rst = 0;
        serial_in = 1;
        data_read = 0;
        @(negedge clk);
        @(negedge clk);
        n_rst = 1;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        test_case = "packet 1";
        send_packet(5'h00, 1'b1, BIT_TIME);
        // 0-00S1-1111
        test_case = "packet 2";
        send_packet(5'h1F, 1'b1, FAST_BIT_TIME);

        test_case = "packet 3";
        send_packet(5'h05, 1'b1, SLOW_BIT_TIME);

        // overrun error
        test_case = "overrun packet 1";
        send_packet(5'h07, 1'b1, BIT_TIME);

        // one more packet
        test_case = "overrun packet 2";
        send_packet(5'h09, 1'b1, BIT_TIME);

        // framing error
        test_case = "framing error packet";
        send_packet(5'h0B, 1'b0, BIT_TIME);

        test_case = "packet 4";
        send_packet(5'h0F, 1'b1, SLOW_BIT_TIME);

        $finish;
    end
endmodule

/* verilator coverage_on */

