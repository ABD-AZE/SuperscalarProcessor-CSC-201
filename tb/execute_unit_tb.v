`timescale 1ns / 1ps

module tb_ExecuteUnit;

    // Testbench signals
    reg clk;
    reg [31:0] pc1, pc2;
    reg [31:0] opA1, opA2;
    reg [31:0] opB1, opB2;
    reg [3:0] aluControl1, aluControl2;
    reg isBranch1, isBranch2;
    reg isRet1, isRet2;
    reg [31:0] branchTarget1, branchTarget2;
    reg isBeq1, isBeq2;
    reg isBgt1, isBgt2;
    wire [31:0] aluResult1, aluResult2;
    wire isBranchTaken1, isBranchTaken2;
    wire [31:0] branchPC1, branchPC2;

    // Instantiate the ExecuteUnit
    ExecuteUnit uut (
        .clk(clk),
        .pc1(pc1), .pc2(pc2),
        .opA1(opA1), .opA2(opA2),
        .opB1(opB1), .opB2(opB2),
        .aluControl1(aluControl1), .aluControl2(aluControl2),
        .isBranch1(isBranch1), .isBranch2(isBranch2),
        .isRet1(isRet1), .isRet2(isRet2),
        .branchTarget1(branchTarget1), .branchTarget2(branchTarget2),
        .isBeq1(isBeq1), .isBeq2(isBeq2),
        .isBgt1(isBgt1), .isBgt2(isBgt2),
        .aluResult1(aluResult1), .aluResult2(aluResult2),
        .isBranchTaken1(isBranchTaken1), .isBranchTaken2(isBranchTaken2),
        .branchPC1(branchPC1), .branchPC2(branchPC2)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test vectors
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

        // Test branch taken (BEQ condition)
        isBranch1 = 1; isBeq1 = 1; opA1 = 32'h00000000; opB1 = 32'h00000000; // BEQ
        @(posedge clk);
        $display("ALU1 Branch (BEQ): Taken = %b, Branch PC = %h", isBranchTaken1, branchPC1);

        // Test branch not taken (BEQ fails)
        isBeq1 = 1; opA1 = 32'h00000001; opB1 = 32'h00000002; // BEQ fails
        @(posedge clk);
        $display("ALU1 Branch (BEQ Fail): Taken = %b, Branch PC = %h", isBranchTaken1, branchPC1);

        // Test return condition
        isBranch1 = 0; isRet1 = 1; opA1 = 32'h00000000; opB1 = 32'h00000000; // Return address
        @(posedge clk);
        $display("ALU1 Return: Taken = %b, Branch PC = %h", isBranchTaken1, branchPC1);

        // End simulation
        $finish;
    end

endmodule
