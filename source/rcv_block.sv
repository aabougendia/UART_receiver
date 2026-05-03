`timescale 1ns / 10ps

module rcv_block (input clk, n_rst,
                  input logic serial_in, data_read,
                  input [3:0] data_size,
                  input [13:0] bit_period,
                  output logic [7:0] rx_data,
                  output logic data_ready, overrun_error, framing_error);

    logic load_buffer_m, sbc_enable_m, sbc_clear_m;
    logic enable_timer_m, packet_done_m, new_packet_detected_m;
    logic shift_strobe_m, stop_bit_m;
    logic [7:0] packet_data_m;

    rx_data_buff buffer(.clk(clk), .n_rst(n_rst),
                 .load_buffer(load_buffer_m), .packet_data(packet_data_m), .data_read(data_read), .rx_data(rx_data),
                 .data_ready(data_ready), .overrun_error(overrun_error));

    start_bit_det start_det(.clk(clk), .n_rst(n_rst), .serial_in(serial_in), .new_packet_detected(new_packet_detected_m));

    stop_bit_chk stop_chk(.clk(clk), .n_rst(n_rst), .sbc_clear(sbc_clear_m), .sbc_enable(sbc_enable_m), .stop_bit(stop_bit_m),
                 .framing_error(framing_error));


    timer tim(.clk(clk), .n_rst(n_rst), .enable_timer(enable_timer_m), .data_size(data_size), .bit_period(bit_period), .shift_strobe(shift_strobe_m), .packet_done(packet_done_m));

    sr_9bit sr(.clk(clk), .n_rst(n_rst), .shift_strobe(shift_strobe_m), .data_size(data_size), .serial_in(serial_in), .packet_data(packet_data_m), .stop_bit(stop_bit_m));

    rcu rc_u(.clk(clk), .n_rst(n_rst), .new_packet_detected(new_packet_detected_m), .packet_done(packet_done_m), .framing_error(framing_error),
             .sbc_clear(sbc_clear_m), .sbc_enable(sbc_enable_m), .load_buffer(load_buffer_m), .enable_timer(enable_timer_m));
endmodule