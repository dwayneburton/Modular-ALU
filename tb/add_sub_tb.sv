/***************************************************/
/* Add/Subtract Testbench                          */
/* Randomized verification of multi-bit ALU module */
/***************************************************/

`timescale 1ns/1ps

module add_sub_tb ();

// Parameters
localparam DATAW = 8;        // Width of input operands
localparam NUM_TESTS = 100;  // Number of randomized test cases

// DUT interface signals
logic [DATAW-1:0] dataa_sig;
logic [DATAW-1:0] datab_sig;
logic op_sig;
logic [DATAW:0]   result_sig;

// Instantiate DUT (add_sub)
add_sub #(
    .DATAW(DATAW)
) dut (
    .i_dataa   (dataa_sig),
    .i_datab   (datab_sig),
    .i_op      (op_sig),
    .o_result  (result_sig)
);

// Internal variables for testing
integer test_id;
integer correct_results;
logic [DATAW:0] golden_result;

initial begin
    $timeformat(-9, 2, " ns");  // Time display formatting

    // Initialize inputs
    op_sig        = 0;
    dataa_sig     = 0;
    datab_sig     = 0;
    correct_results = 0;
    #2;

    // Randomized test loop
    for (test_id = 0; test_id < NUM_TESTS; test_id++) begin
        dataa_sig = $random;
        datab_sig = $random;
        op_sig    = $random % 2;

        // Behavioral golden result (signed arithmetic)
        if (op_sig == 1'b0)
            golden_result = signed'(dataa_sig) + signed'(datab_sig);
        else
            golden_result = signed'(dataa_sig) - signed'(datab_sig);

        #2;

        // Check DUT result
        if (result_sig == golden_result) begin
            $write("[%0t] Correct Result! ", $time);
            correct_results++;
        end else begin
            $write("[%0t] INCORRECT RESULT! ", $time);
        end

        case (op_sig)
            1'b0: $display("A=%b (%d)\tB=%b (%d)\tOP=ADD\t\tResult=%b (%d)\tGolden=%b (%d)",
                signed'(dataa_sig), signed'(dataa_sig),
                signed'(datab_sig), signed'(datab_sig),
                signed'(result_sig), signed'(result_sig),
                signed'(golden_result), signed'(golden_result));
            1'b1: $display("A=%b (%d)\tB=%b (%d)\tOP=SUB\t\tResult=%b (%d)\tGolden=%b (%d)",
                signed'(dataa_sig), signed'(dataa_sig),
                signed'(datab_sig), signed'(datab_sig),
                signed'(result_sig), signed'(result_sig),
                signed'(golden_result), signed'(golden_result));
        endcase
    end

    // Summary
    if (correct_results == NUM_TESTS)
        $display("Test PASSED! %0d of %0d tests matched expected results.", correct_results, NUM_TESTS);
    else
        $display("Test FAILED! %0d tests mismatched expected results.", NUM_TESTS - correct_results);

    $stop;
end

endmodule