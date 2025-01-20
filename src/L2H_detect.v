`timescale 1ns / 1ps

module L2H_detect(
    input clk,       // Clock signal
    input rst,       // Reset signal (active high)
    input pin_in,    // Input signal whose transitions are being detected
    output sig_L2H   // Output signal indicating a low-to-high transition
    );

    // Register to store the previous value of pin_in
    reg pin_pre;

    // sig_L2H is asserted (high) when there's a low-to-high transition in pin_in
    assign sig_L2H = pin_in & !pin_pre;  // Low to High detection: when pin_in is 1 and pin_pre was 0

    // Always block triggered on the rising edge of clk or reset signal (rst)
    always @( posedge clk or posedge rst )
        if( rst )  // If reset is active (high), initialize pin_pre to 0
            pin_pre <= 1'b0;
        else        // On the rising edge of clk, update pin_pre to the current value of pin_in
            pin_pre <= pin_in;

endmodule
