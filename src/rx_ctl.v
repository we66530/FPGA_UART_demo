`timescale 1ns / 1ps

// RX control module for UART, responsible for handling the reception process
module rx_ctl(
    input clk,               // System clock input
    input rst,               // Reset input
    input rx_pin_in,         // Data input pin (received signal)
    input rx_pin_H2L,        // Detects high-to-low edge of the RX signal (Start bit detection)
    output reg rx_band_sig,  // Output signal to start and stop RX operation
    input rx_clk_bps,        // Baud rate clock input (e.g., 9600 bps)
    output reg[7:0] rx_data, // 8-bit received data output
    output reg rx_done_sig   // Signal indicating the completion of data reception
    );
    
    // State definitions for the finite state machine (FSM)
    localparam [3:0] 
        IDLE   = 4'd0,   // Initial state, waiting for start signal
        BEGIN  = 4'd1,   // Start of data reception, checking for valid start bit
        DATA0  = 4'd2,   // Receiving data bit 0
        DATA1  = 4'd3,   // Receiving data bit 1
        DATA2  = 4'd4,   // Receiving data bit 2
        DATA3  = 4'd5,   // Receiving data bit 3
        DATA4  = 4'd6,   // Receiving data bit 4
        DATA5  = 4'd7,   // Receiving data bit 5
        DATA6  = 4'd8,   // Receiving data bit 6
        DATA7  = 4'd9,   // Receiving data bit 7
        END    = 4'd10,  // End of reception, preparing to signal completion
        BFREE  = 4'd11;  // Buffer free, reset state for next reception

    reg [3:0] pos;  // State register to hold current state position

    // Asynchronous reset and state machine logic
    always @( posedge clk or posedge rst )
        if (rst)  // Reset condition: clear all signals and return to IDLE state
            begin
                rx_band_sig <= 1'b0;        // Disable RX operation
                rx_data <= 8'd0;            // Clear received data
                pos <= IDLE;                // Set state to IDLE
                rx_done_sig <= 1'b0;        // Clear done signal
            end
        else  // FSM operation based on current state
            case (pos)
                IDLE:  // Wait for the start signal (H2L edge), then move to BEGIN
                    if (rx_pin_H2L)  // Detect high-to-low transition (start bit)
                        begin
                            rx_band_sig <= 1'b1;  // Enable RX operation
                            pos <= pos + 1'b1;    // Transition to BEGIN state
                            rx_data <= 8'd0;      // Clear data register
                        end

                BEGIN:  // Check for valid start bit (rx_pin_in = 0), then move to DATA0
                    if (rx_clk_bps)  // Use baud rate clock to sample data
                        begin
                            if (rx_pin_in == 1'b0)  // Valid start bit detected
                                pos <= pos + 1'b1;  // Move to DATA0 state
                            else  // Invalid start bit, return to IDLE
                                begin
                                    rx_band_sig <= 1'b0;  // Disable RX operation
                                    pos <= IDLE;          // Return to IDLE state
                                end
                        end

                // States DATA0 to DATA7: Receive each bit and store in rx_data
                DATA0, DATA1, DATA2, DATA3, DATA4, DATA5, DATA6, DATA7:
                    if (rx_clk_bps)  // Use baud rate clock to sample data bits
                        begin
                            rx_data[pos - DATA0] <= rx_pin_in;  // Store the bit in rx_data
                            pos <= pos + 1'b1;  // Move to the next bit
                        end

                END:  // End of reception: signal completion and stop RX operation
                    if (rx_clk_bps)  // Use baud rate clock to finalize reception
                        begin
                            rx_done_sig <= 1'b1;  // Set done signal to indicate data is received
                            pos <= pos + 1'b1;    // Transition to BFREE
                            rx_band_sig <= 1'b0;  // Disable RX operation
                        end

                BFREE:  // After reception is done, return to IDLE to prepare for the next cycle
                    begin
                        rx_done_sig <= 1'b0;  // Clear done signal
                        pos <= IDLE;          // Return to IDLE state
                    end
            endcase
endmodule
