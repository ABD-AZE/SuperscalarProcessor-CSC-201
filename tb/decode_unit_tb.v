module tb_decode_unit;

    // Testbench signals
    reg clk;
    reg reset;
    reg stall;
    reg is_branch_taken;
    reg [15:0] instr;
    wire [4:0] imm;
    wire [3:0] opcode;
    wire [15:0] branch_target;
    wire [15:0] op1, op2;

    // Instantiate the decode unit
    decode_unit uut (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .is_branch_taken(is_branch_taken),
        .instr(instr),
        .imm(imm),
        .opcode(opcode),
        .branch_target(branch_target),
        .op1(op1),
        .op2(op2)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // 10 time units clock period
    end

    // Initialize signals and run test cases
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 0;
        stall = 0;
        is_branch_taken = 0;
        instr = 16'b0;

        // Apply reset
        reset = 1;
        #10;
        reset = 0;

        // Test Case 1: NOP instruction
        instr = 16'b0000000000000000;  // NOP opcode
        #10;
        $display("TC1 - NOP | opcode=%b, imm=%b, op1=%h, op2=%h, branch_target=%h", 
                  opcode, imm, op1, op2, branch_target);

        // Test Case 2: Immediate instruction with imm_flag
        instr = 16'b0001100100010001; // opcode=0001, imm_flag=1, rd=001, rs1=00011, imm=00001
        #10;
        $display("TC2 - Immediate | opcode=%b, imm=%b, op1=%h, op2=%h, branch_target=%h", 
                  opcode, imm, op1, op2, branch_target);

        // Test Case 3: Register instruction without imm_flag
        instr = 16'b0010001010010000; // opcode=0010, imm_flag=0, rd=010, rs1=00101, rs2=00010
        #10;
        $display("TC3 - Register | opcode=%b, imm=%b, op1=%h, op2=%h, branch_target=%h", 
                  opcode, imm, op1, op2, branch_target);

        // Test Case 4: Branch instruction
        instr = 16'b1100011001100001; // opcode=1100 (branch), imm_flag=1, rd=011, rs1=00110, imm=00001
        #10;
        $display("TC4 - Branch | opcode=%b, imm=%b, op1=%h, op2=%h, branch_target=%h", 
                  opcode, imm, op1, op2, branch_target);

        // Test Case 5: Branch taken (flush)
        is_branch_taken = 1;
        #10;
        $display("TC5 - Branch Taken | opcode=%b, imm=%b, op1=%h, op2=%h, branch_target=%h", 
                  opcode, imm, op1, op2, branch_target);
        is_branch_taken = 0;

        // Test Case 6: Stall signal active
        stall = 1;
        instr = 16'b0011101001010001; // New instruction, but stall should prevent decoding
        #10;
        $display("TC6 - Stall | opcode=%b, imm=%b, op1=%h, op2=%h, branch_target=%h", 
                  opcode, imm, op1, op2, branch_target);
        stall = 0;

        // End simulation
        #10;
        $finish;
    end

endmodule
