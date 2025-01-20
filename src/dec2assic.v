// Module: dec2assic
// This module converts a 4-bit binary input (0-15) into its corresponding ASCII representation.
// ASCII representation:
// - 0-9: ASCII codes for characters '0' to '9'
// - A-F: ASCII codes for characters 'A' to 'F'

module dec2assic (
    input [3:0] datain,       // 4-bit binary input representing decimal numbers (0-15)
    output reg [7:0] dataout  // 8-bit ASCII output corresponding to the input
);

    // Always block triggered by any change in the input 'datain'
    always @ (datain) begin
        // Case statement to map each binary input to its ASCII equivalent
        case (datain)
            4'b0000 : dataout = 8'b0011_0000; // ASCII '0'
            4'b0001 : dataout = 8'b0011_0001; // ASCII '1'
            4'b0010 : dataout = 8'b0011_0010; // ASCII '2'
            4'b0011 : dataout = 8'b0011_0011; // ASCII '3'
            4'b0100 : dataout = 8'b0011_0100; // ASCII '4'
            4'b0101 : dataout = 8'b0011_0101; // ASCII '5'
            4'b0110 : dataout = 8'b0011_0110; // ASCII '6'
            4'b0111 : dataout = 8'b0011_0111; // ASCII '7'
            4'b1000 : dataout = 8'b0011_1000; // ASCII '8'
            4'b1001 : dataout = 8'b0011_1001; // ASCII '9'
            4'b1010 : dataout = 8'b0100_0001; // ASCII 'A'
            4'b1011 : dataout = 8'b0100_0010; // ASCII 'B'
            4'b1100 : dataout = 8'b0100_0011; // ASCII 'C'
            4'b1101 : dataout = 8'b0100_0100; // ASCII 'D'
            4'b1110 : dataout = 8'b0100_0101; // ASCII 'E'
            4'b1111 : dataout = 8'b0100_0110; // ASCII 'F'
            default : dataout = 8'b0000_0000;  // Default value if 'datain' is out of range
        endcase
    end
endmodule
