`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_apb_uart_rx ();

    localparam CLK_PERIOD = 20ns;

    logic clk, n_rst;
    logic [7:0] rx_data;
    logic data_ready, overrun_error, framing_error;
    logic [3:0] data_size;
    logic [13:0] bit_period;

    string st;

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

    // bus model signals
    logic enqueue_transaction_en;
    logic transaction_write;
    logic transaction_fake;
    logic [2:0] transaction_addr;
    logic [7:0] transaction_data;
    logic transaction_error;
    
    logic model_reset;
    logic enable_transactions;
    integer current_transaction_num;

    logic serial_in;
    logic psel;
    logic [2:0] paddr;
    logic penable;
    logic pwrite;
    logic [7:0] pwdata;
    logic [7:0] prdata;
    logic psaterr;

    apb_uart_rx DUT (
        .clk(clk),
        .n_rst(n_rst),
        .serial_in(serial_in),
        .psel(psel),
        .paddr(paddr),
        .penable(penable),
        .pwrite(pwrite),
        .pwdata(pwdata),
        .prdata(prdata),
        .psaterr(psaterr)
    );

    // bus model tasks
    task reset_model;
    begin
        model_reset = 1'b1;
        #(0.1);
        model_reset = 1'b0;
    end
    endtask

    task enqueue_transaction;
        input logic for_dut;
        input logic write_mode;
        input logic [2:0] address;
        input logic [7:0] data;
        input logic expected_error;
    begin
        // Make sure enqueue flag is low (will need a 0->1 pulse later)
        enqueue_transaction_en = 1'b0;
        #0.1ns;

        // Setup info about transaction
        transaction_fake  = ~for_dut;
        transaction_write = write_mode;
        transaction_addr  = address;
        transaction_data  = data;
        transaction_error = expected_error;

        // Pulse the enqueue flag
        enqueue_transaction_en = 1'b1;
        #0.1ns;
        enqueue_transaction_en = 1'b0;
    end
    endtask

    task execute_transactions;
        input integer num_transactions;
        integer wait_var;
    begin
        // Activate the bus model
        enable_transactions = 1'b1;
        @(posedge clk);
    
        // Process the transactions
        for(wait_var = 0; wait_var < num_transactions; wait_var++) begin
            @(posedge clk);
            @(posedge clk);
        end
    
        // Turn off the bus model
        @(negedge clk);
        enable_transactions = 1'b0;
    end
    endtask


    // bus model connections
    apb_model BFM ( .clk(clk),
        // Testing setup signals
        .enqueue_transaction(enqueue_transaction_en),
        .transaction_write(transaction_write),
        .transaction_fake(transaction_fake),
        .transaction_addr(transaction_addr),
        .transaction_data(transaction_data),
        .transaction_error(transaction_error),
        // Testing controls
        .model_reset(model_reset),
        .enable_transactions(enable_transactions),
        .current_transaction_num(current_transaction_num),
        // APB-Satellite Side
        .psel(psel),
        .paddr(paddr),
        .penable(penable),
        .pwrite(pwrite),
        .pwdata(pwdata),
        .prdata(prdata),
        .psaterr(psaterr)
    );

    task configure_design;
        input logic [13:0] bit_per;
        input logic [3:0] data_sz;
        begin
            
            // bit period low
            enqueue_transaction(1'b1, 1'b1, 3'h2, bit_per[7:0], 1'b0);
            // bit period high
            enqueue_transaction(1'b1, 1'b1, 3'h3, {2'b00, bit_per[13:8]}, 1'b0);
            // data size
            enqueue_transaction(1'b1, 1'b1, 3'h4, {5'b0, data_sz}, 1'b0);

            // execute
            execute_transactions(3);

        end
    endtask

    task configure_design_err;
        input logic [13:0] bit_per;
        input logic [3:0] data_sz;
        begin
            
            // bit period low
            enqueue_transaction(1'b1, 1'b1, 3'h5, bit_per[7:0], 1'b1);
            // bit period high
            enqueue_transaction(1'b1, 1'b1, 3'h3, {2'b00, bit_per[13:8]}, 1'b0);
            // data size
            enqueue_transaction(1'b1, 1'b1, 3'h4, {5'b0, data_sz}, 1'b0);

            // execute
            execute_transactions(3);

        end
    endtask

    task send_packet;
        input [7:0] data;
        input [13:0] bit_per;
        input [3:0] data_sz;
        integer i;

        begin
            @(negedge clk);
            // send start bit
            serial_in = 1'b0;
            #(bit_per);

            // send data bits
            for(i = 0; i < data_sz; i = i + 1) begin
                serial_in = data[i];
                #(bit_per);
            end

            // send stop bit
            serial_in = 1'b1;
            #(bit_per);

        end

    endtask

    task send_packet_framing_err;
        input [7:0] data;
        input [13:0] bit_per;
        input [3:0] data_sz;
        integer i;

        begin
            @(negedge clk);
            // send start bit
            serial_in = 1'b0;
            #(bit_per);

            // send data bits
            for(i = 0; i < data_sz; i = i + 1) begin
                serial_in = data[i];
                #(bit_per);
            end

            // send stop bit
            serial_in = 1'b0;
            #(bit_per);

            serial_in = 1'b1;
        end

    endtask
    
    task run_testcase;
        input logic [13:0] bit_per;
        input logic [3:0] data_sz;
        input logic [7:0] data;
        input logic is_overrun_err;
        input logic is_framing_err;
        input logic is_config_err;
        begin
            if(!is_config_err) begin
                configure_design(bit_per, data_sz);

                if(is_overrun_err) begin
                    send_packet(data, bit_per * CLK_PERIOD, data_sz);
                    send_packet(8'hCC, bit_per * CLK_PERIOD, data_sz);
                    enqueue_transaction(1'b1, 1'b0, 3'h6, 8'hCC, 1'b0);
                    execute_transactions(1);
                end
                else if (is_framing_err) begin
                    send_packet_framing_err(data, bit_per * CLK_PERIOD, data_sz);
                    enqueue_transaction(1'b1, 1'b0, 3'h6, 8'h3D, 1'b0);
                    execute_transactions(1);
                end
                else begin
                    send_packet(data, bit_per * CLK_PERIOD, data_sz);
                    case (data_sz)
                        4'd5: enqueue_transaction(1'b1, 1'b0, 3'h6, {3'b000, data[4:0]}, 1'b0);
                        4'd7: enqueue_transaction(1'b1, 1'b0, 3'h6, {1'b0, data[6:0]}, 1'b0);
                        4'd5: enqueue_transaction(1'b1, 1'b0, 3'h6, data, 1'b0);
                        default: enqueue_transaction(1'b1, 1'b0, 3'h6, data, 1'b0);
                    endcase
                    execute_transactions(1);
                end

            end
            else
                configure_design_err(bit_per, data_sz);
            
            #(bit_per);
        end

    endtask

    initial begin
        n_rst = 1;
        enqueue_transaction_en = 1'b0;
        enable_transactions = 1'b0;
        transaction_fake  = 1'b0;
        transaction_write = 1'b0;
        transaction_addr  = 3'b0;
        transaction_data  = 8'b0;
        transaction_error = 1'b0;

        serial_in = 1'b1;
        reset_model();
        reset_dut();

        // nominal UART
        st = "nominal 1";
        run_testcase(14'd10, 4'd8, 8'hA1, 0, 0, 0);

        // bit period = 15
        st = "per = 15, sz = 8";
        run_testcase(14'd15, 4'd8, 8'hB2, 0, 0, 0);

        // data size = 5
        st = "per = 10, sz = 5";
        run_testcase(14'd10, 4'd5, 8'h1C, 0, 0, 0);

        // data size = 7, bit period = 20
        st = "per = 20, sz = 7";
        run_testcase(14'd20, 4'd7, 8'h3D, 0, 0, 0);

        // psaterr config error
        st = "psaterr err";
        run_testcase(14'd10, 4'd8, 8'hE5, 0, 0, 1);

        // framing error
        st = "framing err";
        run_testcase(14'd10, 4'd8, 8'hF6, 0, 1, 0);

        // overrun error
        st = "overrun err";
        run_testcase(14'd10, 4'd8, 8'hA1, 1, 0, 0);

        // nominal UART
        st = "nominal 2";
        run_testcase(14'd10, 4'd8, 8'hA4, 0, 0, 0);

        reset_dut;
        $finish;
    end
endmodule

/* verilator coverage_on */

