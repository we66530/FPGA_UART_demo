`timescale 1ns / 1ps
// RX (Receive) Top-level module for handling the reception of data from RX pin
module rx_top(
    input clk,               // System clock input
    input rst,               // System reset input
    input rx_pin_in,         // RX data input pin (received signal)
    output [7:0] rx_data,    // 8-bit received data output
    output rx_done_sig       // Signal indicating that data reception is complete
    );

    // Signal to detect the change from high to low on the RX pin
    wire rx_pin_H2L;

    // Module for detecting a high-to-low signal transition on the RX pin
    H2L_detect rx_in_detect(
        .clk( clk ),               // Clock input
        .rst( rst ),               // Reset input
        .pin_in( rx_pin_in ),      // RX pin input signal
        .sig_H2L( rx_pin_H2L )     // Output signal indicating high-to-low transition
    );

    // Signal to band-pass filter the RX signal and generate a clock for baud rate sampling
    wire rx_band_sig;
    wire clk_bps;

    // Band-pass signal generator for RX signal processing and baud rate clock generation
    rx_band_gen rx_band_gen(
        .clk( clk ),               // Clock input
        .rst( rst ),               // Reset input
        .band_sig( rx_band_sig ),  // Band-pass filtered RX signal output
        .clk_bps( clk_bps )        // Baud rate clock output for sampling the signal
    );

    // RX control module to manage the reception and data extraction from the RX signal
    rx_ctl rx_ctl(
        .clk( clk ),               // Clock input
        .rst( rst ),               // Reset input
        .rx_pin_in( rx_pin_in ),   // RX input pin signal
        .rx_pin_H2L( rx_pin_H2L ), // Signal indicating high-to-low transition on RX pin
        .rx_band_sig( rx_band_sig ), // Processed band-pass signal for RX
        .rx_clk_bps( clk_bps ),    // Baud rate clock for sampling
        .rx_data( rx_data ),       // Output received data
        .rx_done_sig( rx_done_sig ) // Signal indicating completion of data reception
    );
    
endmodule

