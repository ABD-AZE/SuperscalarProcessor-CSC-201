`timescale 1ns / 1ps

module memory_unit_tb;

    // Inputs
    reg clk;
    reg reset;
    reg isld;
    reg isst;
    reg iswb;
    reg [15:0] instr;
    reg [15:0] op2;
    reg [15:0] aluresult;

    // Outputs
    wire [15:0] aluresult_out;
    wire isld_out;
    wire iswb_out;
    wire [15:0] instr_out;
    wire [15:0] ldresult;
    wire [19:0] rdvalmem;

    // Instantiate the memory_unit
    memory_unit uut (
        .clk(clk),
        .isld(isld),
        .isst(isst),
        .reset(reset),
        .iswb(iswb),
        .instr(instr),
        .op2(op2),
        .aluresult(aluresult),
        .aluresult_out(aluresult_out),
        .isld_out(isld_out),
        .iswb_out(iswb_out),
        .instr_out(instr_out),
        .ldresult(ldresult),
        .rdvalmem(rdvalmem)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Testbench
    initial begin
        // Initialize inputs
        $dumpfile("memory_unit.vcd");
        $dumpvars(0, memory_unit_tb);
        reset = 1;
        isld = 0;
        isst = 0;
        iswb = 0;
        instr = 0;
        op2 = 0;
        aluresult = 0;

        // Apply reset
        #10;
        reset = 0;
        #5;

        // Test 1: Load from memory
        isld = 1;
        aluresult = 16'd4; // Load from memory address 4
        instr = 16'b0000000000100000; // Example instruction
        #10;
        isld = 0;
        $display("Load Test: ldresult = %h, rdvalmem = %h (Expected: Data from address 4)", ldresult, rdvalmem);

        // Test 2: Store to memory
        isst = 1;
        aluresult = 16'd4; // Store to memory address 4
        op2 = 16'hA505;    // Data to store
        #10;
        isst = 0;
        $display("Store Test: Stored data at address 4 (Check file for changes)");

        // Test 3: Load after store
        isld = 1;
        aluresult = 16'd7; // Load from memory address 4
        #10;
        isld = 0;
        $display("Load After Store Test: ldresult = %h (Expected: A5A5)", ldresult);

        // Test 4: No operation
        isld = 0;
        isst = 0;
        aluresult = 16'd0; // No memory operation
        #10;
        $display("No Operation Test: ldresult = %h, rdvalmem = %h (Expected: 0000, unchanged result)", ldresult, rdvalmem);

        // End simulation
        #20;
        $finish;
    end

endmodule
