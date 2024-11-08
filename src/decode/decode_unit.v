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
    output reg [0:0] imm_flag                             // Immediate flag
);

    // Internal registers
    reg [7:0] value_rs1, value_rs2;                    // Registers to store rs1 and rs2 values
    reg [2:0] rd, rs1, rs2;                         // Register fields

    // Memory array to hold values from hex file
    reg [15:0] reg_file [0:7];                     // Register file memory (16 registers)

    // Load the hex file at the start
    initial begin
        $readmemh("registers.hex", reg_file); // Load values from hex file
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all outputs
            opcode <= 16'h0;                      // NOP instruction
            rd <= 16'h0;
            rs1 <= 16'h0;
            rs2 <= 16'h0;
            imm <= 16'h00;
            branch_target <= 16'h0;
            imm_flag <= 0;
        end else if (is_branch_taken) begin
            // Handle flush (invalidate current instruction)
            opcode <= 16'h0;                      // NOP
            rd <= 16'h0;
            rs1 <= 16'h0;
            rs2 <= 16'h0;
            imm <= 16'h00;
        end else if (!stall) begin
            // Decode the instruction when not stalled
            opcode <= instr[15:12];                   // Extract 4-bit opcode
            imm_flag <= instr[11];                   // Extract immediate flag (bit 11)
            rd <= instr[10:8];                       // Extract rd (3-bit)
            rs1 <= instr[7:5];                     // Extract rs1 (3-bit)
            if (imm_flag) begin
                // If the instruction uses immediate
                imm <= instr[4:0];                 // Extract 5-bit immediate
                value_rs1 <= reg_file[rs1];          // Load rs1 value from hex file
                value_rs2 <= 16'h0;                  // No rs2 for immediate type
            end else begin
                // If the instruction uses rs2
                rs2 <= instr[4:2];                  // Extract 5-bit rs2 field
                value_rs1 <= reg_file[rs1];           // Load rs1 value from hex file
                value_rs2 <= reg_file[rs2];           // Load rs2 value from hex file
            end

            // Assign operand 1 (op1 is the value of rs1)
            // Branch target calculation
            if (opcode == 16'h1100) begin            // Assuming opcode '1100' is branch
                branch_target <= {{11{instr[4]}}, instr[4:0]} << 2;  // Extend and shift
            end
        end
    end
    
    always @(*) begin
        // Assign operand 1 (op1 is the value of rs1)
        if(imm_flag) begin
            op1 <= value_rs1;
            op2 <= {11'b0, imm};
        end else begin
            op1 <= value_rs1; 
            op2 <= value_rs2;
        end
    end
endmodule
