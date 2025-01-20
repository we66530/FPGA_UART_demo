`timescale 1ns / 1ps

// Module to detect a change (reverse) in the input signal pin_in.
module reverse_detect(
    input clk,            // Clock signal input
    input rst,            // Reset signal input (active-high)
    input pin_in,         // Input signal to detect reversal (change)
    output reverse_sig    // Output signal indicating if a reversal (change) occurred
    );
    
    reg pin_pre;          // Register to store the previous value of pin_in
    
    // Always block triggered on the positive edge of the clock or reset
    always @(posedge clk or posedge rst)
    begin
        if (rst) 
            pin_pre <= 1'b0;  // Reset the previous value of pin_in to 0
        else 
            pin_pre <= pin_in;  // Store the current value of pin_in as pin_pre
    end

    // Assign the output signal reverse_sig based on the change detection
    assign reverse_sig = (pin_in != pin_pre);  // Output high (1) if the current value of pin_in is different from pin_pre
    
endmodule
