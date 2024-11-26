module decode_unit (
    input wire clk,
    input wire reset,
    input wire stall,                               // Stall signal
    input wire is_branch_taken,                     // Branch taken signal
    input wire [15:0] instr,                        // 16-bit instruction
    input wire [19:0] rdvalmem1,
    input wire [19:0] rdvalmem2,
    output wire [4:0] imm,                          // 5-bit immediate value
    output wire [3:0] opcode,                       // 4-bit Opcode
    output wire [15:0] branch_target,               // Calculated branch target
    output wire [15:0] op1, op2,                    // Operand values
    output wire imm_flag,                            // Immediate flag
    output wire [15:0] instrout
);
    // Internal registers for decoding and pipeline
    reg [4:0] imm_reg;
    reg [3:0] opcode_reg;
    reg [15:0] instrn;
    reg [15:0] instrun;
    reg [15:0] branch_target_reg, op1_reg, op2_reg;
    reg imm_flag_reg;
    // Register file
    reg [2:0] rd, rs1, rs2;                         // Register fields
    reg [15:0] registers [0:7];                     // Register file memory (16 registers)
    
    // Pipeline registers for next cycle values
    reg [4:0] imm_next;
    reg [3:0] opcode_next;
    reg [15:0] branch_target_next, op1_next, op2_next;
    reg imm_flag_next;

    // Load the hex file at the start
    initial begin
        $readmemh("registers.hex", registers);      // Load values from hex file
        opcode_next <= 4'h0;
        imm_next <= 5'h00;
        branch_target_next <= 16'h0;
        op1_next <= 16'h0;
        op2_next <= 16'h0;
        instrun <= 16'h0;
        imm_flag_next <= 0;
    end

    // Decode logic - computes values in the current cycle but stores them in the pipeline registers
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all pipeline registers
            opcode_next <= 4'h0;
            imm_next <= 5'h00;
            branch_target_next <= 16'h0;
            op1_next <= 16'h0;
            op2_next <= 16'h0;
            instrun <= 16'h0;
            imm_flag_next <= 0;
        end else if (is_branch_taken) begin
            // Handle branch flush; outputs reset to NOP
            opcode_next <= 4'h0;
            imm_next <= 5'h00;
            imm_flag_next <= 0;
            op1_next <= 16'h0;
            op2_next <= 16'h0;
            branch_target_next <= 16'h0;
            instrun <=16'h0;
        end else if (1) begin
            // Decode instruction and load next-cycle values into pipeline registers
            if((rdvalmem1[19]==0)&&(rdvalmem1[2:0]==instr[7:5])) begin
                op1_next<=rdvalmem1[18:3];
            end
            else if((rdvalmem2[19]==0)&&(rdvalmem2[2:0]==instr[7:5])) begin
                op1_next<=rdvalmem2[18:3];
            end
            else begin
                op1_next <= registers[instr[7:5]];
            end
            if((rdvalmem1[19]==0)&&(instr[11]==0)&&(rdvalmem1[2:0]==instr[4:2])) begin
                op2_next <= rdvalmem1[18:3];
            end
            else if((rdvalmem2[19]==0)&&(instr[11]==0)&&(rdvalmem2[2:0]==instr[4:2])) begin
                op2_next <= rdvalmem2[18:3];
            end
            else if(instr[11]==0) begin
                op2_next <= registers[instr[4:2]];
            end
            else begin
                op2_next <= {11'b0, instr[4:0]};
            end
            opcode_next <= instr[15:12];
            imm_flag_next <= instr[11];
            rd = instr[10:8];
            rs1 = instr[7:5];
            imm_next <= instr[4:0]; 
            rs2 = instr[4:2];
            // if (instr[11]) begin
            //     op1_next <= registers[rs1];
            //     op2_next <= {11'b0, instr[4:0]};
            // end else begin
            //     op1_next <= registers[rs1];
            //     op2_next <= registers[rs2];
            // end
            branch_target_next <= {5'b0, instr[10:0]};
            instrun <= instr;
        end

        // Update internal pipeline registers with next-cycle values
        opcode_reg <= opcode_next;
        imm_reg <= imm_next;
        branch_target_reg <= branch_target_next;
        op1_reg <= op1_next;
        op2_reg <= op2_next;
        imm_flag_reg <= imm_flag_next;
        instrn <= instrun;
        if(0) begin 
            opcode_reg <= 4'h0;
            imm_reg <= 5'h00;
            imm_flag_reg <= 0;
            branch_target_reg <= 16'h0;
            op1_reg <= 16'h0;
            op2_reg <= 16'h0;
        end
    end
    // Continuous assignments to output wires
    assign opcode = opcode_next;
    assign imm = imm_next;
    assign branch_target = branch_target_next;
    assign op1 = op1_next;
    assign op2 = op2_next;
    assign imm_flag = imm_flag_next;
    assign instrout= instrun;
endmodule
