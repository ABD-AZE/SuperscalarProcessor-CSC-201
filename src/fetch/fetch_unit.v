module fetch_unit (
    input wire clk,
    input wire reset,
    input wire stall,                        
    input wire flush,                         
    input wire branch_taken,                  // Signal that branch is taken
    input wire [31:0] branch_target,          // Branch target address
    output reg [31:0] instr1,                 // First instruction for decode
    output reg [31:0] instr2                  // Second instruction for decode
);

    reg [31:0] pc;                            // Program Counter
    reg [31:0] instruction_memory [0:255];    // Instruction memory (single-port)
    reg [31:0] buffer [1:0];                  // 2-entry instruction buffer

    // Initialize instruction memory (for simulation)
    initial begin
        $readmemh("instructions.hex", instruction_memory);
    end

    // PC update logic with branch handling and buffer control
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0;
        end else if (branch_taken) begin
            pc <= branch_target;               // On branch, set PC to branch target
        end else if (!stall) begin
                buffer[0] <= instruction_memory[pc[31:2]]; // Fetch to buffer[0]
                pc <= pc + 4;
                buffer[1] <= instruction_memory[pc[31:2]]; // Fetch to buffer[1]
        end

    end

    // Output instructions from buffer to decode stage
    always @(*) begin
        instr1 = buffer[0];
        instr2 = buffer[1];
    end

endmodule
