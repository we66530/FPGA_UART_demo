// Module: assic2dec
// This module converts an 8-bit ASCII input (representing characters '0'-'9' and 'A'-'F') 
// into a 4-bit binary output corresponding to its hexadecimal value (0-15).

module assic2dec (
    input [7:0] datain,       // 8-bit ASCII input
    output reg [3:0] dataout  // 4-bit binary output representing decimal/hexadecimal values
);

    // Always block triggered by any change in the input 'datain'
    always @ (datain) begin
        // Case statement to map each ASCII input to its 4-bit binary equivalent
        case (datain)
            8'b0011_0000 : dataout = 4'b0000; // ASCII '0' -> Binary 0
            8'b0011_0001 : dataout = 4'b0001; // ASCII '1' -> Binary 1
            8'b0011_0010 : dataout = 4'b0010; // ASCII '2' -> Binary 2
            8'b0011_0011 : dataout = 4'b0011; // ASCII '3' -> Binary 3
            8'b0011_0100 : dataout = 4'b0100; // ASCII '4' -> Binary 4
            8'b0011_0101 : dataout = 4'b0101; // ASCII '5' -> Binary 5
            8'b0011_0110 : dataout = 4'b0110; // ASCII '6' -> Binary 6
            8'b0011_0111 : dataout = 4'b0111; // ASCII '7' -> Binary 7
            8'b0011_1000 : dataout = 4'b1000; // ASCII '8' -> Binary 8
            8'b0011_1001 : dataout = 4'b1001; // ASCII '9' -> Binary 9
            8'b0100_0001 : dataout = 4'b1010; // ASCII 'A' -> Binary 10 (Hexadecimal A)
            8'b0100_0010 : dataout = 4'b1011; // ASCII 'B' -> Binary 11 (Hexadecimal B)
            8'b0100_0011 : dataout = 4'b1100; // ASCII 'C' -> Binary 12 (Hexadecimal C)
            8'b0100_0100 : dataout = 4'b1101; // ASCII 'D' -> Binary 13 (Hexadecimal D)
            8'b0100_0101 : dataout = 4'b1110; // ASCII 'E' -> Binary 14 (Hexadecimal E)
            8'b0100_0110 : dataout = 4'b1111; // ASCII 'F' -> Binary 15 (Hexadecimal F)
            default : dataout = 4'b0000;      // Default case for invalid inputs
        endcase
    end
endmodule
