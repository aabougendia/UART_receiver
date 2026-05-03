`timescale 1ns / 10ps

module timer (input clk, n_rst, input logic [3:0] data_size, input logic [13:0] bit_period,
              input logic enable_timer, output logic shift_strobe, packet_done);
    // localparam CLK_RLV = 4'd10;
    // localparam BIT_RLV = 4'd9;

    flex_counter #(.SIZE(14))clk_counter(.clk(clk), .n_rst(n_rst), .clear(packet_done),
                             .count_enable(enable_timer), .rollover_val(bit_period), .rollover_flag(shift_strobe));
                    
    flex_counter #(.SIZE(4))bit_counter(.clk(clk), .n_rst(n_rst), .clear(packet_done),
                             .count_enable(shift_strobe), .rollover_val(data_size + 4'b1), .rollover_flag(packet_done));


endmodule

