module decode_unit_tb;

    // Inputs
    reg clk;
    reg reset;
    reg stall;
    reg is_branch_taken;
    reg [15:0] instr;
    reg [19:0] rdvalmem1;
    reg [19:0] rdvalmem2;

    // Outputs
    wire [4:0] imm;
    wire [3:0] opcode;
    wire [15:0] branch_target;
    wire [15:0] op1;
    wire [15:0] op2;
    wire imm_flag;

    // Instantiate the Unit Under Test (UUT)
    decode_unit uut (
        .clk(clk), 
        .reset(reset), 
        .stall(stall), 
        .is_branch_taken(is_branch_taken), 
        .instr(instr), 
        .rdvalmem1(rdvalmem1), 
        .rdvalmem2(rdvalmem2), 
        .imm(imm), 
        .opcode(opcode), 
        .branch_target(branch_target), 
        .op1(op1), 
        .op2(op2), 
        .imm_flag(imm_flag)
    );

    // Clock generation
    always #5 clk = ~clk;  // 10 ns clock period

    initial begin
        // Initialize Inputs
        $dumpfile("decode_unit.vcd");
        $dumpvars(0, decode_unit_tb);

        clk = 0;
        reset = 1;
        stall = 0;
        is_branch_taken = 0;
        instr = 16'h0000;
        rdvalmem1 = 20'h00000;
        rdvalmem2 = 20'h00000;
        #5;
        // Wait 10 ns and release reset
        #10 reset = 0;

        // Test Case 1: Normal instruction with matching ALU values from memory
        instr = 16'h11B0;  // opcode = F, rs1 = 001, rs2 = 010
        rdvalmem1 = 20'h0F005;  // Mem value 1 matches rs1
        rdvalmem2 = 20'h0A004;  // Mem value 2 matches rs2
        #10;

        // Test Case 2: Normal instruction with no matching memory values
        instr = 16'hA345;  // opcode = A, rs1 = 011, rs2 = 100
        rdvalmem1 = 20'h00000;  // No matches in memory
        rdvalmem2 = 20'h00000;  // No matches in memory
        #10;

        // Test Case 3: Immediate instruction (use immediate in op2)
        instr = 16'hB456;  // opcode = B, imm_flag = 1, rs1 = 100, imm = 10110
        rdvalmem1 = 20'h00000;  // No matches in memory
        rdvalmem2 = 20'h00000;  // No matches in memory
        #10;

        // Test Case 4: Branch taken (should flush the pipeline)
        is_branch_taken = 1;
        instr = 16'hC567;  // Branch instruction
        #10;
        is_branch_taken = 0;

        // Test Case 5: Stall condition (should prevent instruction decoding)
        stall = 1;
        instr = 16'hD789;  // opcode = D, rs1 = 111, rs2 = 100
        rdvalmem1 = 20'h78901;  // Mem value 1 matches rs1
        rdvalmem2 = 20'h56781;  // Mem value 2 matches rs2
        #10;
        stall = 0;

        // Test Case 6: Reset condition
        reset = 1;
        #10 reset = 0;

        // End of simulation
        #10 $finish;
    end

    // Monitor output values for debugging
    initial begin
        $monitor("Time = %0t | opcode = %b | imm = %b | op1 = %h | op2 = %h | branch_target = %h | imm_flag = %b", 
            $time, opcode, imm, op1, op2, branch_target, imm_flag);
    end

endmodule
