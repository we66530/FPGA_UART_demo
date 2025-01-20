`timescale 1ns / 1ps

module en_ctl(
    input clk,           // Clock input
    input rst,           // Active-high reset input
    
    input en,            // Enable signal to control the module's behavior
    
    input rx_read,       // Input signal for read operation (RX)
    input tx_write,      // Input signal for write operation (TX)
    
    output gate_clk,     // Output clock gated with the enable signal
    output reg rst_en_ctl, // Output for the reset control of the enable module
    output rx_read_buf,  // Buffered version of the rx_read signal
    output tx_write_buf  // Buffered version of the tx_write signal
);

    // Internal registers
    reg en_reg;          // Register for enable signal (used for gating and buffering)
    
    // Assign statements to generate the buffered signals and gated clock
    assign rx_read_buf = rx_read & en_reg;       // rx_read is buffered based on enable
    assign tx_write_buf = tx_write & en_reg;     // tx_write is buffered based on enable
    assign gate_clk = clk & en_reg;              // Output clock is gated based on enable

    // Signal to detect when 'en' transitions from high to low
    wire en_H2L;
    reg en_pre;           // Register to hold the previous state of 'en'
    
    // Detect falling edge of 'en' (transition from high to low)
    assign en_H2L = !en & en_pre;
    
    // Always block to update 'en_pre' on clock edge or reset
    always @(posedge clk or posedge rst) begin
        if (rst)
            en_pre <= 1'b0;        // Reset 'en_pre' to 0 on reset signal
        else
            en_pre <= en;          // Capture current value of 'en' on clock edge
    end

    // Always block to update the reset control signal 'rst_en_ctl'
    always @(posedge clk or posedge rst) begin
        if (rst)
            rst_en_ctl <= 1'b1;    // When reset is active, set 'rst_en_ctl' to 1
        else if (en_H2L)
            rst_en_ctl <= 1'b1;    // When 'en' transitions from high to low, set 'rst_en_ctl' to 1
        else
            rst_en_ctl <= 1'b0;    // Otherwise, keep 'rst_en_ctl' low
    end

    // Register for enabling operation (en_reg) and counter for controlling enable signal timing
    reg [3:0] cnt;          // 4-bit counter to control enable signal timing

    // Always block for controlling the enable signal and counting
    always @(posedge clk or posedge rst) begin
        if (rst)
            en_reg <= 1'b0;      // Reset 'en_reg' to 0 on reset
        else if (cnt == 4'd15)
            en_reg <= en;        // When the counter reaches 15, latch 'en' into 'en_reg'
    end
    
    // Always block for counting 16 cycles
    always @(posedge clk or posedge rst) begin
        if (rst)
            cnt <= 4'd0;          // Reset the counter to 0 on reset
        else if (cnt != 4'd15)
            cnt <= cnt + 1'b1;    // Increment counter on each clock cycle until it reaches 15
    end
endmodule
