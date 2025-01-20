`timescale 1ns / 1ps
module tx_ctl(
    input clk,                // Main clock input (drives the state machine)
    input rst,                // Reset input (active-high, resets the module's state)
    input tx_clk_bps,         // Transmission clock at baud rate (used to control data transmission speed)
    output reg tx_band_sig,   // Band signal (indicates when data transmission is active)
    output reg tx_pin_out,    // The output signal that drives the data pin for transmission
    input [7:0] tx_data,      // 8-bit data to be transmitted
    input tx_buf_not_empty,   // Input signal indicating if the TX buffer is not empty
    output reg tx_read_buf    // Output signal to read the data from the TX buffer
    );

    // Define the states for the state machine using a 4-bit register
    localparam [3:0] 
        IDLE = 4'd0,  // Idle state, waiting for data
        BEGIN = 4'd1, // Start bit transmission state
        DATA0 = 4'd2, // Data bit 0 state
        DATA1 = 4'd3, // Data bit 1 state
        DATA2 = 4'd4, // Data bit 2 state
        DATA3 = 4'd5, // Data bit 3 state
        DATA4 = 4'd6, // Data bit 4 state
        DATA5 = 4'd7, // Data bit 5 state
        DATA6 = 4'd8, // Data bit 6 state
        DATA7 = 4'd9, // Data bit 7 state
        END = 4'd10,  // End bit transmission state
        BFREE = 4'd11; // Free state, ready to transition back to IDLE
    
    reg [3:0] pos;  // 4-bit position register that keeps track of the current state

    // State machine for the transmission control
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset conditions: Clear all outputs and set state to IDLE
            tx_band_sig <= 1'b0;
            tx_pin_out <= 1'b1;  // Set the output pin to idle (high) by default
            tx_read_buf <= 1'b0; // Disable reading from the buffer initially
            pos <= IDLE;         // Set the state to IDLE
        end else begin
            case (pos)
                IDLE: begin
                    // In IDLE state, check if the TX buffer is not empty
                    if (tx_buf_not_empty) begin
                        tx_read_buf <= 1'b1;    // Enable reading from the buffer
                        tx_band_sig <= 1'b1;    // Indicate that data transmission is starting
                        pos <= pos + 1'b1;      // Move to the BEGIN state
                    end
                end
                BEGIN: begin
                    // In BEGIN state, transmit the start bit (logic low)
                    tx_read_buf <= 1'b0;  // Disable reading from the buffer once transmission starts
                    if (tx_clk_bps) begin
                        tx_pin_out <= 1'b0;  // Set the data pin to logic low for the start bit
                        pos <= pos + 1'b1;   // Transition to the DATA0 state
                    end
                end
                DATA0, DATA1, DATA2, DATA3, DATA4, DATA5, DATA6, DATA7: begin
                    // In DATA0 to DATA7 states, transmit the corresponding data bit
                    if (tx_clk_bps) begin
                        tx_pin_out <= tx_data[pos - DATA0];  // Output the appropriate bit from tx_data
                        pos <= pos + 1'b1;  // Move to the next data bit
                    end
                end
                END: begin
                    // In END state, transmit the stop bit (logic high)
                    if (tx_clk_bps) begin
                        tx_pin_out <= 1'b1;  // Set the data pin to logic high for the stop bit
                        pos <= pos + 1'b1;   // Transition to the BFREE state
                    end
                end
                BFREE: begin
                    // In BFREE state, transition back to IDLE after the stop bit is sent
                    if (tx_clk_bps) begin
                        pos <= IDLE;      // Go back to IDLE state
                        tx_band_sig <= 1'b0; // Deactivate the transmission band signal
                    end
                end
            endcase
        end
    end
    
endmodule
