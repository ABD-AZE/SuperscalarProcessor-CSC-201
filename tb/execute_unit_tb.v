module execute_unit_tb;

    // Declare inputs and outputs
    reg [15:0] brachtarget;
    reg isunconditionalbranch;
    reg isBeq;
    reg isBgt;
    reg [127:0] regval;
    wire [15:0] branchpc;
    wire isbranchtaken;

    // Instantiate the execute_unit module
    execute_unit uut (
        .brachtarget(brachtarget),
        .isunconditionalbranch(isunconditionalbranch),
        .isBeq(isBeq),
        .isBgt(isBgt),
        .regval(regval),
        .branchpc(branchpc),
        .isbranchtaken(isbranchtaken)
    );

    // Test stimulus
    initial begin
        // Initialize inputs
        $dumpfile("execute_unit.vcd");
        $dumpvars(0, execute_unit_tb);
        brachtarget = 16'h1000;       // Example target address for branch
        isunconditionalbranch = 0;    // Test unconditional branch condition
        isBeq = 0;                    // Test equality condition
        isBgt = 0;                    // Test greater-than condition
        regval = 128'h00010000000000000000000000000000; // Initial value of registers (all zeros except reg_file[7] = 1)

        // Display results
        $display("Time\t\tbrachtarget\tisunconditionalbranch\tisBeq\tisBgt\tbranchpc\tisbranchtaken");

        // Apply some test vectors
        #5; // Wait for 5 time units
        
        // Test Case 1: Test unconditional branch
        isunconditionalbranch = 1; // Unconditional branch should take place
        #5;
        $display("%g\t\t%h\t\t%0d\t\t%0d\t%0d\t%h\t\t%0d", $time, brachtarget, isunconditionalbranch, isBeq, isBgt, branchpc, isbranchtaken);
        
        // Test Case 2: Test equality condition (isBeq = 1 and reg_file[7] = 1)
        isunconditionalbranch = 0;
        isBeq = 1; // Test BEQ
        regval = 128'h00010000000000000000000000000000; // reg_file[7] = 2, should meet the condition for BGT
        #5;
        $display("%g\t\t%h\t\t%0d\t\t%0d\t%0d\t%h\t\t%0d", $time, brachtarget, isunconditionalbranch, isBeq, isBgt, branchpc, isbranchtaken);

        // Test Case 3: Test greater-than condition (isBgt = 1 and reg_file[7] = 2)
        isBeq = 0;
        isBgt = 1; // Test BGT
        regval = 128'h00020000000000000000000000000000; // reg_file[7] = 2, should meet the condition for BGT
        #5;
        $display("%g\t\t%h\t\t%0d\t\t%0d\t%0d\t%h\t\t%0d", $time, brachtarget, isunconditionalbranch, isBeq, isBgt, branchpc, isbranchtaken);

        // Test Case 4: Test when no condition matches (branch not taken)
        isunconditionalbranch = 0;
        isBeq = 0;
        isBgt = 0; // No branch condition
        regval = 128'h0000000000000000; // reg_file[7] is 0, so branch should not be taken
        #5;
        $display("%g\t\t%h\t\t%0d\t\t%0d\t%0d\t%h\t\t%0d", $time, brachtarget, isunconditionalbranch, isBeq, isBgt, branchpc, isbranchtaken);

        // Test Case 5: Test different value of reg_file[7]
        regval = 128'h0000000000000005; // reg_file[7] = 5, should not match any conditions for branch
        #5;
        $display("%g\t\t%h\t\t%0d\t\t%0d\t%0d\t%h\t\t%0d", $time, brachtarget, isunconditionalbranch, isBeq, isBgt, branchpc, isbranchtaken);

        // End simulation
        $finish;
    end

endmodule
