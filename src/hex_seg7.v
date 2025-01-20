module hex_seg7 (hex, seg_data);
    input [4:0] hex;         // 5-bit input representing a hexadecimal value (0-15)
    output reg [7:0] seg_data; // 8-bit output representing the 7-segment display data

    // Always block to convert the hex input to corresponding 7-segment display data
    always @ (hex) begin
        // Case statement to map the hex input to 7-segment encoding
        case (hex)
            // Hexadecimal value 0 maps to 7-segment display pattern for '0'
            5'b0_0000 : seg_data = ~(8'b1100_0000); // ~1100_0000 (turn on segments a, b, c, d, e, f)
            // Hexadecimal value 1 maps to 7-segment display pattern for '1'
            5'b0_0001 : seg_data = ~(8'b1111_1001); // ~1111_1001 (turn on segments b, c)
            // Hexadecimal value 2 maps to 7-segment display pattern for '2'
            5'b0_0010 : seg_data = ~(8'b1010_0100); // ~1010_0100 (turn on segments a, b, d, e, g)
            // Hexadecimal value 3 maps to 7-segment display pattern for '3'
            5'b0_0011 : seg_data = ~(8'b1011_0000); // ~1011_0000 (turn on segments a, b, c, d, g)
            // Hexadecimal value 4 maps to 7-segment display pattern for '4'
            5'b0_0100 : seg_data = ~(8'b1001_1001); // ~1001_1001 (turn on segments b, c, f, g)
            // Hexadecimal value 5 maps to 7-segment display pattern for '5'
            5'b0_0101 : seg_data = ~(8'b1001_0010); // ~1001_0010 (turn on segments a, c, d, f, g)
            // Hexadecimal value 6 maps to 7-segment display pattern for '6'
            5'b0_0110 : seg_data = ~(8'b1000_0010); // ~1000_0010 (turn on segments a, c, d, e, f, g)
            // Hexadecimal value 7 maps to 7-segment display pattern for '7'
            5'b0_0111 : seg_data = ~(8'b1111_1000); // ~1111_1000 (turn on segments a, b, c)
            // Hexadecimal value 8 maps to 7-segment display pattern for '8'
            5'b0_1000 : seg_data = ~(8'b1000_0000); // ~1000_0000 (turn on all segments)
            // Hexadecimal value 9 maps to 7-segment display pattern for '9'
            5'b0_1001 : seg_data = ~(8'b1001_0000); // ~1001_0000 (turn on segments a, b, c, d, f)
            // Hexadecimal value A (10) maps to 7-segment display pattern for 'A'
            5'b0_1010 : seg_data = ~(8'b1000_1000); // ~1000_1000 (turn on segments a, b, e, f, g)
            // Hexadecimal value B (11) maps to 7-segment display pattern for 'B'
            5'b0_1011 : seg_data = ~(8'b1000_0011); // ~1000_0011 (turn on segments a, b, c, d, e, f)
            // Hexadecimal value C (12) maps to 7-segment display pattern for 'C'
            5'b0_1100 : seg_data = ~(8'b1100_0110); // ~1100_0110 (turn on segments a, d, e, f)
            // Hexadecimal value D (13) maps to 7-segment display pattern for 'D'
            5'b0_1101 : seg_data = ~(8'b1010_0001); // ~1010_0001 (turn on segments a, b, c, d, e)
            // Hexadecimal value E (14) maps to 7-segment display pattern for 'E'
            5'b0_1110 : seg_data = ~(8'b1000_0110); // ~1000_0110 (turn on segments a, d, e, f, g)
            // Hexadecimal value F (15) maps to 7-segment display pattern for 'F'
            5'b0_1111 : seg_data = ~(8'b1000_1110); // ~1000_1110 (turn on segments a, e, f, g)
            // Default case to handle undefined inputs (shouldn't occur in a 4-bit system)
            default : seg_data = ~(8'b1011_1111); // ~1011_1111 (undefined case handling)
        endcase
    end
endmodule
