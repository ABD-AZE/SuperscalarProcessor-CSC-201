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

    // Initialize all signals
    initial begin
        $dumpfile("decode_unit.vcd");
        $dumpvars(0, tb_decode_unit);
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
        #10 test_register;
        #10 test_branch;
        #10 test_branch_taken;
        #10 test_stall;
        #50 $finish;
    end

    // Clock generation
    always begin
        #5 clk = ~clk;  // Toggle clock every 5 time units
    end

    // Test Case 1: NOP Instruction
    task test_nop;
        begin
            instr = 16'b0000000000000000; // NOP instruction
            $display("NOP | opcode=%b, imm=%b, op1=%h, op2=%h, branch_target=%h", 
                      opcode, imm, op1, op2, branch_target);
        end
    endtask

    // Test Case 2: Immediate Instruction
    task test_immediate;
        begin
            instr = 16'b0001100100010001; // Immediate instruction with imm_flag set
            $display("Immediate | opcode=%b, imm=%b, op1=%h, op2=%h, branch_target=%h", 
                      opcode, imm, op1, op2, branch_target);
        end
    endtask

    // Test Case 3: Register Instruction
    task test_register;
        begin
            instr = 16'b0010001010010000; // Register instruction without imm_flag
            $display("Register | opcode=%b, imm=%b, op1=%h, op2=%h, branch_target=%h", 
                      opcode, imm, op1, op2, branch_target);
        end
    endtask

    // Test Case 4: Branch Instruction
    task test_branch;
        begin
            instr = 16'b1100011001100001; // Branch instruction
            $display("Branch | opcode=%b, imm=%b, op1=%h, op2=%h, branch_target=%h", 
                      opcode, imm, op1, op2, branch_target);
        end
    endtask

    // Test Case 5: Branch Taken (Flush)
    task test_branch_taken;
        begin
            is_branch_taken = 1;
            #10;
            $display("Branch Taken | opcode=%b, imm=%b, op1=%h, op2=%h, branch_target=%h", 
                      opcode, imm, op1, op2, branch_target);
            is_branch_taken = 0;
        end
    endtask

    // Test Case 6: Stall Signal Active
    task test_stall;
        begin
            stall = 1;
            instr = 16'b0011101001010001; // New instruction, but stall should prevent decoding
            $display("Stall | opcode=%b, imm=%b, op1=%h, op2=%h, branch_target=%h", 
                      opcode, imm, op1, op2, branch_target);
            stall = 0;
        end
    endtask

endmodule
