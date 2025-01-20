`timescale 1ns / 1ps

module rx_band_gen(
    input clk,       // Clock signal
    input rst,       // Reset signal (active high)
    input band_sig,  // Input signal to enable the generation of baud rate clock
    output reg clk_bps // Baud rate clock signal generated based on the input band_sig
    );

    // Parameters for system and baud rate configuration
    parameter SYS_RATE = 100000000;    // System clock frequency (100 MHz)
    parameter BAND_RATE = 9600;        // Desired baud rate (9600 bps)
    parameter CNT_BAND = SYS_RATE / BAND_RATE;  // Number of clock cycles per baud rate period
    parameter HALF_CNT_BAND = CNT_BAND / 2;     // Half of the cycles per baud period

    // Register for counting clock cycles
    reg [13:0] cnt_bps;

    // Always block triggered on rising edge of clk or reset signal
    always @( posedge clk or posedge rst )
        if( rst )  // If reset is high, initialize the counter and output clock
            begin
                cnt_bps <= HALF_CNT_BAND;  // Initialize the counter to half of the baud period
                clk_bps <= 1'b0;           // Initialize baud clock output to low
            end
        else if( !band_sig )  // If band_sig is low, reset the counter and output clock
            begin
                cnt_bps <= HALF_CNT_BAND;  // Reset counter to half of the baud period
                clk_bps <= 1'b0;           // Keep baud clock output low
            end
        else if( cnt_bps == CNT_BAND )  // If the counter reaches the full baud period
            begin
                cnt_bps <= 14'd0;         // Reset counter to 0
                clk_bps <= 1'b1;          // Set baud clock output high for one cycle
            end
        else  // Otherwise, increment the counter and keep baud clock low
            begin
                cnt_bps <= cnt_bps + 1'b1;  // Increment counter by 1
                clk_bps <= 1'b0;            // Keep baud clock output low
            end

endmodule
