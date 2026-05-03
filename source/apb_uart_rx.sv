`timescale 1ns / 10ps

module apb_uart_rx (input clk, n_rst,
                    input logic serial_in, psel,
                    input logic [2:0] paddr,
                    input logic penable, pwrite,
                    input logic [7:0] pwdata,
                    output logic [7:0] prdata,
                    output logic psaterr);

    logic data_ready_m;
    logic [7:0] rx_data_m;
    logic data_read_m, overrun_error_m, framing_error_m;
    logic [3:0] data_size_m;
    logic [13:0] bit_period_m;

    rcv_block rcv(.clk(clk), .n_rst(n_rst), .serial_in(serial_in), .data_size(data_size_m),
                .bit_period(bit_period_m), .data_read(data_read_m), .rx_data(rx_data_m),
                .data_ready(data_ready_m), .overrun_error(overrun_error_m),
                .framing_error(framing_error_m));

    apb_subordinate apb(.clk(clk), .n_rst(n_rst), .rx_data(rx_data_m), .data_ready(data_ready_m),
                        .overrun_error(overrun_error_m), .framing_error(framing_error_m), .data_read(data_read_m),
                        .psel(psel), .paddr(paddr), .penable(penable), .pwrite(pwrite), .pwdata(pwdata), .prdata(prdata),
                        .psaterr(psaterr), .data_size(data_size_m), .bit_period(bit_period_m));
endmodule

