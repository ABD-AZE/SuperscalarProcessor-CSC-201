module tb_fetch_unit;

    // Testbench signals
    reg clk;
    reg reset;
    reg stall;
    reg is_branch_taken;
    reg [15:0] branch_target;
    reg issingleinstr;
    wire [15:0] instr1;
    wire [15:0] instr2;

    // Instantiate the fetch unit
    fetch_unit uut (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .is_branch_taken(is_branch_taken),
        .branch_target(branch_target),
        .issingleinstr(issingleinstr),
        .instr1(instr1),
        .instr2(instr2)
    );

    // Initialize all signals
    initial begin
        $dumpfile("fetch_unit.vcd");
        $dumpvars(0, tb_fetch_unit);
        clk = 0;
        reset = 0;
        stall = 0;
        is_branch_taken = 0;
        branch_target = 0;
        issingleinstr = 0;

        // Apply reset
        #5 reset = 1;
        #10 reset = 0;

        // Run test scenarios
        test_no_branch;
        #10 test_stall;
        #10 test_no_branch;
        #10 test_with_branch;
        #10 test_single_instruction;
        
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
            branch_target = 16'h0;
            stall = 0;
            issingleinstr = 0;
            #20; // Wait for a few clock cycles
            $display("Time: %0t | Normal fetch - instr1: %h, instr2: %h", $time, instr1, instr2);
        end
    endtask

    // Test Case 2: Branch Taken, Reset PC
    task test_with_branch;
        begin
            // Test fetching with a branch taken
            is_branch_taken = 1;
            branch_target = 16'h1; // Set branch target to a new address
            stall = 0;
            issingleinstr = 0;
            #10; // Wait for a cycle to let branch take effect
            is_branch_taken = 0; // Deassert branch after one cycle
            #20; // Wait for a few clock cycles
            $display("Time: %0t | After branch - instr1: %h, instr2: %h", $time, instr1, instr2);
        end
    endtask

    // Test Case 3: Stall the Fetch
    task test_stall;
        begin
            // Test with the stall signal active
            stall = 1;
            is_branch_taken = 0;
            branch_target = 16'h0;
            issingleinstr = 0;
            #10; // Wait for a few clock cycles
            $display("Time: %0t | Stalled fetch - instr1: %h, instr2: %h", $time, instr1, instr2);
            stall = 0; // Deassert stall to resume normal fetching
        end
    endtask

    // Test Case 4: Single Instruction Mode
    task test_single_instruction;
        begin
            // Test fetching only one instruction per cycle
            issingleinstr = 1;
            is_branch_taken = 0;
            branch_target = 16'h0;
            stall = 0;
            #10; // Wait for a few clock cycles
            $display("Time: %0t | Single instruction fetch - instr1: %h, instr2: %h", $time, instr1, instr2);
            issingleinstr = 0; // Reset to normal fetch mode
        end
    endtask

endmodule
