module memory_unit_tb;

    // Testbench signals
    reg [35:0] Address_Value_RegAddress_isLoad_isMemWrite_isWrite; // Combined input signal
    reg clk;                                                        // Clock signal
    wire [10:0] write;                                              // Output wire

    // Instantiate the memory_access module
    memory_unit uut (
        .Address_Value_RegAddress_isLoad_isMemWrite_isWrite(Address_Value_RegAddress_isLoad_isMemWrite_isWrite),
        .clk(clk),
        .write(write)
    );

    // Initialize signals
    initial begin
        $dumpfile("memory_access.vcd"); // Dump file for waveform
        $dumpvars(0, tb_memory_access);
        clk = 0;
        Address_Value_RegAddress_isLoad_isMemWrite_isWrite = 0;

        // Test Case 1: Write to memory at address 5 with value 16'hABCD
        #5 Address_Value_RegAddress_isLoad_isMemWrite_isWrite = {5'b00101, 16'hABCD, 3'b001, 1'b0, 1'b1, 1'b1}; // address=5, value=ABCD, reg=001, is_load=0, is_mem_write=1, is_write=1
        #10; // Wait to observe the memory write

        // Test Case 2: Load from memory at address 5
        #10 Address_Value_RegAddress_isLoad_isMemWrite_isWrite = {5'b00101, 16'h0000, 3'b001, 1'b1, 1'b0, 1'b1}; // address=5, is_load=1, is_mem_write=0, is_write=1
        #10; // Wait to observe the memory load

        // Test Case 3: Write to register directly without memory access
        #10 Address_Value_RegAddress_isLoad_isMemWrite_isWrite = {5'b00010, 16'h1234, 3'b010, 1'b0, 1'b0, 1'b1}; // address=2, value=1234, reg=010, is_load=0, is_mem_write=0, is_write=1
        #10; // Wait to observe direct register write

        // End simulation
        #50 $finish;
    end

    // Clock generation
    always begin
        #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Display output values during simulation
    always @(posedge clk) begin
        $display("Time: %0t | Write Enable: %b | Register to Write: %b | Data: %h", $time, write[10], write[9:7], write[6:0]);
    end

endmodule
