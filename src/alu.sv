/***************************************************/
/* Shift-Left, Add, Subtract ALU Module            */
/* Supports basic arithmetic and logic operations  */
/***************************************************/

module alu #(
    parameter DATAW = 2 // Bit width of operands
)(
    input  clk,                   // Clock signal
    input  [DATAW-1:0] i_dataa,   // Operand A
    input  [DATAW-1:0] i_datab,   // Operand B
    input  [1:0]       i_op,      // Operation code: 
                                  // 00 = reset, 
                                  // 01 = shift left, 
                                  // 10 = add, 
                                  // 11 = subtract
    output [2*DATAW-1:0] o_result // ALU output (extended width)
);

// Internal registers to store inputs and result
logic [DATAW-1:0] dataa;
logic [DATAW-1:0] datab;
logic [1:0]       op;
logic [DATAW:0]   res;
logic [2*DATAW-1:0] o;

// Instantiate adder/subtractor module (always computes A + B or A - B based on op[0])
add_sub #(DATAW) alu_inst (
    .i_dataa  (dataa),
    .i_datab  (datab),
    .i_op     (op[0]), // LSB of opcode selects between add and subtract
    .o_result (res)
);

// Sequential logic: latch inputs and compute result based on opcode
always_ff @ (posedge clk) begin
    dataa <= i_dataa;
    datab <= i_datab;
    op    <= i_op;

    case (op)
        2'b00: begin
            // Clear output (reset)
            o <= 0;
        end
        2'b01: begin
            // Shift A left by value of B
            o <= dataa << datab;
        end
        default: begin
            // Add or subtract with sign extension to preserve 2's complement format
            o <= {{(DATAW-1){res[DATAW]}}, res};
        end
    endcase
end

// Assign computed value to output
assign o_result = o;

endmodule