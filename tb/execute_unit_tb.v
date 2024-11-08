module tb_execute_unit;

    // Testbench signals
    reg [15:0] brachtarget;
    reg isunconditionalbranch;
    reg isBeq;
    reg isBgt;
    wire [15:0] branchpc;
    wire isbranchtaken;

    // Instantiate the execute unit
    execute_unit uut (
        .brachtarget(brachtarget),
        .isunconditionalbranch(isunconditionalbranch),
        .isBeq(isBeq),
        .isBgt(isBgt),
        .branchpc(branchpc),
        .isbranchtaken(isbranchtaken)
    );

    // Initialize signals and load register values
    initial begin
        // Dump file for waveform analysis
        $dumpfile("execute_unit.vcd");
        $dumpvars(0, tb_execute_unit);

        // Set initial values
        brachtarget = 16'h1234;
        isunconditionalbranch = 0;
        isBeq = 0;
        isBgt = 0;

        // Wait for memory to initialize
        #10;

        // Test Case 1: Unconditional Branch
        isunconditionalbranch = 1;
        isBeq = 0;
        isBgt = 0;
        #10;
        $display("TC1 - Unconditional Branch | branchpc=%h, isbranchtaken=%b", branchpc, isbranchtaken);

        // Test Case 2: Conditional Branch - BEQ, flag = 1
        isunconditionalbranch = 0;
        isBeq = 1;
        isBgt = 0;
        #10;
        $display("TC2 - Conditional BEQ (flag=1) | branchpc=%h, isbranchtaken=%b", branchpc, isbranchtaken);

        // Test Case 3: Conditional Branch - BGT, flag = 2
        isunconditionalbranch = 0;
        isBeq = 0;
        isBgt = 1;
        #10;
        $display("TC3 - Conditional BGT (flag=2) | branchpc=%h, isbranchtaken=%b", branchpc, isbranchtaken);

        // Test Case 4: No Branch Taken
        isunconditionalbranch = 0;
        isBeq = 0;
        isBgt = 0;
        #10;
        $display("TC4 - No Branch | branchpc=%h, isbranchtaken=%b", branchpc, isbranchtaken);

        // Finish simulation
        #10;
        $finish;
    end
endmodule
