module decode_unit (
    input wire clk,
    input wire reset,
    input wire stall,                               // Stall signal
    input wire is_branch_taken,                     // Branch taken signal
    input wire [15:0] instr,                        // 16-bit instruction
    output reg [4:0] imm,                           // 5-bit immediate value
    output reg [3:0] opcode,                        // 4-bit Opcode
    output reg [15:0] branch_target,            // Calculated branch target
    output reg [15:0] op1, op2                      // Operand values
    output wire imm_flag,                           // Immediate flag
);

    // Internal registers
    reg [15:0] reg_rs1, reg_rs2;                    // Registers to store rs1 and rs2 values
    reg [2:0] rd, rs1, rs2;                         // Register fields
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all outputs
            opcode <= 4'b0000;                      // NOP instruction
            rd <= 3'b000;
            rs1 <= 3'b000;
            rs2 <= 3'b000;
            imm <= 5'b00000;
            branch_target <= 16'b0;
            op1 <= 16'b0;
            op2 <= 16'b0;
            reg_rs1 <= 16'b0;
            reg_rs2 <= 16'b0;
        end else if (is_branch_taken) begin
            // Handle flush (invalidate current instruction)
            opcode <= 4'b0000;                      // NOP
            rd <= 3'b000;
            rs1 <= 3'b000;
            rs2 <= 3'b000;
            imm <= 5'b00000;
            op1 <= 16'b0; 
            op2 <= 16'b0;
            reg_rs1 <= 16'b0;
            reg_rs2 <= 16'b0;
        end else if (!stall) begin
            // Decode the instruction when not stalled
            opcode <= instr[15:12];                 // Extract 4-bit opcode
            imm_flag <= instr[11];                  // Extract immediate flag (bit 11)
            rd <= instr[10:8];                      // Extract rd (3-bit)
            rs1 <= instr[7:5];                      // Extract rs1 (3-bit)

            if (imm_flag) begin
                // If the instruction uses immediate
                imm <= instr[4:0];                  // Extract 5-bit immediate
                reg_rs1 <= instr[7:5];              // Load rs1 value into reg_rs1
                reg_rs2 <= 16'b0;                   // No rs2 for immediate type
                op2 <= {11'b0, imm};                // op2 will hold the immediate value
            end else begin
                // If the instruction uses rs2
                rs2 <= instr[4:0];                  // Extract 5-bit rs2 field
                reg_rs1 <= instr[7:5];              // Load rs1 value into reg_rs1
                reg_rs2 <= instr[4:2];              // Load rs2 value into reg_rs2
                op2 <= reg_rs2_val;                     // op2 will hold the value of rs2
            end

            // Assign operand 1 (op1 is the value of rs1)
            // Branch target calculation
            if (opcode == 4'b1100) begin            // Assuming opcode '1100' is branch
                branch_target <= {{11{instr[4]}}, instr[4:0]} << 2;  // Extend and shift
            end
        end
    end
    always @(*) begin
        // Assign operand 1 (op1 is the value of rs1)
        op1 <= reg_rs1_val; 
        // Assign operand 2 (op2 is the value of rs2 or immediate)
        op2 <= reg_rs2_val;
    end
endmodule