`timescale 1ns / 1ps

module btn_debounce(
    input clk,        // Clock signal, used to synchronize operations
    input rst,        // Reset signal (active high), resets the module to initial state
    input btn_pin,    // The button input pin that may have noise or bouncing
    output pin_out    // The debounced output signal for the button press
    );

    // 1. Meta-stable signal hardening: De-bouncing the button input
    wire btn_pin_m; // The meta-stable hardened version of the button input signal
    meta_harden pin_meta (
        .clk( clk ),      // Clock signal
        .rst( rst ),      // Reset signal
        .sig_src( btn_pin ),  // The noisy or bouncing input signal (button)
        .sig_dst( btn_pin_m ) // The debounced output from the meta-stable hardening
    );

    // 2. Reverse signal detection: Detects when the button input changes state
    wire reverse_sig; // The reverse detection signal indicating a change in button state
    reverse_detect reverse_detect (
        .clk( clk ),      // Clock signal
        .rst( rst ),      // Reset signal
        .pin_in( btn_pin_m ),  // The debounced button signal from meta-harden module
        .reverse_sig( reverse_sig ) // Output signal indicating a state change (reverse)
    );

    // 3. Delay module: Adds a 10ms delay to ensure the button press is stable
    wire dly_over; // Signal indicating that the delay period has completed
    delay_10ms delay_10ms (
        .clk( clk ),      // Clock signal
        .rst( rst ),      // Reset signal
        .dly_sig( reverse_sig ), // Reverse signal from reverse detection
        .dly_over( dly_over ) // Signal indicating that the delay is over
    );

    // 4. Output control module: Outputs the final debounced button signal
    out_ctl out_ctl (
        .clk( clk ),      // Clock signal
        .rst( rst ),      // Reset signal
        .dly_over( dly_over ), // Signal indicating that the delay has finished
        .pin_in( btn_pin_m ),  // Debounced button signal from the meta-harden module
        .pin_out( pin_out ) // Final debounced output for the button press
    );

endmodule
