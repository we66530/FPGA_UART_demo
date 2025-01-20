`timescale 1ns / 1ps

// Module to "harden" a signal by synchronizing it with the clock
// to eliminate metastability and avoid glitches due to asynchronous inputs.
module meta_harden(
    input clk,               // Clock signal input
    input rst,               // Reset signal input (active-high)
    input sig_src,           // Input signal to be synchronized
    output reg sig_dst       // Output synchronized signal
    );

    // Internal register to store the synchronized signal temporarily
    reg sig_meta;

    // Always block triggered on the positive edge of the clock or reset
    always @(posedge clk or posedge rst) 
    begin
        if (rst) 
        begin
            // If reset is active, initialize the output and internal registers to 0
            sig_dst <= 1'b0;
            sig_meta <= 1'b0;
        end 
        else 
        begin
            // Synchronize the input signal (`sig_src`) to the clock by passing
            // it through two registers. First to `sig_meta`, then to `sig_dst`.
            sig_meta <= sig_src;
            sig_dst <= sig_meta;
        end
    end
endmodule
