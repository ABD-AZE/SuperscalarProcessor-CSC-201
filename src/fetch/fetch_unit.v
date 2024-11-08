module fetch_unit (
    input wire clk,
    input wire reset,
    input wire stall,                                                 
    input wire is_branch_taken,                  // Signal that branch is taken
    input wire [15:0] branch_target,          // Branch target address
    output reg [15:0] instr1,                 // First instruction for decode
    output reg [15:0] instr2                  // Second instruction for decode
);

    reg [15:0] pc;                            // Program Counter
    reg [15:0] instruction_memory [0:10];    // Instruction memory (single-port)
    reg [15:0] buffer [1:0];                  // 2-entry instruction buffer

    // Initialize instruction memory (for simulation)
    initial begin
        $readmemh("instructions.hex", instruction_memory);
    end
    reg flush = 0;
    // PC update logic with branch handling and buffer control
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0;
            buffer[0] <= 0;
            buffer[1] <= 0;
        end else if (is_branch_taken) begin
            pc <= branch_target;               // On branch, set PC to branch target
            buffer[0] <= 0;                     // instead of 0 place the nop instruction
            buffer[1] <= 0;                     // instead of 0 place the nop instruction
            flush <= 1;
        end else if (flush) begin
            buffer[0] <= 0;                     // instead of 0 place the nop instruction
            buffer[1] <= 0;                     // instead of 0 place the nop instruction
            flush <= 0;
        end else if (stall) begin 
            buffer[0] <= 0; // Fetch to buffer[0]
            buffer[1] <= 0; // Fetch to buffer[1]
        end else if (!stall) begin
            buffer[0] <= instruction_memory[pc]; // Fetch to buffer[0]
            buffer[1] <= instruction_memory[pc+1]; // Fetch to buffer[1]
            pc <= pc + 2;
        end
    end
    // Output instructions from buffer to decode stage
    always @(*) begin
        if(stall) begin
            instr1 = 0;   // replace with nop
            instr2 = 0;  // replace with nop    
        end
        else begin
            instr1 = buffer[0];
            instr2 = buffer[1];
        end
    end

endmodule
