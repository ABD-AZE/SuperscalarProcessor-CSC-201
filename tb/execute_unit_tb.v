module execute_unit_tb;

    // Declare inputs and outputs
    reg [15:0] brachtarget;
    reg isunconditionalbranch;
    reg isBeq;
    reg isBgt;
    reg reset;
    reg clk;
    reg [127:0] regval;
    wire [15:0] branchpc;
    wire isbranchtaken;

    // Instantiate the execute_unit module
    execute_unit uut (
        .brachtarget(brachtarget),
        .isunconditionalbranch(isunconditionalbranch),
        .isBeq(isBeq),
        .isBgt(isBgt),
        .reset(reset),
        .clk(clk),
        .regval(regval),
        .branchpc(branchpc),
        .isbranchtaken(isbranchtaken)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        $dumpfile("execute_unit.vcd");
        $dumpvars(0, execute_unit_tb);
        
        brachtarget = 16'h0000;       // Example target address for branch
        isunconditionalbranch = 0;    // Test unconditional branch condition
        isBeq = 0;                    // Test equality condition
        isBgt = 0;                    // Test greater-than condition
        reset = 1;                    // Initial state to reset
        regval = 128'h00000000000000000000000000000000; // Initial value of registers (all zeros except reg_file[7] = 1)

        // Display header
        $display("Time\t\tbrachtarget\tisunconditionalbranch\tisBeq\tisBgt\tbranchpc\tisbranchtaken");

        // Apply reset
        #10;
        reset = 0; // Release reset

        // Test Case 1: Test unconditional branch
        #5;
        brachtarget = 16'h1001;       // Example target address for branch
        isunconditionalbranch = 1;
        $display("%g\t\t%h\t\t%0d\t\t%0d\t%0d\t%h\t\t%0d", $time, brachtarget, isunconditionalbranch, isBeq, isBgt, branchpc, isbranchtaken);

        // Test Case 2: Test equality condition (isBeq = 1 and reg_file[7] = 1)
        #10;
        brachtarget = 16'h1101;       // Example target address for branch
        isunconditionalbranch = 0;
        isBeq = 1;
        regval = 128'h00010000000000000000000000000010; // reg_file[7] = 1, should meet BEQ condition
        $display("%g\t\t%h\t\t%0d\t\t%0d\t%0d\t%h\t\t%0d", $time, brachtarget, isunconditionalbranch, isBeq, isBgt, branchpc, isbranchtaken);

        // Test Case 3: Test greater-than condition (isBgt = 1 and reg_file[7] = 2)
        #10;
        brachtarget = 16'h1011;       // Example target address for branch
        isBeq = 0;
        isBgt = 1;
        regval = 128'h00020000000000000000000000000000; // reg_file[7] = 2, should meet BGT condition
        $display("%g\t\t%h\t\t%0d\t\t%0d\t%0d\t%h\t\t%0d", $time, brachtarget, isunconditionalbranch, isBeq, isBgt, branchpc, isbranchtaken);

        // Test Case 4: Test when no condition matches (branch not taken)
        #10;
        brachtarget = 16'h100A;       // Example target address for branch
        isunconditionalbranch = 0;
        isBeq = 0;
        isBgt = 0;
        regval = 128'h00000000000000000000000000000000; // reg_file[7] is 0, so branch should not be taken
        $display("%g\t\t%h\t\t%0d\t\t%0d\t%0d\t%h\t\t%0d", $time, brachtarget, isunconditionalbranch, isBeq, isBgt, branchpc, isbranchtaken);

        // Test Case 5: Test different value of reg_file[7]
        #10;
        brachtarget = 16'h1001;       // Example target address for branch
        regval = 128'h00000000000000050000000000000000; // reg_file[7] = 5, should not match any branch condition
        $display("%g\t\t%h\t\t%0d\t\t%0d\t%0d\t%h\t\t%0d", $time, brachtarget, isunconditionalbranch, isBeq, isBgt, branchpc, isbranchtaken);

        // End simulation
        #20;
        $finish;
    end

endmodule
