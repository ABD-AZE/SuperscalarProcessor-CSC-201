module fetch_unit (
    input wire clk,
    input wire reset,
    input wire stall,
    input wire is_branch_taken,               // Signal that branch is taken
    input wire [15:0] branch_target,          // Branch target address
    output reg[15:0] instr1,                 // First instruction for decode
    output reg [15:0] instr2                  // Second instruction for decode
);
    reg [15:0] pc;                            // Program Counter
    reg [15:0] instruction_memory [0:10];     // Instruction memory (single-port)
    reg [15:0] buffer [1:0];                 // 2-entry instruction buffer to hold current instructions
    reg [15:0] instr1_reg;
    reg [15:0] instr2_reg;
    // Initialize instruction memory (for simulation)
    initial begin
        $readmemh("instructions.hex", instruction_memory);
        buffer[0] <= 16'h0;
        buffer[1] <= 16'h0;
        instr1_reg <=  16'h0;
        instr2_reg <=  16'h0;

    end
    // PC update logic with branch handling and buffer control
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, clear PC and buffer
            pc <= 0;
            buffer[0] <= 16'h0;
            buffer[1] <= 16'h0;
        end 
        else if (is_branch_taken) begin
            // If branch is taken, set PC to branch target and flush buffer
            pc <= branch_target;
            buffer[0] <= 16'h0; // NOP for buffer
            buffer[1] <= 16'h0; // NOP for buffer
        end
        else if (stall) begin 
            // I`f stalled, hold current buffer values (instructions)
            buffer[0] <= buffer[0];
            buffer[1] <= buffer[1];
        end 
        else begin
            // Fetch two instructions into buffer on each cycle
            buffer[0] <= instruction_memory[pc];       // Fetch instruction at PC
            buffer[1] <= instruction_memory[pc + 1];   // Fetch next instruction
            pc <= pc + 2;                              // Increment PC by 2 for 2 instructions
        end
        // Update instr1 and instr2 with buffer values from previous cycle (next-cycle update)
        if(!stall) begin
            instr1_reg <= buffer[0];
            instr2_reg <= buffer[1];
        end else begin
            instr1_reg <= 16'h0;
            instr2_reg <= 16'h0;
        end
    end
    assign instr1 = instr1_reg;
    assign instr2 =  instr2_reg;

endmodule
