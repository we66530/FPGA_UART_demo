`timescale 1ns / 1ps

// Module to control the output signal based on the clock, reset, and delay conditions.
module out_ctl(
    input clk,           // Clock signal input
    input rst,           // Reset signal input (active-high)
    input dly_over,      // Delay over signal input (indicating when delay is complete)
    input pin_in,        // Input signal to be passed to the output
    output reg pin_out   // Output signal that controls the external pin
    );

    // Always block triggered on the positive edge of the clock or reset
    always @(posedge clk or posedge rst)
    begin
        if (rst) 
            // If reset is active, set output pin (`pin_out`) to the value of input (`pin_in`)
            pin_out <= pin_in;
        else if (dly_over) 
            // If delay is over (dly_over is high), set output pin (`pin_out`) to the value of input (`pin_in`)
            pin_out <= pin_in;
    end
endmodule
