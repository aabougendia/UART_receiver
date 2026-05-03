`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_apb_subordinate ();

    localparam CLK_PERIOD = 10ns;

    logic clk, n_rst;
    logic [7:0] rx_data;
    logic data_ready, overrun_error, framing_error;
    // logic [2:0] paddr_m;
    // logic penable_m, pwrite_m, data_read;
    // logic [7:0] prdata_m;
    // logic psaterr_m;
    logic [3:0] data_size;
    logic [13:0] bit_period;

    // logic model_reset, enqueue_transaction, transaction_write, transaction_fake;
    // logic [2:0] transaction_addr, transaction_data;
    // logic enable_transactions;
    // logic current_transaction_num;

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

    logic psel;
    logic [2:0] paddr;
    logic penable;
    logic pwrite;
    logic [7:0] pwdata;
    logic [7:0] prdata;
    logic psaterr;

    apb_subordinate DUT (.clk(clk), .n_rst(n_rst), .rx_data(rx_data),
                        .data_ready(data_ready), .overrun_error(overrun_error), .framing_error(framing_error),
                        .psel(psel), .paddr(paddr), .penable(penable), .pwrite(pwrite), .pwdata(pwdata),
                        .data_read(data_read), .prdata(prdata), .psaterr(psaterr), .data_size(data_size),
                        .bit_period(bit_period));
    



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
        // APB-Subordinate Side
        .psel(psel),
        .paddr(paddr),
        .penable(penable),
        .pwrite(pwrite),
        .pwdata(pwdata),
        .prdata(prdata),
        .psaterr(psaterr)
    );
    string status;
    initial begin
        n_rst = 1;
        enqueue_transaction_en = 1'b0;
        transaction_fake  = 1'b0;
        transaction_write = 1'b0;
        transaction_addr  = 3'b0;
        transaction_data  = 8'b0;
        transaction_error = 1'b0;

        reset_model;
        reset_dut;

        rx_data = 8'h3C;
        data_ready = 1'b1;
        framing_error = 1'b0;
        overrun_error = 1'b1;
        @(negedge clk);

        // read from data buffer
        status = "t1";
        enqueue_transaction(1'b1, 1'b0, 3'h6, 8'h3C, 1'b0);

        // read from eror status register
        status = "t2";
        enqueue_transaction(1'b1, 1'b0, 3'h1, 8'h02, 1'b0);

        // read from data status
        status = "t3";
        enqueue_transaction(1'b1, 1'b0, 3'h0, 8'h01, 1'b0);
        
        // write to Bit period low
        status = "t4";
        enqueue_transaction(1'b1, 1'b1, 3'h2, 8'hAA, 1'b0);
        
        // write to Bit period high
        status = "t5";
        enqueue_transaction(1'b1, 1'b1, 3'h3, 8'h05, 1'b0);
        
        // write to Data Size
        status = "t6";
        enqueue_transaction(1'b1, 1'b1, 3'h4, 8'h03, 1'b0);

        // read from Bit period low
        status = "t7";
        enqueue_transaction(1'b1, 1'b0, 3'h2, 8'hAA, 1'b0);

        // read from Bit period high
        status = "t8";
        enqueue_transaction(1'b1, 1'b0, 3'h3, 8'h05, 1'b0);
        
        // read from Data Size
        status = "t9";
        enqueue_transaction(1'b1, 1'b0, 3'h4, 8'h03, 1'b0);


        // write to status register
        status = "t10";
        enqueue_transaction(1'b1, 1'b1, 3'h1, 8'h4B, 1'b1);
        
        // read from data buffer
        status = "t11";
        enqueue_transaction(1'b1, 1'b0, 3'h6, 8'h3C, 1'b0);

        // read from address 0x5
        status = "t12";
        enqueue_transaction(1'b1, 1'b0, 3'h5, 8'h00, 1'b1);

        // execute
        execute_transactions(12);

        $finish;
    end
endmodule

/* verilator coverage_on */

