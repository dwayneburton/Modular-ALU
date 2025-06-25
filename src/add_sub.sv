/***************************************************/
/* Parameterized Adder/Subtractor Module           */
/* Performs addition or subtraction on N-bit data  */
/***************************************************/

module add_sub #(
    parameter DATAW = 2 // Bit width of operands
)(
    input  [DATAW-1:0] i_dataa, // First operand (A)
    input  [DATAW-1:0] i_datab, // Second operand (B)
    input              i_op,    // Operation select: 0 = A + B, 1 = A - B
    output [DATAW:0]   o_result // N+1 bit result (includes carry/borrow)
);

// Internal result and carry signals
logic [DATAW:0] res;
logic [DATAW:0] carry;

// Initial carry-in is the operation bit (used for 2's complement subtraction)
assign carry[0] = i_op;

// Generate full adder chain for each bit
genvar i;
generate
    for (i = 0; i < DATAW; i = i + 1) begin: gen_adders
        full_adder add_inst (
            .a   (i_dataa[i]),
            .b   (i_datab[i] ^ i_op), // XOR with op for 2's complement subtraction
            .cin (carry[i]),
            .s   (res[i]),
            .cout(carry[i + 1])
        );
    end
endgenerate

// Final full adder stage (handles overflow/carry-out)
full_adder add_final (
    .a   (i_dataa[DATAW-1]),
    .b   (i_datab[DATAW-1] ^ i_op),
    .cin (carry[DATAW]),
    .s   (res[DATAW]),
    .cout() // Overflow not captured
);

// Assign result to output
assign o_result = res;

endmodule