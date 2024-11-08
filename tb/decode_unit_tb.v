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
    wire imm_flag;

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
        .op2(op2),
        .imm_flag(imm_flag)
    );

    // Initialize all signals
    initial begin
        $dumpfile("decode_unit.vcd");
        $dumpvars(0, tb_decode_unit);

        // Initial values for control signals
        clk = 0;
        reset = 0;
        stall = 0;
        is_branch_taken = 0;
        instr = 16'b0;

        // Apply reset
        #5 reset = 1;
        #10 reset = 0;

        // Run test scenarios
        test_nop;
        #10 test_immediate;
        test_register;
        #10 test_branch;
        #10 test_branch_taken;
        #10 test_stall;
        #80 $finish;
    end

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Test Case 1: NOP Instruction
    task test_nop;
        begin
            is_branch_taken = 0;
            instr = 16'h0000; // NOP instruction
            #10; // Wait for a clock cycle to capture output
            $display("NOP | opcode=%h, imm=%h, imm_flag=%h, op1=%h, op2=%h, branch_target=%h", 
                      opcode, imm, imm_flag, op1, op2, branch_target);
        end
    endtask

    // Test Case 2: Immediate Instruction
    task test_immediate;
        begin
            stall = 0;
            is_branch_taken = 0;
            instr = 16'hFCB7; // Immediate instruction with imm_flag set imm =00111, rs1=001
            #10; // Wait for a clock cycle to capture output
            $display("Immediate | opcode=%h, imm=%h, imm_flag=%h, op1=%h, op2=%h, branch_target=%h", 
                      opcode, imm, imm_flag, op1, op2, branch_target);
        end
    endtask

    // Test Case 3: Register Instruction
    task test_register;
        begin
            instr = 16'h2294; // Register instruction without imm_flag
            #10; // Wait for a clock cycle to capture output
            $display("Register | opcode=%h, imm=%h, imm_flag=%h, op1=%h, op2=%h, branch_target=%h", 
                      opcode, imm, imm_flag, op1, op2, branch_target);
        end
    endtask

    // Test Case 4: Branch Instruction
    task test_branch;
        begin
            instr = 16'hDE60; // Branch instruction
            #10; // Wait for a clock cycle to capture output
            $display("Branch | opcode=%h, imm=%h, imm_flag=%h, op1=%h, op2=%h, branch_target=%h", 
                      opcode, imm, imm_flag, op1, op2, branch_target);
        end
    endtask

    // Test Case 5: Branch Taken (Flush)
    task test_branch_taken;
        begin
            is_branch_taken = 1;
            #10; // Wait for a clock cycle to capture output
            $display("Branch Taken | opcode=%h, imm=%h, imm_flag=%h, op1=%h, op2=%h, branch_target=%h", 
                      opcode, imm, imm_flag, op1, op2, branch_target);
            is_branch_taken = 0;
        end
    endtask

    // Test Case 6: Stall Signal Active
    task test_stall;
        begin
            stall = 1;
            instr = 16'h3A51; // New instruction, but stall should prevent decoding
            #10; // Wait for a clock cycle to capture output
            $display("Stall | opcode=%h, imm=%h, imm_flag=%h, op1=%h, op2=%h, branch_target=%h", 
                      opcode, imm, imm_flag, op1, op2, branch_target);
            stall = 0;
        end
    endtask

endmodule
