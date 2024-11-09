
module memory_unit_tb;
    // Testbench signals
    reg clk;
    reg isld;
    reg isst;
    reg [15:0] op2;
    reg [15:0] aluresult;
    wire [15:0] ldresult;

    // Instantiate the memory_unit module
    memory_unit dut (
        .clk(clk),
        .isld(isld),
        .isst(isst),
        .op2(op2),
        .aluresult(aluresult),
        .ldresult(ldresult)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 5 ns for a 10 ns period
    end


    // Test sequence
    initial begin
        // Initialize control signals
        $dumpfile("memory_unit.vcd");
        $dumpvars(0, memory_unit_tb);
        isld = 0;
        isst = 0;
        op2 = 16'h0000;
        aluresult = 16'h0000;

        #5

        // Display initial message
        $display("Starting memory_unit testbench...");

        // Wait for the initial clock cycle
        #10;
        // Test store operation
        $display("Testing store operation...");
        isst = 1;
        aluresult = 16'h0001; // Address to store at
        op2 = 16'hA5A5;       // Data to store
        isld = 0; // End of store operation

        // Wait for a clock cycle, then test load operation
        #10;
        $display("Testing load operation...");
        isld = 1;
        aluresult = 16'h0002; // Address to load from
        op2 = 16'h1000;
        isst = 0; // End of load operation

        // Test store operation at a different address
        $display("Testing store operation at a different address...");
        #10;
        isst = 1;
        aluresult = 16'h0003; // Address to store at
        op2 = 16'h100A;       // Data to store
        isld = 0; // End of store operation

        // Load from the new address
        #10;
        isld = 1;
        aluresult = 16'h0004; // Address to load from
        op2 = 16'h101A;       // Data to store
        isst = 0; // End of load operation

        // End of simulation
        #20;
        $finish;
    end
endmodule
