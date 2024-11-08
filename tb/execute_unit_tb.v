initial begin
    // Initialize inputs
    pc1 = 32'h00000000; pc2 = 32'h00000004;
    opA1 = 32'h00000010; opA2 = 32'h00000020;
    opB1 = 32'h00000005; opB2 = 32'h00000003;
    aluControl1 = 4'b0000; aluControl2 = 4'b0010; // Add and Sub
    isBranch1 = 0; isBranch2 = 0;
    isRet1 = 0; isRet2 = 0;
    branchTarget1 = 32'h00000008; branchTarget2 = 32'h0000000C;
    isBeq1 = 0; isBeq2 = 0;
    isBgt1 = 0; isBgt2 = 0;

    @(posedge clk); // Wait for first clock edge
    // Test addition in ALU1
    aluControl1 = 4'b0000; // Addition
    @(posedge clk);
    $display("ALU1 Add: Result = %h", aluResult1);

    // Test subtraction in ALU2
    aluControl2 = 4'b0010; // Subtraction
    @(posedge clk);
    $display("ALU2 Sub: Result = %h", aluResult2);

    // Test branch taken
    isBranch1 = 1; isBeq1 = 1; opA1 = 32'h00000000; opB1 = 32'h00000000; // BEQ condition
    @(posedge clk);
    $display("ALU1 Branch Taken: %b, Branch PC: %h", isBranchTaken1, branchPC1);

    // Test return
    isBranch1 = 0; isRet1 = 1; aluResult1 = 32'hDEADBEEF; // Simulate return address
    @(posedge clk);
    $display("ALU1 Return: Taken = %b, PC = %h", isBranchTaken1, branchPC1);

    // End simulation
    $finish;
end
