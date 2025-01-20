`timescale 1ns / 1ps

module delay_10ms(
    input clk,           // Clock signal to synchronize operations
    input rst,           // Reset signal (active high), resets the module to initial state
    input dly_sig,       // Input signal that triggers the delay
    output reg dly_over  // Output signal indicating that the delay has completed
    );

    // Parameter defining the number of clock cycles required for a 10ms delay
    parameter T10MS = 20'd1000000;  // 10ms delay at a 100 MHz clock rate (1e6 clock cycles for 10ms)

    // Internal registers for counting clock cycles and tracking the state
    reg [19:0] cnt_clk;  // 20-bit counter to count clock cycles
    reg pos;              // State signal used to track the delay stages (0 or 1)

    // Main process triggered on rising edge of clock or reset signal
    always @(posedge clk or posedge rst)
        if (rst)  // Reset condition
        begin
            cnt_clk <= 20'd0;    // Reset the counter to 0
            dly_over <= 1'b0;     // Reset the output delay signal
            pos <= 1'b0;          // Reset state signal to 0 (start state)
        end
        else
            case (pos)
                1'b0:  // State 0: Waiting for the input trigger signal (dly_sig)
                begin
                    dly_over <= 1'b0;  // The delay is not over yet
                    if (dly_sig)        // If the trigger signal (dly_sig) is active
                        pos <= 1'b1;     // Transition to state 1 (start counting delay)
                end
                1'b1:  // State 1: Delay counting is in progress
                    if (cnt_clk == T10MS)  // If the counter reaches the defined delay duration (10ms)
                    begin
                        dly_over <= 1'b1;    // Set the output signal to indicate that the delay is complete
                        cnt_clk <= 20'd0;     // Reset the counter
                        pos <= 1'b0;          // Transition back to state 0 (wait for next trigger)
                    end
                    else
                        cnt_clk <= cnt_clk + 1'b1;  // Increment the counter until it reaches the target delay
            endcase

endmodule
