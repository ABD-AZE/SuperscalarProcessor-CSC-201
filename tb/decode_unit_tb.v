module tb_decode_unit;

    // Testbench signals
    reg clk;
    reg reset;
    reg stall;
    reg flush;
    reg is_branch_taken;
    reg [15:0] instr;               // 16-bit instruction input for decode unit
    reg [15:0] branch_target;        // Simulated branch target

    // Outputs from the decode unit
    wire [2:0] rd, rs1, rs2;         // Register fields
    wire [4:0] imm;                  // Immediate field
    wire [3:0] opcode;               // Opcode field
    wire [15:0] branch_target_out;   // Branch target calculation
    wire [15:0] op1, op2;            // Decoded operands

    // Instantiate the decode unit
    decode_unit uut (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .flush(flush),
        .is_branch_taken(is_branch_taken),
        .instr(instr),
        .branch_target_in(branch_target),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .imm(imm),
        .opcode(opcode),
        .branch_target_out(branch_target_out),
        .op1(op1),
        .op2(op2)
    );

    // Initialize signals
    initial begin
        $dumpfile("decode_unit.vcd");
        $dumpvars(0, tb_decode_unit);
        clk = 0;
        reset = 0;
        stall = 0;
        flush = 0;
        is_branch_taken = 0;
        instr = 16'b0;
        branch_target = 16'h0000;

        // Apply reset
        #5 reset = 1;
        #10 reset = 0;

        // Run test scenarios
        #10 test_no_branch;
        #10 test_stall;
        #10 test_with_branch;
        #10 test_flush;
        #50 $finish;
    end

    // Clock generation
    always begin
        #5 clk = ~clk;  // Toggle clock every 5 time units
    end

    // Test Case 1: No Branch, Normal Decode
    task test_no_branch;
        begin
            is_branch_taken = 0;
            flush = 0;
            stall = 0;

            // Provide a regular instruction (immediate)
            instr = 16'b0001_1_010_011_00010;  // Example instruction

            // Wait for a few cycles and observe the outputs
            #20;
            $display("Test No Branch:");
            $display("instr: %b, opcode: %b, rd: %b, rs1: %b, imm: %b", instr, opcode, rd, rs1, imm);
            $display("op1: %h, op2 (imm): %h", op1, op2);
        end
    endtask

    // Test Case 2: Decode Stalled
    task test_stall;
        begin
            stall = 1;
            is_branch_taken = 0;

            // Apply a new instruction, but expect it to be stalled
            instr = 16'b0010_0_100_101_00100;

            // Wait for a few cycles and observe the outputs (no new decode should happen)
            #20;
            $display("Test Stall:");
            $display("Stalled, instr: %b, opcode: %b, rd: %b, rs1: %b", instr, opcode, rd, rs1);
        end
    endtask

    // Test Case 3: Branch Instruction Handling
    task test_with_branch;
        begin
            stall = 0;
            is_branch_taken = 1;
            branch_target = 16'h0008;

            // Simulate branch instruction
            instr = 16'b1100_1_001_000_00011;  // Example branch instruction

            // Wait for a few cycles and observe the outputs
            #20;
            $display("Test Branch Taken:");
            $display("instr: %b, opcode: %b, branch_target_out: %h", instr, opcode, branch_target_out);
        end
    endtask

    // Test Case 4: Flush Instruction
    task test_flush;
        begin
            flush = 1;
            is_branch_taken = 0;
            stall = 0;

            // Provide a regular instruction (register-based)
            instr = 16'b0011_0_011_100_00111;  // Example instruction

            // Wait for a few cycles and observe the outputs
            #20;
            flush = 0;
            $display("Test Flush:");
            $display("Flushed, instr: %b, opcode: %b, rd: %b, rs1: %b, rs2: %b", instr, opcode, rd, rs1, rs2);
        end
    endtask
  
endmodule
