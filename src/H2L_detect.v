`timescale 1ns / 1ps

module H2L_detect(
    input clk,       // Clock signal
    input rst,       // Reset signal (active high)
    input pin_in,    // Input signal whose transitions are being detected
    output sig_H2L   // Output signal indicating a high-to-low transition
    );

    // Register to store the previous value of pin_in
    reg pin_pre;

    // sig_H2L is asserted (high) when there's a high-to-low transition in pin_in
    assign sig_H2L = !pin_in & pin_pre;  // High to Low detection: when pin_in is 0 and pin_pre was 1

    // Always block triggered on the rising edge of clk or reset signal (rst)
    always @( posedge clk or posedge rst )
        if( rst )  // If reset is active (high), initialize pin_pre to 0
            pin_pre <= 1'b0;
        else        // On the rising edge of clk, update pin_pre to the current value of pin_in
            pin_pre <= pin_in;

endmodule
