module fetch_unit_tb;
    // Testbench signals
    reg clk;
    reg reset;
    reg stall;
    reg is_branch_taken;
    reg [15:0] branch_target;
    reg issingleinstr;
    wire [15:0] instr1;
    wire [15:0] instr2;

    // Instantiate the fetch_unit
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

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        $dumpfile("fetch_unit.vcd");
        $dumpvars(0, fetch_unit_tb);
        reset = 1;
        stall = 0;
        is_branch_taken = 0;
        branch_target = 16'h0000;
        issingleinstr = 0;

        // Apply reset
        #10;
        reset = 0;
        #5;

        // Let the program counter increment sequentially
        #30; // Allow instructions to appear sequentially

        // Test case 1: Branch taken
        $display("Test Case 1: Branch taken");
        is_branch_taken = 1;
        branch_target = 16'h0004; // Set branch target to instruction at address 4
        #10; // Allow one clock cycle
        is_branch_taken = 0;

        // Let the program counter increment after the branch
        #20;

        $display("Test Case 1: Branch taken");
        is_branch_taken = 1;
        branch_target = 16'h0000; // Set branch target to instruction at address 4
        #10; // Allow one clock cycle
        is_branch_taken = 0;

        #10;
        // Test case 2: Stall the fetch unit
        $display("Test Case 2: Stall condition");
        stall = 1;
        #30; // Stall for 3 clock cycles
        stall = 0;

        #10;

        // Test case 3: Branch and single-instruction fetch
        $display("Test Case 3: Branch and single-instruction fetch");
        is_branch_taken = 0;
        issingleinstr = 1; // Enable single-instruction fetch mode
        #10; // Allow one clock cycle
        is_branch_taken = 0;
        issingleinstr = 0;

        // Finish simulation
        $display("Simulation complete.");
        #20;
        $stop;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | PC: %h | Instr1: %h | Instr2: %h | Stall: %b | Branch: %b | Target: %h | SingleInstr: %b",
                 $time, uut.pc, instr1, instr2, stall, is_branch_taken, branch_target, issingleinstr);
    end
endmodule
