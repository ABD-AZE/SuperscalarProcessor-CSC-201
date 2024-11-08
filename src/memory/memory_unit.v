module memory_access (
    input wire [15:0] Address_Value_RegAddress_isLoad_isMemWrite_isWrite, // Combined input
    input wire clk,                                                       // Clock
    output reg [10:0] write                                               // Output wire
);

    // Signal Declarations
    wire [4:0] address;               // 5-bit memory address
    wire [15:0] value;                // 16-bit data value
    wire is_load;                     // Load signal
    wire is_mem_write;                // Memory write signal
    reg [2:0] reg_to_write;           // Register to be written (3 bits for 8 registers)
    wire is_write;                    // Write enable signal
    reg is_write_temp;                // Temporary write enable signal

    // Internal Data Signals
    wire [15:0] dm_output;            // Output data from data memory
    reg [15:0] temp_write_data;       // Temporary register for write-back data

    // Decompose input signals into individual components
    assign address      = Address_Value_RegAddress_isLoad_isMemWrite_isWrite[4:0];   // 5 bits for address (0-31)
    assign value        = Address_Value_RegAddress_isLoad_isMemWrite_isWrite[15:5];  // 16 bits for value
    assign is_load      = Address_Value_RegAddress_isLoad_isMemWrite_isWrite[16];    // 1 bit for load
    assign is_mem_write = Address_Value_RegAddress_isLoad_isMemWrite_isWrite[17];    // 1 bit for memory write
    assign is_write     = Address_Value_RegAddress_isLoad_isMemWrite_isWrite[18];    // 1 bit for write enable

    // Set up data memory
    data_memory DM (
        .memaddress(address),
        .inputdata(value),
        .ismemwrite(is_mem_write),
        .outputdata(dm_output)
    );

    // Register Write Control Logic
    always @(posedge clk) begin
        is_write_temp <= is_write;
        reg_to_write <= Address_Value_RegAddress_isLoad_isMemWrite_isWrite[21:19]; // 3 bits for register address

        // Load data from memory or directly use the provided value
        if (is_load) begin
            temp_write_data <= dm_output; // Load from memory
        end else begin
            temp_write_data <= value;     // Directly use the value from the input
        end
    end

    // Output Assignments
    assign write[15:0] = temp_write_data;       // Write-back data
    assign write[18:16] = reg_to_write;         // Register to write to
    assign write[10] = is_write_temp;           // Write enable flag

endmodule
