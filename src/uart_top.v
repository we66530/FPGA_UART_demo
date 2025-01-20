`timescale 1ns / 1ps
// UART top-level module for handling both TX (transmit) and RX (receive) functionalities
module uart_top(
    input clk,               // System clock input
    input rst,               // System reset input
    input en,                // Enable signal for UART operation
    
    // RX (Receive) Interface
    input rx_read,           // Read signal for UART RX buffer
    input rx_pin_in,         // RX data input pin (received signal)
    output rx_buf_not_empty, // Flag indicating that RX buffer is not empty
    output rx_buf_full,      // Flag indicating that RX buffer is full
    output [7:0] rx_get_data,// 8-bit received data output
    
    // TX (Transmit) Interface
    input tx_write,          // Write signal for UART TX buffer
    input [7:0] tx_send_data,// 8-bit data to be transmitted
    output tx_pin_out,       // TX data output pin (transmit signal)
    output tx_buf_not_full   // Flag indicating that TX buffer is not full
    );
    
    // Internal signals for buffered RX and TX operations
    wire rx_read_buf, tx_write_buf;
    wire gate_clk, rst_en_ctl;

    // Enable control unit to manage various UART operations based on enable signal
    en_ctl en_ctl(
        .clk( clk ),
        .rst( rst ),
        .en( en ),
        .rx_read( rx_read ),
        .tx_write( tx_write ),
        .gate_clk( gate_clk ),
        .rst_en_ctl( rst_en_ctl ),
        .rx_read_buf( rx_read_buf ),
        .tx_write_buf( tx_write_buf )
    );
    
    // RX data buffer signals
    wire [7:0] rx_data;           // 8-bit RX data signal
    wire rx_write_buf;            // RX write buffer enable signal
    wire rx_buf_empty;            // Flag for RX buffer empty status

    // Output assignment for RX buffer not empty flag
    assign rx_buf_not_empty = ~rx_buf_empty;

    // RX data buffer to store received data
    data_buf rx_buf (
      .clk( clk ),               // Clock input
      .rst( rst ),               // Reset input
      .din( rx_data ),           // Data input for RX buffer
      .wr_en( rx_write_buf ),    // Write enable signal for RX buffer
      .rd_en( rx_read_buf ),     // Read enable signal for RX buffer
      .dout( rx_get_data ),      // Data output from RX buffer
      .full( rx_buf_full ),      // RX buffer full flag
      .empty( rx_buf_empty )     // RX buffer empty flag
    );

    // TX data buffer signals
    wire tx_read_buf;            // TX read buffer enable signal
    wire [7:0] tx_data;          // 8-bit TX data signal
    wire tx_buf_full, tx_buf_empty; // TX buffer full and empty status flags
    wire tx_buf_not_empty;       // TX buffer not empty status flag

    // Output assignments for TX buffer not full and not empty flags
    assign tx_buf_not_full = ~tx_buf_full;
    assign tx_buf_not_empty = ~tx_buf_empty;
    
    // TX data buffer to store data to be transmitted
    data_buf tx_buf (
      .clk( clk ),               // Clock input
      .rst( rst ),               // Reset input
      .din( tx_send_data ),      // Data input for TX buffer
      .wr_en( tx_write_buf ),    // Write enable signal for TX buffer
      .rd_en( tx_read_buf ),     // Read enable signal for TX buffer
      .dout( tx_data ),          // Data output from TX buffer
      .full( tx_buf_full ),      // TX buffer full flag
      .empty( tx_buf_empty )     // TX buffer empty flag
    );
    
    // TX module responsible for generating the transmission signal
    tx_top tx_top(
        .clk( clk ),             // Clock input
        .rst( rst_en_ctl ),      // Reset signal controlled by enable logic
        .tx_pin_out( tx_pin_out ), // Output for TX signal
        .tx_data( tx_data ),      // Data to be transmitted
        .tx_buf_not_empty( tx_buf_not_empty ), // Flag for TX buffer not empty
        .tx_read_buf( tx_read_buf ) // Read enable signal for TX buffer
    );

    // RX module responsible for receiving data from the input pin
    rx_top rx_top(
        .clk( clk ),             // Clock input
        .rst( rst_en_ctl ),      // Reset signal controlled by enable logic
        .rx_pin_in( rx_pin_in ), // RX input data pin
        .rx_data( rx_data ),     // Received data signal
        .rx_done_sig( rx_write_buf ) // Signal to write received data to buffer
    );
    
endmodule
