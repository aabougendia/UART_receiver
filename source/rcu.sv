`timescale 1ns / 10ps

typedef enum {IDLE, START_PCKT, WAIT_PCKT_DONE, SBC_ENABLE,
 CHECK_ERR, LOAD_DATA} state;

module rcu (input clk, n_rst, input logic new_packet_detected, packet_done, framing_error,
            output logic sbc_clear, sbc_enable, load_buffer, enable_timer);

    state current_state, next_state;
    always_ff @(posedge clk, negedge n_rst) begin
        if(~n_rst) begin
            current_state <= IDLE;
        end
        else begin
            current_state <= next_state;
        end
    end

    always_comb begin : NEXT_STATE
        next_state = current_state;
        case (current_state)
            IDLE: if(new_packet_detected)   next_state = START_PCKT;

            START_PCKT: if(!new_packet_detected)    next_state = WAIT_PCKT_DONE;

            WAIT_PCKT_DONE: if(packet_done)    next_state = SBC_ENABLE;

            SBC_ENABLE: next_state = CHECK_ERR;
            
            CHECK_ERR: if(framing_error)   next_state = IDLE;
                       else     next_state = LOAD_DATA;

            LOAD_DATA: next_state = IDLE;

        endcase
    end

    always_comb begin : OUTPUT
        {sbc_clear, sbc_enable, load_buffer, enable_timer} = 4'b0000;
        case (current_state)
            IDLE:           {sbc_clear, sbc_enable, load_buffer, enable_timer} = 4'b0000;
            START_PCKT:     {sbc_clear, sbc_enable, load_buffer, enable_timer} = 4'b1000;
            WAIT_PCKT_DONE: {sbc_clear, sbc_enable, load_buffer, enable_timer} = 4'b0001;
            SBC_ENABLE:     {sbc_clear, sbc_enable, load_buffer, enable_timer} = 4'b0100;
            CHECK_ERR:      {sbc_clear, sbc_enable, load_buffer, enable_timer} = 4'b0000;
            LOAD_DATA:      {sbc_clear, sbc_enable, load_buffer, enable_timer} = 4'b0010;
        endcase
    end
endmodule

