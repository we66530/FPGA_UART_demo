`timescale 1ns / 1ps

module Divider_Clock #(
    // Parameters to allow customization of the output clock frequencies
    parameter Custom_Outputclk_0 = 10'b1,  // Custom output clock frequency 0 (default: 1)
    parameter Custom_Outputclk_1 = 10'b1,  // Custom output clock frequency 1 (default: 1)
    parameter Custom_Outputclk_2 = 10'b1   // Custom output clock frequency 2 (default: 1)
)(
    input clkin,                // Input clock signal
    input rst_n,                // Active-low reset signal
    output reg clkout_1K = 1,   // Output clock signal at 1 KHz
    output reg clkout_100 = 1,  // Output clock signal at 100 Hz
    output reg clkout_10 = 1,   // Output clock signal at 10 Hz
    output reg clkout_1 = 1,    // Output clock signal at 1 Hz
    output reg clkout_Custom_0 = 1,  // Output custom clock 0
    output reg clkout_Custom_1 = 1,  // Output custom clock 1
    output reg clkout_Custom_2 = 1   // Output custom clock 2
);

    // Function to calculate the number of bits required for a counter
    function integer clogb2(input integer bit_Depth);
        begin
            for(clogb2 = 0; bit_Depth > 0 ; clogb2 = clogb2 + 1)
                bit_Depth = bit_Depth >> 1;
        end
    endfunction

    // Original clock frequency (100 MHz)
    parameter Orianal_Clock = 100_000_000;

    // Divider values for the fixed frequency outputs
    parameter Divider_Counter_1K = 100_000;    // 1 KHz clock divider (1 MHz / 1000)
    parameter Divider_Counter_100 = 1_00_000;  // 100 Hz clock divider (10 MHz / 100)
    parameter Divider_Counter_10 = 10_000_000; // 10 Hz clock divider (10 MHz / 1)
    parameter Divider_Counter_1 = 100_000_000; // 1 Hz clock divider (100 MHz / 1)

    // Calculating the counters for the custom output clocks based on the input parameters
    localparam integer Divider_Counter_C_0 = Orianal_Clock / Custom_Outputclk_0;
    localparam integer Count_Bits_0 = clogb2(Divider_Counter_C_0 - 1);

    localparam integer Divider_Counter_C_1 = Orianal_Clock / Custom_Outputclk_1;
    localparam integer Count_Bits_1 = clogb2(Divider_Counter_C_1 - 1);

    localparam integer Divider_Counter_C_2 = Orianal_Clock / Custom_Outputclk_2;
    localparam integer Count_Bits_2 = clogb2(Divider_Counter_C_2 - 1);

    // Internal counters for each output clock signal
    reg [15:0] Counter_1k = 0;
    reg [18:0] Counter_100 = 0;
    reg [24:0] Counter_10 = 0;
    reg [26:0] Counter_1 = 0;
    reg [Count_Bits_0 - 1 : 0] Counter_C_0 = 0;    
    reg [Count_Bits_1 - 1 : 0] Counter_C_1 = 0;
    reg [Count_Bits_2 - 1 : 0] Counter_C_2 = 0;

    // First always block to manage the counting of fixed-frequency clock outputs
    always @(posedge clkin or negedge rst_n) begin
        if (!rst_n) begin
            Counter_1k <= 0;
            Counter_100 <= 0;
            Counter_10 <= 0;
            Counter_1 <= 0;
        end else begin
            // Generate 1KHz clock signal
            if (Counter_1k == (Divider_Counter_1K - 1))
                Counter_1k <= 0;
            else
                Counter_1k <= Counter_1k + 1;

            // Generate 100Hz clock signal
            if (Counter_100 == (Divider_Counter_100 - 1))
                Counter_100 <= 0;
            else
                Counter_100 <= Counter_100 + 1;

            // Generate 10Hz clock signal
            if (Counter_10 == (Divider_Counter_10 - 1))
                Counter_10 <= 0;
            else
                Counter_10 <= Counter_10 + 1;

            // Generate 1Hz clock signal
            if (Counter_1 == (Divider_Counter_1 - 1))
                Counter_1 <= 0;
            else
                Counter_1 <= Counter_1 + 1;
        end
    end

    // Second always block to manage the counting of custom-frequency clock outputs
    always @(posedge clkin or negedge rst_n) begin
        if (!rst_n) begin
            Counter_C_0 <= 0;
            Counter_C_1 <= 0;
            Counter_C_2 <= 0;
        end else begin
            // Custom clock 0
            if (Divider_Counter_C_0 != Orianal_Clock) begin
                if (Counter_C_0 == (Divider_Counter_C_0 - 1))
                    Counter_C_0 <= 0;
                else
                    Counter_C_0 <= Counter_C_0 + 1;
            end

            // Custom clock 1
            if (Divider_Counter_C_1 != Orianal_Clock) begin
                if (Counter_C_1 == (Divider_Counter_C_1 - 1))
                    Counter_C_1 <= 0;
                else
                    Counter_C_1 <= Counter_C_1 + 1;
            end

            // Custom clock 2
            if (Divider_Counter_C_2 != Orianal_Clock) begin
                if (Counter_C_2 == (Divider_Counter_C_2 - 1))
                    Counter_C_2 <= 0;
                else
                    Counter_C_2 <= Counter_C_2 + 1;
            end
        end
    end

    // Third always block to generate the output clock signals based on the counters
    always @(posedge clkin or negedge rst_n) begin
        if (!rst_n) begin
            clkout_1K <= 0;
            clkout_100 <= 0;
            clkout_10 <= 0;
            clkout_1 <= 0;
            clkout_Custom_0 <= 0;
            clkout_Custom_1 <= 0;
            clkout_Custom_2 <= 0;
        end else begin
            // Generate 1KHz clock output
            if (Counter_1k < Divider_Counter_1K / 2)
                clkout_1K <= 1'b0;
            else
                clkout_1K <= 1'b1;

            // Generate 100Hz clock output
            if (Counter_100 < Divider_Counter_100 / 2)
                clkout_100 <= 1'b0;
            else
                clkout_100 <= 1'b1;

            // Generate 10Hz clock output
            if (Counter_10 < Divider_Counter_10 / 2)
                clkout_10 <= 1'b0;
            else
                clkout_10 <= 1'b1;

            // Generate 1Hz clock output
            if (Counter_1 < Divider_Counter_1 / 2)
                clkout_1 <= 1'b0;
            else
                clkout_1 <= 1'b1;

            // Generate custom clock output 0
            if (Counter_C_0 < Divider_Counter_C_0 / 2)
                clkout_Custom_0 <= 1'b0;
            else
                clkout_Custom_0 <= 1'b1;

            // Generate custom clock output 1
            if (Counter_C_1 < Divider_Counter_C_1 / 2)
                clkout_Custom_1 <= 1'b0;
            else
                clkout_Custom_1 <= 1'b1;

            // Generate custom clock output 2
            if (Counter_C_2 < Divider_Counter_C_2 / 2)
                clkout_Custom_2 <= 1'b0;
            else
                clkout_Custom_2 <= 1'b1;
        end
    end
endmodule
