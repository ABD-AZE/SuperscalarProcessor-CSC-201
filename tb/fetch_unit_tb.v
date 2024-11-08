module tb_fetch_unit;

    // Testbench signals
    reg clk;
    reg reset;
    reg stall;
    reg is_branch_taken;
    reg [31:0] branch_target;
    wire [31:0] instr1;
    wire [31:0] instr2;
    reg [31:0] pc;
    // Instantiate the fetch unit
    fetch_unit uut (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .is_branch_taken(is_branch_taken),
        .branch_target(branch_target),
        .instr1(instr1),
        .instr2(instr2)
    );

    // Initialize all signals
    initial begin
        $dumpfile("fetch_unit.vcd");
        $dumpvars(0,tb_fetch_unit);
        clk = 0;
        reset = 0;
        stall = 0;
        is_branch_taken = 0;
        branch_target = 0;

        // Apply reset
        #5 reset = 1;
        #10 reset = 0;
        // Run test scenarios
        test_no_branch;
        // #10 test_stall;
        #10 test_no_branch;
        #10 test_with_branch;
        #10 test_no_branch;
        #50 $finish;
    end

    // Clock generation
    always begin
        #5 clk = ~clk;  // Toggle clock every 5 time units
    end

    // Test Case 1: No Branch, Normal Fetch
    task test_no_branch;
        begin
            // Test fetching two instructions without a branch
            is_branch_taken = 0;
            branch_target = 32'h0;
            stall = 0;

            // Observe the outputs
            // #20; // Wait for a few clock cycles
            $display("instr1: %h, instr2: %h", instr1, instr2);
        end
    endtask

    // Test Case 2: Branch Taken, Reset PC
    task test_with_branch;
        begin
            // Test fetching with a branch taken
            is_branch_taken = 1;
            branch_target = 32'h5; // Set branch target to a new address
            stall = 0;

            // Observe the outputs after branch handling
            // #20; // Wait for a few clock cycles
            $display("After branch, instr1: %h, instr2: %h", instr1, instr2);
        end
    endtask

    // Test Case 3: Stall the Fetch
    task test_stall;
        begin
            // Test with the stall signal active
            stall = 1;
            is_branch_taken = 0;
            branch_target = 32'h0;
            reset = 0;

            // No new fetch should occur due to stall
            #10; // Wait for a few clock cycles
            $display("Stalled, instr1: %h, instr2: %h", instr1, instr2);
        end
    endtask

endmodule
