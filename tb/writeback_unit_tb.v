module writeback_unit_tb;

    // Declare inputs for the writeback_unit module
    reg clk;
    reg iswb;
    reg isld;
    reg [2:0] rd;
    reg [15:0] ldresult;
    reg [15:0] aluresult;

    // Declare outputs for the writeback_unit module
    wire [15:0] reg_file [0:7];  // The register file
    wire [15:0] result;          // Result being written back

    // Instantiate the writeback_unit module
    writeback_unit uut (
        .clk(clk),
        .iswb(iswb),
        .isld(isld),
        .rd(rd),
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
        rd = 3'b000;
        ldresult = 16'h0000;
        aluresult = 16'h0000;

        // Initialize the file for checking the register writeback results
        $dumpfile("writeback_unit_tb.vcd");
        $dumpvars(0, writeback_unit_tb);

        // Test 1: Write to register with ALU result
        #10;
        iswb = 1;
        isld = 0;
        rd = 3'b001;  // Write to register 1
        aluresult = 16'hABCD; // ALU result to be written
        #10; // Wait for one clock cycle

        // Test 2: Write to register with Load result
        #10;
        iswb = 1;
        isld = 1;
        rd = 3'b010;  // Write to register 2
        ldresult = 16'h1234;  // Load result to be written
        #10;

        // Test 3: Ensure that no write occurs without `iswb` being set
        #10;
        iswb = 0; // No writeback
        rd = 3'b011;  // Register 3
        aluresult = 16'h5678; // ALU result
        #10; // Wait for one clock cycle

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
