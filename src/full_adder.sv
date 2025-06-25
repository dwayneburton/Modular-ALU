/***************************************************/
/* 1-bit Full Adder Module                         */
/* Adds two 1-bit operands and a carry-in          */
/***************************************************/

module full_adder (
    input  a,     // First operand bit
    input  b,     // Second operand bit
    input  cin,   // Carry-in bit
    output s,     // Sum output bit
    output cout   // Carry-out bit
);

// Internal signals for sum and carry logic
logic o0, o1;

// Combinational logic for 1-bit full adder
always_comb begin
    o0 <= cin ^ (a ^ b);                     // Sum: XOR of all three inputs
    o1 <= (cin & (a | b)) | (a & b);         // Carry: Majority logic
end

assign s    = o0;
assign cout = o1;

endmodule