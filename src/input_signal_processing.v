`timescale 1ns / 1ps

// Module for input signal processing, handling debouncing and level detection for buttons and switches.
module input_signal_processing(
    input clk,                 // Clock signal input
    input rst_btn_c,           // Reset button input (active-low)
    output rst,                // Processed reset signal output
    
    input rx_pin_jb1,          // Input signal for receive pin
    output rx_pin_in,          // Processed receive pin signal output
    
    input get_btn_d,           // Button input for "get" action (debounced)
    output read_sig,           // Read signal output (activated on button press)
    
    input send_btn_r,          // Button input for "send" action (debounced)
    output write_sig,          // Write signal output (activated on button press)
    
    input en_sw15,             // Enable switch input
    output en_sig_ld15         // Processed enable signal output
);

// Instantiate the meta_harden module for debouncing the reset signal (rst_btn_c)
meta_harden rst_meta(
    .clk( clk ),              // Connect clock
    .rst( 1'b0 ),             // No reset needed for the meta_harden block itself
    .sig_src( rst_btn_c ),    // Input signal source (raw reset button)
    .sig_dst( rst )           // Output signal for reset
);

// Instantiate the meta_harden module for debouncing the receive pin signal (rx_pin_jb1)
meta_harden rx_pin_meta(
    .clk( clk ),              // Connect clock
    .rst( rst ),              // Connect reset signal
    .sig_src( rx_pin_jb1 ),   // Input signal source (raw receive pin)
    .sig_dst( rx_pin_in )     // Output signal for processed receive pin
);

///////////////////////////////
// Process the "get" button signal
wire get_pin;                 // Internal wire to hold debounced signal for "get" button
btn_debounce get_btn(
    .clk( clk ),               // Connect clock
    .rst( rst ),               // Connect reset signal
    .btn_pin( get_btn_d ),     // Input signal for the "get" button (raw)
    .pin_out( get_pin )        // Output debounced signal
);

// Instantiate L2H_detect to detect the rising edge (low-to-high transition) of "get" button signal
L2H_detect read_detect(
    .clk( clk ),               // Connect clock
    .rst( rst ),               // Connect reset signal
    .pin_in( get_pin ),        // Input signal (debounced "get" button)
    .sig_L2H( read_sig )       // Output read signal (activated on rising edge)
);

///////////////////////////////////
// Process the "send" button signal
wire send_pin;                // Internal wire to hold debounced signal for "send" button
btn_debounce send_btn(
    .clk( clk ),               // Connect clock
    .rst( rst ),               // Connect reset signal
    .btn_pin( send_btn_r ),    // Input signal for the "send" button (raw)
    .pin_out( send_pin )       // Output debounced signal
);

// Instantiate L2H_detect to detect the rising edge (low-to-high transition) of "send" button signal
L2H_detect write_detect(
    .clk( clk ),               // Connect clock
    .rst( rst ),               // Connect reset signal
    .pin_in( send_pin ),       // Input signal (debounced "send" button)
    .sig_L2H( write_sig )      // Output write signal (activated on rising edge)
);

///////////////////////////////////
// Process the "enable" switch signal
btn_debounce en_sw(
    .clk( clk ),               // Connect clock
    .rst( rst ),               // Connect reset signal
    .btn_pin( en_sw15 ),       // Input signal for the enable switch (raw)
    .pin_out( en_sig_ld15 )    // Output processed enable signal
);

endmodule
