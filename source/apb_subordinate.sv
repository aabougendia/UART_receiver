`timescale 1ns / 10ps

module apb_subordinate #(
    // parameters
) (
    input clk, n_rst,
    input logic [7:0] rx_data,
    input logic data_ready, overrun_error, framing_error,
    input logic psel,
    input logic [2:0] paddr,
    input logic penable, pwrite,
    input logic [7:0] pwdata,
    output logic data_read,
    output logic [7:0] prdata,
    output logic psaterr,
    output logic[3:0] data_size,
    output logic [13:0] bit_period
);

    logic [6:0][7:0] current_regs, next_regs;
    logic [7:0] prdata_next;

    always_ff @(posedge clk, negedge n_rst) begin
        if(~n_rst) begin
            current_regs[3'h0] <= 8'h00;
            current_regs[3'h1] <= 8'h00;
            current_regs[3'h2] <= 8'h0A; // bit period low
            current_regs[3'h3] <= 8'h00; // bit period high
            current_regs[3'h4] <= 8'h08; // data size
            current_regs[3'h6] <= 8'h00;
            prdata <= '0;
        end
        else begin
            current_regs <= next_regs;
            prdata <= prdata_next;
        end
    end

    always_comb begin : WRITE_LOGIC
        next_regs[3'h0] = data_ready;
        next_regs[3'h1] = {overrun_error, framing_error};
        next_regs[3'h2] = current_regs[3'h2];
        next_regs[3'h3] = current_regs[3'h3];
        next_regs[3'h4] = current_regs[3'h4];
        next_regs[3'h6] = rx_data;


        if (psel) begin
            if(!penable) begin
                if(pwrite) begin
                    case (paddr)
                        3'h2:   next_regs[3'h2] = pwdata;
                        3'h3:   next_regs[3'h3] = pwdata[5:0];
                        3'h4:   next_regs[3'h4] = pwdata[3:0];
                    endcase
                end
            end
        end

    end

    always_comb begin : READ_LOGIC

        bit_period[7:0] = current_regs[3'h2];
        bit_period[13:8] = current_regs[3'h3][5:0];
        data_size = current_regs[3'h4][3:0];
        prdata_next = 8'h00;
        data_read = 1'b0;

        if (psel) begin
            if (!penable) begin
                if (!pwrite) begin
                    case (paddr)
                        3'h0: prdata_next = current_regs[3'h0];
                        3'h1: prdata_next = current_regs[3'h1];
                        3'h2: prdata_next = current_regs[3'h2];
                        3'h3: prdata_next = current_regs[3'h3];
                        3'h4: prdata_next = current_regs[3'h4];
                        3'h6: begin prdata_next = current_regs[3'h6];
                                    data_read = 1'b1;
                        end
                    endcase
                end
            end
        end
    end

    always_comb begin : ERROR_LOGIC
        psaterr = 0;
        if (psel) begin
            if (pwrite) begin
                case (paddr)
                    3'h2, 3'h3, 3'h4: psaterr = 0;
                    default: psaterr = 1;
                endcase
            end
            else begin
                case (paddr) 
                    3'h5, 3'h7: psaterr = 1;
                    default: psaterr = 0;
                endcase
            end
        end
    end

endmodule

