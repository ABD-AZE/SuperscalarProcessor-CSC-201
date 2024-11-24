`timescale 1ns / 1ps

module writeback_unit_tb;

    // Declare inputs for the writeback_unit module
    reg clk;
    reg iswb;
    reg isld;
    reg [15:0] instr;
    reg [15:0] ldresult;
    reg [15:0] aluresult;

    // Instantiate the writeback_unit module
    writeback_unit uut (
        .clk(clk),
        .iswb(iswb),
        .isld(isld),
        .instr(instr),
        .ldresult(ldresult),
        .aluresult(aluresult)
    );

    // Clock generation (period = 10 time units)
    always begin
        #5 clk = ~clk; // Toggle clock every 5 time units (100 MHz clock)
    end

    // Test stimulus
    initial begin
        // Initialize signals
        clk = 0;
        iswb = 0;
        isld = 0;
        instr = 16'h0000;
        ldresult = 16'h0000;
        aluresult = 16'h0000;

        // Initialize the file for checking the register writeback results
        $dumpfile("writeback_unit.vcd");
        $dumpvars(0, writeback_unit_tb);

        // Test 1: Write ALU result to register
        #10;
        iswb = 1;
        isld = 0;
        instr = 16'b0000000100000000; // Write to register 1 (bits [7:5] = 3'b001)
        aluresult = 16'hABCD; // ALU result to be written
        #10; // Wait for one clock cycle

        // Test 2: Write Load result to register
        iswb = 1;
        isld = 1;
        instr = 16'b0000001000000000; // Write to register 2 (bits [7:5] = 3'b010)
        ldresult = 16'h1234; // Load result to be written
        #10;

        // Test 3: Ensure no write occurs without iswb
        iswb = 0; // No writeback
        isld = 0;
        instr = 16'b000000110000000; // Register 3 (bits [7:5] = 3'b011)
        aluresult = 16'h5678; // ALU result
        #10; // Wait for one clock cycle

        // Test 4: Write ALU result to a different register
        iswb = 1;
        isld = 0;
        instr = 16'b0000011000000000; // Write to register 4 (bits [10:8] = 3'b110=6)
        aluresult = 16'hFEDC; // ALU result to be written
        #10;

        // Finish simulation
        #10;
        $finish;
    end

    // Monitor the changes in register file
    initial begin
        $monitor("At time %0t, reg_file[0] = %h, reg_file[1] = %h, reg_file[2] = %h, reg_file[3] = %h, reg_file[4] = %h, reg_file[5] = %h, reg_file[6] = %h, reg_file[7] = %h",
                 $time, uut.reg_file[0], uut.reg_file[1], uut.reg_file[2], uut.reg_file[3], uut.reg_file[4], uut.reg_file[5], uut.reg_file[6], uut.reg_file[7]);
    end

endmodule
