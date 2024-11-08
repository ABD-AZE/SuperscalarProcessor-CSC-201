module memory_access (
    input wire [35:0] Address_Value_RegAddress_isLoad_isMemWrite_isWrite, // Combined input
    input wire clk,                                                       // Clock
    output reg [10:0] write                                               // Output wire
);

    // Signal Declarations
    wire [4:0] address;               // 5-bit memory address (0-31)
    wire [15:0] value;                // 16-bit data value
    wire is_load;                     // Load signal
    wire is_mem_write;                // Memory write signal
    reg [2:0] reg_to_write;           // Register to be written (3 bits for 8 registers)
    wire is_write;                    // Write enable signal
    reg is_write_temp;                // Temporary write enable signal

    // Data Memory Array
    reg [15:0] data_memory [0:31];    // 16-bit word memory with 32 entries
    reg [15:0] temp_write_data;       // Temporary register for write-back data
    integer fd;                       // File handler for memory file

    // Initialize memory from file
    initial begin
        $readmemb("./Data_Memory.txt", data_memory, 0, 31); // Initializes memory array from file
    end

    // Decompose input signals into individual components
    assign address      = Address_Value_RegAddress_isLoad_isMemWrite_isWrite[4:0];   // 5 bits for address (0-31)
    assign value        = Address_Value_RegAddress_isLoad_isMemWrite_isWrite[15:5];  // 16 bits for value
    assign is_load      = Address_Value_RegAddress_isLoad_isMemWrite_isWrite[16];    // 1 bit for load
    assign is_mem_write = Address_Value_RegAddress_isLoad_isMemWrite_isWrite[17];    // 1 bit for memory write
    assign is_write     = Address_Value_RegAddress_isLoad_isMemWrite_isWrite[18];    // 1 bit for write enable

    // Memory Write and Load Operations
    always @(posedge clk) begin
        is_write_temp <= is_write;
        reg_to_write <= Address_Value_RegAddress_isLoad_isMemWrite_isWrite[21:19]; // 3 bits for register address

        if (is_mem_write) begin
            // Write to memory
            data_memory[address] <= value;
            fd = $fopen("./Data_Memory.txt", "w"); 
            for (integer i = 0; i < 32; i = i + 1) begin 
                $fdisplay(fd, "%b", data_memory[i]); // Update memory file with new data
            end
            $fclose(fd);
        end else if (is_load) begin
            // Load from memory
            temp_write_data <= data_memory[address];
        end else begin
            // Directly use the provided value for non-memory operations
            temp_write_data <= value;
        end
    end

    // Output Assignments
    assign write[15:0] = temp_write_data;       // Write-back data
    assign write[18:16] = reg_to_write;         // Register to write to
    assign write[10] = is_write_temp;           // Write enable flag

endmodule
