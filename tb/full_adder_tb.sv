/***************************************************/
/* Full Adder Testbench                            */
/* Tests 1-bit full adder module logic             */
/***************************************************/

`timescale 1ns/1ps

module full_adder_tb ();

// Internal signals to drive inputs and capture outputs
logic a_sig, b_sig, cin_sig;
logic s_sig, cout_sig;

// Instantiate the full adder as the device under test (DUT)
full_adder dut (
    .a    (a_sig),
    .b    (b_sig),
    .cin  (cin_sig),
    .s    (s_sig),
    .cout (cout_sig)
);

// Test: covers all 8 input combinations for 1-bit full adder
initial begin
    $timeformat(-9, 2, " ns"); // Display time in nanoseconds with 2 decimal places

    // Test case 1: 0 + 0 + 0 = 0 (carry 0)
    a_sig = 0; b_sig = 0; cin_sig = 0; #2;
    $display("[%0t] Got: Sum=%b, Cout=%b -- Expecting: Sum=0, Cout=0", $time, s_sig, cout_sig);

    // Test case 2: 0 + 0 + 1 = 1 (carry 0)
    a_sig = 0; b_sig = 0; cin_sig = 1; #2;
    $display("[%0t] Got: Sum=%b, Cout=%b -- Expecting: Sum=1, Cout=0", $time, s_sig, cout_sig);

    // Test case 3: 0 + 1 + 0 = 1 (carry 0)
    a_sig = 0; b_sig = 1; cin_sig = 0; #2;
    $display("[%0t] Got: Sum=%b, Cout=%b -- Expecting: Sum=1, Cout=0", $time, s_sig, cout_sig);

    // Test case 4: 0 + 1 + 1 = 0 (carry 1)
    a_sig = 0; b_sig = 1; cin_sig = 1; #2;
    $display("[%0t] Got: Sum=%b, Cout=%b -- Expecting: Sum=0, Cout=1", $time, s_sig, cout_sig);

    // Test case 5: 1 + 0 + 0 = 1 (carry 0)
    a_sig = 1; b_sig = 0; cin_sig = 0; #2;
    $display("[%0t] Got: Sum=%b, Cout=%b -- Expecting: Sum=1, Cout=0", $time, s_sig, cout_sig);

    // Test case 6: 1 + 0 + 1 = 0 (carry 1)
    a_sig = 1; b_sig = 0; cin_sig = 1; #2;
    $display("[%0t] Got: Sum=%b, Cout=%b -- Expecting: Sum=0, Cout=1", $time, s_sig, cout_sig);

    // Test case 7: 1 + 1 + 0 = 0 (carry 1)
    a_sig = 1; b_sig = 1; cin_sig = 0; #2;
    $display("[%0t] Got: Sum=%b, Cout=%b -- Expecting: Sum=0, Cout=1", $time, s_sig, cout_sig);

    // Test case 8: 1 + 1 + 1 = 1 (carry 1)
    a_sig = 1; b_sig = 1; cin_sig = 1; #2;
    $display("[%0t] Got: Sum=%b, Cout=%b -- Expecting: Sum=1, Cout=1", $time, s_sig, cout_sig);

    $display("Test Complete!");
    $stop;
end

endmodule
