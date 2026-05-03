`timescale 1ns / 10ps

module sr_9bit (input clk, n_rst, shift_strobe, serial_in, input logic [3:0] data_size,
                output logic [7:0] packet_data, output logic stop_bit);

    logic [8:0] sr_out;

    flex_sr #(.SIZE(9), .MSB_FIRST(0)) sr_core (.clk(clk), .n_rst(n_rst),
              .serial_in(serial_in), .shift_enable(shift_strobe),
              .parallel_out(sr_out));
// 7  S11111000
    always_comb begin
        case (data_size)
            4'd8: {stop_bit, packet_data} = sr_out;
            4'd7: {stop_bit, packet_data} = {sr_out[8], 1'b0, sr_out[7:1]};
            4'd5: {stop_bit, packet_data} = {sr_out[8], 3'b000, sr_out[7:3]};
            default:
                {stop_bit, packet_data} = sr_out;
        endcase
    end
endmodule

