/***************************************************/
/* ALU Testbench                                   */
/* Validates shift, add, subtract, and reset ops   */
/***************************************************/

`timescale 1ns/1ps

module alu_tb ();

//---------------------------------------------------------------------
// Parameters
//---------------------------------------------------------------------
localparam CLK_PERIOD = 8;        // Clock period in ns (50% duty cycle)
localparam DATAW = 4;             // Width of ALU operands
localparam NUM_TESTS = 100;       // Number of randomized test cases

//---------------------------------------------------------------------
// DUT Interface Signals
//---------------------------------------------------------------------
logic clk_sig;
logic [DATAW-1:0] dataa_sig;
logic [DATAW-1:0] datab_sig;
logic [1:0]       op_sig;
logic [2*DATAW-1:0] result_sig;

//---------------------------------------------------------------------
// DUT Instantiation
//---------------------------------------------------------------------
alu #(
    .DATAW(DATAW)
) dut (
    .clk      (clk_sig),
    .i_dataa  (dataa_sig),
    .i_datab  (datab_sig),
    .i_op     (op_sig),
    .o_result (result_sig)
);

//---------------------------------------------------------------------
// Clock Generator
//---------------------------------------------------------------------
initial begin
    clk_sig = 1'b0;
    forever #(CLK_PERIOD / 2) clk_sig = ~clk_sig;
end

//---------------------------------------------------------------------
// Test Variables
//---------------------------------------------------------------------
integer test_id;
integer correct_results;
logic [2*DATAW-1:0] golden_result;

//---------------------------------------------------------------------
// Test Procedure
//---------------------------------------------------------------------
initial begin
    $timeformat(-9, 2, " ns");

    // Initialize inputs
    dataa_sig = 0;
    datab_sig = 0;
    op_sig    = 2'b00;
    correct_results = 0;
    #(5 * CLK_PERIOD);

    // Begin test loop
    for (test_id = 0; test_id < NUM_TESTS; test_id++) begin
        dataa_sig = $random;
        datab_sig = $random;
        op_sig    = $random % 4;

        // Compute expected output
        case (op_sig)
            2'b00: golden_result = 0;
            2'b01: golden_result = dataa_sig << datab_sig;
            2'b10: golden_result = signed'(dataa_sig) + signed'(datab_sig);
            2'b11: golden_result = signed'(dataa_sig) - signed'(datab_sig);
        endcase

        #(2 * CLK_PERIOD); // Wait for pipelined output to propagate

        // Compare DUT output with golden output
        if (result_sig == golden_result) begin
            $write("[%0t] Correct Result! ", $time);
            correct_results++;
        end else begin
            $write("[%0t] INCORRECT RESULT! ", $time);
        end

        // Display result details
        case (op_sig)
            2'b00: $display("A=%b(%d)  B=%b(%d)  OP=RST  Result=%b(%d)  Golden=%b(%d)",
                dataa_sig, dataa_sig, datab_sig, datab_sig,
                result_sig, result_sig, golden_result, golden_result);
            2'b01: $display("A=%b(%d)  B=%b(%d)  OP=SHL  Result=%b(%d)  Golden=%b(%d)",
                dataa_sig, dataa_sig, datab_sig, datab_sig,
                result_sig, result_sig, golden_result, golden_result);
            2'b10: $display("A=%b(%d)  B=%b(%d)  OP=ADD  Result=%b(%d)  Golden=%b(%d)",
                signed'(dataa_sig), signed'(dataa_sig),
                signed'(datab_sig), signed'(datab_sig),
                signed'(result_sig), signed'(result_sig),
                signed'(golden_result), signed'(golden_result));
            2'b11: $display("A=%b(%d)  B=%b(%d)  OP=SUB  Result=%b(%d)  Golden=%b(%d)",
                signed'(dataa_sig), signed'(dataa_sig),
                signed'(datab_sig), signed'(datab_sig),
                signed'(result_sig), signed'(result_sig),
                signed'(golden_result), signed'(golden_result));
        endcase
    end

    // Final summary
    if (correct_results == NUM_TESTS)
        $display("Test PASSED! %0d out of %0d tests matched expected results.", correct_results, NUM_TESTS);
    else
        $display("Test FAILED! %0d tests did not match expected results.", NUM_TESTS - correct_results);

    $stop;
end

endmodule