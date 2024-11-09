module decode_unit (
    input wire clk,
    input wire reset,
    input wire stall,                               // Stall signal
    input wire is_branch_taken,                     // Branch taken signal
    input wire [15:0] instr,                        // 16-bit instruction
    output reg [4:0] imm,                           // 5-bit immediate value
    output reg [3:0] opcode,                        // 4-bit Opcode
    output reg [15:0] branch_target,                // Calculated branch target
    output reg [15:0] op1, op2,                     // Operand values
    output reg imm_flag                             // Immediate flag
);
    reg [15:0] reg_file [0:7];                      // Register file memory (16 registers)
    // Load the hex file at the start
    initial begin
        $readmemh("reg_file.hex", reg_file);         // Load values from hex file
    end
    wire imm_flag_w;
    wire [4:0] imm_w;
    wire [3:0] opcode_w;
    wire [15:0] branch_target_w;
    wire [15:0] op1_w;
    wire [15:0] op2_w;
    wire [2:0] rs1_w;
    wire [2:0] rs2_w;
    wire [2:0] rd_w;
    assign rs1_w = instr[7:5];
    assign rs2_w = instr[4:2];
    assign rd_w  = instr[10:8];
    assign imm_w = instr[4:0];
    assign opcode_w = instr[15:12];
    assign branch_target_w = {{5'b0, instr[10:0]}};
    assign op1_w = reg_file[rs1_w];
    assign op2_w = reg_file[rs2_w];
    assign imm_flag_w = instr[11];
    // Internal registers
    reg [15:0] value_rs1;
    reg [15:0] value_rs2;                 // Registers to store rs1 and rs2 values
    // Decode logic triggered on the positive edge of the clock or reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all outputs
            opcode <= 4'h0;                         // NOP instruction
            imm <= 5'h0;
            op1 <= 16'h0;
            op2 <= 16'h0;
            branch_target <= 16'h0;
            imm_flag <= 0;
        end else if (is_branch_taken) begin
            // Handle flush (invalidate current instruction)
            opcode <= 4'h0;                         // NOP
            rd <= 3'h0;
            rs1 <= 3'h0;
            rs2 <= 3'h0;
            imm <= 5'h00;
            imm_flag <= 0;
            value_rs1 <= 16'h0;
            value_rs2 <= reg_file[rs2];
            branch_target <= 16'h0;
        end else if (!stall) begin
            // Decode the instruction when not stalled
            opcode <= instr[15:12];                 // Extract 4-bit opcode
            imm_flag <= instr[11];                  // Extract immediate flag (bit 11)
            rd <= instr[10:8];                      // Extract rd (3-bit)
            rs1 <= instr[7:5];                      // Extract rs1 (3-bit)
            imm <= instr[4:0];                  // Extract 5-bit immediate
            rs2 <= instr[4:2];
            
            if (instr[11]) begin
                // If the instruction uses immediate
                value_rs1 <= reg_file[rs1];         // Load rs1 value from register file
            end else begin
                // If the instruction uses rs2
                value_rs1 <= reg_file[rs1];         // Load rs1 value from register file
                value_rs2 <= reg_file[rs2];         // Load rs2 value from register file
            end
            branch_target <= {{5'b0, instr[10:0]}};  // Extend and shift
        end
        if (instr[11] && !is_branch_taken) begin
            op1 <= value_rs1;             // Operand 1 from rs1
            op2 <= {10'b0, imm};          // Operand 2 from immediate value
        end else begin
            op1 <= value_rs1;             // Operand 1 from rs1
            op2 <= value_rs2;             // Operand 2 from rs2
        end
    end

    // Operand assignment
endmodule
